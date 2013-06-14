Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:35802 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab3FNMPk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jun 2013 08:15:40 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: [PATCHv2 5/5] ath9k: enable CSA functionality in ath9k
Date: Fri, 14 Jun 2013 14:15:23 +0200
Message-Id: <1371212124-26264-6-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130614_141547_842660_531A03FC)
In-Reply-To: <1371212124-26264-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1371212124-26264-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CSA is only enabled for one interface, but the same limitation applies
for mac80211 too. It checks whether the beacon has been sent (different
approaches for non-EDMA-enabled and EDMA-enabled devices), and completes
the channel switch after that.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
Changes to PATCHv1:
 * complete channel switch after the last beacon has been sent
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |    2 ++
 drivers/net/wireless/ath/ath9k/beacon.c |   21 +++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/main.c   |   17 +++++++++++++++++
 drivers/net/wireless/ath/ath9k/xmit.c   |    2 ++
 4 files changed, 42 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 579ed9c..3745487 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -424,6 +424,7 @@ void ath9k_beacon_assign_slot(struct ath_softc *sc, struct ieee80211_vif *vif);
 void ath9k_beacon_remove_slot(struct ath_softc *sc, struct ieee80211_vif *vif);
 void ath9k_set_tsfadjust(struct ath_softc *sc, struct ieee80211_vif *vif);
 void ath9k_set_beacon(struct ath_softc *sc);
+bool ath9k_csa_is_finished(struct ath_softc *sc);
 
 /*******************/
 /* Link Monitoring */
@@ -751,6 +752,7 @@ struct ath_softc {
 #endif
 
 	struct ath_descdma txsdma;
+	struct ieee80211_vif *csa_vif;
 
 	struct ath_ant_comb ant_comb;
 	u8 ant_tx, ant_rx;
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index fd1eeba..e400151 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -310,6 +310,23 @@ void ath9k_set_tsfadjust(struct ath_softc *sc, struct ieee80211_vif *vif)
 		(unsigned long long)tsfadjust, avp->av_bslot);
 }
 
+bool ath9k_csa_is_finished(struct ath_softc *sc)
+{
+	struct ieee80211_vif *vif;
+
+	vif = sc->csa_vif;
+	if (!vif || !vif->csa_active)
+		return false;
+
+	if (!ieee80211_csa_is_complete(vif))
+		return false;
+
+	ieee80211_csa_finish(vif);
+	vif->csa_active = 0;
+	sc->csa_vif = NULL;
+	return true;
+}
+
 void ath9k_beacon_tasklet(unsigned long data)
 {
 	struct ath_softc *sc = (struct ath_softc *)data;
@@ -355,6 +372,10 @@ void ath9k_beacon_tasklet(unsigned long data)
 		return;
 	}
 
+	/* EDMA devices check that in the tx completion function. */
+	if (!edma && ath9k_csa_is_finished(sc))
+		return;
+
 	slot = ath9k_beacon_choose_slot(sc);
 	vif = sc->beacon.bslot[slot];
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index cc5a98b..57d0642 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1026,6 +1026,9 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	if (ath9k_uses_beacons(vif->type))
 		ath9k_beacon_remove_slot(sc, vif);
 
+	if (sc->csa_vif == vif)
+		sc->csa_vif = NULL;
+
 	ath9k_ps_wakeup(sc);
 	ath9k_calculate_summary_state(hw, NULL);
 	ath9k_ps_restore(sc);
@@ -2319,6 +2322,19 @@ static void ath9k_sw_scan_complete(struct ieee80211_hw *hw)
 	clear_bit(SC_OP_SCANNING, &sc->sc_flags);
 }
 
+static void ath9k_channel_switch_beacon(struct ieee80211_hw *hw,
+					struct ieee80211_vif *vif)
+{
+	struct ath_softc *sc = hw->priv;
+
+	/* mac80211 does not support CSA in multi-if cases (yet) */
+	if (WARN_ON(sc->csa_vif))
+		return;
+
+	vif->csa_active = 1;
+	sc->csa_vif = vif;
+}
+
 struct ieee80211_ops ath9k_ops = {
 	.tx 		    = ath9k_tx,
 	.start 		    = ath9k_start,
@@ -2366,4 +2382,5 @@ struct ieee80211_ops ath9k_ops = {
 #endif
 	.sw_scan_start	    = ath9k_sw_scan_start,
 	.sw_scan_complete   = ath9k_sw_scan_complete,
+	.channel_switch_beacon     = ath9k_channel_switch_beacon,
 };
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index eab0fcb..cec670d 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2282,6 +2282,8 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
 		if (ts.qid == sc->beacon.beaconq) {
 			sc->beacon.tx_processed = true;
 			sc->beacon.tx_last = !(ts.ts_status & ATH9K_TXERR_MASK);
+
+			ath9k_csa_is_finished(sc);
 			continue;
 		}
 
-- 
1.7.10.4

