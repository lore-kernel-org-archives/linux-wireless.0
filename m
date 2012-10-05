Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755391Ab2JELpq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 07:45:46 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 1/7] rt2800: use BBP_R1 for setting tx power
Date: Fri,  5 Oct 2012 13:44:09 +0200
Message-Id: <1349437455-18754-1-git-send-email-sgruszka@redhat.com> (sfid-20121005_134549_148248_02621DAD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

TX power delta can be negative. TX_PWR_CFG_ registers allow to set delta
only in range between 0 dBm and 15 dBm (4 bits for each rate). Se we
need to use BBP_R1 to configure negative deltas.

Not utilize +6 dBm increasing BBP_R1 option for safety reason. For now,
this can be used for devices, which export maximum allowed TX power
value.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   27 +++++++++++++++++++--------
 1 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 540c94f..a849a39 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2570,13 +2570,10 @@ static void rt2800_config_txpower(struct rt2x00_dev *rt2x00dev,
 				  enum ieee80211_band band,
 				  int power_level)
 {
-	u8 txpower;
+	u8 txpower, r1;
 	u16 eeprom;
-	int i, is_rate_b;
-	u32 reg;
-	u8 r1;
-	u32 offset;
-	int delta;
+	u32 reg, offset;
+	int i, is_rate_b, delta, power_ctrl;
 
 	/*
 	 * Calculate HT40 compensation delta
@@ -2589,10 +2586,24 @@ static void rt2800_config_txpower(struct rt2x00_dev *rt2x00dev,
 	delta += rt2800_get_gain_calibration_delta(rt2x00dev);
 
 	/*
-	 * set to normal bbp tx power control mode: +/- 0dBm
+	 * BBP_R1 controls TX power for all rates, it allow to set the following
+	 * gains -12, -6, 0, +6 dBm by setting values 2, 1, 0, 3 respectively.
+	 *
+	 * TODO: we do not use +6 dBm option to do not increase power beyond
+	 * regulatory limit, however this could be utilized for devices with
+	 * CAPABILITY_POWER_LIMIT.
 	 */
 	rt2800_bbp_read(rt2x00dev, 1, &r1);
-	rt2x00_set_field8(&r1, BBP1_TX_POWER_CTRL, 0);
+	if (delta <= -12) {
+		power_ctrl = 2;
+		delta += 12;
+	} else if (delta <= -6) {
+		power_ctrl = 1;
+		delta += 6;
+	} else {
+		power_ctrl = 0;
+	}
+	rt2x00_set_field8(&r1, BBP1_TX_POWER_CTRL, power_ctrl);
 	rt2800_bbp_write(rt2x00dev, 1, r1);
 	offset = TX_PWR_CFG_0;
 
-- 
1.7.1

