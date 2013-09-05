Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:41932 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757006Ab3IETOw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Sep 2013 15:14:52 -0400
Received: by mail-pb0-f49.google.com with SMTP id xb4so2195479pbc.22
        for <linux-wireless@vger.kernel.org>; Thu, 05 Sep 2013 12:14:52 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com,
	Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>,
	Colleen Twitty <colleen@cozybit.com>
Subject: [PATCH v2] mac80211: fix the setting of extended supported rate IE
Date: Thu,  5 Sep 2013 12:14:39 -0700
Message-Id: <1378408479-1025-1-git-send-email-yeohchunyeow@cozybit.com> (sfid-20130905_211456_716152_7A1B1F38)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch "mac80211: select and adjust bitrates according to
channel mode" causes regression and breaks the extended supported rate
IE setting. Since "i" is starting with 8, so this is not necessary
to introduce "skip" here.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Signed-off-by: Colleen Twitty <colleen@cozybit.com>
Reviewed-by: Jason Abele <jason@cozybit.com>
---
v2: remove skip (Jason)

 net/mac80211/util.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 3c8283b..4bb639f 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2128,14 +2128,11 @@ int ieee80211_add_ext_srates_ie(struct ieee80211_sub_if_data *sdata,
 		pos = skb_put(skb, exrates + 2);
 		*pos++ = WLAN_EID_EXT_SUPP_RATES;
 		*pos++ = exrates;
-		skip = 0;
 		for (i = 8; i < sband->n_bitrates; i++) {
 			u8 basic = 0;
 			if ((rate_flags & sband->bitrates[i].flags)
 			    != rate_flags)
 				continue;
-			if (skip++ < 8)
-				continue;
 			if (need_basic && basic_rates & BIT(i))
 				basic = 0x80;
 			rate = DIV_ROUND_UP(sband->bitrates[i].bitrate,
-- 
1.7.9.5

