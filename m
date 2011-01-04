Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53576 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab1ADTgh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 14:36:37 -0500
Received: by iyi12 with SMTP id 12so13271425iyi.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Jan 2011 11:36:37 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19747.30389.751676.478131@gargle.gargle.HOWL>
Date: Wed, 5 Jan 2011 01:06:21 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: [PATCH] ath9k_htc: Really fix packet injection
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

The chainmask value along with other configuration has to be set
on the target for packet injection. Fix this and also move the monitor
interface addition before the channel set segment to ensure that
the opmode is updated properly.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |    1 +
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   37 +++++++++++++++++-------
 2 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index a099b3e..1ce506f 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -433,6 +433,7 @@ void ath9k_htc_txep(void *priv, struct sk_buff *skb, enum htc_endpoint_id ep_id,
 void ath9k_htc_beaconep(void *drv_priv, struct sk_buff *skb,
 			enum htc_endpoint_id ep_id, bool txok);
 
+int ath9k_htc_update_cap_target(struct ath9k_htc_priv *priv);
 void ath9k_htc_station_work(struct work_struct *work);
 void ath9k_htc_aggr_work(struct work_struct *work);
 void ath9k_ani_work(struct work_struct *work);;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 845b4c9..f4d576b 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -301,6 +301,16 @@ static int ath9k_htc_add_monitor_interface(struct ath9k_htc_priv *priv)
 
 	priv->nstations++;
 
+	/*
+	 * Set chainmask etc. on the target.
+	 */
+	ret = ath9k_htc_update_cap_target(priv);
+	if (ret)
+		ath_dbg(common, ATH_DBG_CONFIG,
+			"Failed to update capability in target\n");
+
+	priv->ah->is_monitoring = true;
+
 	return 0;
 
 err_vif:
@@ -328,6 +338,7 @@ static int ath9k_htc_remove_monitor_interface(struct ath9k_htc_priv *priv)
 	}
 
 	priv->nstations--;
+	priv->ah->is_monitoring = false;
 
 	return 0;
 }
@@ -419,7 +430,7 @@ static int ath9k_htc_remove_station(struct ath9k_htc_priv *priv,
 	return 0;
 }
 
-static int ath9k_htc_update_cap_target(struct ath9k_htc_priv *priv)
+int ath9k_htc_update_cap_target(struct ath9k_htc_priv *priv)
 {
 	struct ath9k_htc_cap_target tcap;
 	int ret;
@@ -1186,6 +1197,20 @@ static int ath9k_htc_config(struct ieee80211_hw *hw, u32 changed)
 		}
 	}
 
+	/*
+	 * Monitor interface should be added before
+	 * IEEE80211_CONF_CHANGE_CHANNEL is handled.
+	 */
+	if (changed & IEEE80211_CONF_CHANGE_MONITOR) {
+		if (conf->flags & IEEE80211_CONF_MONITOR) {
+			if (ath9k_htc_add_monitor_interface(priv))
+				ath_err(common, "Failed to set monitor mode\n");
+			else
+				ath_dbg(common, ATH_DBG_CONFIG,
+					"HW opmode set to Monitor mode\n");
+		}
+	}
+
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
 		struct ieee80211_channel *curchan = hw->conf.channel;
 		int pos = curchan->hw_value;
@@ -1221,16 +1246,6 @@ static int ath9k_htc_config(struct ieee80211_hw *hw, u32 changed)
 		ath_update_txpow(priv);
 	}
 
-	if (changed & IEEE80211_CONF_CHANGE_MONITOR) {
-		if (conf->flags & IEEE80211_CONF_MONITOR) {
-			if (ath9k_htc_add_monitor_interface(priv))
-				ath_err(common, "Failed to set monitor mode\n");
-			else
-				ath_dbg(common, ATH_DBG_CONFIG,
-					"HW opmode set to Monitor mode\n");
-		}
-	}
-
 	if (changed & IEEE80211_CONF_CHANGE_IDLE) {
 		mutex_lock(&priv->htc_pm_lock);
 		if (!priv->ps_idle) {
-- 
1.7.3.4

