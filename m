Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52545 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbZD1W2x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2009 18:28:53 -0400
Subject: [PATCH] mac80211: default to automatic power control
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Niel Lambrechts <niel.lambrechts@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 29 Apr 2009 00:28:18 +0200
Message-Id: <1240957698.593.14.camel@johannes.local> (sfid-20090429_002858_783808_97B47BD3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In
commit 47afbaf5af9454a7a1a64591e20cbfcc27ca67a8
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Tue Apr 7 15:22:28 2009 +0200

    mac80211: correct wext transmit power handler

I fixed the wext handler, but forgot to make the default of the
user_power_level -1 (aka "auto"), so that now the transmit power
is always set to 0, causing associations to time out and similar
problems since we're transmitting with very little power. Correct
this by correcting the default user_power_level to -1.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Bisected-by: Niel Lambrechts <niel.lambrechts@gmail.com>
---
 net/mac80211/main.c |    1 +
 1 file changed, 1 insertion(+)

--- wireless-testing.orig/net/mac80211/main.c	2009-04-28 23:59:48.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2009-04-29 00:01:48.000000000 +0200
@@ -763,6 +763,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	local->hw.conf.long_frame_max_tx_count = wiphy->retry_long;
 	local->hw.conf.short_frame_max_tx_count = wiphy->retry_short;
 	local->hw.conf.radio_enabled = true;
+	local->user_power_level = -1;
 
 	INIT_LIST_HEAD(&local->interfaces);
 	mutex_init(&local->iflist_mtx);


