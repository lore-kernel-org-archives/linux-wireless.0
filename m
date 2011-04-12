Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:38919 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753756Ab1DLNSS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 09:18:18 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 06:17:52 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 09/22] ath9k_hw: Read spur frequency information from eeprom for AR9340
Date: Tue, 12 Apr 2011 18:47:45 +0530
Message-ID: <1302614273-2063-5-git-send-email-vasanth@atheros.com>
In-Reply-To: <1302614273-2063-1-git-send-email-vasanth@atheros.com>
References: <1302614273-2063-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 1544e57..65c52b4 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -151,7 +151,7 @@ static void ar9003_hw_spur_mitigate_mrc_cck(struct ath_hw *ah,
 	 * is out-of-band and can be ignored.
 	 */
 
-	if (AR_SREV_9485(ah)) {
+	if (AR_SREV_9485(ah) || AR_SREV_9340(ah)) {
 		spur_fbin_ptr = ar9003_get_spur_chan_ptr(ah,
 							 IS_CHAN_2GHZ(chan));
 		if (spur_fbin_ptr[0] == 0) /* No spur */
@@ -176,7 +176,7 @@ static void ar9003_hw_spur_mitigate_mrc_cck(struct ath_hw *ah,
 
 	for (i = 0; i < max_spur_cnts; i++) {
 		negative = 0;
-		if (AR_SREV_9485(ah))
+		if (AR_SREV_9485(ah) || AR_SREV_9340(ah))
 			cur_bb_spur = FBIN2FREQ(spur_fbin_ptr[i],
 					IS_CHAN_2GHZ(chan)) - synth_freq;
 		else
-- 
1.7.0.4

