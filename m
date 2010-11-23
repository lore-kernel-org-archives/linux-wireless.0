Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41988 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab0KWTC2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 14:02:28 -0500
Received: by ewy5 with SMTP id 5so2650325ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 11:02:27 -0800 (PST)
Date: Tue, 23 Nov 2010 21:02:20 +0200
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org
Subject: [PATCH 11/30] ath5k: Small cleanup on tweak_initvals
Message-ID: <20101123190220.GK4303@makis.mantri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Now that we properly set rx/tx latencies for AR5311 remove
 that old buggy part of code left inside ath5k_hw_tweak_initval_settings
 that was never executed (you can't have an RF5112 radio on a mac older
 than AR5212). Also use a magic value for 5311 PHY_SCAL value.

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/reg.h   |    1 +
 drivers/net/wireless/ath/ath5k/reset.c |   18 +++---------------
 2 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/reg.h b/drivers/net/wireless/ath/ath5k/reg.h
index ca79ecd..4d61061 100644
--- a/drivers/net/wireless/ath/ath5k/reg.h
+++ b/drivers/net/wireless/ath/ath5k/reg.h
@@ -2058,6 +2058,7 @@
 
 #define AR5K_PHY_SCAL			0x9878
 #define AR5K_PHY_SCAL_32MHZ		0x0000000e
+#define	AR5K_PHY_SCAL_32MHZ_5311	0x00000008
 #define	AR5K_PHY_SCAL_32MHZ_2417	0x0000000a
 #define	AR5K_PHY_SCAL_32MHZ_HB63	0x00000032
 
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index a013bdf..f9457f4 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -730,24 +730,12 @@ static void ath5k_hw_tweak_initval_settings(struct ath5k_hw *ah,
 		ath5k_hw_reg_write(ah, data, AR5K_PHY_FRAME_CTL);
 	}
 
-	if ((ah->ah_radio == AR5K_RF5112) &&
-	(ah->ah_mac_srev < AR5K_SREV_AR5211)) {
-		u32 usec_reg;
-		/* 5311 has different tx/rx latency masks
-		 * from 5211, since we deal 5311 the same
-		 * as 5211 when setting initvals, shift
-		 * values here to their proper locations */
-		usec_reg = ath5k_hw_reg_read(ah, AR5K_USEC_5211);
-		ath5k_hw_reg_write(ah, usec_reg & (AR5K_USEC_1 |
-				AR5K_USEC_32 |
-				AR5K_USEC_TX_LATENCY_5211 |
-				AR5K_REG_SM(29,
-				AR5K_USEC_RX_LATENCY_5210)),
-				AR5K_USEC_5211);
+	if (ah->ah_mac_srev < AR5K_SREV_AR5211) {
 		/* Clear QCU/DCU clock gating register */
 		ath5k_hw_reg_write(ah, 0, AR5K_QCUDCU_CLKGT);
 		/* Set DAC/ADC delays */
-		ath5k_hw_reg_write(ah, 0x08, AR5K_PHY_SCAL);
+		ath5k_hw_reg_write(ah, AR5K_PHY_SCAL_32MHZ_5311,
+						AR5K_PHY_SCAL);
 		/* Enable PCU FIFO corruption ECO */
 		AR5K_REG_ENABLE_BITS(ah, AR5K_DIAG_SW_5211,
 					AR5K_DIAG_SW_ECO_ENABLE);
