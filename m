Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42170 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757597Ab0ERMgj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 May 2010 08:36:39 -0400
Subject: [PATCH] cfg80211: add missing braces
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1274181194.3762.77.camel@jlt3.sipsolutions.net>
References: <1274181194.3762.77.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 May 2010 14:36:34 +0200
Message-ID: <1274186194.3762.79.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Specifying a valid channel type will get
goto out rather than continuing, due to
missing braces. This affects both remain
on channel and action frame TX commands.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
replaces the earlier patch

 net/wireless/nl80211.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/wireless/nl80211.c	2010-05-18 13:09:26.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2010-05-18 14:35:20.000000000 +0200
@@ -4443,9 +4443,10 @@ static int nl80211_remain_on_channel(str
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
@@ -4717,9 +4718,10 @@ static int nl80211_action(struct sk_buff
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


