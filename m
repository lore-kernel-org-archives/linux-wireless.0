Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53110 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202Ab2EHTgU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 15:36:20 -0400
Message-ID: <1336505780.4320.6.camel@jlt3.sipsolutions.net> (sfid-20120508_213632_280765_109C27FC)
Subject: [PATCH] cfg80211: add warning when calculating MCS rates >= 32
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 08 May 2012 21:36:20 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

cfg80211_calculate_bitrate() doesn't work for MCS
rates 32 or higher, and it has always returned 0
in that case. Warn if it ever really happens.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/wireless/util.c	2012-05-08 21:33:50.000000000 +0200
+++ b/net/wireless/util.c	2012-05-08 21:33:54.000000000 +0200
@@ -879,7 +879,7 @@ u16 cfg80211_calculate_bitrate(struct ra
 		return rate->legacy;
 
 	/* the formula below does only work for MCS values smaller than 32 */
-	if (rate->mcs >= 32)
+	if (WARN_ON_ONCE(rate->mcs >= 32))
 		return 0;
 
 	modulation = rate->mcs & 7;


