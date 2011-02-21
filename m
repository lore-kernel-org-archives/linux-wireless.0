Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47207 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab1BUC2p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Feb 2011 21:28:45 -0500
Received: by yxs7 with SMTP id 7so125077yxs.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Feb 2011 18:28:45 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19809.52191.602985.119813@gargle.gargle.HOWL>
Date: Mon, 21 Feb 2011 07:50:15 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: [PATCH 20/23] ath9k_htc: Fix host RX initialization
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

There is no need to set the BSSID mask or opmode when
initializing RX, they would be set correctly in the HW reset
routine.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 04d8248..426620a 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -433,20 +433,12 @@ u32 ath9k_htc_calcrxfilter(struct ath9k_htc_priv *priv)
 static void ath9k_htc_opmode_init(struct ath9k_htc_priv *priv)
 {
 	struct ath_hw *ah = priv->ah;
-	struct ath_common *common = ath9k_hw_common(ah);
-
 	u32 rfilt, mfilt[2];
 
 	/* configure rx filter */
 	rfilt = ath9k_htc_calcrxfilter(priv);
 	ath9k_hw_setrxfilter(ah, rfilt);
 
-	/* configure bssid mask */
-	ath_hw_setbssidmask(common);
-
-	/* configure operational mode */
-	ath9k_hw_setopmode(ah);
-
 	/* calculate and install multicast filter */
 	mfilt[0] = mfilt[1] = ~0;
 	ath9k_hw_setmcastfilter(ah, mfilt[0], mfilt[1]);
-- 
1.7.4.1

