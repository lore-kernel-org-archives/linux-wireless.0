Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37228 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161454Ab2COU2H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 16:28:07 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 12/26] iwlwifi: move queue mapping out of transport
Date: Thu, 15 Mar 2012 13:26:52 -0700
Message-Id: <1331843226-29860-13-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120315_212848_987350_30A6A4E1)
In-Reply-To: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The queue mapping is not only dynamic, it
is also dependent on the uCode, as we can
already see today with the dual-mode and
non-dual-mode being different.

Move the queue mapping out of the transport
layer and let the higher layer manage it.
Part of the transport configuration is how
to set up the queues.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c           |    1 -
 drivers/net/wireless/iwlwifi/iwl-2000.c           |    2 -
 drivers/net/wireless/iwlwifi/iwl-5000.c           |    1 -
 drivers/net/wireless/iwlwifi/iwl-6000.c           |    3 -
 drivers/net/wireless/iwlwifi/iwl-agn-hw.h         |    3 -
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c         |  132 +++++++++++--
 drivers/net/wireless/iwlwifi/iwl-agn.c            |  164 +++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-agn.h            |    7 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c        |   11 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h            |   12 +-
 drivers/net/wireless/iwlwifi/iwl-mac80211.c       |    2 +
 drivers/net/wireless/iwlwifi/iwl-op-mode.h        |   17 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h         |    3 -
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |  146 ++------------
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |  201 +++----------------
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |  218 ++++-----------------
 drivers/net/wireless/iwlwifi/iwl-trans.h          |   71 +++----
 17 files changed, 419 insertions(+), 575 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 5b0d888..95c59e3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -157,7 +157,6 @@ static struct iwl_lib_ops iwl1000_lib = {
 
 static const struct iwl_base_params iwl1000_base_params = {
 	.num_of_queues = IWLAGN_NUM_QUEUES,
-	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
 	.max_ll_items = OTP_MAX_LL_ITEMS_1000,
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 5b898db..e1329a1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -171,7 +171,6 @@ static struct iwl_lib_ops iwl2030_lib = {
 static const struct iwl_base_params iwl2000_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
-	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.pll_cfg_val = 0,
 	.max_ll_items = OTP_MAX_LL_ITEMS_2x00,
 	.shadow_ram_support = true,
@@ -190,7 +189,6 @@ static const struct iwl_base_params iwl2000_base_params = {
 static const struct iwl_base_params iwl2030_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
-	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.pll_cfg_val = 0,
 	.max_ll_items = OTP_MAX_LL_ITEMS_2x00,
 	.shadow_ram_support = true,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index a805e97..34bc8dd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -308,7 +308,6 @@ static struct iwl_lib_ops iwl5150_lib = {
 static const struct iwl_base_params iwl5000_base_params = {
 	.eeprom_size = IWLAGN_EEPROM_IMG_SIZE,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
-	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
 	.led_compensation = 51,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 64060cd..7075570 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -269,7 +269,6 @@ static struct iwl_lib_ops iwl6030_lib = {
 static const struct iwl_base_params iwl6000_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
-	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.pll_cfg_val = 0,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
 	.shadow_ram_support = true,
@@ -286,7 +285,6 @@ static const struct iwl_base_params iwl6000_base_params = {
 static const struct iwl_base_params iwl6050_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
-	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.pll_cfg_val = 0,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x50,
 	.shadow_ram_support = true,
@@ -303,7 +301,6 @@ static const struct iwl_base_params iwl6050_base_params = {
 static const struct iwl_base_params iwl6000_g2_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
-	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.pll_cfg_val = 0,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
 	.shadow_ram_support = true,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hw.h b/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
index d0ec0ab..c797ab1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
@@ -103,9 +103,6 @@
 /* EEPROM */
 #define IWLAGN_EEPROM_IMG_SIZE		2048
 
-#define IWLAGN_CMD_FIFO_NUM		7
 #define IWLAGN_NUM_QUEUES		20
-#define IWLAGN_NUM_AMPDU_QUEUES		9
-#define IWLAGN_FIRST_AMPDU_QUEUE	11
 
 #endif /* __iwl_agn_hw_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 453d880..07563a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -40,6 +40,17 @@
 #include "iwl-agn.h"
 #include "iwl-trans.h"
 
+static const u8 tid_to_ac[] = {
+	IEEE80211_AC_BE,
+	IEEE80211_AC_BK,
+	IEEE80211_AC_BK,
+	IEEE80211_AC_BE,
+	IEEE80211_AC_VI,
+	IEEE80211_AC_VI,
+	IEEE80211_AC_VO,
+	IEEE80211_AC_VO,
+};
+
 static void iwlagn_tx_cmd_protection(struct iwl_priv *priv,
 				     struct ieee80211_tx_info *info,
 				     __le16 fc, __le32 *tx_flags)
@@ -293,6 +304,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	u16 len, seq_number = 0;
 	u8 sta_id, tid = IWL_MAX_TID_COUNT;
 	bool is_agg = false;
+	int txq_id;
 
 	if (info->control.vif)
 		ctx = iwl_rxon_ctx_from_vif(info->control.vif);
@@ -435,7 +447,27 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	/* Copy MAC header from skb into command buffer */
 	memcpy(tx_cmd->hdr, hdr, hdr_len);
 
-	if (iwl_trans_tx(trans(priv), skb, dev_cmd, ctx->ctxid, sta_id, tid))
+	if (is_agg)
+		txq_id = priv->tid_data[sta_id][tid].agg.txq_id;
+	else if (info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) {
+		/*
+		 * Send this frame after DTIM -- there's a special queue
+		 * reserved for this for contexts that support AP mode.
+		 */
+		txq_id = ctx->mcast_queue;
+
+		/*
+		 * The microcode will clear the more data
+		 * bit in the last frame it transmits.
+		 */
+		hdr->frame_control |=
+			cpu_to_le16(IEEE80211_FCTL_MOREDATA);
+	} else if (info->flags & IEEE80211_TX_CTL_TX_OFFCHAN)
+		txq_id = IWL_AUX_QUEUE;
+	else
+		txq_id = ctx->ac_to_queue[skb_get_queue_mapping(skb)];
+
+	if (iwl_trans_tx(trans(priv), skb, dev_cmd, txq_id))
 		goto drop_unlock_sta;
 
 	if (ieee80211_is_data_qos(fc) && !ieee80211_is_qos_nullfunc(fc) &&
@@ -464,11 +496,32 @@ drop_unlock_priv:
 	return -1;
 }
 
+static int iwlagn_alloc_agg_txq(struct iwl_priv *priv, int ac)
+{
+	int q;
+
+	for (q = IWLAGN_FIRST_AMPDU_QUEUE;
+	     q < cfg(priv)->base_params->num_of_queues; q++) {
+		if (!test_and_set_bit(q, priv->agg_q_alloc)) {
+			priv->queue_to_ac[q] = ac;
+			return q;
+		}
+	}
+
+	return -ENOSPC;
+}
+
+static void iwlagn_dealloc_agg_txq(struct iwl_priv *priv, int q)
+{
+	clear_bit(q, priv->agg_q_alloc);
+	priv->queue_to_ac[q] = IWL_INVALID_AC;
+}
+
 int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 			struct ieee80211_sta *sta, u16 tid)
 {
 	struct iwl_tid_data *tid_data;
-	int sta_id;
+	int sta_id, txq_id;
 
 	sta_id = iwl_sta_id(sta);
 
@@ -480,6 +533,7 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	spin_lock_bh(&priv->sta_lock);
 
 	tid_data = &priv->tid_data[sta_id][tid];
+	txq_id = priv->tid_data[sta_id][tid].agg.txq_id;
 
 	switch (priv->tid_data[sta_id][tid].agg.state) {
 	case IWL_EMPTYING_HW_QUEUE_ADDBA:
@@ -504,9 +558,13 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	tid_data->agg.ssn = SEQ_TO_SN(tid_data->seq_number);
 
 	/* There are still packets for this RA / TID in the HW */
-	if (tid_data->agg.ssn != tid_data->next_reclaimed) {
+	if (!test_bit(txq_id, priv->agg_q_alloc)) {
+		IWL_DEBUG_TX_QUEUES(priv,
+			"stopping AGG on STA/TID %d/%d but hwq %d not used\n",
+			sta_id, tid, txq_id);
+	} else if (tid_data->agg.ssn != tid_data->next_reclaimed) {
 		IWL_DEBUG_TX_QUEUES(priv, "Can't proceed: ssn %d, "
-				    "next_recl = %d",
+				    "next_recl = %d\n",
 				    tid_data->agg.ssn,
 				    tid_data->next_reclaimed);
 		priv->tid_data[sta_id][tid].agg.state =
@@ -522,7 +580,10 @@ turn_off:
 
 	spin_unlock_bh(&priv->sta_lock);
 
-	iwl_trans_tx_agg_disable(trans(priv), sta_id, tid);
+	if (test_bit(txq_id, priv->agg_q_alloc)) {
+		iwl_trans_tx_agg_disable(trans(priv), txq_id);
+		iwlagn_dealloc_agg_txq(priv, txq_id);
+	}
 
 	ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 
@@ -533,8 +594,7 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 			struct ieee80211_sta *sta, u16 tid, u16 *ssn)
 {
 	struct iwl_tid_data *tid_data;
-	int sta_id;
-	int ret;
+	int sta_id, txq_id, ret;
 
 	IWL_DEBUG_HT(priv, "TX AGG request on ra = %pM tid = %d\n",
 		     sta->addr, tid);
@@ -552,23 +612,25 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 		return -ENXIO;
 	}
 
+	txq_id = iwlagn_alloc_agg_txq(priv, tid_to_ac[tid]);
+	if (txq_id < 0) {
+		IWL_DEBUG_TX_QUEUES(priv,
+			"No free aggregation queue for %pM/%d\n",
+			sta->addr, tid);
+		return txq_id;
+	}
+
 	ret = iwl_sta_tx_modify_enable_tid(priv, sta_id, tid);
 	if (ret)
 		return ret;
 
 	spin_lock_bh(&priv->sta_lock);
-
 	tid_data = &priv->tid_data[sta_id][tid];
 	tid_data->agg.ssn = SEQ_TO_SN(tid_data->seq_number);
+	tid_data->agg.txq_id = txq_id;
 
 	*ssn = tid_data->agg.ssn;
 
-	ret = iwl_trans_tx_agg_alloc(trans(priv), sta_id, tid);
-	if (ret) {
-		spin_unlock_bh(&priv->sta_lock);
-		return ret;
-	}
-
 	if (*ssn == tid_data->next_reclaimed) {
 		IWL_DEBUG_TX_QUEUES(priv, "Can proceed: ssn = next_recl = %d\n",
 				    tid_data->agg.ssn);
@@ -581,7 +643,6 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 				    tid_data->next_reclaimed);
 		tid_data->agg.state = IWL_EMPTYING_HW_QUEUE_ADDBA;
 	}
-
 	spin_unlock_bh(&priv->sta_lock);
 
 	return ret;
@@ -592,15 +653,20 @@ int iwlagn_tx_agg_oper(struct iwl_priv *priv, struct ieee80211_vif *vif,
 {
 	struct iwl_station_priv *sta_priv = (void *) sta->drv_priv;
 	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
+	int q, fifo;
 	u16 ssn;
 
 	buf_size = min_t(int, buf_size, LINK_QUAL_AGG_FRAME_LIMIT_DEF);
 
 	spin_lock_bh(&priv->sta_lock);
 	ssn = priv->tid_data[sta_priv->sta_id][tid].agg.ssn;
+	q = priv->tid_data[sta_priv->sta_id][tid].agg.txq_id;
 	spin_unlock_bh(&priv->sta_lock);
 
-	iwl_trans_tx_agg_setup(trans(priv), ctx->ctxid, sta_priv->sta_id, tid,
+	fifo = ctx->ac_to_fifo[tid_to_ac[tid]];
+
+	iwl_trans_tx_agg_setup(trans(priv), q, fifo,
+			       sta_priv->sta_id, tid,
 			       buf_size, ssn);
 
 	/*
@@ -666,7 +732,9 @@ static void iwlagn_check_ratid_empty(struct iwl_priv *priv, int sta_id, u8 tid)
 			IWL_DEBUG_TX_QUEUES(priv,
 				"Can continue DELBA flow ssn = next_recl ="
 				" %d", tid_data->next_reclaimed);
-			iwl_trans_tx_agg_disable(trans(priv), sta_id, tid);
+			iwl_trans_tx_agg_disable(trans(priv),
+						 tid_data->agg.txq_id);
+			iwlagn_dealloc_agg_txq(priv, tid_data->agg.txq_id);
 			tid_data->agg.state = IWL_AGG_OFF;
 			ieee80211_stop_tx_ba_cb_irqsafe(vif, addr, tid);
 		}
@@ -1005,6 +1073,29 @@ static void iwl_check_abort_status(struct iwl_priv *priv,
 	}
 }
 
+static int iwl_reclaim(struct iwl_priv *priv, int sta_id, int tid,
+		       int txq_id, int ssn, struct sk_buff_head *skbs)
+{
+	if (unlikely(txq_id >= IWLAGN_FIRST_AMPDU_QUEUE &&
+		     tid != IWL_TID_NON_QOS &&
+		     txq_id != priv->tid_data[sta_id][tid].agg.txq_id)) {
+		/*
+		 * FIXME: this is a uCode bug which need to be addressed,
+		 * log the information and return for now.
+		 * Since it is can possibly happen very often and in order
+		 * not to fill the syslog, don't use IWL_ERR or IWL_WARN
+		 */
+		IWL_DEBUG_TX_QUEUES(priv,
+			"Bad queue mapping txq_id=%d, agg_txq[sta:%d,tid:%d]=%d\n",
+			txq_id, sta_id, tid,
+			priv->tid_data[sta_id][tid].agg.txq_id);
+		return 1;
+	}
+
+	iwl_trans_reclaim(trans(priv), txq_id, ssn, skbs);
+	return 0;
+}
+
 int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 			       struct iwl_device_cmd *cmd)
 {
@@ -1064,8 +1155,7 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 		}
 
 		/*we can free until ssn % q.n_bd not inclusive */
-		WARN_ON(iwl_trans_reclaim(trans(priv), sta_id, tid,
-					  txq_id, ssn, &skbs));
+		WARN_ON(iwl_reclaim(priv, sta_id, tid, txq_id, ssn, &skbs));
 		iwlagn_check_ratid_empty(priv, sta_id, tid);
 		freed = 0;
 
@@ -1183,8 +1273,8 @@ int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 	/* Release all TFDs before the SSN, i.e. all TFDs in front of
 	 * block-ack window (we assume that they've been successfully
 	 * transmitted ... if not, it's too late anyway). */
-	if (iwl_trans_reclaim(trans(priv), sta_id, tid, scd_flow,
-			      ba_resp_scd_ssn, &reclaimed_skbs)) {
+	if (iwl_reclaim(priv, sta_id, tid, scd_flow,
+			ba_resp_scd_ssn, &reclaimed_skbs)) {
 		spin_unlock(&priv->sta_lock);
 		return 0;
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index e7da3a5..c9079af 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -488,6 +488,93 @@ static void iwl_bg_tx_flush(struct work_struct *work)
 	iwlagn_dev_txfifo_flush(priv, IWL_DROP_ALL);
 }
 
+/*
+ * queue/FIFO/AC mapping definitions
+ */
+
+#define IWL_TX_FIFO_BK		0	/* shared */
+#define IWL_TX_FIFO_BE		1
+#define IWL_TX_FIFO_VI		2	/* shared */
+#define IWL_TX_FIFO_VO		3
+#define IWL_TX_FIFO_BK_IPAN	IWL_TX_FIFO_BK
+#define IWL_TX_FIFO_BE_IPAN	4
+#define IWL_TX_FIFO_VI_IPAN	IWL_TX_FIFO_VI
+#define IWL_TX_FIFO_VO_IPAN	5
+/* re-uses the VO FIFO, uCode will properly flush/schedule */
+#define IWL_TX_FIFO_AUX		5
+#define IWL_TX_FIFO_UNUSED	-1
+
+#define IWLAGN_CMD_FIFO_NUM	7
+
+/*
+ * This queue number is required for proper operation
+ * because the ucode will stop/start the scheduler as
+ * required.
+ */
+#define IWL_IPAN_MCAST_QUEUE	8
+
+static const u8 iwlagn_default_queue_to_tx_fifo[] = {
+	IWL_TX_FIFO_VO,
+	IWL_TX_FIFO_VI,
+	IWL_TX_FIFO_BE,
+	IWL_TX_FIFO_BK,
+	IWLAGN_CMD_FIFO_NUM,
+};
+
+static const u8 iwlagn_ipan_queue_to_tx_fifo[] = {
+	IWL_TX_FIFO_VO,
+	IWL_TX_FIFO_VI,
+	IWL_TX_FIFO_BE,
+	IWL_TX_FIFO_BK,
+	IWL_TX_FIFO_BK_IPAN,
+	IWL_TX_FIFO_BE_IPAN,
+	IWL_TX_FIFO_VI_IPAN,
+	IWL_TX_FIFO_VO_IPAN,
+	IWL_TX_FIFO_BE_IPAN,
+	IWLAGN_CMD_FIFO_NUM,
+	IWL_TX_FIFO_AUX,
+};
+
+static const u8 iwlagn_bss_ac_to_fifo[] = {
+	IWL_TX_FIFO_VO,
+	IWL_TX_FIFO_VI,
+	IWL_TX_FIFO_BE,
+	IWL_TX_FIFO_BK,
+};
+
+static const u8 iwlagn_bss_ac_to_queue[] = {
+	0, 1, 2, 3,
+};
+
+static const u8 iwlagn_pan_ac_to_fifo[] = {
+	IWL_TX_FIFO_VO_IPAN,
+	IWL_TX_FIFO_VI_IPAN,
+	IWL_TX_FIFO_BE_IPAN,
+	IWL_TX_FIFO_BK_IPAN,
+};
+
+static const u8 iwlagn_pan_ac_to_queue[] = {
+	7, 6, 5, 4,
+};
+
+static const u8 iwlagn_bss_queue_to_ac[] = {
+	IEEE80211_AC_VO,
+	IEEE80211_AC_VI,
+	IEEE80211_AC_BE,
+	IEEE80211_AC_BK,
+};
+
+static const u8 iwlagn_pan_queue_to_ac[] = {
+	IEEE80211_AC_VO,
+	IEEE80211_AC_VI,
+	IEEE80211_AC_BE,
+	IEEE80211_AC_BK,
+	IEEE80211_AC_BK,
+	IEEE80211_AC_BE,
+	IEEE80211_AC_VI,
+	IEEE80211_AC_VO,
+};
+
 static void iwl_init_context(struct iwl_priv *priv, u32 ucode_flags)
 {
 	int i;
@@ -520,6 +607,10 @@ static void iwl_init_context(struct iwl_priv *priv, u32 ucode_flags)
 	priv->contexts[IWL_RXON_CTX_BSS].ibss_devtype = RXON_DEV_TYPE_IBSS;
 	priv->contexts[IWL_RXON_CTX_BSS].station_devtype = RXON_DEV_TYPE_ESS;
 	priv->contexts[IWL_RXON_CTX_BSS].unused_devtype = RXON_DEV_TYPE_ESS;
+	memcpy(priv->contexts[IWL_RXON_CTX_BSS].ac_to_queue,
+	       iwlagn_bss_ac_to_queue, sizeof(iwlagn_bss_ac_to_queue));
+	memcpy(priv->contexts[IWL_RXON_CTX_BSS].ac_to_fifo,
+	       iwlagn_bss_ac_to_fifo, sizeof(iwlagn_bss_ac_to_fifo));
 
 	priv->contexts[IWL_RXON_CTX_PAN].rxon_cmd = REPLY_WIPAN_RXON;
 	priv->contexts[IWL_RXON_CTX_PAN].rxon_timing_cmd =
@@ -542,6 +633,11 @@ static void iwl_init_context(struct iwl_priv *priv, u32 ucode_flags)
 	priv->contexts[IWL_RXON_CTX_PAN].ap_devtype = RXON_DEV_TYPE_CP;
 	priv->contexts[IWL_RXON_CTX_PAN].station_devtype = RXON_DEV_TYPE_2STA;
 	priv->contexts[IWL_RXON_CTX_PAN].unused_devtype = RXON_DEV_TYPE_P2P;
+	memcpy(priv->contexts[IWL_RXON_CTX_PAN].ac_to_queue,
+	       iwlagn_pan_ac_to_queue, sizeof(iwlagn_pan_ac_to_queue));
+	memcpy(priv->contexts[IWL_RXON_CTX_PAN].ac_to_fifo,
+	       iwlagn_pan_ac_to_fifo, sizeof(iwlagn_pan_ac_to_fifo));
+	priv->contexts[IWL_RXON_CTX_PAN].mcast_queue = IWL_IPAN_MCAST_QUEUE;
 
 	BUILD_BUG_ON(NUM_IWL_RXON_CTX != 2);
 }
@@ -869,6 +965,7 @@ void iwlagn_prepare_restart(struct iwl_priv *priv)
 	u8 bt_load;
 	u8 bt_status;
 	bool bt_is_sco;
+	int i;
 
 	lockdep_assert_held(&priv->mutex);
 
@@ -898,6 +995,15 @@ void iwlagn_prepare_restart(struct iwl_priv *priv)
 	priv->bt_traffic_load = bt_load;
 	priv->bt_status = bt_status;
 	priv->bt_is_sco = bt_is_sco;
+
+	/* reset all queues */
+	for (i = 0; i < IEEE80211_NUM_ACS; i++)
+		atomic_set(&priv->ac_stop_count[i], 0);
+
+	for (i = IWLAGN_FIRST_AMPDU_QUEUE; i < IWL_MAX_HW_QUEUES; i++)
+		priv->queue_to_ac[i] = IWL_INVALID_AC;
+
+	memset(priv->agg_q_alloc, 0, sizeof(priv->agg_q_alloc));
 }
 
 static void iwl_bg_restart(struct work_struct *data)
@@ -1130,8 +1236,6 @@ static void iwl_set_hw_params(struct iwl_priv *priv)
 	if (iwlagn_mod_params.disable_11n & IWL_DISABLE_HT_ALL)
 		hw_params(priv).sku &= ~EEPROM_SKU_CAP_11N_ENABLE;
 
-	hw_params(priv).num_ampdu_queues =
-		cfg(priv)->base_params->num_of_ampdu_queues;
 	hw_params(priv).wd_timeout = cfg(priv)->base_params->wd_timeout;
 
 	/* Device-specific setup */
@@ -1192,6 +1296,9 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 		STATISTICS_NOTIFICATION,
 		REPLY_TX,
 	};
+	const u8 *q_to_ac;
+	int n_q_to_ac;
+	int i;
 
 	/************************
 	 * 1. Allocating HW data
@@ -1228,9 +1335,19 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	if (ucode_flags & IWL_UCODE_TLV_FLAGS_PAN) {
 		priv->sta_key_max_num = STA_KEY_MAX_NUM_PAN;
 		trans_cfg.cmd_queue = IWL_IPAN_CMD_QUEUE_NUM;
+		trans_cfg.queue_to_fifo = iwlagn_ipan_queue_to_tx_fifo;
+		trans_cfg.n_queue_to_fifo =
+			ARRAY_SIZE(iwlagn_ipan_queue_to_tx_fifo);
+		q_to_ac = iwlagn_pan_queue_to_ac;
+		n_q_to_ac = ARRAY_SIZE(iwlagn_pan_queue_to_ac);
 	} else {
 		priv->sta_key_max_num = STA_KEY_MAX_NUM;
 		trans_cfg.cmd_queue = IWL_DEFAULT_CMD_QUEUE_NUM;
+		trans_cfg.queue_to_fifo = iwlagn_default_queue_to_tx_fifo;
+		trans_cfg.n_queue_to_fifo =
+			ARRAY_SIZE(iwlagn_default_queue_to_tx_fifo);
+		q_to_ac = iwlagn_bss_queue_to_ac;
+		n_q_to_ac = ARRAY_SIZE(iwlagn_bss_queue_to_ac);
 	}
 
 	/* Configure transport layer */
@@ -1319,6 +1436,11 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 		ucode_flags &= ~IWL_UCODE_TLV_FLAGS_P2P;
 		priv->sta_key_max_num = STA_KEY_MAX_NUM;
 		trans_cfg.cmd_queue = IWL_DEFAULT_CMD_QUEUE_NUM;
+		trans_cfg.queue_to_fifo = iwlagn_default_queue_to_tx_fifo;
+		trans_cfg.n_queue_to_fifo =
+			ARRAY_SIZE(iwlagn_default_queue_to_tx_fifo);
+		q_to_ac = iwlagn_bss_queue_to_ac;
+		n_q_to_ac = ARRAY_SIZE(iwlagn_bss_queue_to_ac);
 
 		/* Configure transport layer again*/
 		iwl_trans_configure(trans(priv), &trans_cfg);
@@ -1327,6 +1449,18 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	/*******************
 	 * 5. Setup priv
 	 *******************/
+	for (i = 0; i < IEEE80211_NUM_ACS; i++)
+		atomic_set(&priv->ac_stop_count[i], 0);
+
+	for (i = 0; i < IWL_MAX_HW_QUEUES; i++) {
+		if (i < n_q_to_ac)
+			priv->queue_to_ac[i] = q_to_ac[i];
+		else
+			priv->queue_to_ac[i] = IWL_INVALID_AC;
+	}
+
+	WARN_ON(trans_cfg.queue_to_fifo[trans_cfg.cmd_queue] !=
+						IWLAGN_CMD_FIFO_NUM);
 
 	if (iwl_init_drv(priv))
 		goto out_free_eeprom;
@@ -1439,17 +1573,39 @@ static void iwl_nic_config(struct iwl_op_mode *op_mode)
 	cfg(priv)->lib->nic_config(priv);
 }
 
-static void iwl_stop_sw_queue(struct iwl_op_mode *op_mode, u8 ac)
+static void iwl_stop_sw_queue(struct iwl_op_mode *op_mode, int queue)
 {
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
+	int ac = priv->queue_to_ac[queue];
+
+	if (WARN_ON_ONCE(ac == IWL_INVALID_AC))
+		return;
+
+	if (atomic_inc_return(&priv->ac_stop_count[ac]) > 1) {
+		IWL_DEBUG_TX_QUEUES(priv,
+			"queue %d (AC %d) already stopped\n",
+			queue, ac);
+		return;
+	}
 
 	set_bit(ac, &priv->transport_queue_stop);
 	ieee80211_stop_queue(priv->hw, ac);
 }
 
-static void iwl_wake_sw_queue(struct iwl_op_mode *op_mode, u8 ac)
+static void iwl_wake_sw_queue(struct iwl_op_mode *op_mode, int queue)
 {
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
+	int ac = priv->queue_to_ac[queue];
+
+	if (WARN_ON_ONCE(ac == IWL_INVALID_AC))
+		return;
+
+	if (atomic_dec_return(&priv->ac_stop_count[ac]) > 0) {
+		IWL_DEBUG_TX_QUEUES(priv,
+			"queue %d (AC %d) already awake\n",
+			queue, ac);
+		return;
+	}
 
 	clear_bit(ac, &priv->transport_queue_stop);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 2dfa564..436611c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -65,6 +65,13 @@
 
 #include "iwl-dev.h"
 
+/* The first 11 queues (0-10) are used otherwise */
+#define IWLAGN_FIRST_AMPDU_QUEUE	11
+
+/* AUX (TX during scan dwell) queue */
+#define IWL_AUX_QUEUE		10
+
+
 struct iwl_ucode_capabilities;
 
 extern struct ieee80211_ops iwlagn_hw_ops;
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index b7b1c04..bc0bed8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -375,14 +375,19 @@ static ssize_t iwl_dbgfs_stations_read(struct file *file, char __user *user_buf,
 				 i, station->sta.sta.addr,
 				 station->sta.station_flags_msk);
 		pos += scnprintf(buf + pos, bufsz - pos,
-				"TID\tseq_num\trate_n_flags\n");
+				"TID seqno  next_rclmd "
+				"rate_n_flags state txq\n");
 
 		for (j = 0; j < IWL_MAX_TID_COUNT; j++) {
 			tid_data = &priv->tid_data[i][j];
 			pos += scnprintf(buf + pos, bufsz - pos,
-				"%d:\t%#x\t%#x",
+				"%d:  0x%.4x 0x%.4x     0x%.8x   "
+				"%d     %.2d",
 				j, tid_data->seq_number,
-				tid_data->agg.rate_n_flags);
+				tid_data->next_reclaimed,
+				tid_data->agg.rate_n_flags,
+				tid_data->agg.state,
+				tid_data->agg.txq_id);
 
 			if (tid_data->agg.wait_for_ba)
 				pos += scnprintf(buf + pos, bufsz - pos,
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 16956b7..297508d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -220,8 +220,7 @@ enum iwl_agg_state {
  *	Tx response (REPLY_TX), and the block ack notification
  *	(REPLY_COMPRESSED_BA).
  * @state: state of the BA agreement establishment / tear down.
- * @txq_id: Tx queue used by the BA session - used by the transport layer.
- *	Needed by the upper layer for debugfs only.
+ * @txq_id: Tx queue used by the BA session
  * @ssn: the first packet to be sent in AGG HW queue in Tx AGG start flow, or
  *	the first packet to be sent in legacy HW queue in Tx AGG stop flow.
  *	Basically when next_reclaimed reaches ssn, we can tell mac80211 that
@@ -623,6 +622,10 @@ struct iwl_force_reset {
 struct iwl_rxon_context {
 	struct ieee80211_vif *vif;
 
+	u8 mcast_queue;
+	u8 ac_to_queue[IEEE80211_NUM_ACS];
+	u8 ac_to_fifo[IEEE80211_NUM_ACS];
+
 	/*
 	 * We could use the vif to indicate active, but we
 	 * also need it to be active during disabling when
@@ -720,6 +723,11 @@ struct iwl_priv {
 
 	unsigned long transport_queue_stop;
 	bool passive_no_rx;
+#define IWL_INVALID_AC	0xff
+	u8 queue_to_ac[IWL_MAX_HW_QUEUES];
+	atomic_t ac_stop_count[IEEE80211_NUM_ACS];
+
+	unsigned long agg_q_alloc[BITS_TO_LONGS(IWL_MAX_HW_QUEUES)];
 
 	/* ieee device used by generic ieee processing code */
 	struct ieee80211_hw *hw;
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index d2be4b6..1bd021a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -654,6 +654,8 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 		ret = iwl_sta_rx_agg_stop(priv, sta, tid);
 		break;
 	case IEEE80211_AMPDU_TX_START:
+		if (!trans(priv)->ops->tx_agg_setup)
+			break;
 		if (iwlagn_mod_params.disable_11n & IWL_DISABLE_HT_TXAGG)
 			break;
 		IWL_DEBUG_HT(priv, "start Tx\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-op-mode.h b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
index 6ea4163..b1fd251 100644
--- a/drivers/net/wireless/iwlwifi/iwl-op-mode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
@@ -111,10 +111,10 @@ struct iwl_fw;
  * @rx: Rx notification to the op_mode. rxb is the Rx buffer itself. Cmd is the
  *	HCMD the this Rx responds to.
  *	Must be atomic.
- * @queue_full: notifies that a HW queue is full. Ac is the ac of the queue
+ * @queue_full: notifies that a HW queue is full.
  *	Must be atomic
  * @queue_not_full: notifies that a HW queue is not full any more.
- *	Ac is the ac of the queue. Must be atomic
+ *	Must be atomic
  * @hw_rf_kill:notifies of a change in the HW rf kill switch. True means that
  *	the radio is killed. Must be atomic.
  * @free_skb: allows the transport layer to free skbs that haven't been
@@ -132,8 +132,8 @@ struct iwl_op_mode_ops {
 	void (*stop)(struct iwl_op_mode *op_mode);
 	int (*rx)(struct iwl_op_mode *op_mode, struct iwl_rx_cmd_buffer *rxb,
 		  struct iwl_device_cmd *cmd);
-	void (*queue_full)(struct iwl_op_mode *op_mode, u8 ac);
-	void (*queue_not_full)(struct iwl_op_mode *op_mode, u8 ac);
+	void (*queue_full)(struct iwl_op_mode *op_mode, int queue);
+	void (*queue_not_full)(struct iwl_op_mode *op_mode, int queue);
 	void (*hw_rf_kill)(struct iwl_op_mode *op_mode, bool state);
 	void (*free_skb)(struct iwl_op_mode *op_mode, struct sk_buff *skb);
 	void (*nic_error)(struct iwl_op_mode *op_mode);
@@ -169,15 +169,16 @@ static inline int iwl_op_mode_rx(struct iwl_op_mode *op_mode,
 	return op_mode->ops->rx(op_mode, rxb, cmd);
 }
 
-static inline void iwl_op_mode_queue_full(struct iwl_op_mode *op_mode, u8 ac)
+static inline void iwl_op_mode_queue_full(struct iwl_op_mode *op_mode,
+					  int queue)
 {
-	op_mode->ops->queue_full(op_mode, ac);
+	op_mode->ops->queue_full(op_mode, queue);
 }
 
 static inline void iwl_op_mode_queue_not_full(struct iwl_op_mode *op_mode,
-					      u8 ac)
+					      int queue)
 {
-	op_mode->ops->queue_not_full(op_mode, ac);
+	op_mode->ops->queue_not_full(op_mode, queue);
 }
 
 static inline void iwl_op_mode_hw_rf_kill(struct iwl_op_mode *op_mode,
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index f53feb8..e4f619c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -160,7 +160,6 @@ struct iwl_mod_params {
  *
  * Holds the module parameters
  *
- * @num_ampdu_queues: num of ampdu queues
  * @tx_chains_num: Number of TX chains
  * @rx_chains_num: Number of RX chains
  * @valid_tx_ant: usable antennas for TX
@@ -176,7 +175,6 @@ struct iwl_mod_params {
  * @use_rts_for_aggregation: use rts/cts protection for HT traffic
  */
 struct iwl_hw_params {
-	u8  num_ampdu_queues;
 	u8  tx_chains_num;
 	u8  rx_chains_num;
 	u8  valid_tx_ant;
@@ -230,7 +228,6 @@ enum iwl_led_mode {
 struct iwl_base_params {
 	int eeprom_size;
 	int num_of_queues;	/* def: HW dependent */
-	int num_of_ampdu_queues;/* def: HW dependent */
 	/* for iwl_apm_init() */
 	u32 pll_cfg_val;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index 1c2fe87..5325ff7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -136,13 +136,6 @@ static inline int iwl_queue_dec_wrap(int index, int n_bd)
 	return --index & (n_bd - 1);
 }
 
-/*
- * This queue number is required for proper operation
- * because the ucode will stop/start the scheduler as
- * required.
- */
-#define IWL_IPAN_MCAST_QUEUE		8
-
 struct iwl_cmd_meta {
 	/* only for SYNC commands, iff the reply skb is wanted */
 	struct iwl_host_cmd *source;
@@ -199,9 +192,6 @@ struct iwl_queue {
  * lock: queue lock
  * @time_stamp: time (in jiffies) of last read_ptr change
  * @need_update: indicates need to update read/write index
- * @sched_retry: indicates queue is high-throughput aggregation (HT AGG) enabled
- * @sta_id: valid if sched_retry is set
- * @tid: valid if sched_retry is set
  *
  * A Tx queue consists of circular buffer of BDs (a.k.a. TFDs, transmit frame
  * descriptors) and required locking structures.
@@ -218,12 +208,7 @@ struct iwl_tx_queue {
 	spinlock_t lock;
 	unsigned long time_stamp;
 	u8 need_update;
-	u8 sched_retry;
 	u8 active;
-	u8 swq_id;
-
-	u16 sta_id;
-	u16 tid;
 };
 
 /**
@@ -236,13 +221,6 @@ struct iwl_tx_queue {
  * @scd_base_addr: scheduler sram base address in SRAM
  * @scd_bc_tbls: pointer to the byte count table of the scheduler
  * @kw: keep warm address
- * @ac_to_fifo: to what fifo is a specifc AC mapped ?
- * @ac_to_queue: to what tx queue  is a specifc AC mapped ?
- * @mcast_queue:
- * @txq: Tx DMA processing queues
- * @txq_ctx_active_msk: what queue is active
- * queue_stopped: tracks what queue is stopped
- * queue_stop_count: tracks what SW queue is stopped
  * @pci_dev: basic pci-network driver stuff
  * @hw_base: pci hardware address support
  * @ucode_write_complete: indicates that the ucode has been copied.
@@ -272,16 +250,9 @@ struct iwl_trans_pcie {
 	struct iwl_dma_ptr scd_bc_tbls;
 	struct iwl_dma_ptr kw;
 
-	const u8 *ac_to_fifo[NUM_IWL_RXON_CTX];
-	const u8 *ac_to_queue[NUM_IWL_RXON_CTX];
-	u8 mcast_queue[NUM_IWL_RXON_CTX];
-	u8 agg_txq[IWLAGN_STATION_COUNT][IWL_MAX_TID_COUNT];
-
 	struct iwl_tx_queue *txq;
-	unsigned long txq_ctx_active_msk;
-#define IWL_MAX_HW_QUEUES	32
+	unsigned long queue_used[BITS_TO_LONGS(IWL_MAX_HW_QUEUES)];
 	unsigned long queue_stopped[BITS_TO_LONGS(IWL_MAX_HW_QUEUES)];
-	atomic_t queue_stop_count[4];
 
 	/* PCI bus related data */
 	struct pci_dev *pci_dev;
@@ -293,6 +264,8 @@ struct iwl_trans_pcie {
 	u8 cmd_queue;
 	u8 n_no_reclaim_cmds;
 	u8 no_reclaim_cmds[MAX_NO_RECLAIM_CMDS];
+	u8 setup_q_to_fifo[IWL_MAX_HW_QUEUES];
+	u8 n_q_to_fifo;
 };
 
 #define IWL_TRANS_GET_PCIE_TRANS(_iwl_trans) \
@@ -331,15 +304,12 @@ void iwl_tx_cmd_complete(struct iwl_trans *trans,
 void iwl_trans_txq_update_byte_cnt_tbl(struct iwl_trans *trans,
 					   struct iwl_tx_queue *txq,
 					   u16 byte_cnt);
-int iwl_trans_pcie_tx_agg_disable(struct iwl_trans *trans,
-				  int sta_id, int tid);
+void iwl_trans_pcie_tx_agg_disable(struct iwl_trans *trans, int queue);
 void iwl_trans_set_wr_ptrs(struct iwl_trans *trans, int txq_id, u32 index);
 void iwl_trans_tx_queue_set_status(struct iwl_trans *trans,
-			     struct iwl_tx_queue *txq,
-			     int tx_fifo_id, int scd_retry);
-int iwl_trans_pcie_tx_agg_alloc(struct iwl_trans *trans, int sta_id, int tid);
-void iwl_trans_pcie_tx_agg_setup(struct iwl_trans *trans,
-				 enum iwl_rxon_context_id ctx,
+				   struct iwl_tx_queue *txq,
+				   int tx_fifo_id, bool active);
+void iwl_trans_pcie_tx_agg_setup(struct iwl_trans *trans, int queue, int fifo,
 				 int sta_id, int tid, int frame_limit, u16 ssn);
 void iwlagn_txq_free_tfd(struct iwl_trans *trans, struct iwl_tx_queue *txq,
 	int index, enum dma_data_direction dma_dir);
@@ -388,91 +358,28 @@ static inline void iwl_enable_rfkill_int(struct iwl_trans *trans)
 	iwl_write32(trans, CSR_INT_MASK, CSR_INT_BIT_RF_KILL);
 }
 
-/*
- * we have 8 bits used like this:
- *
- * 7 6 5 4 3 2 1 0
- * | | | | | | | |
- * | | | | | | +-+-------- AC queue (0-3)
- * | | | | | |
- * | +-+-+-+-+------------ HW queue ID
- * |
- * +---------------------- unused
- */
-static inline void iwl_set_swq_id(struct iwl_tx_queue *txq, u8 ac, u8 hwq)
-{
-	BUG_ON(ac > 3);   /* only have 2 bits */
-	BUG_ON(hwq > 31); /* only use 5 bits */
-
-	txq->swq_id = (hwq << 2) | ac;
-}
-
-static inline u8 iwl_get_queue_ac(struct iwl_tx_queue *txq)
-{
-	return txq->swq_id & 0x3;
-}
-
 static inline void iwl_wake_queue(struct iwl_trans *trans,
 				  struct iwl_tx_queue *txq)
 {
-	u8 queue = txq->swq_id;
-	u8 ac = queue & 3;
-	u8 hwq = (queue >> 2) & 0x1f;
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
-
-	if (test_and_clear_bit(hwq, trans_pcie->queue_stopped)) {
-		if (atomic_dec_return(&trans_pcie->queue_stop_count[ac]) <= 0) {
-			iwl_op_mode_queue_not_full(trans->op_mode, ac);
-			IWL_DEBUG_TX_QUEUES(trans, "Wake hwq %d ac %d",
-					    hwq, ac);
-		} else {
-			IWL_DEBUG_TX_QUEUES(trans,
-				"Don't wake hwq %d ac %d stop count %d",
-				hwq, ac,
-				atomic_read(&trans_pcie->queue_stop_count[ac]));
-		}
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	if (test_and_clear_bit(txq->q.id, trans_pcie->queue_stopped)) {
+		IWL_DEBUG_TX_QUEUES(trans, "Wake hwq %d\n", txq->q.id);
+		iwl_op_mode_queue_not_full(trans->op_mode, txq->q.id);
 	}
 }
 
 static inline void iwl_stop_queue(struct iwl_trans *trans,
 				  struct iwl_tx_queue *txq)
 {
-	u8 queue = txq->swq_id;
-	u8 ac = queue & 3;
-	u8 hwq = (queue >> 2) & 0x1f;
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
-
-	if (!test_and_set_bit(hwq, trans_pcie->queue_stopped)) {
-		if (atomic_inc_return(&trans_pcie->queue_stop_count[ac]) > 0) {
-			iwl_op_mode_queue_full(trans->op_mode, ac);
-			IWL_DEBUG_TX_QUEUES(trans,
-				"Stop hwq %d ac %d stop count %d",
-				hwq, ac,
-				atomic_read(&trans_pcie->queue_stop_count[ac]));
-		} else {
-			IWL_DEBUG_TX_QUEUES(trans,
-				"Don't stop hwq %d ac %d stop count %d",
-				hwq, ac,
-				atomic_read(&trans_pcie->queue_stop_count[ac]));
-		}
-	} else {
-		IWL_DEBUG_TX_QUEUES(trans, "stop hwq %d, but it is stopped",
-				    hwq);
-	}
-}
-
-static inline void iwl_txq_ctx_activate(struct iwl_trans_pcie *trans_pcie,
-					int txq_id)
-{
-	set_bit(txq_id, &trans_pcie->txq_ctx_active_msk);
-}
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
-static inline void iwl_txq_ctx_deactivate(struct iwl_trans_pcie *trans_pcie,
-					  int txq_id)
-{
-	clear_bit(txq_id, &trans_pcie->txq_ctx_active_msk);
+	if (!test_and_set_bit(txq->q.id, trans_pcie->queue_stopped)) {
+		iwl_op_mode_queue_full(trans->op_mode, txq->q.id);
+		IWL_DEBUG_TX_QUEUES(trans, "Stop hwq %d\n", txq->q.id);
+	} else
+		IWL_DEBUG_TX_QUEUES(trans, "hwq %d already stopped\n",
+				    txq->q.id);
 }
 
 static inline int iwl_queue_used(const struct iwl_queue *q, int i)
@@ -487,19 +394,4 @@ static inline u8 get_cmd_index(struct iwl_queue *q, u32 index)
 	return index & (q->n_window - 1);
 }
 
-#define IWL_TX_FIFO_BK		0	/* shared */
-#define IWL_TX_FIFO_BE		1
-#define IWL_TX_FIFO_VI		2	/* shared */
-#define IWL_TX_FIFO_VO		3
-#define IWL_TX_FIFO_BK_IPAN	IWL_TX_FIFO_BK
-#define IWL_TX_FIFO_BE_IPAN	4
-#define IWL_TX_FIFO_VI_IPAN	IWL_TX_FIFO_VI
-#define IWL_TX_FIFO_VO_IPAN	5
-/* re-uses the VO FIFO, uCode will properly flush/schedule */
-#define IWL_TX_FIFO_AUX		5
-#define IWL_TX_FIFO_UNUSED	-1
-
-/* AUX (TX during scan dwell) queue */
-#define IWL_AUX_QUEUE		10
-
 #endif /* __iwl_trans_int_pcie_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index 8b3eb9e..105c093 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -41,43 +41,6 @@
 #define IWL_TX_CRC_SIZE 4
 #define IWL_TX_DELIMITER_SIZE 4
 
-/*
- * mac80211 queues, ACs, hardware queues, FIFOs.
- *
- * Cf. http://wireless.kernel.org/en/developers/Documentation/mac80211/queues
- *
- * Mac80211 uses the following numbers, which we get as from it
- * by way of skb_get_queue_mapping(skb):
- *
- *	VO	0
- *	VI	1
- *	BE	2
- *	BK	3
- *
- *
- * Regular (not A-MPDU) frames are put into hardware queues corresponding
- * to the FIFOs, see comments in iwl-prph.h. Aggregated frames get their
- * own queue per aggregation session (RA/TID combination), such queues are
- * set up to map into FIFOs too, for which we need an AC->FIFO mapping. In
- * order to map frames to the right queue, we also need an AC->hw queue
- * mapping. This is implemented here.
- *
- * Due to the way hw queues are set up (by the hw specific code), the AC->hw
- * queue mapping is the identity mapping.
- */
-
-static const u8 tid_to_ac[] = {
-	IEEE80211_AC_BE,
-	IEEE80211_AC_BK,
-	IEEE80211_AC_BK,
-	IEEE80211_AC_BE,
-	IEEE80211_AC_VI,
-	IEEE80211_AC_VI,
-	IEEE80211_AC_VO,
-	IEEE80211_AC_VO
-};
-
-
 /**
  * iwl_trans_txq_update_byte_cnt_tbl - Set up entry in Tx byte-count array
  */
@@ -455,13 +418,10 @@ void iwl_trans_set_wr_ptrs(struct iwl_trans *trans,
 }
 
 void iwl_trans_tx_queue_set_status(struct iwl_trans *trans,
-					struct iwl_tx_queue *txq,
-					int tx_fifo_id, int scd_retry)
+				   struct iwl_tx_queue *txq,
+				   int tx_fifo_id, bool active)
 {
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int txq_id = txq->q.id;
-	int active =
-		test_bit(txq_id, &trans_pcie->txq_ctx_active_msk) ? 1 : 0;
 
 	iwl_write_prph(trans, SCD_QUEUE_STATUS_BITS(txq_id),
 			(active << SCD_QUEUE_STTS_REG_POS_ACTIVE) |
@@ -469,77 +429,22 @@ void iwl_trans_tx_queue_set_status(struct iwl_trans *trans,
 			(1 << SCD_QUEUE_STTS_REG_POS_WSL) |
 			SCD_QUEUE_STTS_REG_MSK);
 
-	txq->sched_retry = scd_retry;
-
 	if (active)
-		IWL_DEBUG_TX_QUEUES(trans, "Activate %s Queue %d on FIFO %d\n",
-			scd_retry ? "BA" : "AC/CMD", txq_id, tx_fifo_id);
+		IWL_DEBUG_TX_QUEUES(trans, "Activate queue %d on FIFO %d\n",
+				    txq_id, tx_fifo_id);
 	else
-		IWL_DEBUG_TX_QUEUES(trans, "Deactivate %s Queue %d\n",
-			scd_retry ? "BA" : "AC/CMD", txq_id);
+		IWL_DEBUG_TX_QUEUES(trans, "Deactivate queue %d\n", txq_id);
 }
 
-static inline int get_ac_from_tid(u16 tid)
+void iwl_trans_pcie_tx_agg_setup(struct iwl_trans *trans, int txq_id, int fifo,
+				 int sta_id, int tid, int frame_limit, u16 ssn)
 {
-	if (likely(tid < ARRAY_SIZE(tid_to_ac)))
-		return tid_to_ac[tid];
-
-	/* no support for TIDs 8-15 yet */
-	return -EINVAL;
-}
-
-static inline int get_fifo_from_tid(struct iwl_trans_pcie *trans_pcie,
-				    u8 ctx, u16 tid)
-{
-	const u8 *ac_to_fifo = trans_pcie->ac_to_fifo[ctx];
-	if (likely(tid < ARRAY_SIZE(tid_to_ac)))
-		return ac_to_fifo[tid_to_ac[tid]];
-
-	/* no support for TIDs 8-15 yet */
-	return -EINVAL;
-}
-
-static inline bool is_agg_txqid_valid(struct iwl_trans *trans, int txq_id)
-{
-	if (txq_id < IWLAGN_FIRST_AMPDU_QUEUE)
-		return false;
-	return txq_id < (IWLAGN_FIRST_AMPDU_QUEUE +
-		hw_params(trans).num_ampdu_queues);
-}
-
-void iwl_trans_pcie_tx_agg_setup(struct iwl_trans *trans,
-				 enum iwl_rxon_context_id ctx, int sta_id,
-				 int tid, int frame_limit, u16 ssn)
-{
-	int tx_fifo, txq_id;
-	u16 ra_tid;
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	unsigned long flags;
+	u16 ra_tid = BUILD_RAxTID(sta_id, tid);
 
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
-
-	if (WARN_ON(sta_id == IWL_INVALID_STATION))
-		return;
-	if (WARN_ON(tid >= IWL_MAX_TID_COUNT))
-		return;
-
-	tx_fifo = get_fifo_from_tid(trans_pcie, ctx, tid);
-	if (WARN_ON(tx_fifo < 0)) {
-		IWL_ERR(trans, "txq_agg_setup, bad fifo: %d\n", tx_fifo);
-		return;
-	}
-
-	txq_id = trans_pcie->agg_txq[sta_id][tid];
-	if (WARN_ON_ONCE(is_agg_txqid_valid(trans, txq_id) == false)) {
-		IWL_ERR(trans,
-			"queue number out of range: %d, must be %d to %d\n",
-			txq_id, IWLAGN_FIRST_AMPDU_QUEUE,
-			IWLAGN_FIRST_AMPDU_QUEUE +
-			hw_params(trans).num_ampdu_queues - 1);
-		return;
-	}
-
-	ra_tid = BUILD_RAxTID(sta_id, tid);
+	if (test_and_set_bit(txq_id, trans_pcie->queue_used))
+		WARN_ONCE(1, "queue %d already used - expect issues", txq_id);
 
 	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
 
@@ -550,10 +455,10 @@ void iwl_trans_pcie_tx_agg_setup(struct iwl_trans *trans,
 	iwlagn_tx_queue_set_q2ratid(trans, ra_tid, txq_id);
 
 	/* Set this queue as a chain-building queue */
-	iwl_set_bits_prph(trans, SCD_QUEUECHAIN_SEL, (1<<txq_id));
+	iwl_set_bits_prph(trans, SCD_QUEUECHAIN_SEL, BIT(txq_id));
 
 	/* enable aggregations for the queue */
-	iwl_set_bits_prph(trans, SCD_AGGR_SEL, (1<<txq_id));
+	iwl_set_bits_prph(trans, SCD_AGGR_SEL, BIT(txq_id));
 
 	/* Place first TFD at index corresponding to start sequence number.
 	 * Assumes that ssn_idx is valid (!= 0xFFF) */
@@ -563,92 +468,42 @@ void iwl_trans_pcie_tx_agg_setup(struct iwl_trans *trans,
 
 	/* Set up Tx window size and frame limit for this queue */
 	iwl_write_targ_mem(trans, trans_pcie->scd_base_addr +
-			SCD_CONTEXT_QUEUE_OFFSET(txq_id) +
-			sizeof(u32),
-			((frame_limit <<
-			SCD_QUEUE_CTX_REG2_WIN_SIZE_POS) &
-			SCD_QUEUE_CTX_REG2_WIN_SIZE_MSK) |
-			((frame_limit <<
-			SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS) &
-			SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK));
+			SCD_CONTEXT_QUEUE_OFFSET(txq_id) + sizeof(u32),
+			((frame_limit << SCD_QUEUE_CTX_REG2_WIN_SIZE_POS) &
+				SCD_QUEUE_CTX_REG2_WIN_SIZE_MSK) |
+			((frame_limit << SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS) &
+				SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK));
 
 	iwl_set_bits_prph(trans, SCD_INTERRUPT_MASK, (1 << txq_id));
 
 	/* Set up Status area in SRAM, map to Tx DMA/FIFO, activate the queue */
 	iwl_trans_tx_queue_set_status(trans, &trans_pcie->txq[txq_id],
-					tx_fifo, 1);
-
-	trans_pcie->txq[txq_id].sta_id = sta_id;
-	trans_pcie->txq[txq_id].tid = tid;
+				      fifo, true);
 
 	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 }
 
-/*
- * Find first available (lowest unused) Tx Queue, mark it "active".
- * Called only when finding queue for aggregation.
- * Should never return anything < 7, because they should already
- * be in use as EDCA AC (0-3), Command (4), reserved (5, 6)
- */
-static int iwlagn_txq_ctx_activate_free(struct iwl_trans *trans)
+void iwl_trans_pcie_tx_agg_disable(struct iwl_trans *trans, int txq_id)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	int txq_id;
-
-	for (txq_id = 0; txq_id < cfg(trans)->base_params->num_of_queues;
-	     txq_id++)
-		if (!test_and_set_bit(txq_id,
-					&trans_pcie->txq_ctx_active_msk))
-			return txq_id;
-	return -1;
-}
 
-int iwl_trans_pcie_tx_agg_alloc(struct iwl_trans *trans,
-				int sta_id, int tid)
-{
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	int txq_id;
-
-	txq_id = iwlagn_txq_ctx_activate_free(trans);
-	if (txq_id == -1) {
-		IWL_ERR(trans, "No free aggregation queue available\n");
-		return -ENXIO;
-	}
-
-	trans_pcie->agg_txq[sta_id][tid] = txq_id;
-	iwl_set_swq_id(&trans_pcie->txq[txq_id], get_ac_from_tid(tid), txq_id);
-
-	return 0;
-}
-
-int iwl_trans_pcie_tx_agg_disable(struct iwl_trans *trans, int sta_id, int tid)
-{
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	u8 txq_id = trans_pcie->agg_txq[sta_id][tid];
-
-	if (WARN_ON_ONCE(is_agg_txqid_valid(trans, txq_id) == false)) {
-		IWL_ERR(trans,
-			"queue number out of range: %d, must be %d to %d\n",
-			txq_id, IWLAGN_FIRST_AMPDU_QUEUE,
-			IWLAGN_FIRST_AMPDU_QUEUE +
-			hw_params(trans).num_ampdu_queues - 1);
-		return -EINVAL;
+	if (!test_and_clear_bit(txq_id, trans_pcie->queue_used)) {
+		WARN_ONCE(1, "queue %d not used", txq_id);
+		return;
 	}
 
 	iwlagn_tx_queue_stop_scheduler(trans, txq_id);
 
-	iwl_clear_bits_prph(trans, SCD_AGGR_SEL, (1 << txq_id));
+	iwl_clear_bits_prph(trans, SCD_AGGR_SEL, BIT(txq_id));
 
-	trans_pcie->agg_txq[sta_id][tid] = 0;
 	trans_pcie->txq[txq_id].q.read_ptr = 0;
 	trans_pcie->txq[txq_id].q.write_ptr = 0;
-	/* supposes that ssn_idx is valid (!= 0xFFF) */
 	iwl_trans_set_wr_ptrs(trans, txq_id, 0);
 
-	iwl_clear_bits_prph(trans, SCD_INTERRUPT_MASK, (1 << txq_id));
-	iwl_txq_ctx_deactivate(trans_pcie, txq_id);
-	iwl_trans_tx_queue_set_status(trans, &trans_pcie->txq[txq_id], 0, 0);
-	return 0;
+	iwl_clear_bits_prph(trans, SCD_INTERRUPT_MASK, BIT(txq_id));
+
+	iwl_trans_tx_queue_set_status(trans, &trans_pcie->txq[txq_id],
+				      0, false);
 }
 
 /*************** HOST COMMAND QUEUE FUNCTIONS   *****/
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 98cd71f..0a23372 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -369,21 +369,13 @@ error:
 }
 
 static int iwl_trans_txq_init(struct iwl_trans *trans, struct iwl_tx_queue *txq,
-		      int slots_num, u32 txq_id)
+			      int slots_num, u32 txq_id)
 {
 	int ret;
 
 	txq->need_update = 0;
 	memset(txq->meta, 0, sizeof(txq->meta[0]) * slots_num);
 
-	/*
-	 * For the default queues 0-3, set up the swq_id
-	 * already -- all others need to get one later
-	 * (if they need one at all).
-	 */
-	if (txq_id < 4)
-		iwl_set_swq_id(txq, txq_id, txq_id);
-
 	/* TFD_QUEUE_SIZE_MAX must be power-of-two size, otherwise
 	 * iwl_queue_inc_wrap and iwl_queue_dec_wrap are broken. */
 	BUILD_BUG_ON(TFD_QUEUE_SIZE_MAX & (TFD_QUEUE_SIZE_MAX - 1));
@@ -894,59 +886,6 @@ static int iwl_prepare_card_hw(struct iwl_trans *trans)
 	return ret;
 }
 
-#define IWL_AC_UNSET -1
-
-struct queue_to_fifo_ac {
-	s8 fifo, ac;
-};
-
-static const struct queue_to_fifo_ac iwlagn_default_queue_to_tx_fifo[] = {
-	{ IWL_TX_FIFO_VO, IEEE80211_AC_VO, },
-	{ IWL_TX_FIFO_VI, IEEE80211_AC_VI, },
-	{ IWL_TX_FIFO_BE, IEEE80211_AC_BE, },
-	{ IWL_TX_FIFO_BK, IEEE80211_AC_BK, },
-	{ IWLAGN_CMD_FIFO_NUM, IWL_AC_UNSET, },
-	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
-	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
-	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
-	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
-	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
-	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
-};
-
-static const struct queue_to_fifo_ac iwlagn_ipan_queue_to_tx_fifo[] = {
-	{ IWL_TX_FIFO_VO, IEEE80211_AC_VO, },
-	{ IWL_TX_FIFO_VI, IEEE80211_AC_VI, },
-	{ IWL_TX_FIFO_BE, IEEE80211_AC_BE, },
-	{ IWL_TX_FIFO_BK, IEEE80211_AC_BK, },
-	{ IWL_TX_FIFO_BK_IPAN, IEEE80211_AC_BK, },
-	{ IWL_TX_FIFO_BE_IPAN, IEEE80211_AC_BE, },
-	{ IWL_TX_FIFO_VI_IPAN, IEEE80211_AC_VI, },
-	{ IWL_TX_FIFO_VO_IPAN, IEEE80211_AC_VO, },
-	{ IWL_TX_FIFO_BE_IPAN, 2, },
-	{ IWLAGN_CMD_FIFO_NUM, IWL_AC_UNSET, },
-	{ IWL_TX_FIFO_AUX, IWL_AC_UNSET, },
-};
-
-static const u8 iwlagn_bss_ac_to_fifo[] = {
-	IWL_TX_FIFO_VO,
-	IWL_TX_FIFO_VI,
-	IWL_TX_FIFO_BE,
-	IWL_TX_FIFO_BK,
-};
-static const u8 iwlagn_bss_ac_to_queue[] = {
-	0, 1, 2, 3,
-};
-static const u8 iwlagn_pan_ac_to_fifo[] = {
-	IWL_TX_FIFO_VO_IPAN,
-	IWL_TX_FIFO_VI_IPAN,
-	IWL_TX_FIFO_BE_IPAN,
-	IWL_TX_FIFO_BK_IPAN,
-};
-static const u8 iwlagn_pan_ac_to_queue[] = {
-	7, 6, 5, 4,
-};
-
 /*
  * ucode
  */
@@ -1027,19 +966,8 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 				   const struct fw_img *fw)
 {
 	int ret;
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
 	bool hw_rfkill;
 
-	trans_pcie->ac_to_queue[IWL_RXON_CTX_BSS] = iwlagn_bss_ac_to_queue;
-	trans_pcie->ac_to_queue[IWL_RXON_CTX_PAN] = iwlagn_pan_ac_to_queue;
-
-	trans_pcie->ac_to_fifo[IWL_RXON_CTX_BSS] = iwlagn_bss_ac_to_fifo;
-	trans_pcie->ac_to_fifo[IWL_RXON_CTX_PAN] = iwlagn_pan_ac_to_fifo;
-
-	trans_pcie->mcast_queue[IWL_RXON_CTX_BSS] = 0;
-	trans_pcie->mcast_queue[IWL_RXON_CTX_PAN] = IWL_IPAN_MCAST_QUEUE;
-
 	/* This may fail if AMT took ownership of the device */
 	if (iwl_prepare_card_hw(trans)) {
 		IWL_WARN(trans, "Exit HW not ready\n");
@@ -1097,9 +1025,7 @@ static void iwl_trans_txq_set_sched(struct iwl_trans *trans, u32 mask)
 
 static void iwl_tx_start(struct iwl_trans *trans)
 {
-	const struct queue_to_fifo_ac *queue_to_fifo;
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	u32 a;
 	unsigned long flags;
 	int i, chan;
@@ -1165,41 +1091,19 @@ static void iwl_tx_start(struct iwl_trans *trans)
 	/* Activate all Tx DMA/FIFO channels */
 	iwl_trans_txq_set_sched(trans, IWL_MASK(0, 7));
 
-	/* map queues to FIFOs */
-	if (trans->shrd->valid_contexts != BIT(IWL_RXON_CTX_BSS))
-		queue_to_fifo = iwlagn_ipan_queue_to_tx_fifo;
-	else
-		queue_to_fifo = iwlagn_default_queue_to_tx_fifo;
-
 	iwl_trans_set_wr_ptrs(trans, trans_pcie->cmd_queue, 0);
 
-	/* make sure all queue are not stopped */
-	memset(&trans_pcie->queue_stopped[0], 0,
-		sizeof(trans_pcie->queue_stopped));
-	for (i = 0; i < 4; i++)
-		atomic_set(&trans_pcie->queue_stop_count[i], 0);
-
-	/* reset to 0 to enable all the queue first */
-	trans_pcie->txq_ctx_active_msk = 0;
+	/* make sure all queue are not stopped/used */
+	memset(trans_pcie->queue_stopped, 0, sizeof(trans_pcie->queue_stopped));
+	memset(trans_pcie->queue_used, 0, sizeof(trans_pcie->queue_used));
 
-	BUILD_BUG_ON(ARRAY_SIZE(iwlagn_default_queue_to_tx_fifo) <
-						IWLAGN_FIRST_AMPDU_QUEUE);
-	BUILD_BUG_ON(ARRAY_SIZE(iwlagn_ipan_queue_to_tx_fifo) <
-						IWLAGN_FIRST_AMPDU_QUEUE);
+	for (i = 0; i < trans_pcie->n_q_to_fifo; i++) {
+		int fifo = trans_pcie->setup_q_to_fifo[i];
 
-	for (i = 0; i < IWLAGN_FIRST_AMPDU_QUEUE; i++) {
-		int fifo = queue_to_fifo[i].fifo;
-		int ac = queue_to_fifo[i].ac;
+		set_bit(i, trans_pcie->queue_used);
 
-		iwl_txq_ctx_activate(trans_pcie, i);
-
-		if (fifo == IWL_TX_FIFO_UNUSED)
-			continue;
-
-		if (ac != IWL_AC_UNSET)
-			iwl_set_swq_id(&trans_pcie->txq[i], ac, i);
 		iwl_trans_tx_queue_set_status(trans, &trans_pcie->txq[i],
-					      fifo, 0);
+					      fifo, true);
 	}
 
 	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
@@ -1324,70 +1228,32 @@ static void iwl_trans_pcie_wowlan_suspend(struct iwl_trans *trans)
 }
 
 static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
-		struct iwl_device_cmd *dev_cmd, enum iwl_rxon_context_id ctx,
-		u8 sta_id, u8 tid)
+			     struct iwl_device_cmd *dev_cmd, int txq_id)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct iwl_tx_cmd *tx_cmd = (struct iwl_tx_cmd *) dev_cmd->payload;
 	struct iwl_cmd_meta *out_meta;
 	struct iwl_tx_queue *txq;
 	struct iwl_queue *q;
-
 	dma_addr_t phys_addr = 0;
 	dma_addr_t txcmd_phys;
 	dma_addr_t scratch_phys;
 	u16 len, firstlen, secondlen;
 	u8 wait_write_ptr = 0;
-	u8 txq_id;
-	bool is_agg = false;
 	__le16 fc = hdr->frame_control;
 	u8 hdr_len = ieee80211_hdrlen(fc);
 	u16 __maybe_unused wifi_seq;
 
-	/*
-	 * Send this frame after DTIM -- there's a special queue
-	 * reserved for this for contexts that support AP mode.
-	 */
-	if (info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) {
-		txq_id = trans_pcie->mcast_queue[ctx];
-
-		/*
-		 * The microcode will clear the more data
-		 * bit in the last frame it transmits.
-		 */
-		hdr->frame_control |=
-			cpu_to_le16(IEEE80211_FCTL_MOREDATA);
-	} else if (info->flags & IEEE80211_TX_CTL_TX_OFFCHAN)
-		txq_id = IWL_AUX_QUEUE;
-	else
-		txq_id =
-		    trans_pcie->ac_to_queue[ctx][skb_get_queue_mapping(skb)];
-
-	/* aggregation is on for this <sta,tid> */
-	if (info->flags & IEEE80211_TX_CTL_AMPDU) {
-		WARN_ON(tid >= IWL_MAX_TID_COUNT);
-		txq_id = trans_pcie->agg_txq[sta_id][tid];
-		is_agg = true;
-	}
-
 	txq = &trans_pcie->txq[txq_id];
 	q = &txq->q;
 
-	spin_lock(&txq->lock);
+	if (unlikely(!test_bit(txq_id, trans_pcie->queue_used))) {
+		WARN_ON_ONCE(1);
+		return -EINVAL;
+	}
 
-	/* In AGG mode, the index in the ring must correspond to the WiFi
-	 * sequence number. This is a HW requirements to help the SCD to parse
-	 * the BA.
-	 * Check here that the packets are in the right place on the ring.
-	 */
-#ifdef CONFIG_IWLWIFI_DEBUG
-	wifi_seq = SEQ_TO_SN(le16_to_cpu(hdr->seq_ctrl));
-	WARN_ONCE(is_agg && ((wifi_seq & 0xff) != q->write_ptr),
-		  "Q: %d WiFi Seq %d tfdNum %d",
-		  txq_id, wifi_seq, q->write_ptr);
-#endif
+	spin_lock(&txq->lock);
 
 	/* Set up driver data for this TFD */
 	txq->skbs[q->write_ptr] = skb;
@@ -1564,8 +1430,8 @@ static void iwl_trans_pcie_stop_hw(struct iwl_trans *trans)
 	iwl_enable_rfkill_int(trans);
 }
 
-static int iwl_trans_pcie_reclaim(struct iwl_trans *trans, int sta_id, int tid,
-		      int txq_id, int ssn, struct sk_buff_head *skbs)
+static void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
+				   struct sk_buff_head *skbs)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_tx_queue *txq = &trans_pcie->txq[txq_id];
@@ -1577,33 +1443,15 @@ static int iwl_trans_pcie_reclaim(struct iwl_trans *trans, int sta_id, int tid,
 
 	txq->time_stamp = jiffies;
 
-	if (unlikely(txq_id >= IWLAGN_FIRST_AMPDU_QUEUE &&
-		     tid != IWL_TID_NON_QOS &&
-		     txq_id != trans_pcie->agg_txq[sta_id][tid])) {
-		/*
-		 * FIXME: this is a uCode bug which need to be addressed,
-		 * log the information and return for now.
-		 * Since it is can possibly happen very often and in order
-		 * not to fill the syslog, don't use IWL_ERR or IWL_WARN
-		 */
-		IWL_DEBUG_TX_QUEUES(trans, "Bad queue mapping txq_id %d, "
-			"agg_txq[sta_id[tid] %d", txq_id,
-			trans_pcie->agg_txq[sta_id][tid]);
-		spin_unlock(&txq->lock);
-		return 1;
-	}
-
 	if (txq->q.read_ptr != tfd_num) {
-		IWL_DEBUG_TX_REPLY(trans, "[Q %d | AC %d] %d -> %d (%d)\n",
-				txq_id, iwl_get_queue_ac(txq), txq->q.read_ptr,
-				tfd_num, ssn);
+		IWL_DEBUG_TX_REPLY(trans, "[Q %d] %d -> %d (%d)\n",
+				   txq_id, txq->q.read_ptr, tfd_num, ssn);
 		freed = iwl_tx_queue_reclaim(trans, txq_id, tfd_num, skbs);
 		if (iwl_queue_space(&txq->q) > txq->q.low_mark)
 			iwl_wake_queue(trans, txq);
 	}
 
 	spin_unlock(&txq->lock);
-	return 0;
 }
 
 static void iwl_trans_pcie_write8(struct iwl_trans *trans, u32 ofs, u8 val)
@@ -1622,7 +1470,7 @@ static u32 iwl_trans_pcie_read32(struct iwl_trans *trans, u32 ofs)
 }
 
 static void iwl_trans_pcie_configure(struct iwl_trans *trans,
-			      const struct iwl_trans_config *trans_cfg)
+				     const struct iwl_trans_config *trans_cfg)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
@@ -1634,6 +1482,17 @@ static void iwl_trans_pcie_configure(struct iwl_trans *trans,
 	if (trans_pcie->n_no_reclaim_cmds)
 		memcpy(trans_pcie->no_reclaim_cmds, trans_cfg->no_reclaim_cmds,
 		       trans_pcie->n_no_reclaim_cmds * sizeof(u8));
+
+	trans_pcie->n_q_to_fifo = trans_cfg->n_queue_to_fifo;
+
+	if (WARN_ON(trans_pcie->n_q_to_fifo > IWL_MAX_HW_QUEUES))
+		trans_pcie->n_q_to_fifo = IWL_MAX_HW_QUEUES;
+
+	/* at least the command queue must be mapped */
+	WARN_ON(!trans_pcie->n_q_to_fifo);
+
+	memcpy(trans_pcie->setup_q_to_fifo, trans_cfg->queue_to_fifo,
+	       trans_pcie->n_q_to_fifo * sizeof(u8));
 }
 
 static void iwl_trans_pcie_free(struct iwl_trans *trans)
@@ -1957,18 +1816,10 @@ static ssize_t iwl_dbgfs_tx_queue_read(struct file *file,
 		txq = &trans_pcie->txq[cnt];
 		q = &txq->q;
 		pos += scnprintf(buf + pos, bufsz - pos,
-				"hwq %.2d: read=%u write=%u stop=%d"
-				" swq_id=%#.2x (ac %d/hwq %d)\n",
+				"hwq %.2d: read=%u write=%u use=%d stop=%d\n",
 				cnt, q->read_ptr, q->write_ptr,
-				!!test_bit(cnt, trans_pcie->queue_stopped),
-				txq->swq_id, txq->swq_id & 3,
-				(txq->swq_id >> 2) & 0x1f);
-		if (cnt >= 4)
-			continue;
-		/* for the ACs, display the stop count too */
-		pos += scnprintf(buf + pos, bufsz - pos,
-			"        stop-count: %d\n",
-			atomic_read(&trans_pcie->queue_stop_count[cnt]));
+				!!test_bit(cnt, trans_pcie->queue_used),
+				!!test_bit(cnt, trans_pcie->queue_stopped));
 	}
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 	kfree(buf);
@@ -2210,7 +2061,6 @@ const struct iwl_trans_ops trans_ops_pcie = {
 	.reclaim = iwl_trans_pcie_reclaim,
 
 	.tx_agg_disable = iwl_trans_pcie_tx_agg_disable,
-	.tx_agg_alloc = iwl_trans_pcie_tx_agg_alloc,
 	.tx_agg_setup = iwl_trans_pcie_tx_agg_setup,
 
 	.free = iwl_trans_pcie_free,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 57d8ae7..2785308 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -285,11 +285,19 @@ static inline struct page *rxb_steal_page(struct iwl_rx_cmd_buffer *r)
 
 #define MAX_NO_RECLAIM_CMDS	6
 
+/*
+ * Maximum number of HW queues the transport layer
+ * currently supports
+ */
+#define IWL_MAX_HW_QUEUES		32
+
 /**
  * struct iwl_trans_config - transport configuration
  *
  * @op_mode: pointer to the upper layer.
- *	Must be set before any other call.
+ * @queue_to_fifo: queue to FIFO mapping to set up by
+ *	default
+ * @n_queue_to_fifo: number of queues to set up
  * @cmd_queue: the index of the command queue.
  *	Must be set before start_fw.
  * @no_reclaim_cmds: Some devices erroneously don't set the
@@ -300,6 +308,9 @@ static inline struct page *rxb_steal_page(struct iwl_rx_cmd_buffer *r)
  */
 struct iwl_trans_config {
 	struct iwl_op_mode *op_mode;
+	const u8 *queue_to_fifo;
+	u8 n_queue_to_fifo;
+
 	u8 cmd_queue;
 	const u8 *no_reclaim_cmds;
 	int n_no_reclaim_cmds;
@@ -331,8 +342,6 @@ struct iwl_trans_config {
  *	Must be atomic
  * @reclaim: free packet until ssn. Returns a list of freed packets.
  *	Must be atomic
- * @tx_agg_alloc: allocate resources for a TX BA session
- *	Must be atomic
  * @tx_agg_setup: setup a tx queue for AMPDU - will be called once the HW is
  *	ready and a successful ADDBA response has been received.
  *	May sleep
@@ -369,18 +378,13 @@ struct iwl_trans_ops {
 	int (*send_cmd)(struct iwl_trans *trans, struct iwl_host_cmd *cmd);
 
 	int (*tx)(struct iwl_trans *trans, struct sk_buff *skb,
-		struct iwl_device_cmd *dev_cmd, enum iwl_rxon_context_id ctx,
-		u8 sta_id, u8 tid);
-	int (*reclaim)(struct iwl_trans *trans, int sta_id, int tid,
-			int txq_id, int ssn, struct sk_buff_head *skbs);
-
-	int (*tx_agg_disable)(struct iwl_trans *trans,
-			      int sta_id, int tid);
-	int (*tx_agg_alloc)(struct iwl_trans *trans,
-			    int sta_id, int tid);
-	void (*tx_agg_setup)(struct iwl_trans *trans,
-			     enum iwl_rxon_context_id ctx, int sta_id, int tid,
-			     int frame_limit, u16 ssn);
+		  struct iwl_device_cmd *dev_cmd, int queue);
+	void (*reclaim)(struct iwl_trans *trans, int queue, int ssn,
+			struct sk_buff_head *skbs);
+
+	void (*tx_agg_setup)(struct iwl_trans *trans, int queue, int fifo,
+			     int sta_id, int tid, int frame_limit, u16 ssn);
+	void (*tx_agg_disable)(struct iwl_trans *trans, int queue);
 
 	void (*free)(struct iwl_trans *trans);
 
@@ -516,55 +520,42 @@ static inline int iwl_trans_send_cmd(struct iwl_trans *trans,
 }
 
 static inline int iwl_trans_tx(struct iwl_trans *trans, struct sk_buff *skb,
-		struct iwl_device_cmd *dev_cmd, enum iwl_rxon_context_id ctx,
-		u8 sta_id, u8 tid)
-{
-	if (trans->state != IWL_TRANS_FW_ALIVE)
-		IWL_ERR(trans, "%s bad state = %d", __func__, trans->state);
-
-	return trans->ops->tx(trans, skb, dev_cmd, ctx, sta_id, tid);
-}
-
-static inline int iwl_trans_reclaim(struct iwl_trans *trans, int sta_id,
-				 int tid, int txq_id, int ssn,
-				 struct sk_buff_head *skbs)
+			       struct iwl_device_cmd *dev_cmd, int queue)
 {
 	WARN_ONCE(trans->state != IWL_TRANS_FW_ALIVE,
 		  "%s bad state = %d", __func__, trans->state);
 
-	return trans->ops->reclaim(trans, sta_id, tid, txq_id, ssn, skbs);
+	return trans->ops->tx(trans, skb, dev_cmd, queue);
 }
 
-static inline int iwl_trans_tx_agg_disable(struct iwl_trans *trans,
-					    int sta_id, int tid)
+static inline void iwl_trans_reclaim(struct iwl_trans *trans, int queue,
+				     int ssn, struct sk_buff_head *skbs)
 {
 	WARN_ONCE(trans->state != IWL_TRANS_FW_ALIVE,
 		  "%s bad state = %d", __func__, trans->state);
 
-	return trans->ops->tx_agg_disable(trans, sta_id, tid);
+	trans->ops->reclaim(trans, queue, ssn, skbs);
 }
 
-static inline int iwl_trans_tx_agg_alloc(struct iwl_trans *trans,
-					 int sta_id, int tid)
+static inline void iwl_trans_tx_agg_disable(struct iwl_trans *trans, int queue)
 {
 	WARN_ONCE(trans->state != IWL_TRANS_FW_ALIVE,
 		  "%s bad state = %d", __func__, trans->state);
 
-	return trans->ops->tx_agg_alloc(trans, sta_id, tid);
+	trans->ops->tx_agg_disable(trans, queue);
 }
 
-
-static inline void iwl_trans_tx_agg_setup(struct iwl_trans *trans,
-					   enum iwl_rxon_context_id ctx,
-					   int sta_id, int tid,
-					   int frame_limit, u16 ssn)
+static inline void iwl_trans_tx_agg_setup(struct iwl_trans *trans, int queue,
+					  int fifo, int sta_id, int tid,
+					  int frame_limit, u16 ssn)
 {
 	might_sleep();
 
 	WARN_ONCE(trans->state != IWL_TRANS_FW_ALIVE,
 		  "%s bad state = %d", __func__, trans->state);
 
-	trans->ops->tx_agg_setup(trans, ctx, sta_id, tid, frame_limit, ssn);
+	trans->ops->tx_agg_setup(trans, queue, fifo, sta_id, tid,
+				 frame_limit, ssn);
 }
 
 static inline void iwl_trans_free(struct iwl_trans *trans)
-- 
1.7.0.4

