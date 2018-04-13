Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:40970 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751240AbeDMOot (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Apr 2018 10:44:49 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Jakub Kicinski <kubakici@wp.pl>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 1/2] mt7601u: use EWMA to calculate avg_rssi
Date: Fri, 13 Apr 2018 16:44:37 +0200
Message-Id: <1523630678-8100-1-git-send-email-sgruszka@redhat.com> (sfid-20180413_164454_200614_E61A7BB7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

avr_rssi is not calculated correctly as we do not divide result
by 256 (mt76 sum avg_rssi1 and avg_rssi2 and divide by 512).
However dividing by 256 will make avg_rssi almost the same as
last rssi value - not really an average. So use EWMA to calculate
avg_rssi. I've chosen weight_rcp=4 to convergence quicker on signal
strength changes.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt7601u/mac.c     |  4 ++--
 drivers/net/wireless/mediatek/mt7601u/mt7601u.h |  5 ++++-
 drivers/net/wireless/mediatek/mt7601u/phy.c     | 10 +++++++---
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/mac.c b/drivers/net/wireless/mediatek/mt7601u/mac.c
index d6dc59bb00df..8ec18d69f564 100644
--- a/drivers/net/wireless/mediatek/mt7601u/mac.c
+++ b/drivers/net/wireless/mediatek/mt7601u/mac.c
@@ -437,7 +437,7 @@ void mt7601u_mac_set_ampdu_factor(struct mt7601u_dev *dev)
 {
 	dev->bcn_freq_off = rxwi->freq_off;
 	dev->bcn_phy_mode = FIELD_GET(MT_RXWI_RATE_PHY, rate);
-	dev->avg_rssi = (dev->avg_rssi * 15) / 16 + (rssi << 8);
+	ewma_rssi_add(&dev->avg_rssi, -rssi);
 }
 
 static int
@@ -479,7 +479,7 @@ u32 mt76_mac_process_rx(struct mt7601u_dev *dev, struct sk_buff *skb,
 	if (mt7601u_rx_is_our_beacon(dev, data))
 		mt7601u_rx_monitor_beacon(dev, rxwi, rate, rssi);
 	else if (rxwi->rxinfo & cpu_to_le32(MT_RXINFO_U2M))
-		dev->avg_rssi = (dev->avg_rssi * 15) / 16 + (rssi << 8);
+		ewma_rssi_add(&dev->avg_rssi, -rssi);
 	spin_unlock_bh(&dev->con_mon_lock);
 
 	return len;
diff --git a/drivers/net/wireless/mediatek/mt7601u/mt7601u.h b/drivers/net/wireless/mediatek/mt7601u/mt7601u.h
index c7ec40475a5f..9058b0af7bec 100644
--- a/drivers/net/wireless/mediatek/mt7601u/mt7601u.h
+++ b/drivers/net/wireless/mediatek/mt7601u/mt7601u.h
@@ -23,6 +23,7 @@
 #include <linux/completion.h>
 #include <net/mac80211.h>
 #include <linux/debugfs.h>
+#include <linux/average.h>
 
 #include "regs.h"
 
@@ -138,6 +139,8 @@ enum {
 	MT7601U_STATE_MORE_STATS,
 };
 
+DECLARE_EWMA(rssi, 10, 4);
+
 /**
  * struct mt7601u_dev - adapter structure
  * @lock:		protects @wcid->tx_rate.
@@ -219,7 +222,7 @@ struct mt7601u_dev {
 	s8 bcn_freq_off;
 	u8 bcn_phy_mode;
 
-	int avg_rssi; /* starts at 0 and converges */
+	struct ewma_rssi avg_rssi;
 
 	u8 agc_save;
 
diff --git a/drivers/net/wireless/mediatek/mt7601u/phy.c b/drivers/net/wireless/mediatek/mt7601u/phy.c
index ca09a5d4305e..d440c550bdb1 100644
--- a/drivers/net/wireless/mediatek/mt7601u/phy.c
+++ b/drivers/net/wireless/mediatek/mt7601u/phy.c
@@ -974,6 +974,7 @@ void mt7601u_agc_restore(struct mt7601u_dev *dev)
 static void mt7601u_agc_tune(struct mt7601u_dev *dev)
 {
 	u8 val = mt7601u_agc_default(dev);
+	long avg_rssi;
 
 	if (test_bit(MT7601U_STATE_SCANNING, &dev->state))
 		return;
@@ -983,9 +984,12 @@ static void mt7601u_agc_tune(struct mt7601u_dev *dev)
 	 *	 Rssi updates are only on beacons and U2M so should work...
 	 */
 	spin_lock_bh(&dev->con_mon_lock);
-	if (dev->avg_rssi <= -70)
+	avg_rssi = ewma_rssi_read(&dev->avg_rssi);
+	WARN_ON_ONCE(avg_rssi == 0);
+	avg_rssi = -avg_rssi;
+	if (avg_rssi <= -70)
 		val -= 0x20;
-	else if (dev->avg_rssi <= -60)
+	else if (avg_rssi <= -60)
 		val -= 0x10;
 	spin_unlock_bh(&dev->con_mon_lock);
 
@@ -1101,7 +1105,7 @@ void mt7601u_phy_con_cal_onoff(struct mt7601u_dev *dev,
 	/* Start/stop collecting beacon data */
 	spin_lock_bh(&dev->con_mon_lock);
 	ether_addr_copy(dev->ap_bssid, info->bssid);
-	dev->avg_rssi = 0;
+	ewma_rssi_init(&dev->avg_rssi);
 	dev->bcn_freq_off = MT_FREQ_OFFSET_INVALID;
 	spin_unlock_bh(&dev->con_mon_lock);
 
-- 
1.9.3
