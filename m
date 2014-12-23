Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21161 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182AbaLWHse (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 02:48:34 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 19/22] wil6210: fix reordering for MCAST
Date: Tue, 23 Dec 2014 09:47:21 +0200
Message-Id: <1419320844-23989-20-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141223_091347_897232_C64C5BAC)
In-Reply-To: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the reordering block, Ethernet DA was checked for MCAST, this is wrong.
Check instead MCAST indication from 802.11 MAC header. Hardware saves
this into Rx descriptor.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/rx_reorder.c | 10 ++++++++--
 drivers/net/wireless/ath/wil6210/txrx.c       |  8 +-------
 drivers/net/wireless/ath/wil6210/txrx.h       |  5 +++++
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/rx_reorder.c b/drivers/net/wireless/ath/wil6210/rx_reorder.c
index 0865c34..20d65f2 100644
--- a/drivers/net/wireless/ath/wil6210/rx_reorder.c
+++ b/drivers/net/wireless/ath/wil6210/rx_reorder.c
@@ -97,14 +97,20 @@ void wil_rx_reorder(struct wil6210_priv *wil, struct sk_buff *skb)
 	int cid = wil_rxdesc_cid(d);
 	int mid = wil_rxdesc_mid(d);
 	u16 seq = wil_rxdesc_seq(d);
+	int mcast = wil_rxdesc_mcast(d);
 	struct wil_sta_info *sta = &wil->sta[cid];
 	struct wil_tid_ampdu_rx *r;
 	u16 hseq;
 	int index;
 	unsigned long flags;
 
-	wil_dbg_txrx(wil, "MID %d CID %d TID %d Seq 0x%03x\n",
-		     mid, cid, tid, seq);
+	wil_dbg_txrx(wil, "MID %d CID %d TID %d Seq 0x%03x mcast %01x\n",
+		     mid, cid, tid, seq, mcast);
+
+	if (unlikely(mcast)) {
+		wil_netif_rx_any(skb, ndev);
+		return;
+	}
 
 	spin_lock_irqsave(&sta->tid_rx_lock, flags);
 
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 4c145ee..5fc5f56 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -581,14 +581,8 @@ void wil_rx_handle(struct wil6210_priv *wil, int *quota)
 			skb->protocol = htons(ETH_P_802_2);
 			wil_netif_rx_any(skb, ndev);
 		} else {
-			struct ethhdr *eth = (void *)skb->data;
-
 			skb->protocol = eth_type_trans(skb, ndev);
-
-			if (is_unicast_ether_addr(eth->h_dest))
-				wil_rx_reorder(wil, skb);
-			else
-				wil_netif_rx_any(skb, ndev);
+			wil_rx_reorder(wil, skb);
 		}
 	}
 	wil_rx_refill(wil, v->size);
diff --git a/drivers/net/wireless/ath/wil6210/txrx.h b/drivers/net/wireless/ath/wil6210/txrx.h
index e7db356..c906c5f0 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.h
+++ b/drivers/net/wireless/ath/wil6210/txrx.h
@@ -423,6 +423,11 @@ static inline int wil_rxdesc_mcs(struct vring_rx_desc *d)
 	return WIL_GET_BITS(d->mac.d1, 21, 24);
 }
 
+static inline int wil_rxdesc_mcast(struct vring_rx_desc *d)
+{
+	return WIL_GET_BITS(d->mac.d1, 13, 14);
+}
+
 static inline int wil_rxdesc_phy_length(struct vring_rx_desc *d)
 {
 	return WIL_GET_BITS(d->dma.d0, 16, 29);
-- 
2.1.0

