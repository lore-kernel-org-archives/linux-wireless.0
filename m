Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60767 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946949Ab3BHUaz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 15:30:55 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix chandef tracing bug
Date: Fri,  8 Feb 2013 21:30:49 +0100
Message-Id: <1360355449-20662-1-git-send-email-johannes@sipsolutions.net> (sfid-20130208_213058_453074_4BAECA0D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The chandef tracing writes center_freq1 twice, so
that it is always 0 (no driver supports 80+80 yet)
and leaves center_freq2 unset. Fix this mistake.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/trace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index dd2b80a..0bdd7ae 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -36,7 +36,7 @@
 			__entry->control_freq = (c)->chan->center_freq;		\
 			__entry->chan_width = (c)->width;			\
 			__entry->center_freq1 = (c)->center_freq1;		\
-			__entry->center_freq1 = (c)->center_freq2;
+			__entry->center_freq2 = (c)->center_freq2;
 #define CHANDEF_PR_FMT	" control:%d MHz width:%d center: %d/%d MHz"
 #define CHANDEF_PR_ARG	__entry->control_freq, __entry->chan_width,		\
 			__entry->center_freq1, __entry->center_freq2
-- 
1.8.0

