Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:4672 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143Ab0HRQSf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Aug 2010 12:18:35 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/16] iwlwifi: refactor iwl_setup_rxon_timing
Date: Wed, 18 Aug 2010 09:22:43 -0700
Message-Id: <1282148571-9258-9-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282148571-9258-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282148571-9258-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

All callers of iwl_setup_rxon_timing() also send
the command right away, so rename the function
to iwl_send_rxon_timing() and move the sending
into it. Also, some callers clear the data, this
can be done always and thus moved in as well.
Finally, there's no reason for the function to
acquire the spinlock, but it should be called
with the mutex held, so assert that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    8 ++------
 drivers/net/wireless/iwlwifi/iwl-core.c     |   14 +++++++++-----
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   11 ++---------
 4 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 8011105..a88fabc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3109,9 +3109,7 @@ void iwl_post_associate(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	iwlcore_commit_rxon(priv);
 
-	iwl_setup_rxon_timing(priv, vif);
-	ret = iwl_send_cmd_pdu(priv, REPLY_RXON_TIMING,
-			      sizeof(priv->rxon_timing), &priv->rxon_timing);
+	ret = iwl_send_rxon_timing(priv, vif);
 	if (ret)
 		IWL_WARN(priv, "REPLY_RXON_TIMING failed - "
 			    "Attempting to continue.\n");
@@ -3347,9 +3345,7 @@ void iwl_config_ap(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		iwlcore_commit_rxon(priv);
 
 		/* RXON Timing */
-		iwl_setup_rxon_timing(priv, vif);
-		ret = iwl_send_cmd_pdu(priv, REPLY_RXON_TIMING,
-				sizeof(priv->rxon_timing), &priv->rxon_timing);
+		ret = iwl_send_rxon_timing(priv, vif);
 		if (ret)
 			IWL_WARN(priv, "REPLY_RXON_TIMING failed - "
 					"Attempting to continue.\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index fe28272..c31177c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -491,17 +491,19 @@ static u16 iwl_adjust_beacon_interval(u16 beacon_val, u16 max_beacon_val)
 	return new_val;
 }
 
-void iwl_setup_rxon_timing(struct iwl_priv *priv, struct ieee80211_vif *vif)
+int iwl_send_rxon_timing(struct iwl_priv *priv, struct ieee80211_vif *vif)
 {
 	u64 tsf;
 	s32 interval_tm, rem;
-	unsigned long flags;
 	struct ieee80211_conf *conf = NULL;
 	u16 beacon_int;
 
 	conf = ieee80211_get_hw_conf(priv->hw);
 
-	spin_lock_irqsave(&priv->lock, flags);
+	lockdep_assert_held(&priv->mutex);
+
+	memset(&priv->rxon_timing, 0, sizeof(struct iwl_rxon_time_cmd));
+
 	priv->rxon_timing.timestamp = cpu_to_le64(priv->timestamp);
 	priv->rxon_timing.listen_interval = cpu_to_le16(conf->listen_interval);
 
@@ -524,14 +526,16 @@ void iwl_setup_rxon_timing(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	rem = do_div(tsf, interval_tm);
 	priv->rxon_timing.beacon_init_val = cpu_to_le32(interval_tm - rem);
 
-	spin_unlock_irqrestore(&priv->lock, flags);
 	IWL_DEBUG_ASSOC(priv,
 			"beacon interval %d beacon timer %d beacon tim %d\n",
 			le16_to_cpu(priv->rxon_timing.beacon_interval),
 			le32_to_cpu(priv->rxon_timing.beacon_init_val),
 			le16_to_cpu(priv->rxon_timing.atim_window));
+
+	return iwl_send_cmd_pdu(priv, REPLY_RXON_TIMING,
+				sizeof(priv->rxon_timing), &priv->rxon_timing);
 }
-EXPORT_SYMBOL(iwl_setup_rxon_timing);
+EXPORT_SYMBOL(iwl_send_rxon_timing);
 
 void iwl_set_rxon_hwcrypto(struct iwl_priv *priv, int hw_decrypt)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 17fae00..4f4280e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -711,7 +711,7 @@ extern int iwl_send_lq_cmd(struct iwl_priv *priv,
 void iwl_apm_stop(struct iwl_priv *priv);
 int iwl_apm_init(struct iwl_priv *priv);
 
-void iwl_setup_rxon_timing(struct iwl_priv *priv, struct ieee80211_vif *vif);
+int iwl_send_rxon_timing(struct iwl_priv *priv, struct ieee80211_vif *vif);
 static inline int iwl_send_rxon_assoc(struct iwl_priv *priv)
 {
 	return priv->cfg->ops->hcmd->rxon_assoc(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index bef5b17..94d7e6e 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3094,10 +3094,7 @@ void iwl3945_post_associate(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	iwlcore_commit_rxon(priv);
 
-	memset(&priv->rxon_timing, 0, sizeof(struct iwl_rxon_time_cmd));
-	iwl_setup_rxon_timing(priv, vif);
-	rc = iwl_send_cmd_pdu(priv, REPLY_RXON_TIMING,
-			      sizeof(priv->rxon_timing), &priv->rxon_timing);
+	rc = iwl_send_rxon_timing(priv, vif);
 	if (rc)
 		IWL_WARN(priv, "REPLY_RXON_TIMING failed - "
 			    "Attempting to continue.\n");
@@ -3271,11 +3268,7 @@ void iwl3945_config_ap(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		iwlcore_commit_rxon(priv);
 
 		/* RXON Timing */
-		memset(&priv->rxon_timing, 0, sizeof(struct iwl_rxon_time_cmd));
-		iwl_setup_rxon_timing(priv, vif);
-		rc = iwl_send_cmd_pdu(priv, REPLY_RXON_TIMING,
-				      sizeof(priv->rxon_timing),
-				      &priv->rxon_timing);
+		rc = iwl_send_rxon_timing(priv, vif);
 		if (rc)
 			IWL_WARN(priv, "REPLY_RXON_TIMING failed - "
 					"Attempting to continue.\n");
-- 
1.7.0.4

