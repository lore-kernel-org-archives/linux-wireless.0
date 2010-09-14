Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57149 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab0INOQ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 10:16:56 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, stable@kernel.org,
	Paul Stewart <pstew@google.com>,
	Amod Bodas <amod.bodas@atheros.com>
Subject: [PATCH 02/10] ath9k: fix regression on beacon loss after bgscan
Date: Tue, 14 Sep 2010 10:16:55 -0400
Message-Id: <1284473815-9999-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we return to the home channel we were never reseting our beacon
timers, this was casued by the fact that the scanning flag was still
on even after we returned to our home channel. There are also other
reasons why we would get a reset and if we are not off channel
we always need to resynch our beacon timers, because a reset will
clear them.

For more details refer to:

http://code.google.com/p/chromium-os/issues/detail?id=5715

This bug is a regression introduced on 2.6.36. The order of the
changes are as follows:

5ee08656 - Sat Jul 31 - ath9k: prevent calibration during off-channel activity
a0daa0e7 - Tue Jul 27 - Revert "mac80211: fix sw scan bracketing"
543708be - Fri Jun 18 - mac80211: fix sw scan bracketing

mcgrof@tux ~/linux-2.6-allstable (git::master)$ git describe \
        --contains 5ee0865615f65f84e6ee9174771a6716c29e08e1
v2.6.36-rc1~43^2~34^2~22

mcgrof@tux ~/linux-2.6-allstable (git::master)$ git describe \
        --contains a0daa0e7592ada797d6835f11529097aabc27ad2
v2.6.36-rc1~571^2~64^2~13

mcgrof@tux ~/linux-2.6-allstable (git::master)$ git describe \
        --contains 543708be320d7df692d24b349ca01a947b340764
v2.6.36-rc1~571^2~107^2~187

So 5ee08656 would have worked if a0daa0e7 was not committed but
it was so this means 5ee08656 was broken since it assumed that
when we were in the channel change routine the scan flag would
be lifted. As it turns out the scan flag will be set when we
are already on the home channel.

This will need to be considered for our solution on this on
kernels >= 2.6.37.

This patch has stable fixes which apply down to [2.6.36+]

Cc: stable@kernel.org
Cc: Paul Stewart <pstew@google.com>
Cc: Amod Bodas <amod.bodas@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index ba029b2..e349619 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -258,9 +258,11 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 	if (!(sc->sc_flags & (SC_OP_OFFCHANNEL | SC_OP_SCANNING))) {
 		ath_start_ani(common);
 		ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work, 0);
-		ath_beacon_config(sc, NULL);
 	}
 
+	if (!(sc->sc_flags & (SC_OP_OFFCHANNEL)))
+		ath_beacon_config(sc, NULL);
+
  ps_restore:
 	ath9k_ps_restore(sc);
 	return r;
@@ -957,7 +959,7 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 
 	ath_update_txpow(sc);
 
-	if (sc->sc_flags & SC_OP_BEACONS)
+	if ((sc->sc_flags & SC_OP_BEACONS) || !(sc->sc_flags & (SC_OP_OFFCHANNEL)))
 		ath_beacon_config(sc, NULL);	/* restart beacons */
 
 	ath9k_hw_set_interrupts(ah, ah->imask);
-- 
1.7.0.4

