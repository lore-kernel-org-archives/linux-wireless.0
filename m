Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:35206 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbbDAVdb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2015 17:33:31 -0400
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 2/2] staging: vt6655: use ieee80211_tx_info to select packet type.
Date: Wed,  1 Apr 2015 22:32:52 +0100
Message-Id: <1427923972-11947-2-git-send-email-tvboxspy@gmail.com> (sfid-20150401_233334_836919_547C677C)
In-Reply-To: <1427923972-11947-1-git-send-email-tvboxspy@gmail.com>
References: <1427923972-11947-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Information for packet type is in ieee80211_tx_info

band IEEE80211_BAND_5GHZ for PK_TYPE_11A.

IEEE80211_TX_RC_USE_CTS_PROTECT via tx_rate flags selects PK_TYPE_11GB

This ensures that the packet is always the right type.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: <stable@vger.kernel.org> # v3.19+
---
 drivers/staging/vt6655/rxtx.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 195dcc9..7468776 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -1305,10 +1305,18 @@ int vnt_generate_fifo_header(struct vnt_private *priv, u32 dma_idx,
 			    priv->hw->conf.chandef.chan->hw_value);
 	}
 
-	if (current_rate > RATE_11M)
-		pkt_type = (u8)priv->byPacketType;
-	else
+	if (current_rate > RATE_11M) {
+		if (info->band == IEEE80211_BAND_5GHZ) {
+			pkt_type = PK_TYPE_11A;
+		} else {
+			if (tx_rate->flags & IEEE80211_TX_RC_USE_CTS_PROTECT)
+				pkt_type = PK_TYPE_11GB;
+			else
+				pkt_type = PK_TYPE_11GA;
+		}
+	} else {
 		pkt_type = PK_TYPE_11B;
+	}
 
 	/*Set fifo controls */
 	if (pkt_type == PK_TYPE_11A)
-- 
2.1.0

