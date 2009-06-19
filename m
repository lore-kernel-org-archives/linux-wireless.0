Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36924 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbZFSBcI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 21:32:08 -0400
Subject: [PATCH] wext: allow returning NULL stats
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 19 Jun 2009 03:31:38 +0200
Message-Id: <1245375099.16399.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, wext drivers cannot return NULL for stats even though
that would make the ioctl return -EOPNOTSUPP because that would
mean they are no longer listed in /proc/net/wireless. This patch
changes the wext core's behaviour to list them if they have any
wireless_handlers, but only show their stats when available, so
that drivers can start returning NULL if stats are currently not
available, reducing confusion for e.g. IBSS.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/wext.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- wireless-testing.orig/net/wireless/wext.c	2009-06-19 03:16:40.000000000 +0200
+++ wireless-testing/net/wireless/wext.c	2009-06-19 03:20:30.000000000 +0200
@@ -610,6 +610,11 @@ static void wireless_seq_printf_stats(st
 {
 	/* Get stats from the driver */
 	struct iw_statistics *stats = get_wireless_stats(dev);
+	static const struct iw_statistics nullstats = {};
+
+	/* show device if it's wireless regardless of current stats */
+	if (!stats && dev->wireless_handlers)
+		stats = &nullstats;
 
 	if (stats) {
 		seq_printf(seq, "%6s: %04x  %3d%c  %3d%c  %3d%c  %6d %6d %6d "
@@ -628,7 +633,9 @@ static void wireless_seq_printf_stats(st
 			   stats->discard.nwid, stats->discard.code,
 			   stats->discard.fragment, stats->discard.retries,
 			   stats->discard.misc, stats->miss.beacon);
-		stats->qual.updated &= ~IW_QUAL_ALL_UPDATED;
+
+		if (stats != &nullstats)
+			stats->qual.updated &= ~IW_QUAL_ALL_UPDATED;
 	}
 }
 


