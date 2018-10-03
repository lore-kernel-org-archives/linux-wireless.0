Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AB22C64EBC
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 07:49:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AA1820835
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 07:49:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5AA1820835
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbeJCOgU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 10:36:20 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52434 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727256AbeJCOgU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 10:36:20 -0400
Received: by mail-wm1-f66.google.com with SMTP id 189-v6so4688725wmw.2
        for <linux-wireless@vger.kernel.org>; Wed, 03 Oct 2018 00:49:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=P2YNmkfMn/fUF+qz1KnYSVF1ez5flWWrUSKeTqSXHq4=;
        b=Te4m6/LONjDS80PChpFY4P907BasfOIM/AubA/Mb+CU26ZtHBKeJxbs0EHqNZsDvq/
         1D+rk2QrIkXomFFotWlX0IcuLpczJDIz5EZARsuphsbgkFb+WsHvg9jRyzcnEBKztFuZ
         kpp8nmP4Z8aitjxmtHmLz6SV9Zu/asxOheUyOQEsqmLBc+HtX6P+xwNYQPWZXfHXiiaK
         C/6g7TDZHiUcBW/hPRyjAHungzqziXUHAMKBzSSkIBclZ1iOtr+Rmpd1spPReZTCkzi9
         MZ576mfBPNbmL3e07RxbQoeFfOSQb0uJEvlorF4mJB5Nf0J0GM6A6eimOv0VYh17AiQq
         SL6g==
X-Gm-Message-State: ABuFfogU04TX6xSmzx+/i4lkUM0hlGLoRWHW9d6krmfOmM06ZlGzpr/i
        k7pDM+xL06QZNAUOS4Ti2ZyLeg==
X-Google-Smtp-Source: ACcGV61aLPOd/9LQnWoCGL9QZavuiPWpgVCkENdU5mGpbZIsf9gxhkDh8pelUJvouCwbqPahqnmWGQ==
X-Received: by 2002:a1c:8e81:: with SMTP id q123-v6mr578838wmd.56.1538552943696;
        Wed, 03 Oct 2018 00:49:03 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id y3sm421878wrw.11.2018.10.03.00.49.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Oct 2018 00:49:03 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 5/9] mt76: move mt76x02_tx_complete in mt76x02-lib module
Date:   Wed,  3 Oct 2018 09:48:47 +0200
Message-Id: <117e01ee10de755225a94d886a73d6703bce7282.1538552703.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538552703.git.lorenzo.bianconi@redhat.com>
References: <cover.1538552703.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02_tx_complete mt76x02-lib module in order to
be reused by mt76x0 drivers for irq unification.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  | 29 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x02_mac.h  | 19 ++++++++++++
 .../wireless/mediatek/mt76/mt76x02_trace.h    | 22 ++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x2/mac.h   | 17 -----------
 .../wireless/mediatek/mt76/mt76x2/mt76x2.h    |  2 --
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  |  2 +-
 .../wireless/mediatek/mt76/mt76x2/pci_mac.c   | 28 ------------------
 .../net/wireless/mediatek/mt76/mt76x2/trace.h | 22 --------------
 8 files changed, 71 insertions(+), 70 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index a39c10b61df9..244245418ebb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -714,3 +714,32 @@ void mt76x02_mac_poll_tx_status(struct mt76x02_dev *dev, bool irq)
 	}
 }
 EXPORT_SYMBOL_GPL(mt76x02_mac_poll_tx_status);
+
+static void
+mt76x02_mac_queue_txdone(struct mt76x02_dev *dev, struct sk_buff *skb,
+			 void *txwi_ptr)
+{
+	struct mt76x02_tx_info *txi = mt76x02_skb_tx_info(skb);
+	struct mt76x02_txwi *txwi = txwi_ptr;
+
+	mt76x02_mac_poll_tx_status(dev, false);
+
+	txi->tries = 0;
+	txi->jiffies = jiffies;
+	txi->wcid = txwi->wcid;
+	txi->pktid = txwi->pktid;
+	trace_mac_txdone_add(dev, txwi->wcid, txwi->pktid);
+	mt76x02_tx_complete(&dev->mt76, skb);
+}
+
+void mt76x02_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
+			     struct mt76_queue_entry *e, bool flush)
+{
+	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
+
+	if (e->txwi)
+		mt76x02_mac_queue_txdone(dev, e->skb, &e->txwi->txwi);
+	else
+		dev_kfree_skb_any(e->skb);
+}
+EXPORT_SYMBOL_GPL(mt76x02_tx_complete_skb);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index 426e68041642..4f7ee4620ab5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -42,6 +42,15 @@ struct mt76x02_vif {
 	struct mt76_wcid group_wcid;
 };
 
+struct mt76x02_tx_info {
+	unsigned long jiffies;
+	u8 tries;
+
+	u8 wcid;
+	u8 pktid;
+	u8 retry;
+};
+
 DECLARE_EWMA(signal, 10, 8);
 
 struct mt76x02_sta {
@@ -181,6 +190,14 @@ static inline bool mt76x02_wait_for_mac(struct mt76_dev *dev)
 	return false;
 }
 
+static inline struct mt76x02_tx_info *
+mt76x02_skb_tx_info(struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+
+	return (void *)info->status.status_driver_data;
+}
+
 void mt76x02_txq_init(struct mt76_dev *dev, struct ieee80211_txq *txq);
 enum mt76x02_cipher_type
 mt76x02_mac_get_key_info(struct ieee80211_key_conf *key, u8 *key_data);
@@ -206,4 +223,6 @@ void mt76x02_mac_write_txwi(struct mt76_dev *dev, struct mt76x02_txwi *txwi,
 			    struct sk_buff *skb, struct mt76_wcid *wcid,
 			    struct ieee80211_sta *sta, int len);
 void mt76x02_mac_poll_tx_status(struct mt76x02_dev *dev, bool irq);
+void mt76x02_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
+			     struct mt76_queue_entry *e, bool flush);
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_trace.h b/drivers/net/wireless/mediatek/mt76/mt76x02_trace.h
index 98580dd22e78..a18f26d857e4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_trace.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_trace.h
@@ -46,6 +46,28 @@ DECLARE_EVENT_CLASS(dev_evt,
 	TP_printk(DEV_PR_FMT, DEV_PR_ARG)
 );
 
+DECLARE_EVENT_CLASS(dev_txid_evt,
+	TP_PROTO(struct mt76x02_dev *dev, u8 wcid, u8 pktid),
+	TP_ARGS(dev, wcid, pktid),
+	TP_STRUCT__entry(
+		DEV_ENTRY
+		TXID_ENTRY
+	),
+	TP_fast_assign(
+		DEV_ASSIGN;
+		TXID_ASSIGN;
+	),
+	TP_printk(
+		DEV_PR_FMT TXID_PR_FMT,
+		DEV_PR_ARG, TXID_PR_ARG
+	)
+);
+
+DEFINE_EVENT(dev_txid_evt, mac_txdone_add,
+	TP_PROTO(struct mt76x02_dev *dev, u8 wcid, u8 pktid),
+	TP_ARGS(dev, wcid, pktid)
+);
+
 DEFINE_EVENT(dev_evt, mac_txstat_poll,
 	TP_PROTO(struct mt76x02_dev *dev),
 	TP_ARGS(dev)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h
index 6a6761050035..b13d629053d6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h
@@ -23,23 +23,6 @@ struct mt76x02_dev;
 struct mt76x2_sta;
 struct mt76x02_vif;
 
-struct mt76x2_tx_info {
-	unsigned long jiffies;
-	u8 tries;
-
-	u8 wcid;
-	u8 pktid;
-	u8 retry;
-};
-
-static inline struct mt76x2_tx_info *
-mt76x2_skb_tx_info(struct sk_buff *skb)
-{
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-
-	return (void *) info->status.status_driver_data;
-}
-
 int mt76x2_mac_start(struct mt76x02_dev *dev);
 void mt76x2_mac_stop(struct mt76x02_dev *dev, bool force);
 void mt76x2_mac_resume(struct mt76x02_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
index e29ce8d23a4f..db9b3b30a8ac 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
@@ -86,8 +86,6 @@ void mt76x2_dma_cleanup(struct mt76x02_dev *dev);
 
 void mt76x2_cleanup(struct mt76x02_dev *dev);
 
-void mt76x2_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
-			    struct mt76_queue_entry *e, bool flush);
 void mt76x2_mac_set_tx_protection(struct mt76x02_dev *dev, u32 val);
 
 void mt76x2_pre_tbtt_tasklet(unsigned long arg);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index 055c90b1e522..404f5b6adc46 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -356,7 +356,7 @@ struct mt76x02_dev *mt76x2_alloc_device(struct device *pdev)
 		.txwi_size = sizeof(struct mt76x02_txwi),
 		.update_survey = mt76x2_update_channel,
 		.tx_prepare_skb = mt76x02_tx_prepare_skb,
-		.tx_complete_skb = mt76x2_tx_complete_skb,
+		.tx_complete_skb = mt76x02_tx_complete_skb,
 		.rx_skb = mt76x02_queue_rx_skb,
 		.rx_poll_complete = mt76x2_rx_poll_complete,
 		.sta_ps = mt76x2_sta_ps,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
index 8017db8a341b..458e168bdf0e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
@@ -28,23 +28,6 @@ void mt76x2_mac_set_bssid(struct mt76x02_dev *dev, u8 idx, const u8 *addr)
 		       get_unaligned_le16(addr + 4));
 }
 
-static void
-mt76x2_mac_queue_txdone(struct mt76x02_dev *dev, struct sk_buff *skb,
-			void *txwi_ptr)
-{
-	struct mt76x2_tx_info *txi = mt76x2_skb_tx_info(skb);
-	struct mt76x02_txwi *txwi = txwi_ptr;
-
-	mt76x02_mac_poll_tx_status(dev, false);
-
-	txi->tries = 0;
-	txi->jiffies = jiffies;
-	txi->wcid = txwi->wcid;
-	txi->pktid = txwi->pktid;
-	trace_mac_txdone_add(dev, txwi->wcid, txwi->pktid);
-	mt76x02_tx_complete(&dev->mt76, skb);
-}
-
 void mt76x2_mac_process_tx_status_fifo(struct mt76x02_dev *dev)
 {
 	struct mt76x02_tx_status stat;
@@ -54,17 +37,6 @@ void mt76x2_mac_process_tx_status_fifo(struct mt76x02_dev *dev)
 		mt76x02_send_tx_status(&dev->mt76, &stat, &update);
 }
 
-void mt76x2_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
-			    struct mt76_queue_entry *e, bool flush)
-{
-	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
-
-	if (e->txwi)
-		mt76x2_mac_queue_txdone(dev, e->skb, &e->txwi->txwi);
-	else
-		dev_kfree_skb_any(e->skb);
-}
-
 static int
 mt76_write_beacon(struct mt76x02_dev *dev, int offset, struct sk_buff *skb)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/trace.h b/drivers/net/wireless/mediatek/mt76/mt76x2/trace.h
index 8a49657380b4..86a4703ddbc1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/trace.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/trace.h
@@ -34,28 +34,6 @@
 #define TXID_PR_FMT	" [%d:%d]"
 #define TXID_PR_ARG	__entry->wcid, __entry->pktid
 
-DECLARE_EVENT_CLASS(dev_txid_evt,
-	TP_PROTO(struct mt76x02_dev *dev, u8 wcid, u8 pktid),
-	TP_ARGS(dev, wcid, pktid),
-	TP_STRUCT__entry(
-		DEV_ENTRY
-		TXID_ENTRY
-	),
-	TP_fast_assign(
-		DEV_ASSIGN;
-		TXID_ASSIGN;
-	),
-	TP_printk(
-		DEV_PR_FMT TXID_PR_FMT,
-		DEV_PR_ARG, TXID_PR_ARG
-	)
-);
-
-DEFINE_EVENT(dev_txid_evt, mac_txdone_add,
-	TP_PROTO(struct mt76x02_dev *dev, u8 wcid, u8 pktid),
-	TP_ARGS(dev, wcid, pktid)
-);
-
 TRACE_EVENT(dev_irq,
 	TP_PROTO(struct mt76x02_dev *dev, u32 val, u32 mask),
 
-- 
2.17.1

