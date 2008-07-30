Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44019 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757425AbYG3Tre (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 15:47:34 -0400
Message-Id: <200807301946.m6UJkKPm012986@imap1.linux-foundation.org> (sfid-20080730_214756_484541_AB175929)
Subject: [patch 1/4] ath5k: mask out unneeded interrupts
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org,
	jirislaby@gmail.com, mcgrof@gmail.com, me@bobcopeland.com,
	mickflemm@gmail.com
From: akpm@linux-foundation.org
Date: Wed, 30 Jul 2008 12:46:20 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jiri Slaby <jirislaby@gmail.com>

Mask out previously demanded interrupt flags because we set new ones. 
Don't allow mixing them after switch from sta to ibss and vice versa.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: Luis R. Rodriguez <mcgrof@gmail.com>
Cc: "Bob Copeland" <me@bobcopeland.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ath5k/base.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/net/wireless/ath5k/base.c~ath5k-mask-out-unneeded-interrupts drivers/net/wireless/ath5k/base.c
--- a/drivers/net/wireless/ath5k/base.c~ath5k-mask-out-unneeded-interrupts
+++ a/drivers/net/wireless/ath5k/base.c
@@ -2170,6 +2170,7 @@ ath5k_beacon_config(struct ath5k_softc *
 
 	ath5k_hw_set_intr(ah, 0);
 	sc->bmisscount = 0;
+	sc->imask &= ~(AR5K_INT_BMISS | AR5K_INT_SWBA);
 
 	if (sc->opmode == IEEE80211_IF_TYPE_STA) {
 		sc->imask |= AR5K_INT_BMISS;
_
