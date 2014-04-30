Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:37812 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759024AbaD3UdF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2014 16:33:05 -0400
Received: by mail-we0-f173.google.com with SMTP id w61so2207327wes.4
        for <linux-wireless@vger.kernel.org>; Wed, 30 Apr 2014 13:33:04 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/4] staging: vt6656: nsDMA_tx_packet Move pContext later
Date: Wed, 30 Apr 2014 21:31:14 +0100
Message-Id: <1398889875-3312-3-git-send-email-tvboxspy@gmail.com> (sfid-20140430_223310_981271_BE234977)
In-Reply-To: <1398889875-3312-1-git-send-email-tvboxspy@gmail.com>
References: <1398889875-3312-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

call s_vGetFreeContext later in function skiping large
chunk of code.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 4977f72..6bef0e3 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -2175,14 +2175,6 @@ int nsDMA_tx_packet(struct vnt_private *pDevice, struct sk_buff *skb)
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
     memcpy(pDevice->sTxEthHeader.h_dest, (u8 *)(skb->data), ETH_HLEN);
 
 //mike add:station mode check eapol-key challenge--->
@@ -2405,7 +2397,6 @@ int nsDMA_tx_packet(struct vnt_private *pDevice, struct sk_buff *skb)
 
             if (pTransmitKey == NULL) {
                 DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"return no tx key\n");
-		pContext->bBoolInUse = false;
                 dev_kfree_skb_irq(skb);
                 pStats->tx_dropped++;
                 return STATUS_FAILURE;
@@ -2413,6 +2404,13 @@ int nsDMA_tx_packet(struct vnt_private *pDevice, struct sk_buff *skb)
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

