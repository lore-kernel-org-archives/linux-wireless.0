Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:44363 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab3KXN1q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 08:27:46 -0500
Received: by mail-we0-f177.google.com with SMTP id p61so2792608wes.36
        for <linux-wireless@vger.kernel.org>; Sun, 24 Nov 2013 05:27:42 -0800 (PST)
Message-ID: <1385299652.13346.10.camel@canaries32-MCP7A> (sfid-20131124_142748_494468_E93B6709)
Subject: [PATCH 2/2] staging: vt6656: vnt_beacon_buffer attach mac header.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sun, 24 Nov 2013 13:27:32 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Attach ieee80211_hdr to vnt_beacon_buffer and remove pointer arithmetic.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 19 +++++++++----------
 drivers/staging/vt6656/rxtx.h |  1 +
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index a45604a..723a8de 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -1650,7 +1650,6 @@ CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice,
 	u16 wCurrentRate;
 	u32 cbFrameBodySize;
 	u32 cbReqCount;
-	u8 *pbyTxBufferAddr;
 	struct vnt_usb_send_context *pContext;
 	CMD_STATUS status;
 
@@ -1663,7 +1662,6 @@ CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice,
 
 	pTX_Buffer = (struct vnt_beacon_buffer *)&pContext->Data[0];
 	short_head = &pTX_Buffer->short_head;
-	pbyTxBufferAddr = (u8 *)&short_head->fifo_ctl;
 
     cbFrameBodySize = pPacket->cbPayloadLen;
 
@@ -1697,15 +1695,16 @@ CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice,
 	}
 

-    //Generate Beacon Header
-    pMACHeader = (struct ieee80211_hdr *)(pbyTxBufferAddr + cbHeaderSize);
-    memcpy(pMACHeader, pPacket->p80211Header, pPacket->cbMPDULen);
+	/* Generate Beacon Header */
+	pMACHeader = &pTX_Buffer->hdr;
 
-    pMACHeader->duration_id = 0;
-    pMACHeader->seq_ctrl = cpu_to_le16(pDevice->wSeqCounter << 4);
-    pDevice->wSeqCounter++ ;
-    if (pDevice->wSeqCounter > 0x0fff)
-        pDevice->wSeqCounter = 0;
+	memcpy(pMACHeader, pPacket->p80211Header, pPacket->cbMPDULen);
+
+	pMACHeader->duration_id = 0;
+	pMACHeader->seq_ctrl = cpu_to_le16(pDevice->wSeqCounter << 4);
+	pDevice->wSeqCounter++;
+	if (pDevice->wSeqCounter > 0x0fff)
+		pDevice->wSeqCounter = 0;
 
     cbReqCount = cbHeaderSize + WLAN_HDR_ADDR3_LEN + cbFrameBodySize;
 
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index bb21ad6..b3ee6d0 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -243,6 +243,7 @@ struct vnt_beacon_buffer {
 	u8 byPKTNO;
 	u16 wTxByteCount;
 	struct vnt_tx_short_buf_head short_head;
+	struct ieee80211_hdr hdr;
 } __packed;
 
 void vDMA0_tx_80211(struct vnt_private *, struct sk_buff *skb);
-- 
1.8.4.4

