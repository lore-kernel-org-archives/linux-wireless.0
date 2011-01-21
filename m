Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40689 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab1AUDE1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 22:04:27 -0500
Received: by iyj18 with SMTP id 18so1248234iyj.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 19:04:27 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19768.63373.791952.897019@gargle.gargle.HOWL>
Date: Fri, 21 Jan 2011 08:33:41 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC/WIP 30/33] ath9k_htc: Fix host RX initialization
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
index 9913ef0..458164f 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -451,20 +451,12 @@ u32 ath9k_htc_calcrxfilter(struct ath9k_htc_priv *priv)
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
1.7.3.5

