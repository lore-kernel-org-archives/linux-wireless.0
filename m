Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12973 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062Ab2H0K0a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2012 06:26:30 -0400
From: Wei Ni <wni@nvidia.com>
To: <swarren@wwwdotorg.org>, <brudley@broadcom.com>,
	<rvossen@broadcom.com>
CC: <krakesh@nvidia.com>, <ldewangan@nvidia.com>,
	<linux-tegra@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
	<brcm80211-dev-list@broadcom.com>, Wei Ni <wni@nvidia.com>
Subject: [PATCH 4/6] ARM: dt: t20 ventana: set pinmux and power for wlan
Date: Mon, 27 Aug 2012 18:25:12 +0800
Message-ID: <1346063114-30361-5-git-send-email-wni@nvidia.com> (sfid-20120827_122754_344802_6362D0C3)
In-Reply-To: <1346063114-30361-1-git-send-email-wni@nvidia.com>
References: <1346063114-30361-1-git-send-email-wni@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Configure pinmux as required for WiFi.
Enable the SDHCI1 controller, which is connectted to the WiFi module.

Signed-off-by: Wei Ni <wni@nvidia.com>
---
 arch/arm/boot/dts/tegra20-ventana.dts |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20-ventana.dts b/arch/arm/boot/dts/tegra20-ventana.dts
index 4ec6b4c..3cbe54c 100644
--- a/arch/arm/boot/dts/tegra20-ventana.dts
+++ b/arch/arm/boot/dts/tegra20-ventana.dts
@@ -237,6 +237,16 @@
 					"ld23_22";
 				nvidia,pull = <1>;
 			};
+			drive_sdio1 {
+				nvidia,pins = "drive_sdio1";
+				nvidia,high-speed-mode = <0>;
+				nvidia,schmitt = <1>;
+				nvidia,low-power-mode = <3>;
+				nvidia,pull-down-strength = <31>;
+				nvidia,pull-up-strength = <31>;
+				nvidia,slew-rate-rising = <3>;
+				nvidia,slew-rate-falling = <3>;
+			};
 		};
 	};
 
@@ -454,6 +464,11 @@
 		status = "okay";
 	};
 
+	sdhci@c8000000 {
+		status = "okay";
+		power-gpios = <&gpio 86 0>; /* gpio PK6 */
+	};
+
 	sdhci@c8000400 {
 		status = "okay";
 		cd-gpios = <&gpio 69 0>; /* gpio PI5 */
-- 
1.7.1

