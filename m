Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pool-71-115-160-52.gdrpmi.dsl-w.verizon.net ([71.115.160.52]:48791
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbZCJGEV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 02:04:21 -0400
Message-ID: <49B60061.9040409@erley.org> (sfid-20090310_070425_671457_EFA8C24B)
Date: Tue, 10 Mar 2009 01:53:37 -0400
From: pat-lkml <pat-lkml@erley.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: brian@cozybit.com, andrey@cozybit.com, javier@cozybit.com,
	colin@cozybit.com
Subject: [patch/RFC] ath9k mesh mode
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch begins the work to getting mesh mode working with ath9k.  I am
using the b43 and rt2x00 drivers as templates on how to do this.    

Unfortunately it doesn't seem to work yet.  In attempting to set up a mesh between 
an ath9k device and a b43 device, the ath9k device does not seem to be enabling
beaconing.  I have a third device in monitor mode that sees the b43 beacons, 
sees ath9k responding to them (I believe trying to establish a link), and b43
is acknowledging those responses, but no link is established.  On the same ath9k
device, I'm not seeing beaconing in ad-hoc mode, which leads me to believe that
beaconing may be broken right now for my Atheros device.  What am I doing wrong?

Atheros HW: Atheros AR9280 MAC/BB Rev:2 AR5133 RF Rev:d0: mem=0xf9280000, irq=17
b43 HW: BCM4306 802.11b/g (rev 5)

---
diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index 039c781..cbd94dd 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -70,7 +70,8 @@ static void ath_beacon_setup(struct ath_softc *sc, struct ath_vif *avp,
 	ds = bf->bf_desc;
 	flags = ATH9K_TXDESC_NOACK;
 
-	if (sc->sc_ah->opmode == NL80211_IFTYPE_ADHOC &&
+	if (((sc->sc_ah->opmode == NL80211_IFTYPE_ADHOC) ||
+	     (sc->sc_ah->opmode == NL80211_IFTYPE_MESH_POINT)) &&
 	    (ah->caps.hw_caps & ATH9K_HW_CAP_VEOL)) {
 		ds->ds_link = bf->bf_daddr; /* self-linked */
 		flags |= ATH9K_TXDESC_VEOL;
@@ -727,6 +728,8 @@ void ath_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif)
 		case NL80211_IFTYPE_AP:
 			ath_beacon_config_ap(sc, &conf, avp);
 			break;
+		case NL80211_IFTYPE_MESH_POINT:
+			/* Handle mesh beaconing just like ad-hoc */
 		case NL80211_IFTYPE_ADHOC:
 			ath_beacon_config_adhoc(sc, &conf, avp, vif);
 			break;
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index c10b33b..06376aa 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -1430,6 +1430,8 @@ static void ath9k_hw_set_operating_mode(struct ath_hw *ah, int opmode)
 			  | AR_STA_ID1_KSRCH_MODE);
 		REG_CLR_BIT(ah, AR_CFG, AR_CFG_AP_ADHOC_INDICATION);
 		break;
+	case NL80211_IFTYPE_MESH_POINT:
+		/* Configure HW same as ADHOC */
 	case NL80211_IFTYPE_ADHOC:
 		REG_WRITE(ah, AR_STA_ID1, val | AR_STA_ID1_ADHOC
 			  | AR_STA_ID1_KSRCH_MODE);
@@ -3135,6 +3137,8 @@ void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period)
 		REG_WRITE(ah, AR_NEXT_SWBA, 0x7ffff);
 		flags |= AR_TBTT_TIMER_EN;
 		break;
+	case NL80211_IFTYPE_MESH_POINT:
+		/* Should IBSS style beaconing be used for mesh point? */
 	case NL80211_IFTYPE_ADHOC:
 		REG_SET_BIT(ah, AR_TXCFG,
 			    AR_TXCFG_ADHOC_BEACON_ATIM_TX_POLICY);
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 5268697..e76e0de 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1590,6 +1590,7 @@ void ath_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_AP) |
 		BIT(NL80211_IFTYPE_STATION) |
+		BIT(NL80211_IFTYPE_MESH_POINT) |
 		BIT(NL80211_IFTYPE_ADHOC);
 
 	hw->wiphy->reg_notifier = ath9k_reg_notifier;
@@ -2198,18 +2199,13 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 		ic_opmode = NL80211_IFTYPE_STATION;
 		break;
 	case NL80211_IFTYPE_ADHOC:
-		if (sc->nbcnvifs >= ATH_BCBUF) {
-			ret = -ENOBUFS;
-			goto out;
-		}
-		ic_opmode = NL80211_IFTYPE_ADHOC;
-		break;
 	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_MESH_POINT:
 		if (sc->nbcnvifs >= ATH_BCBUF) {
 			ret = -ENOBUFS;
 			goto out;
 		}
-		ic_opmode = NL80211_IFTYPE_AP;
+		ic_opmode = conf->type;
 		break;
 	default:
 		DPRINTF(sc, ATH_DBG_FATAL,
@@ -2242,10 +2238,11 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 
 	/*
 	 * Enable MIB interrupts when there are hardware phy counters.
-	 * Note we only do this (at the moment) for station mode.
+	 * Note we only do this (at the moment) for non AP modes.
 	 */
 	if ((conf->type == NL80211_IFTYPE_STATION) ||
-	    (conf->type == NL80211_IFTYPE_ADHOC)) {
+	    (conf->type == NL80211_IFTYPE_ADHOC) ||
+	    (conf->type == NL80211_IFTYPE_MESH_POINT)) {
 		if (ath9k_hw_phycounters(sc->sc_ah))
 			sc->imask |= ATH9K_INT_MIB;
 		sc->imask |= ATH9K_INT_TSFOOR;
@@ -2292,8 +2289,9 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	del_timer_sync(&sc->ani.timer);
 
 	/* Reclaim beacon resources */
-	if (sc->sc_ah->opmode == NL80211_IFTYPE_AP ||
-	    sc->sc_ah->opmode == NL80211_IFTYPE_ADHOC) {
+	if ((sc->sc_ah->opmode == NL80211_IFTYPE_AP) ||
+	    (sc->sc_ah->opmode == NL80211_IFTYPE_ADHOC) ||
+	    (sc->sc_ah->opmode == NL80211_IFTYPE_MESH_POINT)) {
 		ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
 		ath_beacon_return(sc, avp);
 	}
@@ -2446,10 +2444,31 @@ static int ath9k_config_interface(struct ieee80211_hw *hw,
 		default:
 			break;
 		}
+	} else if ((vif->type == NL80211_IFTYPE_MESH_POINT) && (conf->bssid)) {
+		/* Both b43 and rt2x00 set the bssid in the case that one
+		 * is passed durint interface config, irregardless of the
+		 * status of conf->changed */
+		
+		/* Set BSSID */
+		memcpy(sc->curbssid, conf->bssid, ETH_ALEN);
+		memcpy(avp->bssid, conf->bssid, ETH_ALEN);
+		sc->curaid = 0;
+		ath9k_hw_write_associd(sc);
+
+		/* Set aggregation protection mode parameters */
+		sc->config.ath_aggr_prot = 0;
+
+		DPRINTF(sc, ATH_DBG_CONFIG,
+			"RX filter 0x%x bssid %pM aid 0x%x\n",
+			rfilt, sc->curbssid, sc->curaid);
+
+		/* need to reconfigure the beacon */
+		sc->sc_flags &= ~SC_OP_BEACONS ;
 	}
 
 	if ((vif->type == NL80211_IFTYPE_ADHOC) ||
-	    (vif->type == NL80211_IFTYPE_AP)) {
+	    (vif->type == NL80211_IFTYPE_AP) ||
+	    (vif->type == NL80211_IFTYPE_MESH_POINT)) {
 		if ((conf->changed & IEEE80211_IFCC_BEACON) ||
 		    (conf->changed & IEEE80211_IFCC_BEACON_ENABLED &&
 		     conf->enable_beacon)) {
@@ -2482,8 +2501,9 @@ static int ath9k_config_interface(struct ieee80211_hw *hw,
 						   sc->curbssid);
 	}
 
-	/* Only legacy IBSS for now */
-	if (vif->type == NL80211_IFTYPE_ADHOC)
+	/* Only legacy IBSS and Mesh Point for now */
+	if ((vif->type == NL80211_IFTYPE_ADHOC) ||
+	    (vif->type == NL80211_IFTYPE_MESH_POINT))
 		ath_update_chainmask(sc, 0);
 
 	mutex_unlock(&sc->mutex);
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index 8327356..61f8334 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -1615,7 +1615,8 @@ static void ath_rate_init(void *priv, struct ieee80211_supported_band *sband,
 	/* Choose rate table first */
 
 	if ((sc->sc_ah->opmode == NL80211_IFTYPE_STATION) ||
-	    (sc->sc_ah->opmode == NL80211_IFTYPE_ADHOC)) {
+	    (sc->sc_ah->opmode == NL80211_IFTYPE_ADHOC) ||
+	    (sc->sc_ah->opmode == NL80211_IFTYPE_MESH_POINT)) {
 		rate_table = ath_choose_rate_table(sc, sband->band,
 						   sta->ht_cap.ht_supported,
 						   is_cw40);
