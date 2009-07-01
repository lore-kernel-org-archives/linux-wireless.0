Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35970 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857AbZGATfa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 15:35:30 -0400
Message-Id: <20090701193418.429260022@sipsolutions.net>
References: <20090701192641.072258140@sipsolutions.net>
Date: Wed, 01 Jul 2009 21:26:42 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 01/20 v4] wext: allow returning NULL stats
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

--- wireless-testing.orig/net/wireless/wext.c	2009-07-01 08:55:08.000000000 +0200
+++ wireless-testing/net/wireless/wext.c	2009-07-01 08:59:43.000000000 +0200
@@ -610,6 +610,11 @@ static void wireless_seq_printf_stats(st
 {
 	/* Get stats from the driver */
 	struct iw_statistics *stats = get_wireless_stats(dev);
+	static struct iw_statistics nullstats = {};
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
 

-- 

