Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:63411 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949Ab1FOWDX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jun 2011 18:03:23 -0400
Subject: [PATCH 1/2] ath5k: minor cleanup
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Wed, 15 Jun 2011 18:03:22 -0400
Message-ID: <20110615220322.1942.81252.stgit@mj.roinet.com> (sfid-20110616_000326_144876_CBEC340A)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move an extern variable declaration to a header file.  Prefix all
functions with "ath5k_".  Make ath5k_intr() static.  Remove unneeded
forward declarations.  Remove pointless "extern" in a function
declaration.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/ath/ath5k/ath5k.h        |    7 ++++---
 drivers/net/wireless/ath/ath5k/base.c         |   14 ++++++--------
 drivers/net/wireless/ath/ath5k/mac80211-ops.c |    6 ++----
 3 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index bb50700..c4c02d5 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -767,6 +767,7 @@ struct ath5k_athchan_2ghz {
  */
 
 #define AR5K_KEYCACHE_SIZE	8
+extern int ath5k_modparam_nohwcrypt;
 
 /***********************\
  HW RELATED DEFINITIONS
@@ -1180,8 +1181,8 @@ void ath5k_sysfs_unregister(struct ath5k_softc *sc);
 struct ath5k_buf;
 struct ath5k_txq;
 
-void set_beacon_filter(struct ieee80211_hw *hw, bool enable);
-bool ath_any_vif_assoc(struct ath5k_softc *sc);
+void ath5k_set_beacon_filter(struct ieee80211_hw *hw, bool enable);
+bool ath5k_any_vif_assoc(struct ath5k_softc *sc);
 void ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
 		    struct ath5k_txq *txq);
 int ath5k_init_hw(struct ath5k_softc *sc);
@@ -1253,7 +1254,7 @@ int ath5k_hw_get_frame_duration(struct ath5k_hw *ah,
 		int len, struct ieee80211_rate *rate, bool shortpre);
 unsigned int ath5k_hw_get_default_slottime(struct ath5k_hw *ah);
 unsigned int ath5k_hw_get_default_sifs(struct ath5k_hw *ah);
-extern int ath5k_hw_set_opmode(struct ath5k_hw *ah, enum nl80211_iftype opmode);
+int ath5k_hw_set_opmode(struct ath5k_hw *ah, enum nl80211_iftype opmode);
 void ath5k_hw_set_coverage_class(struct ath5k_hw *ah, u8 coverage_class);
 /* RX filter control*/
 int ath5k_hw_set_lladdr(struct ath5k_hw *ah, const u8 *mac);
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index b6c5d37..3e70b14 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -87,8 +87,6 @@ MODULE_LICENSE("Dual BSD/GPL");
 static int ath5k_init(struct ieee80211_hw *hw);
 static int ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan,
 								bool skip_pcu);
-int ath5k_beacon_update(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
-void ath5k_beacon_update_timers(struct ath5k_softc *sc, u64 bc_tsf);
 
 /* Known SREVs */
 static const struct ath5k_srev_name srev_names[] = {
@@ -2161,7 +2159,7 @@ ath5k_schedule_tx(struct ath5k_softc *sc)
 	tasklet_schedule(&sc->txtq);
 }
 
-irqreturn_t
+static irqreturn_t
 ath5k_intr(int irq, void *dev_id)
 {
 	struct ath5k_softc *sc = dev_id;
@@ -2615,7 +2613,7 @@ done:
 	return ret;
 }
 
-static void stop_tasklets(struct ath5k_softc *sc)
+static void ath5k_stop_tasklets(struct ath5k_softc *sc)
 {
 	sc->rx_pending = false;
 	sc->tx_pending = false;
@@ -2669,7 +2667,7 @@ ath5k_stop_hw(struct ath5k_softc *sc)
 	mmiowb();
 	mutex_unlock(&sc->lock);
 
-	stop_tasklets(sc);
+	ath5k_stop_tasklets(sc);
 
 	cancel_delayed_work_sync(&sc->tx_complete_work);
 
@@ -2697,7 +2695,7 @@ ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan,
 
 	ath5k_hw_set_imr(ah, 0);
 	synchronize_irq(sc->irq);
-	stop_tasklets(sc);
+	ath5k_stop_tasklets(sc);
 
 	/* Save ani mode and disable ANI during
 	 * reset. If we don't we might get false
@@ -2966,7 +2964,7 @@ ath5k_deinit_softc(struct ath5k_softc *sc)
 }
 
 bool
-ath_any_vif_assoc(struct ath5k_softc *sc)
+ath5k_any_vif_assoc(struct ath5k_softc *sc)
 {
 	struct ath5k_vif_iter_data iter_data;
 	iter_data.hw_macaddr = NULL;
@@ -2980,7 +2978,7 @@ ath_any_vif_assoc(struct ath5k_softc *sc)
 }
 
 void
-set_beacon_filter(struct ieee80211_hw *hw, bool enable)
+ath5k_set_beacon_filter(struct ieee80211_hw *hw, bool enable)
 {
 	struct ath5k_softc *sc = hw->priv;
 	struct ath5k_hw *ah = sc->ah;
diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index 807bd64..4939082 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -46,8 +46,6 @@
 #include "base.h"
 #include "reg.h"
 
-extern int ath5k_modparam_nohwcrypt;
-
 /********************\
 * Mac80211 functions *
 \********************/
@@ -296,10 +294,10 @@ ath5k_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		if (bss_conf->assoc)
 			sc->assoc = bss_conf->assoc;
 		else
-			sc->assoc = ath_any_vif_assoc(sc);
+			sc->assoc = ath5k_any_vif_assoc(sc);
 
 		if (sc->opmode == NL80211_IFTYPE_STATION)
-			set_beacon_filter(hw, sc->assoc);
+			ath5k_set_beacon_filter(hw, sc->assoc);
 		ath5k_hw_set_ledstate(sc->ah, sc->assoc ?
 			AR5K_LED_ASSOC : AR5K_LED_INIT);
 		if (bss_conf->assoc) {
