Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58025 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbcETMON (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2016 08:14:13 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
	"Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH 1/2] ath10k: Remove duplicate and unused rx rate flags
Date: Fri, 20 May 2016 17:43:18 +0530
Message-ID: <1463746399-22839-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20160520_141416_806543_0C691DFD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

All these flags are not used and their use is completely
covered by 'ath10k_hw_rate_ofdm', 'ath10k_hw_rate_cck',
and RX_PPDU_START_RATE_FLAG

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
[thanks Michal/Kalle/Vasanth for the first level review]

 drivers/net/wireless/ath/ath10k/rx_desc.h |   39 -----------------------------
 1 file changed, 39 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/rx_desc.h b/drivers/net/wireless/ath/ath10k/rx_desc.h
index ca8d168..aa660a4 100644
--- a/drivers/net/wireless/ath/ath10k/rx_desc.h
+++ b/drivers/net/wireless/ath/ath10k/rx_desc.h
@@ -656,26 +656,6 @@ struct rx_msdu_end {
  *		Reserved: HW should fill with zero.  FW should ignore.
  */
 
-#define RX_PPDU_START_SIG_RATE_SELECT_OFDM 0
-#define RX_PPDU_START_SIG_RATE_SELECT_CCK  1
-
-#define RX_PPDU_START_SIG_RATE_OFDM_48 0
-#define RX_PPDU_START_SIG_RATE_OFDM_24 1
-#define RX_PPDU_START_SIG_RATE_OFDM_12 2
-#define RX_PPDU_START_SIG_RATE_OFDM_6  3
-#define RX_PPDU_START_SIG_RATE_OFDM_54 4
-#define RX_PPDU_START_SIG_RATE_OFDM_36 5
-#define RX_PPDU_START_SIG_RATE_OFDM_18 6
-#define RX_PPDU_START_SIG_RATE_OFDM_9  7
-
-#define RX_PPDU_START_SIG_RATE_CCK_LP_11  0
-#define RX_PPDU_START_SIG_RATE_CCK_LP_5_5 1
-#define RX_PPDU_START_SIG_RATE_CCK_LP_2   2
-#define RX_PPDU_START_SIG_RATE_CCK_LP_1   3
-#define RX_PPDU_START_SIG_RATE_CCK_SP_11  4
-#define RX_PPDU_START_SIG_RATE_CCK_SP_5_5 5
-#define RX_PPDU_START_SIG_RATE_CCK_SP_2   6
-
 #define HTT_RX_PPDU_START_PREAMBLE_LEGACY        0x04
 #define HTT_RX_PPDU_START_PREAMBLE_HT            0x08
 #define HTT_RX_PPDU_START_PREAMBLE_HT_WITH_TXBF  0x09
@@ -711,25 +691,6 @@ struct rx_msdu_end {
 /* No idea what this flag means. It seems to be always set in rate. */
 #define RX_PPDU_START_RATE_FLAG BIT(3)
 
-enum rx_ppdu_start_rate {
-	RX_PPDU_START_RATE_OFDM_48M = RX_PPDU_START_RATE_FLAG | ATH10K_HW_RATE_OFDM_48M,
-	RX_PPDU_START_RATE_OFDM_24M = RX_PPDU_START_RATE_FLAG | ATH10K_HW_RATE_OFDM_24M,
-	RX_PPDU_START_RATE_OFDM_12M = RX_PPDU_START_RATE_FLAG | ATH10K_HW_RATE_OFDM_12M,
-	RX_PPDU_START_RATE_OFDM_6M  = RX_PPDU_START_RATE_FLAG | ATH10K_HW_RATE_OFDM_6M,
-	RX_PPDU_START_RATE_OFDM_54M = RX_PPDU_START_RATE_FLAG | ATH10K_HW_RATE_OFDM_54M,
-	RX_PPDU_START_RATE_OFDM_36M = RX_PPDU_START_RATE_FLAG | ATH10K_HW_RATE_OFDM_36M,
-	RX_PPDU_START_RATE_OFDM_18M = RX_PPDU_START_RATE_FLAG | ATH10K_HW_RATE_OFDM_18M,
-	RX_PPDU_START_RATE_OFDM_9M  = RX_PPDU_START_RATE_FLAG | ATH10K_HW_RATE_OFDM_9M,
-
-	RX_PPDU_START_RATE_CCK_LP_11M  = RX_PPDU_START_RATE_FLAG | ATH10K_HW_RATE_CCK_LP_11M,
-	RX_PPDU_START_RATE_CCK_LP_5_5M = RX_PPDU_START_RATE_FLAG | ATH10K_HW_RATE_CCK_LP_5_5M,
-	RX_PPDU_START_RATE_CCK_LP_2M   = RX_PPDU_START_RATE_FLAG | ATH10K_HW_RATE_CCK_LP_2M,
-	RX_PPDU_START_RATE_CCK_LP_1M   = RX_PPDU_START_RATE_FLAG | ATH10K_HW_RATE_CCK_LP_1M,
-	RX_PPDU_START_RATE_CCK_SP_11M  = RX_PPDU_START_RATE_FLAG | ATH10K_HW_RATE_CCK_SP_11M,
-	RX_PPDU_START_RATE_CCK_SP_5_5M = RX_PPDU_START_RATE_FLAG | ATH10K_HW_RATE_CCK_SP_5_5M,
-	RX_PPDU_START_RATE_CCK_SP_2M   = RX_PPDU_START_RATE_FLAG | ATH10K_HW_RATE_CCK_SP_2M,
-};
-
 struct rx_ppdu_start {
 	struct {
 		u8 pri20_mhz;
-- 
1.7.9.5

