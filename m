Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49611 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab0L1XBu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 18:01:50 -0500
Received: by pwj3 with SMTP id 3so1087171pwj.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Dec 2010 15:01:50 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: mwl8k-devel@cozybit.com, buytenh@wantstofly.org,
	Nishant Sarmukadam <nishants@marvell.com>,
	Pradeep Nemavat <pnemavat@marvell.com>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 1/4] mwl8k: Modify add_dma_header to include pad parameters
Date: Tue, 28 Dec 2010 15:01:34 -0800
Message-Id: <1293577297-25755-2-git-send-email-thomas@cozybit.com>
In-Reply-To: <1293577297-25755-1-git-send-email-thomas@cozybit.com>
References: <1293577297-25755-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Nishant Sarmukadam <nishants@marvell.com>

Add capability to add_dma_header to support padding at head
and tail of the data packet to be transmitted when crypto is
enabled. Padding is required for adding crypto information
in data packets for supporting 802.11 security modes.

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Pradeep Nemavat <pnemavat@marvell.com>
Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 drivers/net/wireless/mwl8k.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 9ecf840..771283b 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -715,10 +715,12 @@ static inline void mwl8k_remove_dma_header(struct sk_buff *skb, __le16 qos)
 		skb_pull(skb, sizeof(*tr) - hdrlen);
 }
 
-static inline void mwl8k_add_dma_header(struct sk_buff *skb)
+static void
+mwl8k_add_dma_header(struct sk_buff *skb, int hdr_pad, int tail_pad)
 {
 	struct ieee80211_hdr *wh;
 	int hdrlen;
+	int reqd_hdrlen;
 	struct mwl8k_dma_data *tr;
 
 	/*
@@ -730,8 +732,10 @@ static inline void mwl8k_add_dma_header(struct sk_buff *skb)
 	wh = (struct ieee80211_hdr *)skb->data;
 
 	hdrlen = ieee80211_hdrlen(wh->frame_control);
-	if (hdrlen != sizeof(*tr))
-		skb_push(skb, sizeof(*tr) - hdrlen);
+	reqd_hdrlen = sizeof(*tr) + hdr_pad;
+
+	if (hdrlen != reqd_hdrlen)
+		skb_push(skb, reqd_hdrlen - hdrlen);
 
 	if (ieee80211_is_data_qos(wh->frame_control))
 		hdrlen -= 2;
@@ -739,8 +743,12 @@ static inline void mwl8k_add_dma_header(struct sk_buff *skb)
 	tr = (struct mwl8k_dma_data *)skb->data;
 	if (wh != &tr->wh)
 		memmove(&tr->wh, wh, hdrlen);
-	if (hdrlen != sizeof(tr->wh))
-		memset(((void *)&tr->wh) + hdrlen, 0, sizeof(tr->wh) - hdrlen);
+	if (hdrlen != sizeof(tr->wh) + hdr_pad)
+		memset(((void *)&tr->wh) + hdrlen, 0,
+					sizeof(tr->wh) + hdr_pad - hdrlen);
+
+	if (tail_pad)
+		skb_put(skb, tail_pad);
 
 	/*
 	 * Firmware length is the length of the fully formed "802.11
@@ -1443,7 +1451,7 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 	else
 		qos = 0;
 
-	mwl8k_add_dma_header(skb);
+	mwl8k_add_dma_header(skb, 0, 0);
 	wh = &((struct mwl8k_dma_data *)skb->data)->wh;
 
 	tx_info = IEEE80211_SKB_CB(skb);
-- 
1.7.0.4

