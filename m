Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53676 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbZJaGoF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Oct 2009 02:44:05 -0400
Subject: [PATCH] mac80211: fix scan abort sanity checks
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	mcgrof <mcgrof@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 31 Oct 2009 07:44:08 +0100
Message-ID: <1256971448.3555.89.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since sometimes mac80211 queues up a scan request
to only act on it later, it must be allowed to
(internally) cancel a not-yet-running scan, e.g.
when the interface is taken down. This condition
was missing since we always checked only the
local->scanning variable which isn't yet set in
that situation.

Reported-by: Luis R. Rodriguez <mcgrof@gmail.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/scan.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- wireless-testing.orig/net/mac80211/scan.c	2009-10-31 07:29:47.000000000 +0100
+++ wireless-testing/net/mac80211/scan.c	2009-10-31 07:31:21.000000000 +0100
@@ -288,10 +288,14 @@ void ieee80211_scan_completed(struct iee
 
 	mutex_lock(&local->scan_mtx);
 
-	if (WARN_ON(!local->scanning)) {
-		mutex_unlock(&local->scan_mtx);
-		return;
-	}
+	/*
+	 * It's ok to abort a not-yet-running scan (that
+	 * we have one at all will be verified by checking
+	 * local->scan_req next), but not to complete it
+	 * successfully.
+	 */
+	if (WARN_ON(!local->scanning && !aborted))
+		aborted = true;
 
 	if (WARN_ON(!local->scan_req)) {
 		mutex_unlock(&local->scan_mtx);


