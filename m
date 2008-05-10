Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:20731 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbYEJMJt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 08:09:49 -0400
Received: by nf-out-0910.google.com with SMTP id d3so883151nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 10 May 2008 05:09:47 -0700 (PDT)
To: linville@tuxdriver.com
Subject: [PATCH 01/16] rt2x00: Don't use pskb_expand_head()
Date: Sat, 10 May 2008 13:38:26 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200805101337.14536.IvDoorn@gmail.com>
In-Reply-To: <200805101337.14536.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200805101338.27042.IvDoorn@gmail.com> (sfid-20080510_141008_956244_F9D4BE39)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2x00pci allocates DMA for descriptor and data,
rt61pci doesn't use this for the beacon, but it can
use the descriptor part as temporary buffer instead
of using pskb_expand_head().
Using this temporary buffer is obviously much better
then reallocating the skb buffer...

At the same time we can set the data length for the
beacon queue at 0, to make sure no DMA is allocated for
data (but just for the descriptor).

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt61pci.c |   31 +++++++++++--------------------
 1 files changed, 11 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 98af4d2..b64f2f5 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2362,6 +2362,7 @@ static int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct rt2x00_intf *intf = vif_to_intf(control->vif);
+	struct queue_entry_priv_pci_tx *priv_tx;
 	struct skb_frame_desc *skbdesc;
 	unsigned int beacon_base;
 	u32 reg;
@@ -2369,21 +2370,8 @@ static int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	if (unlikely(!intf->beacon))
 		return -ENOBUFS;
 
-	/*
-	 * We need to append the descriptor in front of the
-	 * beacon frame.
-	 */
-	if (skb_headroom(skb) < intf->beacon->queue->desc_size) {
-		if (pskb_expand_head(skb, intf->beacon->queue->desc_size,
-				     0, GFP_ATOMIC))
-			return -ENOMEM;
-	}
-
-	/*
-	 * Add the descriptor in front of the skb.
-	 */
-	skb_push(skb, intf->beacon->queue->desc_size);
-	memset(skb->data, 0, intf->beacon->queue->desc_size);
+	priv_tx = intf->beacon->priv_data;
+	memset(priv_tx->desc, 0, intf->beacon->queue->desc_size);
 
 	/*
 	 * Fill in skb descriptor
@@ -2391,9 +2379,9 @@ static int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	skbdesc = get_skb_frame_desc(skb);
 	memset(skbdesc, 0, sizeof(*skbdesc));
 	skbdesc->flags |= FRAME_DESC_DRIVER_GENERATED;
-	skbdesc->data = skb->data + intf->beacon->queue->desc_size;
-	skbdesc->data_len = skb->len - intf->beacon->queue->desc_size;
-	skbdesc->desc = skb->data;
+	skbdesc->data = skb->data;
+	skbdesc->data_len = skb->len;
+	skbdesc->desc = priv_tx->desc;
 	skbdesc->desc_len = intf->beacon->queue->desc_size;
 	skbdesc->entry = intf->beacon;
 
@@ -2414,7 +2402,10 @@ static int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
 	beacon_base = HW_BEACON_OFFSET(intf->beacon->entry_idx);
 	rt2x00pci_register_multiwrite(rt2x00dev, beacon_base,
-				      skb->data, skb->len);
+				      skbdesc->desc, skbdesc->desc_len);
+	rt2x00pci_register_multiwrite(rt2x00dev,
+				      beacon_base + skbdesc->desc_len,
+				      skbdesc->data, skbdesc->data_len);
 	rt61pci_kick_tx_queue(rt2x00dev, QID_BEACON);
 
 	return 0;
@@ -2479,7 +2470,7 @@ static const struct data_queue_desc rt61pci_queue_tx = {
 
 static const struct data_queue_desc rt61pci_queue_bcn = {
 	.entry_num		= 4 * BEACON_ENTRIES,
-	.data_size		= MGMT_FRAME_SIZE,
+	.data_size		= 0, /* No DMA required for beacons */
 	.desc_size		= TXINFO_SIZE,
 	.priv_size		= sizeof(struct queue_entry_priv_pci_tx),
 };
-- 
1.5.5.1

