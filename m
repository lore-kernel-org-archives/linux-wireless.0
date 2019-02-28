Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CC3BC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 08:04:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC0FB2171F
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 08:04:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731894AbfB1IED (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 03:04:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56442 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730969AbfB1IED (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 03:04:03 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5F4E88F931;
        Thu, 28 Feb 2019 08:04:02 +0000 (UTC)
Received: from localhost (unknown [10.40.205.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB8D4413F;
        Thu, 28 Feb 2019 08:03:59 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [RFC 04/12] mt76x02u: implement beacon_ops
Date:   Thu, 28 Feb 2019 09:03:25 +0100
Message-Id: <1551341013-24519-5-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1551341013-24519-1-git-send-email-sgruszka@redhat.com>
References: <1551341013-24519-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Thu, 28 Feb 2019 08:04:02 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add implementation of beacon_ops for USB and exit function to
stop the timer if running when device is removed. Still no
actual work on pre tbtt event.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   |  5 +--
 .../net/wireless/mediatek/mt76/mt76x02_usb.h  |  1 +
 .../wireless/mediatek/mt76/mt76x02_usb_core.c | 33 +++++++++++++++++++
 3 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 9d3ad8586530..7f3113b91498 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -87,14 +87,11 @@ static void mt76x0u_mac_stop(struct mt76x02_dev *dev)
 	cancel_delayed_work_sync(&dev->cal_work);
 	cancel_delayed_work_sync(&dev->mac_work);
 	mt76u_stop_stat_wk(&dev->mt76);
+	mt76x02u_exit_beacon_config(dev);
 
 	if (test_bit(MT76_REMOVED, &dev->mt76.state))
 		return;
 
-	mt76_clear(dev, MT_BEACON_TIME_CFG, MT_BEACON_TIME_CFG_TIMER_EN |
-		   MT_BEACON_TIME_CFG_SYNC_MODE | MT_BEACON_TIME_CFG_TBTT_EN |
-		   MT_BEACON_TIME_CFG_BEACON_TX);
-
 	if (!mt76_poll(dev, MT_USB_DMA_CFG, MT_USB_DMA_CFG_TX_BUSY, 0, 1000))
 		dev_warn(dev->mt76.dev, "TX DMA did not stop\n");
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h b/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
index 3874f363418f..d9389bf6dabe 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
@@ -32,4 +32,5 @@ int mt76x02u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 void mt76x02u_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
 			      struct mt76_queue_entry *e, bool flush);
 void mt76x02u_init_beacon_config(struct mt76x02_dev *dev);
+void mt76x02u_exit_beacon_config(struct mt76x02_dev *dev);
 #endif /* __MT76x02_USB_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
index 5dd39c59a797..fdd6a021914d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
@@ -151,6 +151,15 @@ static void mt76x02u_restart_pre_tbtt_timer(struct mt76x02_dev *dev)
 	hrtimer_start(&dev->pre_tbtt_timer, time, HRTIMER_MODE_REL);
 }
 
+static void mt76x02u_stop_pre_tbtt_timer(struct mt76x02_dev *dev)
+{
+	do {
+		hrtimer_cancel(&dev->pre_tbtt_timer);
+		cancel_work_sync(&dev->pre_tbtt_work);
+		/* Timer can be rearmed by work. */
+	} while (hrtimer_active(&dev->pre_tbtt_timer));
+}
+
 static void mt76x02u_pre_tbtt_work(struct work_struct *work)
 {
 	struct mt76x02_dev *dev =
@@ -173,10 +182,21 @@ static enum hrtimer_restart mt76x02u_pre_tbtt_interrupt(struct hrtimer *timer)
 
 static void mt76x02u_pre_tbtt_enable(struct mt76x02_dev *dev, bool en)
 {
+	if (en && dev->beacon_mask && !hrtimer_active(&dev->pre_tbtt_timer))
+		mt76x02u_start_pre_tbtt_timer(dev);
+	if (!en)
+		mt76x02u_stop_pre_tbtt_timer(dev);
 }
 
 static void mt76x02u_beacon_enable(struct mt76x02_dev *dev, bool en)
 {
+	if (WARN_ON_ONCE(!dev->beacon_int))
+		return;
+
+	if (en)
+		mt76x02u_start_pre_tbtt_timer(dev);
+
+	/* Nothing to do on disable as timer is already stopped */
 }
 
 void mt76x02u_init_beacon_config(struct mt76x02_dev *dev)
@@ -194,3 +214,16 @@ void mt76x02u_init_beacon_config(struct mt76x02_dev *dev)
 	mt76x02_init_beacon_config(dev);
 }
 EXPORT_SYMBOL_GPL(mt76x02u_init_beacon_config);
+
+void mt76x02u_exit_beacon_config(struct mt76x02_dev *dev)
+{
+	if (!test_bit(MT76_REMOVED, &dev->mt76.state))
+		mt76_clear(dev, MT_BEACON_TIME_CFG,
+			   MT_BEACON_TIME_CFG_TIMER_EN |
+			   MT_BEACON_TIME_CFG_SYNC_MODE |
+			   MT_BEACON_TIME_CFG_TBTT_EN |
+			   MT_BEACON_TIME_CFG_BEACON_TX);
+
+	mt76x02u_stop_pre_tbtt_timer(dev);
+}
+EXPORT_SYMBOL_GPL(mt76x02u_exit_beacon_config);
-- 
2.20.1

