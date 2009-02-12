Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:36317 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755790AbZBLEkd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 23:40:33 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2009 20:40:32 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18835.42851.30424.42167@gargle.gargle.HOWL> (sfid-20090212_054036_223315_612D7097)
Date: Thu, 12 Feb 2009 10:06:51 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 6/8] ath9k: Fix bug in disabling MIB counters
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a bug in ANI, where the MIB counters were
being cleared before the stats were updated.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/ani.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ani.c b/drivers/net/wireless/ath9k/ani.c
index d4df7e6..a39eb76 100644
--- a/drivers/net/wireless/ath9k/ani.c
+++ b/drivers/net/wireless/ath9k/ani.c
@@ -642,14 +642,13 @@ void ath9k_enable_mib_counters(struct ath_hw *ah)
 	REG_WRITE(ah, AR_PHY_ERR_MASK_2, AR_PHY_ERR_CCK_TIMING);
 }
 
+/* Freeze the MIB counters, get the stats and then clear them */
 void ath9k_hw_disable_mib_counters(struct ath_hw *ah)
 {
 	DPRINTF(ah->ah_sc, ATH_DBG_ANI, "Disable MIB counters\n");
-
-	REG_WRITE(ah, AR_MIBC, AR_MIBC_FMC | AR_MIBC_CMC);
-
+	REG_WRITE(ah, AR_MIBC, AR_MIBC_FMC);
 	ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
-
+	REG_WRITE(ah, AR_MIBC, AR_MIBC_CMC);
 	REG_WRITE(ah, AR_FILT_OFDM, 0);
 	REG_WRITE(ah, AR_FILT_CCK, 0);
 }
-- 
1.6.1

