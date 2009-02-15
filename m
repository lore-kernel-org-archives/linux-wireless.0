Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:4328 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412AbZBORGX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2009 12:06:23 -0500
From: Bob Copeland <me@bobcopeland.com>
To: jirislaby@gmail.com, mickflemm@gmail.com, lrodriguez@atheros.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 1/4] ath5k: don't mask off interrupt bits
Date: Sun, 15 Feb 2009 12:06:09 -0500
Message-Id: <1234717572-10651-1-git-send-email-me@bobcopeland.com> (sfid-20090215_180626_146798_99E0C3F8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since interrupts are already masked by the hardware, there's no need to
discard interrupt bits in the ISR itself.  Also, in ath5k_beacon_config
we mask off a couple of bits without locking, so doing this mask in
software can lead to unhandled beacon timer and beacon miss interrupts.

Changes-licensed-under: 3-Clause-BSD

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath5k/base.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 6837ca9..d930c10 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -2408,16 +2408,9 @@ ath5k_intr(int irq, void *dev_id)
 		return IRQ_NONE;
 
 	do {
-		/*
-		 * Figure out the reason(s) for the interrupt.  Note
-		 * that get_isr returns a pseudo-ISR that may include
-		 * bits we haven't explicitly enabled so we mask the
-		 * value to insure we only process bits we requested.
-		 */
 		ath5k_hw_get_isr(ah, &status);		/* NB: clears IRQ too */
 		ATH5K_DBG(sc, ATH5K_DEBUG_INTR, "status 0x%x/0x%x\n",
 				status, sc->imask);
-		status &= sc->imask; /* discard unasked for bits */
 		if (unlikely(status & AR5K_INT_FATAL)) {
 			/*
 			 * Fatal errors are unrecoverable.
-- 
1.6.0.6


