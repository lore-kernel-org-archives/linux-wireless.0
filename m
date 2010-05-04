Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:51205 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755923Ab0EDGrK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 02:47:10 -0400
From: Benoit Papillault <benoit.papillault@free.fr>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Benoit Papillault <benoit.papillault@free.fr>
Subject: [PATCH] cfg80211: Check for channel HT capabilities in an IBSS
Date: Tue,  4 May 2010 08:47:01 +0200
Message-Id: <1272955622-6987-2-git-send-email-benoit.papillault@free.fr>
In-Reply-To: <1272955622-6987-1-git-send-email-benoit.papillault@free.fr>
References: <1272955622-6987-1-git-send-email-benoit.papillault@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When configuring an HT IBSS, we need to check if the specified channel
is capable of ht40+, ht40- or ht20.

Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
---
 net/wireless/nl80211.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8da9823..0a82623 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3858,11 +3858,11 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 		ibss.ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
 	}
 
-	ibss.channel = ieee80211_get_channel(wiphy,
-		nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]));
+	ibss.channel = rdev_freq_to_chan(rdev,
+		nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]),
+		channel_type);
 	if (!ibss.channel ||
-	    ibss.channel->flags & IEEE80211_CHAN_NO_IBSS ||
-	    ibss.channel->flags & IEEE80211_CHAN_DISABLED) {
+	    ibss.channel->flags & IEEE80211_CHAN_NO_IBSS) {
 		err = -EINVAL;
 		goto out;
 	}
-- 
1.5.6.5

