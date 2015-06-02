Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38315 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285AbbFBLcd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2015 07:32:33 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] mac80211: copy nl80211 mgmt TX SKB for status
Date: Tue,  2 Jun 2015 13:32:28 +0200
Message-Id: <1433244749-13800-1-git-send-email-johannes@sipsolutions.net> (sfid-20150602_133237_468099_185F1ED4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When we return the TX status for an nl80211 mgmt TX SKB, we
should also return the original frame with the status to
allow userspace to match up the submission (it could also
use the cookie but both ways are permissible.)

As TX SKBs could be encrypted, at least in the case of ANQP
while associated with the AP, copy the original SKB, store
it with an ACK frame ID and restructure the status path to
use that to return status with the original SKB. Otherwise,
userspace (in particular wpa_supplicant) will get confused.

Reported-by: Matti Gottlieb <matti.gottlieb@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c    |  39 ++++++++++++++++--
 net/mac80211/status.c | 109 +++++++++++++++++++++++++++++++-------------------
 2 files changed, 104 insertions(+), 44 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 02f48c848ef5..5ba528f13300 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2,7 +2,7 @@
  * mac80211 configuration hooks for cfg80211
  *
  * Copyright 2006-2010	Johannes Berg <johannes@sipsolutions.net>
- * Copyright 2013-2014  Intel Mobile Communications GmbH
+ * Copyright 2013-2015  Intel Mobile Communications GmbH
  *
  * This file is GPLv2 as found in COPYING.
  */
@@ -3290,7 +3290,7 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
 	struct ieee80211_local *local = sdata->local;
-	struct sk_buff *skb;
+	struct sk_buff *skb, *ack_skb;
 	struct sta_info *sta;
 	const struct ieee80211_mgmt *mgmt = (void *)params->buf;
 	bool need_offchan = false;
@@ -3428,8 +3428,41 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 	skb->dev = sdata->dev;
 
+	if (!params->dont_wait_for_ack) {
+		unsigned long spin_flags;
+		int id;
+
+		/* make a copy to preserve the original cookie (in case the
+		 * driver decides to reallocate the skb) and the frame contents
+		 * in case of encryption.
+		 */
+		ack_skb = skb_copy(skb, GFP_KERNEL);
+		if (!ack_skb) {
+			ret = -ENOMEM;
+			kfree_skb(skb);
+			goto out_unlock;
+		}
+
+		spin_lock_irqsave(&local->ack_status_lock, spin_flags);
+		id = idr_alloc(&local->ack_status_frames, ack_skb,
+			       1, 0x10000, GFP_ATOMIC);
+		spin_unlock_irqrestore(&local->ack_status_lock, spin_flags);
+
+		if (id < 0) {
+			ret = -ENOMEM;
+			kfree_skb(ack_skb);
+			kfree_skb(skb);
+			goto out_unlock;
+		}
+
+		IEEE80211_SKB_CB(skb)->ack_frame_id = id;
+	} else {
+		/* for cookie below */
+		ack_skb = skb;
+	}
+
 	if (!need_offchan) {
-		*cookie = (unsigned long) skb;
+		*cookie = (unsigned long)ack_skb;
 		ieee80211_tx_skb(sdata, skb);
 		ret = 0;
 		goto out_unlock;
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 461594966b65..56b73e012757 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -429,6 +429,66 @@ static void ieee80211_tdls_td_tx_handle(struct ieee80211_local *local,
 	}
 }
 
+static struct ieee80211_sub_if_data *
+ieee80211_sdata_from_skb(struct ieee80211_local *local, struct sk_buff *skb)
+{
+	struct ieee80211_sub_if_data *sdata;
+
+	if (skb->dev) {
+		list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+			if (!sdata->dev)
+				continue;
+
+			if (skb->dev == sdata->dev)
+				return sdata;
+		}
+
+		return NULL;
+	}
+
+	return rcu_dereference(local->p2p_sdata);
+}
+
+static void ieee80211_report_ack_skb(struct ieee80211_local *local,
+				     struct ieee80211_tx_info *info,
+				     bool acked, bool dropped)
+{
+	struct sk_buff *skb;
+	unsigned long flags;
+
+	spin_lock_irqsave(&local->ack_status_lock, flags);
+	skb = idr_find(&local->ack_status_frames, info->ack_frame_id);
+	if (skb)
+		idr_remove(&local->ack_status_frames, info->ack_frame_id);
+	spin_unlock_irqrestore(&local->ack_status_lock, flags);
+
+	if (!skb)
+		return;
+
+	if (dropped) {
+		dev_kfree_skb_any(skb);
+		return;
+	}
+
+	if (info->flags & IEEE80211_TX_INTFL_NL80211_FRAME_TX) {
+		struct ieee80211_sub_if_data *sdata;
+
+		rcu_read_lock();
+		sdata = ieee80211_sdata_from_skb(local, skb);
+		if (sdata)
+			cfg80211_mgmt_tx_status(&sdata->wdev,
+						(unsigned long)skb,
+						skb->data, skb->len,
+						acked, GFP_ATOMIC);
+		rcu_read_unlock();
+
+		dev_kfree_skb_any(skb);
+	} else {
+		/* consumes skb */
+		skb_complete_wifi_ack(skb, acked);
+	}
+}
+
 static void ieee80211_report_used_skb(struct ieee80211_local *local,
 				      struct sk_buff *skb, bool dropped)
 {
@@ -440,27 +500,14 @@ static void ieee80211_report_used_skb(struct ieee80211_local *local,
 		acked = false;
 
 	if (info->flags & (IEEE80211_TX_INTFL_NL80211_FRAME_TX |
-			   IEEE80211_TX_INTFL_MLME_CONN_TX)) {
-		struct ieee80211_sub_if_data *sdata = NULL;
-		struct ieee80211_sub_if_data *iter_sdata;
+			   IEEE80211_TX_INTFL_MLME_CONN_TX) &&
+	    !info->ack_frame_id) {
+		struct ieee80211_sub_if_data *sdata;
 		u64 cookie = (unsigned long)skb;
 
 		rcu_read_lock();
 
-		if (skb->dev) {
-			list_for_each_entry_rcu(iter_sdata, &local->interfaces,
-						list) {
-				if (!iter_sdata->dev)
-					continue;
-
-				if (skb->dev == iter_sdata->dev) {
-					sdata = iter_sdata;
-					break;
-				}
-			}
-		} else {
-			sdata = rcu_dereference(local->p2p_sdata);
-		}
+		sdata = ieee80211_sdata_from_skb(local, skb);
 
 		if (!sdata) {
 			skb->dev = NULL;
@@ -483,33 +530,13 @@ static void ieee80211_report_used_skb(struct ieee80211_local *local,
 			cfg80211_probe_status(sdata->dev, hdr->addr1,
 					      cookie, acked, GFP_ATOMIC);
 		} else {
-			cfg80211_mgmt_tx_status(&sdata->wdev, cookie, skb->data,
-						skb->len, acked, GFP_ATOMIC);
+			/* we assign ack frame ID for the others */
+			WARN_ON(1);
 		}
 
 		rcu_read_unlock();
-	}
-
-	if (unlikely(info->ack_frame_id)) {
-		struct sk_buff *ack_skb;
-		unsigned long flags;
-
-		spin_lock_irqsave(&local->ack_status_lock, flags);
-		ack_skb = idr_find(&local->ack_status_frames,
-				   info->ack_frame_id);
-		if (ack_skb)
-			idr_remove(&local->ack_status_frames,
-				   info->ack_frame_id);
-		spin_unlock_irqrestore(&local->ack_status_lock, flags);
-
-		if (ack_skb) {
-			if (!dropped) {
-				/* consumes ack_skb */
-				skb_complete_wifi_ack(ack_skb, acked);
-			} else {
-				dev_kfree_skb_any(ack_skb);
-			}
-		}
+	} else if (info->ack_frame_id) {
+		ieee80211_report_ack_skb(local, info, acked, dropped);
 	}
 }
 
-- 
2.1.4

