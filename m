Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:26505 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754399Ab0KJNEN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 08:04:13 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 05:04:00 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 09/11] ath9k_hw: Add helper function for interpolation
Date: Wed, 10 Nov 2010 05:03:14 -0800
Message-ID: <1289394196-3465-9-git-send-email-vasanth@atheros.com>
In-Reply-To: <1289394196-3465-1-git-send-email-vasanth@atheros.com>
References: <1289394196-3465-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also round off interpolated values this would improve power
accuracy by 0.5dB in some cases.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   48 ++++++++++++++----------
 1 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 5ffeda2..1b4e991 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -2982,6 +2982,16 @@ static int ath9k_hw_ar9300_check_eeprom(struct ath_hw *ah)
 	return 0;
 }
 
+static int interpolate(int x, int xa, int xb, int ya, int yb)
+{
+	int bf, factor, plus;
+
+	bf = 2 * (yb - ya) * (x - xa) / (xb - xa);
+	factor = bf / 2;
+	plus = bf % 2;
+	return ya + factor + plus;
+}
+
 static u32 ath9k_hw_ar9300_get_eeprom(struct ath_hw *ah,
 				      enum eeprom_param param)
 {
@@ -3614,7 +3624,7 @@ static int ar9003_hw_power_interpolate(int32_t x,
 			if (hx == lx)
 				y = ly;
 			else	/* interpolate  */
-				y = ly + (((x - lx) * (hy - ly)) / (hx - lx));
+				y = interpolate(x, lx, hx, ly, hy);
 		} else		/* only low is good, use it */
 			y = ly;
 	} else if (hhave)	/* only high is good, use it */
@@ -4204,25 +4214,23 @@ static int ar9003_hw_calibration_apply(struct ath_hw *ah, int frequency)
 			/* so is the high frequency, interpolate */
 			if (hfrequency[ichain] - frequency < 1000) {
 
-				correction[ichain] = lcorrection[ichain] +
-				    (((frequency - lfrequency[ichain]) *
-				      (hcorrection[ichain] -
-				       lcorrection[ichain])) /
-				     (hfrequency[ichain] - lfrequency[ichain]));
-
-				temperature[ichain] = ltemperature[ichain] +
-				    (((frequency - lfrequency[ichain]) *
-				      (htemperature[ichain] -
-				       ltemperature[ichain])) /
-				     (hfrequency[ichain] - lfrequency[ichain]));
-
-				voltage[ichain] =
-				    lvoltage[ichain] +
-				    (((frequency -
-				       lfrequency[ichain]) * (hvoltage[ichain] -
-							      lvoltage[ichain]))
-				     / (hfrequency[ichain] -
-					lfrequency[ichain]));
+				correction[ichain] = interpolate(frequency,
+						lfrequency[ichain],
+						hfrequency[ichain],
+						lcorrection[ichain],
+						hcorrection[ichain]);
+
+				temperature[ichain] = interpolate(frequency,
+						lfrequency[ichain],
+						hfrequency[ichain],
+						ltemperature[ichain],
+						htemperature[ichain]);
+
+				voltage[ichain] = interpolate(frequency,
+						lfrequency[ichain],
+						hfrequency[ichain],
+						lvoltage[ichain],
+						hvoltage[ichain]);
 			}
 			/* only low is good, use it */
 			else {
-- 
1.7.0.4

