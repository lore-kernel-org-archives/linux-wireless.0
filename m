Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15554 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242Ab2GAOWp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Jul 2012 10:22:45 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v3 1/5] ath9k_hw: start noisefloor calibration after MCI reset
Date: Sun, 1 Jul 2012 19:53:51 +0530
Message-ID: <1341152635-4840-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120701_162248_523432_989C941A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

noisefloor calibration has to be loaded and started after
chip reset completion and restoring chainmask. Right now it is
being started before MCI reset completion on full reset. Fix that.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index ebfb2a3..10a55bc 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1949,9 +1949,6 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (!ath9k_hw_init_cal(ah, chan))
 		return -EIO;
 
-	ath9k_hw_loadnf(ah, chan);
-	ath9k_hw_start_nfcal(ah, true);
-
 	if (ath9k_hw_mci_is_enabled(ah) && ar9003_mci_end_reset(ah, chan, caldata))
 		return -EIO;
 
@@ -2000,6 +1997,9 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (ath9k_hw_mci_is_enabled(ah))
 		ar9003_mci_check_bt(ah);
 
+	ath9k_hw_loadnf(ah, chan);
+	ath9k_hw_start_nfcal(ah, true);
+
 	if (AR_SREV_9300_20_OR_LATER(ah)) {
 		ar9003_hw_bb_watchdog_config(ah);
 
-- 
1.7.11.1

