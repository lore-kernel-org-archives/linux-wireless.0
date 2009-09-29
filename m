Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:56640 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848AbZI2SrZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2009 14:47:25 -0400
Received: by fxm18 with SMTP id 18so4728882fxm.17
        for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2009 11:47:28 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2.6.32-rc2] ar9170: fix bug in iq-auto calibration value calculation
Date: Tue, 29 Sep 2009 20:47:25 +0200
Cc: linville@tuxdriver.com, Andrew Morton <akpm@linux-foundation.org>,
	Joerg Albert <jal2@gmx.de>,
	"David S. Miller" <davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200909292047.26182.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a embarrassing bug which was introduced by:
"[PATCH] ar9170: implement frequency calibration for one-stage/openfw"

The phy_data variable initialization has to done outside the for-loop
scope. This is because the for-loop uses u32 phy_data variable more
like a 4-byte field. But in each run only a single byte is calculated.
Therefore phy_data content needs to stay the same for at least 3 more
iterations, before the complete set can be uploaded.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
BTW: I found Andrew Morton original patch right here:

http://userweb.kernel.org/~akpm/mmotm/broken-out/
drivers-net-wireless-ath-ar9170-phyc-fix-uninitialised-variable.patch
---
diff --git a/drivers/net/wireless/ath/ar9170/phy.c b/drivers/net/wireless/ath/ar9170/phy.c
index b3e5cf3..dbd488d 100644
--- a/drivers/net/wireless/ath/ar9170/phy.c
+++ b/drivers/net/wireless/ath/ar9170/phy.c
@@ -1141,7 +1141,8 @@ static int ar9170_set_freq_cal_data(struct ar9170 *ar,
 	u8 vpds[2][AR5416_PD_GAIN_ICEPTS];
 	u8 pwrs[2][AR5416_PD_GAIN_ICEPTS];
 	int chain, idx, i;
-	u8 f;
+	u32 phy_data = 0;
+	u8 f, tmp;
 
 	switch (channel->band) {
 	case IEEE80211_BAND_2GHZ:
@@ -1208,9 +1209,6 @@ static int ar9170_set_freq_cal_data(struct ar9170 *ar,
 		}
 
 		for (i = 0; i < 76; i++) {
-			u32 phy_data;
-			u8 tmp;
-
 			if (i < 25) {
 				tmp = ar9170_interpolate_val(i, &pwrs[0][0],
 							     &vpds[0][0]);
