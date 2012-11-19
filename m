Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:37423 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756Ab2KSQjd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 11:39:33 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so2051722eaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2012 08:39:33 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 01/15] wlcore: start sta role on CHANGED_BSSID
Date: Mon, 19 Nov 2012 18:39:16 +0200
Message-Id: <1353343170-26516-2-git-send-email-eliad@wizery.com> (sfid-20121119_173949_101732_E3F99F55)
In-Reply-To: <1353343170-26516-1-git-send-email-eliad@wizery.com>
References: <1353343170-26516-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make the connection flow simpler by starting
sta role on bssid change.

Currently, we start dev role when going idle-off,
and start the sta role only after association
indication. This complicates the connection
flow with some possible intermediate states.

Make it simpler by starting sta role on bssid change,
which now happens *before* auth req get sent.

Update the handling of mac80211's notifications
and change wl1271_join/unjoin accordingly -
* Split wl1271_join() into wlcore_join (tuning on
  a channel/bssid) and wlcore_set_assoc (configure
  sta after association).
* Rename wl1271_unjoin() to wlcore_disconnect(), as
  it is no longer the inversion of wl1271_join()
  (now it's only used to disconnect associated sta /
  joined ibss, without stopping the role).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c |  233 +++++++++++++--------------------
 1 files changed, 88 insertions(+), 145 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 41ed1d5..41a8502 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -2468,8 +2468,7 @@ static int wl12xx_op_change_interface(struct ieee80211_hw *hw,
 	return ret;
 }
 
-static int wl1271_join(struct wl1271 *wl, struct wl12xx_vif *wlvif,
-			  bool set_assoc)
+static int wlcore_join(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	int ret;
 	bool is_ibss = (wlvif->bss_type == BSS_TYPE_IBSS);
@@ -2489,18 +2488,17 @@ static int wl1271_join(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	/* clear encryption type */
 	wlvif->encryption_type = KEY_NONE;
 
-	if (set_assoc)
-		set_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags);
-
 	if (is_ibss)
 		ret = wl12xx_cmd_role_start_ibss(wl, wlvif);
 	else
 		ret = wl12xx_cmd_role_start_sta(wl, wlvif);
-	if (ret < 0)
-		goto out;
 
-	if (!test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags))
-		goto out;
+	return ret;
+}
+
+static int wlcore_set_assoc(struct wl1271 *wl, struct wl12xx_vif *wlvif)
+{
+	int ret;
 
 	/*
 	 * The join command disable the keep-alive mode, shut down its process,
@@ -2525,15 +2523,12 @@ static int wl1271_join(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 					   ACX_KEEP_ALIVE_TPL_VALID);
 	if (ret < 0)
 		goto out;
-
 out:
 	return ret;
 }
 
-static int wl1271_unjoin(struct wl1271 *wl, struct wl12xx_vif *wlvif)
+static void wlcore_disconnect(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
-	int ret;
-
 	if (test_and_clear_bit(WLVIF_FLAG_CS_PROGRESS, &wlvif->flags)) {
 		struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
 
@@ -2546,17 +2541,9 @@ static int wl1271_unjoin(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 				     wlvif->sta.klv_template_id,
 				     ACX_KEEP_ALIVE_TPL_INVALID);
 
-	/* to stop listening to a channel, we disconnect */
-	ret = wl12xx_cmd_role_stop_sta(wl, wlvif);
-	if (ret < 0)
-		goto out;
-
 	/* reset TX security counters on a clean disconnect */
 	wlvif->tx_security_last_seq_lsb = 0;
 	wlvif->tx_security_seq = 0;
-
-out:
-	return ret;
 }
 
 static void wl1271_set_band_rate(struct wl1271 *wl, struct wl12xx_vif *wlvif)
@@ -2565,45 +2552,6 @@ static void wl1271_set_band_rate(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	wlvif->rate_set = wlvif->basic_rate_set;
 }
 
-static int wl1271_sta_handle_idle(struct wl1271 *wl, struct wl12xx_vif *wlvif,
-				  bool idle)
-{
-	int ret;
-	bool cur_idle = !test_bit(WLVIF_FLAG_IN_USE, &wlvif->flags);
-
-	if (idle == cur_idle)
-		return 0;
-
-	if (idle) {
-		/* no need to croc if we weren't busy (e.g. during boot) */
-		if (wl12xx_dev_role_started(wlvif)) {
-			ret = wl12xx_stop_dev(wl, wlvif);
-			if (ret < 0)
-				goto out;
-		}
-		wlvif->rate_set =
-			wl1271_tx_min_rate_get(wl, wlvif->basic_rate_set);
-		ret = wl1271_acx_sta_rate_policies(wl, wlvif);
-		if (ret < 0)
-			goto out;
-		clear_bit(WLVIF_FLAG_IN_USE, &wlvif->flags);
-	} else {
-		/* The current firmware only supports sched_scan in idle */
-		if (wl->sched_scanning) {
-			wl1271_scan_sched_scan_stop(wl, wlvif);
-			ieee80211_sched_scan_stopped(wl->hw);
-		}
-
-		ret = wl12xx_start_dev(wl, wlvif);
-		if (ret < 0)
-			goto out;
-		set_bit(WLVIF_FLAG_IN_USE, &wlvif->flags);
-	}
-
-out:
-	return ret;
-}
-
 static int wl12xx_config_vif(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			     struct ieee80211_conf *conf, u32 changed)
 {
@@ -3833,8 +3781,10 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 			ibss_joined = true;
 		} else {
 			if (test_and_clear_bit(WLVIF_FLAG_IBSS_JOINED,
-					       &wlvif->flags))
-				wl1271_unjoin(wl, wlvif);
+					       &wlvif->flags)) {
+				wlcore_disconnect(wl, wlvif);
+				wl12xx_cmd_role_stop_sta(wl, wlvif);
+			}
 		}
 	}
 
@@ -3852,12 +3802,6 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 		do_join = true;
 	}
 
-	if (changed & BSS_CHANGED_IDLE && !is_ibss) {
-		ret = wl1271_sta_handle_idle(wl, wlvif, bss_conf->idle);
-		if (ret < 0)
-			wl1271_warning("idle mode change failed %d", ret);
-	}
-
 	if ((changed & BSS_CHANGED_CQM)) {
 		bool enable = false;
 		if (bss_conf->cqm_rssi_thold)
@@ -3870,18 +3814,7 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 		wlvif->rssi_thold = bss_conf->cqm_rssi_thold;
 	}
 
-	if (changed & BSS_CHANGED_BSSID)
-		if (!is_zero_ether_addr(bss_conf->bssid)) {
-			ret = wl12xx_cmd_build_null_data(wl, wlvif);
-			if (ret < 0)
-				goto out;
-
-			ret = wl1271_build_qos_null_data(wl, vif);
-			if (ret < 0)
-				goto out;
-		}
-
-	if (changed & (BSS_CHANGED_ASSOC | BSS_CHANGED_HT)) {
+	if (changed & (BSS_CHANGED_BSSID | BSS_CHANGED_HT)) {
 		rcu_read_lock();
 		sta = ieee80211_find_sta(vif, bss_conf->bssid);
 		if (!sta)
@@ -3900,20 +3833,16 @@ sta_not_found:
 		rcu_read_unlock();
 	}
 
-	if ((changed & BSS_CHANGED_ASSOC)) {
-		if (bss_conf->assoc) {
+	if (changed & BSS_CHANGED_BSSID) {
+		if (!is_zero_ether_addr(bss_conf->bssid)) {
 			u32 rates;
-			int ieoffset;
-			wlvif->aid = bss_conf->aid;
-			wlvif->channel_type = bss_conf->channel_type;
-			wlvif->beacon_int = bss_conf->beacon_int;
-			do_join = true;
-			set_assoc = true;
+			wl1271_debug(DEBUG_MAC80211,
+			     "changed_bssid: %pM, aid: %d, bcn_int: %d, brates: 0x%x sta_rate_set: 0x%x (%d)",
+			     bss_conf->bssid, bss_conf->aid,
+			     bss_conf->beacon_int,
+			     bss_conf->basic_rates, sta_rate_set, sta_exists);
 
-			/*
-			 * use basic rates from AP, and determine lowest rate
-			 * to use with control frames.
-			 */
+			wlvif->beacon_int = bss_conf->beacon_int;
 			rates = bss_conf->basic_rates;
 			wlvif->basic_rate_set =
 				wl1271_tx_enabled_rates_get(wl, rates,
@@ -3921,15 +3850,63 @@ sta_not_found:
 			wlvif->basic_rate =
 				wl1271_tx_min_rate_get(wl,
 						       wlvif->basic_rate_set);
+
 			if (sta_rate_set)
 				wlvif->rate_set =
 					wl1271_tx_enabled_rates_get(wl,
 								sta_rate_set,
 								wlvif->band);
+
+			/* we only supports sched_scan while not connected */
+			if (wl->sched_scanning) {
+				wl1271_scan_sched_scan_stop(wl, wlvif);
+				ieee80211_sched_scan_stopped(wl->hw);
+			}
+
 			ret = wl1271_acx_sta_rate_policies(wl, wlvif);
 			if (ret < 0)
 				goto out;
 
+			ret = wl12xx_cmd_build_null_data(wl, wlvif);
+			if (ret < 0)
+				goto out;
+
+			ret = wl1271_build_qos_null_data(wl, vif);
+			if (ret < 0)
+				goto out;
+
+			/* Need to update the BSSID (for filtering etc) */
+			set_bit(WLVIF_FLAG_IN_USE, &wlvif->flags);
+			do_join = true;
+		} else {
+			/* revert back to minimum rates for the current band */
+			wl1271_set_band_rate(wl, wlvif);
+			wlvif->basic_rate =
+				wl1271_tx_min_rate_get(wl,
+						       wlvif->basic_rate_set);
+			ret = wl1271_acx_sta_rate_policies(wl, wlvif);
+			if (ret < 0)
+				goto out;
+
+			if (!is_ibss &&
+			    test_bit(WLVIF_FLAG_IN_USE, &wlvif->flags)) {
+				ret = wl12xx_cmd_role_stop_sta(wl, wlvif);
+				if (ret < 0)
+					goto out;
+			}
+			clear_bit(WLVIF_FLAG_IN_USE, &wlvif->flags);
+		}
+	}
+
+	if ((changed & BSS_CHANGED_ASSOC)) {
+		if (bss_conf->assoc) {
+			int ieoffset;
+			wlvif->aid = bss_conf->aid;
+			wlvif->channel_type = bss_conf->channel_type;
+			wlvif->beacon_int = bss_conf->beacon_int;
+
+			set_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags);
+
 			/*
 			 * with wl1271, we don't need to update the
 			 * beacon_int and dtim_period, because the firmware
@@ -3955,64 +3932,32 @@ sta_not_found:
 			ret = wl1271_acx_conn_monit_params(wl, wlvif, true);
 			if (ret < 0)
 				goto out;
+
+			set_assoc = true;
 		} else {
-			/* use defaults when not associated */
 			bool was_assoc =
 			    !!test_and_clear_bit(WLVIF_FLAG_STA_ASSOCIATED,
 						 &wlvif->flags);
-			bool was_ifup =
-			    !!test_and_clear_bit(WLVIF_FLAG_STA_STATE_SENT,
-						 &wlvif->flags);
+
+			/* use defaults when not associated */
 			wlvif->aid = 0;
 
 			/* free probe-request template */
 			dev_kfree_skb(wlvif->probereq);
 			wlvif->probereq = NULL;
 
-			/* revert back to minimum rates for the current band */
-			wl1271_set_band_rate(wl, wlvif);
-			wlvif->basic_rate =
-				wl1271_tx_min_rate_get(wl,
-						       wlvif->basic_rate_set);
-			ret = wl1271_acx_sta_rate_policies(wl, wlvif);
-			if (ret < 0)
-				goto out;
-
 			/* disable connection monitor features */
 			ret = wl1271_acx_conn_monit_params(wl, wlvif, false);
+			if (ret < 0)
+				goto out;
 
 			/* Disable the keep-alive feature */
 			ret = wl1271_acx_keep_alive_mode(wl, wlvif, false);
 			if (ret < 0)
 				goto out;
 
-			/* restore the bssid filter and go to dummy bssid */
-			if (was_assoc) {
-				/*
-				 * we might have to disable roc, if there was
-				 * no IF_OPER_UP notification.
-				 */
-				if (!was_ifup) {
-					ret = wl12xx_croc(wl, wlvif->role_id);
-					if (ret < 0)
-						goto out;
-				}
-				/*
-				 * (we also need to disable roc in case of
-				 * roaming on the same channel. until we will
-				 * have a better flow...)
-				 */
-				if (test_bit(wlvif->dev_role_id, wl->roc_map)) {
-					ret = wl12xx_croc(wl,
-							  wlvif->dev_role_id);
-					if (ret < 0)
-						goto out;
-				}
-
-				wl1271_unjoin(wl, wlvif);
-				if (!bss_conf->idle)
-					wl12xx_start_dev(wl, wlvif);
-			}
+			if (was_assoc)
+				wlcore_disconnect(wl, wlvif);
 		}
 	}
 
@@ -4042,7 +3987,7 @@ sta_not_found:
 		goto out;
 
 	if (do_join) {
-		ret = wl1271_join(wl, wlvif, set_assoc);
+		ret = wlcore_join(wl, wlvif);
 		if (ret < 0) {
 			wl1271_warning("cmd join failed %d", ret);
 			goto out;
@@ -4053,21 +3998,18 @@ sta_not_found:
 			ret = wl12xx_roc(wl, wlvif, wlvif->role_id);
 			if (ret < 0)
 				goto out;
-
-			if (test_bit(WLVIF_FLAG_STA_AUTHORIZED, &wlvif->flags))
-				wl12xx_set_authorized(wl, wlvif);
-		}
-		/*
-		 * stop device role if started (we might already be in
-		 * STA/IBSS role).
-		 */
-		if (wl12xx_dev_role_started(wlvif)) {
-			ret = wl12xx_stop_dev(wl, wlvif);
-			if (ret < 0)
-				goto out;
 		}
 	}
 
+	if (set_assoc) {
+		ret = wlcore_set_assoc(wl, wlvif);
+		if (ret < 0)
+			goto out;
+
+		if (test_bit(WLVIF_FLAG_STA_AUTHORIZED, &wlvif->flags))
+			wl12xx_set_authorized(wl, wlvif);
+	}
+
 	/* Handle new association with HT. Do this after join. */
 	if (sta_exists) {
 		if ((changed & BSS_CHANGED_HT) &&
@@ -4434,6 +4376,7 @@ static int wl12xx_update_sta_state(struct wl1271 *wl,
 	    old_state == IEEE80211_STA_AUTHORIZED &&
 	    new_state == IEEE80211_STA_ASSOC) {
 		clear_bit(WLVIF_FLAG_STA_AUTHORIZED, &wlvif->flags);
+		clear_bit(WLVIF_FLAG_STA_STATE_SENT, &wlvif->flags);
 		return 0;
 	}
 
-- 
1.7.6.401.g6a319

