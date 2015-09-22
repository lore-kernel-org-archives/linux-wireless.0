Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:57055 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757877AbbIVOYi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 10:24:38 -0400
From: Oleksij Rempel <linux@rempel-privat.de>
To: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH] ath9k_htc: use ether_addr_copy() instead of memcpy()
Date: Tue, 22 Sep 2015 16:24:26 +0200
Message-Id: <1442931866-17115-1-git-send-email-linux@rempel-privat.de> (sfid-20150922_162448_784620_B0DA6309)
In-Reply-To: <87lhbylifx.fsf@kamboji.qca.qualcomm.com>
References: <87lhbylifx.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |  2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c | 24 ++++++++++++------------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 1e84882..254a1e4 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -587,7 +587,7 @@ static void ath9k_init_misc(struct ath9k_htc_priv *priv)
 {
 	struct ath_common *common = ath9k_hw_common(priv->ah);
 
-	memcpy(common->bssidmask, ath_bcast_mac, ETH_ALEN);
+	ether_addr_copy(common->bssidmask, ath_bcast_mac);
 
 	common->last_rssi = ATH_RSSI_DUMMY_MARKER;
 	priv->ah->opmode = NL80211_IFTYPE_STATION;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 172a9ff..e6b13ed 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -159,10 +159,10 @@ static void ath9k_htc_set_mac_bssid_mask(struct ath9k_htc_priv *priv,
 		priv->hw, IEEE80211_IFACE_ITER_RESUME_ALL,
 		ath9k_htc_bssid_iter, &iter_data);
 
-	memcpy(common->bssidmask, iter_data.mask, ETH_ALEN);
+	ether_addr_copy(common->bssidmask, iter_data.mask);
 
 	if (iter_data.hw_macaddr)
-		memcpy(common->macaddr, iter_data.hw_macaddr, ETH_ALEN);
+		ether_addr_copy(common->macaddr, iter_data.hw_macaddr);
 
 	ath_hw_setbssidmask(common);
 }
@@ -338,7 +338,7 @@ static void __ath9k_htc_remove_monitor_interface(struct ath9k_htc_priv *priv)
 	u8 cmd_rsp;
 
 	memset(&hvif, 0, sizeof(struct ath9k_htc_target_vif));
-	memcpy(&hvif.myaddr, common->macaddr, ETH_ALEN);
+	ether_addr_copy(hvif.myaddr, common->macaddr);
 	hvif.index = priv->mon_vif_idx;
 	WMI_CMD_BUF(WMI_VAP_REMOVE_CMDID, &hvif);
 	if (ret) {
@@ -374,7 +374,7 @@ static int ath9k_htc_add_monitor_interface(struct ath9k_htc_priv *priv)
 	 * Add an interface.
 	 */
 	memset(&hvif, 0, sizeof(struct ath9k_htc_target_vif));
-	memcpy(&hvif.myaddr, common->macaddr, ETH_ALEN);
+	ether_addr_copy(hvif.myaddr, common->macaddr);
 
 	hvif.opmode = HTC_M_MONITOR;
 	hvif.index = ffz(priv->vif_slot);
@@ -404,7 +404,7 @@ static int ath9k_htc_add_monitor_interface(struct ath9k_htc_priv *priv)
 	 */
 	memset(&tsta, 0, sizeof(struct ath9k_htc_target_sta));
 
-	memcpy(&tsta.macaddr, common->macaddr, ETH_ALEN);
+	ether_addr_copy(tsta.macaddr, common->macaddr);
 
 	tsta.is_vif_sta = 1;
 	tsta.sta_index = sta_idx;
@@ -489,15 +489,15 @@ static int ath9k_htc_add_station(struct ath9k_htc_priv *priv,
 
 	if (sta) {
 		ista = (struct ath9k_htc_sta *) sta->drv_priv;
-		memcpy(&tsta.macaddr, sta->addr, ETH_ALEN);
-		memcpy(&tsta.bssid, common->curbssid, ETH_ALEN);
+		ether_addr_copy(tsta.macaddr, sta->addr);
+		ether_addr_copy(tsta.bssid, common->curbssid);
 		ista->index = sta_idx;
 		tsta.is_vif_sta = 0;
 		maxampdu = 1 << (IEEE80211_HT_MAX_AMPDU_FACTOR +
 				 sta->ht_cap.ampdu_factor);
 		tsta.maxampdu = cpu_to_be16(maxampdu);
 	} else {
-		memcpy(&tsta.macaddr, vif->addr, ETH_ALEN);
+		ether_addr_copy(tsta.macaddr, vif->addr);
 		tsta.is_vif_sta = 1;
 		tsta.maxampdu = cpu_to_be16(0xffff);
 	}
@@ -1048,7 +1048,7 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 
 	ath9k_htc_ps_wakeup(priv);
 	memset(&hvif, 0, sizeof(struct ath9k_htc_target_vif));
-	memcpy(&hvif.myaddr, vif->addr, ETH_ALEN);
+	ether_addr_copy(hvif.myaddr, vif->addr);
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
@@ -1131,7 +1131,7 @@ static void ath9k_htc_remove_interface(struct ieee80211_hw *hw,
 	ath9k_htc_ps_wakeup(priv);
 
 	memset(&hvif, 0, sizeof(struct ath9k_htc_target_vif));
-	memcpy(&hvif.myaddr, vif->addr, ETH_ALEN);
+	ether_addr_copy(hvif.myaddr, vif->addr);
 	hvif.index = avp->index;
 	WMI_CMD_BUF(WMI_VAP_REMOVE_CMDID, &hvif);
 	if (ret) {
@@ -1493,7 +1493,7 @@ static void ath9k_htc_bss_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 	if ((vif->type == NL80211_IFTYPE_STATION) && bss_conf->assoc) {
 		common->curaid = bss_conf->aid;
 		common->last_rssi = ATH_RSSI_DUMMY_MARKER;
-		memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
+		ether_addr_copy(common->curbssid, bss_conf->bssid);
 		set_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags);
 	}
 }
@@ -1543,7 +1543,7 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
 	if (changed & BSS_CHANGED_IBSS) {
 		if (priv->ah->opmode == NL80211_IFTYPE_ADHOC) {
 			common->curaid = bss_conf->aid;
-			memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
+			ether_addr_copy(common->curbssid, bss_conf->bssid);
 			ath9k_htc_set_bssid(priv);
 		}
 	}
-- 
2.5.0

