Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25150 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbYJ2EuL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 00:50:11 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2008 21:50:11 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18695.60134.39883.499949@gargle.gargle.HOWL> (sfid-20081029_060857_882975_DA2DCECE)
Date: Wed, 29 Oct 2008 10:17:34 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 11/16] ath9k: Remove unnecessary TSF reset
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The TSF is already reset properly via mac80211's callback.
Resetting it in config_interface() is not needed.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index b349e91..d2b53b5 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1239,17 +1239,6 @@ static int ath9k_config_interface(struct ieee80211_hw *hw,
 			/* Set aggregation protection mode parameters */
 			sc->sc_config.ath_aggr_prot = 0;
 
-			/*
-			 * Reset our TSF so that its value is lower than the
-			 * beacon that we are trying to catch.
-			 * Only then hw will update its TSF register with the
-			 * new beacon. Reset the TSF before setting the BSSID
-			 * to avoid allowing in any frames that would update
-			 * our TSF only to have us clear it
-			 * immediately thereafter.
-			 */
-			ath9k_hw_reset_tsf(sc->sc_ah);
-
 			/* Disable BMISS interrupt when we're not associated */
 			ath9k_hw_set_interrupts(sc->sc_ah,
 					sc->sc_imask &
-- 
1.6.0.3

