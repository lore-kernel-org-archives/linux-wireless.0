Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:36160 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728139AbeIFNx5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 09:53:57 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 09/42] mt76x0: init mt76_driver_ops callbacks
Date: Thu,  6 Sep 2018 11:18:25 +0200
Message-Id: <1536225538-16454-10-git-send-email-sgruszka@redhat.com> (sfid-20180906_111929_897765_F0B43D27)
In-Reply-To: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
References: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Init mt76_driver_ops callbacks in mt76x0_alloc_device.
mt76_driver_ops callbacks will be used by mt76-usb module

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 45c9f1f7a89a..23b47c49bc17 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -19,6 +19,7 @@
 #include "trace.h"
 #include "mcu.h"
 #include "usb.h"
+#include "../mt76x02_util.h"
 
 #include "initvals.h"
 
@@ -483,6 +484,12 @@ void mt76x0_cleanup(struct mt76x0_dev *dev)
 
 struct mt76x0_dev *mt76x0_alloc_device(struct device *pdev)
 {
+	static const struct mt76_driver_ops drv_ops = {
+		.tx_prepare_skb = mt76x0_tx_prepare_skb,
+		.tx_complete_skb = mt76x02_tx_complete_skb,
+		.tx_status_data = mt76x02_tx_status_data,
+		.rx_skb = mt76x0_queue_rx_skb,
+	};
 	struct ieee80211_hw *hw;
 	struct mt76x0_dev *dev;
 
@@ -493,7 +500,7 @@ struct mt76x0_dev *mt76x0_alloc_device(struct device *pdev)
 	dev = hw->priv;
 	dev->mt76.dev = pdev;
 	dev->mt76.hw = hw;
-	dev->mt76.drv = NULL;
+	dev->mt76.drv = &drv_ops;
 	mutex_init(&dev->usb_ctrl_mtx);
 	mutex_init(&dev->reg_atomic_mutex);
 	mutex_init(&dev->hw_atomic_mutex);
-- 
2.7.5
