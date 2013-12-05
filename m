Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:36770 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab3LEJVm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 04:21:42 -0500
Received: by mail-ee0-f41.google.com with SMTP id t10so3077329eei.14
        for <linux-wireless@vger.kernel.org>; Thu, 05 Dec 2013 01:21:41 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/4] mac80211: start_next_roc only if scan was actually running
Date: Thu,  5 Dec 2013 11:21:28 +0200
Message-Id: <1386235289-27278-3-git-send-email-eliad@wizery.com> (sfid-20131205_102148_609669_F21763C2)
In-Reply-To: <1386235289-27278-1-git-send-email-eliad@wizery.com>
References: <1386235289-27278-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On scan completion we try start any pending roc.

However, if scan was just pending (and not actually started)
there is no point in trying to start the roc, as it might
have started already.

This solves the following warning:
WARNING: CPU: 0 PID: 3552 at net/mac80211/offchannel.c:269 ieee80211_start_next_roc+0x164/0x204 [mac80211]()
[<c001cd38>] (unwind_backtrace+0x0/0xf0)
[<c00181d0>] (show_stack+0x10/0x14)
[<c05c0d8c>] (dump_stack+0x78/0x94)
[<c0047c08>] (warn_slowpath_common+0x68/0x8c)
[<c0047c48>] (warn_slowpath_null+0x1c/0x24)
[<bf4d6660>] (ieee80211_start_next_roc+0x164/0x204 [mac80211])
[<bf4d5a74>] (ieee80211_scan_cancel+0xe8/0x190 [mac80211])
[<bf4df970>] (ieee80211_do_stop+0x63c/0x79c [mac80211])
[<bf4dfae0>] (ieee80211_stop+0x10/0x18 [mac80211])
[<c0504d84>] (__dev_close_many+0x84/0xcc)
[<c0504df4>] (__dev_close+0x28/0x3c)
[<c0509708>] (__dev_change_flags+0x78/0x144)
[<c0509854>] (dev_change_flags+0x10/0x48)
[<c055fe3c>] (devinet_ioctl+0x614/0x6d0)
[<c04f22a0>] (sock_ioctl+0x5c/0x2a4)
[<c0124eb4>] (do_vfs_ioctl+0x7c/0x5d8)
[<c012547c>] (SyS_ioctl+0x6c/0x7c)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/scan.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index e4baa53..d887b25 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -275,6 +275,7 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	bool hw_scan = local->ops->hw_scan;
+	bool was_scanning = local->scanning;
 
 	lockdep_assert_held(&local->mtx);
 
@@ -327,7 +328,8 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 	ieee80211_mlme_notify_scan_completed(local);
 	ieee80211_ibss_notify_scan_completed(local);
 	ieee80211_mesh_notify_scan_completed(local);
-	ieee80211_start_next_roc(local);
+	if (was_scanning)
+		ieee80211_start_next_roc(local);
 }
 
 void ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
-- 
1.8.5.rc1

