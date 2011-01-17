Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:38763 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911Ab1AQJw2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 04:52:28 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 17 Jan 2011 01:52:10 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: Rajkumar Manoharan <rmanoharan@atheros.com>, <stable@kernel.org>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH] ath9k_hw: do PA offset calibration only on longcal interval
Date: Mon, 17 Jan 2011 15:21:40 +0530
Message-ID: <1295257900-4344-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The power detector adc offset calibration has to be done
on 4 minutes interval (longcal * pa_skip_count). But the commit
"ath9k_hw: fix a noise floor calibration related race condition"
makes the PA calibration executed more frequently beased on
nfcal_pending value. Running PAOffset calibration lesser than
longcal interval doesn't help anything and the worse part is that
it causes NF load timeouts and RX deaf conditions.

In a very noisy environment, where the distance b/w AP & station
is ~10 meter and running a downlink udp traffic with frequent
background scan causes "Timeout while waiting for nf to load:
AR_PHY_AGC_CONTROL=0x40d1a" and moves the chip into deaf state.
This issue was originaly reported in Android platform where
the network-manager application does bgscan more frequently
on AR9271 chips. (AR9285 family usb device).

Cc: stable@kernel.org
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_calib.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
index 14d7d2a..76388c6 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -679,10 +679,6 @@ static bool ar9002_hw_calibrate(struct ath_hw *ah,
 
 	/* Do NF cal only at longer intervals */
 	if (longcal || nfcal_pending) {
-		/* Do periodic PAOffset Cal */
-		ar9002_hw_pa_cal(ah, false);
-		ar9002_hw_olc_temp_compensation(ah);
-
 		/*
 		 * Get the value from the previous NF cal and update
 		 * history buffer.
@@ -697,8 +693,12 @@ static bool ar9002_hw_calibrate(struct ath_hw *ah,
 			ath9k_hw_loadnf(ah, ah->curchan);
 		}
 
-		if (longcal)
+		if (longcal) {
 			ath9k_hw_start_nfcal(ah, false);
+			/* Do periodic PAOffset Cal */
+			ar9002_hw_pa_cal(ah, false);
+			ar9002_hw_olc_temp_compensation(ah);
+		}
 	}
 
 	return iscaldone;
-- 
1.7.3.5

