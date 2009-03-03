Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:35413 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754755AbZCCRYt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2009 12:24:49 -0500
Message-Id: <20090303172441.250416741@atheros.com> (sfid-20090303_182451_662078_6D7377AE)
References: <20090303172325.437810138@atheros.com>
Date: Tue, 03 Mar 2009 19:23:26 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 01/15] ath9k: Cleanup multiple VIF processing
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace the internal sc_vaps array and index values by using vif
pointer from mac80211. Allow multiple VIPs to be registered. Though,
number of beaconing VIFs is still limited by ATH_BCBUF (currently
1). Multiple virtual STAs support is not yet complete, but at least
the data structures should now be able to handle this.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath9k/ath9k.h  |    8 ++---
 drivers/net/wireless/ath9k/beacon.c |   54 ++++++++++++++++--------------------
 drivers/net/wireless/ath9k/main.c   |   54 +++++++++++++++++++++---------------
 3 files changed, 59 insertions(+), 57 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/ath9k/beacon.c	2009-03-03 18:28:59.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/beacon.c	2009-03-03 18:29:02.000000000 +0200
@@ -113,17 +113,16 @@ static void ath_beacon_setup(struct ath_
 				     series, 4, 0);
 }
 
-static struct ath_buf *ath_beacon_generate(struct ath_softc *sc, int if_id)
+static struct ath_buf *ath_beacon_generate(struct ath_softc *sc,
+					   struct ieee80211_vif *vif)
 {
 	struct ath_buf *bf;
 	struct ath_vif *avp;
 	struct sk_buff *skb;
 	struct ath_txq *cabq;
-	struct ieee80211_vif *vif;
 	struct ieee80211_tx_info *info;
 	int cabq_depth;
 
-	vif = sc->vifs[if_id];
 	avp = (void *)vif->drv_priv;
 	cabq = sc->beacon.cabq;
 
@@ -208,15 +207,14 @@ static struct ath_buf *ath_beacon_genera
  * Startup beacon transmission for adhoc mode when they are sent entirely
  * by the hardware using the self-linked descriptor + veol trick.
 */
-static void ath_beacon_start_adhoc(struct ath_softc *sc, int if_id)
+static void ath_beacon_start_adhoc(struct ath_softc *sc,
+				   struct ieee80211_vif *vif)
 {
-	struct ieee80211_vif *vif;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_buf *bf;
 	struct ath_vif *avp;
 	struct sk_buff *skb;
 
-	vif = sc->vifs[if_id];
 	avp = (void *)vif->drv_priv;
 
 	if (avp->av_bcbuf == NULL)
@@ -246,16 +244,14 @@ int ath_beaconq_setup(struct ath_hw *ah)
 	return ath9k_hw_setuptxqueue(ah, ATH9K_TX_QUEUE_BEACON, &qi);
 }
 
-int ath_beacon_alloc(struct ath_softc *sc, int if_id)
+int ath_beacon_alloc(struct ath_softc *sc, struct ieee80211_vif *vif)
 {
-	struct ieee80211_vif *vif;
 	struct ath_vif *avp;
 	struct ieee80211_hdr *hdr;
 	struct ath_buf *bf;
 	struct sk_buff *skb;
 	__le64 tstamp;
 
-	vif = sc->vifs[if_id];
 	avp = (void *)vif->drv_priv;
 
 	/* Allocate a beacon descriptor if we haven't done so. */
@@ -275,22 +271,21 @@ int ath_beacon_alloc(struct ath_softc *s
 			 */
 			avp->av_bslot = 0;
 			for (slot = 0; slot < ATH_BCBUF; slot++)
-				if (sc->beacon.bslot[slot] == ATH_IF_ID_ANY) {
+				if (sc->beacon.bslot[slot] == NULL) {
 					/*
 					 * XXX hack, space out slots to better
 					 * deal with misses
 					 */
 					if (slot+1 < ATH_BCBUF &&
-					    sc->beacon.bslot[slot+1] ==
-						ATH_IF_ID_ANY) {
+					    sc->beacon.bslot[slot+1] == NULL) {
 						avp->av_bslot = slot+1;
 						break;
 					}
 					avp->av_bslot = slot;
 					/* NB: keep looking for a double slot */
 				}
-			BUG_ON(sc->beacon.bslot[avp->av_bslot] != ATH_IF_ID_ANY);
-			sc->beacon.bslot[avp->av_bslot] = if_id;
+			BUG_ON(sc->beacon.bslot[avp->av_bslot] != NULL);
+			sc->beacon.bslot[avp->av_bslot] = vif;
 			sc->nbcnvifs++;
 		}
 	}
@@ -372,7 +367,7 @@ void ath_beacon_return(struct ath_softc 
 		struct ath_buf *bf;
 
 		if (avp->av_bslot != -1) {
-			sc->beacon.bslot[avp->av_bslot] = ATH_IF_ID_ANY;
+			sc->beacon.bslot[avp->av_bslot] = NULL;
 			sc->nbcnvifs--;
 		}
 
@@ -395,7 +390,8 @@ void ath_beacon_tasklet(unsigned long da
 	struct ath_softc *sc = (struct ath_softc *)data;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_buf *bf = NULL;
-	int slot, if_id;
+	struct ieee80211_vif *vif;
+	int slot;
 	u32 bfaddr, bc = 0, tsftu;
 	u64 tsf;
 	u16 intval;
@@ -442,15 +438,15 @@ void ath_beacon_tasklet(unsigned long da
 	tsf = ath9k_hw_gettsf64(ah);
 	tsftu = TSF_TO_TU(tsf>>32, tsf);
 	slot = ((tsftu % intval) * ATH_BCBUF) / intval;
-	if_id = sc->beacon.bslot[(slot + 1) % ATH_BCBUF];
+	vif = sc->beacon.bslot[(slot + 1) % ATH_BCBUF];
 
 	DPRINTF(sc, ATH_DBG_BEACON,
-		"slot %d [tsf %llu tsftu %u intval %u] if_id %d\n",
-		slot, tsf, tsftu, intval, if_id);
+		"slot %d [tsf %llu tsftu %u intval %u] vif %p\n",
+		slot, tsf, tsftu, intval, vif);
 
 	bfaddr = 0;
-	if (if_id != ATH_IF_ID_ANY) {
-		bf = ath_beacon_generate(sc, if_id);
+	if (vif) {
+		bf = ath_beacon_generate(sc, vif);
 		if (bf != NULL) {
 			bfaddr = bf->bf_daddr;
 			bc = 1;
@@ -652,7 +648,8 @@ static void ath_beacon_config_sta(struct
 
 static void ath_beacon_config_adhoc(struct ath_softc *sc,
 				    struct ath_beacon_config *conf,
-				    struct ath_vif *avp)
+				    struct ath_vif *avp,
+				    struct ieee80211_vif *vif)
 {
 	u64 tsf;
 	u32 tsftu, intval, nexttbtt;
@@ -696,14 +693,12 @@ static void ath_beacon_config_adhoc(stru
 	ath9k_hw_set_interrupts(sc->sc_ah, sc->imask);
 
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_VEOL)
-		ath_beacon_start_adhoc(sc, 0);
+		ath_beacon_start_adhoc(sc, vif);
 }
 
-void ath_beacon_config(struct ath_softc *sc, int if_id)
+void ath_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif)
 {
 	struct ath_beacon_config conf;
-	struct ath_vif *avp;
-	struct ieee80211_vif *vif;
 
 	/* Setup the beacon configuration parameters */
 
@@ -715,16 +710,15 @@ void ath_beacon_config(struct ath_softc 
 	conf.dtim_count = 1;
 	conf.bmiss_timeout = ATH_DEFAULT_BMISS_LIMIT * conf.beacon_interval;
 
-	if (if_id != ATH_IF_ID_ANY) {
-		vif = sc->vifs[if_id];
-		avp = (struct ath_vif *)vif->drv_priv;
+	if (vif) {
+		struct ath_vif *avp = (struct ath_vif *)vif->drv_priv;
 
 		switch(avp->av_opmode) {
 		case NL80211_IFTYPE_AP:
 			ath_beacon_config_ap(sc, &conf, avp);
 			break;
 		case NL80211_IFTYPE_ADHOC:
-			ath_beacon_config_adhoc(sc, &conf, avp);
+			ath_beacon_config_adhoc(sc, &conf, avp, vif);
 			break;
 		case NL80211_IFTYPE_STATION:
 			ath_beacon_config_sta(sc, &conf, avp);
--- wireless-testing.orig/drivers/net/wireless/ath9k/main.c	2009-03-03 18:29:02.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/main.c	2009-03-03 18:29:02.000000000 +0200
@@ -798,13 +798,10 @@ static int ath_key_config(struct ath_sof
 		 * need to change with virtual interfaces. */
 		idx = key->keyidx;
 	} else if (key->keyidx) {
-		struct ieee80211_vif *vif;
-
 		if (WARN_ON(!sta))
 			return -EOPNOTSUPP;
 		mac = sta->addr;
 
-		vif = sc->vifs[0];
 		if (vif->type != NL80211_IFTYPE_AP) {
 			/* Only keyidx 0 should be used with unicast key, but
 			 * allow this for client mode for now. */
@@ -913,7 +910,7 @@ static void ath9k_bss_assoc_info(struct 
 		}
 
 		/* Configure the beacon */
-		ath_beacon_config(sc, 0);
+		ath_beacon_config(sc, vif);
 
 		/* Reset rssi stats */
 		sc->nodestats.ns_avgbrssi = ATH_RSSI_DUMMY_MARKER;
@@ -1118,7 +1115,7 @@ static void ath_radio_enable(struct ath_
 	}
 
 	if (sc->sc_flags & SC_OP_BEACONS)
-		ath_beacon_config(sc, ATH_IF_ID_ANY);	/* restart beacons */
+		ath_beacon_config(sc, NULL);	/* restart beacons */
 
 	/* Re-Enable  interrupts */
 	ath9k_hw_set_interrupts(ah, sc->imask);
@@ -1525,7 +1522,7 @@ static int ath_init(u16 devid, struct at
 
 	/* initialize beacon slots */
 	for (i = 0; i < ARRAY_SIZE(sc->beacon.bslot); i++)
-		sc->beacon.bslot[i] = ATH_IF_ID_ANY;
+		sc->beacon.bslot[i] = NULL;
 
 	/* save MISC configurations */
 	sc->config.swBeaconProcess = 1;
@@ -1713,7 +1710,7 @@ int ath_reset(struct ath_softc *sc, bool
 	ath_update_txpow(sc);
 
 	if (sc->sc_flags & SC_OP_BEACONS)
-		ath_beacon_config(sc, ATH_IF_ID_ANY);	/* restart beacons */
+		ath_beacon_config(sc, NULL);	/* restart beacons */
 
 	ath9k_hw_set_interrupts(ah, sc->imask);
 
@@ -2125,11 +2122,7 @@ static int ath9k_add_interface(struct ie
 	struct ath_softc *sc = hw->priv;
 	struct ath_vif *avp = (void *)conf->vif->drv_priv;
 	enum nl80211_iftype ic_opmode = NL80211_IFTYPE_UNSPECIFIED;
-
-	/* Support only vif for now */
-
-	if (sc->nvifs)
-		return -ENOBUFS;
+	int ret = 0;
 
 	mutex_lock(&sc->mutex);
 
@@ -2138,16 +2131,24 @@ static int ath9k_add_interface(struct ie
 		ic_opmode = NL80211_IFTYPE_STATION;
 		break;
 	case NL80211_IFTYPE_ADHOC:
+		if (sc->nbcnvifs >= ATH_BCBUF) {
+			ret = -ENOBUFS;
+			goto out;
+		}
 		ic_opmode = NL80211_IFTYPE_ADHOC;
 		break;
 	case NL80211_IFTYPE_AP:
+		if (sc->nbcnvifs >= ATH_BCBUF) {
+			ret = -ENOBUFS;
+			goto out;
+		}
 		ic_opmode = NL80211_IFTYPE_AP;
 		break;
 	default:
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"Interface type %d not yet supported\n", conf->type);
-		mutex_unlock(&sc->mutex);
-		return -EOPNOTSUPP;
+		ret = -EOPNOTSUPP;
+		goto out;
 	}
 
 	DPRINTF(sc, ATH_DBG_CONFIG, "Attach a VIF of type: %d\n", ic_opmode);
@@ -2156,14 +2157,15 @@ static int ath9k_add_interface(struct ie
 	avp->av_opmode = ic_opmode;
 	avp->av_bslot = -1;
 
+	sc->nvifs++;
+	if (sc->nvifs > 1)
+		goto out; /* skip global settings for secondary vif */
+
 	if (ic_opmode == NL80211_IFTYPE_AP) {
 		ath9k_hw_set_tsfadjust(sc->sc_ah, 1);
 		sc->sc_flags |= SC_OP_TSF_RESET;
 	}
 
-	sc->vifs[0] = conf->vif;
-	sc->nvifs++;
-
 	/* Set the device opmode */
 	sc->sc_ah->opmode = ic_opmode;
 
@@ -2198,9 +2200,9 @@ static int ath9k_add_interface(struct ie
 			  jiffies + msecs_to_jiffies(ATH_ANI_POLLINTERVAL));
 	}
 
+out:
 	mutex_unlock(&sc->mutex);
-
-	return 0;
+	return ret;
 }
 
 static void ath9k_remove_interface(struct ieee80211_hw *hw,
@@ -2208,6 +2210,7 @@ static void ath9k_remove_interface(struc
 {
 	struct ath_softc *sc = hw->priv;
 	struct ath_vif *avp = (void *)conf->vif->drv_priv;
+	int i;
 
 	DPRINTF(sc, ATH_DBG_CONFIG, "Detach Interface\n");
 
@@ -2225,7 +2228,14 @@ static void ath9k_remove_interface(struc
 
 	sc->sc_flags &= ~SC_OP_BEACONS;
 
-	sc->vifs[0] = NULL;
+	for (i = 0; i < ARRAY_SIZE(sc->beacon.bslot); i++) {
+		if (sc->beacon.bslot[i] == conf->vif) {
+			printk(KERN_DEBUG "%s: vif had allocated beacon "
+			       "slot\n", __func__);
+			sc->beacon.bslot[i] = NULL;
+		}
+	}
+
 	sc->nvifs--;
 
 	mutex_unlock(&sc->mutex);
@@ -2362,13 +2372,13 @@ static int ath9k_config_interface(struct
 			 */
 			ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
 
-			error = ath_beacon_alloc(sc, 0);
+			error = ath_beacon_alloc(sc, vif);
 			if (error != 0) {
 				mutex_unlock(&sc->mutex);
 				return error;
 			}
 
-			ath_beacon_config(sc, 0);
+			ath_beacon_config(sc, vif);
 		}
 	}
 
--- wireless-testing.orig/drivers/net/wireless/ath9k/ath9k.h	2009-03-03 18:29:01.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/ath9k.h	2009-03-03 18:29:02.000000000 +0200
@@ -439,7 +439,7 @@ struct ath_beacon {
 	u32 bmisscnt;
 	u32 ast_be_xmit;
 	u64 bc_tstamp;
-	int bslot[ATH_BCBUF];
+	struct ieee80211_vif *bslot[ATH_BCBUF];
 	int slottime;
 	int slotupdate;
 	struct ath9k_tx_queue_info beacon_qi;
@@ -449,9 +449,9 @@ struct ath_beacon {
 };
 
 void ath_beacon_tasklet(unsigned long data);
-void ath_beacon_config(struct ath_softc *sc, int if_id);
+void ath_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif);
 int ath_beaconq_setup(struct ath_hw *ah);
-int ath_beacon_alloc(struct ath_softc *sc, int if_id);
+int ath_beacon_alloc(struct ath_softc *sc, struct ieee80211_vif *vif);
 void ath_beacon_return(struct ath_softc *sc, struct ath_vif *avp);
 
 /*******/
@@ -532,7 +532,6 @@ struct ath_rfkill {
  */
 #define	ATH_KEYMAX	        128     /* max key cache size we handle */
 
-#define ATH_IF_ID_ANY   	0xff
 #define ATH_TXPOWER_MAX         100     /* .5 dBm units */
 #define ATH_RSSI_DUMMY_MARKER   0x127
 #define ATH_RATE_DUMMY_MARKER   0
@@ -595,7 +594,6 @@ struct ath_softc {
 	struct ath_rx rx;
 	struct ath_tx tx;
 	struct ath_beacon beacon;
-	struct ieee80211_vif *vifs[ATH_BCBUF];
 	struct ieee80211_rate rates[IEEE80211_NUM_BANDS][ATH_RATE_MAX];
 	struct ath_rate_table *hw_rate_table[ATH9K_MODE_MAX];
 	struct ath_rate_table *cur_rate_table;

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
