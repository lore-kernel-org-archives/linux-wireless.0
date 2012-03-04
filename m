Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:40715 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842Ab2CDIzw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 03:55:52 -0500
Received: by wibhm2 with SMTP id hm2so1368116wib.19
        for <linux-wireless@vger.kernel.org>; Sun, 04 Mar 2012 00:55:51 -0800 (PST)
MIME-Version: 1.0
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 03/11] wl12xx: implement sta_state callback
Date: Sun,  4 Mar 2012 10:55:47 +0200
Message-Id: <1330851355-24459-4-git-send-email-eliad@wizery.com> (sfid-20120304_095638_797514_6E5626C0)
In-Reply-To: <1330851355-24459-1-git-send-email-eliad@wizery.com>
References: <1330851355-24459-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement sta_state callback instead of the
sta_add/remove callbacks.

Update the fw regarding peer state and ht caps
only after the station was authorized. Otherwise,
the fw might try establishing BA session before
the sta is authorized.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |  137 +++++++++++++++++++++--------------
 1 files changed, 82 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index b771106..8569ac3 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -4233,100 +4233,128 @@ void wl1271_free_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 hlid)
 	wl->active_sta_count--;
 }
 
-static int wl1271_op_sta_add(struct ieee80211_hw *hw,
-			     struct ieee80211_vif *vif,
-			     struct ieee80211_sta *sta)
+static int wl12xx_sta_add(struct wl1271 *wl,
+			  struct wl12xx_vif *wlvif,
+			  struct ieee80211_sta *sta)
 {
-	struct wl1271 *wl = hw->priv;
-	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	struct wl1271_station *wl_sta;
 	int ret = 0;
 	u8 hlid;
 
-	mutex_lock(&wl->mutex);
-
-	if (unlikely(wl->state == WL1271_STATE_OFF))
-		goto out;
-
-	if (wlvif->bss_type != BSS_TYPE_AP_BSS)
-		goto out;
-
 	wl1271_debug(DEBUG_MAC80211, "mac80211 add sta %d", (int)sta->aid);
 
 	ret = wl1271_allocate_sta(wl, wlvif, sta);
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	wl_sta = (struct wl1271_station *)sta->drv_priv;
 	hlid = wl_sta->hlid;
 
-	ret = wl1271_ps_elp_wakeup(wl);
-	if (ret < 0)
-		goto out_free_sta;
-
 	ret = wl12xx_cmd_add_peer(wl, wlvif, sta, hlid);
 	if (ret < 0)
-		goto out_sleep;
+		wl1271_free_sta(wl, wlvif, hlid);
 
-	ret = wl12xx_cmd_set_peer_state(wl, hlid);
-	if (ret < 0)
-		goto out_sleep;
+	return ret;
+}
 
-	ret = wl1271_acx_set_ht_capabilities(wl, &sta->ht_cap, true, hlid);
-	if (ret < 0)
-		goto out_sleep;
+static int wl12xx_sta_remove(struct wl1271 *wl,
+			     struct wl12xx_vif *wlvif,
+			     struct ieee80211_sta *sta)
+{
+	struct wl1271_station *wl_sta;
+	int ret = 0, id;
 
-out_sleep:
-	wl1271_ps_elp_sleep(wl);
+	wl1271_debug(DEBUG_MAC80211, "mac80211 remove sta %d", (int)sta->aid);
+
+	wl_sta = (struct wl1271_station *)sta->drv_priv;
+	id = wl_sta->hlid;
+	if (WARN_ON(!test_bit(id, wlvif->ap.sta_hlid_map)))
+		return -EINVAL;
 
-out_free_sta:
+	ret = wl12xx_cmd_remove_peer(wl, wl_sta->hlid);
 	if (ret < 0)
-		wl1271_free_sta(wl, wlvif, hlid);
+		return ret;
 
-out:
-	mutex_unlock(&wl->mutex);
+	wl1271_free_sta(wl, wlvif, wl_sta->hlid);
 	return ret;
 }
 
-static int wl1271_op_sta_remove(struct ieee80211_hw *hw,
-				struct ieee80211_vif *vif,
-				struct ieee80211_sta *sta)
+static int wl12xx_update_sta_state(struct wl1271 *wl,
+				   struct wl12xx_vif *wlvif,
+				   struct ieee80211_sta *sta,
+				   enum ieee80211_sta_state old_state,
+				   enum ieee80211_sta_state new_state)
 {
-	struct wl1271 *wl = hw->priv;
-	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	struct wl1271_station *wl_sta;
-	int ret = 0, id;
+	u8 hlid;
+	bool is_ap = wlvif->bss_type == BSS_TYPE_AP_BSS;
+	bool is_sta = wlvif->bss_type == BSS_TYPE_STA_BSS;
+	int ret;
 
-	mutex_lock(&wl->mutex);
+	wl_sta = (struct wl1271_station *)sta->drv_priv;
+	hlid = wl_sta->hlid;
 
-	if (unlikely(wl->state == WL1271_STATE_OFF))
-		goto out;
+	/* Add station (AP mode) */
+	if (is_ap &&
+	    old_state == IEEE80211_STA_NOTEXIST &&
+	    new_state == IEEE80211_STA_NONE)
+		return wl12xx_sta_add(wl, wlvif, sta);
+
+	/* Remove station (AP mode) */
+	if (is_ap &&
+	    old_state == IEEE80211_STA_NONE &&
+	    new_state == IEEE80211_STA_NOTEXIST) {
+		/* must not fail */
+		wl12xx_sta_remove(wl, wlvif, sta);
+		return 0;
+	}
 
-	if (wlvif->bss_type != BSS_TYPE_AP_BSS)
-		goto out;
+	/* Authorize station (AP mode) */
+	if (is_ap &&
+	    new_state == IEEE80211_STA_AUTHORIZED) {
+		ret = wl12xx_cmd_set_peer_state(wl, hlid);
+		if (ret < 0)
+			return ret;
 
-	wl1271_debug(DEBUG_MAC80211, "mac80211 remove sta %d", (int)sta->aid);
+		ret = wl1271_acx_set_ht_capabilities(wl, &sta->ht_cap, true,
+						     hlid);
+		return ret;
+	}
 
-	wl_sta = (struct wl1271_station *)sta->drv_priv;
-	id = wl_sta->hlid;
-	if (WARN_ON(!test_bit(id, wlvif->ap.sta_hlid_map)))
+	return 0;
+}
+
+static int wl12xx_op_sta_state(struct ieee80211_hw *hw,
+			       struct ieee80211_vif *vif,
+			       struct ieee80211_sta *sta,
+			       enum ieee80211_sta_state old_state,
+			       enum ieee80211_sta_state new_state)
+{
+	struct wl1271 *wl = hw->priv;
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
+	int ret;
+
+	wl1271_debug(DEBUG_MAC80211, "mac80211 sta %d state=%d->%d",
+		     sta->aid, old_state, new_state);
+
+	mutex_lock(&wl->mutex);
+
+	if (unlikely(wl->state == WL1271_STATE_OFF)) {
+		ret = -EBUSY;
 		goto out;
+	}
 
 	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out;
 
-	ret = wl12xx_cmd_remove_peer(wl, wl_sta->hlid);
-	if (ret < 0)
-		goto out_sleep;
+	ret = wl12xx_update_sta_state(wl, wlvif, sta, old_state, new_state);
 
-	wl1271_free_sta(wl, wlvif, wl_sta->hlid);
-
-out_sleep:
 	wl1271_ps_elp_sleep(wl);
-
 out:
 	mutex_unlock(&wl->mutex);
+	if (new_state < old_state)
+		return 0;
 	return ret;
 }
 
@@ -4795,8 +4823,7 @@ static const struct ieee80211_ops wl1271_ops = {
 	.conf_tx = wl1271_op_conf_tx,
 	.get_tsf = wl1271_op_get_tsf,
 	.get_survey = wl1271_op_get_survey,
-	.sta_add = wl1271_op_sta_add,
-	.sta_remove = wl1271_op_sta_remove,
+	.sta_state = wl12xx_op_sta_state,
 	.ampdu_action = wl1271_op_ampdu_action,
 	.tx_frames_pending = wl1271_tx_frames_pending,
 	.set_bitrate_mask = wl12xx_set_bitrate_mask,
-- 
1.7.6.401.g6a319

