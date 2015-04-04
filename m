Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:36299 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbbDDTtf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Apr 2015 15:49:35 -0400
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>,
	<stable@vger.kernel.org>
Subject: [PATCH] staging: vt6656: use ieee80211_tx_info to select packet type.
Date: Sat,  4 Apr 2015 20:49:10 +0100
Message-Id: <1428176950-3128-1-git-send-email-tvboxspy@gmail.com> (sfid-20150404_214953_325681_B1E0248A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Information for packet type is in ieee80211_tx_info

band IEEE80211_BAND_5GHZ for PK_TYPE_11A.

IEEE80211_TX_RC_USE_CTS_PROTECT via tx_rate flags selects PK_TYPE_11GB

This ensures that the packet is always the right type.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: <stable@vger.kernel.org> # v3.17+
---
 drivers/staging/vt6656/rxtx.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index f6c2cf8..5c58996 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -805,10 +805,18 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 		vnt_schedule_command(priv, WLAN_CMD_SETPOWER);
 	}
 
-	if (current_rate > RATE_11M)
-		pkt_type = priv->packet_type;
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
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-- 
2.1.0

