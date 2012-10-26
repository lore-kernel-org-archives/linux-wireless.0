Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55103 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab2JZN4v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 09:56:51 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: combine status/drop reporting
Date: Fri, 26 Oct 2012 15:57:23 +0200
Message-Id: <1351259843-5593-1-git-send-email-johannes@sipsolutions.net> (sfid-20121026_155727_787383_CAA6AE33)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The TX status reporting is done for both the
nl80211 report as well as the socket option.
The socket option is also reported when an
skb is dropped to guarantee that the copy in
the IDR tree is freed and status is reported
to userspace.

However, when a frame is dropped, no nl80211
status is reported. This can cause userspace
to stop making progress while waiting for a
status notification.

Combine the nl80211 and socket option status
reporting into a new function and call it in
both places -- when the status comes in from
the driver and when the skb is dropped.

While at it, also simplify the code in the
nl80211 portion a bit.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/status.c |  145 ++++++++++++++++++++++++-------------------------
 1 file changed, 71 insertions(+), 74 deletions(-)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 21fa5c7..2d931ad 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -325,6 +325,75 @@ static void ieee80211_add_tx_radiotap_header(struct ieee80211_supported_band
 
 }
 
+static void ieee80211_report_used_skb(struct ieee80211_local *local,
+				      struct sk_buff *skb, bool dropped)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr = (void *)skb->data;
+	bool acked = info->flags & IEEE80211_TX_STAT_ACK;
+
+	if (dropped)
+		acked = false;
+
+	if (info->flags & IEEE80211_TX_INTFL_NL80211_FRAME_TX) {
+		struct ieee80211_sub_if_data *sdata = NULL;
+		struct ieee80211_sub_if_data *iter_sdata;
+		u64 cookie = (unsigned long)skb;
+
+		rcu_read_lock();
+
+		if (skb->dev) {
+			list_for_each_entry_rcu(iter_sdata, &local->interfaces,
+						list) {
+				if (!iter_sdata->dev)
+					continue;
+
+				if (skb->dev == iter_sdata->dev) {
+					sdata = iter_sdata;
+					break;
+				}
+			}
+		} else {
+			sdata = rcu_dereference(local->p2p_sdata);
+		}
+
+		if (!sdata)
+			skb->dev = NULL;
+		else if (ieee80211_is_nullfunc(hdr->frame_control) ||
+			 ieee80211_is_qos_nullfunc(hdr->frame_control)) {
+			cfg80211_probe_status(sdata->dev, hdr->addr1,
+					      cookie, acked, GFP_ATOMIC);
+		} else {
+			cfg80211_mgmt_tx_status(&sdata->wdev, cookie, skb->data,
+						skb->len, acked, GFP_ATOMIC);
+		}
+
+		rcu_read_unlock();
+	}
+
+	if (unlikely(info->ack_frame_id)) {
+		struct sk_buff *ack_skb;
+		unsigned long flags;
+
+		spin_lock_irqsave(&local->ack_status_lock, flags);
+		ack_skb = idr_find(&local->ack_status_frames,
+				   info->ack_frame_id);
+		if (ack_skb)
+			idr_remove(&local->ack_status_frames,
+				   info->ack_frame_id);
+		spin_unlock_irqrestore(&local->ack_status_lock, flags);
+
+		if (ack_skb) {
+			if (!dropped) {
+				/* consumes ack_skb */
+				skb_complete_wifi_ack(ack_skb, acked);
+			} else {
+				dev_kfree_skb_any(ack_skb);
+			}
+		}
+	}
+}
+
 /*
  * Use a static threshold for now, best value to be determined
  * by testing ...
@@ -516,62 +585,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 					msecs_to_jiffies(10));
 	}
 
-	if (info->flags & IEEE80211_TX_INTFL_NL80211_FRAME_TX) {
-		u64 cookie = (unsigned long)skb;
-		bool found = false;
-
-		acked = info->flags & IEEE80211_TX_STAT_ACK;
-
-		rcu_read_lock();
-
-		list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-			if (!sdata->dev)
-				continue;
-
-			if (skb->dev != sdata->dev)
-				continue;
-
-			found = true;
-			break;
-		}
-
-		if (!skb->dev) {
-			sdata = rcu_dereference(local->p2p_sdata);
-			if (sdata)
-				found = true;
-		}
-
-		if (!found)
-			skb->dev = NULL;
-		else if (ieee80211_is_nullfunc(hdr->frame_control) ||
-			 ieee80211_is_qos_nullfunc(hdr->frame_control)) {
-			cfg80211_probe_status(sdata->dev, hdr->addr1,
-					      cookie, acked, GFP_ATOMIC);
-		} else {
-			cfg80211_mgmt_tx_status(&sdata->wdev, cookie, skb->data,
-						skb->len, acked, GFP_ATOMIC);
-		}
-
-		rcu_read_unlock();
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
-		/* consumes ack_skb */
-		if (ack_skb)
-			skb_complete_wifi_ack(ack_skb,
-				info->flags & IEEE80211_TX_STAT_ACK);
-	}
+	ieee80211_report_used_skb(local, skb, false);
 
 	/* this was a transmitted frame, but now we want to reuse it */
 	skb_orphan(skb);
@@ -647,25 +661,8 @@ EXPORT_SYMBOL(ieee80211_report_low_ack);
 void ieee80211_free_txskb(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
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
-		/* consumes ack_skb */
-		if (ack_skb)
-			dev_kfree_skb_any(ack_skb);
-	}
 
+	ieee80211_report_used_skb(local, skb, true);
 	dev_kfree_skb_any(skb);
 }
 EXPORT_SYMBOL(ieee80211_free_txskb);
-- 
1.7.10.4

