Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:50012 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab3EPLB6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 May 2013 07:01:58 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCHv3 03/18] mac80211: Fix rate control mask matching call
Date: Thu, 16 May 2013 13:00:30 +0200
Message-Id: <1368702045-27598-4-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130516_130206_507371_BA1806F1)
In-Reply-To: <1368702045-27598-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1368702045-27598-1-git-send-email-siwu@hrz.tu-chemnitz.de>
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
index 0d51877..8b95819 100644
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

