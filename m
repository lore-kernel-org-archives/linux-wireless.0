Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:14703 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755754Ab1AaSSv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 13:18:51 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 10:18:31 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 4/5] ath9k_htc: make use common of function to update txpower
Date: Mon, 31 Jan 2011 23:47:45 +0530
Message-ID: <1296497866-3189-4-git-send-email-rmanoharan@atheros.com>
In-Reply-To: <1296497866-3189-1-git-send-email-rmanoharan@atheros.com>
References: <1296497866-3189-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |    1 -
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c |    3 ++-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   23 ++++++++---------------
 3 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 6354986..0cb504d 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -460,7 +460,6 @@ void ath9k_htc_ps_restore(struct ath9k_htc_priv *priv);
 void ath9k_ps_work(struct work_struct *work);
 bool ath9k_htc_setpower(struct ath9k_htc_priv *priv,
 			enum ath9k_power_mode mode);
-void ath_update_txpow(struct ath9k_htc_priv *priv);
 
 void ath9k_start_rfkill_poll(struct ath9k_htc_priv *priv);
 void ath9k_htc_rfkill_poll_state(struct ieee80211_hw *hw);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
index fe70f67..7e630a8 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
@@ -389,7 +389,8 @@ void ath9k_htc_radio_enable(struct ieee80211_hw *hw)
 			ret, ah->curchan->channel);
 	}
 
-	ath_update_txpow(priv);
+	ath9k_cmn_update_txpow(ah, priv->curtxpow, priv->txpowlimit,
+			       &priv->curtxpow);
 
 	/* Start RX */
 	WMI_CMD(WMI_START_RECV_CMDID);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 0526c25..953036a 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -24,17 +24,6 @@ static struct dentry *ath9k_debugfs_root;
 /* Utilities */
 /*************/
 
-void ath_update_txpow(struct ath9k_htc_priv *priv)
-{
-	struct ath_hw *ah = priv->ah;
-
-	if (priv->curtxpow != priv->txpowlimit) {
-		ath9k_hw_set_txpowerlimit(ah, priv->txpowlimit, false);
-		/* read back in case value is clamped */
-		priv->curtxpow = ath9k_hw_regulatory(ah)->power_limit;
-	}
-}
-
 /* HACK Alert: Use 11NG for 2.4, use 11NA for 5 */
 static enum htc_phymode ath9k_htc_get_curmode(struct ath9k_htc_priv *priv,
 					      struct ath9k_channel *ichan)
@@ -147,7 +136,8 @@ void ath9k_htc_reset(struct ath9k_htc_priv *priv)
 			channel->center_freq, ret);
 	}
 
-	ath_update_txpow(priv);
+	ath9k_cmn_update_txpow(ah, priv->curtxpow, priv->txpowlimit,
+			       &priv->curtxpow);
 
 	WMI_CMD(WMI_START_RECV_CMDID);
 	ath9k_host_rx_init(priv);
@@ -212,7 +202,8 @@ static int ath9k_htc_set_channel(struct ath9k_htc_priv *priv,
 		goto err;
 	}
 
-	ath_update_txpow(priv);
+	ath9k_cmn_update_txpow(ah, priv->curtxpow, priv->txpowlimit,
+			       &priv->curtxpow);
 
 	WMI_CMD(WMI_START_RECV_CMDID);
 	if (ret)
@@ -988,7 +979,8 @@ static int ath9k_htc_start(struct ieee80211_hw *hw)
 		return ret;
 	}
 
-	ath_update_txpow(priv);
+	ath9k_cmn_update_txpow(ah, priv->curtxpow, priv->txpowlimit,
+			       &priv->curtxpow);
 
 	mode = ath9k_htc_get_curmode(priv, init_channel);
 	htc_mode = cpu_to_be16(mode);
@@ -1254,7 +1246,8 @@ static int ath9k_htc_config(struct ieee80211_hw *hw, u32 changed)
 
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
 		priv->txpowlimit = 2 * conf->power_level;
-		ath_update_txpow(priv);
+		ath9k_cmn_update_txpow(priv->ah, priv->curtxpow,
+				       priv->txpowlimit, &priv->curtxpow);
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_IDLE) {
-- 
1.7.3.5

