Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:37743 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751562AbdH3Jn5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 05:43:57 -0400
Received: by mail-pf0-f195.google.com with SMTP id a2so4003332pfj.4
        for <linux-wireless@vger.kernel.org>; Wed, 30 Aug 2017 02:43:57 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 8/8] rsi: miscellaneous changes for p2p mode
Date: Wed, 30 Aug 2017 15:08:28 +0530
Message-Id: <1504085908-2163-9-git-send-email-amitkarwar@gmail.com> (sfid-20170830_114413_412704_51943743)
In-Reply-To: <1504085908-2163-1-git-send-email-amitkarwar@gmail.com>
References: <1504085908-2163-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

Add P2P_GO condition as well when handling BEACON_ENABLE
from mac80211. Also passing 'vif' for auto rate request.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 15 +++++++++------
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     |  6 +++---
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 79426a2..b1f5dbb 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -756,7 +756,8 @@ static void rsi_mac80211_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if ((changed & BSS_CHANGED_BEACON_ENABLED) &&
-	    (vif->type == NL80211_IFTYPE_AP)) {
+	    ((vif->type == NL80211_IFTYPE_AP) ||
+	     (vif->type == NL80211_IFTYPE_P2P_GO))) {
 		if (bss->enable_beacon) {
 			rsi_dbg(INFO_ZONE, "===> BEACON ENABLED <===\n");
 			common->beacon_enabled = 1;
@@ -1147,9 +1148,9 @@ static int rsi_mac80211_set_rate_mask(struct ieee80211_hw *hw,
  */
 static void rsi_perform_cqm(struct rsi_common *common,
 			    u8 *bssid,
-			    s8 rssi)
+			    s8 rssi,
+			    struct ieee80211_vif *vif)
 {
-	struct rsi_hw *adapter = common->priv;
 	s8 last_event = common->cqm_info.last_cqm_event_rssi;
 	int thold = common->cqm_info.rssi_thold;
 	u32 hyst = common->cqm_info.rssi_hyst;
@@ -1165,7 +1166,7 @@ static void rsi_perform_cqm(struct rsi_common *common,
 
 	common->cqm_info.last_cqm_event_rssi = rssi;
 	rsi_dbg(INFO_ZONE, "CQM: Notifying event: %d\n", event);
-	ieee80211_cqm_rssi_notify(adapter->vifs[0], event, rssi, GFP_KERNEL);
+	ieee80211_cqm_rssi_notify(vif, event, rssi, GFP_KERNEL);
 
 	return;
 }
@@ -1228,15 +1229,17 @@ static void rsi_fill_rx_status(struct ieee80211_hw *hw,
 		vif = adapter->vifs[i];
 		if (!vif)
 			continue;
-		if (vif->type == NL80211_IFTYPE_STATION)
+		if (vif->type == NL80211_IFTYPE_STATION) {
 			bss = &vif->bss_conf;
+			break;
+		}
 	}
 	if (!bss)
 		return;
 	/* CQM only for connected AP beacons, the RSSI is a weighted avg */
 	if (bss->assoc && !(memcmp(bss->bssid, hdr->addr2, ETH_ALEN))) {
 		if (ieee80211_is_beacon(hdr->frame_control))
-			rsi_perform_cqm(common, hdr->addr2, rxs->signal);
+			rsi_perform_cqm(common, hdr->addr2, rxs->signal, vif);
 	}
 
 	return;
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 383cd43..4b94190 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -1160,9 +1160,9 @@ static bool rsi_map_rates(u16 rate, int *offset)
  */
 static int rsi_send_auto_rate_request(struct rsi_common *common,
 				      struct ieee80211_sta *sta,
-				      u16 sta_id)
+				      u16 sta_id,
+				      struct ieee80211_vif *vif)
 {
-	struct ieee80211_vif *vif = common->priv->vifs[0];
 	struct sk_buff *skb;
 	struct rsi_auto_rate *auto_rate;
 	int ii = 0, jj = 0, kk = 0;
@@ -1332,7 +1332,7 @@ void rsi_inform_bss_status(struct rsi_common *common,
 					      aid, sta_id,
 					      vif);
 		if (common->min_rate == 0xffff)
-			rsi_send_auto_rate_request(common, sta, sta_id);
+			rsi_send_auto_rate_request(common, sta, sta_id, vif);
 		if (opmode == RSI_OPMODE_STA) {
 			if (!rsi_send_block_unblock_frame(common, false))
 				common->hw_data_qs_blocked = false;
-- 
2.7.4
