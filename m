Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:8024 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752572Ab0CEGc7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Mar 2010 01:32:59 -0500
Received: from vs3002.wh2.ocn.ne.jp (125.206.180.165)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-017705776
	for <linux-wireless@vger.kernel.org>; Fri,  5 Mar 2010 15:32:57 +0900 (JST)
Subject: [PATCH 1/3] ath5k: fix I/Q calibration (for real)
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: 8an@praha12.net, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, mickflemm@gmail.com
Date: Fri, 05 Mar 2010 15:32:55 +0900
Message-ID: <20100305063255.29522.83920.stgit@void>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I/Q calibration was completely broken, resulting in a high number of CRC errors
on received packets. before i could see around 10% to 20% CRC errors, with this
patch they are between 0% and 3%.

1.) the removal of the mask in commit "ath5k: Fix I/Q calibration
(f1cf2dbd0f798b71b1590e7aca6647f2caef1649)" resulted in no mask beeing used
when writing the I/Q values into the register. additional errors in the
calculation of the values (see 2.) resulted too high numbers, exceeding the
masks, so wrong values like 0xfffffffe were written. to be safe we should
always use the bitmask when writing parts of a register.

2.) using a (s32) cast for q_coff is a wrong conversion to signed, since we
convert to a signed value later by substracting 128. this resulted in too low
numbers for Q many times, which were limited to -16 by the boundary check later
on.

3.) checked everything against the HAL sources and took over comments and minor
optimizations from there.

4.) we can't use ENABLE_BITS when we want to write a number (the number can
contain zeros). also always write the correction values first and set ENABLE
bit last, like the HAL does.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/phy.c |   35 +++++++++++++++++++++-------------
 drivers/net/wireless/ath/ath5k/reg.h |    1 +
 2 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 3fa4f4d..4977d22 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1386,38 +1386,47 @@ static int ath5k_hw_rf511x_calibrate(struct ath5k_hw *ah,
 		goto done;
 
 	/* Calibration has finished, get the results and re-run */
+
+	/* workaround against empty results which can apparently happen on 5212 */
 	for (i = 0; i <= 10; i++) {
 		iq_corr = ath5k_hw_reg_read(ah, AR5K_PHY_IQRES_CAL_CORR);
 		i_pwr = ath5k_hw_reg_read(ah, AR5K_PHY_IQRES_CAL_PWR_I);
 		q_pwr = ath5k_hw_reg_read(ah, AR5K_PHY_IQRES_CAL_PWR_Q);
+		ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_CALIBRATE,
+			"iq_corr:%x i_pwr:%x q_pwr:%x", iq_corr, i_pwr, q_pwr);
+		if (i_pwr && q_pwr)
+			break;
 	}
 
 	i_coffd = ((i_pwr >> 1) + (q_pwr >> 1)) >> 7;
 	q_coffd = q_pwr >> 7;
 
-	/* No correction */
-	if (i_coffd == 0 || q_coffd == 0)
+	/* protect against divide by 0 and loss of sign bits */
+	if (i_coffd == 0 || q_coffd < 2)
 		goto done;
 
-	i_coff = ((-iq_corr) / i_coffd);
-
-	/* Boundary check */
+	i_coff = (-iq_corr) / i_coffd;
+	/* Boundary check (signed 6 bit) */
 	if (i_coff > 31)
 		i_coff = 31;
-	if (i_coff < -32)
+	else if (i_coff < -32)
 		i_coff = -32;
 
-	q_coff = (((s32)i_pwr / q_coffd) - 128);
-
-	/* Boundary check */
+	q_coff = (i_pwr / q_coffd) - 128;
+	/* Boundary check (signed 5 bit) */
 	if (q_coff > 15)
 		q_coff = 15;
-	if (q_coff < -16)
+	else if (q_coff < -16)
 		q_coff = -16;
 
-	/* Commit new I/Q value */
-	AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_IQ, AR5K_PHY_IQ_CORR_ENABLE |
-		((u32)q_coff) | ((u32)i_coff << AR5K_PHY_IQ_CORR_Q_I_COFF_S));
+	ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_CALIBRATE,
+			"new I:%d Q:%d (i_coffd:%x q_coffd:%x)",
+			i_coff, q_coff, i_coffd, q_coffd);
+
+	/* Commit new I/Q values (set enable bit last to match HAL sources) */
+	AR5K_REG_WRITE_BITS(ah, AR5K_PHY_IQ, AR5K_PHY_IQ_CORR_Q_I_COFF, i_coff);
+	AR5K_REG_WRITE_BITS(ah, AR5K_PHY_IQ, AR5K_PHY_IQ_CORR_Q_Q_COFF, q_coff);
+	AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_IQ, AR5K_PHY_IQ_CORR_ENABLE);
 
 	/* Re-enable calibration -if we don't we'll commit
 	 * the same values again and again */
diff --git a/drivers/net/wireless/ath/ath5k/reg.h b/drivers/net/wireless/ath/ath5k/reg.h
index 4cb9c5d..1464f89 100644
--- a/drivers/net/wireless/ath/ath5k/reg.h
+++ b/drivers/net/wireless/ath/ath5k/reg.h
@@ -2187,6 +2187,7 @@
  */
 #define	AR5K_PHY_IQ			0x9920			/* Register Address */
 #define	AR5K_PHY_IQ_CORR_Q_Q_COFF	0x0000001f	/* Mask for q correction info */
+#define	AR5K_PHY_IQ_CORR_Q_Q_COFF_S	0
 #define	AR5K_PHY_IQ_CORR_Q_I_COFF	0x000007e0	/* Mask for i correction info */
 #define	AR5K_PHY_IQ_CORR_Q_I_COFF_S	5
 #define	AR5K_PHY_IQ_CORR_ENABLE		0x00000800	/* Enable i/q correction */

