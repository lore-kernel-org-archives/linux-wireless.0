Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54590 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750773AbdDMMhW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 08:37:22 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Aviya Erenfeld <aviya.erenfeld@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix MU-MIMO follow-MAC mode
Date: Thu, 13 Apr 2017 14:37:18 +0200
Message-Id: <20170413123718.18138-1-johannes@sipsolutions.net> (sfid-20170413_143725_291649_2FA4E2B0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There are two bugs in the follow-MAC code:
 * it treats the radiotap header as the 802.11 header
   (therefore it can't possibly work)
 * it doesn't verify that the skb data it accesses is actually
   present in the header, which is mitigated by the first point

Fix this by moving all of this out into a separate function.
This function copies the data it needs using skb_copy_bits()
to make sure it can be accessed if it's paged, and offsets
that by the possibly present vendor radiotap header.

This also makes all those conditions more readable.

Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 65 ++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 47 insertions(+), 18 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index e48724a6725e..4b12c70c85f0 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -208,6 +208,51 @@ ieee80211_rx_radiotap_hdrlen(struct ieee80211_local *local,
 	return len;
 }
 
+static void ieee80211_handle_mu_mimo_mon(struct ieee80211_sub_if_data *sdata,
+					 struct sk_buff *skb,
+					 int rtap_vendor_space)
+{
+	struct {
+		struct ieee80211_hdr_3addr hdr;
+		u8 category;
+		u8 action_code;
+	} __packed action;
+
+	if (!sdata)
+		return;
+
+	BUILD_BUG_ON(sizeof(action) != IEEE80211_MIN_ACTION_SIZE + 1);
+
+	if (skb->len < rtap_vendor_space + sizeof(action) +
+		       VHT_MUMIMO_GROUPS_DATA_LEN)
+		return;
+
+	if (!is_valid_ether_addr(sdata->u.mntr.mu_follow_addr))
+		return;
+
+	skb_copy_bits(skb, rtap_vendor_space, &action, sizeof(action));
+
+	if (!ieee80211_is_action(action.hdr.frame_control))
+		return;
+
+	if (action.category != WLAN_CATEGORY_VHT)
+		return;
+
+	if (action.action_code != WLAN_VHT_ACTION_GROUPID_MGMT)
+		return;
+
+	if (!ether_addr_equal(action.hdr.addr1, sdata->u.mntr.mu_follow_addr))
+		return;
+
+	skb = skb_copy(skb, GFP_ATOMIC);
+	if (!skb)
+		return;
+
+	skb->pkt_type = IEEE80211_SDATA_QUEUE_TYPE_FRAME;
+	skb_queue_tail(&sdata->skb_queue, skb);
+	ieee80211_queue_work(&sdata->local->hw, &sdata->work);
+}
+
 /*
  * ieee80211_add_rx_radiotap_header - add radiotap header
  *
@@ -515,7 +560,6 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 	struct net_device *prev_dev = NULL;
 	int present_fcs_len = 0;
 	unsigned int rtap_vendor_space = 0;
-	struct ieee80211_mgmt *mgmt;
 	struct ieee80211_sub_if_data *monitor_sdata =
 		rcu_dereference(local->monitor_sdata);
 
@@ -553,6 +597,8 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 		return remove_monitor_info(local, origskb, rtap_vendor_space);
 	}
 
+	ieee80211_handle_mu_mimo_mon(monitor_sdata, origskb, rtap_vendor_space);
+
 	/* room for the radiotap header based on driver features */
 	rt_hdrlen = ieee80211_rx_radiotap_hdrlen(local, status, origskb);
 	needed_headroom = rt_hdrlen - rtap_vendor_space;
@@ -618,23 +664,6 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 		ieee80211_rx_stats(sdata->dev, skb->len);
 	}
 
-	mgmt = (void *)skb->data;
-	if (monitor_sdata &&
-	    skb->len >= IEEE80211_MIN_ACTION_SIZE + 1 + VHT_MUMIMO_GROUPS_DATA_LEN &&
-	    ieee80211_is_action(mgmt->frame_control) &&
-	    mgmt->u.action.category == WLAN_CATEGORY_VHT &&
-	    mgmt->u.action.u.vht_group_notif.action_code == WLAN_VHT_ACTION_GROUPID_MGMT &&
-	    is_valid_ether_addr(monitor_sdata->u.mntr.mu_follow_addr) &&
-	    ether_addr_equal(mgmt->da, monitor_sdata->u.mntr.mu_follow_addr)) {
-		struct sk_buff *mu_skb = skb_copy(skb, GFP_ATOMIC);
-
-		if (mu_skb) {
-			mu_skb->pkt_type = IEEE80211_SDATA_QUEUE_TYPE_FRAME;
-			skb_queue_tail(&monitor_sdata->skb_queue, mu_skb);
-			ieee80211_queue_work(&local->hw, &monitor_sdata->work);
-		}
-	}
-
 	if (prev_dev) {
 		skb->dev = prev_dev;
 		netif_receive_skb(skb);
-- 
2.11.0
