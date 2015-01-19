Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:1744 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbbASOxM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2015 09:53:12 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: delete the assoc/auth timer upon suspend
Date: Mon, 19 Jan 2015 16:53:06 +0200
Message-Id: <1421679186-10898-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150119_155319_333226_10864298)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While suspending, we destroy the authentication /
association that might be taking place. While doing so, we
forgot to delete the timer which can be firing after
local->suspended is already set, producing the warning below.

Fix that by deleting the timer.

[66722.825487] WARNING: CPU: 2 PID: 5612 at net/mac80211/util.c:755 ieee80211_can_queue_work.isra.18+0x32/0x40 [mac80211]()
[66722.825487] queueing ieee80211 work while going to suspend
[66722.825529] CPU: 2 PID: 5612 Comm: kworker/u16:69 Tainted: G        W  O  3.16.1+ #24
[66722.825537] Workqueue: events_unbound async_run_entry_fn
[66722.825545] Call Trace:
[66722.825552]  <IRQ>  [<ffffffff817edbb2>] dump_stack+0x4d/0x66
[66722.825556]  [<ffffffff81075cad>] warn_slowpath_common+0x7d/0xa0
[66722.825572]  [<ffffffffa06b5b90>] ? ieee80211_sta_bcn_mon_timer+0x50/0x50 [mac80211]
[66722.825573]  [<ffffffff81075d1c>] warn_slowpath_fmt+0x4c/0x50
[66722.825586]  [<ffffffffa06977a2>] ieee80211_can_queue_work.isra.18+0x32/0x40 [mac80211]
[66722.825598]  [<ffffffffa06977d5>] ieee80211_queue_work+0x25/0x50 [mac80211]
[66722.825611]  [<ffffffffa06b5bac>] ieee80211_sta_timer+0x1c/0x20 [mac80211]
[66722.825614]  [<ffffffff8108655a>] call_timer_fn+0x8a/0x300

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/mlme.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 1d6bf01..cd86dd4 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2458,6 +2458,12 @@ static void ieee80211_destroy_auth_data(struct ieee80211_sub_if_data *sdata,
 	sdata_assert_lock(sdata);
 
 	if (!assoc) {
+		/*
+		 * we are not authenticated yet, the only timer that could be
+		 * running is the timeout for the authentication response which
+		 * which is not relevant anymore.
+		 */
+		del_timer_sync(&sdata->u.mgd.timer);
 		sta_info_destroy_addr(sdata, auth_data->bss->bssid);
 
 		memset(sdata->u.mgd.bssid, 0, ETH_ALEN);
@@ -2765,6 +2771,12 @@ static void ieee80211_destroy_assoc_data(struct ieee80211_sub_if_data *sdata,
 	sdata_assert_lock(sdata);
 
 	if (!assoc) {
+		/*
+		 * we are not associated yet, the only timer that could be
+		 * running is the timeout for the association response which
+		 * which is not relevant anymore.
+		 */
+		del_timer_sync(&sdata->u.mgd.timer);
 		sta_info_destroy_addr(sdata, assoc_data->bss->bssid);
 
 		memset(sdata->u.mgd.bssid, 0, ETH_ALEN);
-- 
1.9.1

