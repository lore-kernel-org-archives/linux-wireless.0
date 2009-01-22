Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:4877 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbZAVNof (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 08:44:35 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: jirislaby@gmail.com, mickflemm@gmail.com, lrodriguez@atheros.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 6/6] ath5k: honor the RTS/CTS bits
Date: Thu, 22 Jan 2009 08:44:21 -0500
Message-Id: <1232631861-6028-7-git-send-email-me@bobcopeland.com> (sfid-20090122_144442_516782_3559F435)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ath5k driver didn't use set_rts_threshold or use_cts_prot, and also
didn't check the IEEE80211_TX_RC_USE_{RTS_CTS,CTS_PROTECT} RC flags.
Tell the hardware about these so RTS/CTS will work, and so the device
will work better in mixed b/g environments.

Changes-licensed-under: 3-Clause-BSD

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath5k/base.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 85f7f07..57971a9 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1182,6 +1182,8 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 	unsigned int mrr_rate[3], mrr_tries[3];
 	int i, ret;
 	u16 hw_rate;
+	u16 cts_rate = 0;
+	u16 duration = 0;
 	u8 rc_flags;
 
 	flags = AR5K_TXDESC_INTREQ | AR5K_TXDESC_CLRDMASK;
@@ -1201,6 +1203,19 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 
 	pktlen = skb->len;
 
+	if (rc_flags & IEEE80211_TX_RC_USE_RTS_CTS) {
+		flags |= AR5K_TXDESC_RTSENA;
+		cts_rate = ieee80211_get_rts_cts_rate(sc->hw, info)->hw_value;
+		duration = le16_to_cpu(ieee80211_rts_duration(sc->hw,
+			sc->vif, pktlen, info));
+	}
+	if (rc_flags & IEEE80211_TX_RC_USE_CTS_PROTECT) {
+		flags |= AR5K_TXDESC_CTSENA;
+		cts_rate = ieee80211_get_rts_cts_rate(sc->hw, info)->hw_value;
+		duration = le16_to_cpu(ieee80211_ctstoself_duration(sc->hw,
+			sc->vif, pktlen, info));
+	}
+
 	if (info->control.hw_key) {
 		keyidx = info->control.hw_key->hw_key_idx;
 		pktlen += info->control.hw_key->icv_len;
@@ -1209,7 +1224,8 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 		ieee80211_get_hdrlen_from_skb(skb), AR5K_PKT_TYPE_NORMAL,
 		(sc->power_level * 2),
 		hw_rate,
-		info->control.rates[0].count, keyidx, 0, flags, 0, 0);
+		info->control.rates[0].count, keyidx, 0, flags,
+		cts_rate, duration);
 	if (ret)
 		goto err_unmap;
 
-- 
1.6.0.6


