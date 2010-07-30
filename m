Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57796 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758537Ab0G3MKn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jul 2010 08:10:43 -0400
Message-Id: <20100730113152.340700184@sipsolutions.net>
Date: Fri, 30 Jul 2010 13:30:47 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: wey-yi.w.guy@intel.com, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] mac80211: fix scan locking wrt. hw scan
References: <20100730113045.923567583@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Releasing the scan mutex while starting scans
can lead to unexpected things happening, so
we shouldn't do that. Fix that and hold the
mutex across the scan triggering.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/scan.c |   14 --------------
 1 file changed, 14 deletions(-)

--- wireless-testing.orig/net/mac80211/scan.c	2010-07-30 08:43:30.000000000 +0200
+++ wireless-testing/net/mac80211/scan.c	2010-07-30 08:43:38.000000000 +0200
@@ -401,19 +401,7 @@ static int __ieee80211_start_scan(struct
 	else
 		__set_bit(SCAN_SW_SCANNING, &local->scanning);
 
-	/*
-	 * Kicking off the scan need not be protected,
-	 * only the scan variable stuff, since now
-	 * local->scan_req is assigned and other callers
-	 * will abort their scan attempts.
-	 *
-	 * This avoids too many locking dependencies
-	 * so that the scan completed calls have more
-	 * locking freedom.
-	 */
-
 	ieee80211_recalc_idle(local);
-	mutex_unlock(&local->scan_mtx);
 
 	if (local->ops->hw_scan) {
 		WARN_ON(!ieee80211_prep_hw_scan(local));
@@ -421,8 +409,6 @@ static int __ieee80211_start_scan(struct
 	} else
 		rc = ieee80211_start_sw_scan(local);
 
-	mutex_lock(&local->scan_mtx);
-
 	if (rc) {
 		kfree(local->hw_scan_req);
 		local->hw_scan_req = NULL;


