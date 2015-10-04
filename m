Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24814 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbbJDHXy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Oct 2015 03:23:54 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 06/10] wil6210: support BAR (BlockAck Req)
Date: Sun,  4 Oct 2015 10:23:23 +0300
Message-Id: <1443943407-6663-7-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20151004_092357_985637_5BEF0247)
In-Reply-To: <1443943407-6663-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1443943407-6663-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

BAR frames delivered to the host via Rx path; whole BAR frame
get delivered. Advance sequence in the reorder buffer and release
old frames, as per IEEE802.11 spec.

Firmware will reply to BAR, driver responsibility is only reorder
buffer management.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/rx_reorder.c | 26 +++++++++++++++++
 drivers/net/wireless/ath/wil6210/txrx.c       | 40 +++++++++++++++++++++++----
 drivers/net/wireless/ath/wil6210/txrx.h       |  7 +++++
 3 files changed, 67 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/rx_reorder.c b/drivers/net/wireless/ath/wil6210/rx_reorder.c
index 9238c1a..e3d1be8 100644
--- a/drivers/net/wireless/ath/wil6210/rx_reorder.c
+++ b/drivers/net/wireless/ath/wil6210/rx_reorder.c
@@ -205,6 +205,32 @@ out:
 	spin_unlock(&sta->tid_rx_lock);
 }
 
+/* process BAR frame, called in NAPI context */
+void wil_rx_bar(struct wil6210_priv *wil, u8 cid, u8 tid, u16 seq)
+{
+	struct wil_sta_info *sta = &wil->sta[cid];
+	struct wil_tid_ampdu_rx *r;
+
+	spin_lock(&sta->tid_rx_lock);
+
+	r = sta->tid_rx[tid];
+	if (!r) {
+		wil_err(wil, "BAR for non-existing CID %d TID %d\n", cid, tid);
+		goto out;
+	}
+	if (seq_less(seq, r->head_seq_num)) {
+		wil_err(wil, "BAR Seq 0x%03x preceding head 0x%03x\n",
+			seq, r->head_seq_num);
+		goto out;
+	}
+	wil_dbg_txrx(wil, "BAR: CID %d TID %d Seq 0x%03x head 0x%03x\n",
+		     cid, tid, seq, r->head_seq_num);
+	wil_release_reorder_frames(wil, r, seq);
+
+out:
+	spin_unlock(&sta->tid_rx_lock);
+}
+
 struct wil_tid_ampdu_rx *wil_tid_ampdu_rx_alloc(struct wil6210_priv *wil,
 						int size, u16 ssn)
 {
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 8ba271f..c530c79 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -358,6 +358,13 @@ static void wil_rx_add_radiotap_header(struct wil6210_priv *wil,
 	}
 }
 
+/* similar to ieee80211_ version, but FC contain only 1-st byte */
+static inline int wil_is_back_req(u8 fc)
+{
+	return (fc & (IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE)) ==
+	       (IEEE80211_FTYPE_CTL | IEEE80211_STYPE_BACK_REQ);
+}
+
 /**
  * reap 1 frame from @swhead
  *
@@ -411,7 +418,7 @@ again:
 
 	trace_wil6210_rx(i, d);
 	wil_dbg_txrx(wil, "Rx[%3d] : %d bytes\n", i, dmalen);
-	wil_hex_dump_txrx("Rx ", DUMP_PREFIX_NONE, 32, 4,
+	wil_hex_dump_txrx("RxD ", DUMP_PREFIX_NONE, 32, 4,
 			  (const void *)d, sizeof(*d), false);
 
 	cid = wil_rxdesc_cid(d);
@@ -441,23 +448,44 @@ again:
 	/* no extra checks if in sniffer mode */
 	if (ndev->type != ARPHRD_ETHER)
 		return skb;
-	/*
-	 * Non-data frames may be delivered through Rx DMA channel (ex: BAR)
+	/* Non-data frames may be delivered through Rx DMA channel (ex: BAR)
 	 * Driver should recognize it by frame type, that is found
 	 * in Rx descriptor. If type is not data, it is 802.11 frame as is
 	 */
 	ftype = wil_rxdesc_ftype(d) << 2;
 	if (unlikely(ftype != IEEE80211_FTYPE_DATA)) {
-		wil_dbg_txrx(wil, "Non-data frame ftype 0x%08x\n", ftype);
-		/* TODO: process it */
+		u8 fc1 = wil_rxdesc_fc1(d);
+		int mid = wil_rxdesc_mid(d);
+		int tid = wil_rxdesc_tid(d);
+		u16 seq = wil_rxdesc_seq(d);
+
+		wil_dbg_txrx(wil,
+			     "Non-data frame FC[7:0] 0x%02x MID %d CID %d TID %d Seq 0x%03x\n",
+			     fc1, mid, cid, tid, seq);
 		stats->rx_non_data_frame++;
+		if (wil_is_back_req(fc1)) {
+			wil_dbg_txrx(wil,
+				     "BAR: MID %d CID %d TID %d Seq 0x%03x\n",
+				     mid, cid, tid, seq);
+			wil_rx_bar(wil, cid, tid, seq);
+		} else {
+			/* print again all info. One can enable only this
+			 * without overhead for printing every Rx frame
+			 */
+			wil_dbg_txrx(wil,
+				     "Unhandled non-data frame FC[7:0] 0x%02x MID %d CID %d TID %d Seq 0x%03x\n",
+				     fc1, mid, cid, tid, seq);
+			wil_hex_dump_txrx("RxD ", DUMP_PREFIX_NONE, 32, 4,
+					  (const void *)d, sizeof(*d), false);
+			wil_hex_dump_txrx("Rx ", DUMP_PREFIX_OFFSET, 16, 1,
+					  skb->data, skb_headlen(skb), false);
+		}
 		kfree_skb(skb);
 		goto again;
 	}
 
 	if (unlikely(skb->len < ETH_HLEN + snaplen)) {
 		wil_err(wil, "Short frame, len = %d\n", skb->len);
-		/* TODO: process it (i.e. BAR) */
 		stats->rx_short_frame++;
 		kfree_skb(skb);
 		goto again;
diff --git a/drivers/net/wireless/ath/wil6210/txrx.h b/drivers/net/wireless/ath/wil6210/txrx.h
index 82a8f9a..ee7c7b4 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.h
+++ b/drivers/net/wireless/ath/wil6210/txrx.h
@@ -464,6 +464,12 @@ static inline int wil_rxdesc_subtype(struct vring_rx_desc *d)
 	return WIL_GET_BITS(d->mac.d0, 12, 15);
 }
 
+/* 1-st byte (with frame type/subtype) of FC field */
+static inline u8 wil_rxdesc_fc1(struct vring_rx_desc *d)
+{
+	return (u8)(WIL_GET_BITS(d->mac.d0, 10, 15) << 2);
+}
+
 static inline int wil_rxdesc_seq(struct vring_rx_desc *d)
 {
 	return WIL_GET_BITS(d->mac.d0, 16, 27);
@@ -501,6 +507,7 @@ static inline struct vring_rx_desc *wil_skb_rxdesc(struct sk_buff *skb)
 
 void wil_netif_rx_any(struct sk_buff *skb, struct net_device *ndev);
 void wil_rx_reorder(struct wil6210_priv *wil, struct sk_buff *skb);
+void wil_rx_bar(struct wil6210_priv *wil, u8 cid, u8 tid, u16 seq);
 struct wil_tid_ampdu_rx *wil_tid_ampdu_rx_alloc(struct wil6210_priv *wil,
 						int size, u16 ssn);
 void wil_tid_ampdu_rx_free(struct wil6210_priv *wil,
-- 
2.1.4

