Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38280 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023Ab1KDRHr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 13:07:47 -0400
Subject: [PATCH 3.2] mac80211: warn only once about not finding a rate
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Nov 2011 18:07:43 +0100
Message-ID: <1320426463.3969.123.camel@jlt3.sipsolutions.net> (sfid-20111104_180754_421600_83966AA5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The warning really shouldn't happen, but until we
find the reason why it does don't spew it all the
time, just once is enough to know we've hit it.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/net/mac80211.h	2011-11-04 15:10:56.000000000 +0100
+++ b/include/net/mac80211.h	2011-11-04 18:04:48.000000000 +0100
@@ -3576,8 +3576,9 @@ rate_lowest_index(struct ieee80211_suppo
 			return i;
 
 	/* warn when we cannot find a rate. */
-	WARN_ON(1);
+	WARN_ON_ONCE(1);
 
+	/* and return 0 (the lowest index) */
 	return 0;
 }
 


