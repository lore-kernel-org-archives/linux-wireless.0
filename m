Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:36144 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728096AbeIFNyo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 09:54:44 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 28/42] mt76x0: remove mt76x0_stop_hardware routine
Date: Thu,  6 Sep 2018 11:18:44 +0200
Message-Id: <1536225538-16454-29-git-send-email-sgruszka@redhat.com> (sfid-20180906_112015_590648_EE51DF9E)
In-Reply-To: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
References: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Since it is actually used in a single place and it just
runs mt76x0_chip_onoff routine, remove mt76x0_stop_hardware
and use mt76x0_chip_onoff directly

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 418e1918086d..5b819a224d33 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -364,11 +364,6 @@ void mt76x0_mac_stop(struct mt76x0_dev *dev)
 	mt76x0_mac_stop_hw(dev);
 }
 
-static void mt76x0_stop_hardware(struct mt76x0_dev *dev)
-{
-	mt76x0_chip_onoff(dev, false, false);
-}
-
 int mt76x0_init_hardware(struct mt76x0_dev *dev)
 {
 	static const u16 beacon_offsets[16] = {
@@ -476,7 +471,7 @@ void mt76x0_cleanup(struct mt76x0_dev *dev)
 	if (!test_and_clear_bit(MT76_STATE_INITIALIZED, &dev->mt76.state))
 		return;
 
-	mt76x0_stop_hardware(dev);
+	mt76x0_chip_onoff(dev, false, false);
 	mt76u_queues_deinit(&dev->mt76);
 	mt76u_mcu_deinit(&dev->mt76);
 }
-- 
2.7.5
