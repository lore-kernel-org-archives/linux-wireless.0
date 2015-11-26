Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:30873 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbbKZSuK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 13:50:10 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: Allow a STA to join an IBSS with 80+80 MHz channel
Date: Thu, 26 Nov 2015 20:49:38 +0200
Message-ID: <1448563778-27137-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20151126_195045_728922_3559CD70)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While it was possible to create an IBSS with 80+80 MHz channel, joining
such an IBSS resulted in falling back to 20 MHz channel with VHT
disabled due to a missing switch case for 80+80.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 net/mac80211/ibss.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 337bb5d..f7fc0e0 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -428,6 +428,7 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		chandef.width = sdata->u.ibss.chandef.width;
 		break;
 	case NL80211_CHAN_WIDTH_80:
+	case NL80211_CHAN_WIDTH_80P80:
 	case NL80211_CHAN_WIDTH_160:
 		chandef = sdata->u.ibss.chandef;
 		chandef.chan = cbss->channel;
-- 
1.9.1

