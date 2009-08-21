Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:9226 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932616AbZHUUe0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 16:34:26 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 03/14] iwlwifi: name changes from "tx_power_channel_lmt" to "tx_power_device_lmt"
Date: Fri, 21 Aug 2009 13:34:16 -0700
Message-Id: <1250886867-4112-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1250886867-4112-1-git-send-email-reinette.chatre@intel.com>
References: <1250886867-4112-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Changing the name from "tx_power_channel_lmt" to "tx_power_device_lmt";
to give idea that scope of limit is for overall device, not any
individual channels

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    8 ++++----
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index faafcae..82dadd0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -543,8 +543,8 @@ int iwlcore_init_geos(struct iwl_priv *priv)
 
 			geo_ch->flags |= ch->ht40_extension_channel;
 
-			if (ch->max_power_avg > priv->tx_power_channel_lmt)
-				priv->tx_power_channel_lmt = ch->max_power_avg;
+			if (ch->max_power_avg > priv->tx_power_device_lmt)
+				priv->tx_power_device_lmt = ch->max_power_avg;
 		} else {
 			geo_ch->flags |= IEEE80211_CHAN_DISABLED;
 		}
@@ -1708,10 +1708,10 @@ int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
 		return -EINVAL;
 	}
 
-	if (tx_power > priv->tx_power_channel_lmt) {
+	if (tx_power > priv->tx_power_device_lmt) {
 		IWL_WARN(priv,
 			"Requested user TXPOWER %d above upper limit %d.\n",
-			 tx_power, priv->tx_power_channel_lmt);
+			 tx_power, priv->tx_power_device_lmt);
 		return -EINVAL;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 0178734..ccea2e4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1215,7 +1215,7 @@ struct iwl_priv {
 
 	/* TX Power */
 	s8 tx_power_user_lmt;
-	s8 tx_power_channel_lmt;
+	s8 tx_power_device_lmt;
 
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-- 
1.5.6.3

