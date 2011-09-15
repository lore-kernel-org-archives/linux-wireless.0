Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6778 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933125Ab1IONc0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 09:32:26 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 1/2] ath9k: load noise floor from history after the full chip reset
Date: Thu, 15 Sep 2011 19:02:53 +0530
Message-ID: <1316093574-8188-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110915_153230_328010_181CCF4E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently during the full reset, the nf calibration is always
restarted from the defaults. The noise floor history buffers are
never be used again after the scan and ath reset. This patch
ensures that nf histories are always be used that helps to
improve the signal quality on congested environment

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_calib.c |    1 +
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
index 2d394af..e0ab065 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -869,6 +869,7 @@ static bool ar9002_hw_init_cal(struct ath_hw *ah, struct ath9k_channel *chan)
 	ar9002_hw_pa_cal(ah, true);
 
 	/* Do NF Calibration after DC offset and other calibrations */
+	ath9k_hw_loadnf(ah, chan);
 	ath9k_hw_start_nfcal(ah, true);
 
 	if (ah->caldata)
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 695d9d3..e4b1a83 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -885,6 +885,7 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 	if (txiqcal_done)
 		ar9003_hw_tx_iq_cal_post_proc(ah);
 
+	ath9k_hw_loadnf(ah, chan);
 	ath9k_hw_start_nfcal(ah, true);
 
 	/* Initialize list pointers */
-- 
1.7.6.1

