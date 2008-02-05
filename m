Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:30851 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753616AbYBEJpL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2008 04:45:11 -0500
From: Bruno Randolf <bruno@thinktube.com>
Subject: [PATCH] ath5k: correct padding in tx descriptors
To: ath5k-devel@lists.ath5k.org
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Tue, 05 Feb 2008 18:44:55 +0900
Message-ID: <20080205094454.30490.2876.stgit@one> (sfid-20080205_094517_347085_105ABB26)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

when setting up the tx descriptors for the hardware we must account for any
padding between the header and the data we might have added previously. frame
len is the length of the frame in the air (including FCS but no padding) and
buffer len is the length of the buffer (including padding, but without FCS).

changing the way ah_setup_tx_desc is called: now excluding the FCS, since it's
easier to add that in the function where we need it.

before this fix we sent trailing zero bytes after the packet (because frame len
included the padding) which was not a big problem without WEP, but with WEP
this resultes in a wrong WEP checksum and the packet is discarded - which is
how i noticed at all ;)

an easy way to run into header padding problems, btw, is to connect to a QoS
(WME) enabled access point (eg. madwifi) - QoS data frames are 2 byte longer
and will require padding.

this patch applies on top of luis latest patch series from 04.02.2008.

drivers/net/wireless/ath5k/base.c:      Changes-licensed-under: 3-Clause-BSD
drivers/net/wireless/ath5k/hw.c:        Changes-licensed-under: ISC

Signed-off-by: Bruno Randolf <bruno@thinktube.com>
---

 drivers/net/wireless/ath5k/base.c |    4 ++--
 drivers/net/wireless/ath5k/hw.c   |   34 ++++++++++++++++++++--------------
 2 files changed, 22 insertions(+), 16 deletions(-)


diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index ef9655c..1ab53ec 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1312,7 +1312,7 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
 	if (ctl->flags & IEEE80211_TXCTL_NO_ACK)
 		flags |= AR5K_TXDESC_NOACK;
 
-	pktlen = skb->len + FCS_LEN;
+	pktlen = skb->len;
 
 	if (!(ctl->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT)) {
 		keyidx = ctl->key_idx;
@@ -2009,7 +2009,7 @@ ath5k_beacon_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
 	}
 
 	ds->ds_data = bf->skbaddr;
-	ret = ah->ah_setup_tx_desc(ah, ds, skb->len + FCS_LEN,
+	ret = ah->ah_setup_tx_desc(ah, ds, skb->len,
 			ieee80211_get_hdrlen_from_skb(skb),
 			AR5K_PKT_TYPE_BEACON, (sc->power_level * 2),
 			ctl->tx_rate->hw_value, 1, AR5K_TXKEYIX_INVALID,
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index ac7f715..3c31b89 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -3457,7 +3457,7 @@ ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 {
 	u32 frame_type;
 	struct ath5k_hw_2w_tx_desc *tx_desc;
-	unsigned int buff_len;
+	unsigned int frame_len;
 
 	tx_desc = (struct ath5k_hw_2w_tx_desc *)&desc->ds_ctl0;
 
@@ -3488,22 +3488,25 @@ ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 	/* Setup control descriptor */
 
 	/* Verify and set frame length */
-	if (pkt_len & ~AR5K_2W_TX_DESC_CTL0_FRAME_LEN)
+
+	/* remove padding we might have added before */
+	frame_len = pkt_len - (hdr_len & 3) + FCS_LEN;
+
+	if (frame_len & ~AR5K_2W_TX_DESC_CTL0_FRAME_LEN)
 		return -EINVAL;
 
-	tx_desc->tx_control_0 = pkt_len & AR5K_2W_TX_DESC_CTL0_FRAME_LEN;
+	tx_desc->tx_control_0 = frame_len & AR5K_2W_TX_DESC_CTL0_FRAME_LEN;
 
 	/* Verify and set buffer length */
-	buff_len = pkt_len - FCS_LEN;
 
 	/* NB: beacon's BufLen must be a multiple of 4 bytes */
 	if(type == AR5K_PKT_TYPE_BEACON)
-		buff_len = roundup(buff_len, 4);
+		pkt_len = roundup(pkt_len, 4);
 
-	if (buff_len & ~AR5K_2W_TX_DESC_CTL1_BUF_LEN)
+	if (pkt_len & ~AR5K_2W_TX_DESC_CTL1_BUF_LEN)
 		return -EINVAL;
 
-	tx_desc->tx_control_1 = buff_len & AR5K_2W_TX_DESC_CTL1_BUF_LEN;
+	tx_desc->tx_control_1 = pkt_len & AR5K_2W_TX_DESC_CTL1_BUF_LEN;
 
 	/*
 	 * Verify and set header length
@@ -3585,7 +3588,7 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
 {
 	struct ath5k_hw_4w_tx_desc *tx_desc;
 	struct ath5k_hw_tx_status *tx_status;
-	unsigned int buff_len;
+	unsigned int frame_len;
 
 	ATH5K_TRACE(ah->ah_sc);
 	tx_desc = (struct ath5k_hw_4w_tx_desc *)&desc->ds_ctl0;
@@ -3620,22 +3623,25 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
 	/* Setup control descriptor */
 
 	/* Verify and set frame length */
-	if (pkt_len & ~AR5K_4W_TX_DESC_CTL0_FRAME_LEN)
+
+	/* remove padding we might have added before */
+	frame_len = pkt_len - (hdr_len & 3) + FCS_LEN;
+
+	if (frame_len & ~AR5K_4W_TX_DESC_CTL0_FRAME_LEN)
 		return -EINVAL;
 
-	tx_desc->tx_control_0 = pkt_len & AR5K_4W_TX_DESC_CTL0_FRAME_LEN;
+	tx_desc->tx_control_0 = frame_len & AR5K_4W_TX_DESC_CTL0_FRAME_LEN;
 
 	/* Verify and set buffer length */
-	buff_len = pkt_len - FCS_LEN;
 
 	/* NB: beacon's BufLen must be a multiple of 4 bytes */
 	if(type == AR5K_PKT_TYPE_BEACON)
-		buff_len = roundup(buff_len, 4);
+		pkt_len = roundup(pkt_len, 4);
 
-	if (buff_len & ~AR5K_4W_TX_DESC_CTL1_BUF_LEN)
+	if (pkt_len & ~AR5K_4W_TX_DESC_CTL1_BUF_LEN)
 		return -EINVAL;
 
-	tx_desc->tx_control_1 = buff_len & AR5K_4W_TX_DESC_CTL1_BUF_LEN;
+	tx_desc->tx_control_1 = pkt_len & AR5K_4W_TX_DESC_CTL1_BUF_LEN;
 
 	tx_desc->tx_control_0 |=
 		AR5K_REG_SM(tx_power, AR5K_4W_TX_DESC_CTL0_XMIT_POWER) |

