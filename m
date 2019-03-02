Return-Path: <SRS0=UNZO=RF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8567C00319
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 13:48:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8709A2087E
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 13:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551534480;
	bh=Zz6RBYrdKwJfkKpf0eupCc3mcGWloKxrLj6tkxN/uAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=AdAD/PCf5UVATFsjzz1wwlfkH68R923oZYb+gfuy5L3d1p8vEWnw93ZcPNh6MXvS/
	 c3HYV6cXbOh614sw15Nire9bRj9b+ENkiyoDHAHda9yAa+jVsVD12iMI2dtfAFDuZW
	 kQ8KP/FrvqlO3TryuA9Vkf8cqRdtuDQUn+3Wak7g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbfCBNr7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 2 Mar 2019 08:47:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:58340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726901AbfCBNr6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Mar 2019 08:47:58 -0500
Received: from lore-desk.lan (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A3342086D;
        Sat,  2 Mar 2019 13:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551534476;
        bh=Zz6RBYrdKwJfkKpf0eupCc3mcGWloKxrLj6tkxN/uAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZdE8uKiIV+gHhLR9uAu3CIqa88BVbB5hvvzfoxa0TnvjkbEYK9ijoJM62wtxiSYMl
         N059cW/AF3LRxmKTEevb7/9bVx95DQmh3EasuagGPZBtBcgsWON1lertpJJXFgWlQ3
         1YTwIP2RNEWdvSjhmTCrXWkIXMNvqb4fgBPY23d0=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com, roychl666@gmail.com,
        ryder.lee@mediatek.com
Subject: [PATCH 2/5] mt76: remove mt76_queue dependency from tx_prepare_skb function pointer
Date:   Sat,  2 Mar 2019 14:47:39 +0100
Message-Id: <43787f9e0b529974e12066f13123d3be515ae459.1551533068.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1551533068.git.lorenzo@kernel.org>
References: <cover.1551533068.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove mt76_queue dependency from tx_prepare_skb function pointer and
rely on mt76_tx_qid instead. This is a preliminary patch to introduce
mt76_sw_queue support

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c              |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76.h             |  2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c       | 11 ++++++-----
 drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h    |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h          |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c     |  4 ++--
 drivers/net/wireless/mediatek/mt76/mt76x02_usb.h      |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c |  7 +++----
 drivers/net/wireless/mediatek/mt76/usb.c              |  2 +-
 9 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index b9a43183d5d9..a9f0195ef0b7 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -301,7 +301,7 @@ int mt76_dma_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
 	skb->prev = skb->next = NULL;
 	dma_sync_single_for_cpu(dev->dev, t->dma_addr, sizeof(t->txwi),
 				DMA_TO_DEVICE);
-	ret = dev->drv->tx_prepare_skb(dev, &t->txwi, skb, q, wcid, sta,
+	ret = dev->drv->tx_prepare_skb(dev, &t->txwi, skb, qid, wcid, sta,
 				       &tx_info);
 	dma_sync_single_for_device(dev->dev, t->dma_addr, sizeof(t->txwi),
 				   DMA_TO_DEVICE);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 0eaa05007f6d..ef7677f84755 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -288,7 +288,7 @@ struct mt76_driver_ops {
 	void (*update_survey)(struct mt76_dev *dev);
 
 	int (*tx_prepare_skb)(struct mt76_dev *dev, void *txwi_ptr,
-			      struct sk_buff *skb, struct mt76_queue *q,
+			      struct sk_buff *skb, enum mt76_txq_id qid,
 			      struct mt76_wcid *wcid,
 			      struct ieee80211_sta *sta, u32 *tx_info);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
index 0a0115861b51..08ec43765f28 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
@@ -820,7 +820,7 @@ int mt7603_wtbl_set_key(struct mt7603_dev *dev, int wcid,
 
 static int
 mt7603_mac_write_txwi(struct mt7603_dev *dev, __le32 *txwi,
-		      struct sk_buff *skb, struct mt76_queue *q,
+		      struct sk_buff *skb, enum mt76_txq_id qid,
 		      struct mt76_wcid *wcid, struct ieee80211_sta *sta,
 		      int pid, struct ieee80211_key_conf *key)
 {
@@ -828,6 +828,7 @@ mt7603_mac_write_txwi(struct mt7603_dev *dev, __le32 *txwi,
 	struct ieee80211_tx_rate *rate = &info->control.rates[0];
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_vif *vif = info->control.vif;
+	struct mt76_queue *q = &dev->mt76.q_tx[qid];
 	struct mt7603_vif *mvif;
 	int wlan_idx;
 	int hdr_len = ieee80211_get_hdrlen_from_skb(skb);
@@ -841,7 +842,7 @@ mt7603_mac_write_txwi(struct mt7603_dev *dev, __le32 *txwi,
 	if (vif) {
 		mvif = (struct mt7603_vif *)vif->drv_priv;
 		vif_idx = mvif->idx;
-		if (vif_idx && q >= &dev->mt76.q_tx[MT_TXQ_BEACON])
+		if (vif_idx && qid >= MT_TXQ_BEACON)
 			vif_idx += 0x10;
 	}
 
@@ -915,7 +916,7 @@ mt7603_mac_write_txwi(struct mt7603_dev *dev, __le32 *txwi,
 	}
 
 	/* use maximum tx count for beacons and buffered multicast */
-	if (q >= &dev->mt76.q_tx[MT_TXQ_BEACON])
+	if (qid >= MT_TXQ_BEACON)
 		tx_count = 0x1f;
 
 	val = FIELD_PREP(MT_TXD3_REM_TX_COUNT, tx_count) |
@@ -936,7 +937,7 @@ mt7603_mac_write_txwi(struct mt7603_dev *dev, __le32 *txwi,
 }
 
 int mt7603_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
-			  struct sk_buff *skb, struct mt76_queue *q,
+			  struct sk_buff *skb, enum mt76_txq_id qid,
 			  struct mt76_wcid *wcid, struct ieee80211_sta *sta,
 			  u32 *tx_info)
 {
@@ -968,7 +969,7 @@ int mt7603_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 		spin_unlock_bh(&dev->mt76.lock);
 	}
 
-	mt7603_mac_write_txwi(dev, txwi_ptr, skb, q, wcid, sta, pid, key);
+	mt7603_mac_write_txwi(dev, txwi_ptr, skb, qid, wcid, sta, pid, key);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h b/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
index dc9f2e9b20f6..49eeab0f97cf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
@@ -223,7 +223,7 @@ void mt7603_wtbl_set_smps(struct mt7603_dev *dev, struct mt7603_sta *sta,
 void mt7603_filter_tx(struct mt7603_dev *dev, int idx, bool abort);
 
 int mt7603_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
-			  struct sk_buff *skb, struct mt76_queue *q,
+			  struct sk_buff *skb, enum mt76_txq_id qid,
 			  struct mt76_wcid *wcid, struct ieee80211_sta *sta,
 			  u32 *tx_info);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index 3d93017c3227..e42262fd7380 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -169,7 +169,7 @@ irqreturn_t mt76x02_irq_handler(int irq, void *dev_instance);
 void mt76x02_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 		struct sk_buff *skb);
 int mt76x02_tx_prepare_skb(struct mt76_dev *mdev, void *txwi,
-			   struct sk_buff *skb, struct mt76_queue *q,
+			   struct sk_buff *skb, enum mt76_txq_id qid,
 			   struct mt76_wcid *wcid, struct ieee80211_sta *sta,
 			   u32 *tx_info);
 void mt76x02_sw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
index 94f47248c59f..ce9ace11339d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
@@ -147,7 +147,7 @@ bool mt76x02_tx_status_data(struct mt76_dev *mdev, u8 *update)
 EXPORT_SYMBOL_GPL(mt76x02_tx_status_data);
 
 int mt76x02_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
-			   struct sk_buff *skb, struct mt76_queue *q,
+			   struct sk_buff *skb, enum mt76_txq_id qid,
 			   struct mt76_wcid *wcid, struct ieee80211_sta *sta,
 			   u32 *tx_info)
 {
@@ -157,7 +157,7 @@ int mt76x02_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	int pid;
 	int ret;
 
-	if (q == &dev->mt76.q_tx[MT_TXQ_PSD] && wcid && wcid->idx < 128)
+	if (qid == MT_TXQ_PSD && wcid && wcid->idx < 128)
 		mt76x02_mac_wcid_set_drop(dev, wcid->idx, false);
 
 	mt76x02_mac_write_txwi(dev, txwi, skb, wcid, sta, skb->len);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h b/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
index 0126e51d77ed..20e0cee6e4e4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
@@ -26,7 +26,7 @@ int mt76x02u_mcu_fw_send_data(struct mt76x02_dev *dev, const void *data,
 
 int mt76x02u_skb_dma_info(struct sk_buff *skb, int port, u32 flags);
 int mt76x02u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
-			    struct sk_buff *skb, struct mt76_queue *q,
+			    struct sk_buff *skb, enum mt76_txq_id qid,
 			    struct mt76_wcid *wcid, struct ieee80211_sta *sta,
 			    u32 *tx_info);
 void mt76x02u_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
index 6fb52b596d42..643a817ae079 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
@@ -72,16 +72,15 @@ int mt76x02u_skb_dma_info(struct sk_buff *skb, int port, u32 flags)
 }
 
 int mt76x02u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
-			    struct sk_buff *skb, struct mt76_queue *q,
+			    struct sk_buff *skb, enum mt76_txq_id qid,
 			    struct mt76_wcid *wcid, struct ieee80211_sta *sta,
 			    u32 *tx_info)
 {
 	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
+	int pid, len = skb->len, ep = q2ep(mdev->q_tx[qid].hw_idx);
 	struct mt76x02_txwi *txwi;
 	enum mt76_qsel qsel;
-	int len = skb->len;
 	u32 flags;
-	int pid;
 
 	mt76x02_insert_hdr_pad(skb);
 
@@ -92,7 +91,7 @@ int mt76x02u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 	pid = mt76_tx_status_skb_add(mdev, wcid, skb);
 	txwi->pktid = pid;
 
-	if (pid >= MT_PACKET_ID_FIRST || q2ep(q->hw_idx) == MT_EP_OUT_HCCA)
+	if (pid >= MT_PACKET_ID_FIRST || ep == MT_EP_OUT_HCCA)
 		qsel = MT_QSEL_MGMT;
 	else
 		qsel = MT_QSEL_EDCA;
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 47ca79ef1db4..918dc03acfb3 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -739,7 +739,7 @@ mt76u_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
 		return -ENOSPC;
 
 	skb->prev = skb->next = NULL;
-	err = dev->drv->tx_prepare_skb(dev, NULL, skb, q, wcid, sta, NULL);
+	err = dev->drv->tx_prepare_skb(dev, NULL, skb, qid, wcid, sta, NULL);
 	if (err < 0)
 		return err;
 
-- 
2.20.1

