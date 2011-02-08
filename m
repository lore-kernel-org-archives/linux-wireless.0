Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60716 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab1BHQnF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 11:43:05 -0500
Received: by eye27 with SMTP id 27so3074199eye.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 Feb 2011 08:43:04 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] mac80211: add missing locking in ieee80211_reconfig
Date: Tue,  8 Feb 2011 18:43:19 +0200
Message-Id: <1297183399-2296-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When suspending an associated system, and then resuming,
the station vif is being reconfigured without taking the
sdata->u.mgd.mtx lock, which results in the following warning:

WARNING: at net/mac80211/mlme.c:101 ieee80211_ap_probereq_get+0x58/0xb8 [mac80211]()
Modules linked in: wl12xx_sdio wl12xx firmware_class crc7 mac80211 cfg80211 [last unloaded: crc7]
Backtrace:
[<c005432c>] (dump_backtrace+0x0/0x118) from [<c0376e28>] (dump_stack+0x20/0x24)
 r7:00000000 r6:bf12d6ec r5:bf154aac r4:00000065
[<c0376e08>] (dump_stack+0x0/0x24) from [<c0079104>] (warn_slowpath_common+0x5c/0x74)
[<c00790a8>] (warn_slowpath_common+0x0/0x74) from [<c0079148>] (warn_slowpath_null+0x2c/0x34)
 r9:000024ff r8:cd006460 r7:00000001 r6:00000000 r5:00000000
r4:cf1394a0
[<c007911c>] (warn_slowpath_null+0x0/0x34) from [<bf12d6ec>] (ieee80211_ap_probereq_get+0x58/0xb8 [mac80211])
[<bf12d694>] (ieee80211_ap_probereq_get+0x0/0xb8 [mac80211]) from [<bf19cd04>] (wl1271_cmd_build_ap_probe_req+0x30/0xf8 [wl12xx])
 r4:cd007440
[<bf19ccd4>] (wl1271_cmd_build_ap_probe_req+0x0/0xf8 [wl12xx]) from [<bf1995f4>] (wl1271_op_bss_info_changed+0x4c4/0x808 [wl12xx])
 r5:cd007440 r4:000003b4
[<bf199130>] (wl1271_op_bss_info_changed+0x0/0x808 [wl12xx]) from [<bf122168>] (ieee80211_bss_info_change_notify+0x1a4/0x1f8 [mac80211])
[<bf121fc4>] (ieee80211_bss_info_change_notify+0x0/0x1f8 [mac80211]) from [<bf141e80>] (ieee80211_reconfig+0x4d0/0x668 [mac80211])
 r8:cf0eeea4 r7:cd00671c r6:00000000 r5:cd006460 r4:cf1394a0
[<bf1419b0>] (ieee80211_reconfig+0x0/0x668 [mac80211]) from [<bf137dd4>] (ieee80211_resume+0x60/0x70 [mac80211])
[<bf137d74>] (ieee80211_resume+0x0/0x70 [mac80211]) from [<bf0eb930>] (wiphy_resume+0x6c/0x7c [cfg80211])
 r5:cd006248 r4:cd006110
[<bf0eb8c4>] (wiphy_resume+0x0/0x7c [cfg80211]) from [<c0241024>] (legacy_resume+0x38/0x70)
 r7:00000000 r6:00000000 r5:cd006248 r4:cd0062fc
[<c0240fec>] (legacy_resume+0x0/0x70) from [<c0241478>] (device_resume+0x168/0x1a0)
 r8:c04ca8d8 r7:cd00627c r6:00000010 r5:cd006248 r4:cd0062fc
[<c0241310>] (device_resume+0x0/0x1a0) from [<c0241600>] (dpm_resume_end+0xf8/0x3bc)
 r7:00000000 r6:00000005 r5:cd006248 r4:cd0062fc
[<c0241508>] (dpm_resume_end+0x0/0x3bc) from [<c00b2a24>] (suspend_devices_and_enter+0x1b0/0x204)
[<c00b2874>] (suspend_devices_and_enter+0x0/0x204) from [<c00b2b68>] (enter_state+0xf0/0x148)
 r7:c037e978 r6:00000003 r5:c043d807 r4:00000000
[<c00b2a78>] (enter_state+0x0/0x148) from [<c00b20a4>] (state_store+0xa4/0xcc)
 r7:c037e978 r6:00000003 r5:00000003 r4:c043d807
[<c00b2000>] (state_store+0x0/0xcc) from [<c01fc90c>] (kobj_attr_store+0x20/0x24)
[<c01fc8ec>] (kobj_attr_store+0x0/0x24) from [<c0157120>] (sysfs_write_file+0x11c/0x150)
[<c0157004>] (sysfs_write_file+0x0/0x150) from [<c0100f84>] (vfs_write+0xc0/0x14c)
[<c0100ec4>] (vfs_write+0x0/0x14c) from [<c01010e4>] (sys_write+0x4c/0x78)
 r8:40126000 r7:00000004 r6:cf1a7c80 r5:00000000 r4:00000000
[<c0101098>] (sys_write+0x0/0x78) from [<c00500c0>] (ret_fast_syscall+0x0/0x30)
 r8:c00502c8 r7:00000004 r6:403525e8 r5:40126000 r4:00000004

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v1 -> v2: don't truncate warning lines

 net/mac80211/util.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index cf68700..d036597 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1210,7 +1210,9 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		switch (sdata->vif.type) {
 		case NL80211_IFTYPE_STATION:
 			changed |= BSS_CHANGED_ASSOC;
+			mutex_lock(&sdata->u.mgd.mtx);
 			ieee80211_bss_info_change_notify(sdata, changed);
+			mutex_unlock(&sdata->u.mgd.mtx);
 			break;
 		case NL80211_IFTYPE_ADHOC:
 			changed |= BSS_CHANGED_IBSS;
-- 
1.7.0.4

