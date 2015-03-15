Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:57392 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbbCOOBA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2015 10:01:00 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 7/7] wil6210: fall back to pseudo-DMS mcast for secure link and PBSS
Date: Sun, 15 Mar 2015 16:00:24 +0200
Message-Id: <1426428024-4538-11-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150315_150417_381835_2CD2C6F8)
In-Reply-To: <1426428024-4538-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1426428024-4538-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Multicast is not yet properly supported for all connection types;
actually, only non-secure AP is supported. For all other cases,
fall back to old "pseudo-DMS" approach. Namely, for:
- PBSS
- secure connection

When re-routing MCAST Rx->Tx on the AP, do not Tx back to the origin
of the frame

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 103 +++++++++++++++++++++++++++++++-
 1 file changed, 101 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 1fe390f..e8bd512 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -908,8 +908,20 @@ static struct vring *wil_find_tx_vring_sta(struct wil6210_priv *wil,
 	return NULL;
 }
 
-static struct vring *wil_find_tx_bcast(struct wil6210_priv *wil,
-				       struct sk_buff *skb)
+/* Use one of 2 strategies:
+ *
+ * 1. New (real broadcast):
+ *    use dedicated broadcast vring
+ * 2. Old (pseudo-DMS):
+ *    Find 1-st vring and return it;
+ *    duplicate skb and send it to other active vrings;
+ *    in all cases override dest address to unicast peer's address
+ * Use old strategy when new is not supported yet:
+ *  - for PBSS
+ *  - for secure link
+ */
+static struct vring *wil_find_tx_bcast_1(struct wil6210_priv *wil,
+					 struct sk_buff *skb)
 {
 	struct vring *v;
 	int i = wil->bcast_vring;
@@ -923,6 +935,93 @@ static struct vring *wil_find_tx_bcast(struct wil6210_priv *wil,
 	return v;
 }
 
+static void wil_set_da_for_vring(struct wil6210_priv *wil,
+				 struct sk_buff *skb, int vring_index)
+{
+	struct ethhdr *eth = (void *)skb->data;
+	int cid = wil->vring2cid_tid[vring_index][0];
+
+	ether_addr_copy(eth->h_dest, wil->sta[cid].addr);
+}
+
+static struct vring *wil_find_tx_bcast_2(struct wil6210_priv *wil,
+					 struct sk_buff *skb)
+{
+	struct vring *v, *v2;
+	struct sk_buff *skb2;
+	int i;
+	u8 cid;
+	struct ethhdr *eth = (void *)skb->data;
+	char *src = eth->h_source;
+
+	/* find 1-st vring eligible for data */
+	for (i = 0; i < WIL6210_MAX_TX_RINGS; i++) {
+		v = &wil->vring_tx[i];
+		if (!v->va)
+			continue;
+
+		cid = wil->vring2cid_tid[i][0];
+		if (cid >= WIL6210_MAX_CID) /* skip BCAST */
+			continue;
+		if (!wil->sta[cid].data_port_open)
+			continue;
+
+		/* don't Tx back to source when re-routing Rx->Tx at the AP */
+		if (0 == memcmp(wil->sta[cid].addr, src, ETH_ALEN))
+			continue;
+
+		goto found;
+	}
+
+	wil_dbg_txrx(wil, "Tx while no vrings active?\n");
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
+		cid = wil->vring2cid_tid[i][0];
+		if (cid >= WIL6210_MAX_CID) /* skip BCAST */
+			continue;
+		if (!wil->sta[cid].data_port_open)
+			continue;
+
+		if (0 == memcmp(wil->sta[cid].addr, src, ETH_ALEN))
+			continue;
+
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
+static struct vring *wil_find_tx_bcast(struct wil6210_priv *wil,
+				       struct sk_buff *skb)
+{
+	struct wireless_dev *wdev = wil->wdev;
+
+	if (wdev->iftype != NL80211_IFTYPE_AP)
+		return wil_find_tx_bcast_2(wil, skb);
+
+	if (wil->privacy)
+		return wil_find_tx_bcast_2(wil, skb);
+
+	return wil_find_tx_bcast_1(wil, skb);
+}
+
 static int wil_tx_desc_map(struct vring_tx_desc *d, dma_addr_t pa, u32 len,
 			   int vring_index)
 {
-- 
2.1.0

