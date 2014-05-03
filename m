Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:49748 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbaECOT6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 May 2014 10:19:58 -0400
Received: by mail-wg0-f45.google.com with SMTP id m15so2159069wgh.4
        for <linux-wireless@vger.kernel.org>; Sat, 03 May 2014 07:19:57 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 07/13] staging: vt6656: lock changes: vRunCommand nsDMA_tx_packet
Date: Sat,  3 May 2014 15:17:28 +0100
Message-Id: <1399126654-2663-7-git-send-email-tvboxspy@gmail.com> (sfid-20140503_162003_648751_32F3EC59)
In-Reply-To: <1399126654-2663-1-git-send-email-tvboxspy@gmail.com>
References: <1399126654-2663-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

vRunCommand is nolonger atomic add lock for nsDMA_tx_packet.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/wcmd.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index d51cc90..66d59d5 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -279,6 +279,7 @@ void vRunCommand(struct work_struct *work)
 	int ii;
 	u8 byMask[8] = {1, 2, 4, 8, 0x10, 0x20, 0x40, 0x80};
 	u8 byData;
+	unsigned long flags;
 
 	if (pDevice->Flags & fMP_DISCONNECTED)
 		return;
@@ -667,9 +668,13 @@ void vRunCommand(struct work_struct *work)
 					pDevice->bMoreData = true;
 				}
 
+				spin_lock_irqsave(&pDevice->lock, flags);
+
 				if (nsDMA_tx_packet(pDevice, skb) != 0)
 					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Multicast ps tx fail\n");
 
+				spin_unlock_irqrestore(&pDevice->lock, flags);
+
 				pMgmt->sNodeDBTable[0].wEnQueueCnt--;
 			}
 		}
@@ -690,9 +695,13 @@ void vRunCommand(struct work_struct *work)
 						pDevice->bMoreData = true;
 					}
 
+					spin_lock_irqsave(&pDevice->lock, flags);
+
 					if (nsDMA_tx_packet(pDevice, skb) != 0)
 						DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "sta ps tx fail\n");
 
+					spin_unlock_irqrestore(&pDevice->lock, flags);
+
 					pMgmt->sNodeDBTable[ii].wEnQueueCnt--;
 					// check if sta ps enable, wait next pspoll
 					// if sta ps disable, send all pending buffers.
-- 
1.9.1

