Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4045 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760197Ab2COAhe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 20:37:34 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	<stable@vger.kernel.org>, Paul Stewart <pstew@google.com>,
	Madhan Jaganathan <madhanj@qca.qualcomm.com>
Subject: [PATCH] ath9k: fix max noise floor threshold
Date: Thu, 15 Mar 2012 06:08:04 +0530
Message-ID: <1331771884-21347-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120315_013738_846764_FBF8D59A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently the maximum noise floor limit is set as too high (-60dB). The
assumption of having a higher threshold limit is that it would help
de-sensitize the receiver (reduce phy errors) from continuous
interference. But when we have a bursty interference where there are
collisions and then free air time and if the receiver is desensitized too
much, it will miss the normal packets too. Lets make use of chips
specific min, nom and max limits always. This patch helps to improve the
connection stability in congested networks.

Cc: stable@vger.kernel.org
Cc: Paul Stewart <pstew@google.com>
Tested-by: Gary Morain <gmorain@google.com>
Signed-off-by: Madhan Jaganathan <madhanj@qca.qualcomm.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/calib.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 2f4b48e..e5cceb0 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -20,7 +20,6 @@
 
 /* Common calibration code */
 
-#define ATH9K_NF_TOO_HIGH	-60
 
 static int16_t ath9k_hw_get_nf_hist_mid(int16_t *nfCalBuffer)
 {
@@ -346,10 +345,10 @@ static void ath9k_hw_nf_sanitize(struct ath_hw *ah, s16 *nf)
 			"NF calibrated [%s] [chain %d] is %d\n",
 			(i >= 3 ? "ext" : "ctl"), i % 3, nf[i]);
 
-		if (nf[i] > ATH9K_NF_TOO_HIGH) {
+		if (nf[i] > limit->max) {
 			ath_dbg(common, CALIBRATE,
 				"NF[%d] (%d) > MAX (%d), correcting to MAX\n",
-				i, nf[i], ATH9K_NF_TOO_HIGH);
+				i, nf[i], limit->max);
 			nf[i] = limit->max;
 		} else if (nf[i] < limit->min) {
 			ath_dbg(common, CALIBRATE,
-- 
1.7.9.4

