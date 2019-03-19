Return-Path: <SRS0=Jk3u=RW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FC39C10F03
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 10:38:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B3FE20989
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 10:38:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbfCSKiG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Mar 2019 06:38:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33176 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727639AbfCSKiF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Mar 2019 06:38:05 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3799113A42;
        Tue, 19 Mar 2019 10:38:05 +0000 (UTC)
Received: from localhost (unknown [10.43.2.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2EB795DD97;
        Tue, 19 Mar 2019 10:38:01 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v2 02/12] mt76x02: add hrtimer for pre TBTT for USB
Date:   Tue, 19 Mar 2019 11:37:37 +0100
Message-Id: <1552991867-5087-3-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1552991867-5087-1-git-send-email-sgruszka@redhat.com>
References: <1552991867-5087-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Tue, 19 Mar 2019 10:38:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add timer and work for pre TBTT for USB devices. For now code
doesn't do anyting useful, just add hrtimer which synchronize
with hardware MT_TBTT_TIMER.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02.h       |  3 +
 drivers/net/wireless/mediatek/mt76/mt76x02_regs.h  |  5 +-
 .../net/wireless/mediatek/mt76/mt76x02_usb_core.c  | 70 ++++++++++++++++++++++
 3 files changed, 77 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index e93f4840cace..9fa6e4fc221f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -88,6 +88,9 @@ struct mt76x02_dev {
 	struct delayed_work mac_work;
 	struct delayed_work wdt_work;
 
+	struct hrtimer pre_tbtt_timer;
+	struct work_struct pre_tbtt_work;
+
 	u32 aggr_stats[32];
 
 	struct sk_buff *beacons[8];
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h b/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h
index 7401cb94fb72..2ce05b543dff 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h
@@ -356,7 +356,10 @@
 #define MT_BEACON_TIME_CFG_TSF_COMP	GENMASK(31, 24)
 
 #define MT_TBTT_SYNC_CFG		0x1118
-#define MT_TBTT_TIMER_CFG		0x1124
+#define MT_TSF_TIMER_DW0		0x111c
+#define MT_TSF_TIMER_DW1		0x1120
+#define MT_TBTT_TIMER			0x1124
+#define MT_TBTT_TIMER_VAL		GENMASK(16, 0)
 
 #define MT_INT_TIMER_CFG		0x1128
 #define MT_INT_TIMER_CFG_PRE_TBTT	GENMASK(15, 0)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
index 7e0a5f364469..f1a3d41c8209 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
@@ -105,8 +105,78 @@ int mt76x02u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 }
 EXPORT_SYMBOL_GPL(mt76x02u_tx_prepare_skb);
 
+/* Trigger pre-TBTT event 8 ms before TBTT */
+#define PRE_TBTT_USEC 8000
+static void mt76x02u_start_pre_tbtt_timer(struct mt76x02_dev *dev)
+{
+	u64 time;
+	u32 tbtt;
+
+	/* Get remaining TBTT in usec */
+	tbtt = mt76_get_field(dev, MT_TBTT_TIMER, MT_TBTT_TIMER_VAL);
+	tbtt *= 32;
+
+	if (tbtt <= PRE_TBTT_USEC) {
+		queue_work(system_highpri_wq, &dev->pre_tbtt_work);
+		return;
+	}
+
+	time = (tbtt - PRE_TBTT_USEC) * 1000ull;
+	hrtimer_start(&dev->pre_tbtt_timer, time, HRTIMER_MODE_REL);
+}
+
+static void mt76x02u_restart_pre_tbtt_timer(struct mt76x02_dev *dev)
+{
+	u32 tbtt, dw0, dw1;
+	u64 tsf, time;
+
+	/* Get remaining TBTT in usec */
+	tbtt = mt76_get_field(dev, MT_TBTT_TIMER, MT_TBTT_TIMER_VAL);
+	tbtt *= 32;
+
+	dw0 = mt76_rr(dev, MT_TSF_TIMER_DW0);
+	dw1 = mt76_rr(dev, MT_TSF_TIMER_DW1);
+	tsf = (u64)dw0 << 32 | dw1;
+	dev_dbg(dev->mt76.dev, "TSF: %llu us TBTT %u us\n", tsf, tbtt);
+
+	/* Convert beacon interval in TU (1024 usec) to nsec */
+	time = ((1000000000ull * dev->beacon_int) >> 10);
+
+	/* Adjust time to trigger hrtimer 8ms before TBTT */
+	if (tbtt < PRE_TBTT_USEC)
+		time -= (PRE_TBTT_USEC - tbtt) * 1000ull;
+	else
+		time += (tbtt - PRE_TBTT_USEC) * 1000ull;
+
+	hrtimer_start(&dev->pre_tbtt_timer, time, HRTIMER_MODE_REL);
+}
+
+static void mt76x02u_pre_tbtt_work(struct work_struct *work)
+{
+	struct mt76x02_dev *dev =
+		container_of(work, struct mt76x02_dev, pre_tbtt_work);
+
+	if (!dev->beacon_mask)
+		return;
+	mt76x02u_restart_pre_tbtt_timer(dev);
+}
+
+static enum hrtimer_restart mt76x02u_pre_tbtt_interrupt(struct hrtimer *timer)
+{
+	struct mt76x02_dev *dev =
+	    container_of(timer, struct mt76x02_dev, pre_tbtt_timer);
+
+	queue_work(system_highpri_wq, &dev->pre_tbtt_work);
+
+	return HRTIMER_NORESTART;
+}
+
 void mt76x02u_init_beacon_config(struct mt76x02_dev *dev)
 {
+	hrtimer_init(&dev->pre_tbtt_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	dev->pre_tbtt_timer.function = mt76x02u_pre_tbtt_interrupt;
+	INIT_WORK(&dev->pre_tbtt_work, mt76x02u_pre_tbtt_work);
+
 	mt76x02_init_beacon_config(dev);
 }
 EXPORT_SYMBOL_GPL(mt76x02u_init_beacon_config);
-- 
1.9.3

