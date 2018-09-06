Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:36112 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728071AbeIFNy2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 09:54:28 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 22/42] mt76x0: remove unused endpoint definitions
Date: Thu,  6 Sep 2018 11:18:38 +0200
Message-Id: <1536225538-16454-23-git-send-email-sgruszka@redhat.com> (sfid-20180906_112000_666467_0F124B56)
In-Reply-To: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
References: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

remove unused usb endpoint definitions since mt76x0
uses mt76-usb ones. Moreover remove unused usb_ctrl mutex

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   | 1 -
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h | 6 ------
 2 files changed, 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index a7d6e747f221..75597b5a2427 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -502,7 +502,6 @@ struct mt76x0_dev *mt76x0_alloc_device(struct device *pdev)
 	mdev->drv = &drv_ops;
 
 	dev = container_of(mdev, struct mt76x0_dev, mt76);
-	mutex_init(&dev->usb_ctrl_mtx);
 	mutex_init(&dev->reg_atomic_mutex);
 	mutex_init(&dev->hw_atomic_mutex);
 	spin_lock_init(&dev->mac_lock);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 24712ac924ef..0bcf54c0a06f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -79,14 +79,8 @@ enum mt_bw {
 struct mt76x0_dev {
 	struct mt76_dev mt76; /* must be first */
 
-	struct mutex usb_ctrl_mtx;
 	u8 data[32];
 
-	u8 out_ep[__MT_EP_OUT_MAX];
-	u16 out_max_packet;
-	u8 in_ep[__MT_EP_IN_MAX];
-	u16 in_max_packet;
-
 	struct delayed_work cal_work;
 	struct delayed_work mac_work;
 
-- 
2.7.5
