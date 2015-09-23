Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33058 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784AbbIWM0G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2015 08:26:06 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: improve __rate_control_send_low warning
Date: Wed, 23 Sep 2015 14:26:03 +0200
Message-Id: <1443011163-30664-1-git-send-email-johannes@sipsolutions.net> (sfid-20150923_142611_135304_F9885222)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If there are no supported rates in the rate mask with the required
flags, we warn, but it's not clear which part causes the warning.

Add the relevant data to the warning to understand why it happens.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rate.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 9857693b91ec..48d053b00858 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -305,7 +305,10 @@ static void __rate_control_send_low(struct ieee80211_hw *hw,
 		info->control.rates[0].idx = i;
 		break;
 	}
-	WARN_ON_ONCE(i == sband->n_bitrates);
+	WARN_ONCE(i == sband->n_bitrates,
+		  "no supported rates (0x%x) in rate_mask 0x%x with flags 0x%x\n",
+		  sta ? sta->supp_rates[sband->band] : 0,
+		  rate_mask, rate_flags);
 
 	info->control.rates[0].count =
 		(info->flags & IEEE80211_TX_CTL_NO_ACK) ?
-- 
2.5.1

