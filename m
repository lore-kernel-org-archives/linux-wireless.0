Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:60229 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754312Ab1H2Q6G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 12:58:06 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v3] ath9k: fix checks for first subframe delimiter padding
Date: Mon, 29 Aug 2011 18:57:54 +0200
Message-Id: <1314637074-32844-1-git-send-email-nbd@openwrt.org> (sfid-20110829_185811_335649_9A8E4AB3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit "ath9k_hw: Fix exceed transmission burst-time of 5GHz" added
a padding of 60 delimiters on the first subframe to work around an issue
on AR9380, but it lacked the checks to prevent it from being applied to
pre-AR9380, enterprise AR9380 or AR9580+

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/reg.h  |    2 +-
 drivers/net/wireless/ath/ath9k/xmit.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index a3b8bbc..02363c1 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1131,7 +1131,7 @@ enum {
 #define AR_INTR_PRIO_ASYNC_ENABLE (AR_SREV_9340(ah) ? 0x4094 : 0x40d4)
 #define AR_ENT_OTP		  0x40d8
 #define AR_ENT_OTP_CHAIN2_DISABLE               0x00020000
-#define AR_ENT_OTP_MPSD		0x00800000
+#define AR_ENT_OTP_MIN_PKT_SIZE_DISABLE		0x00800000
 
 #define AR_CH0_BB_DPLL1		 0x16180
 #define AR_CH0_BB_DPLL1_REFDIV	 0xF8000000
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 5e29829..f058a96 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -692,7 +692,8 @@ static int ath_compute_num_delims(struct ath_softc *sc, struct ath_atx_tid *tid,
 	 * Add delimiter when using RTS/CTS with aggregation
 	 * and non enterprise AR9003 card
 	 */
-	if (first_subfrm)
+	if (first_subfrm && !AR_SREV_9580_10_OR_LATER(sc->sc_ah) &&
+	    (sc->sc_ah->ent_mode & AR_ENT_OTP_MIN_PKT_SIZE_DISABLE))
 		ndelim = max(ndelim, FIRST_DESC_NDELIMS);
 
 	/*
-- 
1.7.3.2

