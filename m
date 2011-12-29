Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:52297 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab1L2Mrp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Dec 2011 07:47:45 -0500
Received: by qcqz2 with SMTP id z2so7865482qcq.19
        for <linux-wireless@vger.kernel.org>; Thu, 29 Dec 2011 04:47:44 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] wl12xx: implement sta_state callback
Date: Thu, 29 Dec 2011 14:49:18 +0200
Message-Id: <1325162958-8515-1-git-send-email-eliad@wizery.com> (sfid-20111229_134748_472920_12CA0DE5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update the fw regarding peer state and ht caps
only after the station was authorized.

Otherwise, the fw might try establishing BA session
before the sta is authorized.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
depends on "notify driver about changes in station state" patchset

v2: wait for sta_state() callbacks, rather than checking the state
    on sta_add()

 drivers/net/wireless/wl12xx/main.c |   67 +++++++++++++++++++++++++++++------
 1 files changed, 55 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 70f636f..dd81e30 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -4369,6 +4369,29 @@ void wl1271_free_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 hlid)
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
+	wl_sta = (struct wl1271_station *)sta->drv_priv;
+	hlid = wl_sta->hlid;
+
+	if (state == IEEE80211_STA_AUTHORIZED) {
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
@@ -4401,24 +4424,12 @@ static int wl1271_op_sta_add(struct ieee80211_hw *hw,
 		goto out_free_sta;
 
 	ret = wl12xx_cmd_add_peer(wl, wlvif, sta, hlid);
-	if (ret < 0)
-		goto out_sleep;
-
-	ret = wl12xx_cmd_set_peer_state(wl, hlid);
-	if (ret < 0)
-		goto out_sleep;
 
-	ret = wl1271_acx_set_ht_capabilities(wl, &sta->ht_cap, true, hlid);
-	if (ret < 0)
-		goto out_sleep;
-
-out_sleep:
 	wl1271_ps_elp_sleep(wl);
 
 out_free_sta:
 	if (ret < 0)
 		wl1271_free_sta(wl, wlvif, hlid);
-
 out:
 	mutex_unlock(&wl->mutex);
 	return ret;
@@ -4466,6 +4477,37 @@ out:
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
+	wl1271_debug(DEBUG_MAC80211, "mac80211 sta %d state=%d",
+		     sta->aid, state);
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
@@ -4931,6 +4973,7 @@ static const struct ieee80211_ops wl1271_ops = {
 	.get_survey = wl1271_op_get_survey,
 	.sta_add = wl1271_op_sta_add,
 	.sta_remove = wl1271_op_sta_remove,
+	.sta_state = wl12xx_op_sta_state,
 	.ampdu_action = wl1271_op_ampdu_action,
 	.tx_frames_pending = wl1271_tx_frames_pending,
 	.set_bitrate_mask = wl12xx_set_bitrate_mask,
-- 
1.7.6.401.g6a319

