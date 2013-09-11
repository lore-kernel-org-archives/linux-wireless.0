Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:57523 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092Ab3IKQE1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Sep 2013 12:04:27 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3 v2] ath9k: Handle abnormal NAV in AP mode
Date: Wed, 11 Sep 2013 21:30:27 +0530
Message-Id: <1378915227-23095-1-git-send-email-sujith@msujith.org> (sfid-20130911_180430_855515_474FA7C9)
In-Reply-To: <1378879859-32290-1-git-send-email-sujith@msujith.org>
References: <1378879859-32290-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Beacon transmission would get stuck if the NAV is
an invalid value for some reason. Check and correct
the NAV value in the HW when this happens.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
v2 - Use AR_NAV macro instead of the register address.

 drivers/net/wireless/ath/ath9k/beacon.c |  2 ++
 drivers/net/wireless/ath/ath9k/hw.c     | 13 +++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h     |  1 +
 3 files changed, 16 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index b5c16b3a..17be353 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -334,6 +334,8 @@ void ath9k_beacon_tasklet(unsigned long data)
 	if (ath9k_hw_numtxpending(ah, sc->beacon.beaconq) != 0) {
 		sc->beacon.bmisscnt++;
 
+		ath9k_hw_check_nav(ah);
+
 		if (!ath9k_hw_check_alive(ah))
 			ieee80211_queue_work(sc->hw, &sc->hw_check_work);
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 260e0c6..11ed897 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1656,6 +1656,19 @@ hang_check_iter:
 	return true;
 }
 
+void ath9k_hw_check_nav(struct ath_hw *ah)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	u32 val;
+
+	val = REG_READ(ah, AR_NAV);
+	if (val != 0xdeadbeef && val > 0x7fff) {
+		ath_dbg(common, BSTUCK, "Abnormal NAV: 0x%x\n", val);
+		REG_WRITE(ah, AR_NAV, 0);
+	}
+}
+EXPORT_SYMBOL(ath9k_hw_check_nav);
+
 bool ath9k_hw_check_alive(struct ath_hw *ah)
 {
 	int count = 50;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 88f67c3..8e1c675 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -1031,6 +1031,7 @@ void ath9k_hw_set11nmac2040(struct ath_hw *ah);
 void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period);
 void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
 				    const struct ath9k_beacon_state *bs);
+void ath9k_hw_check_nav(struct ath_hw *ah);
 bool ath9k_hw_check_alive(struct ath_hw *ah);
 
 bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode);
-- 
1.8.4

