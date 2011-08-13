Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64488 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab1HME64 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 00:58:56 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 09/11] ath9k: Fix noisefloor history update for extn chains
Date: Sat, 13 Aug 2011 10:28:16 +0530
Message-ID: <1313211498-14442-9-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110813_065858_610712_EC732D8D)
In-Reply-To: <1313211498-14442-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1313211498-14442-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Before doing hw reset the current channel's noisefloor readings
are updated into history buffer. The extension chain's readings
are considered only if the current channel was configured in HT40.
While moving from HT40 to HT20, the extn chain's readings are
skipped though the current channel is in ht40. This patch updates
extn chain reading based on channel flag.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/calib.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index ac2da3c..ebaf304 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -82,7 +82,6 @@ static void ath9k_hw_update_nfcal_hist_buffer(struct ath_hw *ah,
 					      int16_t *nfarray)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
-	struct ieee80211_conf *conf = &common->hw->conf;
 	struct ath_nf_limits *limit;
 	struct ath9k_nfcal_hist *h;
 	bool high_nf_mid = false;
@@ -94,7 +93,7 @@ static void ath9k_hw_update_nfcal_hist_buffer(struct ath_hw *ah,
 
 	for (i = 0; i < NUM_NF_READINGS; i++) {
 		if (!(chainmask & (1 << i)) ||
-		    ((i >= AR5416_MAX_CHAINS) && !conf_is_ht40(conf)))
+		    ((i >= AR5416_MAX_CHAINS) && !IS_CHAN_HT40(ah->curchan)))
 			continue;
 
 		h[i].nfCalBuffer[h[i].currIndex] = nfarray[i];
-- 
1.7.6

