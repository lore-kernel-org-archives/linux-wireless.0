Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:35430 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756436Ab3GKS3z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 14:29:55 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH] mac80211: fix off-by-one regression in ibss beacon generation
Date: Thu, 11 Jul 2013 20:29:49 +0200
Message-Id: <1373567389-6287-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130711_202958_161576_63D335E0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is an off-by-one error in the beacon generation for the ibss mode,
falsely a rate the extended supported rates which was already added to
supported rates, messing up the beacon. This was introduced by commit
"mac80211: select and adjust bitrates according to channel mode".

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
I obviously missed that, sorry. :( This was not visible in 5/10 MHz as
CCK rates are missing in this mode. You might want to squash this one
...
---
 net/mac80211/ibss.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 83197c3..5e6836c 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -168,8 +168,10 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		if (basic_rates & BIT(ri))
 			basic = 0x80;
 		*pos++ = basic | (u8) rate;
-		if (++rates_added == 8)
+		if (++rates_added == 8) {
+			ri++; /* continue at next rate for EXT_SUPP_RATES */
 			break;
+		}
 	}
 
 	if (sband->band == IEEE80211_BAND_2GHZ) {
-- 
1.7.10.4

