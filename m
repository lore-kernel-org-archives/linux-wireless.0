Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:23144 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756367Ab0ITOPW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Sep 2010 10:15:22 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 20 Sep 2010 07:15:15 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: <johannes@sipsolutions.net>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [RFC] mac80211 : Fix for setting of mandatory rate flags
Date: Mon, 20 Sep 2010 19:45:10 +0530
Message-ID: <1284992110-25460-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

	The mandatory rate flags for 'g' mode was not set.Because of
this the basic rates for 'g' mode will not be advertised.

 Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 net/mac80211/util.c    |    3 ++-
 net/wireless/nl80211.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index bd40b11..c1f7ce3 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -851,7 +851,8 @@ u32 ieee80211_mandatory_rates(struct ieee80211_local *local,
 	}
 
 	if (band == IEEE80211_BAND_2GHZ)
-		mandatory_flag = IEEE80211_RATE_MANDATORY_B;
+		mandatory_flag = IEE80211_RATE_MANDATORY_B |
+				 IEEE80211_RATE_MANDATORY_G ;
 	else
 		mandatory_flag = IEEE80211_RATE_MANDATORY_A;
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 1d6ef24..835742c 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4115,7 +4115,8 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 		int j;
 		u32 flag = ibss.channel->band == IEEE80211_BAND_5GHZ ?
 			IEEE80211_RATE_MANDATORY_A :
-			IEEE80211_RATE_MANDATORY_B;
+			IEEE80211_RATE_MANDATORY_B |
+			IEEE80211_RATE_MANDATORY_G ;
 
 		for (j = 0; j < sband->n_bitrates; j++) {
 			if (sband->bitrates[j].flags & flag)
-- 
1.7.0.4

