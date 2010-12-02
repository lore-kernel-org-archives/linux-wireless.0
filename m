Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55707 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757178Ab0LBXLP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 18:11:15 -0500
Received: by bwz15 with SMTP id 15so7774142bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 15:11:14 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: fix pm_qos magic numbers
Date: Fri,  3 Dec 2010 01:11:14 +0200
Message-Id: <1291331474-16475-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

the default /dev/network_latency is 2000s.
1900ms = 1900000us.
just use consts.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/mlme.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index dfc4a31..e01d6fb 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -619,11 +619,12 @@ void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
 			/*
 			 * Go to full PSM if the user configures a very low
 			 * latency requirement.
-			 * The 2 second value is there for compatibility until
-			 * the PM_QOS_NETWORK_LATENCY is configured with real
-			 * values.
+			 * The 2000 second value is there for compatibility
+			 * until the PM_QOS_NETWORK_LATENCY is configured
+			 * with real values.
 			 */
-			if (latency > 1900000000 && latency != 2000000000)
+			if (latency > (1900 * USEC_PER_MSEC) &&
+			    latency != (2000 * USEC_PER_SEC))
 				timeout = 0;
 			else
 				timeout = 100;
-- 
1.7.0.4

