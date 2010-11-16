Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56013 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064Ab0KPQGl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 11:06:41 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/18] iwlagn: support dynamic aggregation for BT coex
Date: Tue, 16 Nov 2010 08:01:36 -0800
Message-Id: <1289923311-14920-4-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1289923311-14920-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1289923311-14920-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use dynamic aggregation threshold if bt traffic load is high
to reduce the impact on aggregated frame.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c    |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    6 +---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c  |   32 ++++++++++++++-------------
 drivers/net/wireless/iwlwifi/iwl-agn.c     |    1 -
 drivers/net/wireless/iwlwifi/iwl-core.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    3 +-
 7 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index c7ff1bd..d8f9df6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -546,6 +546,7 @@ static struct iwl_bt_params iwl6000_bt_params = {
 	.bt_statistics = true,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.advanced_bt_coexist = true,
+	.agg_time_limit = BT_AGG_THRESHOLD_DEF,
 	.bt_init_traffic_load = IWL_BT_COEX_TRAFFIC_LOAD_NONE,
 	.bt_prio_boost = IWLAGN_BT_PRIO_BOOST_DEFAULT,
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index ca3530c..c6f65fd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -2025,7 +2025,6 @@ void iwlagn_bt_coex_profile_notif(struct iwl_priv *priv,
 	struct iwl_bt_coex_profile_notif *coex = &pkt->u.bt_coex_profile_notif;
 	struct iwlagn_bt_sco_cmd sco_cmd = { .flags = 0 };
 	struct iwl_bt_uart_msg *uart_msg = &coex->last_bt_uart_msg;
-	u8 last_traffic_load;
 
 	IWL_DEBUG_NOTIF(priv, "BT Coex notification:\n");
 	IWL_DEBUG_NOTIF(priv, "    status: %d\n", coex->bt_status);
@@ -2034,11 +2033,10 @@ void iwlagn_bt_coex_profile_notif(struct iwl_priv *priv,
 			coex->bt_ci_compliance);
 	iwlagn_print_uartmsg(priv, uart_msg);
 
-	last_traffic_load = priv->notif_bt_traffic_load;
-	priv->notif_bt_traffic_load = coex->bt_traffic_load;
+	priv->last_bt_traffic_load = priv->bt_traffic_load;
 	if (priv->iw_mode != NL80211_IFTYPE_ADHOC) {
 		if (priv->bt_status != coex->bt_status ||
-		    last_traffic_load != coex->bt_traffic_load) {
+		    priv->last_bt_traffic_load != coex->bt_traffic_load) {
 			if (coex->bt_status) {
 				/* BT on */
 				if (!priv->bt_ch_announce)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 0655536..f450adc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -833,17 +833,23 @@ static void rs_bt_update_lq(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 			    struct iwl_lq_sta *lq_sta)
 {
 	struct iwl_scale_tbl_info *tbl;
-	bool full_concurrent;
+	bool full_concurrent = priv->bt_full_concurrent;
 	unsigned long flags;
 
-	spin_lock_irqsave(&priv->lock, flags);
-	if (priv->bt_ci_compliance && priv->bt_ant_couple_ok)
-		full_concurrent = true;
-	else
-		full_concurrent = false;
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	if (priv->bt_full_concurrent != full_concurrent) {
+	if (priv->bt_ant_couple_ok) {
+		/*
+		 * Is there a need to switch between
+		 * full concurrency and 3-wire?
+		 */
+		spin_lock_irqsave(&priv->lock, flags);
+		if (priv->bt_ci_compliance && priv->bt_ant_couple_ok)
+			full_concurrent = true;
+		else
+			full_concurrent = false;
+		spin_unlock_irqrestore(&priv->lock, flags);
+	}
+	if ((priv->bt_traffic_load != priv->last_bt_traffic_load) ||
+	    (priv->bt_full_concurrent != full_concurrent)) {
 		priv->bt_full_concurrent = full_concurrent;
 
 		/* Update uCode's rate table. */
@@ -1040,8 +1046,7 @@ done:
 	if (sta && sta->supp_rates[sband->band])
 		rs_rate_scale_perform(priv, skb, sta, lq_sta);
 
-	/* Is there a need to switch between full concurrency and 3-wire? */
-	if (priv->bt_ant_couple_ok)
+	if (priv->cfg->bt_params && priv->cfg->bt_params->advanced_bt_coexist)
 		rs_bt_update_lq(priv, ctx, lq_sta);
 }
 
@@ -3010,10 +3015,7 @@ static void rs_fill_link_cmd(struct iwl_priv *priv,
 	 */
 	if (priv && priv->cfg->bt_params &&
 	    priv->cfg->bt_params->agg_time_limit &&
-	    priv->cfg->bt_params->agg_time_limit >=
-		LINK_QUAL_AGG_TIME_LIMIT_MIN &&
-	    priv->cfg->bt_params->agg_time_limit <=
-		 LINK_QUAL_AGG_TIME_LIMIT_MAX)
+	    priv->bt_traffic_load >= IWL_BT_COEX_TRAFFIC_LOAD_HIGH)
 		lq_cmd->agg_params.agg_time_limit =
 			cpu_to_le16(priv->cfg->bt_params->agg_time_limit);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 007fb20..d976912 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3837,7 +3837,6 @@ static int iwl_init_drv(struct iwl_priv *priv)
 		priv->bt_on_thresh = BT_ON_THRESHOLD_DEF;
 		priv->bt_duration = BT_DURATION_LIMIT_DEF;
 		priv->dynamic_frag_thresh = BT_FRAG_THRESHOLD_DEF;
-		priv->dynamic_agg_thresh = BT_AGG_THRESHOLD_DEF;
 	}
 
 	/* Set the tx_power_user_lmt to the lowest power level
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index c884ed3..c41f5a8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1469,7 +1469,7 @@ static void iwl_teardown_interface(struct iwl_priv *priv,
 	 * both values are the same and zero.
 	 */
 	if (vif->type == NL80211_IFTYPE_ADHOC)
-		priv->bt_traffic_load = priv->notif_bt_traffic_load;
+		priv->bt_traffic_load = priv->last_bt_traffic_load;
 }
 
 void iwl_mac_remove_interface(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 8fdd4ef..4876e26 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1580,7 +1580,7 @@ static ssize_t iwl_dbgfs_bt_traffic_read(struct file *file,
 		priv->bt_full_concurrent ? "full concurrency" : "3-wire");
 	pos += scnprintf(buf + pos, bufsz - pos, "BT status: %s, "
 			 "last traffic notif: %d\n",
-		priv->bt_status ? "On" : "Off", priv->notif_bt_traffic_load);
+		priv->bt_status ? "On" : "Off", priv->last_bt_traffic_load);
 	pos += scnprintf(buf + pos, bufsz - pos, "ch_announcement: %d, "
 			 "sco_active: %d, kill_ack_mask: %x, "
 			 "kill_cts_mask: %x\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 9fcaaf0..ea81ced 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1471,7 +1471,7 @@ struct iwl_priv {
 
 	/* bt coex */
 	u8 bt_status;
-	u8 bt_traffic_load, notif_bt_traffic_load;
+	u8 bt_traffic_load, last_bt_traffic_load;
 	bool bt_ch_announce;
 	bool bt_sco_active;
 	bool bt_full_concurrent;
@@ -1482,7 +1482,6 @@ struct iwl_priv {
 	u16 bt_on_thresh;
 	u16 bt_duration;
 	u16 dynamic_frag_thresh;
-	u16 dynamic_agg_thresh;
 	u8 bt_ci_compliance;
 	struct work_struct bt_traffic_change_work;
 
-- 
1.7.0.4

