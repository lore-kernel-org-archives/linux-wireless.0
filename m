Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:64222 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbYJ2Esy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 00:48:54 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2008 21:48:54 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18695.60046.887789.96746@gargle.gargle.HOWL> (sfid-20081029_054858_324894_28A2FB7D)
Date: Wed, 29 Oct 2008 10:16:06 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 07/16] ath9k: Revamp VAP management
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the internal VAP management routines
and embed ath_vap in mac80211's driver private area
provided in ieee80211_vif.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/beacon.c |   40 ++++++++----
 drivers/net/wireless/ath9k/core.c   |  116 +----------------------------------
 drivers/net/wireless/ath9k/core.h   |   16 +----
 drivers/net/wireless/ath9k/main.c   |   80 +++++++++---------------
 drivers/net/wireless/ath9k/rc.c     |    8 ++-
 5 files changed, 67 insertions(+), 193 deletions(-)

diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index b36d3fb..d186cd4 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -152,12 +152,14 @@ static struct ath_buf *ath_beacon_generate(struct ath_softc *sc, int if_id)
 	struct ath_vap *avp;
 	struct sk_buff *skb;
 	struct ath_txq *cabq;
+	struct ieee80211_vif *vif;
 	struct ieee80211_tx_info *info;
 	int cabq_depth;
 
-	avp = sc->sc_vaps[if_id];
-	ASSERT(avp);
+	vif = sc->sc_vaps[if_id];
+	ASSERT(vif);
 
+	avp = (void *)vif->drv_priv;
 	cabq = sc->sc_cabq;
 
 	if (avp->av_bcbuf == NULL) {
@@ -174,7 +176,7 @@ static struct ath_buf *ath_beacon_generate(struct ath_softc *sc, int if_id)
 				 PCI_DMA_TODEVICE);
 	}
 
-	skb = ieee80211_beacon_get(sc->hw, avp->av_if_data);
+	skb = ieee80211_beacon_get(sc->hw, vif);
 	bf->bf_mpdu = skb;
 	if (skb == NULL)
 		return NULL;
@@ -196,7 +198,7 @@ static struct ath_buf *ath_beacon_generate(struct ath_softc *sc, int if_id)
 			       skb_end_pointer(skb) - skb->head,
 			       PCI_DMA_TODEVICE);
 
-	skb = ieee80211_get_buffered_bc(sc->hw, avp->av_if_data);
+	skb = ieee80211_get_buffered_bc(sc->hw, vif);
 
 	/*
 	 * if the CABQ traffic from previous DTIM is pending and the current
@@ -232,7 +234,7 @@ static struct ath_buf *ath_beacon_generate(struct ath_softc *sc, int if_id)
 	 */
 	while (skb) {
 		ath_tx_cabq(sc, skb);
-		skb = ieee80211_get_buffered_bc(sc->hw, avp->av_if_data);
+		skb = ieee80211_get_buffered_bc(sc->hw, vif);
 	}
 
 	return bf;
@@ -244,13 +246,16 @@ static struct ath_buf *ath_beacon_generate(struct ath_softc *sc, int if_id)
 */
 static void ath_beacon_start_adhoc(struct ath_softc *sc, int if_id)
 {
+	struct ieee80211_vif *vif;
 	struct ath_hal *ah = sc->sc_ah;
 	struct ath_buf *bf;
 	struct ath_vap *avp;
 	struct sk_buff *skb;
 
-	avp = sc->sc_vaps[if_id];
-	ASSERT(avp);
+	vif = sc->sc_vaps[if_id];
+	ASSERT(vif);
+
+	avp = (void *)vif->drv_priv;
 
 	if (avp->av_bcbuf == NULL) {
 		DPRINTF(sc, ATH_DBG_BEACON, "%s: avp=%p av_bcbuf=%p\n",
@@ -300,14 +305,17 @@ int ath_beaconq_setup(struct ath_hal *ah)
 */
 int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 {
+	struct ieee80211_vif *vif;
 	struct ath_vap *avp;
 	struct ieee80211_hdr *hdr;
 	struct ath_buf *bf;
 	struct sk_buff *skb;
 	__le64 tstamp;
 
-	avp = sc->sc_vaps[if_id];
-	ASSERT(avp);
+	vif = sc->sc_vaps[if_id];
+	ASSERT(vif);
+
+	avp = (void *)vif->drv_priv;
 
 	/* Allocate a beacon descriptor if we haven't done so. */
 	if (!avp->av_bcbuf) {
@@ -363,7 +371,7 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 	 * FIXME: Fill avp->av_btxctl.txpower and
 	 * avp->av_btxctl.shortPreamble
 	 */
-	skb = ieee80211_beacon_get(sc->hw, avp->av_if_data);
+	skb = ieee80211_beacon_get(sc->hw, vif);
 	if (skb == NULL) {
 		DPRINTF(sc, ATH_DBG_BEACON, "%s: cannot get skb\n",
 			__func__);
@@ -652,15 +660,21 @@ void ath_bstuck_process(struct ath_softc *sc)
  */
 void ath_beacon_config(struct ath_softc *sc, int if_id)
 {
+	struct ieee80211_vif *vif;
 	struct ath_hal *ah = sc->sc_ah;
 	struct ath_beacon_config conf;
+	struct ath_vap *avp;
 	enum ath9k_opmode av_opmode;
 	u32 nexttbtt, intval;
 
-	if (if_id != ATH_IF_ID_ANY)
-		av_opmode = sc->sc_vaps[if_id]->av_opmode;
-	else
+	if (if_id != ATH_IF_ID_ANY) {
+		vif = sc->sc_vaps[if_id];
+		ASSERT(vif);
+		avp = (void *)vif->drv_priv;
+		av_opmode = avp->av_opmode;
+	} else {
 		av_opmode = sc->sc_ah->ah_opmode;
+	}
 
 	memset(&conf, 0, sizeof(struct ath_beacon_config));
 
diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index 689a280..aa1f1fc 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -14,8 +14,6 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
- /* Implementation of the main "ATH" layer. */
-
 #include "core.h"
 #include "regd.h"
 
@@ -641,114 +639,6 @@ static void ath_ani_calibrate(unsigned long data)
 	mod_timer(&sc->sc_ani.timer, jiffies + msecs_to_jiffies(cal_interval));
 }
 
-/******************/
-/* VAP management */
-/******************/
-
-int ath_vap_attach(struct ath_softc *sc,
-		   int if_id,
-		   struct ieee80211_vif *if_data,
-		   enum ath9k_opmode opmode)
-{
-	struct ath_vap *avp;
-
-	if (if_id >= ATH_BCBUF || sc->sc_vaps[if_id] != NULL) {
-		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: Invalid interface id = %u\n", __func__, if_id);
-		return -EINVAL;
-	}
-
-	switch (opmode) {
-	case ATH9K_M_STA:
-	case ATH9K_M_IBSS:
-	case ATH9K_M_MONITOR:
-		break;
-	case ATH9K_M_HOSTAP:
-		/* XXX not right, beacon buffer is allocated on RUN trans */
-		if (list_empty(&sc->sc_bbuf))
-			return -ENOMEM;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	/* create ath_vap */
-	avp = kmalloc(sizeof(struct ath_vap), GFP_KERNEL);
-	if (avp == NULL)
-		return -ENOMEM;
-
-	memset(avp, 0, sizeof(struct ath_vap));
-	avp->av_if_data = if_data;
-	/* Set the VAP opmode */
-	avp->av_opmode = opmode;
-	avp->av_bslot = -1;
-
-	if (opmode == ATH9K_M_HOSTAP)
-		ath9k_hw_set_tsfadjust(sc->sc_ah, 1);
-
-	sc->sc_vaps[if_id] = avp;
-	sc->sc_nvaps++;
-	/* Set the device opmode */
-	sc->sc_ah->ah_opmode = opmode;
-
-	/* default VAP configuration */
-	avp->av_config.av_fixed_rateset = IEEE80211_FIXED_RATE_NONE;
-	avp->av_config.av_fixed_retryset = 0x03030303;
-
-	return 0;
-}
-
-int ath_vap_detach(struct ath_softc *sc, int if_id)
-{
-	struct ath_hal *ah = sc->sc_ah;
-	struct ath_vap *avp;
-
-	avp = sc->sc_vaps[if_id];
-	if (avp == NULL) {
-		DPRINTF(sc, ATH_DBG_FATAL, "%s: invalid interface id %u\n",
-			__func__, if_id);
-		return -EINVAL;
-	}
-
-	/*
-	 * Quiesce the hardware while we remove the vap.  In
-	 * particular we need to reclaim all references to the
-	 * vap state by any frames pending on the tx queues.
-	 *
-	 * XXX can we do this w/o affecting other vap's?
-	 */
-	ath9k_hw_set_interrupts(ah, 0);	/* disable interrupts */
-	ath_draintxq(sc, false);	/* stop xmit side */
-	ath_stoprecv(sc);	/* stop recv side */
-	ath_flushrecv(sc);	/* flush recv queue */
-
-	kfree(avp);
-	sc->sc_vaps[if_id] = NULL;
-	sc->sc_nvaps--;
-
-	return 0;
-}
-
-int ath_vap_config(struct ath_softc *sc,
-	int if_id, struct ath_vap_config *if_config)
-{
-	struct ath_vap *avp;
-
-	if (if_id >= ATH_BCBUF) {
-		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: Invalid interface id = %u\n", __func__, if_id);
-		return -EINVAL;
-	}
-
-	avp = sc->sc_vaps[if_id];
-	ASSERT(avp != NULL);
-
-	if (avp)
-		memcpy(&avp->av_config, if_config, sizeof(avp->av_config));
-
-	return 0;
-}
-
 /********/
 /* Core */
 /********/
@@ -1356,14 +1246,10 @@ void ath_deinit(struct ath_softc *sc)
 /* Node Management */
 /*******************/
 
-void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta, int if_id)
+void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta)
 {
-	struct ath_vap *avp;
 	struct ath_node *an;
 
-	avp = sc->sc_vaps[if_id];
-	ASSERT(avp != NULL);
-
 	an = (struct ath_node *)sta->drv_priv;
 
 	if (sc->sc_flags & SC_OP_TXAGGR)
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index d89dd03..c03acf7 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -635,8 +635,7 @@ int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
 int ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid);
 void ath_newassoc(struct ath_softc *sc,
 	struct ath_node *node, int isnew, int isuapsd);
-void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta,
-		     int if_id);
+void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta);
 void ath_node_detach(struct ath_softc *sc, struct ieee80211_sta *sta);
 
 /*******************/
@@ -701,23 +700,14 @@ struct ath_vap_config {
 
 /* driver-specific vap state */
 struct ath_vap {
-	struct ieee80211_vif *av_if_data;
+	int av_bslot;			/* beacon slot index */
 	enum ath9k_opmode av_opmode;	/* VAP operational mode */
 	struct ath_buf *av_bcbuf;	/* beacon buffer */
 	struct ath_tx_control av_btxctl;  /* txctl information for beacon */
-	int av_bslot;			/* beacon slot index */
 	struct ath_vap_config av_config;/* vap configuration parameters*/
 	struct ath_rate_node *rc_node;
 };
 
-int ath_vap_attach(struct ath_softc *sc,
-		   int if_id,
-		   struct ieee80211_vif *if_data,
-		   enum ath9k_opmode opmode);
-int ath_vap_detach(struct ath_softc *sc, int if_id);
-int ath_vap_config(struct ath_softc *sc,
-		   int if_id, struct ath_vap_config *if_config);
-
 /*********************/
 /* Antenna diversity */
 /*********************/
@@ -925,7 +915,7 @@ struct ath_softc {
 
 	u8 sc_nbcnvaps;			/* # of vaps sending beacons */
 	u16 sc_nvaps;			/* # of active virtual ap's */
-	struct ath_vap *sc_vaps[ATH_BCBUF];
+	struct ieee80211_vif *sc_vaps[ATH_BCBUF];
 
 	u8 sc_mcastantenna;
 	u8 sc_defant;			/* current default antenna */
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 831dc75..2587db8 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -162,7 +162,7 @@ static int ath_key_config(struct ath_softc *sc,
 	if (!sc->sc_vaps[0])
 		return -EIO;
 
-	vif = sc->sc_vaps[0]->av_if_data;
+	vif = sc->sc_vaps[0];
 	opmode = vif->type;
 
 	/*
@@ -313,11 +313,12 @@ static void ath9k_ht_conf(struct ath_softc *sc,
 }
 
 static void ath9k_bss_assoc_info(struct ath_softc *sc,
+				 struct ieee80211_vif *vif,
 				 struct ieee80211_bss_conf *bss_conf)
 {
 	struct ieee80211_hw *hw = sc->hw;
 	struct ieee80211_channel *curchan = hw->conf.channel;
-	struct ath_vap *avp;
+	struct ath_vap *avp = (void *)vif->drv_priv;
 	int pos;
 	DECLARE_MAC_BUF(mac);
 
@@ -326,13 +327,6 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 			__func__,
 			bss_conf->aid);
 
-		avp = sc->sc_vaps[0];
-		if (avp == NULL) {
-			DPRINTF(sc, ATH_DBG_FATAL, "%s: Invalid interface\n",
-				__func__);
-			return;
-		}
-
 		/* New association, store aid */
 		if (avp->av_opmode == ATH9K_M_STA) {
 			sc->sc_curaid = bss_conf->aid;
@@ -907,6 +901,7 @@ static int ath_attach(u16 devid,
 
 	hw->queues = 4;
 	hw->sta_data_size = sizeof(struct ath_node);
+	hw->vif_data_size = sizeof(struct ath_vap);
 
 	/* Register rate control */
 	hw->rate_control_algorithm = "ath9k_rate_control";
@@ -1092,7 +1087,8 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 			       struct ieee80211_if_init_conf *conf)
 {
 	struct ath_softc *sc = hw->priv;
-	int error, ic_opmode = 0;
+	struct ath_vap *avp = (void *)conf->vif->drv_priv;
+	int ic_opmode = 0;
 
 	/* Support only vap for now */
 
@@ -1120,13 +1116,22 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 		__func__,
 		ic_opmode);
 
-	error = ath_vap_attach(sc, 0, conf->vif, ic_opmode);
-	if (error) {
-		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: Unable to attach vap, error: %d\n",
-			__func__, error);
-		return error;
-	}
+	/* Set the VAP opmode */
+	avp->av_opmode = ic_opmode;
+	avp->av_bslot = -1;
+
+	if (ic_opmode == ATH9K_M_HOSTAP)
+		ath9k_hw_set_tsfadjust(sc->sc_ah, 1);
+
+	sc->sc_vaps[0] = conf->vif;
+	sc->sc_nvaps++;
+
+	/* Set the device opmode */
+	sc->sc_ah->ah_opmode = ic_opmode;
+
+	/* default VAP configuration */
+	avp->av_config.av_fixed_rateset = IEEE80211_FIXED_RATE_NONE;
+	avp->av_config.av_fixed_retryset = 0x03030303;
 
 	if (conf->type == NL80211_IFTYPE_AP) {
 		/* TODO: is this a suitable place to start ANI for AP mode? */
@@ -1142,27 +1147,16 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 				   struct ieee80211_if_init_conf *conf)
 {
 	struct ath_softc *sc = hw->priv;
-	struct ath_vap *avp;
-	int error;
+	struct ath_vap *avp = (void *)conf->vif->drv_priv;
 
 	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Detach VAP\n", __func__);
 
-	avp = sc->sc_vaps[0];
-	if (avp == NULL) {
-		DPRINTF(sc, ATH_DBG_FATAL, "%s: Invalid interface\n",
-			__func__);
-		return;
-	}
-
 #ifdef CONFIG_SLOW_ANT_DIV
 	ath_slow_ant_div_stop(&sc->sc_antdiv);
 #endif
 	/* Stop ANI */
 	del_timer_sync(&sc->sc_ani.timer);
 
-	/* Update ratectrl */
-	ath_rate_newstate(sc, avp);
-
 	/* Reclaim beacon resources */
 	if (sc->sc_ah->ah_opmode == ATH9K_M_HOSTAP ||
 	    sc->sc_ah->ah_opmode == ATH9K_M_IBSS) {
@@ -1170,16 +1164,10 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 		ath_beacon_return(sc, avp);
 	}
 
-	/* Set interrupt mask */
-	sc->sc_imask &= ~(ATH9K_INT_SWBA | ATH9K_INT_BMISS);
-	ath9k_hw_set_interrupts(sc->sc_ah, sc->sc_imask & ~ATH9K_INT_GLOBAL);
 	sc->sc_flags &= ~SC_OP_BEACONS;
 
-	error = ath_vap_detach(sc, 0);
-	if (error)
-		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: Unable to detach vap, error: %d\n",
-			__func__, error);
+	sc->sc_vaps[0] = NULL;
+	sc->sc_nvaps--;
 }
 
 static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
@@ -1227,18 +1215,11 @@ static int ath9k_config_interface(struct ieee80211_hw *hw,
 {
 	struct ath_softc *sc = hw->priv;
 	struct ath_hal *ah = sc->sc_ah;
-	struct ath_vap *avp;
+	struct ath_vap *avp = (void *)vif->drv_priv;
 	u32 rfilt = 0;
 	int error, i;
 	DECLARE_MAC_BUF(mac);
 
-	avp = sc->sc_vaps[0];
-	if (avp == NULL) {
-		DPRINTF(sc, ATH_DBG_FATAL, "%s: Invalid interface\n",
-			__func__);
-		return -EINVAL;
-	}
-
 	/* TODO: Need to decide which hw opmode to use for multi-interface
 	 * cases */
 	if (vif->type == NL80211_IFTYPE_AP &&
@@ -1319,7 +1300,7 @@ static int ath9k_config_interface(struct ieee80211_hw *hw,
 	}
 
 	/* Check for WLAN_CAPABILITY_PRIVACY ? */
-	if ((avp->av_opmode != NL80211_IFTYPE_STATION)) {
+	if ((avp->av_opmode != ATH9K_M_STA)) {
 		for (i = 0; i < IEEE80211_WEP_NKID; i++)
 			if (ath9k_hw_keyisvalid(sc->sc_ah, (u16)i))
 				ath9k_hw_keysetmac(sc->sc_ah,
@@ -1368,9 +1349,6 @@ static void ath9k_configure_filter(struct ieee80211_hw *hw,
 		__func__, sc->rx_filter);
 }
 
-/* Only a single interface is currently supported,
-   so pass 0 as the interface id to ath_node_attach */
-
 static void ath9k_sta_notify(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif,
 			     enum sta_notify_cmd cmd,
@@ -1380,7 +1358,7 @@ static void ath9k_sta_notify(struct ieee80211_hw *hw,
 
 	switch (cmd) {
 	case STA_NOTIFY_ADD:
-		ath_node_attach(sc, sta, 0);
+		ath_node_attach(sc, sta);
 		break;
 	case STA_NOTIFY_REMOVE:
 		ath_node_detach(sc, sta);
@@ -1498,7 +1476,7 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 		DPRINTF(sc, ATH_DBG_CONFIG, "%s: BSS Changed ASSOC %d\n",
 			__func__,
 			bss_conf->assoc);
-		ath9k_bss_assoc_info(sc, bss_conf);
+		ath9k_bss_assoc_info(sc, vif, bss_conf);
 	}
 }
 
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index f234a9b..ad29270 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -2043,12 +2043,18 @@ static void ath_rate_free(void *priv)
 
 static void *ath_rate_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp)
 {
+	struct ieee80211_vif *vif;
 	struct ath_softc *sc = priv;
-	struct ath_vap *avp = sc->sc_vaps[0];
+	struct ath_vap *avp;
 	struct ath_rate_node *rate_priv;
 
 	DPRINTF(sc, ATH_DBG_RATE, "%s\n", __func__);
 
+	vif = sc->sc_vaps[0];
+	ASSERT(vif);
+
+	avp = (void *)vif->drv_priv;
+
 	rate_priv = ath_rate_node_alloc(avp, sc->sc_rc, gfp);
 	if (!rate_priv) {
 		DPRINTF(sc, ATH_DBG_FATAL,
-- 
1.6.0.3

