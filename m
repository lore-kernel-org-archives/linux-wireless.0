Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EE8AC00449
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:28:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 221222084D
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:28:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 221222084D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbeJEP03 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 11:26:29 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43246 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727236AbeJEP03 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 11:26:29 -0400
Received: by mail-wr1-f65.google.com with SMTP id n1-v6so12614521wrt.10
        for <linux-wireless@vger.kernel.org>; Fri, 05 Oct 2018 01:28:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7OFPf2RkG3iXmKd4QFxolPPMkeP1epF7OjTw9KYp3nA=;
        b=Zlh+51cKAiGRzB7+7fuBO/vE6mAqV1KIHEdL8ZHwRe915XyDbbEHBN8mBrqOV15uMm
         +2DNTznTE/DP+sMpOfMCELMUinHIAfi0D9w1WkTQJq253BdzSnDB1GX3PSHVaudzGf/D
         S0x1JBXgk46KBCRlk4C4RIlkrK8QjRV+Pqo8zFQCnkwxJpI6XcxIYKvxmFNJnnn6szYa
         4r5pdjRWnaA2ofVXF6NoJung8yy3XhnKAu7gGjNuirFm+BNCdXItiCFjLZfQeJShVp4e
         EZBQxhNpfwTJJx8oOk0EXody1uRzgjemwcU1LR61UGhfMOs2DiOfzc/eJ2+Q5V/TiOdm
         B3NA==
X-Gm-Message-State: ABuFfoh0mHLfnBipSChYBeAiAHb6tGL9PTx4VuOHD/eat8n78O2XNoaj
        FVcqiPVZ0/LeZCKbYZaKdCNwSQ==
X-Google-Smtp-Source: ACcGV63/FsfyDIJDjp8rEtQEVXXrrvxvKgb7cPcocqsqY55M2cH+cKhkv3j3FxScgzG8gIJNrcxKQg==
X-Received: by 2002:a5d:518f:: with SMTP id k15-v6mr7146255wrv.107.1538728128687;
        Fri, 05 Oct 2018 01:28:48 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id 77-v6sm3630227wmv.6.2018.10.05.01.28.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Oct 2018 01:28:48 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 4/8] mt76: move mt76x02_mac_poll_tx_status in mt76x02-lib moudle
Date:   Fri,  5 Oct 2018 10:28:34 +0200
Message-Id: <c5750e8dcc06204e12dd4c0e9cf6fbc9942962a7.1538726819.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538726819.git.lorenzo.bianconi@redhat.com>
References: <cover.1538726819.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02_mac_poll_tx_status in mt76x02_mac.c in order to
be reused by mt76x0 drivers for irq unification.
Moreover introduce mt76x02_trace source file to define mt76x02
trace points

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/Makefile   |  3 +-
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  | 33 +++++++
 .../net/wireless/mediatek/mt76/mt76x02_mac.h  |  1 +
 .../wireless/mediatek/mt76/mt76x02_trace.c    | 23 +++++
 .../wireless/mediatek/mt76/mt76x02_trace.h    | 98 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x2/mac.h   |  1 -
 .../wireless/mediatek/mt76/mt76x2/pci_core.c  |  2 +-
 .../wireless/mediatek/mt76/mt76x2/pci_dma.c   |  2 +-
 .../wireless/mediatek/mt76/mt76x2/pci_mac.c   | 33 +------
 .../net/wireless/mediatek/mt76/mt76x2/trace.h | 55 -----------
 10 files changed, 160 insertions(+), 91 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_trace.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_trace.h

diff --git a/drivers/net/wireless/mediatek/mt76/Makefile b/drivers/net/wireless/mediatek/mt76/Makefile
index 09c90eef61a4..9b8d7488c545 100644
--- a/drivers/net/wireless/mediatek/mt76/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/Makefile
@@ -10,10 +10,11 @@ mt76-usb-y := usb.o usb_trace.o usb_mcu.o
 
 CFLAGS_trace.o := -I$(src)
 CFLAGS_usb_trace.o := -I$(src)
+CFLAGS_mt76x02_trace.o := -I$(src)
 
 mt76x02-lib-y := mt76x02_util.o mt76x02_mac.o mt76x02_mcu.o \
 		 mt76x02_eeprom.o mt76x02_phy.o mt76x02_mmio.o \
-		 mt76x02_txrx.o
+		 mt76x02_txrx.o mt76x02_trace.o
 
 mt76x02-usb-y := mt76x02_usb_mcu.o mt76x02_usb_core.o
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index a5058e4a9b14..a39c10b61df9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -16,6 +16,7 @@
  */
 
 #include "mt76x02.h"
+#include "mt76x02_trace.h"
 
 enum mt76x02_cipher_type
 mt76x02_mac_get_key_info(struct ieee80211_key_conf *key, u8 *key_data)
@@ -681,3 +682,35 @@ int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
 
 	return mt76x02_mac_process_rate(status, rate);
 }
+
+void mt76x02_mac_poll_tx_status(struct mt76x02_dev *dev, bool irq)
+{
+	struct mt76x02_tx_status stat = {};
+	unsigned long flags;
+	u8 update = 1;
+	bool ret;
+
+	if (!test_bit(MT76_STATE_RUNNING, &dev->mt76.state))
+		return;
+
+	trace_mac_txstat_poll(dev);
+
+	while (!irq || !kfifo_is_full(&dev->txstatus_fifo)) {
+		spin_lock_irqsave(&dev->mt76.mmio.irq_lock, flags);
+		ret = mt76x02_mac_load_tx_status(&dev->mt76, &stat);
+		spin_unlock_irqrestore(&dev->mt76.mmio.irq_lock, flags);
+
+		if (!ret)
+			break;
+
+		trace_mac_txstat_fetch(dev, &stat);
+
+		if (!irq) {
+			mt76x02_send_tx_status(&dev->mt76, &stat, &update);
+			continue;
+		}
+
+		kfifo_put(&dev->txstatus_fifo, stat);
+	}
+}
+EXPORT_SYMBOL_GPL(mt76x02_mac_poll_tx_status);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index 857ab2308e8b..426e68041642 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -205,4 +205,5 @@ void mt76x02_mac_setaddr(struct mt76_dev *dev, u8 *addr);
 void mt76x02_mac_write_txwi(struct mt76_dev *dev, struct mt76x02_txwi *txwi,
 			    struct sk_buff *skb, struct mt76_wcid *wcid,
 			    struct ieee80211_sta *sta, int len);
+void mt76x02_mac_poll_tx_status(struct mt76x02_dev *dev, bool irq);
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_trace.c b/drivers/net/wireless/mediatek/mt76/mt76x02_trace.c
new file mode 100644
index 000000000000..5b42d2c87937
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_trace.c
@@ -0,0 +1,23 @@
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/module.h>
+
+#ifndef __CHECKER__
+#define CREATE_TRACE_POINTS
+#include "mt76x02_trace.h"
+
+#endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_trace.h b/drivers/net/wireless/mediatek/mt76/mt76x02_trace.h
new file mode 100644
index 000000000000..98580dd22e78
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_trace.h
@@ -0,0 +1,98 @@
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#if !defined(__MT76x02_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define __MT76x02_TRACE_H
+
+#include <linux/tracepoint.h>
+#include "mt76x02.h"
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM mt76x02
+
+#define MAXNAME		32
+#define DEV_ENTRY	__array(char, wiphy_name, 32)
+#define DEV_ASSIGN	strlcpy(__entry->wiphy_name, wiphy_name(mt76_hw(dev)->wiphy), MAXNAME)
+#define DEV_PR_FMT	"%s"
+#define DEV_PR_ARG	__entry->wiphy_name
+
+#define TXID_ENTRY	__field(u8, wcid) __field(u8, pktid)
+#define TXID_ASSIGN	__entry->wcid = wcid; __entry->pktid = pktid
+#define TXID_PR_FMT	" [%d:%d]"
+#define TXID_PR_ARG	__entry->wcid, __entry->pktid
+
+DECLARE_EVENT_CLASS(dev_evt,
+	TP_PROTO(struct mt76x02_dev *dev),
+	TP_ARGS(dev),
+	TP_STRUCT__entry(
+		DEV_ENTRY
+	),
+	TP_fast_assign(
+		DEV_ASSIGN;
+	),
+	TP_printk(DEV_PR_FMT, DEV_PR_ARG)
+);
+
+DEFINE_EVENT(dev_evt, mac_txstat_poll,
+	TP_PROTO(struct mt76x02_dev *dev),
+	TP_ARGS(dev)
+);
+
+TRACE_EVENT(mac_txstat_fetch,
+	TP_PROTO(struct mt76x02_dev *dev,
+		 struct mt76x02_tx_status *stat),
+
+	TP_ARGS(dev, stat),
+
+	TP_STRUCT__entry(
+		DEV_ENTRY
+		TXID_ENTRY
+		__field(bool, success)
+		__field(bool, aggr)
+		__field(bool, ack_req)
+		__field(u16, rate)
+		__field(u8, retry)
+	),
+
+	TP_fast_assign(
+		DEV_ASSIGN;
+		__entry->success = stat->success;
+		__entry->aggr = stat->aggr;
+		__entry->ack_req = stat->ack_req;
+		__entry->wcid = stat->wcid;
+		__entry->pktid = stat->pktid;
+		__entry->rate = stat->rate;
+		__entry->retry = stat->retry;
+	),
+
+	TP_printk(
+		DEV_PR_FMT TXID_PR_FMT
+		" success:%d aggr:%d ack_req:%d"
+		" rate:%04x retry:%d",
+		DEV_PR_ARG, TXID_PR_ARG,
+		__entry->success, __entry->aggr, __entry->ack_req,
+		__entry->rate, __entry->retry
+	)
+);
+
+#endif
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE mt76x02_trace
+
+#include <trace/define_trace.h>
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h
index 6bd04b74e15a..6a6761050035 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h
@@ -49,7 +49,6 @@ int mt76x2_mac_set_beacon(struct mt76x02_dev *dev, u8 vif_idx,
 			  struct sk_buff *skb);
 void mt76x2_mac_set_beacon_enable(struct mt76x02_dev *dev, u8 vif_idx, bool val);
 
-void mt76x2_mac_poll_tx_status(struct mt76x02_dev *dev, bool irq);
 void mt76x2_mac_process_tx_status_fifo(struct mt76x02_dev *dev);
 
 void mt76x2_mac_work(struct work_struct *work);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_core.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_core.c
index 1738e025a57e..2abd891f229a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_core.c
@@ -61,7 +61,7 @@ irqreturn_t mt76x2_irq_handler(int irq, void *dev_instance)
 		mt76_queue_kick(dev, &dev->mt76.q_tx[MT_TXQ_PSD]);
 
 	if (intr & MT_INT_TX_STAT) {
-		mt76x2_mac_poll_tx_status(dev, true);
+		mt76x02_mac_poll_tx_status(dev, true);
 		tasklet_schedule(&dev->tx_tasklet);
 	}
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dma.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dma.c
index 2859812ac47a..bfb590d6f288 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dma.c
@@ -26,7 +26,7 @@ void mt76x2_tx_tasklet(unsigned long data)
 	for (i = MT_TXQ_MCU; i >= 0; i--)
 		mt76_queue_tx_cleanup(dev, i, false);
 
-	mt76x2_mac_poll_tx_status(dev, false);
+	mt76x02_mac_poll_tx_status(dev, false);
 	mt76x02_irq_enable(&dev->mt76, MT_INT_TX_DONE_ALL);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
index 981633cbd527..8017db8a341b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
@@ -28,37 +28,6 @@ void mt76x2_mac_set_bssid(struct mt76x02_dev *dev, u8 idx, const u8 *addr)
 		       get_unaligned_le16(addr + 4));
 }
 
-void mt76x2_mac_poll_tx_status(struct mt76x02_dev *dev, bool irq)
-{
-	struct mt76x02_tx_status stat = {};
-	unsigned long flags;
-	u8 update = 1;
-	bool ret;
-
-	if (!test_bit(MT76_STATE_RUNNING, &dev->mt76.state))
-		return;
-
-	trace_mac_txstat_poll(dev);
-
-	while (!irq || !kfifo_is_full(&dev->txstatus_fifo)) {
-		spin_lock_irqsave(&dev->mt76.mmio.irq_lock, flags);
-		ret = mt76x02_mac_load_tx_status(&dev->mt76, &stat);
-		spin_unlock_irqrestore(&dev->mt76.mmio.irq_lock, flags);
-
-		if (!ret)
-			break;
-
-		trace_mac_txstat_fetch(dev, &stat);
-
-		if (!irq) {
-			mt76x02_send_tx_status(&dev->mt76, &stat, &update);
-			continue;
-		}
-
-		kfifo_put(&dev->txstatus_fifo, stat);
-	}
-}
-
 static void
 mt76x2_mac_queue_txdone(struct mt76x02_dev *dev, struct sk_buff *skb,
 			void *txwi_ptr)
@@ -66,7 +35,7 @@ mt76x2_mac_queue_txdone(struct mt76x02_dev *dev, struct sk_buff *skb,
 	struct mt76x2_tx_info *txi = mt76x2_skb_tx_info(skb);
 	struct mt76x02_txwi *txwi = txwi_ptr;
 
-	mt76x2_mac_poll_tx_status(dev, false);
+	mt76x02_mac_poll_tx_status(dev, false);
 
 	txi->tries = 0;
 	txi->jiffies = jiffies;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/trace.h b/drivers/net/wireless/mediatek/mt76/mt76x2/trace.h
index ef88623fa6c9..8a49657380b4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/trace.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/trace.h
@@ -34,18 +34,6 @@
 #define TXID_PR_FMT	" [%d:%d]"
 #define TXID_PR_ARG	__entry->wcid, __entry->pktid
 
-DECLARE_EVENT_CLASS(dev_evt,
-	TP_PROTO(struct mt76x02_dev *dev),
-	TP_ARGS(dev),
-	TP_STRUCT__entry(
-		DEV_ENTRY
-	),
-	TP_fast_assign(
-		DEV_ASSIGN;
-	),
-	TP_printk(DEV_PR_FMT, DEV_PR_ARG)
-);
-
 DECLARE_EVENT_CLASS(dev_txid_evt,
 	TP_PROTO(struct mt76x02_dev *dev, u8 wcid, u8 pktid),
 	TP_ARGS(dev, wcid, pktid),
@@ -63,54 +51,11 @@ DECLARE_EVENT_CLASS(dev_txid_evt,
 	)
 );
 
-DEFINE_EVENT(dev_evt, mac_txstat_poll,
-	TP_PROTO(struct mt76x02_dev *dev),
-	TP_ARGS(dev)
-);
-
 DEFINE_EVENT(dev_txid_evt, mac_txdone_add,
 	TP_PROTO(struct mt76x02_dev *dev, u8 wcid, u8 pktid),
 	TP_ARGS(dev, wcid, pktid)
 );
 
-TRACE_EVENT(mac_txstat_fetch,
-	TP_PROTO(struct mt76x02_dev *dev,
-		 struct mt76x02_tx_status *stat),
-
-	TP_ARGS(dev, stat),
-
-	TP_STRUCT__entry(
-		DEV_ENTRY
-		TXID_ENTRY
-		__field(bool, success)
-		__field(bool, aggr)
-		__field(bool, ack_req)
-		__field(u16, rate)
-		__field(u8, retry)
-	),
-
-	TP_fast_assign(
-		DEV_ASSIGN;
-		__entry->success = stat->success;
-		__entry->aggr = stat->aggr;
-		__entry->ack_req = stat->ack_req;
-		__entry->wcid = stat->wcid;
-		__entry->pktid = stat->pktid;
-		__entry->rate = stat->rate;
-		__entry->retry = stat->retry;
-	),
-
-	TP_printk(
-		DEV_PR_FMT TXID_PR_FMT
-		" success:%d aggr:%d ack_req:%d"
-		" rate:%04x retry:%d",
-		DEV_PR_ARG, TXID_PR_ARG,
-		__entry->success, __entry->aggr, __entry->ack_req,
-		__entry->rate, __entry->retry
-	)
-);
-
-
 TRACE_EVENT(dev_irq,
 	TP_PROTO(struct mt76x02_dev *dev, u32 val, u32 mask),
 
-- 
2.17.1

