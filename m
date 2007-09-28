Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.232]:9289 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757607AbXI1BDE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2007 21:03:04 -0400
Received: by wx-out-0506.google.com with SMTP id h31so2268602wxd
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2007 18:03:02 -0700 (PDT)
Date: Thu, 27 Sep 2007 21:04:19 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH] ath5k: add new configure_filter, compile fix on  wireless-2.6
Message-ID: <20070928010419.GA26497@pogo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch:

* removes the old ath_calcrxfilter() and ath_set_multicast_list()
* adds new required required configure_filter() ops, this one
  just stores the filter value in cache for later use.
* introduces a cached sc->filter_flags for hw filter flags
* moves the driver to mac80211's new required start()/stop()
* initializes at add_interface() sc->bintval to a common value,
  this will later be updated as per mac80211's preference.
* Fix compile bug on ath_set_key() (adds enum for set_key_cmd)

We'll later port some driver-specific filter stuff onto mac80211.

This has been tested. This patch applies to the wireless-2.6 everything branch,
after the new ath5k directory move and file renames.

Changes-licensed-under: 3-clause-BSD
Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>

---

 drivers/net/wireless/ath5k/base.c |  149 +++++++++++++++++++++---------------
 drivers/net/wireless/ath5k/base.h |    4 +
 2 files changed, 91 insertions(+), 62 deletions(-)


diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 6e326ac..a1f2034 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2004-2005 Atheros Communications, Inc.
  * Copyright (c) 2006 Devicescape Software, Inc.
  * Copyright (c) 2007 Jiri Slaby <jirislaby@gmail.com>
+ * Copyright (c) 2007 Luis R. Rodriguez <mcgrof@gmail.com>
  *
  * All rights reserved.
  *
@@ -706,61 +707,13 @@ static void ath_beacon_config(struct ath_softc *sc)
 #undef TSF_TO_TU
 }
 
-/*
- * Calculate the receive filter according to the
- * operating mode and state:
- *
- * o always accept unicast, broadcast, and multicast traffic
- * o maintain current state of phy error reception (the hal
- *   may enable phy error frames for noise immunity work)
- * o probe request frames are accepted only when operating in
- *   hostap, adhoc, or monitor modes
- * o enable promiscuous mode according to the interface state
- * o accept beacons:
- *   - when operating in adhoc mode so the 802.11 layer creates
- *     node table entries for peers,
- *   - when operating in station mode for collecting rssi data when
- *     the station is otherwise quiet, or
- *   - when scanning
- * o accept any additional packets specified by sc_rxfilter
- */
-static u32 ath_calcrxfilter(struct ath_softc *sc)
-{
-	struct ath_hw *ah = sc->ah;
-	unsigned int opmode = sc->opmode;
-	u32 rfilt;
-
-	rfilt = (ath5k_hw_get_rx_filter(ah) & AR5K_RX_FILTER_PHYERR) |
-		AR5K_RX_FILTER_UCAST | AR5K_RX_FILTER_BCAST |
-		AR5K_RX_FILTER_MCAST | AR5K_RX_FILTER_RADARERR;
-
-	if (opmode == IEEE80211_IF_TYPE_MNTR)
-		rfilt |= AR5K_RX_FILTER_CONTROL | AR5K_RX_FILTER_BEACON |
-			AR5K_RX_FILTER_PROBEREQ | AR5K_RX_FILTER_PROM;
-	if (opmode != IEEE80211_IF_TYPE_STA)
-		rfilt |= AR5K_RX_FILTER_PROBEREQ;
-	if (opmode != IEEE80211_IF_TYPE_AP && test_bit(ATH_STAT_PROMISC,
-				sc->status))
-		rfilt |= AR5K_RX_FILTER_PROM;
-	if (opmode == IEEE80211_IF_TYPE_STA || opmode == IEEE80211_IF_TYPE_IBSS) {
-		rfilt |= AR5K_RX_FILTER_BEACON;
-		/* Note: AR5212 requires AR5K_RX_FILTER_PROM to receive broadcasts,
-		 * perhaps the flags are off, for now to be safe we'll enable it for
-		 * STA and ADHOC until we have this properly mapped */
-		if (ah->ah_version == AR5K_AR5212)
-			rfilt |= AR5K_RX_FILTER_PROM;
-	}
-
-	return rfilt;
-}
-
 static void ath_mode_init(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->ah;
 	u32 rfilt;
 
 	/* configure rx filter */
-	rfilt = ath_calcrxfilter(sc);
+	rfilt = sc->filter_flags;
 	ath5k_hw_set_rx_filter(ah, rfilt);
 
 	if (ath5k_hw_hasbssidmask(ah))
@@ -1334,14 +1287,14 @@ err:
 	return ret;
 }
 
-static int ath_open(struct ieee80211_hw *hw)
+static int ath_start(struct ieee80211_hw *hw)
 {
 	return ath_init(hw->priv);
 }
 
-static int ath_stop(struct ieee80211_hw *hw)
+void ath_stop(struct ieee80211_hw *hw)
 {
-	return ath_stop_hw(hw->priv);
+	ath_stop_hw(hw->priv);
 }
 
 static int ath_add_interface(struct ieee80211_hw *hw,
@@ -1404,6 +1357,9 @@ static int ath_config_interface(struct ieee80211_hw *hw, int if_id,
 	struct ath_softc *sc = hw->priv;
 	int ret;
 
+	/* Set to a reasonable value. Note that this will
+	 * be set to mac80211's value at ath_config(). */
+	sc->bintval = 1000 * 1000 / 1024;
 	mutex_lock(&sc->lock);
 	if (sc->iface_id != if_id) {
 		ret = -EIO;
@@ -1419,24 +1375,93 @@ unlock:
 	return ret;
 }
 
-static void ath_set_multicast_list(struct ieee80211_hw *hw,
-		unsigned short flags, int mc_count)
+#define SUPPORTED_FIF_FLAGS \
+	FIF_PROMISC_IN_BSS |  FIF_ALLMULTI | FIF_FCSFAIL | \
+	FIF_PLCPFAIL | FIF_CONTROL | FIF_OTHER_BSS | \
+	FIF_BCN_PRBRESP_PROMISC
+/*
+ * o always accept unicast, broadcast, and multicast traffic
+ * o maintain current state of phy error reception (the hal
+ *   may enable phy error frames for noise immunity work)
+ * o probe request frames are accepted only when operating in
+ *   hostap, adhoc, or monitor modes
+ * o enable promiscuous mode according to the interface state
+ * o accept beacons:
+ *   - when operating in adhoc mode so the 802.11 layer creates
+ *     node table entries for peers,
+ *   - when operating in station mode for collecting rssi data when
+ *     the station is otherwise quiet, or
+ *   - when scanning
+ */
+static void ath_configure_filter(struct ieee80211_hw *hw,
+               unsigned int changed_flags,
+               unsigned int *new_flags,
+               int mc_count, struct dev_mc_list *mclist)
 {
 	struct ath_softc *sc = hw->priv;
-	unsigned int prom = !!(flags & IFF_PROMISC);
+	struct ath_hw *ah = sc->ah;
 	u32 rfilt;
 
-	if (test_bit(ATH_STAT_PROMISC, sc->status) != prom) {
-		if (prom)
+	/* Only deal with supported flags */
+	changed_flags &= SUPPORTED_FIF_FLAGS;
+	*new_flags &= SUPPORTED_FIF_FLAGS;
+
+	/* XXX: Start by enabling broadcasts and Unicast, move this later 
+	 * to mac802111 and add a flag for these */
+	rfilt = AR5K_RX_FILTER_UCAST | AR5K_RX_FILTER_BCAST;
+
+	if (changed_flags & (FIF_PROMISC_IN_BSS | FIF_OTHER_BSS)) {
+		if (*new_flags & FIF_PROMISC_IN_BSS) {
+			rfilt |= AR5K_RX_FILTER_PROM;
 			__set_bit(ATH_STAT_PROMISC, sc->status);
+		}
 		else
 			__clear_bit(ATH_STAT_PROMISC, sc->status);
-		rfilt = ath_calcrxfilter(sc);
-		ath5k_hw_set_rx_filter(sc->ah, rfilt);
 	}
+
+	if (*new_flags & FIF_ALLMULTI)
+		rfilt |= AR5K_RX_FILTER_MCAST;
+	/* This is the best we can do */
+	if (*new_flags & (FIF_FCSFAIL | FIF_PLCPFAIL))
+		rfilt |= AR5K_RX_FILTER_PHYERR;
+	/* FIF_BCN_PRBRESP_PROMISC really means to enable beacons 
+	* and probes for any BSSID, this needs testing */
+	if (*new_flags & FIF_BCN_PRBRESP_PROMISC)
+		rfilt |= AR5K_RX_FILTER_BEACON | AR5K_RX_FILTER_PROBEREQ;
+	/* FIF_CONTROL doc says that FIF_PROMISC_IN_BSS is not set we should
+	* only pass on control frames for this station. This needs testing.
+	* I believe right now this enables *all* control frames */
+	if (*new_flags & FIF_CONTROL)
+		rfilt |= AR5K_RX_FILTER_CONTROL;
+
+	/* Additional settings per mode -- this is per ath5k */
+
+	/* XXX move these to mac80211, and add a beacon IFF flag to mac80211 */
+
+	if (sc->opmode == IEEE80211_IF_TYPE_MNTR)
+		rfilt |= AR5K_RX_FILTER_CONTROL | AR5K_RX_FILTER_BEACON |
+			AR5K_RX_FILTER_PROBEREQ | AR5K_RX_FILTER_PROM;
+	if (sc->opmode != IEEE80211_IF_TYPE_STA)
+		rfilt |= AR5K_RX_FILTER_PROBEREQ;
+	if (sc->opmode != IEEE80211_IF_TYPE_AP && 
+		test_bit(ATH_STAT_PROMISC, sc->status))
+		rfilt |= AR5K_RX_FILTER_PROM;
+	if (sc->opmode == IEEE80211_IF_TYPE_STA || 
+		sc->opmode == IEEE80211_IF_TYPE_IBSS) {
+		rfilt |= AR5K_RX_FILTER_BEACON;
+		/* Note: AR5212 requires AR5K_RX_FILTER_PROM to receive broadcasts, 
+		 * perhaps the flags are off, for now to be safe we'll enable it for
+		 * STA and ADHOC until we have this properly mapped */
+		if (ah->ah_version == AR5K_AR5212)
+			rfilt |= AR5K_RX_FILTER_PROM;
+	}
+
+	/* Set the cached hw filter flags, this will alter actually
+	 * be set in HW */
+	sc->filter_flags = rfilt;
 }
 
-static int ath_set_key(struct ieee80211_hw *hw, set_key_cmd cmd,
+static int ath_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		const u8 *local_addr, const u8 *addr,
 		struct ieee80211_key_conf *key)
 {
@@ -1544,13 +1569,13 @@ end:
 
 static struct ieee80211_ops ath_hw_ops = {
 	.tx = ath_tx,
-	.open = ath_open,
+	.start = ath_start,
 	.stop = ath_stop,
 	.add_interface = ath_add_interface,
 	.remove_interface = ath_remove_interface,
 	.config = ath_config,
 	.config_interface = ath_config_interface,
-	.set_multicast_list = ath_set_multicast_list,
+	.configure_filter = ath_configure_filter,
 	.set_key = ath_set_key,
 	.get_stats = ath_get_stats,
 	.conf_tx = NULL,
diff --git a/drivers/net/wireless/ath5k/base.h b/drivers/net/wireless/ath5k/base.h
index 15560ad..5888c9e 100644
--- a/drivers/net/wireless/ath5k/base.h
+++ b/drivers/net/wireless/ath5k/base.h
@@ -117,6 +117,9 @@ struct ath_txq {
 #define ATH_CHAN_MAX	(14+14+14+252+20)	/* XXX what's the max? */
 #endif
 
+
+/* Software Carrier, keeps track of the driver state
+ * associated with an instance of a device */
 struct ath_softc {
 	struct pci_dev		*pdev;		/* for dma mapping */
 	void __iomem		*iobase;	/* address of the device */
@@ -146,6 +149,7 @@ struct ath_softc {
 #define ATH_STAT_LEDENDBLINK	4		/* finish LED blink operation */
 #define ATH_STAT_LEDSOFT	5		/* enable LED gpio status */
 
+	unsigned int		filter_flags;	/* HW flags, AR5K_RX_FILTER_* */
 	unsigned int		curmode;	/* current phy mode */
 	struct ieee80211_channel *curchan;	/* current h/w channel */
 
