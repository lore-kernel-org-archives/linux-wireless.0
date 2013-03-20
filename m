Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43415 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747Ab3CTSZr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 14:25:47 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: return the RSSI in dBm
Date: Wed, 20 Mar 2013 19:25:39 +0100
Message-Id: <1363803939-27946-1-git-send-email-johannes@sipsolutions.net> (sfid-20130320_192550_798843_4DBDB2F6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

For the sake of speed of calculation and number accuracy,
mac80211 tracks the RSSI in dBm * 16. But it forgot to
divide back by 16 when the RSSI is asked by the driver.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index a736887..90cc2b8 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2056,7 +2056,7 @@ int ieee80211_ave_rssi(struct ieee80211_vif *vif)
 		/* non-managed type inferfaces */
 		return 0;
 	}
-	return ifmgd->ave_beacon_signal;
+	return ifmgd->ave_beacon_signal / 16;
 }
 EXPORT_SYMBOL_GPL(ieee80211_ave_rssi);
 
-- 
1.8.0

