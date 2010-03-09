Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:37501 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790Ab0CITFh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Mar 2010 14:05:37 -0500
Received: by fxm5 with SMTP id 5so1690638fxm.29
        for <linux-wireless@vger.kernel.org>; Tue, 09 Mar 2010 11:05:35 -0800 (PST)
From: Michael Sprecher <sprecher.m@gmail.com>
To: lrodriguez@atheros.com, jmalinen@atheros.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Michael Sprecher <sprecher.m@gmail.com>
Subject: [PATCH] wireless: ath9k: Fix most coding style issues in ath9k This patch fixed up almost all coding style issues in the ath9k driver found by the ceckpatch.pl tool. Signed-off-by: Michael Sprecher <sprecher.m@gmail.com>
Date: Tue,  9 Mar 2010 20:05:28 +0100
Message-Id: <1268161528-24028-1-git-send-email-sprecher.m@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 drivers/net/wireless/ath/ath9k/ani.c         |    5 ++-
 drivers/net/wireless/ath/ath9k/ath9k.h       |   28 ++++++++--------
 drivers/net/wireless/ath/ath9k/beacon.c      |    6 ++--
 drivers/net/wireless/ath/ath9k/btcoex.h      |    6 ++--
 drivers/net/wireless/ath/ath9k/calib.c       |   15 ++++-----
 drivers/net/wireless/ath/ath9k/calib.h       |    4 +-
 drivers/net/wireless/ath/ath9k/common.c      |   20 +++++------
 drivers/net/wireless/ath/ath9k/common.h      |   10 +++---
 drivers/net/wireless/ath/ath9k/debug.c       |   12 +++---
 drivers/net/wireless/ath/ath9k/eeprom.h      |    4 +-
 drivers/net/wireless/ath/ath9k/eeprom_4k.c   |   16 +++++-----
 drivers/net/wireless/ath/ath9k/eeprom_9287.c |   14 +++++---
 drivers/net/wireless/ath/ath9k/eeprom_def.c  |   31 +++++++++---------
 drivers/net/wireless/ath/ath9k/gpio.c        |    2 +-
 drivers/net/wireless/ath/ath9k/hw.c          |   44 +++++++++++--------------
 drivers/net/wireless/ath/ath9k/hw.h          |   22 ++++++------
 drivers/net/wireless/ath/ath9k/init.c        |    6 ++--
 drivers/net/wireless/ath/ath9k/mac.h         |    2 +-
 drivers/net/wireless/ath/ath9k/main.c        |   26 +++++++-------
 drivers/net/wireless/ath/ath9k/phy.c         |   12 +++----
 drivers/net/wireless/ath/ath9k/phy.h         |    4 +-
 drivers/net/wireless/ath/ath9k/rc.c          |   13 +++----
 drivers/net/wireless/ath/ath9k/rc.h          |    4 +-
 drivers/net/wireless/ath/ath9k/recv.c        |    5 +--
 drivers/net/wireless/ath/ath9k/reg.h         |   22 ++++++------
 drivers/net/wireless/ath/ath9k/virtual.c     |    3 +-
 drivers/net/wireless/ath/ath9k/xmit.c        |   11 +++---
 27 files changed, 167 insertions(+), 180 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 2a0cd64..a9296bb 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -170,8 +170,9 @@ static bool ath9k_hw_ani_control(struct ath_hw *ah,
 		break;
 	}
 	case ATH9K_ANI_SPUR_IMMUNITY_LEVEL:{
-		const int cycpwrThr1[] =
-			{ 2, 4, 6, 8, 10, 12, 14, 16 };
+		const int cycpwrThr1[] = {
+			2, 4, 6, 8, 10, 12, 14, 16
+		};
 		u32 level = param;
 
 		if (level >= ARRAY_SIZE(cycpwrThr1)) {
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 83c7ea4..e55bf6a 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -55,7 +55,7 @@ struct ath_node;
 
 #define A_MAX(a, b) ((a) > (b) ? (a) : (b))
 
-#define TSF_TO_TU(_h,_l) \
+#define TSF_TO_TU(_h, _l) \
 	((((u32)(_h)) << 22) | (((u32)(_l)) >> 10))
 
 #define	ATH_TXQ_SETUP(sc, i)        ((sc)->tx.txqsetup & (1<<i))
@@ -100,14 +100,14 @@ enum buffer_type {
 	BUF_XRETRY		= BIT(5),
 };
 
-#define bf_nframes      	bf_state.bfs_nframes
-#define bf_al           	bf_state.bfs_al
-#define bf_frmlen       	bf_state.bfs_frmlen
-#define bf_retries      	bf_state.bfs_retries
-#define bf_seqno        	bf_state.bfs_seqno
-#define bf_tidno        	bf_state.bfs_tidno
+#define bf_nframes		bf_state.bfs_nframes
+#define bf_al			bf_state.bfs_al
+#define bf_frmlen		bf_state.bfs_frmlen
+#define bf_retries		bf_state.bfs_retries
+#define bf_seqno		bf_state.bfs_seqno
+#define bf_tidno		bf_state.bfs_tidno
 #define bf_keyix                bf_state.bfs_keyix
-#define bf_keytype      	bf_state.bfs_keytype
+#define bf_keytype		bf_state.bfs_keytype
 #define bf_isht(bf)		(bf->bf_state.bf_type & BUF_HT)
 #define bf_isampdu(bf)		(bf->bf_state.bf_type & BUF_AMPDU)
 #define bf_isaggr(bf)		(bf->bf_state.bf_type & BUF_AGGR)
@@ -291,11 +291,11 @@ struct ath_vif {
  * number of BSSIDs) if a given beacon does not go out even after waiting this
  * number of beacon intervals, the game's up.
  */
-#define BSTUCK_THRESH           	(9 * ATH_BCBUF)
-#define	ATH_BCBUF               	4
-#define ATH_DEFAULT_BINTVAL     	100 /* TU */
-#define ATH_DEFAULT_BMISS_LIMIT 	10
-#define IEEE80211_MS_TO_TU(x)           (((x) * 1000) / 1024)
+#define BSTUCK_THRESH			(9 * ATH_BCBUF)
+#define	ATH_BCBUF			4
+#define ATH_DEFAULT_BINTVAL		100 /* TU */
+#define ATH_DEFAULT_BMISS_LIMIT		10
+#define IEEE80211_MS_TO_TU(x)		(((x) * 1000) / 1024)
 
 struct ath_beacon_config {
 	u16 beacon_interval;
@@ -377,7 +377,7 @@ void ath9k_btcoex_timer_pause(struct ath_softc *sc);
 /*   LED Control    */
 /********************/
 
-#define ATH_LED_PIN_DEF 		1
+#define ATH_LED_PIN_DEF			1
 #define ATH_LED_PIN_9287		8
 #define ATH_LED_ON_DURATION_IDLE	350	/* in msecs */
 #define ATH_LED_OFF_DURATION_IDLE	250	/* in msecs */
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index b4a31a4..c5a4347 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -699,9 +699,9 @@ static void ath_beacon_config_adhoc(struct ath_softc *sc,
 
 	nexttbtt = TSF_TO_TU(sc->beacon.bc_tstamp >> 32, sc->beacon.bc_tstamp);
 	if (nexttbtt == 0)
-                nexttbtt = intval;
-        else if (intval)
-                nexttbtt = roundup(nexttbtt, intval);
+		nexttbtt = intval;
+	else if (intval)
+		nexttbtt = roundup(nexttbtt, intval);
 
 	tsf = ath9k_hw_gettsf64(sc->sc_ah);
 	tsftu = TSF_TO_TU((u32)(tsf>>32), (u32)tsf) + FUDGE;
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
index 1ee5a15..57ef25e 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.h
+++ b/drivers/net/wireless/ath/ath9k/btcoex.h
@@ -44,9 +44,9 @@ struct ath_btcoex_hw {
 	u8 wlanactive_gpio;
 	u8 btactive_gpio;
 	u8 btpriority_gpio;
-	u32 bt_coex_mode; 	/* Register setting for AR_BT_COEX_MODE */
-	u32 bt_coex_weights; 	/* Register setting for AR_BT_COEX_WEIGHT */
-	u32 bt_coex_mode2; 	/* Register setting for AR_BT_COEX_MODE2 */
+	u32 bt_coex_mode;	/* Register setting for AR_BT_COEX_MODE */
+	u32 bt_coex_weights;	/* Register setting for AR_BT_COEX_WEIGHT */
+	u32 bt_coex_mode2;	/* Register setting for AR_BT_COEX_MODE2 */
 };
 
 bool ath9k_hw_btcoex_supported(struct ath_hw *ah);
diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 238a574..2e10e5b 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -727,9 +727,8 @@ void ath9k_init_nfcal_hist_buffer(struct ath_hw *ah)
 		ah->nfCalHist[i].privNF = noise_floor;
 		ah->nfCalHist[i].invalidNFcount =
 			AR_PHY_CCA_FILTERWINDOW_LENGTH;
-		for (j = 0; j < ATH9K_NF_CAL_HIST_MAX; j++) {
+		for (j = 0; j < ATH9K_NF_CAL_HIST_MAX; j++)
 			ah->nfCalHist[i].nfCalBuffer[j] = noise_floor;
-		}
 	}
 }
 
@@ -817,7 +816,7 @@ static void ath9k_hw_9271_pa_cal(struct ath_hw *ah, bool is_reset)
 {
 	u32 regVal;
 	unsigned int i;
-	u32 regList [][2] = {
+	u32 regList[][2] = {
 		{ 0x786c, 0 },
 		{ 0x7854, 0 },
 		{ 0x7820, 0 },
@@ -855,16 +854,16 @@ static void ath9k_hw_9271_pa_cal(struct ath_hw *ah, bool is_reset)
 	/* 7820,b25,1, pdpadrv1=0 */
 	REG_RMW_FIELD(ah, AR9285_AN_RF2G1, AR9285_AN_RF2G1_PDPADRV1, 0);
 	/* 7820,b24,0, pdpadrv2=0 */
-	REG_RMW_FIELD(ah, AR9285_AN_RF2G1,AR9285_AN_RF2G1_PDPADRV2,0);
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G1, AR9285_AN_RF2G1_PDPADRV2, 0);
 	/* 7820,b23,0, pdpaout=0 */
 	REG_RMW_FIELD(ah, AR9285_AN_RF2G1, AR9285_AN_RF2G1_PDPAOUT, 0);
 	/* 783c,b14-16,7, padrvgn2tab_0=7 */
-	REG_RMW_FIELD(ah, AR9285_AN_RF2G8,AR9285_AN_RF2G8_PADRVGN2TAB0, 7);
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G8, AR9285_AN_RF2G8_PADRVGN2TAB0, 7);
 	/*
 	 * 7838,b29-31,0, padrvgn1tab_0=0
 	 * does not matter since we turn it off
 	 */
-	REG_RMW_FIELD(ah, AR9285_AN_RF2G7,AR9285_AN_RF2G7_PADRVGN2TAB0, 0);
+	REG_RMW_FIELD(ah, AR9285_AN_RF2G7, AR9285_AN_RF2G7_PADRVGN2TAB0, 0);
 
 	REG_RMW_FIELD(ah, AR9285_AN_RF2G3, AR9271_AN_RF2G3_CCOMP, 0xfff);
 
@@ -882,14 +881,14 @@ static void ath9k_hw_9271_pa_cal(struct ath_hw *ah, bool is_reset)
 		regVal |= (1 << (20 + i));
 		REG_WRITE(ah, 0x7834, regVal);
 		udelay(1);
-		//regVal = REG_READ(ah, 0x7834);
+		/* regVal = REG_READ(ah, 0x7834); */
 		regVal &= (~(0x1 << (20 + i)));
 		regVal |= (MS(REG_READ(ah, 0x7840), AR9285_AN_RXTXBB1_SPARE9)
 			    << (20 + i));
 		REG_WRITE(ah, 0x7834, regVal);
 	}
 
-	regVal = (regVal >>20) & 0x7f;
+	regVal = (regVal >> 20) & 0x7f;
 
 	/* Update PA cal info */
 	if ((!is_reset) && (ah->pacal_info.prev_offset == regVal)) {
diff --git a/drivers/net/wireless/ath/ath9k/calib.h b/drivers/net/wireless/ath/ath9k/calib.h
index b2c873e..68ee2a0 100644
--- a/drivers/net/wireless/ath/ath9k/calib.h
+++ b/drivers/net/wireless/ath/ath9k/calib.h
@@ -31,8 +31,8 @@ extern const struct ath9k_percal_data adc_init_dc_cal;
 #define AR_PHY_CCA_MAX_AR9280_GOOD_VALUE	-112
 #define AR_PHY_CCA_MAX_AR9285_GOOD_VALUE	-118
 #define AR_PHY_CCA_MAX_AR9287_GOOD_VALUE	-118
-#define AR_PHY_CCA_MAX_HIGH_VALUE      		-62
-#define AR_PHY_CCA_MIN_BAD_VALUE       		-140
+#define AR_PHY_CCA_MAX_HIGH_VALUE		-62
+#define AR_PHY_CCA_MIN_BAD_VALUE		-140
 #define AR_PHY_CCA_FILTERWINDOW_LENGTH_INIT     3
 #define AR_PHY_CCA_FILTERWINDOW_LENGTH          5
 
diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index 4d775ae..e3ba866 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -45,11 +45,11 @@ static bool ath9k_rx_accept(struct ath_common *common,
 
 	if (!rx_stats->rs_datalen)
 		return false;
-        /*
-         * rs_status follows rs_datalen so if rs_datalen is too large
-         * we can take a hint that hardware corrupted it, so ignore
-         * those frames.
-         */
+	/*
+	 * rs_status follows rs_datalen so if rs_datalen is too large
+	 * we can take a hint that hardware corrupted it, so ignore
+	 * those frames.
+	 */
 	if (rx_stats->rs_datalen > common->rx_bufsize)
 		return false;
 
@@ -140,7 +140,7 @@ static u8 ath9k_process_rate(struct ath_common *common,
 	if ((common->debug_mask & ATH_DBG_XMIT))
 		print_hex_dump_bytes("", DUMP_PREFIX_NONE, skb->data, skb->len);
 
-        return 0;
+	return 0;
 }
 
 static void ath9k_process_rssi(struct ath_common *common,
@@ -248,7 +248,7 @@ void ath9k_cmn_rx_skb_postprocess(struct ath_common *common,
 	 * not try to remove padding from short control frames that do
 	 * not have payload. */
 	padsize = padpos & 3;
-	if (padsize && skb->len>=padpos+padsize+FCS_LEN) {
+	if (padsize && skb->len >= padpos + padsize + FCS_LEN) {
 		memmove(skb->data + padsize, skb->data, padpos);
 		skb_pull(skb, padsize);
 	}
@@ -275,12 +275,10 @@ EXPORT_SYMBOL(ath9k_cmn_rx_skb_postprocess);
 int ath9k_cmn_padpos(__le16 frame_control)
 {
 	int padpos = 24;
-	if (ieee80211_has_a4(frame_control)) {
+	if (ieee80211_has_a4(frame_control))
 		padpos += ETH_ALEN;
-	}
-	if (ieee80211_is_data_qos(frame_control)) {
+	if (ieee80211_is_data_qos(frame_control))
 		padpos += IEEE80211_QOS_CTL_LEN;
-	}
 
 	return padpos;
 }
diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
index 042999c..1f4fedd 100644
--- a/drivers/net/wireless/ath/ath9k/common.h
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -35,18 +35,18 @@
 #define WME_NUM_AC  4
 
 #define ATH_RSSI_DUMMY_MARKER   0x127
-#define ATH_RSSI_LPF_LEN 		10
+#define ATH_RSSI_LPF_LEN		10
 #define RSSI_LPF_THRESHOLD		-20
 #define ATH_RSSI_EP_MULTIPLIER     (1<<7)
 #define ATH_EP_MUL(x, mul)         ((x) * (mul))
 #define ATH_RSSI_IN(x)             (ATH_EP_MUL((x), ATH_RSSI_EP_MULTIPLIER))
 #define ATH_LPF_RSSI(x, y, len) \
     ((x != ATH_RSSI_DUMMY_MARKER) ? (((x) * ((len) - 1) + (y)) / (len)) : (y))
-#define ATH_RSSI_LPF(x, y) do {                     			\
-    if ((y) >= RSSI_LPF_THRESHOLD)                         		\
-	x = ATH_LPF_RSSI((x), ATH_RSSI_IN((y)), ATH_RSSI_LPF_LEN);  	\
+#define ATH_RSSI_LPF(x, y) do {						\
+    if ((y) >= RSSI_LPF_THRESHOLD)					\
+	x = ATH_LPF_RSSI((x), ATH_RSSI_IN((y)), ATH_RSSI_LPF_LEN);	\
 } while (0)
-#define ATH_EP_RND(x, mul) 						\
+#define ATH_EP_RND(x, mul)						\
 	((((x)%(mul)) >= ((mul)/2)) ? ((x) + ((mul) - 1)) / (mul) : (x)/(mul))
 
 struct ath_atx_ac {
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 42d2a50..e713aee 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -156,10 +156,10 @@ static ssize_t read_file_dma(struct file *file, char __user *user_buf,
 		"txfifo_dcu_num_0:   %2d    txfifo_dcu_num_1:       %2d\n",
 		(val[6] & 0x0001e000) >> 13, (val[6] & 0x001e0000) >> 17);
 
-	len += snprintf(buf + len, DMA_BUF_LEN - len, "pcu observe: 0x%x \n",
+	len += snprintf(buf + len, DMA_BUF_LEN - len, "pcu observe: 0x%x\n",
 			REG_READ_D(ah, AR_OBS_BUS_1));
 	len += snprintf(buf + len, DMA_BUF_LEN - len,
-			"AR_CR: 0x%x \n", REG_READ_D(ah, AR_CR));
+			"AR_CR: 0x%x\n", REG_READ_D(ah, AR_CR));
 
 	ath9k_ps_restore(sc);
 
@@ -355,7 +355,7 @@ static const struct file_operations fops_rcstat = {
 	.owner = THIS_MODULE
 };
 
-static const char * ath_wiphy_state_str(enum ath_wiphy_state state)
+static const char *ath_wiphy_state_str(enum ath_wiphy_state state)
 {
 	switch (state) {
 	case ATH_WIPHY_INACTIVE:
@@ -409,7 +409,7 @@ static ssize_t read_file_wiphy(struct file *file, char __user *user_buf,
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
-static struct ath_wiphy * get_wiphy(struct ath_softc *sc, const char *name)
+static struct ath_wiphy *get_wiphy(struct ath_softc *sc, const char *name)
 {
 	int i;
 	if (strcmp(name, wiphy_name(sc->pri_wiphy->hw->wiphy)) == 0)
@@ -456,7 +456,7 @@ static int select_wiphy(struct ath_softc *sc, const char *name)
 
 static int schedule_wiphy(struct ath_softc *sc, const char *msec)
 {
-	ath9k_wiphy_set_scheduler(sc, simple_strtoul(msec, NULL, 0));
+	ath9k_wiphy_set_scheduler(sc, strict_strtoul(msec, NULL, 0));
 	return 0;
 }
 
@@ -519,7 +519,7 @@ static const struct file_operations fops_wiphy = {
 		sc->debug.stats.txstats[sc->tx.hwq_map[ATH9K_WME_AC_BK]].elem, \
 		sc->debug.stats.txstats[sc->tx.hwq_map[ATH9K_WME_AC_VI]].elem, \
 		sc->debug.stats.txstats[sc->tx.hwq_map[ATH9K_WME_AC_VO]].elem); \
-} while(0)
+} while (0)
 
 static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
 			      size_t count, loff_t *ppos)
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 2f2993b..a0f071b 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -194,8 +194,8 @@
 #define AR9287_NUM_2G_CCK_TARGET_POWERS 3
 #define AR9287_NUM_2G_20_TARGET_POWERS  3
 #define AR9287_NUM_2G_40_TARGET_POWERS  3
-#define AR9287_NUM_CTLS              	12
-#define AR9287_NUM_BAND_EDGES        	4
+#define AR9287_NUM_CTLS			12
+#define AR9287_NUM_BAND_EDGES		4
 #define AR9287_NUM_PD_GAINS             4
 #define AR9287_PD_GAINS_IN_MASK         4
 #define AR9287_PD_GAIN_ICEPTS           1
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index 68db166..0b6655d 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -43,7 +43,7 @@ static bool ath9k_hw_4k_fill_eeprom(struct ath_hw *ah)
 	for (addr = 0; addr < SIZE_EEPROM_4K; addr++) {
 		if (!ath9k_hw_nvram_read(common, addr + eep_start_loc, eep_data)) {
 			ath_print(common, ATH_DBG_EEPROM,
-				  "Unable to read eeprom region \n");
+				  "Unable to read eeprom region\n");
 			return false;
 		}
 		eep_data++;
@@ -508,7 +508,7 @@ static void ath9k_hw_set_4k_power_per_rate_table(struct ath_hw *ah,
 						 u16 powerLimit)
 {
 #define CMP_TEST_GRP \
-	(((cfgCtl & ~CTL_MODE_M)| (pCtlMode[ctlMode] & CTL_MODE_M)) ==	\
+	(((cfgCtl & ~CTL_MODE_M) | (pCtlMode[ctlMode] & CTL_MODE_M)) ==	\
 	 pEepData->ctlIndex[i])						\
 	|| (((cfgCtl & ~CTL_MODE_M) | (pCtlMode[ctlMode] & CTL_MODE_M)) == \
 	    ((pEepData->ctlIndex[i] & CTL_MODE_M) | SD_NO_CTL))
@@ -523,8 +523,8 @@ static void ath9k_hw_set_4k_power_per_rate_table(struct ath_hw *ah,
 	struct chan_centers centers;
 	struct cal_ctl_data_4k *rep;
 	struct ar5416_eeprom_4k *pEepData = &ah->eeprom.map4k;
-	static const u16 tpScaleReductionTable[5] =
-		{ 0, 3, 6, 9, AR5416_MAX_RATE_POWER };
+	static const u16 tpScaleReductionTable[5] = {
+		0, 3, 6, 9, AR5416_MAX_RATE_POWER };
 	struct cal_target_power_leg targetPowerOfdm, targetPowerCck = {
 		0, { 0, 0, 0, 0}
 	};
@@ -535,10 +535,10 @@ static void ath9k_hw_set_4k_power_per_rate_table(struct ath_hw *ah,
 	struct cal_target_power_ht targetPowerHt20, targetPowerHt40 = {
 		0, {0, 0, 0, 0}
 	};
-	u16 ctlModesFor11g[] =
-		{ CTL_11B, CTL_11G, CTL_2GHT20, CTL_11B_EXT, CTL_11G_EXT,
-		  CTL_2GHT40
-		};
+	u16 ctlModesFor11g[] = {
+		CTL_11B, CTL_11G, CTL_2GHT20, CTL_11B_EXT, CTL_11G_EXT,
+		CTL_2GHT40
+	};
 
 	ath9k_hw_get_channel_centers(ah, chan, &centers);
 
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index 839d05a..4302d18 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -44,7 +44,7 @@ static bool ath9k_hw_AR9287_fill_eeprom(struct ath_hw *ah)
 		if (!ath9k_hw_nvram_read(common,
 					 addr + eep_start_loc, eep_data)) {
 			ath_print(common, ATH_DBG_EEPROM,
-				  "Unable to read eeprom region \n");
+				  "Unable to read eeprom region\n");
 			return false;
 		}
 		eep_data++;
@@ -606,8 +606,9 @@ static void ath9k_hw_set_AR9287_power_per_rate_table(struct ath_hw *ah,
 #define REDUCE_SCALED_POWER_BY_THREE_CHAIN   10
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	u16 twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
-	static const u16 tpScaleReductionTable[5] =
-		{ 0, 3, 6, 9, AR5416_MAX_RATE_POWER };
+	static const u16 tpScaleReductionTable[5] = {
+		0, 3, 6, 9, AR5416_MAX_RATE_POWER
+	};
 	int i;
 	int16_t  twiceLargestAntenna;
 	struct cal_ctl_data_ar9287 *rep;
@@ -618,9 +619,10 @@ static void ath9k_hw_set_AR9287_power_per_rate_table(struct ath_hw *ah,
 	struct cal_target_power_ht  targetPowerHt20,
 				    targetPowerHt40 = {0, {0, 0, 0, 0} };
 	u16 scaledPower = 0, minCtlPower, maxRegAllowedPower;
-	u16 ctlModesFor11g[] =
-		{CTL_11B, CTL_11G, CTL_2GHT20,
-		 CTL_11B_EXT, CTL_11G_EXT, CTL_2GHT40};
+	u16 ctlModesFor11g[] = {
+		CTL_11B, CTL_11G, CTL_2GHT20,
+		CTL_11B_EXT, CTL_11G_EXT, CTL_2GHT40
+	};
 	u16 numCtlModes = 0, *pCtlMode = NULL, ctlMode, freq;
 	struct chan_centers centers;
 	int tx_chainmask;
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 404a034..f128752 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -326,7 +326,7 @@ static void ath9k_hw_def_set_gain(struct ath_hw *ah,
 			REG_WRITE(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
 			  (REG_READ(ah, AR_PHY_GAIN_2GHZ + regChainOffset) &
 			   ~AR_PHY_GAIN_2GHZ_BSW_MARGIN)
-			  | SM(pModal-> bswMargin[i],
+			  | SM(pModal->bswMargin[i],
 			       AR_PHY_GAIN_2GHZ_BSW_MARGIN));
 			REG_WRITE(ah, AR_PHY_GAIN_2GHZ + regChainOffset,
 			  (REG_READ(ah, AR_PHY_GAIN_2GHZ + regChainOffset) &
@@ -713,9 +713,8 @@ static void ath9k_hw_get_def_gain_boundaries_pdadcs(struct ath_hw *ah,
 		maxIndex = (tgtIndex < sizeCurrVpdTable) ?
 			tgtIndex : sizeCurrVpdTable;
 
-		while ((ss < maxIndex) && (k < (AR5416_NUM_PDADC_VALUES - 1))) {
+		while ((ss < maxIndex) && (k < (AR5416_NUM_PDADC_VALUES - 1)))
 			pPDADCValues[k++] = vpdTableI[i][ss++];
-		}
 
 		vpdStep = (int16_t)(vpdTableI[i][sizeCurrVpdTable - 1] -
 				    vpdTableI[i][sizeCurrVpdTable - 2]);
@@ -803,14 +802,12 @@ static void ath9k_adjust_pdadc_values(struct ath_hw *ah,
 	if (AR_SREV_9280_20_OR_LATER(ah)) {
 		if (AR5416_PWR_TABLE_OFFSET_DB != pwr_table_offset) {
 			/* shift the table to start at the new offset */
-			for (k = 0; k < (u16)NUM_PDADC(diff); k++ ) {
+			for (k = 0; k < (u16)NUM_PDADC(diff); k++)
 				pdadcValues[k] = pdadcValues[k + diff];
-			}
 
 			/* fill the back of the table */
-			for (k = (u16)NUM_PDADC(diff); k < NUM_PDADC(0); k++) {
+			for (k = (u16)NUM_PDADC(diff); k < NUM_PDADC(0); k++)
 				pdadcValues[k] = pdadcValues[NUM_PDADC(diff)];
-			}
 		}
 	}
 #undef NUM_PDADC
@@ -1000,8 +997,9 @@ static void ath9k_hw_set_def_power_per_rate_table(struct ath_hw *ah,
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	struct ar5416_eeprom_def *pEepData = &ah->eeprom.def;
 	u16 twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
-	static const u16 tpScaleReductionTable[5] =
-		{ 0, 3, 6, 9, AR5416_MAX_RATE_POWER };
+	static const u16 tpScaleReductionTable[5] = {
+		0, 3, 6, 9, AR5416_MAX_RATE_POWER
+	};
 
 	int i;
 	int16_t twiceLargestAntenna;
@@ -1017,12 +1015,13 @@ static void ath9k_hw_set_def_power_per_rate_table(struct ath_hw *ah,
 		0, {0, 0, 0, 0}
 	};
 	u16 scaledPower = 0, minCtlPower, maxRegAllowedPower;
-	u16 ctlModesFor11a[] =
-		{ CTL_11A, CTL_5GHT20, CTL_11A_EXT, CTL_5GHT40 };
-	u16 ctlModesFor11g[] =
-		{ CTL_11B, CTL_11G, CTL_2GHT20, CTL_11B_EXT, CTL_11G_EXT,
-		  CTL_2GHT40
-		};
+	u16 ctlModesFor11a[] = {
+		CTL_11A, CTL_5GHT20, CTL_11A_EXT, CTL_5GHT40
+	};
+	u16 ctlModesFor11g[] = {
+		CTL_11B, CTL_11G, CTL_2GHT20, CTL_11B_EXT, CTL_11G_EXT,
+		CTL_2GHT40
+	};
 	u16 numCtlModes, *pCtlMode, ctlMode, freq;
 	struct chan_centers centers;
 	int tx_chainmask;
@@ -1397,7 +1396,7 @@ static void ath9k_hw_def_set_txpower(struct ath_hw *ah,
 	else
 		regulatory->max_power_level = ratesArray[i];
 
-	switch(ar5416_get_ntxchains(ah->txchainmask)) {
+	switch (ar5416_get_ntxchains(ah->txchainmask)) {
 	case 1:
 		break;
 	case 2:
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index deab8be..c2c3090 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -364,7 +364,7 @@ static void ath_btcoex_no_stomp_timer(void *arg)
 	bool is_btscan = sc->sc_flags & SC_OP_BT_SCAN;
 
 	ath_print(ath9k_hw_common(ah), ATH_DBG_BTCOEX,
-		  "no stomp timer running \n");
+		  "no stomp timer running\n");
 
 	spin_lock_bh(&btcoex->btcoex_lock);
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 2e767cf..90de6ab 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -57,10 +57,10 @@ static u32 ath9k_hw_mac_clks(struct ath_hw *ah, u32 usecs)
 	struct ieee80211_conf *conf = &ath9k_hw_common(ah)->hw->conf;
 
 	if (!ah->curchan) /* should really check for CCK instead */
-		return usecs *ATH9K_CLOCK_RATE_CCK;
+		return usecs * ATH9K_CLOCK_RATE_CCK;
 	if (conf->channel->band == IEEE80211_BAND_2GHZ)
-		return usecs *ATH9K_CLOCK_RATE_2GHZ_OFDM;
-	return usecs *ATH9K_CLOCK_RATE_5GHZ_OFDM;
+		return usecs * ATH9K_CLOCK_RATE_2GHZ_OFDM;
+	return usecs * ATH9K_CLOCK_RATE_5GHZ_OFDM;
 }
 
 static u32 ath9k_hw_mac_to_clks(struct ath_hw *ah, u32 usecs)
@@ -515,7 +515,7 @@ static int ath9k_hw_post_init(struct ath_hw *ah)
 		  ah->eep_ops->get_eeprom_ver(ah),
 		  ah->eep_ops->get_eeprom_rev(ah));
 
-        if (!AR_SREV_9280_10_OR_LATER(ah)) {
+	if (!AR_SREV_9280_10_OR_LATER(ah)) {
 		ecode = ath9k_hw_rf_alloc_ext_banks(ah);
 		if (ecode) {
 			ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
@@ -680,7 +680,7 @@ static void ath9k_hw_init_mode_regs(struct ath_hw *ah)
 		if (ah->config.pcie_clock_req) {
 			INIT_INI_ARRAY(&ah->iniPcieSerdes,
 			       ar9280PciePhy_clkreq_off_L1_9280,
-			       ARRAY_SIZE(ar9280PciePhy_clkreq_off_L1_9280),2);
+			       ARRAY_SIZE(ar9280PciePhy_clkreq_off_L1_9280), 2);
 		} else {
 			INIT_INI_ARRAY(&ah->iniPcieSerdes,
 			       ar9280PciePhy_clkreq_always_on_L1_9280,
@@ -1071,7 +1071,7 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
 
 	/* Switch the core clock for ar9271 to 117Mhz */
 	if (AR_SREV_9271(ah)) {
-		if ((pll == 0x142c) || (pll == 0x2850) ) {
+		if ((pll == 0x142c) || (pll == 0x2850)) {
 			udelay(500);
 			/* set CLKOBS to output AHB clock */
 			REG_WRITE(ah, 0x7020, 0xe);
@@ -1275,8 +1275,7 @@ static void ath9k_hw_override_ini(struct ath_hw *ah,
 			val = REG_READ(ah, AR_PHY_SPECTRAL_SCAN) |
 			      AR_PHY_SPECTRAL_SCAN_ENABLE;
 			REG_WRITE(ah, AR_PHY_SPECTRAL_SCAN, val);
-		}
-		else if (AR_SREV_9271_11(ah))
+		} else if (AR_SREV_9271_11(ah))
 			/*
 			 * change AR_PHY_RF_CTL3 setting to fix MAC issue
 			 * present on AR9271 1.1
@@ -2131,10 +2130,10 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		}
 	} else {
 		/* Configure AR9271 target WLAN */
-                if (AR_SREV_9271(ah))
+		if (AR_SREV_9271(ah))
 			REG_WRITE(ah, AR_CFG, AR_CFG_SWRB | AR_CFG_SWTB);
 #ifdef __BIG_ENDIAN
-                else
+		else
 			REG_WRITE(ah, AR_CFG, AR_CFG_SWTD | AR_CFG_SWRD);
 #endif
 	}
@@ -2437,7 +2436,7 @@ static void ath9k_set_power_sleep(struct ath_hw *ah, int setChip)
 		if (!AR_SREV_9100(ah))
 			REG_WRITE(ah, AR_RC, AR_RC_AHB | AR_RC_HOSTIF);
 
-		if(!AR_SREV_5416(ah))
+		if (!AR_SREV_5416(ah))
 			REG_CLR_BIT(ah, (AR_RTC_RESET),
 				    AR_RTC_RESET_EN);
 	}
@@ -3013,9 +3012,8 @@ void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period)
 	REG_WRITE(ah, AR_NDP_PERIOD, TU_TO_USEC(beacon_period));
 
 	beacon_period &= ~ATH9K_BEACON_ENA;
-	if (beacon_period & ATH9K_BEACON_RESET_TSF) {
+	if (beacon_period & ATH9K_BEACON_RESET_TSF)
 		ath9k_hw_reset_tsf(ah);
-	}
 
 	REG_SET_BIT(ah, AR_TIMER_MODE, flags);
 }
@@ -3677,8 +3675,7 @@ void ath9k_hw_set11nmac2040(struct ath_hw *ah)
 
 /* HW Generic timers configuration */
 
-static const struct ath_gen_timer_configuration gen_tmr_configuration[] =
-{
+static const struct ath_gen_timer_configuration gen_tmr_configuration[] = {
 	{AR_NEXT_NDP_TIMER, AR_NDP_PERIOD, AR_TIMER_MODE, 0x0080},
 	{AR_NEXT_NDP_TIMER, AR_NDP_PERIOD, AR_TIMER_MODE, 0x0080},
 	{AR_NEXT_NDP_TIMER, AR_NDP_PERIOD, AR_TIMER_MODE, 0x0080},
@@ -3869,7 +3866,7 @@ EXPORT_SYMBOL(ath_gen_timer_isr);
 
 static struct {
 	u32 version;
-	const char * name;
+	const char *name;
 } ath_mac_bb_names[] = {
 	/* Devices with external radios */
 	{ AR_SREV_VERSION_5416_PCI,	"5416" },
@@ -3886,7 +3883,7 @@ static struct {
 /* For devices with external radios */
 static struct {
 	u16 version;
-	const char * name;
+	const char *name;
 } ath_rf_names[] = {
 	{ 0,				"5133" },
 	{ AR_RAD5133_SREV_MAJOR,	"5133" },
@@ -3902,10 +3899,9 @@ static const char *ath9k_hw_mac_bb_name(u32 mac_bb_version)
 {
 	int i;
 
-	for (i=0; i<ARRAY_SIZE(ath_mac_bb_names); i++) {
-		if (ath_mac_bb_names[i].version == mac_bb_version) {
+	for (i = 0; i < ARRAY_SIZE(ath_mac_bb_names); i++) {
+		if (ath_mac_bb_names[i].version == mac_bb_version)
 			return ath_mac_bb_names[i].name;
-		}
 	}
 
 	return "????";
@@ -3919,10 +3915,9 @@ static const char *ath9k_hw_rf_name(u16 rf_version)
 {
 	int i;
 
-	for (i=0; i<ARRAY_SIZE(ath_rf_names); i++) {
-		if (ath_rf_names[i].version == rf_version) {
+	for (i = 0; i < ARRAY_SIZE(ath_rf_names); i++) {
+		if (ath_rf_names[i].version == rf_version)
 			return ath_rf_names[i].name;
-		}
 	}
 
 	return "????";
@@ -3938,8 +3933,7 @@ void ath9k_hw_name(struct ath_hw *ah, char *hw_name, size_t len)
 			       "Atheros AR%s Rev:%x",
 			       ath9k_hw_mac_bb_name(ah->hw_version.macVersion),
 			       ah->hw_version.macRev);
-	}
-	else {
+	} else {
 		used = snprintf(hw_name, len,
 			       "Atheros AR%s MAC/BB Rev:%x AR%s RF Rev:%x",
 			       ath9k_hw_mac_bb_name(ah->hw_version.macVersion),
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index dbbf7ca..e596e9a 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -214,17 +214,17 @@ struct ath9k_ops_config {
 	u32 enable_ani;
 	int serialize_regmode;
 	bool rx_intr_mitigation;
-#define SPUR_DISABLE        	0
-#define SPUR_ENABLE_IOCTL   	1
-#define SPUR_ENABLE_EEPROM  	2
-#define AR_EEPROM_MODAL_SPURS   5
-#define AR_SPUR_5413_1      	1640
-#define AR_SPUR_5413_2      	1200
-#define AR_NO_SPUR      	0x8000
-#define AR_BASE_FREQ_2GHZ   	2300
-#define AR_BASE_FREQ_5GHZ   	4900
-#define AR_SPUR_FEEQ_BOUND_HT40 19
-#define AR_SPUR_FEEQ_BOUND_HT20 10
+#define SPUR_DISABLE		0
+#define SPUR_ENABLE_IOCTL	1
+#define SPUR_ENABLE_EEPROM	2
+#define AR_EEPROM_MODAL_SPURS	5
+#define AR_SPUR_5413_1		1640
+#define AR_SPUR_5413_2		1200
+#define AR_NO_SPUR		0x8000
+#define AR_BASE_FREQ_2GHZ	2300
+#define AR_BASE_FREQ_5GHZ	4900
+#define AR_SPUR_FEEQ_BOUND_HT40	19
+#define AR_SPUR_FEEQ_BOUND_HT20	10
 	int spurmode;
 	u16 spurchans[AR_EEPROM_MODAL_SPURS][2];
 	u8 max_txtrig_level;
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 623c2f8..58f19ad 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -104,7 +104,7 @@ static struct ieee80211_channel ath9k_5ghz_chantable[] = {
 
 /* Atheros hardware rate code addition for short premble */
 #define SHPCHECK(__hw_rate, __flags) \
-	((__flags & IEEE80211_RATE_SHORT_PREAMBLE) ? (__hw_rate | 0x04 ) : 0)
+	((__flags & IEEE80211_RATE_SHORT_PREAMBLE) ? (__hw_rate | 0x04) : 0)
 
 #define RATE(_bitrate, _hw_rate, _flags) {              \
 	.bitrate        = (_bitrate),                   \
@@ -626,7 +626,7 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 		IEEE80211_HW_REPORTS_TX_ACK_STATUS;
 
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT)
-		 hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;
+		hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;
 
 	if (AR_SREV_9160_10_OR_LATER(sc->sc_ah) || modparam_nohwcrypt)
 		hw->flags |= IEEE80211_HW_MFP_CAPABLE;
@@ -745,7 +745,7 @@ static void ath9k_deinit_softc(struct ath_softc *sc)
 {
 	int i = 0;
 
-        if ((sc->btcoex.no_stomp_timer) &&
+	if ((sc->btcoex.no_stomp_timer) &&
 	    sc->sc_ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
 		ath_gen_timer_free(sc->sc_ah, sc->btcoex.no_stomp_timer);
 
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 29851e6..e93afc2 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -241,7 +241,7 @@ struct ath_desc {
 #define ATH9K_TXDESC_EXT_ONLY		0x0040
 #define ATH9K_TXDESC_EXT_AND_CTL	0x0080
 #define ATH9K_TXDESC_VMF		0x0100
-#define ATH9K_TXDESC_FRAG_IS_ON 	0x0200
+#define ATH9K_TXDESC_FRAG_IS_ON		0x0200
 #define ATH9K_TXDESC_CAB		0x0400
 
 #define ATH9K_RXDESC_INTREQ		0x0020
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 67ca4e5..770d9aa 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -553,7 +553,7 @@ static u32 ath_get_extchanmode(struct ath_softc *sc,
 
 	switch (chan->band) {
 	case IEEE80211_BAND_2GHZ:
-		switch(channel_type) {
+		switch (channel_type) {
 		case NL80211_CHAN_NO_HT:
 		case NL80211_CHAN_HT20:
 			chanmode = CHANNEL_G_HT20;
@@ -567,7 +567,7 @@ static u32 ath_get_extchanmode(struct ath_softc *sc,
 		}
 		break;
 	case IEEE80211_BAND_5GHZ:
-		switch(channel_type) {
+		switch (channel_type) {
 		case NL80211_CHAN_NO_HT:
 		case NL80211_CHAN_HT20:
 			chanmode = CHANNEL_A_HT20;
@@ -1276,7 +1276,7 @@ static int ath9k_tx(struct ieee80211_hw *hw,
 	/* Add the padding after the header if this is not already done */
 	padpos = ath9k_cmn_padpos(hdr->frame_control);
 	padsize = padpos & 3;
-	if (padsize && skb->len>padpos) {
+	if (padsize && skb->len > padpos) {
 		if (skb_headroom(skb) < padsize)
 			return -1;
 		skb_push(skb, padsize);
@@ -1567,7 +1567,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 			if ((sc->ps_flags & PS_NULLFUNC_COMPLETED)) {
 				sc->ps_flags &= ~PS_NULLFUNC_COMPLETED;
 				ath9k_enable_ps(sc);
-                        }
+			}
 		} else {
 			sc->ps_enabled = false;
 			sc->ps_flags &= ~(PS_ENABLED |
@@ -2042,21 +2042,21 @@ static void ath9k_set_coverage_class(struct ieee80211_hw *hw, u8 coverage_class)
 }
 
 struct ieee80211_ops ath9k_ops = {
-	.tx 		    = ath9k_tx,
-	.start 		    = ath9k_start,
-	.stop 		    = ath9k_stop,
-	.add_interface 	    = ath9k_add_interface,
+	.tx		    = ath9k_tx,
+	.start		    = ath9k_start,
+	.stop		    = ath9k_stop,
+	.add_interface	    = ath9k_add_interface,
 	.remove_interface   = ath9k_remove_interface,
-	.config 	    = ath9k_config,
+	.config		    = ath9k_config,
 	.configure_filter   = ath9k_configure_filter,
 	.sta_add	    = ath9k_sta_add,
 	.sta_remove	    = ath9k_sta_remove,
-	.conf_tx 	    = ath9k_conf_tx,
+	.conf_tx	    = ath9k_conf_tx,
 	.bss_info_changed   = ath9k_bss_info_changed,
 	.set_key            = ath9k_set_key,
-	.get_tsf 	    = ath9k_get_tsf,
-	.set_tsf 	    = ath9k_set_tsf,
-	.reset_tsf 	    = ath9k_reset_tsf,
+	.get_tsf	    = ath9k_get_tsf,
+	.set_tsf	    = ath9k_set_tsf,
+	.reset_tsf	    = ath9k_reset_tsf,
 	.ampdu_action       = ath9k_ampdu_action,
 	.sw_scan_start      = ath9k_sw_scan_start,
 	.sw_scan_complete   = ath9k_sw_scan_complete,
diff --git a/drivers/net/wireless/ath/ath9k/phy.c b/drivers/net/wireless/ath/ath9k/phy.c
index c3b5939..e05ba25 100644
--- a/drivers/net/wireless/ath/ath9k/phy.c
+++ b/drivers/net/wireless/ath/ath9k/phy.c
@@ -116,20 +116,19 @@ int ath9k_hw_ar9280_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 					  txctl | AR_PHY_CCK_TX_CTRL_JAPAN);
 			} else {
 				REG_WRITE(ah, AR_PHY_CCK_TX_CTRL,
-					  txctl &~ AR_PHY_CCK_TX_CTRL_JAPAN);
+					  txctl & ~AR_PHY_CCK_TX_CTRL_JAPAN);
 			}
 		}
 	} else {
 		bMode = 0;
 		fracMode = 0;
 
-		switch(ah->eep_ops->get_eeprom(ah, EEP_FRAC_N_5G)) {
+		switch (ah->eep_ops->get_eeprom(ah, EEP_FRAC_N_5G)) {
 		case 0:
-			if ((freq % 20) == 0) {
+			if ((freq % 20) == 0)
 				aModeRefSel = 3;
-			} else if ((freq % 10) == 0) {
+			else if ((freq % 10) == 0)
 				aModeRefSel = 2;
-			}
 			if (aModeRefSel)
 				break;
 		case 1:
@@ -500,9 +499,8 @@ static void ath9k_hw_force_bias(struct ath_hw *ah, u16 synth_freq)
 	int reg_writes = 0;
 	u32 new_bias = 0;
 
-	if (!AR_SREV_5416(ah) || synth_freq >= 3000) {
+	if (!AR_SREV_5416(ah) || synth_freq >= 3000)
 		return;
-	}
 
 	BUG_ON(AR_SREV_9280_10_OR_LATER(ah));
 
diff --git a/drivers/net/wireless/ath/ath9k/phy.h b/drivers/net/wireless/ath/ath9k/phy.h
index 0999a49..2495e5a 100644
--- a/drivers/net/wireless/ath/ath9k/phy.h
+++ b/drivers/net/wireless/ath/ath9k/phy.h
@@ -56,7 +56,7 @@ bool ath9k_hw_set_rf_regs(struct ath_hw *ah,
 #define AR_PHY_FC_SINGLE_HT_LTF1    0x00000200
 #define AR_PHY_FC_ENABLE_DAC_FIFO   0x00000800
 
-#define AR_PHY_TEST2 		    0x9808
+#define AR_PHY_TEST2		    0x9808
 
 #define AR_PHY_TIMING2           0x9810
 #define AR_PHY_TIMING3           0x9814
@@ -577,7 +577,7 @@ bool ath9k_hw_set_rf_regs(struct ath_hw *ah,
 #define AR_PHY_POWER_TX_RATE8   0xA3D0
 #define AR_PHY_POWER_TX_RATE9   0xA3D4
 
-#define AR_PHY_XPA_CFG  	0xA3D8
+#define AR_PHY_XPA_CFG		0xA3D8
 #define AR_PHY_FORCE_XPA_CFG	0x000000001
 #define AR_PHY_FORCE_XPA_CFG_S	0
 
diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index ac34a05..73766c7 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -506,7 +506,7 @@ static u8 ath_rc_setvalid_htrates(struct ath_rate_priv *ath_rc_priv,
 
 /* Finds the highest rate index we can use */
 static u8 ath_rc_get_highest_rix(struct ath_softc *sc,
-			         struct ath_rate_priv *ath_rc_priv,
+				 struct ath_rate_priv *ath_rc_priv,
 				 const struct ath_rate_table *rate_table,
 				 int *is_probing)
 {
@@ -1073,7 +1073,7 @@ struct ath_rate_table *ath_choose_rate_table(struct ath_softc *sc,
 	int mode = 0;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 
-	switch(band) {
+	switch (band) {
 	case IEEE80211_BAND_2GHZ:
 		mode = ATH9K_MODE_11G;
 		if (is_ht)
@@ -1118,9 +1118,8 @@ static void ath_rc_init(struct ath_softc *sc,
 	ath_rc_priv->rate_table_size = RATE_TABLE_SIZE;
 
 	/* Initialize thresholds according to the global rate table */
-	for (i = 0 ; i < ath_rc_priv->rate_table_size; i++) {
+	for (i = 0 ; i < ath_rc_priv->rate_table_size; i++)
 		ath_rc_priv->per[i] = 0;
-	}
 
 	/* Determine the valid rates */
 	ath_rc_init_valid_txmask(ath_rc_priv);
@@ -1266,7 +1265,7 @@ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
 			tid = qc[0] & 0xf;
 			an = (struct ath_node *)sta->drv_priv;
 
-			if(ath_tx_aggr_check(sc, an, tid))
+			if (ath_tx_aggr_check(sc, an, tid))
 				ieee80211_start_tx_ba_session(sta, tid);
 		}
 	}
@@ -1276,7 +1275,7 @@ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
 }
 
 static void ath_rate_init(void *priv, struct ieee80211_supported_band *sband,
-                          struct ieee80211_sta *sta, void *priv_sta)
+			  struct ieee80211_sta *sta, void *priv_sta)
 {
 	struct ath_softc *sc = priv;
 	struct ath_rate_priv *ath_rc_priv = priv_sta;
@@ -1312,7 +1311,7 @@ static void ath_rate_init(void *priv, struct ieee80211_supported_band *sband,
 	    (sc->sc_ah->opmode == NL80211_IFTYPE_MESH_POINT) ||
 	    (sc->sc_ah->opmode == NL80211_IFTYPE_ADHOC)) {
 		rate_table = ath_choose_rate_table(sc, sband->band,
-		                      sta->ht_cap.ht_supported, is_cw40);
+			     sta->ht_cap.ht_supported, is_cw40);
 	} else {
 		rate_table = hw_rate_table[sc->cur_rate_mode];
 	}
diff --git a/drivers/net/wireless/ath/ath9k/rc.h b/drivers/net/wireless/ath/ath9k/rc.h
index 4f6d6fd..99ce3a7 100644
--- a/drivers/net/wireless/ath/ath9k/rc.h
+++ b/drivers/net/wireless/ath/ath9k/rc.h
@@ -92,14 +92,14 @@ enum {
  * struct ath_rate_table - Rate Control table
  * @valid: valid for use in rate control
  * @valid_single_stream: valid for use in rate control for
- * 	single stream operation
+ *	single stream operation
  * @phy: CCK/OFDM
  * @ratekbps: rate in Kbits per second
  * @user_ratekbps: user rate in Kbits per second
  * @ratecode: rate that goes into HW descriptors
  * @short_preamble: Mask for enabling short preamble in ratecode for CCK
  * @dot11rate: value that goes into supported
- * 	rates info element of MLME
+ *	rates info element of MLME
  * @ctrl_rate: Index of next lower basic rate, used for duration computation
  * @max_4ms_framelen: maximum frame length(bytes) for tx duration
  * @probe_interval: interval for rate control to probe for other rates
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 1ca42e5..3e1e9f4 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -16,7 +16,7 @@
 
 #include "ath9k.h"
 
-static struct ieee80211_hw * ath_get_virt_hw(struct ath_softc *sc,
+static struct ieee80211_hw *ath_get_virt_hw(struct ath_softc *sc,
 					     struct ieee80211_hdr *hdr)
 {
 	struct ieee80211_hw *hw = sc->pri_wiphy->hw;
@@ -547,9 +547,8 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 			tds = tbf->bf_desc;
 			retval = ath9k_hw_rxprocdesc(ah, tds, tbf->bf_daddr,
 					     PA2DESC(sc, tds->ds_link), 0);
-			if (retval == -EINPROGRESS) {
+			if (retval == -EINPROGRESS)
 				break;
-			}
 		}
 
 		skb = bf->bf_mpdu;
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 72cfa8e..525b35f 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -677,11 +677,11 @@
 #define AR_RC_APB            0x00000002
 #define AR_RC_HOSTIF         0x00000100
 
-#define AR_WA                		0x4004
+#define AR_WA				0x4004
 #define AR_WA_D3_L1_DISABLE		(1 << 14)
-#define AR9285_WA_DEFAULT 		0x004a05cb
-#define AR9280_WA_DEFAULT           	0x0040073b
-#define AR_WA_DEFAULT               	0x0000073f
+#define AR9285_WA_DEFAULT		0x004a05cb
+#define AR9280_WA_DEFAULT		0x0040073b
+#define AR_WA_DEFAULT			0x0000073f
 
 
 #define AR_PM_STATE                 0x4008
@@ -726,14 +726,14 @@
 #define AR_SREV_REVISION                      0x00000007
 
 #define AR_SREV_ID2                           0xFFFFFFFF
-#define AR_SREV_VERSION2        	      0xFFFC0000
+#define AR_SREV_VERSION2		      0xFFFC0000
 #define AR_SREV_VERSION2_S                    18
-#define AR_SREV_TYPE2        	      	      0x0003F000
+#define AR_SREV_TYPE2			      0x0003F000
 #define AR_SREV_TYPE2_S                       12
 #define AR_SREV_TYPE2_CHAIN		      0x00001000
 #define AR_SREV_TYPE2_HOST_MODE		      0x00002000
-#define AR_SREV_REVISION2        	      0x00000F00
-#define AR_SREV_REVISION2_S     	      8
+#define AR_SREV_REVISION2		      0x00000F00
+#define AR_SREV_REVISION2_S		      8
 
 #define AR_SREV_VERSION_5416_PCI               0xD
 #define AR_SREV_VERSION_5416_PCIE              0xC
@@ -741,9 +741,9 @@
 #define AR_SREV_REVISION_5416_20               1
 #define AR_SREV_REVISION_5416_22               2
 #define AR_SREV_VERSION_9100                  0x14
-#define AR_SREV_VERSION_9160        	      0x40
-#define AR_SREV_REVISION_9160_10    	      0
-#define AR_SREV_REVISION_9160_11    	      1
+#define AR_SREV_VERSION_9160		      0x40
+#define AR_SREV_REVISION_9160_10	      0
+#define AR_SREV_REVISION_9160_11	      1
 #define AR_SREV_VERSION_9280                0x80
 #define AR_SREV_REVISION_9280_10            0
 #define AR_SREV_REVISION_9280_20            1
diff --git a/drivers/net/wireless/ath/ath9k/virtual.c b/drivers/net/wireless/ath/ath9k/virtual.c
index a43fbf8..d385fdb 100644
--- a/drivers/net/wireless/ath/ath9k/virtual.c
+++ b/drivers/net/wireless/ath/ath9k/virtual.c
@@ -506,8 +506,7 @@ int ath9k_wiphy_select(struct ath_wiphy *aphy)
 		if (sc->wiphy_select_failures == 0)
 			sc->wiphy_select_first_fail = jiffies;
 		sc->wiphy_select_failures++;
-		if (time_after(jiffies, sc->wiphy_select_first_fail + HZ / 2))
-		{
+		if (time_after(jiffies, sc->wiphy_select_first_fail + HZ / 2)) {
 			printk(KERN_DEBUG "ath9k: Previous wiphy select timed "
 			       "out; disable/enable hw to recover\n");
 			__ath9k_wiphy_mark_all_paused(sc);
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 47294f9..7175a5c 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -31,7 +31,7 @@
 #define NUM_SYMBOLS_PER_USEC(_usec) (_usec >> 2)
 #define NUM_SYMBOLS_PER_USEC_HALFGI(_usec) (((_usec*5)-4)/18)
 
-#define OFDM_SIFS_TIME    	    16
+#define OFDM_SIFS_TIME		16
 
 static u32 bits_per_symbol[][2] = {
 	/* 20MHz 40MHz */
@@ -259,7 +259,7 @@ static void ath_tx_set_retry(struct ath_softc *sc, struct ath_txq *txq,
 	hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_RETRY);
 }
 
-static struct ath_buf* ath_clone_txbuf(struct ath_softc *sc, struct ath_buf *bf)
+static struct ath_buf *ath_clone_txbuf(struct ath_softc *sc, struct ath_buf *bf)
 {
 	struct ath_buf *tbf;
 
@@ -1606,9 +1606,8 @@ static int ath_tx_setup_buffer(struct ieee80211_hw *hw, struct ath_buf *bf,
 	/* Remove the padding size from bf_frmlen, if any */
 	padpos = ath9k_cmn_padpos(hdr->frame_control);
 	padsize = padpos & 3;
-	if (padsize && skb->len>padpos+padsize) {
+	if (padsize && skb->len > padpos + padsize)
 		bf->bf_frmlen -= padsize;
-	}
 
 	if (conf_is_ht(&hw->conf))
 		bf->bf_state.bf_type |= BUF_HT;
@@ -1790,7 +1789,7 @@ void ath_tx_cabq(struct ieee80211_hw *hw, struct sk_buff *skb)
 	/* Add the padding after the header if this is not already done */
 	padpos = ath9k_cmn_padpos(hdr->frame_control);
 	padsize = padpos & 3;
-	if (padsize && skb->len>padpos) {
+	if (padsize && skb->len > padpos) {
 		if (skb_headroom(skb) < padsize) {
 			ath_print(common, ATH_DBG_XMIT,
 				  "TX CABQ padding failed\n");
@@ -1844,7 +1843,7 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 
 	padpos = ath9k_cmn_padpos(hdr->frame_control);
 	padsize = padpos & 3;
-	if (padsize && skb->len>padpos+padsize) {
+	if (padsize && skb->len > padpos + padsize) {
 		/*
 		 * Remove MAC header padding before giving the frame back to
 		 * mac80211.
-- 
1.6.3.3

