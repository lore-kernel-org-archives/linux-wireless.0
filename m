Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:56726 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728272AbeIFNyc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 09:54:32 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 23/42] mt76x0: remove unused stat_work
Date: Thu,  6 Sep 2018 11:18:39 +0200
Message-Id: <1536225538-16454-24-git-send-email-sgruszka@redhat.com> (sfid-20180906_112006_620489_4F640054)
In-Reply-To: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
References: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Remove unused definition of stat_work delayed_work definition and
related flush/cancel routines

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   | 2 --
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 75597b5a2427..1f4a0fff684b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -362,8 +362,6 @@ static void mt76x0_mac_stop_hw(struct mt76x0_dev *dev)
 void mt76x0_mac_stop(struct mt76x0_dev *dev)
 {
 	mt76x0_mac_stop_hw(dev);
-	flush_delayed_work(&dev->stat_work);
-	cancel_delayed_work_sync(&dev->stat_work);
 }
 
 static void mt76x0_stop_hardware(struct mt76x0_dev *dev)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 0bcf54c0a06f..cd260317de27 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -84,8 +84,6 @@ struct mt76x0_dev {
 	struct delayed_work cal_work;
 	struct delayed_work mac_work;
 
-	struct delayed_work stat_work;
-
 	spinlock_t mac_lock;
 
 	const u16 *beacon_offsets;
-- 
2.7.5
