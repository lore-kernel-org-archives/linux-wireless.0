Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:43869 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696Ab0CAIxz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 03:53:55 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 01 Mar 2010 00:53:55 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19339.34073.723714.219572@gargle.gargle.HOWL>
Date: Mon, 1 Mar 2010 14:42:57 +0530
To: <linville@tuxdriver.com>
CC: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: Fix HT configuration
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Handling HT configuration changes involved setting the channel
with the new HT parameters and then issuing a rate_update()
notification to the driver.

This behavior changed after the off-channel changes. Now, the channel
is not updated with the new HT params in enable_ht() - instead, it
is now done when the scan work terminates. This results in the driver
depending on stale information, defaulting to non-HT mode always.

Fix this by passing the new channel type to the driver.

Cc: stable@kernel.org
Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 include/net/mac80211.h |    3 ++-
 net/mac80211/mlme.c    |    3 ++-
 net/mac80211/rate.h    |    5 +++--
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 80eb7cc..45d7d44 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2426,7 +2426,8 @@ struct rate_control_ops {
 			  struct ieee80211_sta *sta, void *priv_sta);
 	void (*rate_update)(void *priv, struct ieee80211_supported_band *sband,
 			    struct ieee80211_sta *sta,
-			    void *priv_sta, u32 changed);
+			    void *priv_sta, u32 changed,
+			    enum nl80211_channel_type oper_chan_type);
 	void (*free_sta)(void *priv, struct ieee80211_sta *sta,
 			 void *priv_sta);
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 41812a1..2b621e1 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -177,7 +177,8 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 		sta = sta_info_get(sdata, bssid);
 		if (sta)
 			rate_control_rate_update(local, sband, sta,
-						 IEEE80211_RC_HT_CHANGED);
+						 IEEE80211_RC_HT_CHANGED,
+						 local->oper_channel_type);
 		rcu_read_unlock();
         }
 
diff --git a/net/mac80211/rate.h b/net/mac80211/rate.h
index b6108bc..065a961 100644
--- a/net/mac80211/rate.h
+++ b/net/mac80211/rate.h
@@ -66,7 +66,8 @@ static inline void rate_control_rate_init(struct sta_info *sta)
 
 static inline void rate_control_rate_update(struct ieee80211_local *local,
 				    struct ieee80211_supported_band *sband,
-				    struct sta_info *sta, u32 changed)
+				    struct sta_info *sta, u32 changed,
+				    enum nl80211_channel_type oper_chan_type)
 {
 	struct rate_control_ref *ref = local->rate_ctrl;
 	struct ieee80211_sta *ista = &sta->sta;
@@ -74,7 +75,7 @@ static inline void rate_control_rate_update(struct ieee80211_local *local,
 
 	if (ref && ref->ops->rate_update)
 		ref->ops->rate_update(ref->priv, sband, ista,
-				      priv_sta, changed);
+				      priv_sta, changed, oper_chan_type);
 }
 
 static inline void *rate_control_alloc_sta(struct rate_control_ref *ref,
-- 
1.7.0.1

