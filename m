Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:59643 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149Ab0AaVdo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2010 16:33:44 -0500
Message-ID: <4B65F735.1020509@openwrt.org>
Date: Sun, 31 Jan 2010 22:33:41 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath9k: fix PAE frame handling
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k's tx handling code contains a special case for PAE frames, which
looks like it was intended to be improving reliability by excluding
them from aggregates.
What it actually did is the opposite: By assigning a faulty sequence
number, yet still keeping it as a qos-frame, it caused bogus packet
reordering, which broke WPA rekeying.
The special case handling is completely unnecessary, so this patch
removes it.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@kernel.org
---
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1353,25 +1353,6 @@ static enum ath9k_pkt_type get_hw_packet
 	return htype;
 }
 
-static bool is_pae(struct sk_buff *skb)
-{
-	struct ieee80211_hdr *hdr;
-	__le16 fc;
-
-	hdr = (struct ieee80211_hdr *)skb->data;
-	fc = hdr->frame_control;
-
-	if (ieee80211_is_data(fc)) {
-		if (ieee80211_is_nullfunc(fc) ||
-		    /* Port Access Entity (IEEE 802.1X) */
-		    (skb->protocol == cpu_to_be16(ETH_P_PAE))) {
-			return true;
-		}
-	}
-
-	return false;
-}
-
 static int get_hw_crypto_keytype(struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
@@ -1610,7 +1591,7 @@ static int ath_tx_setup_buffer(struct ie
 		bf->bf_frmlen -= padsize;
 	}
 
-	if (conf_is_ht(&hw->conf) && !is_pae(skb))
+	if (conf_is_ht(&hw->conf))
 		bf->bf_state.bf_type |= BUF_HT;
 
 	bf->bf_flags = setup_tx_flags(sc, skb, txctl->txq);
