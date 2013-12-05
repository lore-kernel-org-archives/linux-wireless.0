Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:64039 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab3LEJVk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 04:21:40 -0500
Received: by mail-ee0-f48.google.com with SMTP id e49so3037614eek.7
        for <linux-wireless@vger.kernel.org>; Thu, 05 Dec 2013 01:21:39 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/4] mac80211: determine completed scan type by defined ops
Date: Thu,  5 Dec 2013 11:21:27 +0200
Message-Id: <1386235289-27278-2-git-send-email-eliad@wizery.com> (sfid-20131205_102147_309358_622F3EB7)
In-Reply-To: <1386235289-27278-1-git-send-email-eliad@wizery.com>
References: <1386235289-27278-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In some cases, determining the completed scan type was
done by testing the SCAN_HW_SCANNING flag.

However, this doesn't take care for the case in which
the hw scan was requested, but hasn't started yet (e.g.
due to active remain_on_channel).

Replace this test by checking whether ops->hw_scan is
defined.

This solves the following warning:

WARNING: CPU: 0 PID: 3552 at net/mac80211/offchannel.c:156 __ieee80211_scan_completed+0x1b4/0x2dc [mac80211]()
[<c001cd38>] (unwind_backtrace+0x0/0xf0)
[<c00181d0>] (show_stack+0x10/0x14)
[<c05c0d8c>] (dump_stack+0x78/0x94)
[<c0047c08>] (warn_slowpath_common+0x68/0x8c)
[<c0047c48>] (warn_slowpath_null+0x1c/0x24)
[<bf4d4504>] (__ieee80211_scan_completed+0x1b4/0x2dc [mac80211])
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
 net/mac80211/scan.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 618267b..e4baa53 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -271,10 +271,10 @@ static bool ieee80211_prep_hw_scan(struct ieee80211_local *local)
 	return true;
 }
 
-static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted,
-				       bool was_hw_scan)
+static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
+	bool hw_scan = local->ops->hw_scan;
 
 	lockdep_assert_held(&local->mtx);
 
@@ -290,7 +290,7 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted,
 	if (WARN_ON(!local->scan_req))
 		return;
 
-	if (was_hw_scan && !aborted && ieee80211_prep_hw_scan(local)) {
+	if (hw_scan && !aborted && ieee80211_prep_hw_scan(local)) {
 		int rc;
 
 		rc = drv_hw_scan(local,
@@ -316,7 +316,7 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted,
 	/* Set power back to normal operating levels. */
 	ieee80211_hw_config(local, 0);
 
-	if (!was_hw_scan) {
+	if (!hw_scan) {
 		ieee80211_configure_filter(local);
 		drv_sw_scan_complete(local);
 		ieee80211_offchannel_return(local);
@@ -751,7 +751,7 @@ void ieee80211_scan_work(struct work_struct *work)
 		container_of(work, struct ieee80211_local, scan_work.work);
 	struct ieee80211_sub_if_data *sdata;
 	unsigned long next_delay = 0;
-	bool aborted, hw_scan;
+	bool aborted;
 
 	mutex_lock(&local->mtx);
 
@@ -838,8 +838,7 @@ void ieee80211_scan_work(struct work_struct *work)
 	goto out;
 
 out_complete:
-	hw_scan = test_bit(SCAN_HW_SCANNING, &local->scanning);
-	__ieee80211_scan_completed(&local->hw, aborted, hw_scan);
+	__ieee80211_scan_completed(&local->hw, aborted);
 out:
 	mutex_unlock(&local->mtx);
 }
@@ -977,7 +976,7 @@ void ieee80211_scan_cancel(struct ieee80211_local *local)
 	 */
 	cancel_delayed_work(&local->scan_work);
 	/* and clean up */
-	__ieee80211_scan_completed(&local->hw, true, false);
+	__ieee80211_scan_completed(&local->hw, true);
 out:
 	mutex_unlock(&local->mtx);
 }
-- 
1.8.5.rc1

