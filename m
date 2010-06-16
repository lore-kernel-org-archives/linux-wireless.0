Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:12099 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758688Ab0FPKMh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 06:12:37 -0400
Received: from vs3001.wh2.ocn.ne.jp (125.206.180.229)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0859643155
	for <linux-wireless@vger.kernel.org>; Wed, 16 Jun 2010 19:12:35 +0900 (JST)
Subject: [PATCH 13/17] ath5k: review and add comments for descriptors
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Wed, 16 Jun 2010 19:12:17 +0900
Message-ID: <20100616101217.10067.76662.stgit@tt-desk>
In-Reply-To: <20100616100809.10067.34787.stgit@tt-desk>
References: <20100616100809.10067.34787.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I carefully reviewed desh.h against the HAL sources. Added comments and made
differences between 5210, 5211 and 5212 more clear by adding _521x to the
defines which are specific to that chipset. Renamed some defines. No functional
changes.

Signed-off-by: Bruno Randolf <br1@einfach.org>
Acked-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/desc.c |   22 +--
 drivers/net/wireless/ath/ath5k/desc.h |  276 ++++++++++++++++-----------------
 2 files changed, 144 insertions(+), 154 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/desc.c b/drivers/net/wireless/ath/ath5k/desc.c
index eb1427c..41a490e 100644
--- a/drivers/net/wireless/ath/ath5k/desc.c
+++ b/drivers/net/wireless/ath/ath5k/desc.c
@@ -95,10 +95,10 @@ ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 	 * XXX: I only found that on 5210 code, does it work on 5211 ?
 	 */
 	if (ah->ah_version == AR5K_AR5210) {
-		if (hdr_len & ~AR5K_2W_TX_DESC_CTL0_HEADER_LEN)
+		if (hdr_len & ~AR5K_2W_TX_DESC_CTL0_HEADER_LEN_5210)
 			return -EINVAL;
 		tx_ctl->tx_control_0 |=
-			AR5K_REG_SM(hdr_len, AR5K_2W_TX_DESC_CTL0_HEADER_LEN);
+			AR5K_REG_SM(hdr_len, AR5K_2W_TX_DESC_CTL0_HEADER_LEN_5210);
 	}
 
 	/*Differences between 5210-5211*/
@@ -114,7 +114,7 @@ ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 		}
 
 		tx_ctl->tx_control_0 |=
-		AR5K_REG_SM(frame_type, AR5K_2W_TX_DESC_CTL0_FRAME_TYPE) |
+		AR5K_REG_SM(frame_type, AR5K_2W_TX_DESC_CTL0_FRAME_TYPE_5210) |
 		AR5K_REG_SM(tx_rate0, AR5K_2W_TX_DESC_CTL0_XMIT_RATE);
 
 	} else {
@@ -123,7 +123,7 @@ ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 			AR5K_REG_SM(antenna_mode,
 				AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT);
 		tx_ctl->tx_control_1 |=
-			AR5K_REG_SM(type, AR5K_2W_TX_DESC_CTL1_FRAME_TYPE);
+			AR5K_REG_SM(type, AR5K_2W_TX_DESC_CTL1_FRAME_TYPE_5211);
 	}
 #define _TX_FLAGS(_c, _flag)					\
 	if (flags & AR5K_TXDESC_##_flag) {			\
@@ -147,7 +147,7 @@ ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 			AR5K_2W_TX_DESC_CTL0_ENCRYPT_KEY_VALID;
 		tx_ctl->tx_control_1 |=
 			AR5K_REG_SM(key_index,
-			AR5K_2W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX);
+			AR5K_2W_TX_DESC_CTL1_ENC_KEY_IDX);
 	}
 
 	/*
@@ -156,7 +156,7 @@ ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 	if ((ah->ah_version == AR5K_AR5210) &&
 			(flags & (AR5K_TXDESC_RTSENA | AR5K_TXDESC_CTSENA)))
 		tx_ctl->tx_control_1 |= rtscts_duration &
-				AR5K_2W_TX_DESC_CTL1_RTS_DURATION;
+				AR5K_2W_TX_DESC_CTL1_RTS_DURATION_5210;
 
 	return 0;
 }
@@ -255,7 +255,7 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
 	if (key_index != AR5K_TXKEYIX_INVALID) {
 		tx_ctl->tx_control_0 |= AR5K_4W_TX_DESC_CTL0_ENCRYPT_KEY_VALID;
 		tx_ctl->tx_control_1 |= AR5K_REG_SM(key_index,
-				AR5K_4W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX);
+				AR5K_4W_TX_DESC_CTL1_ENCRYPT_KEY_IDX);
 	}
 
 	/*
@@ -409,11 +409,11 @@ static int ath5k_hw_proc_4word_tx_status(struct ath5k_hw *ah,
 	ts->ts_rssi = AR5K_REG_MS(tx_status->tx_status_1,
 		AR5K_DESC_TX_STATUS1_ACK_SIG_STRENGTH);
 	ts->ts_antenna = (tx_status->tx_status_1 &
-		AR5K_DESC_TX_STATUS1_XMIT_ANTENNA) ? 2 : 1;
+		AR5K_DESC_TX_STATUS1_XMIT_ANTENNA_5212) ? 2 : 1;
 	ts->ts_status = 0;
 
 	ts->ts_final_idx = AR5K_REG_MS(tx_status->tx_status_1,
-			AR5K_DESC_TX_STATUS1_FINAL_TS_INDEX);
+			AR5K_DESC_TX_STATUS1_FINAL_TS_IX_5212);
 
 	/* The longretry counter has the number of un-acked retries
 	 * for the final rate. To get the total number of retries
@@ -527,7 +527,7 @@ static int ath5k_hw_proc_5210_rx_status(struct ath5k_hw *ah,
 	rs->rs_rate = AR5K_REG_MS(rx_status->rx_status_0,
 		AR5K_5210_RX_DESC_STATUS0_RECEIVE_RATE);
 	rs->rs_antenna = AR5K_REG_MS(rx_status->rx_status_0,
-		AR5K_5210_RX_DESC_STATUS0_RECEIVE_ANTENNA);
+		AR5K_5210_RX_DESC_STATUS0_RECEIVE_ANT_5211);
 	rs->rs_more = !!(rx_status->rx_status_0 &
 		AR5K_5210_RX_DESC_STATUS0_MORE);
 	/* TODO: this timestamp is 13 bit, later on we assume 15 bit */
@@ -555,7 +555,7 @@ static int ath5k_hw_proc_5210_rx_status(struct ath5k_hw *ah,
 			rs->rs_status |= AR5K_RXERR_CRC;
 
 		if (rx_status->rx_status_1 &
-				AR5K_5210_RX_DESC_STATUS1_FIFO_OVERRUN)
+				AR5K_5210_RX_DESC_STATUS1_FIFO_OVERRUN_5210)
 			rs->rs_status |= AR5K_RXERR_FIFO;
 
 		if (rx_status->rx_status_1 &
diff --git a/drivers/net/wireless/ath/ath5k/desc.h b/drivers/net/wireless/ath/ath5k/desc.h
index 45f2644..50f9a12 100644
--- a/drivers/net/wireless/ath/ath5k/desc.h
+++ b/drivers/net/wireless/ath/ath5k/desc.h
@@ -17,28 +17,24 @@
  */
 
 /*
- * Internal RX/TX descriptor structures
- * (rX: reserved fields possibily used by future versions of the ar5k chipset)
+ * RX/TX descriptor structures
  */
 
 /*
- * common hardware RX control descriptor
+ * Common hardware RX control descriptor
  */
 struct ath5k_hw_rx_ctl {
 	u32	rx_control_0; /* RX control word 0 */
 	u32	rx_control_1; /* RX control word 1 */
 } __packed;
 
-/* RX control word 0 field/sflags */
-#define AR5K_DESC_RX_CTL0			0x00000000
-
 /* RX control word 1 fields/flags */
-#define AR5K_DESC_RX_CTL1_BUF_LEN		0x00000fff
-#define AR5K_DESC_RX_CTL1_INTREQ		0x00002000
+#define AR5K_DESC_RX_CTL1_BUF_LEN		0x00000fff /* data buffer length */
+#define AR5K_DESC_RX_CTL1_INTREQ		0x00002000 /* RX interrupt request */
 
 /*
- * common hardware RX status descriptor
- * 5210/11 and 5212 differ only in the flags defined below
+ * Common hardware RX status descriptor
+ * 5210, 5211 and 5212 differ only in the fields and flags defined below
  */
 struct ath5k_hw_rx_status {
 	u32	rx_status_0; /* RX status word 0 */
@@ -47,68 +43,69 @@ struct ath5k_hw_rx_status {
 
 /* 5210/5211 */
 /* RX status word 0 fields/flags */
-#define AR5K_5210_RX_DESC_STATUS0_DATA_LEN		0x00000fff
-#define AR5K_5210_RX_DESC_STATUS0_MORE			0x00001000
-#define AR5K_5210_RX_DESC_STATUS0_RECEIVE_RATE		0x00078000
+#define AR5K_5210_RX_DESC_STATUS0_DATA_LEN		0x00000fff /* RX data length */
+#define AR5K_5210_RX_DESC_STATUS0_MORE			0x00001000 /* more desc for this frame */
+#define AR5K_5210_RX_DESC_STATUS0_RECEIVE_ANT_5210	0x00004000 /* [5210] receive on ant 1 TODO */
+#define AR5K_5210_RX_DESC_STATUS0_RECEIVE_RATE		0x00078000 /* reception rate */
 #define AR5K_5210_RX_DESC_STATUS0_RECEIVE_RATE_S	15
-#define AR5K_5210_RX_DESC_STATUS0_RECEIVE_SIGNAL	0x07f80000
+#define AR5K_5210_RX_DESC_STATUS0_RECEIVE_SIGNAL	0x07f80000 /* rssi */
 #define AR5K_5210_RX_DESC_STATUS0_RECEIVE_SIGNAL_S	19
-#define AR5K_5210_RX_DESC_STATUS0_RECEIVE_ANTENNA	0x38000000
-#define AR5K_5210_RX_DESC_STATUS0_RECEIVE_ANTENNA_S	27
+#define AR5K_5210_RX_DESC_STATUS0_RECEIVE_ANT_5211	0x38000000 /* [5211] receive antenna */
+#define AR5K_5210_RX_DESC_STATUS0_RECEIVE_ANT_5211_S	27
 
 /* RX status word 1 fields/flags */
-#define AR5K_5210_RX_DESC_STATUS1_DONE			0x00000001
-#define AR5K_5210_RX_DESC_STATUS1_FRAME_RECEIVE_OK	0x00000002
-#define AR5K_5210_RX_DESC_STATUS1_CRC_ERROR		0x00000004
-#define AR5K_5210_RX_DESC_STATUS1_FIFO_OVERRUN		0x00000008
-#define AR5K_5210_RX_DESC_STATUS1_DECRYPT_CRC_ERROR	0x00000010
-#define AR5K_5210_RX_DESC_STATUS1_PHY_ERROR		0x000000e0
+#define AR5K_5210_RX_DESC_STATUS1_DONE			0x00000001 /* descriptor complete */
+#define AR5K_5210_RX_DESC_STATUS1_FRAME_RECEIVE_OK	0x00000002 /* reception success */
+#define AR5K_5210_RX_DESC_STATUS1_CRC_ERROR		0x00000004 /* CRC error */
+#define AR5K_5210_RX_DESC_STATUS1_FIFO_OVERRUN_5210	0x00000008 /* [5210] FIFO overrun */
+#define AR5K_5210_RX_DESC_STATUS1_DECRYPT_CRC_ERROR	0x00000010 /* decyption CRC failure */
+#define AR5K_5210_RX_DESC_STATUS1_PHY_ERROR		0x000000e0 /* PHY error */
 #define AR5K_5210_RX_DESC_STATUS1_PHY_ERROR_S		5
-#define AR5K_5210_RX_DESC_STATUS1_KEY_INDEX_VALID	0x00000100
-#define AR5K_5210_RX_DESC_STATUS1_KEY_INDEX		0x00007e00
+#define AR5K_5210_RX_DESC_STATUS1_KEY_INDEX_VALID	0x00000100 /* key index valid */
+#define AR5K_5210_RX_DESC_STATUS1_KEY_INDEX		0x00007e00 /* decyption key index */
 #define AR5K_5210_RX_DESC_STATUS1_KEY_INDEX_S		9
-#define AR5K_5210_RX_DESC_STATUS1_RECEIVE_TIMESTAMP	0x0fff8000
+#define AR5K_5210_RX_DESC_STATUS1_RECEIVE_TIMESTAMP	0x0fff8000 /* 13 bit of TSF */
 #define AR5K_5210_RX_DESC_STATUS1_RECEIVE_TIMESTAMP_S	15
-#define AR5K_5210_RX_DESC_STATUS1_KEY_CACHE_MISS	0x10000000
+#define AR5K_5210_RX_DESC_STATUS1_KEY_CACHE_MISS	0x10000000 /* key cache miss */
 
 /* 5212 */
 /* RX status word 0 fields/flags */
-#define AR5K_5212_RX_DESC_STATUS0_DATA_LEN		0x00000fff
-#define AR5K_5212_RX_DESC_STATUS0_MORE			0x00001000
-#define AR5K_5212_RX_DESC_STATUS0_DECOMP_CRC_ERROR	0x00002000
-#define AR5K_5212_RX_DESC_STATUS0_RECEIVE_RATE		0x000f8000
+#define AR5K_5212_RX_DESC_STATUS0_DATA_LEN		0x00000fff /* RX data length */
+#define AR5K_5212_RX_DESC_STATUS0_MORE			0x00001000 /* more desc for this frame */
+#define AR5K_5212_RX_DESC_STATUS0_DECOMP_CRC_ERROR	0x00002000 /* decompression CRC error */
+#define AR5K_5212_RX_DESC_STATUS0_RECEIVE_RATE		0x000f8000 /* reception rate */
 #define AR5K_5212_RX_DESC_STATUS0_RECEIVE_RATE_S	15
-#define AR5K_5212_RX_DESC_STATUS0_RECEIVE_SIGNAL	0x0ff00000
+#define AR5K_5212_RX_DESC_STATUS0_RECEIVE_SIGNAL	0x0ff00000 /* rssi */
 #define AR5K_5212_RX_DESC_STATUS0_RECEIVE_SIGNAL_S	20
-#define AR5K_5212_RX_DESC_STATUS0_RECEIVE_ANTENNA	0xf0000000
+#define AR5K_5212_RX_DESC_STATUS0_RECEIVE_ANTENNA	0xf0000000 /* receive antenna */
 #define AR5K_5212_RX_DESC_STATUS0_RECEIVE_ANTENNA_S	28
 
 /* RX status word 1 fields/flags */
-#define AR5K_5212_RX_DESC_STATUS1_DONE			0x00000001
-#define AR5K_5212_RX_DESC_STATUS1_FRAME_RECEIVE_OK	0x00000002
-#define AR5K_5212_RX_DESC_STATUS1_CRC_ERROR		0x00000004
-#define AR5K_5212_RX_DESC_STATUS1_DECRYPT_CRC_ERROR	0x00000008
-#define AR5K_5212_RX_DESC_STATUS1_PHY_ERROR		0x00000010
-#define AR5K_5212_RX_DESC_STATUS1_MIC_ERROR		0x00000020
-#define AR5K_5212_RX_DESC_STATUS1_KEY_INDEX_VALID	0x00000100
-#define AR5K_5212_RX_DESC_STATUS1_KEY_INDEX		0x0000fe00
+#define AR5K_5212_RX_DESC_STATUS1_DONE			0x00000001 /* descriptor complete */
+#define AR5K_5212_RX_DESC_STATUS1_FRAME_RECEIVE_OK	0x00000002 /* frame reception success */
+#define AR5K_5212_RX_DESC_STATUS1_CRC_ERROR		0x00000004 /* CRC error */
+#define AR5K_5212_RX_DESC_STATUS1_DECRYPT_CRC_ERROR	0x00000008 /* decryption CRC failure */
+#define AR5K_5212_RX_DESC_STATUS1_PHY_ERROR		0x00000010 /* PHY error */
+#define AR5K_5212_RX_DESC_STATUS1_MIC_ERROR		0x00000020 /* MIC decrypt error */
+#define AR5K_5212_RX_DESC_STATUS1_KEY_INDEX_VALID	0x00000100 /* key index valid */
+#define AR5K_5212_RX_DESC_STATUS1_KEY_INDEX		0x0000fe00 /* decryption key index */
 #define AR5K_5212_RX_DESC_STATUS1_KEY_INDEX_S		9
-#define AR5K_5212_RX_DESC_STATUS1_RECEIVE_TIMESTAMP	0x7fff0000
+#define AR5K_5212_RX_DESC_STATUS1_RECEIVE_TIMESTAMP	0x7fff0000 /* first 15bit of the TSF */
 #define AR5K_5212_RX_DESC_STATUS1_RECEIVE_TIMESTAMP_S	16
-#define AR5K_5212_RX_DESC_STATUS1_KEY_CACHE_MISS	0x80000000
-#define AR5K_5212_RX_DESC_STATUS1_PHY_ERROR_CODE	0x0000ff00
+#define AR5K_5212_RX_DESC_STATUS1_KEY_CACHE_MISS	0x80000000 /* key cache miss */
+#define AR5K_5212_RX_DESC_STATUS1_PHY_ERROR_CODE	0x0000ff00 /* phy error code overlays key index and valid fields */
 #define AR5K_5212_RX_DESC_STATUS1_PHY_ERROR_CODE_S	8
 
 /**
  * enum ath5k_phy_error_code - PHY Error codes
  */
 enum ath5k_phy_error_code {
-	AR5K_RX_PHY_ERROR_UNDERRUN		= 0,	/* Transmit underrun */
+	AR5K_RX_PHY_ERROR_UNDERRUN		= 0,	/* Transmit underrun, [5210] No error */
 	AR5K_RX_PHY_ERROR_TIMING		= 1,	/* Timing error */
 	AR5K_RX_PHY_ERROR_PARITY		= 2,	/* Illegal parity */
 	AR5K_RX_PHY_ERROR_RATE			= 3,	/* Illegal rate */
 	AR5K_RX_PHY_ERROR_LENGTH		= 4,	/* Illegal length */
-	AR5K_RX_PHY_ERROR_RADAR			= 5,	/* Radar detect */
+	AR5K_RX_PHY_ERROR_RADAR			= 5,	/* Radar detect, [5210] 64 QAM rate */
 	AR5K_RX_PHY_ERROR_SERVICE		= 6,	/* Illegal service */
 	AR5K_RX_PHY_ERROR_TOR			= 7,	/* Transmit override receive */
 	/* these are specific to the 5212 */
@@ -135,45 +132,41 @@ struct ath5k_hw_2w_tx_ctl {
 } __packed;
 
 /* TX control word 0 fields/flags */
-#define AR5K_2W_TX_DESC_CTL0_FRAME_LEN		0x00000fff
-#define AR5K_2W_TX_DESC_CTL0_HEADER_LEN		0x0003f000 /*[5210 ?]*/
-#define AR5K_2W_TX_DESC_CTL0_HEADER_LEN_S	12
-#define AR5K_2W_TX_DESC_CTL0_XMIT_RATE		0x003c0000
+#define AR5K_2W_TX_DESC_CTL0_FRAME_LEN		0x00000fff /* frame length */
+#define AR5K_2W_TX_DESC_CTL0_HEADER_LEN_5210	0x0003f000 /* [5210] header length */
+#define AR5K_2W_TX_DESC_CTL0_HEADER_LEN_5210_S	12
+#define AR5K_2W_TX_DESC_CTL0_XMIT_RATE		0x003c0000 /* tx rate */
 #define AR5K_2W_TX_DESC_CTL0_XMIT_RATE_S	18
-#define AR5K_2W_TX_DESC_CTL0_RTSENA		0x00400000
-#define AR5K_2W_TX_DESC_CTL0_CLRDMASK		0x01000000
-#define AR5K_2W_TX_DESC_CTL0_LONG_PACKET	0x00800000 /*[5210]*/
-#define AR5K_2W_TX_DESC_CTL0_VEOL		0x00800000 /*[5211]*/
-#define AR5K_2W_TX_DESC_CTL0_FRAME_TYPE		0x1c000000 /*[5210]*/
-#define AR5K_2W_TX_DESC_CTL0_FRAME_TYPE_S	26
-#define AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT_5210	0x02000000
-#define AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT_5211	0x1e000000
-
+#define AR5K_2W_TX_DESC_CTL0_RTSENA		0x00400000 /* RTS/CTS enable */
+#define AR5K_2W_TX_DESC_CTL0_LONG_PACKET_5210	0x00800000 /* [5210] long packet */
+#define AR5K_2W_TX_DESC_CTL0_VEOL		0x00800000 /* [5211] virtual end-of-list TODO */
+#define AR5K_2W_TX_DESC_CTL0_CLRDMASK		0x01000000 /* clear destination mask */
+#define AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT_5210	0x02000000 /* [5210] antenna selection */
+#define AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT_5211	0x1e000000 /* [5211] antenna selection */
 #define AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT			\
 		(ah->ah_version == AR5K_AR5210 ?		\
 		AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT_5210 :	\
 		AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT_5211)
-
 #define AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT_S	25
-#define AR5K_2W_TX_DESC_CTL0_INTREQ		0x20000000
-#define AR5K_2W_TX_DESC_CTL0_ENCRYPT_KEY_VALID	0x40000000
+#define AR5K_2W_TX_DESC_CTL0_FRAME_TYPE_5210	0x1c000000 /* [5210] frame type */
+#define AR5K_2W_TX_DESC_CTL0_FRAME_TYPE_5210_S	26
+#define AR5K_2W_TX_DESC_CTL0_INTREQ		0x20000000 /* TX interrupt request */
+#define AR5K_2W_TX_DESC_CTL0_ENCRYPT_KEY_VALID	0x40000000 /* key is valid */
 
 /* TX control word 1 fields/flags */
-#define AR5K_2W_TX_DESC_CTL1_BUF_LEN		0x00000fff
-#define AR5K_2W_TX_DESC_CTL1_MORE		0x00001000
-#define AR5K_2W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX_5210	0x0007e000
-#define AR5K_2W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX_5211	0x000fe000
-
-#define AR5K_2W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX				\
+#define AR5K_2W_TX_DESC_CTL1_BUF_LEN		0x00000fff /* data buffer length */
+#define AR5K_2W_TX_DESC_CTL1_MORE		0x00001000 /* more desc for this frame */
+#define AR5K_2W_TX_DESC_CTL1_ENC_KEY_IDX_5210	0x0007e000 /* [5210] key table index */
+#define AR5K_2W_TX_DESC_CTL1_ENC_KEY_IDX_5211	0x000fe000 /* [5211] key table index */
+#define AR5K_2W_TX_DESC_CTL1_ENC_KEY_IDX				\
 			(ah->ah_version == AR5K_AR5210 ?		\
-			AR5K_2W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX_5210 :	\
-			AR5K_2W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX_5211)
-
-#define AR5K_2W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX_S	13
-#define AR5K_2W_TX_DESC_CTL1_FRAME_TYPE		0x00700000 /*[5211]*/
-#define AR5K_2W_TX_DESC_CTL1_FRAME_TYPE_S	20
-#define AR5K_2W_TX_DESC_CTL1_NOACK		0x00800000 /*[5211]*/
-#define AR5K_2W_TX_DESC_CTL1_RTS_DURATION	0xfff80000 /*[5210 ?]*/
+			AR5K_2W_TX_DESC_CTL1_ENC_KEY_IDX_5210 :		\
+			AR5K_2W_TX_DESC_CTL1_ENC_KEY_IDX_5211)
+#define AR5K_2W_TX_DESC_CTL1_ENC_KEY_IDX_S	13
+#define AR5K_2W_TX_DESC_CTL1_FRAME_TYPE_5211	0x00700000 /* [5211] frame type */
+#define AR5K_2W_TX_DESC_CTL1_FRAME_TYPE_5211_S	20
+#define AR5K_2W_TX_DESC_CTL1_NOACK		0x00800000 /* [5211] no ACK TODO */
+#define AR5K_2W_TX_DESC_CTL1_RTS_DURATION_5210	0xfff80000 /* [5210] lower 13 bit of duration */
 
 /* Frame types */
 #define AR5K_AR5210_TX_DESC_FRAME_TYPE_NORMAL   0x00
@@ -187,60 +180,61 @@ struct ath5k_hw_2w_tx_ctl {
  */
 struct ath5k_hw_4w_tx_ctl {
 	u32	tx_control_0; /* TX control word 0 */
+	u32	tx_control_1; /* TX control word 1 */
+	u32	tx_control_2; /* TX control word 2 */
+	u32	tx_control_3; /* TX control word 3 */
+} __packed;
 
-#define AR5K_4W_TX_DESC_CTL0_FRAME_LEN		0x00000fff
-#define AR5K_4W_TX_DESC_CTL0_XMIT_POWER		0x003f0000
+/* TX control word 0 fields/flags */
+#define AR5K_4W_TX_DESC_CTL0_FRAME_LEN		0x00000fff /* frame length */
+#define AR5K_4W_TX_DESC_CTL0_XMIT_POWER		0x003f0000 /* transmit power */
 #define AR5K_4W_TX_DESC_CTL0_XMIT_POWER_S	16
-#define AR5K_4W_TX_DESC_CTL0_RTSENA		0x00400000
-#define AR5K_4W_TX_DESC_CTL0_VEOL		0x00800000
-#define AR5K_4W_TX_DESC_CTL0_CLRDMASK		0x01000000
-#define AR5K_4W_TX_DESC_CTL0_ANT_MODE_XMIT	0x1e000000
+#define AR5K_4W_TX_DESC_CTL0_RTSENA		0x00400000 /* RTS/CTS enable */
+#define AR5K_4W_TX_DESC_CTL0_VEOL		0x00800000 /* virtual end-of-list */
+#define AR5K_4W_TX_DESC_CTL0_CLRDMASK		0x01000000 /* clear destination mask */
+#define AR5K_4W_TX_DESC_CTL0_ANT_MODE_XMIT	0x1e000000 /* TX antenna selection */
 #define AR5K_4W_TX_DESC_CTL0_ANT_MODE_XMIT_S	25
-#define AR5K_4W_TX_DESC_CTL0_INTREQ		0x20000000
-#define AR5K_4W_TX_DESC_CTL0_ENCRYPT_KEY_VALID	0x40000000
-#define AR5K_4W_TX_DESC_CTL0_CTSENA		0x80000000
+#define AR5K_4W_TX_DESC_CTL0_INTREQ		0x20000000 /* TX interrupt request */
+#define AR5K_4W_TX_DESC_CTL0_ENCRYPT_KEY_VALID	0x40000000 /* destination index valid */
+#define AR5K_4W_TX_DESC_CTL0_CTSENA		0x80000000 /* precede frame with CTS */
 
-	u32	tx_control_1; /* TX control word 1 */
-
-#define AR5K_4W_TX_DESC_CTL1_BUF_LEN		0x00000fff
-#define AR5K_4W_TX_DESC_CTL1_MORE		0x00001000
-#define AR5K_4W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX	0x000fe000
-#define AR5K_4W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX_S	13
-#define AR5K_4W_TX_DESC_CTL1_FRAME_TYPE		0x00f00000
+/* TX control word 1 fields/flags */
+#define AR5K_4W_TX_DESC_CTL1_BUF_LEN		0x00000fff /* data buffer length */
+#define AR5K_4W_TX_DESC_CTL1_MORE		0x00001000 /* more desc for this frame */
+#define AR5K_4W_TX_DESC_CTL1_ENCRYPT_KEY_IDX	0x000fe000 /* destination table index */
+#define AR5K_4W_TX_DESC_CTL1_ENCRYPT_KEY_IDX_S	13
+#define AR5K_4W_TX_DESC_CTL1_FRAME_TYPE		0x00f00000 /* frame type */
 #define AR5K_4W_TX_DESC_CTL1_FRAME_TYPE_S	20
-#define AR5K_4W_TX_DESC_CTL1_NOACK		0x01000000
-#define AR5K_4W_TX_DESC_CTL1_COMP_PROC		0x06000000
+#define AR5K_4W_TX_DESC_CTL1_NOACK		0x01000000 /* no ACK */
+#define AR5K_4W_TX_DESC_CTL1_COMP_PROC		0x06000000 /* compression processing */
 #define AR5K_4W_TX_DESC_CTL1_COMP_PROC_S	25
-#define AR5K_4W_TX_DESC_CTL1_COMP_IV_LEN	0x18000000
+#define AR5K_4W_TX_DESC_CTL1_COMP_IV_LEN	0x18000000 /* length of frame IV */
 #define AR5K_4W_TX_DESC_CTL1_COMP_IV_LEN_S	27
-#define AR5K_4W_TX_DESC_CTL1_COMP_ICV_LEN	0x60000000
+#define AR5K_4W_TX_DESC_CTL1_COMP_ICV_LEN	0x60000000 /* length of frame ICV */
 #define AR5K_4W_TX_DESC_CTL1_COMP_ICV_LEN_S	29
 
-	u32	tx_control_2; /* TX control word 2 */
-
-#define AR5K_4W_TX_DESC_CTL2_RTS_DURATION		0x00007fff
-#define AR5K_4W_TX_DESC_CTL2_DURATION_UPDATE_ENABLE	0x00008000
-#define AR5K_4W_TX_DESC_CTL2_XMIT_TRIES0		0x000f0000
-#define AR5K_4W_TX_DESC_CTL2_XMIT_TRIES0_S		16
-#define AR5K_4W_TX_DESC_CTL2_XMIT_TRIES1		0x00f00000
-#define AR5K_4W_TX_DESC_CTL2_XMIT_TRIES1_S		20
-#define AR5K_4W_TX_DESC_CTL2_XMIT_TRIES2		0x0f000000
-#define AR5K_4W_TX_DESC_CTL2_XMIT_TRIES2_S		24
-#define AR5K_4W_TX_DESC_CTL2_XMIT_TRIES3		0xf0000000
-#define AR5K_4W_TX_DESC_CTL2_XMIT_TRIES3_S		28
-
-	u32	tx_control_3; /* TX control word 3 */
-
-#define AR5K_4W_TX_DESC_CTL3_XMIT_RATE0		0x0000001f
-#define AR5K_4W_TX_DESC_CTL3_XMIT_RATE1		0x000003e0
+/* TX control word 2 fields/flags */
+#define AR5K_4W_TX_DESC_CTL2_RTS_DURATION	0x00007fff /* RTS/CTS duration */
+#define AR5K_4W_TX_DESC_CTL2_DURATION_UPD_EN	0x00008000 /* frame duration update */
+#define AR5K_4W_TX_DESC_CTL2_XMIT_TRIES0	0x000f0000 /* series 0 max attempts */
+#define AR5K_4W_TX_DESC_CTL2_XMIT_TRIES0_S	16
+#define AR5K_4W_TX_DESC_CTL2_XMIT_TRIES1	0x00f00000 /* series 1 max attempts */
+#define AR5K_4W_TX_DESC_CTL2_XMIT_TRIES1_S	20
+#define AR5K_4W_TX_DESC_CTL2_XMIT_TRIES2	0x0f000000 /* series 2 max attempts */
+#define AR5K_4W_TX_DESC_CTL2_XMIT_TRIES2_S	24
+#define AR5K_4W_TX_DESC_CTL2_XMIT_TRIES3	0xf0000000 /* series 3 max attempts */
+#define AR5K_4W_TX_DESC_CTL2_XMIT_TRIES3_S	28
+
+/* TX control word 3 fields/flags */
+#define AR5K_4W_TX_DESC_CTL3_XMIT_RATE0		0x0000001f /* series 0 tx rate */
+#define AR5K_4W_TX_DESC_CTL3_XMIT_RATE1		0x000003e0 /* series 1 tx rate */
 #define AR5K_4W_TX_DESC_CTL3_XMIT_RATE1_S	5
-#define AR5K_4W_TX_DESC_CTL3_XMIT_RATE2		0x00007c00
+#define AR5K_4W_TX_DESC_CTL3_XMIT_RATE2		0x00007c00 /* series 2 tx rate */
 #define AR5K_4W_TX_DESC_CTL3_XMIT_RATE2_S	10
-#define AR5K_4W_TX_DESC_CTL3_XMIT_RATE3		0x000f8000
+#define AR5K_4W_TX_DESC_CTL3_XMIT_RATE3		0x000f8000 /* series 3 tx rate */
 #define AR5K_4W_TX_DESC_CTL3_XMIT_RATE3_S	15
-#define AR5K_4W_TX_DESC_CTL3_RTS_CTS_RATE	0x01f00000
+#define AR5K_4W_TX_DESC_CTL3_RTS_CTS_RATE	0x01f00000 /* RTS or CTS rate */
 #define AR5K_4W_TX_DESC_CTL3_RTS_CTS_RATE_S	20
-} __packed;
 
 /*
  * Common TX status descriptor
@@ -251,37 +245,34 @@ struct ath5k_hw_tx_status {
 } __packed;
 
 /* TX status word 0 fields/flags */
-#define AR5K_DESC_TX_STATUS0_FRAME_XMIT_OK	0x00000001
-#define AR5K_DESC_TX_STATUS0_EXCESSIVE_RETRIES	0x00000002
-#define AR5K_DESC_TX_STATUS0_FIFO_UNDERRUN	0x00000004
-#define AR5K_DESC_TX_STATUS0_FILTERED		0x00000008
-/*???
-#define AR5K_DESC_TX_STATUS0_RTS_FAIL_COUNT	0x000000f0
-#define AR5K_DESC_TX_STATUS0_RTS_FAIL_COUNT_S	4
-*/
-#define AR5K_DESC_TX_STATUS0_SHORT_RETRY_COUNT	0x000000f0
+#define AR5K_DESC_TX_STATUS0_FRAME_XMIT_OK	0x00000001 /* TX success */
+#define AR5K_DESC_TX_STATUS0_EXCESSIVE_RETRIES	0x00000002 /* excessive retries */
+#define AR5K_DESC_TX_STATUS0_FIFO_UNDERRUN	0x00000004 /* FIFO underrun */
+#define AR5K_DESC_TX_STATUS0_FILTERED		0x00000008 /* TX filter indication */
+/* according to the HAL sources the spec has short/long retry counts reversed.
+ * we have it reversed to the HAL sources as well, for 5210 and 5211.
+ * For 5212 these fields are defined as RTS_FAIL_COUNT and DATA_FAIL_COUNT,
+ * but used respectively as SHORT and LONG retry count in the code later. This
+ * is consistent with the definitions here... TODO: check */
+#define AR5K_DESC_TX_STATUS0_SHORT_RETRY_COUNT	0x000000f0 /* short retry count */
 #define AR5K_DESC_TX_STATUS0_SHORT_RETRY_COUNT_S	4
-/*???
-#define AR5K_DESC_TX_STATUS0_DATA_FAIL_COUNT	0x00000f00
-#define AR5K_DESC_TX_STATUS0_DATA_FAIL_COUNT_S	8
-*/
-#define AR5K_DESC_TX_STATUS0_LONG_RETRY_COUNT	0x00000f00
+#define AR5K_DESC_TX_STATUS0_LONG_RETRY_COUNT	0x00000f00 /* long retry count */
 #define AR5K_DESC_TX_STATUS0_LONG_RETRY_COUNT_S	8
-#define AR5K_DESC_TX_STATUS0_VIRT_COLL_COUNT	0x0000f000
-#define AR5K_DESC_TX_STATUS0_VIRT_COLL_COUNT_S	12
-#define AR5K_DESC_TX_STATUS0_SEND_TIMESTAMP	0xffff0000
+#define AR5K_DESC_TX_STATUS0_VIRTCOLL_CT_5211	0x0000f000 /* [5211+] virtual collision count */
+#define AR5K_DESC_TX_STATUS0_VIRTCOLL_CT_5212_S	12
+#define AR5K_DESC_TX_STATUS0_SEND_TIMESTAMP	0xffff0000 /* TX timestamp */
 #define AR5K_DESC_TX_STATUS0_SEND_TIMESTAMP_S	16
 
 /* TX status word 1 fields/flags */
-#define AR5K_DESC_TX_STATUS1_DONE		0x00000001
-#define AR5K_DESC_TX_STATUS1_SEQ_NUM		0x00001ffe
+#define AR5K_DESC_TX_STATUS1_DONE		0x00000001 /* descriptor complete */
+#define AR5K_DESC_TX_STATUS1_SEQ_NUM		0x00001ffe /* TX sequence number */
 #define AR5K_DESC_TX_STATUS1_SEQ_NUM_S		1
-#define AR5K_DESC_TX_STATUS1_ACK_SIG_STRENGTH	0x001fe000
+#define AR5K_DESC_TX_STATUS1_ACK_SIG_STRENGTH	0x001fe000 /* signal strength of ACK */
 #define AR5K_DESC_TX_STATUS1_ACK_SIG_STRENGTH_S	13
-#define AR5K_DESC_TX_STATUS1_FINAL_TS_INDEX	0x00600000
-#define AR5K_DESC_TX_STATUS1_FINAL_TS_INDEX_S	21
-#define AR5K_DESC_TX_STATUS1_COMP_SUCCESS	0x00800000
-#define AR5K_DESC_TX_STATUS1_XMIT_ANTENNA	0x01000000
+#define AR5K_DESC_TX_STATUS1_FINAL_TS_IX_5212	0x00600000 /* [5212] final TX attempt series ix */
+#define AR5K_DESC_TX_STATUS1_FINAL_TS_IX_5212_S	21
+#define AR5K_DESC_TX_STATUS1_COMP_SUCCESS_5212	0x00800000 /* [5212] compression status */
+#define AR5K_DESC_TX_STATUS1_XMIT_ANTENNA_5212	0x01000000 /* [5212] transmit antenna */
 
 /*
  * 5210/5211 hardware TX descriptor
@@ -300,7 +291,7 @@ struct ath5k_hw_5212_tx_desc {
 } __packed;
 
 /*
- * common hardware RX descriptor
+ * Common hardware RX descriptor
  */
 struct ath5k_hw_all_rx_desc {
 	struct ath5k_hw_rx_ctl		rx_ctl;
@@ -308,7 +299,7 @@ struct ath5k_hw_all_rx_desc {
 } __packed;
 
 /*
- * Atheros hardware descriptor
+ * Atheros hardware DMA descriptor
  * This is read and written to by the hardware
  */
 struct ath5k_desc {
@@ -330,4 +321,3 @@ struct ath5k_desc {
 #define AR5K_TXDESC_CTSENA	0x0008
 #define AR5K_TXDESC_INTREQ	0x0010
 #define AR5K_TXDESC_VEOL	0x0020	/*[5211+]*/
-

