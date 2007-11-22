Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:25761 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745AbXKVCzn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2007 21:55:43 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 2/2] iwlwifi: cache mac80211 conf setting during a hardware scan
Date: Thu, 22 Nov 2007 10:53:22 +0800
Message-Id: <11957000051938-git-send-email-yi.zhu@intel.com> (sfid-20071122_025546_843274_E24CA8C9)
In-Reply-To: <11957000022000-git-send-email-yi.zhu@intel.com>
References: <11957000022000-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch caches mac80211 configuration setting during a hardware
scan for the iwlwifi drivers.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index e5b345d..101e0b5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -732,6 +732,7 @@ struct iwl3945_priv {
 	struct ieee80211_hw *hw;
 	struct ieee80211_channel *ieee_channels;
 	struct ieee80211_rate *ieee_rates;
+	struct ieee80211_conf *cache_conf;
 
 	/* temporary frame storage list */
 	struct list_head free_frames;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 5944b4b..8713077 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -1053,6 +1053,7 @@ struct iwl4965_priv {
 	struct ieee80211_hw *hw;
 	struct ieee80211_channel *ieee_channels;
 	struct ieee80211_rate *ieee_rates;
+	struct ieee80211_conf *cache_conf;
 
 	/* temporary frame storage list */
 	struct list_head free_frames;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 96420d5..8b1bb74 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6822,6 +6822,8 @@ static void iwl3945_bg_abort_scan(struct work_struct *work)
 	mutex_unlock(&priv->mutex);
 }
 
+static int iwl3945_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf);
+
 static void iwl3945_bg_scan_completed(struct work_struct *work)
 {
 	struct iwl3945_priv *priv =
@@ -6832,6 +6834,9 @@ static void iwl3945_bg_scan_completed(struct work_struct *work)
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
+	if (priv->cache_conf)
+		iwl3945_mac_config(priv->hw, priv->cache_conf);
+
 	ieee80211_scan_completed(priv->hw);
 
 	/* Since setting the TXPOWER may have been deferred while
@@ -6952,23 +6957,38 @@ static int iwl3945_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 	struct iwl3945_priv *priv = hw->priv;
 	const struct iwl3945_channel_info *ch_info;
 	unsigned long flags;
+	int ret = 0;
 
 	mutex_lock(&priv->mutex);
 	IWL_DEBUG_MAC80211("enter to channel %d\n", conf->channel);
 
 	if (!iwl3945_is_ready(priv)) {
 		IWL_DEBUG_MAC80211("leave - not ready\n");
-		mutex_unlock(&priv->mutex);
-		return -EIO;
+		ret = -EIO;
+		goto out;
 	}
 
 	/* TODO: Figure out how to get ieee80211_local->sta_scanning w/ only
 	 * what is exposed through include/ declarations */
 	if (unlikely(!iwl3945_param_disable_hw_scan &&
 		     test_bit(STATUS_SCANNING, &priv->status))) {
-		IWL_DEBUG_MAC80211("leave - scanning\n");
+
+		if (priv->cache_conf)
+			IWL_DEBUG_MAC80211("leave - still scanning\n");
+		else {
+			/* Cache the configuration now so that we can
+			 * replay it after the hardware scan is finished. */
+			priv->cache_conf = kmalloc(sizeof(*conf), GFP_KERNEL);
+			if (priv->cache_conf) {
+				memcpy(priv->cache_conf, conf, sizeof(*conf));
+				IWL_DEBUG_MAC80211("leave - scanning\n");
+			} else {
+				IWL_DEBUG_MAC80211("leave - no memory\n");
+				ret = -ENOMEM;
+			}
+		}
 		mutex_unlock(&priv->mutex);
-		return 0;
+		return ret;
 	}
 
 	spin_lock_irqsave(&priv->lock, flags);
@@ -6979,8 +6999,8 @@ static int iwl3945_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 			       conf->channel, conf->phymode);
 		IWL_DEBUG_MAC80211("leave - invalid channel\n");
 		spin_unlock_irqrestore(&priv->lock, flags);
-		mutex_unlock(&priv->mutex);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	iwl3945_set_rxon_channel(priv, conf->phymode, conf->channel);
@@ -6997,8 +7017,7 @@ static int iwl3945_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 #ifdef IEEE80211_CONF_CHANNEL_SWITCH
 	if (conf->flags & IEEE80211_CONF_CHANNEL_SWITCH) {
 		iwl3945_hw_channel_switch(priv, conf->channel);
-		mutex_unlock(&priv->mutex);
-		return 0;
+		goto out;
 	}
 #endif
 
@@ -7006,14 +7025,13 @@ static int iwl3945_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 
 	if (!conf->radio_enabled) {
 		IWL_DEBUG_MAC80211("leave - radio disabled\n");
-		mutex_unlock(&priv->mutex);
-		return 0;
+		goto out;
 	}
 
 	if (iwl3945_is_rfkill(priv)) {
 		IWL_DEBUG_MAC80211("leave - RF kill\n");
-		mutex_unlock(&priv->mutex);
-		return -EIO;
+		ret = -EIO;
+		goto out;
 	}
 
 	iwl3945_set_rate(priv);
@@ -7026,9 +7044,13 @@ static int iwl3945_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 
 	IWL_DEBUG_MAC80211("leave\n");
 
+out:
+	if (priv->cache_conf) {
+		kfree(priv->cache_conf);
+		priv->cache_conf = NULL;
+	}
 	mutex_unlock(&priv->mutex);
-
-	return 0;
+	return ret;
 }
 
 static void iwl3945_config_ap(struct iwl3945_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index df011ea..c0e5900 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -7222,6 +7222,8 @@ static void iwl4965_bg_abort_scan(struct work_struct *work)
 	mutex_unlock(&priv->mutex);
 }
 
+static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf);
+
 static void iwl4965_bg_scan_completed(struct work_struct *work)
 {
 	struct iwl4965_priv *priv =
@@ -7232,6 +7234,9 @@ static void iwl4965_bg_scan_completed(struct work_struct *work)
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
+	if (priv->cache_conf)
+		iwl4965_mac_config(priv->hw, priv->cache_conf);
+
 	ieee80211_scan_completed(priv->hw);
 
 	/* Since setting the TXPOWER may have been deferred while
@@ -7352,23 +7357,38 @@ static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 	struct iwl4965_priv *priv = hw->priv;
 	const struct iwl4965_channel_info *ch_info;
 	unsigned long flags;
+	int ret = 0;
 
 	mutex_lock(&priv->mutex);
 	IWL_DEBUG_MAC80211("enter to channel %d\n", conf->channel);
 
 	if (!iwl4965_is_ready(priv)) {
 		IWL_DEBUG_MAC80211("leave - not ready\n");
-		mutex_unlock(&priv->mutex);
-		return -EIO;
+		ret = -EIO;
+		goto out;
 	}
 
 	/* TODO: Figure out how to get ieee80211_local->sta_scanning w/ only
 	 * what is exposed through include/ declarations */
 	if (unlikely(!iwl4965_param_disable_hw_scan &&
 		     test_bit(STATUS_SCANNING, &priv->status))) {
-		IWL_DEBUG_MAC80211("leave - scanning\n");
+
+		if (unlikely(priv->cache_conf))
+			IWL_DEBUG_MAC80211("leave - still scanning\n");
+		else {
+			/* Cache the configuration now so that we can
+			 * replay it after the hardware scan is finished. */
+			priv->cache_conf = kmalloc(sizeof(*conf), GFP_KERNEL);
+			if (priv->cache_conf) {
+				memcpy(priv->cache_conf, conf, sizeof(*conf));
+				IWL_DEBUG_MAC80211("leave - scanning\n");
+			} else {
+				IWL_DEBUG_MAC80211("leave - no memory\n");
+				ret = -ENOMEM;
+			}
+		}
 		mutex_unlock(&priv->mutex);
-		return 0;
+		return ret;
 	}
 
 	spin_lock_irqsave(&priv->lock, flags);
@@ -7379,8 +7399,8 @@ static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 			       conf->channel, conf->phymode);
 		IWL_DEBUG_MAC80211("leave - invalid channel\n");
 		spin_unlock_irqrestore(&priv->lock, flags);
-		mutex_unlock(&priv->mutex);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 #ifdef CONFIG_IWL4965_HT
@@ -7409,8 +7429,7 @@ static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 #ifdef IEEE80211_CONF_CHANNEL_SWITCH
 	if (conf->flags & IEEE80211_CONF_CHANNEL_SWITCH) {
 		iwl4965_hw_channel_switch(priv, conf->channel);
-		mutex_unlock(&priv->mutex);
-		return 0;
+		goto out;
 	}
 #endif
 
@@ -7418,14 +7437,13 @@ static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 
 	if (!conf->radio_enabled) {
 		IWL_DEBUG_MAC80211("leave - radio disabled\n");
-		mutex_unlock(&priv->mutex);
-		return 0;
+		goto out;
 	}
 
 	if (iwl4965_is_rfkill(priv)) {
 		IWL_DEBUG_MAC80211("leave - RF kill\n");
-		mutex_unlock(&priv->mutex);
-		return -EIO;
+		ret = -EIO;
+		goto out;
 	}
 
 	iwl4965_set_rate(priv);
@@ -7438,9 +7456,13 @@ static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 
 	IWL_DEBUG_MAC80211("leave\n");
 
+out:
+	if (priv->cache_conf) {
+		kfree(priv->cache_conf);
+		priv->cache_conf = NULL;
+	}
 	mutex_unlock(&priv->mutex);
-
-	return 0;
+	return ret;
 }
 
 static void iwl4965_config_ap(struct iwl4965_priv *priv)
