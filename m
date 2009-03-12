Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53638 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbZCLWHT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 18:07:19 -0400
Subject: [PATCH] mac80211: reduce max number of queues
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 12 Mar 2009 11:16:48 +0100
Message-Id: <1236853008.4175.21.camel@johannes.local> (sfid-20090312_230722_511846_4E1CE6C1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No hw/driver actually supports more than four queues right now,
and we allocate a number of things per queue which means we
waste a bit of memory. Reduce the maximum number to four to
accurately reflect what we do (and need for QoS). Even if we
had hardware supporting more queues we couldn't take advantage
of that right now anyway.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/include/net/mac80211.h	2009-02-13 11:38:26.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2009-02-13 11:38:27.000000000 +0100
@@ -97,7 +97,7 @@ struct ieee80211_ht_bss_info {
  *	for A-MPDU operation.
  */
 enum ieee80211_max_queues {
-	IEEE80211_MAX_QUEUES =		16,
+	IEEE80211_MAX_QUEUES =		4,
 	IEEE80211_MAX_AMPDU_QUEUES =	16,
 };
 


