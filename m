Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:58398 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbXJ0X6b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Oct 2007 19:58:31 -0400
Date: Sun, 28 Oct 2007 02:58:27 +0300
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com
Subject: [PATCH] ath5k: Remove fill_tx_desc
Message-ID: <20071027235827.GH5973@localhost.domain.invalid> (sfid-20071028_005836_123405_B9F86414)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

fill_tx_desc is used for fast frames operation, since
we don't support fast frames (and since fill_tx_desc
had a bug -thanx to Ulrich Meis for finding that out-)
these functions are not needed (+ they are misleading
because they don't "fill" any tx descriptor).

I couldn't test this patch much so plz someone ACK it...

It applies on top of my previous patches (i just thought
that [PATCH 8/7] won't look nice ;-) ).


Changes-licensed-under: ISC
Signed-off-by: Ulrich Meis <meis@nets.rwth-aachen.de>
Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>

---
diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index ef76f1c..4122466 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -1031,8 +1031,6 @@ struct ath5k_hw {
 	bool (*ah_setup_xtx_desc)(struct ath5k_hw *, struct ath5k_desc *,
 		unsigned int, unsigned int, unsigned int, unsigned int,
 		unsigned int, unsigned int);
-	int (*ah_fill_tx_desc)(struct ath5k_hw *, struct ath5k_desc *,
-		unsigned int, bool, bool);
 	int (*ah_proc_tx_desc)(struct ath5k_hw *, struct ath5k_desc *);
 	int (*ah_proc_rx_desc)(struct ath5k_hw *, struct ath5k_desc *);
 };
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index e6a3155..4b4ddf4 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1390,10 +1390,6 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
 	ds->ds_link = 0;
 	ds->ds_data = bf->skbaddr;
 
-	ret = ah->ah_fill_tx_desc(ah, ds, skb->len, true, true);
-	if (ret)
-		goto err_unmap;
-
 	spin_lock_bh(&txq->lock);
 	list_add_tail(&bf->list, &txq->q);
 	sc->tx_stats.data[txq->qnum].len++;
@@ -1966,10 +1962,6 @@ ath5k_beacon_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
 			AR5K_TXKEYIX_INVALID, antenna, flags, 0, 0);
 	if (ret)
 		goto err_unmap;
-	/* NB: beacon's BufLen must be a multiple of 4 bytes */
-	ret = ah->ah_fill_tx_desc(ah, ds, roundup(skb->len, 4), true, true);
-	if (ret)
-		goto err_unmap;
 
 	return 0;
 err_unmap:
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index ac105c6..7b9920c 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -47,15 +47,11 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *, struct ath5k_desc *,
 static bool ath5k_hw_setup_xr_tx_desc(struct ath5k_hw *, struct ath5k_desc *,
 	unsigned int, unsigned int, unsigned int, unsigned int, unsigned int,
 	unsigned int);
-static int ath5k_hw_fill_4word_tx_desc(struct ath5k_hw *, struct ath5k_desc *,
-	unsigned int, bool, bool);
 static int ath5k_hw_proc_4word_tx_status(struct ath5k_hw *, struct ath5k_desc *);
 static int ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *, struct ath5k_desc *,
 	unsigned int, unsigned int, enum ath5k_pkt_type, unsigned int,
 	unsigned int, unsigned int, unsigned int, unsigned int, unsigned int,
 	unsigned int, unsigned int);
-static int ath5k_hw_fill_2word_tx_desc(struct ath5k_hw *, struct ath5k_desc *,
-	unsigned int, bool, bool);
 static int ath5k_hw_proc_2word_tx_status(struct ath5k_hw *, struct ath5k_desc *);
 static int ath5k_hw_proc_new_rx_status(struct ath5k_hw *, struct ath5k_desc *);
 static int ath5k_hw_proc_old_rx_status(struct ath5k_hw *, struct ath5k_desc *);
@@ -243,12 +239,10 @@ struct ath5k_hw *ath5k_hw_attach(u16 device, u8 mac_version, void *sc,
 	if (ah->ah_version == AR5K_AR5212) {
 		ah->ah_setup_tx_desc = ath5k_hw_setup_4word_tx_desc;
 		ah->ah_setup_xtx_desc = ath5k_hw_setup_xr_tx_desc;
-		ah->ah_fill_tx_desc = ath5k_hw_fill_4word_tx_desc;
 		ah->ah_proc_tx_desc = ath5k_hw_proc_4word_tx_status;
 	} else {
 		ah->ah_setup_tx_desc = ath5k_hw_setup_2word_tx_desc;
 		ah->ah_setup_xtx_desc = ath5k_hw_setup_xr_tx_desc;
-		ah->ah_fill_tx_desc = ath5k_hw_fill_2word_tx_desc;
 		ah->ah_proc_tx_desc = ath5k_hw_proc_2word_tx_status;
 	}
 
@@ -287,7 +281,7 @@ struct ath5k_hw *ath5k_hw_attach(u16 device, u8 mac_version, void *sc,
 
 	/* Warn for partially supported chips (unsupported phy etc) */
 	if(srev >= AR5K_SREV_VER_AR2424){
-		printk(KERN_WARN "ath5k: Device partially supported.\n");
+		printk(KERN_DEBUG "ath5k: Device partially supported.\n");
 	}
 
 	/* Identify single chip solutions */
@@ -3491,31 +3485,52 @@ ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 {
 	u32 frame_type;
 	struct ath5k_hw_2w_tx_desc *tx_desc;
+	unsigned int buff_len;
 
 	tx_desc = (struct ath5k_hw_2w_tx_desc *)&desc->ds_ctl0;
 
+	/*
+	 * Validate input
+	 */
 	if (tx_tries0 == 0)
 		return -EINVAL;
 
+	/* Clear status descriptor */
+	memset(desc->ds_hw, 0, sizeof(struct ath5k_hw_tx_status));
+
 	/* Initialize control descriptor */
 	tx_desc->tx_control_0 = 0;
 	tx_desc->tx_control_1 = 0;
 
 	/* Setup control descriptor */
 
-	/*Verify packet length*/
+	/* Verify and set frame length */
+	if (pkt_len & ~AR5K_2W_TX_DESC_CTL0_FRAME_LEN)
+		return -EINVAL;
+
 	tx_desc->tx_control_0 = pkt_len & AR5K_2W_TX_DESC_CTL0_FRAME_LEN;
-	if (tx_desc->tx_control_0 != pkt_len)
+
+	/* Verify and set buffer length */
+	buff_len = pkt_len - FCS_LEN;
+
+	/* NB: beacon's BufLen must be a multiple of 4 bytes */
+	if(type == AR5K_PKT_TYPE_BEACON)
+		buff_len = roundup(buff_len, 4);
+
+	if (buff_len & ~AR5K_2W_TX_DESC_CTL1_BUF_LEN)
 		return -EINVAL;
+
+	tx_desc->tx_control_1 = buff_len & AR5K_2W_TX_DESC_CTL1_BUF_LEN;
+
 	/*
-	 * Verify header length
+	 * Verify and set header length
 	 * XXX: I only found that on 5210 code, does it work on 5211 ?
 	 */
 	if (ah->ah_version == AR5K_AR5210) {
-		tx_desc->tx_control_0 = hdr_len &
-				AR5K_2W_TX_DESC_CTL0_HEADER_LEN;
-		if (tx_desc->tx_control_0 != hdr_len)
+		if (hdr_len & ~AR5K_2W_TX_DESC_CTL0_HEADER_LEN)
 			return -EINVAL;
+		tx_desc->tx_control_0 |= 
+			AR5K_REG_SM(hdr_len, AR5K_2W_TX_DESC_CTL0_HEADER_LEN);
 	}
 
 	/*Diferences between 5210-5211*/
@@ -3530,14 +3545,14 @@ ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 			frame_type = type /*<< 2 ?*/;
 		}
 
-		tx_desc->tx_control_0 =
+		tx_desc->tx_control_0 |=
 			AR5K_REG_SM(frame_type, AR5K_2W_TX_DESC_CTL0_FRAME_TYPE) |
 			AR5K_REG_SM(tx_rate0, AR5K_2W_TX_DESC_CTL0_XMIT_RATE);
 	} else {
 		tx_desc->tx_control_0 |=
 			AR5K_REG_SM(tx_rate0, AR5K_2W_TX_DESC_CTL0_XMIT_RATE) |
 			AR5K_REG_SM(antenna_mode, AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT);
-		tx_desc->tx_control_1 =
+		tx_desc->tx_control_1 |=
 			AR5K_REG_SM(type, AR5K_2W_TX_DESC_CTL1_FRAME_TYPE);
 	}
 #define _TX_FLAGS(_c, _flag)						\
@@ -3586,10 +3601,12 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
 	unsigned int rtscts_duration)
 {
 	struct ath5k_hw_4w_tx_desc *tx_desc;
+	struct ath5k_hw_tx_status *tx_status;
+	unsigned int buff_len;
 
 	AR5K_TRACE;
-
 	tx_desc = (struct ath5k_hw_4w_tx_desc *)&desc->ds_ctl0;
+	tx_status = (struct ath5k_hw_tx_status *)&desc->ds_hw[2];
 
 	/*
 	 * Validate input
@@ -3597,21 +3614,37 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
 	if (tx_tries0 == 0)
 		return -EINVAL;
 
-	/* Initialize status descriptor */
+	/* Clear status descriptor */
+	memset(tx_status, 0, sizeof(struct ath5k_hw_tx_status));
+
+	/* Initialize control descriptor */
 	tx_desc->tx_control_0 = 0;
 	tx_desc->tx_control_1 = 0;
 	tx_desc->tx_control_2 = 0;
 	tx_desc->tx_control_3 = 0;
 
-	/* Setup status descriptor */
+	/* Setup control descriptor */
+
+	/* Verify and set frame length */
+	if (pkt_len & ~AR5K_4W_TX_DESC_CTL0_FRAME_LEN)
+		return -EINVAL;
+
 	tx_desc->tx_control_0 = pkt_len & AR5K_4W_TX_DESC_CTL0_FRAME_LEN;
-	if (tx_desc->tx_control_0 != pkt_len)
+
+	/* Verify and set buffer length */
+	buff_len = pkt_len - FCS_LEN;
+
+	/* NB: beacon's BufLen must be a multiple of 4 bytes */
+	if(type == AR5K_PKT_TYPE_BEACON)
+		buff_len = roundup(buff_len, 4);
+	
+	if (buff_len & ~AR5K_4W_TX_DESC_CTL1_BUF_LEN)
 		return -EINVAL;
 
 	tx_desc->tx_control_0 |=
 		AR5K_REG_SM(tx_power, AR5K_4W_TX_DESC_CTL0_XMIT_POWER) |
 		AR5K_REG_SM(antenna_mode, AR5K_4W_TX_DESC_CTL0_ANT_MODE_XMIT);
-	tx_desc->tx_control_1 = AR5K_REG_SM(type,
+	tx_desc->tx_control_1 |= AR5K_REG_SM(type,
 					AR5K_4W_TX_DESC_CTL1_FRAME_TYPE);
 	tx_desc->tx_control_2 = AR5K_REG_SM(tx_tries0 + AR5K_TUNE_HWTXTRIES,
 					AR5K_4W_TX_DESC_CTL2_XMIT_TRIES0);
@@ -3657,7 +3690,7 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
 }
 
 /*
- * Initialize a 4-word XR tx descriptor on 5212
+ * Initialize a 4-word multirate tx descriptor on 5212
  */
 static bool
 ath5k_hw_setup_xr_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
@@ -3692,66 +3725,6 @@ ath5k_hw_setup_xr_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 }
 
 /*
- * Fill the 2-word tx descriptor on 5210/5211
- */
-static int ath5k_hw_fill_2word_tx_desc(struct ath5k_hw *ah,
-	struct ath5k_desc *desc, unsigned int segment_length,
-	bool first_segment, bool last_segment)
-{
-	struct ath5k_hw_2w_tx_desc *tx_desc;
-
-	tx_desc = (struct ath5k_hw_2w_tx_desc *)&desc->ds_ctl0;
-
-	/* Clear status descriptor */
-	memset(desc->ds_hw, 0, sizeof(desc->ds_hw));
-
-	/* Validate segment length and initialize the descriptor */
-	tx_desc->tx_control_1 = segment_length & AR5K_2W_TX_DESC_CTL1_BUF_LEN;
-	if (tx_desc->tx_control_1 != segment_length)
-		return -EINVAL;
-
-	if (first_segment != true)
-		tx_desc->tx_control_0 &= ~AR5K_2W_TX_DESC_CTL0_FRAME_LEN;
-
-	if (last_segment != true)
-		tx_desc->tx_control_1 |= AR5K_2W_TX_DESC_CTL1_MORE;
-
-	return 0;
-}
-
-/*
- * Fill the 4-word tx descriptor on 5212
- * XXX: Added an argument *last_desc -need revision
- */
-static int ath5k_hw_fill_4word_tx_desc(struct ath5k_hw *ah,
-	struct ath5k_desc *desc, unsigned int segment_length,
-	bool first_segment, bool last_segment)
-{
-	struct ath5k_hw_4w_tx_desc *tx_desc;
-	struct ath5k_hw_tx_status *tx_status;
-
-	AR5K_TRACE;
-	tx_desc = (struct ath5k_hw_4w_tx_desc *)&desc->ds_ctl0;
-	tx_status = (struct ath5k_hw_tx_status *)&desc->ds_hw[2];
-
-	/* Clear status descriptor */
-	memset(tx_status, 0, sizeof(struct ath5k_hw_tx_status));
-
-	/* Validate segment length and initialize the descriptor */
-	tx_desc->tx_control_1 = segment_length & AR5K_4W_TX_DESC_CTL1_BUF_LEN;
-	if (tx_desc->tx_control_1 != segment_length)
-		return -EINVAL;
-
-	if (first_segment != true)
-		tx_desc->tx_control_0 &= ~AR5K_4W_TX_DESC_CTL0_FRAME_LEN;
-
-	if (last_segment != true)
-		tx_desc->tx_control_1 |= AR5K_4W_TX_DESC_CTL1_MORE;
-
-	return 0;
-}
-
-/*
  * Proccess the tx status descriptor on 5210/5211
  */
 static int ath5k_hw_proc_2word_tx_status(struct ath5k_hw *ah,





