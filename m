Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hermes.aosc.io ([199.195.250.187]:39286 "EHLO hermes.aosc.io"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752241AbdJCRAj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Oct 2017 13:00:39 -0400
From: Icenowy Zheng <icenowy@aosc.io>
To: Kalle Valo <kvalo@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Chen-Yu Tsai <wens@csie.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        Icenowy Zheng <icenowy@aosc.io>
Subject: [PATCH v3 1/2] dt-bindings: add device tree binding for Allwinner XR819 SDIO Wi-Fi
Date: Wed,  4 Oct 2017 00:59:43 +0800
Message-Id: <20171003165944.13056-2-icenowy@aosc.io> (sfid-20171003_190125_374387_FF4A461D)
In-Reply-To: <20171003165944.13056-1-icenowy@aosc.io>
References: <20171003165944.13056-1-icenowy@aosc.io>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allwinner XR819 is a SDIO Wi-Fi chip, which has the functionality to use
an out-of-band interrupt pin instead of SDIO in-band interrupt.

Add the device tree binding of this chip, in order to make it possible
to add this interrupt pin to device trees.

Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
Acked-by: Rob Herring <robh@kernel.org>
---
Changes in v3:
- Renames the node name.
- Adds ACK from Rob.
Changes in v2:
- Removed status property in example.
- Added required property reg.

 .../bindings/net/wireless/allwinner,xr819.txt      | 38 ++++++++++++++++++++++
 1 file changed, 38 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/allwinner,xr819.txt

diff --git a/Documentation/devicetree/bindings/net/wireless/allwinner,xr819.txt b/Documentation/devicetree/bindings/net/wireless/allwinner,xr819.txt
new file mode 100644
index 000000000000..7ae40441e343
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/wireless/allwinner,xr819.txt
@@ -0,0 +1,38 @@
+Allwinner XRadio wireless SDIO devices
+
+This node provides properties for controlling the XRadio wireless device. The
+node is expected to be specified as a child node to the SDIO controller that
+connects the device to the system.
+
+Required properties:
+
+ - reg : The SDIO function number, see "Use of function subnodes" in
+	../../mmc/mmc.txt.
+ - compatible : Should be "allwinner,xr819".
+
+Optional properties:
+ - interrupt-parent : the phandle for the interrupt controller to which the
+	device interrupts are connected.
+ - interrupts : specifies attributes for the out-of-band interrupt (host-wake).
+	When not specified the device will use in-band SDIO interrupts.
+
+Example:
+
+mmc1: mmc@01c10000 {
+	#address-cells = <1>;
+	#size-cells = <0>;
+
+	pinctrl-names = "default";
+	pinctrl-0 = <&mmc1_pins_a>;
+	vmmc-supply = <&reg_vcc_wifi>;
+	mmc-pwrseq = <&wifi_pwrseq>;
+	bus-width = <4>;
+	non-removable;
+
+	xr819: wifi@1 {
+		reg = <1>;
+		compatible = "allwinner,xr819";
+		interrupt-parent = <&pio>;
+		interrupts = <6 10 IRQ_TYPE_EDGE_RISING>;
+	};
+};
-- 
2.13.5
