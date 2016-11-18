Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:35462 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753823AbcKRMhn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 07:37:43 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>, <devicetree@vger.kernel.org>,
        Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v8] mwifiex: parse device tree node for PCIe
Date: Fri, 18 Nov 2016 18:07:04 +0530
Message-ID: <1479472624-22340-1-git-send-email-akarwar@marvell.com> (sfid-20161118_133748_344452_D8106A35)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

This patch derives device tree node from pcie bus layer framework.
Device tree bindings file has been renamed(marvell-sd8xxx.txt ->
marvell-8xxx.txt) to accommodate PCIe changes.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Rajat Jain <rajatja@google.com>
Reviewed-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
v2: Included vendor and product IDs in compatible strings for PCIe
chipsets(Rob Herring)
v3: Patch is created using -M option so that it will only include diff of
original and renamed files(Rob Herring)
Resend v3: Resending the patch because I missed to include device tree mailing
while sending v3.
v4: Fix error handling, also move-on even if no device tree node is present.
v5: Update commit log to include memory leak, return -EINVAL instead of -1.
v6: Remove an unnecessary error print, fix typo in commit log
v7: a) Earlier versions of this patch claims to have a change which fixes "memory
       leak". But it actually introduces double-free problem. That change is removed
       here(Brian Norris)
    b) Cosmetic change in bindings documentation(Rob Herring)
	s/marvell/Marvell/
	s/sdio\/pcie/SDIO\/PCIE/
v8: Same as v7. I had missed to CC device tree mailing list in v7. Correcting this
    in v8.
---
 .../{marvell-sd8xxx.txt => marvell-8xxx.txt}       |  8 +++++---
 drivers/net/wireless/marvell/mwifiex/pcie.c        | 24 ++++++++++++++++++++++
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c     |  3 ++-
 3 files changed, 31 insertions(+), 4 deletions(-)
 rename Documentation/devicetree/bindings/net/wireless/{marvell-sd8xxx.txt => marvell-8xxx.txt} (91%)

diff --git a/Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt b/Documentation/devicetree/bindings/net/wireless/marvell-8xxx.txt
similarity index 91%
rename from Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt
rename to Documentation/devicetree/bindings/net/wireless/marvell-8xxx.txt
index c421aba..980b16df 100644
--- a/Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt
+++ b/Documentation/devicetree/bindings/net/wireless/marvell-8xxx.txt
@@ -1,8 +1,8 @@
-Marvell 8897/8997 (sd8897/sd8997) SDIO devices
+Marvell 8897/8997 (sd8897/sd8997/pcie8997) SDIO/PCIE devices
 ------
 
-This node provides properties for controlling the marvell sdio wireless device.
-The node is expected to be specified as a child node to the SDIO controller that
+This node provides properties for controlling the Marvell SDIO/PCIE wireless device.
+The node is expected to be specified as a child node to the SDIO/PCIE controller that
 connects the device to the system.
 
 Required properties:
@@ -10,6 +10,8 @@ Required properties:
   - compatible : should be one of the following:
 	* "marvell,sd8897"
 	* "marvell,sd8997"
+	* "pci11ab,2b42"
+	* "pci1b4b,2b42"
 
 Optional properties:
 
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 3047c1a..5737cc6 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -37,6 +37,22 @@
 
 static struct semaphore add_remove_card_sem;
 
+static const struct of_device_id mwifiex_pcie_of_match_table[] = {
+	{ .compatible = "pci11ab,2b42" },
+	{ .compatible = "pci1b4b,2b42" },
+	{ }
+};
+
+static int mwifiex_pcie_probe_of(struct device *dev)
+{
+	if (!of_match_node(mwifiex_pcie_of_match_table, dev->of_node)) {
+		dev_err(dev, "required compatible string missing\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int
 mwifiex_map_pci_memory(struct mwifiex_adapter *adapter, struct sk_buff *skb,
 		       size_t size, int flags)
@@ -185,6 +201,7 @@ static int mwifiex_pcie_probe(struct pci_dev *pdev,
 					const struct pci_device_id *ent)
 {
 	struct pcie_service_card *card;
+	int ret;
 
 	pr_debug("info: vendor=0x%4.04X device=0x%4.04X rev=%d\n",
 		 pdev->vendor, pdev->device, pdev->revision);
@@ -206,6 +223,13 @@ static int mwifiex_pcie_probe(struct pci_dev *pdev,
 		card->pcie.can_ext_scan = data->can_ext_scan;
 	}
 
+	/* device tree node parsing and platform specific configuration*/
+	if (pdev->dev.of_node) {
+		ret = mwifiex_pcie_probe_of(&pdev->dev);
+		if (ret)
+			return ret;
+	}
+
 	if (mwifiex_add_card(card, &add_remove_card_sem, &pcie_ops,
 			     MWIFIEX_PCIE)) {
 		pr_err("%s failed\n", __func__);
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
index 0a54e21..b697b61 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
@@ -2235,7 +2235,8 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta, bool init)
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
