Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:48942 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455AbaB0OVg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 09:21:36 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 07/16] wil6210: broadcast Tx
Date: Thu, 27 Feb 2014 16:20:46 +0200
Message-ID: <1393510855-17566-8-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140227_152149_337669_F3D2BA81)
In-Reply-To: <1393510855-17566-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1393510855-17566-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hardware do not support "real" broadcast on the air.
Use method similar to the Directed Multicast Service (DMS) as
described in the 10.23.15.2 "DMS procedures"

This service copies frame and delivers unicast for each associated peer

Do the following: send original frame to 1-st Tx vring, and send copies
to all other active vrings.

As currently hardware/firmware don't support A-MSDU, convert broadcast
frame to unicast instead of wrapping it in A-MSDU

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 65 ++++++++++++++++++++++++++++-----
 1 file changed, 55 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 48d9715..5ff59ee 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -662,6 +662,60 @@ static struct vring *wil_find_tx_vring(struct wil6210_priv *wil,
 	return NULL;
 }
 
+static void wil_set_da_for_vring(struct wil6210_priv *wil,
+				 struct sk_buff *skb, int vring_index)
+{
+	struct ethhdr *eth = (void *)skb->data;
+	int cid = wil->vring2cid_tid[vring_index][0];
+	memcpy(eth->h_dest, wil->sta[cid].addr, ETH_ALEN);
+}
+
+static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
+			struct sk_buff *skb);
+/*
+ * Find 1-st vring and return it; set dest address for this vring in skb
+ * duplicate skb and send it to other active vrings
+ */
+static struct vring *wil_tx_bcast(struct wil6210_priv *wil,
+				       struct sk_buff *skb)
+{
+	struct vring *v, *v2;
+	struct sk_buff *skb2;
+	int i;
+
+	/* find 1-st vring */
+	for (i = 0; i < WIL6210_MAX_TX_RINGS; i++) {
+		v = &wil->vring_tx[i];
+		if (v->va)
+			goto found;
+	}
+
+	wil_err(wil, "Tx while no vrings active?\n");
+
+	return NULL;
+
+found:
+	wil_dbg_txrx(wil, "BCAST -> ring %d\n", i);
+	wil_set_da_for_vring(wil, skb, i);
+
+	/* find other active vrings and duplicate skb for each */
+	for (i++; i < WIL6210_MAX_TX_RINGS; i++) {
+		v2 = &wil->vring_tx[i];
+		if (!v2->va)
+			continue;
+		skb2 = skb_copy(skb, GFP_ATOMIC);
+		if (skb2) {
+			wil_dbg_txrx(wil, "BCAST DUP -> ring %d\n", i);
+			wil_set_da_for_vring(wil, skb2, i);
+			wil_tx_vring(wil, v2, skb2);
+		} else {
+			wil_err(wil, "skb_copy failed\n");
+		}
+	}
+
+	return v;
+}
+
 static int wil_tx_desc_map(struct vring_tx_desc *d, dma_addr_t pa, u32 len,
 			   int vring_index)
 {
@@ -875,16 +929,7 @@ netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	if (is_unicast_ether_addr(eth->h_dest)) {
 		vring = wil_find_tx_vring(wil, skb);
 	} else {
-		int i = 0;
-		/* TODO: duplicate for all CID's */
-		vring = &wil->vring_tx[i];
-		if (vring->va) {
-			int cid = wil->vring2cid_tid[i][0];
-			/* FIXME FW can accept only unicast frames */
-			memcpy(skb->data, wil->sta[cid].addr, ETH_ALEN);
-		} else {
-			vring = NULL;
-		}
+		vring = wil_tx_bcast(wil, skb);
 	}
 	if (!vring) {
 		wil_err(wil, "No Tx VRING found for %pM\n", eth->h_dest);
-- 
1.8.3.2

