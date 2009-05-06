Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57221 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755465AbZEFGUB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 May 2009 02:20:01 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] ath9k: make private driver rate tables const
Date: Wed,  6 May 2009 02:20:00 -0400
Message-Id: <1241590800-26052-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On x86 this allows us to do the following small savings:
shave off 23 % off of the module's data, and
shave off 6  % off of the module's text.

We save 456 bytes, for those counting.

$ size ath9k.ko
   text    data     bss     dec     hex filename
 250794    3628    1600  256022   3e816 ath9k.ko
$ size ath9k-old.ko
   text    data     bss     dec     hex filename
 239114   15308    1600  256022   3e816 ath9k-old.ko

$ du -b ath9k.ko
4034244 ath9k.ko
$ du -b ath9k-old.ko
4033788 ath9k-old.ko

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |    4 +-
 drivers/net/wireless/ath/ath9k/beacon.c |    2 +-
 drivers/net/wireless/ath/ath9k/hw.c     |    2 +-
 drivers/net/wireless/ath/ath9k/hw.h     |    3 +-
 drivers/net/wireless/ath/ath9k/main.c   |    2 +-
 drivers/net/wireless/ath/ath9k/rc.c     |   61 ++++++++++++++++---------------
 drivers/net/wireless/ath/ath9k/xmit.c   |    8 ++--
 7 files changed, 43 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 9399626..3ed40d8 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -580,8 +580,8 @@ struct ath_softc {
 	struct ath_tx tx;
 	struct ath_beacon beacon;
 	struct ieee80211_rate rates[IEEE80211_NUM_BANDS][ATH_RATE_MAX];
-	struct ath_rate_table *hw_rate_table[ATH9K_MODE_MAX];
-	struct ath_rate_table *cur_rate_table;
+	const struct ath_rate_table *hw_rate_table[ATH9K_MODE_MAX];
+	const struct ath_rate_table *cur_rate_table;
 	struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
 
 	struct ath_led radio_led;
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index c17b838..3a7154b 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -63,7 +63,7 @@ static void ath_beacon_setup(struct ath_softc *sc, struct ath_vif *avp,
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_desc *ds;
 	struct ath9k_11n_rate_series series[4];
-	struct ath_rate_table *rt;
+	const struct ath_rate_table *rt;
 	int flags, antenna, ctsrate = 0, ctsduration = 0;
 	u8 rate;
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 02f4015..041c0f5 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -168,7 +168,7 @@ bool ath9k_get_channel_edges(struct ath_hw *ah,
 }
 
 u16 ath9k_hw_computetxtime(struct ath_hw *ah,
-			   struct ath_rate_table *rates,
+			   const struct ath_rate_table *rates,
 			   u32 frameLen, u16 rateix,
 			   bool shortPreamble)
 {
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index ab34126..ddb24c4 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -580,7 +580,8 @@ bool ath9k_hw_setantennaswitch(struct ath_hw *ah,
 bool ath9k_hw_wait(struct ath_hw *ah, u32 reg, u32 mask, u32 val, u32 timeout);
 u32 ath9k_hw_reverse_bits(u32 val, u32 n);
 bool ath9k_get_channel_edges(struct ath_hw *ah, u16 flags, u16 *low, u16 *high);
-u16 ath9k_hw_computetxtime(struct ath_hw *ah, struct ath_rate_table *rates,
+u16 ath9k_hw_computetxtime(struct ath_hw *ah,
+			   const struct ath_rate_table *rates,
 			   u32 frameLen, u16 rateix, bool shortPreamble);
 void ath9k_hw_get_channel_centers(struct ath_hw *ah,
 				  struct ath9k_channel *chan,
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a96a992..a0721e1 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -189,7 +189,7 @@ static u8 parse_mpdudensity(u8 mpdudensity)
 
 static void ath_setup_rates(struct ath_softc *sc, enum ieee80211_band band)
 {
-	struct ath_rate_table *rate_table = NULL;
+	const struct ath_rate_table *rate_table = NULL;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_rate *rate;
 	int i, maxrates;
diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index e526dbc..ba06e78 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -17,7 +17,7 @@
 
 #include "ath9k.h"
 
-static struct ath_rate_table ar5416_11na_ratetable = {
+static const struct ath_rate_table ar5416_11na_ratetable = {
 	42,
 	{
 		{ VALID, VALID, WLAN_RC_PHY_OFDM, 6000, /* 6 Mb */
@@ -155,7 +155,7 @@ static struct ath_rate_table ar5416_11na_ratetable = {
 /* 4ms frame limit not used for NG mode.  The values filled
  * for HT are the 64K max aggregate limit */
 
-static struct ath_rate_table ar5416_11ng_ratetable = {
+static const struct ath_rate_table ar5416_11ng_ratetable = {
 	46,
 	{
 		{ VALID_ALL, VALID_ALL, WLAN_RC_PHY_CCK, 1000, /* 1 Mb */
@@ -302,7 +302,7 @@ static struct ath_rate_table ar5416_11ng_ratetable = {
 	WLAN_RC_HT_FLAG,  /* Phy rates allowed initially */
 };
 
-static struct ath_rate_table ar5416_11a_ratetable = {
+static const struct ath_rate_table ar5416_11a_ratetable = {
 	8,
 	{
 		{ VALID, VALID, WLAN_RC_PHY_OFDM, 6000, /* 6 Mb */
@@ -335,7 +335,7 @@ static struct ath_rate_table ar5416_11a_ratetable = {
 	0,   /* Phy rates allowed initially */
 };
 
-static struct ath_rate_table ar5416_11g_ratetable = {
+static const struct ath_rate_table ar5416_11g_ratetable = {
 	12,
 	{
 		{ VALID, VALID, WLAN_RC_PHY_CCK, 1000, /* 1 Mb */
@@ -380,7 +380,7 @@ static struct ath_rate_table ar5416_11g_ratetable = {
 	0,   /* Phy rates allowed initially */
 };
 
-static struct ath_rate_table ar5416_11b_ratetable = {
+static const struct ath_rate_table ar5416_11b_ratetable = {
 	4,
 	{
 		{ VALID, VALID, WLAN_RC_PHY_CCK, 1000, /* 1 Mb */
@@ -420,7 +420,7 @@ static inline int8_t median(int8_t a, int8_t b, int8_t c)
 	}
 }
 
-static void ath_rc_sort_validrates(struct ath_rate_table *rate_table,
+static void ath_rc_sort_validrates(const struct ath_rate_table *rate_table,
 				   struct ath_rate_priv *ath_rc_priv)
 {
 	u8 i, j, idx, idx_next;
@@ -461,10 +461,11 @@ static inline int ath_rc_isvalid_txmask(struct ath_rate_priv *ath_rc_priv,
 	return ath_rc_priv->valid_rate_index[index];
 }
 
-static inline int ath_rc_get_nextvalid_txrate(struct ath_rate_table *rate_table,
-					      struct ath_rate_priv *ath_rc_priv,
-					      u8 cur_valid_txrate,
-					      u8 *next_idx)
+static inline
+int ath_rc_get_nextvalid_txrate(const struct ath_rate_table *rate_table,
+				struct ath_rate_priv *ath_rc_priv,
+				u8 cur_valid_txrate,
+				u8 *next_idx)
 {
 	u8 i;
 
@@ -500,7 +501,7 @@ static int ath_rc_valid_phyrate(u32 phy, u32 capflag, int ignore_cw)
 }
 
 static inline int
-ath_rc_get_nextlowervalid_txrate(struct ath_rate_table *rate_table,
+ath_rc_get_nextlowervalid_txrate(const struct ath_rate_table *rate_table,
 				 struct ath_rate_priv *ath_rc_priv,
 				 u8 cur_valid_txrate, u8 *next_idx)
 {
@@ -517,7 +518,7 @@ ath_rc_get_nextlowervalid_txrate(struct ath_rate_table *rate_table,
 }
 
 static u8 ath_rc_init_validrates(struct ath_rate_priv *ath_rc_priv,
-				 struct ath_rate_table *rate_table,
+				 const struct ath_rate_table *rate_table,
 				 u32 capflag)
 {
 	u8 i, hi = 0;
@@ -547,7 +548,7 @@ static u8 ath_rc_init_validrates(struct ath_rate_priv *ath_rc_priv,
 }
 
 static u8 ath_rc_setvalid_rates(struct ath_rate_priv *ath_rc_priv,
-				struct ath_rate_table *rate_table,
+				const struct ath_rate_table *rate_table,
 				struct ath_rateset *rateset,
 				u32 capflag)
 {
@@ -592,7 +593,7 @@ static u8 ath_rc_setvalid_rates(struct ath_rate_priv *ath_rc_priv,
 }
 
 static u8 ath_rc_setvalid_htrates(struct ath_rate_priv *ath_rc_priv,
-				  struct ath_rate_table *rate_table,
+				  const struct ath_rate_table *rate_table,
 				  u8 *mcs_set, u32 capflag)
 {
 	struct ath_rateset *rateset = (struct ath_rateset *)mcs_set;
@@ -630,7 +631,7 @@ static u8 ath_rc_setvalid_htrates(struct ath_rate_priv *ath_rc_priv,
 
 static u8 ath_rc_ratefind_ht(struct ath_softc *sc,
 			     struct ath_rate_priv *ath_rc_priv,
-			     struct ath_rate_table *rate_table,
+			     const struct ath_rate_table *rate_table,
 			     int *is_probing)
 {
 	u32 dt, best_thruput, this_thruput, now_msec;
@@ -748,7 +749,7 @@ static u8 ath_rc_ratefind_ht(struct ath_softc *sc,
 	return rate;
 }
 
-static void ath_rc_rate_set_series(struct ath_rate_table *rate_table,
+static void ath_rc_rate_set_series(const struct ath_rate_table *rate_table,
 				   struct ieee80211_tx_rate *rate,
 				   struct ieee80211_tx_rate_control *txrc,
 				   u8 tries, u8 rix, int rtsctsenable)
@@ -769,7 +770,7 @@ static void ath_rc_rate_set_series(struct ath_rate_table *rate_table,
 }
 
 static void ath_rc_rate_set_rtscts(struct ath_softc *sc,
-				   struct ath_rate_table *rate_table,
+				   const struct ath_rate_table *rate_table,
 				   struct ieee80211_tx_info *tx_info)
 {
 	struct ieee80211_tx_rate *rates = tx_info->control.rates;
@@ -807,7 +808,7 @@ static void ath_rc_rate_set_rtscts(struct ath_softc *sc,
 
 static u8 ath_rc_rate_getidx(struct ath_softc *sc,
 			     struct ath_rate_priv *ath_rc_priv,
-			     struct ath_rate_table *rate_table,
+			     const struct ath_rate_table *rate_table,
 			     u8 rix, u16 stepdown,
 			     u16 min_rate)
 {
@@ -838,7 +839,7 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 			    struct ath_rate_priv *ath_rc_priv,
 			    struct ieee80211_tx_rate_control *txrc)
 {
-	struct ath_rate_table *rate_table;
+	const struct ath_rate_table *rate_table;
 	struct sk_buff *skb = txrc->skb;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_tx_rate *rates = tx_info->control.rates;
@@ -937,7 +938,7 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 }
 
 static bool ath_rc_update_per(struct ath_softc *sc,
-			      struct ath_rate_table *rate_table,
+			      const struct ath_rate_table *rate_table,
 			      struct ath_rate_priv *ath_rc_priv,
 			      struct ath_tx_info_priv *tx_info_priv,
 			      int tx_rate, int xretries, int retries,
@@ -1142,7 +1143,7 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 	int rate;
 	u8 last_per;
 	bool state_change = false;
-	struct ath_rate_table *rate_table = sc->cur_rate_table;
+	const struct ath_rate_table *rate_table = sc->cur_rate_table;
 	int size = ath_rc_priv->rate_table_size;
 
 	if ((tx_rate < 0) || (tx_rate > rate_table->rate_cnt))
@@ -1276,7 +1277,7 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 #undef CHK_RSSI
 }
 
-static int ath_rc_get_rateindex(struct ath_rate_table *rate_table,
+static int ath_rc_get_rateindex(const struct ath_rate_table *rate_table,
 				struct ieee80211_tx_rate *rate)
 {
 	int rix;
@@ -1300,7 +1301,7 @@ static void ath_rc_tx_status(struct ath_softc *sc,
 			     int final_ts_idx, int xretries, int long_retry)
 {
 	struct ath_tx_info_priv *tx_info_priv = ATH_TX_INFO_PRIV(tx_info);
-	struct ath_rate_table *rate_table;
+	const struct ath_rate_table *rate_table;
 	struct ieee80211_tx_rate *rates = tx_info->status.rates;
 	u8 flags;
 	u32 i = 0, rix;
@@ -1354,9 +1355,11 @@ static void ath_rc_tx_status(struct ath_softc *sc,
 			 xretries, long_retry);
 }
 
-static struct ath_rate_table *ath_choose_rate_table(struct ath_softc *sc,
-						    enum ieee80211_band band,
-						    bool is_ht, bool is_cw_40)
+static const
+struct ath_rate_table *ath_choose_rate_table(struct ath_softc *sc,
+					     enum ieee80211_band band,
+					     bool is_ht,
+					     bool is_cw_40)
 {
 	int mode = 0;
 
@@ -1390,7 +1393,7 @@ static void ath_rc_init(struct ath_softc *sc,
 			struct ath_rate_priv *ath_rc_priv,
 			struct ieee80211_supported_band *sband,
 			struct ieee80211_sta *sta,
-			struct ath_rate_table *rate_table)
+			const struct ath_rate_table *rate_table)
 {
 	struct ath_rateset *rateset = &ath_rc_priv->neg_rates;
 	u8 *ht_mcs = (u8 *)&ath_rc_priv->neg_ht_rates;
@@ -1587,7 +1590,7 @@ static void ath_rate_init(void *priv, struct ieee80211_supported_band *sband,
 {
 	struct ath_softc *sc = priv;
 	struct ath_rate_priv *ath_rc_priv = priv_sta;
-	struct ath_rate_table *rate_table = NULL;
+	const struct ath_rate_table *rate_table = NULL;
 	bool is_cw40, is_sgi40;
 	int i, j = 0;
 
@@ -1636,7 +1639,7 @@ static void ath_rate_update(void *priv, struct ieee80211_supported_band *sband,
 {
 	struct ath_softc *sc = priv;
 	struct ath_rate_priv *ath_rc_priv = priv_sta;
-	struct ath_rate_table *rate_table = NULL;
+	const struct ath_rate_table *rate_table = NULL;
 	bool oper_cw40 = false, oper_sgi40;
 	bool local_cw40 = (ath_rc_priv->ht_cap & WLAN_RC_40_FLAG) ?
 		true : false;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 501493f..41c4282 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -434,7 +434,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 static u32 ath_lookup_rate(struct ath_softc *sc, struct ath_buf *bf,
 			   struct ath_atx_tid *tid)
 {
-	struct ath_rate_table *rate_table = sc->cur_rate_table;
+	const struct ath_rate_table *rate_table = sc->cur_rate_table;
 	struct sk_buff *skb;
 	struct ieee80211_tx_info *tx_info;
 	struct ieee80211_tx_rate *rates;
@@ -497,7 +497,7 @@ static u32 ath_lookup_rate(struct ath_softc *sc, struct ath_buf *bf,
 static int ath_compute_num_delims(struct ath_softc *sc, struct ath_atx_tid *tid,
 				  struct ath_buf *bf, u16 frmlen)
 {
-	struct ath_rate_table *rt = sc->cur_rate_table;
+	const struct ath_rate_table *rt = sc->cur_rate_table;
 	struct sk_buff *skb = bf->bf_mpdu;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	u32 nsymbits, nsymbols, mpdudensity;
@@ -1407,7 +1407,7 @@ static int setup_tx_flags(struct ath_softc *sc, struct sk_buff *skb,
 static u32 ath_pkt_duration(struct ath_softc *sc, u8 rix, struct ath_buf *bf,
 			    int width, int half_gi, bool shortPreamble)
 {
-	struct ath_rate_table *rate_table = sc->cur_rate_table;
+	const struct ath_rate_table *rate_table = sc->cur_rate_table;
 	u32 nbits, nsymbits, duration, nsymbols;
 	u8 rc;
 	int streams, pktlen;
@@ -1439,7 +1439,7 @@ static u32 ath_pkt_duration(struct ath_softc *sc, u8 rix, struct ath_buf *bf,
 
 static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 {
-	struct ath_rate_table *rt = sc->cur_rate_table;
+	const struct ath_rate_table *rt = sc->cur_rate_table;
 	struct ath9k_11n_rate_series series[4];
 	struct sk_buff *skb;
 	struct ieee80211_tx_info *tx_info;
-- 
1.5.6.4

