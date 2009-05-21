Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48965 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbZEUKCJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 06:02:09 -0400
Subject: [PATCH] mac80211: correct probe wait time
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 21 May 2009 12:02:05 +0200
Message-Id: <1242900125.5471.13.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My first patch submission used 200ms, which I then somehow
managed to revert back to the earlier 50ms I had used for
some tests in the second patch submission -- but that was
wrong, I should have used 200ms here. Correct that.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mlme.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-05-21 11:59:59.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-05-21 12:00:04.000000000 +0200
@@ -33,7 +33,7 @@
 #define IEEE80211_ASSOC_TIMEOUT (HZ / 5)
 #define IEEE80211_ASSOC_MAX_TRIES 3
 #define IEEE80211_MONITORING_INTERVAL (2 * HZ)
-#define IEEE80211_PROBE_WAIT (HZ / 20)
+#define IEEE80211_PROBE_WAIT (HZ / 5)
 #define IEEE80211_PROBE_IDLE_TIME (60 * HZ)
 #define IEEE80211_RETRY_AUTH_INTERVAL (1 * HZ)
 


