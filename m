Return-Path: <SRS0=QiZU=RR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 716CDC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Mar 2019 13:54:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 385692184E
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Mar 2019 13:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552571685;
	bh=4EkdB1AXUoHcmIVHe2bK+14SU370kcnQYFF7p9TyaLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=XsRSGQdYUn4Vw2sdyXCtk4AQoz/WLNjVoN3ueQ/02sM82Eg9+xHeLgp4lhXUcpQJ8
	 G/j7cXEULwbROhz7X06ZS9RJEgj1rsG3McjhKNBNiLAhI4cXGZTV/aFgfdwwsbnYjc
	 MQ8Ii+IKh6L6iRfqRUkB9lY1rBk2cTYZVzSYk+s8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbfCNNyo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Mar 2019 09:54:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:41150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727501AbfCNNyo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Mar 2019 09:54:44 -0400
Received: from localhost.localdomain (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6843F2184C;
        Thu, 14 Mar 2019 13:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552571683;
        bh=4EkdB1AXUoHcmIVHe2bK+14SU370kcnQYFF7p9TyaLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jCml9U06DgGtGVp470ky5dDrs2PKhDGscgjev+pneDkshWoo6iieUsgEYMLY6hFpx
         EmbDwlMYsEKk7DXuV8FVzMEgcevO0W/4tTls8rKVpMGPJt6jfrm4Z/tr5+ybN6WDZm
         KxJxxSDrQejDyM+CAUAzezU00OlP1WLKmXQgllqU=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     ryder.lee@mediatek.com, roychl666@gmail.com,
        linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com
Subject: [PATCH v2 4/4] mt76: introduce mt76_tx_info data structure
Date:   Thu, 14 Mar 2019 14:54:12 +0100
Message-Id: <040189ed66ed30df7b842d0a273c143e4d18e40a.1552570806.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1552570806.git.lorenzo@kernel.org>
References: <cover.1552570806.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add mt76_tx_info as auxiliary data structure to pass values
to tx_prepare_skb pointer. This is a preliminary patch to add
support for new chipsets (e.g. mt7615)

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c      | 29 ++++++++++---------
 drivers/net/wireless/mediatek/mt76/mt76.h     |  9 +++++-
 .../net/wireless/mediatek/mt76/mt7603/mac.c   |  2 +-
 .../wireless/mediatek/mt76/mt7603/mt7603.h    |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  2 +-
 .../net/wireless/mediatek/mt76/mt76x02_txrx.c |  8 ++---
 .../net/wireless/mediatek/mt76/mt76x02_usb.h  |  2 +-
 .../wireless/mediatek/mt76/mt76x02_usb_core.c |  2 +-
 8 files changed, 32 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index a3edaca05fa8..7b8a998103d7 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -284,13 +284,12 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
 		      struct ieee80211_sta *sta)
 {
 	struct mt76_queue *q = dev->q_tx[qid].q;
+	struct mt76_tx_info tx_info = {};
+	int len, n = 0, ret = -ENOMEM;
 	struct mt76_queue_entry e;
 	struct mt76_txwi_cache *t;
-	struct mt76_queue_buf buf[32];
-	int len, n = 0, ret = -ENOMEM;
 	struct sk_buff *iter;
 	dma_addr_t addr;
-	u32 tx_info = 0;
 
 	t = mt76_get_txwi(dev);
 	if (!t) {
@@ -307,13 +306,13 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
 	if (dma_mapping_error(dev->dev, addr))
 		goto free;
 
-	buf[n].addr = t->dma_addr;
-	buf[n++].len = dev->drv->txwi_size;
-	buf[n].addr = addr;
-	buf[n++].len = len;
+	tx_info.buf[n].addr = t->dma_addr;
+	tx_info.buf[n++].len = dev->drv->txwi_size;
+	tx_info.buf[n].addr = addr;
+	tx_info.buf[n++].len = len;
 
 	skb_walk_frags(skb, iter) {
-		if (n == ARRAY_SIZE(buf))
+		if (n == ARRAY_SIZE(tx_info.buf))
 			goto unmap;
 
 		addr = dma_map_single(dev->dev, iter->data, iter->len,
@@ -321,9 +320,10 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
 		if (dma_mapping_error(dev->dev, addr))
 			goto unmap;
 
-		buf[n].addr = addr;
-		buf[n++].len = iter->len;
+		tx_info.buf[n].addr = addr;
+		tx_info.buf[n++].len = iter->len;
 	}
+	tx_info.nbuf = n;
 
 	dma_sync_single_for_cpu(dev->dev, t->dma_addr, sizeof(t->txwi),
 				DMA_TO_DEVICE);
@@ -334,17 +334,18 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
 	if (ret < 0)
 		goto unmap;
 
-	if (q->queued + (n + 1) / 2 >= q->ndesc - 1) {
+	if (q->queued + (tx_info.nbuf + 1) / 2 >= q->ndesc - 1) {
 		ret = -ENOMEM;
 		goto unmap;
 	}
 
-	return mt76_dma_add_buf(dev, q, buf, n, tx_info, skb, t);
+	return mt76_dma_add_buf(dev, q, tx_info.buf, tx_info.nbuf,
+				tx_info.info, skb, t);
 
 unmap:
 	for (n--; n > 0; n--)
-		dma_unmap_single(dev->dev, buf[n].addr, buf[n].len,
-				 DMA_TO_DEVICE);
+		dma_unmap_single(dev->dev, tx_info.buf[n].addr,
+				 tx_info.buf[n].len, DMA_TO_DEVICE);
 
 free:
 	e.skb = skb;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 48d3c03e46a7..edff44f32c8e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -83,6 +83,12 @@ struct mt76_queue_buf {
 	int len;
 };
 
+struct mt76_tx_info {
+	struct mt76_queue_buf buf[32];
+	int nbuf;
+	u32 info;
+};
+
 struct mt76u_buf {
 	struct mt76_dev *dev;
 	struct urb *urb;
@@ -296,7 +302,8 @@ struct mt76_driver_ops {
 	int (*tx_prepare_skb)(struct mt76_dev *dev, void *txwi_ptr,
 			      struct sk_buff *skb, enum mt76_txq_id qid,
 			      struct mt76_wcid *wcid,
-			      struct ieee80211_sta *sta, u32 *tx_info);
+			      struct ieee80211_sta *sta,
+			      struct mt76_tx_info *tx_info);
 
 	void (*tx_complete_skb)(struct mt76_dev *dev, enum mt76_txq_id qid,
 				struct mt76_queue_entry *e);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
index 1ff4c10b291c..5f800467c628 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
@@ -939,7 +939,7 @@ mt7603_mac_write_txwi(struct mt7603_dev *dev, __le32 *txwi,
 int mt7603_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 			  struct sk_buff *skb, enum mt76_txq_id qid,
 			  struct mt76_wcid *wcid, struct ieee80211_sta *sta,
-			  u32 *tx_info)
+			  struct mt76_tx_info *tx_info)
 {
 	struct mt7603_dev *dev = container_of(mdev, struct mt7603_dev, mt76);
 	struct mt7603_sta *msta = container_of(wcid, struct mt7603_sta, wcid);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h b/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
index 8bd00b97066a..f414ff2a5279 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
@@ -225,7 +225,7 @@ void mt7603_filter_tx(struct mt7603_dev *dev, int idx, bool abort);
 int mt7603_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 			  struct sk_buff *skb, enum mt76_txq_id qid,
 			  struct mt76_wcid *wcid, struct ieee80211_sta *sta,
-			  u32 *tx_info);
+			  struct mt76_tx_info *tx_info);
 
 void mt7603_tx_complete_skb(struct mt76_dev *mdev, enum mt76_txq_id qid,
 			    struct mt76_queue_entry *e);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index 53ec8103a268..cb5792b41d2d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -174,7 +174,7 @@ void mt76x02_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 int mt76x02_tx_prepare_skb(struct mt76_dev *mdev, void *txwi,
 			   struct sk_buff *skb, enum mt76_txq_id qid,
 			   struct mt76_wcid *wcid, struct ieee80211_sta *sta,
-			   u32 *tx_info);
+			   struct mt76_tx_info *tx_info);
 void mt76x02_sw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		     const u8 *mac);
 void mt76x02_sw_scan_complete(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
index 708f2c65d3fd..dd7d04b9b8db 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
@@ -149,7 +149,7 @@ EXPORT_SYMBOL_GPL(mt76x02_tx_status_data);
 int mt76x02_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 			   struct sk_buff *skb, enum mt76_txq_id qid,
 			   struct mt76_wcid *wcid, struct ieee80211_sta *sta,
-			   u32 *tx_info)
+			   struct mt76_tx_info *tx_info)
 {
 	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
@@ -169,11 +169,11 @@ int mt76x02_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	if (pid >= MT_PACKET_ID_FIRST)
 		qsel = MT_QSEL_MGMT;
 
-	*tx_info = FIELD_PREP(MT_TXD_INFO_QSEL, qsel) |
-		   MT_TXD_INFO_80211;
+	tx_info->info = FIELD_PREP(MT_TXD_INFO_QSEL, qsel) |
+			MT_TXD_INFO_80211;
 
 	if (!wcid || wcid->hw_key_idx == 0xff || wcid->sw_iv)
-		*tx_info |= MT_TXD_INFO_WIV;
+		tx_info->info |= MT_TXD_INFO_WIV;
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h b/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
index 98e647c8c7c7..8f98cc6ce094 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
@@ -28,7 +28,7 @@ int mt76x02u_skb_dma_info(struct sk_buff *skb, int port, u32 flags);
 int mt76x02u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 			    struct sk_buff *skb, enum mt76_txq_id qid,
 			    struct mt76_wcid *wcid, struct ieee80211_sta *sta,
-			    u32 *tx_info);
+			    struct mt76_tx_info *tx_info);
 void mt76x02u_tx_complete_skb(struct mt76_dev *mdev, enum mt76_txq_id qid,
 			      struct mt76_queue_entry *e);
 #endif /* __MT76x02_USB_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
index 6c3fc4cea283..394dfe5b4a2e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
@@ -74,7 +74,7 @@ int mt76x02u_skb_dma_info(struct sk_buff *skb, int port, u32 flags)
 int mt76x02u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 			    struct sk_buff *skb, enum mt76_txq_id qid,
 			    struct mt76_wcid *wcid, struct ieee80211_sta *sta,
-			    u32 *tx_info)
+			    struct mt76_tx_info *tx_info)
 {
 	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
 	int pid, len = skb->len, ep = q2ep(mdev->q_tx[qid].q->hw_idx);
-- 
2.20.1

