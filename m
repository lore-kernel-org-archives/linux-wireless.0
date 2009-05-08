Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57297 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757828AbZEHLNb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2009 07:13:31 -0400
Subject: [PATCH] mac80211: don't wait for channel switch that has happened
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 08 May 2009 13:13:27 +0200
Message-Id: <1241781207.4495.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The call to ieee80211_hw_config() is supposed to apply changes
synchronously, so once it returns the parameters are applied to
the hardware. Thus, there really is no need to delay the probing
by the channel switch time again since the channel switch has
already happened once we get to this code.

This cuts scanning time from over 7 seconds to about 4 on ar9170,
which is due to the number of channels scanned and ar9170's switch
time being advertised as 135ms (my test now indicates it is about
77ms with the current driver, but the difference might also be due
to using a different machine with different USB controllers).

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/scan.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- wireless-testing.orig/net/mac80211/scan.c	2009-05-08 12:45:38.000000000 +0200
+++ wireless-testing/net/mac80211/scan.c	2009-05-08 12:59:53.000000000 +0200
@@ -559,8 +559,7 @@ void ieee80211_scan_work(struct work_str
 		if (skip)
 			break;
 
-		next_delay = IEEE80211_PROBE_DELAY +
-			     usecs_to_jiffies(local->hw.channel_change_time);
+		next_delay = IEEE80211_PROBE_DELAY;
 		local->scan_state = SCAN_SEND_PROBE;
 		break;
 	case SCAN_SEND_PROBE:


