Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:50618 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933122AbaE3P2n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2014 11:28:43 -0400
Received: by mail-wi0-f176.google.com with SMTP id n15so1292262wiw.9
        for <linux-wireless@vger.kernel.org>; Fri, 30 May 2014 08:28:40 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 10/12] staging: vt6656: rename CARDbyGetPktType to vnt_get_pkt_type
Date: Fri, 30 May 2014 16:27:49 +0100
Message-Id: <1401463671-4705-10-git-send-email-tvboxspy@gmail.com> (sfid-20140530_172854_489892_13434E4D)
In-Reply-To: <1401463671-4705-1-git-send-email-tvboxspy@gmail.com>
References: <1401463671-4705-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drop card rename to vnt_get_pkt_type

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c | 4 ++--
 drivers/staging/vt6656/card.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 8e6158b..27ed88b 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -526,7 +526,7 @@ int vnt_ofdm_min_rate(struct vnt_private *priv)
 	return false;
 }
 
-u8 CARDbyGetPktType(struct vnt_private *priv)
+u8 vnt_get_pkt_type(struct vnt_private *priv)
 {
 
 	if (priv->byBBType == BB_TYPE_11A || priv->byBBType == BB_TYPE_11B)
@@ -836,7 +836,7 @@ void CARDvSetBSSMode(struct vnt_private *priv)
 	else
 		MACvSetBBType(priv, priv->byBBType);
 
-	priv->byPacketType = CARDbyGetPktType(priv);
+	priv->byPacketType = vnt_get_pkt_type(priv);
 
 	if (priv->byBBType == BB_TYPE_11A)
 		vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG, 0x88, 0x03);
diff --git a/drivers/staging/vt6656/card.h b/drivers/staging/vt6656/card.h
index 41871e9..7a844c3 100644
--- a/drivers/staging/vt6656/card.h
+++ b/drivers/staging/vt6656/card.h
@@ -62,7 +62,7 @@ u64 CARDqGetNextTBTT(u64 qwTSF, u16 wBeaconInterval);
 u64 CARDqGetTSFOffset(u8 byRxRate, u64 qwTSF1, u64 qwTSF2);
 int CARDbRadioPowerOff(struct vnt_private *pDevice);
 int CARDbRadioPowerOn(struct vnt_private *pDevice);
-u8 CARDbyGetPktType(struct vnt_private *pDevice);
+u8 vnt_get_pkt_type(struct vnt_private *);
 void CARDvSetBSSMode(struct vnt_private *pDevice);
 
 #endif /* __CARD_H__ */
-- 
1.9.1

