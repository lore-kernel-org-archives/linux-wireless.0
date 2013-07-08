Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:58679 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab3GHO4V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 10:56:21 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv6 10/18] nl80211: allow 5 and 10 MHz channels for IBSS
Date: Mon,  8 Jul 2013 16:55:58 +0200
Message-Id: <1373295366-12823-11-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130708_165631_693208_F804F42A)
In-Reply-To: <1373295366-12823-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1373295366-12823-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Whether the wiphy supports it or not is already checked, so what is left
is to enable these channel types.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 net/wireless/nl80211.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 3019748..1318b5a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6318,6 +6318,8 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 
 	switch (ibss.chandef.width) {
+	case NL80211_CHAN_WIDTH_5:
+	case NL80211_CHAN_WIDTH_10:
 	case NL80211_CHAN_WIDTH_20_NOHT:
 		break;
 	case NL80211_CHAN_WIDTH_20:
-- 
1.7.10.4

