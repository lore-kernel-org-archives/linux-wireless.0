Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39802 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753825AbYHZCnL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2008 22:43:11 -0400
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18611.27990.45291.311008@localhost.localdomain> (sfid-20080826_044314_358158_6178F4A1)
Date: Tue, 26 Aug 2008 08:11:26 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 4/4] ath9k: rc.h cleanup
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use kernel doc syntax for comments and remove a few unused macros.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/rc.c |   18 ++--
 drivers/net/wireless/ath9k/rc.h |  222 ++++++++++++++++++++-------------------
 2 files changed, 125 insertions(+), 115 deletions(-)

diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index 1dd7c71..390019e 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -1141,14 +1141,14 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 /*
  * Return the Tx rate series.
  */
-void ath_rate_findrate(struct ath_softc *sc,
-		       struct ath_rate_node *ath_rc_priv,
-		       int num_tries,
-		       int num_rates,
-		       unsigned int rcflag,
-		       struct ath_rc_series series[],
-		       int *is_probe,
-		       int is_retry)
+static void ath_rate_findrate(struct ath_softc *sc,
+			      struct ath_rate_node *ath_rc_priv,
+			      int num_tries,
+			      int num_rates,
+			      unsigned int rcflag,
+			      struct ath_rc_series series[],
+			      int *is_probe,
+			      int is_retry)
 {
 	struct ath_vap *avp = ath_rc_priv->avp;
 
@@ -1942,7 +1942,7 @@ static void ath_get_rate(void *priv, struct net_device *dev,
 	struct ath_rate_node *ath_rc_priv;
 	struct ath_node *an;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-	int is_probe, chk, ret;
+	int is_probe = FALSE, chk, ret;
 	s8 lowest_idx;
 	__le16 fc = hdr->frame_control;
 	u8 *qc, tid;
diff --git a/drivers/net/wireless/ath9k/rc.h b/drivers/net/wireless/ath9k/rc.h
index 71aef9c..b95b415 100644
--- a/drivers/net/wireless/ath9k/rc.h
+++ b/drivers/net/wireless/ath9k/rc.h
@@ -71,9 +71,6 @@ enum ieee80211_fixed_rate_mode {
  */
 #define IEEE80211_RATE_IDX_ENTRY(val, idx) (((val&(0xff<<(idx*8)))>>(idx*8)))
 
-#define SHORT_PRE 1
-#define LONG_PRE 0
-
 #define WLAN_PHY_HT_20_SS       WLAN_RC_PHY_HT_20_SS
 #define WLAN_PHY_HT_20_DS       WLAN_RC_PHY_HT_20_DS
 #define WLAN_PHY_HT_20_DS_HGI   WLAN_RC_PHY_HT_20_DS_HGI
@@ -102,18 +99,18 @@ enum {
 	WLAN_RC_PHY_MAX
 };
 
-#define WLAN_RC_PHY_DS(_phy)   ((_phy == WLAN_RC_PHY_HT_20_DS)           \
-	|| (_phy == WLAN_RC_PHY_HT_40_DS)        \
-	|| (_phy == WLAN_RC_PHY_HT_20_DS_HGI)    \
-	|| (_phy == WLAN_RC_PHY_HT_40_DS_HGI))
-#define WLAN_RC_PHY_40(_phy)   ((_phy == WLAN_RC_PHY_HT_40_SS)           \
-	|| (_phy == WLAN_RC_PHY_HT_40_DS)        \
-	|| (_phy == WLAN_RC_PHY_HT_40_SS_HGI)    \
-	|| (_phy == WLAN_RC_PHY_HT_40_DS_HGI))
+#define WLAN_RC_PHY_DS(_phy)   ((_phy == WLAN_RC_PHY_HT_20_DS)		\
+				|| (_phy == WLAN_RC_PHY_HT_40_DS)	\
+				|| (_phy == WLAN_RC_PHY_HT_20_DS_HGI)	\
+				|| (_phy == WLAN_RC_PHY_HT_40_DS_HGI))
+#define WLAN_RC_PHY_40(_phy)   ((_phy == WLAN_RC_PHY_HT_40_SS)		\
+				|| (_phy == WLAN_RC_PHY_HT_40_DS)	\
+				|| (_phy == WLAN_RC_PHY_HT_40_SS_HGI)	\
+				|| (_phy == WLAN_RC_PHY_HT_40_DS_HGI))
 #define WLAN_RC_PHY_SGI(_phy)  ((_phy == WLAN_RC_PHY_HT_20_SS_HGI)      \
-	|| (_phy == WLAN_RC_PHY_HT_20_DS_HGI)   \
-	|| (_phy == WLAN_RC_PHY_HT_40_SS_HGI)   \
-	|| (_phy == WLAN_RC_PHY_HT_40_DS_HGI))
+				|| (_phy == WLAN_RC_PHY_HT_20_DS_HGI)   \
+				|| (_phy == WLAN_RC_PHY_HT_40_SS_HGI)   \
+				|| (_phy == WLAN_RC_PHY_HT_40_DS_HGI))
 
 #define WLAN_RC_PHY_HT(_phy)    (_phy >= WLAN_RC_PHY_HT_20_SS)
 
@@ -135,56 +132,59 @@ enum {
 #define WLAN_RC_SGI_FLAG        (0x04)
 #define WLAN_RC_HT_FLAG         (0x08)
 
-/* Index into the rate table */
-#define INIT_RATE_MAX_20	23
-#define INIT_RATE_MAX_40	40
-
 #define RATE_TABLE_SIZE		64
 
-/* XXX: Convert to kdoc */
+/**
+ * struct ath_rate_table - Rate Control table
+ * @valid: valid for use in rate control
+ * @valid_single_stream: valid for use in rate control for
+ * 	single stream operation
+ * @phy: CCK/OFDM
+ * @ratekbps: rate in Kbits per second
+ * @user_ratekbps: user rate in Kbits per second
+ * @ratecode: rate that goes into HW descriptors
+ * @short_preamble: Mask for enabling short preamble in ratecode for CCK
+ * @dot11rate: value that goes into supported
+ * 	rates info element of MLME
+ * @ctrl_rate: Index of next lower basic rate, used for duration computation
+ * @max_4ms_framelen: maximum frame length(bytes) for tx duration
+ * @probe_interval: interval for rate control to probe for other rates
+ * @rssi_reduce_interval: interval for rate control to reduce rssi
+ * @initial_ratemax: initial ratemax value used in ath_rc_sib_update()
+ */
 struct ath_rate_table {
 	int rate_cnt;
 	struct {
-		int valid;            /* Valid for use in rate control */
-		int valid_single_stream;/* Valid for use in rate control
-					for single stream operation */
-		u8 phy;              /* CCK/OFDM/TURBO/XR */
-		u32 ratekbps;         /* Rate in Kbits per second */
-		u32 user_ratekbps;     /* User rate in KBits per second */
-		u8 ratecode;         /* rate that goes into
-					hw descriptors */
-		u8 short_preamble;    /* Mask for enabling short preamble
-						in rate code for CCK */
-		u8 dot11rate;        /* Value that goes into supported
-					rates info element of MLME */
-		u8 ctrl_rate;      /* Index of next lower basic rate,
-					used for duration computation */
-		int8_t rssi_ack_validmin;  /* Rate control related */
-		int8_t rssi_ack_deltamin;  /* Rate control related */
-		u8 base_index;        /* base rate index */
-		u8 cw40index;        /* 40cap rate index */
-		u8 sgi_index;         /* shortgi rate index */
-		u8 ht_index;          /* shortgi rate index */
-		u32 max_4ms_framelen;   /* Maximum frame length(bytes)
-						for 4ms tx duration */
+		int valid;
+		int valid_single_stream;
+		u8 phy;
+		u32 ratekbps;
+		u32 user_ratekbps;
+		u8 ratecode;
+		u8 short_preamble;
+		u8 dot11rate;
+		u8 ctrl_rate;
+		int8_t rssi_ack_validmin;
+		int8_t rssi_ack_deltamin;
+		u8 base_index;
+		u8 cw40index;
+		u8 sgi_index;
+		u8 ht_index;
+		u32 max_4ms_framelen;
 	} info[RATE_TABLE_SIZE];
-	u32 probe_interval;        /* interval for ratectrl to
-					probe for other rates */
-	u32 rssi_reduce_interval;   /* interval for ratectrl
-						to reduce RSSI */
-	u8 initial_ratemax;   /* the initial ratemax value used
-					in ath_rc_sib_update() */
+	u32 probe_interval;
+	u32 rssi_reduce_interval;
+	u8 initial_ratemax;
 };
 
 #define ATH_RC_PROBE_ALLOWED            0x00000001
 #define ATH_RC_MINRATE_LASTRATE         0x00000002
-#define ATH_RC_SHORT_PREAMBLE           0x00000004
 
 struct ath_rc_series {
-	u8    rix;
-	u8    tries;
-	u8    flags;
-	u32   max_4ms_framelen;
+	u8 rix;
+	u8 tries;
+	u8 flags;
+	u32 max_4ms_framelen;
 };
 
 /* rcs_flags definition */
@@ -201,42 +201,56 @@ struct ath_rc_series {
 #define MAX_TX_RATE_PHY         48
 
 struct ath_tx_ratectrl_state {
-	int8_t rssi_thres; /* required rssi for this rate (dB) */
-	u8 per; /* recent estimate of packet error rate (%) */
+	int8_t rssi_thres;	/* required rssi for this rate (dB) */
+	u8 per;			/* recent estimate of packet error rate (%) */
 };
 
+/**
+ * struct ath_tx_ratectrl - TX Rate control Information
+ * @state: RC state
+ * @rssi_last: last ACK rssi
+ * @rssi_last_lookup: last ACK rssi used for lookup
+ * @rssi_last_prev: previous last ACK rssi
+ * @rssi_last_prev2: 2nd previous last ACK rssi
+ * @rssi_sum_cnt: count of rssi_sum for averaging
+ * @rssi_sum_rate: rate that we are averaging
+ * @rssi_sum: running sum of rssi for averaging
+ * @probe_rate: rate we are probing at
+ * @rssi_time: msec timestamp for last ack rssi
+ * @rssi_down_time: msec timestamp for last down step
+ * @probe_time: msec timestamp for last probe
+ * @hw_maxretry_pktcnt: num of packets since we got HW max retry error
+ * @max_valid_rate: maximum number of valid rate
+ * @per_down_time: msec timestamp for last PER down step
+ * @valid_phy_ratecnt: valid rate count
+ * @rate_max_phy: phy index for the max rate
+ * @probe_interval: interval for ratectrl to probe for other rates
+ */
 struct ath_tx_ratectrl {
-	struct ath_tx_ratectrl_state state[MAX_TX_RATE_TBL]; /* state */
-	int8_t rssi_last;            /* last ack rssi */
-	int8_t rssi_last_lookup;	/* last ack rssi used for lookup */
-	int8_t rssi_last_prev;	/* previous last ack rssi */
-	int8_t rssi_last_prev2;	/* 2nd previous last ack rssi */
-	int32_t rssi_sum_cnt;        /* count of rssi_sum for averaging */
-	int32_t rssi_sum_rate;       /* rate that we are averaging */
-	int32_t rssi_sum;           /* running sum of rssi for averaging */
-	u32 valid_txrate_mask;   /* mask of valid rates */
-	u8 rate_table_size;      /* rate table size */
-	u8 rate_max;            /* max rate that has recently worked */
-	u8 probe_rate;          /* rate we are probing at */
-	u32 rssi_time;          /* msec timestamp for last ack rssi */
-	u32 rssi_down_time;      /* msec timestamp for last down step */
-	u32 probe_time;         /* msec timestamp for last probe */
-	u8 hw_maxretry_pktcnt;   /* num packets since we got
-					HW max retry error */
-	u8 max_valid_rate;       /* maximum number of valid rate */
-	u8 valid_rate_index[MAX_TX_RATE_TBL]; /* valid rate index */
-	u32 per_down_time;       /* msec timstamp for last
-					PER down step */
+	struct ath_tx_ratectrl_state state[MAX_TX_RATE_TBL];
+	int8_t rssi_last;
+	int8_t rssi_last_lookup;
+	int8_t rssi_last_prev;
+	int8_t rssi_last_prev2;
+	int32_t rssi_sum_cnt;
+	int32_t rssi_sum_rate;
+	int32_t rssi_sum;
+	u8 rate_table_size;
+	u8 probe_rate;
+	u32 rssi_time;
+	u32 rssi_down_time;
+	u32 probe_time;
+	u8 hw_maxretry_pktcnt;
+	u8 max_valid_rate;
+	u8 valid_rate_index[MAX_TX_RATE_TBL];
+	u32 per_down_time;
 
 	/* 11n state */
-	u8  valid_phy_ratecnt[WLAN_RC_PHY_MAX]; /* valid rate count */
-	u8  valid_phy_rateidx[WLAN_RC_PHY_MAX][MAX_TX_RATE_TBL];
-	u8  rc_phy_mode;
-	u8  rate_max_phy;        /* Phy index for the max rate */
-	u32 rate_max_lastused;   /* msec timstamp of when we
-					last used rateMaxPhy */
-	u32 probe_interval;     /* interval for ratectrl to probe
-					for other rates */
+	u8 valid_phy_ratecnt[WLAN_RC_PHY_MAX];
+	u8 valid_phy_rateidx[WLAN_RC_PHY_MAX][MAX_TX_RATE_TBL];
+	u8 rc_phy_mode;
+	u8 rate_max_phy;
+	u32 probe_interval;
 };
 
 struct ath_rateset {
@@ -248,29 +262,32 @@ struct ath_rateset {
 struct ath_rate_softc {
 	/* phy tables that contain rate control data */
 	const void *hw_rate_table[ATH9K_MODE_MAX];
-	int fixedrix;	/* -1 or index of fixed rate */
+
+	/* -1 or index of fixed rate */
+	int fixedrix;
 };
 
 /* per-node state */
 struct ath_rate_node {
-	struct ath_tx_ratectrl tx_ratectrl;	/* rate control state proper */
-	u32 prev_data_rix;	/* rate idx of last data frame */
+	struct ath_tx_ratectrl tx_ratectrl;
 
-	/* map of rate ix -> negotiated rate set ix */
-	u8 rixmap[MAX_TX_RATE_TBL];
+	/* rate idx of last data frame */
+	u32 prev_data_rix;
 
-	/* map of ht rate ix -> negotiated rate set ix */
-	u8 ht_rixmap[MAX_TX_RATE_TBL];
+	/* ht capabilities */
+	u8 ht_cap;
 
-	u8 ht_cap;		/* ht capabilities */
-	u8 ant_tx;		/* current transmit antenna */
+	/* When TRUE, only single stream Tx possible */
+	u8 single_stream;
 
-	u8 single_stream;   /* When TRUE, only single
-				stream Tx possible */
-	struct ath_rateset neg_rates;	/* Negotiated rates */
-	struct ath_rateset neg_ht_rates;	/* Negotiated HT rates */
-	struct ath_rate_softc *asc; /* back pointer to atheros softc */
-	struct ath_vap *avp;	/* back pointer to vap */
+	/* Negotiated rates */
+	struct ath_rateset neg_rates;
+
+	/* Negotiated HT rates */
+	struct ath_rateset neg_ht_rates;
+
+	struct ath_rate_softc *asc;
+	struct ath_vap *avp;
 };
 
 /* Driver data of ieee80211_tx_info */
@@ -297,17 +314,10 @@ void ath_rc_node_update(struct ieee80211_hw *hw, struct ath_rate_node *rc_priv);
 void ath_rate_newstate(struct ath_softc *sc, struct ath_vap *avp);
 
 /*
- * Return the tx rate series.
- */
-void ath_rate_findrate(struct ath_softc *sc, struct ath_rate_node *ath_rc_priv,
-		       int num_tries, int num_rates,
-		       unsigned int rcflag, struct ath_rc_series[],
-		       int *is_probe, int isretry);
-/*
  * Return rate index for given Dot11 Rate.
  */
 u8 ath_rate_findrateix(struct ath_softc *sc,
-			     u8 dot11_rate);
+		       u8 dot11_rate);
 
 /* Routines to register/unregister rate control algorithm */
 int ath_rate_control_register(void);
-- 
1.6.0

