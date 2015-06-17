Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46734 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbbFQIlT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 04:41:19 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 01/14] mac80211: remove exposing 'mfp' to drivers
Date: Wed, 17 Jun 2015 10:41:02 +0200
Message-Id: <1434530475-3553-2-git-send-email-johannes@sipsolutions.net> (sfid-20150617_104124_818601_42BC8F22)
In-Reply-To: <1434530475-3553-1-git-send-email-johannes@sipsolutions.net>
References: <1434530475-3553-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no driver using this, so remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h | 1 -
 net/mac80211/cfg.c     | 1 -
 net/mac80211/mlme.c    | 6 +-----
 3 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 6b1077c2a63f..fb220b9c5ed1 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1693,7 +1693,6 @@ struct ieee80211_sta {
 	struct ieee80211_sta_rates __rcu *rates;
 	bool tdls;
 	bool tdls_initiator;
-	bool mfp;
 
 	struct ieee80211_txq *txq[IEEE80211_NUM_TIDS];
 
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index bf7023f6c327..5fc7788e2ff2 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1076,7 +1076,6 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 	}
 
 	if (mask & BIT(NL80211_STA_FLAG_MFP)) {
-		sta->sta.mfp = !!(set & BIT(NL80211_STA_FLAG_MFP));
 		if (set & BIT(NL80211_STA_FLAG_MFP))
 			set_sta_flag(sta, WLAN_STA_MFP);
 		else
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 9b2cc278ac2a..ae5d6c48272d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3034,12 +3034,8 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 
 	rate_control_rate_init(sta);
 
-	if (ifmgd->flags & IEEE80211_STA_MFP_ENABLED) {
+	if (ifmgd->flags & IEEE80211_STA_MFP_ENABLED)
 		set_sta_flag(sta, WLAN_STA_MFP);
-		sta->sta.mfp = true;
-	} else {
-		sta->sta.mfp = false;
-	}
 
 	sta->sta.wme = elems.wmm_param && local->hw.queues >= IEEE80211_NUM_ACS;
 
-- 
2.1.4

