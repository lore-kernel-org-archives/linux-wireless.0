Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:44588 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754264Ab0KZRzO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Nov 2010 12:55:14 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 26 Nov 2010 09:55:00 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 3/3] Revert "ath9k_htc: Handle monitor mode properly for HTC devices"
Date: Fri, 26 Nov 2010 23:24:33 +0530
Message-ID: <1290794073-5309-3-git-send-email-rmanoharan@atheros.com>
In-Reply-To: <1290794073-5309-1-git-send-email-rmanoharan@atheros.com>
References: <1290794073-5309-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit 446fad5a5b6be765c8ec39bfdbbc6c7aa63fbcbb.

The change had broken the packet injection on monitoring mode.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   64 +++++++++++++++++++++++--
 1 files changed, 59 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index e9761c2..8266ce1 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -184,6 +184,47 @@ err:
 	return ret;
 }
 
+static int ath9k_htc_add_monitor_interface(struct ath9k_htc_priv *priv)
+{
+	struct ath_common *common = ath9k_hw_common(priv->ah);
+	struct ath9k_htc_target_vif hvif;
+	int ret = 0;
+	u8 cmd_rsp;
+
+	if (priv->nvifs > 0)
+		return -ENOBUFS;
+
+	memset(&hvif, 0, sizeof(struct ath9k_htc_target_vif));
+	memcpy(&hvif.myaddr, common->macaddr, ETH_ALEN);
+
+	hvif.opmode = cpu_to_be32(HTC_M_MONITOR);
+	priv->ah->opmode = NL80211_IFTYPE_MONITOR;
+	hvif.index = priv->nvifs;
+
+	WMI_CMD_BUF(WMI_VAP_CREATE_CMDID, &hvif);
+	if (ret)
+		return ret;
+
+	priv->nvifs++;
+	return 0;
+}
+
+static int ath9k_htc_remove_monitor_interface(struct ath9k_htc_priv *priv)
+{
+	struct ath_common *common = ath9k_hw_common(priv->ah);
+	struct ath9k_htc_target_vif hvif;
+	int ret = 0;
+	u8 cmd_rsp;
+
+	memset(&hvif, 0, sizeof(struct ath9k_htc_target_vif));
+	memcpy(&hvif.myaddr, common->macaddr, ETH_ALEN);
+	hvif.index = 0; /* Should do for now */
+	WMI_CMD_BUF(WMI_VAP_REMOVE_CMDID, &hvif);
+	priv->nvifs--;
+
+	return ret;
+}
+
 static int ath9k_htc_add_station(struct ath9k_htc_priv *priv,
 				 struct ieee80211_vif *vif,
 				 struct ieee80211_sta *sta)
@@ -1199,6 +1240,16 @@ static void ath9k_htc_stop(struct ieee80211_hw *hw)
 	WMI_CMD(WMI_STOP_RECV_CMDID);
 	skb_queue_purge(&priv->tx_queue);
 
+	/* Remove monitor interface here */
+	if (ah->opmode == NL80211_IFTYPE_MONITOR) {
+		if (ath9k_htc_remove_monitor_interface(priv))
+			ath_print(common, ATH_DBG_FATAL,
+				  "Unable to remove monitor interface\n");
+		else
+			ath_print(common, ATH_DBG_CONFIG,
+				  "Monitor interface removed\n");
+	}
+
 	if (ah->btcoex_hw.enabled) {
 		ath9k_hw_btcoex_disable(ah);
 		if (ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
@@ -1372,13 +1423,16 @@ static int ath9k_htc_config(struct ieee80211_hw *hw, u32 changed)
 		}
 	}
 
-	if (changed & IEEE80211_CONF_CHANGE_MONITOR)
+	if (changed & IEEE80211_CONF_CHANGE_MONITOR) {
 		if (conf->flags & IEEE80211_CONF_MONITOR) {
-			ath_print(common, ATH_DBG_CONFIG,
-				  "HW opmode set to Monitor mode\n");
-			priv->ah->opmode = NL80211_IFTYPE_MONITOR;
+			if (ath9k_htc_add_monitor_interface(priv))
+				ath_print(common, ATH_DBG_FATAL,
+					  "Failed to set monitor mode\n");
+			else
+				ath_print(common, ATH_DBG_CONFIG,
+					  "HW opmode set to Monitor mode\n");
 		}
-
+	}
 
 	if (changed & IEEE80211_CONF_CHANGE_IDLE) {
 		mutex_lock(&priv->htc_pm_lock);
-- 
1.7.3.2

