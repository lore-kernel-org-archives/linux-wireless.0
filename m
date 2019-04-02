Return-Path: <SRS0=bKPU=SE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E9C8C4360F
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Apr 2019 09:48:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 505EA20857
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Apr 2019 09:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554198495;
	bh=JqURCqDSHqO3lrOh826461hUgG0VVUIZXAVLB9ITokM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=xAYsXoypD8VZfhnzCRtZhTiFoQWRz18a4QaXD1yVRNodrS3BwxHPT5PA42Dlr3aNj
	 uICAoJ/VrioXxrO33IpQ6satuLXNivx7qoDzWPkgeDthvnIs/syzGZC/KMqAE8FNjG
	 O3I0Nxicw0SwYrtt2I+4Uv42/ShmnHSpAZWlIY8g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729178AbfDBJsO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Apr 2019 05:48:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:59636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729151AbfDBJsO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Apr 2019 05:48:14 -0400
Received: from localhost.localdomain (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A449F207E0;
        Tue,  2 Apr 2019 09:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554198493;
        bh=JqURCqDSHqO3lrOh826461hUgG0VVUIZXAVLB9ITokM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UfdEN7xKlEugcYB1qX/1yDKhnDudMxn6yyTInxZVuxusR+wXmmLYZUyp+fmOuIbrH
         USySfMeO/0FoRkZn3HhSc1EjWi0FfAwrv+tBo0AOmmHxO1NF9IODFsCeRUgKY2fmAo
         RRtNu1DPHcL4eoUl3o3JKPg6TjnE28FHERyC5yKI=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     ryder.lee@mediatek.com, roychl666@gmail.com,
        lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2 2/4] mt76: add skb pointer to mt76_tx_info
Date:   Tue,  2 Apr 2019 11:47:57 +0200
Message-Id: <0179a6b2248c304ca379f296c3c5104180c1cc1c.1554194917.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1554194917.git.lorenzo@kernel.org>
References: <cover.1554194917.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Pass skb pointer to tx_prepare_skb through mt76_tx_info data structure.
This is a preliminary patch to properly support dma error path for
new chipsets (e.g. 7615)

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c       | 11 ++++++-----
 drivers/net/wireless/mediatek/mt76/mt76.h      |  4 ++--
 .../net/wireless/mediatek/mt76/mt7603/mac.c    | 11 ++++++-----
 .../net/wireless/mediatek/mt76/mt7603/mt7603.h |  4 ++--
 drivers/net/wireless/mediatek/mt76/mt76x02.h   |  4 ++--
 .../net/wireless/mediatek/mt76/mt76x02_txrx.c  | 12 ++++++------
 .../net/wireless/mediatek/mt76/mt76x02_usb.h   |  4 ++--
 .../wireless/mediatek/mt76/mt76x02_usb_core.c  | 18 +++++++++---------
 drivers/net/wireless/mediatek/mt76/usb.c       | 14 ++++++++------
 9 files changed, 43 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index e0286fae8e79..54e6d985d384 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -284,7 +284,9 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
 		      struct ieee80211_sta *sta)
 {
 	struct mt76_queue *q = dev->q_tx[qid].q;
-	struct mt76_tx_info tx_info = {};
+	struct mt76_tx_info tx_info = {
+		.skb = skb,
+	};
 	int len, n = 0, ret = -ENOMEM;
 	struct mt76_queue_entry e;
 	struct mt76_txwi_cache *t;
@@ -329,8 +331,7 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
 
 	dma_sync_single_for_cpu(dev->dev, t->dma_addr, dev->drv->txwi_size,
 				DMA_TO_DEVICE);
-	ret = dev->drv->tx_prepare_skb(dev, txwi, skb, qid, wcid, sta,
-				       &tx_info);
+	ret = dev->drv->tx_prepare_skb(dev, txwi, qid, wcid, sta, &tx_info);
 	dma_sync_single_for_device(dev->dev, t->dma_addr, dev->drv->txwi_size,
 				   DMA_TO_DEVICE);
 	if (ret < 0)
@@ -342,7 +343,7 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
 	}
 
 	return mt76_dma_add_buf(dev, q, tx_info.buf, tx_info.nbuf,
-				tx_info.info, skb, t);
+				tx_info.info, tx_info.skb, t);
 
 unmap:
 	for (n--; n > 0; n--)
@@ -350,7 +351,7 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
 				 tx_info.buf[n].len, DMA_TO_DEVICE);
 
 free:
-	e.skb = skb;
+	e.skb = tx_info.skb;
 	e.txwi = t;
 	dev->drv->tx_complete_skb(dev, qid, &e);
 	mt76_put_txwi(dev, t);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 277f6b754693..91f9433bf979 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -85,6 +85,7 @@ struct mt76_queue_buf {
 
 struct mt76_tx_info {
 	struct mt76_queue_buf buf[32];
+	struct sk_buff *skb;
 	int nbuf;
 	u32 info;
 };
@@ -290,8 +291,7 @@ struct mt76_driver_ops {
 	void (*update_survey)(struct mt76_dev *dev);
 
 	int (*tx_prepare_skb)(struct mt76_dev *dev, void *txwi_ptr,
-			      struct sk_buff *skb, enum mt76_txq_id qid,
-			      struct mt76_wcid *wcid,
+			      enum mt76_txq_id qid, struct mt76_wcid *wcid,
 			      struct ieee80211_sta *sta,
 			      struct mt76_tx_info *tx_info);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
index 5f800467c628..b38b89a89322 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
@@ -937,13 +937,13 @@ mt7603_mac_write_txwi(struct mt7603_dev *dev, __le32 *txwi,
 }
 
 int mt7603_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
-			  struct sk_buff *skb, enum mt76_txq_id qid,
-			  struct mt76_wcid *wcid, struct ieee80211_sta *sta,
+			  enum mt76_txq_id qid, struct mt76_wcid *wcid,
+			  struct ieee80211_sta *sta,
 			  struct mt76_tx_info *tx_info)
 {
 	struct mt7603_dev *dev = container_of(mdev, struct mt7603_dev, mt76);
 	struct mt7603_sta *msta = container_of(wcid, struct mt7603_sta, wcid);
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx_info->skb);
 	struct ieee80211_key_conf *key = info->control.hw_key;
 	int pid;
 
@@ -959,7 +959,7 @@ int mt7603_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 			mt7603_wtbl_set_ps(dev, msta, false);
 	}
 
-	pid = mt76_tx_status_skb_add(mdev, wcid, skb);
+	pid = mt76_tx_status_skb_add(mdev, wcid, tx_info->skb);
 
 	if (info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE) {
 		spin_lock_bh(&dev->mt76.lock);
@@ -969,7 +969,8 @@ int mt7603_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 		spin_unlock_bh(&dev->mt76.lock);
 	}
 
-	mt7603_mac_write_txwi(dev, txwi_ptr, skb, qid, wcid, sta, pid, key);
+	mt7603_mac_write_txwi(dev, txwi_ptr, tx_info->skb, qid, wcid,
+			      sta, pid, key);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h b/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
index 9cc8ca7a4d1c..72352559a212 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
@@ -223,8 +223,8 @@ void mt7603_wtbl_set_smps(struct mt7603_dev *dev, struct mt7603_sta *sta,
 void mt7603_filter_tx(struct mt7603_dev *dev, int idx, bool abort);
 
 int mt7603_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
-			  struct sk_buff *skb, enum mt76_txq_id qid,
-			  struct mt76_wcid *wcid, struct ieee80211_sta *sta,
+			  enum mt76_txq_id qid, struct mt76_wcid *wcid,
+			  struct ieee80211_sta *sta,
 			  struct mt76_tx_info *tx_info);
 
 void mt7603_tx_complete_skb(struct mt76_dev *mdev, enum mt76_txq_id qid,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index 0d817a142e76..fdf2f32b26dc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -184,8 +184,8 @@ irqreturn_t mt76x02_irq_handler(int irq, void *dev_instance);
 void mt76x02_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 		struct sk_buff *skb);
 int mt76x02_tx_prepare_skb(struct mt76_dev *mdev, void *txwi,
-			   struct sk_buff *skb, enum mt76_txq_id qid,
-			   struct mt76_wcid *wcid, struct ieee80211_sta *sta,
+			   enum mt76_txq_id qid, struct mt76_wcid *wcid,
+			   struct ieee80211_sta *sta,
 			   struct mt76_tx_info *tx_info);
 void mt76x02_sw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		     const u8 *mac);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
index dd7d04b9b8db..cf7abd9b7d2e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
@@ -147,12 +147,12 @@ bool mt76x02_tx_status_data(struct mt76_dev *mdev, u8 *update)
 EXPORT_SYMBOL_GPL(mt76x02_tx_status_data);
 
 int mt76x02_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
-			   struct sk_buff *skb, enum mt76_txq_id qid,
-			   struct mt76_wcid *wcid, struct ieee80211_sta *sta,
+			   enum mt76_txq_id qid, struct mt76_wcid *wcid,
+			   struct ieee80211_sta *sta,
 			   struct mt76_tx_info *tx_info)
 {
 	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx_info->skb->data;
 	struct mt76x02_txwi *txwi = txwi_ptr;
 	int hdrlen, len, pid, qsel = MT_QSEL_EDCA;
 
@@ -160,10 +160,10 @@ int mt76x02_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 		mt76x02_mac_wcid_set_drop(dev, wcid->idx, false);
 
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
-	len = skb->len - (hdrlen & 2);
-	mt76x02_mac_write_txwi(dev, txwi, skb, wcid, sta, len);
+	len = tx_info->skb->len - (hdrlen & 2);
+	mt76x02_mac_write_txwi(dev, txwi, tx_info->skb, wcid, sta, len);
 
-	pid = mt76_tx_status_skb_add(mdev, wcid, skb);
+	pid = mt76_tx_status_skb_add(mdev, wcid, tx_info->skb);
 	txwi->pktid = pid;
 
 	if (pid >= MT_PACKET_ID_FIRST)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h b/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
index a012410c5ae7..7b53f9e57f29 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
@@ -26,8 +26,8 @@ int mt76x02u_mcu_fw_send_data(struct mt76x02_dev *dev, const void *data,
 
 int mt76x02u_skb_dma_info(struct sk_buff *skb, int port, u32 flags);
 int mt76x02u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
-			    struct sk_buff *skb, enum mt76_txq_id qid,
-			    struct mt76_wcid *wcid, struct ieee80211_sta *sta,
+			    enum mt76_txq_id qid, struct mt76_wcid *wcid,
+			    struct ieee80211_sta *sta,
 			    struct mt76_tx_info *tx_info);
 void mt76x02u_tx_complete_skb(struct mt76_dev *mdev, enum mt76_txq_id qid,
 			      struct mt76_queue_entry *e);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
index c403218533da..818b96064dec 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
@@ -72,23 +72,23 @@ int mt76x02u_skb_dma_info(struct sk_buff *skb, int port, u32 flags)
 }
 
 int mt76x02u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
-			    struct sk_buff *skb, enum mt76_txq_id qid,
-			    struct mt76_wcid *wcid, struct ieee80211_sta *sta,
+			    enum mt76_txq_id qid, struct mt76_wcid *wcid,
+			    struct ieee80211_sta *sta,
 			    struct mt76_tx_info *tx_info)
 {
 	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
-	int pid, len = skb->len, ep = q2ep(mdev->q_tx[qid].q->hw_idx);
+	int pid, len = tx_info->skb->len, ep = q2ep(mdev->q_tx[qid].q->hw_idx);
 	struct mt76x02_txwi *txwi;
 	enum mt76_qsel qsel;
 	u32 flags;
 
-	mt76_insert_hdr_pad(skb);
+	mt76_insert_hdr_pad(tx_info->skb);
 
-	txwi = (struct mt76x02_txwi *)(skb->data - sizeof(struct mt76x02_txwi));
-	mt76x02_mac_write_txwi(dev, txwi, skb, wcid, sta, len);
-	skb_push(skb, sizeof(struct mt76x02_txwi));
+	txwi = (struct mt76x02_txwi *)(tx_info->skb->data - sizeof(*txwi));
+	mt76x02_mac_write_txwi(dev, txwi, tx_info->skb, wcid, sta, len);
+	skb_push(tx_info->skb, sizeof(*txwi));
 
-	pid = mt76_tx_status_skb_add(mdev, wcid, skb);
+	pid = mt76_tx_status_skb_add(mdev, wcid, tx_info->skb);
 	txwi->pktid = pid;
 
 	if (pid >= MT_PACKET_ID_FIRST || ep == MT_EP_OUT_HCCA)
@@ -101,7 +101,7 @@ int mt76x02u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 	if (!wcid || wcid->hw_key_idx == 0xff || wcid->sw_iv)
 		flags |= MT_TXD_INFO_WIV;
 
-	return mt76x02u_skb_dma_info(skb, WLAN_PORT, flags);
+	return mt76x02u_skb_dma_info(tx_info->skb, WLAN_PORT, flags);
 }
 EXPORT_SYMBOL_GPL(mt76x02u_tx_prepare_skb);
 
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 3b5d30eaa31f..070eef631c43 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -735,7 +735,9 @@ mt76u_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
 		   struct ieee80211_sta *sta)
 {
 	struct mt76_queue *q = dev->q_tx[qid].q;
-	struct urb *urb;
+	struct mt76_tx_info tx_info = {
+		.skb = skb,
+	};
 	u16 idx = q->tail;
 	int err;
 
@@ -743,20 +745,20 @@ mt76u_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
 		return -ENOSPC;
 
 	skb->prev = skb->next = NULL;
-	err = dev->drv->tx_prepare_skb(dev, NULL, skb, qid, wcid, sta, NULL);
+	err = dev->drv->tx_prepare_skb(dev, NULL, qid, wcid, sta, &tx_info);
 	if (err < 0)
 		return err;
 
-	urb = q->entry[idx].urb;
-	err = mt76u_tx_setup_buffers(dev, skb, urb);
+	err = mt76u_tx_setup_buffers(dev, tx_info.skb, q->entry[idx].urb);
 	if (err < 0)
 		return err;
 
 	mt76u_fill_bulk_urb(dev, USB_DIR_OUT, q2ep(q->hw_idx),
-			    urb, mt76u_complete_tx, &q->entry[idx]);
+			    q->entry[idx].urb, mt76u_complete_tx,
+			    &q->entry[idx]);
 
 	q->tail = (q->tail + 1) % q->ndesc;
-	q->entry[idx].skb = skb;
+	q->entry[idx].skb = tx_info.skb;
 	q->queued++;
 
 	return idx;
-- 
2.20.1

