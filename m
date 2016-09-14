Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42780 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759721AbcINIMC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 04:12:02 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/5] mac80211: remove unused assignment
Date: Wed, 14 Sep 2016 10:11:56 +0200
Message-Id: <1473840718-5605-3-git-send-email-johannes@sipsolutions.net> (sfid-20160914_101208_099016_783CE561)
In-Reply-To: <1473840718-5605-1-git-send-email-johannes@sipsolutions.net>
References: <1473840718-5605-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The next line overwrites this assignment, so remove it; there's
no real value in using it for the next assignment either.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/util.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index e777c2a6568f..b6865d884487 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2555,7 +2555,6 @@ int ieee80211_add_srates_ie(struct ieee80211_sub_if_data *sdata,
 
 		if (need_basic && basic_rates & BIT(i))
 			basic = 0x80;
-		rate = sband->bitrates[i].bitrate;
 		rate = DIV_ROUND_UP(sband->bitrates[i].bitrate,
 				    5 * (1 << shift));
 		*pos++ = basic | (u8) rate;
-- 
2.8.1
