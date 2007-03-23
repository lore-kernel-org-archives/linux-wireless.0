Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:48988 "EHLO silver.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933277AbXCWUn1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 16:43:27 -0400
From: Jiri Benc <jbenc@suse.cz>
To: "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20070323214400.642621638.midnight@suse.cz>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/19] mac80211: drop packets from nonexisting interfaces in PS mode
Message-Id: <20070323204443.409B24849A@silver.suse.cz>
Date: Fri, 23 Mar 2007 21:44:43 +0100 (CET)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In a power saving mode, packets queued by devices that meanwhile disappeared
has to be discarded.

Signed-off-by: Jiri Benc <jbenc@suse.cz>

---

 net/mac80211/ieee80211.c |   46 +++++++++++++++++++++++++---------------------
 1 files changed, 25 insertions(+), 21 deletions(-)

c5ba64d9fc39c42ebc1ed38993dd6d3281708b8a
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 577dbe3..3d4fabe 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -1100,10 +1100,10 @@ static int inline is_ieee80211_device(st
 
 /* Device in tx->dev has a reference added; use dev_put(tx->dev) when
  * finished with it. */
-static void inline ieee80211_tx_prepare(struct ieee80211_txrx_data *tx,
-					struct sk_buff *skb,
-					struct net_device *mdev,
-					struct ieee80211_tx_control *control)
+static int inline ieee80211_tx_prepare(struct ieee80211_txrx_data *tx,
+				       struct sk_buff *skb,
+				       struct net_device *mdev,
+				       struct ieee80211_tx_control *control)
 {
 	struct ieee80211_tx_packet_data *pkt_data;
 	struct net_device *dev;
@@ -1114,13 +1114,10 @@ static void inline ieee80211_tx_prepare(
 		dev_put(dev);
 		dev = NULL;
 	}
-	if (unlikely(!dev)) {
-		printk(KERN_WARNING "%s: NULL ifindex in pkt_data\n",
-		       mdev->name);
-		dev = mdev;
-		dev_hold(dev);
-	}
+	if (unlikely(!dev))
+		return -ENODEV;
 	__ieee80211_tx_prepare(tx, skb, dev, control);
+	return 0;
 }
 
 static inline int __ieee80211_queue_stopped(const struct ieee80211_local *local,
@@ -1915,20 +1912,27 @@ ieee80211_get_buffered_bc(struct ieee802
 
 	if (bss->dtim_count != 0)
 		return NULL; /* send buffered bc/mc only after DTIM beacon */
-	skb = skb_dequeue(&bss->ps_bc_buf);
 	memset(control, 0, sizeof(*control));
-	if (!skb)
-		return NULL;
-	local->total_ps_buffered--;
+	while (1) {
+		skb = skb_dequeue(&bss->ps_bc_buf);
+		if (!skb)
+			return NULL;
+		local->total_ps_buffered--;
 
-	if (!skb_queue_empty(&bss->ps_bc_buf) && skb->len >= 2) {
-		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-		/* more buffered multicast/broadcast frames ==> set MoreData
-		 * flag in IEEE 802.11 header to inform PS STAs */
-		hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_MOREDATA);
-	}
+		if (!skb_queue_empty(&bss->ps_bc_buf) && skb->len >= 2) {
+			struct ieee80211_hdr *hdr =
+				(struct ieee80211_hdr *) skb->data;
+			/* more buffered multicast/broadcast frames ==> set
+			 * MoreData flag in IEEE 802.11 header to inform PS
+			 * STAs */
+			hdr->frame_control |=
+				cpu_to_le16(IEEE80211_FCTL_MOREDATA);
+		}
 
-	ieee80211_tx_prepare(&tx, skb, local->mdev, control);
+		if (ieee80211_tx_prepare(&tx, skb, local->mdev, control) == 0)
+			break;
+		dev_kfree_skb_any(skb);
+	}
 	sta = tx.sta;
 	tx.u.tx.ps_buffered = 1;
 
-- 
1.3.0

