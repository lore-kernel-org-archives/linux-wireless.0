Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36091 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab0H3WOq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 18:14:46 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Miles Lane <miles.lane@gmail.com>, rjw@sisk.pl,
	maciej.rutecki@gmail.com, johannes@sipsolutions.net,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2.6.36] wireless: register wiphy rfkill w/o holding cfg80211_mutex
Date: Mon, 30 Aug 2010 18:10:22 -0400
Message-Id: <1283206222-21830-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Otherwise lockdep complains...

https://bugzilla.kernel.org/show_bug.cgi?id=17311

[ INFO: possible circular locking dependency detected ]
2.6.36-rc2-git4 #12
-------------------------------------------------------
kworker/0:3/3630 is trying to acquire lock:
 (rtnl_mutex){+.+.+.}, at: [<ffffffff813396c7>] rtnl_lock+0x12/0x14

but task is already holding lock:
 (rfkill_global_mutex){+.+.+.}, at: [<ffffffffa014b129>]
rfkill_switch_all+0x24/0x49 [rfkill]

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #2 (rfkill_global_mutex){+.+.+.}:
       [<ffffffff81079ad7>] lock_acquire+0x120/0x15b
       [<ffffffff813ae869>] __mutex_lock_common+0x54/0x52e
       [<ffffffff813aede9>] mutex_lock_nested+0x34/0x39
       [<ffffffffa014b4ab>] rfkill_register+0x2b/0x29c [rfkill]
       [<ffffffffa0185ba0>] wiphy_register+0x1ae/0x270 [cfg80211]
       [<ffffffffa0206f01>] ieee80211_register_hw+0x1b4/0x3cf [mac80211]
       [<ffffffffa0292e98>] iwl_ucode_callback+0x9e9/0xae3 [iwlagn]
       [<ffffffff812d3e9d>] request_firmware_work_func+0x54/0x6f
       [<ffffffff81065d15>] kthread+0x8c/0x94
       [<ffffffff8100ac24>] kernel_thread_helper+0x4/0x10

-> #1 (cfg80211_mutex){+.+.+.}:
       [<ffffffff81079ad7>] lock_acquire+0x120/0x15b
       [<ffffffff813ae869>] __mutex_lock_common+0x54/0x52e
       [<ffffffff813aede9>] mutex_lock_nested+0x34/0x39
       [<ffffffffa018605e>] cfg80211_get_dev_from_ifindex+0x1b/0x7c [cfg80211]
       [<ffffffffa0189f36>] cfg80211_wext_giwscan+0x58/0x990 [cfg80211]
       [<ffffffff8139a3ce>] ioctl_standard_iw_point+0x1a8/0x272
       [<ffffffff8139a529>] ioctl_standard_call+0x91/0xa7
       [<ffffffff8139a687>] T.723+0xbd/0x12c
       [<ffffffff8139a727>] wext_handle_ioctl+0x31/0x6d
       [<ffffffff8133014e>] dev_ioctl+0x63d/0x67a
       [<ffffffff8131afd9>] sock_ioctl+0x48/0x21d
       [<ffffffff81102abd>] do_vfs_ioctl+0x4ba/0x509
       [<ffffffff81102b5d>] sys_ioctl+0x51/0x74
       [<ffffffff81009e02>] system_call_fastpath+0x16/0x1b

-> #0 (rtnl_mutex){+.+.+.}:
       [<ffffffff810796b0>] __lock_acquire+0xa93/0xd9a
       [<ffffffff81079ad7>] lock_acquire+0x120/0x15b
       [<ffffffff813ae869>] __mutex_lock_common+0x54/0x52e
       [<ffffffff813aede9>] mutex_lock_nested+0x34/0x39
       [<ffffffff813396c7>] rtnl_lock+0x12/0x14
       [<ffffffffa0185cb5>] cfg80211_rfkill_set_block+0x1a/0x7b [cfg80211]
       [<ffffffffa014aed0>] rfkill_set_block+0x80/0xd5 [rfkill]
       [<ffffffffa014b07e>] __rfkill_switch_all+0x3f/0x6f [rfkill]
       [<ffffffffa014b13d>] rfkill_switch_all+0x38/0x49 [rfkill]
       [<ffffffffa014b821>] rfkill_op_handler+0x105/0x136 [rfkill]
       [<ffffffff81060708>] process_one_work+0x248/0x403
       [<ffffffff81062620>] worker_thread+0x139/0x214
       [<ffffffff81065d15>] kthread+0x8c/0x94
       [<ffffffff8100ac24>] kernel_thread_helper+0x4/0x10

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/wireless/core.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 541e2ff..d80c1d5 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -472,16 +472,16 @@ int wiphy_register(struct wiphy *wiphy)
 	/* check and set up bitrates */
 	ieee80211_set_bitrate_flags(wiphy);
 
+	res = rfkill_register(rdev->rfkill);
+	if (res)
+		return res;
+
 	mutex_lock(&cfg80211_mutex);
 
 	res = device_add(&rdev->wiphy.dev);
 	if (res)
 		goto out_unlock;
 
-	res = rfkill_register(rdev->rfkill);
-	if (res)
-		goto out_rm_dev;
-
 	/* set up regulatory info */
 	wiphy_update_regulatory(wiphy, NL80211_REGDOM_SET_BY_CORE);
 
@@ -511,9 +511,6 @@ int wiphy_register(struct wiphy *wiphy)
 
 	return 0;
 
-out_rm_dev:
-	device_del(&rdev->wiphy.dev);
-
 out_unlock:
 	mutex_unlock(&cfg80211_mutex);
 	return res;
-- 
1.7.2.2

