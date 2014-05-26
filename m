Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980AbaEZHtZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 03:49:25 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linus Walleij <linus.walleij@linaro.org>,
	Chris Ball <chris@printf.net>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-arm-kernel@lists.infradead.org,
	linux-mmc@vger.kernel.org, linux-wireless@vger.kernel.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 11/11] ARM: dts: sun7i: Add OOB irq support to boards with broadcom sdio wifi
Date: Mon, 26 May 2014 09:48:06 +0200
Message-Id: <1401090486-4414-12-git-send-email-hdegoede@redhat.com> (sfid-20140526_094938_890190_C741FD5A)
In-Reply-To: <1401090486-4414-1-git-send-email-hdegoede@redhat.com>
References: <1401090486-4414-1-git-send-email-hdegoede@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 arch/arm/boot/dts/sun7i-a20-cubietruck.dts | 12 ++++++++++++
 arch/arm/boot/dts/sun7i-a20-i12-tvbox.dts  | 12 ++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
index 3931986..d3dcd8e 100644
--- a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
+++ b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
@@ -31,12 +31,24 @@
 		};
 
 		mmc3: mmc@01c12000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
 			pinctrl-names = "default";
 			pinctrl-0 = <&mmc3_pins_a>;
 			vmmc-supply = <&reg_vmmc3>;
 			bus-width = <4>;
 			non-removable;
 			status = "okay";
+
+			brcmf: bcrmf@1 {
+				reg = <1>;
+				compatible = "brcm,bcm43xx-fmac";
+				interrupt-parent = <&pio>;
+				interrupts = <10 8>; /* PH10 / EINT10 */
+				interrupt-names = "host-wake";
+				status = "okay";
+			};
 		};
 
 		usbphy: phy@01c13400 {
diff --git a/arch/arm/boot/dts/sun7i-a20-i12-tvbox.dts b/arch/arm/boot/dts/sun7i-a20-i12-tvbox.dts
index 4aad09c..806f236 100644
--- a/arch/arm/boot/dts/sun7i-a20-i12-tvbox.dts
+++ b/arch/arm/boot/dts/sun7i-a20-i12-tvbox.dts
@@ -29,12 +29,24 @@
 		};
 
 		mmc3: mmc@01c12000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
 			pinctrl-names = "default";
 			pinctrl-0 = <&mmc3_pins_a>;
 			vmmc-supply = <&reg_vmmc3>;
 			bus-width = <4>;
 			non-removable;
 			status = "okay";
+
+			brcmf: bcrmf@1 {
+				reg = <1>;
+				compatible = "brcm,bcm43xx-fmac";
+				interrupt-parent = <&pio>;
+				interrupts = <10 8>; /* PH10 / EINT10 */
+				interrupt-names = "host-wake";
+				status = "okay";
+			};
 		};
 
 		usbphy: phy@01c13400 {
-- 
1.9.3

