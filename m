Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42838 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078AbaBYKYD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 05:24:03 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 3.14 1/2] ath9k: reduce baseband hang detection false positive rate
Date: Mon, 24 Feb 2014 22:26:05 +0100
Message-Id: <1393277166-28356-1-git-send-email-nbd@openwrt.org> (sfid-20140225_112448_299924_4C9626B4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check if the baseband state remains stable, and add a small delay
between register reads.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 11eab9f..303ce27 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1534,7 +1534,7 @@ EXPORT_SYMBOL(ath9k_hw_check_nav);
 bool ath9k_hw_check_alive(struct ath_hw *ah)
 {
 	int count = 50;
-	u32 reg;
+	u32 reg, last_val;
 
 	if (AR_SREV_9300(ah))
 		return !ath9k_hw_detect_mac_hang(ah);
@@ -1542,9 +1542,13 @@ bool ath9k_hw_check_alive(struct ath_hw *ah)
 	if (AR_SREV_9285_12_OR_LATER(ah))
 		return true;
 
+	last_val = REG_READ(ah, AR_OBS_BUS_1);
 	do {
 		reg = REG_READ(ah, AR_OBS_BUS_1);
+		if (reg != last_val)
+			return true;
 
+		last_val = reg;
 		if ((reg & 0x7E7FFFEF) == 0x00702400)
 			continue;
 
@@ -1556,6 +1560,8 @@ bool ath9k_hw_check_alive(struct ath_hw *ah)
 		default:
 			return true;
 		}
+
+		udelay(1);
 	} while (count-- > 0);
 
 	return false;
-- 
1.8.3.4 (Apple Git-47)

