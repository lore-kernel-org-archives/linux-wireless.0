Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:43706 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647Ab0I2PPh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 11:15:37 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 1/6] ath9k_htc: remove use of common->ani.noise_floor
Date: Wed, 29 Sep 2010 17:15:26 +0200
Message-Id: <1285773331-73439-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is unused aside from a single redundant debug message

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 5124d04..f12591f 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -760,23 +760,12 @@ void ath9k_ani_work(struct work_struct *work)
 			ath9k_hw_ani_monitor(ah, ah->curchan);
 
 		/* Perform calibration if necessary */
-		if (longcal || shortcal) {
+		if (longcal || shortcal)
 			common->ani.caldone =
 				ath9k_hw_calibrate(ah, ah->curchan,
 						   common->rx_chainmask,
 						   longcal);
 
-			if (longcal)
-				common->ani.noise_floor =
-					ath9k_hw_getchan_noise(ah, ah->curchan);
-
-			ath_print(common, ATH_DBG_ANI,
-				  " calibrate chan %u/%x nf: %d\n",
-				  ah->curchan->channel,
-				  ah->curchan->channelFlags,
-				  common->ani.noise_floor);
-		}
-
 		ath9k_htc_ps_restore(priv);
 	}
 
-- 
1.7.2.2

