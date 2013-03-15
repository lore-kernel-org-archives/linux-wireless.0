Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44392 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754256Ab3CONxl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Mar 2013 09:53:41 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Wojciech.Dubowik@neratec.com,
	mcgrof@qca.qualcomm.com
Subject: [PATCH 3.9] ath9k_hw: revert chainmask to user configuration after calibration
Date: Fri, 15 Mar 2013 14:53:31 +0100
Message-Id: <1363355611-10426-1-git-send-email-nbd@openwrt.org> (sfid-20130315_145345_669966_793489C9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit 'ath9k_hw: fix calibration issues on chainmask that don't
include chain 0' changed the hardware chainmask to the chip chainmask
for the duration of the calibration, but the revert to user
configuration in the reset path runs too early.

That causes some issues with limiting the number of antennas (including
spurious failure in hardware-generated packets).

Fix this by reverting the chainmask after the essential parts of the
calibration that need the workaround, and before NF calibration is run.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Reported-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Tested-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Cc: stable@vger.kernel.org
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 4cc1394..f76c3ca 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -1023,6 +1023,7 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 					  AR_PHY_AGC_CONTROL_FLTR_CAL   |
 					  AR_PHY_AGC_CONTROL_PKDET_CAL;
 
+	/* Use chip chainmask only for calibration */
 	ar9003_hw_set_chain_masks(ah, ah->caps.rx_chainmask, ah->caps.tx_chainmask);
 
 	if (rtt) {
@@ -1150,6 +1151,9 @@ skip_tx_iqcal:
 		ar9003_hw_rtt_disable(ah);
 	}
 
+	/* Revert chainmask to runtime parameters */
+	ar9003_hw_set_chain_masks(ah, ah->rxchainmask, ah->txchainmask);
+
 	/* Initialize list pointers */
 	ah->cal_list = ah->cal_list_last = ah->cal_list_curr = NULL;
 
-- 
1.8.0.2

