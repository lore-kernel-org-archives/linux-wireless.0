Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:62029 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379AbaEOVuX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 17:50:23 -0400
Received: by mail-wi0-f170.google.com with SMTP id bs8so1278139wib.3
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 14:50:22 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH rebased 01/15] staging: staging: vt6656: nsDMA_tx_packet Move pContext later.
Date: Thu, 15 May 2014 22:49:10 +0100
Message-Id: <1400190564-5135-1-git-send-email-tvboxspy@gmail.com> (sfid-20140515_235027_293883_2C32A4E5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

call s_vGetFreeContext later in function skiping large
chunk of code.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 03d5339..57eb502 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -2172,14 +2172,6 @@ int nsDMA_tx_packet(struct vnt_private *pDevice, struct sk_buff *skb)
         }
     }
 
-	pContext = s_vGetFreeContext(pDevice);
-
-    if (pContext == NULL) {
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG" pContext == NULL\n");
-        dev_kfree_skb_irq(skb);
-        return STATUS_RESOURCES;
-    }
-
 	memcpy(&pDevice->sTxEthHeader, skb->data, ETH_HLEN);
 
 //mike add:station mode check eapol-key challenge--->
@@ -2402,7 +2394,6 @@ int nsDMA_tx_packet(struct vnt_private *pDevice, struct sk_buff *skb)
 
             if (pTransmitKey == NULL) {
                 DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"return no tx key\n");
-		pContext->bBoolInUse = false;
                 dev_kfree_skb_irq(skb);
                 pStats->tx_dropped++;
                 return STATUS_FAILURE;
@@ -2410,6 +2401,13 @@ int nsDMA_tx_packet(struct vnt_private *pDevice, struct sk_buff *skb)
         }
     }
 
+	pContext = s_vGetFreeContext(pDevice);
+	if (!pContext) {
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG" pContext == NULL\n");
+		dev_kfree_skb_irq(skb);
+		return STATUS_RESOURCES;
+	}
+
 	pTX_Buffer = (struct vnt_tx_buffer *)&pContext->Data[0];
 
     fConvertedPacket = s_bPacketToWirelessUsb(pDevice, byPktType,
-- 
1.9.1

