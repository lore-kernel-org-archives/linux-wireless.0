Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25186 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758110AbZC3KC5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 06:02:57 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2009 03:02:56 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18896.38870.613700.109192@gargle.gargle.HOWL> (sfid-20090330_120318_866124_F01C1A0C)
Date: Mon, 30 Mar 2009 15:28:46 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 13/17] ath9k: Initialize values when setting up the queue parameters
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also fix a small typo.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index d510c4e..6db2131 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -922,7 +922,7 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 		mod_timer(&sc->ani.timer,
 			  jiffies + msecs_to_jiffies(ATH_ANI_POLLINTERVAL));
 	} else {
-		DPRINTF(sc, ATH_DBG_CONFIG, "Bss Info DISSOC\n");
+		DPRINTF(sc, ATH_DBG_CONFIG, "Bss Info DISASSOC\n");
 		sc->curaid = 0;
 	}
 }
@@ -2037,8 +2037,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	 * here except setup the interrupt mask.
 	 */
 	if (ath_startrecv(sc) != 0) {
-		DPRINTF(sc, ATH_DBG_FATAL,
-			"Unable to start recv logic\n");
+		DPRINTF(sc, ATH_DBG_FATAL, "Unable to start recv logic\n");
 		r = -EIO;
 		goto mutex_unlock;
 	}
@@ -2552,6 +2551,8 @@ static int ath9k_conf_tx(struct ieee80211_hw *hw, u16 queue,
 
 	mutex_lock(&sc->mutex);
 
+	memset(&qi, 0, sizeof(struct ath9k_tx_queue_info));
+
 	qi.tqi_aifs = params->aifs;
 	qi.tqi_cwmin = params->cw_min;
 	qi.tqi_cwmax = params->cw_max;
-- 
1.6.2.1

