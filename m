Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:36137 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932596Ab3EOOTf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 10:19:35 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv2 10/18] nl80211: allow 5 and 10 MHz channels for IBSS
Date: Wed, 15 May 2013 16:19:01 +0200
Message-Id: <1368627549-22518-11-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130515_162936_139311_38FAB3FF)
In-Reply-To: <1368627549-22518-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1368627549-22518-1-git-send-email-siwu@hrz.tu-chemnitz.de>
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
index 75070da..a5f281a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6297,6 +6297,8 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 
 	switch (ibss.chandef.width) {
+	case NL80211_CHAN_WIDTH_5:
+	case NL80211_CHAN_WIDTH_10:
 	case NL80211_CHAN_WIDTH_20_NOHT:
 		break;
 	case NL80211_CHAN_WIDTH_20:
-- 
1.7.10.4

