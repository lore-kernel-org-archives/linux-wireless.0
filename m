Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:36941 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbaATOcE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 09:32:04 -0500
Received: by mail-ee0-f45.google.com with SMTP id b15so3352523eek.18
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jan 2014 06:32:03 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/2] ath9k: prepare for multi-interface CSA support
Date: Mon, 20 Jan 2014 15:27:12 +0100
Message-Id: <1390228033-19162-2-git-send-email-michal.kazior@tieto.com> (sfid-20140120_153210_828973_23073030)
In-Reply-To: <1390228033-19162-1-git-send-email-michal.kazior@tieto.com>
References: <1390228033-19162-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Soon mac80211 will support multi-interface CSA so
using sc->csa_vif is not an option.

Instead just depend on vif->csa_active. Calling
ieee80211_csa_finish() multiple number of times
should not be an issue.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |  4 ++--
 drivers/net/wireless/ath/ath9k/beacon.c | 29 +++++++++++++++++++----------
 drivers/net/wireless/ath/ath9k/main.c   | 12 ++----------
 drivers/net/wireless/ath/ath9k/xmit.c   |  2 +-
 4 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 5e5d5cb..0415a3b 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -427,7 +427,8 @@ void ath9k_beacon_assign_slot(struct ath_softc *sc, struct ieee80211_vif *vif);
 void ath9k_beacon_remove_slot(struct ath_softc *sc, struct ieee80211_vif *vif);
 void ath9k_set_tsfadjust(struct ath_softc *sc, struct ieee80211_vif *vif);
 void ath9k_set_beacon(struct ath_softc *sc);
-bool ath9k_csa_is_finished(struct ath_softc *sc);
+bool ath9k_csa_is_finished(struct ath_softc *sc, struct ieee80211_vif *vif);
+void ath9k_csa_update(struct ath_softc *sc);
 
 /*******************/
 /* Link Monitoring */
@@ -800,7 +801,6 @@ struct ath_softc {
 #endif
 
 	struct ath_descdma txsdma;
-	struct ieee80211_vif *csa_vif;
 
 	struct ath_ant_comb ant_comb;
 	u8 ant_tx, ant_rx;
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 17be353..9b75234 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -291,11 +291,8 @@ void ath9k_set_tsfadjust(struct ath_softc *sc, struct ieee80211_vif *vif)
 		(unsigned long long)tsfadjust, avp->av_bslot);
 }
 
-bool ath9k_csa_is_finished(struct ath_softc *sc)
+bool ath9k_csa_is_finished(struct ath_softc *sc, struct ieee80211_vif *vif)
 {
-	struct ieee80211_vif *vif;
-
-	vif = sc->csa_vif;
 	if (!vif || !vif->csa_active)
 		return false;
 
@@ -303,11 +300,23 @@ bool ath9k_csa_is_finished(struct ath_softc *sc)
 		return false;
 
 	ieee80211_csa_finish(vif);
-
-	sc->csa_vif = NULL;
 	return true;
 }
 
+static void ath9k_csa_update_vif(void *data, u8 *mac, struct ieee80211_vif *vif)
+{
+	struct ath_softc *sc = data;
+	ath9k_csa_is_finished(sc, vif);
+}
+
+void ath9k_csa_update(struct ath_softc *sc)
+{
+	ieee80211_iterate_active_interfaces(sc->hw,
+					    IEEE80211_IFACE_ITER_NORMAL,
+					    ath9k_csa_update_vif,
+					    sc);
+}
+
 void ath9k_beacon_tasklet(unsigned long data)
 {
 	struct ath_softc *sc = (struct ath_softc *)data;
@@ -355,13 +364,13 @@ void ath9k_beacon_tasklet(unsigned long data)
 		return;
 	}
 
-	/* EDMA devices check that in the tx completion function. */
-	if (!edma && ath9k_csa_is_finished(sc))
-		return;
-
 	slot = ath9k_beacon_choose_slot(sc);
 	vif = sc->beacon.bslot[slot];
 
+	/* EDMA devices check that in the tx completion function. */
+	if (!edma && ath9k_csa_is_finished(sc, vif))
+		return;
+
 	if (!vif || !vif->bss_conf.enable_beacon)
 		return;
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index b1dcf89..3b797b8 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1147,9 +1147,6 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	if (ath9k_uses_beacons(vif->type))
 		ath9k_beacon_remove_slot(sc, vif);
 
-	if (sc->csa_vif == vif)
-		sc->csa_vif = NULL;
-
 	ath9k_ps_wakeup(sc);
 	ath9k_calculate_summary_state(hw, NULL);
 	ath9k_ps_restore(sc);
@@ -2061,13 +2058,8 @@ static void ath9k_channel_switch_beacon(struct ieee80211_hw *hw,
 					struct ieee80211_vif *vif,
 					struct cfg80211_chan_def *chandef)
 {
-	struct ath_softc *sc = hw->priv;
-
-	/* mac80211 does not support CSA in multi-if cases (yet) */
-	if (WARN_ON(sc->csa_vif))
-		return;
-
-	sc->csa_vif = vif;
+	/* depend on vif->csa_active only */
+	return;
 }
 
 struct ieee80211_ops ath9k_ops = {
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 24846d9..24f19d2 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2576,7 +2576,7 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
 			sc->beacon.tx_processed = true;
 			sc->beacon.tx_last = !(ts.ts_status & ATH9K_TXERR_MASK);
 
-			ath9k_csa_is_finished(sc);
+			ath9k_csa_update(sc);
 			continue;
 		}
 
-- 
1.8.4.rc3

