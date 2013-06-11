Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:50485 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab3FKIou (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 04:44:50 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Felix Fietkau <nbd@openwrt.org>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: [PATCH 2/2] mac80211: Fix rate control mask matching call
Date: Tue, 11 Jun 2013 10:44:40 +0200
Message-Id: <1370940280-7876-3-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130611_104455_181858_B1AE0A71)
In-Reply-To: <1370940280-7876-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1370940280-7876-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The order of parameters was mixed up, introduced in commit
"mac80211: improve the rate control API"

Cc: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 net/mac80211/rate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index d3f414f..a02bef3 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -615,7 +615,7 @@ static void rate_control_apply_mask(struct ieee80211_sub_if_data *sdata,
 		if (rates[i].idx < 0)
 			break;
 
-		rate_idx_match_mask(&rates[i], sband, mask, chan_width,
+		rate_idx_match_mask(&rates[i], sband, chan_width, mask,
 				    mcs_mask);
 	}
 }
-- 
1.7.10.4

