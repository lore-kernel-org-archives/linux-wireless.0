Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56110 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbYJ1ShK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 14:37:10 -0400
Subject: [PATCH] iwlwifi: remove unused essid variable
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 18:25:43 +0100
Message-Id: <1225214743.3598.28.camel@johannes.berg> (sfid-20081028_193714_253960_4A04E10C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now the essid stuff is unused, so remove it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Sorry, will create more print_mac conflicts with the DECLARE_MAC_BUF
thing there...

 drivers/net/wireless/iwlwifi/iwl-3945.h     |    2 --
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   12 ------------
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 --
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   12 ------------
 4 files changed, 28 deletions(-)

--- everything.orig/drivers/net/wireless/iwlwifi/iwl-3945.h	2008-10-28 18:21:27.000000000 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl-3945.h	2008-10-28 18:21:32.000000000 +0100
@@ -828,8 +828,6 @@ struct iwl3945_priv {
 	unsigned long last_statistics_time;
 
 	/* context information */
-	u8 essid[IW_ESSID_MAX_SIZE];
-	u8 essid_len;
 	u16 rates_mask;
 
 	u32 power_mode;
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-dev.h	2008-10-28 18:21:27.000000000 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl-dev.h	2008-10-28 18:21:35.000000000 +0100
@@ -926,8 +926,6 @@ struct iwl_priv {
 	unsigned long last_statistics_time;
 
 	/* context information */
-	u8 essid[IW_ESSID_MAX_SIZE];
-	u8 essid_len;
 	u16 rates_mask;
 
 	u32 power_mode;
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-agn.c	2008-10-28 18:22:31.000000000 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl-agn.c	2008-10-28 18:22:53.000000000 +0100
@@ -2945,7 +2945,6 @@ static int iwl4965_mac_config_interface(
 {
 	struct iwl_priv *priv = hw->priv;
 	DECLARE_MAC_BUF(mac);
-	unsigned long flags;
 	int rc;
 
 	if (conf == NULL)
@@ -3040,15 +3039,6 @@ static int iwl4965_mac_config_interface(
 	}
 
  done:
-	spin_lock_irqsave(&priv->lock, flags);
-	if (!conf->ssid_len)
-		memset(priv->essid, 0, IW_ESSID_MAX_SIZE);
-	else
-		memcpy(priv->essid, conf->ssid, conf->ssid_len);
-
-	priv->essid_len = conf->ssid_len;
-	spin_unlock_irqrestore(&priv->lock, flags);
-
 	IWL_DEBUG_MAC80211("leave\n");
 	mutex_unlock(&priv->mutex);
 
@@ -3091,8 +3081,6 @@ static void iwl4965_mac_remove_interface
 	if (priv->vif == conf->vif) {
 		priv->vif = NULL;
 		memset(priv->bssid, 0, ETH_ALEN);
-		memset(priv->essid, 0, IW_ESSID_MAX_SIZE);
-		priv->essid_len = 0;
 	}
 	mutex_unlock(&priv->mutex);
 
--- everything.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-10-28 18:21:44.000000000 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-10-28 18:22:24.000000000 +0100
@@ -6721,7 +6721,6 @@ static int iwl3945_mac_config_interface(
 {
 	struct iwl3945_priv *priv = hw->priv;
 	DECLARE_MAC_BUF(mac);
-	unsigned long flags;
 	int rc;
 
 	if (conf == NULL)
@@ -6819,15 +6818,6 @@ static int iwl3945_mac_config_interface(
 	}
 
  done:
-	spin_lock_irqsave(&priv->lock, flags);
-	if (!conf->ssid_len)
-		memset(priv->essid, 0, IW_ESSID_MAX_SIZE);
-	else
-		memcpy(priv->essid, conf->ssid, conf->ssid_len);
-
-	priv->essid_len = conf->ssid_len;
-	spin_unlock_irqrestore(&priv->lock, flags);
-
 	IWL_DEBUG_MAC80211("leave\n");
 	mutex_unlock(&priv->mutex);
 
@@ -6870,8 +6860,6 @@ static void iwl3945_mac_remove_interface
 	if (priv->vif == conf->vif) {
 		priv->vif = NULL;
 		memset(priv->bssid, 0, ETH_ALEN);
-		memset(priv->essid, 0, IW_ESSID_MAX_SIZE);
-		priv->essid_len = 0;
 	}
 	mutex_unlock(&priv->mutex);
 


