Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:37686 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbaFQKHM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2014 06:07:12 -0400
Received: by mail-we0-f180.google.com with SMTP id x48so6848621wes.25
        for <linux-wireless@vger.kernel.org>; Tue, 17 Jun 2014 03:07:11 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] cfg80211: fix elapsed_jiffies calculation
Date: Tue, 17 Jun 2014 13:07:02 +0300
Message-Id: <1402999622-27880-1-git-send-email-eliad@wizery.com> (sfid-20140617_120717_212342_EC0FC44B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

MAX_JIFFY_OFFSET has no meaning when calculating the
elapsed jiffies, as jiffies run out until ULONG_MAX.

This miscalculation results in erroneous values
in case of a wrap-around.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
since this function is currently used only
for returning values to userspace (e.g. time
in current dfs state), it's probably not
needed for stable.

 net/wireless/core.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/core.h b/net/wireless/core.h
index 402a653..c43b0ce 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -418,7 +418,7 @@ static inline unsigned int elapsed_jiffies_msecs(unsigned long start)
 	if (end >= start)
 		return jiffies_to_msecs(end - start);
 
-	return jiffies_to_msecs(end + (MAX_JIFFY_OFFSET - start) + 1);
+	return jiffies_to_msecs(end + (ULONG_MAX - start) + 1);
 }
 
 void
-- 
1.8.5.2.229.g4448466.dirty

