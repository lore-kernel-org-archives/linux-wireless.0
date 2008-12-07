Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:31399 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754206AbYLGQPV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Dec 2008 11:15:21 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 07 Dec 2008 08:15:21 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18747.62938.351479.781133@gargle.gargle.HOWL> (sfid-20081207_171524_740731_E4C25A3C)
Date: Sun, 7 Dec 2008 21:42:10 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 2/6] ath9k: Maintain rate table choice after association
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A scan run after association would change sc_curmode which is
used to get the current rate table. This patch fixes it
by removing sc_curmode and setting the rate table in usage in cur_rate_table
on association.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/beacon.c |    2 +-
 drivers/net/wireless/ath9k/core.h   |    1 -
 drivers/net/wireless/ath9k/main.c   |    3 ++-
 drivers/net/wireless/ath9k/rc.c     |    9 ++++-----
 drivers/net/wireless/ath9k/recv.c   |    2 +-
 drivers/net/wireless/ath9k/xmit.c   |    8 ++++----
 6 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index d874223..9e5c0c0 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -106,7 +106,7 @@ static void ath_beacon_setup(struct ath_softc *sc,
 	 * XXX everything at min xmit rate
 	 */
 	rix = 0;
-	rt = sc->hw_rate_table[sc->sc_curmode];
+	rt = sc->cur_rate_table;
 	rate = rt->info[rix].ratecode;
 	if (sc->sc_flags & SC_OP_PREAMBLE_SHORT)
 		rate |= rt->info[rix].short_preamble;
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 726d0a3..23844e0 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -646,7 +646,6 @@ struct ath_softc {
 	u8 sc_tx_chainmask;
 	u8 sc_rx_chainmask;
 	enum ath9k_int sc_imask;
-	enum wireless_mode sc_curmode;
 	enum PROT_MODE sc_protmode;
 
 	u8 sc_nbcnvaps;
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 08f2949..5c6a1b0 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -60,7 +60,8 @@ static void bus_read_cachesize(struct ath_softc *sc, int *csz)
 
 static void ath_setcurmode(struct ath_softc *sc, enum wireless_mode mode)
 {
-	sc->sc_curmode = mode;
+	if (!sc->sc_curaid)
+		sc->cur_rate_table = sc->hw_rate_table[mode];
 	/*
 	 * All protection frames are transmited at 2Mb/s for
 	 * 11g, otherwise at 1Mb/s.
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index 8eec667..0ae5988 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -874,9 +874,8 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 	 * So, set fourth rate in series to be same as third one for
 	 * above conditions.
 	 */
-	if ((sc->sc_curmode == ATH9K_MODE_11NG_HT20) ||
-	    (sc->sc_curmode == ATH9K_MODE_11NG_HT40PLUS) ||
-	    (sc->sc_curmode == ATH9K_MODE_11NG_HT40MINUS)) {
+	if ((sc->hw->conf.channel->band == IEEE80211_BAND_2GHZ) &&
+	    (sc->hw->conf.ht.enabled)) {
 		u8 dot11rate = rate_table->info[rix].dot11rate;
 		u8 phy = rate_table->info[rix].phy;
 		if (i == 4 &&
@@ -1354,8 +1353,8 @@ static void ath_rc_init(struct ath_softc *sc,
 						   sta->ht_cap.ht_supported,
 						   is_cw_40);
 	} else if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_AP) {
-		/* sc_curmode would be set on init through config() */
-		rate_table = sc->hw_rate_table[sc->sc_curmode];
+		/* cur_rate_table would be set on init through config() */
+		rate_table = sc->cur_rate_table;
 	}
 
 	if (!rate_table) {
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index ec7edac..8aa8614 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -147,7 +147,7 @@ static int ath_rx_prepare(struct sk_buff *skb, struct ath_desc *ds,
 			  struct ieee80211_rx_status *rx_status, bool *decrypt_error,
 			  struct ath_softc *sc)
 {
-	struct ath_rate_table *rate_table = sc->hw_rate_table[sc->sc_curmode];
+	struct ath_rate_table *rate_table = sc->cur_rate_table;
 	struct ieee80211_hdr *hdr;
 	int ratekbps, rix;
 	u8 ratecode;
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 9de27c6..353b7ed 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -493,7 +493,7 @@ static void ath_tx_update_baw(struct ath_softc *sc, struct ath_atx_tid *tid,
 static u32 ath_pkt_duration(struct ath_softc *sc, u8 rix, struct ath_buf *bf,
 			    int width, int half_gi, bool shortPreamble)
 {
-	struct ath_rate_table *rate_table = sc->hw_rate_table[sc->sc_curmode];
+	struct ath_rate_table *rate_table = sc->cur_rate_table;
 	u32 nbits, nsymbits, duration, nsymbols;
 	u8 rc;
 	int streams, pktlen;
@@ -557,7 +557,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 	}
 
 	/* get the cix for the lowest valid rix */
-	rt = sc->hw_rate_table[sc->sc_curmode];
+	rt = sc->cur_rate_table;
 	for (i = 3; i >= 0; i--) {
 		if (rates[i].count && (rates[i].idx >= 0)) {
 			rix = rates[i].idx;
@@ -1240,7 +1240,7 @@ static u32 ath_lookup_rate(struct ath_softc *sc,
 			   struct ath_buf *bf,
 			   struct ath_atx_tid *tid)
 {
-	struct ath_rate_table *rate_table = sc->hw_rate_table[sc->sc_curmode];
+	struct ath_rate_table *rate_table = sc->cur_rate_table;
 	struct sk_buff *skb;
 	struct ieee80211_tx_info *tx_info;
 	struct ieee80211_tx_rate *rates;
@@ -1308,7 +1308,7 @@ static int ath_compute_num_delims(struct ath_softc *sc,
 				  struct ath_buf *bf,
 				  u16 frmlen)
 {
-	struct ath_rate_table *rt = sc->hw_rate_table[sc->sc_curmode];
+	struct ath_rate_table *rt = sc->cur_rate_table;
 	struct sk_buff *skb = bf->bf_mpdu;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	u32 nsymbits, nsymbols, mpdudensity;
-- 
1.6.0.3

