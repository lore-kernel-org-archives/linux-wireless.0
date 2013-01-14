Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:47495 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756233Ab3ANP45 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2013 10:56:57 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	robert.shade@gmail.com
Subject: [PATCH 3.8] ath9k: disable the tasklet before taking the PCU lock
Date: Mon, 14 Jan 2013 16:56:46 +0100
Message-Id: <1358179006-72370-1-git-send-email-nbd@openwrt.org> (sfid-20130114_165700_653831_64D73CA2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes a reported CPU soft lockup where the tasklet tries to acquire the
lock and blocks while ath_prepare_reset (holding the lock) waits for it
to complete.

Cc: stable@vger.kernel.org
Reported-by: Robert Shade <robert.shade@gmail.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 17a5eec..0fb53d6 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -196,16 +196,12 @@ static bool ath_prepare_reset(struct ath_softc *sc, bool retry_tx)
 	ath9k_debug_samp_bb_mac(sc);
 	ath9k_hw_disable_interrupts(ah);
 
-	tasklet_disable(&sc->intr_tq);
-
 	if (!ath_stoprecv(sc))
 		ret = false;
 
 	if (!ath_drain_all_txq(sc, retry_tx))
 		ret = false;
 
-	tasklet_enable(&sc->intr_tq);
-
 	return ret;
 }
 
@@ -262,6 +258,7 @@ static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan,
 
 	__ath_cancel_work(sc);
 
+	tasklet_disable(&sc->intr_tq);
 	spin_lock_bh(&sc->sc_pcu_lock);
 
 	if (!(sc->hw->conf.flags & IEEE80211_CONF_OFFCHANNEL)) {
@@ -296,6 +293,8 @@ static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan,
 
 out:
 	spin_unlock_bh(&sc->sc_pcu_lock);
+	tasklet_enable(&sc->intr_tq);
+
 	return r;
 }
 
-- 
1.8.0.2

