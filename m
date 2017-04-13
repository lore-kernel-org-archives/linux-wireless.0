Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55408 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751212AbdDMNua (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 09:50:30 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: rewrite monitor mode delivery logic
Date: Thu, 13 Apr 2017 15:50:27 +0200
Message-Id: <20170413135027.26161-1-johannes@sipsolutions.net> (sfid-20170413_155033_789227_40747097)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The monitor mode delivery logic makes it hard to add any
kind of filtering in an efficient way, because the monitor
SKB is created first and then passed to all interfaces.

Rewrite the logic to create the monitor SKB the first time
it's actually needed, and then keep delivering it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 151 +++++++++++++++++++++++++++++++++---------------------
 1 file changed, 92 insertions(+), 59 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 45fcf28acc3c..50d8f8435830 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -533,6 +533,59 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	}
 }
 
+static struct sk_buff *
+ieee80211_make_monitor_skb(struct ieee80211_local *local,
+			   struct sk_buff **origskb,
+			   struct ieee80211_rate *rate,
+			   int rtap_vendor_space, bool use_origskb)
+{
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(*origskb);
+	int rt_hdrlen, needed_headroom;
+	struct sk_buff *skb;
+
+	/* room for the radiotap header based on driver features */
+	rt_hdrlen = ieee80211_rx_radiotap_hdrlen(local, status, *origskb);
+	needed_headroom = rt_hdrlen - rtap_vendor_space;
+
+	if (use_origskb) {
+		/* only need to expand headroom if necessary */
+		skb = *origskb;
+		*origskb = NULL;
+
+		/*
+		 * This shouldn't trigger often because most devices have an
+		 * RX header they pull before we get here, and that should
+		 * be big enough for our radiotap information. We should
+		 * probably export the length to drivers so that we can have
+		 * them allocate enough headroom to start with.
+		 */
+		if (skb_headroom(skb) < needed_headroom &&
+		    pskb_expand_head(skb, needed_headroom, 0, GFP_ATOMIC)) {
+			dev_kfree_skb(skb);
+			return NULL;
+		}
+	} else {
+		/*
+		 * Need to make a copy and possibly remove radiotap header
+		 * and FCS from the original.
+		 */
+		skb = skb_copy_expand(*origskb, needed_headroom, 0, GFP_ATOMIC);
+
+		if (!skb)
+			return NULL;
+	}
+
+	/* prepend radiotap information */
+	ieee80211_add_rx_radiotap_header(local, skb, rate, rt_hdrlen, true);
+
+	skb_reset_mac_header(skb);
+	skb->ip_summed = CHECKSUM_UNNECESSARY;
+	skb->pkt_type = PACKET_OTHERHOST;
+	skb->protocol = htons(ETH_P_802_2);
+
+	return skb;
+}
+
 /*
  * This function copies a received frame to all monitor interfaces and
  * returns a cleaned-up SKB that no longer includes the FCS nor the
@@ -544,13 +597,12 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 {
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(origskb);
 	struct ieee80211_sub_if_data *sdata;
-	int rt_hdrlen, needed_headroom;
-	struct sk_buff *skb, *skb2;
-	struct net_device *prev_dev = NULL;
+	struct sk_buff *monskb = NULL;
 	int present_fcs_len = 0;
 	unsigned int rtap_vendor_space = 0;
 	struct ieee80211_sub_if_data *monitor_sdata =
 		rcu_dereference(local->monitor_sdata);
+	bool only_monitor = false;
 
 	if (unlikely(status->flag & RX_FLAG_RADIOTAP_VENDOR_DATA)) {
 		struct ieee80211_vendor_radiotap *rtap = (void *)origskb->data;
@@ -583,9 +635,11 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 		return NULL;
 	}
 
+	only_monitor = should_drop_frame(origskb, present_fcs_len,
+					 rtap_vendor_space);
+
 	if (!local->monitors || (status->flag & RX_FLAG_SKIP_MONITOR)) {
-		if (should_drop_frame(origskb, present_fcs_len,
-				      rtap_vendor_space)) {
+		if (only_monitor) {
 			dev_kfree_skb(origskb);
 			return NULL;
 		}
@@ -597,67 +651,46 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 
 	ieee80211_handle_mu_mimo_mon(monitor_sdata, origskb, rtap_vendor_space);
 
-	/* room for the radiotap header based on driver features */
-	rt_hdrlen = ieee80211_rx_radiotap_hdrlen(local, status, origskb);
-	needed_headroom = rt_hdrlen - rtap_vendor_space;
-
-	if (should_drop_frame(origskb, present_fcs_len, rtap_vendor_space)) {
-		/* only need to expand headroom if necessary */
-		skb = origskb;
-		origskb = NULL;
-
-		/*
-		 * This shouldn't trigger often because most devices have an
-		 * RX header they pull before we get here, and that should
-		 * be big enough for our radiotap information. We should
-		 * probably export the length to drivers so that we can have
-		 * them allocate enough headroom to start with.
-		 */
-		if (skb_headroom(skb) < needed_headroom &&
-		    pskb_expand_head(skb, needed_headroom, 0, GFP_ATOMIC)) {
-			dev_kfree_skb(skb);
-			return NULL;
-		}
-	} else {
-		/*
-		 * Need to make a copy and possibly remove radiotap header
-		 * and FCS from the original.
-		 */
-		skb = skb_copy_expand(origskb, needed_headroom, 0, GFP_ATOMIC);
-		remove_monitor_info(origskb, present_fcs_len,
-				    rtap_vendor_space);
-
-		if (!skb)
-			return origskb;
-	}
-
-	/* prepend radiotap information */
-	ieee80211_add_rx_radiotap_header(local, skb, rate, rt_hdrlen, true);
-
-	skb_reset_mac_header(skb);
-	skb->ip_summed = CHECKSUM_UNNECESSARY;
-	skb->pkt_type = PACKET_OTHERHOST;
-	skb->protocol = htons(ETH_P_802_2);
-
 	list_for_each_entry_rcu(sdata, &local->mon_list, u.mntr.list) {
-		if (prev_dev) {
-			skb2 = skb_clone(skb, GFP_ATOMIC);
-			if (skb2) {
-				skb2->dev = prev_dev;
-				netif_receive_skb(skb2);
+		bool last_monitor = list_is_last(&sdata->u.mntr.list,
+						 &local->mon_list);
+
+		if (!monskb)
+			monskb = ieee80211_make_monitor_skb(local, &origskb,
+							    rate,
+							    rtap_vendor_space,
+							    only_monitor &&
+							    last_monitor);
+
+		if (monskb) {
+			struct sk_buff *skb;
+
+			if (last_monitor) {
+				skb = monskb;
+				monskb = NULL;
+			} else {
+				skb = skb_clone(monskb, GFP_ATOMIC);
+			}
+
+			if (skb) {
+				skb->dev = sdata->dev;
+				ieee80211_rx_stats(skb->dev, skb->len);
+				netif_receive_skb(skb);
 			}
 		}
 
-		prev_dev = sdata->dev;
-		ieee80211_rx_stats(sdata->dev, skb->len);
+		if (last_monitor)
+			break;
 	}
 
-	if (prev_dev) {
-		skb->dev = prev_dev;
-		netif_receive_skb(skb);
-	} else
-		dev_kfree_skb(skb);
+	/* this happens if last_monitor was erroneously false */
+	dev_kfree_skb(monskb);
+
+	/* ditto */
+	if (!origskb)
+		return NULL;
 
+	remove_monitor_info(origskb, present_fcs_len, rtap_vendor_space);
 	return origskb;
 }
 
-- 
2.11.0
