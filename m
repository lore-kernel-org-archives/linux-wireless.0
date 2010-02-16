Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:55999 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756625Ab0BPP4Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 10:56:25 -0500
Date: Tue, 16 Feb 2010 17:56:18 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Use the Beacon TX rate from mac80211
Message-ID: <20100216155618.GA27640@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of hardcoding the lowest rate for Beacon frames, use the rate
index specified in the mac80211 TX info in AP mode.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath/ath9k/beacon.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- uml.orig/drivers/net/wireless/ath/ath9k/beacon.c	2010-02-16 17:52:01.000000000 +0200
+++ uml/drivers/net/wireless/ath/ath9k/beacon.c	2010-02-16 17:53:54.000000000 +0200
@@ -62,7 +62,7 @@ int ath_beaconq_config(struct ath_softc 
  *  Beacons are always sent out at the lowest rate, and are not retried.
 */
 static void ath_beacon_setup(struct ath_softc *sc, struct ath_vif *avp,
-			     struct ath_buf *bf)
+			     struct ath_buf *bf, int rateidx)
 {
 	struct sk_buff *skb = bf->bf_mpdu;
 	struct ath_hw *ah = sc->sc_ah;
@@ -96,9 +96,9 @@ static void ath_beacon_setup(struct ath_
 	ds->ds_data = bf->bf_buf_addr;
 
 	sband = &sc->sbands[common->hw->conf.channel->band];
-	rate = sband->bitrates[0].hw_value;
+	rate = sband->bitrates[rateidx].hw_value;
 	if (sc->sc_flags & SC_OP_PREAMBLE_SHORT)
-		rate |= sband->bitrates[0].hw_value_short;
+		rate |= sband->bitrates[rateidx].hw_value_short;
 
 	ath9k_hw_set11n_txdesc(ah, ds, skb->len + FCS_LEN,
 			       ATH9K_PKT_TYPE_BEACON,
@@ -206,7 +206,7 @@ static struct ath_buf *ath_beacon_genera
 		}
 	}
 
-	ath_beacon_setup(sc, avp, bf);
+	ath_beacon_setup(sc, avp, bf, info->control.rates[0].idx);
 
 	while (skb) {
 		ath_tx_cabq(hw, skb);
@@ -237,7 +237,7 @@ static void ath_beacon_start_adhoc(struc
 	bf = avp->av_bcbuf;
 	skb = bf->bf_mpdu;
 
-	ath_beacon_setup(sc, avp, bf);
+	ath_beacon_setup(sc, avp, bf, 0);
 
 	/* NB: caller is known to have already stopped tx dma */
 	ath9k_hw_puttxbuf(ah, sc->beacon.beaconq, bf->bf_daddr);

-- 
Jouni Malinen                                            PGP id EFC895FA
