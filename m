Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:37259 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478Ab1EDOHY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 10:07:24 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 04 May 2011 07:06:56 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>,
	<stable@kernel.org>
Subject: [PATCH] ath9k_hw: do noise floor calibration only on required chains
Date: Wed, 4 May 2011 19:37:17 +0530
Message-ID: <1304518037-25156-1-git-send-email-rmanoharan@atheros.com> (sfid-20110504_160728_369195_85D36916)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

At present the noise floor calibration is processed in supported
control and extension chains rather than required chains.
Unnccesarily doing nfcal in all supported chains leads to
invalid nf readings on extn chains and these invalid values
got updated into history buffer. While loading those values
from history buffer is moving the chip to deaf state.

This issue was observed in AR9002/AR9003 chips while doing
associate/dissociate in HT40 mode and interface up/down
in iterative manner. After some iterations, the chip was moved
to deaf state. Somehow the pci devices are recovered by poll work
after chip reset. Raading the nf values in all supported extension chains
when the hw is not yet configured in HT40 mode results invalid values.

Cc: stable@kernel.org
Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/calib.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 8649581..fe3c10e 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -69,15 +69,21 @@ static void ath9k_hw_update_nfcal_hist_buffer(struct ath_hw *ah,
 					      int16_t *nfarray)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
+	struct ieee80211_conf *conf = &common->hw->conf;
 	struct ath_nf_limits *limit;
 	struct ath9k_nfcal_hist *h;
 	bool high_nf_mid = false;
+	u8 chainmask = (ah->rxchainmask << 3) | ah->rxchainmask;
 	int i;
 
 	h = cal->nfCalHist;
 	limit = ath9k_hw_get_nf_limits(ah, ah->curchan);
 
 	for (i = 0; i < NUM_NF_READINGS; i++) {
+		if (!(chainmask & (1 << i)) ||
+		    ((i >= AR5416_MAX_CHAINS) && !conf_is_ht40(conf)))
+			continue;
+
 		h[i].nfCalBuffer[h[i].currIndex] = nfarray[i];
 
 		if (++h[i].currIndex >= ATH9K_NF_CAL_HIST_MAX)
@@ -225,6 +231,7 @@ void ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
 	int32_t val;
 	u8 chainmask = (ah->rxchainmask << 3) | ah->rxchainmask;
 	struct ath_common *common = ath9k_hw_common(ah);
+	struct ieee80211_conf *conf = &common->hw->conf;
 	s16 default_nf = ath9k_hw_get_default_nf(ah, chan);
 
 	if (ah->caldata)
@@ -234,6 +241,9 @@ void ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
 		if (chainmask & (1 << i)) {
 			s16 nfval;
 
+			if ((i >= AR5416_MAX_CHAINS) && !conf_is_ht40(conf))
+				continue;
+
 			if (h)
 				nfval = h[i].privNF;
 			else
@@ -293,6 +303,9 @@ void ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
 	ENABLE_REGWRITE_BUFFER(ah);
 	for (i = 0; i < NUM_NF_READINGS; i++) {
 		if (chainmask & (1 << i)) {
+			if ((i >= AR5416_MAX_CHAINS) && !conf_is_ht40(conf))
+				continue;
+
 			val = REG_READ(ah, ah->nf_regs[i]);
 			val &= 0xFFFFFE00;
 			val |= (((u32) (-50) << 1) & 0x1ff);
-- 
1.7.5

