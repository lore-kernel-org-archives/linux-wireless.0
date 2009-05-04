Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46141 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756735AbZEDPwn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 11:52:43 -0400
Subject: [PATCH] mac80211: report operating frequency rather than current
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 04 May 2009 17:52:10 +0200
Message-Id: <1241452330.8683.49.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's not very helpful to see, in iwconfig, the current frequency
the card is tuned to if that frequency is currently somewhere
across the board because we're scanning. Since we keep track of
the frequency the user wants, display that instead.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/wext.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/wext.c	2009-05-04 17:41:53.000000000 +0200
+++ wireless-testing/net/mac80211/wext.c	2009-05-04 17:42:02.000000000 +0200
@@ -185,7 +185,7 @@ static int ieee80211_ioctl_giwfreq(struc
 	if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
 		return cfg80211_ibss_wext_giwfreq(dev, info, freq, extra);
 
-	freq->m = local->hw.conf.channel->center_freq;
+	freq->m = local->oper_channel->center_freq;
 	freq->e = 6;
 
 	return 0;


