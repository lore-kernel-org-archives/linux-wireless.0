Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:35348 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752666AbcIIPSC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Sep 2016 11:18:02 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <devicetree@vger.kernel.org>,
        Wei-Ning Huang <wnhuang@chromium.org>,
        Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mwifiex: parse device tree node for PCIe
Date: Fri, 9 Sep 2016 20:47:34 +0530
Message-ID: <1473434254-16782-1-git-send-email-akarwar@marvell.com> (sfid-20160909_171808_395560_19F1F69F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

This patch derives device tree node from pcie bus layer framework.
Device tree bindings file has been renamed(marvell-sd8xxx.txt ->
marvell-8xxx.txt) to accomodate PCIe changes.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 .../bindings/net/wireless/marvell-8xxx.txt         | 64 ++++++++++++++++++++++
 .../bindings/net/wireless/marvell-sd8xxx.txt       | 63 ---------------------
 drivers/net/wireless/marvell/mwifiex/pcie.c        | 19 +++++++
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c     |  3 +-
 4 files changed, 85 insertions(+), 64 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/marvell-8xxx.txt
 delete mode 100644 Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt

diff --git a/Documentation/devicetree/bindings/net/wireless/marvell-8xxx.txt b/Documentation/devicetree/bindings/net/wireless/marvell-8xxx.txt
new file mode 100644
index 0000000..a8a95aa
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/wireless/marvell-8xxx.txt
@@ -0,0 +1,64 @@
+Marvell 8897/8997 (sd8897/sd8997/pcie8997) SDIO/PCIE devices
+------
+
+This node provides properties for controlling the marvell sdio/pcie wireless device.
+The node is expected to be specified as a child node to the SDIO/PCIE controller that
+connects the device to the system.
+
+Required properties:
+
+  - compatible : should be one of the following:
+	* "marvell,sd8897"
+	* "marvell,sd8997"
+	* "marvell,pcie8997"
+
+Optional properties:
+
+  - marvell,caldata* : A series of properties with marvell,caldata prefix,
+		      represent calibration data downloaded to the device during
+		      initialization. This is an array of unsigned 8-bit values.
+		      the properties should follow below property name and
+		      corresponding array length:
+	"marvell,caldata-txpwrlimit-2g" (length = 566).
+	"marvell,caldata-txpwrlimit-5g-sub0" (length = 502).
+	"marvell,caldata-txpwrlimit-5g-sub1" (length = 688).
+	"marvell,caldata-txpwrlimit-5g-sub2" (length = 750).
+	"marvell,caldata-txpwrlimit-5g-sub3" (length = 502).
+  - marvell,wakeup-pin : a wakeup pin number of wifi chip which will be configured
+		      to firmware. Firmware will wakeup the host using this pin
+		      during suspend/resume.
+  - interrupt-parent: phandle of the parent interrupt controller
+  - interrupts : interrupt pin number to the cpu. driver will request an irq based on
+		 this interrupt number. during system suspend, the irq will be enabled
+		 so that the wifi chip can wakeup host platform under certain condition.
+		 during system resume, the irq will be disabled to make sure
+		 unnecessary interrupt is not received.
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
+	mwifiex: wifi@1 {
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
diff --git a/Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt b/Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt
deleted file mode 100644
index c421aba..0000000
--- a/Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt
+++ /dev/null
@@ -1,63 +0,0 @@
-Marvell 8897/8997 (sd8897/sd8997) SDIO devices
-------
-
-This node provides properties for controlling the marvell sdio wireless device.
-The node is expected to be specified as a child node to the SDIO controller that
-connects the device to the system.
-
-Required properties:
-
-  - compatible : should be one of the following:
-	* "marvell,sd8897"
-	* "marvell,sd8997"
-
-Optional properties:
-
-  - marvell,caldata* : A series of properties with marvell,caldata prefix,
-		      represent calibration data downloaded to the device during
-		      initialization. This is an array of unsigned 8-bit values.
-		      the properties should follow below property name and
-		      corresponding array length:
-	"marvell,caldata-txpwrlimit-2g" (length = 566).
-	"marvell,caldata-txpwrlimit-5g-sub0" (length = 502).
-	"marvell,caldata-txpwrlimit-5g-sub1" (length = 688).
-	"marvell,caldata-txpwrlimit-5g-sub2" (length = 750).
-	"marvell,caldata-txpwrlimit-5g-sub3" (length = 502).
-  - marvell,wakeup-pin : a wakeup pin number of wifi chip which will be configured
-		      to firmware. Firmware will wakeup the host using this pin
-		      during suspend/resume.
-  - interrupt-parent: phandle of the parent interrupt controller
-  - interrupts : interrupt pin number to the cpu. driver will request an irq based on
-		 this interrupt number. during system suspend, the irq will be enabled
-		 so that the wifi chip can wakeup host platform under certain condition.
-		 during system resume, the irq will be disabled to make sure
-		 unnecessary interrupt is not received.
-
-Example:
-
-Tx power limit calibration data is configured in below example.
-The calibration data is an array of unsigned values, the length
-can vary between hw versions.
-IRQ pin 38 is used as system wakeup source interrupt. wakeup pin 3 is configured
-so that firmware can wakeup host using this device side pin.
-
-&mmc3 {
-	status = "okay";
-	vmmc-supply = <&wlan_en_reg>;
-	bus-width = <4>;
-	cap-power-off-card;
-	keep-power-in-suspend;
-
-	#address-cells = <1>;
-	#size-cells = <0>;
-	mwifiex: wifi@1 {
-		compatible = "marvell,sd8897";
-		reg = <1>;
-		interrupt-parent = <&pio>;
-		interrupts = <38 IRQ_TYPE_LEVEL_LOW>;
-
-		marvell,caldata_00_txpwrlimit_2g_cfg_set = /bits/ 8 <
-	0x01 0x00 0x06 0x00 0x08 0x02 0x89 0x01>;
-		marvell,wakeup-pin = <3>;
-	};
-};
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 3c3c4f1..be4d2b9 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -37,6 +37,22 @@ static struct mwifiex_if_ops pcie_ops;
 
 static struct semaphore add_remove_card_sem;
 
+static const struct of_device_id mwifiex_pcie_of_match_table[] = {
+	{ .compatible = "marvell,pcie8997" },
+	{ }
+};
+
+static int mwifiex_pcie_probe_of(struct device *dev)
+{
+	if (!dev->of_node ||
+	    !of_match_node(mwifiex_pcie_of_match_table, dev->of_node)) {
+		pr_err("pcie device node not available");
+		return -1;
+	}
+
+	return 0;
+}
+
 static int
 mwifiex_map_pci_memory(struct mwifiex_adapter *adapter, struct sk_buff *skb,
 		       size_t size, int flags)
@@ -199,6 +215,9 @@ static int mwifiex_pcie_probe(struct pci_dev *pdev,
 		card->pcie.can_ext_scan = data->can_ext_scan;
 	}
 
+	/* device tree node parsing and platform specific configuration*/
+	mwifiex_pcie_probe_of(&pdev->dev);
+
 	if (mwifiex_add_card(card, &add_remove_card_sem, &pcie_ops,
 			     MWIFIEX_PCIE)) {
 		pr_err("%s failed\n", __func__);
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
index 2a162c3..c8dccf5 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
@@ -2218,7 +2218,8 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta, bool init)
 		 * The cal-data can be read from device tree and/or
 		 * a configuration file and downloaded to firmware.
 		 */
-		if (priv->adapter->iface_type == MWIFIEX_SDIO &&
+		if ((priv->adapter->iface_type == MWIFIEX_SDIO ||
+		    priv->adapter->iface_type == MWIFIEX_PCIE) &&
 		    adapter->dev->of_node) {
 			adapter->dt_node = adapter->dev->of_node;
 			if (of_property_read_u32(adapter->dt_node,
-- 
1.9.1
