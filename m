Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:58266 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbaCVJCb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Mar 2014 05:02:31 -0400
Received: by mail-we0-f181.google.com with SMTP id q58so2133229wes.26
        for <linux-wireless@vger.kernel.org>; Sat, 22 Mar 2014 02:02:30 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 06/10] staging: vt6656: rxtx struct vnt_tx_buffer Replace wTxByteCount
Date: Sat, 22 Mar 2014 09:01:28 +0000
Message-Id: <1395478892-3419-6-git-send-email-tvboxspy@gmail.com> (sfid-20140322_100235_237997_1D47A0EA)
In-Reply-To: <1395478892-3419-1-git-send-email-tvboxspy@gmail.com>
References: <1395478892-3419-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace with tx_byte_count with base type __le16.

In nsDMA_tx_packet and bRelayPacketSend provide endian correction.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 8 ++++----
 drivers/staging/vt6656/rxtx.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 1624efb..c17c3da 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -1605,7 +1605,7 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 	}
     }
 
-    pTX_Buffer->wTxByteCount = cpu_to_le16((u16)(cbReqCount));
+    pTX_Buffer->tx_byte_count = cpu_to_le16((u16)(cbReqCount));
     pTX_Buffer->byPKTNO = (u8) (((wCurrentRate<<4) &0x00F0) | ((pDevice->wSeqCounter - 1) & 0x000F));
     pTX_Buffer->byType = 0x00;
 
@@ -2045,7 +2045,7 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
 	}
     }
 
-    pTX_Buffer->wTxByteCount = cpu_to_le16((u16)(cbReqCount));
+    pTX_Buffer->tx_byte_count = cpu_to_le16((u16)(cbReqCount));
     pTX_Buffer->byPKTNO = (u8) (((wCurrentRate<<4) &0x00F0) | ((pDevice->wSeqCounter - 1) & 0x000F));
     pTX_Buffer->byType = 0x00;
 
@@ -2437,7 +2437,7 @@ int nsDMA_tx_packet(struct vnt_private *pDevice,
     }
 
     pTX_Buffer->byPKTNO = (u8) (((pDevice->wCurrentRate<<4) &0x00F0) | ((pDevice->wSeqCounter - 1) & 0x000F));
-    pTX_Buffer->wTxByteCount = (u16)BytesToWrite;
+    pTX_Buffer->tx_byte_count = cpu_to_le16((u16)BytesToWrite);
 
     pContext->pPacket = skb;
     pContext->type = CONTEXT_DATA_PACKET;
@@ -2591,7 +2591,7 @@ int bRelayPacketSend(struct vnt_private *pDevice, u8 *pbySkbData, u32 uDataLen,
     }
 
     pTX_Buffer->byPKTNO = (u8) (((pDevice->wCurrentRate<<4) &0x00F0) | ((pDevice->wSeqCounter - 1) & 0x000F));
-    pTX_Buffer->wTxByteCount = (u16)BytesToWrite;
+    pTX_Buffer->tx_byte_count = cpu_to_le16((u16)BytesToWrite);
 
     pContext->pPacket = NULL;
     pContext->type = CONTEXT_DATA_PACKET;
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index d7e4273..0233761 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -225,7 +225,7 @@ struct vnt_tx_fifo_head {
 struct vnt_tx_buffer {
 	u8 byType;
 	u8 byPKTNO;
-	u16 wTxByteCount;
+	__le16 tx_byte_count;
 	struct vnt_tx_fifo_head fifo_head;
 	union vnt_tx_head tx_head;
 } __packed;
-- 
1.9.0

