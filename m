Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:26836 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755634Ab0CQV1P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 17:27:15 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 17 Mar 2010 14:27:15 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Sujith <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 06/12] ath9k_hw: fix noisefloor history buffer usage on AR9271
Date: Wed, 17 Mar 2010 14:25:19 +0530
Message-ID: <1268816125-16173-7-git-send-email-senthilkumar@atheros.com>
In-Reply-To: <1268816125-16173-6-git-send-email-senthilkumar@atheros.com>
References: <1268816125-16173-1-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-2-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-3-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-4-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-5-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-6-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith <Sujith.Manoharan@atheros.com>

Noisefloor calibration involves querying hardware for samples
and storing this information on a history buffer in hardware for
actual noisefloor calibration processing in hardware. The history
buffer supports collecting information for all Atheros hardware,
one history buffer slot for each chain on each channel used for
MIMO operation. For current hardware this means one history
buffer slot for each chain on both the control (or primary) channel
and the extension (or secondary) channel. We know which noisefloor
registers to poke for collecting noisefloor data through the
chainmask.

For AR9285 and AR9271 devices, both 1x1, the chaimmask is defined as
0x9 = 0b0001001. The first four bits represent each chain out of
a maximum of 4 chains [0-3] on the primary channel. The last four
bits represent each chain on the extension channel. A chainmask
of 0x9 therefore indicates chain 1 is active on both the primary
and the extension channel.

AR9271 only requires collecting and storing noisefloor history buffer
data for the first chain on both the control and extension channel
(nfarray[0] and nfarray[3]) so fix the code and avoid which reads
and writes to the history buffer for the other chains.

Since the noisefloor varies depending on the number of chains your
device supports also initialize the noisefloor history buffer with
reasonable values seen on 1x1 devices such as AR9285.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/calib.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 238a574..0c3e9c8 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -103,7 +103,7 @@ static void ath9k_hw_do_getnf(struct ath_hw *ah,
 		  "NF calibrated [ctl] [chain 0] is %d\n", nf);
 	nfarray[0] = nf;
 
-	if (!AR_SREV_9285(ah)) {
+	if (!AR_SREV_9285(ah) && !AR_SREV_9271(ah)) {
 		if (AR_SREV_9280_10_OR_LATER(ah))
 			nf = MS(REG_READ(ah, AR_PHY_CH1_CCA),
 					AR9280_PHY_CH1_MINCCA_PWR);
@@ -141,7 +141,7 @@ static void ath9k_hw_do_getnf(struct ath_hw *ah,
 		  "NF calibrated [ext] [chain 0] is %d\n", nf);
 	nfarray[3] = nf;
 
-	if (!AR_SREV_9285(ah)) {
+	if (!AR_SREV_9285(ah) && !AR_SREV_9271(ah)) {
 		if (AR_SREV_9280_10_OR_LATER(ah))
 			nf = MS(REG_READ(ah, AR_PHY_CH1_EXT_CCA),
 					AR9280_PHY_CH1_EXT_MINCCA_PWR);
@@ -621,7 +621,7 @@ void ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
 	u8 chainmask, rx_chain_status;
 
 	rx_chain_status = REG_READ(ah, AR_PHY_RX_CHAINMASK);
-	if (AR_SREV_9285(ah))
+	if (AR_SREV_9285(ah) || AR_SREV_9271(ah))
 		chainmask = 0x9;
 	else if (AR_SREV_9280(ah) || AR_SREV_9287(ah)) {
 		if ((rx_chain_status & 0x2) || (rx_chain_status & 0x4))
@@ -715,7 +715,7 @@ void ath9k_init_nfcal_hist_buffer(struct ath_hw *ah)
 
 	if (AR_SREV_9280(ah))
 		noise_floor = AR_PHY_CCA_MAX_AR9280_GOOD_VALUE;
-	else if (AR_SREV_9285(ah))
+	else if (AR_SREV_9285(ah) || AR_SREV_9271(ah))
 		noise_floor = AR_PHY_CCA_MAX_AR9285_GOOD_VALUE;
 	else if (AR_SREV_9287(ah))
 		noise_floor = AR_PHY_CCA_MAX_AR9287_GOOD_VALUE;
-- 
1.6.4.2

