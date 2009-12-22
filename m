Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2318 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbZLVD1y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2009 22:27:54 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>, stable@kernel.org
Subject: [PATCH] ath5k: fix SWI calibration interrupt storm
Date: Mon, 21 Dec 2009 22:26:48 -0500
Message-Id: <1261452408-4124-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The calibration period is now invoked by triggering a software
interrupt from within the ISR by ath5k_hw_calibration_poll()
instead of via a timer.

However, the calibration interval isn't initialized before
interrupts are enabled, so we can have a situation where an
interrupt occurs before the interval is assigned, so the
interval is actually negative.  As a result, the ISR will
arm a software interrupt to schedule the tasklet, and then
rearm it when the SWI is processed, and so on, leading to a
softlockup at modprobe time.

Move the initialization order around so the calibration interval
is set before interrupts are active.  Another possible fix
is to schedule the tasklet directly from the poll routine,
but I think there are additional plans for the SWI.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
Cc: stable@kernel.org
---
 drivers/net/wireless/ath/ath5k/base.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index a4c086f..8e1dab4 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2381,6 +2381,9 @@ ath5k_init(struct ath5k_softc *sc)
 	 */
 	ath5k_stop_locked(sc);
 
+	/* Set PHY calibration interval */
+	ah->ah_cal_intval = ath5k_calinterval;
+
 	/*
 	 * The basic interface to setting the hardware in a good
 	 * state is ``reset''.  On return the hardware is known to
@@ -2408,10 +2411,6 @@ ath5k_init(struct ath5k_softc *sc)
 
 	/* Set ack to be sent at low bit-rates */
 	ath5k_hw_set_ack_bitrate_high(ah, false);
-
-	/* Set PHY calibration inteval */
-	ah->ah_cal_intval = ath5k_calinterval;
-
 	ret = 0;
 done:
 	mmiowb();
-- 
1.6.3.3


