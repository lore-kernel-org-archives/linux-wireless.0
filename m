Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:4331 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbZBORGX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2009 12:06:23 -0500
From: Bob Copeland <me@bobcopeland.com>
To: jirislaby@gmail.com, mickflemm@gmail.com, lrodriguez@atheros.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org, Bob Copeland <me@bobcopeland.com>,
	stable@kernel.org
Subject: [PATCH 2/4] ath5k: use spin_lock_irqsave for beacon lock
Date: Sun, 15 Feb 2009 12:06:10 -0500
Message-Id: <1234717572-10651-2-git-send-email-me@bobcopeland.com> (sfid-20090215_180629_022299_E3AC06B1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath5k_reset can be called from process context, which in turn can
call ath5k_beacon_config which takes the sc->block spinlock.  Since
it can also be taken in hard irq context, use spin_lock_irqsave
everywhere.  This fixes a potential deadlock in adhoc mode.

Changes-licensed-under: 3-Clause-BSD

Cc: stable@kernel.org
Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath5k/base.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index d930c10..8e5620a 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1700,7 +1700,6 @@ ath5k_check_ibss_tsf(struct ath5k_softc *sc, struct sk_buff *skb,
 	}
 }
 
-
 static void
 ath5k_tasklet_rx(unsigned long data)
 {
@@ -2216,6 +2215,7 @@ static void
 ath5k_beacon_config(struct ath5k_softc *sc)
 {
 	struct ath5k_hw *ah = sc->ah;
+	unsigned long flags;
 
 	ath5k_hw_set_imr(ah, 0);
 	sc->bmisscount = 0;
@@ -2237,9 +2237,9 @@ ath5k_beacon_config(struct ath5k_softc *sc)
 
 		if (sc->opmode == NL80211_IFTYPE_ADHOC) {
 			if (ath5k_hw_hasveol(ah)) {
-				spin_lock(&sc->block);
+				spin_lock_irqsave(&sc->block, flags);
 				ath5k_beacon_send(sc);
-				spin_unlock(&sc->block);
+				spin_unlock_irqrestore(&sc->block, flags);
 			}
 		} else
 			ath5k_beacon_update_timers(sc, -1);
-- 
1.6.0.6


