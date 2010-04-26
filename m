Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:22136 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664Ab0DZSBV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 14:01:21 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 26 Apr 2010 11:01:21 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19413.24411.750843.368010@gargle.gargle.HOWL>
Date: Mon, 26 Apr 2010 15:09:39 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/3] ath9k_htc: Validate TX Endpoint ID
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check for the endpoint IDs when processing
TX completions and drop the unsupported EPIDs.

We can add other endpoints (UAPSD,..) when support
is added.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 2c3c510..08bfe5d 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -244,16 +244,25 @@ void ath9k_htc_txep(void *drv_priv, struct sk_buff *skb,
 		    enum htc_endpoint_id ep_id, bool txok)
 {
 	struct ath9k_htc_priv *priv = (struct ath9k_htc_priv *) drv_priv;
+	struct ath_common *common = ath9k_hw_common(priv->ah);
 	struct ieee80211_tx_info *tx_info;
 
 	if (!skb)
 		return;
 
-	if (ep_id == priv->mgmt_ep)
+	if (ep_id == priv->mgmt_ep) {
 		skb_pull(skb, sizeof(struct tx_mgmt_hdr));
-	else
-		/* TODO: Check for cab/uapsd/data */
+	} else if ((ep_id == priv->data_bk_ep) ||
+		   (ep_id == priv->data_be_ep) ||
+		   (ep_id == priv->data_vi_ep) ||
+		   (ep_id == priv->data_vo_ep)) {
 		skb_pull(skb, sizeof(struct tx_frame_hdr));
+	} else {
+		ath_print(common, ATH_DBG_FATAL,
+			  "Unsupported TX EPID: %d\n", ep_id);
+		dev_kfree_skb_any(skb);
+		return;
+	}
 
 	tx_info = IEEE80211_SKB_CB(skb);
 
-- 
1.7.0.5

