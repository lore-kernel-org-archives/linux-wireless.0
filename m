Return-Path: <SRS0=hbYo=M5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FB29ECDE32
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 22:36:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 351A221470
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 22:36:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 351A221470
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbeJRGds (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Oct 2018 02:33:48 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39883 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727188AbeJRGds (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Oct 2018 02:33:48 -0400
Received: by mail-wr1-f68.google.com with SMTP id 61-v6so31432523wrb.6
        for <linux-wireless@vger.kernel.org>; Wed, 17 Oct 2018 15:35:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=IcMzSSjcDPVy6uxe0SKAd7Bh7EjQQ8+IJuyIvi83B2s=;
        b=toc/vCwy7wbIAZOuwpbKgHVKlpqQPIgxARUQwZ9xIneQLzoXEPPd+PMDiIvxkoaJ+7
         REdw1UjA9r51xqN14etrvkFunS9AGB65D4zcnfW5g+Z4YNv3sTZXgqkiTxwwIhglZBXY
         Yax3mGXaUTPaIIzst+VHF4CDlxlVdKU6lSPzHPiFEPlgEo59LN9h3FTJ6GVioIkv1w82
         inxXzHbOQxcCWfZMciloYso80hdxvziPmM22GccoGxDIJ0RZ8KWdJat5BWij57nAyhna
         84F8EgPZwSroloPzTS6x8JrIUNa9+66d7rnGx4RVZ7I5u51iimbyEIyMvBi+oNQyD+ON
         rKfg==
X-Gm-Message-State: ABuFfoiSvDC/0cakID7XvKDHZXhjrGG2tvShiKNBBuAK2mDC2ENoSrtp
        YUjkSqMJh9lbVVq8mSqdXCuiCg==
X-Google-Smtp-Source: ACcGV61Tu+s4Wy1becsoZsqMCfaF5KudYTtENHhZ8hMp63bX1emh+iiqwag6XpGFs3rgPoW9JVxZ6A==
X-Received: by 2002:a5d:6309:: with SMTP id i9-v6mr24916869wru.163.1539815757965;
        Wed, 17 Oct 2018 15:35:57 -0700 (PDT)
Received: from localhost.lan ([151.66.57.235])
        by smtp.gmail.com with ESMTPSA id e14-v6sm16224584wrs.69.2018.10.17.15.35.56
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 17 Oct 2018 15:35:57 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH] mt76: usb: fix static tracepoints
Date:   Thu, 18 Oct 2018 00:35:32 +0200
Message-Id: <d9c86c268b987115f4ce08a8594e9e4da6c5f9fb.1539815635.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <cover.1539815635.git.lorenzo.bianconi@redhat.com>
References: <cover.1539815635.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add submit_urb and rx_urb static tracepoints in mt76-usb module.
Move trace_mac_txstat_fetch in mt76x02_mac_load_tx_status routine
in order to be available to usb drivers. Moreover remove
no longer used mt76x0/trace.{c,h}

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x0/Makefile    |   3 +-
 .../net/wireless/mediatek/mt76/mt76x0/init.c  |   1 -
 .../net/wireless/mediatek/mt76/mt76x0/mac.c   |   1 -
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   |   8 +-
 .../net/wireless/mediatek/mt76/mt76x0/trace.c |  21 --
 .../net/wireless/mediatek/mt76/mt76x0/trace.h | 312 ------------------
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   |   1 -
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  |   4 +-
 drivers/net/wireless/mediatek/mt76/usb.c      |   5 +
 .../net/wireless/mediatek/mt76/usb_trace.h    |  29 +-
 10 files changed, 38 insertions(+), 347 deletions(-)
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/trace.c
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/trace.h

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile b/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
index e49cbf6be945..1b4f2fa99317 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
@@ -3,10 +3,9 @@ obj-$(CONFIG_MT76x0E) += mt76x0e.o
 obj-$(CONFIG_MT76x0_COMMON) += mt76x0-common.o
 
 mt76x0-common-y := \
-	init.o main.o trace.o eeprom.o phy.o mac.o
+	init.o main.o eeprom.o phy.o mac.o
 
 mt76x0u-y := usb.o usb_mcu.o
 mt76x0e-y := pci.o pci_mcu.o
 
 # ccflags-y := -DDEBUG
-CFLAGS_trace.o := -I$(src)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index d49357c7f104..263d5e8df945 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -16,7 +16,6 @@
 
 #include "mt76x0.h"
 #include "eeprom.h"
-#include "trace.h"
 #include "mcu.h"
 #include "initvals.h"
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
index 98d4a97f0a72..8cbdeb6d3dbe 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
@@ -16,7 +16,6 @@
 #include <linux/etherdevice.h>
 
 #include "mt76x0.h"
-#include "trace.h"
 
 void mt76x0_mac_set_protection(struct mt76x02_dev *dev, bool legacy_prot,
 			       int ht_mode)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index dbb92586b6e1..859fb6f23773 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -20,7 +20,6 @@
 #include "mt76x0.h"
 #include "mcu.h"
 #include "eeprom.h"
-#include "trace.h"
 #include "phy.h"
 #include "initvals.h"
 #include "initvals_phy.h"
@@ -54,7 +53,7 @@ mt76x0_rf_csr_wr(struct mt76x02_dev *dev, u32 offset, u8 value)
 		FIELD_PREP(MT_RF_CSR_CFG_REG_ID, reg) |
 		MT_RF_CSR_CFG_WR |
 		MT_RF_CSR_CFG_KICK);
-	trace_mt76x0_rf_write(&dev->mt76, bank, offset, value);
+
 out:
 	mutex_unlock(&dev->phy_mutex);
 
@@ -95,10 +94,9 @@ static int mt76x0_rf_csr_rr(struct mt76x02_dev *dev, u32 offset)
 
 	val = mt76_rr(dev, MT_RF_CSR_CFG);
 	if (FIELD_GET(MT_RF_CSR_CFG_REG_ID, val) == reg &&
-	    FIELD_GET(MT_RF_CSR_CFG_REG_BANK, val) == bank) {
+	    FIELD_GET(MT_RF_CSR_CFG_REG_BANK, val) == bank)
 		ret = FIELD_GET(MT_RF_CSR_CFG_DATA, val);
-		trace_mt76x0_rf_read(&dev->mt76, bank, offset, ret);
-	}
+
 out:
 	mutex_unlock(&dev->phy_mutex);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/trace.c b/drivers/net/wireless/mediatek/mt76/mt76x0/trace.c
deleted file mode 100644
index 8abdd3cd546d..000000000000
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/trace.c
+++ /dev/null
@@ -1,21 +0,0 @@
-/*
- * Copyright (C) 2014 Felix Fietkau <nbd@openwrt.org>
- * Copyright (C) 2015 Jakub Kicinski <kubakici@wp.pl>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2
- * as published by the Free Software Foundation
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#include <linux/module.h>
-
-#ifndef __CHECKER__
-#define CREATE_TRACE_POINTS
-#include "trace.h"
-
-#endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/trace.h b/drivers/net/wireless/mediatek/mt76/mt76x0/trace.h
deleted file mode 100644
index 75d1d6738c34..000000000000
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/trace.h
+++ /dev/null
@@ -1,312 +0,0 @@
-/*
- * Copyright (C) 2014 Felix Fietkau <nbd@openwrt.org>
- * Copyright (C) 2015 Jakub Kicinski <kubakici@wp.pl>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2
- * as published by the Free Software Foundation
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#if !defined(__MT76X0U_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
-#define __MT76X0U_TRACE_H
-
-#include <linux/tracepoint.h>
-#include "mt76x0.h"
-
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM mt76x0
-
-#define MAXNAME		32
-#define DEV_ENTRY	__array(char, wiphy_name, 32)
-#define DEV_ASSIGN	strlcpy(__entry->wiphy_name,			\
-				wiphy_name(dev->hw->wiphy), MAXNAME)
-#define DEV_PR_FMT	"%s "
-#define DEV_PR_ARG	__entry->wiphy_name
-
-#define REG_ENTRY	__field(u32, reg) __field(u32, val)
-#define REG_ASSIGN	__entry->reg = reg; __entry->val = val
-#define REG_PR_FMT	"%04x=%08x"
-#define REG_PR_ARG	__entry->reg, __entry->val
-
-DECLARE_EVENT_CLASS(dev_reg_evt,
-	TP_PROTO(struct mt76_dev *dev, u32 reg, u32 val),
-	TP_ARGS(dev, reg, val),
-	TP_STRUCT__entry(
-		DEV_ENTRY
-		REG_ENTRY
-	),
-	TP_fast_assign(
-		DEV_ASSIGN;
-		REG_ASSIGN;
-	),
-	TP_printk(
-		DEV_PR_FMT REG_PR_FMT,
-		DEV_PR_ARG, REG_PR_ARG
-	)
-);
-
-DEFINE_EVENT(dev_reg_evt, mt76x0_reg_read,
-	TP_PROTO(struct mt76_dev *dev, u32 reg, u32 val),
-	TP_ARGS(dev, reg, val)
-);
-
-DEFINE_EVENT(dev_reg_evt, mt76x0_reg_write,
-	TP_PROTO(struct mt76_dev *dev, u32 reg, u32 val),
-	TP_ARGS(dev, reg, val)
-);
-
-TRACE_EVENT(mt76x0_submit_urb,
-	TP_PROTO(struct mt76_dev *dev, struct urb *u),
-	TP_ARGS(dev, u),
-	TP_STRUCT__entry(
-		DEV_ENTRY __field(unsigned, pipe) __field(u32, len)
-	),
-	TP_fast_assign(
-		DEV_ASSIGN;
-		__entry->pipe = u->pipe;
-		__entry->len = u->transfer_buffer_length;
-	),
-	TP_printk(DEV_PR_FMT "p:%08x len:%u",
-		  DEV_PR_ARG, __entry->pipe, __entry->len)
-);
-
-#define trace_mt76x0_submit_urb_sync(__dev, __pipe, __len) ({	\
-	struct urb u;					\
-	u.pipe = __pipe;				\
-	u.transfer_buffer_length = __len;		\
-	trace_mt76x0_submit_urb(__dev, &u);			\
-})
-
-TRACE_EVENT(mt76x0_mcu_msg_send,
-	TP_PROTO(struct mt76_dev *dev,
-		 struct sk_buff *skb, u32 csum, bool resp),
-	TP_ARGS(dev, skb, csum, resp),
-	TP_STRUCT__entry(
-		DEV_ENTRY
-		__field(u32, info)
-		__field(u32, csum)
-		__field(bool, resp)
-	),
-	TP_fast_assign(
-		DEV_ASSIGN;
-		__entry->info = *(u32 *)skb->data;
-		__entry->csum = csum;
-		__entry->resp = resp;
-	),
-	TP_printk(DEV_PR_FMT "i:%08x c:%08x r:%d",
-		  DEV_PR_ARG, __entry->info, __entry->csum, __entry->resp)
-);
-
-TRACE_EVENT(mt76x0_vend_req,
-	TP_PROTO(struct mt76_dev *dev, unsigned pipe, u8 req, u8 req_type,
-		 u16 val, u16 offset, void *buf, size_t buflen, int ret),
-	TP_ARGS(dev, pipe, req, req_type, val, offset, buf, buflen, ret),
-	TP_STRUCT__entry(
-		DEV_ENTRY
-		__field(unsigned, pipe) __field(u8, req) __field(u8, req_type)
-		__field(u16, val) __field(u16, offset) __field(void*, buf)
-		__field(int, buflen) __field(int, ret)
-	),
-	TP_fast_assign(
-		DEV_ASSIGN;
-		__entry->pipe = pipe;
-		__entry->req = req;
-		__entry->req_type = req_type;
-		__entry->val = val;
-		__entry->offset = offset;
-		__entry->buf = buf;
-		__entry->buflen = buflen;
-		__entry->ret = ret;
-	),
-	TP_printk(DEV_PR_FMT
-		  "%d p:%08x req:%02hhx %02hhx val:%04hx %04hx buf:%d %d",
-		  DEV_PR_ARG, __entry->ret, __entry->pipe, __entry->req,
-		  __entry->req_type, __entry->val, __entry->offset,
-		  !!__entry->buf, __entry->buflen)
-);
-
-DECLARE_EVENT_CLASS(dev_rf_reg_evt,
-	TP_PROTO(struct mt76_dev *dev, u8 bank, u8 reg, u8 val),
-	TP_ARGS(dev, bank, reg, val),
-	TP_STRUCT__entry(
-		DEV_ENTRY
-		__field(u8, bank)
-		__field(u8, reg)
-		__field(u8, val)
-	),
-	TP_fast_assign(
-		DEV_ASSIGN;
-		REG_ASSIGN;
-		__entry->bank = bank;
-	),
-	TP_printk(
-		DEV_PR_FMT "%02hhx:%02hhx=%02hhx",
-		DEV_PR_ARG, __entry->bank, __entry->reg, __entry->val
-	)
-);
-
-DEFINE_EVENT(dev_rf_reg_evt, mt76x0_rf_read,
-	TP_PROTO(struct mt76_dev *dev, u8 bank, u8 reg, u8 val),
-	TP_ARGS(dev, bank, reg, val)
-);
-
-DEFINE_EVENT(dev_rf_reg_evt, mt76x0_rf_write,
-	TP_PROTO(struct mt76_dev *dev, u8 bank, u8 reg, u8 val),
-	TP_ARGS(dev, bank, reg, val)
-);
-
-DECLARE_EVENT_CLASS(dev_simple_evt,
-	TP_PROTO(struct mt76_dev *dev, u8 val),
-	TP_ARGS(dev, val),
-	TP_STRUCT__entry(
-		DEV_ENTRY
-		__field(u8, val)
-	),
-	TP_fast_assign(
-		DEV_ASSIGN;
-		__entry->val = val;
-	),
-	TP_printk(
-		DEV_PR_FMT "%02hhx", DEV_PR_ARG, __entry->val
-	)
-);
-
-TRACE_EVENT(mt76x0_rx,
-	TP_PROTO(struct mt76_dev *dev, struct mt76x02_rxwi *rxwi, u32 f),
-	TP_ARGS(dev, rxwi, f),
-	TP_STRUCT__entry(
-		DEV_ENTRY
-		__field_struct(struct mt76x02_rxwi, rxwi)
-		__field(u32, fce_info)
-	),
-	TP_fast_assign(
-		DEV_ASSIGN;
-		__entry->rxwi = *rxwi;
-		__entry->fce_info = f;
-	),
-	TP_printk(DEV_PR_FMT "rxi:%08x ctl:%08x", DEV_PR_ARG,
-		  le32_to_cpu(__entry->rxwi.rxinfo),
-		  le32_to_cpu(__entry->rxwi.ctl))
-);
-
-TRACE_EVENT(mt76x0_tx,
-	TP_PROTO(struct mt76_dev *dev, struct sk_buff *skb,
-		 struct mt76x02_sta *sta, struct mt76x02_txwi *h),
-	TP_ARGS(dev, skb, sta, h),
-	TP_STRUCT__entry(
-		DEV_ENTRY
-		__field_struct(struct mt76x02_txwi, h)
-		__field(struct sk_buff *, skb)
-		__field(struct mt76x02_sta *, sta)
-	),
-	TP_fast_assign(
-		DEV_ASSIGN;
-		__entry->h = *h;
-		__entry->skb = skb;
-		__entry->sta = sta;
-	),
-	TP_printk(DEV_PR_FMT "skb:%p sta:%p  flg:%04hx rate:%04hx "
-		  "ack:%02hhx wcid:%02hhx len_ctl:%05hx", DEV_PR_ARG,
-		  __entry->skb, __entry->sta,
-		  le16_to_cpu(__entry->h.flags),
-		  le16_to_cpu(__entry->h.rate),
-		  __entry->h.ack_ctl, __entry->h.wcid,
-		  le16_to_cpu(__entry->h.len_ctl))
-);
-
-TRACE_EVENT(mt76x0_tx_dma_done,
-	TP_PROTO(struct mt76_dev *dev, struct sk_buff *skb),
-	TP_ARGS(dev, skb),
-	TP_STRUCT__entry(
-		DEV_ENTRY
-		__field(struct sk_buff *, skb)
-	),
-	TP_fast_assign(
-		DEV_ASSIGN;
-		__entry->skb = skb;
-	),
-	TP_printk(DEV_PR_FMT "%p", DEV_PR_ARG, __entry->skb)
-);
-
-TRACE_EVENT(mt76x0_tx_status_cleaned,
-	TP_PROTO(struct mt76_dev *dev, int cleaned),
-	TP_ARGS(dev, cleaned),
-	TP_STRUCT__entry(
-		DEV_ENTRY
-		__field(int, cleaned)
-	),
-	TP_fast_assign(
-		DEV_ASSIGN;
-		__entry->cleaned = cleaned;
-	),
-	TP_printk(DEV_PR_FMT "%d", DEV_PR_ARG, __entry->cleaned)
-);
-
-TRACE_EVENT(mt76x0_tx_status,
-	TP_PROTO(struct mt76_dev *dev, u32 stat1, u32 stat2),
-	TP_ARGS(dev, stat1, stat2),
-	TP_STRUCT__entry(
-		DEV_ENTRY
-		__field(u32, stat1)	__field(u32, stat2)
-	),
-	TP_fast_assign(
-		DEV_ASSIGN;
-		__entry->stat1 = stat1;
-		__entry->stat2 = stat2;
-	),
-	TP_printk(DEV_PR_FMT "%08x %08x",
-		  DEV_PR_ARG, __entry->stat1, __entry->stat2)
-);
-
-TRACE_EVENT(mt76x0_rx_dma_aggr,
-	TP_PROTO(struct mt76_dev *dev, int cnt, bool paged),
-	TP_ARGS(dev, cnt, paged),
-	TP_STRUCT__entry(
-		DEV_ENTRY
-		__field(u8, cnt)
-		__field(bool, paged)
-	),
-	TP_fast_assign(
-		DEV_ASSIGN;
-		__entry->cnt = cnt;
-		__entry->paged = paged;
-	),
-	TP_printk(DEV_PR_FMT "cnt:%d paged:%d",
-		  DEV_PR_ARG, __entry->cnt, __entry->paged)
-);
-
-DEFINE_EVENT(dev_simple_evt, mt76x0_set_key,
-	TP_PROTO(struct mt76_dev *dev, u8 val),
-	TP_ARGS(dev, val)
-);
-
-TRACE_EVENT(mt76x0_set_shared_key,
-	TP_PROTO(struct mt76_dev *dev, u8 vid, u8 key),
-	TP_ARGS(dev, vid, key),
-	TP_STRUCT__entry(
-		DEV_ENTRY
-		__field(u8, vid)
-		__field(u8, key)
-	),
-	TP_fast_assign(
-		DEV_ASSIGN;
-		__entry->vid = vid;
-		__entry->key = key;
-	),
-	TP_printk(DEV_PR_FMT "phy:%02hhx off:%02hhx",
-		  DEV_PR_ARG, __entry->vid, __entry->key)
-);
-
-#endif
-
-#undef TRACE_INCLUDE_PATH
-#define TRACE_INCLUDE_PATH .
-#undef TRACE_INCLUDE_FILE
-#define TRACE_INCLUDE_FILE trace
-
-#include <trace/define_trace.h>
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index ea517864186b..cdbb8a6db608 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -17,7 +17,6 @@
 
 #include "mt76x0.h"
 #include "mcu.h"
-#include "trace.h"
 #include "../mt76x02_usb.h"
 
 static struct usb_device_id mt76x0_device_table[] = {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 3896da690b83..73132ea95c17 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -237,6 +237,8 @@ bool mt76x02_mac_load_tx_status(struct mt76x02_dev *dev,
 	stat->retry = FIELD_GET(MT_TX_STAT_FIFO_EXT_RETRY, stat2);
 	stat->pktid = FIELD_GET(MT_TX_STAT_FIFO_EXT_PKTID, stat2);
 
+	trace_mac_txstat_fetch(dev, stat);
+
 	return true;
 }
 EXPORT_SYMBOL_GPL(mt76x02_mac_load_tx_status);
@@ -695,8 +697,6 @@ void mt76x02_mac_poll_tx_status(struct mt76x02_dev *dev, bool irq)
 		if (!ret)
 			break;
 
-		trace_mac_txstat_fetch(dev, &stat);
-
 		if (!irq) {
 			mt76x02_send_tx_status(dev, &stat, &update);
 			continue;
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 5f0faf07c346..4fda02e04ee8 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -356,6 +356,7 @@ int mt76u_submit_buf(struct mt76_dev *dev, int dir, int index,
 
 	usb_fill_bulk_urb(buf->urb, udev, pipe, NULL, buf->len,
 			  complete_fn, context);
+	trace_submit_urb(dev, buf->urb);
 
 	return usb_submit_urb(buf->urb, gfp);
 }
@@ -442,6 +443,8 @@ static void mt76u_complete_rx(struct urb *urb)
 	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
 	unsigned long flags;
 
+	trace_rx_urb(dev, urb);
+
 	switch (urb->status) {
 	case -ECONNRESET:
 	case -ESHUTDOWN:
@@ -728,6 +731,8 @@ static void mt76u_tx_kick(struct mt76_dev *dev, struct mt76_queue *q)
 
 	while (q->first != q->tail) {
 		buf = &q->entry[q->first].ubuf;
+
+		trace_submit_urb(dev, buf->urb);
 		err = usb_submit_urb(buf->urb, GFP_ATOMIC);
 		if (err < 0) {
 			if (err == -ENODEV)
diff --git a/drivers/net/wireless/mediatek/mt76/usb_trace.h b/drivers/net/wireless/mediatek/mt76/usb_trace.h
index 52db7012304a..b56c32343eb1 100644
--- a/drivers/net/wireless/mediatek/mt76/usb_trace.h
+++ b/drivers/net/wireless/mediatek/mt76/usb_trace.h
@@ -26,12 +26,12 @@
 #define MAXNAME		32
 #define DEV_ENTRY   __array(char, wiphy_name, 32)
 #define DEV_ASSIGN  strlcpy(__entry->wiphy_name, wiphy_name(dev->hw->wiphy), MAXNAME)
-#define DEV_PR_FMT  "%s"
+#define DEV_PR_FMT  "%s "
 #define DEV_PR_ARG  __entry->wiphy_name
 
 #define REG_ENTRY	__field(u32, reg) __field(u32, val)
 #define REG_ASSIGN	__entry->reg = reg; __entry->val = val
-#define REG_PR_FMT	" %04x=%08x"
+#define REG_PR_FMT	"reg:0x%04x=0x%08x"
 #define REG_PR_ARG	__entry->reg, __entry->val
 
 DECLARE_EVENT_CLASS(dev_reg_evt,
@@ -61,6 +61,31 @@ DEFINE_EVENT(dev_reg_evt, usb_reg_wr,
 	TP_ARGS(dev, reg, val)
 );
 
+DECLARE_EVENT_CLASS(urb_transfer,
+	TP_PROTO(struct mt76_dev *dev, struct urb *u),
+	TP_ARGS(dev, u),
+	TP_STRUCT__entry(
+		DEV_ENTRY __field(unsigned, pipe) __field(u32, len)
+	),
+	TP_fast_assign(
+		DEV_ASSIGN;
+		__entry->pipe = u->pipe;
+		__entry->len = u->transfer_buffer_length;
+	),
+	TP_printk(DEV_PR_FMT "p:%08x len:%u",
+		  DEV_PR_ARG, __entry->pipe, __entry->len)
+);
+
+DEFINE_EVENT(urb_transfer, submit_urb,
+	TP_PROTO(struct mt76_dev *dev, struct urb *u),
+	TP_ARGS(dev, u)
+);
+
+DEFINE_EVENT(urb_transfer, rx_urb,
+	TP_PROTO(struct mt76_dev *dev, struct urb *u),
+	TP_ARGS(dev, u)
+);
+
 #endif
 
 #undef TRACE_INCLUDE_PATH
-- 
2.17.2

