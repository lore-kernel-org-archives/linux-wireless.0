Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:17690 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754608Ab0I2JWU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 05:22:20 -0400
Received: from vs3002.wh2.ocn.ne.jp (125.206.180.165)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0906822136
	for <linux-wireless@vger.kernel.org>; Wed, 29 Sep 2010 18:22:18 +0900 (JST)
Subject: [PATCH] ath5k: vif adhoc fixup
To: greearb@candelatech.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 29 Sep 2010 18:22:22 +0900
Message-ID: <20100929092221.12160.62425.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi ben!

i made these changes on top of your v7 patch, please tell me what you think!
and feel free to merge the changes into your patch, if you agree with them.

use staggered beacons only when multiple AP interfaces are configured.
this fixes single-interface ad-hoc mode and also reduces the impact of the vif
changes for the more common single-interface AP setups (beacon interval and
SWBA interrupts).

btw: we can always only have one ad-hoc interface. mac80211 makes sure of that,
because it's impossible to synchronize to more than one TSF. this is the most
important "feature" of ad-hoc, i think: it has to (and will) adapt the TSF of
beacons in the same IBSS. that means the local TSF can make jumps (into the
future only).

i'm not sure where that leaves us concerning one ad-hoc interface + multiple AP
interfaces. to allow the TSF updates we would have to keep the HW opmode in
ad-hoc though. would VAPs still work that way? also how about stations? aren't
they supposed to adapt the TSF of their AP? as i see the HW is in AP mode if
there is at least one AP, so that does not happen if there is an AP interface
too. how would multiple STA sync their TSF if they are connected to different
AP with different TSF? but maybe the TSF does not matter as much for STA as it
does for IBSS mode... if that is the case we could allow one adhoc + multiple
STA interfaces and drive the HW in adhoc mode.

oh, another thing: ad-hoc interfaces could potentially move to another channel
(if it is not set to a fixed channel). i quess in most cases a fixed channel
will be used, but it wouldn't be good for the other STAs if that happens. but
thinking about it - doesn't the same apply with multiple STA interfaces? how
do you avoid one STA from changing to another channel?

so... many questions about the coexistence of adhoc and other interfaces... and
honestly, i don't care much about adhoc + other vif at this time. as long as
one adhoc interface works, i'm fine.

btw: i think we should cleanup the beacon code, but i might do that after your
vif changes got merged...

bruno
---
 drivers/net/wireless/ath/ath5k/base.c |   30 ++++++++++++++----------------
 1 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 499a906..3ed9935 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1857,9 +1857,6 @@ ath5k_beacon_send(struct ath5k_softc *sc)
 	struct ath5k_vif *avf;
 	struct ath5k_buf *bf;
 	struct sk_buff *skb;
-	u64 tsf;
-	u32 tsftu;
-	int slot;
 
 	ATH5K_DBG_UNLIMIT(sc, ATH5K_DEBUG_BEACON, "in beacon_send\n");
 
@@ -1891,20 +1888,21 @@ ath5k_beacon_send(struct ath5k_softc *sc)
 		sc->bmisscount = 0;
 	}
 
-	tsf = ath5k_hw_get_tsf64(ah);
-	tsftu = TSF_TO_TU(tsf);
-	slot = ((tsftu % sc->bintval) * ATH_BCBUF) / sc->bintval;
-	vif = sc->bslot[(slot + 1) % ATH_BCBUF];
-
-	ATH5K_DBG(sc, ATH5K_DEBUG_BEACON,
-		  "tsf %llx tsftu %x intval %u slot %u vif %p\n",
-		 (unsigned long long)tsf, tsftu, sc->bintval, slot, vif);
+	if (sc->opmode == NL80211_IFTYPE_AP && sc->num_ap_vifs > 1) {
+		u64 tsf = ath5k_hw_get_tsf64(ah);
+		u32 tsftu = TSF_TO_TU(tsf);
+		int slot = ((tsftu % sc->bintval) * ATH_BCBUF) / sc->bintval;
+		vif = sc->bslot[(slot + 1) % ATH_BCBUF];
+		ATH5K_DBG(sc, ATH5K_DEBUG_BEACON,
+			"tsf %llx tsftu %x intval %u slot %u vif %p\n",
+			(unsigned long long)tsf, tsftu, sc->bintval, slot, vif);
+	} else /* only one interface */
+		vif = sc->bslot[0];
 
-	if (vif)
-		avf = (void *)vif->drv_priv;
-	else
+	if (!vif)
 		return;
 
+	avf = (void *)vif->drv_priv;
 	bf = avf->bbuf;
 	if (unlikely(bf->skb == NULL || sc->opmode == NL80211_IFTYPE_STATION ||
 			sc->opmode == NL80211_IFTYPE_MONITOR)) {
@@ -1964,7 +1962,7 @@ ath5k_beacon_update_timers(struct ath5k_softc *sc, u64 bc_tsf)
 	u64 hw_tsf;
 
 	intval = sc->bintval & AR5K_BEACON_PERIOD;
-	if (sc->opmode == NL80211_IFTYPE_AP) {
+	if (sc->opmode == NL80211_IFTYPE_AP && sc->num_ap_vifs > 1) {
 		intval /= ATH_BCBUF;	/* staggered multi-bss beacons */
 		if (intval < 15)
 			ATH5K_WARN(sc, "intval %u is too low, min 15\n",
@@ -2795,7 +2793,6 @@ static int ath5k_add_interface(struct ieee80211_hw *hw,
 		ret = -ELNRNG;
 		goto end;
 	}
-	sc->nvifs++;
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_AP:
@@ -2809,6 +2806,7 @@ static int ath5k_add_interface(struct ieee80211_hw *hw,
 		goto end;
 	}
 
+	sc->nvifs++;
 	ATH5K_DBG(sc, ATH5K_DEBUG_MODE, "add interface mode %d\n", avf->opmode);
 
 	/* Assign the vap/adhoc to a beacon xmit slot. */

