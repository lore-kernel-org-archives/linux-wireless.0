Return-Path: <SRS0=M0/e=RK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37C76C43381
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Mar 2019 10:25:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E4F720675
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Mar 2019 10:25:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbfCGKZc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Mar 2019 05:25:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33714 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726308AbfCGKZc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Mar 2019 05:25:32 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DD78CC057EC3;
        Thu,  7 Mar 2019 10:25:31 +0000 (UTC)
Received: from localhost (unknown [10.43.2.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1C0EC413B;
        Thu,  7 Mar 2019 10:25:23 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] mt76x02u: check chip version on probe
Date:   Thu,  7 Mar 2019 11:25:16 +0100
Message-Id: <1551954316-18985-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Thu, 07 Mar 2019 10:25:31 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Since some USB device IDs are duplicated between mt76x0u, mt7601u
and mt76x2u device, check chip version on probe and return error if
not match the driver.

Don't think this is serious issue, probe most likely will fail at
some other point for wrong device, but we do not have to configure
it if we know is not our device.

Reported-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c | 10 +++++++---
 drivers/net/wireless/mediatek/mt76/mt76x02.h    |  7 +++++++
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c |  4 ++++
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index cf97bbd89485..a565fe766efd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -231,7 +231,7 @@ static int mt76x0u_probe(struct usb_interface *usb_intf,
 	struct usb_device *usb_dev = interface_to_usbdev(usb_intf);
 	struct mt76x02_dev *dev;
 	struct mt76_dev *mdev;
-	u32 asic_rev, mac_rev;
+	u32 mac_rev;
 	int ret;
 
 	mdev = mt76_alloc_device(&usb_intf->dev, sizeof(*dev), &mt76x0u_ops,
@@ -264,10 +264,14 @@ static int mt76x0u_probe(struct usb_interface *usb_intf,
 		goto err;
 	}
 
-	asic_rev = mt76_rr(dev, MT_ASIC_VERSION);
+	mdev->rev = mt76_rr(dev, MT_ASIC_VERSION);
 	mac_rev = mt76_rr(dev, MT_MAC_CSR0);
 	dev_info(mdev->dev, "ASIC revision: %08x MAC revision: %08x\n",
-		 asic_rev, mac_rev);
+		 mdev->rev, mac_rev);
+	if (!is_mt76x0(dev)) {
+		ret = -EINVAL;
+		goto err;
+	}
 
 	/* Note: vendor driver skips this check for MT76X0U */
 	if (!(mt76_rr(dev, MT_EFUSE_CTRL) & MT_EFUSE_CTRL_SEL))
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index 9099ec77fd86..81d8dd325cc3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -209,6 +209,13 @@ void mt76x02_enqueue_buffered_bc(struct mt76x02_dev *dev,
 
 void mt76x02_init_debugfs(struct mt76x02_dev *dev);
 
+static inline bool is_mt76x0(struct mt76x02_dev *dev)
+{
+	return mt76_chip(&dev->mt76) == 0x7610 ||
+	       mt76_chip(&dev->mt76) == 0x7630 ||
+	       mt76_chip(&dev->mt76) == 0x7650;
+}
+
 static inline bool is_mt76x2(struct mt76x02_dev *dev)
 {
 	return mt76_chip(&dev->mt76) == 0x7612 ||
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
index 03cd744bb89d..f22a132f07dd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
@@ -67,6 +67,10 @@ static int mt76x2u_probe(struct usb_interface *intf,
 
 	mdev->rev = mt76_rr(dev, MT_ASIC_VERSION);
 	dev_info(mdev->dev, "ASIC revision: %08x\n", mdev->rev);
+	if (!is_mt76x2(dev)) {
+		err = -EINVAL;
+		goto err;
+	}
 
 	err = mt76x2u_register_device(dev);
 	if (err < 0)
-- 
1.9.3

