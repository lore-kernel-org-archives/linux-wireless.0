Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57714 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab2KTLUM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 06:20:12 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so1625946eek.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2012 03:20:11 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 01/11] wlcore: start sta role on CHANGED_BSSID
Date: Tue, 20 Nov 2012 13:20:01 +0200
Message-Id: <1353410411-18833-2-git-send-email-eliad@wizery.com> (sfid-20121120_122017_335614_8B6F697B)
In-Reply-To: <1353410411-18833-1-git-send-email-eliad@wizery.com>
References: <1353410411-18833-1-git-send-email-eliad@wizery.com>
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
* Rename wl1271_unjoin() to wlcore_unset_assoc(), as
  it is no longer the inversion of wl1271_join()
  (now it's only used to disconnect associated sta /
  joined ibss, without stopping the role).
* Set ssid before starting station role (needed for
  start_role(sta)

While on it, split wl1271_bss_info_changed_sta() into
some sub-functions.

since we no longer use dev role in the connection flow,
we now always use the hlid of the sta role.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v2: take some more code out of wl1271_bss_info_changed_sta (thanks Luca!)
    squash patches [2/15, 3/15] into this one (thanks Julian!)

drivers/net/wireless/ti/wlcore/main.c |  444 ++++++++++++++++-----------------
 drivers/net/wireless/ti/wlcore/tx.c   |   10 +-
 2 files changed, 221 insertions(+), 233 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 41ed1d5..2690fe9 100644
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
@@ -2489,18 +2488,96 @@ static int wl1271_join(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	/* clear encryption type */
 	wlvif->encryption_type = KEY_NONE;
 
-	if (set_assoc)
-		set_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags);
-
 	if (is_ibss)
 		ret = wl12xx_cmd_role_start_ibss(wl, wlvif);
 	else
 		ret = wl12xx_cmd_role_start_sta(wl, wlvif);
+
+	return ret;
+}
+
+static int wl1271_ssid_set(struct wl12xx_vif *wlvif, struct sk_buff *skb,
+			    int offset)
+{
+	u8 ssid_len;
+	const u8 *ptr = cfg80211_find_ie(WLAN_EID_SSID, skb->data + offset,
+					 skb->len - offset);
+
+	if (!ptr) {
+		wl1271_error("No SSID in IEs!");
+		return -ENOENT;
+	}
+
+	ssid_len = ptr[1];
+	if (ssid_len > IEEE80211_MAX_SSID_LEN) {
+		wl1271_error("SSID is too long!");
+		return -EINVAL;
+	}
+
+	wlvif->ssid_len = ssid_len;
+	memcpy(wlvif->ssid, ptr+2, ssid_len);
+	return 0;
+}
+
+static int wlcore_set_ssid(struct wl1271 *wl, struct wl12xx_vif *wlvif)
+{
+	struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
+	struct sk_buff *skb;
+	int ieoffset;
+
+	/* we currently only support setting the ssid from the ap probe req */
+	if (wlvif->bss_type != BSS_TYPE_STA_BSS)
+		return -EINVAL;
+
+	skb = ieee80211_ap_probereq_get(wl->hw, vif);
+	if (!skb)
+		return -EINVAL;
+
+	ieoffset = offsetof(struct ieee80211_mgmt,
+			    u.probe_req.variable);
+	wl1271_ssid_set(wlvif, skb, ieoffset);
+	dev_kfree_skb(skb);
+
+	return 0;
+}
+
+static int wlcore_set_assoc(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			    struct ieee80211_bss_conf *bss_conf)
+{
+	int ieoffset;
+	int ret;
+
+	wlvif->aid = bss_conf->aid;
+	wlvif->channel_type = bss_conf->channel_type;
+	wlvif->beacon_int = bss_conf->beacon_int;
+
+	set_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags);
+
+	/*
+	 * with wl1271, we don't need to update the
+	 * beacon_int and dtim_period, because the firmware
+	 * updates it by itself when the first beacon is
+	 * received after a join.
+	 */
+	ret = wl1271_cmd_build_ps_poll(wl, wlvif, wlvif->aid);
 	if (ret < 0)
-		goto out;
+		return ret;
 
-	if (!test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags))
-		goto out;
+	/*
+	 * Get a template for hardware connection maintenance
+	 */
+	dev_kfree_skb(wlvif->probereq);
+	wlvif->probereq = wl1271_cmd_build_ap_probe_req(wl,
+							wlvif,
+							NULL);
+	ieoffset = offsetof(struct ieee80211_mgmt,
+			    u.probe_req.variable);
+	wl1271_ssid_set(wlvif, wlvif->probereq, ieoffset);
+
+	/* enable the connection monitoring feature */
+	ret = wl1271_acx_conn_monit_params(wl, wlvif, true);
+	if (ret < 0)
+		return ret;
 
 	/*
 	 * The join command disable the keep-alive mode, shut down its process,
@@ -2510,29 +2587,58 @@ static int wl1271_join(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	 */
 	ret = wl1271_acx_keep_alive_mode(wl, wlvif, true);
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	ret = wl1271_acx_aid(wl, wlvif, wlvif->aid);
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	ret = wl12xx_cmd_build_klv_null_data(wl, wlvif);
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	ret = wl1271_acx_keep_alive_config(wl, wlvif,
 					   wlvif->sta.klv_template_id,
 					   ACX_KEEP_ALIVE_TPL_VALID);
 	if (ret < 0)
-		goto out;
+		return ret;
 
-out:
 	return ret;
 }
 
-static int wl1271_unjoin(struct wl1271 *wl, struct wl12xx_vif *wlvif)
+static int wlcore_unset_assoc(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	int ret;
+	bool sta = wlvif->bss_type == BSS_TYPE_STA_BSS;
+
+	/* make sure we are connected (sta) joined */
+	if (sta &&
+	    !test_and_clear_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags))
+		return false;
+
+	/* make sure we are joined (ibss) */
+	if (!sta &&
+	    test_and_clear_bit(WLVIF_FLAG_IBSS_JOINED, &wlvif->flags))
+		return false;
+
+	if (sta) {
+		/* use defaults when not associated */
+		wlvif->aid = 0;
+
+		/* free probe-request template */
+		dev_kfree_skb(wlvif->probereq);
+		wlvif->probereq = NULL;
+
+		/* disable connection monitor features */
+		ret = wl1271_acx_conn_monit_params(wl, wlvif, false);
+		if (ret < 0)
+			return ret;
+
+		/* Disable the keep-alive feature */
+		ret = wl1271_acx_keep_alive_mode(wl, wlvif, false);
+		if (ret < 0)
+			return ret;
+	}
 
 	if (test_and_clear_bit(WLVIF_FLAG_CS_PROGRESS, &wlvif->flags)) {
 		struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
@@ -2546,17 +2652,11 @@ static int wl1271_unjoin(struct wl1271 *wl, struct wl12xx_vif *wlvif)
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
 
-out:
-	return ret;
+	return 0;
 }
 
 static void wl1271_set_band_rate(struct wl1271 *wl, struct wl12xx_vif *wlvif)
@@ -2565,45 +2665,6 @@ static void wl1271_set_band_rate(struct wl1271 *wl, struct wl12xx_vif *wlvif)
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
@@ -3418,30 +3479,6 @@ out:
 	return ret;
 }
 
-static int wl1271_ssid_set(struct ieee80211_vif *vif, struct sk_buff *skb,
-			    int offset)
-{
-	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
-	u8 ssid_len;
-	const u8 *ptr = cfg80211_find_ie(WLAN_EID_SSID, skb->data + offset,
-					 skb->len - offset);
-
-	if (!ptr) {
-		wl1271_error("No SSID in IEs!");
-		return -ENOENT;
-	}
-
-	ssid_len = ptr[1];
-	if (ssid_len > IEEE80211_MAX_SSID_LEN) {
-		wl1271_error("SSID is too long!");
-		return -EINVAL;
-	}
-
-	wlvif->ssid_len = ssid_len;
-	memcpy(wlvif->ssid, ptr+2, ssid_len);
-	return 0;
-}
-
 static void wl12xx_remove_ie(struct sk_buff *skb, u8 eid, int ieoffset)
 {
 	int len;
@@ -3622,7 +3659,7 @@ static int wlcore_set_beacon_template(struct wl1271 *wl,
 
 	wl1271_debug(DEBUG_MASTER, "beacon updated");
 
-	ret = wl1271_ssid_set(vif, beacon, ieoffset);
+	ret = wl1271_ssid_set(wlvif, beacon, ieoffset);
 	if (ret < 0) {
 		dev_kfree_skb(beacon);
 		goto out;
@@ -3804,6 +3841,81 @@ out:
 	return;
 }
 
+static int wlcore_set_bssid(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			    struct ieee80211_bss_conf *bss_conf,
+			    u32 sta_rate_set)
+{
+	u32 rates;
+	int ret;
+
+	wl1271_debug(DEBUG_MAC80211,
+	     "changed_bssid: %pM, aid: %d, bcn_int: %d, brates: 0x%x sta_rate_set: 0x%x",
+	     bss_conf->bssid, bss_conf->aid,
+	     bss_conf->beacon_int,
+	     bss_conf->basic_rates, sta_rate_set);
+
+	wlvif->beacon_int = bss_conf->beacon_int;
+	rates = bss_conf->basic_rates;
+	wlvif->basic_rate_set =
+		wl1271_tx_enabled_rates_get(wl, rates,
+					    wlvif->band);
+	wlvif->basic_rate =
+		wl1271_tx_min_rate_get(wl,
+				       wlvif->basic_rate_set);
+
+	if (sta_rate_set)
+		wlvif->rate_set =
+			wl1271_tx_enabled_rates_get(wl,
+						sta_rate_set,
+						wlvif->band);
+
+	/* we only support sched_scan while not connected */
+	if (wl->sched_scanning) {
+		wl1271_scan_sched_scan_stop(wl, wlvif);
+		ieee80211_sched_scan_stopped(wl->hw);
+	}
+
+	ret = wl1271_acx_sta_rate_policies(wl, wlvif);
+	if (ret < 0)
+		return ret;
+
+	ret = wl12xx_cmd_build_null_data(wl, wlvif);
+	if (ret < 0)
+		return ret;
+
+	ret = wl1271_build_qos_null_data(wl, wl12xx_wlvif_to_vif(wlvif));
+	if (ret < 0)
+		return ret;
+
+	wlcore_set_ssid(wl, wlvif);
+
+	set_bit(WLVIF_FLAG_IN_USE, &wlvif->flags);
+
+	return 0;
+}
+
+static int wlcore_clear_bssid(struct wl1271 *wl, struct wl12xx_vif *wlvif)
+{
+	int ret;
+
+	/* revert back to minimum rates for the current band */
+	wl1271_set_band_rate(wl, wlvif);
+	wlvif->basic_rate = wl1271_tx_min_rate_get(wl, wlvif->basic_rate_set);
+
+	ret = wl1271_acx_sta_rate_policies(wl, wlvif);
+	if (ret < 0)
+		return ret;
+
+	if (wlvif->bss_type == BSS_TYPE_STA_BSS &&
+	    test_bit(WLVIF_FLAG_IN_USE, &wlvif->flags)) {
+		ret = wl12xx_cmd_role_stop_sta(wl, wlvif);
+		if (ret < 0)
+			return ret;
+	}
+
+	clear_bit(WLVIF_FLAG_IN_USE, &wlvif->flags);
+	return 0;
+}
 /* STA/IBSS mode changes */
 static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 					struct ieee80211_vif *vif,
@@ -3811,7 +3923,7 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 					u32 changed)
 {
 	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
-	bool do_join = false, set_assoc = false;
+	bool do_join = false;
 	bool is_ibss = (wlvif->bss_type == BSS_TYPE_IBSS);
 	bool ibss_joined = false;
 	u32 sta_rate_set = 0;
@@ -3832,9 +3944,8 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 			set_bit(WLVIF_FLAG_IBSS_JOINED, &wlvif->flags);
 			ibss_joined = true;
 		} else {
-			if (test_and_clear_bit(WLVIF_FLAG_IBSS_JOINED,
-					       &wlvif->flags))
-				wl1271_unjoin(wl, wlvif);
+			wlcore_unset_assoc(wl, wlvif);
+			wl12xx_cmd_role_stop_sta(wl, wlvif);
 		}
 	}
 
@@ -3852,12 +3963,6 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
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
@@ -3870,18 +3975,7 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
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
@@ -3900,119 +3994,19 @@ sta_not_found:
 		rcu_read_unlock();
 	}
 
-	if ((changed & BSS_CHANGED_ASSOC)) {
-		if (bss_conf->assoc) {
-			u32 rates;
-			int ieoffset;
-			wlvif->aid = bss_conf->aid;
-			wlvif->channel_type = bss_conf->channel_type;
-			wlvif->beacon_int = bss_conf->beacon_int;
-			do_join = true;
-			set_assoc = true;
-
-			/*
-			 * use basic rates from AP, and determine lowest rate
-			 * to use with control frames.
-			 */
-			rates = bss_conf->basic_rates;
-			wlvif->basic_rate_set =
-				wl1271_tx_enabled_rates_get(wl, rates,
-							    wlvif->band);
-			wlvif->basic_rate =
-				wl1271_tx_min_rate_get(wl,
-						       wlvif->basic_rate_set);
-			if (sta_rate_set)
-				wlvif->rate_set =
-					wl1271_tx_enabled_rates_get(wl,
-								sta_rate_set,
-								wlvif->band);
-			ret = wl1271_acx_sta_rate_policies(wl, wlvif);
-			if (ret < 0)
-				goto out;
-
-			/*
-			 * with wl1271, we don't need to update the
-			 * beacon_int and dtim_period, because the firmware
-			 * updates it by itself when the first beacon is
-			 * received after a join.
-			 */
-			ret = wl1271_cmd_build_ps_poll(wl, wlvif, wlvif->aid);
+	if (changed & BSS_CHANGED_BSSID) {
+		if (!is_zero_ether_addr(bss_conf->bssid)) {
+			ret = wlcore_set_bssid(wl, wlvif, bss_conf,
+					       sta_rate_set);
 			if (ret < 0)
 				goto out;
 
-			/*
-			 * Get a template for hardware connection maintenance
-			 */
-			dev_kfree_skb(wlvif->probereq);
-			wlvif->probereq = wl1271_cmd_build_ap_probe_req(wl,
-									wlvif,
-									NULL);
-			ieoffset = offsetof(struct ieee80211_mgmt,
-					    u.probe_req.variable);
-			wl1271_ssid_set(vif, wlvif->probereq, ieoffset);
-
-			/* enable the connection monitoring feature */
-			ret = wl1271_acx_conn_monit_params(wl, wlvif, true);
-			if (ret < 0)
-				goto out;
+			/* Need to update the BSSID (for filtering etc) */
+			do_join = true;
 		} else {
-			/* use defaults when not associated */
-			bool was_assoc =
-			    !!test_and_clear_bit(WLVIF_FLAG_STA_ASSOCIATED,
-						 &wlvif->flags);
-			bool was_ifup =
-			    !!test_and_clear_bit(WLVIF_FLAG_STA_STATE_SENT,
-						 &wlvif->flags);
-			wlvif->aid = 0;
-
-			/* free probe-request template */
-			dev_kfree_skb(wlvif->probereq);
-			wlvif->probereq = NULL;
-
-			/* revert back to minimum rates for the current band */
-			wl1271_set_band_rate(wl, wlvif);
-			wlvif->basic_rate =
-				wl1271_tx_min_rate_get(wl,
-						       wlvif->basic_rate_set);
-			ret = wl1271_acx_sta_rate_policies(wl, wlvif);
-			if (ret < 0)
-				goto out;
-
-			/* disable connection monitor features */
-			ret = wl1271_acx_conn_monit_params(wl, wlvif, false);
-
-			/* Disable the keep-alive feature */
-			ret = wl1271_acx_keep_alive_mode(wl, wlvif, false);
+			ret = wlcore_clear_bssid(wl, wlvif);
 			if (ret < 0)
 				goto out;
-
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
 		}
 	}
 
@@ -4042,7 +4036,7 @@ sta_not_found:
 		goto out;
 
 	if (do_join) {
-		ret = wl1271_join(wl, wlvif, set_assoc);
+		ret = wlcore_join(wl, wlvif);
 		if (ret < 0) {
 			wl1271_warning("cmd join failed %d", ret);
 			goto out;
@@ -4053,18 +4047,19 @@ sta_not_found:
 			ret = wl12xx_roc(wl, wlvif, wlvif->role_id);
 			if (ret < 0)
 				goto out;
-
-			if (test_bit(WLVIF_FLAG_STA_AUTHORIZED, &wlvif->flags))
-				wl12xx_set_authorized(wl, wlvif);
 		}
-		/*
-		 * stop device role if started (we might already be in
-		 * STA/IBSS role).
-		 */
-		if (wl12xx_dev_role_started(wlvif)) {
-			ret = wl12xx_stop_dev(wl, wlvif);
+	}
+
+	if (changed & BSS_CHANGED_ASSOC) {
+		if (bss_conf->assoc) {
+			ret = wlcore_set_assoc(wl, wlvif, bss_conf);
 			if (ret < 0)
 				goto out;
+
+			if (test_bit(WLVIF_FLAG_STA_AUTHORIZED, &wlvif->flags))
+				wl12xx_set_authorized(wl, wlvif);
+		} else {
+			wlcore_unset_assoc(wl, wlvif);
 		}
 	}
 
@@ -4434,6 +4429,7 @@ static int wl12xx_update_sta_state(struct wl1271 *wl,
 	    old_state == IEEE80211_STA_AUTHORIZED &&
 	    new_state == IEEE80211_STA_ASSOC) {
 		clear_bit(WLVIF_FLAG_STA_AUTHORIZED, &wlvif->flags);
+		clear_bit(WLVIF_FLAG_STA_STATE_SENT, &wlvif->flags);
 		return 0;
 	}
 
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index a90d3cd..a555a70 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -155,21 +155,13 @@ static u8 wl12xx_tx_get_hlid_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 u8 wl12xx_tx_get_hlid(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		      struct sk_buff *skb, struct ieee80211_sta *sta)
 {
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-
 	if (!wlvif || wl12xx_is_dummy_packet(wl, skb))
 		return wl->system_hlid;
 
 	if (wlvif->bss_type == BSS_TYPE_AP_BSS)
 		return wl12xx_tx_get_hlid_ap(wl, wlvif, skb, sta);
 
-	if ((test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags) ||
-	     test_bit(WLVIF_FLAG_IBSS_JOINED, &wlvif->flags)) &&
-	    !ieee80211_is_auth(hdr->frame_control) &&
-	    !ieee80211_is_assoc_req(hdr->frame_control))
-		return wlvif->sta.hlid;
-	else
-		return wlvif->dev_hlid;
+	return wlvif->sta.hlid;
 }
 
 unsigned int wlcore_calc_packet_alignment(struct wl1271 *wl,
-- 
1.7.6.401.g6a319

