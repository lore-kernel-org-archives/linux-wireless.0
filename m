Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54840 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216Ab0LCAQY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 19:16:24 -0500
Received: by fxm20 with SMTP id 20so1707877fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 16:16:23 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] mac80211: fix dynamic-ps/pm_qos magic numbers
Date: Fri,  3 Dec 2010 02:16:23 +0200
Message-Id: <1291335383-17239-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 uses pm_qos (/dev/network_latency) in order to determine the
dynamic ps timeout (or disable the dynamic-ps at all in some cases).

commit ff616381 added a comparison for the current network_latency
against one high value (1900ms), and against the default value
(2000sec, rather than the commented 2sec).

however, the representation of 1900ms was incorrect:
1900ms = 1900000us ( != 1900000000 )

fix it by using USEC_TO_MSEC/SEC consts.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v1->2: better commit msg

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

