Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094AbaF2ORw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jun 2014 10:17:52 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	Chen-Yu Tsai <wens@csie.org>, linux-wireless@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v3 1/4] dt: bindings: add bindings for Broadcom bcm43xx sdio devices
Date: Sun, 29 Jun 2014 16:16:58 +0200
Message-Id: <1404051421-24377-2-git-send-email-hdegoede@redhat.com> (sfid-20140629_161755_800371_4A752356)
In-Reply-To: <1404051421-24377-1-git-send-email-hdegoede@redhat.com>
References: <1404051421-24377-1-git-send-email-hdegoede@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The Broadcom bcm43xx sdio devices are fullmac devices that may be
integrated in ARM platforms. Currently, the brcmfmac driver for
these devices support use of platform data. This patch specifies
the bindings that allow this platform data to be expressed in the
devicetree.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
[hdegoede@redhat.com: drop clk / reg_on gpio handling, as there is no consensus
 on how to handle this yet]
[hdegoede@redhat.com: move from bindings/staging to bindings]
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 .../bindings/net/wireless/brcm,bcm43xx-fmac.txt    | 41 ++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt

diff --git a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
new file mode 100644
index 0000000..5dbf169
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
@@ -0,0 +1,41 @@
+Broadcom BCM43xx Fullmac wireless SDIO devices
+
+This node provides properties for controlling the Broadcom wireless device. The
+node is expected to be specified as a child node to the SDIO controller that
+connects the device to the system.
+
+Required properties:
+
+ - compatible : Should be "brcm,bcm4329-fmac".
+
+Optional properties:
+ - brcm,drive-strength : drive strength used for SDIO pins on device in mA
+	(default = 6).
+ - interrupt-parent : the phandle for the interrupt controller to which the
+	device interrupts are connected.
+ - interrupts : specifies attributes for the out-of-band interrupt (host-wake).
+	When not specified the device will use in-band SDIO interrupts.
+ - interrupt-names : name of the out-of-band interrupt, which must be set
+	to "host-wake".
+
+Example:
+
+mmc3: mmc@01c12000 {
+	#address-cells = <1>;
+	#size-cells = <0>;
+
+	pinctrl-names = "default";
+	pinctrl-0 = <&mmc3_pins_a>;
+	vmmc-supply = <&reg_vmmc3>;
+	bus-width = <4>;
+	non-removable;
+	status = "okay";
+
+	brcmf: bcrmf@1 {
+		reg = <1>;
+		compatible = "brcm,bcm4329-fmac";
+		interrupt-parent = <&pio>;
+		interrupts = <10 8>; /* PH10 / EINT10 */
+		interrupt-names = "host-wake";
+	};
+};
-- 
2.0.0

