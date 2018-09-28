Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B23CEC43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 11:39:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 758CD21547
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 11:39:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 758CD21547
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729559AbeI1SCq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 14:02:46 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34002 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729480AbeI1SCq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 14:02:46 -0400
Received: by mail-wr1-f67.google.com with SMTP id z4-v6so4660187wrb.1
        for <linux-wireless@vger.kernel.org>; Fri, 28 Sep 2018 04:39:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vgxSqcu4NlpvRNFO4p7YcBxnFcUgVJkyGB8V56cU8Tc=;
        b=eDHPXTsSJWvm45q9ZAK+/C7w26uLbKahxvRfH+4O4VeXhGKp/AKpE2EkC2stRHTNKU
         hmqkXhSRTiYkHeEfhf3UuBYuDeRe1fu4U5wodfXnXFfx8VqpVAEpGbCD1Xw4Q4jvnsWh
         pskESFPC/xMe/Rhzq7IlzngbN9mfE6LoFM5VURidLS+fe+49ePrmKHRmxr8Fr4fbB/iM
         mUKeuqGfFIgkAOHfV4GIPsCOZ/A3mQxpXAxPNe4vXoivEaajzMydMH+c5HOqKiLmUe0h
         ql5sDpaWOFDfGVIG8SuqFlHzpHQE/HtYXMd8b5JG+d1en0d58ZYK9Ozto6HRQ9/0RZ4G
         6qBQ==
X-Gm-Message-State: ABuFfogEZrUkH4nuEHs9uEoJxx0ZV7LLxmBLnjpxVq5GXD/a7XpyUiqa
        QbGr2vl5cQPoG5z0Awa4KXzZECGsRQg=
X-Google-Smtp-Source: ACcGV63yDLaSIUdF/bgIwSNoF5kNZkuw/GLjuWTm2hKse23WgrhR3GvPDCskPVunkaKPL6UVeQqzAA==
X-Received: by 2002:a05:6000:1201:: with SMTP id e1mr3957869wrx.157.1538134762410;
        Fri, 28 Sep 2018 04:39:22 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id s10-v6sm2395655wmd.22.2018.09.28.04.39.21
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:39:21 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v3 06/24] mt76: move mt76x02_beacon_offset in mt76x02_util.c
Date:   Fri, 28 Sep 2018 13:38:49 +0200
Message-Id: <9de96bf67dda434c72cc312c594647fb1eeaab13.1538134522.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538134522.git.lorenzo.bianconi@redhat.com>
References: <cover.1538134522.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02_beacon_offset utility routine in mt76x02-lib module
since it is shared between mt76x0 and mt76x2 driver and remove
duplicated code. Moreover move beacon_offset data structure in
mt76x02-lib module since it is shared between mt76x0 and mt76x2
drivers

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/init.c  | 28 +------------
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |  2 -
 .../net/wireless/mediatek/mt76/mt76x02_util.c | 38 +++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x02_util.h |  2 +
 drivers/net/wireless/mediatek/mt76/mt76x2.h   |  2 -
 .../net/wireless/mediatek/mt76/mt76x2_init.c  | 41 +------------------
 .../net/wireless/mediatek/mt76/mt76x2_mac.c   |  6 +--
 .../net/wireless/mediatek/mt76/mt76x2u_init.c |  9 ----
 8 files changed, 45 insertions(+), 83 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 5e3ec1bef144..3b4a67bf7039 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -168,30 +168,13 @@ static int mt76x0_init_bbp(struct mt76x0_dev *dev)
 	return 0;
 }
 
-static void
-mt76_init_beacon_offsets(struct mt76x0_dev *dev)
-{
-	u16 base = MT_BEACON_BASE;
-	u32 regs[4] = {};
-	int i;
-
-	for (i = 0; i < 16; i++) {
-		u16 addr = dev->beacon_offsets[i];
-
-		regs[i / 4] |= ((addr - base) / 64) << (8 * (i % 4));
-	}
-
-	for (i = 0; i < 4; i++)
-		mt76_wr(dev, MT_BCN_OFFSET(i), regs[i]);
-}
-
 static void mt76x0_init_mac_registers(struct mt76x0_dev *dev)
 {
 	u32 reg;
 
 	RANDOM_WRITE(dev, common_mac_reg_table);
 
-	mt76_init_beacon_offsets(dev);
+	mt76x02_set_beacon_offsets(&dev->mt76);
 
 	/* Enable PBF and MAC clock SYS_CTRL[11:10] = 0x3 */
 	RANDOM_WRITE(dev, mt76x0_mac_reg_table);
@@ -372,17 +355,8 @@ EXPORT_SYMBOL_GPL(mt76x0_mac_stop);
 
 int mt76x0_init_hardware(struct mt76x0_dev *dev)
 {
-	static const u16 beacon_offsets[16] = {
-		/* 512 byte per beacon */
-		0xc000,	0xc200,	0xc400,	0xc600,
-		0xc800,	0xca00,	0xcc00,	0xce00,
-		0xd000,	0xd200,	0xd400,	0xd600,
-		0xd800,	0xda00,	0xdc00,	0xde00
-	};
 	int ret;
 
-	dev->beacon_offsets = beacon_offsets;
-
 	if (!mt76_poll_msec(dev, MT_WPDMA_GLO_CFG,
 			    MT_WPDMA_GLO_CFG_TX_DMA_BUSY |
 			    MT_WPDMA_GLO_CFG_RX_DMA_BUSY, 0, 100))
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 242abab69cdb..66fcb90c1083 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -87,8 +87,6 @@ struct mt76x0_dev {
 
 	spinlock_t mac_lock;
 
-	const u16 *beacon_offsets;
-
 	struct mt76x0_caldata caldata;
 
 	struct mutex reg_atomic_mutex;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 310720f8b8d8..ec422c3980e8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -454,4 +454,42 @@ bool mt76x02_tx_status_data(struct mt76_dev *dev, u8 *update)
 }
 EXPORT_SYMBOL_GPL(mt76x02_tx_status_data);
 
+const u16 mt76x02_beacon_offsets[16] = {
+	/* 1024 byte per beacon */
+	0xc000,
+	0xc400,
+	0xc800,
+	0xcc00,
+	0xd000,
+	0xd400,
+	0xd800,
+	0xdc00,
+	/* BSS idx 8-15 not used for beacons */
+	0xc000,
+	0xc000,
+	0xc000,
+	0xc000,
+	0xc000,
+	0xc000,
+	0xc000,
+	0xc000,
+};
+EXPORT_SYMBOL_GPL(mt76x02_beacon_offsets);
+
+void mt76x02_set_beacon_offsets(struct mt76_dev *dev)
+{
+	u16 val, base = MT_BEACON_BASE;
+	u32 regs[4] = {};
+	int i;
+
+	for (i = 0; i < 16; i++) {
+		val = mt76x02_beacon_offsets[i] - base;
+		regs[i / 4] |= (val / 64) << (8 * (i % 4));
+	}
+
+	for (i = 0; i < 4; i++)
+		__mt76_wr(dev, MT_BCN_OFFSET(i), regs[i]);
+}
+EXPORT_SYMBOL_GPL(mt76x02_set_beacon_offsets);
+
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
index 2c1ead85077e..479e7ffcc951 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
@@ -52,6 +52,8 @@ void mt76x02_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
 			    struct mt76_queue_entry *e, bool flush);
 bool mt76x02_tx_status_data(struct mt76_dev *dev, u8 *update);
 
+extern const u16 mt76x02_beacon_offsets[16];
+void mt76x02_set_beacon_offsets(struct mt76_dev *dev);
 void mt76x02_set_irq_mask(struct mt76_dev *dev, u32 clear, u32 set);
 
 static inline void mt76x02_irq_enable(struct mt76_dev *dev, u32 mask)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
index 1798f418c69d..c51d6e2a64ce 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -78,8 +78,6 @@ struct mt76x2_dev {
 
 	struct mutex mutex;
 
-	const u16 *beacon_offsets;
-
 	u8 txdone_seq;
 	DECLARE_KFIFO_PTR(txstatus_fifo, struct mt76x02_tx_status);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index 98e40f6045b9..37cbe550ad1a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -79,23 +79,6 @@ mt76x2_fixup_xtal(struct mt76x2_dev *dev)
 	}
 }
 
-static void
-mt76x2_init_beacon_offsets(struct mt76x2_dev *dev)
-{
-	u16 base = MT_BEACON_BASE;
-	u32 regs[4] = {};
-	int i;
-
-	for (i = 0; i < 16; i++) {
-		u16 addr = dev->beacon_offsets[i];
-
-		regs[i / 4] |= ((addr - base) / 64) << (8 * (i % 4));
-	}
-
-	for (i = 0; i < 4; i++)
-		mt76_wr(dev, MT_BCN_OFFSET(i), regs[i]);
-}
-
 static int mt76x2_mac_reset(struct mt76x2_dev *dev, bool hard)
 {
 	static const u8 null_addr[ETH_ALEN] = {};
@@ -187,7 +170,7 @@ static int mt76x2_mac_reset(struct mt76x2_dev *dev, bool hard)
 		MT_CH_TIME_CFG_EIFS_AS_BUSY |
 		FIELD_PREP(MT_CH_TIME_CFG_CH_TIMER_CLR, 1));
 
-	mt76x2_init_beacon_offsets(dev);
+	mt76x02_set_beacon_offsets(&dev->mt76);
 
 	mt76x2_set_tx_ackto(dev);
 
@@ -325,30 +308,8 @@ void mt76x2_set_tx_ackto(struct mt76x2_dev *dev)
 
 int mt76x2_init_hardware(struct mt76x2_dev *dev)
 {
-	static const u16 beacon_offsets[16] = {
-		/* 1024 byte per beacon */
-		0xc000,
-		0xc400,
-		0xc800,
-		0xcc00,
-		0xd000,
-		0xd400,
-		0xd800,
-		0xdc00,
-
-		/* BSS idx 8-15 not used for beacons */
-		0xc000,
-		0xc000,
-		0xc000,
-		0xc000,
-		0xc000,
-		0xc000,
-		0xc000,
-		0xc000,
-	};
 	int ret;
 
-	dev->beacon_offsets = beacon_offsets;
 	tasklet_init(&dev->pre_tbtt_tasklet, mt76x2_pre_tbtt_tasklet,
 		     (unsigned long) dev);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
index 5fff0860731b..25ce8fcbb873 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
@@ -100,7 +100,7 @@ void mt76x2_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
 static int
 mt76_write_beacon(struct mt76x2_dev *dev, int offset, struct sk_buff *skb)
 {
-	int beacon_len = dev->beacon_offsets[1] - dev->beacon_offsets[0];
+	int beacon_len = mt76x02_beacon_offsets[1] - mt76x02_beacon_offsets[0];
 	struct mt76x02_txwi txwi;
 
 	if (WARN_ON_ONCE(beacon_len < skb->len + sizeof(struct mt76x02_txwi)))
@@ -118,8 +118,8 @@ mt76_write_beacon(struct mt76x2_dev *dev, int offset, struct sk_buff *skb)
 static int
 __mt76x2_mac_set_beacon(struct mt76x2_dev *dev, u8 bcn_idx, struct sk_buff *skb)
 {
-	int beacon_len = dev->beacon_offsets[1] - dev->beacon_offsets[0];
-	int beacon_addr = dev->beacon_offsets[bcn_idx];
+	int beacon_len = mt76x02_beacon_offsets[1] - mt76x02_beacon_offsets[0];
+	int beacon_addr = mt76x02_beacon_offsets[bcn_idx];
 	int ret = 0;
 	int i;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
index 9ba029451f8a..4eb3fe657bd2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
@@ -165,21 +165,12 @@ static void mt76x2u_init_beacon_offsets(struct mt76x2_dev *dev)
 
 int mt76x2u_init_hardware(struct mt76x2_dev *dev)
 {
-	static const u16 beacon_offsets[] = {
-		/* 512 byte per beacon */
-		0xc000, 0xc200, 0xc400, 0xc600,
-		0xc800, 0xca00, 0xcc00, 0xce00,
-		0xd000, 0xd200, 0xd400, 0xd600,
-		0xd800, 0xda00, 0xdc00, 0xde00
-	};
 	const struct mt76_wcid_addr addr = {
 		.macaddr = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff},
 		.ba_mask = 0,
 	};
 	int i, err;
 
-	dev->beacon_offsets = beacon_offsets;
-
 	mt76x2_reset_wlan(dev, true);
 	mt76x2u_power_on(dev);
 
-- 
2.17.1

