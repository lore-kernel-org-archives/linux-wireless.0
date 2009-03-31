Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out11.libero.it ([212.52.84.111]:43653 "EHLO
	cp-out11.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbZCaKHK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 06:07:10 -0400
From: Fabio Rossi <rossi.f@inwind.it>
To: linville@tuxdriver.com
Subject: [PATCH] ath5k: fix interpolation with equal power levels
Date: Tue, 31 Mar 2009 11:59:56 +0200
Cc: linux-wireless@vger.kernel.org, mickflemm@gmail.com,
	jirislaby@gmail.com, lrodriguez@atheros.com, me@bobcopeland.com,
	ath5k-devel@lists.ath5k.org
MIME-Version: 1.0
Message-Id: <200903311159.57449.rossi.f@inwind.it> (sfid-20090331_120713_876366_2C1F26C1)
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the EEPROM contains weird values for the power levels we have to
fix the interpolation process.

Signed-off-by: Fabio Rossi <rossi.f@inwind.it>
---
diff --git a/drivers/net/wireless/ath5k/phy.c b/drivers/net/wireless/ath5k/phy.c
index 9e2faae..0e3e0e0 100644
--- a/drivers/net/wireless/ath5k/phy.c
+++ b/drivers/net/wireless/ath5k/phy.c
@@ -1487,28 +1487,35 @@ ath5k_get_linear_pcdac_min(const u8 *stepL, const u8 *stepR,
 {
 	s8 tmp;
 	s16 min_pwrL, min_pwrR;
-	s16 pwr_i = pwrL[0];
-
-	do {
-		pwr_i--;
-		tmp = (s8) ath5k_get_interpolated_value(pwr_i,
-						pwrL[0], pwrL[1],
-						stepL[0], stepL[1]);
-
-	} while (tmp > 1);
-
-	min_pwrL = pwr_i;
-
-	pwr_i = pwrR[0];
-	do {
-		pwr_i--;
-		tmp = (s8) ath5k_get_interpolated_value(pwr_i,
-						pwrR[0], pwrR[1],
-						stepR[0], stepR[1]);
-
-	} while (tmp > 1);
+	s16 pwr_i;
+
+	if (pwrL[0] == pwrL[1])
+		min_pwrL = pwrL[0];
+	else {
+		pwr_i = pwrL[0];
+		do {
+			pwr_i--;
+			tmp = (s8) ath5k_get_interpolated_value(pwr_i,
+							pwrL[0], pwrL[1],
+							stepL[0], stepL[1]);
+		} while (tmp > 1);
+
+		min_pwrL = pwr_i;
+	}
 
-	min_pwrR = pwr_i;
+	if (pwrR[0] == pwrR[1])
+		min_pwrR = pwrR[0];
+	else {
+		pwr_i = pwrR[0];
+		do {
+			pwr_i--;
+			tmp = (s8) ath5k_get_interpolated_value(pwr_i,
+							pwrR[0], pwrR[1],
+							stepR[0], stepR[1]);
+		} while (tmp > 1);
+ 
+		min_pwrR = pwr_i;
+	}
 
 	/* Keep the right boundary so that it works for both curves */
 	return max(min_pwrL, min_pwrR);
