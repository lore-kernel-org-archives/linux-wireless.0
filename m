Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47641 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932992AbbDQPRF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2015 11:17:05 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 11/11] mac80211: allow segmentation offloads
Date: Fri, 17 Apr 2015 17:15:51 +0200
Message-Id: <1429283751-5104-11-git-send-email-johannes@sipsolutions.net> (sfid-20150417_171709_437390_C16D55F4)
In-Reply-To: <1429283751-5104-1-git-send-email-johannes@sipsolutions.net>
References: <1429283751-5104-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Implement the necessary software segmentation on the normal
TX path so that fast-xmit can use segmentation offload if
the hardware (or driver) supports it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |  3 +-
 net/mac80211/tx.c          | 70 ++++++++++++++++++++++++++++++----------------
 2 files changed, 48 insertions(+), 25 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 25a456c48043..d912e614f53b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -87,7 +87,8 @@ struct ieee80211_local;
 #define IEEE80211_SUPPORTED_NETDEV_FEATURES	\
 	(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |	\
 	 NETIF_F_HW_CSUM | NETIF_F_RXCSUM |	\
-	 NETIF_F_SG | NETIF_F_HIGHDMA)
+	 NETIF_F_SG | NETIF_F_HIGHDMA |		\
+	 NETIF_F_GSO_SOFTWARE)
 
 struct ieee80211_fragment_entry {
 	unsigned long first_frag_time;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 53a16257dfc1..24b082f65a20 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2827,6 +2827,7 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct sta_info *sta;
+	struct sk_buff *next;
 
 	if (unlikely(skb->len < ETH_HLEN)) {
 		kfree_skb(skb);
@@ -2848,36 +2849,57 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 			goto out;
 	}
 
-	/* we cannot process non-linear frames on this path */
-	if (skb_linearize(skb)) {
-		kfree_skb(skb);
-		goto out;
-	}
+	if (netif_needs_gso(dev, skb, 0)) {
+		struct sk_buff *segs;
 
-	/* the frame could be fragmented, software-encrypted, and other things
-	 * so we cannot really handle checksum offload with it - fix it up in
-	 * software before we handle anything else.
-	 */
-	if (skb->ip_summed == CHECKSUM_PARTIAL) {
-		if (skb->encapsulation)
-			skb_set_inner_transport_header(skb,
-						       skb_checksum_start_offset(skb));
-		else
-			skb_set_transport_header(skb,
-						 skb_checksum_start_offset(skb));
-		if (skb_checksum_help(skb))
+		segs = skb_gso_segment(skb, 0);
+		if (IS_ERR(segs)) {
 			goto out_free;
+		} else if (segs) {
+			consume_skb(skb);
+			skb = segs;
+		}
+	} else {
+		/* we cannot process non-linear frames on this path */
+		if (skb_linearize(skb)) {
+			kfree_skb(skb);
+			goto out;
+		}
+
+		/* the frame could be fragmented, software-encrypted, and other
+		 * things so we cannot really handle checksum offload with it -
+		 * fix it up in software before we handle anything else.
+		 */
+		if (skb->ip_summed == CHECKSUM_PARTIAL) {
+			if (skb->encapsulation)
+				skb_set_inner_transport_header(skb,
+							       skb_checksum_start_offset(skb));
+			else
+				skb_set_transport_header(skb,
+							 skb_checksum_start_offset(skb));
+			if (skb_checksum_help(skb))
+				goto out_free;
+		}
 	}
 
-	skb = ieee80211_build_hdr(sdata, skb, info_flags, sta);
-	if (IS_ERR(skb))
-		goto out;
+	next = skb;
+	while (next) {
+		skb = next;
+		next = skb->next;
 
-	dev->stats.tx_packets++;
-	dev->stats.tx_bytes += skb->len;
-	dev->trans_start = jiffies;
+		skb->prev = NULL;
+		skb->next = NULL;
+
+		skb = ieee80211_build_hdr(sdata, skb, info_flags, sta);
+		if (IS_ERR(skb))
+			goto out;
 
-	ieee80211_xmit(sdata, sta, skb);
+		dev->stats.tx_packets++;
+		dev->stats.tx_bytes += skb->len;
+		dev->trans_start = jiffies;
+
+		ieee80211_xmit(sdata, sta, skb);
+	}
 	goto out;
  out_free:
 	kfree_skb(skb);
-- 
2.1.4

