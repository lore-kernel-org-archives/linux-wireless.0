Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:35650 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751676AbeFIKKq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Jun 2018 06:10:46 -0400
Date: Sat, 9 Jun 2018 12:10:44 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Jakub Kicinski <kubakici@wp.pl>, linux-wireless@vger.kernel.org
Cc: Adam Borowski <kilobyte@angband.pl>
Subject: [PATCH] mt7601u: remove warning when avg_rssi is zero
Message-ID: <20180609101043.GA28502@redhat.com> (sfid-20180609_121051_216783_933A0EF6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It turned out that we can run calibration without already received
frames with RSSI data. In such case just don't update AGC register
and don't print the warning.

Fixes: b305a6ab0247 ("mt7601u: use EWMA to calculate avg_rssi")
Reported-by: Adam Borowski <kilobyte@angband.pl>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt7601u/phy.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/phy.c b/drivers/net/wireless/mediatek/mt7601u/phy.c
index d440c550bdb1..3ffc8d19285b 100644
--- a/drivers/net/wireless/mediatek/mt7601u/phy.c
+++ b/drivers/net/wireless/mediatek/mt7601u/phy.c
@@ -985,13 +985,15 @@ static void mt7601u_agc_tune(struct mt7601u_dev *dev)
 	 */
 	spin_lock_bh(&dev->con_mon_lock);
 	avg_rssi = ewma_rssi_read(&dev->avg_rssi);
-	WARN_ON_ONCE(avg_rssi == 0);
+	spin_unlock_bh(&dev->con_mon_lock);
+	if (avg_rssi == 0)
+		return;
+
 	avg_rssi = -avg_rssi;
 	if (avg_rssi <= -70)
 		val -= 0x20;
 	else if (avg_rssi <= -60)
 		val -= 0x10;
-	spin_unlock_bh(&dev->con_mon_lock);
 
 	if (val != mt7601u_bbp_rr(dev, 66))
 		mt7601u_bbp_wr(dev, 66, val);
-- 
1.9.3
