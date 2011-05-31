Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:53491 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758216Ab1EaTru (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 15:47:50 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [RFC 12/32] ath9k: read spur frequency information from eeprom for AR9330
Date: Tue, 31 May 2011 21:37:03 +0200
Message-Id: <1306870643-7935-13-git-send-email-juhosg@openwrt.org> (sfid-20110531_214857_050672_BE83CBB1)
In-Reply-To: <1306870643-7935-1-git-send-email-juhosg@openwrt.org>
References: <1306870643-7935-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 48893f1..2df72cb 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -168,7 +168,7 @@ static void ar9003_hw_spur_mitigate_mrc_cck(struct ath_hw *ah,
 	 * is out-of-band and can be ignored.
 	 */
 
-	if (AR_SREV_9485(ah) || AR_SREV_9340(ah)) {
+	if (AR_SREV_9485(ah) || AR_SREV_9340(ah) || AR_SREV_9330(ah)) {
 		spur_fbin_ptr = ar9003_get_spur_chan_ptr(ah,
 							 IS_CHAN_2GHZ(chan));
 		if (spur_fbin_ptr[0] == 0) /* No spur */
@@ -193,7 +193,7 @@ static void ar9003_hw_spur_mitigate_mrc_cck(struct ath_hw *ah,
 
 	for (i = 0; i < max_spur_cnts; i++) {
 		negative = 0;
-		if (AR_SREV_9485(ah) || AR_SREV_9340(ah))
+		if (AR_SREV_9485(ah) || AR_SREV_9340(ah) || AR_SREV_9330(ah))
 			cur_bb_spur = FBIN2FREQ(spur_fbin_ptr[i],
 					IS_CHAN_2GHZ(chan)) - synth_freq;
 		else
-- 
1.7.2.1

