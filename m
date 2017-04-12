Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35230 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752668AbdDLLGZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Apr 2017 07:06:25 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: aviya.erenfeld@intel.com, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/6] mac80211: drop frames too short for FCS earlier
Date: Wed, 12 Apr 2017 13:06:16 +0200
Message-Id: <20170412110621.8981-1-johannes@sipsolutions.net> (sfid-20170412_130630_222069_086A2546)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of dropping such frames only when removing the
monitor info, drop them earlier (keeping the warning)
and simplify removing monitor info. While at it, make
that function return void.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 40 +++++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index e48724a6725e..335c7843169f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -95,24 +95,14 @@ static u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len,
  * This function cleans up the SKB, i.e. it removes all the stuff
  * only useful for monitoring.
  */
-static struct sk_buff *remove_monitor_info(struct ieee80211_local *local,
-					   struct sk_buff *skb,
-					   unsigned int rtap_vendor_space)
+static void remove_monitor_info(struct ieee80211_local *local,
+				struct sk_buff *skb,
+				unsigned int present_fcs_len,
+				unsigned int rtap_vendor_space)
 {
-	if (ieee80211_hw_check(&local->hw, RX_INCLUDES_FCS)) {
-		if (likely(skb->len > FCS_LEN))
-			__pskb_trim(skb, skb->len - FCS_LEN);
-		else {
-			/* driver bug */
-			WARN_ON(1);
-			dev_kfree_skb(skb);
-			return NULL;
-		}
-	}
-
+	if (present_fcs_len)
+		__pskb_trim(skb, skb->len - present_fcs_len);
 	__pskb_pull(skb, rtap_vendor_space);
-
-	return skb;
 }
 
 static inline bool should_drop_frame(struct sk_buff *skb, int present_fcs_len,
@@ -534,8 +524,15 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 	 * the SKB because it has a bad FCS/PLCP checksum.
 	 */
 
-	if (ieee80211_hw_check(&local->hw, RX_INCLUDES_FCS))
+	if (ieee80211_hw_check(&local->hw, RX_INCLUDES_FCS)) {
+		if (unlikely(origskb->len <= FCS_LEN)) {
+			/* driver bug */
+			WARN_ON(1);
+			dev_kfree_skb(origskb);
+			return NULL;
+		}
 		present_fcs_len = FCS_LEN;
+	}
 
 	/* ensure hdr->frame_control and vendor radiotap data are in skb head */
 	if (!pskb_may_pull(origskb, 2 + rtap_vendor_space)) {
@@ -550,7 +547,9 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 			return NULL;
 		}
 
-		return remove_monitor_info(local, origskb, rtap_vendor_space);
+		remove_monitor_info(local, origskb, present_fcs_len,
+				    rtap_vendor_space);
+		return origskb;
 	}
 
 	/* room for the radiotap header based on driver features */
@@ -580,9 +579,8 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 		 * and FCS from the original.
 		 */
 		skb = skb_copy_expand(origskb, needed_headroom, 0, GFP_ATOMIC);
-
-		origskb = remove_monitor_info(local, origskb,
-					      rtap_vendor_space);
+		remove_monitor_info(local, origskb, present_fcs_len,
+				    rtap_vendor_space);
 
 		if (!skb)
 			return origskb;
-- 
2.11.0
