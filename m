Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:53067 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965622Ab3DRLeU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Apr 2013 07:34:20 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 4/4] wil6210: more Rx descriptor accessor functions
Date: Thu, 18 Apr 2013 14:33:53 +0300
Message-ID: <1366284834-540-5-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130418_133424_446169_72741A8E)
In-Reply-To: <1366284834-540-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1366284834-540-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Helpers to fetch various fields from the Rx descriptor

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.h |   42 ++++++++++++++++++++++++++-----
 1 file changed, 36 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.h b/drivers/net/wireless/ath/wil6210/txrx.h
index f0cc48a..adef12f 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.h
+++ b/drivers/net/wireless/ath/wil6210/txrx.h
@@ -339,19 +339,19 @@ union vring_desc {
 	struct vring_rx_desc rx;
 } __packed;
 
-static inline int wil_rxdesc_phy_length(struct vring_rx_desc *d)
+static inline int wil_rxdesc_tid(struct vring_rx_desc *d)
 {
-	return WIL_GET_BITS(d->dma.d0, 16, 29);
+	return WIL_GET_BITS(d->mac.d0, 0, 3);
 }
 
-static inline int wil_rxdesc_mcs(struct vring_rx_desc *d)
+static inline int wil_rxdesc_cid(struct vring_rx_desc *d)
 {
-	return WIL_GET_BITS(d->mac.d1, 21, 24);
+	return WIL_GET_BITS(d->mac.d0, 4, 6);
 }
 
-static inline int wil_rxdesc_ds_bits(struct vring_rx_desc *d)
+static inline int wil_rxdesc_mid(struct vring_rx_desc *d)
 {
-	return WIL_GET_BITS(d->mac.d1, 8, 9);
+	return WIL_GET_BITS(d->mac.d0, 8, 9);
 }
 
 static inline int wil_rxdesc_ftype(struct vring_rx_desc *d)
@@ -359,6 +359,36 @@ static inline int wil_rxdesc_ftype(struct vring_rx_desc *d)
 	return WIL_GET_BITS(d->mac.d0, 10, 11);
 }
 
+static inline int wil_rxdesc_subtype(struct vring_rx_desc *d)
+{
+	return WIL_GET_BITS(d->mac.d0, 12, 15);
+}
+
+static inline int wil_rxdesc_seq(struct vring_rx_desc *d)
+{
+	return WIL_GET_BITS(d->mac.d0, 16, 27);
+}
+
+static inline int wil_rxdesc_ext_subtype(struct vring_rx_desc *d)
+{
+	return WIL_GET_BITS(d->mac.d0, 28, 31);
+}
+
+static inline int wil_rxdesc_ds_bits(struct vring_rx_desc *d)
+{
+	return WIL_GET_BITS(d->mac.d1, 8, 9);
+}
+
+static inline int wil_rxdesc_mcs(struct vring_rx_desc *d)
+{
+	return WIL_GET_BITS(d->mac.d1, 21, 24);
+}
+
+static inline int wil_rxdesc_phy_length(struct vring_rx_desc *d)
+{
+	return WIL_GET_BITS(d->dma.d0, 16, 29);
+}
+
 static inline struct vring_rx_desc *wil_skb_rxdesc(struct sk_buff *skb)
 {
 	return (void *)skb->cb;
-- 
1.7.10.4

