Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33478 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab3HPWrB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 18:47:01 -0400
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: linux-wireless@vger.kernel.org
Cc: linux@rempel-privat.de, ath9k-devel@lists.ath9k.org,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Marc Kleine-Budde <mkl@blackshift.org>
Subject: [PATCH v2] ath9k_htc: Restore skb headroom when returning skb to mac80211
Date: Fri, 16 Aug 2013 21:39:40 +0200
Message-Id: <1376681980-27831-1-git-send-email-mkl@pengutronix.de> (sfid-20130817_004708_288610_E1824103)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

ath9k_htc adds padding between the 802.11 header and the payload during
TX by moving the header. When handing the frame back to mac80211 for TX
status handling the header is not moved back into its original position.
This can result in a too small skb headroom when entering ath9k_htc
again (due to a soft retransmission for example) causing an
skb_under_panic oops.

Fix this by moving the 802.11 header back into its original position
before returning the frame to mac80211 as other drivers like rt2x00
or ath5k do.

Reported-by: Marc Kleine-Budde <mkl@blackshift.org>
Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Tested-by: Marc Kleine-Budde <mkl@blackshift.org>
Signed-off-by: Marc Kleine-Budde <mkl@blackshift.org>
---
Hello Helmut,

I've change the patch a bit, I've used ieee80211_get_hdrlen_from_skb() instead
of open coding it.

Tested in ARMv5 with USB device
  "ID 0cf3:7015 Atheros Communications, Inc. TP-Link TL-WN821N v3 802.11n [Atheros AR7010+AR9287]"
for four weeks. Without that patch the kernel oopes after about one week.

I think this is a candidate for stable, can you add stable to Cc?

regards,
Marc

changes since v1:
- use ieee80211_get_hdrlen_from_skb() instead of open coding it

 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index e602c95..c028df7 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -448,6 +448,7 @@ static void ath9k_htc_tx_process(struct ath9k_htc_priv *priv,
 	struct ieee80211_conf *cur_conf = &priv->hw->conf;
 	bool txok;
 	int slot;
+	int hdrlen, padsize;
 
 	slot = strip_drv_header(priv, skb);
 	if (slot < 0) {
@@ -504,6 +505,15 @@ send_mac80211:
 
 	ath9k_htc_tx_clear_slot(priv, slot);
 
+	/* Remove padding before handing frame back to mac80211 */
+	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
+
+	padsize = hdrlen & 3;
+	if (padsize && skb->len > hdrlen + padsize) {
+		memmove(skb->data + padsize, skb->data, hdrlen);
+		skb_pull(skb, padsize);
+	}
+
 	/* Send status to mac80211 */
 	ieee80211_tx_status(priv->hw, skb);
 }
-- 
1.8.3.1

