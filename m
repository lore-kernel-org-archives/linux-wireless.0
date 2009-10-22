Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:59624 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756580AbZJVSxt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 14:53:49 -0400
Date: Thu, 22 Oct 2009 20:20:47 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 15/28] mwl8k: change pci id table driver data to a structure pointer
Message-ID: <20091022182046.GQ1583@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To prepare for adding support for more device types, introduce a
new structure, mwl8k_device_info, where per-device information can
be stored, and change the pci id table driver data from an integer
indicating only the part number to a pointer to a mwl8k_device_info
structure.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   47 ++++++++++++++++++++++++++---------------
 1 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 7aea8eb..49edd0c 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -27,13 +27,6 @@
 #define MWL8K_NAME	KBUILD_MODNAME
 #define MWL8K_VERSION	"0.10"
 
-static DEFINE_PCI_DEVICE_TABLE(mwl8k_table) = {
-	{ PCI_VDEVICE(MARVELL, 0x2a2b), .driver_data = 8687, },
-	{ PCI_VDEVICE(MARVELL, 0x2a30), .driver_data = 8687, },
-	{ }
-};
-MODULE_DEVICE_TABLE(pci, mwl8k_table);
-
 /* Register definitions */
 #define MWL8K_HIU_GEN_PTR			0x00000c10
 #define  MWL8K_MODE_STA				 0x0000005a
@@ -86,6 +79,10 @@ MODULE_DEVICE_TABLE(pci, mwl8k_table);
 #define MWL8K_RX_QUEUES		1
 #define MWL8K_TX_QUEUES		4
 
+struct mwl8k_device_info {
+	int part_num;
+};
+
 struct mwl8k_rx_queue {
 	int rxd_count;
 
@@ -129,9 +126,10 @@ struct mwl8k_priv {
 
 	struct pci_dev *pdev;
 
+	struct mwl8k_device_info *device_info;
+
 	/* firmware files and meta data */
 	struct mwl8k_firmware fw;
-	u32 part_num;
 
 	/* firmware access */
 	struct mutex fw_mutex;
@@ -355,15 +353,13 @@ static int mwl8k_request_fw(struct mwl8k_priv *priv,
 				fname, &priv->pdev->dev);
 }
 
-static int mwl8k_request_firmware(struct mwl8k_priv *priv, u32 part_num)
+static int mwl8k_request_firmware(struct mwl8k_priv *priv)
 {
 	u8 filename[64];
 	int rc;
 
-	priv->part_num = part_num;
-
 	snprintf(filename, sizeof(filename),
-		 "mwl8k/helper_%u.fw", priv->part_num);
+		 "mwl8k/helper_%u.fw", priv->device_info->part_num);
 
 	rc = mwl8k_request_fw(priv, filename, &priv->fw.helper);
 	if (rc) {
@@ -373,7 +369,7 @@ static int mwl8k_request_firmware(struct mwl8k_priv *priv, u32 part_num)
 	}
 
 	snprintf(filename, sizeof(filename),
-		 "mwl8k/fmimage_%u.fw", priv->part_num);
+		 "mwl8k/fmimage_%u.fw", priv->device_info->part_num);
 
 	rc = mwl8k_request_fw(priv, filename, &priv->fw.ucode);
 	if (rc) {
@@ -2940,6 +2936,22 @@ static void mwl8k_finalize_join_worker(struct work_struct *work)
 	priv->beacon_skb = NULL;
 }
 
+static struct mwl8k_device_info di_8687 = {
+	.part_num	= 8687,
+};
+
+static DEFINE_PCI_DEVICE_TABLE(mwl8k_pci_id_table) = {
+	{
+		PCI_VDEVICE(MARVELL, 0x2a2b),
+		.driver_data = (unsigned long)&di_8687,
+	}, {
+		PCI_VDEVICE(MARVELL, 0x2a30),
+		.driver_data = (unsigned long)&di_8687,
+	}, {
+	},
+};
+MODULE_DEVICE_TABLE(pci, mwl8k_pci_id_table);
+
 static int __devinit mwl8k_probe(struct pci_dev *pdev,
 				 const struct pci_device_id *id)
 {
@@ -2980,6 +2992,7 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	priv = hw->priv;
 	priv->hw = hw;
 	priv->pdev = pdev;
+	priv->device_info = (void *)id->driver_data;
 	priv->sniffer_enabled = false;
 	priv->wmm_enabled = false;
 	priv->pending_tx_pkts = 0;
@@ -3091,7 +3104,7 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	mwl8k_hw_reset(priv);
 
 	/* Ask userland hotplug daemon for the device firmware */
-	rc = mwl8k_request_firmware(priv, (u32)id->driver_data);
+	rc = mwl8k_request_firmware(priv);
 	if (rc) {
 		printk(KERN_ERR "%s: Firmware files not found\n",
 		       wiphy_name(hw->wiphy));
@@ -3151,8 +3164,8 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	}
 
 	printk(KERN_INFO "%s: 88w%u v%d, %pM, firmware version %u.%u.%u.%u\n",
-	       wiphy_name(hw->wiphy), priv->part_num, priv->hw_rev,
-	       hw->wiphy->perm_addr,
+	       wiphy_name(hw->wiphy), priv->device_info->part_num,
+	       priv->hw_rev, hw->wiphy->perm_addr,
 	       (priv->fw_rev >> 24) & 0xff, (priv->fw_rev >> 16) & 0xff,
 	       (priv->fw_rev >> 8) & 0xff, priv->fw_rev & 0xff);
 
@@ -3238,7 +3251,7 @@ static void __devexit mwl8k_remove(struct pci_dev *pdev)
 
 static struct pci_driver mwl8k_driver = {
 	.name		= MWL8K_NAME,
-	.id_table	= mwl8k_table,
+	.id_table	= mwl8k_pci_id_table,
 	.probe		= mwl8k_probe,
 	.remove		= __devexit_p(mwl8k_remove),
 	.shutdown	= __devexit_p(mwl8k_shutdown),
-- 
1.5.6.4
