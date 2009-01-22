Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:4885 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655AbZAVNoh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 08:44:37 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: jirislaby@gmail.com, mickflemm@gmail.com, lrodriguez@atheros.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 5/6] ath5k: use short preamble when possible
Date: Thu, 22 Jan 2009 08:44:20 -0500
Message-Id: <1232631861-6028-6-git-send-email-me@bobcopeland.com> (sfid-20090122_144445_552139_FA376903)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath5k previously ignored TX_RC_SHORT_PREAMBLE and did not use
config->use_short_preamble, so the long preamble was always
used for transmitted packets.

Changes-licensed-under: 3-Clause-BSD

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath5k/base.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 1e1222c..85f7f07 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1181,6 +1181,8 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 	struct ieee80211_rate *rate;
 	unsigned int mrr_rate[3], mrr_tries[3];
 	int i, ret;
+	u16 hw_rate;
+	u8 rc_flags;
 
 	flags = AR5K_TXDESC_INTREQ | AR5K_TXDESC_CLRDMASK;
 
@@ -1188,9 +1190,15 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 	bf->skbaddr = pci_map_single(sc->pdev, skb->data, skb->len,
 			PCI_DMA_TODEVICE);
 
+	rate = ieee80211_get_tx_rate(sc->hw, info);
+
 	if (info->flags & IEEE80211_TX_CTL_NO_ACK)
 		flags |= AR5K_TXDESC_NOACK;
 
+	rc_flags = info->control.rates[0].flags;
+	hw_rate = (rc_flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE) ?
+		rate->hw_value_short : rate->hw_value;
+
 	pktlen = skb->len;
 
 	if (info->control.hw_key) {
@@ -1200,7 +1208,7 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 	ret = ah->ah_setup_tx_desc(ah, ds, pktlen,
 		ieee80211_get_hdrlen_from_skb(skb), AR5K_PKT_TYPE_NORMAL,
 		(sc->power_level * 2),
-		ieee80211_get_tx_rate(sc->hw, info)->hw_value,
+		hw_rate,
 		info->control.rates[0].count, keyidx, 0, flags, 0, 0);
 	if (ret)
 		goto err_unmap;
-- 
1.6.0.6


