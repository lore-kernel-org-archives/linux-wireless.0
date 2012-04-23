Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40830 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab2DWLpC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 07:45:02 -0400
Received: by wgbdr13 with SMTP id dr13so11770989wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 23 Apr 2012 04:45:00 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] mac80211: call ieee80211_mgd_stop() on interface stop
Date: Mon, 23 Apr 2012 14:45:15 +0300
Message-Id: <1335181515-13383-1-git-send-email-eliad@wizery.com> (sfid-20120423_134508_223676_0945F391)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_mgd_teardown() is called on netdev removal, which
occurs after the vif was already removed from the low-level
driver, resulting in the following warning:

[ 4809.014734] ------------[ cut here ]------------
[ 4809.019861] WARNING: at net/mac80211/driver-ops.h:12 ieee80211_bss_info_change_notify+0x200/0x2c8 [mac80211]()
[ 4809.030388] wlan0:  Failed check-sdata-in-driver check, flags: 0x4
[ 4809.036862] Modules linked in: wlcore_sdio(-) wl12xx wlcore mac80211 cfg80211 [last unloaded: cfg80211]
[ 4809.046849] [<c001bd4c>] (unwind_backtrace+0x0/0x12c)
[ 4809.055937] [<c047cf1c>] (dump_stack+0x20/0x24)
[ 4809.065385] [<c003e334>] (warn_slowpath_common+0x5c/0x74)
[ 4809.075589] [<c003e408>] (warn_slowpath_fmt+0x40/0x48)
[ 4809.088291] [<bf033630>] (ieee80211_bss_info_change_notify+0x200/0x2c8 [mac80211])
[ 4809.102844] [<bf067f84>] (ieee80211_destroy_auth_data+0x80/0xa4 [mac80211])
[ 4809.116276] [<bf068004>] (ieee80211_mgd_teardown+0x5c/0x74 [mac80211])
[ 4809.129331] [<bf043f18>] (ieee80211_teardown_sdata+0xb0/0xd8 [mac80211])
[ 4809.141595] [<c03b5e58>] (rollback_registered_many+0x228/0x2f0)
[ 4809.153056] [<c03b5f48>] (unregister_netdevice_many+0x28/0x50)
[ 4809.165696] [<bf041ea8>] (ieee80211_remove_interfaces+0xb4/0xdc [mac80211])
[ 4809.179151] [<bf032174>] (ieee80211_unregister_hw+0x50/0xf0 [mac80211])
[ 4809.191043] [<bf0bebb4>] (wlcore_remove+0x5c/0x7c [wlcore])
[ 4809.201491] [<c02c6918>] (platform_drv_remove+0x24/0x28)
[ 4809.212029] [<c02c4d50>] (__device_release_driver+0x8c/0xcc)
[ 4809.222738] [<c02c4e84>] (device_release_driver+0x30/0x3c)
[ 4809.233099] [<c02c4258>] (bus_remove_device+0x10c/0x128)
[ 4809.242620] [<c02c26f8>] (device_del+0x11c/0x17c)
[ 4809.252150] [<c02c6de0>] (platform_device_del+0x28/0x68)
[ 4809.263051] [<bf0df49c>] (wl1271_remove+0x3c/0x50 [wlcore_sdio])
[ 4809.273590] [<c03806b0>] (sdio_bus_remove+0x48/0xf8)
[ 4809.283754] [<c02c4d50>] (__device_release_driver+0x8c/0xcc)
[ 4809.293729] [<c02c4e2c>] (driver_detach+0x9c/0xc4)
[ 4809.303163] [<c02c3d7c>] (bus_remove_driver+0xc4/0xf4)
[ 4809.312973] [<c02c5a98>] (driver_unregister+0x70/0x7c)
[ 4809.323220] [<c03809c4>] (sdio_unregister_driver+0x24/0x2c)
[ 4809.334213] [<bf0df458>] (wl1271_exit+0x14/0x1c [wlcore_sdio])
[ 4809.344930] [<c009b1a4>] (sys_delete_module+0x228/0x2a8)
[ 4809.354734] ---[ end trace 515290ccf5feb522 ]---

Rename ieee80211_mgd_teardown() to ieee80211_mgd_stop(),
and call it on ieee80211_do_stop().

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v2: rename function, call before flush_work (thanks Johannes)

 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/iface.c       |    4 ++--
 net/mac80211/mlme.c        |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 4be11ea..f813e60 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1231,7 +1231,7 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 				  struct sk_buff *skb);
 void ieee80211_sta_reset_beacon_monitor(struct ieee80211_sub_if_data *sdata);
 void ieee80211_sta_reset_conn_monitor(struct ieee80211_sub_if_data *sdata);
-void ieee80211_mgd_teardown(struct ieee80211_sub_if_data *sdata);
+void ieee80211_mgd_stop(struct ieee80211_sub_if_data *sdata);
 
 /* IBSS code */
 void ieee80211_ibss_notify_scan_completed(struct ieee80211_local *local);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 6e85fae..269c919 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -605,6 +605,8 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		/* free all potentially still buffered bcast frames */
 		local->total_ps_buffered -= skb_queue_len(&sdata->u.ap.ps_bc_buf);
 		skb_queue_purge(&sdata->u.ap.ps_bc_buf);
+	} else if (sdata->vif.type == NL80211_IFTYPE_STATION) {
+		ieee80211_mgd_stop(sdata);
 	}
 
 	if (going_down)
@@ -767,8 +769,6 @@ static void ieee80211_teardown_sdata(struct net_device *dev)
 
 	if (ieee80211_vif_is_mesh(&sdata->vif))
 		mesh_rmc_free(sdata);
-	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
-		ieee80211_mgd_teardown(sdata);
 
 	flushed = sta_info_flush(local, sdata);
 	WARN_ON(flushed);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index bbf1100..5521393 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3512,7 +3512,7 @@ int ieee80211_mgd_disassoc(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
-void ieee80211_mgd_teardown(struct ieee80211_sub_if_data *sdata)
+void ieee80211_mgd_stop(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
-- 
1.7.6.401.g6a319

