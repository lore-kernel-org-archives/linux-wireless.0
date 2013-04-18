Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:33910 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936229Ab3DRLeP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Apr 2013 07:34:15 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 1/4] wil6210: Use cached copy of Rx descriptor
Date: Thu, 18 Apr 2013 14:33:50 +0300
Message-ID: <1366284834-540-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130418_133418_769732_FB5C7807)
In-Reply-To: <1366284834-540-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1366284834-540-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rx descriptors stored in non-cacheable memory area for DMA.
Non-cacheable memory causes long access time from CPU.

Copy rx descriptor to the skb->cb, and use this copy.
It provides faster memory access, and will be usefull to keep
Rx information for later processing (BACK reorder)

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c |   20 ++++++++++++++------
 drivers/net/wireless/ath/wil6210/txrx.h |   13 +++++++++----
 2 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 1bfa736..d861944 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -193,8 +193,7 @@ static int wil_vring_alloc_skb(struct wil6210_priv *wil, struct vring *vring,
  *  - Phy info
  */
 static void wil_rx_add_radiotap_header(struct wil6210_priv *wil,
-				       struct sk_buff *skb,
-				       volatile struct vring_rx_desc *d)
+				       struct sk_buff *skb)
 {
 	struct wireless_dev *wdev = wil->wdev;
 	struct wil6210_rtap {
@@ -218,6 +217,7 @@ static void wil_rx_add_radiotap_header(struct wil6210_priv *wil,
 		__le16 vendor_skip;
 		u8 vendor_data[0];
 	} __packed;
+	struct vring_rx_desc *d = wil_skb_rxdesc(skb);
 	struct wil6210_rtap_vendor *rtap_vendor;
 	int rtap_len = sizeof(struct wil6210_rtap);
 	int phy_length = 0; /* phy info header size, bytes */
@@ -314,6 +314,8 @@ static void wil_swap_ethaddr(void *data)
 /**
  * reap 1 frame from @swhead
  *
+ * Rx descriptor copied to skb->cb
+ *
  * Safe to call from IRQ
  */
 static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
@@ -322,12 +324,15 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	struct device *dev = wil_to_dev(wil);
 	struct net_device *ndev = wil_to_ndev(wil);
 	volatile struct vring_rx_desc *d;
+	struct vring_rx_desc *d1;
 	struct sk_buff *skb;
 	dma_addr_t pa;
 	unsigned int sz = RX_BUF_LEN;
 	u8 ftype;
 	u8 ds_bits;
 
+	BUILD_BUG_ON(sizeof(struct vring_rx_desc) > sizeof(skb->cb));
+
 	if (wil_vring_is_empty(vring))
 		return NULL;
 
@@ -342,11 +347,14 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	dma_unmap_single(dev, pa, sz, DMA_FROM_DEVICE);
 	skb_trim(skb, d->dma.length);
 
-	wil->stats.last_mcs_rx = wil_rxdesc_mcs(d);
+	d1 = wil_skb_rxdesc(skb);
+	*d1 = *d;
+
+	wil->stats.last_mcs_rx = wil_rxdesc_mcs(d1);
 
 	/* use radiotap header only if required */
 	if (ndev->type == ARPHRD_IEEE80211_RADIOTAP)
-		wil_rx_add_radiotap_header(wil, skb, d);
+		wil_rx_add_radiotap_header(wil, skb);
 
 	wil_dbg_txrx(wil, "Rx[%3d] : %d bytes\n", vring->swhead, d->dma.length);
 	wil_hex_dump_txrx("Rx ", DUMP_PREFIX_NONE, 32, 4,
@@ -362,7 +370,7 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	 * Driver should recognize it by frame type, that is found
 	 * in Rx descriptor. If type is not data, it is 802.11 frame as is
 	 */
-	ftype = wil_rxdesc_ftype(d) << 2;
+	ftype = wil_rxdesc_ftype(d1) << 2;
 	if (ftype != IEEE80211_FTYPE_DATA) {
 		wil_dbg_txrx(wil, "Non-data frame ftype 0x%08x\n", ftype);
 		/* TODO: process it */
@@ -377,7 +385,7 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 		return NULL;
 	}
 
-	ds_bits = wil_rxdesc_ds_bits(d);
+	ds_bits = wil_rxdesc_ds_bits(d1);
 	if (ds_bits == 1) {
 		/*
 		 * HW bug - in ToDS mode, i.e. Rx on AP side,
diff --git a/drivers/net/wireless/ath/wil6210/txrx.h b/drivers/net/wireless/ath/wil6210/txrx.h
index 45a61f5..f0cc48a 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.h
+++ b/drivers/net/wireless/ath/wil6210/txrx.h
@@ -339,24 +339,29 @@ union vring_desc {
 	struct vring_rx_desc rx;
 } __packed;
 
-static inline int wil_rxdesc_phy_length(volatile struct vring_rx_desc *d)
+static inline int wil_rxdesc_phy_length(struct vring_rx_desc *d)
 {
 	return WIL_GET_BITS(d->dma.d0, 16, 29);
 }
 
-static inline int wil_rxdesc_mcs(volatile struct vring_rx_desc *d)
+static inline int wil_rxdesc_mcs(struct vring_rx_desc *d)
 {
 	return WIL_GET_BITS(d->mac.d1, 21, 24);
 }
 
-static inline int wil_rxdesc_ds_bits(volatile struct vring_rx_desc *d)
+static inline int wil_rxdesc_ds_bits(struct vring_rx_desc *d)
 {
 	return WIL_GET_BITS(d->mac.d1, 8, 9);
 }
 
-static inline int wil_rxdesc_ftype(volatile struct vring_rx_desc *d)
+static inline int wil_rxdesc_ftype(struct vring_rx_desc *d)
 {
 	return WIL_GET_BITS(d->mac.d0, 10, 11);
 }
 
+static inline struct vring_rx_desc *wil_skb_rxdesc(struct sk_buff *skb)
+{
+	return (void *)skb->cb;
+}
+
 #endif /* WIL6210_TXRX_H */
-- 
1.7.10.4

