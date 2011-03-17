Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65082 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab1CQS7J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2011 14:59:09 -0400
Received: by iyb26 with SMTP id 26so3126341iyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2011 11:59:08 -0700 (PDT)
From: Brian Cavagnolo <brian@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: buytenh@wantstofly.org, Brian Cavagnolo <brian@cozybit.com>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH 1/9] mwl8k: refactor in preparation for APIv2 update
Date: Thu, 17 Mar 2011 11:58:41 -0700
Message-Id: <1300388329-15380-1-git-send-email-brian@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Specifically, APIv2 will specify a variable number of AMPDU
queues in the MWL8K_CMD_GET_HW_SPEC.  So init the tx queues after
MWL8K_CMD_GET_HW_SPEC for ap fw.

Also, we make it safe to deinit queues that have not been init'd.
This happens if the mwl8k_get_hw_spec_ap routine fails, for
example.

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Brian Cavagnolo <brian@cozybit.com>
---
 drivers/net/wireless/mwl8k.c |   51 +++++++++++++++++++++++++++++++----------
 1 files changed, 38 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 3695227..8fefed2 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -191,6 +191,7 @@ struct mwl8k_priv {
 
 	struct mwl8k_rx_queue rxq[MWL8K_RX_QUEUES];
 	struct mwl8k_tx_queue txq[MWL8K_TX_QUEUES];
+	u32 txq_offset[MWL8K_TX_QUEUES];
 
 	bool radio_on;
 	bool radio_short_preamble;
@@ -1126,6 +1127,9 @@ static void mwl8k_rxq_deinit(struct ieee80211_hw *hw, int index)
 	struct mwl8k_rx_queue *rxq = priv->rxq + index;
 	int i;
 
+	if (rxq->rxd == NULL)
+		return;
+
 	for (i = 0; i < MWL8K_RX_DESCS; i++) {
 		if (rxq->buf[i].skb != NULL) {
 			pci_unmap_single(priv->pdev,
@@ -1560,6 +1564,9 @@ static void mwl8k_txq_deinit(struct ieee80211_hw *hw, int index)
 	struct mwl8k_priv *priv = hw->priv;
 	struct mwl8k_tx_queue *txq = priv->txq + index;
 
+	if (txq->txd == NULL)
+		return;
+
 	mwl8k_txq_reclaim(hw, index, INT_MAX, 1);
 
 	kfree(txq->skb);
@@ -2058,23 +2065,16 @@ static int mwl8k_cmd_get_hw_spec_ap(struct ieee80211_hw *hw)
 		priv->ap_macids_supported = 0x000000ff;
 		priv->sta_macids_supported = 0x00000000;
 
-		off = le32_to_cpu(cmd->wcbbase0) & 0xffff;
-		iowrite32(priv->txq[0].txd_dma, priv->sram + off);
-
 		off = le32_to_cpu(cmd->rxwrptr) & 0xffff;
 		iowrite32(priv->rxq[0].rxd_dma, priv->sram + off);
 
 		off = le32_to_cpu(cmd->rxrdptr) & 0xffff;
 		iowrite32(priv->rxq[0].rxd_dma, priv->sram + off);
 
-		off = le32_to_cpu(cmd->wcbbase1) & 0xffff;
-		iowrite32(priv->txq[1].txd_dma, priv->sram + off);
-
-		off = le32_to_cpu(cmd->wcbbase2) & 0xffff;
-		iowrite32(priv->txq[2].txd_dma, priv->sram + off);
-
-		off = le32_to_cpu(cmd->wcbbase3) & 0xffff;
-		iowrite32(priv->txq[3].txd_dma, priv->sram + off);
+		priv->txq_offset[0] = le32_to_cpu(cmd->wcbbase0) & 0xffff;
+		priv->txq_offset[1] = le32_to_cpu(cmd->wcbbase1) & 0xffff;
+		priv->txq_offset[2] = le32_to_cpu(cmd->wcbbase2) & 0xffff;
+		priv->txq_offset[3] = le32_to_cpu(cmd->wcbbase3) & 0xffff;
 	}
 
 done:
@@ -4600,6 +4600,23 @@ static int mwl8k_init_firmware(struct ieee80211_hw *hw, char *fw_image,
 	return rc;
 }
 
+static int mwl8k_init_txqs(struct ieee80211_hw *hw)
+{
+	struct mwl8k_priv *priv = hw->priv;
+	int rc = 0;
+	int i;
+
+	for (i = 0; i < MWL8K_TX_QUEUES; i++) {
+		rc = mwl8k_txq_init(hw, i);
+		if (rc)
+			break;
+		if (priv->ap_fw)
+			iowrite32(priv->txq[i].txd_dma,
+				  priv->sram + priv->txq_offset[i]);
+	}
+	return rc;
+}
+
 /* initialize hw after successfully loading a firmware image */
 static int mwl8k_probe_hw(struct ieee80211_hw *hw)
 {
@@ -4627,8 +4644,14 @@ static int mwl8k_probe_hw(struct ieee80211_hw *hw)
 		goto err_stop_firmware;
 	rxq_refill(hw, 0, INT_MAX);
 
-	for (i = 0; i < MWL8K_TX_QUEUES; i++) {
-		rc = mwl8k_txq_init(hw, i);
+	/* For the sta firmware, we need to know the dma addresses of tx queues
+	 * before sending MWL8K_CMD_GET_HW_SPEC.  So we must initialize them
+	 * prior to issuing this command.  But for the AP case, we learn the
+	 * total number of queues from the result CMD_GET_HW_SPEC, so for this
+	 * case we must initialize the tx queues after.
+	 */
+	if (!priv->ap_fw) {
+		rc = mwl8k_init_txqs(hw);
 		if (rc)
 			goto err_free_queues;
 	}
@@ -4657,6 +4680,8 @@ static int mwl8k_probe_hw(struct ieee80211_hw *hw)
 	if (priv->ap_fw) {
 		rc = mwl8k_cmd_get_hw_spec_ap(hw);
 		if (!rc)
+			rc = mwl8k_init_txqs(hw);
+		if (!rc)
 			rc = mwl8k_cmd_set_hw_spec(hw);
 	} else {
 		rc = mwl8k_cmd_get_hw_spec_sta(hw);
-- 
1.7.1.1

