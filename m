Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36272 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216Ab3BTRli (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 12:41:38 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 2/2] mac80211:  Fix crash due to un-canceled work-items.
Date: Wed, 20 Feb 2013 09:41:09 -0800
Message-Id: <1361382069-31729-2-git-send-email-greearb@candelatech.com> (sfid-20130220_184141_297767_ED9451D7)
In-Reply-To: <1361382069-31729-1-git-send-email-greearb@candelatech.com>
References: <1361382069-31729-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

The monitor_work and beacon_connection_loss_work items were
not being canceled on disassociation (and not on deletion
either).  This leads to work-items trying to run after memory
has been deleted.

There is not a clean way to cancel these in the disassociation
logic because they must be canceled outside of the ifmgd->mtx
lock, so just cancel them in mgd_stop logic that tears down
the station.

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
 net/mac80211/mlme.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 4001d1c..f46607a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3651,6 +3651,12 @@ void ieee80211_mgd_stop(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
+	/* Make sure some work items will not run after this.
+	 * Have to do this outside the ifmgd->mtx lock.
+	 */
+	cancel_work_sync(&ifmgd->monitor_work);
+	cancel_work_sync(&ifmgd->beacon_connection_loss_work);
+
 	mutex_lock(&ifmgd->mtx);
 	if (ifmgd->assoc_data)
 		ieee80211_destroy_assoc_data(sdata, false);
-- 
1.7.3.4

