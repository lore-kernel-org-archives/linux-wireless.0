Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:55974 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754024AbeDPL42 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Apr 2018 07:56:28 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Jakub Kicinski <kubakici@wp.pl>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 2/2 v2] mt7601u: run calibration works after finishing scanning
Date: Mon, 16 Apr 2018 13:56:18 +0200
Message-Id: <1523879778-6455-2-git-send-email-sgruszka@redhat.com> (sfid-20180416_135632_087058_19C75820)
In-Reply-To: <1523879778-6455-1-git-send-email-sgruszka@redhat.com>
References: <1523879778-6455-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When finishing scanning we switch to operational channel sill with
SCANNING flag. This mean that we never perform calibration works after
scanning. To fix the problem queue calibration works on
.sw_scan_complete() routine.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt7601u/main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt7601u/main.c b/drivers/net/wireless/mediatek/mt7601u/main.c
index 43ebd460ba86..f2ddefaa29f7 100644
--- a/drivers/net/wireless/mediatek/mt7601u/main.c
+++ b/drivers/net/wireless/mediatek/mt7601u/main.c
@@ -285,6 +285,12 @@ static int mt7601u_config(struct ieee80211_hw *hw, u32 changed)
 
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
-- 
1.9.3
