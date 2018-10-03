Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26DC9C64EBC
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 07:49:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1E0B20684
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 07:49:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E1E0B20684
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbeJCOgR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 10:36:17 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52429 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727256AbeJCOgR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 10:36:17 -0400
Received: by mail-wm1-f65.google.com with SMTP id 189-v6so4688645wmw.2
        for <linux-wireless@vger.kernel.org>; Wed, 03 Oct 2018 00:49:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tOnhnu3zHz8HuesGVJihJJ9/CENWHWYzwSfcGd5aTlI=;
        b=nZG9usJLVt4Q1w9f36GTSgvaGGQnzyAHP4TpWWF0HsdPH6HGV+H1toFfQL1pEVX5Xc
         3prCmKbPvQDt9rXZ2D5AGURFAlx9aeGyJENOXtr2l3sdxhgg7XD/uSJWEp83c9wAsnQ0
         /JriH64lkl+b82uEpacnfOVxOsuqSR4ilkoOGBf8MdH285Wx+XLa8uuSPn+d0vnpExp/
         ZW6YgUG1LpkwuYRUJZEoK+uFnNmeSpoTAsBvU71SRMWpLxjCVVFLNoVlrDzNkNc27hCF
         fRHZMxJYhIgORFJ9jkuA9RHmPzPi5HaNmqYQM+i72etNAdIJ5GvLACYnu3LdIwQcH4iv
         hk6Q==
X-Gm-Message-State: ABuFfognGEiGq5GsFG5Wfp/7ljoga2hkgBbe0AqO6c7c701RQEy9rdGu
        D2qkzc3qiqZg5PMRD/imVfpG7Q==
X-Google-Smtp-Source: ACcGV60j8olnnh25Roa9ZoX5eQok11eahcQ2/9WjT4aVlxJJ0ASeoWOv5QMf4kj8cr3PvjhLCmz5oA==
X-Received: by 2002:a1c:6782:: with SMTP id b124-v6mr548113wmc.30.1538552941948;
        Wed, 03 Oct 2018 00:49:01 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id y3sm421878wrw.11.2018.10.03.00.49.01
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Oct 2018 00:49:01 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 3/9] mt76: usb: move mt76x02u_tx_complete_skb in mt76x02_usb_core.c
Date:   Wed,  3 Oct 2018 09:48:45 +0200
Message-Id: <ec5d8e618499b7c6f95cd5f22b8e6f8adbacc676.1538552703.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538552703.git.lorenzo.bianconi@redhat.com>
References: <cover.1538552703.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02u_tx_complete_skb and mt76x02u_remove_dma_hdr since they
are used just by usb code

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/usb.c    |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h   |  2 --
 .../net/wireless/mediatek/mt76/mt76x02_txrx.c  | 18 ------------------
 .../net/wireless/mediatek/mt76/mt76x02_usb.h   |  2 ++
 .../wireless/mediatek/mt76/mt76x02_usb_core.c  | 18 ++++++++++++++++++
 .../wireless/mediatek/mt76/mt76x2/usb_init.c   |  2 +-
 6 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 2080933efa2e..d2e10fa53a0e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -215,7 +215,7 @@ static int mt76x0u_probe(struct usb_interface *usb_intf,
 {
 	static const struct mt76_driver_ops drv_ops = {
 		.tx_prepare_skb = mt76x02u_tx_prepare_skb,
-		.tx_complete_skb = mt76x02_tx_complete_skb,
+		.tx_complete_skb = mt76x02u_tx_complete_skb,
 		.tx_status_data = mt76x02_tx_status_data,
 		.rx_skb = mt76x02_queue_rx_skb,
 	};
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index 2905bd964dc2..3f76754b139f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -143,8 +143,6 @@ void mt76x02_tx_set_txpwr_auto(struct mt76x02_dev *dev, s8 txpwr);
 int mt76x02_insert_hdr_pad(struct sk_buff *skb);
 void mt76x02_remove_hdr_pad(struct sk_buff *skb, int len);
 void mt76x02_tx_complete(struct mt76_dev *dev, struct sk_buff *skb);
-void mt76x02_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
-			    struct mt76_queue_entry *e, bool flush);
 bool mt76x02_tx_status_data(struct mt76_dev *dev, u8 *update);
 void mt76x02_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 			  struct sk_buff *skb);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
index ab7877a07b6c..830377221739 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
@@ -142,16 +142,6 @@ void mt76x02_tx_set_txpwr_auto(struct mt76x02_dev *dev, s8 txpwr)
 }
 EXPORT_SYMBOL_GPL(mt76x02_tx_set_txpwr_auto);
 
-static void mt76x02_remove_dma_hdr(struct sk_buff *skb)
-{
-	int hdr_len;
-
-	skb_pull(skb, sizeof(struct mt76x02_txwi) + MT_DMA_HDR_LEN);
-	hdr_len = ieee80211_get_hdrlen_from_skb(skb);
-	if (hdr_len % 4)
-		mt76x02_remove_hdr_pad(skb, 2);
-}
-
 void mt76x02_tx_complete(struct mt76_dev *dev, struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -167,14 +157,6 @@ void mt76x02_tx_complete(struct mt76_dev *dev, struct sk_buff *skb)
 }
 EXPORT_SYMBOL_GPL(mt76x02_tx_complete);
 
-void mt76x02_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
-			     struct mt76_queue_entry *e, bool flush)
-{
-	mt76x02_remove_dma_hdr(e->skb);
-	mt76x02_tx_complete(mdev, e->skb);
-}
-EXPORT_SYMBOL_GPL(mt76x02_tx_complete_skb);
-
 bool mt76x02_tx_status_data(struct mt76_dev *dev, u8 *update)
 {
 	struct mt76x02_tx_status stat;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h b/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
index e70ba4f97761..6b2138328eb2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
@@ -29,4 +29,6 @@ int mt76x02u_tx_prepare_skb(struct mt76_dev *dev, void *data,
 			    struct sk_buff *skb, struct mt76_queue *q,
 			    struct mt76_wcid *wcid, struct ieee80211_sta *sta,
 			    u32 *tx_info);
+void mt76x02u_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
+			      struct mt76_queue_entry *e, bool flush);
 #endif /* __MT76x02_USB_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
index a0cd77ddaef3..7c6c973af386 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
@@ -16,6 +16,24 @@
 
 #include "mt76x02.h"
 
+static void mt76x02u_remove_dma_hdr(struct sk_buff *skb)
+{
+	int hdr_len;
+
+	skb_pull(skb, sizeof(struct mt76x02_txwi) + MT_DMA_HDR_LEN);
+	hdr_len = ieee80211_get_hdrlen_from_skb(skb);
+	if (hdr_len % 4)
+		mt76x02_remove_hdr_pad(skb, 2);
+}
+
+void mt76x02u_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
+			      struct mt76_queue_entry *e, bool flush)
+{
+	mt76x02u_remove_dma_hdr(e->skb);
+	mt76x02_tx_complete(mdev, e->skb);
+}
+EXPORT_SYMBOL_GPL(mt76x02u_tx_complete_skb);
+
 static int mt76x02u_check_skb_rooms(struct sk_buff *skb)
 {
 	int hdr_len = ieee80211_get_hdrlen_from_skb(skb);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
index 01f096f36fa2..47d33e8585de 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
@@ -138,7 +138,7 @@ struct mt76x02_dev *mt76x2u_alloc_device(struct device *pdev)
 {
 	static const struct mt76_driver_ops drv_ops = {
 		.tx_prepare_skb = mt76x02u_tx_prepare_skb,
-		.tx_complete_skb = mt76x02_tx_complete_skb,
+		.tx_complete_skb = mt76x02u_tx_complete_skb,
 		.tx_status_data = mt76x02_tx_status_data,
 		.rx_skb = mt76x02_queue_rx_skb,
 	};
-- 
2.17.1

