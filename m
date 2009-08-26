Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:13447 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756608AbZHZDJR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2009 23:09:17 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2009 20:09:19 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19092.42880.790223.334421@gargle.gargle.HOWL>
Date: Wed, 26 Aug 2009 08:39:52 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/4] ath9k: Handle PA cal usage properly
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PA Calibration is not needed for high power solutions.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/calib.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index f9de16c..3234995 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -879,6 +879,11 @@ static inline void ath9k_hw_9285_pa_cal(struct ath_hw *ah, bool is_reset)
 
 	DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE, "Running PA Calibration\n");
 
+	/* PA CAL is not needed for high power solution */
+	if (ah->eep_ops->get_eeprom(ah, EEP_TXGAIN_TYPE) ==
+	    AR5416_EEP_TXGAIN_HIGH_POWER)
+		return;
+
 	if (AR_SREV_9285_11(ah)) {
 		REG_WRITE(ah, AR9285_AN_TOP4, (AR9285_AN_TOP4_DEFAULT | 0x14));
 		udelay(10);
-- 
1.6.4

