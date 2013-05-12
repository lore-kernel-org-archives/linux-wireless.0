Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:33881 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab3ELJfl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 May 2013 05:35:41 -0400
Received: by mail-wg0-f48.google.com with SMTP id f11so5397980wgh.27
        for <linux-wireless@vger.kernel.org>; Sun, 12 May 2013 02:35:40 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/4] wlcore: set default_wep_key when configured
Date: Sun, 12 May 2013 12:35:28 +0300
Message-Id: <1368351331-6914-1-git-send-email-eliad@wizery.com> (sfid-20130512_113548_797348_AA5B053C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yoni Divinsky <yoni.divinsky@ti.com>

When associating to an AP with WEP set the
default key upon association by implementing
the set_deafult_key_idx op.

Fixes auto-arp sent with wrong key_idx bug.

Signed-off-by: Yoni Divinsky <yoni.divinsky@ti.com>
Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 49 +++++++++++++++++++++++++++++------
 drivers/net/wireless/ti/wlcore/tx.c   |  2 +-
 2 files changed, 42 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index a018221..c384bad 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -3196,14 +3196,6 @@ static int wl1271_set_key(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		if (ret < 0)
 			return ret;
 
-		/* the default WEP key needs to be configured at least once */
-		if (key_type == KEY_WEP) {
-			ret = wl12xx_cmd_set_default_wep_key(wl,
-							wlvif->default_key,
-							wlvif->sta.hlid);
-			if (ret < 0)
-				return ret;
-		}
 	}
 
 	return 0;
@@ -3360,6 +3352,46 @@ int wlcore_set_key(struct wl1271 *wl, enum set_key_cmd cmd,
 }
 EXPORT_SYMBOL_GPL(wlcore_set_key);
 
+static void wl1271_op_set_default_key_idx(struct ieee80211_hw *hw,
+					  struct ieee80211_vif *vif,
+					  int key_idx)
+{
+	struct wl1271 *wl = hw->priv;
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
+	int ret;
+
+	wl1271_debug(DEBUG_MAC80211, "mac80211 set default key idx %d",
+		     key_idx);
+
+	mutex_lock(&wl->mutex);
+
+	if (unlikely(wl->state != WLCORE_STATE_ON)) {
+		ret = -EAGAIN;
+		goto out_unlock;
+	}
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out_unlock;
+
+	wlvif->default_key = key_idx;
+
+	/* the default WEP key needs to be configured at least once */
+	if (wlvif->encryption_type == KEY_WEP) {
+		ret = wl12xx_cmd_set_default_wep_key(wl,
+				key_idx,
+				wlvif->sta.hlid);
+		if (ret < 0)
+			goto out_sleep;
+	}
+
+out_sleep:
+	wl1271_ps_elp_sleep(wl);
+
+out_unlock:
+	mutex_unlock(&wl->mutex);
+}
+
 void wlcore_regdomain_config(struct wl1271 *wl)
 {
 	int ret;
@@ -5352,6 +5384,7 @@ static const struct ieee80211_ops wl1271_ops = {
 	.ampdu_action = wl1271_op_ampdu_action,
 	.tx_frames_pending = wl1271_tx_frames_pending,
 	.set_bitrate_mask = wl12xx_set_bitrate_mask,
+	.set_default_unicast_key = wl1271_op_set_default_key_idx,
 	.channel_switch = wl12xx_op_channel_switch,
 	.flush = wlcore_op_flush,
 	.remain_on_channel = wlcore_op_remain_on_channel,
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 004d02e..7e93fe6 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -386,7 +386,7 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		is_wep = (cipher == WLAN_CIPHER_SUITE_WEP40) ||
 			 (cipher == WLAN_CIPHER_SUITE_WEP104);
 
-		if (unlikely(is_wep && wlvif->default_key != idx)) {
+		if (WARN_ON(is_wep && wlvif->default_key != idx)) {
 			ret = wl1271_set_default_wep_key(wl, wlvif, idx);
 			if (ret < 0)
 				return ret;
-- 
1.8.1.2

