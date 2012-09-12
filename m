Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32776 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab2ILGyA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Sep 2012 02:54:00 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 1/5] ath9k_hw: move 2g5g switch before nfcal start
Date: Wed, 12 Sep 2012 12:23:49 +0530
Message-ID: <1347432833-10343-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120912_085437_680052_A2D0FCF4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During fast channel change, perform 2g5g_switch before starting
noisefloor calibration to avoid nfload timeout.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 40f57aa..e58e79d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1733,12 +1733,12 @@ static int ath9k_hw_do_fastcc(struct ath_hw *ah, struct ath9k_channel *chan)
 	if (!ret)
 		goto fail;
 
-	ath9k_hw_loadnf(ah, ah->curchan);
-	ath9k_hw_start_nfcal(ah, true);
-
 	if (ath9k_hw_mci_is_enabled(ah))
 		ar9003_mci_2g5g_switch(ah, false);
 
+	ath9k_hw_loadnf(ah, ah->curchan);
+	ath9k_hw_start_nfcal(ah, true);
+
 	if (AR_SREV_9271(ah))
 		ar9002_hw_load_ani_reg(ah, chan);
 
-- 
1.7.12

