Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:59785 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721Ab0ENFsb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 01:48:31 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 13 May 2010 22:48:31 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19436.58441.828970.737593@gargle.gargle.HOWL>
Date: Fri, 14 May 2010 11:18:57 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/4] ath9k_htc: Remove HW queue translation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no need to determine the HW queue
for each packet that is transmitted. The endpoint
can be chosen directly based on the queue type
that mac80211 sends down.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 15e716a..8d461aa 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -81,7 +81,7 @@ int ath9k_htc_tx_start(struct ath9k_htc_priv *priv, struct sk_buff *skb)
 	struct ath9k_htc_vif *avp;
 	struct ath9k_htc_tx_ctl tx_ctl;
 	enum htc_endpoint_id epid;
-	u16 qnum, hw_qnum;
+	u16 qnum;
 	__le16 fc;
 	u8 *tx_fhdr;
 	u8 sta_idx;
@@ -141,22 +141,21 @@ int ath9k_htc_tx_start(struct ath9k_htc_priv *priv, struct sk_buff *skb)
 		memcpy(tx_fhdr, (u8 *) &tx_hdr, sizeof(tx_hdr));
 
 		qnum = skb_get_queue_mapping(skb);
-		hw_qnum = get_hw_qnum(qnum, priv->hwq_map);
 
-		switch (hw_qnum) {
+		switch (qnum) {
 		case 0:
-			TX_QSTAT_INC(WME_AC_BE);
-			epid = priv->data_be_ep;
+			TX_QSTAT_INC(WME_AC_VO);
+			epid = priv->data_vo_ep;
 			break;
-		case 2:
+		case 1:
 			TX_QSTAT_INC(WME_AC_VI);
 			epid = priv->data_vi_ep;
 			break;
-		case 3:
-			TX_QSTAT_INC(WME_AC_VO);
-			epid = priv->data_vo_ep;
+		case 2:
+			TX_QSTAT_INC(WME_AC_BE);
+			epid = priv->data_be_ep;
 			break;
-		case 1:
+		case 3:
 		default:
 			TX_QSTAT_INC(WME_AC_BK);
 			epid = priv->data_bk_ep;
-- 
1.7.1

