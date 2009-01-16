Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:46742 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757995AbZAPQMV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 11:12:21 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2009 08:12:21 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18800.45336.294871.849693@gargle.gargle.HOWL> (sfid-20090116_171224_198818_6C471279)
Date: Fri, 16 Jan 2009 21:38:56 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 9/9] ath9k: Cleanup buffer type assignment
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The buffer state is already cleared in ATH_TXBUF_RESET.
Remove redundant code clearing the type variable.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/xmit.c |   28 +++++++++++-----------------
 1 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 0d05a7f..1b83673 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -1576,27 +1576,21 @@ static int ath_tx_setup_buffer(struct ath_softc *sc, struct ath_buf *bf,
 
 	bf->bf_frmlen = skb->len + FCS_LEN - (hdrlen & 3);
 
-	ieee80211_is_data(fc) ?
-		(bf->bf_state.bf_type |= BUF_DATA) :
-		(bf->bf_state.bf_type &= ~BUF_DATA);
-	ieee80211_is_back_req(fc) ?
-		(bf->bf_state.bf_type |= BUF_BAR) :
-		(bf->bf_state.bf_type &= ~BUF_BAR);
-	ieee80211_is_pspoll(fc) ?
-		(bf->bf_state.bf_type |= BUF_PSPOLL) :
-		(bf->bf_state.bf_type &= ~BUF_PSPOLL);
-	(sc->sc_flags & SC_OP_PREAMBLE_SHORT) ?
-		(bf->bf_state.bf_type |= BUF_SHORT_PREAMBLE) :
-		(bf->bf_state.bf_type &= ~BUF_SHORT_PREAMBLE);
-	(conf_is_ht(&sc->hw->conf) && !is_pae(skb) &&
-	 (tx_info->flags & IEEE80211_TX_CTL_AMPDU)) ?
-		(bf->bf_state.bf_type |= BUF_HT) :
-		(bf->bf_state.bf_type &= ~BUF_HT);
+	if (ieee80211_is_data(fc))
+		bf->bf_state.bf_type |= BUF_DATA;
+	if (ieee80211_is_back_req(fc))
+		bf->bf_state.bf_type |= BUF_BAR;
+	if (ieee80211_is_pspoll(fc))
+		bf->bf_state.bf_type |= BUF_PSPOLL;
+	if (sc->sc_flags & SC_OP_PREAMBLE_SHORT)
+		bf->bf_state.bf_type |= BUF_SHORT_PREAMBLE;
+	if ((conf_is_ht(&sc->hw->conf) && !is_pae(skb) &&
+	     (tx_info->flags & IEEE80211_TX_CTL_AMPDU)))
+		bf->bf_state.bf_type |= BUF_HT;
 
 	bf->bf_flags = setup_tx_flags(sc, skb, txctl->txq);
 
 	bf->bf_keytype = get_hw_crypto_keytype(skb);
-
 	if (bf->bf_keytype != ATH9K_KEY_TYPE_CLEAR) {
 		bf->bf_frmlen += tx_info->control.hw_key->icv_len;
 		bf->bf_keyix = tx_info->control.hw_key->hw_key_idx;
-- 
1.6.0.3

