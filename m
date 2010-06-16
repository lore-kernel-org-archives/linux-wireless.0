Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:49853 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758618Ab0FPKMs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 06:12:48 -0400
Received: from vs3006.wh2.ocn.ne.jp (125.206.180.169)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0581303166
	for <linux-wireless@vger.kernel.org>; Wed, 16 Jun 2010 19:12:46 +0900 (JST)
Subject: [PATCH 15/17] ath5k: take descriptor differences between 5210 and
	5211 into account
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Wed, 16 Jun 2010 19:12:28 +0900
Message-ID: <20100616101228.10067.50501.stgit@tt-desk>
In-Reply-To: <20100616100809.10067.34787.stgit@tt-desk>
References: <20100616100809.10067.34787.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are some differences between 5210 and 5211 descriptors which we did not
take into account before.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/desc.c |   29 ++++++++++++++++++++++-------
 drivers/net/wireless/ath/ath5k/desc.h |    6 +++---
 2 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/desc.c b/drivers/net/wireless/ath/ath5k/desc.c
index f1f1a22..019525d 100644
--- a/drivers/net/wireless/ath/ath5k/desc.c
+++ b/drivers/net/wireless/ath/ath5k/desc.c
@@ -91,8 +91,7 @@ ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 	tx_ctl->tx_control_1 = pkt_len & AR5K_2W_TX_DESC_CTL1_BUF_LEN;
 
 	/*
-	 * Verify and set header length
-	 * XXX: I only found that on 5210 code, does it work on 5211 ?
+	 * Verify and set header length (only 5210)
 	 */
 	if (ah->ah_version == AR5K_AR5210) {
 		if (hdr_len & ~AR5K_2W_TX_DESC_CTL0_HEADER_LEN_5210)
@@ -125,19 +124,28 @@ ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 		tx_ctl->tx_control_1 |=
 			AR5K_REG_SM(type, AR5K_2W_TX_DESC_CTL1_FRAME_TYPE_5211);
 	}
+
 #define _TX_FLAGS(_c, _flag)					\
 	if (flags & AR5K_TXDESC_##_flag) {			\
 		tx_ctl->tx_control_##_c |=			\
 			AR5K_2W_TX_DESC_CTL##_c##_##_flag;	\
 	}
-
+#define _TX_FLAGS_5211(_c, _flag)					\
+	if (flags & AR5K_TXDESC_##_flag) {				\
+		tx_ctl->tx_control_##_c |=				\
+			AR5K_2W_TX_DESC_CTL##_c##_##_flag##_5211;	\
+	}
 	_TX_FLAGS(0, CLRDMASK);
-	_TX_FLAGS(0, VEOL);
 	_TX_FLAGS(0, INTREQ);
 	_TX_FLAGS(0, RTSENA);
-	_TX_FLAGS(1, NOACK);
+
+	if (ah->ah_version == AR5K_AR5211) {
+		_TX_FLAGS_5211(0, VEOL);
+		_TX_FLAGS_5211(1, NOACK);
+	}
 
 #undef _TX_FLAGS
+#undef _TX_FLAGS_5211
 
 	/*
 	 * WEP crap
@@ -526,13 +534,20 @@ static int ath5k_hw_proc_5210_rx_status(struct ath5k_hw *ah,
 		AR5K_5210_RX_DESC_STATUS0_RECEIVE_SIGNAL);
 	rs->rs_rate = AR5K_REG_MS(rx_status->rx_status_0,
 		AR5K_5210_RX_DESC_STATUS0_RECEIVE_RATE);
-	rs->rs_antenna = AR5K_REG_MS(rx_status->rx_status_0,
-		AR5K_5210_RX_DESC_STATUS0_RECEIVE_ANT_5211);
 	rs->rs_more = !!(rx_status->rx_status_0 &
 		AR5K_5210_RX_DESC_STATUS0_MORE);
 	/* TODO: this timestamp is 13 bit, later on we assume 15 bit */
 	rs->rs_tstamp = AR5K_REG_MS(rx_status->rx_status_1,
 		AR5K_5210_RX_DESC_STATUS1_RECEIVE_TIMESTAMP);
+
+	if (ah->ah_version == AR5K_AR5211)
+		rs->rs_antenna = AR5K_REG_MS(rx_status->rx_status_0,
+				AR5K_5210_RX_DESC_STATUS0_RECEIVE_ANT_5211);
+	else
+		rs->rs_antenna = (rx_status->rx_status_0 &
+				AR5K_5210_RX_DESC_STATUS0_RECEIVE_ANT_5210)
+				? 2 : 1;
+
 	rs->rs_status = 0;
 	rs->rs_phyerr = 0;
 
diff --git a/drivers/net/wireless/ath/ath5k/desc.h b/drivers/net/wireless/ath/ath5k/desc.h
index 1aca4af..b2adb2a 100644
--- a/drivers/net/wireless/ath/ath5k/desc.h
+++ b/drivers/net/wireless/ath/ath5k/desc.h
@@ -45,7 +45,7 @@ struct ath5k_hw_rx_status {
 /* RX status word 0 fields/flags */
 #define AR5K_5210_RX_DESC_STATUS0_DATA_LEN		0x00000fff /* RX data length */
 #define AR5K_5210_RX_DESC_STATUS0_MORE			0x00001000 /* more desc for this frame */
-#define AR5K_5210_RX_DESC_STATUS0_RECEIVE_ANT_5210	0x00004000 /* [5210] receive on ant 1 TODO */
+#define AR5K_5210_RX_DESC_STATUS0_RECEIVE_ANT_5210	0x00004000 /* [5210] receive on ant 1 */
 #define AR5K_5210_RX_DESC_STATUS0_RECEIVE_RATE		0x00078000 /* reception rate */
 #define AR5K_5210_RX_DESC_STATUS0_RECEIVE_RATE_S	15
 #define AR5K_5210_RX_DESC_STATUS0_RECEIVE_SIGNAL	0x07f80000 /* rssi */
@@ -139,7 +139,7 @@ struct ath5k_hw_2w_tx_ctl {
 #define AR5K_2W_TX_DESC_CTL0_XMIT_RATE_S	18
 #define AR5K_2W_TX_DESC_CTL0_RTSENA		0x00400000 /* RTS/CTS enable */
 #define AR5K_2W_TX_DESC_CTL0_LONG_PACKET_5210	0x00800000 /* [5210] long packet */
-#define AR5K_2W_TX_DESC_CTL0_VEOL		0x00800000 /* [5211] virtual end-of-list TODO */
+#define AR5K_2W_TX_DESC_CTL0_VEOL_5211		0x00800000 /* [5211] virtual end-of-list */
 #define AR5K_2W_TX_DESC_CTL0_CLRDMASK		0x01000000 /* clear destination mask */
 #define AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT_5210	0x02000000 /* [5210] antenna selection */
 #define AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT_5211	0x1e000000 /* [5211] antenna selection */
@@ -165,7 +165,7 @@ struct ath5k_hw_2w_tx_ctl {
 #define AR5K_2W_TX_DESC_CTL1_ENC_KEY_IDX_S	13
 #define AR5K_2W_TX_DESC_CTL1_FRAME_TYPE_5211	0x00700000 /* [5211] frame type */
 #define AR5K_2W_TX_DESC_CTL1_FRAME_TYPE_5211_S	20
-#define AR5K_2W_TX_DESC_CTL1_NOACK		0x00800000 /* [5211] no ACK TODO */
+#define AR5K_2W_TX_DESC_CTL1_NOACK_5211		0x00800000 /* [5211] no ACK */
 #define AR5K_2W_TX_DESC_CTL1_RTS_DURATION_5210	0xfff80000 /* [5210] lower 13 bit of duration */
 
 /* Frame types */

