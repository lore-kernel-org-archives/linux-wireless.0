Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42318 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968Ab1CQS7P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2011 14:59:15 -0400
Received: by iwn34 with SMTP id 34so3123030iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2011 11:59:14 -0700 (PDT)
From: Brian Cavagnolo <brian@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: buytenh@wantstofly.org, Brian Cavagnolo <brian@cozybit.com>
Subject: [PATCH 4/9] mwl8k: differentiate between WMM queues and AMPDU queues
Date: Thu, 17 Mar 2011 11:58:44 -0700
Message-Id: <1300388329-15380-4-git-send-email-brian@cozybit.com>
In-Reply-To: <1300388329-15380-1-git-send-email-brian@cozybit.com>
References: <1300388329-15380-1-git-send-email-brian@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We now have two different kinds of queues.  And the number of
AMPDU queues may vary.  So we must be clear about which queues we
are dealing with.  Note that when we report the number of queues
to mac80211, we only report the WMM queues.

Based on work by Yogesh Powar <yogeshp@marvell.com>.

Signed-off-by: Brian Cavagnolo <brian@cozybit.com>
---
 drivers/net/wireless/mwl8k.c |   52 +++++++++++++++++++++--------------------
 1 files changed, 27 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 944ad03..53581ee 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -85,8 +85,10 @@ MODULE_PARM_DESC(ap_mode_default,
 				 MWL8K_A2H_INT_TX_DONE)
 
 #define MWL8K_RX_QUEUES		1
-#define MWL8K_TX_QUEUES		4
+#define MWL8K_TX_WMM_QUEUES	4
 #define MWL8K_MAX_AMPDU_QUEUES	8
+#define MWL8K_MAX_TX_QUEUES	(MWL8K_TX_WMM_QUEUES + MWL8K_MAX_AMPDU_QUEUES)
+#define mwl8k_tx_queues(priv)	(MWL8K_TX_WMM_QUEUES + (priv)->num_ampdu_queues)
 
 struct rxd_ops {
 	int rxd_size;
@@ -202,8 +204,8 @@ struct mwl8k_priv {
 	int pending_tx_pkts;
 
 	struct mwl8k_rx_queue rxq[MWL8K_RX_QUEUES];
-	struct mwl8k_tx_queue txq[MWL8K_TX_QUEUES + MWL8K_MAX_AMPDU_QUEUES];
-	u32 txq_offset[MWL8K_TX_QUEUES + MWL8K_MAX_AMPDU_QUEUES];
+	struct mwl8k_tx_queue txq[MWL8K_MAX_TX_QUEUES];
+	u32 txq_offset[MWL8K_MAX_TX_QUEUES];
 
 	bool radio_on;
 	bool radio_short_preamble;
@@ -236,7 +238,7 @@ struct mwl8k_priv {
 	 * preserve the queue configurations so they can be restored if/when
 	 * the firmware image is swapped.
 	 */
-	struct ieee80211_tx_queue_params wmm_params[MWL8K_TX_QUEUES];
+	struct ieee80211_tx_queue_params wmm_params[MWL8K_TX_WMM_QUEUES];
 
 	/* async firmware loading state */
 	unsigned fw_state;
@@ -1400,7 +1402,7 @@ static void mwl8k_dump_tx_rings(struct ieee80211_hw *hw)
 	struct mwl8k_priv *priv = hw->priv;
 	int i;
 
-	for (i = 0; i < MWL8K_TX_QUEUES; i++) {
+	for (i = 0; i < mwl8k_tx_queues(priv); i++) {
 		struct mwl8k_tx_queue *txq = priv->txq + i;
 		int fw_owned = 0;
 		int drv_owned = 0;
@@ -1888,7 +1890,7 @@ struct mwl8k_cmd_get_hw_spec_sta {
 	__u8 mcs_bitmap[16];
 	__le32 rx_queue_ptr;
 	__le32 num_tx_queues;
-	__le32 tx_queue_ptrs[MWL8K_TX_QUEUES];
+	__le32 tx_queue_ptrs[MWL8K_TX_WMM_QUEUES];
 	__le32 caps2;
 	__le32 num_tx_desc_per_queue;
 	__le32 total_rxd;
@@ -1994,8 +1996,8 @@ static int mwl8k_cmd_get_hw_spec_sta(struct ieee80211_hw *hw)
 	memset(cmd->perm_addr, 0xff, sizeof(cmd->perm_addr));
 	cmd->ps_cookie = cpu_to_le32(priv->cookie_dma);
 	cmd->rx_queue_ptr = cpu_to_le32(priv->rxq[0].rxd_dma);
-	cmd->num_tx_queues = cpu_to_le32(MWL8K_TX_QUEUES);
-	for (i = 0; i < MWL8K_TX_QUEUES; i++)
+	cmd->num_tx_queues = cpu_to_le32(mwl8k_tx_queues(priv));
+	for (i = 0; i < mwl8k_tx_queues(priv); i++)
 		cmd->tx_queue_ptrs[i] = cpu_to_le32(priv->txq[i].txd_dma);
 	cmd->num_tx_desc_per_queue = cpu_to_le32(MWL8K_TX_DESCS);
 	cmd->total_rxd = cpu_to_le32(MWL8K_RX_DESCS);
@@ -2101,7 +2103,7 @@ static int mwl8k_cmd_get_hw_spec_ap(struct ieee80211_hw *hw)
 		priv->txq_offset[3] = le32_to_cpu(cmd->wcbbase3) & 0xffff;
 
 		for (i = 0; i < priv->num_ampdu_queues; i++)
-			priv->txq_offset[i + MWL8K_TX_QUEUES] =
+			priv->txq_offset[i + MWL8K_TX_WMM_QUEUES] =
 				le32_to_cpu(cmd->wcbbase_ampdu[i]) & 0xffff;
 	}
 
@@ -2125,7 +2127,7 @@ struct mwl8k_cmd_set_hw_spec {
 	__le32 caps;
 	__le32 rx_queue_ptr;
 	__le32 num_tx_queues;
-	__le32 tx_queue_ptrs[MWL8K_TX_QUEUES];
+	__le32 tx_queue_ptrs[MWL8K_MAX_TX_QUEUES];
 	__le32 flags;
 	__le32 num_tx_desc_per_queue;
 	__le32 total_rxd;
@@ -2159,7 +2161,7 @@ static int mwl8k_cmd_set_hw_spec(struct ieee80211_hw *hw)
 
 	cmd->ps_cookie = cpu_to_le32(priv->cookie_dma);
 	cmd->rx_queue_ptr = cpu_to_le32(priv->rxq[0].rxd_dma);
-	cmd->num_tx_queues = cpu_to_le32(MWL8K_TX_QUEUES);
+	cmd->num_tx_queues = cpu_to_le32(mwl8k_tx_queues(priv));
 
 	/*
 	 * Mac80211 stack has Q0 as highest priority and Q3 as lowest in
@@ -2167,8 +2169,8 @@ static int mwl8k_cmd_set_hw_spec(struct ieee80211_hw *hw)
 	 * in that order. Map Q3 of mac80211 to Q0 of firmware so that the
 	 * priority is interpreted the right way in firmware.
 	 */
-	for (i = 0; i < MWL8K_TX_QUEUES; i++) {
-		int j = MWL8K_TX_QUEUES - 1 - i;
+	for (i = 0; i < mwl8k_tx_queues(priv); i++) {
+		int j = mwl8k_tx_queues(priv) - 1 - i;
 		cmd->tx_queue_ptrs[i] = cpu_to_le32(priv->txq[j].txd_dma);
 	}
 
@@ -3880,7 +3882,7 @@ static void mwl8k_tx_poll(unsigned long data)
 
 	spin_lock_bh(&priv->tx_lock);
 
-	for (i = 0; i < MWL8K_TX_QUEUES; i++)
+	for (i = 0; i < mwl8k_tx_queues(priv); i++)
 		limit -= mwl8k_txq_reclaim(hw, i, limit, 0);
 
 	if (!priv->pending_tx_pkts && priv->tx_wait != NULL) {
@@ -4012,7 +4014,7 @@ static void mwl8k_stop(struct ieee80211_hw *hw)
 	tasklet_disable(&priv->poll_rx_task);
 
 	/* Return all skbs to mac80211 */
-	for (i = 0; i < MWL8K_TX_QUEUES; i++)
+	for (i = 0; i < mwl8k_tx_queues(priv); i++)
 		mwl8k_txq_reclaim(hw, i, INT_MAX, 1);
 }
 
@@ -4510,14 +4512,14 @@ static int mwl8k_conf_tx(struct ieee80211_hw *hw, u16 queue,
 
 	rc = mwl8k_fw_lock(hw);
 	if (!rc) {
-		BUG_ON(queue > MWL8K_TX_QUEUES - 1);
+		BUG_ON(queue > MWL8K_TX_WMM_QUEUES - 1);
 		memcpy(&priv->wmm_params[queue], params, sizeof(*params));
 
 		if (!priv->wmm_enabled)
 			rc = mwl8k_cmd_set_wmm_mode(hw, 1);
 
 		if (!rc) {
-			int q = MWL8K_TX_QUEUES - 1 - queue;
+			int q = MWL8K_TX_WMM_QUEUES - 1 - queue;
 			rc = mwl8k_cmd_set_edca_params(hw, q,
 						       params->cw_min,
 						       params->cw_max,
@@ -4788,7 +4790,7 @@ static int mwl8k_init_txqs(struct ieee80211_hw *hw)
 	int rc = 0;
 	int i;
 
-	for (i = 0; i < MWL8K_TX_QUEUES; i++) {
+	for (i = 0; i < mwl8k_tx_queues(priv); i++) {
 		rc = mwl8k_txq_init(hw, i);
 		if (rc)
 			break;
@@ -4906,7 +4908,7 @@ err_free_irq:
 	free_irq(priv->pdev->irq, hw);
 
 err_free_queues:
-	for (i = 0; i < MWL8K_TX_QUEUES; i++)
+	for (i = 0; i < mwl8k_tx_queues(priv); i++)
 		mwl8k_txq_deinit(hw, i);
 	mwl8k_rxq_deinit(hw, 0);
 
@@ -4928,7 +4930,7 @@ static int mwl8k_reload_firmware(struct ieee80211_hw *hw, char *fw_image)
 	mwl8k_stop(hw);
 	mwl8k_rxq_deinit(hw, 0);
 
-	for (i = 0; i < MWL8K_TX_QUEUES; i++)
+	for (i = 0; i < mwl8k_tx_queues(priv); i++)
 		mwl8k_txq_deinit(hw, i);
 
 	rc = mwl8k_init_firmware(hw, fw_image, false);
@@ -4947,7 +4949,7 @@ static int mwl8k_reload_firmware(struct ieee80211_hw *hw, char *fw_image)
 	if (rc)
 		goto fail;
 
-	for (i = 0; i < MWL8K_TX_QUEUES; i++) {
+	for (i = 0; i < MWL8K_TX_WMM_QUEUES; i++) {
 		rc = mwl8k_conf_tx(hw, i, &priv->wmm_params[i]);
 		if (rc)
 			goto fail;
@@ -4981,7 +4983,7 @@ static int mwl8k_firmware_load_success(struct mwl8k_priv *priv)
 
 	hw->channel_change_time = 10;
 
-	hw->queues = MWL8K_TX_QUEUES;
+	hw->queues = MWL8K_TX_WMM_QUEUES;
 
 	/* Set rssi values to dBm */
 	hw->flags |= IEEE80211_HW_SIGNAL_DBM | IEEE80211_HW_HAS_RATE_CONTROL;
@@ -5037,7 +5039,7 @@ static int mwl8k_firmware_load_success(struct mwl8k_priv *priv)
 	return 0;
 
 err_unprobe_hw:
-	for (i = 0; i < MWL8K_TX_QUEUES; i++)
+	for (i = 0; i < mwl8k_tx_queues(priv); i++)
 		mwl8k_txq_deinit(hw, i);
 	mwl8k_rxq_deinit(hw, 0);
 
@@ -5196,10 +5198,10 @@ static void __devexit mwl8k_remove(struct pci_dev *pdev)
 	mwl8k_hw_reset(priv);
 
 	/* Return all skbs to mac80211 */
-	for (i = 0; i < MWL8K_TX_QUEUES; i++)
+	for (i = 0; i < mwl8k_tx_queues(priv); i++)
 		mwl8k_txq_reclaim(hw, i, INT_MAX, 1);
 
-	for (i = 0; i < MWL8K_TX_QUEUES; i++)
+	for (i = 0; i < mwl8k_tx_queues(priv); i++)
 		mwl8k_txq_deinit(hw, i);
 
 	mwl8k_rxq_deinit(hw, 0);
-- 
1.7.1.1

