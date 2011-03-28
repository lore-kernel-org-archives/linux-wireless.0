Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:26380 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753947Ab1C1U5Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2011 16:57:25 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 28 Mar 2011 13:57:01 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <greg@kroah.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Kyungwan Nam <kyungwan.nam@atheros.com>, <stable@kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/9] ath9k: simplify hw reset locking
Date: Mon, 28 Mar 2011 13:57:07 -0700
Message-ID: <1301345835-11401-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1301345835-11401-1-git-send-email-lrodriguez@atheros.com>
References: <1301345835-11401-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 9d94674ab754be0e275120a183670ead435f9c0d upstream

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
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 -
 drivers/net/wireless/ath/ath9k/init.c  |    1 -
 drivers/net/wireless/ath/ath9k/main.c  |   22 ++++++----------------
 3 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 94bd9bc..aaaa100 100644
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
index 91d9b2a..79a0659 100644
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
index cb0b2b9..e946ac3 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -267,19 +267,15 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
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
@@ -890,7 +886,6 @@ void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw)
 		ah->curchan = ath_get_curchannel(sc, sc->hw);
 
 	spin_lock_bh(&sc->rx.pcu_lock);
-	spin_lock_bh(&sc->sc_resetlock);
 	r = ath9k_hw_reset(ah, ah->curchan, ah->caldata, false);
 	if (r) {
 		ath_print(common, ATH_DBG_FATAL,
@@ -898,7 +893,6 @@ void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw)
 			  "reset status %d\n",
 			  channel->center_freq, r);
 	}
-	spin_unlock_bh(&sc->sc_resetlock);
 
 	ath_update_txpow(sc);
 	if (ath_startrecv(sc) != 0) {
@@ -955,7 +949,6 @@ void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw)
 	if (!ah->curchan)
 		ah->curchan = ath_get_curchannel(sc, hw);
 
-	spin_lock_bh(&sc->sc_resetlock);
 	r = ath9k_hw_reset(ah, ah->curchan, ah->caldata, false);
 	if (r) {
 		ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_FATAL,
@@ -963,7 +956,6 @@ void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw)
 			  "reset status %d\n",
 			  channel->center_freq, r);
 	}
-	spin_unlock_bh(&sc->sc_resetlock);
 
 	ath9k_hw_phy_disable(ah);
 
@@ -994,12 +986,10 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
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
@@ -1170,18 +1160,15 @@ static int ath9k_start(struct ieee80211_hw *hw)
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
@@ -1403,14 +1390,17 @@ static void ath9k_stop(struct ieee80211_hw *hw)
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
-- 
1.7.4.15.g7811d

