Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E18DC65BA7
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:28:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD48D20652
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:28:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BD48D20652
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728404AbeJEP03 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 11:26:29 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36909 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727750AbeJEP02 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 11:26:28 -0400
Received: by mail-wm1-f65.google.com with SMTP id 185-v6so1071423wmt.2
        for <linux-wireless@vger.kernel.org>; Fri, 05 Oct 2018 01:28:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=UobFFF+pHrhSWdjumJeH54aGbsqrIwBafy64+O/GuDM=;
        b=igdldRpSmMlcuL4WYDibHSGkc5c2Qji4TjNkq+/nMYIWlBMUvmnVTDxzzvWIDrF1Xi
         6SkBthZq9b2GVGkiQmRfLqAo+FQPg2ZfVea5cbSSnLCJZ+SP3JdRKoiWmWtPCcDr5LaB
         6/4K1VI3AkmwPq6j4qsNWeXXD0389KOGT4d8yN3anIDRxF8Kw1zeUrL2/bICWxxK4FE3
         ITS9iRHxNYEgwbroKhT4JV3MEiGelGwZW63K7dZ3sVEthHsqridyi1DLf6mfivUsAH1P
         NBYWArx8ft25cAAMYJrlksoFxg6kAzWVH7yU30amviiGoQm9ROWI36uUqMK10GjuRfHS
         BOWw==
X-Gm-Message-State: ABuFfohONgfN9TR0ufB3JMdQD+VkZPN2rwV4KcP4Yqz3QD074T5KFrkS
        xzWl1JBUjlMD7fXjfVSqu9oEgd6hLhc=
X-Google-Smtp-Source: ACcGV634id9yEeMSg8UHBjYcNt2lyb/uLvCCjtLxmGSgUeGXjG7Mr09ACWUsVByUqbzZr9SdAVgm7Q==
X-Received: by 2002:a1c:1b91:: with SMTP id b139-v6mr7106343wmb.147.1538728127702;
        Fri, 05 Oct 2018 01:28:47 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id 77-v6sm3630227wmv.6.2018.10.05.01.28.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Oct 2018 01:28:47 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 3/8] mt76: usb: move mt76x02u_tx_complete_skb in mt76x02_usb_core.c
Date:   Fri,  5 Oct 2018 10:28:33 +0200
Message-Id: <7fe3363de742cc13abe684c111f0d07cb895f1b7.1538726819.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538726819.git.lorenzo.bianconi@redhat.com>
References: <cover.1538726819.git.lorenzo.bianconi@redhat.com>
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
index e29fc3af49cf..a7fd36c2f633 100644
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
index 45d628af7d57..c82f16efa327 100644
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

