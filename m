Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:46093 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754057Ab2BQUXy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 15:23:54 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 14/26] iwlwifi: kill iwl_down and s/__iwl_down/iwl_down
Date: Fri, 17 Feb 2012 11:13:42 -0800
Message-Id: <1329506034-1394-15-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120217_212405_419827_072EBC26)
In-Reply-To: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

iwl_down was just a wrapper around __iwl_down which was called from
one place only. Replace it to direct call to iwl_down. Add lockdep
warning in iwl_down to ensure it was called with the mutex held.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   19 +++++--------------
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |    6 +++++-
 3 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index ff22c4a..cf1a353 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -738,14 +738,14 @@ int iwl_alive_start(struct iwl_priv *priv)
 	return iwl_power_update_mode(priv, true);
 }
 
-static void iwl_cancel_deferred_work(struct iwl_priv *priv);
-
-void __iwl_down(struct iwl_priv *priv)
+void iwl_down(struct iwl_priv *priv)
 {
 	int exit_pending;
 
 	IWL_DEBUG_INFO(priv, DRV_NAME " is going down\n");
 
+	lockdep_assert_held(&priv->shrd->mutex);
+
 	iwl_scan_cancel_timeout(priv, 200);
 
 	/*
@@ -803,15 +803,6 @@ void __iwl_down(struct iwl_priv *priv)
 	priv->beacon_skb = NULL;
 }
 
-void iwl_down(struct iwl_priv *priv)
-{
-	mutex_lock(&priv->shrd->mutex);
-	__iwl_down(priv);
-	mutex_unlock(&priv->shrd->mutex);
-
-	iwl_cancel_deferred_work(priv);
-}
-
 /*****************************************************************************
  *
  * Workqueue callbacks
@@ -869,7 +860,7 @@ void iwlagn_prepare_restart(struct iwl_priv *priv)
 	bt_status = priv->bt_status;
 	bt_is_sco = priv->bt_is_sco;
 
-	__iwl_down(priv);
+	iwl_down(priv);
 
 	priv->bt_full_concurrent = bt_full_concurrent;
 	priv->bt_ci_compliance = bt_ci_compliance;
@@ -970,7 +961,7 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 	priv->watchdog.function = iwl_bg_watchdog;
 }
 
-static void iwl_cancel_deferred_work(struct iwl_priv *priv)
+void iwl_cancel_deferred_work(struct iwl_priv *priv)
 {
 	if (cfg(priv)->lib->cancel_deferred_work)
 		cfg(priv)->lib->cancel_deferred_work(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 37c325f..8a170b7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -81,8 +81,8 @@ static inline void iwl_set_calib_hdr(struct iwl_calib_hdr *hdr, u8 cmd)
 	hdr->data_valid = 1;
 }
 
-void __iwl_down(struct iwl_priv *priv);
 void iwl_down(struct iwl_priv *priv);
+void iwl_cancel_deferred_work(struct iwl_priv *priv);
 void iwlagn_prepare_restart(struct iwl_priv *priv);
 
 /* MAC80211 */
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index ca0c465..90d8081 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -296,7 +296,7 @@ static int __iwl_up(struct iwl_priv *priv)
 
  error:
 	set_bit(STATUS_EXIT_PENDING, &priv->shrd->status);
-	__iwl_down(priv);
+	iwl_down(priv);
 	clear_bit(STATUS_EXIT_PENDING, &priv->shrd->status);
 
 	IWL_ERR(priv, "Unable to initialize device.\n");
@@ -341,7 +341,11 @@ static void iwlagn_mac_stop(struct ieee80211_hw *hw)
 
 	priv->is_open = 0;
 
+	mutex_lock(&priv->shrd->mutex);
 	iwl_down(priv);
+	mutex_unlock(&priv->shrd->mutex);
+
+	iwl_cancel_deferred_work(priv);
 
 	flush_workqueue(priv->workqueue);
 
-- 
1.7.0.4

