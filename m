Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41533 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760148Ab0FRKcX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jun 2010 06:32:23 -0400
Subject: [PATCH] mac80211: fix sw scan bracketing
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Jun 2010 12:32:20 +0200
Message-ID: <1276857140.3638.22.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Currently, detection in hwsim and ath9k can
detect that two sw scans are in flight at the
same time, which isn't really true. It is
caused by a race condition, because the scan
complete callback is called too late, after
the lock has been dropped, so that a new scan
can be started before it is called.

It is also called too early semantically, as
it is currently called _after_ the return to
the operating channel -- it should be before
so that drivers know this is the operating
channel again.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/scan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/mac80211/scan.c	2010-06-18 12:22:56.000000000 +0200
+++ wireless-testing/net/mac80211/scan.c	2010-06-18 12:23:25.000000000 +0200
@@ -287,6 +287,8 @@ void ieee80211_scan_completed(struct iee
 	local->scanning = 0;
 	local->scan_channel = NULL;
 
+	drv_sw_scan_complete(local);
+
 	/* we only have to protect scan_req and hw/sw scan */
 	mutex_unlock(&local->scan_mtx);
 
@@ -296,8 +298,6 @@ void ieee80211_scan_completed(struct iee
 
 	ieee80211_configure_filter(local);
 
-	drv_sw_scan_complete(local);
-
 	ieee80211_offchannel_return(local, true);
 
  done:


