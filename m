Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58249 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab0ERLNV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 May 2010 07:13:21 -0400
Subject: [PATCH] cfg80211: fix action frame TX
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 May 2010 13:13:14 +0200
Message-ID: <1274181194.3762.77.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Specifying a valid channel type will get
goto out rather than continuing, due to
missing braces.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/nl80211.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- wireless-testing.orig/net/wireless/nl80211.c	2010-05-18 13:09:26.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2010-05-18 13:09:37.000000000 +0200
@@ -4717,9 +4717,10 @@ static int nl80211_action(struct sk_buff
 		if (channel_type != NL80211_CHAN_NO_HT &&
 		    channel_type != NL80211_CHAN_HT20 &&
 		    channel_type != NL80211_CHAN_HT40PLUS &&
-		    channel_type != NL80211_CHAN_HT40MINUS)
+		    channel_type != NL80211_CHAN_HT40MINUS) {
 			err = -EINVAL;
 			goto out;
+		}
 	}
 
 	freq = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]);


