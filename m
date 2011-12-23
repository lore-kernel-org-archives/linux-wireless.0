Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:59857 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915Ab1LWMZi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Dec 2011 07:25:38 -0500
Received: by wibhm6 with SMTP id hm6so3121641wib.19
        for <linux-wireless@vger.kernel.org>; Fri, 23 Dec 2011 04:25:37 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: implement sta_state callback
Date: Fri, 23 Dec 2011 14:26:51 +0200
Message-Id: <1324643211-29498-1-git-send-email-eliad@wizery.com> (sfid-20111223_132540_746532_07645AC9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update the fw regarding peer state and ht caps
only after the station was authorized.

Otherwise, the fw might try establishing BA session
before the sta is authorized.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
depends on the "notify driver about changes in station
state" patchset.

 drivers/net/wireless/wl12xx/main.c |   70 +++++++++++++++++++++++++++++++----
 1 files changed, 62 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index d5f55a1..19747c4 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -4092,6 +4092,32 @@ void wl1271_free_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 hlid)
 	wl->active_sta_count--;
 }
 
+static void wl12xx_update_sta_state(struct wl1271 *wl,
+				    struct ieee80211_sta *sta,
+				    enum ieee80211_sta_state state)
+{
+	struct wl1271_station *wl_sta;
+	u8 hlid;
+	int ret;
+
+	wl1271_debug(DEBUG_MAC80211, "update sta state 0x%p state=%d",
+		     sta, state);
+
+	wl_sta = (struct wl1271_station *)sta->drv_priv;
+	hlid = wl_sta->hlid;
+
+	if (sta->state == IEEE80211_STA_AUTHORIZED) {
+		ret = wl12xx_cmd_set_peer_state(wl, hlid);
+		if (ret < 0)
+			return;
+
+		ret = wl1271_acx_set_ht_capabilities(wl, &sta->ht_cap, true,
+						     hlid);
+		if (ret < 0)
+			return;
+	}
+}
+
 static int wl1271_op_sta_add(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif,
 			     struct ieee80211_sta *sta)
@@ -4099,6 +4125,7 @@ static int wl1271_op_sta_add(struct ieee80211_hw *hw,
 	struct wl1271 *wl = hw->priv;
 	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	struct wl1271_station *wl_sta;
+	enum ieee80211_sta_state state;
 	int ret = 0;
 	u8 hlid;
 
@@ -4127,14 +4154,9 @@ static int wl1271_op_sta_add(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out_sleep;
 
-	ret = wl12xx_cmd_set_peer_state(wl, hlid);
-	if (ret < 0)
-		goto out_sleep;
-
-	ret = wl1271_acx_set_ht_capabilities(wl, &sta->ht_cap, true, hlid);
-	if (ret < 0)
-		goto out_sleep;
-
+	state = IEEE80211_STA_NONE;
+	while (state < sta->state)
+		wl12xx_update_sta_state(wl, sta, ++state);
 out_sleep:
 	wl1271_ps_elp_sleep(wl);
 
@@ -4189,6 +4211,37 @@ out:
 	return ret;
 }
 
+static void wl12xx_op_sta_state(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				struct ieee80211_sta *sta,
+				enum ieee80211_sta_state state)
+{
+	struct wl1271 *wl = hw->priv;
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
+	int ret;
+
+	wl1271_debug(DEBUG_MAC80211, "mac80211 sta state 0x%p state=%d",
+		     sta, state);
+
+	mutex_lock(&wl->mutex);
+
+	if (unlikely(wl->state == WL1271_STATE_OFF))
+		goto out;
+
+	if (wlvif->bss_type != BSS_TYPE_AP_BSS)
+		goto out;
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	wl12xx_update_sta_state(wl, sta, state);
+
+	wl1271_ps_elp_sleep(wl);
+out:
+	mutex_unlock(&wl->mutex);
+}
+
 static int wl1271_op_ampdu_action(struct ieee80211_hw *hw,
 				  struct ieee80211_vif *vif,
 				  enum ieee80211_ampdu_mlme_action action,
@@ -4652,6 +4705,7 @@ static const struct ieee80211_ops wl1271_ops = {
 	.get_survey = wl1271_op_get_survey,
 	.sta_add = wl1271_op_sta_add,
 	.sta_remove = wl1271_op_sta_remove,
+	.sta_state = wl12xx_op_sta_state,
 	.ampdu_action = wl1271_op_ampdu_action,
 	.tx_frames_pending = wl1271_tx_frames_pending,
 	.set_bitrate_mask = wl12xx_set_bitrate_mask,
-- 
1.7.6.401.g6a319

