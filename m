Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:36248 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728096AbeIFNyx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 09:54:53 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 32/42] mt76x0: move stop related routines in mt76x0_mac_stop
Date: Thu,  6 Sep 2018 11:18:48 +0200
Message-Id: <1536225538-16454-33-git-send-email-sgruszka@redhat.com> (sfid-20180906_112023_782177_A652E150)
In-Reply-To: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
References: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Move tear-down routines in mt76x0_mac_stop function.
mt76x0_mac_stop routines will be reused in mt76x0_suspend

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c | 3 +++
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c | 4 ----
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index d186f509b5a8..b1d5f647eac5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -361,6 +361,9 @@ static void mt76x0_mac_stop_hw(struct mt76x0_dev *dev)
 
 void mt76x0_mac_stop(struct mt76x0_dev *dev)
 {
+	cancel_delayed_work_sync(&dev->cal_work);
+	cancel_delayed_work_sync(&dev->mac_work);
+	mt76u_stop_stat_wk(&dev->mt76);
 	mt76x0_mac_stop_hw(dev);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index 8c8a0f676228..0d3c7accb4f8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -48,10 +48,6 @@ static void mt76x0_stop(struct ieee80211_hw *hw)
 	mutex_lock(&dev->mt76.mutex);
 
 	clear_bit(MT76_STATE_RUNNING, &dev->mt76.state);
-
-	cancel_delayed_work_sync(&dev->cal_work);
-	cancel_delayed_work_sync(&dev->mac_work);
-	mt76u_stop_stat_wk(&dev->mt76);
 	mt76x0_mac_stop(dev);
 
 	mutex_unlock(&dev->mt76.mutex);
-- 
2.7.5
