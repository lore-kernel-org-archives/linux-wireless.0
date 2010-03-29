Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:50332 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755142Ab0C2KRL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 06:17:11 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 29 Mar 2010 03:17:11 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19376.33506.672695.950934@gargle.gargle.HOWL>
Date: Mon, 29 Mar 2010 16:07:22 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 7/7] ath9k_htc: Fix TKIP encryption
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The FCS has to be stripped before the packet
is given to mac80211. Also, remove a redundant
assignment of skb length and include the FCS_LEN
when checking padding.

Fixing this issue makes TKIP work.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index befe574..b171f8e 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -450,7 +450,7 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	padpos = ath9k_cmn_padpos(fc);
 
 	padsize = padpos & 3;
-	if (padsize && skb->len >= padpos+padsize) {
+	if (padsize && skb->len >= padpos+padsize+FCS_LEN) {
 		memmove(skb->data + padsize, skb->data, padpos);
 		skb_pull(skb, padsize);
 	}
@@ -537,6 +537,9 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	rx_status->antenna = rxbuf->rxstatus.rs_antenna;
 	rx_status->flag |= RX_FLAG_TSFT;
 
+	/* Strip FCS */
+	skb_trim(skb, skb->len - FCS_LEN);
+
 	return true;
 
 rx_next:
@@ -646,7 +649,6 @@ void ath9k_htc_rxep(void *drv_priv, struct sk_buff *skb,
 	spin_lock(&priv->rx.rxbuflock);
 	memcpy(&rxbuf->rxstatus, rxstatus, HTC_RX_FRAME_HEADER_SIZE);
 	skb_pull(skb, HTC_RX_FRAME_HEADER_SIZE);
-	skb->len = rxstatus->rs_datalen;
 	rxbuf->skb = skb;
 	rxbuf->in_process = true;
 	spin_unlock(&priv->rx.rxbuflock);
-- 
1.7.0.3

