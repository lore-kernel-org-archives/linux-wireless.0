Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45634 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014Ab1H2IGW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 04:06:22 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com, adrian@freebsd.org
Subject: [PATCH 3.1] ath9k_hw: fix calibration on 5 ghz
Date: Mon, 29 Aug 2011 10:06:14 +0200
Message-Id: <1314605174-66206-1-git-send-email-nbd@openwrt.org> (sfid-20110829_100626_811849_29C84D06)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ADC calibrations cannot run on 5 GHz with fast clock enabled. They
need to be disabled, otherwise they'll hang and IQ mismatch calibration
will not be run either.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Reported-by: Adrian Chadd <adrian@freebsd.org>
Cc: stable@kernel.org
---
 drivers/net/wireless/ath/ath9k/ar9002_calib.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
index 2d4c091..2d394af 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -41,7 +41,8 @@ static bool ar9002_hw_is_cal_supported(struct ath_hw *ah,
 	case ADC_DC_CAL:
 		/* Run ADC Gain Cal for non-CCK & non 2GHz-HT20 only */
 		if (!IS_CHAN_B(chan) &&
-		    !(IS_CHAN_2GHZ(chan) && IS_CHAN_HT20(chan)))
+		    !((IS_CHAN_2GHZ(chan) || IS_CHAN_A_FAST_CLOCK(ah, chan)) &&
+		      IS_CHAN_HT20(chan)))
 			supported = true;
 		break;
 	}
-- 
1.7.3.2

