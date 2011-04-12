Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:35120 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932076Ab1DLLEd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 07:04:33 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Q9bOZ-0005oZ-CT
	for linux-wireless@vger.kernel.org; Tue, 12 Apr 2011 13:04:31 +0200
Received: from 89.204.153.111 ([89.204.153.111])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 13:04:31 +0200
Received: from alexander.simon by 89.204.153.111 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 13:04:31 +0200
To: linux-wireless@vger.kernel.org
From: Alexander Simon <alexander.simon@saxnet.de>
Subject: Re: [PATCH 2/4] nl80211: Add =?utf-8?b?Tkw4MDIxMV9BVFRSX1dJUEhZX0NIQU5ORUxfVFlQRQ==?= for IBSS
Date: Tue, 12 Apr 2011 11:04:16 +0000 (UTC)
Message-ID: <loom.20110412T130245-14@post.gmane.org>
References: <1302604964.2139.5.camel@alex-2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Needed for IBSS IEEE802.11N operation

* Add a new attribute NL80211_ATTR_WIPHY_CHANNEL_TYPE to specify
    a HT channel type for IBSS

Signed-off-by: Alexander Simon <alexander.simon@saxnet.de>
---
 nl80211.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff -Nrup a/net/wireless/nl80211.c b/net/wireless/nl80211.c
--- a/net/wireless/nl80211.c	2011-03-31 21:04:02.000000000 +0200
+++ b/net/wireless/nl80211.c	2011-04-12 08:49:19.000000000 +0200
@@ -3927,8 +3927,24 @@ static int nl80211_join_ibss(struct sk_b
 		ibss.ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
 	}
 
-	ibss.channel = ieee80211_get_channel(wiphy,
-		nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]));
+	if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]) {
+		enum nl80211_channel_type channel_type;
+
+		channel_type = nla_get_u32(
+			info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]);
+		if (channel_type != NL80211_CHAN_NO_HT &&
+				channel_type != NL80211_CHAN_HT20 &&
+				channel_type != NL80211_CHAN_HT40PLUS &&
+				channel_type != NL80211_CHAN_HT40MINUS)
+			return -EINVAL;
+		ibss.channel_type = channel_type;
+	} else {
+		ibss.channel_type = NL80211_CHAN_NO_HT;
+	}
+
+	ibss.channel = rdev_freq_to_chan(rdev,
+		nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]),
+		ibss.channel_type);
 	if (!ibss.channel ||
 	    ibss.channel->flags & IEEE80211_CHAN_NO_IBSS ||
 	    ibss.channel->flags & IEEE80211_CHAN_DISABLED)



