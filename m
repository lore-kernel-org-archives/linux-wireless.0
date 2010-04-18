Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:42625 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149Ab0DRPig (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Apr 2010 11:38:36 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 1/9] ath9k: check for specific rx stuck conditions and recover from them
Date: Sun, 18 Apr 2010 16:56:34 +0200
Message-Id: <1271602602-8538-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c   |   28 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h   |    1 +
 drivers/net/wireless/ath/ath9k/main.c |    3 ++-
 3 files changed, 31 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 9aa40df..5a29048 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1160,6 +1160,34 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 	return true;
 }
 
+bool ath9k_hw_check_alive(struct ath_hw *ah)
+{
+	int count = 50;
+	u32 reg;
+
+	if (AR_SREV_9285_10_OR_LATER(ah))
+		return true;
+
+	do {
+		reg = REG_READ(ah, AR_OBS_BUS_1);
+
+		if ((reg & 0x7E7FFFEF) == 0x00702400)
+			continue;
+
+		switch (reg & 0x7E000B00) {
+		case 0x1E000000:
+		case 0x52000B00:
+		case 0x18000B00:
+			continue;
+		default:
+			return true;
+		}
+	} while (count-- > 0);
+
+	return false;
+}
+EXPORT_SYMBOL(ath9k_hw_check_alive);
+
 int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		    bool bChannelChange)
 {
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 8158e8e..a78e09b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -869,6 +869,7 @@ void ath9k_hw_set11nmac2040(struct ath_hw *ah);
 void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period);
 void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
 				    const struct ath9k_beacon_state *bs);
+bool ath9k_hw_check_alive(struct ath_hw *ah);
 
 bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode);
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 1f4ea74..0246e7a 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -405,7 +405,8 @@ void ath9k_tasklet(unsigned long data)
 
 	ath9k_ps_wakeup(sc);
 
-	if (status & ATH9K_INT_FATAL) {
+	if ((status & ATH9K_INT_FATAL) ||
+	    !ath9k_hw_check_alive(ah)) {
 		ath_reset(sc, false);
 		ath9k_ps_restore(sc);
 		return;
-- 
1.6.4.2

