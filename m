Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61085 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbYDOXCJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 19:02:09 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 04/11] iwlwifi: move the creation of LQ host command to iwlcore
Date: Tue, 15 Apr 2008 16:01:40 -0700
Message-Id: <1208300507-25628-5-git-send-email-reinette.chatre@intel.com> (sfid-20080416_000236_120809_6C969C83)
In-Reply-To: <1208300507-25628-4-git-send-email-reinette.chatre@intel.com>
References: <1208300507-25628-1-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-2-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-3-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch moves creation of LQ host command to iwlcore
from previous location in rate scaling.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-commands.h |   14 ++--
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c       |   65 +++-------------------
 drivers/net/wireless/iwlwifi/iwl-4965.c          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.h          |    3 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c           |   48 ++++++++++++++++
 5 files changed, 67 insertions(+), 65 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
index 7aa7f0b..3bcd107 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
@@ -1413,11 +1413,11 @@ struct iwl4965_txpowertable_cmd {
 
 
 /**
- * struct iwl4965_link_qual_general_params
+ * struct iwl_link_qual_general_params
  *
  * Used in REPLY_TX_LINK_QUALITY_CMD
  */
-struct iwl4965_link_qual_general_params {
+struct iwl_link_qual_general_params {
 	u8 flags;
 
 	/* No entries at or above this (driver chosen) index contain MIMO */
@@ -1444,11 +1444,11 @@ struct iwl4965_link_qual_general_params {
 } __attribute__ ((packed));
 
 /**
- * struct iwl4965_link_qual_agg_params
+ * struct iwl_link_qual_agg_params
  *
  * Used in REPLY_TX_LINK_QUALITY_CMD
  */
-struct iwl4965_link_qual_agg_params {
+struct iwl_link_qual_agg_params {
 
 	/* Maximum number of uSec in aggregation.
 	 * Driver should set this to 4000 (4 milliseconds). */
@@ -1658,14 +1658,14 @@ struct iwl4965_link_qual_agg_params {
  * legacy), and then repeat the search process.
  *
  */
-struct iwl4965_link_quality_cmd {
+struct iwl_link_quality_cmd {
 
 	/* Index of destination/recipient station in uCode's station table */
 	u8 sta_id;
 	u8 reserved1;
 	__le16 control;		/* not used */
-	struct iwl4965_link_qual_general_params general_params;
-	struct iwl4965_link_qual_agg_params agg_params;
+	struct iwl_link_qual_general_params general_params;
+	struct iwl_link_qual_agg_params agg_params;
 
 	/*
 	 * Rate info; when using rate-scaling, Tx command's initial_rate_index
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index 315b043..b608e1c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -150,7 +150,7 @@ struct iwl4965_lq_sta {
 	u16 active_mimo_rate;
 	u16 active_rate_basic;
 
-	struct iwl4965_link_quality_cmd lq;
+	struct iwl_link_quality_cmd lq;
 	struct iwl4965_scale_tbl_info lq_info[LQ_SIZE]; /* "active", "search" */
 #ifdef CONFIG_IWL4965_HT
 	struct iwl4965_traffic_load load[TID_MAX_LOAD_COUNT];
@@ -173,7 +173,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 				   struct sta_info *sta);
 static void rs_fill_link_cmd(struct iwl4965_lq_sta *lq_sta,
 			     struct iwl4965_rate *tx_mcs,
-			     struct iwl4965_link_quality_cmd *tbl);
+			     struct iwl_link_quality_cmd *tbl);
 
 
 #ifdef CONFIG_MAC80211_DEBUGFS
@@ -230,58 +230,11 @@ static s32 expected_tpt_mimo40MHzSGI[IWL_RATE_COUNT] = {
 	0, 0, 0, 0, 131, 131, 191, 222, 242, 270, 284, 289, 293
 };
 
-static int iwl4965_lq_sync_callback(struct iwl_priv *priv,
-				struct iwl_cmd *cmd, struct sk_buff *skb)
-{
-	/*We didn't cache the SKB; let the caller free it */
-	return 1;
-}
-
 static inline u8 iwl4965_rate_get_rate(u32 rate_n_flags)
 {
 	return (u8)(rate_n_flags & 0xFF);
 }
 
-static int rs_send_lq_cmd(struct iwl_priv *priv,
-			  struct iwl4965_link_quality_cmd *lq, u8 flags)
-{
-#ifdef CONFIG_IWLWIFI_DEBUG
-	int i;
-#endif
-	struct iwl_host_cmd cmd = {
-		.id = REPLY_TX_LINK_QUALITY_CMD,
-		.len = sizeof(struct iwl4965_link_quality_cmd),
-		.meta.flags = flags,
-		.data = lq,
-	};
-
-	if ((lq->sta_id == 0xFF) &&
-	    (priv->iw_mode == IEEE80211_IF_TYPE_IBSS))
-		return -EINVAL;
-
-	if (lq->sta_id == 0xFF)
-		lq->sta_id = IWL_AP_ID;
-
-	IWL_DEBUG_RATE("lq station id 0x%x\n", lq->sta_id);
-	IWL_DEBUG_RATE("lq dta 0x%X 0x%X\n",
-		       lq->general_params.single_stream_ant_msk,
-		       lq->general_params.dual_stream_ant_msk);
-#ifdef CONFIG_IWLWIFI_DEBUG
-	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++)
-		IWL_DEBUG_RATE("lq index %d 0x%X\n",
-				i, lq->rs_table[i].rate_n_flags);
-#endif
-
-	if (flags & CMD_ASYNC)
-		cmd.meta.u.callback = iwl4965_lq_sync_callback;
-
-	if (iwl_is_associated(priv) && priv->assoc_station_added &&
-	    priv->lq_mngr.lq_ready)
-		return  iwl_send_cmd(priv, &cmd);
-
-	return 0;
-}
-
 static void rs_rate_scale_clear_window(struct iwl4965_rate_scale_data *window)
 {
 	window->data = 0;
@@ -819,7 +772,7 @@ static void rs_tx_status(void *priv_rate, struct net_device *dev,
 	u8 retries;
 	int rs_index, index = 0;
 	struct iwl4965_lq_sta *lq_sta;
-	struct iwl4965_link_quality_cmd *table;
+	struct iwl_link_quality_cmd *table;
 	struct sta_info *sta;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct iwl_priv *priv = (struct iwl_priv *)priv_rate;
@@ -1879,7 +1832,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 		if (update_lq) {
 			rs_mcs_from_tbl(&mcs_rate, tbl, index, is_green);
 			rs_fill_link_cmd(lq_sta, &mcs_rate, &lq_sta->lq);
-			rs_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC);
+			iwl_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC);
 		}
 		goto out;
 
@@ -2044,7 +1997,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 	if (update_lq) {
 		rs_mcs_from_tbl(&mcs_rate, tbl, index, is_green);
 		rs_fill_link_cmd(lq_sta, &mcs_rate, &lq_sta->lq);
-		rs_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC);
+		iwl_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC);
 	}
 
 	/* Should we stay with this modulation mode, or search for a new one? */
@@ -2084,7 +2037,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 				     tbl->current_rate.rate_n_flags, index);
 			rs_fill_link_cmd(lq_sta, &tbl->current_rate,
 					 &lq_sta->lq);
-			rs_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC);
+			iwl_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC);
 		}
 
 		/* If the "active" (non-search) mode was legacy,
@@ -2197,7 +2150,7 @@ static void rs_initialize_lq(struct iwl_priv *priv,
 	tbl->current_rate.rate_n_flags = mcs_rate.rate_n_flags;
 	rs_get_expected_tpt_table(lq_sta, tbl);
 	rs_fill_link_cmd(lq_sta, &mcs_rate, &lq_sta->lq);
-	rs_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC);
+	iwl_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC);
  out:
 	return;
 }
@@ -2392,7 +2345,7 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 
 static void rs_fill_link_cmd(struct iwl4965_lq_sta *lq_sta,
 			    struct iwl4965_rate *tx_mcs,
-			    struct iwl4965_link_quality_cmd *lq_cmd)
+			    struct iwl_link_quality_cmd *lq_cmd)
 {
 	int index = 0;
 	int rate_idx;
@@ -2591,7 +2544,7 @@ static ssize_t rs_sta_dbgfs_scale_table_write(struct file *file,
 
 	if (lq_sta->dbg_fixed.rate_n_flags) {
 		rs_fill_link_cmd(lq_sta, &lq_sta->dbg_fixed, &lq_sta->lq);
-		rs_send_lq_cmd(lq_sta->drv, &lq_sta->lq, CMD_ASYNC);
+		iwl_send_lq_cmd(lq_sta->drv, &lq_sta->lq, CMD_ASYNC);
 	}
 
 	return count;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index e647be7..8c8d7cf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -4484,7 +4484,7 @@ static int iwl4965_tx_queue_agg_enable(struct iwl_priv *priv, int txq_id,
 void iwl4965_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap)
 {
 	int i, r;
-	struct iwl4965_link_quality_cmd link_cmd = {
+	struct iwl_link_quality_cmd link_cmd = {
 		.reserved1 = 0,
 	};
 	u16 rate_flags;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 7791d2b..0ff0978 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -231,5 +231,6 @@ enum iwlcore_card_notify {
 int iwlcore_low_level_notify(struct iwl_priv *priv,
 			     enum iwlcore_card_notify notify);
 extern int iwl_send_statistics_request(struct iwl_priv *priv, u8 flags);
-
+int iwl_send_lq_cmd(struct iwl_priv *priv,
+		    struct iwl_link_quality_cmd *lq, u8 flags);
 #endif /* __iwl_core_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index bc2e603..0ccd156 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -303,3 +303,51 @@ int iwl_set_dynamic_key(struct iwl_priv *priv,
 	return ret;
 }
 
+#ifdef CONFIG_IWLWIFI_DEBUG
+static void iwl_dump_lq_cmd(struct iwl_priv *priv,
+			   struct iwl_link_quality_cmd *lq)
+{
+	int i;
+	IWL_DEBUG_RATE("lq station id 0x%x\n", lq->sta_id);
+	IWL_DEBUG_RATE("lq dta 0x%X 0x%X\n",
+		       lq->general_params.single_stream_ant_msk,
+		       lq->general_params.dual_stream_ant_msk);
+
+	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++)
+		IWL_DEBUG_RATE("lq index %d 0x%X\n",
+			       i, lq->rs_table[i].rate_n_flags);
+}
+#else
+static inline void iwl_dump_lq_cmd(struct iwl_priv *priv,
+				   struct iwl_link_quality_cmd *lq)
+{
+}
+#endif
+
+int iwl_send_lq_cmd(struct iwl_priv *priv,
+		    struct iwl_link_quality_cmd *lq, u8 flags)
+{
+	struct iwl_host_cmd cmd = {
+		.id = REPLY_TX_LINK_QUALITY_CMD,
+		.len = sizeof(struct iwl_link_quality_cmd),
+		.meta.flags = flags,
+		.data = lq,
+	};
+
+	if ((lq->sta_id == 0xFF) &&
+	    (priv->iw_mode == IEEE80211_IF_TYPE_IBSS))
+		return -EINVAL;
+
+	if (lq->sta_id == 0xFF)
+		lq->sta_id = IWL_AP_ID;
+
+	iwl_dump_lq_cmd(priv,lq);
+
+	if (iwl_is_associated(priv) && priv->assoc_station_added &&
+	    priv->lq_mngr.lq_ready)
+		return  iwl_send_cmd(priv, &cmd);
+
+	return 0;
+}
+EXPORT_SYMBOL(iwl_send_lq_cmd);
+
-- 
1.5.3.4

