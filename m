Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:49960 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755200Ab0C3C6Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 22:58:16 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 29 Mar 2010 19:58:16 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19377.28036.56183.487318@gargle.gargle.HOWL>
Date: Tue, 30 Mar 2010 08:48:27 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k_htc: Fix TKIP encryption
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set IEEE80211_HW_RX_INCLUDES_FCS to indicate that
the FCS is present in RX frames. Also, remove a redundant
assignment of skb length and include the FCS_LEN
when checking padding.

Fixing this issue makes TKIP work.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    3 ++-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |    3 +--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index d8779b9..90cfd90 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -513,7 +513,8 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 	hw->flags = IEEE80211_HW_SIGNAL_DBM |
 		IEEE80211_HW_AMPDU_AGGREGATION |
 		IEEE80211_HW_SPECTRUM_MGMT |
-		IEEE80211_HW_HAS_RATE_CONTROL;
+		IEEE80211_HW_HAS_RATE_CONTROL |
+		IEEE80211_HW_RX_INCLUDES_FCS;
 
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_STATION) |
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index befe574..f1e3d83 100644
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
@@ -646,7 +646,6 @@ void ath9k_htc_rxep(void *drv_priv, struct sk_buff *skb,
 	spin_lock(&priv->rx.rxbuflock);
 	memcpy(&rxbuf->rxstatus, rxstatus, HTC_RX_FRAME_HEADER_SIZE);
 	skb_pull(skb, HTC_RX_FRAME_HEADER_SIZE);
-	skb->len = rxstatus->rs_datalen;
 	rxbuf->skb = skb;
 	rxbuf->in_process = true;
 	spin_unlock(&priv->rx.rxbuflock);
-- 
1.7.0.3

