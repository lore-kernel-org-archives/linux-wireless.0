Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAE9CC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 08:03:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAC812171F
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 08:03:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731891AbfB1ID7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 03:03:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8100 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730969AbfB1ID6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 03:03:58 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 742AB8EA48;
        Thu, 28 Feb 2019 08:03:58 +0000 (UTC)
Received: from localhost (unknown [10.40.205.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C4F4C600C5;
        Thu, 28 Feb 2019 08:03:55 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [RFC 03/12] mt76x02: introduce beacon_ops
Date:   Thu, 28 Feb 2019 09:03:24 +0100
Message-Id: <1551341013-24519-4-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1551341013-24519-1-git-send-email-sgruszka@redhat.com>
References: <1551341013-24519-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Thu, 28 Feb 2019 08:03:58 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Enabling/disableing TBTT and beacon will be diffrent for USB. Introduce
beacon_ops to encapsulate that and implement it for MMIO. USB
implementation is noop for now.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/main.c  |  8 +++----
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  7 ++++++
 .../wireless/mediatek/mt76/mt76x02_beacon.c   | 18 ++++-----------
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c | 23 +++++++++++++++++++
 .../wireless/mediatek/mt76/mt76x02_usb_core.c | 14 +++++++++++
 5 files changed, 53 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index fee16ab21edb..691984037f98 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -22,10 +22,9 @@ mt76x0_set_channel(struct mt76x02_dev *dev, struct cfg80211_chan_def *chandef)
 	int ret;
 
 	cancel_delayed_work_sync(&dev->cal_work);
-	if (mt76_is_mmio(dev)) {
-		tasklet_disable(&dev->pre_tbtt_tasklet);
+	dev->beacon_ops->pre_tbtt_enable(dev, false);
+	if (mt76_is_mmio(dev))
 		tasklet_disable(&dev->dfs_pd.dfs_tasklet);
-	}
 
 	mt76_set_channel(&dev->mt76);
 	ret = mt76x0_phy_set_channel(dev, chandef);
@@ -38,9 +37,10 @@ mt76x0_set_channel(struct mt76x02_dev *dev, struct cfg80211_chan_def *chandef)
 
 	if (mt76_is_mmio(dev)) {
 		mt76x02_dfs_init_params(dev);
-		tasklet_enable(&dev->pre_tbtt_tasklet);
 		tasklet_enable(&dev->dfs_pd.dfs_tasklet);
 	}
+	dev->beacon_ops->pre_tbtt_enable(dev, true);
+
 	mt76_txq_schedule_all(&dev->mt76);
 
 	return ret;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index edb1c140c487..46c4635cd66a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -67,6 +67,11 @@ struct mt76x02_calibration {
 	s8 tssi_dc;
 };
 
+struct mt76x02_beacon_ops {
+	void (*pre_tbtt_enable) (struct mt76x02_dev *, bool);
+	void (*beacon_enable) (struct mt76x02_dev *, bool);
+};
+
 struct mt76x02_dev {
 	struct mt76_dev mt76; /* must be first */
 
@@ -90,6 +95,8 @@ struct mt76x02_dev {
 	struct hrtimer pre_tbtt_timer;
 	struct work_struct pre_tbtt_work;
 
+	const struct mt76x02_beacon_ops *beacon_ops;
+
 	u32 aggr_stats[32];
 
 	struct sk_buff *beacons[8];
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_beacon.c b/drivers/net/wireless/mediatek/mt76/mt76x02_beacon.c
index e9f71def9f21..42798a918c0c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_beacon.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_beacon.c
@@ -162,14 +162,7 @@ __mt76x02_mac_set_beacon_enable(struct mt76x02_dev *dev, u8 vif_idx,
 	      MT_BEACON_TIME_CFG_TIMER_EN;
 	mt76_rmw(dev, MT_BEACON_TIME_CFG, reg, reg * en);
 
-	if (mt76_is_usb(dev))
-		return;
-
-	mt76_rmw_field(dev, MT_INT_TIMER_EN, MT_INT_TIMER_EN_PRE_TBTT_EN, en);
-	if (en)
-		mt76x02_irq_enable(dev, MT_INT_PRE_TBTT | MT_INT_TBTT);
-	else
-		mt76x02_irq_disable(dev, MT_INT_PRE_TBTT | MT_INT_TBTT);
+	dev->beacon_ops->beacon_enable(dev, en);
 }
 
 void mt76x02_mac_set_beacon_enable(struct mt76x02_dev *dev,
@@ -178,9 +171,9 @@ void mt76x02_mac_set_beacon_enable(struct mt76x02_dev *dev,
 	u8 vif_idx = ((struct mt76x02_vif *)vif->drv_priv)->idx;
 	struct sk_buff *skb = NULL;
 
-	if (mt76_is_mmio(dev))
-		tasklet_disable(&dev->pre_tbtt_tasklet);
-	else if (val)
+	dev->beacon_ops->pre_tbtt_enable(dev, true);
+
+	if (mt76_is_usb(dev))
 		skb = ieee80211_beacon_get(mt76_hw(dev), vif);
 
 	if (!dev->beacon_mask)
@@ -188,8 +181,7 @@ void mt76x02_mac_set_beacon_enable(struct mt76x02_dev *dev,
 
 	__mt76x02_mac_set_beacon_enable(dev, vif_idx, val, skb);
 
-	if (mt76_is_mmio(dev))
-		tasklet_enable(&dev->pre_tbtt_tasklet);
+	dev->beacon_ops->pre_tbtt_enable(dev, true);
 }
 
 void mt76x02_init_beacon_config(struct mt76x02_dev *dev)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index c21bcb56c7de..f83a633144ab 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -151,8 +151,31 @@ static void mt76x02_pre_tbtt_tasklet(unsigned long arg)
 	spin_unlock_bh(&q->lock);
 }
 
+static void mt76x02e_pre_tbtt_enable(struct mt76x02_dev *dev, bool en)
+{
+	if (en)
+		tasklet_enable(&dev->pre_tbtt_tasklet);
+	else
+		tasklet_disable(&dev->pre_tbtt_tasklet);
+}
+
+static void mt76x02e_beacon_enable(struct mt76x02_dev *dev, bool en)
+{
+	mt76_rmw_field(dev, MT_INT_TIMER_EN, MT_INT_TIMER_EN_PRE_TBTT_EN, en);
+	if (en)
+		mt76x02_irq_enable(dev, MT_INT_PRE_TBTT | MT_INT_TBTT);
+	else
+		mt76x02_irq_disable(dev, MT_INT_PRE_TBTT | MT_INT_TBTT);
+}
+
 void mt76x02e_init_beacon_config(struct mt76x02_dev *dev)
 {
+	static const struct mt76x02_beacon_ops beacon_ops = {
+		.pre_tbtt_enable = mt76x02e_pre_tbtt_enable,
+		.beacon_enable = mt76x02e_beacon_enable,
+	};
+	dev->beacon_ops = &beacon_ops;
+
 	tasklet_init(&dev->pre_tbtt_tasklet, mt76x02_pre_tbtt_tasklet,
 		     (unsigned long)dev);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
index 051fa68a85d5..5dd39c59a797 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
@@ -171,8 +171,22 @@ static enum hrtimer_restart mt76x02u_pre_tbtt_interrupt(struct hrtimer *timer)
 	return HRTIMER_NORESTART;
 }
 
+static void mt76x02u_pre_tbtt_enable(struct mt76x02_dev *dev, bool en)
+{
+}
+
+static void mt76x02u_beacon_enable(struct mt76x02_dev *dev, bool en)
+{
+}
+
 void mt76x02u_init_beacon_config(struct mt76x02_dev *dev)
 {
+	static const struct mt76x02_beacon_ops beacon_ops = {
+		.pre_tbtt_enable = mt76x02u_pre_tbtt_enable,
+		.beacon_enable = mt76x02u_beacon_enable,
+	};
+	dev->beacon_ops = &beacon_ops;
+
 	hrtimer_init(&dev->pre_tbtt_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	dev->pre_tbtt_timer.function = mt76x02u_pre_tbtt_interrupt;
 	INIT_WORK(&dev->pre_tbtt_work, mt76x02u_pre_tbtt_work);
-- 
2.20.1

