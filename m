Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:52546 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbYHKIon (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2008 04:44:43 -0400
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 11 Aug 2008 01:44:43 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18591.63817.351066.308723@localhost.localdomain> (sfid-20080811_104446_388660_606B230D)
Date: Mon, 11 Aug 2008 14:03:13 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<Jouni.Malinen@Atheros.com>, <Luis.Rodriguez@Atheros.com>
Subject: [PATCH 02/10] ath9k: RX Filter cleanup
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/core.c |   53 -------------------------------------
 drivers/net/wireless/ath9k/core.h |    5 ++-
 drivers/net/wireless/ath9k/main.c |   19 +++++++------
 drivers/net/wireless/ath9k/recv.c |   11 +++++--
 4 files changed, 21 insertions(+), 67 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index 10f2729..7f92d46 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -21,9 +21,6 @@
 
 static int ath_outdoor;		/* enable outdoor use */
 
-static const u8 ath_bcast_mac[ETH_ALEN] =
-    { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
-
 static u32 ath_chainmask_sel_up_rssi_thres =
 	ATH_CHAINMASK_SEL_UP_RSSI_THRES;
 static u32 ath_chainmask_sel_down_rssi_thres =
@@ -307,56 +304,6 @@ static int ath_stop(struct ath_softc *sc)
 }
 
 /*
- *  Start Scan
- *
- *  This function is called when starting a channel scan.  It will perform
- *  power save wakeup processing, set the filter for the scan, and get the
- *  chip ready to send broadcast packets out during the scan.
-*/
-
-void ath_scan_start(struct ath_softc *sc)
-{
-	struct ath_hal *ah = sc->sc_ah;
-	u32 rfilt;
-	u32 now = (u32) jiffies_to_msecs(get_timestamp());
-
-	sc->sc_scanning = 1;
-	rfilt = ath_calcrxfilter(sc);
-	ath9k_hw_setrxfilter(ah, rfilt);
-	ath9k_hw_write_associd(ah, ath_bcast_mac, 0);
-
-	/* Restore previous power management state. */
-
-	DPRINTF(sc, ATH_DBG_CONFIG, "%d.%03d | %s: RX filter 0x%x aid 0\n",
-		now / 1000, now % 1000, __func__, rfilt);
-}
-
-/*
- *  Scan End
- *
- *  This routine is called by the upper layer when the scan is completed.  This
- *  will set the filters back to normal operating mode, set the BSSID to the
- *  correct value, and restore the power save state.
-*/
-
-void ath_scan_end(struct ath_softc *sc)
-{
-	struct ath_hal *ah = sc->sc_ah;
-	u32 rfilt;
-	u32 now = (u32) jiffies_to_msecs(get_timestamp());
-
-	sc->sc_scanning = 0;
-	/* Request for a full reset due to rx packet filter changes */
-	sc->sc_full_reset = 1;
-	rfilt = ath_calcrxfilter(sc);
-	ath9k_hw_setrxfilter(ah, rfilt);
-	ath9k_hw_write_associd(ah, sc->sc_curbssid, sc->sc_curaid);
-
-	DPRINTF(sc, ATH_DBG_CONFIG, "%d.%03d | %s: RX filter 0x%x aid 0x%x\n",
-		now / 1000, now % 1000, __func__, rfilt, sc->sc_curaid);
-}
-
-/*
  * Set the current channel
  *
  * Set/change channels.  If the channel is really being changed, it's done
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index ef8f637..07c9588 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -95,6 +95,8 @@ static inline unsigned long get_timestamp(void)
 	return ((jiffies / HZ) * 1000) + (jiffies % HZ) * (1000 / HZ);
 }
 
+static const u8 ath_bcast_mac[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+
 /*************/
 /* Debugging */
 /*************/
@@ -919,10 +921,9 @@ struct ath_softc {
 	struct ath_rate_softc *sc_rc;	/* tx rate control support */
 	u32 sc_intrstatus;
 	enum ath9k_opmode sc_opmode;	/* current operating mode */
-
+	unsigned int rx_filter;
 	u8 sc_invalid;			/* being detached */
 	u8 sc_beacons;			/* beacons running */
-	u8 sc_scanning;			/* scanning active */
 	u8 sc_txaggr;			/* enable 11n tx aggregation */
 	u8 sc_rxaggr;			/* enable 11n rx aggregation */
 	u8 sc_update_chainmask;		/* change chain mask */
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 2888778..262fd7a 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -549,10 +549,6 @@ static int ath9k_config_interface(struct ieee80211_hw *hw,
 			/* Update ratectrl about the new state */
 			ath_rate_newstate(sc, avp);
 
-			/* Set rx filter */
-			rfilt = ath_calcrxfilter(sc);
-			ath9k_hw_setrxfilter(sc->sc_ah, rfilt);
-
 			/* Set BSSID */
 			memcpy(sc->sc_curbssid, conf->bssid, ETH_ALEN);
 			sc->sc_curaid = 0;
@@ -636,8 +632,7 @@ static int ath9k_config_interface(struct ieee80211_hw *hw,
 	FIF_BCN_PRBRESP_PROMISC |		\
 	FIF_FCSFAIL)
 
-/* Accept unicast, bcast and mcast frames */
-
+/* FIXME: sc->sc_full_reset ? */
 static void ath9k_configure_filter(struct ieee80211_hw *hw,
 				   unsigned int changed_flags,
 				   unsigned int *total_flags,
@@ -645,16 +640,22 @@ static void ath9k_configure_filter(struct ieee80211_hw *hw,
 				   struct dev_mc_list *mclist)
 {
 	struct ath_softc *sc = hw->priv;
+	u32 rfilt;
 
 	changed_flags &= SUPPORTED_FILTERS;
 	*total_flags &= SUPPORTED_FILTERS;
 
+	sc->rx_filter = *total_flags;
+	rfilt = ath_calcrxfilter(sc);
+	ath9k_hw_setrxfilter(sc->sc_ah, rfilt);
+
 	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
 		if (*total_flags & FIF_BCN_PRBRESP_PROMISC)
-			ath_scan_start(sc);
-		else
-			ath_scan_end(sc);
+			ath9k_hw_write_associd(sc->sc_ah, ath_bcast_mac, 0);
 	}
+
+	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Set HW RX filter: 0x%x\n",
+		__func__, sc->rx_filter);
 }
 
 static void ath9k_sta_notify(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 838b656..a125849 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -597,6 +597,7 @@ void ath_rx_cleanup(struct ath_softc *sc)
 u32 ath_calcrxfilter(struct ath_softc *sc)
 {
 #define	RX_FILTER_PRESERVE (ATH9K_RX_FILTER_PHYERR | ATH9K_RX_FILTER_PHYRADAR)
+
 	u32 rfilt;
 
 	rfilt = (ath9k_hw_getrxfilter(sc->sc_ah) & RX_FILTER_PRESERVE)
@@ -608,14 +609,17 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 		rfilt |= ATH9K_RX_FILTER_PROBEREQ;
 
 	/* Can't set HOSTAP into promiscous mode */
-	if (sc->sc_opmode == ATH9K_M_MONITOR) {
+	if (((sc->sc_opmode != ATH9K_M_HOSTAP) &&
+	     (sc->rx_filter & FIF_PROMISC_IN_BSS)) ||
+	    (sc->sc_opmode == ATH9K_M_MONITOR)) {
 		rfilt |= ATH9K_RX_FILTER_PROM;
 		/* ??? To prevent from sending ACK */
 		rfilt &= ~ATH9K_RX_FILTER_UCAST;
 	}
 
-	if (sc->sc_opmode == ATH9K_M_STA || sc->sc_opmode == ATH9K_M_IBSS ||
-	    sc->sc_scanning)
+	if (((sc->sc_opmode == ATH9K_M_STA) &&
+	     (sc->rx_filter & FIF_BCN_PRBRESP_PROMISC)) ||
+	    (sc->sc_opmode == ATH9K_M_IBSS))
 		rfilt |= ATH9K_RX_FILTER_BEACON;
 
 	/* If in HOSTAP mode, want to enable reception of PSPOLL frames
@@ -623,6 +627,7 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 	if (sc->sc_opmode == ATH9K_M_HOSTAP)
 		rfilt |= (ATH9K_RX_FILTER_BEACON | ATH9K_RX_FILTER_PSPOLL);
 	return rfilt;
+
 #undef RX_FILTER_PRESERVE
 }
 
-- 
1.5.6.5

