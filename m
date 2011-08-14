Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65029 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab1HNKR5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 06:17:57 -0400
Received: by mail-wy0-f174.google.com with SMTP id 24so2967085wyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 14 Aug 2011 03:17:56 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 28/40] wl12xx: AP-mode - set STA HT capabilities when adding a STA
Date: Sun, 14 Aug 2011 13:17:27 +0300
Message-Id: <1313317059-16567-29-git-send-email-eliad@wizery.com> (sfid-20110814_121802_027366_9E94DD7E)
In-Reply-To: <1313317059-16567-1-git-send-email-eliad@wizery.com>
References: <1313317059-16567-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

In addition, set global HT operation mode via ACX_HT_BSS_OPERATION when
a change is detected by usermode

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/acx.c  |   10 ++++++----
 drivers/net/wireless/wl12xx/acx.h  |    2 +-
 drivers/net/wireless/wl12xx/main.c |   34 +++++++++++++++++++++++++++-------
 3 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index ecbceb6..e047594 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -1306,27 +1306,29 @@ out:
 	kfree(acx);
 	return ret;
 }
 
 int wl1271_acx_set_ht_capabilities(struct wl1271 *wl,
 				    struct ieee80211_sta_ht_cap *ht_cap,
-				    bool allow_ht_operation)
+				    bool allow_ht_operation, u8 hlid)
 {
 	struct wl1271_acx_ht_capabilities *acx;
 	int ret = 0;
 	u32 ht_capabilites = 0;
 
-	wl1271_debug(DEBUG_ACX, "acx ht capabilities setting");
+	wl1271_debug(DEBUG_ACX, "acx ht capabilities setting "
+		     "sta supp: %d sta cap: %d", ht_cap->ht_supported,
+		     ht_cap->cap);
 
 	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
 	if (!acx) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
-	if (allow_ht_operation) {
+	if (allow_ht_operation && ht_cap->ht_supported) {
 		/* no need to translate capabilities - use the spec values */
 		ht_capabilites = ht_cap->cap;
 
 		/*
 		 * this bit is not employed by the spec but only by FW to
 		 * indicate peer HT support
@@ -1335,13 +1337,13 @@ int wl1271_acx_set_ht_capabilities(struct wl1271 *wl,
 
 		/* get data from A-MPDU parameters field */
 		acx->ampdu_max_length = ht_cap->ampdu_factor;
 		acx->ampdu_min_spacing = ht_cap->ampdu_density;
 	}
 
-	acx->hlid = wl->sta_hlid;
+	acx->hlid = hlid;
 	acx->ht_capabilites = cpu_to_le32(ht_capabilites);
 
 	ret = wl1271_cmd_configure(wl, ACX_PEER_HT_CAP, acx, sizeof(*acx));
 	if (ret < 0) {
 		wl1271_warning("acx ht capabilities setting failed: %d", ret);
 		goto out;
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index 82c9271..758c596 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -1265,13 +1265,13 @@ int wl1271_acx_keep_alive_mode(struct wl1271 *wl, bool enable);
 int wl1271_acx_keep_alive_config(struct wl1271 *wl, u8 index, u8 tpl_valid);
 int wl1271_acx_rssi_snr_trigger(struct wl1271 *wl, bool enable,
 				s16 thold, u8 hyst);
 int wl1271_acx_rssi_snr_avg_weights(struct wl1271 *wl);
 int wl1271_acx_set_ht_capabilities(struct wl1271 *wl,
 				    struct ieee80211_sta_ht_cap *ht_cap,
-				    bool allow_ht_operation);
+				    bool allow_ht_operation, u8 hlid);
 int wl1271_acx_set_ht_information(struct wl1271 *wl,
 				   u16 ht_operation_mode);
 int wl12xx_acx_set_ba_initiator_policy(struct wl1271 *wl);
 int wl12xx_acx_set_ba_receiver_session(struct wl1271 *wl, u8 tid_index,
 				       u16 ssn, bool enable, u8 peer_hlid);
 int wl1271_acx_tsf_info(struct wl1271 *wl, u64 *mactime);
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index de4b6c2..053751e 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3121,12 +3121,24 @@ static void wl1271_bss_info_changed_ap(struct wl1271 *wl,
 		}
 	}
 
 	ret = wl1271_bss_erp_info_changed(wl, bss_conf, changed);
 	if (ret < 0)
 		goto out;
+
+	/* Handle HT information change */
+	if ((changed & BSS_CHANGED_HT) &&
+	    (bss_conf->channel_type != NL80211_CHAN_NO_HT)) {
+		ret = wl1271_acx_set_ht_information(wl,
+					bss_conf->ht_operation_mode);
+		if (ret < 0) {
+			wl1271_warning("Set ht information failed %d", ret);
+			goto out;
+		}
+	}
+
 out:
 	return;
 }
 
 /* STA/IBSS mode changes */
 static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
@@ -3436,38 +3448,42 @@ sta_not_found:
 			ret = wl12xx_cmd_role_stop_dev(wl);
 			if (ret < 0)
 				goto out;
 		}
 	}
 
-	/* Handle new association with HT. Do this only after join. */
+	/* Handle new association with HT. Do this after join. */
 	if (sta_exists) {
 		if ((changed & BSS_CHANGED_HT) &&
 		    (bss_conf->channel_type != NL80211_CHAN_NO_HT)) {
-			ret = wl1271_acx_set_ht_capabilities(wl, &sta_ht_cap,
-							     true);
+			ret = wl1271_acx_set_ht_capabilities(wl,
+							     &sta_ht_cap,
+							     true,
+							     wl->sta_hlid);
 			if (ret < 0) {
 				wl1271_warning("Set ht cap true failed %d",
 					       ret);
 				goto out;
 			}
 		}
 		/* handle new association without HT and disassociation */
 		else if (changed & BSS_CHANGED_ASSOC) {
-			ret = wl1271_acx_set_ht_capabilities(wl, &sta_ht_cap,
-							     false);
+			ret = wl1271_acx_set_ht_capabilities(wl,
+							     &sta_ht_cap,
+							     false,
+							     wl->sta_hlid);
 			if (ret < 0) {
 				wl1271_warning("Set ht cap false failed %d",
 					       ret);
 				goto out;
 			}
 		}
 	}
 
-	/* Handle HT information change. Only after join. */
-	if (sta_exists && (changed & BSS_CHANGED_HT) &&
+	/* Handle HT information change. Done after join. */
+	if ((changed & BSS_CHANGED_HT) &&
 	    (bss_conf->channel_type != NL80211_CHAN_NO_HT)) {
 		ret = wl1271_acx_set_ht_information(wl,
 					bss_conf->ht_operation_mode);
 		if (ret < 0) {
 			wl1271_warning("Set ht information failed %d", ret);
 			goto out;
@@ -3700,12 +3716,16 @@ static int wl1271_op_sta_add(struct ieee80211_hw *hw,
 		goto out_sleep;
 
 	ret = wl12xx_cmd_set_peer_state(wl, hlid);
 	if (ret < 0)
 		goto out_sleep;
 
+	ret = wl1271_acx_set_ht_capabilities(wl, &sta->ht_cap, true, hlid);
+	if (ret < 0)
+		goto out_sleep;
+
 out_sleep:
 	wl1271_ps_elp_sleep(wl);
 
 out_free_sta:
 	if (ret < 0)
 		wl1271_free_sta(wl, hlid);
-- 
1.7.6.401.g6a319

