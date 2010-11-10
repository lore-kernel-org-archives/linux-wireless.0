Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:43232 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187Ab0KJSBE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 13:01:04 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/16] iwlagn: fix non-5000+ build
Date: Wed, 10 Nov 2010 09:56:38 -0800
Message-Id: <1289411810-23093-5-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1289411810-23093-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1289411810-23093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When building 4965 without 5000+ there were a
lot of build errors due to functions being used
that weren't even compiled in. To fix this move
some code around and only compile the HCMD code
for 5000+ series as it's not used for 4965.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile       |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |   16 ------------
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   16 ++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c  |   32 ++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   34 +++-----------------------
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    5 +++-
 6 files changed, 57 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index ce05c26..b85a9c8 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -12,13 +12,13 @@ CFLAGS_iwl-devtrace.o := -I$(src)
 # AGN
 obj-$(CONFIG_IWLAGN)	+= iwlagn.o
 iwlagn-objs		:= iwl-agn.o iwl-agn-rs.o iwl-agn-led.o iwl-agn-ict.o
-iwlagn-objs		+= iwl-agn-ucode.o iwl-agn-hcmd.o iwl-agn-tx.o
+iwlagn-objs		+= iwl-agn-ucode.o iwl-agn-tx.o
 iwlagn-objs		+= iwl-agn-lib.o iwl-agn-rx.o iwl-agn-calib.o
 iwlagn-objs		+= iwl-agn-tt.o iwl-agn-sta.o iwl-agn-eeprom.o
 iwlagn-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-agn-debugfs.o
 
 iwlagn-$(CONFIG_IWL4965) += iwl-4965.o
-iwlagn-$(CONFIG_IWL5000) += iwl-agn-rxon.o
+iwlagn-$(CONFIG_IWL5000) += iwl-agn-rxon.o iwl-agn-hcmd.o
 iwlagn-$(CONFIG_IWL5000) += iwl-5000.o
 iwlagn-$(CONFIG_IWL5000) += iwl-6000.o
 iwlagn-$(CONFIG_IWL5000) += iwl-1000.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 931af54..740591f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1584,22 +1584,6 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	return ret;
 }
 
-void iwlagn_post_scan(struct iwl_priv *priv)
-{
-	struct iwl_rxon_context *ctx;
-
-	/*
-	 * Since setting the RXON may have been deferred while
-	 * performing the scan, fire one off if needed
-	 */
-	for_each_context(priv, ctx)
-		if (memcmp(&ctx->staging, &ctx->active, sizeof(ctx->staging)))
-			iwlagn_commit_rxon(priv, ctx);
-
-	if (priv->cfg->ops->hcmd->set_pan_params)
-		priv->cfg->ops->hcmd->set_pan_params(priv);
-}
-
 int iwlagn_manage_ibss_station(struct iwl_priv *priv,
 			       struct ieee80211_vif *vif, bool add)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 11b3d88..f0ddfb1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -585,3 +585,19 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 
 	mutex_unlock(&priv->mutex);
 }
+
+void iwlagn_post_scan(struct iwl_priv *priv)
+{
+	struct iwl_rxon_context *ctx;
+
+	/*
+	 * Since setting the RXON may have been deferred while
+	 * performing the scan, fire one off if needed
+	 */
+	for_each_context(priv, ctx)
+		if (memcmp(&ctx->staging, &ctx->active, sizeof(ctx->staging)))
+			iwlagn_commit_rxon(priv, ctx);
+
+	if (priv->cfg->ops->hcmd->set_pan_params)
+		priv->cfg->ops->hcmd->set_pan_params(priv);
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 35a30d2..35f085a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -684,7 +684,7 @@ int iwl_sta_rx_agg_stop(struct iwl_priv *priv, struct ieee80211_sta *sta,
 	return iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
 }
 
-void iwl_sta_modify_ps_wake(struct iwl_priv *priv, int sta_id)
+static void iwl_sta_modify_ps_wake(struct iwl_priv *priv, int sta_id)
 {
 	unsigned long flags;
 
@@ -714,3 +714,33 @@ void iwl_sta_modify_sleep_tx_count(struct iwl_priv *priv, int sta_id, int cnt)
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
 }
+
+void iwlagn_mac_sta_notify(struct ieee80211_hw *hw,
+			   struct ieee80211_vif *vif,
+			   enum sta_notify_cmd cmd,
+			   struct ieee80211_sta *sta)
+{
+	struct iwl_priv *priv = hw->priv;
+	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
+	int sta_id;
+
+	switch (cmd) {
+	case STA_NOTIFY_SLEEP:
+		WARN_ON(!sta_priv->client);
+		sta_priv->asleep = true;
+		if (atomic_read(&sta_priv->pending_frames) > 0)
+			ieee80211_sta_block_awake(hw, sta, true);
+		break;
+	case STA_NOTIFY_AWAKE:
+		WARN_ON(!sta_priv->client);
+		if (!sta_priv->asleep)
+			break;
+		sta_priv->asleep = false;
+		sta_id = iwl_sta_id(sta);
+		if (sta_id != IWL_INVALID_STATION)
+			iwl_sta_modify_ps_wake(priv, sta_id);
+		break;
+	default:
+		break;
+	}
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index bdabf7f..4d7eb0e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3474,36 +3474,6 @@ int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 	return ret;
 }
 
-static void iwlagn_mac_sta_notify(struct ieee80211_hw *hw,
-				  struct ieee80211_vif *vif,
-				  enum sta_notify_cmd cmd,
-				  struct ieee80211_sta *sta)
-{
-	struct iwl_priv *priv = hw->priv;
-	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
-	int sta_id;
-
-	switch (cmd) {
-	case STA_NOTIFY_SLEEP:
-		WARN_ON(!sta_priv->client);
-		sta_priv->asleep = true;
-		if (atomic_read(&sta_priv->pending_frames) > 0)
-			ieee80211_sta_block_awake(hw, sta, true);
-		break;
-	case STA_NOTIFY_AWAKE:
-		WARN_ON(!sta_priv->client);
-		if (!sta_priv->asleep)
-			break;
-		sta_priv->asleep = false;
-		sta_id = iwl_sta_id(sta);
-		if (sta_id != IWL_INVALID_STATION)
-			iwl_sta_modify_ps_wake(priv, sta_id);
-		break;
-	default:
-		break;
-	}
-}
-
 int iwlagn_mac_sta_add(struct ieee80211_hw *hw,
 		       struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta)
@@ -3898,6 +3868,7 @@ static void iwl_uninit_drv(struct iwl_priv *priv)
 	kfree(priv->scan_cmd);
 }
 
+#ifdef CONFIG_IWL5000
 struct ieee80211_ops iwlagn_hw_ops = {
 	.tx = iwlagn_mac_tx,
 	.start = iwlagn_mac_start,
@@ -3920,6 +3891,7 @@ struct ieee80211_ops iwlagn_hw_ops = {
 	.flush = iwlagn_mac_flush,
 	.tx_last_beacon = iwl_mac_tx_last_beacon,
 };
+#endif
 
 static void iwl_hw_detect(struct iwl_priv *priv)
 {
@@ -3987,7 +3959,9 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (cfg->mod_params->disable_hw_scan) {
 		dev_printk(KERN_DEBUG, &(pdev->dev),
 			"sw scan support is deprecated\n");
+#ifdef CONFIG_IWL5000
 		iwlagn_hw_ops.hw_scan = NULL;
+#endif
 #ifdef CONFIG_IWL4965
 		iwl4965_hw_ops.hw_scan = NULL;
 #endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index aca93f4..28837a1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -301,9 +301,12 @@ int iwl_sta_rx_agg_start(struct iwl_priv *priv, struct ieee80211_sta *sta,
 			 int tid, u16 ssn);
 int iwl_sta_rx_agg_stop(struct iwl_priv *priv, struct ieee80211_sta *sta,
 			int tid);
-void iwl_sta_modify_ps_wake(struct iwl_priv *priv, int sta_id);
 void iwl_sta_modify_sleep_tx_count(struct iwl_priv *priv, int sta_id, int cnt);
 int iwl_update_bcast_stations(struct iwl_priv *priv);
+void iwlagn_mac_sta_notify(struct ieee80211_hw *hw,
+			   struct ieee80211_vif *vif,
+			   enum sta_notify_cmd cmd,
+			   struct ieee80211_sta *sta);
 
 /* rate */
 static inline u32 iwl_ant_idx_to_flags(u8 ant_idx)
-- 
1.7.0.4

