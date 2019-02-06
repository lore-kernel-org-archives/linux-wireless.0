Return-Path: <SRS0=cSSL=QN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D86F9C169C4
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 14:34:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF61B217F9
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 14:34:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729733AbfBFOeW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Feb 2019 09:34:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39908 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726914AbfBFOeW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Feb 2019 09:34:22 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0CE3BC01DDFA;
        Wed,  6 Feb 2019 14:34:22 +0000 (UTC)
Received: from localhost (ovpn-204-178.brq.redhat.com [10.40.204.178])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DC1C96CF65;
        Wed,  6 Feb 2019 14:34:17 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 5.0 v2] mt76x0u: fix suspend/resume
Date:   Wed,  6 Feb 2019 15:34:16 +0100
Message-Id: <1549463656-22219-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Wed, 06 Feb 2019 14:34:22 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

We need to reset MCU and do other initializations on resume otherwise
MT7610U device will fail to initialize, what cause system hung due to
USB requests timeouts.

Patch fixes 4.19 -> 4.20 regression.

Cc: stable@vger.kernel.org # 4.20+
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
v2: minor coding style changes

 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c | 46 ++++++++++++++++---------
 1 file changed, 29 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 0e6b43bb4678..a5ea3ba495a4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -158,39 +158,49 @@ static const struct ieee80211_ops mt76x0u_ops = {
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
-	if (!mt76x02_wait_for_mac(&dev->mt76)) {
-		err = -ETIMEDOUT;
-		goto out_err;
-	}
+
+	if (!mt76x02_wait_for_mac(&dev->mt76))
+		return -ETIMEDOUT;
 
 	err = mt76x0u_mcu_init(dev);
 	if (err < 0)
-		goto out_err;
+		return err;
 
 	mt76x0_init_usb_dma(dev);
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
@@ -301,6 +311,8 @@ static int __maybe_unused mt76x0_suspend(struct usb_interface *usb_intf,
 
 	mt76u_stop_queues(&dev->mt76);
 	mt76x0u_mac_stop(dev);
+	clear_bit(MT76_STATE_MCU_RUNNING, &dev->mt76.state);
+	mt76x0_chip_onoff(dev, false, false);
 	usb_kill_urb(usb->mcu.res.urb);
 
 	return 0;
@@ -328,7 +340,7 @@ static int __maybe_unused mt76x0_resume(struct usb_interface *usb_intf)
 	tasklet_enable(&usb->rx_tasklet);
 	tasklet_enable(&usb->tx_tasklet);
 
-	ret = mt76x0_init_hardware(dev);
+	ret = mt76x0u_init_hardware(dev);
 	if (ret)
 		goto err;
 
-- 
2.7.5

