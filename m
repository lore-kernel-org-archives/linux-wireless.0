Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19072 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755097Ab2CDUnH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:07 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 053/101] iwlwifi: put use_rts_for_aggregation into hw_params
Date: Sun,  4 Mar 2012 11:29:07 -0800
Message-Id: <1330889395-533-54-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214543_220984_13A1E75D)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The hardware config ht_params shouldn't be modified,
so copy the use_rts_for_aggregation parameter into
hw_params and use/modify it there.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    3 +--
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c   |    3 +--
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    4 ++++
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-shared.h   |    2 ++
 6 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 2c5e7ec..e191d39 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -436,8 +436,7 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	 * force CTS-to-self frames protection if RTS-CTS is not preferred
 	 * one aggregation protection method
 	 */
-	if (!(cfg(priv)->ht_params &&
-	      cfg(priv)->ht_params->use_rts_for_aggregation))
+	if (!hw_params(priv).use_rts_for_aggregation)
 		ctx->staging.flags |= RXON_FLG_SELF_CTS_EN;
 
 	if ((ctx->vif && ctx->vif->bss_conf.use_short_slot) ||
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index ab2221d..5734dbf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -594,8 +594,7 @@ int iwlagn_tx_agg_oper(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	sta_priv->max_agg_bufsize =
 		min(sta_priv->max_agg_bufsize, buf_size);
 
-	if (cfg(priv)->ht_params &&
-	    cfg(priv)->ht_params->use_rts_for_aggregation) {
+	if (hw_params(priv).use_rts_for_aggregation) {
 		/*
 		 * switch to RTS/CTS if it is the prefer protection
 		 * method for HT traffic
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index ac23aa3..ce62a2f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1119,6 +1119,10 @@ static void iwl_uninit_drv(struct iwl_priv *priv)
 
 static void iwl_set_hw_params(struct iwl_priv *priv)
 {
+	if (cfg(priv)->ht_params)
+		hw_params(priv).use_rts_for_aggregation =
+			cfg(priv)->ht_params->use_rts_for_aggregation;
+
 	if (iwlagn_mod_params.amsdu_size_8K)
 		hw_params(priv).rx_page_order =
 			get_order(IWL_RX_BUF_SIZE_8K);
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index b729128..5e1b078 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -2431,7 +2431,7 @@ static ssize_t iwl_dbgfs_protection_mode_read(struct file *file,
 	if (cfg(priv)->ht_params)
 		pos += scnprintf(buf + pos, bufsz - pos,
 			 "use %s for aggregation\n",
-			 (cfg(priv)->ht_params->use_rts_for_aggregation) ?
+			 (hw_params(priv).use_rts_for_aggregation) ?
 				"rts/cts" : "cts-to-self");
 	else
 		pos += scnprintf(buf + pos, bufsz - pos, "N/A");
@@ -2458,9 +2458,9 @@ static ssize_t iwl_dbgfs_protection_mode_write(struct file *file,
 	if (sscanf(buf, "%d", &rts) != 1)
 		return -EINVAL;
 	if (rts)
-		cfg(priv)->ht_params->use_rts_for_aggregation = true;
+		hw_params(priv).use_rts_for_aggregation = true;
 	else
-		cfg(priv)->ht_params->use_rts_for_aggregation = false;
+		hw_params(priv).use_rts_for_aggregation = false;
 	return count;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 3086176..d2c1d71 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -660,8 +660,8 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 			IWL_DEBUG_HT(priv, "priv->agg_tids_count = %u\n",
 				     priv->agg_tids_count);
 		}
-		if (!priv->agg_tids_count && cfg(priv)->ht_params &&
-		    cfg(priv)->ht_params->use_rts_for_aggregation) {
+		if (!priv->agg_tids_count &&
+		    hw_params(priv).use_rts_for_aggregation) {
 			/*
 			 * switch off RTS/CTS if it was previously enabled
 			 */
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 5fac263..ecb46dc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -173,6 +173,7 @@ struct iwl_mod_params {
  *	relevant for 1000, 6000 and up
  * @wd_timeout: TX queues watchdog timeout
  * @struct iwl_sensitivity_ranges: range of sensitivity values
+ * @use_rts_for_aggregation: use rts/cts protection for HT traffic
  */
 struct iwl_hw_params {
 	u8  num_ampdu_queues;
@@ -181,6 +182,7 @@ struct iwl_hw_params {
 	u8  valid_tx_ant;
 	u8  valid_rx_ant;
 	u8  ht40_channel;
+	bool use_rts_for_aggregation;
 	u16 sku;
 	u32 rx_page_order;
 	u32 ct_kill_threshold;
-- 
1.7.0.4

