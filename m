Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:41102 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab3EISKs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 May 2013 14:10:48 -0400
From: a@pandem0nium
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH 5/8] nl80211: allow 5 and 10 MHz channels for IBSS
Date: Thu,  9 May 2013 20:10:33 +0200
Message-Id: <1368123036-22721-6-git-send-email-a> (sfid-20130509_201058_232206_3A48E537)
In-Reply-To: <1368123036-22721-1-git-send-email-a>
References: <1368123036-22721-1-git-send-email-a>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>

Whether the wiphy supports it or not is already checked, so what is left
is to enable these channel types.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 net/wireless/nl80211.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f67d825..fbbb639 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6335,6 +6335,8 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 
 	switch (ibss.chandef.width) {
+	case NL80211_CHAN_WIDTH_5:
+	case NL80211_CHAN_WIDTH_10:
 	case NL80211_CHAN_WIDTH_20_NOHT:
 		break;
 	case NL80211_CHAN_WIDTH_20:
-- 
1.7.10.4

