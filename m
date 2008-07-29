Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:17141 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753886AbYG2Frh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 01:47:37 -0400
Received: from mail.atheros.com ([192.168.11.2])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2008 22:47:37 -0700
From: <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<Jouni.Malinen@Atheros.com>, Sujith <Sujith.Manoharan@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 07/16] ath9k: Replace enum hal_bool with bool
Date: Mon, 28 Jul 2008 22:47:16 -0700
Message-ID: <d17bb934a0517ef944db8d1054bffc6fec429ac3.1217309551.git.lrodriguez@atheros.com> (sfid-20080729_074745_529822_9BBEF7D3)
In-Reply-To: <4800d552efce6350888c68b859f66767196d720b.1217309551.git.lrodriguez@atheros.com>
References: <4800d552efce6350888c68b859f66767196d720b.1217309551.git.lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith <Sujith.Manoharan@atheros.com>

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 24dad48..1f858b0 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -116,11 +116,6 @@ struct ath_rx_status {
 #define ATH9K_RX_DELIM_CRC_POST   0x20
 #define ATH9K_RX_DECRYPT_BUSY     0x40
 
-enum hal_bool {
-	AH_FALSE = 0,
-	AH_TRUE = 1,
-};
-
 #define	HAL_RXKEYIX_INVALID	((u_int8_t)-1)
 #define	HAL_TXKEYIX_INVALID	((u_int)-1)
 
@@ -482,11 +477,11 @@ struct hal_channel_internal {
 	int8_t maxRegTxPower;
 	int8_t maxTxPower;
 	int8_t minTxPower;
-	enum hal_bool bssSendHere;
+	bool bssSendHere;
 	u_int8_t gainI;
-	enum hal_bool iqCalValid;
+	bool iqCalValid;
 	int32_t CalValid;
-	enum hal_bool oneTimeCalsDone;
+	bool oneTimeCalsDone;
 	int8_t iCoff;
 	int8_t qCoff;
 	int16_t rawNoiseFloor;
@@ -936,13 +931,13 @@ struct ath_hal {
 	u_int16_t ah_currentRD2G;
 	char ah_iso[4];
 	enum start_adhoc_option ah_adHocMode;
-	enum hal_bool ah_commonMode;
+	bool ah_commonMode;
 	struct hal_channel_internal ah_channels[150];
 	u_int ah_nchan;
 	struct hal_channel_internal *ah_curchan;
 	u_int16_t ah_rfsilent;
-	enum hal_bool ah_rfkillEnabled;
-	enum hal_bool ah_isPciExpress;
+	bool ah_rfkillEnabled;
+	bool ah_isPciExpress;
 	u_int16_t ah_txTrigLevel;
 #ifndef ATH_NF_PER_CHAN
 	struct hal_nfcal_hist nfCalHist[NUM_NF_READINGS];
@@ -1003,36 +998,35 @@ struct ath_hal *ath9k_hw_attach(u_int16_t devid,
 				struct ath_softc *sc,
 				void __iomem *mem,
 				enum hal_status *error);
-enum hal_bool ath9k_regd_init_channels(struct ath_hal *ah,
-				       struct hal_channel *chans,
-				       u_int maxchans, u_int *nchans,
-				       u_int8_t *regclassids,
-				       u_int maxregids, u_int *nregids,
-				       u_int16_t cc, u_int32_t modeSelect,
-				       enum hal_bool enableOutdoor,
-				       enum hal_bool
-				       enableExtendedChannels);
+bool ath9k_regd_init_channels(struct ath_hal *ah,
+			      struct hal_channel *chans,
+			      u_int maxchans, u_int *nchans,
+			      u_int8_t *regclassids,
+			      u_int maxregids, u_int *nregids,
+			      u_int16_t cc, u_int32_t modeSelect,
+			      bool enableOutdoor,
+			      bool enableExtendedChannels);
 u_int ath9k_hw_mhz2ieee(struct ath_hal *ah, u_int freq, u_int flags);
 enum hal_int ath9k_hw_set_interrupts(struct ath_hal *ah,
 				     enum hal_int ints);
-enum hal_bool ath9k_hw_reset(struct ath_hal *ah, enum hal_opmode opmode,
-			     struct hal_channel *chan,
-			     enum hal_ht_macmode macmode,
-			     u_int8_t txchainmask, u_int8_t rxchainmask,
-			     enum hal_ht_extprotspacing extprotspacing,
-			     enum hal_bool bChannelChange,
-			     enum hal_status *status);
-enum hal_bool ath9k_hw_phy_disable(struct ath_hal *ah);
+bool ath9k_hw_reset(struct ath_hal *ah, enum hal_opmode opmode,
+		    struct hal_channel *chan,
+		    enum hal_ht_macmode macmode,
+		    u_int8_t txchainmask, u_int8_t rxchainmask,
+		    enum hal_ht_extprotspacing extprotspacing,
+		    bool bChannelChange,
+		    enum hal_status *status);
+bool ath9k_hw_phy_disable(struct ath_hal *ah);
 void ath9k_hw_reset_calvalid(struct ath_hal *ah, struct hal_channel *chan,
-			     enum hal_bool *isCalDone);
+			     bool *isCalDone);
 void ath9k_hw_ani_monitor(struct ath_hal *ah,
 			  const struct hal_node_stats *stats,
 			  struct hal_channel *chan);
-enum hal_bool ath9k_hw_calibrate(struct ath_hal *ah,
-				 struct hal_channel *chan,
-				 u_int8_t rxchainmask,
-				 enum hal_bool longcal,
-				 enum hal_bool *isCalDone);
+bool ath9k_hw_calibrate(struct ath_hal *ah,
+			struct hal_channel *chan,
+			u_int8_t rxchainmask,
+			bool longcal,
+			bool *isCalDone);
 int16_t ath9k_hw_getchan_noise(struct ath_hal *ah,
 			       struct hal_channel *chan);
 void ath9k_hw_write_associd(struct ath_hal *ah, const u_int8_t *bssid,
@@ -1040,65 +1034,65 @@ void ath9k_hw_write_associd(struct ath_hal *ah, const u_int8_t *bssid,
 void ath9k_hw_setrxfilter(struct ath_hal *ah, u_int32_t bits);
 void ath9k_hw_write_associd(struct ath_hal *ah, const u_int8_t *bssid,
 			    u_int16_t assocId);
-enum hal_bool ath9k_hw_stoptxdma(struct ath_hal *ah, u_int q);
+bool ath9k_hw_stoptxdma(struct ath_hal *ah, u_int q);
 void ath9k_hw_reset_tsf(struct ath_hal *ah);
-enum hal_bool ath9k_hw_keyisvalid(struct ath_hal *ah, u_int16_t entry);
-enum hal_bool ath9k_hw_keysetmac(struct ath_hal *ah, u_int16_t entry,
-				 const u_int8_t *mac);
-enum hal_bool ath9k_hw_set_keycache_entry(struct ath_hal *ah,
-					  u_int16_t entry,
-					  const struct hal_keyval *k,
-					  const u_int8_t *mac,
-					  int xorKey);
-enum hal_bool ath9k_hw_set_tsfadjust(struct ath_hal *ah,
-				     u_int32_t setting);
+bool ath9k_hw_keyisvalid(struct ath_hal *ah, u_int16_t entry);
+bool ath9k_hw_keysetmac(struct ath_hal *ah, u_int16_t entry,
+			const u_int8_t *mac);
+bool ath9k_hw_set_keycache_entry(struct ath_hal *ah,
+				 u_int16_t entry,
+				 const struct hal_keyval *k,
+				 const u_int8_t *mac,
+				 int xorKey);
+bool ath9k_hw_set_tsfadjust(struct ath_hal *ah,
+			    u_int32_t setting);
 void ath9k_hw_configpcipowersave(struct ath_hal *ah, int restore);
-enum hal_bool ath9k_hw_intrpend(struct ath_hal *ah);
-enum hal_bool ath9k_hw_getisr(struct ath_hal *ah, enum hal_int *masked);
-enum hal_bool ath9k_hw_updatetxtriglevel(struct ath_hal *ah,
-					 enum hal_bool bIncTrigLevel);
+bool ath9k_hw_intrpend(struct ath_hal *ah);
+bool ath9k_hw_getisr(struct ath_hal *ah, enum hal_int *masked);
+bool ath9k_hw_updatetxtriglevel(struct ath_hal *ah,
+				bool bIncTrigLevel);
 void ath9k_hw_procmibevent(struct ath_hal *ah,
 			   const struct hal_node_stats *stats);
-enum hal_bool ath9k_hw_setrxabort(struct ath_hal *ah, enum hal_bool set);
+bool ath9k_hw_setrxabort(struct ath_hal *ah, bool set);
 void ath9k_hw_set11nmac2040(struct ath_hal *ah, enum hal_ht_macmode mode);
-enum hal_bool ath9k_hw_phycounters(struct ath_hal *ah);
-enum hal_bool ath9k_hw_keyreset(struct ath_hal *ah, u_int16_t entry);
-enum hal_bool ath9k_hw_getcapability(struct ath_hal *ah,
-				     enum hal_capability_type type,
-				     u_int32_t capability,
-				     u_int32_t *result);
-enum hal_bool ath9k_hw_setcapability(struct ath_hal *ah,
-				     enum hal_capability_type type,
-				     u_int32_t capability,
-				     u_int32_t setting,
-				     enum hal_status *status);
+bool ath9k_hw_phycounters(struct ath_hal *ah);
+bool ath9k_hw_keyreset(struct ath_hal *ah, u_int16_t entry);
+bool ath9k_hw_getcapability(struct ath_hal *ah,
+			    enum hal_capability_type type,
+			    u_int32_t capability,
+			    u_int32_t *result);
+bool ath9k_hw_setcapability(struct ath_hal *ah,
+			    enum hal_capability_type type,
+			    u_int32_t capability,
+			    u_int32_t setting,
+			    enum hal_status *status);
 u_int ath9k_hw_getdefantenna(struct ath_hal *ah);
 void ath9k_hw_getmac(struct ath_hal *ah, u_int8_t *mac);
 void ath9k_hw_getbssidmask(struct ath_hal *ah, u_int8_t *mask);
-enum hal_bool ath9k_hw_setbssidmask(struct ath_hal *ah,
-				    const u_int8_t *mask);
-enum hal_bool ath9k_hw_setpower(struct ath_hal *ah,
-				enum hal_power_mode mode);
+bool ath9k_hw_setbssidmask(struct ath_hal *ah,
+			   const u_int8_t *mask);
+bool ath9k_hw_setpower(struct ath_hal *ah,
+		       enum hal_power_mode mode);
 enum hal_int ath9k_hw_intrget(struct ath_hal *ah);
 u_int64_t ath9k_hw_gettsf64(struct ath_hal *ah);
 u_int ath9k_hw_getdefantenna(struct ath_hal *ah);
-enum hal_bool ath9k_hw_setslottime(struct ath_hal *ah, u_int us);
-enum hal_bool ath9k_hw_setantennaswitch(struct ath_hal *ah,
-					enum hal_ant_setting settings,
-					struct hal_channel *chan,
-					u_int8_t *tx_chainmask,
-					u_int8_t *rx_chainmask,
-					u_int8_t *antenna_cfgd);
+bool ath9k_hw_setslottime(struct ath_hal *ah, u_int us);
+bool ath9k_hw_setantennaswitch(struct ath_hal *ah,
+			       enum hal_ant_setting settings,
+			       struct hal_channel *chan,
+			       u_int8_t *tx_chainmask,
+			       u_int8_t *rx_chainmask,
+			       u_int8_t *antenna_cfgd);
 void ath9k_hw_setantenna(struct ath_hal *ah, u_int antenna);
 enum hal_status ath9k_hw_select_antconfig(struct ath_hal *ah,
 					  u_int32_t cfg);
-enum hal_bool ath9k_hw_puttxbuf(struct ath_hal *ah, u_int q,
-				u_int32_t txdp);
-enum hal_bool ath9k_hw_txstart(struct ath_hal *ah, u_int q);
+bool ath9k_hw_puttxbuf(struct ath_hal *ah, u_int q,
+		       u_int32_t txdp);
+bool ath9k_hw_txstart(struct ath_hal *ah, u_int q);
 u_int16_t ath9k_hw_computetxtime(struct ath_hal *ah,
 				 const struct hal_rate_table *rates,
 				 u_int32_t frameLen, u_int16_t rateix,
-				 enum hal_bool shortPreamble);
+				 bool shortPreamble);
 void ath9k_hw_set11n_ratescenario(struct ath_hal *ah, struct ath_desc *ds,
 				  struct ath_desc *lastds,
 				  u_int durUpdateEn, u_int rtsctsRate,
@@ -1110,25 +1104,25 @@ void ath9k_hw_set11n_burstduration(struct ath_hal *ah,
 				   u_int burstDuration);
 void ath9k_hw_cleartxdesc(struct ath_hal *ah, struct ath_desc *ds);
 u_int32_t ath9k_hw_reverse_bits(u_int32_t val, u_int32_t n);
-enum hal_bool ath9k_hw_resettxqueue(struct ath_hal *ah, u_int q);
+bool ath9k_hw_resettxqueue(struct ath_hal *ah, u_int q);
 u_int ath9k_regd_get_ctl(struct ath_hal *ah, struct hal_channel *chan);
 u_int ath9k_regd_get_antenna_allowed(struct ath_hal *ah,
-	struct hal_channel *chan);
+				     struct hal_channel *chan);
 u_int ath9k_hw_mhz2ieee(struct ath_hal *ah, u_int freq, u_int flags);
-enum hal_bool ath9k_hw_gettxqueueprops(struct ath_hal *ah, int q,
-	struct hal_txq_info *qInfo);
-enum hal_bool ath9k_hw_settxqueueprops(struct ath_hal *ah, int q,
-				       const struct hal_txq_info *qInfo);
+bool ath9k_hw_gettxqueueprops(struct ath_hal *ah, int q,
+			      struct hal_txq_info *qInfo);
+bool ath9k_hw_settxqueueprops(struct ath_hal *ah, int q,
+			      const struct hal_txq_info *qInfo);
 struct hal_channel_internal *ath9k_regd_check_channel(struct ath_hal *ah,
-	const struct hal_channel *c);
+					      const struct hal_channel *c);
 void ath9k_hw_set11n_txdesc(struct ath_hal *ah, struct ath_desc *ds,
-	u_int pktLen, enum hal_pkt_type type,
-	u_int txPower, u_int keyIx,
-	enum hal_key_type keyType, u_int flags);
-enum hal_bool ath9k_hw_filltxdesc(struct ath_hal *ah, struct ath_desc *ds,
-	u_int segLen, enum hal_bool firstSeg,
-	enum hal_bool lastSeg,
-	const struct ath_desc *ds0);
+			    u_int pktLen, enum hal_pkt_type type,
+			    u_int txPower, u_int keyIx,
+			    enum hal_key_type keyType, u_int flags);
+bool ath9k_hw_filltxdesc(struct ath_hal *ah, struct ath_desc *ds,
+			 u_int segLen, bool firstSeg,
+			 bool lastSeg,
+			 const struct ath_desc *ds0);
 u_int32_t ath9k_hw_GetMibCycleCountsPct(struct ath_hal *ah,
 					u_int32_t *rxc_pcnt,
 					u_int32_t *rxf_pcnt,
@@ -1138,18 +1132,18 @@ void ath9k_hw_beaconinit(struct ath_hal *ah,
 			 u_int32_t next_beacon, u_int32_t beacon_period);
 void ath9k_hw_set_sta_beacon_timers(struct ath_hal *ah,
 				    const struct hal_beacon_state *bs);
-enum hal_bool ath9k_hw_setuprxdesc(struct ath_hal *ah, struct ath_desc *ds,
-				   u_int32_t size, u_int flags);
+bool ath9k_hw_setuprxdesc(struct ath_hal *ah, struct ath_desc *ds,
+			  u_int32_t size, u_int flags);
 void ath9k_hw_putrxbuf(struct ath_hal *ah, u_int32_t rxdp);
 void ath9k_hw_rxena(struct ath_hal *ah);
 void ath9k_hw_setopmode(struct ath_hal *ah);
-enum hal_bool ath9k_hw_setmac(struct ath_hal *ah, const u_int8_t *mac);
+bool ath9k_hw_setmac(struct ath_hal *ah, const u_int8_t *mac);
 void ath9k_hw_setmcastfilter(struct ath_hal *ah, u_int32_t filter0,
 			     u_int32_t filter1);
 u_int32_t ath9k_hw_getrxfilter(struct ath_hal *ah);
 void ath9k_hw_startpcureceive(struct ath_hal *ah);
 void ath9k_hw_stoppcurecv(struct ath_hal *ah);
-enum hal_bool ath9k_hw_stopdmarecv(struct ath_hal *ah);
+bool ath9k_hw_stopdmarecv(struct ath_hal *ah);
 enum hal_status ath9k_hw_rxprocdesc(struct ath_hal *ah,
 				    struct ath_desc *ds, u_int32_t pa,
 				    struct ath_desc *nds, u_int64_t tsf);
@@ -1161,26 +1155,26 @@ void ath9k_hw_set11n_aggr_middle(struct ath_hal *ah, struct ath_desc *ds,
 void ath9k_hw_set11n_aggr_first(struct ath_hal *ah, struct ath_desc *ds,
 				u_int aggrLen);
 void ath9k_hw_set11n_aggr_last(struct ath_hal *ah, struct ath_desc *ds);
-enum hal_bool ath9k_hw_releasetxqueue(struct ath_hal *ah, u_int q);
+bool ath9k_hw_releasetxqueue(struct ath_hal *ah, u_int q);
 void ath9k_hw_gettxintrtxqs(struct ath_hal *ah, u_int32_t *txqs);
 void ath9k_hw_clr11n_aggr(struct ath_hal *ah, struct ath_desc *ds);
 void ath9k_hw_set11n_virtualmorefrag(struct ath_hal *ah,
 				     struct ath_desc *ds, u_int vmf);
-enum hal_bool ath9k_hw_set_txpowerlimit(struct ath_hal *ah, u_int32_t limit);
-enum hal_bool ath9k_regd_is_public_safety_sku(struct ath_hal *ah);
+bool ath9k_hw_set_txpowerlimit(struct ath_hal *ah, u_int32_t limit);
+bool ath9k_regd_is_public_safety_sku(struct ath_hal *ah);
 int ath9k_hw_setuptxqueue(struct ath_hal *ah, enum hal_tx_queue type,
 			  const struct hal_txq_info *qInfo);
 u_int32_t ath9k_hw_numtxpending(struct ath_hal *ah, u_int q);
 const char *ath9k_hw_probe(u_int16_t vendorid, u_int16_t devid);
-enum hal_bool ath9k_hw_disable(struct ath_hal *ah);
+bool ath9k_hw_disable(struct ath_hal *ah);
 void ath9k_hw_rfdetach(struct ath_hal *ah);
 void ath9k_hw_get_channel_centers(struct ath_hal *ah,
 				  struct hal_channel_internal *chan,
 				  struct chan_centers *centers);
-enum hal_bool ath9k_get_channel_edges(struct ath_hal *ah,
-				      u_int16_t flags, u_int16_t *low,
-				      u_int16_t *high);
-enum hal_bool ath9k_hw_get_chip_power_limits(struct ath_hal *ah,
-					     struct hal_channel *chans,
-					     u_int32_t nchans);
+bool ath9k_get_channel_edges(struct ath_hal *ah,
+			     u_int16_t flags, u_int16_t *low,
+			     u_int16_t *high);
+bool ath9k_hw_get_chip_power_limits(struct ath_hal *ah,
+				    struct hal_channel *chans,
+				    u_int32_t nchans);
 #endif
diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index b2f44b1..699159e 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -128,8 +128,8 @@ static void ath_beacon_setup(struct ath_softc *sc,
 	/* NB: beacon's BufLen must be a multiple of 4 bytes */
 	ath9k_hw_filltxdesc(ah, ds
 			   , roundup(skb->len, 4) /* buffer length */
-			   , AH_TRUE /* first segment */
-			   , AH_TRUE /* last segment */
+			   , true /* first segment */
+			   , true /* last segment */
 			   , ds /* first descriptor */
 		);
 
@@ -273,7 +273,7 @@ static struct ath_buf *ath_beacon_generate(struct ath_softc *sc, int if_id)
 		 * acquires txq lock inside.
 		 */
 		if (sc->sc_nvaps > 1 && sc->sc_stagbeacons) {
-			ath_tx_draintxq(sc, cabq, AH_FALSE);
+			ath_tx_draintxq(sc, cabq, false);
 			DPRINTF(sc, ATH_DEBUG_BEACON,
 				"%s: flush previous cabq traffic\n", __func__);
 		}
diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index d9c7561..99ba213 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -19,7 +19,7 @@
 #include "core.h"
 #include "regd.h"
 
-static int ath_outdoor = AH_FALSE;		/* enable outdoor use */
+static int ath_outdoor;		/* enable outdoor use */
 
 static const u_int8_t ath_bcast_mac[ETH_ALEN] =
     { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
@@ -176,8 +176,8 @@ static int ath_rate_setup(struct ath_softc *sc, enum wireless_mode mode)
 
 static int ath_getchannels(struct ath_softc *sc,
 			   u_int cc,
-			   enum hal_bool outDoor,
-			   enum hal_bool xchanMode)
+			   bool outDoor,
+			   bool xchanMode)
 {
 	struct ath_hal *ah = sc->sc_ah;
 	struct hal_channel *chans;
@@ -311,7 +311,7 @@ static int ath_stop(struct ath_softc *sc)
 
 	if (!sc->sc_invalid)
 		ath9k_hw_set_interrupts(ah, 0);
-	ath_draintxq(sc, AH_FALSE);
+	ath_draintxq(sc, false);
 	if (!sc->sc_invalid) {
 		ath_stoprecv(sc);
 		ath9k_hw_phy_disable(ah);
@@ -379,7 +379,7 @@ void ath_scan_end(struct ath_softc *sc)
 int ath_set_channel(struct ath_softc *sc, struct hal_channel *hchan)
 {
 	struct ath_hal *ah = sc->sc_ah;
-	enum hal_bool fastcc = AH_TRUE, stopped;
+	bool fastcc = true, stopped;
 	enum hal_ht_macmode ht_macmode;
 
 	if (sc->sc_invalid)	/* if the device is invalid or removed */
@@ -410,7 +410,7 @@ int ath_set_channel(struct ath_softc *sc, struct hal_channel *hchan)
 		 * the relevant bits of the h/w.
 		 */
 		ath9k_hw_set_interrupts(ah, 0);	/* disable interrupts */
-		ath_draintxq(sc, AH_FALSE);	/* clear pending tx frames */
+		ath_draintxq(sc, false);	/* clear pending tx frames */
 		stopped = ath_stoprecv(sc);	/* turn off frame recv */
 
 		/* XXX: do not flush receive queue here. We don't want
@@ -418,7 +418,7 @@ int ath_set_channel(struct ath_softc *sc, struct hal_channel *hchan)
 		 * changing channel. */
 
 		if (!stopped || sc->sc_full_reset)
-			fastcc = AH_FALSE;
+			fastcc = false;
 
 		spin_lock_bh(&sc->sc_resetlock);
 		if (!ath9k_hw_reset(ah, sc->sc_opmode, hchan,
@@ -507,8 +507,7 @@ int ath_chainmask_sel_logic(struct ath_softc *sc, struct ath_node *an)
 	 * sc_chainmask_auto_sel is used for internal global auto-switching
 	 * enabled/disabled setting
 	 */
-	if ((sc->sc_no_tx_3_chains == AH_FALSE) ||
-	    (sc->sc_config.chainmask_sel == AH_FALSE)) {
+	if (!sc->sc_no_tx_3_chains || !sc->sc_config.chainmask_sel) {
 		cm->cur_tx_mask = sc->sc_tx_chainmask;
 		return cm->cur_tx_mask;
 	}
@@ -716,12 +715,12 @@ int ath_vap_detach(struct ath_softc *sc, int if_id)
 	 * XXX can we do this w/o affecting other vap's?
 	 */
 	ath9k_hw_set_interrupts(ah, 0);	/* disable interrupts */
-	ath_draintxq(sc, AH_FALSE);	/* stop xmit side */
+	ath_draintxq(sc, false);	/* stop xmit side */
 	ath_stoprecv(sc);	/* stop recv side */
 	ath_flushrecv(sc);	/* flush recv queue */
 
 	/* Reclaim any pending mcast bufs on the vap. */
-	ath_tx_draintxq(sc, &avp->av_mcastq, AH_FALSE);
+	ath_tx_draintxq(sc, &avp->av_mcastq, false);
 
 	if (sc->sc_opmode == HAL_M_HOSTAP && sc->sc_nostabeacons)
 		sc->sc_nostabeacons = 0;
@@ -791,7 +790,7 @@ int ath_open(struct ath_softc *sc, struct hal_channel *initial_chan)
 	spin_lock_bh(&sc->sc_resetlock);
 	if (!ath9k_hw_reset(ah, sc->sc_opmode, &sc->sc_curchan, ht_macmode,
 			   sc->sc_tx_chainmask, sc->sc_rx_chainmask,
-			   sc->sc_ht_extprotspacing, AH_FALSE, &status)) {
+			   sc->sc_ht_extprotspacing, false, &status)) {
 		DPRINTF(sc, ATH_DEBUG_FATAL,
 			"%s: unable to reset hardware; hal status %u "
 			"(freq %u flags 0x%x)\n", __func__, status,
@@ -928,7 +927,7 @@ int ath_reset(struct ath_softc *sc)
 	if (!ath9k_hw_reset(ah, sc->sc_opmode, &sc->sc_curchan,
 			   ht_macmode,
 			   sc->sc_tx_chainmask, sc->sc_rx_chainmask,
-			   sc->sc_ht_extprotspacing, AH_FALSE, &status)) {
+			   sc->sc_ht_extprotspacing, false, &status)) {
 		DPRINTF(sc, ATH_DEBUG_FATAL,
 			"%s: unable to reset hardware; hal status %u\n",
 			__func__, status);
@@ -1026,7 +1025,7 @@ int ath_intr(struct ath_softc *sc)
 
 			if (status & HAL_INT_TXURN)
 				/* bump tx trigger level */
-				ath9k_hw_updatetxtriglevel(ah, AH_TRUE);
+				ath9k_hw_updatetxtriglevel(ah, true);
 			/* XXX: optimize this */
 			if (status & HAL_INT_RX)
 				sched = ATH_ISR_SCHED;
@@ -1334,7 +1333,7 @@ int ath_init(u_int16_t devid, struct ath_softc *sc)
 	 */
 	sc->sc_no_tx_3_chains =
 	    (ah->ah_caps.halTxChainMask == ATH_CHAINMASK_SEL_3X3) ?
-		AH_TRUE : AH_FALSE;
+		true : false;
 	sc->sc_config.chainmask_sel = sc->sc_no_tx_3_chains;
 
 	sc->sc_tx_chainmask = ah->ah_caps.halTxChainMask;
@@ -1347,8 +1346,7 @@ int ath_init(u_int16_t devid, struct ath_softc *sc)
 	sc->sc_rxchaindetect_delta5GHz = 30;
 	sc->sc_rxchaindetect_delta2GHz = 30;
 
-	ath9k_hw_setcapability(ah, HAL_CAP_DIVERSITY, 1, AH_TRUE, NULL);
-
+	ath9k_hw_setcapability(ah, HAL_CAP_DIVERSITY, 1, true, NULL);
 	sc->sc_defant = ath9k_hw_getdefantenna(ah);
 
 	/*
@@ -1560,12 +1558,12 @@ int ath_keyset(struct ath_softc *sc,
 	       struct hal_keyval *hk,
 	       const u_int8_t mac[ETH_ALEN])
 {
-	enum hal_bool status;
+	bool status;
 
 	status = ath9k_hw_set_keycache_entry(sc->sc_ah,
-		keyix, hk, mac, AH_FALSE);
+		keyix, hk, mac, false);
 
-	return status != AH_FALSE;
+	return status != false;
 }
 
 /***********************/
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 6acf3a6..4eaf942 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -370,7 +370,7 @@ struct ath_arx {
 };
 
 int ath_startrecv(struct ath_softc *sc);
-enum hal_bool ath_stoprecv(struct ath_softc *sc);
+bool ath_stoprecv(struct ath_softc *sc);
 void ath_flushrecv(struct ath_softc *sc);
 u_int32_t ath_calcrxfilter(struct ath_softc *sc);
 void ath_rx_node_init(struct ath_softc *sc, struct ath_node *an);
@@ -551,9 +551,9 @@ struct ath_tx_stat {
 struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype);
 void ath_tx_cleanupq(struct ath_softc *sc, struct ath_txq *txq);
 int ath_tx_setup(struct ath_softc *sc, int haltype);
-void ath_draintxq(struct ath_softc *sc, enum hal_bool retry_tx);
+void ath_draintxq(struct ath_softc *sc, bool retry_tx);
 void ath_tx_draintxq(struct ath_softc *sc,
-	struct ath_txq *txq, enum hal_bool retry_tx);
+	struct ath_txq *txq, bool retry_tx);
 void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an);
 void ath_tx_node_cleanup(struct ath_softc *sc,
 	struct ath_node *an, bool bh_flag);
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 71f6574..081fee3 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -111,14 +111,14 @@ static struct hal_rate_table ar5416_11a_table = {
 	8,
 	{0},
 	{
-		{AH_TRUE, PHY_OFDM, 6000, 0x0b, 0x00, (0x80 | 12), 0},
-		{AH_TRUE, PHY_OFDM, 9000, 0x0f, 0x00, 18, 0},
-		{AH_TRUE, PHY_OFDM, 12000, 0x0a, 0x00, (0x80 | 24), 2},
-		{AH_TRUE, PHY_OFDM, 18000, 0x0e, 0x00, 36, 2},
-		{AH_TRUE, PHY_OFDM, 24000, 0x09, 0x00, (0x80 | 48), 4},
-		{AH_TRUE, PHY_OFDM, 36000, 0x0d, 0x00, 72, 4},
-		{AH_TRUE, PHY_OFDM, 48000, 0x08, 0x00, 96, 4},
-		{AH_TRUE, PHY_OFDM, 54000, 0x0c, 0x00, 108, 4}
+		{true, PHY_OFDM, 6000, 0x0b, 0x00, (0x80 | 12), 0},
+		{true, PHY_OFDM, 9000, 0x0f, 0x00, 18, 0},
+		{true, PHY_OFDM, 12000, 0x0a, 0x00, (0x80 | 24), 2},
+		{true, PHY_OFDM, 18000, 0x0e, 0x00, 36, 2},
+		{true, PHY_OFDM, 24000, 0x09, 0x00, (0x80 | 48), 4},
+		{true, PHY_OFDM, 36000, 0x0d, 0x00, 72, 4},
+		{true, PHY_OFDM, 48000, 0x08, 0x00, 96, 4},
+		{true, PHY_OFDM, 54000, 0x0c, 0x00, 108, 4}
 	},
 };
 
@@ -126,10 +126,10 @@ static struct hal_rate_table ar5416_11b_table = {
 	4,
 	{0},
 	{
-		{AH_TRUE, PHY_CCK, 1000, 0x1b, 0x00, (0x80 | 2), 0},
-		{AH_TRUE, PHY_CCK, 2000, 0x1a, 0x04, (0x80 | 4), 1},
-		{AH_TRUE, PHY_CCK, 5500, 0x19, 0x04, (0x80 | 11), 1},
-		{AH_TRUE, PHY_CCK, 11000, 0x18, 0x04, (0x80 | 22), 1}
+		{true, PHY_CCK, 1000, 0x1b, 0x00, (0x80 | 2), 0},
+		{true, PHY_CCK, 2000, 0x1a, 0x04, (0x80 | 4), 1},
+		{true, PHY_CCK, 5500, 0x19, 0x04, (0x80 | 11), 1},
+		{true, PHY_CCK, 11000, 0x18, 0x04, (0x80 | 22), 1}
 	},
 };
 
@@ -137,19 +137,19 @@ static struct hal_rate_table ar5416_11g_table = {
 	12,
 	{0},
 	{
-		{AH_TRUE, PHY_CCK, 1000, 0x1b, 0x00, (0x80 | 2), 0},
-		{AH_TRUE, PHY_CCK, 2000, 0x1a, 0x04, (0x80 | 4), 1},
-		{AH_TRUE, PHY_CCK, 5500, 0x19, 0x04, (0x80 | 11), 2},
-		{AH_TRUE, PHY_CCK, 11000, 0x18, 0x04, (0x80 | 22), 3},
-
-		{AH_FALSE, PHY_OFDM, 6000, 0x0b, 0x00, 12, 4},
-		{AH_FALSE, PHY_OFDM, 9000, 0x0f, 0x00, 18, 4},
-		{AH_TRUE, PHY_OFDM, 12000, 0x0a, 0x00, 24, 6},
-		{AH_TRUE, PHY_OFDM, 18000, 0x0e, 0x00, 36, 6},
-		{AH_TRUE, PHY_OFDM, 24000, 0x09, 0x00, 48, 8},
-		{AH_TRUE, PHY_OFDM, 36000, 0x0d, 0x00, 72, 8},
-		{AH_TRUE, PHY_OFDM, 48000, 0x08, 0x00, 96, 8},
-		{AH_TRUE, PHY_OFDM, 54000, 0x0c, 0x00, 108, 8}
+		{true, PHY_CCK, 1000, 0x1b, 0x00, (0x80 | 2), 0},
+		{true, PHY_CCK, 2000, 0x1a, 0x04, (0x80 | 4), 1},
+		{true, PHY_CCK, 5500, 0x19, 0x04, (0x80 | 11), 2},
+		{true, PHY_CCK, 11000, 0x18, 0x04, (0x80 | 22), 3},
+
+		{false, PHY_OFDM, 6000, 0x0b, 0x00, 12, 4},
+		{false, PHY_OFDM, 9000, 0x0f, 0x00, 18, 4},
+		{true, PHY_OFDM, 12000, 0x0a, 0x00, 24, 6},
+		{true, PHY_OFDM, 18000, 0x0e, 0x00, 36, 6},
+		{true, PHY_OFDM, 24000, 0x09, 0x00, 48, 8},
+		{true, PHY_OFDM, 36000, 0x0d, 0x00, 72, 8},
+		{true, PHY_OFDM, 48000, 0x08, 0x00, 96, 8},
+		{true, PHY_OFDM, 54000, 0x0c, 0x00, 108, 8}
 	},
 };
 
@@ -157,35 +157,35 @@ static struct hal_rate_table ar5416_11ng_table = {
 	28,
 	{0},
 	{
-		{AH_TRUE, PHY_CCK, 1000, 0x1b, 0x00, (0x80 | 2), 0},
-		{AH_TRUE, PHY_CCK, 2000, 0x1a, 0x04, (0x80 | 4), 1},
-		{AH_TRUE, PHY_CCK, 5500, 0x19, 0x04, (0x80 | 11), 2},
-		{AH_TRUE, PHY_CCK, 11000, 0x18, 0x04, (0x80 | 22), 3},
-
-		{AH_FALSE, PHY_OFDM, 6000, 0x0b, 0x00, 12, 4},
-		{AH_FALSE, PHY_OFDM, 9000, 0x0f, 0x00, 18, 4},
-		{AH_TRUE, PHY_OFDM, 12000, 0x0a, 0x00, 24, 6},
-		{AH_TRUE, PHY_OFDM, 18000, 0x0e, 0x00, 36, 6},
-		{AH_TRUE, PHY_OFDM, 24000, 0x09, 0x00, 48, 8},
-		{AH_TRUE, PHY_OFDM, 36000, 0x0d, 0x00, 72, 8},
-		{AH_TRUE, PHY_OFDM, 48000, 0x08, 0x00, 96, 8},
-		{AH_TRUE, PHY_OFDM, 54000, 0x0c, 0x00, 108, 8},
-		{AH_TRUE, PHY_HT, 6500, 0x80, 0x00, 0, 4},
-		{AH_TRUE, PHY_HT, 13000, 0x81, 0x00, 1, 6},
-		{AH_TRUE, PHY_HT, 19500, 0x82, 0x00, 2, 6},
-		{AH_TRUE, PHY_HT, 26000, 0x83, 0x00, 3, 8},
-		{AH_TRUE, PHY_HT, 39000, 0x84, 0x00, 4, 8},
-		{AH_TRUE, PHY_HT, 52000, 0x85, 0x00, 5, 8},
-		{AH_TRUE, PHY_HT, 58500, 0x86, 0x00, 6, 8},
-		{AH_TRUE, PHY_HT, 65000, 0x87, 0x00, 7, 8},
-		{AH_TRUE, PHY_HT, 13000, 0x88, 0x00, 8, 4},
-		{AH_TRUE, PHY_HT, 26000, 0x89, 0x00, 9, 6},
-		{AH_TRUE, PHY_HT, 39000, 0x8a, 0x00, 10, 6},
-		{AH_TRUE, PHY_HT, 52000, 0x8b, 0x00, 11, 8},
-		{AH_TRUE, PHY_HT, 78000, 0x8c, 0x00, 12, 8},
-		{AH_TRUE, PHY_HT, 104000, 0x8d, 0x00, 13, 8},
-		{AH_TRUE, PHY_HT, 117000, 0x8e, 0x00, 14, 8},
-		{AH_TRUE, PHY_HT, 130000, 0x8f, 0x00, 15, 8},
+		{true, PHY_CCK, 1000, 0x1b, 0x00, (0x80 | 2), 0},
+		{true, PHY_CCK, 2000, 0x1a, 0x04, (0x80 | 4), 1},
+		{true, PHY_CCK, 5500, 0x19, 0x04, (0x80 | 11), 2},
+		{true, PHY_CCK, 11000, 0x18, 0x04, (0x80 | 22), 3},
+
+		{false, PHY_OFDM, 6000, 0x0b, 0x00, 12, 4},
+		{false, PHY_OFDM, 9000, 0x0f, 0x00, 18, 4},
+		{true, PHY_OFDM, 12000, 0x0a, 0x00, 24, 6},
+		{true, PHY_OFDM, 18000, 0x0e, 0x00, 36, 6},
+		{true, PHY_OFDM, 24000, 0x09, 0x00, 48, 8},
+		{true, PHY_OFDM, 36000, 0x0d, 0x00, 72, 8},
+		{true, PHY_OFDM, 48000, 0x08, 0x00, 96, 8},
+		{true, PHY_OFDM, 54000, 0x0c, 0x00, 108, 8},
+		{true, PHY_HT, 6500, 0x80, 0x00, 0, 4},
+		{true, PHY_HT, 13000, 0x81, 0x00, 1, 6},
+		{true, PHY_HT, 19500, 0x82, 0x00, 2, 6},
+		{true, PHY_HT, 26000, 0x83, 0x00, 3, 8},
+		{true, PHY_HT, 39000, 0x84, 0x00, 4, 8},
+		{true, PHY_HT, 52000, 0x85, 0x00, 5, 8},
+		{true, PHY_HT, 58500, 0x86, 0x00, 6, 8},
+		{true, PHY_HT, 65000, 0x87, 0x00, 7, 8},
+		{true, PHY_HT, 13000, 0x88, 0x00, 8, 4},
+		{true, PHY_HT, 26000, 0x89, 0x00, 9, 6},
+		{true, PHY_HT, 39000, 0x8a, 0x00, 10, 6},
+		{true, PHY_HT, 52000, 0x8b, 0x00, 11, 8},
+		{true, PHY_HT, 78000, 0x8c, 0x00, 12, 8},
+		{true, PHY_HT, 104000, 0x8d, 0x00, 13, 8},
+		{true, PHY_HT, 117000, 0x8e, 0x00, 14, 8},
+		{true, PHY_HT, 130000, 0x8f, 0x00, 15, 8},
 	},
 };
 
@@ -193,30 +193,30 @@ static struct hal_rate_table ar5416_11na_table = {
 	24,
 	{0},
 	{
-		{AH_TRUE, PHY_OFDM, 6000, 0x0b, 0x00, (0x80 | 12), 0},
-		{AH_TRUE, PHY_OFDM, 9000, 0x0f, 0x00, 18, 0},
-		{AH_TRUE, PHY_OFDM, 12000, 0x0a, 0x00, (0x80 | 24), 2},
-		{AH_TRUE, PHY_OFDM, 18000, 0x0e, 0x00, 36, 2},
-		{AH_TRUE, PHY_OFDM, 24000, 0x09, 0x00, (0x80 | 48), 4},
-		{AH_TRUE, PHY_OFDM, 36000, 0x0d, 0x00, 72, 4},
-		{AH_TRUE, PHY_OFDM, 48000, 0x08, 0x00, 96, 4},
-		{AH_TRUE, PHY_OFDM, 54000, 0x0c, 0x00, 108, 4},
-		{AH_TRUE, PHY_HT, 6500, 0x80, 0x00, 0, 0},
-		{AH_TRUE, PHY_HT, 13000, 0x81, 0x00, 1, 2},
-		{AH_TRUE, PHY_HT, 19500, 0x82, 0x00, 2, 2},
-		{AH_TRUE, PHY_HT, 26000, 0x83, 0x00, 3, 4},
-		{AH_TRUE, PHY_HT, 39000, 0x84, 0x00, 4, 4},
-		{AH_TRUE, PHY_HT, 52000, 0x85, 0x00, 5, 4},
-		{AH_TRUE, PHY_HT, 58500, 0x86, 0x00, 6, 4},
-		{AH_TRUE, PHY_HT, 65000, 0x87, 0x00, 7, 4},
-		{AH_TRUE, PHY_HT, 13000, 0x88, 0x00, 8, 0},
-		{AH_TRUE, PHY_HT, 26000, 0x89, 0x00, 9, 2},
-		{AH_TRUE, PHY_HT, 39000, 0x8a, 0x00, 10, 2},
-		{AH_TRUE, PHY_HT, 52000, 0x8b, 0x00, 11, 4},
-		{AH_TRUE, PHY_HT, 78000, 0x8c, 0x00, 12, 4},
-		{AH_TRUE, PHY_HT, 104000, 0x8d, 0x00, 13, 4},
-		{AH_TRUE, PHY_HT, 117000, 0x8e, 0x00, 14, 4},
-		{AH_TRUE, PHY_HT, 130000, 0x8f, 0x00, 15, 4},
+		{true, PHY_OFDM, 6000, 0x0b, 0x00, (0x80 | 12), 0},
+		{true, PHY_OFDM, 9000, 0x0f, 0x00, 18, 0},
+		{true, PHY_OFDM, 12000, 0x0a, 0x00, (0x80 | 24), 2},
+		{true, PHY_OFDM, 18000, 0x0e, 0x00, 36, 2},
+		{true, PHY_OFDM, 24000, 0x09, 0x00, (0x80 | 48), 4},
+		{true, PHY_OFDM, 36000, 0x0d, 0x00, 72, 4},
+		{true, PHY_OFDM, 48000, 0x08, 0x00, 96, 4},
+		{true, PHY_OFDM, 54000, 0x0c, 0x00, 108, 4},
+		{true, PHY_HT, 6500, 0x80, 0x00, 0, 0},
+		{true, PHY_HT, 13000, 0x81, 0x00, 1, 2},
+		{true, PHY_HT, 19500, 0x82, 0x00, 2, 2},
+		{true, PHY_HT, 26000, 0x83, 0x00, 3, 4},
+		{true, PHY_HT, 39000, 0x84, 0x00, 4, 4},
+		{true, PHY_HT, 52000, 0x85, 0x00, 5, 4},
+		{true, PHY_HT, 58500, 0x86, 0x00, 6, 4},
+		{true, PHY_HT, 65000, 0x87, 0x00, 7, 4},
+		{true, PHY_HT, 13000, 0x88, 0x00, 8, 0},
+		{true, PHY_HT, 26000, 0x89, 0x00, 9, 2},
+		{true, PHY_HT, 39000, 0x8a, 0x00, 10, 2},
+		{true, PHY_HT, 52000, 0x8b, 0x00, 11, 4},
+		{true, PHY_HT, 78000, 0x8c, 0x00, 12, 4},
+		{true, PHY_HT, 104000, 0x8d, 0x00, 13, 4},
+		{true, PHY_HT, 117000, 0x8e, 0x00, 14, 4},
+		{true, PHY_HT, 130000, 0x8f, 0x00, 15, 4},
 	},
 };
 
@@ -230,27 +230,27 @@ static enum wireless_mode ath9k_hw_chan2wmode(struct ath_hal *ah,
 	return WIRELESS_MODE_11a;
 }
 
-static enum hal_bool ath9k_hw_wait(struct ath_hal *ah,
-			    u_int reg,
-			    u_int32_t mask,
-			    u_int32_t val)
+static bool ath9k_hw_wait(struct ath_hal *ah,
+			  u_int reg,
+			  u_int32_t mask,
+			  u_int32_t val)
 {
 	int i;
 
 	for (i = 0; i < (AH_TIMEOUT / AH_TIME_QUANTUM); i++) {
 		if ((REG_READ(ah, reg) & mask) == val)
-			return AH_TRUE;
+			return true;
 
 		udelay(AH_TIME_QUANTUM);
 	}
 	HDPRINTF(ah, HAL_DBG_PHY_IO,
 		 "%s: timeout on reg 0x%x: 0x%08x & 0x%08x != 0x%08x\n",
 		 __func__, reg, REG_READ(ah, reg), mask, val);
-	return AH_FALSE;
+	return false;
 }
 
-static enum hal_bool ath9k_hw_eeprom_read(struct ath_hal *ah, u_int off,
-				   u_int16_t *data)
+static bool ath9k_hw_eeprom_read(struct ath_hal *ah, u_int off,
+				 u_int16_t *data)
 {
 	(void) REG_READ(ah, AR5416_EEPROM_OFFSET + (off << AR5416_EEPROM_S));
 
@@ -258,13 +258,13 @@ static enum hal_bool ath9k_hw_eeprom_read(struct ath_hal *ah, u_int off,
 			   AR_EEPROM_STATUS_DATA,
 			   AR_EEPROM_STATUS_DATA_BUSY |
 			   AR_EEPROM_STATUS_DATA_PROT_ACCESS, 0)) {
-		return AH_FALSE;
+		return false;
 	}
 
 	*data = MS(REG_READ(ah, AR_EEPROM_STATUS_DATA),
 		   AR_EEPROM_STATUS_DATA_VAL);
 
-	return AH_TRUE;
+	return true;
 }
 
 static enum hal_status ath9k_hw_flash_map(struct ath_hal *ah)
@@ -282,13 +282,13 @@ static enum hal_status ath9k_hw_flash_map(struct ath_hal *ah)
 	return HAL_OK;
 }
 
-static enum hal_bool ath9k_hw_flash_read(struct ath_hal *ah, u_int off,
-				  u_int16_t *data)
+static bool ath9k_hw_flash_read(struct ath_hal *ah, u_int off,
+				u_int16_t *data)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
 	*data = ioread16(ahp->ah_cal_mem + off);
-	return AH_TRUE;
+	return true;
 }
 
 static void ath9k_hw_read_revisions(struct ath_hal *ah)
@@ -314,7 +314,7 @@ static void ath9k_hw_read_revisions(struct ath_hal *ah)
 		ah->ah_macRev = val & AR_SREV_REVISION;
 
 		if (ah->ah_macVersion == AR_SREV_VERSION_5416_PCIE)
-			ah->ah_isPciExpress = AH_TRUE;
+			ah->ah_isPciExpress = true;
 	}
 }
 
@@ -513,9 +513,9 @@ ath9k_hw_get_eeprom_antenna_cfg(struct ath_hal_5416 *ahp,
 	return HAL_EINVAL;
 }
 
-static inline enum hal_bool ath9k_hw_nvram_read(struct ath_hal *ah,
-						u_int off,
-						u_int16_t *data)
+static inline bool ath9k_hw_nvram_read(struct ath_hal *ah,
+				       u_int off,
+				       u_int16_t *data)
 {
 	if (ath9k_hw_use_flash(ah))
 		return ath9k_hw_flash_read(ah, off, data);
@@ -523,7 +523,7 @@ static inline enum hal_bool ath9k_hw_nvram_read(struct ath_hal *ah,
 		return ath9k_hw_eeprom_read(ah, off, data);
 }
 
-static inline enum hal_bool ath9k_hw_fill_eeprom(struct ath_hal *ah)
+static inline bool ath9k_hw_fill_eeprom(struct ath_hal *ah)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ar5416_eeprom *eep = &ahp->ah_eeprom;
@@ -547,15 +547,15 @@ static inline enum hal_bool ath9k_hw_fill_eeprom(struct ath_hal *ah)
 			HDPRINTF(ah, HAL_DBG_EEPROM,
 				 "%s: Unable to read eeprom region \n",
 				 __func__);
-			return AH_FALSE;
+			return false;
 		}
 		eep_data++;
 	}
-	return AH_TRUE;
+	return true;
 }
 
 /* XXX: Clean me up, make me more legible */
-static enum hal_bool
+static bool
 ath9k_hw_eeprom_set_board_values(struct ath_hal *ah,
 				 struct hal_channel_internal *chan)
 {
@@ -786,7 +786,7 @@ ath9k_hw_eeprom_set_board_values(struct ath_hal *ah,
 					 pModal->swSettleHt40);
 	}
 
-	return AH_TRUE;
+	return true;
 }
 
 static inline enum hal_status ath9k_hw_check_eeprom(struct ath_hal *ah)
@@ -795,7 +795,7 @@ static inline enum hal_status ath9k_hw_check_eeprom(struct ath_hal *ah)
 	u_int16_t *eepdata;
 	int i;
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	enum hal_bool need_swap = AH_FALSE;
+	bool need_swap = false;
 	struct ar5416_eeprom *eep =
 		(struct ar5416_eeprom *) &ahp->ah_eeprom;
 
@@ -807,7 +807,7 @@ static inline enum hal_status ath9k_hw_check_eeprom(struct ath_hal *ah)
 					&magic)) {
 			HDPRINTF(ah, HAL_DBG_EEPROM,
 				 "%s: Reading Magic # failed\n", __func__);
-			return AH_FALSE;
+			return false;
 		}
 		HDPRINTF(ah, HAL_DBG_EEPROM, "%s: Read Magic = 0x%04X\n",
 			 __func__, magic);
@@ -816,7 +816,7 @@ static inline enum hal_status ath9k_hw_check_eeprom(struct ath_hal *ah)
 			magic2 = swab16(magic);
 
 			if (magic2 == AR5416_EEPROM_MAGIC) {
-				need_swap = AH_TRUE;
+				need_swap = true;
 				eepdata = (u_int16_t *) (&ahp->ah_eeprom);
 
 				for (addr = 0;
@@ -922,7 +922,7 @@ static inline enum hal_status ath9k_hw_check_eeprom(struct ath_hal *ah)
 	return HAL_OK;
 }
 
-static enum hal_bool ath9k_hw_chip_test(struct ath_hal *ah)
+static bool ath9k_hw_chip_test(struct ath_hal *ah)
 {
 	u_int32_t regAddr[2] = { AR_STA_ID0, AR_PHY_BASE + (8 << 2) };
 	u_int32_t regHold[2];
@@ -946,7 +946,7 @@ static enum hal_bool ath9k_hw_chip_test(struct ath_hal *ah)
 				 "%s: address test failed "
 				"addr: 0x%08x - wr:0x%08x != rd:0x%08x\n",
 				 __func__, addr, wrData, rdData);
-				return AH_FALSE;
+				return false;
 			}
 		}
 		for (j = 0; j < 4; j++) {
@@ -958,13 +958,13 @@ static enum hal_bool ath9k_hw_chip_test(struct ath_hal *ah)
 				 "%s: address test failed "
 				"addr: 0x%08x - wr:0x%08x != rd:0x%08x\n",
 				 __func__, addr, wrData, rdData);
-				return AH_FALSE;
+				return false;
 			}
 		}
 		REG_WRITE(ah, regAddr[i], regHold[i]);
 	}
 	udelay(100);
-	return AH_TRUE;
+	return true;
 }
 
 u_int32_t ath9k_hw_getrxfilter(struct ath_hal *ah)
@@ -999,11 +999,11 @@ void ath9k_hw_setrxfilter(struct ath_hal *ah, u_int32_t bits)
 			  REG_READ(ah, AR_RXCFG) & ~AR_RXCFG_ZLFDMA);
 }
 
-enum hal_bool ath9k_hw_setcapability(struct ath_hal *ah,
-				     enum hal_capability_type type,
-				     u_int32_t capability,
-				     u_int32_t setting,
-				     enum hal_status *status)
+bool ath9k_hw_setcapability(struct ath_hal *ah,
+			    enum hal_capability_type type,
+			    u_int32_t capability,
+			    u_int32_t setting,
+			    enum hal_status *status)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	u_int32_t v;
@@ -1016,7 +1016,7 @@ enum hal_bool ath9k_hw_setcapability(struct ath_hal *ah,
 		else
 			ahp->ah_staId1Defaults &=
 				~AR_STA_ID1_CRPT_MIC_ENABLE;
-		return AH_TRUE;
+		return true;
 	case HAL_CAP_DIVERSITY:
 		v = REG_READ(ah, AR_PHY_CCK_DETECT);
 		if (setting)
@@ -1024,21 +1024,21 @@ enum hal_bool ath9k_hw_setcapability(struct ath_hal *ah,
 		else
 			v &= ~AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV;
 		REG_WRITE(ah, AR_PHY_CCK_DETECT, v);
-		return AH_TRUE;
+		return true;
 	case HAL_CAP_MCAST_KEYSRCH:
 		if (setting)
 			ahp->ah_staId1Defaults |= AR_STA_ID1_MCAST_KSRCH;
 		else
 			ahp->ah_staId1Defaults &= ~AR_STA_ID1_MCAST_KSRCH;
-		return AH_TRUE;
+		return true;
 	case HAL_CAP_TSF_ADJUST:
 		if (setting)
 			ahp->ah_miscMode |= AR_PCU_TX_ADD_TSF;
 		else
 			ahp->ah_miscMode &= ~AR_PCU_TX_ADD_TSF;
-		return AH_TRUE;
+		return true;
 	default:
-		return AH_FALSE;
+		return false;
 	}
 }
 
@@ -1349,7 +1349,7 @@ static inline int16_t ath9k_hw_interpolate(u_int16_t target,
 }
 
 static inline u_int16_t ath9k_hw_fbin2freq(u_int8_t fbin,
-					   enum hal_bool is2GHz)
+					   bool is2GHz)
 {
 
 	if (fbin == AR5416_BCHAN_UNUSED)
@@ -1360,7 +1360,7 @@ static inline u_int16_t ath9k_hw_fbin2freq(u_int8_t fbin,
 
 static u_int16_t ath9k_hw_eeprom_get_spur_chan(struct ath_hal *ah,
 					       u_int16_t i,
-					       enum hal_bool is2GHz)
+					       bool is2GHz)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ar5416_eeprom *eep =
@@ -1389,7 +1389,7 @@ static u_int16_t ath9k_hw_eeprom_get_spur_chan(struct ath_hal *ah,
 
 static inline enum hal_status ath9k_hw_rfattach(struct ath_hal *ah)
 {
-	enum hal_bool rfStatus = AH_FALSE;
+	bool rfStatus = false;
 	enum hal_status ecode = HAL_OK;
 
 	rfStatus = ath9k_hw_init_rf(ah, &ecode);
@@ -1571,7 +1571,7 @@ ath9k_hw_set_rfmode(struct ath_hal *ah, struct hal_channel *chan)
 	REG_WRITE(ah, AR_PHY_MODE, rfMode);
 }
 
-static enum hal_bool ath9k_hw_set_reset(struct ath_hal *ah, int type)
+static bool ath9k_hw_set_reset(struct ath_hal *ah, int type)
 {
 	u_int32_t rst_flags;
 	u_int32_t tmpReg;
@@ -1605,7 +1605,7 @@ static enum hal_bool ath9k_hw_set_reset(struct ath_hal *ah, int type)
 	if (!ath9k_hw_wait(ah, (u_int16_t) (AR_RTC_RC), AR_RTC_RC_M, 0)) {
 		HDPRINTF(ah, HAL_DBG_RESET, "%s: RTC stuck in MAC reset\n",
 			 __func__);
-		return AH_FALSE;
+		return false;
 	}
 
 	if (!AR_SREV_9100(ah))
@@ -1616,10 +1616,10 @@ static enum hal_bool ath9k_hw_set_reset(struct ath_hal *ah, int type)
 	if (AR_SREV_9100(ah))
 		udelay(50);
 
-	return AH_TRUE;
+	return true;
 }
 
-static inline enum hal_bool ath9k_hw_set_reset_power_on(struct ath_hal *ah)
+static inline bool ath9k_hw_set_reset_power_on(struct ath_hal *ah)
 {
 	REG_WRITE(ah, AR_RTC_FORCE_WAKE, AR_RTC_FORCE_WAKE_EN |
 		  AR_RTC_FORCE_WAKE_ON_INT);
@@ -1633,7 +1633,7 @@ static inline enum hal_bool ath9k_hw_set_reset_power_on(struct ath_hal *ah)
 			   AR_RTC_STATUS_ON)) {
 		HDPRINTF(ah, HAL_DBG_RESET, "%s: RTC not waking up\n",
 			 __func__);
-		return AH_FALSE;
+		return false;
 	}
 
 	ath9k_hw_read_revisions(ah);
@@ -1641,8 +1641,8 @@ static inline enum hal_bool ath9k_hw_set_reset_power_on(struct ath_hal *ah)
 	return ath9k_hw_set_reset(ah, HAL_RESET_WARM);
 }
 
-static enum hal_bool ath9k_hw_set_reset_reg(struct ath_hal *ah,
-					    u_int32_t type)
+static bool ath9k_hw_set_reset_reg(struct ath_hal *ah,
+				   u_int32_t type)
 {
 	REG_WRITE(ah, AR_RTC_FORCE_WAKE,
 		  AR_RTC_FORCE_WAKE_EN | AR_RTC_FORCE_WAKE_ON_INT);
@@ -1656,7 +1656,7 @@ static enum hal_bool ath9k_hw_set_reset_reg(struct ath_hal *ah,
 		return ath9k_hw_set_reset(ah, type);
 		break;
 	default:
-		return AH_FALSE;
+		return false;
 	}
 }
 
@@ -1686,7 +1686,7 @@ static inline struct hal_channel_internal *ath9k_hw_check_chan(
 	return ath9k_regd_check_channel(ah, chan);
 }
 
-static inline enum hal_bool
+static inline bool
 ath9k_hw_get_lower_upper_index(u_int8_t target,
 			       u_int8_t *pList,
 			       u_int16_t listSize,
@@ -1697,25 +1697,25 @@ ath9k_hw_get_lower_upper_index(u_int8_t target,
 
 	if (target <= pList[0]) {
 		*indexL = *indexR = 0;
-		return AH_TRUE;
+		return true;
 	}
 	if (target >= pList[listSize - 1]) {
 		*indexL = *indexR = (u_int16_t) (listSize - 1);
-		return AH_TRUE;
+		return true;
 	}
 
 	for (i = 0; i < listSize - 1; i++) {
 		if (pList[i] == target) {
 			*indexL = *indexR = i;
-			return AH_TRUE;
+			return true;
 		}
 		if (target < pList[i + 1]) {
 			*indexL = i;
 			*indexR = (u_int16_t) (i + 1);
-			return AH_FALSE;
+			return false;
 		}
 	}
-	return AH_FALSE;
+	return false;
 }
 
 static int16_t ath9k_hw_get_nf_hist_mid(int16_t *nfCalBuffer)
@@ -1844,7 +1844,7 @@ static void ar5416GetNoiseFloor(struct ath_hal *ah,
 	}
 }
 
-static enum hal_bool
+static bool
 getNoiseFloorThresh(struct ath_hal *ah,
 		    const struct hal_channel_internal *chan,
 		    int16_t *nft)
@@ -1869,9 +1869,9 @@ getNoiseFloorThresh(struct ath_hal *ah,
 		HDPRINTF(ah, HAL_DBG_CHANNEL,
 			 "%s: invalid channel flags 0x%x\n", __func__,
 			 chan->channelFlags);
-		return AH_FALSE;
+		return false;
 	}
-	return AH_TRUE;
+	return true;
 }
 
 static void ath9k_hw_start_nfcal(struct ath_hal *ah)
@@ -2124,8 +2124,8 @@ static void ath9k_hw_ani_detach(struct ath_hal *ah)
 }
 
 
-static enum hal_bool ath9k_hw_ani_control(struct ath_hal *ah,
-					  enum hal_ani_cmd cmd, int param)
+static bool ath9k_hw_ani_control(struct ath_hal *ah,
+				 enum hal_ani_cmd cmd, int param)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ar5416AniState *aniState = ahp->ah_curani;
@@ -2140,7 +2140,7 @@ static enum hal_bool ath9k_hw_ani_control(struct ath_hal *ah,
 				 __func__, level,
 				 (unsigned) ARRAY_SIZE(ahp->
 						       ah_totalSizeDesired));
-			return AH_FALSE;
+			return false;
 		}
 
 		OS_REG_RMW_FIELD(ah, AR_PHY_DESIRED_SZ,
@@ -2245,7 +2245,7 @@ static enum hal_bool ath9k_hw_ani_control(struct ath_hal *ah,
 				 "%s: level out of range (%u > %u)\n",
 				 __func__, level,
 				 (unsigned) ARRAY_SIZE(firstep));
-			return AH_FALSE;
+			return false;
 		}
 		OS_REG_RMW_FIELD(ah, AR_PHY_FIND_SIG,
 				 AR_PHY_FIND_SIG_FIRSTEP,
@@ -2268,7 +2268,7 @@ static enum hal_bool ath9k_hw_ani_control(struct ath_hal *ah,
 				 __func__, level,
 				 (unsigned)
 				 ARRAY_SIZE(cycpwrThr1));
-			return AH_FALSE;
+			return false;
 		}
 		OS_REG_RMW_FIELD(ah, AR_PHY_TIMING5,
 				 AR_PHY_TIMING5_CYCPWR_THR1,
@@ -2285,7 +2285,7 @@ static enum hal_bool ath9k_hw_ani_control(struct ath_hal *ah,
 	default:
 		HDPRINTF(ah, HAL_DBG_ANI, "%s: invalid cmd %u\n", __func__,
 			 cmd);
-		return AH_FALSE;
+		return false;
 	}
 
 	HDPRINTF(ah, HAL_DBG_ANI, "%s: ANI parameters:\n", __func__);
@@ -2303,7 +2303,7 @@ static enum hal_bool ath9k_hw_ani_control(struct ath_hal *ah,
 		 "cycleCount=%d, ofdmPhyErrCount=%d, cckPhyErrCount=%d\n\n",
 		 aniState->cycleCount, aniState->ofdmPhyErrCount,
 		 aniState->cckPhyErrCount);
-	return AH_TRUE;
+	return true;
 }
 
 static void ath9k_ani_restart(struct ath_hal *ah)
@@ -2364,16 +2364,14 @@ static void ath9k_hw_ani_ofdm_err_trigger(struct ath_hal *ah)
 
 	if (aniState->noiseImmunityLevel < HAL_NOISE_IMMUNE_MAX) {
 		if (ath9k_hw_ani_control(ah, HAL_ANI_NOISE_IMMUNITY_LEVEL,
-					 aniState->noiseImmunityLevel +
-					 1) == AH_TRUE) {
+					 aniState->noiseImmunityLevel + 1)) {
 			return;
 		}
 	}
 
 	if (aniState->spurImmunityLevel < HAL_SPUR_IMMUNE_MAX) {
 		if (ath9k_hw_ani_control(ah, HAL_ANI_SPUR_IMMUNITY_LEVEL,
-					 aniState->spurImmunityLevel +
-					 1) == AH_TRUE) {
+					 aniState->spurImmunityLevel + 1)) {
 			return;
 		}
 	}
@@ -2390,7 +2388,7 @@ static void ath9k_hw_ani_ofdm_err_trigger(struct ath_hal *ah)
 		if (!aniState->ofdmWeakSigDetectOff) {
 			if (ath9k_hw_ani_control(ah,
 					 HAL_ANI_OFDM_WEAK_SIGNAL_DETECTION,
-					 AH_FALSE) == AH_TRUE) {
+					 false)) {
 				ath9k_hw_ani_control(ah,
 					HAL_ANI_SPUR_IMMUNITY_LEVEL,
 					0);
@@ -2406,7 +2404,7 @@ static void ath9k_hw_ani_ofdm_err_trigger(struct ath_hal *ah)
 		if (aniState->ofdmWeakSigDetectOff)
 			ath9k_hw_ani_control(ah,
 					     HAL_ANI_OFDM_WEAK_SIGNAL_DETECTION,
-					     AH_TRUE);
+					     true);
 		if (aniState->firstepLevel < HAL_FIRST_STEP_MAX)
 			ath9k_hw_ani_control(ah, HAL_ANI_FIRSTEP_LEVEL,
 					     aniState->firstepLevel + 1);
@@ -2417,7 +2415,7 @@ static void ath9k_hw_ani_ofdm_err_trigger(struct ath_hal *ah)
 			if (!aniState->ofdmWeakSigDetectOff)
 				ath9k_hw_ani_control(ah,
 					     HAL_ANI_OFDM_WEAK_SIGNAL_DETECTION,
-					     AH_FALSE);
+					     false);
 			if (aniState->firstepLevel > 0)
 				ath9k_hw_ani_control(ah,
 						     HAL_ANI_FIRSTEP_LEVEL,
@@ -2441,8 +2439,7 @@ static void ath9k_hw_ani_cck_err_trigger(struct ath_hal *ah)
 	aniState = ahp->ah_curani;
 	if (aniState->noiseImmunityLevel < HAL_NOISE_IMMUNE_MAX) {
 		if (ath9k_hw_ani_control(ah, HAL_ANI_NOISE_IMMUNITY_LEVEL,
-					 aniState->noiseImmunityLevel +
-					 1) == AH_TRUE) {
+					 aniState->noiseImmunityLevel + 1)) {
 			return;
 		}
 	}
@@ -2602,8 +2599,7 @@ static void ath9k_hw_ani_lower_immunity(struct ath_hal *ah)
 	if (ah->ah_opmode == HAL_M_HOSTAP) {
 		if (aniState->firstepLevel > 0) {
 			if (ath9k_hw_ani_control(ah, HAL_ANI_FIRSTEP_LEVEL,
-						 aniState->firstepLevel -
-						 1) == AH_TRUE) {
+						 aniState->firstepLevel - 1)) {
 				return;
 			}
 		}
@@ -2615,8 +2611,8 @@ static void ath9k_hw_ani_lower_immunity(struct ath_hal *ah)
 			if (aniState->ofdmWeakSigDetectOff) {
 				if (ath9k_hw_ani_control(ah,
 					 HAL_ANI_OFDM_WEAK_SIGNAL_DETECTION,
-					 AH_TRUE) ==
-				    AH_TRUE) {
+					 true) ==
+				    true) {
 					return;
 				}
 			}
@@ -2624,7 +2620,7 @@ static void ath9k_hw_ani_lower_immunity(struct ath_hal *ah)
 				if (ath9k_hw_ani_control
 				    (ah, HAL_ANI_FIRSTEP_LEVEL,
 				     aniState->firstepLevel - 1) ==
-				    AH_TRUE) {
+				    true) {
 					return;
 				}
 			}
@@ -2633,7 +2629,7 @@ static void ath9k_hw_ani_lower_immunity(struct ath_hal *ah)
 				if (ath9k_hw_ani_control
 				    (ah, HAL_ANI_FIRSTEP_LEVEL,
 				     aniState->firstepLevel - 1) ==
-				    AH_TRUE) {
+				    true) {
 					return;
 				}
 			}
@@ -2642,8 +2638,7 @@ static void ath9k_hw_ani_lower_immunity(struct ath_hal *ah)
 
 	if (aniState->spurImmunityLevel > 0) {
 		if (ath9k_hw_ani_control(ah, HAL_ANI_SPUR_IMMUNITY_LEVEL,
-					 aniState->spurImmunityLevel -
-					 1) == AH_TRUE) {
+					 aniState->spurImmunityLevel - 1)) {
 			return;
 		}
 	}
@@ -2822,9 +2817,9 @@ static void ath9k_hw_gpio_cfg_output_mux(struct ath_hal *ah,
 	}
 }
 
-static enum hal_bool ath9k_hw_cfg_output(struct ath_hal *ah, u_int32_t gpio,
-				  enum hal_gpio_output_mux_type
-				  halSignalType)
+static bool ath9k_hw_cfg_output(struct ath_hal *ah, u_int32_t gpio,
+				enum hal_gpio_output_mux_type
+				halSignalType)
 {
 	u_int32_t ah_signal_type;
 	u_int32_t gpio_shift;
@@ -2846,7 +2841,7 @@ static enum hal_bool ath9k_hw_cfg_output(struct ath_hal *ah, u_int32_t gpio,
 	    && (halSignalType < ARRAY_SIZE(MuxSignalConversionTable)))
 		ah_signal_type = MuxSignalConversionTable[halSignalType];
 	else
-		return AH_FALSE;
+		return false;
 
 	ath9k_hw_gpio_cfg_output_mux(ah, gpio, ah_signal_type);
 
@@ -2857,15 +2852,15 @@ static enum hal_bool ath9k_hw_cfg_output(struct ath_hal *ah, u_int32_t gpio,
 		   (AR_GPIO_OE_OUT_DRV_ALL << gpio_shift),
 		   (AR_GPIO_OE_OUT_DRV << gpio_shift));
 
-	return AH_TRUE;
+	return true;
 }
 
-static enum hal_bool ath9k_hw_set_gpio(struct ath_hal *ah, u_int32_t gpio,
-				u_int32_t val)
+static bool ath9k_hw_set_gpio(struct ath_hal *ah, u_int32_t gpio,
+			      u_int32_t val)
 {
 	OS_REG_RMW(ah, AR_GPIO_IN_OUT, ((val & 1) << gpio),
 		   AR_GPIO_BIT(gpio));
-	return AH_TRUE;
+	return true;
 }
 
 static u_int32_t ath9k_hw_gpio_get(struct ath_hal *ah, u_int32_t gpio)
@@ -2944,7 +2939,7 @@ static u_int32_t ath9k_hw_ini_fixup(struct ath_hal *ah,
 	return value;
 }
 
-static enum hal_bool ath9k_hw_fill_cap_info(struct ath_hal *ah)
+static bool ath9k_hw_fill_cap_info(struct ath_hal *ah)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct hal_capabilities *pCap = &ah->ah_caps;
@@ -3012,22 +3007,22 @@ static enum hal_bool ath9k_hw_fill_cap_info(struct ath_hal *ah)
 	pCap->halLow5GhzChan = 4920;
 	pCap->halHigh5GhzChan = 6100;
 
-	pCap->halCipherCkipSupport = AH_FALSE;
-	pCap->halCipherTkipSupport = AH_TRUE;
-	pCap->halCipherAesCcmSupport = AH_TRUE;
+	pCap->halCipherCkipSupport = false;
+	pCap->halCipherTkipSupport = true;
+	pCap->halCipherAesCcmSupport = true;
 
-	pCap->halMicCkipSupport = AH_FALSE;
-	pCap->halMicTkipSupport = AH_TRUE;
-	pCap->halMicAesCcmSupport = AH_TRUE;
+	pCap->halMicCkipSupport = false;
+	pCap->halMicTkipSupport = true;
+	pCap->halMicAesCcmSupport = true;
 
-	pCap->halChanSpreadSupport = AH_TRUE;
+	pCap->halChanSpreadSupport = true;
 
 	pCap->halHTSupport =
-		ah->ah_config.ath_hal_htEnable ? AH_TRUE : AH_FALSE;
-	pCap->halGTTSupport = AH_TRUE;
-	pCap->halVEOLSupport = AH_TRUE;
-	pCap->halBssIdMaskSupport = AH_TRUE;
-	pCap->halMcastKeySrchSupport = AH_FALSE;
+		ah->ah_config.ath_hal_htEnable ? true : false;
+	pCap->halGTTSupport = true;
+	pCap->halVEOLSupport = true;
+	pCap->halBssIdMaskSupport = true;
+	pCap->halMcastKeySrchSupport = false;
 
 	if (capField & AR_EEPROM_EEPCAP_MAXQCU)
 		pCap->halTotalQueues =
@@ -3041,7 +3036,7 @@ static enum hal_bool ath9k_hw_fill_cap_info(struct ath_hal *ah)
 	else
 		pCap->halKeyCacheSize = AR_KEYTABLE_SIZE;
 
-	pCap->halFastCCSupport = AH_TRUE;
+	pCap->halFastCCSupport = true;
 	pCap->halNumMRRetries = 4;
 	pCap->halTxTrigLevelMax = MAX_TX_FIFO_THRESHOLD;
 
@@ -3051,21 +3046,21 @@ static enum hal_bool ath9k_hw_fill_cap_info(struct ath_hal *ah)
 		pCap->halNumGpioPins = AR_NUM_GPIO;
 
 	if (AR_SREV_9280_10_OR_LATER(ah)) {
-		pCap->halWowSupport = AH_TRUE;
-		pCap->halWowMatchPatternExact = AH_TRUE;
+		pCap->halWowSupport = true;
+		pCap->halWowMatchPatternExact = true;
 	} else {
-		pCap->halWowSupport = AH_FALSE;
-		pCap->halWowMatchPatternExact = AH_FALSE;
+		pCap->halWowSupport = false;
+		pCap->halWowMatchPatternExact = false;
 	}
 
 	if (AR_SREV_9160_10_OR_LATER(ah) || AR_SREV_9100(ah)) {
-		pCap->halCSTSupport = AH_TRUE;
+		pCap->halCSTSupport = true;
 		pCap->halRtsAggrLimit = ATH_AMPDU_LIMIT_MAX;
 	} else {
 		pCap->halRtsAggrLimit = (8 * 1024);
 	}
 
-	pCap->halEnhancedPmSupport = AH_TRUE;
+	pCap->halEnhancedPmSupport = true;
 
 	ah->ah_rfsilent = ath9k_hw_get_eeprom(ahp, EEP_RF_SILENT);
 	if (ah->ah_rfsilent & EEP_RFSILENT_ENABLED) {
@@ -3074,9 +3069,9 @@ static enum hal_bool ath9k_hw_fill_cap_info(struct ath_hal *ah)
 		ahp->ah_polarity =
 			MS(ah->ah_rfsilent, EEP_RFSILENT_POLARITY);
 
-		ath9k_hw_setcapability(ah, HAL_CAP_RFSILENT, 1, AH_TRUE,
+		ath9k_hw_setcapability(ah, HAL_CAP_RFSILENT, 1, true,
 				       NULL);
-		pCap->halRfSilentSupport = AH_TRUE;
+		pCap->halRfSilentSupport = true;
 	}
 
 	if ((ah->ah_macVersion == AR_SREV_VERSION_5416_PCI) ||
@@ -3084,14 +3079,14 @@ static enum hal_bool ath9k_hw_fill_cap_info(struct ath_hal *ah)
 	    (ah->ah_macVersion == AR_SREV_VERSION_9160) ||
 	    (ah->ah_macVersion == AR_SREV_VERSION_9100) ||
 	    (ah->ah_macVersion == AR_SREV_VERSION_9280))
-		pCap->halAutoSleepSupport = AH_FALSE;
+		pCap->halAutoSleepSupport = false;
 	else
-		pCap->halAutoSleepSupport = AH_TRUE;
+		pCap->halAutoSleepSupport = true;
 
 	if (AR_SREV_9280(ah))
-		pCap->hal4kbSplitTransSupport = AH_FALSE;
+		pCap->hal4kbSplitTransSupport = false;
 	else
-		pCap->hal4kbSplitTransSupport = AH_TRUE;
+		pCap->hal4kbSplitTransSupport = true;
 
 	if (ah->ah_currentRDExt & (1 << REG_EXT_JAPAN_MIDBAND)) {
 		pCap->halRegCap =
@@ -3112,7 +3107,7 @@ static enum hal_bool ath9k_hw_fill_cap_info(struct ath_hal *ah)
 	pCap->halNumAntCfg2GHz =
 		ath9k_hw_get_num_ant_config(ahp, HAL_FREQ_BAND_2GHZ);
 
-	return AH_TRUE;
+	return true;
 }
 
 static void ar5416DisablePciePhy(struct ath_hal *ah)
@@ -3163,8 +3158,8 @@ static void ath9k_set_power_network_sleep(struct ath_hal *ah, int setChip)
 	}
 }
 
-static enum hal_bool ath9k_hw_set_power_awake(struct ath_hal *ah,
-					      int setChip)
+static bool ath9k_hw_set_power_awake(struct ath_hal *ah,
+				     int setChip)
 {
 	u_int32_t val;
 	int i;
@@ -3173,8 +3168,8 @@ static enum hal_bool ath9k_hw_set_power_awake(struct ath_hal *ah,
 		if ((REG_READ(ah, AR_RTC_STATUS) & AR_RTC_STATUS_M) ==
 		    AR_RTC_STATUS_SHUTDOWN) {
 			if (ath9k_hw_set_reset_reg(ah, HAL_RESET_POWER_ON)
-			    != AH_TRUE) {
-				return AH_FALSE;
+			    != true) {
+				return false;
 			}
 		}
 		if (AR_SREV_9100(ah))
@@ -3197,16 +3192,16 @@ static enum hal_bool ath9k_hw_set_power_awake(struct ath_hal *ah,
 			HDPRINTF(ah, HAL_DBG_POWER_MGMT,
 				 "%s: Failed to wakeup in %uus\n",
 				 __func__, POWER_UP_TIME / 20);
-			return AH_FALSE;
+			return false;
 		}
 	}
 
 	OS_REG_CLR_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
-	return AH_TRUE;
+	return true;
 }
 
-enum hal_bool ath9k_hw_setpower(struct ath_hal *ah,
-				enum hal_power_mode mode)
+bool ath9k_hw_setpower(struct ath_hal *ah,
+		       enum hal_power_mode mode)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	static const char *modes[] = {
@@ -3215,7 +3210,7 @@ enum hal_bool ath9k_hw_setpower(struct ath_hal *ah,
 		"NETWORK SLEEP",
 		"UNDEFINED"
 	};
-	int status = AH_TRUE, setChip = AH_TRUE;
+	int status = true, setChip = true;
 
 	HDPRINTF(ah, HAL_DBG_POWER_MGMT, "%s: %s -> %s (%s)\n", __func__,
 		 modes[ahp->ah_powerMode], modes[mode],
@@ -3227,7 +3222,7 @@ enum hal_bool ath9k_hw_setpower(struct ath_hal *ah,
 		break;
 	case HAL_PM_FULL_SLEEP:
 		ath9k_set_power_sleep(ah, setChip);
-		ahp->ah_chipFullSleep = AH_TRUE;
+		ahp->ah_chipFullSleep = true;
 		break;
 	case HAL_PM_NETWORK_SLEEP:
 		ath9k_set_power_network_sleep(ah, setChip);
@@ -3235,7 +3230,7 @@ enum hal_bool ath9k_hw_setpower(struct ath_hal *ah,
 	default:
 		HDPRINTF(ah, HAL_DBG_POWER_MGMT,
 			 "%s: unknown power mode %u\n", __func__, mode);
-		return AH_FALSE;
+		return false;
 	}
 	ahp->ah_powerMode = mode;
 	return status;
@@ -3263,7 +3258,7 @@ static struct ath_hal *ath9k_hw_do_attach(u_int16_t devid,
 	ath9k_hw_set_defaults(ah);
 
 	if (ah->ah_config.ath_hal_intrMitigation != 0)
-		ahp->ah_intrMitigation = AH_TRUE;
+		ahp->ah_intrMitigation = true;
 
 	if (!ath9k_hw_set_reset_reg(ah, HAL_RESET_POWER_ON)) {
 		HDPRINTF(ah, HAL_DBG_RESET, "%s: couldn't reset chip\n",
@@ -3306,7 +3301,7 @@ static struct ath_hal *ath9k_hw_do_attach(u_int16_t devid,
 	if (AR_SREV_9100(ah)) {
 		ahp->ah_iqCalData.calData = &iq_cal_multi_sample;
 		ahp->ah_suppCals = IQ_MISMATCH_CAL;
-		ah->ah_isPciExpress = AH_FALSE;
+		ah->ah_isPciExpress = false;
 	}
 	ah->ah_phyRev = REG_READ(ah, AR_PHY_CHIP_ID);
 
@@ -3523,33 +3518,33 @@ void ath9k_hw_detach(struct ath_hal *ah)
 	kfree(ah);
 }
 
-enum hal_bool ath9k_get_channel_edges(struct ath_hal *ah,
-				      u_int16_t flags, u_int16_t *low,
-				      u_int16_t *high)
+bool ath9k_get_channel_edges(struct ath_hal *ah,
+			     u_int16_t flags, u_int16_t *low,
+			     u_int16_t *high)
 {
 	struct hal_capabilities *pCap = &ah->ah_caps;
 
 	if (flags & CHANNEL_5GHZ) {
 		*low = pCap->halLow5GhzChan;
 		*high = pCap->halHigh5GhzChan;
-		return AH_TRUE;
+		return true;
 	}
 	if ((flags & CHANNEL_2GHZ)) {
 		*low = pCap->halLow2GhzChan;
 		*high = pCap->halHigh2GhzChan;
 
-		return AH_TRUE;
+		return true;
 	}
-	return AH_FALSE;
+	return false;
 }
 
-static inline enum hal_bool ath9k_hw_fill_vpd_table(u_int8_t pwrMin,
-						    u_int8_t pwrMax,
-						    u_int8_t *pPwrList,
-						    u_int8_t *pVpdList,
-						    u_int16_t
-						    numIntercepts,
-						    u_int8_t *pRetVpdList)
+static inline bool ath9k_hw_fill_vpd_table(u_int8_t pwrMin,
+					   u_int8_t pwrMax,
+					   u_int8_t *pPwrList,
+					   u_int8_t *pVpdList,
+					   u_int16_t
+					   numIntercepts,
+					   u_int8_t *pRetVpdList)
 {
 	u_int16_t i, k;
 	u_int8_t currPwr = pwrMin;
@@ -3577,7 +3572,7 @@ static inline enum hal_bool ath9k_hw_fill_vpd_table(u_int8_t pwrMin,
 		currPwr += 2;
 	}
 
-	return AH_TRUE;
+	return true;
 }
 
 static inline void
@@ -3608,7 +3603,7 @@ ath9k_hw_get_gain_boundaries_pdadcs(struct ath_hal *ah,
 	int16_t vpdStep;
 	int16_t tmpVal;
 	u_int16_t sizeCurrVpdTable, maxIndex, tgtIndex;
-	enum hal_bool match;
+	bool match;
 	int16_t minDelta = 0;
 	struct chan_centers centers;
 
@@ -3762,7 +3757,7 @@ ath9k_hw_get_gain_boundaries_pdadcs(struct ath_hal *ah,
 	return;
 }
 
-static inline enum hal_bool
+static inline bool
 ath9k_hw_set_power_cal_table(struct ath_hal *ah,
 			     struct ar5416_eeprom *pEepData,
 			     struct hal_channel_internal *chan,
@@ -3896,7 +3891,7 @@ ath9k_hw_set_power_cal_table(struct ath_hal *ah,
 	}
 	*pTxPowerIndexOffset = 0;
 
-	return AH_TRUE;
+	return true;
 }
 
 void ath9k_hw_configpcipowersave(struct ath_hal *ah, int restore)
@@ -3904,7 +3899,7 @@ void ath9k_hw_configpcipowersave(struct ath_hal *ah, int restore)
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	u_int8_t i;
 
-	if (ah->ah_isPciExpress != AH_TRUE)
+	if (ah->ah_isPciExpress != true)
 		return;
 
 	if (ah->ah_config.ath_hal_pciePowerSaveEnable == 2)
@@ -3972,7 +3967,7 @@ ath9k_hw_get_legacy_target_powers(struct ath_hal *ah,
 				  u_int16_t numChannels,
 				  struct cal_target_power_leg *pNewPower,
 				  u_int16_t numRates,
-				  enum hal_bool isExtTarget)
+				  bool isExtTarget)
 {
 	u_int16_t clo, chi;
 	int i;
@@ -4038,7 +4033,7 @@ ath9k_hw_get_target_powers(struct ath_hal *ah,
 			   u_int16_t numChannels,
 			   struct cal_target_power_ht *pNewPower,
 			   u_int16_t numRates,
-			   enum hal_bool isHt40Target)
+			   bool isHt40Target)
 {
 	u_int16_t clo, chi;
 	int i;
@@ -4101,7 +4096,7 @@ ath9k_hw_get_target_powers(struct ath_hal *ah,
 static inline u_int16_t
 ath9k_hw_get_max_edge_power(u_int16_t freq,
 			    struct cal_ctl_edges *pRdEdgesPower,
-			    enum hal_bool is2GHz)
+			    bool is2GHz)
 {
 	u_int16_t twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
 	int i;
@@ -4128,7 +4123,7 @@ ath9k_hw_get_max_edge_power(u_int16_t freq,
 	return twiceMaxEdgePower;
 }
 
-static inline enum hal_bool
+static inline bool
 ath9k_hw_set_power_per_rate_table(struct ath_hal *ah,
 				  struct ar5416_eeprom *pEepData,
 				  struct hal_channel_internal *chan,
@@ -4222,17 +4217,17 @@ ath9k_hw_set_power_per_rate_table(struct ath_hal *ah,
 			calTargetPowerCck,
 			AR5416_NUM_2G_CCK_TARGET_POWERS,
 			&targetPowerCck, 4,
-			AH_FALSE);
+			false);
 		ath9k_hw_get_legacy_target_powers(ah, chan,
 			pEepData->
 			calTargetPower2G,
 			AR5416_NUM_2G_20_TARGET_POWERS,
 			&targetPowerOfdm, 4,
-			AH_FALSE);
+			false);
 		ath9k_hw_get_target_powers(ah, chan,
 			pEepData->calTargetPower2GHT20,
 			AR5416_NUM_2G_20_TARGET_POWERS,
-			&targetPowerHt20, 8, AH_FALSE);
+			&targetPowerHt20, 8, false);
 
 		if (IS_CHAN_HT40(chan)) {
 			numCtlModes = ARRAY_SIZE(ctlModesFor11g);
@@ -4241,19 +4236,19 @@ ath9k_hw_set_power_per_rate_table(struct ath_hal *ah,
 				calTargetPower2GHT40,
 				AR5416_NUM_2G_40_TARGET_POWERS,
 				&targetPowerHt40, 8,
-				AH_TRUE);
+				true);
 			ath9k_hw_get_legacy_target_powers(ah, chan,
 				pEepData->
 				calTargetPowerCck,
 				AR5416_NUM_2G_CCK_TARGET_POWERS,
 				&targetPowerCckExt,
-				4, AH_TRUE);
+				4, true);
 			ath9k_hw_get_legacy_target_powers(ah, chan,
 				pEepData->
 				calTargetPower2G,
 				AR5416_NUM_2G_20_TARGET_POWERS,
 				&targetPowerOfdmExt,
-				4, AH_TRUE);
+				4, true);
 		}
 	} else {
 
@@ -4267,11 +4262,11 @@ ath9k_hw_set_power_per_rate_table(struct ath_hal *ah,
 			calTargetPower5G,
 			AR5416_NUM_5G_20_TARGET_POWERS,
 			&targetPowerOfdm, 4,
-			AH_FALSE);
+			false);
 		ath9k_hw_get_target_powers(ah, chan,
 			pEepData->calTargetPower5GHT20,
 			AR5416_NUM_5G_20_TARGET_POWERS,
-			&targetPowerHt20, 8, AH_FALSE);
+			&targetPowerHt20, 8, false);
 
 		if (IS_CHAN_HT40(chan)) {
 			numCtlModes = ARRAY_SIZE(ctlModesFor11a);
@@ -4280,18 +4275,18 @@ ath9k_hw_set_power_per_rate_table(struct ath_hal *ah,
 				calTargetPower5GHT40,
 				AR5416_NUM_5G_40_TARGET_POWERS,
 				&targetPowerHt40, 8,
-				AH_TRUE);
+				true);
 			ath9k_hw_get_legacy_target_powers(ah, chan,
 				pEepData->
 				calTargetPower5G,
 				AR5416_NUM_5G_20_TARGET_POWERS,
 				&targetPowerOfdmExt,
-				4, AH_TRUE);
+				4, true);
 		}
 	}
 
 	for (ctlMode = 0; ctlMode < numCtlModes; ctlMode++) {
-		enum hal_bool isHt40CtlMode =
+		bool isHt40CtlMode =
 			(pCtlMode[ctlMode] == CTL_5GHT40)
 			|| (pCtlMode[ctlMode] == CTL_2GHT40);
 		if (isHt40CtlMode)
@@ -4453,7 +4448,7 @@ ath9k_hw_set_power_per_rate_table(struct ath_hal *ah,
 				targetPowerCckExt.tPow2x[0];
 		}
 	}
-	return AH_TRUE;
+	return true;
 }
 
 static enum hal_status
@@ -4683,7 +4678,7 @@ static void ath9k_hw_9280_spur_mitigate(struct ath_hal *ah,
 	int8_t mask_amt;
 	int tmp_mask;
 	int cur_bb_spur;
-	enum hal_bool is2GHz = IS_CHAN_2GHZ(chan);
+	bool is2GHz = IS_CHAN_2GHZ(chan);
 
 	memset(&mask_m, 0, sizeof(int8_t) * 123);
 	memset(&mask_p, 0, sizeof(int8_t) * 123);
@@ -4927,7 +4922,7 @@ static void ath9k_hw_spur_mitigate(struct ath_hal *ah,
 	int8_t mask_amt;
 	int tmp_mask;
 	int cur_bb_spur;
-	enum hal_bool is2GHz = IS_CHAN_2GHZ(chan);
+	bool is2GHz = IS_CHAN_2GHZ(chan);
 
 	memset(&mask_m, 0, sizeof(int8_t) * 123);
 	memset(&mask_p, 0, sizeof(int8_t) * 123);
@@ -5243,7 +5238,7 @@ static u_int ath9k_hw_mac_to_clks(struct ath_hal *ah, u_int usecs)
 		return ath9k_hw_mac_clks(ah, usecs);
 }
 
-static enum hal_bool ath9k_hw_set_ack_timeout(struct ath_hal *ah, u_int us)
+static bool ath9k_hw_set_ack_timeout(struct ath_hal *ah, u_int us)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
@@ -5251,16 +5246,16 @@ static enum hal_bool ath9k_hw_set_ack_timeout(struct ath_hal *ah, u_int us)
 		HDPRINTF(ah, HAL_DBG_RESET, "%s: bad ack timeout %u\n",
 			 __func__, us);
 		ahp->ah_acktimeout = (u_int) -1;
-		return AH_FALSE;
+		return false;
 	} else {
 		OS_REG_RMW_FIELD(ah, AR_TIME_OUT,
 				 AR_TIME_OUT_ACK, ath9k_hw_mac_to_clks(ah, us));
 		ahp->ah_acktimeout = us;
-		return AH_TRUE;
+		return true;
 	}
 }
 
-static enum hal_bool ath9k_hw_set_cts_timeout(struct ath_hal *ah, u_int us)
+static bool ath9k_hw_set_cts_timeout(struct ath_hal *ah, u_int us)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
@@ -5268,16 +5263,16 @@ static enum hal_bool ath9k_hw_set_cts_timeout(struct ath_hal *ah, u_int us)
 		HDPRINTF(ah, HAL_DBG_RESET, "%s: bad cts timeout %u\n",
 			 __func__, us);
 		ahp->ah_ctstimeout = (u_int) -1;
-		return AH_FALSE;
+		return false;
 	} else {
 		OS_REG_RMW_FIELD(ah, AR_TIME_OUT,
 				 AR_TIME_OUT_CTS, ath9k_hw_mac_to_clks(ah, us));
 		ahp->ah_ctstimeout = us;
-		return AH_TRUE;
+		return true;
 	}
 }
-static enum hal_bool ath9k_hw_set_global_txtimeout(struct ath_hal *ah,
-						   u_int tu)
+static bool ath9k_hw_set_global_txtimeout(struct ath_hal *ah,
+					  u_int tu)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
@@ -5285,15 +5280,15 @@ static enum hal_bool ath9k_hw_set_global_txtimeout(struct ath_hal *ah,
 		HDPRINTF(ah, HAL_DBG_TX, "%s: bad global tx timeout %u\n",
 			 __func__, tu);
 		ahp->ah_globaltxtimeout = (u_int) -1;
-		return AH_FALSE;
+		return false;
 	} else {
 		OS_REG_RMW_FIELD(ah, AR_GTXTO, AR_GTXTO_TIMEOUT_LIMIT, tu);
 		ahp->ah_globaltxtimeout = tu;
-		return AH_TRUE;
+		return true;
 	}
 }
 
-enum hal_bool ath9k_hw_setslottime(struct ath_hal *ah, u_int us)
+bool ath9k_hw_setslottime(struct ath_hal *ah, u_int us)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
@@ -5301,11 +5296,11 @@ enum hal_bool ath9k_hw_setslottime(struct ath_hal *ah, u_int us)
 		HDPRINTF(ah, HAL_DBG_RESET, "%s: bad slot time %u\n",
 			 __func__, us);
 		ahp->ah_slottime = (u_int) -1;
-		return AH_FALSE;
+		return false;
 	} else {
 		REG_WRITE(ah, AR_D_GBL_IFS_SLOT, ath9k_hw_mac_to_clks(ah, us));
 		ahp->ah_slottime = us;
-		return AH_TRUE;
+		return true;
 	}
 }
 
@@ -5521,11 +5516,11 @@ ath9k_hw_per_calibration(struct ath_hal *ah,
 			 struct hal_channel_internal *ichan,
 			 u_int8_t rxchainmask,
 			 struct hal_cal_list *currCal,
-			 enum hal_bool *isCalDone)
+			 bool *isCalDone)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
-	*isCalDone = AH_FALSE;
+	*isCalDone = false;
 
 	if (currCal->calState == CAL_RUNNING) {
 		if (!(REG_READ(ah,
@@ -5550,7 +5545,7 @@ ath9k_hw_per_calibration(struct ath_hal *ah,
 				ichan->CalValid |=
 					currCal->calData->calType;
 				currCal->calState = CAL_DONE;
-				*isCalDone = AH_TRUE;
+				*isCalDone = true;
 			} else {
 				ath9k_hw_setup_calibration(ah, currCal);
 			}
@@ -5560,18 +5555,18 @@ ath9k_hw_per_calibration(struct ath_hal *ah,
 	}
 }
 
-static inline enum hal_bool ath9k_hw_run_init_cals(struct ath_hal *ah,
-						   int init_cal_count)
+static inline bool ath9k_hw_run_init_cals(struct ath_hal *ah,
+					  int init_cal_count)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct hal_channel_internal ichan;
-	enum hal_bool isCalDone;
+	bool isCalDone;
 	struct hal_cal_list *currCal = ahp->ah_cal_list_curr;
 	const struct hal_percal_data *calData = currCal->calData;
 	int i;
 
 	if (currCal == NULL)
-		return AH_FALSE;
+		return false;
 
 	ichan.CalValid = 0;
 
@@ -5586,12 +5581,12 @@ static inline enum hal_bool ath9k_hw_run_init_cals(struct ath_hal *ah,
 
 			ahp->ah_cal_list = ahp->ah_cal_list_last =
 				ahp->ah_cal_list_curr = NULL;
-			return AH_FALSE;
+			return false;
 		}
 
 		ath9k_hw_per_calibration(ah, &ichan, ahp->ah_rxchainmask,
 					 currCal, &isCalDone);
-		if (isCalDone == AH_FALSE) {
+		if (!isCalDone) {
 			HDPRINTF(ah, HAL_DBG_CALIBRATE,
 				 "%s: Not able to run Init Cal %d.\n",
 				 __func__, calData->calType);
@@ -5603,10 +5598,10 @@ static inline enum hal_bool ath9k_hw_run_init_cals(struct ath_hal *ah,
 	}
 
 	ahp->ah_cal_list = ahp->ah_cal_list_last = ahp->ah_cal_list_curr = NULL;
-	return AH_TRUE;
+	return true;
 }
 
-static inline enum hal_bool
+static inline bool
 ath9k_hw_channel_change(struct ath_hal *ah,
 			struct hal_channel *chan,
 			struct hal_channel_internal *ichan,
@@ -5620,7 +5615,7 @@ ath9k_hw_channel_change(struct ath_hal *ah,
 			HDPRINTF(ah, HAL_DBG_QUEUE,
 				 "%s: Transmit frames pending on queue %d\n",
 				 __func__, qnum);
-			return AH_FALSE;
+			return false;
 		}
 	}
 
@@ -5629,7 +5624,7 @@ ath9k_hw_channel_change(struct ath_hal *ah,
 			   AR_PHY_RFBUS_GRANT_EN)) {
 		HDPRINTF(ah, HAL_DBG_PHY_IO,
 			 "%s: Could not kill baseband RX\n", __func__);
-		return AH_FALSE;
+		return false;
 	}
 
 	ath9k_hw_set_regs(ah, chan, macmode);
@@ -5638,13 +5633,13 @@ ath9k_hw_channel_change(struct ath_hal *ah,
 		if (!(ath9k_hw_ar9280_set_channel(ah, ichan))) {
 			HDPRINTF(ah, HAL_DBG_CHANNEL,
 				 "%s: failed to set channel\n", __func__);
-			return AH_FALSE;
+			return false;
 		}
 	} else {
 		if (!(ath9k_hw_set_channel(ah, ichan))) {
 			HDPRINTF(ah, HAL_DBG_CHANNEL,
 				 "%s: failed to set channel\n", __func__);
-			return AH_FALSE;
+			return false;
 		}
 	}
 
@@ -5657,7 +5652,7 @@ ath9k_hw_channel_change(struct ath_hal *ah,
 	    != HAL_OK) {
 		HDPRINTF(ah, HAL_DBG_EEPROM,
 			 "%s: error init'ing transmit power\n", __func__);
-		return AH_FALSE;
+		return false;
 	}
 
 	synthDelay = REG_READ(ah, AR_PHY_RX_DELAY) & AR_PHY_RX_DELAY_DELAY;
@@ -5679,29 +5674,29 @@ ath9k_hw_channel_change(struct ath_hal *ah,
 		ath9k_hw_spur_mitigate(ah, chan);
 
 	if (!ichan->oneTimeCalsDone)
-		ichan->oneTimeCalsDone = AH_TRUE;
+		ichan->oneTimeCalsDone = true;
 
-	return AH_TRUE;
+	return true;
 }
 
-static enum hal_bool ath9k_hw_chip_reset(struct ath_hal *ah,
-					 struct hal_channel *chan)
+static bool ath9k_hw_chip_reset(struct ath_hal *ah,
+				struct hal_channel *chan)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
 	if (!ath9k_hw_set_reset_reg(ah, HAL_RESET_WARM))
-		return AH_FALSE;
+		return false;
 
 	if (!ath9k_hw_setpower(ah, HAL_PM_AWAKE))
-		return AH_FALSE;
+		return false;
 
-	ahp->ah_chipFullSleep = AH_FALSE;
+	ahp->ah_chipFullSleep = false;
 
 	ath9k_hw_init_pll(ah, chan);
 
 	ath9k_hw_set_rfmode(ah, chan);
 
-	return AH_TRUE;
+	return true;
 }
 
 static inline void ath9k_hw_set_dma(struct ath_hal *ah)
@@ -5730,7 +5725,7 @@ static inline void ath9k_hw_set_dma(struct ath_hal *ah)
 	}
 }
 
-enum hal_bool ath9k_hw_stopdmarecv(struct ath_hal *ah)
+bool ath9k_hw_stopdmarecv(struct ath_hal *ah)
 {
 	REG_WRITE(ah, AR_CR, AR_CR_RXD);
 	if (!ath9k_hw_wait(ah, AR_CR, AR_CR_RXE, 0)) {
@@ -5738,9 +5733,9 @@ enum hal_bool ath9k_hw_stopdmarecv(struct ath_hal *ah)
 			 "AR_CR=0x%08x\nAR_DIAG_SW=0x%08x\n",
 			 __func__,
 			 REG_READ(ah, AR_CR), REG_READ(ah, AR_DIAG_SW));
-		return AH_FALSE;
+		return false;
 	} else {
-		return AH_TRUE;
+		return true;
 	}
 }
 
@@ -5761,31 +5756,31 @@ void ath9k_hw_stoppcurecv(struct ath_hal *ah)
 	ath9k_hw_disable_mib_counters(ah);
 }
 
-static enum hal_bool ath9k_hw_iscal_supported(struct ath_hal *ah,
-					      struct hal_channel *chan,
-					      enum hal_cal_types calType)
+static bool ath9k_hw_iscal_supported(struct ath_hal *ah,
+				     struct hal_channel *chan,
+				     enum hal_cal_types calType)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	enum hal_bool retval = AH_FALSE;
+	bool retval = false;
 
 	switch (calType & ahp->ah_suppCals) {
 	case IQ_MISMATCH_CAL:
 		if (!IS_CHAN_B(chan))
-			retval = AH_TRUE;
+			retval = true;
 		break;
 	case ADC_GAIN_CAL:
 	case ADC_DC_CAL:
 		if (!IS_CHAN_B(chan)
 		    && !(IS_CHAN_2GHZ(chan) && IS_CHAN_HT20(chan)))
-			retval = AH_TRUE;
+			retval = true;
 		break;
 	}
 
 	return retval;
 }
 
-static inline enum hal_bool ath9k_hw_init_cal(struct ath_hal *ah,
-					      struct hal_channel *chan)
+static inline bool ath9k_hw_init_cal(struct ath_hal *ah,
+				     struct hal_channel *chan)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct hal_channel_internal *ichan =
@@ -5800,7 +5795,7 @@ static inline enum hal_bool ath9k_hw_init_cal(struct ath_hal *ah,
 		HDPRINTF(ah, HAL_DBG_CALIBRATE,
 			 "%s: offset calibration failed to complete in 1ms; "
 			 "noisy environment?\n", __func__);
-		return AH_FALSE;
+		return false;
 	}
 
 	REG_WRITE(ah, AR_PHY_AGC_CONTROL,
@@ -5811,24 +5806,21 @@ static inline enum hal_bool ath9k_hw_init_cal(struct ath_hal *ah,
 		NULL;
 
 	if (AR_SREV_9100(ah) || AR_SREV_9160_10_OR_LATER(ah)) {
-		if (AH_TRUE ==
-		    ath9k_hw_iscal_supported(ah, chan, ADC_GAIN_CAL)) {
+		if (ath9k_hw_iscal_supported(ah, chan, ADC_GAIN_CAL)) {
 			INIT_CAL(&ahp->ah_adcGainCalData);
 			INSERT_CAL(ahp, &ahp->ah_adcGainCalData);
 			HDPRINTF(ah, HAL_DBG_CALIBRATE,
 				 "%s: enabling ADC Gain Calibration.\n",
 				 __func__);
 		}
-		if (AH_TRUE ==
-		    ath9k_hw_iscal_supported(ah, chan, ADC_DC_CAL)) {
+		if (ath9k_hw_iscal_supported(ah, chan, ADC_DC_CAL)) {
 			INIT_CAL(&ahp->ah_adcDcCalData);
 			INSERT_CAL(ahp, &ahp->ah_adcDcCalData);
 			HDPRINTF(ah, HAL_DBG_CALIBRATE,
 				 "%s: enabling ADC DC Calibration.\n",
 				 __func__);
 		}
-		if (AH_TRUE ==
-		    ath9k_hw_iscal_supported(ah, chan, IQ_MISMATCH_CAL)) {
+		if (ath9k_hw_iscal_supported(ah, chan, IQ_MISMATCH_CAL)) {
 			INIT_CAL(&ahp->ah_iqCalData);
 			INSERT_CAL(ahp, &ahp->ah_iqCalData);
 			HDPRINTF(ah, HAL_DBG_CALIBRATE,
@@ -5845,17 +5837,17 @@ static inline enum hal_bool ath9k_hw_init_cal(struct ath_hal *ah,
 
 	ichan->CalValid = 0;
 
-	return AH_TRUE;
+	return true;
 }
 
 
-enum hal_bool ath9k_hw_reset(struct ath_hal *ah, enum hal_opmode opmode,
-			     struct hal_channel *chan,
-			     enum hal_ht_macmode macmode,
-			     u_int8_t txchainmask, u_int8_t rxchainmask,
-			     enum hal_ht_extprotspacing extprotspacing,
-			     enum hal_bool bChannelChange,
-			     enum hal_status *status)
+bool ath9k_hw_reset(struct ath_hal *ah, enum hal_opmode opmode,
+		    struct hal_channel *chan,
+		    enum hal_ht_macmode macmode,
+		    u_int8_t txchainmask, u_int8_t rxchainmask,
+		    enum hal_ht_extprotspacing extprotspacing,
+		    bool bChannelChange,
+		    enum hal_status *status)
 {
 #define FAIL(_code)     do { ecode = _code; goto bad; } while (0)
 	u_int32_t saveLedState;
@@ -5885,13 +5877,13 @@ enum hal_bool ath9k_hw_reset(struct ath_hal *ah, enum hal_opmode opmode,
 	}
 
 	if (!ath9k_hw_setpower(ah, HAL_PM_AWAKE))
-		return AH_FALSE;
+		return false;
 
 	if (curchan)
 		ath9k_hw_getnf(ah, curchan);
 
 	if (bChannelChange &&
-	    (ahp->ah_chipFullSleep != AH_TRUE) &&
+	    (ahp->ah_chipFullSleep != true) &&
 	    (ah->ah_curchan != NULL) &&
 	    (chan->channel != ah->ah_curchan->channel) &&
 	    ((chan->channelFlags & CHANNEL_ALL) ==
@@ -5908,7 +5900,7 @@ enum hal_bool ath9k_hw_reset(struct ath_hal *ah, enum hal_opmode opmode,
 
 			ath9k_hw_start_nfcal(ah);
 
-			return AH_TRUE;
+			return true;
 		}
 	}
 
@@ -6055,44 +6047,44 @@ enum hal_bool ath9k_hw_reset(struct ath_hal *ah, enum hal_opmode opmode,
 	}
 	chan->channelFlags = ichan->channelFlags;
 	chan->privFlags = ichan->privFlags;
-	return AH_TRUE;
+	return true;
 bad:
 	if (status)
 		*status = ecode;
-	return AH_FALSE;
+	return false;
 #undef FAIL
 }
 
-enum hal_bool ath9k_hw_phy_disable(struct ath_hal *ah)
+bool ath9k_hw_phy_disable(struct ath_hal *ah)
 {
 	return ath9k_hw_set_reset_reg(ah, HAL_RESET_WARM);
 }
 
-enum hal_bool ath9k_hw_disable(struct ath_hal *ah)
+bool ath9k_hw_disable(struct ath_hal *ah)
 {
 	if (!ath9k_hw_setpower(ah, HAL_PM_AWAKE))
-		return AH_FALSE;
+		return false;
 
 	return ath9k_hw_set_reset_reg(ah, HAL_RESET_COLD);
 }
 
-enum hal_bool
+bool
 ath9k_hw_calibrate(struct ath_hal *ah, struct hal_channel *chan,
-		   u_int8_t rxchainmask, enum hal_bool longcal,
-		   enum hal_bool *isCalDone)
+		   u_int8_t rxchainmask, bool longcal,
+		   bool *isCalDone)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct hal_cal_list *currCal = ahp->ah_cal_list_curr;
 	struct hal_channel_internal *ichan =
 		ath9k_regd_check_channel(ah, chan);
 
-	*isCalDone = AH_TRUE;
+	*isCalDone = true;
 
 	if (ichan == NULL) {
 		HDPRINTF(ah, HAL_DBG_CHANNEL,
 			 "%s: invalid channel %u/0x%x; no mapping\n",
 			 __func__, chan->channel, chan->channelFlags);
-		return AH_FALSE;
+		return false;
 	}
 
 	if (currCal &&
@@ -6100,11 +6092,11 @@ ath9k_hw_calibrate(struct ath_hal *ah, struct hal_channel *chan,
 	     currCal->calState == CAL_WAITING)) {
 		ath9k_hw_per_calibration(ah, ichan, rxchainmask, currCal,
 					 isCalDone);
-		if (*isCalDone == AH_TRUE) {
+		if (*isCalDone) {
 			ahp->ah_cal_list_curr = currCal = currCal->calNext;
 
 			if (currCal->calState == CAL_WAITING) {
-				*isCalDone = AH_FALSE;
+				*isCalDone = false;
 				ath9k_hw_reset_calibration(ah, currCal);
 			}
 		}
@@ -6122,7 +6114,7 @@ ath9k_hw_calibrate(struct ath_hal *ah, struct hal_channel *chan,
 		}
 	}
 
-	return AH_TRUE;
+	return true;
 }
 
 static void ath9k_hw_iqcal_collect(struct ath_hal *ah)
@@ -6396,7 +6388,7 @@ ath9k_hw_adc_dccal_calibrate(struct ath_hal *ah, u_int8_t numChains)
 		  AR_PHY_NEW_ADC_DC_OFFSET_CORR_ENABLE);
 }
 
-enum hal_bool ath9k_hw_set_txpowerlimit(struct ath_hal *ah, u_int32_t limit)
+bool ath9k_hw_set_txpowerlimit(struct ath_hal *ah, u_int32_t limit)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct hal_channel_internal *ichan = ah->ah_curchan;
@@ -6412,9 +6404,9 @@ enum hal_bool ath9k_hw_set_txpowerlimit(struct ath_hal *ah, u_int32_t limit)
 				 min((u_int32_t) MAX_RATE_POWER,
 				     (u_int32_t) ah->ah_powerLimit))
 	    != HAL_OK)
-		return AH_FALSE;
+		return false;
 
-	return AH_TRUE;
+	return true;
 }
 
 void
@@ -6456,14 +6448,14 @@ ath9k_hw_get_channel_centers(struct ath_hal *ah,
 
 void
 ath9k_hw_reset_calvalid(struct ath_hal *ah, struct hal_channel *chan,
-			enum hal_bool *isCalDone)
+			bool *isCalDone)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct hal_channel_internal *ichan =
 		ath9k_regd_check_channel(ah, chan);
 	struct hal_cal_list *currCal = ahp->ah_cal_list_curr;
 
-	*isCalDone = AH_TRUE;
+	*isCalDone = true;
 
 	if (!AR_SREV_9100(ah) && !AR_SREV_9160_10_OR_LATER(ah))
 		return;
@@ -6487,8 +6479,7 @@ ath9k_hw_reset_calvalid(struct ath_hal *ah, struct hal_channel *chan,
 	}
 
 
-	if (ath9k_hw_iscal_supported(ah, chan, currCal->calData->calType)
-	    == AH_FALSE) {
+	if (!ath9k_hw_iscal_supported(ah, chan, currCal->calData->calType)) {
 		return;
 	}
 
@@ -6500,7 +6491,7 @@ ath9k_hw_reset_calvalid(struct ath_hal *ah, struct hal_channel *chan,
 	ichan->CalValid &= ~currCal->calData->calType;
 	currCal->calState = CAL_WAITING;
 
-	*isCalDone = AH_FALSE;
+	*isCalDone = false;
 }
 
 void ath9k_hw_getmac(struct ath_hal *ah, u_int8_t *mac)
@@ -6510,12 +6501,12 @@ void ath9k_hw_getmac(struct ath_hal *ah, u_int8_t *mac)
 	memcpy(mac, ahp->ah_macaddr, ETH_ALEN);
 }
 
-enum hal_bool ath9k_hw_setmac(struct ath_hal *ah, const u_int8_t *mac)
+bool ath9k_hw_setmac(struct ath_hal *ah, const u_int8_t *mac)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
 	memcpy(ahp->ah_macaddr, mac, ETH_ALEN);
-	return AH_TRUE;
+	return true;
 }
 
 void ath9k_hw_getbssidmask(struct ath_hal *ah, u_int8_t *mask)
@@ -6525,7 +6516,7 @@ void ath9k_hw_getbssidmask(struct ath_hal *ah, u_int8_t *mask)
 	memcpy(mask, ahp->ah_bssidmask, ETH_ALEN);
 }
 
-enum hal_bool
+bool
 ath9k_hw_setbssidmask(struct ath_hal *ah, const u_int8_t *mask)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
@@ -6535,7 +6526,7 @@ ath9k_hw_setbssidmask(struct ath_hal *ah, const u_int8_t *mask)
 	REG_WRITE(ah, AR_BSSMSKL, LE_READ_4(ahp->ah_bssidmask));
 	REG_WRITE(ah, AR_BSSMSKU, LE_READ_2(ahp->ah_bssidmask + 4));
 
-	return AH_TRUE;
+	return true;
 }
 
 #ifdef CONFIG_ATH9K_RFKILL
@@ -6614,7 +6605,7 @@ void ath9k_hw_setantenna(struct ath_hal *ah, u_int antenna)
 	REG_WRITE(ah, AR_DEF_ANTENNA, (antenna & 0x7));
 }
 
-enum hal_bool
+bool
 ath9k_hw_setantennaswitch(struct ath_hal *ah,
 			  enum hal_ant_setting settings,
 			  struct hal_channel *chan,
@@ -6636,7 +6627,7 @@ ath9k_hw_setantennaswitch(struct ath_hal *ah,
 		case HAL_ANT_FIXED_A:
 			*tx_chainmask = ATH9K_ANTENNA0_CHAINMASK;
 			*rx_chainmask = ATH9K_ANTENNA0_CHAINMASK;
-			*antenna_cfgd = AH_TRUE;
+			*antenna_cfgd = true;
 			break;
 		case HAL_ANT_FIXED_B:
 			if (ah->ah_caps.halTxChainMask >
@@ -6644,12 +6635,12 @@ ath9k_hw_setantennaswitch(struct ath_hal *ah,
 				*tx_chainmask = ATH9K_ANTENNA1_CHAINMASK;
 			}
 			*rx_chainmask = ATH9K_ANTENNA1_CHAINMASK;
-			*antenna_cfgd = AH_TRUE;
+			*antenna_cfgd = true;
 			break;
 		case HAL_ANT_VARIABLE:
 			*tx_chainmask = tx_chainmask_cfg;
 			*rx_chainmask = rx_chainmask_cfg;
-			*antenna_cfgd = AH_TRUE;
+			*antenna_cfgd = true;
 			break;
 		default:
 			break;
@@ -6658,7 +6649,7 @@ ath9k_hw_setantennaswitch(struct ath_hal *ah,
 		ahp->ah_diversityControl = settings;
 	}
 
-	return AH_TRUE;
+	return true;
 }
 
 void ath9k_hw_setopmode(struct ath_hal *ah)
@@ -6666,7 +6657,7 @@ void ath9k_hw_setopmode(struct ath_hal *ah)
 	ath9k_hw_set_operating_mode(ah, ah->ah_opmode);
 }
 
-enum hal_bool
+bool
 ath9k_hw_getcapability(struct ath_hal *ah, enum hal_capability_type type,
 		       u_int32_t capability, u_int32_t *result)
 {
@@ -6682,22 +6673,22 @@ ath9k_hw_getcapability(struct ath_hal *ah, enum hal_capability_type type,
 		case HAL_CIPHER_WEP:
 		case HAL_CIPHER_MIC:
 		case HAL_CIPHER_CLR:
-			return AH_TRUE;
+			return true;
 		default:
-			return AH_FALSE;
+			return false;
 		}
 	case HAL_CAP_TKIP_MIC:
 		switch (capability) {
 		case 0:
-			return AH_TRUE;
+			return true;
 		case 1:
 			return (ahp->ah_staId1Defaults &
-				AR_STA_ID1_CRPT_MIC_ENABLE) ? AH_TRUE :
-			AH_FALSE;
+				AR_STA_ID1_CRPT_MIC_ENABLE) ? true :
+			false;
 		}
 	case HAL_CAP_TKIP_SPLIT:
 		return (ahp->ah_miscMode & AR_PCU_MIC_NEW_LOC_ENA) ?
-			AH_FALSE : AH_TRUE;
+			false : true;
 	case HAL_CAP_WME_TKIPMIC:
 		return HAL_OK;
 	case HAL_CAP_PHYCOUNTERS:
@@ -6705,41 +6696,41 @@ ath9k_hw_getcapability(struct ath_hal *ah, enum hal_capability_type type,
 	case HAL_CAP_DIVERSITY:
 		return (REG_READ(ah, AR_PHY_CCK_DETECT) &
 			AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV) ?
-			AH_TRUE : AH_FALSE;
+			true : false;
 	case HAL_CAP_PHYDIAG:
-		return AH_TRUE;
+		return true;
 	case HAL_CAP_MCAST_KEYSRCH:
 		switch (capability) {
 		case 0:
-			return AH_TRUE;
+			return true;
 		case 1:
 			if (REG_READ(ah, AR_STA_ID1) & AR_STA_ID1_ADHOC) {
-				return AH_FALSE;
+				return false;
 			} else {
 				return (ahp->ah_staId1Defaults &
-					AR_STA_ID1_MCAST_KSRCH) ? AH_TRUE :
-					AH_FALSE;
+					AR_STA_ID1_MCAST_KSRCH) ? true :
+					false;
 			}
 		}
-		return AH_FALSE;
+		return false;
 	case HAL_CAP_TSF_ADJUST:
 		switch (capability) {
 		case 0:
-			return AH_TRUE;
+			return true;
 		case 1:
 			return (ahp->ah_miscMode & AR_PCU_TX_ADD_TSF) ?
-				AH_TRUE : AH_FALSE;
+				true : false;
 		}
-		return AH_FALSE;
+		return false;
 	case HAL_CAP_RFSILENT:
 		if (capability == 3)
-			return AH_FALSE;
+			return false;
 	case HAL_CAP_ANT_CFG_2GHZ:
 		*result = pCap->halNumAntCfg2GHz;
-		return AH_TRUE;
+		return true;
 	case HAL_CAP_ANT_CFG_5GHZ:
 		*result = pCap->halNumAntCfg5GHz;
-		return AH_TRUE;
+		return true;
 	case HAL_CAP_TXPOW:
 		switch (capability) {
 		case 0:
@@ -6754,9 +6745,9 @@ ath9k_hw_getcapability(struct ath_hal *ah, enum hal_capability_type type,
 			*result = ah->ah_tpScale;
 			return HAL_OK;
 		}
-		return AH_FALSE;
+		return false;
 	default:
-		return AH_FALSE;
+		return false;
 	}
 }
 
@@ -6785,32 +6776,32 @@ ath9k_hw_select_antconfig(struct ath_hal *ah, u_int32_t cfg)
 	return HAL_EINVAL;
 }
 
-enum hal_bool ath9k_hw_intrpend(struct ath_hal *ah)
+bool ath9k_hw_intrpend(struct ath_hal *ah)
 {
 	u_int32_t host_isr;
 
 	if (AR_SREV_9100(ah))
-		return AH_TRUE;
+		return true;
 
 	host_isr = REG_READ(ah, AR_INTR_ASYNC_CAUSE);
 	if ((host_isr & AR_INTR_MAC_IRQ) && (host_isr != AR_INTR_SPURIOUS))
-		return AH_TRUE;
+		return true;
 
 	host_isr = REG_READ(ah, AR_INTR_SYNC_CAUSE);
 	if ((host_isr & AR_INTR_SYNC_DEFAULT)
 	    && (host_isr != AR_INTR_SPURIOUS))
-		return AH_TRUE;
+		return true;
 
-	return AH_FALSE;
+	return false;
 }
 
-enum hal_bool ath9k_hw_getisr(struct ath_hal *ah, enum hal_int *masked)
+bool ath9k_hw_getisr(struct ath_hal *ah, enum hal_int *masked)
 {
 	u_int32_t isr = 0;
 	u_int32_t mask2 = 0;
 	struct hal_capabilities *pCap = &ah->ah_caps;
 	u_int32_t sync_cause = 0;
-	enum hal_bool fatal_int = AH_FALSE;
+	bool fatal_int = false;
 
 	if (!AR_SREV_9100(ah)) {
 		if (REG_READ(ah, AR_INTR_ASYNC_CAUSE) & AR_INTR_MAC_IRQ) {
@@ -6827,7 +6818,7 @@ enum hal_bool ath9k_hw_getisr(struct ath_hal *ah, enum hal_int *masked)
 		*masked = 0;
 
 		if (!isr && !sync_cause)
-			return AH_FALSE;
+			return false;
 	} else {
 		*masked = 0;
 		isr = REG_READ(ah, AR_ISR);
@@ -6856,7 +6847,7 @@ enum hal_bool ath9k_hw_getisr(struct ath_hal *ah, enum hal_int *masked)
 		isr = REG_READ(ah, AR_ISR_RAC);
 		if (isr == 0xffffffff) {
 			*masked = 0;
-			return AH_FALSE;
+			return false;
 		}
 
 		*masked = isr & HAL_INT_COMMON;
@@ -6902,14 +6893,14 @@ enum hal_bool ath9k_hw_getisr(struct ath_hal *ah, enum hal_int *masked)
 		*masked |= mask2;
 	}
 	if (AR_SREV_9100(ah))
-		return AH_TRUE;
+		return true;
 	if (sync_cause) {
 		fatal_int =
 			(sync_cause &
 			 (AR_INTR_SYNC_HOST1_FATAL | AR_INTR_SYNC_HOST1_PERR))
-			? AH_TRUE : AH_FALSE;
+			? true : false;
 
-		if (AH_TRUE == fatal_int) {
+		if (fatal_int) {
 			if (sync_cause & AR_INTR_SYNC_HOST1_FATAL) {
 				HDPRINTF(ah, HAL_DBG_UNMASKABLE,
 					 "%s: received PCI FATAL interrupt\n",
@@ -6938,7 +6929,7 @@ enum hal_bool ath9k_hw_getisr(struct ath_hal *ah, enum hal_int *masked)
 		REG_WRITE(ah, AR_INTR_SYNC_CAUSE_CLR, sync_cause);
 		(void) REG_READ(ah, AR_INTR_SYNC_CAUSE_CLR);
 	}
-	return AH_TRUE;
+	return true;
 }
 
 enum hal_int ath9k_hw_intrget(struct ath_hal *ah)
@@ -7174,24 +7165,24 @@ ath9k_hw_set_sta_beacon_timers(struct ath_hal *ah,
 
 }
 
-enum hal_bool ath9k_hw_keyisvalid(struct ath_hal *ah, u_int16_t entry)
+bool ath9k_hw_keyisvalid(struct ath_hal *ah, u_int16_t entry)
 {
 	if (entry < ah->ah_caps.halKeyCacheSize) {
 		u_int32_t val = REG_READ(ah, AR_KEYTABLE_MAC1(entry));
 		if (val & AR_KEYTABLE_VALID)
-			return AH_TRUE;
+			return true;
 	}
-	return AH_FALSE;
+	return false;
 }
 
-enum hal_bool ath9k_hw_keyreset(struct ath_hal *ah, u_int16_t entry)
+bool ath9k_hw_keyreset(struct ath_hal *ah, u_int16_t entry)
 {
 	u_int32_t keyType;
 
 	if (entry >= ah->ah_caps.halKeyCacheSize) {
 		HDPRINTF(ah, HAL_DBG_KEYCACHE,
 			 "%s: entry %u out of range\n", __func__, entry);
-		return AH_FALSE;
+		return false;
 	}
 	keyType = REG_READ(ah, AR_KEYTABLE_TYPE(entry));
 
@@ -7215,12 +7206,12 @@ enum hal_bool ath9k_hw_keyreset(struct ath_hal *ah, u_int16_t entry)
 	}
 
 	if (ah->ah_curchan == NULL)
-		return AH_TRUE;
+		return true;
 
-	return AH_TRUE;
+	return true;
 }
 
-enum hal_bool
+bool
 ath9k_hw_keysetmac(struct ath_hal *ah, u_int16_t entry,
 		   const u_int8_t *mac)
 {
@@ -7229,7 +7220,7 @@ ath9k_hw_keysetmac(struct ath_hal *ah, u_int16_t entry,
 	if (entry >= ah->ah_caps.halKeyCacheSize) {
 		HDPRINTF(ah, HAL_DBG_KEYCACHE,
 			 "%s: entry %u out of range\n", __func__, entry);
-		return AH_FALSE;
+		return false;
 	}
 
 	if (mac != NULL) {
@@ -7245,10 +7236,10 @@ ath9k_hw_keysetmac(struct ath_hal *ah, u_int16_t entry,
 	REG_WRITE(ah, AR_KEYTABLE_MAC0(entry), macLo);
 	REG_WRITE(ah, AR_KEYTABLE_MAC1(entry), macHi | AR_KEYTABLE_VALID);
 
-	return AH_TRUE;
+	return true;
 }
 
-enum hal_bool
+bool
 ath9k_hw_set_keycache_entry(struct ath_hal *ah, u_int16_t entry,
 			    const struct hal_keyval *k,
 			    const u_int8_t *mac, int xorKey)
@@ -7264,7 +7255,7 @@ ath9k_hw_set_keycache_entry(struct ath_hal *ah, u_int16_t entry,
 	if (entry >= pCap->halKeyCacheSize) {
 		HDPRINTF(ah, HAL_DBG_KEYCACHE,
 			 "%s: entry %u out of range\n", __func__, entry);
-		return AH_FALSE;
+		return false;
 	}
 	switch (k->kv_type) {
 	case HAL_CIPHER_AES_OCB:
@@ -7276,7 +7267,7 @@ ath9k_hw_set_keycache_entry(struct ath_hal *ah, u_int16_t entry,
 				 "%s: AES-CCM not supported by "
 				 "mac rev 0x%x\n", __func__,
 				 ah->ah_macRev);
-			return AH_FALSE;
+			return false;
 		}
 		keyType = AR_KEYTABLE_TYPE_CCM;
 		break;
@@ -7287,7 +7278,7 @@ ath9k_hw_set_keycache_entry(struct ath_hal *ah, u_int16_t entry,
 			HDPRINTF(ah, HAL_DBG_KEYCACHE,
 				 "%s: entry %u inappropriate for TKIP\n",
 				 __func__, entry);
-			return AH_FALSE;
+			return false;
 		}
 		break;
 	case HAL_CIPHER_WEP:
@@ -7295,7 +7286,7 @@ ath9k_hw_set_keycache_entry(struct ath_hal *ah, u_int16_t entry,
 			HDPRINTF(ah, HAL_DBG_KEYCACHE,
 				 "%s: WEP key length %u too small\n",
 				 __func__, k->kv_len);
-			return AH_FALSE;
+			return false;
 		}
 		if (k->kv_len <= 40 / NBBY)
 			keyType = AR_KEYTABLE_TYPE_40;
@@ -7311,7 +7302,7 @@ ath9k_hw_set_keycache_entry(struct ath_hal *ah, u_int16_t entry,
 		HDPRINTF(ah, HAL_DBG_KEYCACHE,
 			 "%s: cipher %u not supported\n", __func__,
 			 k->kv_type);
-		return AH_FALSE;
+		return false;
 	}
 
 	key0 = LE_READ_4(k->kv_val + 0) ^ xorMask;
@@ -7378,20 +7369,20 @@ ath9k_hw_set_keycache_entry(struct ath_hal *ah, u_int16_t entry,
 	}
 
 	if (ah->ah_curchan == NULL)
-		return AH_TRUE;
+		return true;
 
-	return AH_TRUE;
+	return true;
 }
 
-enum hal_bool
-ath9k_hw_updatetxtriglevel(struct ath_hal *ah, enum hal_bool bIncTrigLevel)
+bool
+ath9k_hw_updatetxtriglevel(struct ath_hal *ah, bool bIncTrigLevel)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	u_int32_t txcfg, curLevel, newLevel;
 	enum hal_int omask;
 
 	if (ah->ah_txTrigLevel >= MAX_TX_FIFO_THRESHOLD)
-		return AH_FALSE;
+		return false;
 
 	omask = ath9k_hw_set_interrupts(ah, ahp->ah_maskReg & ~HAL_INT_GLOBAL);
 
@@ -7414,16 +7405,16 @@ ath9k_hw_updatetxtriglevel(struct ath_hal *ah, enum hal_bool bIncTrigLevel)
 	return newLevel != curLevel;
 }
 
-static enum hal_bool ath9k_hw_set_txq_props(struct ath_hal *ah,
-				     struct hal_tx_queue_info *qi,
-				     const struct hal_txq_info *qInfo)
+static bool ath9k_hw_set_txq_props(struct ath_hal *ah,
+				   struct hal_tx_queue_info *qi,
+				   const struct hal_txq_info *qInfo)
 {
 	u_int32_t cw;
 
 	if (qi->tqi_type == HAL_TX_QUEUE_INACTIVE) {
 		HDPRINTF(ah, HAL_DBG_QUEUE, "%s: inactive queue\n",
 			 __func__);
-		return AH_FALSE;
+		return false;
 	}
 
 	HDPRINTF(ah, HAL_DBG_QUEUE, "%s: queue %p\n", __func__, qi);
@@ -7472,11 +7463,11 @@ static enum hal_bool ath9k_hw_set_txq_props(struct ath_hal *ah,
 	default:
 		break;
 	}
-	return AH_TRUE;
+	return true;
 }
 
-enum hal_bool ath9k_hw_settxqueueprops(struct ath_hal *ah, int q,
-				       const struct hal_txq_info *qInfo)
+bool ath9k_hw_settxqueueprops(struct ath_hal *ah, int q,
+			      const struct hal_txq_info *qInfo)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct hal_capabilities *pCap = &ah->ah_caps;
@@ -7484,19 +7475,19 @@ enum hal_bool ath9k_hw_settxqueueprops(struct ath_hal *ah, int q,
 	if (q >= pCap->halTotalQueues) {
 		HDPRINTF(ah, HAL_DBG_QUEUE, "%s: invalid queue num %u\n",
 			 __func__, q);
-		return AH_FALSE;
+		return false;
 	}
 	return ath9k_hw_set_txq_props(ah, &ahp->ah_txq[q], qInfo);
 }
 
-static enum hal_bool ath9k_hw_get_txq_props(struct ath_hal *ah,
-				     struct hal_txq_info *qInfo,
-				     const struct hal_tx_queue_info *qi)
+static bool ath9k_hw_get_txq_props(struct ath_hal *ah,
+				   struct hal_txq_info *qInfo,
+				   const struct hal_tx_queue_info *qi)
 {
 	if (qi->tqi_type == HAL_TX_QUEUE_INACTIVE) {
 		HDPRINTF(ah, HAL_DBG_QUEUE, "%s: inactive queue\n",
 			 __func__);
-		return AH_FALSE;
+		return false;
 	}
 
 	qInfo->tqi_qflags = qi->tqi_qflags;
@@ -7514,10 +7505,10 @@ static enum hal_bool ath9k_hw_get_txq_props(struct ath_hal *ah,
 	qInfo->tqi_burstTime = qi->tqi_burstTime;
 	qInfo->tqi_readyTime = qi->tqi_readyTime;
 
-	return AH_TRUE;
+	return true;
 }
 
-enum hal_bool
+bool
 ath9k_hw_gettxqueueprops(struct ath_hal *ah, int q,
 			 struct hal_txq_info *qInfo)
 {
@@ -7527,7 +7518,7 @@ ath9k_hw_gettxqueueprops(struct ath_hal *ah, int q,
 	if (q >= pCap->halTotalQueues) {
 		HDPRINTF(ah, HAL_DBG_QUEUE, "%s: invalid queue num %u\n",
 			 __func__, q);
-		return AH_FALSE;
+		return false;
 	}
 	return ath9k_hw_get_txq_props(ah, qInfo, &ahp->ah_txq[q]);
 }
@@ -7624,7 +7615,7 @@ ath9k_hw_set_txq_interrupts(struct ath_hal *ah,
 			 AR_IMR_S2_QCU_TXURN, ahp->ah_txUrnInterruptMask);
 }
 
-enum hal_bool ath9k_hw_releasetxqueue(struct ath_hal *ah, u_int q)
+bool ath9k_hw_releasetxqueue(struct ath_hal *ah, u_int q)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct hal_capabilities *pCap = &ah->ah_caps;
@@ -7633,13 +7624,13 @@ enum hal_bool ath9k_hw_releasetxqueue(struct ath_hal *ah, u_int q)
 	if (q >= pCap->halTotalQueues) {
 		HDPRINTF(ah, HAL_DBG_QUEUE, "%s: invalid queue num %u\n",
 			 __func__, q);
-		return AH_FALSE;
+		return false;
 	}
 	qi = &ahp->ah_txq[q];
 	if (qi->tqi_type == HAL_TX_QUEUE_INACTIVE) {
 		HDPRINTF(ah, HAL_DBG_QUEUE, "%s: inactive queue %u\n",
 			 __func__, q);
-		return AH_FALSE;
+		return false;
 	}
 
 	HDPRINTF(ah, HAL_DBG_QUEUE, "%s: release queue %u\n", __func__, q);
@@ -7652,10 +7643,10 @@ enum hal_bool ath9k_hw_releasetxqueue(struct ath_hal *ah, u_int q)
 	ahp->ah_txUrnInterruptMask &= ~(1 << q);
 	ath9k_hw_set_txq_interrupts(ah, qi);
 
-	return AH_TRUE;
+	return true;
 }
 
-enum hal_bool ath9k_hw_resettxqueue(struct ath_hal *ah, u_int q)
+bool ath9k_hw_resettxqueue(struct ath_hal *ah, u_int q)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct hal_capabilities *pCap = &ah->ah_caps;
@@ -7666,13 +7657,13 @@ enum hal_bool ath9k_hw_resettxqueue(struct ath_hal *ah, u_int q)
 	if (q >= pCap->halTotalQueues) {
 		HDPRINTF(ah, HAL_DBG_QUEUE, "%s: invalid queue num %u\n",
 			 __func__, q);
-		return AH_FALSE;
+		return false;
 	}
 	qi = &ahp->ah_txq[q];
 	if (qi->tqi_type == HAL_TX_QUEUE_INACTIVE) {
 		HDPRINTF(ah, HAL_DBG_QUEUE, "%s: inactive queue %u\n",
 			 __func__, q);
-		return AH_TRUE;
+		return true;
 	}
 
 	HDPRINTF(ah, HAL_DBG_QUEUE, "%s: reset queue %u\n", __func__, q);
@@ -7818,7 +7809,7 @@ enum hal_bool ath9k_hw_resettxqueue(struct ath_hal *ah, u_int q)
 		ahp->ah_txUrnInterruptMask &= ~(1 << q);
 	ath9k_hw_set_txq_interrupts(ah, qi);
 
-	return AH_TRUE;
+	return true;
 }
 
 void ath9k_hw_gettxintrtxqs(struct ath_hal *ah, u_int32_t *txqs)
@@ -7828,10 +7819,10 @@ void ath9k_hw_gettxintrtxqs(struct ath_hal *ah, u_int32_t *txqs)
 	ahp->ah_intrTxqs &= ~(*txqs);
 }
 
-enum hal_bool
+bool
 ath9k_hw_filltxdesc(struct ath_hal *ah, struct ath_desc *ds,
-		    u_int segLen, enum hal_bool firstSeg,
-		    enum hal_bool lastSeg, const struct ath_desc *ds0)
+		    u_int segLen, bool firstSeg,
+		    bool lastSeg, const struct ath_desc *ds0)
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
 
@@ -7853,7 +7844,7 @@ ath9k_hw_filltxdesc(struct ath_hal *ah, struct ath_desc *ds,
 	ads->ds_txstatus4 = ads->ds_txstatus5 = 0;
 	ads->ds_txstatus6 = ads->ds_txstatus7 = 0;
 	ads->ds_txstatus8 = ads->ds_txstatus9 = 0;
-	return AH_TRUE;
+	return true;
 }
 
 void ath9k_hw_cleartxdesc(struct ath_hal *ah, struct ath_desc *ds)
@@ -7895,11 +7886,11 @@ ath9k_hw_txprocdesc(struct ath_hal *ah, struct ath_desc *ds)
 		ds->ds_txstat.ts_flags |= ATH9K_TX_DESC_CFG_ERR;
 	if (ads->ds_txstatus1 & AR_TxDataUnderrun) {
 		ds->ds_txstat.ts_flags |= ATH9K_TX_DATA_UNDERRUN;
-		ath9k_hw_updatetxtriglevel(ah, AH_TRUE);
+		ath9k_hw_updatetxtriglevel(ah, true);
 	}
 	if (ads->ds_txstatus1 & AR_TxDelimUnderrun) {
 		ds->ds_txstat.ts_flags |= ATH9K_TX_DELIM_UNDERRUN;
-		ath9k_hw_updatetxtriglevel(ah, AH_TRUE);
+		ath9k_hw_updatetxtriglevel(ah, true);
 	}
 	if (ads->ds_txstatus0 & AR_TxBaStatus) {
 		ds->ds_txstat.ts_flags |= ATH9K_TX_BA;
@@ -8113,7 +8104,7 @@ void ath9k_hw_rxena(struct ath_hal *ah)
 	REG_WRITE(ah, AR_CR, AR_CR_RXE);
 }
 
-enum hal_bool ath9k_hw_setrxabort(struct ath_hal *ah, enum hal_bool set)
+bool ath9k_hw_setrxabort(struct ath_hal *ah, bool set)
 {
 	if (set) {
 
@@ -8133,14 +8124,14 @@ enum hal_bool ath9k_hw_setrxabort(struct ath_hal *ah, enum hal_bool set)
 				"%s: rx failed to go idle in 10 ms RXSM=0x%x\n",
 				__func__, reg);
 
-			return AH_FALSE;
+			return false;
 		}
 	} else {
 		OS_REG_CLR_BIT(ah, AR_DIAG_SW,
 			       (AR_DIAG_RX_DIS | AR_DIAG_RX_ABORT));
 	}
 
-	return AH_TRUE;
+	return true;
 }
 
 void
@@ -8151,7 +8142,7 @@ ath9k_hw_setmcastfilter(struct ath_hal *ah, u_int32_t filter0,
 	REG_WRITE(ah, AR_MCAST_FIL1, filter1);
 }
 
-enum hal_bool
+bool
 ath9k_hw_setuprxdesc(struct ath_hal *ah, struct ath_desc *ds,
 		     u_int32_t size, u_int flags)
 {
@@ -8165,7 +8156,7 @@ ath9k_hw_setuprxdesc(struct ath_hal *ah, struct ath_desc *ds,
 	ads->ds_rxstatus8 &= ~AR_RxDone;
 	if (!pCap->halAutoSleepSupport)
 		memset(&(ads->u), 0, sizeof(ads->u));
-	return AH_TRUE;
+	return true;
 }
 
 enum hal_status
@@ -8256,12 +8247,12 @@ static void ath9k_hw_setup_rate_table(struct ath_hal *ah,
 			ath9k_hw_computetxtime(ah, rt,
 					       WLAN_CTRL_FRAME_SIZE,
 					       cix,
-					       AH_FALSE);
+					       false);
 		rt->info[i].spAckDuration =
 			ath9k_hw_computetxtime(ah, rt,
 					       WLAN_CTRL_FRAME_SIZE,
 					       cix,
-					       AH_TRUE);
+					       true);
 	}
 }
 
@@ -8357,7 +8348,7 @@ u_int16_t
 ath9k_hw_computetxtime(struct ath_hal *ah,
 		       const struct hal_rate_table *rates,
 		       u_int32_t frameLen, u_int16_t rateix,
-		       enum hal_bool shortPreamble)
+		       bool shortPreamble)
 {
 	u_int32_t bitsPerSymbol, numBits, numSymbols, phyTime, txTime;
 	u_int32_t kbps;
@@ -8475,7 +8466,7 @@ ath9k_hw_getchan_noise(struct ath_hal *ah, struct hal_channel *chan)
 		return ichan->rawNoiseFloor;
 }
 
-enum hal_bool ath9k_hw_set_tsfadjust(struct ath_hal *ah, u_int32_t setting)
+bool ath9k_hw_set_tsfadjust(struct ath_hal *ah, u_int32_t setting)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
@@ -8483,14 +8474,14 @@ enum hal_bool ath9k_hw_set_tsfadjust(struct ath_hal *ah, u_int32_t setting)
 		ahp->ah_miscMode |= AR_PCU_TX_ADD_TSF;
 	else
 		ahp->ah_miscMode &= ~AR_PCU_TX_ADD_TSF;
-	return AH_TRUE;
+	return true;
 }
 
-enum hal_bool ath9k_hw_phycounters(struct ath_hal *ah)
+bool ath9k_hw_phycounters(struct ath_hal *ah)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
-	return ahp->ah_hasHwPhyCounters ? AH_TRUE : AH_FALSE;
+	return ahp->ah_hasHwPhyCounters ? true : false;
 }
 
 u_int32_t ath9k_hw_gettxbuf(struct ath_hal *ah, u_int q)
@@ -8498,21 +8489,21 @@ u_int32_t ath9k_hw_gettxbuf(struct ath_hal *ah, u_int q)
 	return REG_READ(ah, AR_QTXDP(q));
 }
 
-enum hal_bool ath9k_hw_puttxbuf(struct ath_hal *ah, u_int q,
-				u_int32_t txdp)
+bool ath9k_hw_puttxbuf(struct ath_hal *ah, u_int q,
+		       u_int32_t txdp)
 {
 	REG_WRITE(ah, AR_QTXDP(q), txdp);
 
-	return AH_TRUE;
+	return true;
 }
 
-enum hal_bool ath9k_hw_txstart(struct ath_hal *ah, u_int q)
+bool ath9k_hw_txstart(struct ath_hal *ah, u_int q)
 {
 	HDPRINTF(ah, HAL_DBG_QUEUE, "%s: queue %u\n", __func__, q);
 
 	REG_WRITE(ah, AR_Q_TXE, 1 << q);
 
-	return AH_TRUE;
+	return true;
 }
 
 u_int32_t ath9k_hw_numtxpending(struct ath_hal *ah, u_int q)
@@ -8528,7 +8519,7 @@ u_int32_t ath9k_hw_numtxpending(struct ath_hal *ah, u_int q)
 	return npend;
 }
 
-enum hal_bool ath9k_hw_stoptxdma(struct ath_hal *ah, u_int q)
+bool ath9k_hw_stoptxdma(struct ath_hal *ah, u_int q)
 {
 	u_int wait;
 
diff --git a/drivers/net/wireless/ath9k/hw.h b/drivers/net/wireless/ath9k/hw.h
index 089aecd..1a77ed3 100644
--- a/drivers/net/wireless/ath9k/hw.h
+++ b/drivers/net/wireless/ath9k/hw.h
@@ -711,7 +711,7 @@ struct ath_hal_5416 {
 	u_int32_t ah_txUrnInterruptMask;
 	struct hal_tx_queue_info ah_txq[HAL_NUM_TX_QUEUES];
 	enum hal_power_mode ah_powerMode;
-	enum hal_bool ah_chipFullSleep;
+	bool ah_chipFullSleep;
 	u_int32_t ah_atimWindow;
 	enum hal_ant_setting ah_diversityControl;
 	u_int16_t ah_antennaSwitchSwap;
@@ -754,7 +754,7 @@ struct ath_hal_5416 {
 	u_int32_t ah_tx6PowerInHalfDbm;
 	u_int32_t ah_staId1Defaults;
 	u_int32_t ah_miscMode;
-	enum hal_bool ah_tpcEnabled;
+	bool ah_tpcEnabled;
 	u_int32_t ah_beaconInterval;
 	enum {
 		AUTO_32KHZ,
@@ -780,9 +780,9 @@ struct ath_hal_5416 {
 	u_int32_t ah_gpioSelect;
 	u_int32_t ah_polarity;
 	u_int32_t ah_gpioBit;
-	enum hal_bool ah_eepEnabled;
+	bool ah_eepEnabled;
 	u_int32_t ah_procPhyErr;
-	enum hal_bool ah_hasHwPhyCounters;
+	bool ah_hasHwPhyCounters;
 	u_int32_t ah_aniPeriod;
 	struct ar5416AniState *ah_curani;
 	struct ar5416AniState ah_ani[255];
@@ -792,7 +792,7 @@ struct ath_hal_5416 {
 	int ah_firpwr[5];
 	u_int16_t ah_ratesArray[16];
 	u_int32_t ah_intrTxqs;
-	enum hal_bool ah_intrMitigation;
+	bool ah_intrMitigation;
 	u_int32_t ah_cycleCount;
 	u_int32_t ah_ctlBusy;
 	u_int32_t ah_extBusy;
@@ -899,8 +899,8 @@ struct ath_hal_5416 {
 #define HAL_ANI_CCK_TRIG_HIGH           200
 #define HAL_ANI_CCK_TRIG_LOW            100
 #define HAL_ANI_NOISE_IMMUNE_LVL        4
-#define HAL_ANI_USE_OFDM_WEAK_SIG       AH_TRUE
-#define HAL_ANI_CCK_WEAK_SIG_THR        AH_FALSE
+#define HAL_ANI_USE_OFDM_WEAK_SIG       true
+#define HAL_ANI_CCK_WEAK_SIG_THR        false
 #define HAL_ANI_SPUR_IMMUNE_LVL         7
 #define HAL_ANI_FIRSTEP_LVL             0
 #define HAL_ANI_RSSI_THR_HIGH           40
diff --git a/drivers/net/wireless/ath9k/phy.c b/drivers/net/wireless/ath9k/phy.c
index 8baecf1..37af73e 100644
--- a/drivers/net/wireless/ath9k/phy.c
+++ b/drivers/net/wireless/ath9k/phy.c
@@ -28,7 +28,7 @@ ath9k_hw_write_regs(struct ath_hal *ah, u_int modesIndex, u_int freqIndex,
 	REG_WRITE_ARRAY(&ahp->ah_iniBB_RfGain, freqIndex, regWrites);
 }
 
-enum hal_bool
+bool
 ath9k_hw_set_channel(struct ath_hal *ah, struct hal_channel_internal *chan)
 {
 	u_int32_t channelSel = 0;
@@ -54,7 +54,7 @@ ath9k_hw_set_channel(struct ath_hal *ah, struct hal_channel_internal *chan)
 			HDPRINTF(ah, HAL_DBG_CHANNEL,
 				 "%s: invalid channel %u MHz\n", __func__,
 				 freq);
-			return AH_FALSE;
+			return false;
 		}
 
 		channelSel = (channelSel << 2) & 0xff;
@@ -87,7 +87,7 @@ ath9k_hw_set_channel(struct ath_hal *ah, struct hal_channel_internal *chan)
 	} else {
 		HDPRINTF(ah, HAL_DBG_CHANNEL,
 			 "%s: invalid channel %u MHz\n", __func__, freq);
-		return AH_FALSE;
+		return false;
 	}
 
 	reg32 =
@@ -100,10 +100,10 @@ ath9k_hw_set_channel(struct ath_hal *ah, struct hal_channel_internal *chan)
 
 	AH5416(ah)->ah_curchanRadIndex = -1;
 
-	return AH_TRUE;
+	return true;
 }
 
-enum hal_bool
+bool
 ath9k_hw_ar9280_set_channel(struct ath_hal *ah,
 			    struct hal_channel_internal *chan)
 {
@@ -171,7 +171,7 @@ ath9k_hw_ar9280_set_channel(struct ath_hal *ah,
 
 	AH5416(ah)->ah_curchanRadIndex = -1;
 
-	return AH_TRUE;
+	return true;
 }
 
 static void
@@ -201,7 +201,7 @@ ath9k_phy_modify_rx_buffer(u_int32_t *rfBuf, u_int32_t reg32,
 	}
 }
 
-enum hal_bool
+bool
 ath9k_hw_set_rf_regs(struct ath_hal *ah, struct hal_channel_internal *chan,
 		     u_int16_t modesIndex)
 {
@@ -213,7 +213,7 @@ ath9k_hw_set_rf_regs(struct ath_hal *ah, struct hal_channel_internal *chan,
 	int regWrites = 0;
 
 	if (AR_SREV_9280_10_OR_LATER(ah))
-		return AH_TRUE;
+		return true;
 
 	eepMinorRev = ath9k_hw_get_eeprom(ahp, EEP_MINOR_REV);
 
@@ -266,7 +266,7 @@ ath9k_hw_set_rf_regs(struct ath_hal *ah, struct hal_channel_internal *chan,
 	REG_WRITE_RF_ARRAY(&ahp->ah_iniBank7, ahp->ah_analogBank7Data,
 			   regWrites);
 
-	return AH_TRUE;
+	return true;
 }
 
 void
@@ -312,11 +312,11 @@ ath9k_hw_rfdetach(struct ath_hal *ah)
 	}
 }
 
-enum hal_bool
+bool
 ath9k_hw_get_chip_power_limits(struct ath_hal *ah,
 			       struct hal_channel *chans, u_int32_t nchans)
 {
-	enum hal_bool retVal = AH_TRUE;
+	bool retVal = true;
 	int i;
 
 	for (i = 0; i < nchans; i++) {
@@ -327,7 +327,7 @@ ath9k_hw_get_chip_power_limits(struct ath_hal *ah,
 }
 
 
-enum hal_bool ath9k_hw_init_rf(struct ath_hal *ah, enum hal_status *status)
+bool ath9k_hw_init_rf(struct ath_hal *ah, enum hal_status *status)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
@@ -366,7 +366,7 @@ enum hal_bool ath9k_hw_init_rf(struct ath_hal *ah, enum hal_status *status)
 				 "%s: cannot allocate RF banks\n",
 				 __func__);
 			*status = HAL_ENOMEM;
-			return AH_FALSE;
+			return false;
 		}
 
 		ahp->ah_addac5416_21 =
@@ -378,7 +378,7 @@ enum hal_bool ath9k_hw_init_rf(struct ath_hal *ah, enum hal_status *status)
 				 "%s: cannot allocate ah_addac5416_21\n",
 				 __func__);
 			*status = HAL_ENOMEM;
-			return AH_FALSE;
+			return false;
 		}
 
 		ahp->ah_bank6Temp =
@@ -389,11 +389,11 @@ enum hal_bool ath9k_hw_init_rf(struct ath_hal *ah, enum hal_status *status)
 				 "%s: cannot allocate ah_bank6Temp\n",
 				 __func__);
 			*status = HAL_ENOMEM;
-			return AH_FALSE;
+			return false;
 		}
 	}
 
-	return AH_TRUE;
+	return true;
 }
 
 void
diff --git a/drivers/net/wireless/ath9k/phy.h b/drivers/net/wireless/ath9k/phy.h
index 6481944..9b75467 100644
--- a/drivers/net/wireless/ath9k/phy.h
+++ b/drivers/net/wireless/ath9k/phy.h
@@ -17,19 +17,19 @@
 #ifndef PHY_H
 #define PHY_H
 
-enum hal_bool ath9k_hw_ar9280_set_channel(struct ath_hal *ah,
+bool ath9k_hw_ar9280_set_channel(struct ath_hal *ah,
 					  struct hal_channel_internal
 					  *chan);
-enum hal_bool ath9k_hw_set_channel(struct ath_hal *ah,
+bool ath9k_hw_set_channel(struct ath_hal *ah,
 				   struct hal_channel_internal *chan);
 void ath9k_hw_write_regs(struct ath_hal *ah, u_int modesIndex,
 			 u_int freqIndex, int regWrites);
-enum hal_bool ath9k_hw_set_rf_regs(struct ath_hal *ah,
+bool ath9k_hw_set_rf_regs(struct ath_hal *ah,
 				   struct hal_channel_internal *chan,
 				   u_int16_t modesIndex);
 void ath9k_hw_decrease_chain_power(struct ath_hal *ah,
 				   struct hal_channel *chan);
-enum hal_bool ath9k_hw_init_rf(struct ath_hal *ah,
+bool ath9k_hw_init_rf(struct ath_hal *ah,
 			       enum hal_status *status);
 
 #define AR_PHY_BASE     0x9800
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index 1114c32..3c2b1cb 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -1974,8 +1974,8 @@ static void ath_get_rate(void *priv, struct net_device *dev,
 			  ATH_RC_PROBE_ALLOWED,
 			  tx_info_priv->rcs,
 			  &is_probe,
-			  AH_FALSE);
-	if (is_probe == AH_TRUE)
+			  false);
+	if (is_probe)
 		sel->probe_idx = ((struct ath_tx_ratectrl *)
 			sta->rate_ctrl_priv)->probe_rate;
 
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 372c893..4b724c1 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -728,11 +728,11 @@ start_recv:
 
 /* Disable the receive h/w in preparation for a reset. */
 
-enum hal_bool ath_stoprecv(struct ath_softc *sc)
+bool ath_stoprecv(struct ath_softc *sc)
 {
 	struct ath_hal *ah = sc->sc_ah;
 	u_int64_t tsf;
-	enum hal_bool stopped;
+	bool stopped;
 
 	ath9k_hw_stoppcurecv(ah);	/* disable PCU */
 	ath9k_hw_setrxfilter(ah, 0);	/* clear recv filter */
diff --git a/drivers/net/wireless/ath9k/regd.c b/drivers/net/wireless/ath9k/regd.c
index 519cae8..d2ab67f 100644
--- a/drivers/net/wireless/ath9k/regd.c
+++ b/drivers/net/wireless/ath9k/regd.c
@@ -50,18 +50,18 @@ static u_int16_t ath9k_regd_get_eepromRD(struct ath_hal *ah)
 	return ah->ah_currentRD & ~WORLDWIDE_ROAMING_FLAG;
 }
 
-static enum hal_bool ath9k_regd_is_chan_bm_zero(u_int64_t *bitmask)
+static bool ath9k_regd_is_chan_bm_zero(u_int64_t *bitmask)
 {
 	int i;
 
 	for (i = 0; i < BMLEN; i++) {
 		if (bitmask[i] != 0)
-			return AH_FALSE;
+			return false;
 	}
-	return AH_TRUE;
+	return true;
 }
 
-static enum hal_bool ath9k_regd_is_eeprom_valid(struct ath_hal *ah)
+static bool ath9k_regd_is_eeprom_valid(struct ath_hal *ah)
 {
 	u_int16_t rd = ath9k_regd_get_eepromRD(ah);
 	int i;
@@ -70,42 +70,41 @@ static enum hal_bool ath9k_regd_is_eeprom_valid(struct ath_hal *ah)
 		u_int16_t cc = rd & ~COUNTRY_ERD_FLAG;
 		for (i = 0; i < ARRAY_SIZE(allCountries); i++)
 			if (allCountries[i].countryCode == cc)
-				return AH_TRUE;
+				return true;
 	} else {
 		for (i = 0; i < ARRAY_SIZE(regDomainPairs); i++)
 			if (regDomainPairs[i].regDmnEnum == rd)
-				return AH_TRUE;
+				return true;
 	}
 	HDPRINTF(ah, HAL_DBG_REGULATORY,
 		 "%s: invalid regulatory domain/country code 0x%x\n",
 		 __func__, rd);
-	return AH_FALSE;
+	return false;
 }
 
-static enum hal_bool ath9k_regd_is_fcc_midband_supported(struct ath_hal
-							 *ah)
+static bool ath9k_regd_is_fcc_midband_supported(struct ath_hal *ah)
 {
 	u_int32_t regcap;
 
 	regcap = ah->ah_caps.halRegCap;
 
 	if (regcap & AR_EEPROM_EEREGCAP_EN_FCC_MIDBAND)
-		return AH_TRUE;
+		return true;
 	else
-		return AH_FALSE;
+		return false;
 }
 
-static enum hal_bool ath9k_regd_is_ccode_valid(struct ath_hal *ah,
-					       u_int16_t cc)
+static bool ath9k_regd_is_ccode_valid(struct ath_hal *ah,
+				      u_int16_t cc)
 {
 	u_int16_t rd;
 	int i;
 
 	if (cc == CTRY_DEFAULT)
-		return AH_TRUE;
+		return true;
 #ifdef AH_DEBUG_COUNTRY
 	if (cc == CTRY_DEBUG)
-		return AH_TRUE;
+		return true;
 #endif
 	rd = ath9k_regd_get_eepromRD(ah);
 	HDPRINTF(ah, HAL_DBG_REGULATORY, "%s: EEPROM regdomain 0x%x\n",
@@ -123,14 +122,14 @@ static enum hal_bool ath9k_regd_is_ccode_valid(struct ath_hal *ah,
 		if (cc == allCountries[i].countryCode) {
 #ifdef AH_SUPPORT_11D
 			if ((rd & WORLD_SKU_MASK) == WORLD_SKU_PREFIX)
-				return AH_TRUE;
+				return true;
 #endif
 			if (allCountries[i].regDmnEnum == rd ||
 			    rd == DEBUG_REG_DMN || rd == NO_ENUMRD)
-				return AH_TRUE;
+				return true;
 		}
 	}
-	return AH_FALSE;
+	return false;
 }
 
 static u_int
@@ -175,7 +174,7 @@ ath9k_regd_get_wmodes_nreg(struct ath_hal *ah,
 	return modesAvail;
 }
 
-enum hal_bool ath9k_regd_is_public_safety_sku(struct ath_hal *ah)
+bool ath9k_regd_is_public_safety_sku(struct ath_hal *ah)
 {
 	u_int16_t rd;
 
@@ -184,14 +183,14 @@ enum hal_bool ath9k_regd_is_public_safety_sku(struct ath_hal *ah)
 	switch (rd) {
 	case FCC4_FCCA:
 	case (CTRY_UNITED_STATES_FCC49 | COUNTRY_ERD_FLAG):
-		return AH_TRUE;
+		return true;
 	case DEBUG_REG_DMN:
 	case NO_ENUMRD:
 		if (ah->ah_countryCode == CTRY_UNITED_STATES_FCC49)
-			return AH_TRUE;
+			return true;
 		break;
 	}
-	return AH_FALSE;
+	return false;
 }
 
 static struct country_code_to_enum_rd *ath9k_regd_find_country(u_int16_t
@@ -231,8 +230,8 @@ static u_int16_t ath9k_regd_get_default_country(struct ath_hal *ah)
 	return CTRY_DEFAULT;
 }
 
-static enum hal_bool ath9k_regd_is_valid_reg_domain(int regDmn,
-						    struct regDomain *rd)
+static bool ath9k_regd_is_valid_reg_domain(int regDmn,
+					   struct regDomain *rd)
 {
 	int i;
 
@@ -242,26 +241,26 @@ static enum hal_bool ath9k_regd_is_valid_reg_domain(int regDmn,
 				memcpy(rd, &regDomains[i],
 				       sizeof(struct regDomain));
 			}
-			return AH_TRUE;
+			return true;
 		}
 	}
-	return AH_FALSE;
+	return false;
 }
 
-static enum hal_bool ath9k_regd_is_valid_reg_domainPair(int regDmnPair)
+static bool ath9k_regd_is_valid_reg_domainPair(int regDmnPair)
 {
 	int i;
 
 	if (regDmnPair == NO_ENUMRD)
-		return AH_FALSE;
+		return false;
 	for (i = 0; i < ARRAY_SIZE(regDomainPairs); i++) {
 		if (regDomainPairs[i].regDmnEnum == regDmnPair)
-			return AH_TRUE;
+			return true;
 	}
-	return AH_FALSE;
+	return false;
 }
 
-static enum hal_bool
+static bool
 ath9k_regd_get_wmode_regdomain(struct ath_hal *ah, int regDmn,
 			       u_int16_t channelFlag, struct regDomain *rd)
 {
@@ -296,7 +295,7 @@ ath9k_regd_get_wmode_regdomain(struct ath_hal *ah, int regDmn,
 			HDPRINTF(ah, HAL_DBG_REGULATORY,
 				 "%s: Failed to find reg domain pair %u\n",
 				 __func__, regDmn);
-			return AH_FALSE;
+			return false;
 		}
 		if (!(channelFlag & CHANNEL_2GHZ)) {
 			regDmn = regPair->regDmn5GHz;
@@ -313,7 +312,7 @@ ath9k_regd_get_wmode_regdomain(struct ath_hal *ah, int regDmn,
 		HDPRINTF(ah, HAL_DBG_REGULATORY,
 			 "%s: Failed to find unitary reg domain %u\n",
 			 __func__, regDmn);
-		return AH_FALSE;
+		return false;
 	} else {
 		rd->pscan &= regPair->pscanMask;
 		if (((regOrg & MULTI_DOMAIN_MASK) == 0) &&
@@ -323,11 +322,11 @@ ath9k_regd_get_wmode_regdomain(struct ath_hal *ah, int regDmn,
 
 		rd->flags &= (channelFlag & CHANNEL_2GHZ) ?
 		    REG_DOMAIN_2GHZ_MASK : REG_DOMAIN_5GHZ_MASK;
-		return AH_TRUE;
+		return true;
 	}
 }
 
-static enum hal_bool ath9k_regd_is_bit_set(int bit, u_int64_t *bitmask)
+static bool ath9k_regd_is_bit_set(int bit, u_int64_t *bitmask)
 {
 	int byteOffset, bitnum;
 	u_int64_t val;
@@ -336,9 +335,9 @@ static enum hal_bool ath9k_regd_is_bit_set(int bit, u_int64_t *bitmask)
 	bitnum = bit - byteOffset * 64;
 	val = ((u_int64_t) 1) << bitnum;
 	if (bitmask[byteOffset] & val)
-		return AH_TRUE;
+		return true;
 	else
-		return AH_FALSE;
+		return false;
 }
 
 static void
@@ -367,11 +366,11 @@ ath9k_regd_add_reg_classid(u_int8_t *regclassids, u_int maxregids,
 	return;
 }
 
-static enum hal_bool
+static bool
 ath9k_regd_get_eeprom_reg_ext_bits(struct ath_hal *ah,
 				   enum reg_ext_bitmap bit)
 {
-	return (ah->ah_currentRDExt & (1 << bit)) ? AH_TRUE : AH_FALSE;
+	return (ah->ah_currentRDExt & (1 << bit)) ? true : false;
 }
 
 #ifdef ATH_NF_PER_CHAN
@@ -397,13 +396,13 @@ static void ath9k_regd_init_rf_buffer(struct hal_channel_internal *ichans,
 }
 #endif
 
-enum hal_bool
+bool
 ath9k_regd_init_channels(struct ath_hal *ah,
 			 struct hal_channel *chans, u_int maxchans,
 			 u_int *nchans, u_int8_t *regclassids,
 			 u_int maxregids, u_int *nregids, u_int16_t cc,
-			 u_int32_t modeSelect, enum hal_bool enableOutdoor,
-			 enum hal_bool enableExtendedChannels)
+			 u_int32_t modeSelect, bool enableOutdoor,
+			 bool enableExtendedChannels)
 {
 	u_int modesAvail;
 	u_int16_t maxChan = 7000;
@@ -426,14 +425,14 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 
 		HDPRINTF(ah, HAL_DBG_REGULATORY,
 			 "%s: invalid country code %d\n", __func__, cc);
-		return AH_FALSE;
+		return false;
 	}
 
 	if (!ath9k_regd_is_eeprom_valid(ah)) {
 
 		HDPRINTF(ah, HAL_DBG_REGULATORY,
 			 "%s: invalid EEPROM contents\n", __func__);
-		return AH_FALSE;
+		return false;
 	}
 
 	ah->ah_countryCode = ath9k_regd_get_default_country(ah);
@@ -460,7 +459,7 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 			HDPRINTF(ah, HAL_DBG_REGULATORY,
 				 "Country is NULL!!!!, cc= %d\n",
 				 ah->ah_countryCode);
-			return AH_FALSE;
+			return false;
 		} else {
 			regdmn = country->regDmnEnum;
 #ifdef AH_SUPPORT_11D
@@ -487,7 +486,7 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 			"%s: couldn't find unitary "
 			"5GHz reg domain for country %u\n",
 			 __func__, ah->ah_countryCode);
-		return AH_FALSE;
+		return false;
 	}
 	if (!ath9k_regd_get_wmode_regdomain
 	    (ah, regdmn, CHANNEL_2GHZ, &rd2GHz)) {
@@ -495,7 +494,7 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 			"%s: couldn't find unitary 2GHz "
 			"reg domain for country %u\n",
 			 __func__, ah->ah_countryCode);
-		return AH_FALSE;
+		return false;
 	}
 
 	if (!isWwrSKU(ah)
@@ -509,7 +508,7 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 					"%s: couldn't find unitary 5GHz "
 					"reg domain for country %u\n",
 					 __func__, ah->ah_countryCode);
-				return AH_FALSE;
+				return false;
 			}
 		}
 	}
@@ -1062,9 +1061,9 @@ void ath9k_regd_get_current_country(struct ath_hal *ah,
 {
 	u_int16_t rd = ath9k_regd_get_eepromRD(ah);
 
-	ctry->isMultidomain = AH_FALSE;
+	ctry->isMultidomain = false;
 	if (rd == CTRY_DEFAULT)
-		ctry->isMultidomain = AH_TRUE;
+		ctry->isMultidomain = true;
 	else if (!(rd & COUNTRY_ERD_FLAG))
 		ctry->isMultidomain = isWwrSKU(ah);
 
diff --git a/drivers/net/wireless/ath9k/regd.h b/drivers/net/wireless/ath9k/regd.h
index 8546117..6d6c89f 100644
--- a/drivers/net/wireless/ath9k/regd.h
+++ b/drivers/net/wireless/ath9k/regd.h
@@ -124,7 +124,7 @@
 	(((_mode == ATH9K_MODE_SEL_11NA_HT40PLUS  || \
 	_mode == ATH9K_MODE_SEL_11NG_HT40PLUS    || \
 	_mode == ATH9K_MODE_SEL_11NA_HT40MINUS   || \
-	_mode == ATH9K_MODE_SEL_11NG_HT40MINUS) ? AH_TRUE : AH_FALSE))
+	_mode == ATH9K_MODE_SEL_11NG_HT40MINUS) ? true : false))
 
 #define CHAN_FLAGS      (CHANNEL_ALL|CHANNEL_HALF|CHANNEL_QUARTER)
 
@@ -172,13 +172,13 @@ struct country_code_to_enum_rd {
 	u_int16_t regDmnEnum;
 	const char *isoName;
 	const char *name;
-	enum hal_bool allow11g;
-	enum hal_bool allow11aTurbo;
-	enum hal_bool allow11gTurbo;
-	enum hal_bool allow11ng20;
-	enum hal_bool allow11ng40;
-	enum hal_bool allow11na20;
-	enum hal_bool allow11na40;
+	bool allow11g;
+	bool allow11aTurbo;
+	bool allow11gTurbo;
+	bool allow11ng20;
+	bool allow11ng40;
+	bool allow11na20;
+	bool allow11na40;
 	u_int16_t outdoorChanStart;
 };
 
@@ -213,8 +213,8 @@ struct cmode {
 	u_int32_t flags;
 };
 
-#define YES AH_TRUE
-#define NO  AH_FALSE
+#define YES true
+#define NO  false
 
 struct japan_bandcheck {
 	u_int16_t freqbandbit;
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 71c2e77..4f46517 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -558,7 +558,7 @@ static void ath_tx_queue_tid(struct ath_txq *txq, struct ath_atx_tid *tid)
 	if (tid->sched)
 		return;
 
-	tid->sched = AH_TRUE;
+	tid->sched = true;
 	list_add_tail(&tid->list, &ac->tid_q);
 
 	/*
@@ -567,7 +567,7 @@ static void ath_tx_queue_tid(struct ath_txq *txq, struct ath_atx_tid *tid)
 	if (ac->sched)
 		return;
 
-	ac->sched = AH_TRUE;
+	ac->sched = true;
 	list_add_tail(&ac->list, &txq->axq_acq);
 }
 
@@ -690,7 +690,7 @@ static u_int32_t ath_pkt_duration(struct ath_softc *sc,
 				  struct ath_buf *bf,
 				  int width,
 				  int half_gi,
-				  enum hal_bool shortPreamble)
+				  bool shortPreamble)
 {
 	const struct hal_rate_table *rt = sc->sc_currates;
 	u_int32_t nbits, nsymbits, duration, nsymbols;
@@ -1218,7 +1218,7 @@ static void ath_tx_complete_aggr_rifs(struct ath_softc *sc,
 			tid->addba_exchangeattempts = 0;
 			spin_unlock_bh(&txq->axq_lock);
 
-			tid->cleanup_inprogress = AH_FALSE;
+			tid->cleanup_inprogress = false;
 
 			/* send buffered frames as singles */
 			ath_tx_flush_tid(sc, tid);
@@ -1424,7 +1424,7 @@ static void ath_tx_stopdma(struct ath_softc *sc, struct ath_txq *txq)
 
 /* Drain only the data queues */
 
-static void ath_drain_txdataq(struct ath_softc *sc, enum hal_bool retry_tx)
+static void ath_drain_txdataq(struct ath_softc *sc, bool retry_tx)
 {
 	struct ath_hal *ah = sc->sc_ah;
 	int i;
@@ -1456,7 +1456,7 @@ static void ath_drain_txdataq(struct ath_softc *sc, enum hal_bool retry_tx)
 		if (!ath9k_hw_reset(ah, sc->sc_opmode,
 			&sc->sc_curchan, ht_macmode,
 			sc->sc_tx_chainmask, sc->sc_rx_chainmask,
-			sc->sc_ht_extprotspacing, AH_TRUE, &status)) {
+			sc->sc_ht_extprotspacing, true, &status)) {
 
 			DPRINTF(sc, ATH_DEBUG_FATAL,
 				"%s: unable to reset hardware; hal status %u\n",
@@ -1969,10 +1969,10 @@ static void ath_txq_drain_pending_buffers(struct ath_softc *sc,
 
 	list_for_each_entry_safe(ac, ac_tmp, &txq->axq_acq, list) {
 		list_del(&ac->list);
-		ac->sched = AH_FALSE;
+		ac->sched = false;
 		list_for_each_entry_safe(tid, tid_tmp, &ac->tid_q, list) {
 			list_del(&tid->list);
-			tid->sched = AH_FALSE;
+			tid->sched = false;
 			ath_tid_drain(sc, txq, tid, bh_flag);
 		}
 	}
@@ -2054,8 +2054,8 @@ static int ath_tx_start_dma(struct ath_softc *sc,
 	ath9k_hw_filltxdesc(ah,
 			    ds,
 			    sg_dma_len(sg),     /* segment length */
-			    AH_TRUE,            /* first segment */
-			    (n_sg == 1) ? AH_TRUE : AH_FALSE, /* last segment */
+			    true,            /* first segment */
+			    (n_sg == 1) ? true : false, /* last segment */
 			    ds);                /* first descriptor */
 
 	bf->bf_lastfrm = bf;
@@ -2440,7 +2440,7 @@ void ath_tx_tasklet(struct ath_softc *sc)
 }
 
 void ath_tx_draintxq(struct ath_softc *sc,
-	struct ath_txq *txq, enum hal_bool retry_tx)
+	struct ath_txq *txq, bool retry_tx)
 {
 	struct ath_buf *bf, *lastbf;
 	struct list_head bf_head;
@@ -2503,7 +2503,7 @@ void ath_tx_draintxq(struct ath_softc *sc,
 
 /* Drain the transmit queues and reclaim resources */
 
-void ath_draintxq(struct ath_softc *sc, enum hal_bool retry_tx)
+void ath_draintxq(struct ath_softc *sc, bool retry_tx)
 {
 	/* stop beacon queue. The beacon will be freed when
 	 * we go to INIT state */
@@ -2663,7 +2663,7 @@ void ath_tx_aggr_teardown(struct ath_softc *sc,
 
 	if (txtid->baw_head != txtid->baw_tail) {
 		spin_unlock_bh(&txq->axq_lock);
-		txtid->cleanup_inprogress = AH_TRUE;
+		txtid->cleanup_inprogress = true;
 	} else {
 		txtid->addba_exchangecomplete = 0;
 		txtid->addba_exchangeattempts = 0;
@@ -2690,7 +2690,7 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 	 */
 	ac = list_first_entry(&txq->axq_acq, struct ath_atx_ac, list);
 	list_del(&ac->list);
-	ac->sched = AH_FALSE;
+	ac->sched = false;
 
 	/*
 	 * process a single tid per destination
@@ -2702,7 +2702,7 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 
 		tid = list_first_entry(&ac->tid_q, struct ath_atx_tid, list);
 		list_del(&tid->list);
-		tid->sched = AH_FALSE;
+		tid->sched = false;
 
 		if (tid->paused)    /* check next tid to keep h/w busy */
 			continue;
@@ -2730,8 +2730,8 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 		/*
 		 * add dest ac to txq if not already added
 		 */
-		if (ac->sched == AH_FALSE) {
-			ac->sched = AH_TRUE;
+		if (!ac->sched) {
+			ac->sched = true;
 			list_add_tail(&ac->list, &txq->axq_acq);
 		}
 	}
@@ -2759,9 +2759,9 @@ void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 			tid->seq_start = tid->seq_next = 0;
 			tid->baw_size  = WME_MAX_BA;
 			tid->baw_head  = tid->baw_tail = 0;
-			tid->sched     = AH_FALSE;
-			tid->paused = AH_FALSE;
-			tid->cleanup_inprogress = AH_FALSE;
+			tid->sched     = false;
+			tid->paused = false;
+			tid->cleanup_inprogress = false;
 			INIT_LIST_HEAD(&tid->buf_q);
 
 			acno = TID_TO_WME_AC(tidno);
@@ -2778,7 +2778,7 @@ void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 		 */
 		for (acno = 0, ac = &an->an_aggr.tx.ac[acno];
 				acno < WME_NUM_AC; acno++, ac++) {
-			ac->sched    = AH_FALSE;
+			ac->sched    = false;
 			INIT_LIST_HEAD(&ac->tid_q);
 
 			switch (acno) {
@@ -2828,16 +2828,16 @@ void ath_tx_node_cleanup(struct ath_softc *sc,
 				if (tid && tid->an != an)
 					continue;
 				list_del(&ac->list);
-				ac->sched = AH_FALSE;
+				ac->sched = false;
 
 				list_for_each_entry_safe(tid,
 						tid_tmp, &ac->tid_q, list) {
 					list_del(&tid->list);
-					tid->sched = AH_FALSE;
+					tid->sched = false;
 					ath_tid_drain(sc, txq, tid, bh_flag);
 					tid->addba_exchangecomplete = 0;
 					tid->addba_exchangeattempts = 0;
-					tid->cleanup_inprogress = AH_FALSE;
+					tid->cleanup_inprogress = false;
 				}
 			}
 
-- 
1.5.4.3

