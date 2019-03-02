Return-Path: <SRS0=UNZO=RF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF3D5C4360F
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 13:48:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90F4F20838
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 13:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551534481;
	bh=cIs06+KoSULCD0b8n6fHW10XWBlwryX4eOQFz3LGP7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=zTRnt7JDLPt+IhjfYfEXNclZ5LW44Lk+SsbaspgLwAkXSPLyNpvHDAsw6mV2P3Ero
	 7D5Ws+qt5Ib9xJWXxUYfwo+Aa3dHS2CC+PWVxoZibddXiezFCLytLdIE7kq2xoy4Wu
	 MJGQ101A8o5IwF6Y/pCkdr6lEWp/dqofW/5uf5hM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfCBNsA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 2 Mar 2019 08:48:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:58370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726945AbfCBNsA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Mar 2019 08:48:00 -0500
Received: from lore-desk.lan (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C853C20838;
        Sat,  2 Mar 2019 13:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551534479;
        bh=cIs06+KoSULCD0b8n6fHW10XWBlwryX4eOQFz3LGP7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jnCnjAsD2qQrhQvEnp8S2hVyEEH36J/DzYT+BOuxbKnFwOGN5lbmQJj+nJHCoZv95
         la/G9f3YCOvUSoQmCztZ34Xlp9DzWs3tS67u79/se6Dgznfpf6FqRTOEdez5nLd6u1
         a05m7Kx6rdNrPQs5a6sCtuNRinwWJhmMuHk6QMQw=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com, roychl666@gmail.com,
        ryder.lee@mediatek.com
Subject: [PATCH 3/5] mt76: remove mt76_queue dependency from tx_complete_skb function pointer
Date:   Sat,  2 Mar 2019 14:47:40 +0100
Message-Id: <ae5b9c34c2c1492ee5ffa03a9a4de1c7a80c371b.1551533068.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1551533068.git.lorenzo@kernel.org>
References: <cover.1551533068.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove mt76_queue dependency from tx_complete_skb function pointer and
rely on mt76_tx_qid instead. Remove flush from tx_complete_skb
signature. This is a preliminary patch to introduce mt76_sw_queue
support

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c              | 4 ++--
 drivers/net/wireless/mediatek/mt76/mt76.h             | 4 ++--
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c       | 6 +++---
 drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h    | 4 ++--
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c      | 4 ++--
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h      | 4 ++--
 drivers/net/wireless/mediatek/mt76/mt76x02_usb.h      | 4 ++--
 drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c | 4 ++--
 drivers/net/wireless/mediatek/mt76/usb.c              | 2 +-
 9 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index a9f0195ef0b7..58c67df9f185 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -171,7 +171,7 @@ mt76_dma_tx_cleanup(struct mt76_dev *dev, enum mt76_txq_id qid, bool flush)
 
 		if (entry.skb) {
 			spin_unlock_bh(&q->lock);
-			dev->drv->tx_complete_skb(dev, q, &entry, flush);
+			dev->drv->tx_complete_skb(dev, qid, &entry);
 			spin_lock_bh(&q->lock);
 		}
 
@@ -348,7 +348,7 @@ int mt76_dma_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
 free:
 	e.skb = skb;
 	e.txwi = t;
-	dev->drv->tx_complete_skb(dev, q, &e, true);
+	dev->drv->tx_complete_skb(dev, qid, &e);
 	mt76_put_txwi(dev, t);
 	return ret;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index ef7677f84755..e9bb1812c4cf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -292,8 +292,8 @@ struct mt76_driver_ops {
 			      struct mt76_wcid *wcid,
 			      struct ieee80211_sta *sta, u32 *tx_info);
 
-	void (*tx_complete_skb)(struct mt76_dev *dev, struct mt76_queue *q,
-				struct mt76_queue_entry *e, bool flush);
+	void (*tx_complete_skb)(struct mt76_dev *dev, enum mt76_txq_id qid,
+				struct mt76_queue_entry *e);
 
 	bool (*tx_status_data)(struct mt76_dev *dev, u8 *update);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
index 08ec43765f28..7a7f898f5400 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
@@ -1168,8 +1168,8 @@ void mt7603_mac_add_txs(struct mt7603_dev *dev, void *data)
 	rcu_read_unlock();
 }
 
-void mt7603_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
-			    struct mt76_queue_entry *e, bool flush)
+void mt7603_tx_complete_skb(struct mt76_dev *mdev, enum mt76_txq_id qid,
+			    struct mt76_queue_entry *e)
 {
 	struct mt7603_dev *dev = container_of(mdev, struct mt7603_dev, mt76);
 	struct sk_buff *skb = e->skb;
@@ -1179,7 +1179,7 @@ void mt7603_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
 		return;
 	}
 
-	if (q - dev->mt76.q_tx < 4)
+	if (qid < 4)
 		dev->tx_hang_check = 0;
 
 	mt76_tx_complete_skb(mdev, skb);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h b/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
index 49eeab0f97cf..8bd00b97066a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
@@ -227,8 +227,8 @@ int mt7603_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 			  struct mt76_wcid *wcid, struct ieee80211_sta *sta,
 			  u32 *tx_info);
 
-void mt7603_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
-			    struct mt76_queue_entry *e, bool flush);
+void mt7603_tx_complete_skb(struct mt76_dev *mdev, enum mt76_txq_id qid,
+			    struct mt76_queue_entry *e);
 
 void mt7603_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 			 struct sk_buff *skb);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index e1e0c8da5a8c..e2077ba3c761 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -755,8 +755,8 @@ void mt76x02_mac_poll_tx_status(struct mt76x02_dev *dev, bool irq)
 	}
 }
 
-void mt76x02_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
-			     struct mt76_queue_entry *e, bool flush)
+void mt76x02_tx_complete_skb(struct mt76_dev *mdev, enum mt76_txq_id qid,
+			     struct mt76_queue_entry *e)
 {
 	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
 	struct mt76x02_txwi *txwi;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index caeeef96c42f..e4a9e0d0924b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -198,8 +198,8 @@ void mt76x02_mac_write_txwi(struct mt76x02_dev *dev, struct mt76x02_txwi *txwi,
 			    struct sk_buff *skb, struct mt76_wcid *wcid,
 			    struct ieee80211_sta *sta, int len);
 void mt76x02_mac_poll_tx_status(struct mt76x02_dev *dev, bool irq);
-void mt76x02_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
-			     struct mt76_queue_entry *e, bool flush);
+void mt76x02_tx_complete_skb(struct mt76_dev *mdev, enum mt76_txq_id qid,
+			     struct mt76_queue_entry *e);
 void mt76x02_update_channel(struct mt76_dev *mdev);
 void mt76x02_mac_work(struct work_struct *work);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h b/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
index 20e0cee6e4e4..98e647c8c7c7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
@@ -29,6 +29,6 @@ int mt76x02u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 			    struct sk_buff *skb, enum mt76_txq_id qid,
 			    struct mt76_wcid *wcid, struct ieee80211_sta *sta,
 			    u32 *tx_info);
-void mt76x02u_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
-			      struct mt76_queue_entry *e, bool flush);
+void mt76x02u_tx_complete_skb(struct mt76_dev *mdev, enum mt76_txq_id qid,
+			      struct mt76_queue_entry *e);
 #endif /* __MT76x02_USB_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
index 643a817ae079..6ad2f9f95120 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
@@ -26,8 +26,8 @@ static void mt76x02u_remove_dma_hdr(struct sk_buff *skb)
 		mt76x02_remove_hdr_pad(skb, 2);
 }
 
-void mt76x02u_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
-			      struct mt76_queue_entry *e, bool flush)
+void mt76x02u_tx_complete_skb(struct mt76_dev *mdev, enum mt76_txq_id qid,
+			      struct mt76_queue_entry *e)
 {
 	mt76x02u_remove_dma_hdr(e->skb);
 	mt76_tx_complete_skb(mdev, e->skb);
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 918dc03acfb3..e5485c83267b 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -651,7 +651,7 @@ static void mt76u_tx_tasklet(unsigned long data)
 			q->queued--;
 
 			spin_unlock_bh(&q->lock);
-			dev->drv->tx_complete_skb(dev, q, &entry, false);
+			dev->drv->tx_complete_skb(dev, i, &entry);
 			spin_lock_bh(&q->lock);
 		}
 		mt76_txq_schedule(dev, q);
-- 
2.20.1

