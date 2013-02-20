Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42164 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933498Ab3BTCMP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2013 21:12:15 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] mac80211:  Clean up work-queues on disassociation.
Date: Tue, 19 Feb 2013 18:11:07 -0800
Message-Id: <1361326267-16847-1-git-send-email-greearb@candelatech.com> (sfid-20130220_031220_995074_BF5628B4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

The monitor_work and beacon_connection_loss_work items were
not being canceled on disassociation (and not on deletion
either).  This leads to work-items trying to run after memory
has been deleted.

I could not find a cleaner way to do this because the
cancel_work_sync for these items must be done outside
of the ifmgd->mtx.

In addition, re-order the quiesce code so that timers are
always stopped before work-items are flushed.  This was
not the problem I saw, but I think it may still be more
correct.

This fixes the crashes we see in 3.7.9+.  The crash stack
trace itself isn't so helpful, but this warning gives
more useful info:

------------[ cut here ]------------
WARNING: at /home/greearb/git/linux-3.7.dev.y/lib/debugobjects.c:261 debug_print_object+0x7c/0x8d()
Hardware name: To be filled by O.E.M.
ODEBUG: free active (active state 0) object type: work_struct hint: ieee80211_sta_monitor_work+0x0/0x14 [mac80211]
Modules linked in: nf_nat_ipv4 nf_nat 8021q garp stp llc macvlan pktgen lockd sunrpc f71882fg iTCO_wdt iTCO_vendor_support coretemp gpio_ich hwmon mperf kvm cdc_acm snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep microcode snd_seq snd_seq_device serio_raw pcspkr snd_pcm ath9k ath9k_common ath9k_hw ath i2c_i801 ppdev mac80211 lpc_ich cfg80211 snd_page_alloc e1000e snd_timer snd soundcore parport_pc parport uinput ipv6 i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: iptable_nat]
Pid: 14743, comm: iw Tainted: G         C O 3.7.9+ #11
Call Trace:
 [<ffffffff81087ef8>] warn_slowpath_common+0x80/0x98
 [<ffffffff81087fa4>] warn_slowpath_fmt+0x41/0x43
 [<ffffffff812a2608>] debug_print_object+0x7c/0x8d
 [<ffffffffa025f5ad>] ? ieee80211_beacon_connection_loss_work+0x88/0x88 [mac80211]
 [<ffffffff812a2b9a>] ? debug_check_no_obj_freed+0x65/0x1c3
 [<ffffffff812a2bca>] debug_check_no_obj_freed+0x95/0x1c3
 [<ffffffff8149f465>] ? netdev_release+0x39/0x3e
 [<ffffffff8114cc69>] slab_free_hook+0x70/0x79
 [<ffffffff8114ea3e>] kfree+0x62/0xb7
 [<ffffffff8149f465>] netdev_release+0x39/0x3e
 [<ffffffff8136ad67>] device_release+0x52/0x8a
 [<ffffffff812937db>] kobject_release+0x121/0x158
 [<ffffffff81293612>] kobject_put+0x4c/0x50
 [<ffffffff8148f0d7>] netdev_run_todo+0x25c/0x27e
 [<ffffffff8149b2a0>] rtnl_unlock+0x9/0xb
 [<ffffffffa01d31a7>] nl80211_post_doit+0x49/0x4e [cfg80211]
 [<ffffffff814b0928>] genl_rcv_msg+0x25b/0x288
 [<ffffffff814b06a3>] ? genl_lock+0x12/0x14
 [<ffffffff814b06cd>] ? genl_rcv+0x28/0x28
 [<ffffffff814aef13>] netlink_rcv_skb+0x3e/0x8f
 [<ffffffff814b06c6>] genl_rcv+0x21/0x28
 [<ffffffff814aecd1>] netlink_unicast+0xe9/0x16f
 [<ffffffff814af4b3>] netlink_sendmsg+0x264/0x282
 [<ffffffff8147d785>] ? rcu_read_unlock+0x5b/0x5d
 [<ffffffff814784ab>] __sock_sendmsg_nosec+0x58/0x61
 [<ffffffff814798e6>] __sock_sendmsg+0x3d/0x48
 [<ffffffff8147995a>] sock_sendmsg+0x69/0x82
 [<ffffffff8112c835>] ? might_fault+0x84/0x8b
 [<ffffffff814849ce>] ? copy_from_user+0x2a/0x2c
 [<ffffffff81484da0>] ? verify_iovec+0x4f/0xa3
 [<ffffffff8147b8e7>] __sys_sendmsg+0x1fe/0x280
 [<ffffffff810a8058>] ? up_read+0x1e/0x36
 [<ffffffff8116ea14>] ? fcheck_files+0xac/0xea
 [<ffffffff8116efd3>] ? fget_light+0x35/0xae
 [<ffffffff8147badb>] sys_sendmsg+0x3d/0x5b
 [<ffffffff815595e9>] system_call_fastpath+0x16/0x1b
---[ end trace 791ff0751a368327 ]---

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

NOTE:  Please do not apply this until it is reviewed by Johannes,
at least.

 net/mac80211/mlme.c |   68 +++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 61 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 164ecf0..5a65144 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1725,6 +1725,10 @@ static void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata,
 	ifmgd->flags &= ~IEEE80211_STA_CSA_RECEIVED;
 	mutex_unlock(&ifmgd->mtx);
 
+	/* Have to do this outside the ifmgd->mtx lock. */
+	cancel_work_sync(&ifmgd->monitor_work);
+	cancel_work_sync(&ifmgd->beacon_connection_loss_work);
+
 	/*
 	 * must be outside lock due to cfg80211,
 	 * but that's not a problem.
@@ -2579,6 +2583,7 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 	struct cfg80211_bss *bss = NULL;
 	enum rx_mgmt_action rma = RX_MGMT_NONE;
 	u16 fc;
+	bool cancel_work = false;
 
 	rx_status = (struct ieee80211_rx_status *) skb->cb;
 	mgmt = (struct ieee80211_mgmt *) skb->data;
@@ -2598,9 +2603,11 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 		break;
 	case IEEE80211_STYPE_DEAUTH:
 		rma = ieee80211_rx_mgmt_deauth(sdata, mgmt, skb->len);
+		cancel_work = true;
 		break;
 	case IEEE80211_STYPE_DISASSOC:
 		rma = ieee80211_rx_mgmt_disassoc(sdata, mgmt, skb->len);
+		cancel_work = true;
 		break;
 	case IEEE80211_STYPE_ASSOC_RESP:
 	case IEEE80211_STYPE_REASSOC_RESP:
@@ -2618,6 +2625,12 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 	}
 	mutex_unlock(&ifmgd->mtx);
 
+	if (cancel_work) {
+		/* Have to do this outside the ifmgd->mtx lock. */
+		cancel_work_sync(&ifmgd->monitor_work);
+		cancel_work_sync(&ifmgd->beacon_connection_loss_work);
+	}
+
 	switch (rma) {
 	case RX_MGMT_NONE:
 		/* no action */
@@ -2668,6 +2681,10 @@ static void ieee80211_sta_connection_lost(struct ieee80211_sub_if_data *sdata,
 			       false, frame_buf);
 	mutex_unlock(&ifmgd->mtx);
 
+	/* Have to do this outside the ifmgd->mtx lock. */
+	cancel_work_sync(&ifmgd->monitor_work);
+	cancel_work_sync(&ifmgd->beacon_connection_loss_work);
+
 	/*
 	 * must be outside lock due to cfg80211,
 	 * but that's not a problem.
@@ -2946,6 +2963,13 @@ void ieee80211_sta_quiesce(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
+	/* Stop timers before deleting work items, as timers could
+	 * race and re-add the work-items.
+	 * These will be re-established on connection.
+	 */
+	del_timer_sync(&ifmgd->conn_mon_timer);
+	del_timer_sync(&ifmgd->bcn_mon_timer);
+
 	/*
 	 * we need to use atomic bitops for the running bits
 	 * only because both timers might fire at the same
@@ -2954,19 +2978,15 @@ void ieee80211_sta_quiesce(struct ieee80211_sub_if_data *sdata)
 
 	cancel_work_sync(&ifmgd->request_smps_work);
 
+	sdata_err(sdata, "Cancel-work-sync monitor_work, sta_quiesce.\n");
 	cancel_work_sync(&ifmgd->monitor_work);
 	cancel_work_sync(&ifmgd->beacon_connection_loss_work);
 	cancel_work_sync(&ifmgd->csa_connection_drop_work);
 	if (del_timer_sync(&ifmgd->timer))
 		set_bit(TMR_RUNNING_TIMER, &ifmgd->timers_running);
 
-	cancel_work_sync(&ifmgd->chswitch_work);
 	if (del_timer_sync(&ifmgd->chswitch_timer))
 		set_bit(TMR_RUNNING_CHANSW, &ifmgd->timers_running);
-
-	/* these will just be re-established on connection */
-	del_timer_sync(&ifmgd->conn_mon_timer);
-	del_timer_sync(&ifmgd->bcn_mon_timer);
 }
 
 void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata)
@@ -3262,6 +3282,8 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_mgd_auth_data *auth_data;
 	u16 auth_alg;
 	int err;
+	bool maybe_cancel_work = false;
+	bool hit_err_clear = false;
 
 	/* prepare auth data structure */
 
@@ -3319,8 +3341,10 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 	/* prep auth_data so we don't go into idle on disassoc */
 	ifmgd->auth_data = auth_data;
 
-	if (ifmgd->associated)
+	if (ifmgd->associated) {
+		maybe_cancel_work = true;
 		ieee80211_set_disassoc(sdata, 0, 0, false, NULL);
+	}
 
 	sdata_info(sdata, "authenticate with %pM\n", req->bss->bssid);
 
@@ -3340,6 +3364,7 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 	goto out_unlock;
 
  err_clear:
+	hit_err_clear = true;
 	memset(ifmgd->bssid, 0, ETH_ALEN);
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BSSID);
 	ifmgd->auth_data = NULL;
@@ -3348,6 +3373,12 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
  out_unlock:
 	mutex_unlock(&ifmgd->mtx);
 
+	if (maybe_cancel_work && hit_err_clear) {
+		/* Have to do this outside the ifmgd->mtx lock. */
+		cancel_work_sync(&ifmgd->monitor_work);
+		cancel_work_sync(&ifmgd->beacon_connection_loss_work);
+	}
+
 	return err;
 }
 
@@ -3361,6 +3392,8 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_supported_band *sband;
 	const u8 *ssidie, *ht_ie;
 	int i, err;
+	bool maybe_cancel_work = false;
+	bool hit_err_state = false;
 
 	ssidie = ieee80211_bss_get_ie(req->bss, WLAN_EID_SSID);
 	if (!ssidie)
@@ -3372,8 +3405,10 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 
 	mutex_lock(&ifmgd->mtx);
 
-	if (ifmgd->associated)
+	if (ifmgd->associated) {
+		maybe_cancel_work = true;
 		ieee80211_set_disassoc(sdata, 0, 0, false, NULL);
+	}
 
 	if (ifmgd->auth_data && !ifmgd->auth_data->done) {
 		err = -EBUSY;
@@ -3555,9 +3590,16 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	ifmgd->assoc_data = NULL;
  err_free:
 	kfree(assoc_data);
+	hit_err_state = true;
  out:
 	mutex_unlock(&ifmgd->mtx);
 
+	if (maybe_cancel_work && hit_err_state) {
+		/* Have to do this outside the ifmgd->mtx lock. */
+		cancel_work_sync(&ifmgd->monitor_work);
+		cancel_work_sync(&ifmgd->beacon_connection_loss_work);
+	}
+
 	return err;
 }
 
@@ -3567,6 +3609,7 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	u8 frame_buf[IEEE80211_DEAUTH_FRAME_LEN];
 	bool tx = !req->local_state_change;
+	bool cancel_work = false;
 
 	mutex_lock(&ifmgd->mtx);
 
@@ -3584,6 +3627,7 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 	    ether_addr_equal(ifmgd->associated->bssid, req->bssid)) {
 		ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
 				       req->reason_code, tx, frame_buf);
+		cancel_work = true;
 	} else {
 		drv_mgd_prepare_tx(sdata->local, sdata);
 		ieee80211_send_deauth_disassoc(sdata, req->bssid,
@@ -3594,6 +3638,12 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 
 	mutex_unlock(&ifmgd->mtx);
 
+	if (cancel_work) {
+		/* Have to do this outside the ifmgd->mtx lock. */
+		cancel_work_sync(&ifmgd->monitor_work);
+		cancel_work_sync(&ifmgd->beacon_connection_loss_work);
+	}
+
 	__cfg80211_send_deauth(sdata->dev, frame_buf,
 			       IEEE80211_DEAUTH_FRAME_LEN);
 
@@ -3634,6 +3684,10 @@ int ieee80211_mgd_disassoc(struct ieee80211_sub_if_data *sdata,
 			       frame_buf);
 	mutex_unlock(&ifmgd->mtx);
 
+	/* Have to do this outside the ifmgd->mtx lock. */
+	cancel_work_sync(&ifmgd->monitor_work);
+	cancel_work_sync(&ifmgd->beacon_connection_loss_work);
+
 	__cfg80211_send_disassoc(sdata->dev, frame_buf,
 				 IEEE80211_DEAUTH_FRAME_LEN);
 
-- 
1.7.3.4

