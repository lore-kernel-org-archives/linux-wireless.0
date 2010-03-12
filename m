Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:60656 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755948Ab0CLDCu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 22:02:50 -0500
Message-ID: <4B99AED3.4000204@openwrt.org>
Date: Fri, 12 Mar 2010 04:02:43 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Sujith <Sujith.Manoharan@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath9k: fix BUG_ON triggered by PAE frames
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When I initially stumbled upon sequence number problems with PAE frames
in ath9k, I submitted a patch to remove all special cases for PAE
frames and let them go through the normal transmit path.
Out of concern about crypto incompatibility issues, this change was
merged instead:

commit 6c8afef551fef87a3bf24f8a74c69a7f2f72fc82
Author: Sujith <Sujith.Manoharan@atheros.com>
Date:   Tue Feb 9 10:07:00 2010 +0530

    ath9k: Fix sequence numbers for PAE frames

After a lot of testing, I'm able to reliably trigger a driver crash on
rekeying with current versions with this change in place.
It seems that the driver does not support sending out regular MPDUs with
the same TID while an A-MPDU session is active.
This leads to duplicate entries in the TID Tx buffer, which hits the
following BUG_ON in ath_tx_addto_baw():

    index  = ATH_BA_INDEX(tid->seq_start, bf->bf_seqno);
    cindex = (tid->baw_head + index) & (ATH_TID_MAX_BUFS - 1);

    BUG_ON(tid->tx_buf[cindex] != NULL);

I believe until we actually have a reproducible case of an
incompatibility with another AP using no PAE special cases, we should
simply get rid of this mess.

This patch completely fixes my crash issues in STA mode and makes it
stay connected without throughput drops or connectivity issues even
when the AP is configured to a very short group rekey interval.

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
@@ -1696,7 +1677,7 @@ static void ath_tx_start_dma(struct ath_
 			goto tx_done;
 		}
 
-		if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) && !is_pae(skb)) {
+		if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
 			/*
 			 * Try aggregation if it's a unicast data frame
 			 * and the destination is HT capable.
