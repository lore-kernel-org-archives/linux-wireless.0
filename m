Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:4330 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461AbZBORGX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2009 12:06:23 -0500
From: Bob Copeland <me@bobcopeland.com>
To: jirislaby@gmail.com, mickflemm@gmail.com, lrodriguez@atheros.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 4/4] ath5k: compute rts/cts duration after computing full pktlen
Date: Sun, 15 Feb 2009 12:06:12 -0500
Message-Id: <1234717572-10651-4-git-send-email-me@bobcopeland.com> (sfid-20090215_180628_288804_2116EADF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RTS and CTS-to-self duration needs to go after ICV len is considered.

Changes-licensed-under: 3-Clause-BSD

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath5k/base.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index fa6a216..bce825b 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1220,6 +1220,10 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 
 	pktlen = skb->len;
 
+	if (info->control.hw_key) {
+		keyidx = info->control.hw_key->hw_key_idx;
+		pktlen += info->control.hw_key->icv_len;
+	}
 	if (rc_flags & IEEE80211_TX_RC_USE_RTS_CTS) {
 		flags |= AR5K_TXDESC_RTSENA;
 		cts_rate = ieee80211_get_rts_cts_rate(sc->hw, info)->hw_value;
@@ -1232,11 +1236,6 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 		duration = le16_to_cpu(ieee80211_ctstoself_duration(sc->hw,
 			sc->vif, pktlen, info));
 	}
-
-	if (info->control.hw_key) {
-		keyidx = info->control.hw_key->hw_key_idx;
-		pktlen += info->control.hw_key->icv_len;
-	}
 	ret = ah->ah_setup_tx_desc(ah, ds, pktlen,
 		ieee80211_get_hdrlen_from_skb(skb), AR5K_PKT_TYPE_NORMAL,
 		(sc->power_level * 2),
-- 
1.6.0.6


