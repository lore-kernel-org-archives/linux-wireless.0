Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54440 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab1HIJOG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 05:14:06 -0400
Received: by mail-wy0-f174.google.com with SMTP id 24so210739wyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 02:14:05 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 18/40] wl12xx: replace dummy_join with ROC/CROC commands
Date: Tue,  9 Aug 2011 12:13:31 +0300
Message-Id: <1312881233-9366-19-git-send-email-eliad@wizery.com> (sfid-20110809_111415_659624_1F5CDEB0)
In-Reply-To: <1312881233-9366-1-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ROC command asks the fw stay on the channel of the given
hlid. it currently has 2 primary functions:

1. Allow tx/rx from the device role.

In order to tx/rx packets while the stations is not associated
(e.g. auth req/resp), the device role has to be used, along
with ROC on its link.

Keep the logic similiar to the one used in dummy_join. However,
since we can't scan while we ROC, we add CROC before starting
a scan, and ROC again (if needed) on scan complete.

2. Keeping the antenna for a specific link.

We ROC until the connection was completed (after EAPOLs exchange)
in order to prevent BT coex operations from taking the antenna
and failing the connection (after this stage, psm can be used).

During association, we ROC on the station role, and then CROC
the device role, thus assuring being ROC during all the connection
process.

Replace the WL1271_FLAG_JOINED with a new WL1271_FLAG_ROC,
indicating the fw was configured to ROC. Add a roc bitmap
to indicate what roles are currently ROCed.

Add wl1271_roc/croc functions in order to wrap the roc/croc
commands while taking care of the roc bitmap.

The current ROC/CROC state-machine is a bit complicated. In
the future we'll probably want to use wpa_supplicant to control
the ROC during connection.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c    |   56 +++++++++++++-
 drivers/net/wireless/wl12xx/cmd.h    |    9 ++
 drivers/net/wireless/wl12xx/main.c   |  137 +++++++++++++++++++++++++---------
 drivers/net/wireless/wl12xx/scan.c   |   20 ++++--
 drivers/net/wireless/wl12xx/tx.c     |   13 +++
 drivers/net/wireless/wl12xx/wl12xx.h |    3 +-
 6 files changed, 192 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 3091351..918c46b 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -1484,13 +1484,13 @@ out:
 
 static int wl1271_cmd_roc(struct wl1271 *wl, u8 role_id)
 {
 	struct wl1271_cmd_roc *cmd;
 	int ret = 0;
 
-	wl1271_debug(DEBUG_CMD, "cmd roc %d (%d)", wl->channel, wl->band);
+	wl1271_debug(DEBUG_CMD, "cmd roc %d (%d)", wl->channel, role_id);
 
 	if (WARN_ON(role_id == WL1271_INVALID_ROLE_ID))
 		return -EINVAL;
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (!cmd) {
@@ -1526,22 +1526,23 @@ out_free:
 out:
 	return ret;
 }
 
 static int wl1271_cmd_croc(struct wl1271 *wl, u8 role_id)
 {
-	struct wl1271_cmd_header *cmd;
+	struct wl1271_cmd_croc *cmd;
 	int ret = 0;
 
-	wl1271_debug(DEBUG_CMD, "cmd croc");
+	wl1271_debug(DEBUG_CMD, "cmd croc (%d)", role_id);
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (!cmd) {
 		ret = -ENOMEM;
 		goto out;
 	}
+	cmd->role_id = role_id;
 
 	ret = wl1271_cmd_send(wl, CMD_CANCEL_REMAIN_ON_CHANNEL, cmd,
 			      sizeof(*cmd), 0);
 	if (ret < 0) {
 		wl1271_error("failed to send ROC command");
 		goto out_free;
@@ -1550,6 +1551,55 @@ static int wl1271_cmd_croc(struct wl1271 *wl, u8 role_id)
 out_free:
 	kfree(cmd);
 
 out:
 	return ret;
 }
+
+int wl1271_roc(struct wl1271 *wl, u8 role_id)
+{
+	int ret = 0;
+
+	if (WARN_ON(test_bit(role_id, wl->roc_map)))
+		return 0;
+
+	ret = wl1271_cmd_roc(wl, role_id);
+	if (ret < 0)
+		goto out;
+
+	ret = wl1271_cmd_wait_for_event(wl,
+					REMAIN_ON_CHANNEL_COMPLETE_EVENT_ID);
+	if (ret < 0) {
+		wl1271_error("cmd roc event completion error");
+		goto out;
+	}
+
+	__set_bit(role_id, wl->roc_map);
+	set_bit(WL1271_FLAG_ROC, &wl->flags);
+
+out:
+	return ret;
+}
+
+int wl1271_croc(struct wl1271 *wl, u8 role_id)
+{
+	int ret = 0;
+	u8 roc_role;
+
+	if (WARN_ON(!test_bit(WL1271_FLAG_ROC, &wl->flags)))
+		return 0;
+
+	if (WARN_ON(!test_bit(role_id, wl->roc_map)))
+		return 0;
+
+	ret = wl1271_cmd_croc(wl, role_id);
+	if (ret < 0)
+		goto out;
+
+	__clear_bit(role_id, wl->roc_map);
+	roc_role = find_first_bit(wl->roc_map, WL1271_MAX_ROLES);
+	if (roc_role >= WL1271_MAX_ROLES)
+		clear_bit(WL1271_FLAG_ROC, &wl->flags);
+
+out:
+	return ret;
+}
diff --git a/drivers/net/wireless/wl12xx/cmd.h b/drivers/net/wireless/wl12xx/cmd.h
index 0ba4537..bb727d7 100644
--- a/drivers/net/wireless/wl12xx/cmd.h
+++ b/drivers/net/wireless/wl12xx/cmd.h
@@ -68,12 +68,14 @@ int wl1271_cmd_set_sta_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
 			   u8 key_size, const u8 *key, const u8 *addr,
 			   u32 tx_seq_32, u16 tx_seq_16);
 int wl1271_cmd_set_ap_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
 			  u8 key_size, const u8 *key, u8 hlid, u32 tx_seq_32,
 			  u16 tx_seq_16);
 int wl1271_cmd_set_peer_state(struct wl1271 *wl);
+int wl1271_roc(struct wl1271 *wl, u8 role_id);
+int wl1271_croc(struct wl1271 *wl, u8 role_id);
 int wl1271_cmd_add_peer(struct wl1271 *wl, struct ieee80211_sta *sta, u8 hlid);
 int wl1271_cmd_remove_peer(struct wl1271 *wl, u8 hlid);
 int wl12xx_cmd_config_fwlog(struct wl1271 *wl);
 int wl12xx_cmd_start_fwlog(struct wl1271 *wl);
 int wl12xx_cmd_stop_fwlog(struct wl1271 *wl);
 
@@ -579,12 +581,19 @@ struct wl1271_cmd_roc {
 	u8 role_id;
 	u8 channel;
 	u8 band;
 	u8 padding;
 };
 
+struct wl1271_cmd_croc {
+	struct wl1271_cmd_header header;
+
+	u8 role_id;
+	u8 padding[3];
+};
+
 enum wl1271_ssid_type {
 	WL1271_SSID_TYPE_PUBLIC = 0,
 	WL1271_SSID_TYPE_HIDDEN = 1,
 	WL1271_SSID_TYPE_ANY = 2,
 };
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 11909bb..fda2531 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -437,12 +437,14 @@ static int wl1271_check_operstate(struct wl1271 *wl, unsigned char operstate)
 		return 0;
 
 	ret = wl1271_cmd_set_peer_state(wl);
 	if (ret < 0)
 		return ret;
 
+	wl1271_croc(wl, wl->role_id);
+
 	wl1271_info("Association completed.");
 	return 0;
 }
 static int wl1271_dev_notify(struct notifier_block *me, unsigned long what,
 			     void *arg)
 {
@@ -2046,12 +2048,13 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 	wl->ap_ps_map = 0;
 	wl->sched_scanning = false;
 	wl->role_id = WL1271_INVALID_ROLE_ID;
 	wl->dev_role_id = WL1271_INVALID_ROLE_ID;
 	memset(wl->roles_map, 0, sizeof(wl->roles_map));
 	memset(wl->links_map, 0, sizeof(wl->links_map));
+	memset(wl->roc_map, 0, sizeof(wl->roc_map));
 
 	/* The system link is always allocated */
 	__set_bit(WL1271_SYSTEM_HLID, wl->links_map);
 
 	/*
 	 * this is performed after the cancel_work calls and the associated
@@ -2088,31 +2091,12 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 	}
 
 	mutex_unlock(&wl->mutex);
 	cancel_work_sync(&wl->recovery_work);
 }
 
-static int wl1271_dummy_join(struct wl1271 *wl)
-{
-	int ret = 0;
-	/* we need to use a dummy BSSID for now */
-	static const u8 dummy_bssid[ETH_ALEN] = { 0x0b, 0xad, 0xde,
-						  0xad, 0xbe, 0xef };
-
-	memcpy(wl->bssid, dummy_bssid, ETH_ALEN);
-
-	ret = wl1271_cmd_role_start_sta(wl);
-	if (ret < 0)
-		goto out;
-
-	set_bit(WL1271_FLAG_JOINED, &wl->flags);
-
-out:
-	return ret;
-}
-
 static int wl1271_join(struct wl1271 *wl, bool set_assoc)
 {
 	int ret;
 
 	/*
 	 * One of the side effects of the JOIN command is that is clears
@@ -2130,14 +2114,12 @@ static int wl1271_join(struct wl1271 *wl, bool set_assoc)
 		set_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags);
 
 	ret = wl1271_cmd_role_start_sta(wl);
 	if (ret < 0)
 		goto out;
 
-	set_bit(WL1271_FLAG_JOINED, &wl->flags);
-
 	if (!test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags))
 		goto out;
 
 	/*
 	 * The join command disable the keep-alive mode, shut down its process,
 	 * and also clear the template config, so we need to reset it all after
@@ -2171,13 +2153,12 @@ static int wl1271_unjoin(struct wl1271 *wl)
 
 	/* to stop listening to a channel, we disconnect */
 	ret = wl1271_cmd_role_stop_sta(wl);
 	if (ret < 0)
 		goto out;
 
-	clear_bit(WL1271_FLAG_JOINED, &wl->flags);
 	memset(wl->bssid, 0, ETH_ALEN);
 
 	/* reset TX security counters on a clean disconnect */
 	wl->tx_security_last_seq_lsb = 0;
 	wl->tx_security_seq = 0;
 
@@ -2195,14 +2176,18 @@ static void wl1271_set_band_rate(struct wl1271 *wl)
 
 static int wl1271_sta_handle_idle(struct wl1271 *wl, bool idle)
 {
 	int ret;
 
 	if (idle) {
-		if (test_bit(WL1271_FLAG_JOINED, &wl->flags)) {
-			ret = wl1271_unjoin(wl);
+		if (test_bit(WL1271_FLAG_ROC, &wl->flags)) {
+			ret = wl1271_croc(wl, wl->dev_role_id);
+			if (ret < 0)
+				goto out;
+
+			ret = wl1271_cmd_role_stop_dev(wl);
 			if (ret < 0)
 				goto out;
 		}
 		wl->rate_set = wl1271_tx_min_rate_get(wl);
 		ret = wl1271_acx_sta_rate_policies(wl);
 		if (ret < 0)
@@ -2211,24 +2196,23 @@ static int wl1271_sta_handle_idle(struct wl1271 *wl, bool idle)
 			wl, CMD_TEMPL_KLV_IDX_NULL_DATA,
 			ACX_KEEP_ALIVE_TPL_INVALID);
 		if (ret < 0)
 			goto out;
 		set_bit(WL1271_FLAG_IDLE, &wl->flags);
 	} else {
-		/* increment the session counter */
-		wl->session_counter++;
-		if (wl->session_counter >= SESSION_COUNTER_MAX)
-			wl->session_counter = 0;
-
 		/* The current firmware only supports sched_scan in idle */
 		if (wl->sched_scanning) {
 			wl1271_scan_sched_scan_stop(wl);
 			ieee80211_sched_scan_stopped(wl->hw);
 		}
 
-		ret = wl1271_dummy_join(wl);
+		ret = wl1271_cmd_role_start_dev(wl);
+		if (ret < 0)
+			goto out;
+
+		ret = wl1271_roc(wl, wl->dev_role_id);
 		if (ret < 0)
 			goto out;
 		clear_bit(WL1271_FLAG_IDLE, &wl->flags);
 	}
 
 out:
@@ -2302,17 +2286,40 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 			wl->basic_rate = wl1271_tx_min_rate_get(wl);
 			ret = wl1271_acx_sta_rate_policies(wl);
 			if (ret < 0)
 				wl1271_warning("rate policy for channel "
 					       "failed %d", ret);
 
-			if (test_bit(WL1271_FLAG_JOINED, &wl->flags)) {
+			if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags)) {
+				if (test_bit(WL1271_FLAG_ROC, &wl->flags)) {
+					/* roaming */
+					ret = wl1271_croc(wl, wl->dev_role_id);
+					if (ret < 0)
+						goto out_sleep;
+				}
 				ret = wl1271_join(wl, false);
 				if (ret < 0)
 					wl1271_warning("cmd join on channel "
 						       "failed %d", ret);
+			} else {
+				/*
+				 * change the ROC channel. do it only if we are
+				 * not idle. otherwise, CROC will be called
+				 * anyway.
+				 */
+				if (test_bit(WL1271_FLAG_ROC, &wl->flags) &&
+				    !(conf->flags & IEEE80211_CONF_IDLE)) {
+					ret = wl1271_croc(wl, wl->dev_role_id);
+					if (ret < 0)
+						goto out_sleep;
+
+					ret = wl1271_roc(wl, wl->dev_role_id);
+					if (ret < 0)
+						wl1271_warning("roc failed %d",
+							       ret);
+				}
 			}
 		}
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_IDLE && !is_ap) {
 		ret = wl1271_sta_handle_idle(wl,
@@ -2762,16 +2769,26 @@ static int wl1271_op_hw_scan(struct ieee80211_hw *hw,
 	}
 
 	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out;
 
-	ret = wl1271_scan(hw->priv, ssid, len, req);
+	/* cancel ROC before scanning */
+	if (test_bit(WL1271_FLAG_ROC, &wl->flags)) {
+		if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags)) {
+			/* don't allow scanning right now (?) */
+			ret = -EBUSY;
+			goto out_sleep;
+		}
+		wl1271_croc(wl, wl->dev_role_id);
+		wl1271_cmd_role_stop_dev(wl);
+	}
 
+	ret = wl1271_scan(hw->priv, ssid, len, req);
+out_sleep:
 	wl1271_ps_elp_sleep(wl);
-
 out:
 	mutex_unlock(&wl->mutex);
 
 	return ret;
 }
 
@@ -3289,13 +3306,15 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 			}
 		} else {
 			/* use defaults when not associated */
 			bool was_assoc =
 			    !!test_and_clear_bit(WL1271_FLAG_STA_ASSOCIATED,
 						 &wl->flags);
-			clear_bit(WL1271_FLAG_STA_STATE_SENT, &wl->flags);
+			bool was_ifup =
+			    !!test_and_clear_bit(WL1271_FLAG_STA_STATE_SENT,
+						 &wl->flags);
 			wl->aid = 0;
 
 			/* free probe-request template */
 			dev_kfree_skb(wl->probereq);
 			wl->probereq = NULL;
 
@@ -3316,14 +3335,38 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 			ret = wl1271_acx_keep_alive_mode(wl, false);
 			if (ret < 0)
 				goto out;
 
 			/* restore the bssid filter and go to dummy bssid */
 			if (was_assoc) {
+				u32 conf_flags = wl->hw->conf.flags;
+				/*
+				 * we might have to disable roc, if there was
+				 * no IF_OPER_UP notification.
+				 */
+				if (!was_ifup) {
+					ret = wl1271_croc(wl, wl->role_id);
+					if (ret < 0)
+						goto out;
+				}
+				/*
+				 * (we also need to disable roc in case of
+				 * roaming on the same channel. until we will
+				 * have a better flow...)
+				 */
+				if (test_bit(wl->dev_role_id, wl->roc_map)) {
+					ret = wl1271_croc(wl, wl->dev_role_id);
+					if (ret < 0)
+						goto out;
+				}
+
 				wl1271_unjoin(wl);
-				wl1271_dummy_join(wl);
+				if (!(conf_flags & IEEE80211_CONF_IDLE)) {
+					wl1271_cmd_role_start_dev(wl);
+					wl1271_roc(wl, wl->dev_role_id);
+				}
 			}
 		}
 	}
 
 	if (changed & BSS_CHANGED_IBSS) {
 		wl1271_debug(DEBUG_ADHOC, "ibss_joined: %d",
@@ -3378,13 +3421,35 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 	if (do_join) {
 		ret = wl1271_join(wl, set_assoc);
 		if (ret < 0) {
 			wl1271_warning("cmd join failed %d", ret);
 			goto out;
 		}
-		wl1271_check_operstate(wl, ieee80211_get_operstate(vif));
+
+		/* ROC until interface is up (after EAPOL exchange) */
+		if (!is_ibss) {
+			ret = wl1271_roc(wl, wl->role_id);
+			if (ret < 0)
+				goto out;
+
+			wl1271_check_operstate(wl,
+					       ieee80211_get_operstate(vif));
+		}
+		/*
+		 * stop device role if started (we might already be in
+		 * STA role). TODO: make it better.
+		 */
+		if (wl->dev_role_id != WL1271_INVALID_ROLE_ID) {
+			ret = wl1271_croc(wl, wl->dev_role_id);
+			if (ret < 0)
+				goto out;
+
+			ret = wl1271_cmd_role_stop_dev(wl);
+			if (ret < 0)
+				goto out;
+		}
 	}
 
 out:
 	return;
 }
 
diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index b34034c..52f2b6b 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -30,12 +30,13 @@
 #include "ps.h"
 
 void wl1271_scan_complete_work(struct work_struct *work)
 {
 	struct delayed_work *dwork;
 	struct wl1271 *wl;
+	int ret;
 
 	dwork = container_of(work, struct delayed_work, work);
 	wl = container_of(dwork, struct wl1271, scan_complete_work);
 
 	wl1271_debug(DEBUG_SCAN, "Scanning complete");
 
@@ -47,27 +48,34 @@ void wl1271_scan_complete_work(struct work_struct *work)
 	if (wl->scan.state == WL1271_SCAN_STATE_IDLE)
 		goto out;
 
 	wl->scan.state = WL1271_SCAN_STATE_IDLE;
 	memset(wl->scan.scanned_ch, 0, sizeof(wl->scan.scanned_ch));
 	wl->scan.req = NULL;
-	ieee80211_scan_completed(wl->hw, false);
 
-	/* restore hardware connection monitoring template */
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
 	if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags)) {
-		if (wl1271_ps_elp_wakeup(wl) == 0) {
-			wl1271_cmd_build_ap_probe_req(wl, wl->probereq);
-			wl1271_ps_elp_sleep(wl);
-		}
+		/* restore hardware connection monitoring template */
+		wl1271_cmd_build_ap_probe_req(wl, wl->probereq);
+	} else {
+		/* restore remain on channel */
+		wl1271_cmd_role_start_dev(wl);
+		wl1271_roc(wl, wl->dev_role_id);
 	}
+	wl1271_ps_elp_sleep(wl);
 
 	if (wl->scan.failed) {
 		wl1271_info("Scan completed due to error.");
 		wl12xx_queue_recovery_work(wl);
 	}
 
+	ieee80211_scan_completed(wl->hw, false);
+
 out:
 	mutex_unlock(&wl->mutex);
 
 }
 
 
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 6a9be77..ea05caf 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -75,12 +75,13 @@ static void wl1271_free_tx_id(struct wl1271 *wl, int id)
 }
 
 static int wl1271_tx_update_filters(struct wl1271 *wl,
 						 struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr;
+	int ret;
 
 	hdr = (struct ieee80211_hdr *)(skb->data +
 				       sizeof(struct wl1271_tx_hw_descr));
 
 	/*
 	 * stop bssid-based filtering before transmitting authentication
@@ -88,12 +89,24 @@ static int wl1271_tx_update_filters(struct wl1271 *wl,
 	 * responses coming from BSSIDs it isn't familiar with (e.g. on
 	 * roaming)
 	 */
 	if (!ieee80211_is_auth(hdr->frame_control))
 		return 0;
 
+	if (wl->dev_hlid != WL1271_INVALID_LINK_ID)
+		goto out;
+
+	wl1271_debug(DEBUG_CMD, "starting device role for roaming");
+	ret = wl1271_cmd_role_start_dev(wl);
+	if (ret < 0)
+		goto out;
+
+	ret = wl1271_roc(wl, wl->dev_role_id);
+	if (ret < 0)
+		goto out;
+out:
 	return 0;
 }
 
 static void wl1271_tx_ap_update_inconnection_sta(struct wl1271 *wl,
 						 struct sk_buff *skb)
 {
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 9c5daae..37b1d6b 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -316,13 +316,13 @@ struct wl1271_ap_key {
 	u32 tx_seq_32;
 	u16 tx_seq_16;
 };
 
 enum wl12xx_flags {
 	WL1271_FLAG_STA_ASSOCIATED,
-	WL1271_FLAG_JOINED,
+	WL1271_FLAG_ROC,
 	WL1271_FLAG_GPIO_POWER,
 	WL1271_FLAG_TX_QUEUE_STOPPED,
 	WL1271_FLAG_TX_PENDING,
 	WL1271_FLAG_IN_ELP,
 	WL1271_FLAG_ELP_REQUESTED,
 	WL1271_FLAG_PSM,
@@ -399,12 +399,13 @@ struct wl1271 {
 	u8 system_hlid;
 	u8 sta_hlid;
 	u8 dev_hlid;
 
 	unsigned long links_map[BITS_TO_LONGS(WL1271_MAX_LINKS)];
 	unsigned long roles_map[BITS_TO_LONGS(WL1271_MAX_ROLES)];
+	unsigned long roc_map[BITS_TO_LONGS(WL1271_MAX_ROLES)];
 
 	struct wl1271_acx_mem_map *target_mem_map;
 
 	/* Accounting for allocated / available TX blocks on HW */
 	u32 tx_blocks_freed;
 	u32 tx_blocks_available;
-- 
1.7.6.401.g6a319

