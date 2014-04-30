Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from reiner-h.de ([79.140.41.118]:59846 "EHLO reiner-h.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbaD3QQO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2014 12:16:14 -0400
Received: from icarus.reiner-h.de (91-67-195-183-dynip.superkabel.de [91.67.195.183])
	(Authenticated sender: reiner@reiner-h.de)
	by reiner-h.de (Postfix) with ESMTPSA id A661624CB83
	for <linux-wireless@vger.kernel.org>; Wed, 30 Apr 2014 18:09:43 +0200 (CEST)
Date: Wed, 30 Apr 2014 18:09:42 +0200
From: Reiner Herrmann <reiner@reiner-h.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: fix time difference calculation for jiffy wrap
Message-ID: <20140430160941.GA5158@icarus.reiner-h.de> (sfid-20140430_181617_042936_EFEF55C1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The previous calculation is wrong for jiffy wraps,
because the result would be LONG_MAX/2 - (start - end),
which is about LONG_MAX/2 for values near the wrap
(e.g. start=LONG_MAX-1, end=1), though they should be very small.

Calculating the difference with signed values works
also if there was a wrap.

Signed-off-by: Reiner Herrmann <reiner@reiner-h.de>
---
 drivers/net/wireless/ipw2x00/libipw_wx.c | 8 ++------
 net/wireless/core.h                      | 8 ++------
 2 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/libipw_wx.c b/drivers/net/wireless/ipw2x00/libipw_wx.c
index 54aba47..1c61cfc 100644
--- a/drivers/net/wireless/ipw2x00/libipw_wx.c
+++ b/drivers/net/wireless/ipw2x00/libipw_wx.c
@@ -47,12 +47,8 @@ static const char *libipw_modes[] = {
 
 static inline unsigned int elapsed_jiffies_msecs(unsigned long start)
 {
-	unsigned long end = jiffies;
-
-	if (end >= start)
-		return jiffies_to_msecs(end - start);
-
-	return jiffies_to_msecs(end + (MAX_JIFFY_OFFSET - start) + 1);
+	unsigned long diff = (long)jiffies - (long)start;
+	return jiffies_to_msecs(diff);
 }
 
 #define MAX_CUSTOM_LEN 64
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 5b1fdca..930fbbe 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -432,12 +432,8 @@ cfg80211_can_use_chan(struct cfg80211_registered_device *rdev,
 
 static inline unsigned int elapsed_jiffies_msecs(unsigned long start)
 {
-	unsigned long end = jiffies;
-
-	if (end >= start)
-		return jiffies_to_msecs(end - start);
-
-	return jiffies_to_msecs(end + (MAX_JIFFY_OFFSET - start) + 1);
+	unsigned long diff = (long)jiffies - (long)start;
+	return jiffies_to_msecs(diff);
 }
 
 void
-- 
2.0.0.rc0

