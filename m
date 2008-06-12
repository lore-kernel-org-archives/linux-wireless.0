Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:12449 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbYFLBtv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 21:49:51 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 17/29] iwlwifi: refactor tx aggregation response flow
Date: Thu, 12 Jun 2008 09:47:07 +0800
Message-Id: <1213235239-2954-18-git-send-email-yi.zhu@intel.com> (sfid-20080612_041914_757853_93B1AE14)
In-Reply-To: <1213235239-2954-17-git-send-email-yi.zhu@intel.com>
References: <1213235239-2954-1-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-2-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-3-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-4-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-5-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-6-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-7-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-8-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-9-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-10-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-11-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-12-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-13-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-14-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-15-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-16-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-17-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch refactors tx aggregation respnse flow
and fixes bug revealed by tx_info to cb patch

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   23 ++++++++---------------
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   17 ++++++-----------
 drivers/net/wireless/iwlwifi/iwl-commands.h |   19 ++++---------------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 +-
 4 files changed, 19 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 4d47dd7..3f24e97 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -3204,10 +3204,7 @@ static u16 iwl4965_build_addsta_hcmd(const struct iwl_addsta_cmd *cmd, u8 *data)
 
 static inline u32 iwl4965_get_scd_ssn(struct iwl4965_tx_resp *tx_resp)
 {
-	__le32 *scd_ssn = (__le32 *)((u32 *)&tx_resp->status +
-				tx_resp->frame_count);
-	return le32_to_cpu(*scd_ssn) & MAX_SN;
-
+	return le32_to_cpup(&tx_resp->u.status + tx_resp->frame_count) & MAX_SN;
 }
 
 /**
@@ -3215,15 +3212,14 @@ static inline u32 iwl4965_get_scd_ssn(struct iwl4965_tx_resp *tx_resp)
  */
 static int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 				      struct iwl_ht_agg *agg,
-				      struct iwl4965_tx_resp_agg *tx_resp,
-				      u16 start_idx)
+				      struct iwl4965_tx_resp *tx_resp,
+				      int txq_id, u16 start_idx)
 {
 	u16 status;
-	struct agg_tx_status *frame_status = &tx_resp->status;
+	struct agg_tx_status *frame_status = tx_resp->u.agg_status;
 	struct ieee80211_tx_info *info = NULL;
 	struct ieee80211_hdr *hdr = NULL;
-	int i, sh;
-	int txq_id, idx;
+	int i, sh, idx;
 	u16 seq;
 
 	if (agg->wait_for_ba)
@@ -3238,9 +3234,7 @@ static int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 	if (agg->frame_count == 1) {
 		/* Only one frame was attempted; no block-ack will arrive */
 		status = le16_to_cpu(frame_status[0].status);
-		seq  = le16_to_cpu(frame_status[0].sequence);
-		idx = SEQ_TO_INDEX(seq);
-		txq_id = SEQ_TO_QUEUE(seq);
+		idx = start_idx;
 
 		/* FIXME: code repetition */
 		IWL_DEBUG_TX_REPLY("FrameCnt = %d, StartIdx=%d idx=%d\n",
@@ -3341,7 +3335,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 	struct iwl_tx_queue *txq = &priv->txq[txq_id];
 	struct ieee80211_tx_info *info;
 	struct iwl4965_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
-	u32  status = le32_to_cpu(tx_resp->status);
+	u32  status = le32_to_cpu(tx_resp->u.status);
 	int tid = MAX_TID_COUNT, sta_id = IWL_INVALID_STATION;
 	u16 fc;
 	struct ieee80211_hdr *hdr;
@@ -3380,8 +3374,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 
 		agg = &priv->stations[sta_id].tid[tid].agg;
 
-		iwl4965_tx_status_reply_tx(priv, agg,
-				(struct iwl4965_tx_resp_agg *)tx_resp, index);
+		iwl4965_tx_status_reply_tx(priv, agg, tx_resp, txq_id, index);
 
 		if ((tx_resp->frame_count == 1) && !iwl_is_tx_success(status)) {
 			/* TODO: send BAR */
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index d3c0e10..2a30306 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1126,23 +1126,20 @@ static void iwl5000_txq_set_sched(struct iwl_priv *priv, u32 mask)
 
 static inline u32 iwl5000_get_scd_ssn(struct iwl5000_tx_resp *tx_resp)
 {
-	__le32 *scd_ssn = (__le32 *)((u32 *)&tx_resp->status +
-				tx_resp->frame_count);
-	return le32_to_cpu(*scd_ssn) & MAX_SN;
-
+	return le32_to_cpup((__le32*)&tx_resp->status +
+			    tx_resp->frame_count) & MAX_SN;
 }
 
 static int iwl5000_tx_status_reply_tx(struct iwl_priv *priv,
 				      struct iwl_ht_agg *agg,
 				      struct iwl5000_tx_resp *tx_resp,
-				      u16 start_idx)
+				      int txq_id, u16 start_idx)
 {
 	u16 status;
 	struct agg_tx_status *frame_status = &tx_resp->status;
 	struct ieee80211_tx_info *info = NULL;
 	struct ieee80211_hdr *hdr = NULL;
-	int i, sh;
-	int txq_id, idx;
+	int i, sh, idx;
 	u16 seq;
 
 	if (agg->wait_for_ba)
@@ -1157,9 +1154,7 @@ static int iwl5000_tx_status_reply_tx(struct iwl_priv *priv,
 	if (agg->frame_count == 1) {
 		/* Only one frame was attempted; no block-ack will arrive */
 		status = le16_to_cpu(frame_status[0].status);
-		seq  = le16_to_cpu(frame_status[0].sequence);
-		idx = SEQ_TO_INDEX(seq);
-		txq_id = SEQ_TO_QUEUE(seq);
+		idx = start_idx;
 
 		/* FIXME: code repetition */
 		IWL_DEBUG_TX_REPLY("FrameCnt = %d, StartIdx=%d idx=%d\n",
@@ -1296,7 +1291,7 @@ static void iwl5000_rx_reply_tx(struct iwl_priv *priv,
 
 		agg = &priv->stations[sta_id].tid[tid].agg;
 
-		iwl5000_tx_status_reply_tx(priv, agg, tx_resp, index);
+		iwl5000_tx_status_reply_tx(priv, agg, tx_resp, txq_id, index);
 
 		if ((tx_resp->frame_count == 1) && !iwl_is_tx_success(status)) {
 			/* TODO: send BAR */
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index fb6f5ff..9b64a39 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -1481,21 +1481,10 @@ struct iwl4965_tx_resp {
 	 *                   table entry used for all frames in the new agg.
 	 *           31-16:  Sequence # for this frame's Tx cmd (not SSN!)
 	 */
-	__le32 status;	/* TX status (for aggregation status of 1st frame) */
-} __attribute__ ((packed));
-
-struct iwl4965_tx_resp_agg {
-	u8 frame_count;         /* 1 no aggregation, >1 aggregation */
-	u8 reserved1;
-	u8 failure_rts;
-	u8 failure_frame;
-	__le32 rate_n_flags;
-	__le16 wireless_media_time;
-	__le16 reserved3;
-	__le32 pa_power1;
-	__le32 pa_power2;
-	struct agg_tx_status status;    /* TX status (for aggregation status */
-					/* of 1st frame) */
+	union {
+		__le32 status;
+		struct agg_tx_status agg_status[0]; /* for each agg frame */
+	} u;
 } __attribute__ ((packed));
 
 struct iwl5000_tx_resp {
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 8e7860d..510e403 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1668,7 +1668,7 @@ static void iwl4965_rx_beacon_notif(struct iwl_priv *priv,
 
 	IWL_DEBUG_RX("beacon status %x retries %d iss %d "
 		"tsf %d %d rate %d\n",
-		le32_to_cpu(beacon->beacon_notify_hdr.status) & TX_STATUS_MSK,
+		le32_to_cpu(beacon->beacon_notify_hdr.u.status) & TX_STATUS_MSK,
 		beacon->beacon_notify_hdr.failure_frame,
 		le32_to_cpu(beacon->ibss_mgr_status),
 		le32_to_cpu(beacon->high_tsf),
-- 
1.5.3.6

