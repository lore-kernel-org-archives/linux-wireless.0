Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:55973 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754981Ab2CDUnA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:00 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 018/101] iwlwifi: move wowlan bool into priv
Date: Sun,  4 Mar 2012 11:28:32 -0800
Message-Id: <1330889395-533-19-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214638_747237_9DF72783)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

With the new WoWLAN flow into the transport
there no longer is a need for this to be
shared, so move it into priv.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 ++
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-power.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h   |    1 -
 8 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 79ac7cb..626b0d1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1193,7 +1193,7 @@ int iwlagn_suspend(struct iwl_priv *priv,
 
 	iwl_trans_stop_device(trans(priv));
 
-	priv->shrd->wowlan = true;
+	priv->wowlan = true;
 
 	ret = iwl_load_ucode_wait_alive(trans(priv), IWL_UCODE_WOWLAN);
 	if (ret)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 222a8f4..7a713ba 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -586,7 +586,7 @@ void iwl_restore_stations(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 			       sizeof(struct iwl_addsta_cmd));
 			send_lq = false;
 			if (priv->stations[i].lq) {
-				if (priv->shrd->wowlan)
+				if (priv->wowlan)
 					iwl_sta_fill_lq(priv, ctx, i, &lq);
 				else
 					memcpy(&lq, priv->stations[i].lq,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 2b722cc..e5ebc36 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -126,7 +126,7 @@ static void iwlagn_tx_cmd_build_rate(struct iwl_priv *priv,
 	u8 data_retry_limit;
 	u8 rate_plcp;
 
-	if (priv->shrd->wowlan) {
+	if (priv->wowlan) {
 		rts_retry_limit = IWLAGN_LOW_RETRY_LIMIT;
 		data_retry_limit = IWLAGN_LOW_RETRY_LIMIT;
 	} else {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 6cec7e6..6dd4fae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -701,7 +701,7 @@ int iwl_alive_start(struct iwl_priv *priv)
 	/* Configure Tx antenna selection based on H/W config */
 	iwlagn_send_tx_ant_config(priv, hw_params(priv).valid_tx_ant);
 
-	if (iwl_is_associated_ctx(ctx) && !priv->shrd->wowlan) {
+	if (iwl_is_associated_ctx(ctx) && !priv->wowlan) {
 		struct iwl_rxon_cmd *active_rxon =
 				(struct iwl_rxon_cmd *)&ctx->active;
 		/* apply any changes in staging */
@@ -716,7 +716,7 @@ int iwl_alive_start(struct iwl_priv *priv)
 		iwlagn_set_rxon_chain(priv, ctx);
 	}
 
-	if (!priv->shrd->wowlan) {
+	if (!priv->wowlan) {
 		/* WoWLAN ucode will not reply in the same way, skip it */
 		iwl_reset_run_time_calib(priv);
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 9ea9002..ef71463 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -787,6 +787,8 @@ struct iwl_priv {
 
 	bool new_scan_threshold_behaviour;
 
+	bool wowlan;
+
 	/* EEPROM MAC addresses */
 	struct mac_address addresses[2];
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 8c7ca73..8160f61 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -418,7 +418,7 @@ static int iwlagn_mac_suspend(struct ieee80211_hw *hw,
 	goto out;
 
  error:
-	priv->shrd->wowlan = false;
+	priv->wowlan = false;
 	iwlagn_prepare_restart(priv);
 	ieee80211_restart_hw(priv->hw);
  out:
@@ -474,7 +474,7 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 	/* we'll clear ctx->vif during iwlagn_prepare_restart() */
 	vif = ctx->vif;
 
-	priv->shrd->wowlan = false;
+	priv->wowlan = false;
 
 	device_set_wakeup_enable(trans(priv)->dev, false);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index fd008c4..1ef3c4d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -348,7 +348,7 @@ static void iwl_power_build_cmd(struct iwl_priv *priv,
 
 	dtimper = priv->hw->conf.ps_dtim_period ?: 1;
 
-	if (priv->shrd->wowlan)
+	if (priv->wowlan)
 		iwl_static_sleep_cmd(priv, cmd, IWL_POWER_INDEX_5, dtimper);
 	else if (!cfg(priv)->base_params->no_idle_support &&
 		 priv->hw->conf.flags & IEEE80211_CONF_IDLE)
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 4efc9e1..a7dbcab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -371,7 +371,6 @@ struct iwl_shared {
 	u8 ucode_owner;
 	u8 cmd_queue;
 	unsigned long status;
-	bool wowlan;
 	u8 valid_contexts;
 
 	const struct iwl_cfg *cfg;
-- 
1.7.0.4

