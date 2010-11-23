Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37556 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532Ab0KWT0V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 14:26:21 -0500
Received: by ewy5 with SMTP id 5so2669950ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 11:26:20 -0800 (PST)
Date: Tue, 23 Nov 2010 21:26:13 +0200
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org
Subject: [PATCH 19/30] ath5k: Tweak power detector delays on RF5111/RF5112
Message-ID: <20101123192613.GS4303@makis.mantri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Tweak power detector delays on AR5111/AR5112 when
 using half/quarter modes.

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/phy.c |   32 ++++++++++++++++++++++++++++++--
 1 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 706fc46..6913a52 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -851,7 +851,23 @@ static int ath5k_hw_rfregs_init(struct ath5k_hw *ah,
 		ath5k_hw_rfb_op(ah, rf_regs, ee->ee_xpd[ee_mode],
 						AR5K_RF_PLO_SEL, true);
 
-		/* TODO: Half/quarter channel support */
+		/* Tweak power detectors for half/quarter rate support */
+		if (ah->ah_bwmode == AR5K_BWMODE_5MHZ ||
+		ah->ah_bwmode == AR5K_BWMODE_10MHZ) {
+			u8 wait_i;
+
+			ath5k_hw_rfb_op(ah, rf_regs, 0x1f,
+						AR5K_RF_WAIT_S, true);
+
+			wait_i = (ah->ah_bwmode == AR5K_BWMODE_5MHZ) ?
+							0x1f : 0x10;
+
+			ath5k_hw_rfb_op(ah, rf_regs, wait_i,
+						AR5K_RF_WAIT_I, true);
+			ath5k_hw_rfb_op(ah, rf_regs, 3,
+						AR5K_RF_MAX_TIME, true);
+
+		}
 	}
 
 	if (ah->ah_radio == AR5K_RF5112) {
@@ -949,8 +965,20 @@ static int ath5k_hw_rfregs_init(struct ath5k_hw *ah,
 		ath5k_hw_rfb_op(ah, rf_regs, ee->ee_i_gain[ee_mode],
 						AR5K_RF_GAIN_I, true);
 
-		/* TODO: Half/quarter channel support */
+		/* Tweak power detector for half/quarter rates */
+		if (ah->ah_bwmode == AR5K_BWMODE_5MHZ ||
+		ah->ah_bwmode == AR5K_BWMODE_10MHZ) {
+			u8 pd_delay;
 
+			pd_delay = (ah->ah_bwmode == AR5K_BWMODE_5MHZ) ?
+							0xf : 0x8;
+
+			ath5k_hw_rfb_op(ah, rf_regs, pd_delay,
+						AR5K_RF_PD_PERIOD_A, true);
+			ath5k_hw_rfb_op(ah, rf_regs, 0xf,
+						AR5K_RF_PD_DELAY_A, true);
+
+		}
 	}
 
 	if (ah->ah_radio == AR5K_RF5413 &&
