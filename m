Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:42141 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757293AbcCaRET (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2016 13:04:19 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 05/10] mac80211: remove rx_stats.last_rx update after sta alloc
Date: Thu, 31 Mar 2016 20:02:06 +0300
Message-Id: <1459443731-4614-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160331_190425_259205_0068E55A)
In-Reply-To: <1459443731-4614-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1459443731-4614-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to update rx_stats.last_rx after allocating
a station since it's already updated during allocation.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ibss.c | 4 ----
 net/mac80211/ocb.c  | 2 --
 2 files changed, 6 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index fc32383..b3407db 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -649,8 +649,6 @@ ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata, const u8 *bssid,
 		return NULL;
 	}
 
-	sta->rx_stats.last_rx = jiffies;
-
 	/* make sure mandatory rates are always added */
 	sband = local->hw.wiphy->bands[band];
 	sta->sta.supp_rates[band] = supp_rates |
@@ -1236,8 +1234,6 @@ void ieee80211_ibss_rx_no_sta(struct ieee80211_sub_if_data *sdata,
 	if (!sta)
 		return;
 
-	sta->rx_stats.last_rx = jiffies;
-
 	/* make sure mandatory rates are always added */
 	sband = local->hw.wiphy->bands[band];
 	sta->sta.supp_rates[band] = supp_rates |
diff --git a/net/mac80211/ocb.c b/net/mac80211/ocb.c
index 0be0aad..88e6ebb 100644
--- a/net/mac80211/ocb.c
+++ b/net/mac80211/ocb.c
@@ -75,8 +75,6 @@ void ieee80211_ocb_rx_no_sta(struct ieee80211_sub_if_data *sdata,
 	if (!sta)
 		return;
 
-	sta->rx_stats.last_rx = jiffies;
-
 	/* Add only mandatory rates for now */
 	sband = local->hw.wiphy->bands[band];
 	sta->sta.supp_rates[band] =
-- 
2.5.0

