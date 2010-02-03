Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60616 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091Ab0BCJVz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2010 04:21:55 -0500
Subject: [PATCH] mac80211: fix deferred hardware scan requests
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: reinette.chatre@intel.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Feb 2010 10:21:41 +0100
Message-ID: <1265188901.29119.85.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reinette found the reason for the warnings that
happened occasionally when a hw-offloaded scan
finished; her description of the problem:

  mac80211 will defer the handling of scan requests if it is
  busy with management work at the time. The scan requests
  are deferred and run after the work has completed. When
  this occurs there are currently two problems.

  * The scan request for hardware scan is not fully populated
    with the band and channels to scan not initialized.

  * When the scan is queued the state is not correctly updated
    to reflect that a scan is in progress. The problem here is
    that when the driver completes the scan and calls
    ieee80211_scan_completed() a warning will be triggered
    since mac80211 was not aware that a scan was in progress.

The reason is that the queued scan work will start
the hw scan right away when the hw_scan_req struct
has already been allocated. However, in the first
pass it will not have been filled, which happens
at the same time as setting the bits. To fix this,
simply move the allocation after the pending work
test as well, so that the first iteration of the
scan work will call __ieee80211_start_scan() even
in the hardware scan case.

Also, fix a wrong locking comment that I noticed,
a dependency between those two mutexes exists but
others are potentially avoided (especially with
driver locks).

Bug-identified-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/scan.c |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

--- wireless-testing.orig/net/mac80211/scan.c	2010-02-03 09:53:28.000000000 +0100
+++ wireless-testing/net/mac80211/scan.c	2010-02-03 10:05:59.000000000 +0100
@@ -345,6 +345,13 @@ static int __ieee80211_start_scan(struct
 	if (local->scan_req)
 		return -EBUSY;
 
+	if (!list_empty(&local->work_list)) {
+		/* wait for the work to finish/time out */
+		local->scan_req = req;
+		local->scan_sdata = sdata;
+		return 0;
+	}
+
 	if (local->ops->hw_scan) {
 		u8 *ies;
 
@@ -364,29 +371,33 @@ static int __ieee80211_start_scan(struct
 		local->hw_scan_req->ie = ies;
 
 		local->hw_scan_band = 0;
+
+		/*
+		 * After allocating local->hw_scan_req, we must
+		 * go through until ieee80211_prep_hw_scan(), so
+		 * anything that might be changed here and leave
+		 * this function early must not go after this
+		 * allocation.
+		 */
 	}
 
 	local->scan_req = req;
 	local->scan_sdata = sdata;
 
-	if (!list_empty(&local->work_list)) {
-		/* wait for the work to finish/time out */
-		return 0;
-	}
-
 	if (local->ops->hw_scan)
 		__set_bit(SCAN_HW_SCANNING, &local->scanning);
 	else
 		__set_bit(SCAN_SW_SCANNING, &local->scanning);
+
 	/*
 	 * Kicking off the scan need not be protected,
 	 * only the scan variable stuff, since now
 	 * local->scan_req is assigned and other callers
 	 * will abort their scan attempts.
 	 *
-	 * This avoids getting a scan_mtx -> iflist_mtx
-	 * dependency, so that the scan completed calls
-	 * have more locking freedom.
+	 * This avoids too many locking dependencies
+	 * so that the scan completed calls have more
+	 * locking freedom.
 	 */
 
 	ieee80211_recalc_idle(local);


