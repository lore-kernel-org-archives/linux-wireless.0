Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:53528 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab2HLQZU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Aug 2012 12:25:20 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <ordex@autistici.org>
Subject: [PATCH] mac80211: add supported rates change notification in IBSS
Date: Sun, 12 Aug 2012 18:24:55 +0200
Message-Id: <1344788695-1458-1-git-send-email-ordex@autistici.org> (sfid-20120812_182557_605132_7EDE9818)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In IBSS it is possible that the supported rates set for a station changes over
time (e.g. it gets first initialised as an empty set because of no available
information about rates and updated later). In this case the driver has to be
notified about the change in order to update its internal table accordingly (if
needed).

This behaviour is needed by all those drivers that handle rc internally but
leave stations management to mac80211

Reported-by: Gui Iribarren <gui@altermundi.net>
Signed-off-by: Antonio Quartulli <ordex@autistici.org>
---
 include/net/mac80211.h |    1 +
 net/mac80211/ibss.c    |    5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index bb86aa6..9b0f71f 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1888,6 +1888,7 @@ enum ieee80211_frame_release_type {
 enum ieee80211_rate_control_changed {
 	IEEE80211_RC_BW_CHANGED		= BIT(0),
 	IEEE80211_RC_SMPS_CHANGED	= BIT(1),
+	IEEE80211_RC_SUPP_RATES_CHANGED	= BIT(2),
 };
 
 /**
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 37e71a3..590cf19 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -467,8 +467,11 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 			}
 		}
 
-		if (sta && rates_updated)
+		if (sta && rates_updated) {
+			drv_sta_rc_update(&local->hw, &sdata->vif, &sta->sta,
+					  IEEE80211_RC_SUPP_RATES_CHANGED);
 			rate_control_rate_init(sta);
+		}
 
 		rcu_read_unlock();
 	}
-- 
1.7.9.4

