Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:55695 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab3HDIze (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Aug 2013 04:55:34 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 01/11] ath9k: Add information about antenna diversity
Date: Sun,  4 Aug 2013 14:21:52 +0530
Message-Id: <1375606322-9983-1-git-send-email-sujith@msujith.org> (sfid-20130804_105557_468480_A1F5D238)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/antenna.c | 52 ++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/antenna.c b/drivers/net/wireless/ath/ath9k/antenna.c
index 291ca01..4cd2bce 100644
--- a/drivers/net/wireless/ath/ath9k/antenna.c
+++ b/drivers/net/wireless/ath/ath9k/antenna.c
@@ -16,6 +16,58 @@
 
 #include "ath9k.h"
 
+/*
+ * AR9285
+ * ======
+ *
+ * EEPROM has 2 4-bit fields containing the card configuration.
+ *
+ * antdiv_ctl1:
+ * ------------
+ * bb_enable_ant_div_lnadiv : 1
+ * bb_ant_div_alt_gaintb    : 1
+ * bb_ant_div_main_gaintb   : 1
+ * bb_enable_ant_fast_div   : 1
+ *
+ * antdiv_ctl2:
+ * -----------
+ * bb_ant_div_alt_lnaconf  : 2
+ * bb_ant_div_main_lnaconf : 2
+ *
+ * The EEPROM bits are used as follows:
+ * ------------------------------------
+ *
+ * bb_enable_ant_div_lnadiv      - Enable LNA path rx antenna diversity/combining.
+ *                                 Set in AR_PHY_MULTICHAIN_GAIN_CTL.
+ *
+ * bb_ant_div_[alt/main]_gaintb  - 0 -> Antenna config Alt/Main uses gaintable 0
+ *                                 1 -> Antenna config Alt/Main uses gaintable 1
+ *                                 Set in AR_PHY_MULTICHAIN_GAIN_CTL.
+ *
+ * bb_enable_ant_fast_div        - Enable fast antenna diversity.
+ *                                 Set in AR_PHY_CCK_DETECT.
+ *
+ * bb_ant_div_[alt/main]_lnaconf - Alt/Main LNA diversity/combining input config.
+ *                                 Set in AR_PHY_MULTICHAIN_GAIN_CTL.
+ *                                 10=LNA1
+ *                                 01=LNA2
+ *                                 11=LNA1+LNA2
+ *                                 00=LNA1-LNA2
+ *
+ * AR9485 / AR9565 / AR9331
+ * ========================
+ *
+ * The same bits are present in the EEPROM, but the location in the
+ * EEPROM is different (ant_div_control in ar9300_BaseExtension_1).
+ *
+ * ant_div_alt_lnaconf      ==> bit 0~1
+ * ant_div_main_lnaconf     ==> bit 2~3
+ * ant_div_alt_gaintb       ==> bit 4
+ * ant_div_main_gaintb      ==> bit 5
+ * enable_ant_div_lnadiv    ==> bit 6
+ * enable_ant_fast_div      ==> bit 7
+ */
+
 static inline bool ath_is_alt_ant_ratio_better(int alt_ratio, int maxdelta,
 					       int mindelta, int main_rssi_avg,
 					       int alt_rssi_avg, int pkt_count)
-- 
1.8.3.4

