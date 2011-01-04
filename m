Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52396 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab1ADHrQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 02:47:16 -0500
Received: by yxt3 with SMTP id 3so5535114yxt.19
        for <linux-wireless@vger.kernel.org>; Mon, 03 Jan 2011 23:47:16 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19746.53358.813179.593419@gargle.gargle.HOWL>
Date: Tue, 4 Jan 2011 13:16:54 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: [PATCH 2/5] ath9k_hw: Fix calibration for AR9287 devices
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

AR9287 based devices have issues with ADC gain calibration
which would cause uplink throughput drops in HT40 mode.
Remove ADC gain from the supported calibration algorithms.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_calib.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
index 01880aa..ea2e7d7 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -954,6 +954,9 @@ static void ar9002_hw_init_cal_settings(struct ath_hw *ah)
 				&adc_dc_cal_multi_sample;
 		}
 		ah->supp_cals = ADC_GAIN_CAL | ADC_DC_CAL | IQ_MISMATCH_CAL;
+
+		if (AR_SREV_9287(ah))
+			ah->supp_cals &= ~ADC_GAIN_CAL;
 	}
 }
 
-- 
1.7.3.4

