Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:63985 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661Ab1EFM57 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 08:57:59 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 06 May 2011 05:57:31 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 2/2] ath9k: process TSF out of range before RX
Date: Fri, 6 May 2011 18:27:47 +0530
Message-ID: <1304686667-2864-2-git-send-email-rmanoharan@atheros.com> (sfid-20110506_145802_664122_2411915A)
In-Reply-To: <1304686667-2864-1-git-send-email-rmanoharan@atheros.com>
References: <1304686667-2864-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Processing TSF out of range before RX helps to update beacon
timers so early in the succeeding rx process.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index c171d11..11d9eca 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -689,6 +689,17 @@ void ath9k_tasklet(unsigned long data)
 	    !ath9k_hw_check_alive(ah))
 		ieee80211_queue_work(sc->hw, &sc->hw_check_work);
 
+	if ((status & ATH9K_INT_TSFOOR) && sc->ps_enabled) {
+		/*
+		 * TSF sync does not look correct; remain awake to sync with
+		 * the next Beacon.
+		 */
+		ath_dbg(common, ATH_DBG_PS,
+			"TSFOOR - Sync with next Beacon\n");
+		sc->ps_flags |= PS_WAIT_FOR_BEACON | PS_BEACON_SYNC |
+				PS_TSFOOR_SYNC;
+	}
+
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
 		rxmask = (ATH9K_INT_RXHP | ATH9K_INT_RXLP | ATH9K_INT_RXEOL |
 			  ATH9K_INT_RXORN);
@@ -711,17 +722,6 @@ void ath9k_tasklet(unsigned long data)
 			ath_tx_tasklet(sc);
 	}
 
-	if ((status & ATH9K_INT_TSFOOR) && sc->ps_enabled) {
-		/*
-		 * TSF sync does not look correct; remain awake to sync with
-		 * the next Beacon.
-		 */
-		ath_dbg(common, ATH_DBG_PS,
-			"TSFOOR - Sync with next Beacon\n");
-		sc->ps_flags |= PS_WAIT_FOR_BEACON | PS_BEACON_SYNC |
-				PS_TSFOOR_SYNC;
-	}
-
 	if (ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
 		if (status & ATH9K_INT_GENTIMER)
 			ath_gen_timer_isr(sc->sc_ah);
-- 
1.7.5.1

