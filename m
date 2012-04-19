Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39566 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754588Ab2DSTSg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 15:18:36 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH v3 6/8] ath9k_hw: disable Tx IQ calibration on half/quarter channels
Date: Thu, 19 Apr 2012 21:18:27 +0200
Message-Id: <1334863109-95726-6-git-send-email-nbd@openwrt.org> (sfid-20120419_211840_264660_693E5587)
In-Reply-To: <1334863109-95726-5-git-send-email-nbd@openwrt.org>
References: <1334863109-95726-1-git-send-email-nbd@openwrt.org>
 <1334863109-95726-2-git-send-email-nbd@openwrt.org>
 <1334863109-95726-3-git-send-email-nbd@openwrt.org>
 <1334863109-95726-4-git-send-email-nbd@openwrt.org>
 <1334863109-95726-5-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It does not work properly and reduces throughput.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 63089cc..a0387a0 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -1000,10 +1000,12 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 	if (mci && IS_CHAN_2GHZ(chan) && run_agc_cal)
 		ar9003_mci_init_cal_req(ah, &is_reusable);
 
-	txiqcal_done = ar9003_hw_tx_iq_cal_run(ah);
-	REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_DIS);
-	udelay(5);
-	REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_EN);
+	if (!(IS_CHAN_HALF_RATE(chan) || IS_CHAN_QUARTER_RATE(chan))) {
+		txiqcal_done = ar9003_hw_tx_iq_cal_run(ah);
+		REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_DIS);
+		udelay(5);
+		REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_EN);
+	}
 
 skip_tx_iqcal:
 	if (run_agc_cal || !(ah->ah_flags & AH_FASTCC)) {
-- 
1.7.3.2

