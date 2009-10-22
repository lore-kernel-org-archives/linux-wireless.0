Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:59628 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756485AbZJVSxu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 14:53:50 -0400
Date: Thu, 22 Oct 2009 20:20:50 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 16/28] mwl8k: spell out the names of firmware images in the pci driver data
Message-ID: <20091022182050.GR1583@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To allow use of a more flexible firmware file naming scheme.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   43 +++++++++++++++++++++--------------------
 1 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 49edd0c..37b3f31 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -80,7 +80,9 @@
 #define MWL8K_TX_QUEUES		4
 
 struct mwl8k_device_info {
-	int part_num;
+	char *part_name;
+	char *helper_image;
+	char *fw_image;
 };
 
 struct mwl8k_rx_queue {
@@ -112,11 +114,11 @@ struct mwl8k_tx_queue {
 
 /* Pointers to the firmware data and meta information about it.  */
 struct mwl8k_firmware {
-	/* Microcode */
-	struct firmware *ucode;
-
 	/* Boot helper code */
 	struct firmware *helper;
+
+	/* Microcode */
+	struct firmware *ucode;
 };
 
 struct mwl8k_priv {
@@ -355,26 +357,23 @@ static int mwl8k_request_fw(struct mwl8k_priv *priv,
 
 static int mwl8k_request_firmware(struct mwl8k_priv *priv)
 {
-	u8 filename[64];
+	struct mwl8k_device_info *di = priv->device_info;
 	int rc;
 
-	snprintf(filename, sizeof(filename),
-		 "mwl8k/helper_%u.fw", priv->device_info->part_num);
-
-	rc = mwl8k_request_fw(priv, filename, &priv->fw.helper);
-	if (rc) {
-		printk(KERN_ERR "%s: Error requesting helper firmware "
-		       "file %s\n", pci_name(priv->pdev), filename);
-		return rc;
+	if (di->helper_image != NULL) {
+		rc = mwl8k_request_fw(priv, di->helper_image, &priv->fw.helper);
+		if (rc) {
+			printk(KERN_ERR "%s: Error requesting helper "
+			       "firmware file %s\n", pci_name(priv->pdev),
+			       di->helper_image);
+			return rc;
+		}
 	}
 
-	snprintf(filename, sizeof(filename),
-		 "mwl8k/fmimage_%u.fw", priv->device_info->part_num);
-
-	rc = mwl8k_request_fw(priv, filename, &priv->fw.ucode);
+	rc = mwl8k_request_fw(priv, di->fw_image, &priv->fw.ucode);
 	if (rc) {
 		printk(KERN_ERR "%s: Error requesting firmware file %s\n",
-		       pci_name(priv->pdev), filename);
+		       pci_name(priv->pdev), di->fw_image);
 		mwl8k_release_fw(&priv->fw.helper);
 		return rc;
 	}
@@ -2937,7 +2936,9 @@ static void mwl8k_finalize_join_worker(struct work_struct *work)
 }
 
 static struct mwl8k_device_info di_8687 = {
-	.part_num	= 8687,
+	.part_name	= "88w8687",
+	.helper_image	= "mwl8k/helper_8687.fw",
+	.fw_image	= "mwl8k/fmimage_8687.fw",
 };
 
 static DEFINE_PCI_DEVICE_TABLE(mwl8k_pci_id_table) = {
@@ -3163,8 +3164,8 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 		goto err_stop_firmware;
 	}
 
-	printk(KERN_INFO "%s: 88w%u v%d, %pM, firmware version %u.%u.%u.%u\n",
-	       wiphy_name(hw->wiphy), priv->device_info->part_num,
+	printk(KERN_INFO "%s: %s v%d, %pM, firmware version %u.%u.%u.%u\n",
+	       wiphy_name(hw->wiphy), priv->device_info->part_name,
 	       priv->hw_rev, hw->wiphy->perm_addr,
 	       (priv->fw_rev >> 24) & 0xff, (priv->fw_rev >> 16) & 0xff,
 	       (priv->fw_rev >> 8) & 0xff, priv->fw_rev & 0xff);
-- 
1.5.6.4
