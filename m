Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:35542 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbbIAC4W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2015 22:56:22 -0400
From: <miaoqing@qti.qualcomm.com>
Cc: <linux-wireless@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>,
	<kvalo@qca.qualcomm.com>, Miaoqing Pan <miaoqing@qti.qualcomm.com>
To: <linville@tuxdriver.com>
Subject: [PATCH] ath9k: enable hw manual peak calibration for QCA9561
Date: Tue, 1 Sep 2015 10:56:09 +0800
Message-ID: <1441076169-13398-1-git-send-email-miaoqing@qca.qualcomm.com> (sfid-20150901_045625_713077_08241E7D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@qca.qualcomm.com>

This patch fix https://lists.openwrt.org/pipermail/openwrt-devel/
2015-August/034979.html. As the peak detect calibration is set
incorrectly.

Signed-off-by: Miaoqing Pan <miaoqing@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 174442b..0c39199 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -1249,7 +1249,8 @@ static void ar9003_hw_manual_peak_cal(struct ath_hw *ah, u8 chain, bool is_2g)
 		REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_AGC(chain),
 			      AR_PHY_65NM_RXRF_AGC_AGC2G_CALDAC_OVR, 0x0);
 
-	if (AR_SREV_9003_PCOEM(ah) || AR_SREV_9550(ah) || AR_SREV_9531(ah)) {
+	if (AR_SREV_9003_PCOEM(ah) || AR_SREV_9550(ah) || AR_SREV_9531(ah) ||
+	    AR_SREV_9561(ah)) {
 		if (is_2g)
 			REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_AGC(chain),
 				      AR_PHY_65NM_RXRF_AGC_AGC2G_DBDAC_OVR,
@@ -1640,7 +1641,8 @@ static bool ar9003_hw_init_cal_soc(struct ath_hw *ah,
 
 skip_tx_iqcal:
 	if (run_agc_cal || !(ah->ah_flags & AH_FASTCC)) {
-		if (AR_SREV_9330_11(ah) || AR_SREV_9531(ah) || AR_SREV_9550(ah)) {
+		if (AR_SREV_9330_11(ah) || AR_SREV_9531(ah) || AR_SREV_9550(ah) ||
+		    AR_SREV_9561(ah)) {
 			for (i = 0; i < AR9300_MAX_CHAINS; i++) {
 				if (!(ah->rxchainmask & (1 << i)))
 					continue;
-- 
1.9.1

