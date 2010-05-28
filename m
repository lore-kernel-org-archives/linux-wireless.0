Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43887 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087Ab0E1M0a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 May 2010 08:26:30 -0400
Subject: [PATCH] mac80211: make a function static
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 May 2010 14:26:23 +0200
Message-ID: <1275049583.3909.100.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sparse correctly complains that
__ieee80211_get_channel_mode is not static.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/chan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/chan.c	2010-05-28 14:24:30.000000000 +0200
+++ wireless-testing/net/mac80211/chan.c	2010-05-28 14:24:33.000000000 +0200
@@ -5,7 +5,7 @@
 #include <linux/nl80211.h>
 #include "ieee80211_i.h"
 
-enum ieee80211_chan_mode
+static enum ieee80211_chan_mode
 __ieee80211_get_channel_mode(struct ieee80211_local *local,
 			     struct ieee80211_sub_if_data *ignore)
 {


