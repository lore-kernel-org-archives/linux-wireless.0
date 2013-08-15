Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:42304 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756840Ab3HOSkP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Aug 2013 14:40:15 -0400
Received: by mail-wg0-f43.google.com with SMTP id z12so846475wgg.22
        for <linux-wireless@vger.kernel.org>; Thu, 15 Aug 2013 11:40:14 -0700 (PDT)
Message-ID: <1376592008.5404.22.camel@canaries32-MCP7A> (sfid-20130815_204022_967603_13FA069C)
Subject: [PATCH 3/3] staging: vt6656: rxtx.h : remove typedef struct
 tagSBEACON_BUFFER
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Thu, 15 Aug 2013 19:40:08 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace with struct vnt_beacon_buffer.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c |  5 +++--
 drivers/staging/vt6656/rxtx.h | 16 +++++++---------
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index e37e82c..7a4ebbc 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -1753,6 +1753,7 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice,
 	struct vnt_tx_mgmt *pPacket)
 {
+	struct vnt_beacon_buffer *pTX_Buffer;
 	u32 cbFrameSize = pPacket->cbMPDULen + WLAN_FCS_LEN;
 	u32 cbHeaderSize = 0;
 	u16 wTxBufSize = sizeof(STxShortBufHead);
@@ -1762,7 +1763,6 @@ CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice,
 	u16 wCurrentRate;
 	u32 cbFrameBodySize;
 	u32 cbReqCount;
-	PBEACON_BUFFER pTX_Buffer;
 	u8 *pbyTxBufferAddr;
 	PUSB_SEND_CONTEXT pContext;
 	CMD_STATUS status;
@@ -1773,7 +1773,8 @@ CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice,
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"ManagementSend TX...NO CONTEXT!\n");
         return status ;
     }
-    pTX_Buffer = (PBEACON_BUFFER) (&pContext->Data[0]);
+
+	pTX_Buffer = (struct vnt_beacon_buffer *)&pContext->Data[0];
     pbyTxBufferAddr = (u8 *)&(pTX_Buffer->wFIFOCtl);
 
     cbFrameBodySize = pPacket->cbPayloadLen;
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index bd1f9e2..3e347a9 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -43,15 +43,13 @@ struct vnt_tx_buffer {
 	u16 wReserved;
 } __packed;
 
-typedef struct tagSBEACON_BUFFER
-{
-    u8                            byType;
-    u8                            byPKTNO;
-    u16                            wTxByteCount;
-
-    u16                            wFIFOCtl;
-    u16                            wTimeStamp;
-} __packed BEACON_BUFFER, *PBEACON_BUFFER;
+struct vnt_beacon_buffer {
+	u8 byType;
+	u8 byPKTNO;
+	u16 wTxByteCount;
+	u16 wFIFOCtl;
+	u16 wTimeStamp;
+} __packed;
 
 void vDMA0_tx_80211(struct vnt_private *, struct sk_buff *skb);
 int nsDMA_tx_packet(struct vnt_private *, u32 uDMAIdx, struct sk_buff *skb);
-- 
1.8.1.2



