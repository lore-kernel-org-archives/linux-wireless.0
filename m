Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14451 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105AbYEOF41 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2008 01:56:27 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 14/26] iwlwifi: refactor ieee80211_get_qos_ctrl
Date: Thu, 15 May 2008 13:54:06 +0800
Message-Id: <1210830858-3410-15-git-send-email-yi.zhu@intel.com> (sfid-20080515_081615_175030_81F102F0)
In-Reply-To: <1210830858-3410-14-git-send-email-yi.zhu@intel.com>
References: <1210830858-3410-1-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-2-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-3-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-4-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-5-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-6-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-7-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-8-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-9-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-10-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-11-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-12-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-13-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-14-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch refactors ieee80211_get_qos_ctrl function and its usage
in iwlwifi drivers. Function is moved as inline into iwl-helpers.h.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c  |   17 +++++----
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 -
 drivers/net/wireless/iwlwifi/iwl-helpers.h  |   19 ++++++++++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   35 +++++++-----------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   51 +++++++++++---------------
 5 files changed, 63 insertions(+), 60 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index ce70f2b..071c7b6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -282,14 +282,20 @@ static void rs_tl_rm_old_stats(struct iwl4965_traffic_load *tl, u32 curr_time)
  *	increment traffic load value for tid and also remove
  *	any old values if passed the certain time period
  */
-static void rs_tl_add_packet(struct iwl4965_lq_sta *lq_data, u8 tid)
+static void rs_tl_add_packet(struct iwl4965_lq_sta *lq_data,
+			     struct ieee80211_hdr *hdr)
 {
 	u32 curr_time = jiffies_to_msecs(jiffies);
 	u32 time_diff;
 	s32 index;
 	struct iwl4965_traffic_load *tl = NULL;
+	u16 fc = le16_to_cpu(hdr->frame_control);
+	u8 tid;
 
-	if (tid >= TID_MAX_LOAD_COUNT)
+	if (ieee80211_is_qos_data(fc)) {
+		u8 *qc = ieee80211_get_qos_ctrl(hdr, ieee80211_get_hdrlen(fc));
+		tid = qc[0] & 0xf;
+	} else
 		return;
 
 	tl = &lq_data->load[tid];
@@ -1670,7 +1676,6 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 	u16 high_low;
 #ifdef CONFIG_IWL4965_HT
 	u8 tid = MAX_TID_COUNT;
-	__le16 *qc;
 #endif
 
 	IWL_DEBUG_RATE("rate scale calculate new rate for skb\n");
@@ -1693,11 +1698,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 	lq_sta = (struct iwl4965_lq_sta *)sta->rate_ctrl_priv;
 
 #ifdef CONFIG_IWL4965_HT
-	qc = ieee80211_get_qos_ctrl(hdr);
-	if (qc) {
-		tid = (u8)(le16_to_cpu(*qc) & 0xf);
-		rs_tl_add_packet(lq_sta, tid);
-	}
+	rs_tl_add_packet(lq_sta, hdr);
 #endif
 	/*
 	 * Select rate-scale / modulation-mode table to work with in
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index ddb950e..7bd99f9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -650,7 +650,6 @@ extern int iwl4965_calc_sig_qual(int rssi_dbm, int noise_dbm);
 extern unsigned int iwl4965_fill_beacon_frame(struct iwl_priv *priv,
 					struct ieee80211_hdr *hdr,
 					const u8 *dest, int left);
-extern __le16 *ieee80211_get_qos_ctrl(struct ieee80211_hdr *hdr);
 extern void iwl4965_update_chain_flags(struct iwl_priv *priv);
 int iwl4965_set_pwr_src(struct iwl_priv *priv, enum iwl_pwr_src src);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-helpers.h b/drivers/net/wireless/iwlwifi/iwl-helpers.h
index a443472..e4c3f84 100644
--- a/drivers/net/wireless/iwlwifi/iwl-helpers.h
+++ b/drivers/net/wireless/iwlwifi/iwl-helpers.h
@@ -235,6 +235,25 @@ static inline int ieee80211_is_reassoc_response(u16 fc)
 	       ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_REASSOC_RESP);
 }
 
+static inline int ieee80211_is_qos_data(u16 fc)
+{
+	return ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA) &&
+	       ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_QOS_DATA);
+}
+/**
+ * ieee80211_get_qos_ctrl - get pointer to the QoS control field
+ *
+ * This function returns the pointer to 802.11 header QoS field (2 bytes)
+ * This function doesn't check whether hdr is a QoS hdr, use with care
+ * @hdr: struct ieee80211_hdr *hdr
+ * @hdr_len: header length
+ */
+
+static inline u8 *ieee80211_get_qos_ctrl(struct ieee80211_hdr *hdr, int hdr_len)
+{
+	return  ((u8 *) hdr + hdr_len - QOS_CONTROL_LEN);
+}
+
 static inline int iwl_check_bits(unsigned long field, unsigned long mask)
 {
 	return ((field & mask) == mask) ? 1 : 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index c1234ff..b8fb8d8 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -102,16 +102,6 @@ MODULE_VERSION(DRV_VERSION);
 MODULE_AUTHOR(DRV_COPYRIGHT);
 MODULE_LICENSE("GPL");
 
-static __le16 *ieee80211_get_qos_ctrl(struct ieee80211_hdr *hdr)
-{
-	u16 fc = le16_to_cpu(hdr->frame_control);
-	int hdr_len = ieee80211_get_hdrlen(fc);
-
-	if ((fc & 0x00cc) == (IEEE80211_STYPE_QOS_DATA | IEEE80211_FTYPE_DATA))
-		return (__le16 *) ((u8 *) hdr + hdr_len - QOS_CONTROL_LEN);
-	return NULL;
-}
-
 static const struct ieee80211_supported_band *iwl3945_get_band(
 		struct iwl3945_priv *priv, enum ieee80211_band band)
 {
@@ -2441,7 +2431,6 @@ static void iwl3945_build_tx_cmd_basic(struct iwl3945_priv *priv,
 				  struct ieee80211_hdr *hdr,
 				  int is_unicast, u8 std_id)
 {
-	__le16 *qc;
 	u16 fc = le16_to_cpu(hdr->frame_control);
 	__le32 tx_flags = cmd->cmd.tx.tx_flags;
 
@@ -2462,12 +2451,13 @@ static void iwl3945_build_tx_cmd_basic(struct iwl3945_priv *priv,
 	if (ieee80211_get_morefrag(hdr))
 		tx_flags |= TX_CMD_FLG_MORE_FRAG_MSK;
 
-	qc = ieee80211_get_qos_ctrl(hdr);
-	if (qc) {
-		cmd->cmd.tx.tid_tspec = (u8) (le16_to_cpu(*qc) & 0xf);
+	if (ieee80211_is_qos_data(fc)) {
+		u8 *qc = ieee80211_get_qos_ctrl(hdr, ieee80211_get_hdrlen(fc));
+		cmd->cmd.tx.tid_tspec = qc[0] & 0xf;
 		tx_flags &= ~TX_CMD_FLG_SEQ_CTL_MSK;
-	} else
+	} else {
 		tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
+	}
 
 	if (ctrl->flags & IEEE80211_TXCTL_USE_RTS_CTS) {
 		tx_flags |= TX_CMD_FLG_RTS_MSK;
@@ -2568,13 +2558,15 @@ static int iwl3945_tx_skb(struct iwl3945_priv *priv,
 	dma_addr_t phys_addr;
 	dma_addr_t txcmd_phys;
 	struct iwl3945_cmd *out_cmd = NULL;
-	u16 len, idx, len_org;
-	u8 id, hdr_len, unicast;
+	u16 len, idx, len_org, hdr_len;
+	u8 id;
+	u8 unicast;
 	u8 sta_id;
+	u8 tid = 0;
 	u16 seq_number = 0;
 	u16 fc;
-	__le16 *qc;
 	u8 wait_write_ptr = 0;
+	u8 *qc = NULL;
 	unsigned long flags;
 	int rc;
 
@@ -2632,9 +2624,9 @@ static int iwl3945_tx_skb(struct iwl3945_priv *priv,
 
 	IWL_DEBUG_RATE("station Id %d\n", sta_id);
 
-	qc = ieee80211_get_qos_ctrl(hdr);
-	if (qc) {
-		u8 tid = (u8)(le16_to_cpu(*qc) & 0xf);
+	if (ieee80211_is_qos_data(fc)) {
+		qc = ieee80211_get_qos_ctrl(hdr, hdr_len);
+		tid = qc[0] & 0xf;
 		seq_number = priv->stations[sta_id].tid[tid].seq_number &
 				IEEE80211_SCTL_SEQ;
 		hdr->seq_ctrl = cpu_to_le16(seq_number) |
@@ -2745,7 +2737,6 @@ static int iwl3945_tx_skb(struct iwl3945_priv *priv,
 	if (!ieee80211_get_morefrag(hdr)) {
 		txq->need_update = 1;
 		if (qc) {
-			u8 tid = (u8)(le16_to_cpu(*qc) & 0xf);
 			priv->stations[sta_id].tid[tid].seq_number = seq_number;
 		}
 	} else {
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 6d5b58f..e3f872e 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -89,16 +89,6 @@ MODULE_VERSION(DRV_VERSION);
 MODULE_AUTHOR(DRV_COPYRIGHT);
 MODULE_LICENSE("GPL");
 
-__le16 *ieee80211_get_qos_ctrl(struct ieee80211_hdr *hdr)
-{
-	u16 fc = le16_to_cpu(hdr->frame_control);
-	int hdr_len = ieee80211_get_hdrlen(fc);
-
-	if ((fc & 0x00cc) == (IEEE80211_STYPE_QOS_DATA | IEEE80211_FTYPE_DATA))
-		return (__le16 *) ((u8 *) hdr + hdr_len - QOS_CONTROL_LEN);
-	return NULL;
-}
-
 static const struct ieee80211_supported_band *iwl_get_hw_mode(
 		struct iwl_priv *priv, enum ieee80211_band band)
 {
@@ -1532,7 +1522,6 @@ static void iwl4965_build_tx_cmd_basic(struct iwl_priv *priv,
 				  struct ieee80211_hdr *hdr,
 				  int is_unicast, u8 std_id)
 {
-	__le16 *qc;
 	u16 fc = le16_to_cpu(hdr->frame_control);
 	__le32 tx_flags = cmd->cmd.tx.tx_flags;
 
@@ -1557,12 +1546,13 @@ static void iwl4965_build_tx_cmd_basic(struct iwl_priv *priv,
 	if (ieee80211_get_morefrag(hdr))
 		tx_flags |= TX_CMD_FLG_MORE_FRAG_MSK;
 
-	qc = ieee80211_get_qos_ctrl(hdr);
-	if (qc) {
-		cmd->cmd.tx.tid_tspec = (u8) (le16_to_cpu(*qc) & 0xf);
+	if (ieee80211_is_qos_data(fc)) {
+		u8 *qc = ieee80211_get_qos_ctrl(hdr, ieee80211_get_hdrlen(fc));
+		cmd->cmd.tx.tid_tspec = qc[0] & 0xf;
 		tx_flags &= ~TX_CMD_FLG_SEQ_CTL_MSK;
-	} else
+	} else {
 		tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
+	}
 
 	if (ctrl->flags & IEEE80211_TXCTL_USE_RTS_CTS) {
 		tx_flags |= TX_CMD_FLG_RTS_MSK;
@@ -1614,12 +1604,15 @@ static int iwl4965_tx_skb(struct iwl_priv *priv,
 	dma_addr_t scratch_phys;
 	struct iwl_cmd *out_cmd = NULL;
 	u16 len, idx, len_org;
-	u8 id, hdr_len, unicast;
+	u8 hdr_len;
+	u8 id;
+	u8 unicast;
 	u8 sta_id;
+	u8 tid = 0;
+	u8 wait_write_ptr = 0;
 	u16 seq_number = 0;
 	u16 fc;
-	__le16 *qc;
-	u8 wait_write_ptr = 0;
+	u8 *qc = NULL;
 	unsigned long flags;
 	int rc;
 
@@ -1678,9 +1671,9 @@ static int iwl4965_tx_skb(struct iwl_priv *priv,
 
 	IWL_DEBUG_TX("station Id %d\n", sta_id);
 
-	qc = ieee80211_get_qos_ctrl(hdr);
-	if (qc) {
-		u8 tid = (u8)(le16_to_cpu(*qc) & 0xf);
+	if (ieee80211_is_qos_data(fc)) {
+		qc = ieee80211_get_qos_ctrl(hdr, hdr_len);
+		tid = qc[0] & 0xf;
 		seq_number = priv->stations[sta_id].tid[tid].seq_number &
 				IEEE80211_SCTL_SEQ;
 		hdr->seq_ctrl = cpu_to_le16(seq_number) |
@@ -1795,10 +1788,8 @@ static int iwl4965_tx_skb(struct iwl_priv *priv,
 
 	if (!ieee80211_get_morefrag(hdr)) {
 		txq->need_update = 1;
-		if (qc) {
-			u8 tid = (u8)(le16_to_cpu(*qc) & 0xf);
+		if (qc)
 			priv->stations[sta_id].tid[tid].seq_number = seq_number;
-		}
 	} else {
 		wait_write_ptr = 1;
 		txq->need_update = 0;
@@ -2377,8 +2368,9 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 	u32  status = le32_to_cpu(tx_resp->status);
 #ifdef CONFIG_IWL4965_HT
 	int tid = MAX_TID_COUNT, sta_id = IWL_INVALID_STATION;
+	u16 fc;
 	struct ieee80211_hdr *hdr;
-	__le16 *qc;
+	u8 *qc = NULL;
 #endif
 
 	if ((index >= txq->q.n_bd) || (iwl_queue_used(&txq->q, index) == 0)) {
@@ -2391,10 +2383,11 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 
 #ifdef CONFIG_IWL4965_HT
 	hdr = iwl4965_tx_queue_get_hdr(priv, txq_id, index);
-	qc = ieee80211_get_qos_ctrl(hdr);
-
-	if (qc)
-		tid = le16_to_cpu(*qc) & 0xf;
+	fc = le16_to_cpu(hdr->frame_control);
+	if (ieee80211_is_qos_data(fc)) {
+		qc = ieee80211_get_qos_ctrl(hdr, ieee80211_get_hdrlen(fc));
+		tid = qc[0] & 0xf;
+	}
 
 	sta_id = iwl4965_get_ra_sta_id(priv, hdr);
 	if (txq->sched_retry && unlikely(sta_id == IWL_INVALID_STATION)) {
-- 
1.5.3.6

