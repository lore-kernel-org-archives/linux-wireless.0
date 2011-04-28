Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880Ab1D1JNA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 05:13:00 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] iwlagn: fix tx power initialization
Date: Thu, 28 Apr 2011 11:12:10 +0200
Message-Id: <1303981930-6104-1-git-send-email-sgruszka@redhat.com> (sfid-20110428_111304_131811_2BA26794)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since

commit f844a709a7d8f8be61a571afc31dfaca9e779621
Author: Stanislaw Gruszka <sgruszka@redhat.com>
Date:   Fri Jan 28 16:47:44 2011 +0100

    iwlwifi: do not set tx power when channel is changing

we set device tx power during initialization to priv->tx_power_next,
which itself is initialized to minimum power. That changed
default behaviour of driver. Previously we initialized device to
transmit at maximum available power by default. Patch change again
to previous behaviour and cleanup tx power initialization.

Fortunately this is not critical fix, as mac80211 layer setup
tx power lately to 14dB, hence device does not operate at minimal
transmit power all the time.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    6 ------
 drivers/net/wireless/iwlwifi/iwl-core.c   |    9 +++++++--
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |    7 -------
 3 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index a4f1009..a4ec524 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3444,12 +3444,6 @@ static int iwl_init_drv(struct iwl_priv *priv)
 		priv->dynamic_frag_thresh = BT_FRAG_THRESHOLD_DEF;
 	}
 
-	/* Set the tx_power_user_lmt to the lowest power level
-	 * this value will get overwritten by channel max power avg
-	 * from eeprom */
-	priv->tx_power_user_lmt = IWLAGN_TX_POWER_TARGET_POWER_MIN;
-	priv->tx_power_next = IWLAGN_TX_POWER_TARGET_POWER_MIN;
-
 	ret = iwl_init_channel_map(priv);
 	if (ret) {
 		IWL_ERR(priv, "initializing regulatory failed: %d\n", ret);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 46d6965..af72fd5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -135,6 +135,7 @@ int iwlcore_init_geos(struct iwl_priv *priv)
 	struct ieee80211_channel *geo_ch;
 	struct ieee80211_rate *rates;
 	int i = 0;
+	s8 max_tx_power = IWLAGN_TX_POWER_TARGET_POWER_MIN;
 
 	if (priv->bands[IEEE80211_BAND_2GHZ].n_bitrates ||
 	    priv->bands[IEEE80211_BAND_5GHZ].n_bitrates) {
@@ -208,8 +209,8 @@ int iwlcore_init_geos(struct iwl_priv *priv)
 
 			geo_ch->flags |= ch->ht40_extension_channel;
 
-			if (ch->max_power_avg > priv->tx_power_device_lmt)
-				priv->tx_power_device_lmt = ch->max_power_avg;
+			if (ch->max_power_avg > max_tx_power)
+				max_tx_power = ch->max_power_avg;
 		} else {
 			geo_ch->flags |= IEEE80211_CHAN_DISABLED;
 		}
@@ -222,6 +223,10 @@ int iwlcore_init_geos(struct iwl_priv *priv)
 				 geo_ch->flags);
 	}
 
+	priv->tx_power_device_lmt = max_tx_power;
+	priv->tx_power_user_lmt = max_tx_power;
+	priv->tx_power_next = max_tx_power;
+
 	if ((priv->bands[IEEE80211_BAND_5GHZ].n_channels == 0) &&
 	     priv->cfg->sku & IWL_SKU_A) {
 		IWL_INFO(priv, "Incorrectly detected BG card as ABG. "
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 4027336..1e1a2d8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -711,13 +711,6 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 					     flags & EEPROM_CHANNEL_RADAR))
 				       ? "" : "not ");
 
-			/* Set the tx_power_user_lmt to the highest power
-			 * supported by any channel */
-			if (eeprom_ch_info[ch].max_power_avg >
-						priv->tx_power_user_lmt)
-				priv->tx_power_user_lmt =
-				    eeprom_ch_info[ch].max_power_avg;
-
 			ch_info++;
 		}
 	}
-- 
1.7.1

