Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3211 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058Ab0BISIB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2010 13:08:01 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>, stable@kernel.org
Subject: [PATCH] ath5k: use correct packet type when transmitting
Date: Tue,  9 Feb 2010 13:06:54 -0500
Message-Id: <1265738814-17059-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The hardware needs to know what type of frames are being
sent in order to fill in various fields, for example the
timestamp in probe responses (before this patch, it was
always 0).  Set it correctly when initializing the TX
descriptor.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
Cc: stable@kernel.org
---
 drivers/net/wireless/ath/ath5k/ath5k.h |    1 -
 drivers/net/wireless/ath/ath5k/base.c  |   26 +++++++++++++++++++++++++-
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index ad4d446..ac67f02 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -541,7 +541,6 @@ struct ath5k_txq_info {
 /*
  * Transmit packet types.
  * used on tx control descriptor
- * TODO: Use them inside base.c corectly
  */
 enum ath5k_pkt_type {
 	AR5K_PKT_TYPE_NORMAL		= 0,
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 535a6af..2904876 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1249,6 +1249,29 @@ ath5k_rxbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 	return 0;
 }
 
+static enum ath5k_pkt_type get_hw_packet_type(struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr;
+	enum ath5k_pkt_type htype;
+	__le16 fc;
+
+	hdr = (struct ieee80211_hdr *)skb->data;
+	fc = hdr->frame_control;
+
+	if (ieee80211_is_beacon(fc))
+		htype = AR5K_PKT_TYPE_BEACON;
+	else if (ieee80211_is_probe_resp(fc))
+		htype = AR5K_PKT_TYPE_PROBE_RESP;
+	else if (ieee80211_is_atim(fc))
+		htype = AR5K_PKT_TYPE_ATIM;
+	else if (ieee80211_is_pspoll(fc))
+		htype = AR5K_PKT_TYPE_PSPOLL;
+	else
+		htype = AR5K_PKT_TYPE_NORMAL;
+
+	return htype;
+}
+
 static int
 ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
 		  struct ath5k_txq *txq)
@@ -1303,7 +1326,8 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
 			sc->vif, pktlen, info));
 	}
 	ret = ah->ah_setup_tx_desc(ah, ds, pktlen,
-		ieee80211_get_hdrlen_from_skb(skb), AR5K_PKT_TYPE_NORMAL,
+		ieee80211_get_hdrlen_from_skb(skb),
+		get_hw_packet_type(skb),
 		(sc->power_level * 2),
 		hw_rate,
 		info->control.rates[0].count, keyidx, ah->ah_tx_ant, flags,
-- 
1.6.3.3


