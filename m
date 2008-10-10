Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:62948 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760308AbYJJTXH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 15:23:07 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 10 Oct 2008 12:23:07 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] ath9k: remove nasty FAIL macro from ath9k_hw_reset()
Date: Fri, 10 Oct 2008 05:22:53 -0700
Message-ID: <1223641374-11872-1-git-send-email-lrodriguez@atheros.com> (sfid-20081010_212312_563798_A4C0EE32)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is fucking horribe crap code so nuke it. There I cursed too in a commit log.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/hw.c |   33 +++++++++++++++++++++------------
 1 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 62e44a0..372ae61 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -5867,7 +5867,6 @@ bool ath9k_hw_reset(struct ath_hal *ah,
 		    bool bChannelChange,
 		    int *status)
 {
-#define FAIL(_code)     do { ecode = _code; goto bad; } while (0)
 	u32 saveLedState;
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ath9k_channel *curchan = ah->ah_curchan;
@@ -5889,7 +5888,8 @@ bool ath9k_hw_reset(struct ath_hal *ah,
 		DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
 			 "%s: invalid channel %u/0x%x; no mapping\n",
 			 __func__, chan->channel, chan->channelFlags);
-		FAIL(-EINVAL);
+		ecode = -EINVAL;
+		goto bad;
 	}
 
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
@@ -5930,7 +5930,8 @@ bool ath9k_hw_reset(struct ath_hal *ah,
 	if (!ath9k_hw_chip_reset(ah, chan)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_RESET, "%s: chip reset failed\n",
 			 __func__);
-		FAIL(-EIO);
+		ecode = -EINVAL;
+		goto bad;
 	}
 
 	if (AR_SREV_9280(ah)) {
@@ -5947,8 +5948,10 @@ bool ath9k_hw_reset(struct ath_hal *ah,
 	}
 
 	ecode = ath9k_hw_process_ini(ah, chan, macmode);
-	if (ecode != 0)
+	if (ecode != 0) {
+		ecode = -EINVAL;
 		goto bad;
+	}
 
 	if (IS_CHAN_OFDM(chan) || IS_CHAN_HT(chan))
 		ath9k_hw_set_delta_slope(ah, chan);
@@ -5961,7 +5964,8 @@ bool ath9k_hw_reset(struct ath_hal *ah,
 	if (!ath9k_hw_eeprom_set_board_values(ah, chan)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 			 "%s: error setting board options\n", __func__);
-		FAIL(-EIO);
+		ecode = -EIO;
+		goto bad;
 	}
 
 	ath9k_hw_decrease_chain_power(ah, chan);
@@ -5989,11 +5993,15 @@ bool ath9k_hw_reset(struct ath_hal *ah,
 	REG_WRITE(ah, AR_RSSI_THR, INIT_RSSI_THR);
 
 	if (AR_SREV_9280_10_OR_LATER(ah)) {
-		if (!(ath9k_hw_ar9280_set_channel(ah, chan)))
-			FAIL(-EIO);
+		if (!(ath9k_hw_ar9280_set_channel(ah, chan))) {
+			ecode = -EIO;
+			goto bad;
+		}
 	} else {
-		if (!(ath9k_hw_set_channel(ah, chan)))
-			FAIL(-EIO);
+		if (!(ath9k_hw_set_channel(ah, chan))) {
+			ecode = -EIO;
+			goto bad;
+		}
 	}
 
 	for (i = 0; i < AR_NUM_DCU; i++)
@@ -6027,8 +6035,10 @@ bool ath9k_hw_reset(struct ath_hal *ah,
 
 	ath9k_hw_init_bb(ah, chan);
 
-	if (!ath9k_hw_init_cal(ah, chan))
-		FAIL(-ENODEV);
+	if (!ath9k_hw_init_cal(ah, chan)){
+		ecode = -EIO;;
+		goto bad;
+	}
 
 	rx_chainmask = ahp->ah_rxchainmask;
 	if ((rx_chainmask == 0x5) || (rx_chainmask == 0x3)) {
@@ -6064,7 +6074,6 @@ bad:
 	if (status)
 		*status = ecode;
 	return false;
-#undef FAIL
 }
 
 bool ath9k_hw_phy_disable(struct ath_hal *ah)
-- 
1.5.6.rc2.15.g457bb.dirty

