Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60620 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091Ab0BCJWg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2010 04:22:36 -0500
Subject: [PATCH 2.6.33] mac80211: fix deferred hardware scan requests
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: reinette.chatre@intel.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Feb 2010 10:22:31 +0100
Message-ID: <1265188951.29119.86.camel@johannes.local>
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

Bug-identified-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/scan.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- iwlwifi-2.6.orig/net/mac80211/scan.c	2010-02-03 10:12:59.000000000 +0100
+++ iwlwifi-2.6/net/mac80211/scan.c	2010-02-03 10:18:34.000000000 +0100
@@ -439,6 +439,16 @@ static int __ieee80211_start_scan(struct
 	if (local->scan_req)
 		return -EBUSY;
 
+	if (req != local->int_scan_req &&
+	    sdata->vif.type == NL80211_IFTYPE_STATION &&
+	    !list_empty(&ifmgd->work_list)) {
+		/* actually wait for the work it's doing to finish/time out */
+		set_bit(IEEE80211_STA_REQ_SCAN, &ifmgd->request);
+		local->scan_req = req;
+		local->scan_sdata = sdata;
+		return 0;
+	}
+
 	if (local->ops->hw_scan) {
 		u8 *ies;
 
@@ -463,14 +473,6 @@ static int __ieee80211_start_scan(struct
 	local->scan_req = req;
 	local->scan_sdata = sdata;
 
-	if (req != local->int_scan_req &&
-	    sdata->vif.type == NL80211_IFTYPE_STATION &&
-	    !list_empty(&ifmgd->work_list)) {
-		/* actually wait for the work it's doing to finish/time out */
-		set_bit(IEEE80211_STA_REQ_SCAN, &ifmgd->request);
-		return 0;
-	}
-
 	if (local->ops->hw_scan)
 		__set_bit(SCAN_HW_SCANNING, &local->scanning);
 	else


