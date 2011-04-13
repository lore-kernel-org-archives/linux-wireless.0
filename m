Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757863Ab1DMI4x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 04:56:53 -0400
Date: Wed, 13 Apr 2011 10:56:51 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH wireless-2.6] iwlegacy: fix tx_power initialization
Message-ID: <20110413085628.GA2747@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

priv->tx_power_next is not initialized to max supported power,
but instead default value is used, what cause errors like

[   58.597834] iwl3945 0000:03:00.0: Requested user TXPOWER 15 above upper limit 14.
[   58.597839] iwl3945 0000:03:00.0: Error setting Tx power (-22).

if maximum tx power read from the eeprom is smaller than default.
In consequence card is unable to initialize properly. Fix the problem
and cleanup tx power initialization.

Reported-and-tested-by: Robin Dong <hao.bigrat@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-3945-hw.h  |    2 --
 drivers/net/wireless/iwlegacy/iwl-4965-hw.h  |    3 ---
 drivers/net/wireless/iwlegacy/iwl-core.c     |   17 +++++++++++------
 drivers/net/wireless/iwlegacy/iwl-eeprom.c   |    7 -------
 drivers/net/wireless/iwlegacy/iwl3945-base.c |    4 ----
 drivers/net/wireless/iwlegacy/iwl4965-base.c |    6 ------
 6 files changed, 11 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-3945-hw.h b/drivers/net/wireless/iwlegacy/iwl-3945-hw.h
index 779d3cb..5c3a68d 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlegacy/iwl-3945-hw.h
@@ -74,8 +74,6 @@
 /* RSSI to dBm */
 #define IWL39_RSSI_OFFSET	95
 
-#define IWL_DEFAULT_TX_POWER	0x0F
-
 /*
  * EEPROM related constants, enums, and structures.
  */
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-hw.h b/drivers/net/wireless/iwlegacy/iwl-4965-hw.h
index 08b189c..fc6fa28 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-hw.h
@@ -804,9 +804,6 @@ struct iwl4965_scd_bc_tbl {
 
 #define IWL4965_DEFAULT_TX_RETRY  15
 
-/* Limit range of txpower output target to be between these values */
-#define IWL4965_TX_POWER_TARGET_POWER_MIN	(0)	/* 0 dBm: 1 milliwatt */
-
 /* EEPROM */
 #define IWL4965_FIRST_AMPDU_QUEUE	10
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.c b/drivers/net/wireless/iwlegacy/iwl-core.c
index 7007d61..c1511b1 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.c
+++ b/drivers/net/wireless/iwlegacy/iwl-core.c
@@ -160,6 +160,7 @@ int iwl_legacy_init_geos(struct iwl_priv *priv)
 	struct ieee80211_channel *geo_ch;
 	struct ieee80211_rate *rates;
 	int i = 0;
+	s8 max_tx_power = 0;
 
 	if (priv->bands[IEEE80211_BAND_2GHZ].n_bitrates ||
 	    priv->bands[IEEE80211_BAND_5GHZ].n_bitrates) {
@@ -235,8 +236,8 @@ int iwl_legacy_init_geos(struct iwl_priv *priv)
 
 			geo_ch->flags |= ch->ht40_extension_channel;
 
-			if (ch->max_power_avg > priv->tx_power_device_lmt)
-				priv->tx_power_device_lmt = ch->max_power_avg;
+			if (ch->max_power_avg > max_tx_power)
+				max_tx_power = ch->max_power_avg;
 		} else {
 			geo_ch->flags |= IEEE80211_CHAN_DISABLED;
 		}
@@ -249,6 +250,10 @@ int iwl_legacy_init_geos(struct iwl_priv *priv)
 				 geo_ch->flags);
 	}
 
+	priv->tx_power_device_lmt = max_tx_power;
+	priv->tx_power_user_lmt = max_tx_power;
+	priv->tx_power_next = max_tx_power;
+
 	if ((priv->bands[IEEE80211_BAND_5GHZ].n_channels == 0) &&
 	     priv->cfg->sku & IWL_SKU_A) {
 		IWL_INFO(priv, "Incorrectly detected BG card as ABG. "
@@ -1124,11 +1129,11 @@ int iwl_legacy_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
 	if (!priv->cfg->ops->lib->send_tx_power)
 		return -EOPNOTSUPP;
 
-	if (tx_power < IWL4965_TX_POWER_TARGET_POWER_MIN) {
+	/* 0 dBm mean 1 milliwatt */
+	if (tx_power < 0) {
 		IWL_WARN(priv,
-			 "Requested user TXPOWER %d below lower limit %d.\n",
-			 tx_power,
-			 IWL4965_TX_POWER_TARGET_POWER_MIN);
+			 "Requested user TXPOWER %d below 1 mW.\n",
+			 tx_power);
 		return -EINVAL;
 	}
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-eeprom.c b/drivers/net/wireless/iwlegacy/iwl-eeprom.c
index 04c5648..cb346d1 100644
--- a/drivers/net/wireless/iwlegacy/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlegacy/iwl-eeprom.c
@@ -471,13 +471,6 @@ int iwl_legacy_init_channel_map(struct iwl_priv *priv)
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
diff --git a/drivers/net/wireless/iwlegacy/iwl3945-base.c b/drivers/net/wireless/iwlegacy/iwl3945-base.c
index 28eb3d8..cc7ebce 100644
--- a/drivers/net/wireless/iwlegacy/iwl3945-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl3945-base.c
@@ -3825,10 +3825,6 @@ static int iwl3945_init_drv(struct iwl_priv *priv)
 	priv->force_reset[IWL_FW_RESET].reset_duration =
 		IWL_DELAY_NEXT_FORCE_FW_RELOAD;
 
-
-	priv->tx_power_user_lmt = IWL_DEFAULT_TX_POWER;
-	priv->tx_power_next = IWL_DEFAULT_TX_POWER;
-
 	if (eeprom->version < EEPROM_3945_EEPROM_VERSION) {
 		IWL_WARN(priv, "Unsupported EEPROM version: 0x%04X\n",
 			 eeprom->version);
diff --git a/drivers/net/wireless/iwlegacy/iwl4965-base.c b/drivers/net/wireless/iwlegacy/iwl4965-base.c
index 91b3d8b..d484c36 100644
--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
@@ -3140,12 +3140,6 @@ static int iwl4965_init_drv(struct iwl_priv *priv)
 
 	iwl_legacy_init_scan_params(priv);
 
-	/* Set the tx_power_user_lmt to the lowest power level
-	 * this value will get overwritten by channel max power avg
-	 * from eeprom */
-	priv->tx_power_user_lmt = IWL4965_TX_POWER_TARGET_POWER_MIN;
-	priv->tx_power_next = IWL4965_TX_POWER_TARGET_POWER_MIN;
-
 	ret = iwl_legacy_init_channel_map(priv);
 	if (ret) {
 		IWL_ERR(priv, "initializing regulatory failed: %d\n", ret);
-- 
1.7.1

