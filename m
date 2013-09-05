Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:49781 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763301Ab3IEBjv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Sep 2013 21:39:51 -0400
Received: by mail-pd0-f170.google.com with SMTP id x10so1090055pdj.29
        for <linux-wireless@vger.kernel.org>; Wed, 04 Sep 2013 18:39:50 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com,
	Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>,
	Colleen Twitty <colleen@cozybit.com>
Subject: [PATCH] mac80211: fix the setting of extended supported rate IE
Date: Wed,  4 Sep 2013 18:39:43 -0700
Message-Id: <1378345183-5921-1-git-send-email-yeohchunyeow@cozybit.com> (sfid-20130905_034305_344776_64C6F516)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch "mac80211: select and adjust bitrates according to
channel mode" causes regression and breaks the extended supported rate
IE setting. Fix this.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Signed-off-by: Colleen Twitty <colleen@cozybit.com>
---
 net/mac80211/util.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 3c8283b..21fef9f 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2134,13 +2134,13 @@ int ieee80211_add_ext_srates_ie(struct ieee80211_sub_if_data *sdata,
 			if ((rate_flags & sband->bitrates[i].flags)
 			    != rate_flags)
 				continue;
-			if (skip++ < 8)
-				continue;
 			if (need_basic && basic_rates & BIT(i))
 				basic = 0x80;
 			rate = DIV_ROUND_UP(sband->bitrates[i].bitrate,
 					    5 * (1 << shift));
 			*pos++ = basic | (u8) rate;
+			if (skip++ < 8)
+				continue;
 		}
 	}
 	return 0;
-- 
1.7.9.5

