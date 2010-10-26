Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:19140 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758203Ab0JZOf3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 10:35:29 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 26 Oct 2010 07:35:18 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH] ath9k_htc: Handle monitor mode properly for HTC devices
Date: Tue, 26 Oct 2010 20:11:29 +0530
Message-ID: <1288104089-18888-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No need to inform about monitor interface changes to
firmware. Set the HW mode to monitor type based on mac80211
indication flag is sufficient.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   64 ++-----------------------
 1 files changed, 5 insertions(+), 59 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 9a3be8d..8b126cd 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -184,47 +184,6 @@ err:
 	return ret;
 }
 
-static int ath9k_htc_add_monitor_interface(struct ath9k_htc_priv *priv)
-{
-	struct ath_common *common = ath9k_hw_common(priv->ah);
-	struct ath9k_htc_target_vif hvif;
-	int ret = 0;
-	u8 cmd_rsp;
-
-	if (priv->nvifs > 0)
-		return -ENOBUFS;
-
-	memset(&hvif, 0, sizeof(struct ath9k_htc_target_vif));
-	memcpy(&hvif.myaddr, common->macaddr, ETH_ALEN);
-
-	hvif.opmode = cpu_to_be32(HTC_M_MONITOR);
-	priv->ah->opmode = NL80211_IFTYPE_MONITOR;
-	hvif.index = priv->nvifs;
-
-	WMI_CMD_BUF(WMI_VAP_CREATE_CMDID, &hvif);
-	if (ret)
-		return ret;
-
-	priv->nvifs++;
-	return 0;
-}
-
-static int ath9k_htc_remove_monitor_interface(struct ath9k_htc_priv *priv)
-{
-	struct ath_common *common = ath9k_hw_common(priv->ah);
-	struct ath9k_htc_target_vif hvif;
-	int ret = 0;
-	u8 cmd_rsp;
-
-	memset(&hvif, 0, sizeof(struct ath9k_htc_target_vif));
-	memcpy(&hvif.myaddr, common->macaddr, ETH_ALEN);
-	hvif.index = 0; /* Should do for now */
-	WMI_CMD_BUF(WMI_VAP_REMOVE_CMDID, &hvif);
-	priv->nvifs--;
-
-	return ret;
-}
-
 static int ath9k_htc_add_station(struct ath9k_htc_priv *priv,
 				 struct ieee80211_vif *vif,
 				 struct ieee80211_sta *sta)
@@ -1240,16 +1199,6 @@ static void ath9k_htc_stop(struct ieee80211_hw *hw)
 	WMI_CMD(WMI_STOP_RECV_CMDID);
 	skb_queue_purge(&priv->tx_queue);
 
-	/* Remove monitor interface here */
-	if (ah->opmode == NL80211_IFTYPE_MONITOR) {
-		if (ath9k_htc_remove_monitor_interface(priv))
-			ath_print(common, ATH_DBG_FATAL,
-				  "Unable to remove monitor interface\n");
-		else
-			ath_print(common, ATH_DBG_CONFIG,
-				  "Monitor interface removed\n");
-	}
-
 	if (ah->btcoex_hw.enabled) {
 		ath9k_hw_btcoex_disable(ah);
 		if (ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
@@ -1421,16 +1370,13 @@ static int ath9k_htc_config(struct ieee80211_hw *hw, u32 changed)
 		}
 	}
 
-	if (changed & IEEE80211_CONF_CHANGE_MONITOR) {
+	if (changed & IEEE80211_CONF_CHANGE_MONITOR)
 		if (conf->flags & IEEE80211_CONF_MONITOR) {
-			if (ath9k_htc_add_monitor_interface(priv))
-				ath_print(common, ATH_DBG_FATAL,
-					  "Failed to set monitor mode\n");
-			else
-				ath_print(common, ATH_DBG_CONFIG,
-					  "HW opmode set to Monitor mode\n");
+			ath_print(common, ATH_DBG_CONFIG,
+				  "HW opmode set to Monitor mode\n");
+			priv->ah->opmode = NL80211_IFTYPE_MONITOR;
 		}
-	}
+
 
 	if (changed & IEEE80211_CONF_CHANGE_IDLE) {
 		mutex_lock(&priv->htc_pm_lock);
-- 
1.7.3.2

