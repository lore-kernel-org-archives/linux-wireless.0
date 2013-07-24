Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:38879 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab3GXIY4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jul 2013 04:24:56 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/5] ath9k: Add information about AR9285 diversity
Date: Wed, 24 Jul 2013 13:51:26 +0530
Message-Id: <1374654090-24408-1-git-send-email-sujith@msujith.org> (sfid-20130724_102501_552876_4CAC9578)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/antenna.c | 39 ++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/antenna.c b/drivers/net/wireless/ath/ath9k/antenna.c
index 664844c..a05fa18 100644
--- a/drivers/net/wireless/ath/ath9k/antenna.c
+++ b/drivers/net/wireless/ath/ath9k/antenna.c
@@ -16,6 +16,45 @@
 
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
+ */
+
 static inline bool ath_is_alt_ant_ratio_better(int alt_ratio, int maxdelta,
 					       int mindelta, int main_rssi_avg,
 					       int alt_rssi_avg, int pkt_count)
-- 
1.8.3.3

