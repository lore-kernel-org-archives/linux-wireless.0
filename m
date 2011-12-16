Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27087 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760198Ab1LPQh4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 11:37:56 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 20/24] iwlwifi: create iwl_mac80211 unregister routine
Date: Fri, 16 Dec 2011 07:37:25 -0800
Message-Id: <1324049849-831-21-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111216_173817_304015_EC18513B)
In-Reply-To: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

The mac80211 setup_register operations are collected in one routine,
but the cleanup routines are not.  Create a routine for this.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    7 +------
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    1 +
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |    9 +++++++++
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 5a9370d..f7e089d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1915,12 +1915,7 @@ void __devexit iwl_remove(struct iwl_priv * priv)
 	set_bit(STATUS_EXIT_PENDING, &priv->shrd->status);
 
 	iwl_testmode_cleanup(priv);
-	iwl_leds_exit(priv);
-
-	if (priv->mac80211_registered) {
-		ieee80211_unregister_hw(priv->hw);
-		priv->mac80211_registered = 0;
-	}
+	iwlagn_mac_unregister(priv);
 
 	iwl_tt_exit(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 66bcd3e..2c5b6c4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -91,6 +91,7 @@ void iwlagn_prepare_restart(struct iwl_priv *priv);
 struct ieee80211_hw *iwl_alloc_all(void);
 int iwlagn_mac_setup_register(struct iwl_priv *priv,
 			      struct iwlagn_ucode_capabilities *capa);
+void iwlagn_mac_unregister(struct iwl_priv *priv);
 
 /* RXON */
 int iwlagn_set_pan_params(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 8074c6e..412ff48 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -245,6 +245,15 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 	return 0;
 }
 
+void iwlagn_mac_unregister(struct iwl_priv *priv)
+{
+	if (!priv->mac80211_registered)
+		return;
+	iwl_leds_exit(priv);
+	ieee80211_unregister_hw(priv->hw);
+	priv->mac80211_registered = 0;
+}
+
 static int __iwl_up(struct iwl_priv *priv)
 {
 	struct iwl_rxon_context *ctx;
-- 
1.7.0.4

