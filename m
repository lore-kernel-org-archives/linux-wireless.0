Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732Ab1AYNIw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 08:08:52 -0500
Date: Tue, 25 Jan 2011 14:08:40 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Cc: ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>, stable@kernel.org
Subject: [PATCH] ath9k: fix race conditions when stop device
Message-ID: <20110125130735.GA2500@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We do not kill any scheduled tasklets when stopping device, that may
cause usage of resources after free. Moreover we enable interrupts
in tasklet function, so we could potentially end with interrupts
enabled when driver is not ready to receive them.

I think patch should fix Ben's kernel crash from:
http://marc.info/?l=linux-wireless&m=129438358921501&w=2

Cc: stable@kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ath/ath9k/init.c |    5 -----
 drivers/net/wireless/ath/ath9k/main.c |    9 +++++++++
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 767d8b8..b3254a3 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -598,8 +598,6 @@ err_btcoex:
 err_queues:
 	ath9k_hw_deinit(ah);
 err_hw:
-	tasklet_kill(&sc->intr_tq);
-	tasklet_kill(&sc->bcon_tasklet);
 
 	kfree(ah);
 	sc->sc_ah = NULL;
@@ -807,9 +805,6 @@ static void ath9k_deinit_softc(struct ath_softc *sc)
 
 	ath9k_hw_deinit(sc->sc_ah);
 
-	tasklet_kill(&sc->intr_tq);
-	tasklet_kill(&sc->bcon_tasklet);
-
 	kfree(sc->sc_ah);
 	sc->sc_ah = NULL;
 }
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index c03184e..42cfd96 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1320,6 +1320,9 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 
 	spin_lock_bh(&sc->sc_pcu_lock);
 
+	/* prevent tasklets to enable interrupts once we disable them */
+	ah->imask &= ~ATH9K_INT_GLOBAL;
+
 	/* make sure h/w will not generate any interrupt
 	 * before setting the invalid flag. */
 	ath9k_hw_disable_interrupts(ah);
@@ -1337,6 +1340,12 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 
 	spin_unlock_bh(&sc->sc_pcu_lock);
 
+	/* we can now sync irq and kill any running tasklets, since we already
+	 * disabled interrupts and not holding a spin lock */
+	synchronize_irq(sc->irq);
+	tasklet_kill(&sc->intr_tq);
+	tasklet_kill(&sc->bcon_tasklet);
+
 	ath9k_ps_restore(sc);
 
 	sc->ps_idle = true;
-- 
1.7.1


