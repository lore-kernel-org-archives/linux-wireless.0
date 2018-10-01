Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD375C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 16:58:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 990E92082A
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 16:58:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 990E92082A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbeJAXhO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 19:37:14 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39984 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726274AbeJAXhN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 19:37:13 -0400
Received: by mail-wr1-f65.google.com with SMTP id y8-v6so14791596wrh.7
        for <linux-wireless@vger.kernel.org>; Mon, 01 Oct 2018 09:58:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=l1xBXaO/IQi4S/cPQOjlaF7yXPG+4wgq+4eRCVlTmOQ=;
        b=tiqPJ/xS7Qn0NMXE7/zDXyy7O772EJUJCmsBXDH2wPBR5Ks/33Bug5Xz6aNW1w6j1V
         Zmab7WZdJyPrA6aCMBC8naYFOpnDaQAqMFb6hT49+tamRF9ElSNyl1JJoZJGv2IETf/9
         qhoga3u4NA99pAIylxVFrlbMG7AQhiOJqDI3YcW3HJgl2FE3g9Z7Fq3zYUec5fHIsLZq
         O41o7uTbkgCiHIh2rvqpaKn7NTl2svW18f20HFTRxoztrylvF6QkTXuEnt/SwXOWIQdA
         neIKSaqhpGQtNkJU9V994v+/H7f4E1Q/KMPhrhdNy3rjhoVobBg+8uZh9UR4FzoPahF3
         gAOw==
X-Gm-Message-State: ABuFfoj/RmCYKd083Hwl2lJ7YsYjteC1CefaPSaLCOVKsb5hRRKCC62A
        imlV8//ISRx62MU0iY5M87bYhw==
X-Google-Smtp-Source: ACcGV62l44EtUVL5kengO0h4Y2MNa6l8TZxN4msA0BMCpGq+XLPlSgU0NXLaLG6GSz6ekIx9+quPHQ==
X-Received: by 2002:adf:fa4e:: with SMTP id y14-v6mr7939877wrr.155.1538413108882;
        Mon, 01 Oct 2018 09:58:28 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id b2-v6sm5057600wru.51.2018.10.01.09.58.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 01 Oct 2018 09:58:28 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 4/4] mt76: usb: use mt76x02u_tx_prepare_skb to fill txwi
Date:   Mon,  1 Oct 2018 18:58:20 +0200
Message-Id: <a6eb2337fe6235748bb8b314ada66e50ba783d34.1538411693.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538411693.git.lorenzo.bianconi@redhat.com>
References: <cover.1538411693.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use mt76x02u_tx_prepare_skb routine to fill txwi in mt76x2u and
mt76x0u driver and remove duplicated code. Moreover add static
qualifier to mt76x02_mac_tx_rate_val and mt76x02_mac_fill_txwi
routines

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |  5 --
 .../net/wireless/mediatek/mt76/mt76x0/tx.c    | 38 --------------
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   | 17 +-----
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  |  9 ++--
 .../net/wireless/mediatek/mt76/mt76x02_mac.h  |  5 --
 .../net/wireless/mediatek/mt76/mt76x02_usb.h  |  5 +-
 .../wireless/mediatek/mt76/mt76x02_usb_core.c | 38 +++++++++++++-
 .../wireless/mediatek/mt76/mt76x2/Makefile    |  2 +-
 .../wireless/mediatek/mt76/mt76x2/mt76x2u.h   |  4 --
 .../wireless/mediatek/mt76/mt76x2/usb_core.c  | 52 -------------------
 .../wireless/mediatek/mt76/mt76x2/usb_init.c  |  3 +-
 11 files changed, 48 insertions(+), 130 deletions(-)
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2/usb_core.c

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index a37dbf944b15..e54468af6ba7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -168,11 +168,6 @@ void mt76x0_mac_set_ampdu_factor(struct mt76x0_dev *dev);
 /* TX */
 void mt76x0_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 		struct sk_buff *skb);
-struct mt76x02_txwi *
-mt76x0_push_txwi(struct mt76x0_dev *dev, struct sk_buff *skb,
-		 struct ieee80211_sta *sta, struct mt76_wcid *wcid,
-		 int pkt_len);
-
 void mt76x0_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 			 struct sk_buff *skb);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
index b3c5dc2ffeb1..79c0b3ba1ccb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
@@ -17,44 +17,6 @@
 #include "../mt76x02_util.h"
 #include "../mt76x02_usb.h"
 
-struct mt76x02_txwi *
-mt76x0_push_txwi(struct mt76x0_dev *dev, struct sk_buff *skb,
-		 struct ieee80211_sta *sta, struct mt76_wcid *wcid,
-		 int pkt_len)
-{
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_tx_rate *rate = &info->control.rates[0];
-	struct mt76x02_txwi *txwi;
-	unsigned long flags;
-	u16 rate_ctl;
-	u8 nss;
-
-	txwi = (struct mt76x02_txwi *)skb_push(skb, sizeof(struct mt76x02_txwi));
-	memset(txwi, 0, sizeof(*txwi));
-
-	if (!wcid->tx_rate_set)
-		ieee80211_get_tx_rates(info->control.vif, sta, skb,
-				       info->control.rates, 1);
-
-	spin_lock_irqsave(&dev->mt76.lock, flags);
-	if (rate->idx < 0 || !rate->count) {
-		rate_ctl = wcid->tx_rate;
-		nss = wcid->tx_rate_nss;
-	} else {
-		rate_ctl = mt76x02_mac_tx_rate_val(&dev->mt76, rate, &nss);
-	}
-	spin_unlock_irqrestore(&dev->mt76.lock, flags);
-
-	txwi->wcid = wcid->idx;
-	txwi->rate = cpu_to_le16(rate_ctl);
-	txwi->pktid = (!(info->flags & IEEE80211_TX_CTL_NO_ACK)) ? 1 : 0;
-
-	mt76x02_mac_fill_txwi(txwi, skb, sta, pkt_len, nss);
-
-	return txwi;
-}
-EXPORT_SYMBOL_GPL(mt76x0_push_txwi);
-
 void mt76x0_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 	       struct sk_buff *skb)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index a76043213f55..42c996067d9e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -159,21 +159,6 @@ static const struct ieee80211_ops mt76x0u_ops = {
 	.wake_tx_queue = mt76_wake_tx_queue,
 };
 
-static int mt76x0u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
-				  struct sk_buff *skb, struct mt76_queue *q,
-				  struct mt76_wcid *wcid, struct ieee80211_sta *sta,
-				  u32 *tx_info)
-{
-	struct mt76x0_dev *dev = container_of(mdev, struct mt76x0_dev, mt76);
-	struct mt76x02_txwi *txwi;
-	int len = skb->len;
-
-	mt76x02_insert_hdr_pad(skb);
-	txwi = mt76x0_push_txwi(dev, skb, sta, wcid, len);
-
-	return mt76x02u_set_txinfo(skb, wcid, q2ep(q->hw_idx));
-}
-
 static int mt76x0u_register_device(struct mt76x0_dev *dev)
 {
 	struct ieee80211_hw *hw = dev->mt76.hw;
@@ -230,7 +215,7 @@ static int mt76x0u_probe(struct usb_interface *usb_intf,
 			 const struct usb_device_id *id)
 {
 	static const struct mt76_driver_ops drv_ops = {
-		.tx_prepare_skb = mt76x0u_tx_prepare_skb,
+		.tx_prepare_skb = mt76x02u_tx_prepare_skb,
 		.tx_complete_skb = mt76x02_tx_complete_skb,
 		.tx_status_data = mt76x02_tx_status_data,
 		.rx_skb = mt76x0_queue_rx_skb,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 71d677a6b88a..a02e97665463 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -157,8 +157,9 @@ void mt76x02_txq_init(struct mt76_dev *dev, struct ieee80211_txq *txq)
 }
 EXPORT_SYMBOL_GPL(mt76x02_txq_init);
 
-void mt76x02_mac_fill_txwi(struct mt76x02_txwi *txwi, struct sk_buff *skb,
-			  struct ieee80211_sta *sta, int len, u8 nss)
+static void
+mt76x02_mac_fill_txwi(struct mt76x02_txwi *txwi, struct sk_buff *skb,
+		      struct ieee80211_sta *sta, int len, u8 nss)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
@@ -197,9 +198,8 @@ void mt76x02_mac_fill_txwi(struct mt76x02_txwi *txwi, struct sk_buff *skb,
 	txwi->flags |= cpu_to_le16(txwi_flags);
 	txwi->len_ctl = cpu_to_le16(len);
 }
-EXPORT_SYMBOL_GPL(mt76x02_mac_fill_txwi);
 
-__le16
+static __le16
 mt76x02_mac_tx_rate_val(struct mt76_dev *dev,
 		       const struct ieee80211_tx_rate *rate, u8 *nss_val)
 {
@@ -249,7 +249,6 @@ mt76x02_mac_tx_rate_val(struct mt76_dev *dev,
 	*nss_val = nss;
 	return cpu_to_le16(rateval);
 }
-EXPORT_SYMBOL_GPL(mt76x02_mac_tx_rate_val);
 
 void mt76x02_mac_wcid_set_rate(struct mt76_dev *dev, struct mt76_wcid *wcid,
 			      const struct ieee80211_tx_rate *rate)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index ddc8057fbbab..8788c54c6c3d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -180,8 +180,6 @@ static inline bool mt76x02_wait_for_mac(struct mt76_dev *dev)
 }
 
 void mt76x02_txq_init(struct mt76_dev *dev, struct ieee80211_txq *txq);
-void mt76x02_mac_fill_txwi(struct mt76x02_txwi *txwi, struct sk_buff *skb,
-			  struct ieee80211_sta *sta, int len, u8 nss);
 enum mt76x02_cipher_type
 mt76x02_mac_get_key_info(struct ieee80211_key_conf *key, u8 *key_data);
 
@@ -193,9 +191,6 @@ void mt76x02_mac_wcid_setup(struct mt76_dev *dev, u8 idx, u8 vif_idx, u8 *mac);
 void mt76x02_mac_wcid_set_drop(struct mt76_dev *dev, u8 idx, bool drop);
 void mt76x02_mac_wcid_set_rate(struct mt76_dev *dev, struct mt76_wcid *wcid,
 			      const struct ieee80211_tx_rate *rate);
-__le16
-mt76x02_mac_tx_rate_val(struct mt76_dev *dev,
-		       const struct ieee80211_tx_rate *rate, u8 *nss_val);
 bool mt76x02_mac_load_tx_status(struct mt76_dev *dev,
 			       struct mt76x02_tx_status *stat);
 void mt76x02_send_tx_status(struct mt76_dev *dev,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h b/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
index 2482f9761fcd..f8251c8f3a1b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
@@ -25,5 +25,8 @@ int mt76x02u_mcu_fw_send_data(struct mt76_dev *dev, const void *data,
 			      int data_len, u32 max_payload, u32 offset);
 
 int mt76x02u_skb_dma_info(struct sk_buff *skb, int port, u32 flags);
-int mt76x02u_set_txinfo(struct sk_buff *skb, struct mt76_wcid *wcid, u8 ep);
+int mt76x02u_tx_prepare_skb(struct mt76_dev *dev, void *data,
+			    struct sk_buff *skb, struct mt76_queue *q,
+			    struct mt76_wcid *wcid, struct ieee80211_sta *sta,
+			    u32 *tx_info);
 #endif /* __MT76x02_USB_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
index aecbe0c429ea..dea944b43576 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
@@ -16,6 +16,19 @@
 
 #include "mt76.h"
 #include "mt76x02_dma.h"
+#include "mt76x02_mac.h"
+#include "mt76x02_util.h"
+
+static int mt76x02u_check_skb_rooms(struct sk_buff *skb)
+{
+	int hdr_len = ieee80211_get_hdrlen_from_skb(skb);
+	u32 need_head;
+
+	need_head = sizeof(struct mt76x02_txwi) + MT_DMA_HDR_LEN;
+	if (hdr_len % 4)
+		need_head += 2;
+	return skb_cow(skb, need_head);
+}
 
 int mt76x02u_skb_dma_info(struct sk_buff *skb, int port, u32 flags)
 {
@@ -50,7 +63,8 @@ int mt76x02u_skb_dma_info(struct sk_buff *skb, int port, u32 flags)
 	return 0;
 }
 
-int mt76x02u_set_txinfo(struct sk_buff *skb, struct mt76_wcid *wcid, u8 ep)
+static int
+mt76x02u_set_txinfo(struct sk_buff *skb, struct mt76_wcid *wcid, u8 ep)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	enum mt76_qsel qsel;
@@ -69,4 +83,24 @@ int mt76x02u_set_txinfo(struct sk_buff *skb, struct mt76_wcid *wcid, u8 ep)
 
 	return mt76x02u_skb_dma_info(skb, WLAN_PORT, flags);
 }
-EXPORT_SYMBOL_GPL(mt76x02u_set_txinfo);
+
+int mt76x02u_tx_prepare_skb(struct mt76_dev *dev, void *data,
+			    struct sk_buff *skb, struct mt76_queue *q,
+			    struct mt76_wcid *wcid, struct ieee80211_sta *sta,
+			    u32 *tx_info)
+{
+	struct mt76x02_txwi *txwi;
+	int err, len = skb->len;
+
+	err = mt76x02u_check_skb_rooms(skb);
+	if (err < 0)
+		return -ENOMEM;
+
+	mt76x02_insert_hdr_pad(skb);
+
+	txwi = skb_push(skb, sizeof(struct mt76x02_txwi));
+	mt76x02_mac_write_txwi(dev, txwi, skb, wcid, sta, len);
+
+	return mt76x02u_set_txinfo(skb, wcid, q2ep(q->hw_idx));
+}
+EXPORT_SYMBOL_GPL(mt76x02u_tx_prepare_skb);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/Makefile b/drivers/net/wireless/mediatek/mt76/mt76x2/Makefile
index 2b5a3164274e..560c46e02ec7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/Makefile
@@ -13,6 +13,6 @@ mt76x2e-y := \
 
 mt76x2u-y := \
 	usb.o usb_init.o usb_main.o usb_mac.o usb_mcu.o \
-	usb_phy.o usb_core.o
+	usb_phy.o
 
 CFLAGS_pci_trace.o := -I$(src)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2u.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2u.h
index 969e8e15fc58..e5d08cc8ca73 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2u.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2u.h
@@ -55,10 +55,6 @@ int mt76x2u_mcu_fw_init(struct mt76x2_dev *dev);
 int mt76x2u_alloc_queues(struct mt76x2_dev *dev);
 void mt76x2u_queues_deinit(struct mt76x2_dev *dev);
 void mt76x2u_stop_queues(struct mt76x2_dev *dev);
-int mt76x2u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
-			   struct sk_buff *skb, struct mt76_queue *q,
-			   struct mt76_wcid *wcid, struct ieee80211_sta *sta,
-			   u32 *tx_info);
 int mt76x2u_skb_dma_info(struct sk_buff *skb, enum dma_msg_port port,
 			 u32 flags);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_core.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_core.c
deleted file mode 100644
index a740f059e8e1..000000000000
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_core.c
+++ /dev/null
@@ -1,52 +0,0 @@
-/*
- * Copyright (C) 2018 Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
- * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
- * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
- * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#include "mt76x2u.h"
-#include "../dma.h"
-#include "../mt76x02_util.h"
-#include "../mt76x02_usb.h"
-
-static int
-mt76x2u_check_skb_rooms(struct sk_buff *skb)
-{
-	int hdr_len = ieee80211_get_hdrlen_from_skb(skb);
-	u32 need_head;
-
-	need_head = sizeof(struct mt76x02_txwi) + MT_DMA_HDR_LEN;
-	if (hdr_len % 4)
-		need_head += 2;
-	return skb_cow(skb, need_head);
-}
-
-int mt76x2u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
-			   struct sk_buff *skb, struct mt76_queue *q,
-			   struct mt76_wcid *wcid, struct ieee80211_sta *sta,
-			   u32 *tx_info)
-{
-	struct mt76x02_txwi *txwi;
-	int err, len = skb->len;
-
-	err = mt76x2u_check_skb_rooms(skb);
-	if (err < 0)
-		return -ENOMEM;
-
-	mt76x02_insert_hdr_pad(skb);
-
-	txwi = skb_push(skb, sizeof(struct mt76x02_txwi));
-	mt76x02_mac_write_txwi(mdev, txwi, skb, wcid, sta, len);
-
-	return mt76x02u_set_txinfo(skb, wcid, q2ep(q->hw_idx));
-}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
index 55e0dea568b8..d00c449d13b8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
@@ -20,6 +20,7 @@
 #include "../mt76x02_util.h"
 #include "../mt76x02_phy.h"
 #include "eeprom.h"
+#include "../mt76x02_usb.h"
 
 static void mt76x2u_init_dma(struct mt76x2_dev *dev)
 {
@@ -137,7 +138,7 @@ static int mt76x2u_init_eeprom(struct mt76x2_dev *dev)
 struct mt76x2_dev *mt76x2u_alloc_device(struct device *pdev)
 {
 	static const struct mt76_driver_ops drv_ops = {
-		.tx_prepare_skb = mt76x2u_tx_prepare_skb,
+		.tx_prepare_skb = mt76x02u_tx_prepare_skb,
 		.tx_complete_skb = mt76x02_tx_complete_skb,
 		.tx_status_data = mt76x02_tx_status_data,
 		.rx_skb = mt76x2_queue_rx_skb,
-- 
2.17.1

