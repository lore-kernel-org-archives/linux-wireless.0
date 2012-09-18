Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11248 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757611Ab2IRNr4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2012 09:47:56 -0400
From: Sujith Manoharan <c_manoha@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20568.31520.887555.183389@gargle.gargle.HOWL> (sfid-20120918_154800_499051_E06984DD)
Date: Tue, 18 Sep 2012 19:16:08 +0530
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
CC: <ath9k-devel@lists.ath9k.org>, <linux-wireless@vger.kernel.org>
Subject: [ath9k-devel] ath9k: spurious queue reset (beacon stuck) when joining an IBSS.
In-Reply-To: <5058737E.4090601@lri.fr>
References: <50582CF8.4020608@lri.fr>
	<5058737E.4090601@lri.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nicolas Cavallari wrote:
> [resending, as no archive saw my previous message]
> 
> With an AR9382 (well, i think, its PCI-id is 168c:0030 rev 1/168c:3116),
> each time I join an IBSS network, the driver repeatedly
> resets the queue for a while, because of too many missed beacons.  After
> some time, this stops and the card behave normally.  But many packets
> are lost in the process.
> 
> The problem seems to aggravate when the number of IBSS nodes is higher :
> When joining a IBSS network with only one node, Only a few (e.g. 4)
> beacons are lost, and no reset takes places. When joining an IBSS
> network with two nodes, the queues can be reset up to 224 times in 20
> seconds. When joining large IBSS networks, it sometimes never stop
> resetting.  Occasionally, when resetting, the driver fails to reset TX DMA
> 
> If i hack the driver to not reset when the beacon is stuck, the beacon
> tx resumes quickly by itself after 80-200 misses and the network seems
> to work normally (if not better). On large&clogged ad-hoc networks, the
> card sometimes miss between 1 and 80 beacons, but it might be due to
> background scanning i think.
> 
> What could be the problem here ? is ad-hoc beaconing kind of broken ?
> I do not have the problem with AR9285.

I think the problem is that we are programming the beacon timers based on
the beacon interval right after joining, but we base it on the HW TSF which
has just been reset. We should be updating the timers based on the TSF after a
HW sync has been done with a received beacon. This is being done for station
mode, but IBSS mode is missing this.

Here is a very rough patch, it abuses STA-mode flags and doesn't differentiate
between creator/joiner mode, but can you check if it makes any difference ?

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 76f07d8..5a1a89d 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -582,16 +582,19 @@ static void ath9k_beacon_config_adhoc(struct ath_softc *sc,
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	u32 intval, nexttbtt;
+	unsigned long flags;
 
 	ath9k_reset_beacon_status(sc);
 
 	intval = TU_TO_USEC(conf->beacon_interval);
 	nexttbtt = intval;
 
-	if (conf->enable_beacon)
+	spin_lock_irqsave(&sc->sc_pm_lock, flags);
+	if (conf->enable_beacon && !(sc->ps_flags & PS_BEACON_SYNC))
 		ah->imask |= ATH9K_INT_SWBA;
 	else
 		ah->imask &= ~ATH9K_INT_SWBA;
+	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
 
 	ath_dbg(common, BEACON, "IBSS nexttbtt: %u intval: %u conf_intval: %u\n",
 		nexttbtt, intval, conf->beacon_interval);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 3923ad9..ae1c0bb 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1486,6 +1486,7 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_vif *avp = (void *)vif->drv_priv;
 	int slottime;
+	unsigned long flags;
 
 	ath9k_ps_wakeup(sc);
 	mutex_lock(&sc->mutex);
@@ -1517,6 +1518,12 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 		memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
 		common->curaid = bss_conf->aid;
 		ath9k_hw_write_associd(sc->sc_ah);
+
+		if (bss_conf->ibss_joined) {
+			spin_lock_irqsave(&sc->sc_pm_lock, flags);
+			sc->ps_flags |= PS_BEACON_SYNC;
+			spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
+		}
 	}
 
 	if ((changed & BSS_CHANGED_BEACON_ENABLED) ||
