Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63925 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427Ab2IJDvG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Sep 2012 23:51:06 -0400
From: Sujith Manoharan <c_manoha@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20557.25460.305186.84698@gargle.gargle.HOWL> (sfid-20120910_055148_251303_2E5B5DCB)
Date: Mon, 10 Sep 2012 09:20:12 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/7] ath9k: Set correct max streams for AR9565
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also, set the correct chainmask.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c   | 5 ++++-
 drivers/net/wireless/ath/ath9k/init.c | 2 +-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 6539d2a..063d724 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2407,7 +2407,10 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	if (eeval & AR5416_OPFLAGS_11G)
 		pCap->hw_caps |= ATH9K_HW_CAP_2GHZ;
 
-	if (AR_SREV_9485(ah) || AR_SREV_9285(ah) || AR_SREV_9330(ah))
+	if (AR_SREV_9485(ah) ||
+	    AR_SREV_9285(ah) ||
+	    AR_SREV_9330(ah) ||
+	    AR_SREV_9565(ah))
 		chip_chainmask = 1;
 	else if (AR_SREV_9462(ah))
 		chip_chainmask = 3;
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index f337121..f3ce5ca 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -258,7 +258,7 @@ static void setup_ht_cap(struct ath_softc *sc,
 	ht_info->ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K;
 	ht_info->ampdu_density = IEEE80211_HT_MPDU_DENSITY_8;
 
-	if (AR_SREV_9330(ah) || AR_SREV_9485(ah))
+	if (AR_SREV_9330(ah) || AR_SREV_9485(ah) || AR_SREV_9565(ah))
 		max_streams = 1;
 	else if (AR_SREV_9462(ah))
 		max_streams = 2;
-- 
1.7.12

