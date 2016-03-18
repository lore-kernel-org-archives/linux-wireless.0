Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44645 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751042AbcCRLJU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2016 07:09:20 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	<devicetree@vger.kernel.org>,
	Wei-Ning Huang <wnhuang@chromium.org>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v5 1/2] dt: bindings: add MARVELL's sd8xxx wireless device
Date: Fri, 18 Mar 2016 04:03:51 -0700
Message-ID: <1458299032-31929-1-git-send-email-akarwar@marvell.com> (sfid-20160318_120923_884682_BD8B053C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

Add device tree binding documentation for MARVELL's sd8xxx
(sd8897 and sd8997) wlan chip.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
Listing changelist for both 1/2 and 2/2 patches
v3: Don't update adapter->dt_node if mwifiex_plt_dev is NULL

v4: a)Corrected the 'name' and 'compatible' property names.(Arnd Bergmann and Rob
    Herring)
    b)Patch description wraped in 72 columns(Rob Herring)
    c)Moved DT binding file to bindings/net/wireless/(Rob Herring)
    d)Renamed "mwifiex,chip-gpio" to "marvell,wakeup-gpios"(Rob Herring/
    Arnd Bergmann)
    e)Replaced #ifdef with __maybe_unused(Arnd Bergmann)

v5: a)Removed wildcards from compatible string(Arnd Bergmann)
    b)Prepared single patch for all binding changes(Rob Herring)
    c)Specified our node as a subnode of SDIO controller. With this approach, we
    don't need to register new platform driver. (Rob herring)
---
 .../bindings/net/wireless/marvell-sd8xxx.txt       | 56 ++++++++++++++++++++++
 1 file changed, 56 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt

diff --git a/Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt b/Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt
new file mode 100644
index 0000000..c43d488
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt
@@ -0,0 +1,56 @@
+Marvell 8897/8997 (sd8897/sd8997) SDIO devices
+------
+
+This node provides properties for controlling the marvell sdio wireless device.
+The node is expected to be specified as a child node to the SDIO controller that
+connects the device to the system.
+
+Required properties:
+
+  - compatible : should be one of the following:
+	* "marvell,sd8897"
+	* "marvell,sd8997"
+
+Optional properties:
+
+  - marvell,caldata* : A series of properties with marvell,caldata prefix,
+  		      represent Calibration data downloaded to the device during
+		      initialization. This is an array of unsigned values.
+  - marvell,wakeup-pin : 'wakeuppin' is a wakeup pin number of wifi chip which will
+  		      be configured to firmware. firmware will wakeup host side use
+  		      the pin during suspend/resume stage.
+  - interrupt-parent: phandle of the parent interrupt controller
+  - interrupts : interrupt pin number to the cpu. driver will request an irq based on
+  		 this interrupt number. during system suspend, the irq will be enabled
+  		 as system wakeup source, so that the wifi chip can wakeup host
+  		 platform under certain condition. during system resume, the irq will
+  		 be disabled to make sure unnecessary interrupt is not received.
+
+Example:
+
+Tx power limit calibration data is configured in below example.
+The calibration data is an array of unsigned values, the length
+can vary between hw versions.
+IRQ pin 38 is used as system wakeup source interrupt. wakeup pin 3 is configured
+so that firmware can wakeup host using this device side pin.
+
+&mmc3 {
+	status = "okay";
+	vmmc-supply = <&wlan_en_reg>;
+	bus-width = <4>;
+	cap-power-off-card;
+	keep-power-in-suspend;
+
+	#address-cells = <1>;
+	#size-cells = <0>;
+	mwifiex: mwifiex@3 {
+		compatible = "marvell,sd8897";
+		reg = <1>;
+		interrupt-parent = <&pio>;
+		interrupts = <38 IRQ_TYPE_LEVEL_LOW>;
+
+		marvell,caldata_00_txpwrlimit_2g_cfg_set = /bits/ 8 <
+	0x01 0x00 0x06 0x00 0x08 0x02 0x89 0x01>;
+		marvell,wakeup-pin = <3>;
+	};
+};
-- 
1.8.1.4

