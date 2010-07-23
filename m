Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:55125 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343Ab0GWCHu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 22:07:50 -0400
Message-ID: <4C48F974.4050408@openwrt.org>
Date: Fri, 23 Jul 2010 04:07:48 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath9k_hw: fix invalid extension channel noisefloor readings
 in HT20
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the hardware is configured in HT20 mode, noise floor readings for
the extension channel often return invalid values, which keep the
values in the NF history buffer at the hardware-specific maximum limit.
Fix this by discarding the extension channel values when in HT20 mode.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -1508,6 +1508,9 @@ static void ar5008_hw_do_getnf(struct at
 	nf = MS(REG_READ(ah, AR_PHY_CH2_CCA), AR_PHY_CH2_MINCCA_PWR);
 	nfarray[2] = sign_extend(nf, 9);
 
+	if (!IS_CHAN_HT40(ah->curchan))
+		return;
+
 	nf = MS(REG_READ(ah, AR_PHY_EXT_CCA), AR_PHY_EXT_MINCCA_PWR);
 	nfarray[3] = sign_extend(nf, 9);
 
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -477,7 +477,8 @@ static void ar9002_hw_do_getnf(struct at
 	nfarray[0] = sign_extend(nf, 9);
 
 	nf = MS(REG_READ(ah, AR_PHY_EXT_CCA), AR9280_PHY_EXT_MINCCA_PWR);
-	nfarray[3] = sign_extend(nf, 9);
+	if (IS_CHAN_HT40(ah->curchan))
+		nfarray[3] = sign_extend(nf, 9);
 
 	if (AR_SREV_9285(ah) || AR_SREV_9271(ah))
 		return;
@@ -486,7 +487,8 @@ static void ar9002_hw_do_getnf(struct at
 	nfarray[1] = sign_extend(nf, 9);
 
 	nf = MS(REG_READ(ah, AR_PHY_CH1_EXT_CCA), AR9280_PHY_CH1_EXT_MINCCA_PWR);
-	nfarray[4] = sign_extend(nf, 9);
+	if (IS_CHAN_HT40(ah->curchan))
+		nfarray[4] = sign_extend(nf, 9);
 }
 
 static void ar9002_hw_set_nf_limits(struct ath_hw *ah)
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1029,6 +1029,9 @@ static void ar9003_hw_do_getnf(struct at
 	nf = MS(REG_READ(ah, AR_PHY_CCA_2), AR_PHY_CH2_MINCCA_PWR);
 	nfarray[2] = sign_extend(nf, 9);
 
+	if (!IS_CHAN_HT40(ah->curchan))
+		return;
+
 	nf = MS(REG_READ(ah, AR_PHY_EXT_CCA), AR_PHY_EXT_MINCCA_PWR);
 	nfarray[3] = sign_extend(nf, 9);
 
