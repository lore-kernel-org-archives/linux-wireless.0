Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:19616 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755976Ab0JZW1a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 18:27:30 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 26 Oct 2010 15:27:19 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <greearb@candelatech.com>,
	<kyungwan.nam@atheros.com>, <amod.bodas@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, <stable@kernel.org>
Subject: [PATCH 1/3] ath9k: simplify hw reset locking
Date: Tue, 26 Oct 2010 15:27:23 -0700
Message-ID: <1288132045-4718-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1288132045-4718-1-git-send-email-lrodriguez@atheros.com>
References: <1288132045-4718-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The new PCU lock is better placed so we can just contend
against that when trying to reset hardware.

This is part of a series of patches which fix stopping
TX DMA completley when requested on the driver.
For more details about this issue refer to this thread:

http://marc.info/?l=linux-wireless&m=128629803703756&w=2

Tested-by:  Ben Greear <greearb@candelatech.com>
Cc: Kyungwan Nam <kyungwan.nam@atheros.com>
Cc: stable@kernel.org
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 -
 drivers/net/wireless/ath/ath9k/init.c  |    1 -
 drivers/net/wireless/ath/ath9k/main.c  |   22 ++++++----------------
 drivers/net/wireless/ath/ath9k/xmit.c  |    4 ++--
 4 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 9b8e7e3..1b64a30 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -600,7 +600,6 @@ struct ath_softc {
 	struct ath_hw *sc_ah;
 	void __iomem *mem;
 	int irq;
-	spinlock_t sc_resetlock;
 	spinlock_t sc_serial_rw;
 	spinlock_t sc_pm_lock;
 	struct mutex mutex;
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 95b41db..081179d 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -580,7 +580,6 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 	spin_lock_init(&common->cc_lock);
 
 	spin_lock_init(&sc->wiphy_lock);
-	spin_lock_init(&sc->sc_resetlock);
 	spin_lock_init(&sc->sc_serial_rw);
 	spin_lock_init(&sc->sc_pm_lock);
 	mutex_init(&sc->mutex);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index b52f1cf..5e036af 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -262,19 +262,15 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 		  channel->center_freq, conf_is_ht40(conf),
 		  fastcc);
 
-	spin_lock_bh(&sc->sc_resetlock);
-
 	r = ath9k_hw_reset(ah, hchan, caldata, fastcc);
 	if (r) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to reset channel (%u MHz), "
 			  "reset status %d\n",
 			  channel->center_freq, r);
-		spin_unlock_bh(&sc->sc_resetlock);
 		spin_unlock_bh(&sc->rx.pcu_lock);
 		goto ps_restore;
 	}
-	spin_unlock_bh(&sc->sc_resetlock);
 
 	if (ath_startrecv(sc) != 0) {
 		ath_print(common, ATH_DBG_FATAL,
@@ -884,7 +880,6 @@ void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw)
 		ah->curchan = ath_get_curchannel(sc, sc->hw);
 
 	spin_lock_bh(&sc->rx.pcu_lock);
-	spin_lock_bh(&sc->sc_resetlock);
 	r = ath9k_hw_reset(ah, ah->curchan, ah->caldata, false);
 	if (r) {
 		ath_print(common, ATH_DBG_FATAL,
@@ -892,7 +887,6 @@ void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw)
 			  "reset status %d\n",
 			  channel->center_freq, r);
 	}
-	spin_unlock_bh(&sc->sc_resetlock);
 
 	ath_update_txpow(sc);
 	if (ath_startrecv(sc) != 0) {
@@ -949,7 +943,6 @@ void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw)
 	if (!ah->curchan)
 		ah->curchan = ath_get_curchannel(sc, hw);
 
-	spin_lock_bh(&sc->sc_resetlock);
 	r = ath9k_hw_reset(ah, ah->curchan, ah->caldata, false);
 	if (r) {
 		ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_FATAL,
@@ -957,7 +950,6 @@ void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw)
 			  "reset status %d\n",
 			  channel->center_freq, r);
 	}
-	spin_unlock_bh(&sc->sc_resetlock);
 
 	ath9k_hw_phy_disable(ah);
 
@@ -988,12 +980,10 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 	ath_stoprecv(sc);
 	ath_flushrecv(sc);
 
-	spin_lock_bh(&sc->sc_resetlock);
 	r = ath9k_hw_reset(ah, sc->sc_ah->curchan, ah->caldata, false);
 	if (r)
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to reset hardware; reset status %d\n", r);
-	spin_unlock_bh(&sc->sc_resetlock);
 
 	if (ath_startrecv(sc) != 0)
 		ath_print(common, ATH_DBG_FATAL,
@@ -1164,18 +1154,15 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	 * and then setup of the interrupt mask.
 	 */
 	spin_lock_bh(&sc->rx.pcu_lock);
-	spin_lock_bh(&sc->sc_resetlock);
 	r = ath9k_hw_reset(ah, init_channel, ah->caldata, false);
 	if (r) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to reset hardware; reset status %d "
 			  "(freq %u MHz)\n", r,
 			  curchan->center_freq);
-		spin_unlock_bh(&sc->sc_resetlock);
 		spin_unlock_bh(&sc->rx.pcu_lock);
 		goto mutex_unlock;
 	}
-	spin_unlock_bh(&sc->sc_resetlock);
 
 	/*
 	 * This is needed only to setup initial state
@@ -1396,14 +1383,17 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	 * before setting the invalid flag. */
 	ath9k_hw_set_interrupts(ah, 0);
 
-	spin_lock_bh(&sc->rx.pcu_lock);
 	if (!(sc->sc_flags & SC_OP_INVALID)) {
 		ath_drain_all_txq(sc, false);
+		spin_lock_bh(&sc->rx.pcu_lock);
 		ath_stoprecv(sc);
 		ath9k_hw_phy_disable(ah);
-	} else
+		spin_unlock_bh(&sc->rx.pcu_lock);
+	} else {
+		spin_lock_bh(&sc->rx.pcu_lock);
 		sc->rx.rxlink = NULL;
-	spin_unlock_bh(&sc->rx.pcu_lock);
+		spin_unlock_bh(&sc->rx.pcu_lock);
+	}
 
 	/* disable HAL and put h/w to sleep */
 	ath9k_hw_disable(ah);
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 30ef2df..6c0de85 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1148,13 +1148,13 @@ void ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
 		ath_print(common, ATH_DBG_FATAL,
 			  "Failed to stop TX DMA. Resetting hardware!\n");
 
-		spin_lock_bh(&sc->sc_resetlock);
+		spin_lock_bh(&sc->rx.pcu_lock);
 		r = ath9k_hw_reset(ah, sc->sc_ah->curchan, ah->caldata, false);
 		if (r)
 			ath_print(common, ATH_DBG_FATAL,
 				  "Unable to reset hardware; reset status %d\n",
 				  r);
-		spin_unlock_bh(&sc->sc_resetlock);
+		spin_unlock_bh(&sc->rx.pcu_lock);
 	}
 
 	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
-- 
1.7.3.2.90.gd4c43

