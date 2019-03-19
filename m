Return-Path: <SRS0=Jk3u=RW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 695C9C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 10:38:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37D1D2085A
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 10:38:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbfCSKi2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Mar 2019 06:38:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45796 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727236AbfCSKi2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Mar 2019 06:38:28 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9A6E83082E67;
        Tue, 19 Mar 2019 10:38:27 +0000 (UTC)
Received: from localhost (unknown [10.43.2.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1AF8F5C646;
        Tue, 19 Mar 2019 10:38:24 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v2 09/12] mt76x02: make beacon slots bigger for USB
Date:   Tue, 19 Mar 2019 11:37:44 +0100
Message-Id: <1552991867-5087-10-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1552991867-5087-1-git-send-email-sgruszka@redhat.com>
References: <1552991867-5087-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 19 Mar 2019 10:38:27 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Since we sent PS buffered frames via beacon memory we need to make
beacon slots bigger. That imply we will also need to decrease number
of slots as beacon SRAM memory is limited to 8kB.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02.h       |  3 +-
 .../net/wireless/mediatek/mt76/mt76x02_beacon.c    | 34 ++++------------------
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  |  2 ++
 .../net/wireless/mediatek/mt76/mt76x02_usb_core.c  | 20 ++++++++-----
 4 files changed, 22 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index 93f9436ab809..d665137d256c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -69,6 +69,8 @@ struct mt76x02_calibration {
 };
 
 struct mt76x02_beacon_ops {
+	unsigned int nslots;
+	unsigned int slot_size;
 	void (*pre_tbtt_enable) (struct mt76x02_dev *, bool);
 	void (*beacon_enable) (struct mt76x02_dev *, bool);
 };
@@ -194,7 +196,6 @@ void mt76x02_bss_info_changed(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif,
 			      struct ieee80211_bss_conf *info, u32 changed);
 
-extern const u16 mt76x02_beacon_offsets[16];
 struct beacon_bc_data {
 	struct mt76x02_dev *dev;
 	struct sk_buff_head q;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_beacon.c b/drivers/net/wireless/mediatek/mt76/mt76x02_beacon.c
index c0be90988f82..0c232d02f189 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_beacon.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_beacon.c
@@ -18,36 +18,14 @@
 
 #include "mt76x02.h"
 
-const u16 mt76x02_beacon_offsets[16] = {
-	/* 1024 byte per beacon */
-	0xc000,
-	0xc400,
-	0xc800,
-	0xcc00,
-	0xd000,
-	0xd400,
-	0xd800,
-	0xdc00,
-	/* BSS idx 8-15 not used for beacons */
-	0xc000,
-	0xc000,
-	0xc000,
-	0xc000,
-	0xc000,
-	0xc000,
-	0xc000,
-	0xc000,
-};
-EXPORT_SYMBOL_GPL(mt76x02_beacon_offsets);
-
 static void mt76x02_set_beacon_offsets(struct mt76x02_dev *dev)
 {
-	u16 val, base = MT_BEACON_BASE;
 	u32 regs[4] = {};
+	u16 val;
 	int i;
 
-	for (i = 0; i < 16; i++) {
-		val = mt76x02_beacon_offsets[i] - base;
+	for (i = 0; i < dev->beacon_ops->nslots; i++) {
+		val = i * dev->beacon_ops->slot_size;
 		regs[i / 4] |= (val / 64) << (8 * (i % 4));
 	}
 
@@ -58,7 +36,7 @@ static void mt76x02_set_beacon_offsets(struct mt76x02_dev *dev)
 static int
 mt76x02_write_beacon(struct mt76x02_dev *dev, int offset, struct sk_buff *skb)
 {
-	int beacon_len = mt76x02_beacon_offsets[1] - mt76x02_beacon_offsets[0];
+	int beacon_len = dev->beacon_ops->slot_size;
 	struct mt76x02_txwi txwi;
 
 	if (WARN_ON_ONCE(beacon_len < skb->len + sizeof(struct mt76x02_txwi)))
@@ -77,8 +55,8 @@ static void mt76x02_set_beacon_offsets(struct mt76x02_dev *dev)
 __mt76x02_mac_set_beacon(struct mt76x02_dev *dev, u8 bcn_idx,
 			 struct sk_buff *skb)
 {
-	int beacon_len = mt76x02_beacon_offsets[1] - mt76x02_beacon_offsets[0];
-	int beacon_addr = mt76x02_beacon_offsets[bcn_idx];
+	int beacon_len = dev->beacon_ops->slot_size;
+	int beacon_addr = MT_BEACON_BASE + (beacon_len * bcn_idx);
 	int ret = 0;
 	int i;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index eea8e4718600..79c1126f4ba4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -85,6 +85,8 @@ static void mt76x02e_beacon_enable(struct mt76x02_dev *dev, bool en)
 void mt76x02e_init_beacon_config(struct mt76x02_dev *dev)
 {
 	static const struct mt76x02_beacon_ops beacon_ops = {
+		.nslots = 8,
+		.slot_size = 1024,
 		.pre_tbtt_enable = mt76x02e_pre_tbtt_enable,
 		.beacon_enable = mt76x02e_beacon_enable,
 	};
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
index 89249621bcec..c403218533da 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
@@ -107,6 +107,13 @@ int mt76x02u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 
 /* Trigger pre-TBTT event 8 ms before TBTT */
 #define PRE_TBTT_USEC 8000
+
+/* Beacon SRAM memory is limited to 8kB. We need to send PS buffered frames
+ * (which can be 1500 bytes big) via beacon memory. That make limit of number
+ * of slots to 5. TODO: dynamically calculate offsets in beacon SRAM.
+ */
+#define N_BCN_SLOTS 5
+
 static void mt76x02u_start_pre_tbtt_timer(struct mt76x02_dev *dev)
 {
 	u64 time;
@@ -164,7 +171,6 @@ static void mt76x02u_pre_tbtt_work(struct work_struct *work)
 {
 	struct mt76x02_dev *dev =
 		container_of(work, struct mt76x02_dev, pre_tbtt_work);
-	int beacon_len = mt76x02_beacon_offsets[1] - mt76x02_beacon_offsets[0];
 	struct beacon_bc_data data = {};
 	struct sk_buff *skb;
 	int i, nbeacons;
@@ -179,14 +185,10 @@ static void mt76x02u_pre_tbtt_work(struct work_struct *work)
 		mt76x02_update_beacon_iter, dev);
 
 	nbeacons = hweight8(dev->beacon_mask);
-	mt76x02_enqueue_buffered_bc(dev, &data, 8 - nbeacons);
+	mt76x02_enqueue_buffered_bc(dev, &data, N_BCN_SLOTS - nbeacons);
 
-	for (i = nbeacons; i < 8; i++) {
+	for (i = nbeacons; i < N_BCN_SLOTS; i++) {
 		skb = __skb_dequeue(&data.q);
-		if (skb && skb->len >= beacon_len) {
-			dev_kfree_skb(skb);
-			skb = NULL;
-		}
 		mt76x02_mac_set_beacon(dev, i, skb);
 	}
 
@@ -224,7 +226,7 @@ static void mt76x02u_beacon_enable(struct mt76x02_dev *dev, bool en)
 		/* Timer is already stopped, only clean up
 		 * PS buffered frames if any.
 		 */
-		for (i = 0; i < 8; i++)
+		for (i = 0; i < N_BCN_SLOTS; i++)
 			mt76x02_mac_set_beacon(dev, i, NULL);
 	}
 }
@@ -232,6 +234,8 @@ static void mt76x02u_beacon_enable(struct mt76x02_dev *dev, bool en)
 void mt76x02u_init_beacon_config(struct mt76x02_dev *dev)
 {
 	static const struct mt76x02_beacon_ops beacon_ops = {
+		.nslots = N_BCN_SLOTS,
+		.slot_size = (8192 / N_BCN_SLOTS) & ~63,
 		.pre_tbtt_enable = mt76x02u_pre_tbtt_enable,
 		.beacon_enable = mt76x02u_beacon_enable,
 	};
-- 
1.9.3

