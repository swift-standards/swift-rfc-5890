// swift-tools-version: 6.2

import PackageDescription

extension String {
    static let rfc5890: Self = "RFC 5890"
    static let rfc3492: Self = "RFC 3492"
}

extension Target.Dependency {
    static var rfc5890: Self { .target(name: .rfc5890) }
    static var rfc3492: Self { .target(name: .rfc3492) }
}

let package = Package(
    name: "swift-rfc-5890",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11)
    ],
    products: [
        // IDNA2008 Protocol (RFC 5890)
        .library(
            name: .rfc5890,
            targets: [.rfc5890]
        ),
        // Punycode (RFC 3492) - required by IDNA
        .library(
            name: .rfc3492,
            targets: [.rfc3492]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-standards/swift-incits-4-1986", from: "0.1.0"),
    ],
    targets: [
        // RFC 5890: IDNA2008 Protocol
        .target(
            name: .rfc5890,
            dependencies: [
                .rfc3492,
            ]
        ),

        // RFC 3492: Punycode (required by IDNA)
        .target(
            name: .rfc3492,
            dependencies: []
        ),

        // Tests
        .testTarget(
            name: .rfc5890.tests,
            dependencies: [.rfc5890]
        ),
        .testTarget(
            name: .rfc3492.tests,
            dependencies: [.rfc3492]
        ),
    ],
    swiftLanguageModes: [.v6]
)

extension String {
    var tests: Self { self + " Tests" }
}

for target in package.targets where ![.system, .binary, .plugin].contains(target.type) {
    let existing = target.swiftSettings ?? []
    target.swiftSettings = existing + [
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility")
    ]
}
