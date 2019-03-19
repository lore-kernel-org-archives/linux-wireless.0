Return-Path: <SRS0=Jk3u=RW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D562C4360F
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 10:38:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0381A2085A
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 10:38:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbfCSKiL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Mar 2019 06:38:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42492 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727674AbfCSKiK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Mar 2019 06:38:10 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 42F93C058CA4;
        Tue, 19 Mar 2019 10:38:10 +0000 (UTC)
Received: from localhost (unknown [10.43.2.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB592600C2;
        Tue, 19 Mar 2019 10:38:09 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v2 04/12] mt76x02u: implement beacon_ops
Date:   Tue, 19 Mar 2019 11:37:39 +0100
Message-Id: <1552991867-5087-5-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1552991867-5087-1-git-send-email-sgruszka@redhat.com>
References: <1552991867-5087-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Tue, 19 Mar 2019 10:38:10 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add implementation of beacon_ops for USB and exit function to
stop the timer if running when device is removed. Still no
actual work on pre tbtt event.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |  5 +---
 drivers/net/wireless/mediatek/mt76/mt76x02_usb.h   |  1 +
 .../net/wireless/mediatek/mt76/mt76x02_usb_core.c  | 33 ++++++++++++++++++++++
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
index 6ff740f09bc9..a012410c5ae7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
@@ -32,4 +32,5 @@ int mt76x02u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 void mt76x02u_tx_complete_skb(struct mt76_dev *mdev, enum mt76_txq_id qid,
 			      struct mt76_queue_entry *e);
 void mt76x02u_init_beacon_config(struct mt76x02_dev *dev);
+void mt76x02u_exit_beacon_config(struct mt76x02_dev *dev);
 #endif /* __MT76x02_USB_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
index eec6f856f88a..82b78cc5b362 100644
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
1.9.3

