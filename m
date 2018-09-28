Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE6FDC004D1
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 11:39:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A74121547
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 11:39:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8A74121547
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729616AbeI1SDE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 14:03:04 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52673 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729595AbeI1SDD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 14:03:03 -0400
Received: by mail-wm1-f67.google.com with SMTP id 189-v6so1572543wmw.2
        for <linux-wireless@vger.kernel.org>; Fri, 28 Sep 2018 04:39:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=aL8Mn+OtRZWDVDizwsSFMlPk3LeTRK1V87D0BcRxUM8=;
        b=hSlYoupUGmLvmLCtcYzEkymdr8AZtOfPM0xcaOyVqdpOZcFuTSs3uaHYEzzlrsUsDp
         onTSaSS1FvJig7KbMDSMpDMCbrZ1HSfiwnFi0J6HJxF3WcOK+RX3PanFqg7P6IVoBBoG
         IwET52igbEnkCfzseOzibFjO+gqytFhv7edYgoH8ReL6qzHuNHjZtpr4HfgZ0MKwCk54
         RKULBLKBpOxy5bF3tpE9arK6Y1/GA15bScWefr8uA8SPV/dfh3MU83fzF772MkxqJ3Gd
         G0CQpndZg9peFB+jpfLrj0VN0uM46BAxw8/Sbo5U+hT+CO7GjqAeSvegkL3JKvao+LcU
         S0Mg==
X-Gm-Message-State: ABuFfojkfrmKDuZQ1ZwRVNclRzhS9nlUh+MTrHG3hO7CZMhH6d+OpZX1
        42yJBThb86BfrCfh2YrssdoljyZ/ceU=
X-Google-Smtp-Source: ACcGV60oeT5fMbXC0VBg2/ZG9UuN6wU+r8zoF1TGtpk6mTusmCnKo7cC1E00XB1hvlRLT50DEqk0kw==
X-Received: by 2002:a1c:ee9d:: with SMTP id j29-v6mr1553764wmi.52.1538134780323;
        Fri, 28 Sep 2018 04:39:40 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id s10-v6sm2395655wmd.22.2018.09.28.04.39.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:39:39 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v3 24/24] mt76x0: usb: move mt76x0u_tx_prepare_skb in usb.c
Date:   Fri, 28 Sep 2018 13:39:07 +0200
Message-Id: <81fd1c1e7de01557e77a304bc7b7ad90cad6e3ff.1538134522.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538134522.git.lorenzo.bianconi@redhat.com>
References: <cover.1538134522.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x0u_tx_prepare_skb routine in usb module in
order to remove leftover usb dependency from generic code

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |  8 +++----
 .../net/wireless/mediatek/mt76/mt76x0/tx.c    | 23 ++++---------------
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   | 17 +++++++++++++-
 3 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 2a7dfbd9e84d..a37dbf944b15 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -168,12 +168,12 @@ void mt76x0_mac_set_ampdu_factor(struct mt76x0_dev *dev);
 /* TX */
 void mt76x0_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 		struct sk_buff *skb);
+struct mt76x02_txwi *
+mt76x0_push_txwi(struct mt76x0_dev *dev, struct sk_buff *skb,
+		 struct ieee80211_sta *sta, struct mt76_wcid *wcid,
+		 int pkt_len);
 
 void mt76x0_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 			 struct sk_buff *skb);
 
-int mt76x0_tx_prepare_skb(struct mt76_dev *mdev, void *data,
-			  struct sk_buff *skb, struct mt76_queue *q,
-			  struct mt76_wcid *wcid, struct ieee80211_sta *sta,
-			  u32 *tx_info);
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
index 36148518cdf7..b3c5dc2ffeb1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
@@ -17,10 +17,10 @@
 #include "../mt76x02_util.h"
 #include "../mt76x02_usb.h"
 
-static struct mt76x02_txwi *
+struct mt76x02_txwi *
 mt76x0_push_txwi(struct mt76x0_dev *dev, struct sk_buff *skb,
-		  struct ieee80211_sta *sta, struct mt76_wcid *wcid,
-		  int pkt_len)
+		 struct ieee80211_sta *sta, struct mt76_wcid *wcid,
+		 int pkt_len)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_tx_rate *rate = &info->control.rates[0];
@@ -53,6 +53,7 @@ mt76x0_push_txwi(struct mt76x0_dev *dev, struct sk_buff *skb,
 
 	return txwi;
 }
+EXPORT_SYMBOL_GPL(mt76x0_push_txwi);
 
 void mt76x0_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 	       struct sk_buff *skb)
@@ -83,22 +84,6 @@ void mt76x0_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 }
 EXPORT_SYMBOL_GPL(mt76x0_tx);
 
-int mt76x0_tx_prepare_skb(struct mt76_dev *mdev, void *data,
-			  struct sk_buff *skb, struct mt76_queue *q,
-			  struct mt76_wcid *wcid, struct ieee80211_sta *sta,
-			  u32 *tx_info)
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
-EXPORT_SYMBOL_GPL(mt76x0_tx_prepare_skb);
-
 void mt76x0_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 			 struct sk_buff *skb)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 0cd46a48c5bd..a76043213f55 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -159,6 +159,21 @@ static const struct ieee80211_ops mt76x0u_ops = {
 	.wake_tx_queue = mt76_wake_tx_queue,
 };
 
+static int mt76x0u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
+				  struct sk_buff *skb, struct mt76_queue *q,
+				  struct mt76_wcid *wcid, struct ieee80211_sta *sta,
+				  u32 *tx_info)
+{
+	struct mt76x0_dev *dev = container_of(mdev, struct mt76x0_dev, mt76);
+	struct mt76x02_txwi *txwi;
+	int len = skb->len;
+
+	mt76x02_insert_hdr_pad(skb);
+	txwi = mt76x0_push_txwi(dev, skb, sta, wcid, len);
+
+	return mt76x02u_set_txinfo(skb, wcid, q2ep(q->hw_idx));
+}
+
 static int mt76x0u_register_device(struct mt76x0_dev *dev)
 {
 	struct ieee80211_hw *hw = dev->mt76.hw;
@@ -215,7 +230,7 @@ static int mt76x0u_probe(struct usb_interface *usb_intf,
 			 const struct usb_device_id *id)
 {
 	static const struct mt76_driver_ops drv_ops = {
-		.tx_prepare_skb = mt76x0_tx_prepare_skb,
+		.tx_prepare_skb = mt76x0u_tx_prepare_skb,
 		.tx_complete_skb = mt76x02_tx_complete_skb,
 		.tx_status_data = mt76x02_tx_status_data,
 		.rx_skb = mt76x0_queue_rx_skb,
-- 
2.17.1

