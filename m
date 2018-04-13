Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:47984 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751299AbeDMOou (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Apr 2018 10:44:50 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Jakub Kicinski <kubakici@wp.pl>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 2/2] mt7601u: run calibration works after finishing scanning
Date: Fri, 13 Apr 2018 16:44:38 +0200
Message-Id: <1523630678-8100-2-git-send-email-sgruszka@redhat.com> (sfid-20180413_164455_466498_3FACB8CB)
In-Reply-To: <1523630678-8100-1-git-send-email-sgruszka@redhat.com>
References: <1523630678-8100-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When finishing scanning we switch to operational channel sill with
SCANNING flag. This mean that we never perform calibration works after
scanning. To fix the problem cancel and queue calibration works on
.sw_scan_start() and .sw_scan_complete() routines.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt7601u/main.c |  9 +++++++++
 drivers/net/wireless/mediatek/mt7601u/phy.c  | 15 +--------------
 2 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/main.c b/drivers/net/wireless/mediatek/mt7601u/main.c
index 43ebd460ba86..a09b92a9137d 100644
--- a/drivers/net/wireless/mediatek/mt7601u/main.c
+++ b/drivers/net/wireless/mediatek/mt7601u/main.c
@@ -273,6 +273,9 @@ static int mt7601u_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct mt7601u_dev *dev = hw->priv;
 
+	cancel_delayed_work_sync(&dev->cal_work);
+	cancel_delayed_work_sync(&dev->freq_cal.work);
+
 	mt7601u_agc_save(dev);
 	set_bit(MT7601U_STATE_SCANNING, &dev->state);
 }
@@ -285,6 +288,12 @@ static int mt7601u_config(struct ieee80211_hw *hw, u32 changed)
 
 	mt7601u_agc_restore(dev);
 	clear_bit(MT7601U_STATE_SCANNING, &dev->state);
+
+	ieee80211_queue_delayed_work(dev->hw, &dev->cal_work,
+				     MT_CALIBRATE_INTERVAL);
+	if (dev->freq_cal.enabled)
+		ieee80211_queue_delayed_work(dev->hw, &dev->freq_cal.work,
+					     MT_FREQ_CAL_INIT_DELAY);
 }
 
 static int
diff --git a/drivers/net/wireless/mediatek/mt7601u/phy.c b/drivers/net/wireless/mediatek/mt7601u/phy.c
index d440c550bdb1..e5fe3bef596e 100644
--- a/drivers/net/wireless/mediatek/mt7601u/phy.c
+++ b/drivers/net/wireless/mediatek/mt7601u/phy.c
@@ -452,24 +452,11 @@ int mt7601u_phy_set_channel(struct mt7601u_dev *dev,
 {
 	int ret;
 
-	cancel_delayed_work_sync(&dev->cal_work);
-	cancel_delayed_work_sync(&dev->freq_cal.work);
-
 	mutex_lock(&dev->hw_atomic_mutex);
 	ret = __mt7601u_phy_set_channel(dev, chandef);
 	mutex_unlock(&dev->hw_atomic_mutex);
-	if (ret)
-		return ret;
-
-	if (test_bit(MT7601U_STATE_SCANNING, &dev->state))
-		return 0;
 
-	ieee80211_queue_delayed_work(dev->hw, &dev->cal_work,
-				     MT_CALIBRATE_INTERVAL);
-	if (dev->freq_cal.enabled)
-		ieee80211_queue_delayed_work(dev->hw, &dev->freq_cal.work,
-					     MT_FREQ_CAL_INIT_DELAY);
-	return 0;
+	return ret;
 }
 
 #define BBP_R47_FLAG		GENMASK(2, 0)
-- 
1.9.3
