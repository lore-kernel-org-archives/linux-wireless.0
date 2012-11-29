Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:35893 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab2K2Rhf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 12:37:35 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH] nl80211: Fix HT_IBSS feature check in ibss_join
Date: Thu, 29 Nov 2012 18:37:22 +0100
Message-Id: <1354210642-13355-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20121129_183738_956058_12EE22D0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a standalone if, seems to be a regression of commit
"nl80211/cfg80211: add VHT MCS support".

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 net/wireless/nl80211.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d038fa4..275569d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5502,6 +5502,7 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 	if (ibss.chandef.width != NL80211_CHAN_WIDTH_20_NOHT &&
 	    !(rdev->wiphy.features & NL80211_FEATURE_HT_IBSS))
+		return -EINVAL;
 
 	ibss.channel_fixed = !!info->attrs[NL80211_ATTR_FREQ_FIXED];
 	ibss.privacy = !!info->attrs[NL80211_ATTR_PRIVACY];
-- 
1.7.10.4

