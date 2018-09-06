Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:56758 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728096AbeIFNyv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 09:54:51 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 31/42] mt76x0: fix memory leak during hw probe
Date: Thu,  6 Sep 2018 11:18:47 +0200
Message-Id: <1536225538-16454-32-git-send-email-sgruszka@redhat.com> (sfid-20180906_112023_148703_0B7B7EFA)
In-Reply-To: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
References: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Fix memory leak during hw probe if mt76x0_register_device fails
since MT76_STATE_INITIALIZED has not set yet and mt76x0_cleanup
does not free tx/rx queues and mcu buffers

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index ca70b62442a1..d186f509b5a8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -468,9 +468,7 @@ int mt76x0_init_hardware(struct mt76x0_dev *dev)
 
 void mt76x0_cleanup(struct mt76x0_dev *dev)
 {
-	if (!test_and_clear_bit(MT76_STATE_INITIALIZED, &dev->mt76.state))
-		return;
-
+	clear_bit(MT76_STATE_INITIALIZED, &dev->mt76.state);
 	mt76x0_chip_onoff(dev, false, false);
 	mt76u_queues_deinit(&dev->mt76);
 	mt76u_mcu_deinit(&dev->mt76);
-- 
2.7.5
