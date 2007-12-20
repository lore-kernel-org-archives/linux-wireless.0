Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:47189 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbXLTGJ5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2007 01:09:57 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] iwlwifi: skip mac80211 conf during a hardware scan and replay it afterwards
Date: Thu, 20 Dec 2007 14:10:01 +0800
Message-Id: <1198131001-6418-1-git-send-email-yi.zhu@intel.com> (sfid-20071220_061001_275368_87E44096)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch skips mac80211 configuration setting during a hardware scan
and replays it afterwards for the iwlwifi drivers.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   30 +++++--------------------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   32 ++++++---------------------
 4 files changed, 15 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index bfa2606..38db516 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -429,6 +429,7 @@ struct iwl3945_rx_queue {
 #define STATUS_SCAN_HW		14
 #define STATUS_POWER_PMI	15
 #define STATUS_FW_ERROR		16
+#define STATUS_CONF_PENDING	17
 
 #define MAX_TID_COUNT        9
 
@@ -717,7 +718,6 @@ struct iwl3945_priv {
 	struct ieee80211_hw *hw;
 	struct ieee80211_channel *ieee_channels;
 	struct ieee80211_rate *ieee_rates;
-	struct ieee80211_conf *cache_conf;
 
 	/* temporary frame storage list */
 	struct list_head free_frames;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 267ae75..e75f27e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -448,6 +448,7 @@ struct iwl4965_rx_queue {
 #define STATUS_SCAN_HW		14
 #define STATUS_POWER_PMI	15
 #define STATUS_FW_ERROR		16
+#define STATUS_CONF_PENDING	17
 
 #define MAX_TID_COUNT        9
 
@@ -1046,7 +1047,6 @@ struct iwl4965_priv {
 	struct ieee80211_hw *hw;
 	struct ieee80211_channel *ieee_channels;
 	struct ieee80211_rate *ieee_rates;
-	struct ieee80211_conf *cache_conf;
 
 	/* temporary frame storage list */
 	struct list_head free_frames;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 88cf035..43bb69a 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6972,8 +6972,8 @@ static void iwl3945_bg_scan_completed(struct work_struct *work)
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
-	if (priv->cache_conf)
-		iwl3945_mac_config(priv->hw, priv->cache_conf);
+	if (test_bit(STATUS_CONF_PENDING, &priv->status))
+		iwl3945_mac_config(priv->hw, ieee80211_get_hw_conf(priv->hw));
 
 	ieee80211_scan_completed(priv->hw);
 
@@ -7115,27 +7115,12 @@ static int iwl3945_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 		goto out;
 	}
 
-	/* TODO: Figure out how to get ieee80211_local->sta_scanning w/ only
-	 * what is exposed through include/ declarations */
 	if (unlikely(!iwl3945_param_disable_hw_scan &&
 		     test_bit(STATUS_SCANNING, &priv->status))) {
-
-		if (priv->cache_conf)
-			IWL_DEBUG_MAC80211("leave - still scanning\n");
-		else {
-			/* Cache the configuration now so that we can
-			 * replay it after the hardware scan is finished. */
-			priv->cache_conf = kmalloc(sizeof(*conf), GFP_KERNEL);
-			if (priv->cache_conf) {
-				memcpy(priv->cache_conf, conf, sizeof(*conf));
-				IWL_DEBUG_MAC80211("leave - scanning\n");
-			} else {
-				IWL_DEBUG_MAC80211("leave - no memory\n");
-				ret = -ENOMEM;
-			}
-		}
+		IWL_DEBUG_MAC80211("leave - scanning\n");
+		set_bit(STATUS_CONF_PENDING, &priv->status);
 		mutex_unlock(&priv->mutex);
-		return ret;
+		return 0;
 	}
 
 	spin_lock_irqsave(&priv->lock, flags);
@@ -7192,10 +7177,7 @@ static int iwl3945_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 	IWL_DEBUG_MAC80211("leave\n");
 
 out:
-	if (priv->cache_conf) {
-		kfree(priv->cache_conf);
-		priv->cache_conf = NULL;
-	}
+	clear_bit(STATUS_CONF_PENDING, &priv->status);
 	mutex_unlock(&priv->mutex);
 	return ret;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index df6f3b1..57186ab 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -7415,8 +7415,8 @@ static void iwl4965_bg_scan_completed(struct work_struct *work)
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
-	if (priv->cache_conf)
-		iwl4965_mac_config(priv->hw, priv->cache_conf);
+	if (test_bit(STATUS_CONF_PENDING, &priv->status))
+		iwl4965_mac_config(priv->hw, ieee80211_get_hw_conf(priv->hw));
 
 	ieee80211_scan_completed(priv->hw);
 
@@ -7557,27 +7557,12 @@ static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 		goto out;
 	}
 
-	/* TODO: Figure out how to get ieee80211_local->sta_scanning w/ only
-	 * what is exposed through include/ declarations */
 	if (unlikely(!iwl4965_param_disable_hw_scan &&
 		     test_bit(STATUS_SCANNING, &priv->status))) {
-
-		if (unlikely(priv->cache_conf))
-			IWL_DEBUG_MAC80211("leave - still scanning\n");
-		else {
-			/* Cache the configuration now so that we can
-			 * replay it after the hardware scan is finished. */
-			priv->cache_conf = kmalloc(sizeof(*conf), GFP_KERNEL);
-			if (priv->cache_conf) {
-				memcpy(priv->cache_conf, conf, sizeof(*conf));
-				IWL_DEBUG_MAC80211("leave - scanning\n");
-			} else {
-				IWL_DEBUG_MAC80211("leave - no memory\n");
-				ret = -ENOMEM;
-			}
-		}
+		IWL_DEBUG_MAC80211("leave - scanning\n");
+		set_bit(STATUS_CONF_PENDING, &priv->status);
 		mutex_unlock(&priv->mutex);
-		return ret;
+		return 0;
 	}
 
 	spin_lock_irqsave(&priv->lock, flags);
@@ -7645,12 +7630,9 @@ static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 
 	IWL_DEBUG_MAC80211("leave\n");
 
-out:
-	if (priv->cache_conf) {
-		kfree(priv->cache_conf);
-		priv->cache_conf = NULL;
-	}
 	mutex_unlock(&priv->mutex);
+out:
+	clear_bit(STATUS_CONF_PENDING, &priv->status);
 	return ret;
 }
 
-- 
1.5.3.6

