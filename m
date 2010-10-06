Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:12892 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759164Ab0JFPXz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 11:23:55 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 5/6] iwlagn: rename iwl5000_tx_resp
Date: Wed,  6 Oct 2010 08:23:12 -0700
Message-Id: <1286378593-7509-6-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1286378593-7509-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1286378593-7509-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwl5000_tx_resp really should be iwlagn_tx_resp, rename it.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |   14 ++++++++------
 drivers/net/wireless/iwlwifi/iwl-commands.h |   10 +++++-----
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 48c48f1..f5445d5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -40,7 +40,7 @@
 #include "iwl-agn.h"
 #include "iwl-sta.h"
 
-static inline u32 iwlagn_get_scd_ssn(struct iwl5000_tx_resp *tx_resp)
+static inline u32 iwlagn_get_scd_ssn(struct iwlagn_tx_resp *tx_resp)
 {
 	return le32_to_cpup((__le32 *)&tx_resp->status +
 			    tx_resp->frame_count) & MAX_SN;
@@ -172,7 +172,7 @@ static void iwlagn_count_agg_tx_err_status(struct iwl_priv *priv, u16 status)
 
 static void iwlagn_set_tx_status(struct iwl_priv *priv,
 				 struct ieee80211_tx_info *info,
-				 struct iwl5000_tx_resp *tx_resp,
+				 struct iwlagn_tx_resp *tx_resp,
 				 int txq_id, bool is_agg)
 {
 	u16  status = le16_to_cpu(tx_resp->status.status);
@@ -223,7 +223,7 @@ const char *iwl_get_agg_tx_fail_reason(u16 status)
 
 static int iwlagn_tx_status_reply_tx(struct iwl_priv *priv,
 				      struct iwl_ht_agg *agg,
-				      struct iwl5000_tx_resp *tx_resp,
+				      struct iwlagn_tx_resp *tx_resp,
 				      int txq_id, u16 start_idx)
 {
 	u16 status;
@@ -390,7 +390,7 @@ static void iwlagn_rx_reply_tx(struct iwl_priv *priv,
 	int index = SEQ_TO_INDEX(sequence);
 	struct iwl_tx_queue *txq = &priv->txq[txq_id];
 	struct ieee80211_tx_info *info;
-	struct iwl5000_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
+	struct iwlagn_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
 	u32  status = le16_to_cpu(tx_resp->status.status);
 	int tid;
 	int sta_id;
@@ -408,8 +408,10 @@ static void iwlagn_rx_reply_tx(struct iwl_priv *priv,
 	info = IEEE80211_SKB_CB(txq->txb[txq->q.read_ptr].skb);
 	memset(&info->status, 0, sizeof(info->status));
 
-	tid = (tx_resp->ra_tid & IWL50_TX_RES_TID_MSK) >> IWL50_TX_RES_TID_POS;
-	sta_id = (tx_resp->ra_tid & IWL50_TX_RES_RA_MSK) >> IWL50_TX_RES_RA_POS;
+	tid = (tx_resp->ra_tid & IWLAGN_TX_RES_TID_MSK) >>
+		IWLAGN_TX_RES_TID_POS;
+	sta_id = (tx_resp->ra_tid & IWLAGN_TX_RES_RA_MSK) >>
+		IWLAGN_TX_RES_RA_POS;
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
 	if (txq->sched_retry) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 953e536..fe65256 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -1959,12 +1959,12 @@ struct iwl4965_tx_resp {
 #define IWL50_TX_RES_INV_RATE_INDEX_MSK	0x80
 
 /* refer to ra_tid */
-#define IWL50_TX_RES_TID_POS	0
-#define IWL50_TX_RES_TID_MSK	0x0f
-#define IWL50_TX_RES_RA_POS	4
-#define IWL50_TX_RES_RA_MSK	0xf0
+#define IWLAGN_TX_RES_TID_POS	0
+#define IWLAGN_TX_RES_TID_MSK	0x0f
+#define IWLAGN_TX_RES_RA_POS	4
+#define IWLAGN_TX_RES_RA_MSK	0xf0
 
-struct iwl5000_tx_resp {
+struct iwlagn_tx_resp {
 	u8 frame_count;		/* 1 no aggregation, >1 aggregation */
 	u8 bt_kill_count;	/* # blocked by bluetooth (unused for agg) */
 	u8 failure_rts;		/* # failures due to unsuccessful RTS */
-- 
1.7.0.4

