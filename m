Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:49350 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128Ab1KHItB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 03:49:01 -0500
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 3/4] ath9k_hw: Fix channel list of CalFreqPeir for AR938x
Date: Tue, 8 Nov 2011 14:19:34 +0530
Message-ID: <1320742175-10962-3-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111108_094905_812134_BE52719B)
In-Reply-To: <1320742175-10962-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1320742175-10962-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch sync up CalFreqPeir channel list and paprd rate mask
of AR938x templates to the latest received from Systems team.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 5fb3f54..ee9c09b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -1281,8 +1281,8 @@ static const struct ar9300_eeprom ar9300_h112 = {
 		.txEndToRxOn = 0x2,
 		.txFrameToXpaOn = 0xe,
 		.thresh62 = 28,
-		.papdRateMaskHt20 = LE32(0x80c080),
-		.papdRateMaskHt40 = LE32(0x80c080),
+		.papdRateMaskHt20 = LE32(0x0c80c080),
+		.papdRateMaskHt40 = LE32(0x0080c080),
 		.futureModal = {
 			0, 0, 0, 0, 0, 0, 0, 0,
 		},
@@ -1294,7 +1294,7 @@ static const struct ar9300_eeprom ar9300_h112 = {
 	.calFreqPier2G = {
 		FREQ2FBIN(2412, 1),
 		FREQ2FBIN(2437, 1),
-		FREQ2FBIN(2472, 1),
+		FREQ2FBIN(2462, 1),
 	},
 	/* ar9300_cal_data_per_freq_op_loop 2g */
 	.calPierData2G = {
@@ -1304,7 +1304,7 @@ static const struct ar9300_eeprom ar9300_h112 = {
 	},
 	.calTarget_freqbin_Cck = {
 		FREQ2FBIN(2412, 1),
-		FREQ2FBIN(2484, 1),
+		FREQ2FBIN(2472, 1),
 	},
 	.calTarget_freqbin_2G = {
 		FREQ2FBIN(2412, 1),
@@ -1503,7 +1503,7 @@ static const struct ar9300_eeprom ar9300_h112 = {
 		FREQ2FBIN(5500, 0),
 		FREQ2FBIN(5600, 0),
 		FREQ2FBIN(5700, 0),
-		FREQ2FBIN(5825, 0)
+		FREQ2FBIN(5785, 0)
 	},
 	.calPierData5G = {
 		{
@@ -2441,7 +2441,7 @@ static const struct ar9300_eeprom ar9300_h116 = {
 	.calFreqPier2G = {
 		FREQ2FBIN(2412, 1),
 		FREQ2FBIN(2437, 1),
-		FREQ2FBIN(2472, 1),
+		FREQ2FBIN(2462, 1),
 	 },
 	/* ar9300_cal_data_per_freq_op_loop 2g */
 	.calPierData2G = {
@@ -2643,7 +2643,7 @@ static const struct ar9300_eeprom ar9300_h116 = {
 		.xatten1MarginHigh = {0, 0, 0}
 	 },
 	.calFreqPier5G = {
-		FREQ2FBIN(5180, 0),
+		FREQ2FBIN(5160, 0),
 		FREQ2FBIN(5220, 0),
 		FREQ2FBIN(5320, 0),
 		FREQ2FBIN(5400, 0),
-- 
1.7.7.2

