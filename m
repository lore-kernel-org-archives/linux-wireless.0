Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:57885 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758179AbbAITS3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2015 14:18:29 -0500
Received: by mail-oi0-f49.google.com with SMTP id a141so13223456oig.8
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2015 11:18:28 -0800 (PST)
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 7/8] wcn36xx: move set_tx_pdu inside set_tx_data/mgmt
Date: Fri,  9 Jan 2015 14:15:51 -0500
Message-Id: <1420830952-9624-8-git-send-email-me@bobcopeland.com> (sfid-20150109_201834_423072_44E7D072)
In-Reply-To: <1420830952-9624-1-git-send-email-me@bobcopeland.com>
References: <1420830952-9624-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The pdu is part of the buffer descriptor, so it makes
sense that one function would fill both.  Also, passing
the whole skb instead of just the header pointer to the
set_tx_data function paves the way for using its fields
for ampdu setup inside set_tx_data().

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/wcn36xx/txrx.c |   37 +++++++++++++++++--------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/txrx.c b/drivers/net/wireless/ath/wcn36xx/txrx.c
index 277bc39..7f0d9e6 100644
--- a/drivers/net/wireless/ath/wcn36xx/txrx.c
+++ b/drivers/net/wireless/ath/wcn36xx/txrx.c
@@ -115,9 +115,10 @@ static void wcn36xx_set_tx_data(struct wcn36xx_tx_bd *bd,
 				struct wcn36xx *wcn,
 				struct wcn36xx_vif **vif_priv,
 				struct wcn36xx_sta *sta_priv,
-				struct ieee80211_hdr *hdr,
+				struct sk_buff *skb,
 				bool bcast)
 {
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_vif *vif = NULL;
 	struct wcn36xx_vif *__vif_priv = NULL;
 	bd->bd_rate = WCN36XX_BD_RATE_DATA;
@@ -158,14 +159,21 @@ static void wcn36xx_set_tx_data(struct wcn36xx_tx_bd *bd,
 		bd->ack_policy = 1;
 	}
 	*vif_priv = __vif_priv;
+
+	wcn36xx_set_tx_pdu(bd,
+			   ieee80211_is_data_qos(hdr->frame_control) ?
+			   sizeof(struct ieee80211_qos_hdr) :
+			   sizeof(struct ieee80211_hdr_3addr),
+			   skb->len, sta_priv ? sta_priv->tid : 0);
 }
 
 static void wcn36xx_set_tx_mgmt(struct wcn36xx_tx_bd *bd,
 				struct wcn36xx *wcn,
 				struct wcn36xx_vif **vif_priv,
-				struct ieee80211_hdr *hdr,
+				struct sk_buff *skb,
 				bool bcast)
 {
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct wcn36xx_vif *__vif_priv =
 		get_vif_by_addr(wcn, hdr->addr2);
 	bd->sta_index = __vif_priv->self_sta_index;
@@ -199,6 +207,12 @@ static void wcn36xx_set_tx_mgmt(struct wcn36xx_tx_bd *bd,
 	} else
 		bd->queue_id = WCN36XX_TX_U_WQ_ID;
 	*vif_priv = __vif_priv;
+
+	wcn36xx_set_tx_pdu(bd,
+			   ieee80211_is_data_qos(hdr->frame_control) ?
+			   sizeof(struct ieee80211_qos_hdr) :
+			   sizeof(struct ieee80211_hdr_3addr),
+			   skb->len, WCN36XX_TID);
 }
 
 int wcn36xx_start_tx(struct wcn36xx *wcn,
@@ -260,22 +274,11 @@ int wcn36xx_start_tx(struct wcn36xx *wcn,
 	}
 
 	/* Data frames served first*/
-	if (is_low) {
-		wcn36xx_set_tx_data(bd, wcn, &vif_priv, sta_priv, hdr, bcast);
-		wcn36xx_set_tx_pdu(bd,
-			   ieee80211_is_data_qos(hdr->frame_control) ?
-			   sizeof(struct ieee80211_qos_hdr) :
-			   sizeof(struct ieee80211_hdr_3addr),
-			   skb->len, sta_priv ? sta_priv->tid : 0);
-	} else {
+	if (is_low)
+		wcn36xx_set_tx_data(bd, wcn, &vif_priv, sta_priv, skb, bcast);
+	else
 		/* MGMT and CTRL frames are handeld here*/
-		wcn36xx_set_tx_mgmt(bd, wcn, &vif_priv, hdr, bcast);
-		wcn36xx_set_tx_pdu(bd,
-			   ieee80211_is_data_qos(hdr->frame_control) ?
-			   sizeof(struct ieee80211_qos_hdr) :
-			   sizeof(struct ieee80211_hdr_3addr),
-			   skb->len, WCN36XX_TID);
-	}
+		wcn36xx_set_tx_mgmt(bd, wcn, &vif_priv, skb, bcast);
 
 	buff_to_be((u32 *)bd, sizeof(*bd)/sizeof(u32));
 	bd->tx_bd_sign = 0xbdbdbdbd;
-- 
1.7.10.4

