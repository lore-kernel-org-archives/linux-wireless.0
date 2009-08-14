Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f196.google.com ([209.85.222.196]:35896 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755886AbZHNGCW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 02:02:22 -0400
Received: by pzk34 with SMTP id 34so909157pzk.4
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2009 23:02:23 -0700 (PDT)
Date: Fri, 14 Aug 2009 11:32:04 +0530
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/5] ath9k: Fix ref power interpolation logic for AR9287
	chipsets.
Message-ID: <20090814060204.GD3541@myhost.users.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/eeprom_9287.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index aeb7f48..9590979 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -374,7 +374,6 @@ static void ar9287_eeprom_get_tx_gain_index(struct ath_hw *ah,
 			    u8 *pCalChans,  u16 availPiers,
 			    int8_t *pPwr)
 {
-	u8 pcdac, i = 0;
 	u16  idxL = 0, idxR = 0, numPiers;
 	bool match;
 	struct chan_centers centers;
@@ -392,17 +391,12 @@ static void ar9287_eeprom_get_tx_gain_index(struct ath_hw *ah,
 			&idxL, &idxR);
 
 	if (match) {
-		pcdac = pRawDatasetOpLoop[idxL].pcdac[0][0];
-		*pPwr = pRawDatasetOpLoop[idxL].pwrPdg[0][0];
+		*pPwr = (int8_t) pRawDatasetOpLoop[idxL].pwrPdg[0][0];
 	} else {
-		pcdac = pRawDatasetOpLoop[idxR].pcdac[0][0];
-		*pPwr = (pRawDatasetOpLoop[idxL].pwrPdg[0][0] +
-				pRawDatasetOpLoop[idxR].pwrPdg[0][0])/2;
+		*pPwr = ((int8_t) pRawDatasetOpLoop[idxL].pwrPdg[0][0] +
+			    (int8_t) pRawDatasetOpLoop[idxR].pwrPdg[0][0])/2;
 	}
 
-	while ((pcdac > ah->originalGain[i]) &&
-			(i < (AR9280_TX_GAIN_TABLE_SIZE - 1)))
-		i++;
 }
 
 static void ar9287_eeprom_olpc_set_pdadcs(struct ath_hw *ah,
-- 
1.6.0.1

