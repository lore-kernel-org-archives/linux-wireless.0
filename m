Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:36423 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932656AbcJURQV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Oct 2016 13:16:21 -0400
Received: by mail-pf0-f176.google.com with SMTP id e6so59915184pfk.3
        for <linux-wireless@vger.kernel.org>; Fri, 21 Oct 2016 10:16:21 -0700 (PDT)
From: Rajat Jain <rajatja@google.com>
To: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        rajatja@google.com, Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Brian Norris <briannorris@google.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Rob Herring <robh@kernel.org>
Cc: rajatxjain@gmail.com
Subject: [PATCH v5] mwifiex: parse device tree node for PCIe
Date: Fri, 21 Oct 2016 10:15:56 -0700
Message-Id: <1477070156-109965-1-git-send-email-rajatja@google.com> (sfid-20161021_191627_694649_93619E19)
In-Reply-To: <20161021020609.GA18359@localhost>
References: <20161021020609.GA18359@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

This patch derives device tree node from pcie bus layer framework, and
fixes a minor memory leak in mwifiex_pcie_probe() (in failure path).
Device tree bindings file has been renamed(marvell-sd8xxx.txt ->
marvell-8xxx.txt) to accomodate PCIe changes.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Rajat Jain <rajatja@google.com>
Reviewed-by: Brian Norris <briannorris@chromium.org>
---
v2: Included vendor and product IDs in compatible strings for PCIe
chipsets(Rob Herring)
v3: Patch is created using -M option so that it will only include diff of
original and renamed files(Rob Herring)
Resend v3: Resending the patch because I missed to include device tree mailing
while sending v3.
v4: Fix error handling, also move-on even if no device tree node is present.
v5: Update commit log to include memory leak, return -EINVAL instead of -1.

 .../{marvell-sd8xxx.txt => marvell-8xxx.txt}       |  8 +++--
 drivers/net/wireless/marvell/mwifiex/pcie.c        | 39 +++++++++++++++++++---
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c     |  3 +-
 3 files changed, 42 insertions(+), 8 deletions(-)
 rename Documentation/devicetree/bindings/net/wireless/{marvell-sd8xxx.txt => marvell-8xxx.txt} (91%)

diff --git a/Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt b/Documentation/devicetree/bindings/net/wireless/marvell-8xxx.txt
similarity index 91%
rename from Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt
rename to Documentation/devicetree/bindings/net/wireless/marvell-8xxx.txt
index c421aba..dfe5f8e 100644
--- a/Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt
+++ b/Documentation/devicetree/bindings/net/wireless/marvell-8xxx.txt
@@ -1,8 +1,8 @@
-Marvell 8897/8997 (sd8897/sd8997) SDIO devices
+Marvell 8897/8997 (sd8897/sd8997/pcie8997) SDIO/PCIE devices
 ------
 
-This node provides properties for controlling the marvell sdio wireless device.
-The node is expected to be specified as a child node to the SDIO controller that
+This node provides properties for controlling the marvell sdio/pcie wireless device.
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
index 3c3c4f1..7c44f88 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -37,6 +37,22 @@ static struct mwifiex_if_ops pcie_ops;
 
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
+		pr_err("pcie device node not available");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int
 mwifiex_map_pci_memory(struct mwifiex_adapter *adapter, struct sk_buff *skb,
 		       size_t size, int flags)
@@ -178,6 +194,7 @@ static int mwifiex_pcie_probe(struct pci_dev *pdev,
 					const struct pci_device_id *ent)
 {
 	struct pcie_service_card *card;
+	int ret;
 
 	pr_debug("info: vendor=0x%4.04X device=0x%4.04X rev=%d\n",
 		 pdev->vendor, pdev->device, pdev->revision);
@@ -199,13 +216,27 @@ static int mwifiex_pcie_probe(struct pci_dev *pdev,
 		card->pcie.can_ext_scan = data->can_ext_scan;
 	}
 
-	if (mwifiex_add_card(card, &add_remove_card_sem, &pcie_ops,
-			     MWIFIEX_PCIE)) {
-		pr_err("%s failed\n", __func__);
-		return -1;
+	/* device tree node parsing and platform specific configuration*/
+	if (pdev->dev.of_node) {
+		ret = mwifiex_pcie_probe_of(&pdev->dev);
+		if (ret) {
+			dev_err(&pdev->dev,
+				"required compatible string missing\n");
+			goto err_free;
+		}
 	}
 
+	ret = mwifiex_add_card(card, &add_remove_card_sem, &pcie_ops,
+			       MWIFIEX_PCIE);
+	if (ret) {
+		pr_err("%s failed\n", __func__);
+		goto err_free;
+	}
 	return 0;
+
+err_free:
+	kfree(card);
+	return ret;
 }
 
 /*
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
2.8.0.rc3.226.g39d4020
