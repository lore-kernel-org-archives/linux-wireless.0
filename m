Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:49167 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756260AbZJVShK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 14:37:10 -0400
Date: Thu, 22 Oct 2009 20:19:33 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 02/28] mwl8k: coding style cleanups
Message-ID: <20091022181933.GD1583@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |  122 ++++++++++++++++++++++-------------------
 1 files changed, 65 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 3249998..252ef9c 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -27,11 +27,6 @@
 #define MWL8K_NAME	KBUILD_MODNAME
 #define MWL8K_VERSION	"0.10"
 
-MODULE_DESCRIPTION(MWL8K_DESC);
-MODULE_VERSION(MWL8K_VERSION);
-MODULE_AUTHOR("Lennert Buytenhek <buytenh@marvell.com>");
-MODULE_LICENSE("GPL");
-
 static DEFINE_PCI_DEVICE_TABLE(mwl8k_table) = {
 	{ PCI_VDEVICE(MARVELL, 0x2a2b), .driver_data = 8687, },
 	{ PCI_VDEVICE(MARVELL, 0x2a30), .driver_data = 8687, },
@@ -138,7 +133,6 @@ struct mwl8k_priv {
 	struct ieee80211_hw *hw;
 
 	struct pci_dev *pdev;
-	u8 name[16];
 
 	/* firmware files and meta data */
 	struct mwl8k_firmware fw;
@@ -353,14 +347,14 @@ static void mwl8k_release_firmware(struct mwl8k_priv *priv)
 
 /* Request fw image */
 static int mwl8k_request_fw(struct mwl8k_priv *priv,
-				const char *fname, struct firmware **fw)
+			    const char *fname, struct firmware **fw)
 {
 	/* release current image */
 	if (*fw != NULL)
 		mwl8k_release_fw(fw);
 
 	return request_firmware((const struct firmware **)fw,
-						fname, &priv->pdev->dev);
+				fname, &priv->pdev->dev);
 }
 
 static int mwl8k_request_firmware(struct mwl8k_priv *priv, u32 part_num)
@@ -375,9 +369,8 @@ static int mwl8k_request_firmware(struct mwl8k_priv *priv, u32 part_num)
 
 	rc = mwl8k_request_fw(priv, filename, &priv->fw.helper);
 	if (rc) {
-		printk(KERN_ERR
-			"%s Error requesting helper firmware file %s\n",
-			pci_name(priv->pdev), filename);
+		printk(KERN_ERR "%s: Error requesting helper firmware "
+		       "file %s\n", pci_name(priv->pdev), filename);
 		return rc;
 	}
 
@@ -386,8 +379,8 @@ static int mwl8k_request_firmware(struct mwl8k_priv *priv, u32 part_num)
 
 	rc = mwl8k_request_fw(priv, filename, &priv->fw.ucode);
 	if (rc) {
-		printk(KERN_ERR "%s Error requesting firmware file %s\n",
-					pci_name(priv->pdev), filename);
+		printk(KERN_ERR "%s: Error requesting firmware file %s\n",
+		       pci_name(priv->pdev), filename);
 		mwl8k_release_fw(&priv->fw.helper);
 		return rc;
 	}
@@ -542,32 +535,38 @@ static int mwl8k_feed_fw_image(struct mwl8k_priv *priv,
 	return rc;
 }
 
-static int mwl8k_load_firmware(struct mwl8k_priv *priv)
+static int mwl8k_load_firmware(struct ieee80211_hw *hw)
 {
-	int loops, rc;
+	struct mwl8k_priv *priv = hw->priv;
+	struct firmware *fw = priv->fw.ucode;
+	int rc;
+	int loops;
+
+	if (!memcmp(fw->data, "\x01\x00\x00\x00", 4)) {
+		struct firmware *helper = priv->fw.helper;
 
-	const u8 *ucode = priv->fw.ucode->data;
-	size_t ucode_len = priv->fw.ucode->size;
-	const u8 *helper = priv->fw.helper->data;
-	size_t helper_len = priv->fw.helper->size;
+		if (helper == NULL) {
+			printk(KERN_ERR "%s: helper image needed but none "
+			       "given\n", pci_name(priv->pdev));
+			return -EINVAL;
+		}
 
-	if (!memcmp(ucode, "\x01\x00\x00\x00", 4)) {
-		rc = mwl8k_load_fw_image(priv, helper, helper_len);
+		rc = mwl8k_load_fw_image(priv, helper->data, helper->size);
 		if (rc) {
 			printk(KERN_ERR "%s: unable to load firmware "
-				"helper image\n", pci_name(priv->pdev));
+			       "helper image\n", pci_name(priv->pdev));
 			return rc;
 		}
 		msleep(1);
 
-		rc = mwl8k_feed_fw_image(priv, ucode, ucode_len);
+		rc = mwl8k_feed_fw_image(priv, fw->data, fw->size);
 	} else {
-		rc = mwl8k_load_fw_image(priv, ucode, ucode_len);
+		rc = mwl8k_load_fw_image(priv, fw->data, fw->size);
 	}
 
 	if (rc) {
-		printk(KERN_ERR "%s: unable to load firmware data\n",
-			pci_name(priv->pdev));
+		printk(KERN_ERR "%s: unable to load firmware image\n",
+		       pci_name(priv->pdev));
 		return rc;
 	}
 
@@ -772,7 +771,7 @@ static int mwl8k_rxq_init(struct ieee80211_hw *hw, int index)
 		pci_alloc_consistent(priv->pdev, size, &rxq->rx_desc_dma);
 	if (rxq->rx_desc_area == NULL) {
 		printk(KERN_ERR "%s: failed to alloc RX descriptors\n",
-		       priv->name);
+		       wiphy_name(hw->wiphy));
 		return -ENOMEM;
 	}
 	memset(rxq->rx_desc_area, 0, size);
@@ -781,7 +780,7 @@ static int mwl8k_rxq_init(struct ieee80211_hw *hw, int index)
 				sizeof(*rxq->rx_skb), GFP_KERNEL);
 	if (rxq->rx_skb == NULL) {
 		printk(KERN_ERR "%s: failed to alloc RX skbuff list\n",
-			priv->name);
+		       wiphy_name(hw->wiphy));
 		pci_free_consistent(priv->pdev, size,
 				    rxq->rx_desc_area, rxq->rx_desc_dma);
 		return -ENOMEM;
@@ -934,9 +933,9 @@ static int rxq_process(struct ieee80211_hw *hw, int index, int limit)
 		wh = (struct ieee80211_hdr *)skb->data;
 
 		/*
-		 * Check for pending join operation. save a copy of
-		 * the beacon and schedule a tasklet to send finalize
-		 * join command to the firmware.
+		 * Check for a pending join operation.  Save a
+		 * copy of the beacon and schedule a tasklet to
+		 * send a FINALIZE_JOIN command to the firmware.
 		 */
 		if (mwl8k_capture_bssid(priv, wh))
 			mwl8k_save_beacon(priv, skb);
@@ -1024,7 +1023,7 @@ static int mwl8k_txq_init(struct ieee80211_hw *hw, int index)
 		pci_alloc_consistent(priv->pdev, size, &txq->tx_desc_dma);
 	if (txq->tx_desc_area == NULL) {
 		printk(KERN_ERR "%s: failed to alloc TX descriptors\n",
-		       priv->name);
+		       wiphy_name(hw->wiphy));
 		return -ENOMEM;
 	}
 	memset(txq->tx_desc_area, 0, size);
@@ -1033,7 +1032,7 @@ static int mwl8k_txq_init(struct ieee80211_hw *hw, int index)
 								GFP_KERNEL);
 	if (txq->tx_skb == NULL) {
 		printk(KERN_ERR "%s: failed to alloc TX skbuff list\n",
-		       priv->name);
+		       wiphy_name(hw->wiphy));
 		pci_free_consistent(priv->pdev, size,
 				    txq->tx_desc_area, txq->tx_desc_dma);
 		return -ENOMEM;
@@ -1154,8 +1153,8 @@ static int mwl8k_tx_wait_empty(struct ieee80211_hw *hw)
 
 		mwl8k_scan_tx_ring(priv, txinfo);
 		for (index = 0; index < MWL8K_TX_QUEUES; index++)
-			printk(KERN_ERR
-				"TXQ:%u L:%u H:%u T:%u FW:%u DRV:%u U:%u\n",
+			printk(KERN_ERR "TXQ:%u L:%u H:%u T:%u FW:%u "
+			       "DRV:%u U:%u\n",
 					index,
 					txinfo[index].len,
 					txinfo[index].head,
@@ -1317,7 +1316,7 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 
 	if (pci_dma_mapping_error(priv->pdev, dma)) {
 		printk(KERN_DEBUG "%s: failed to dma map skb, "
-			"dropping TX frame.\n", priv->name);
+		       "dropping TX frame.\n", wiphy_name(hw->wiphy));
 		dev_kfree_skb(skb);
 		return NETDEV_TX_OK;
 	}
@@ -1431,7 +1430,7 @@ static int mwl8k_post_cmd(struct ieee80211_hw *hw, struct mwl8k_cmd_pkt *cmd)
 	unsigned long timeout = 0;
 	u8 buf[32];
 
-	cmd->result = 0xFFFF;
+	cmd->result = 0xffff;
 	dma_size = le16_to_cpu(cmd->length);
 	dma_addr = pci_map_single(priv->pdev, cmd, dma_size,
 				  PCI_DMA_BIDIRECTIONAL);
@@ -1464,7 +1463,7 @@ static int mwl8k_post_cmd(struct ieee80211_hw *hw, struct mwl8k_cmd_pkt *cmd)
 
 	if (!timeout) {
 		printk(KERN_ERR "%s: Command %s timeout after %u ms\n",
-		       priv->name,
+		       wiphy_name(hw->wiphy),
 		       mwl8k_cmd_name(cmd->code, buf, sizeof(buf)),
 		       MWL8K_CMD_TIMEOUT_MS);
 		rc = -ETIMEDOUT;
@@ -1472,7 +1471,7 @@ static int mwl8k_post_cmd(struct ieee80211_hw *hw, struct mwl8k_cmd_pkt *cmd)
 		rc = cmd->result ? -EINVAL : 0;
 		if (rc)
 			printk(KERN_ERR "%s: Command %s error 0x%x\n",
-			       priv->name,
+			       wiphy_name(hw->wiphy),
 			       mwl8k_cmd_name(cmd->code, buf, sizeof(buf)),
 			       le16_to_cpu(cmd->result));
 	}
@@ -2091,8 +2090,8 @@ static int mwl8k_finalize_join(struct ieee80211_hw *hw, void *frame,
 	/* XXX TBD Might just have to abort and return an error */
 	if (payload_len > MWL8K_FJ_BEACON_MAXLEN)
 		printk(KERN_ERR "%s(): WARNING: Incomplete beacon "
-			"sent to firmware. Sz=%u MAX=%u\n", __func__,
-			payload_len, MWL8K_FJ_BEACON_MAXLEN);
+		       "sent to firmware. Sz=%u MAX=%u\n", __func__,
+		       payload_len, MWL8K_FJ_BEACON_MAXLEN);
 
 	if (payload_len > MWL8K_FJ_BEACON_MAXLEN)
 		payload_len = MWL8K_FJ_BEACON_MAXLEN;
@@ -2339,9 +2338,10 @@ static int mwl8k_cmd_use_fixed_rate(struct ieee80211_hw *hw,
 	cmd->rate_type = cpu_to_le32(rate_type);
 
 	if (rate_table != NULL) {
-		/* Copy over each field manually so
-		* that bitflipping can be done
-		*/
+		/*
+		 * Copy over each field manually so that endian
+		 * conversion can be done.
+		 */
 		cmd->rate_table.allow_rate_drop =
 				cpu_to_le32(rate_table->allow_rate_drop);
 		cmd->rate_table.num_rates =
@@ -2416,7 +2416,7 @@ static int mwl8k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	if (priv->current_channel == NULL) {
 		printk(KERN_DEBUG "%s: dropped TX frame since radio "
-		       "disabled\n", priv->name);
+		       "disabled\n", wiphy_name(hw->wiphy));
 		dev_kfree_skb(skb);
 		return NETDEV_TX_OK;
 	}
@@ -2435,7 +2435,7 @@ static int mwl8k_start(struct ieee80211_hw *hw)
 			 IRQF_SHARED, MWL8K_NAME, hw);
 	if (rc) {
 		printk(KERN_ERR "%s: failed to register IRQ handler\n",
-		       priv->name);
+		       wiphy_name(hw->wiphy));
 		return -EIO;
 	}
 
@@ -2862,14 +2862,14 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	priv->pdev = pdev;
 	priv->wmm_enabled = false;
 	priv->pending_tx_pkts = 0;
-	strncpy(priv->name, MWL8K_NAME, sizeof(priv->name));
 
 	SET_IEEE80211_DEV(hw, &pdev->dev);
 	pci_set_drvdata(pdev, hw);
 
 	priv->regs = pci_iomap(pdev, 1, 0x10000);
 	if (priv->regs == NULL) {
-		printk(KERN_ERR "%s: Cannot map device memory\n", priv->name);
+		printk(KERN_ERR "%s: Cannot map device memory\n",
+		       wiphy_name(hw->wiphy));
 		goto err_iounmap;
 	}
 
@@ -2952,7 +2952,7 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 			 IRQF_SHARED, MWL8K_NAME, hw);
 	if (rc) {
 		printk(KERN_ERR "%s: failed to register IRQ handler\n",
-		       priv->name);
+		       wiphy_name(hw->wiphy));
 		goto err_free_queues;
 	}
 
@@ -2962,14 +2962,16 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	/* Ask userland hotplug daemon for the device firmware */
 	rc = mwl8k_request_firmware(priv, (u32)id->driver_data);
 	if (rc) {
-		printk(KERN_ERR "%s: Firmware files not found\n", priv->name);
+		printk(KERN_ERR "%s: Firmware files not found\n",
+		       wiphy_name(hw->wiphy));
 		goto err_free_irq;
 	}
 
 	/* Load firmware into hardware */
-	rc = mwl8k_load_firmware(priv);
+	rc = mwl8k_load_firmware(hw);
 	if (rc) {
-		printk(KERN_ERR "%s: Cannot start firmware\n", priv->name);
+		printk(KERN_ERR "%s: Cannot start firmware\n",
+		       wiphy_name(hw->wiphy));
 		goto err_stop_firmware;
 	}
 
@@ -2986,14 +2988,15 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	/* Get config data, mac addrs etc */
 	rc = mwl8k_cmd_get_hw_spec(hw);
 	if (rc) {
-		printk(KERN_ERR "%s: Cannot initialise firmware\n", priv->name);
+		printk(KERN_ERR "%s: Cannot initialise firmware\n",
+		       wiphy_name(hw->wiphy));
 		goto err_stop_firmware;
 	}
 
 	/* Turn radio off */
 	rc = mwl8k_cmd_802_11_radio_disable(hw);
 	if (rc) {
-		printk(KERN_ERR "%s: Cannot disable\n", priv->name);
+		printk(KERN_ERR "%s: Cannot disable\n", wiphy_name(hw->wiphy));
 		goto err_stop_firmware;
 	}
 
@@ -3003,7 +3006,8 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 
 	rc = ieee80211_register_hw(hw);
 	if (rc) {
-		printk(KERN_ERR "%s: Cannot register device\n", priv->name);
+		printk(KERN_ERR "%s: Cannot register device\n",
+		       wiphy_name(hw->wiphy));
 		goto err_stop_firmware;
 	}
 
@@ -3086,8 +3090,7 @@ static void __devexit mwl8k_remove(struct pci_dev *pdev)
 
 	mwl8k_rxq_deinit(hw, 0);
 
-	pci_free_consistent(priv->pdev, 4,
-				priv->cookie, priv->cookie_dma);
+	pci_free_consistent(priv->pdev, 4, priv->cookie, priv->cookie_dma);
 
 	pci_iounmap(pdev, priv->regs);
 	pci_set_drvdata(pdev, NULL);
@@ -3116,3 +3119,8 @@ static void __exit mwl8k_exit(void)
 
 module_init(mwl8k_init);
 module_exit(mwl8k_exit);
+
+MODULE_DESCRIPTION(MWL8K_DESC);
+MODULE_VERSION(MWL8K_VERSION);
+MODULE_AUTHOR("Lennert Buytenhek <buytenh@marvell.com>");
+MODULE_LICENSE("GPL");
-- 
1.5.6.4
