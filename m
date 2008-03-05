Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:27986 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758998AbYCEJ5g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 04:57:36 -0500
From: Bruno Randolf <bruno@thinktube.com>
Subject: [PATCH] ath5k: struct ath5k_desc cleanups
To: ath5k-devel@lists.ath5k.org
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Wed, 05 Mar 2008 18:57:13 +0900
Message-ID: <20080305095706.6841.24975.stgit@one> (sfid-20080305_095746_831928_35D689EA)
In-Reply-To: <20080305093523.5670.38030.stgit@one>
References: <20080305093523.5670.38030.stgit@one>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* make struct ath5k_desc clearer by directly including unions of structures,
  which correspond to the hardware descriptors of different HW versions (5210
  and 5212). before they were casted at onto ath5k_desc at different points
  (e.g.  ds_hw[2]).

* rename some structures and variable names to make their use clearer, e.g.
  struct ath5k_hw_4w_tx_desc to ath5k_hw_4w_tx_ctl.

* substitute "old" with "5210" and "new" with "5212" (eg. rename
  ath5k_hw_proc_new_rx_status() to ath5k_hw_proc_5212_rx_status()) because old
  and new are relative and we might have a newer structure at some point.

* unify structs ath5k_hw_old_rx_status and ath5k_hw_new_rx_status into one
  ath5k_hw_rx_status, because they only differ in the flags and masks.

drivers/net/wireless/ath5k/ath5k.h:     Changes-licensed-under: ISC
drivers/net/wireless/ath5k/debug.c:     Changes-licensed-under: GPL
drivers/net/wireless/ath5k/hw.c:        Changes-licensed-under: ISC
drivers/net/wireless/ath5k/hw.h:        Changes-licensed-under: ISC

Signed-off-by: Bruno Randolf <bruno@thinktube.com>
---

 drivers/net/wireless/ath5k/ath5k.h |   23 ++--
 drivers/net/wireless/ath5k/debug.c |   12 +-
 drivers/net/wireless/ath5k/hw.c    |  212 +++++++++++++++++-------------------
 drivers/net/wireless/ath5k/hw.h    |  150 +++++++++++++++----------
 4 files changed, 210 insertions(+), 187 deletions(-)


diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index 18223d9..e2f889b 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -268,12 +268,13 @@ enum ath5k_driver_mode {
 #define SHPREAMBLE_FLAG(_ix) \
 	(HAS_SHPREAMBLE(_ix) ? AR5K_SET_SHORT_PREAMBLE : 0)
 
+
 /****************\
   TX DEFINITIONS
 \****************/
 
 /*
- * Tx Descriptor
+ * TX Status
  */
 struct ath5k_tx_status {
 	u16	ts_seqnum;
@@ -421,7 +422,7 @@ enum ath5k_dmasize {
 \****************/
 
 /*
- * Rx Descriptor
+ * RX Status
  */
 struct ath5k_rx_status {
 	u16	rs_datalen;
@@ -452,8 +453,6 @@ struct ath5k_mib_stats {
 };
 
 
-
-
 /**************************\
  BEACON TIMERS DEFINITIONS
 \**************************/
@@ -495,20 +494,22 @@ struct ath5k_beacon_state {
 #define TSF_TO_TU(_tsf) (u32)((_tsf) >> 10)
 
 
-
 /********************\
   COMMON DEFINITIONS
 \********************/
 
 /*
- * Atheros descriptor
+ * Atheros hardware descriptor
  */
 struct ath5k_desc {
-	u32	ds_link;
-	u32	ds_data;
-	u32	ds_ctl0;
-	u32	ds_ctl1;
-	u32	ds_hw[4];
+	u32	ds_link;	/* physical address of the next descriptor */
+	u32	ds_data;	/* physical address of data buffer (skb) */
+
+	union {
+		struct ath5k_hw_5210_tx_desc	ds_tx5210;
+		struct ath5k_hw_5212_tx_desc	ds_tx5212;
+		struct ath5k_hw_all_rx_desc	ds_rx;
+	} ud;
 
 	union {
 		struct ath5k_rx_status rx;
diff --git a/drivers/net/wireless/ath5k/debug.c b/drivers/net/wireless/ath5k/debug.c
index 05bf4fb..9301494 100644
--- a/drivers/net/wireless/ath5k/debug.c
+++ b/drivers/net/wireless/ath5k/debug.c
@@ -500,11 +500,13 @@ static inline void
 ath5k_debug_printrxbuf(struct ath5k_buf *bf, int done)
 {
 	struct ath5k_desc *ds = bf->desc;
+	struct ath5k_hw_all_rx_desc *rd = &ds->ud.ds_rx;
 
 	printk(KERN_DEBUG "R (%p %llx) %08x %08x %08x %08x %08x %08x %c\n",
 		ds, (unsigned long long)bf->daddr,
-		ds->ds_link, ds->ds_data, ds->ds_ctl0, ds->ds_ctl1,
-		ds->ds_hw[0], ds->ds_hw[1],
+		ds->ds_link, ds->ds_data,
+		rd->rx_ctl.rx_control_0, rd->rx_ctl.rx_control_1,
+		rd->u.rx_stat.rx_status_0, rd->u.rx_stat.rx_status_0,
 		!done ? ' ' : (ds->ds_rxstat.rs_status == 0) ? '*' : '!');
 }
 
@@ -554,14 +556,16 @@ ath5k_debug_printtxbuf(struct ath5k_softc *sc,
 			struct ath5k_buf *bf, int done)
 {
 	struct ath5k_desc *ds = bf->desc;
+	struct ath5k_hw_5212_tx_desc *td = &ds->ud.ds_tx5212;
 
 	if (likely(!(sc->debug.level & ATH5K_DEBUG_RESET)))
 		return;
 
 	printk(KERN_DEBUG "T (%p %llx) %08x %08x %08x %08x %08x %08x %08x "
 		"%08x %c\n", ds, (unsigned long long)bf->daddr, ds->ds_link,
-		ds->ds_data, ds->ds_ctl0, ds->ds_ctl1,
-		ds->ds_hw[0], ds->ds_hw[1], ds->ds_hw[2], ds->ds_hw[3],
+		ds->ds_data, td->tx_ctl.tx_control_0, td->tx_ctl.tx_control_1,
+		td->tx_ctl.tx_control_2, td->tx_ctl.tx_control_3,
+		td->tx_stat.tx_status_0, td->tx_stat.tx_status_1,
 		!done ? ' ' : (ds->ds_txstat.ts_status == 0) ? '*' : '!');
 }
 
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index eec2b80..bcd6041 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -54,8 +54,8 @@ static int ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *, struct ath5k_desc *,
 	unsigned int, unsigned int, unsigned int, unsigned int, unsigned int,
 	unsigned int, unsigned int);
 static int ath5k_hw_proc_2word_tx_status(struct ath5k_hw *, struct ath5k_desc *);
-static int ath5k_hw_proc_new_rx_status(struct ath5k_hw *, struct ath5k_desc *);
-static int ath5k_hw_proc_old_rx_status(struct ath5k_hw *, struct ath5k_desc *);
+static int ath5k_hw_proc_5212_rx_status(struct ath5k_hw *, struct ath5k_desc *);
+static int ath5k_hw_proc_5210_rx_status(struct ath5k_hw *, struct ath5k_desc *);
 static int ath5k_hw_get_capabilities(struct ath5k_hw *);
 
 static int ath5k_eeprom_init(struct ath5k_hw *);
@@ -174,9 +174,9 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 	}
 
 	if (ah->ah_version == AR5K_AR5212)
-		ah->ah_proc_rx_desc = ath5k_hw_proc_new_rx_status;
+		ah->ah_proc_rx_desc = ath5k_hw_proc_5212_rx_status;
 	else if (ah->ah_version <= AR5K_AR5211)
-		ah->ah_proc_rx_desc = ath5k_hw_proc_old_rx_status;
+		ah->ah_proc_rx_desc = ath5k_hw_proc_5210_rx_status;
 
 	/* Bring device out of sleep and reset it's units */
 	ret = ath5k_hw_nic_wakeup(ah, AR5K_INIT_MODE, true);
@@ -3456,10 +3456,10 @@ ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 	unsigned int rtscts_rate, unsigned int rtscts_duration)
 {
 	u32 frame_type;
-	struct ath5k_hw_2w_tx_desc *tx_desc;
+	struct ath5k_hw_2w_tx_ctl *tx_ctl;
 	unsigned int frame_len;
 
-	tx_desc = (struct ath5k_hw_2w_tx_desc *)&desc->ds_ctl0;
+	tx_ctl = &desc->ud.ds_tx5210.tx_ctl;
 
 	/*
 	 * Validate input
@@ -3478,12 +3478,8 @@ ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 		return -EINVAL;
 	}
 
-	/* Clear status descriptor */
-	memset(desc->ds_hw, 0, sizeof(struct ath5k_hw_tx_status));
-
-	/* Initialize control descriptor */
-	tx_desc->tx_control_0 = 0;
-	tx_desc->tx_control_1 = 0;
+	/* Clear descriptor */
+	memset(&desc->ud.ds_tx5210, 0, sizeof(struct ath5k_hw_5210_tx_desc));
 
 	/* Setup control descriptor */
 
@@ -3495,7 +3491,7 @@ ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 	if (frame_len & ~AR5K_2W_TX_DESC_CTL0_FRAME_LEN)
 		return -EINVAL;
 
-	tx_desc->tx_control_0 = frame_len & AR5K_2W_TX_DESC_CTL0_FRAME_LEN;
+	tx_ctl->tx_control_0 = frame_len & AR5K_2W_TX_DESC_CTL0_FRAME_LEN;
 
 	/* Verify and set buffer length */
 
@@ -3506,7 +3502,7 @@ ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 	if (pkt_len & ~AR5K_2W_TX_DESC_CTL1_BUF_LEN)
 		return -EINVAL;
 
-	tx_desc->tx_control_1 = pkt_len & AR5K_2W_TX_DESC_CTL1_BUF_LEN;
+	tx_ctl->tx_control_1 = pkt_len & AR5K_2W_TX_DESC_CTL1_BUF_LEN;
 
 	/*
 	 * Verify and set header length
@@ -3515,7 +3511,7 @@ ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 	if (ah->ah_version == AR5K_AR5210) {
 		if (hdr_len & ~AR5K_2W_TX_DESC_CTL0_HEADER_LEN)
 			return -EINVAL;
-		tx_desc->tx_control_0 |=
+		tx_ctl->tx_control_0 |=
 			AR5K_REG_SM(hdr_len, AR5K_2W_TX_DESC_CTL0_HEADER_LEN);
 	}
 
@@ -3531,19 +3527,19 @@ ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 			frame_type = type /*<< 2 ?*/;
 		}
 
-		tx_desc->tx_control_0 |=
+		tx_ctl->tx_control_0 |=
 			AR5K_REG_SM(frame_type, AR5K_2W_TX_DESC_CTL0_FRAME_TYPE) |
 			AR5K_REG_SM(tx_rate0, AR5K_2W_TX_DESC_CTL0_XMIT_RATE);
 	} else {
-		tx_desc->tx_control_0 |=
+		tx_ctl->tx_control_0 |=
 			AR5K_REG_SM(tx_rate0, AR5K_2W_TX_DESC_CTL0_XMIT_RATE) |
 			AR5K_REG_SM(antenna_mode, AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT);
-		tx_desc->tx_control_1 |=
+		tx_ctl->tx_control_1 |=
 			AR5K_REG_SM(type, AR5K_2W_TX_DESC_CTL1_FRAME_TYPE);
 	}
 #define _TX_FLAGS(_c, _flag)						\
 	if (flags & AR5K_TXDESC_##_flag)				\
-		tx_desc->tx_control_##_c |=				\
+		tx_ctl->tx_control_##_c |=				\
 			AR5K_2W_TX_DESC_CTL##_c##_##_flag
 
 	_TX_FLAGS(0, CLRDMASK);
@@ -3558,9 +3554,9 @@ ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 	 * WEP crap
 	 */
 	if (key_index != AR5K_TXKEYIX_INVALID) {
-		tx_desc->tx_control_0 |=
+		tx_ctl->tx_control_0 |=
 			AR5K_2W_TX_DESC_CTL0_ENCRYPT_KEY_VALID;
-		tx_desc->tx_control_1 |=
+		tx_ctl->tx_control_1 |=
 			AR5K_REG_SM(key_index,
 			AR5K_2W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX);
 	}
@@ -3570,7 +3566,7 @@ ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 	 */
 	if ((ah->ah_version == AR5K_AR5210) &&
 			(flags & (AR5K_TXDESC_RTSENA | AR5K_TXDESC_CTSENA)))
-		tx_desc->tx_control_1 |= rtscts_duration &
+		tx_ctl->tx_control_1 |= rtscts_duration &
 				AR5K_2W_TX_DESC_CTL1_RTS_DURATION;
 
 	return 0;
@@ -3586,13 +3582,11 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
 	unsigned int antenna_mode, unsigned int flags, unsigned int rtscts_rate,
 	unsigned int rtscts_duration)
 {
-	struct ath5k_hw_4w_tx_desc *tx_desc;
-	struct ath5k_hw_tx_status *tx_status;
+	struct ath5k_hw_4w_tx_ctl *tx_ctl;
 	unsigned int frame_len;
 
 	ATH5K_TRACE(ah->ah_sc);
-	tx_desc = (struct ath5k_hw_4w_tx_desc *)&desc->ds_ctl0;
-	tx_status = (struct ath5k_hw_tx_status *)&desc->ds_hw[2];
+	tx_ctl = &desc->ud.ds_tx5212.tx_ctl;
 
 	/*
 	 * Validate input
@@ -3611,14 +3605,8 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
 		return -EINVAL;
 	}
 
-	/* Clear status descriptor */
-	memset(tx_status, 0, sizeof(struct ath5k_hw_tx_status));
-
-	/* Initialize control descriptor */
-	tx_desc->tx_control_0 = 0;
-	tx_desc->tx_control_1 = 0;
-	tx_desc->tx_control_2 = 0;
-	tx_desc->tx_control_3 = 0;
+	/* Clear descriptor */
+	memset(&desc->ud.ds_tx5212, 0, sizeof(struct ath5k_hw_5212_tx_desc));
 
 	/* Setup control descriptor */
 
@@ -3630,7 +3618,7 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
 	if (frame_len & ~AR5K_4W_TX_DESC_CTL0_FRAME_LEN)
 		return -EINVAL;
 
-	tx_desc->tx_control_0 = frame_len & AR5K_4W_TX_DESC_CTL0_FRAME_LEN;
+	tx_ctl->tx_control_0 = frame_len & AR5K_4W_TX_DESC_CTL0_FRAME_LEN;
 
 	/* Verify and set buffer length */
 
@@ -3641,20 +3629,20 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
 	if (pkt_len & ~AR5K_4W_TX_DESC_CTL1_BUF_LEN)
 		return -EINVAL;
 
-	tx_desc->tx_control_1 = pkt_len & AR5K_4W_TX_DESC_CTL1_BUF_LEN;
+	tx_ctl->tx_control_1 = pkt_len & AR5K_4W_TX_DESC_CTL1_BUF_LEN;
 
-	tx_desc->tx_control_0 |=
+	tx_ctl->tx_control_0 |=
 		AR5K_REG_SM(tx_power, AR5K_4W_TX_DESC_CTL0_XMIT_POWER) |
 		AR5K_REG_SM(antenna_mode, AR5K_4W_TX_DESC_CTL0_ANT_MODE_XMIT);
-	tx_desc->tx_control_1 |= AR5K_REG_SM(type,
+	tx_ctl->tx_control_1 |= AR5K_REG_SM(type,
 					AR5K_4W_TX_DESC_CTL1_FRAME_TYPE);
-	tx_desc->tx_control_2 = AR5K_REG_SM(tx_tries0 + AR5K_TUNE_HWTXTRIES,
+	tx_ctl->tx_control_2 = AR5K_REG_SM(tx_tries0 + AR5K_TUNE_HWTXTRIES,
 					AR5K_4W_TX_DESC_CTL2_XMIT_TRIES0);
-	tx_desc->tx_control_3 = tx_rate0 & AR5K_4W_TX_DESC_CTL3_XMIT_RATE0;
+	tx_ctl->tx_control_3 = tx_rate0 & AR5K_4W_TX_DESC_CTL3_XMIT_RATE0;
 
 #define _TX_FLAGS(_c, _flag)			\
 	if (flags & AR5K_TXDESC_##_flag)	\
-		tx_desc->tx_control_##_c |=	\
+		tx_ctl->tx_control_##_c |=	\
 			AR5K_4W_TX_DESC_CTL##_c##_##_flag
 
 	_TX_FLAGS(0, CLRDMASK);
@@ -3670,8 +3658,8 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
 	 * WEP crap
 	 */
 	if (key_index != AR5K_TXKEYIX_INVALID) {
-		tx_desc->tx_control_0 |= AR5K_4W_TX_DESC_CTL0_ENCRYPT_KEY_VALID;
-		tx_desc->tx_control_1 |= AR5K_REG_SM(key_index,
+		tx_ctl->tx_control_0 |= AR5K_4W_TX_DESC_CTL0_ENCRYPT_KEY_VALID;
+		tx_ctl->tx_control_1 |= AR5K_REG_SM(key_index,
 				AR5K_4W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX);
 	}
 
@@ -3682,9 +3670,9 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
 		if ((flags & AR5K_TXDESC_RTSENA) &&
 				(flags & AR5K_TXDESC_CTSENA))
 			return -EINVAL;
-		tx_desc->tx_control_2 |= rtscts_duration &
+		tx_ctl->tx_control_2 |= rtscts_duration &
 				AR5K_4W_TX_DESC_CTL2_RTS_DURATION;
-		tx_desc->tx_control_3 |= AR5K_REG_SM(rtscts_rate,
+		tx_ctl->tx_control_3 |= AR5K_REG_SM(rtscts_rate,
 				AR5K_4W_TX_DESC_CTL3_RTS_CTS_RATE);
 	}
 
@@ -3699,7 +3687,7 @@ ath5k_hw_setup_xr_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 	unsigned int tx_rate1, u_int tx_tries1, u_int tx_rate2, u_int tx_tries2,
 	unsigned int tx_rate3, u_int tx_tries3)
 {
-	struct ath5k_hw_4w_tx_desc *tx_desc;
+	struct ath5k_hw_4w_tx_ctl *tx_ctl;
 
 	/*
 	 * Rates can be 0 as long as the retry count is 0 too.
@@ -3716,14 +3704,14 @@ ath5k_hw_setup_xr_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 	}
 
 	if (ah->ah_version == AR5K_AR5212) {
-		tx_desc = (struct ath5k_hw_4w_tx_desc *)&desc->ds_ctl0;
+		tx_ctl = &desc->ud.ds_tx5212.tx_ctl;
 
 #define _XTX_TRIES(_n)							\
 	if (tx_tries##_n) {						\
-		tx_desc->tx_control_2 |=				\
+		tx_ctl->tx_control_2 |=				\
 		    AR5K_REG_SM(tx_tries##_n,				\
 		    AR5K_4W_TX_DESC_CTL2_XMIT_TRIES##_n);		\
-		tx_desc->tx_control_3 |=				\
+		tx_ctl->tx_control_3 |=				\
 		    AR5K_REG_SM(tx_rate##_n,				\
 		    AR5K_4W_TX_DESC_CTL3_XMIT_RATE##_n);		\
 	}
@@ -3746,11 +3734,13 @@ ath5k_hw_setup_xr_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 static int ath5k_hw_proc_2word_tx_status(struct ath5k_hw *ah,
 		struct ath5k_desc *desc)
 {
+	struct ath5k_hw_2w_tx_ctl *tx_ctl;
 	struct ath5k_hw_tx_status *tx_status;
-	struct ath5k_hw_2w_tx_desc *tx_desc;
 
-	tx_desc = (struct ath5k_hw_2w_tx_desc *)&desc->ds_ctl0;
-	tx_status = (struct ath5k_hw_tx_status *)&desc->ds_hw[0];
+	ATH5K_TRACE(ah->ah_sc);
+
+	tx_ctl = &desc->ud.ds_tx5210.tx_ctl;
+	tx_status = &desc->ud.ds_tx5210.tx_stat;
 
 	/* No frame has been send or error */
 	if (unlikely((tx_status->tx_status_1 & AR5K_DESC_TX_STATUS1_DONE) == 0))
@@ -3772,7 +3762,7 @@ static int ath5k_hw_proc_2word_tx_status(struct ath5k_hw *ah,
 		AR5K_DESC_TX_STATUS1_ACK_SIG_STRENGTH);
 	desc->ds_us.tx.ts_antenna = 1;
 	desc->ds_us.tx.ts_status = 0;
-	desc->ds_us.tx.ts_rate = AR5K_REG_MS(tx_desc->tx_control_0,
+	desc->ds_us.tx.ts_rate = AR5K_REG_MS(tx_ctl->tx_control_0,
 		AR5K_2W_TX_DESC_CTL0_XMIT_RATE);
 
 	if ((tx_status->tx_status_0 & AR5K_DESC_TX_STATUS0_FRAME_XMIT_OK) == 0){
@@ -3796,12 +3786,13 @@ static int ath5k_hw_proc_2word_tx_status(struct ath5k_hw *ah,
 static int ath5k_hw_proc_4word_tx_status(struct ath5k_hw *ah,
 		struct ath5k_desc *desc)
 {
+	struct ath5k_hw_4w_tx_ctl *tx_ctl;
 	struct ath5k_hw_tx_status *tx_status;
-	struct ath5k_hw_4w_tx_desc *tx_desc;
 
 	ATH5K_TRACE(ah->ah_sc);
-	tx_desc = (struct ath5k_hw_4w_tx_desc *)&desc->ds_ctl0;
-	tx_status = (struct ath5k_hw_tx_status *)&desc->ds_hw[2];
+
+	tx_ctl = &desc->ud.ds_tx5212.tx_ctl;
+	tx_status = &desc->ud.ds_tx5212.tx_stat;
 
 	/* No frame has been send or error */
 	if (unlikely((tx_status->tx_status_1 & AR5K_DESC_TX_STATUS1_DONE) == 0))
@@ -3827,25 +3818,25 @@ static int ath5k_hw_proc_4word_tx_status(struct ath5k_hw *ah,
 	switch (AR5K_REG_MS(tx_status->tx_status_1,
 			AR5K_DESC_TX_STATUS1_FINAL_TS_INDEX)) {
 	case 0:
-		desc->ds_us.tx.ts_rate = tx_desc->tx_control_3 &
+		desc->ds_us.tx.ts_rate = tx_ctl->tx_control_3 &
 			AR5K_4W_TX_DESC_CTL3_XMIT_RATE0;
 		break;
 	case 1:
-		desc->ds_us.tx.ts_rate = AR5K_REG_MS(tx_desc->tx_control_3,
+		desc->ds_us.tx.ts_rate = AR5K_REG_MS(tx_ctl->tx_control_3,
 			AR5K_4W_TX_DESC_CTL3_XMIT_RATE1);
-		desc->ds_us.tx.ts_longretry +=AR5K_REG_MS(tx_desc->tx_control_2,
+		desc->ds_us.tx.ts_longretry += AR5K_REG_MS(tx_ctl->tx_control_2,
 			AR5K_4W_TX_DESC_CTL2_XMIT_TRIES1);
 		break;
 	case 2:
-		desc->ds_us.tx.ts_rate = AR5K_REG_MS(tx_desc->tx_control_3,
+		desc->ds_us.tx.ts_rate = AR5K_REG_MS(tx_ctl->tx_control_3,
 			AR5K_4W_TX_DESC_CTL3_XMIT_RATE2);
-		desc->ds_us.tx.ts_longretry +=AR5K_REG_MS(tx_desc->tx_control_2,
+		desc->ds_us.tx.ts_longretry += AR5K_REG_MS(tx_ctl->tx_control_2,
 			AR5K_4W_TX_DESC_CTL2_XMIT_TRIES2);
 		break;
 	case 3:
-		desc->ds_us.tx.ts_rate = AR5K_REG_MS(tx_desc->tx_control_3,
+		desc->ds_us.tx.ts_rate = AR5K_REG_MS(tx_ctl->tx_control_3,
 			AR5K_4W_TX_DESC_CTL3_XMIT_RATE3);
-		desc->ds_us.tx.ts_longretry +=AR5K_REG_MS(tx_desc->tx_control_2,
+		desc->ds_us.tx.ts_longretry += AR5K_REG_MS(tx_ctl->tx_control_2,
 			AR5K_4W_TX_DESC_CTL2_XMIT_TRIES3);
 		break;
 	}
@@ -3875,31 +3866,27 @@ static int ath5k_hw_proc_4word_tx_status(struct ath5k_hw *ah,
 int ath5k_hw_setup_rx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 			u32 size, unsigned int flags)
 {
-	struct ath5k_rx_desc *rx_desc;
+	struct ath5k_hw_rx_ctl *rx_ctl;
 
 	ATH5K_TRACE(ah->ah_sc);
-	rx_desc = (struct ath5k_rx_desc *)&desc->ds_ctl0;
+	rx_ctl = &desc->ud.ds_rx.rx_ctl;
 
 	/*
-	 *Clear ds_hw
+	 * Clear the descriptor
 	 * If we don't clean the status descriptor,
 	 * while scanning we get too many results,
 	 * most of them virtual, after some secs
 	 * of scanning system hangs. M.F.
 	*/
-	memset(desc->ds_hw, 0, sizeof(desc->ds_hw));
-
-	/*Initialize rx descriptor*/
-	rx_desc->rx_control_0 = 0;
-	rx_desc->rx_control_1 = 0;
+	memset(&desc->ud.ds_rx, 0, sizeof(struct ath5k_hw_all_rx_desc));
 
 	/* Setup descriptor */
-	rx_desc->rx_control_1 = size & AR5K_DESC_RX_CTL1_BUF_LEN;
-	if (unlikely(rx_desc->rx_control_1 != size))
+	rx_ctl->rx_control_1 = size & AR5K_DESC_RX_CTL1_BUF_LEN;
+	if (unlikely(rx_ctl->rx_control_1 != size))
 		return -EINVAL;
 
 	if (flags & AR5K_RXDESC_INTREQ)
-		rx_desc->rx_control_1 |= AR5K_DESC_RX_CTL1_INTREQ;
+		rx_ctl->rx_control_1 |= AR5K_DESC_RX_CTL1_INTREQ;
 
 	return 0;
 }
@@ -3907,15 +3894,15 @@ int ath5k_hw_setup_rx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 /*
  * Proccess the rx status descriptor on 5210/5211
  */
-static int ath5k_hw_proc_old_rx_status(struct ath5k_hw *ah,
+static int ath5k_hw_proc_5210_rx_status(struct ath5k_hw *ah,
 		struct ath5k_desc *desc)
 {
-	struct ath5k_hw_old_rx_status *rx_status;
+	struct ath5k_hw_rx_status *rx_status;
 
-	rx_status = (struct ath5k_hw_old_rx_status *)&desc->ds_hw[0];
+	rx_status = &desc->ud.ds_rx.u.rx_stat;
 
 	/* No frame received / not ready */
-	if (unlikely((rx_status->rx_status_1 & AR5K_OLD_RX_DESC_STATUS1_DONE)
+	if (unlikely((rx_status->rx_status_1 & AR5K_5210_RX_DESC_STATUS1_DONE)
 				== 0))
 		return -EINPROGRESS;
 
@@ -3923,50 +3910,51 @@ static int ath5k_hw_proc_old_rx_status(struct ath5k_hw *ah,
 	 * Frame receive status
 	 */
 	desc->ds_us.rx.rs_datalen = rx_status->rx_status_0 &
-		AR5K_OLD_RX_DESC_STATUS0_DATA_LEN;
+		AR5K_5210_RX_DESC_STATUS0_DATA_LEN;
 	desc->ds_us.rx.rs_rssi = AR5K_REG_MS(rx_status->rx_status_0,
-		AR5K_OLD_RX_DESC_STATUS0_RECEIVE_SIGNAL);
+		AR5K_5210_RX_DESC_STATUS0_RECEIVE_SIGNAL);
 	desc->ds_us.rx.rs_rate = AR5K_REG_MS(rx_status->rx_status_0,
-		AR5K_OLD_RX_DESC_STATUS0_RECEIVE_RATE);
+		AR5K_5210_RX_DESC_STATUS0_RECEIVE_RATE);
 	desc->ds_us.rx.rs_antenna = rx_status->rx_status_0 &
-		AR5K_OLD_RX_DESC_STATUS0_RECEIVE_ANTENNA;
+		AR5K_5210_RX_DESC_STATUS0_RECEIVE_ANTENNA;
 	desc->ds_us.rx.rs_more = rx_status->rx_status_0 &
-		AR5K_OLD_RX_DESC_STATUS0_MORE;
+		AR5K_5210_RX_DESC_STATUS0_MORE;
 	desc->ds_us.rx.rs_tstamp = AR5K_REG_MS(rx_status->rx_status_1,
-		AR5K_OLD_RX_DESC_STATUS1_RECEIVE_TIMESTAMP);
+		AR5K_5210_RX_DESC_STATUS1_RECEIVE_TIMESTAMP);
 	desc->ds_us.rx.rs_status = 0;
 
 	/*
 	 * Key table status
 	 */
-	if (rx_status->rx_status_1 & AR5K_OLD_RX_DESC_STATUS1_KEY_INDEX_VALID)
+	if (rx_status->rx_status_1 & AR5K_5210_RX_DESC_STATUS1_KEY_INDEX_VALID)
 		desc->ds_us.rx.rs_keyix = AR5K_REG_MS(rx_status->rx_status_1,
-			AR5K_OLD_RX_DESC_STATUS1_KEY_INDEX);
+			AR5K_5210_RX_DESC_STATUS1_KEY_INDEX);
 	else
 		desc->ds_us.rx.rs_keyix = AR5K_RXKEYIX_INVALID;
 
 	/*
 	 * Receive/descriptor errors
 	 */
-	if ((rx_status->rx_status_1 & AR5K_OLD_RX_DESC_STATUS1_FRAME_RECEIVE_OK)
-			== 0) {
-		if (rx_status->rx_status_1 & AR5K_OLD_RX_DESC_STATUS1_CRC_ERROR)
+	if ((rx_status->rx_status_1 &
+			AR5K_5210_RX_DESC_STATUS1_FRAME_RECEIVE_OK) == 0) {
+		if (rx_status->rx_status_1 &
+				AR5K_5210_RX_DESC_STATUS1_CRC_ERROR)
 			desc->ds_us.rx.rs_status |= AR5K_RXERR_CRC;
 
 		if (rx_status->rx_status_1 &
-				AR5K_OLD_RX_DESC_STATUS1_FIFO_OVERRUN)
+				AR5K_5210_RX_DESC_STATUS1_FIFO_OVERRUN)
 			desc->ds_us.rx.rs_status |= AR5K_RXERR_FIFO;
 
 		if (rx_status->rx_status_1 &
-				AR5K_OLD_RX_DESC_STATUS1_PHY_ERROR) {
+				AR5K_5210_RX_DESC_STATUS1_PHY_ERROR) {
 			desc->ds_us.rx.rs_status |= AR5K_RXERR_PHY;
 			desc->ds_us.rx.rs_phyerr =
 				AR5K_REG_MS(rx_status->rx_status_1,
-					AR5K_OLD_RX_DESC_STATUS1_PHY_ERROR);
+					AR5K_5210_RX_DESC_STATUS1_PHY_ERROR);
 		}
 
 		if (rx_status->rx_status_1 &
-				AR5K_OLD_RX_DESC_STATUS1_DECRYPT_CRC_ERROR)
+				AR5K_5210_RX_DESC_STATUS1_DECRYPT_CRC_ERROR)
 			desc->ds_us.rx.rs_status |= AR5K_RXERR_DECRYPT;
 	}
 
@@ -3976,20 +3964,20 @@ static int ath5k_hw_proc_old_rx_status(struct ath5k_hw *ah,
 /*
  * Proccess the rx status descriptor on 5212
  */
-static int ath5k_hw_proc_new_rx_status(struct ath5k_hw *ah,
+static int ath5k_hw_proc_5212_rx_status(struct ath5k_hw *ah,
 		struct ath5k_desc *desc)
 {
-	struct ath5k_hw_new_rx_status *rx_status;
+	struct ath5k_hw_rx_status *rx_status;
 	struct ath5k_hw_rx_error *rx_err;
 
 	ATH5K_TRACE(ah->ah_sc);
-	rx_status = (struct ath5k_hw_new_rx_status *)&desc->ds_hw[0];
+	rx_status = &desc->ud.ds_rx.u.rx_stat;
 
 	/* Overlay on error */
-	rx_err = (struct ath5k_hw_rx_error *)&desc->ds_hw[0];
+	rx_err = &desc->ud.ds_rx.u.rx_err;
 
 	/* No frame received / not ready */
-	if (unlikely((rx_status->rx_status_1 & AR5K_NEW_RX_DESC_STATUS1_DONE)
+	if (unlikely((rx_status->rx_status_1 & AR5K_5212_RX_DESC_STATUS1_DONE)
 				== 0))
 		return -EINPROGRESS;
 
@@ -3997,25 +3985,25 @@ static int ath5k_hw_proc_new_rx_status(struct ath5k_hw *ah,
 	 * Frame receive status
 	 */
 	desc->ds_us.rx.rs_datalen = rx_status->rx_status_0 &
-		AR5K_NEW_RX_DESC_STATUS0_DATA_LEN;
+		AR5K_5212_RX_DESC_STATUS0_DATA_LEN;
 	desc->ds_us.rx.rs_rssi = AR5K_REG_MS(rx_status->rx_status_0,
-		AR5K_NEW_RX_DESC_STATUS0_RECEIVE_SIGNAL);
+		AR5K_5212_RX_DESC_STATUS0_RECEIVE_SIGNAL);
 	desc->ds_us.rx.rs_rate = AR5K_REG_MS(rx_status->rx_status_0,
-		AR5K_NEW_RX_DESC_STATUS0_RECEIVE_RATE);
+		AR5K_5212_RX_DESC_STATUS0_RECEIVE_RATE);
 	desc->ds_us.rx.rs_antenna = rx_status->rx_status_0 &
-		AR5K_NEW_RX_DESC_STATUS0_RECEIVE_ANTENNA;
+		AR5K_5212_RX_DESC_STATUS0_RECEIVE_ANTENNA;
 	desc->ds_us.rx.rs_more = rx_status->rx_status_0 &
-		AR5K_NEW_RX_DESC_STATUS0_MORE;
+		AR5K_5212_RX_DESC_STATUS0_MORE;
 	desc->ds_us.rx.rs_tstamp = AR5K_REG_MS(rx_status->rx_status_1,
-		AR5K_NEW_RX_DESC_STATUS1_RECEIVE_TIMESTAMP);
+		AR5K_5212_RX_DESC_STATUS1_RECEIVE_TIMESTAMP);
 	desc->ds_us.rx.rs_status = 0;
 
 	/*
 	 * Key table status
 	 */
-	if (rx_status->rx_status_1 & AR5K_NEW_RX_DESC_STATUS1_KEY_INDEX_VALID)
+	if (rx_status->rx_status_1 & AR5K_5212_RX_DESC_STATUS1_KEY_INDEX_VALID)
 		desc->ds_us.rx.rs_keyix = AR5K_REG_MS(rx_status->rx_status_1,
-				AR5K_NEW_RX_DESC_STATUS1_KEY_INDEX);
+				AR5K_5212_RX_DESC_STATUS1_KEY_INDEX);
 	else
 		desc->ds_us.rx.rs_keyix = AR5K_RXKEYIX_INVALID;
 
@@ -4023,12 +4011,13 @@ static int ath5k_hw_proc_new_rx_status(struct ath5k_hw *ah,
 	 * Receive/descriptor errors
 	 */
 	if ((rx_status->rx_status_1 &
-			AR5K_NEW_RX_DESC_STATUS1_FRAME_RECEIVE_OK) == 0) {
-		if (rx_status->rx_status_1 & AR5K_NEW_RX_DESC_STATUS1_CRC_ERROR)
+			AR5K_5212_RX_DESC_STATUS1_FRAME_RECEIVE_OK) == 0) {
+		if (rx_status->rx_status_1 &
+				AR5K_5212_RX_DESC_STATUS1_CRC_ERROR)
 			desc->ds_us.rx.rs_status |= AR5K_RXERR_CRC;
 
 		if (rx_status->rx_status_1 &
-				AR5K_NEW_RX_DESC_STATUS1_PHY_ERROR) {
+				AR5K_5212_RX_DESC_STATUS1_PHY_ERROR) {
 			desc->ds_us.rx.rs_status |= AR5K_RXERR_PHY;
 			desc->ds_us.rx.rs_phyerr =
 				AR5K_REG_MS(rx_err->rx_error_1,
@@ -4036,10 +4025,11 @@ static int ath5k_hw_proc_new_rx_status(struct ath5k_hw *ah,
 		}
 
 		if (rx_status->rx_status_1 &
-				AR5K_NEW_RX_DESC_STATUS1_DECRYPT_CRC_ERROR)
+				AR5K_5212_RX_DESC_STATUS1_DECRYPT_CRC_ERROR)
 			desc->ds_us.rx.rs_status |= AR5K_RXERR_DECRYPT;
 
-		if (rx_status->rx_status_1 & AR5K_NEW_RX_DESC_STATUS1_MIC_ERROR)
+		if (rx_status->rx_status_1 &
+				AR5K_5212_RX_DESC_STATUS1_MIC_ERROR)
 			desc->ds_us.rx.rs_status |= AR5K_RXERR_MIC;
 	}
 
diff --git a/drivers/net/wireless/ath5k/hw.h b/drivers/net/wireless/ath5k/hw.h
index d9a7c09..64fca8d 100644
--- a/drivers/net/wireless/ath5k/hw.h
+++ b/drivers/net/wireless/ath5k/hw.h
@@ -173,7 +173,10 @@ struct ath5k_eeprom_info {
  * (rX: reserved fields possibily used by future versions of the ar5k chipset)
  */
 
-struct ath5k_rx_desc {
+/*
+ * common hardware RX control descriptor
+ */
+struct ath5k_hw_rx_ctl {
 	u32	rx_control_0; /* RX control word 0 */
 
 #define AR5K_DESC_RX_CTL0			0x00000000
@@ -185,69 +188,63 @@ struct ath5k_rx_desc {
 } __packed;
 
 /*
- * 5210/5211 rx status descriptor
+ * common hardware RX status descriptor
+ * 5210/11 and 5212 differ only in the flags defined below
  */
-struct ath5k_hw_old_rx_status {
+struct ath5k_hw_rx_status {
 	u32	rx_status_0; /* RX status word 0 */
-
-#define AR5K_OLD_RX_DESC_STATUS0_DATA_LEN		0x00000fff
-#define AR5K_OLD_RX_DESC_STATUS0_MORE			0x00001000
-#define AR5K_OLD_RX_DESC_STATUS0_RECEIVE_RATE		0x00078000
-#define AR5K_OLD_RX_DESC_STATUS0_RECEIVE_RATE_S		15
-#define AR5K_OLD_RX_DESC_STATUS0_RECEIVE_SIGNAL		0x07f80000
-#define AR5K_OLD_RX_DESC_STATUS0_RECEIVE_SIGNAL_S	19
-#define AR5K_OLD_RX_DESC_STATUS0_RECEIVE_ANTENNA	0x38000000
-#define AR5K_OLD_RX_DESC_STATUS0_RECEIVE_ANTENNA_S	27
-
 	u32	rx_status_1; /* RX status word 1 */
-
-#define AR5K_OLD_RX_DESC_STATUS1_DONE			0x00000001
-#define AR5K_OLD_RX_DESC_STATUS1_FRAME_RECEIVE_OK	0x00000002
-#define AR5K_OLD_RX_DESC_STATUS1_CRC_ERROR		0x00000004
-#define AR5K_OLD_RX_DESC_STATUS1_FIFO_OVERRUN		0x00000008
-#define AR5K_OLD_RX_DESC_STATUS1_DECRYPT_CRC_ERROR	0x00000010
-#define AR5K_OLD_RX_DESC_STATUS1_PHY_ERROR		0x000000e0
-#define AR5K_OLD_RX_DESC_STATUS1_PHY_ERROR_S		5
-#define AR5K_OLD_RX_DESC_STATUS1_KEY_INDEX_VALID	0x00000100
-#define AR5K_OLD_RX_DESC_STATUS1_KEY_INDEX		0x00007e00
-#define AR5K_OLD_RX_DESC_STATUS1_KEY_INDEX_S		9
-#define AR5K_OLD_RX_DESC_STATUS1_RECEIVE_TIMESTAMP	0x0fff8000
-#define AR5K_OLD_RX_DESC_STATUS1_RECEIVE_TIMESTAMP_S	15
-#define AR5K_OLD_RX_DESC_STATUS1_KEY_CACHE_MISS		0x10000000
 } __packed;
 
+/* 5210/5211 */
+#define AR5K_5210_RX_DESC_STATUS0_DATA_LEN		0x00000fff
+#define AR5K_5210_RX_DESC_STATUS0_MORE			0x00001000
+#define AR5K_5210_RX_DESC_STATUS0_RECEIVE_RATE		0x00078000
+#define AR5K_5210_RX_DESC_STATUS0_RECEIVE_RATE_S	15
+#define AR5K_5210_RX_DESC_STATUS0_RECEIVE_SIGNAL	0x07f80000
+#define AR5K_5210_RX_DESC_STATUS0_RECEIVE_SIGNAL_S	19
+#define AR5K_5210_RX_DESC_STATUS0_RECEIVE_ANTENNA	0x38000000
+#define AR5K_5210_RX_DESC_STATUS0_RECEIVE_ANTENNA_S	27
+#define AR5K_5210_RX_DESC_STATUS1_DONE			0x00000001
+#define AR5K_5210_RX_DESC_STATUS1_FRAME_RECEIVE_OK	0x00000002
+#define AR5K_5210_RX_DESC_STATUS1_CRC_ERROR		0x00000004
+#define AR5K_5210_RX_DESC_STATUS1_FIFO_OVERRUN		0x00000008
+#define AR5K_5210_RX_DESC_STATUS1_DECRYPT_CRC_ERROR	0x00000010
+#define AR5K_5210_RX_DESC_STATUS1_PHY_ERROR		0x000000e0
+#define AR5K_5210_RX_DESC_STATUS1_PHY_ERROR_S		5
+#define AR5K_5210_RX_DESC_STATUS1_KEY_INDEX_VALID	0x00000100
+#define AR5K_5210_RX_DESC_STATUS1_KEY_INDEX		0x00007e00
+#define AR5K_5210_RX_DESC_STATUS1_KEY_INDEX_S		9
+#define AR5K_5210_RX_DESC_STATUS1_RECEIVE_TIMESTAMP	0x0fff8000
+#define AR5K_5210_RX_DESC_STATUS1_RECEIVE_TIMESTAMP_S	15
+#define AR5K_5210_RX_DESC_STATUS1_KEY_CACHE_MISS	0x10000000
+
+/* 5212 */
+#define AR5K_5212_RX_DESC_STATUS0_DATA_LEN		0x00000fff
+#define AR5K_5212_RX_DESC_STATUS0_MORE			0x00001000
+#define AR5K_5212_RX_DESC_STATUS0_DECOMP_CRC_ERROR	0x00002000
+#define AR5K_5212_RX_DESC_STATUS0_RECEIVE_RATE		0x000f8000
+#define AR5K_5212_RX_DESC_STATUS0_RECEIVE_RATE_S	15
+#define AR5K_5212_RX_DESC_STATUS0_RECEIVE_SIGNAL	0x0ff00000
+#define AR5K_5212_RX_DESC_STATUS0_RECEIVE_SIGNAL_S	20
+#define AR5K_5212_RX_DESC_STATUS0_RECEIVE_ANTENNA	0xf0000000
+#define AR5K_5212_RX_DESC_STATUS0_RECEIVE_ANTENNA_S	28
+#define AR5K_5212_RX_DESC_STATUS1_DONE			0x00000001
+#define AR5K_5212_RX_DESC_STATUS1_FRAME_RECEIVE_OK	0x00000002
+#define AR5K_5212_RX_DESC_STATUS1_CRC_ERROR		0x00000004
+#define AR5K_5212_RX_DESC_STATUS1_DECRYPT_CRC_ERROR	0x00000008
+#define AR5K_5212_RX_DESC_STATUS1_PHY_ERROR		0x00000010
+#define AR5K_5212_RX_DESC_STATUS1_MIC_ERROR		0x00000020
+#define AR5K_5212_RX_DESC_STATUS1_KEY_INDEX_VALID	0x00000100
+#define AR5K_5212_RX_DESC_STATUS1_KEY_INDEX		0x0000fe00
+#define AR5K_5212_RX_DESC_STATUS1_KEY_INDEX_S		9
+#define AR5K_5212_RX_DESC_STATUS1_RECEIVE_TIMESTAMP	0x7fff0000
+#define AR5K_5212_RX_DESC_STATUS1_RECEIVE_TIMESTAMP_S	16
+#define AR5K_5212_RX_DESC_STATUS1_KEY_CACHE_MISS	0x80000000
+
 /*
- * 5212 rx status descriptor
+ * common hardware RX error descriptor
  */
-struct ath5k_hw_new_rx_status {
-	u32	rx_status_0; /* RX status word 0 */
-
-#define AR5K_NEW_RX_DESC_STATUS0_DATA_LEN		0x00000fff
-#define AR5K_NEW_RX_DESC_STATUS0_MORE			0x00001000
-#define AR5K_NEW_RX_DESC_STATUS0_DECOMP_CRC_ERROR	0x00002000
-#define AR5K_NEW_RX_DESC_STATUS0_RECEIVE_RATE		0x000f8000
-#define AR5K_NEW_RX_DESC_STATUS0_RECEIVE_RATE_S		15
-#define AR5K_NEW_RX_DESC_STATUS0_RECEIVE_SIGNAL		0x0ff00000
-#define AR5K_NEW_RX_DESC_STATUS0_RECEIVE_SIGNAL_S	20
-#define AR5K_NEW_RX_DESC_STATUS0_RECEIVE_ANTENNA	0xf0000000
-#define AR5K_NEW_RX_DESC_STATUS0_RECEIVE_ANTENNA_S	28
-
-	u32	rx_status_1; /* RX status word 1 */
-
-#define AR5K_NEW_RX_DESC_STATUS1_DONE			0x00000001
-#define AR5K_NEW_RX_DESC_STATUS1_FRAME_RECEIVE_OK	0x00000002
-#define AR5K_NEW_RX_DESC_STATUS1_CRC_ERROR		0x00000004
-#define AR5K_NEW_RX_DESC_STATUS1_DECRYPT_CRC_ERROR	0x00000008
-#define AR5K_NEW_RX_DESC_STATUS1_PHY_ERROR		0x00000010
-#define AR5K_NEW_RX_DESC_STATUS1_MIC_ERROR		0x00000020
-#define AR5K_NEW_RX_DESC_STATUS1_KEY_INDEX_VALID	0x00000100
-#define AR5K_NEW_RX_DESC_STATUS1_KEY_INDEX		0x0000fe00
-#define AR5K_NEW_RX_DESC_STATUS1_KEY_INDEX_S		9
-#define AR5K_NEW_RX_DESC_STATUS1_RECEIVE_TIMESTAMP	0x7fff0000
-#define AR5K_NEW_RX_DESC_STATUS1_RECEIVE_TIMESTAMP_S	16
-#define AR5K_NEW_RX_DESC_STATUS1_KEY_CACHE_MISS		0x80000000
-} __packed;
-
 struct ath5k_hw_rx_error {
 	u32	rx_error_0; /* RX error word 0 */
 
@@ -268,7 +265,10 @@ struct ath5k_hw_rx_error {
 #define AR5K_DESC_RX_PHY_ERROR_SERVICE		0xc0
 #define AR5K_DESC_RX_PHY_ERROR_TRANSMITOVR	0xe0
 
-struct ath5k_hw_2w_tx_desc {
+/*
+ * 5210/5211 hardware 2-word TX control descriptor
+ */
+struct ath5k_hw_2w_tx_ctl {
 	u32	tx_control_0; /* TX control word 0 */
 
 #define AR5K_2W_TX_DESC_CTL0_FRAME_LEN		0x00000fff
@@ -314,9 +314,9 @@ struct ath5k_hw_2w_tx_desc {
 #define AR5K_AR5210_TX_DESC_FRAME_TYPE_PIFS     0x10
 
 /*
- * 5212 4-word tx control descriptor
+ * 5212 hardware 4-word TX control descriptor
  */
-struct ath5k_hw_4w_tx_desc {
+struct ath5k_hw_4w_tx_ctl {
 	u32	tx_control_0; /* TX control word 0 */
 
 #define AR5K_4W_TX_DESC_CTL0_FRAME_LEN		0x00000fff
@@ -374,7 +374,7 @@ struct ath5k_hw_4w_tx_desc {
 } __packed;
 
 /*
- * Common tx status descriptor
+ * Common TX status descriptor
  */
 struct ath5k_hw_tx_status {
 	u32	tx_status_0; /* TX status word 0 */
@@ -415,6 +415,34 @@ struct ath5k_hw_tx_status {
 
 
 /*
+ * 5210/5211 hardware TX descriptor
+ */
+struct ath5k_hw_5210_tx_desc {
+	struct ath5k_hw_2w_tx_ctl	tx_ctl;
+	struct ath5k_hw_tx_status	tx_stat;
+} __packed;
+
+/*
+ * 5212 hardware TX descriptor
+ */
+struct ath5k_hw_5212_tx_desc {
+	struct ath5k_hw_4w_tx_ctl	tx_ctl;
+	struct ath5k_hw_tx_status	tx_stat;
+} __packed;
+
+/*
+ * common hardware RX descriptor
+ */
+struct ath5k_hw_all_rx_desc {
+	struct ath5k_hw_rx_ctl			rx_ctl;
+	union {
+		struct ath5k_hw_rx_status	rx_stat;
+		struct ath5k_hw_rx_error	rx_err;
+	} u;
+} __packed;
+
+
+/*
  * AR5K REGISTER ACCESS
  */
 

