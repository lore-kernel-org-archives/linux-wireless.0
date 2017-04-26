Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53800 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1437750AbdDZPLi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 11:11:38 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, thomas@net.t-labs.tu-berlin.de
Subject: [PATCH 1/5] mac80211: make rate control tx status API more extensible
Date: Wed, 26 Apr 2017 17:11:35 +0200
Message-Id: <20170426151139.87304-1-nbd@nbd.name> (sfid-20170426_173351_126552_68E67F6A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename .tx_status_noskb to .tx_status_ext and pass a new on-stack
struct ieee80211_tx_status instead of struct ieee80211_tx_info.

This struct can be used to pass extra information, e.g. for dynamic tx
power control

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/net/mac80211.h             | 20 +++++++++++++----
 net/mac80211/rate.c                | 22 +++++++++++++++++++
 net/mac80211/rate.h                | 44 +++-----------------------------------
 net/mac80211/rc80211_minstrel.c    |  6 +++---
 net/mac80211/rc80211_minstrel_ht.c | 10 ++++-----
 net/mac80211/status.c              | 11 ++++++++--
 6 files changed, 58 insertions(+), 55 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index b1ac872dc88a..380700e61d3b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -949,6 +949,19 @@ struct ieee80211_tx_info {
 };
 
 /**
+ * struct ieee80211_tx_status - extended tx staus info for rate control
+ *
+ * @sta: Station that the packet was transmitted for
+ * @info: Basic tx status information
+ * @skb: Packet skb (can be NULL if not provided by the driver)
+ */
+struct ieee80211_tx_status {
+	struct ieee80211_sta *sta;
+	struct ieee80211_tx_info *info;
+	struct sk_buff *skb;
+};
+
+/**
  * struct ieee80211_scan_ies - descriptors for different blocks of IEs
  *
  * This structure is used to point to different blocks of IEs in HW scan
@@ -5476,10 +5489,9 @@ struct rate_control_ops {
 	void (*free_sta)(void *priv, struct ieee80211_sta *sta,
 			 void *priv_sta);
 
-	void (*tx_status_noskb)(void *priv,
-				struct ieee80211_supported_band *sband,
-				struct ieee80211_sta *sta, void *priv_sta,
-				struct ieee80211_tx_info *info);
+	void (*tx_status_ext)(void *priv,
+			      struct ieee80211_supported_band *sband,
+			      void *priv_sta, struct ieee80211_tx_status *st);
 	void (*tx_status)(void *priv, struct ieee80211_supported_band *sband,
 			  struct ieee80211_sta *sta, void *priv_sta,
 			  struct sk_buff *skb);
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 9d7a1cd949fb..b387c07b8b47 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -62,6 +62,28 @@ void rate_control_rate_init(struct sta_info *sta)
 	set_sta_flag(sta, WLAN_STA_RATE_CONTROL);
 }
 
+void rate_control_tx_status(struct ieee80211_local *local,
+			    struct ieee80211_supported_band *sband,
+			    struct ieee80211_tx_status *st)
+{
+	struct rate_control_ref *ref = local->rate_ctrl;
+	struct sta_info *sta = container_of(st->sta, struct sta_info, sta);
+	void *priv_sta = sta->rate_ctrl_priv;
+
+	if (!ref || !test_sta_flag(sta, WLAN_STA_RATE_CONTROL))
+		return;
+
+	spin_lock_bh(&sta->rate_ctrl_lock);
+	if (ref->ops->tx_status_ext)
+		ref->ops->tx_status_ext(ref->priv, sband, priv_sta, st);
+	else if (st->skb)
+		ref->ops->tx_status(ref->priv, sband, st->sta, priv_sta, st->skb);
+	else
+		WARN_ON_ONCE(1);
+
+	spin_unlock_bh(&sta->rate_ctrl_lock);
+}
+
 void rate_control_rate_update(struct ieee80211_local *local,
 				    struct ieee80211_supported_band *sband,
 				    struct sta_info *sta, u32 changed)
diff --git a/net/mac80211/rate.h b/net/mac80211/rate.h
index f7825ef5f871..8212bfeb71d6 100644
--- a/net/mac80211/rate.h
+++ b/net/mac80211/rate.h
@@ -28,47 +28,9 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 			   struct sta_info *sta,
 			   struct ieee80211_tx_rate_control *txrc);
 
-static inline void rate_control_tx_status(struct ieee80211_local *local,
-					  struct ieee80211_supported_band *sband,
-					  struct sta_info *sta,
-					  struct sk_buff *skb)
-{
-	struct rate_control_ref *ref = local->rate_ctrl;
-	struct ieee80211_sta *ista = &sta->sta;
-	void *priv_sta = sta->rate_ctrl_priv;
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-
-	if (!ref || !test_sta_flag(sta, WLAN_STA_RATE_CONTROL))
-		return;
-
-	spin_lock_bh(&sta->rate_ctrl_lock);
-	if (ref->ops->tx_status)
-		ref->ops->tx_status(ref->priv, sband, ista, priv_sta, skb);
-	else
-		ref->ops->tx_status_noskb(ref->priv, sband, ista, priv_sta, info);
-	spin_unlock_bh(&sta->rate_ctrl_lock);
-}
-
-static inline void
-rate_control_tx_status_noskb(struct ieee80211_local *local,
-			     struct ieee80211_supported_band *sband,
-			     struct sta_info *sta,
-			     struct ieee80211_tx_info *info)
-{
-	struct rate_control_ref *ref = local->rate_ctrl;
-	struct ieee80211_sta *ista = &sta->sta;
-	void *priv_sta = sta->rate_ctrl_priv;
-
-	if (!ref || !test_sta_flag(sta, WLAN_STA_RATE_CONTROL))
-		return;
-
-	if (WARN_ON_ONCE(!ref->ops->tx_status_noskb))
-		return;
-
-	spin_lock_bh(&sta->rate_ctrl_lock);
-	ref->ops->tx_status_noskb(ref->priv, sband, ista, priv_sta, info);
-	spin_unlock_bh(&sta->rate_ctrl_lock);
-}
+void rate_control_tx_status(struct ieee80211_local *local,
+			    struct ieee80211_supported_band *sband,
+			    struct ieee80211_tx_status *st);
 
 void rate_control_rate_init(struct sta_info *sta);
 void rate_control_rate_update(struct ieee80211_local *local,
diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 3ebe4405a2d4..9766c1cc4b0a 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -264,9 +264,9 @@ minstrel_update_stats(struct minstrel_priv *mp, struct minstrel_sta_info *mi)
 
 static void
 minstrel_tx_status(void *priv, struct ieee80211_supported_band *sband,
-		   struct ieee80211_sta *sta, void *priv_sta,
-		   struct ieee80211_tx_info *info)
+		   void *priv_sta, struct ieee80211_tx_status *st)
 {
+	struct ieee80211_tx_info *info = st->info;
 	struct minstrel_priv *mp = priv;
 	struct minstrel_sta_info *mi = priv_sta;
 	struct ieee80211_tx_rate *ar = info->status.rates;
@@ -726,7 +726,7 @@ static u32 minstrel_get_expected_throughput(void *priv_sta)
 
 const struct rate_control_ops mac80211_minstrel = {
 	.name = "minstrel",
-	.tx_status_noskb = minstrel_tx_status,
+	.tx_status_ext = minstrel_tx_status,
 	.get_rate = minstrel_get_rate,
 	.rate_init = minstrel_rate_init,
 	.alloc = minstrel_alloc,
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 8e783e197e93..4a5bdad9f303 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -678,9 +678,9 @@ minstrel_aggr_check(struct ieee80211_sta *pubsta, struct sk_buff *skb)
 
 static void
 minstrel_ht_tx_status(void *priv, struct ieee80211_supported_band *sband,
-                      struct ieee80211_sta *sta, void *priv_sta,
-                      struct ieee80211_tx_info *info)
+                      void *priv_sta, struct ieee80211_tx_status *st)
 {
+	struct ieee80211_tx_info *info = st->info;
 	struct minstrel_ht_sta_priv *msp = priv_sta;
 	struct minstrel_ht_sta *mi = &msp->ht;
 	struct ieee80211_tx_rate *ar = info->status.rates;
@@ -690,8 +690,8 @@ minstrel_ht_tx_status(void *priv, struct ieee80211_supported_band *sband,
 	int i;
 
 	if (!msp->is_ht)
-		return mac80211_minstrel.tx_status_noskb(priv, sband, sta,
-							 &msp->legacy, info);
+		return mac80211_minstrel.tx_status_ext(priv, sband,
+						       &msp->legacy, st);
 
 	/* This packet was aggregated but doesn't carry status info */
 	if ((info->flags & IEEE80211_TX_CTL_AMPDU) &&
@@ -1374,7 +1374,7 @@ static u32 minstrel_ht_get_expected_throughput(void *priv_sta)
 
 static const struct rate_control_ops mac80211_minstrel_ht = {
 	.name = "minstrel_ht",
-	.tx_status_noskb = minstrel_ht_tx_status,
+	.tx_status_ext = minstrel_ht_tx_status,
 	.get_rate = minstrel_ht_get_rate,
 	.rate_init = minstrel_ht_rate_init,
 	.rate_update = minstrel_ht_rate_update,
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index fac191d6dcb7..e655b3abb84a 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -637,6 +637,7 @@ void ieee80211_tx_status_noskb(struct ieee80211_hw *hw,
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_supported_band *sband;
+	struct ieee80211_tx_status status = {};
 	int retry_count;
 	bool acked, noack_success;
 
@@ -669,7 +670,9 @@ void ieee80211_tx_status_noskb(struct ieee80211_hw *hw,
 			ieee80211_lost_packet(sta, info);
 		}
 
-		rate_control_tx_status_noskb(local, sband, sta, info);
+		status.sta = pubsta;
+		status.info = info;
+		rate_control_tx_status(local, sband, &status);
 	}
 
 	if (acked || noack_success) {
@@ -748,6 +751,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_tx_status status = {};
 	__le16 fc;
 	struct ieee80211_supported_band *sband;
 	struct rhlist_head *tmp;
@@ -857,7 +861,10 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 			}
 		}
 
-		rate_control_tx_status(local, sband, sta, skb);
+		status.sta = &sta->sta;
+		status.skb = skb;
+		status.info = info;
+		rate_control_tx_status(local, sband, &status);
 		if (ieee80211_vif_is_mesh(&sta->sdata->vif))
 			ieee80211s_update_metric(local, sta, skb);
 
-- 
2.11.0
