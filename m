Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38316 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756554AbbCEPhT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2015 10:37:19 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Sven Eckelmann <sven@open-mesh.com>,
	Felix Fietkau <nbd@openwrt.org>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [RFC] mac80211: lock rate control
Date: Thu,  5 Mar 2015 16:37:12 +0100
Message-Id: <1425569832-22373-1-git-send-email-johannes@sipsolutions.net> (sfid-20150305_163723_251308_034A5AEC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Both minstrel (reported by Sven Eckelmann) and the iwlwifi rate
control aren't properly taking concurrency into account. It's
likely that the same is true for other rate control algorithms.

In the case of minstrel this manifests itself in crashes when an
update and other data access are run concurrently, for example
when the stations change bandwidth or similar. In iwlwifi, this
can cause firmware crashes.

Since fixing all rate control algorithms will be very difficult,
just provide locking for invocations. This protects the internal
data structures the algorithms maintain.

I've manipulated hostapd to test this, by having it change its
advertised bandwidth roughly ever 150ms. At the same time, I'm
running a flood ping between the client and the AP, which causes
this race of update vs. get_rate/status to easily happen on the
client. With this change, the system survives this test.

Reported-by: Sven Eckelmann <sven@open-mesh.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rate.c     |  2 ++
 net/mac80211/rate.h     | 12 +++++++++---
 net/mac80211/sta_info.c |  2 +-
 net/mac80211/sta_info.h |  1 +
 4 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index bc5270ed26bd..41732668b7af 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -683,7 +683,9 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 	if (sdata->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL)
 		return;
 
+	spin_lock_bh(&sta->rate_ctrl_lock);
 	ref->ops->get_rate(ref->priv, ista, priv_sta, txrc);
+	spin_unlock_bh(&sta->rate_ctrl_lock);
 
 	if (sdata->local->hw.flags & IEEE80211_HW_SUPPORTS_RC_TABLE)
 		return;
diff --git a/net/mac80211/rate.h b/net/mac80211/rate.h
index a7d5439322d7..d0ecc8952fa0 100644
--- a/net/mac80211/rate.h
+++ b/net/mac80211/rate.h
@@ -42,10 +42,12 @@ static inline void rate_control_tx_status(struct ieee80211_local *local,
 	if (!ref || !test_sta_flag(sta, WLAN_STA_RATE_CONTROL))
 		return;
 
+	spin_lock_bh(&sta->rate_ctrl_lock);
 	if (ref->ops->tx_status)
 		ref->ops->tx_status(ref->priv, sband, ista, priv_sta, skb);
 	else
 		ref->ops->tx_status_noskb(ref->priv, sband, ista, priv_sta, info);
+	spin_unlock_bh(&sta->rate_ctrl_lock);
 }
 
 static inline void
@@ -64,7 +66,9 @@ rate_control_tx_status_noskb(struct ieee80211_local *local,
 	if (WARN_ON_ONCE(!ref->ops->tx_status_noskb))
 		return;
 
+	spin_lock_bh(&sta->rate_ctrl_lock);
 	ref->ops->tx_status_noskb(ref->priv, sband, ista, priv_sta, info);
+	spin_unlock_bh(&sta->rate_ctrl_lock);
 }
 
 static inline void rate_control_rate_init(struct sta_info *sta)
@@ -115,18 +119,20 @@ static inline void rate_control_rate_update(struct ieee80211_local *local,
 			return;
 		}
 
+		spin_lock_bh(&sta->rate_ctrl_lock);
 		ref->ops->rate_update(ref->priv, sband, &chanctx_conf->def,
 				      ista, priv_sta, changed);
+		spin_unlock_bh(&sta->rate_ctrl_lock);
 		rcu_read_unlock();
 	}
 	drv_sta_rc_update(local, sta->sdata, &sta->sta, changed);
 }
 
 static inline void *rate_control_alloc_sta(struct rate_control_ref *ref,
-					   struct ieee80211_sta *sta,
-					   gfp_t gfp)
+					   struct sta_info *sta, gfp_t gfp)
 {
-	return ref->ops->alloc_sta(ref->priv, sta, gfp);
+	spin_lock_init(&sta->rate_ctrl_lock);
+	return ref->ops->alloc_sta(ref->priv, &sta->sta, gfp);
 }
 
 static inline void rate_control_free_sta(struct sta_info *sta)
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 11c1e71c833d..eab8d8afab13 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -292,7 +292,7 @@ static int sta_prepare_rate_control(struct ieee80211_local *local,
 
 	sta->rate_ctrl = local->rate_ctrl;
 	sta->rate_ctrl_priv = rate_control_alloc_sta(sta->rate_ctrl,
-						     &sta->sta, gfp);
+						     sta, gfp);
 	if (!sta->rate_ctrl_priv)
 		return -ENOMEM;
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 36a14a0be6dd..b53c6ca3179a 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -396,6 +396,7 @@ struct sta_info {
 	u8 ptk_idx;
 	struct rate_control_ref *rate_ctrl;
 	void *rate_ctrl_priv;
+	spinlock_t rate_ctrl_lock;
 	spinlock_t lock;
 
 	struct work_struct drv_deliver_wk;
-- 
2.1.4

