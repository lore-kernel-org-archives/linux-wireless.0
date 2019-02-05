Return-Path: <SRS0=RZRw=QM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8A5CC282CB
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 14:47:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 800D22080F
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 14:47:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbfBEOrn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Feb 2019 09:47:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38910 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbfBEOrn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Feb 2019 09:47:43 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 025B1811DD;
        Tue,  5 Feb 2019 14:47:43 +0000 (UTC)
Received: from localhost (unknown [10.43.2.152])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2543B6BF96;
        Tue,  5 Feb 2019 14:47:38 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH 5.0] mt76x0u: fix suspend/resume
Date:   Tue,  5 Feb 2019 15:47:37 +0100
Message-Id: <1549378057-13790-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Tue, 05 Feb 2019 14:47:43 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

We need to reset MCU and do other initalizations on resume otherwise
MT7610U device will fail to initalize, what cause system hung due to
USB requests timeouts.

Patch fixes 4.19 -> 4.20 regression.

Cc: stable@vger.kernel.org # 4.20+
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   | 43 +++++++++++++------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 0e6b43bb4678..bd1dedcb7952 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -158,39 +158,52 @@ static const struct ieee80211_ops mt76x0u_ops = {
 	.get_txpower = mt76x02_get_txpower,
 };
 
-static int mt76x0u_register_device(struct mt76x02_dev *dev)
+static int mt76x0u_init_hardware(struct mt76x02_dev *dev)
 {
-	struct ieee80211_hw *hw = dev->mt76.hw;
 	int err;
 
-	err = mt76u_alloc_queues(&dev->mt76);
-	if (err < 0)
-		goto out_err;
-
-	err = mt76u_mcu_init_rx(&dev->mt76);
-	if (err < 0)
-		goto out_err;
-
 	mt76x0_chip_onoff(dev, true, true);
+
 	if (!mt76x02_wait_for_mac(&dev->mt76)) {
 		err = -ETIMEDOUT;
-		goto out_err;
+		return err;
 	}
 
 	err = mt76x0u_mcu_init(dev);
 	if (err < 0)
-		goto out_err;
+		return err;
 
 	mt76x0_init_usb_dma(dev);
+
 	err = mt76x0_init_hardware(dev);
 	if (err < 0)
-		goto out_err;
+		return err;
 
 	mt76_rmw(dev, MT_US_CYC_CFG, MT_US_CYC_CNT, 0x1e);
 	mt76_wr(dev, MT_TXOP_CTRL_CFG,
 		FIELD_PREP(MT_TXOP_TRUN_EN, 0x3f) |
 		FIELD_PREP(MT_TXOP_EXT_CCA_DLY, 0x58));
 
+	return 0;
+}
+
+static int mt76x0u_register_device(struct mt76x02_dev *dev)
+{
+	struct ieee80211_hw *hw = dev->mt76.hw;
+	int err;
+
+	err = mt76u_alloc_queues(&dev->mt76);
+	if (err < 0)
+		goto out_err;
+
+	err = mt76u_mcu_init_rx(&dev->mt76);
+	if (err < 0)
+		goto out_err;
+
+	err = mt76x0u_init_hardware(dev);
+	if (err < 0)
+		goto out_err;
+
 	err = mt76x0_register_device(dev);
 	if (err < 0)
 		goto out_err;
@@ -301,6 +314,8 @@ static int __maybe_unused mt76x0_suspend(struct usb_interface *usb_intf,
 
 	mt76u_stop_queues(&dev->mt76);
 	mt76x0u_mac_stop(dev);
+	clear_bit(MT76_STATE_MCU_RUNNING, &dev->mt76.state);
+	mt76x0_chip_onoff(dev, false, false);
 	usb_kill_urb(usb->mcu.res.urb);
 
 	return 0;
@@ -328,7 +343,7 @@ static int __maybe_unused mt76x0_resume(struct usb_interface *usb_intf)
 	tasklet_enable(&usb->rx_tasklet);
 	tasklet_enable(&usb->tx_tasklet);
 
-	ret = mt76x0_init_hardware(dev);
+	ret = mt76x0u_init_hardware(dev);
 	if (ret)
 		goto err;
 
-- 
2.19.2

