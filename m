Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45643 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770Ab0L3TXy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Dec 2010 14:23:54 -0500
Received: by pwj3 with SMTP id 3so1343698pwj.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Dec 2010 11:23:54 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: buytenh@wantstofly.org, mwl8k-devel@cozybit.com,
	Nishant Sarmukadam <nishants@marvell.com>,
	Pradeep Nemavat <pnemavat@marvell.com>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 1/4 V2] mwl8k: Modify add_dma_header to include pad parameters
Date: Thu, 30 Dec 2010 11:23:31 -0800
Message-Id: <1293737014-11718-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Nishant Sarmukadam <nishants@marvell.com>

Add capability to add_dma_header to support padding at tail of the data
packet to be transmitted when crypto is enabled. Padding is required for
adding crypto information in data packets for supporting 802.11 security
modes.

V2:
- made padding tail-only as we will tell mac80211 to do head padding
in next patch (Johannes)

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Pradeep Nemavat <pnemavat@marvell.com>
Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 drivers/net/wireless/mwl8k.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 9ecf840..1798b7e 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -715,10 +715,12 @@ static inline void mwl8k_remove_dma_header(struct sk_buff *skb, __le16 qos)
 		skb_pull(skb, sizeof(*tr) - hdrlen);
 }
 
-static inline void mwl8k_add_dma_header(struct sk_buff *skb)
+static void
+mwl8k_add_dma_header(struct sk_buff *skb, int tail_pad)
 {
 	struct ieee80211_hdr *wh;
 	int hdrlen;
+	int reqd_hdrlen;
 	struct mwl8k_dma_data *tr;
 
 	/*
@@ -730,11 +732,13 @@ static inline void mwl8k_add_dma_header(struct sk_buff *skb)
 	wh = (struct ieee80211_hdr *)skb->data;
 
 	hdrlen = ieee80211_hdrlen(wh->frame_control);
-	if (hdrlen != sizeof(*tr))
-		skb_push(skb, sizeof(*tr) - hdrlen);
+	reqd_hdrlen = sizeof(*tr);
+
+	if (hdrlen != reqd_hdrlen)
+		skb_push(skb, reqd_hdrlen - hdrlen);
 
 	if (ieee80211_is_data_qos(wh->frame_control))
-		hdrlen -= 2;
+		hdrlen -= IEEE80211_QOS_CTL_LEN;
 
 	tr = (struct mwl8k_dma_data *)skb->data;
 	if (wh != &tr->wh)
@@ -747,7 +751,7 @@ static inline void mwl8k_add_dma_header(struct sk_buff *skb)
 	 * payload".  That is, everything except for the 802.11 header.
 	 * This includes all crypto material including the MIC.
 	 */
-	tr->fwlen = cpu_to_le16(skb->len - sizeof(*tr));
+	tr->fwlen = cpu_to_le16(skb->len - sizeof(*tr) + tail_pad);
 }
 
 
@@ -1443,7 +1447,7 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 	else
 		qos = 0;
 
-	mwl8k_add_dma_header(skb);
+	mwl8k_add_dma_header(skb, 0);
 	wh = &((struct mwl8k_dma_data *)skb->data)->wh;
 
 	tx_info = IEEE80211_SKB_CB(skb);
-- 
1.7.0.4

