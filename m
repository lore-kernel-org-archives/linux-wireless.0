Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:57351 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab3KYWO3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 17:14:29 -0500
Received: by mail-wi0-f180.google.com with SMTP id hm4so6225114wib.13
        for <linux-wireless@vger.kernel.org>; Mon, 25 Nov 2013 14:14:28 -0800 (PST)
Message-ID: <1385417656.6327.1.camel@canaries32-MCP7A> (sfid-20131125_231437_991298_0FE09E79)
Subject: [PATCH 1/2] staging: vt6656: Remove unused variable bLongHeader
From: Malcolm Priestley <tvboxspy@gmail.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 25 Nov 2013 22:14:16 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove dead bLongHeader code.

In s_vFillTxKey use ieee80211_has_a4 to detect long headers for future use.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h |  1 -
 drivers/staging/vt6656/rxtx.c   | 24 ++++--------------------
 2 files changed, 4 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index ec8acbd..9a4dfbc 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -598,7 +598,6 @@ struct vnt_private {
 
 	int bCCK;
 	int bEncryptionEnable;
-	int bLongHeader;
 	int bShortSlotTime;
 	int bProtectMode;
 	int bNonERPPresent;
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 723a8de..aa71d39 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -278,7 +278,7 @@ static void s_vFillTxKey(struct vnt_private *pDevice,
 		mic_hdr->tsc_15_0 = cpu_to_be16(pTransmitKey->wTSC15_0);
 
 		/* MICHDR1 */
-		if (pDevice->bLongHeader)
+		if (ieee80211_has_a4(pMACHeader->frame_control))
 			mic_hdr->hlen = cpu_to_be16(28);
 		else
 			mic_hdr->hlen = cpu_to_be16(22);
@@ -292,7 +292,7 @@ static void s_vFillTxKey(struct vnt_private *pDevice,
 								& 0xc78f);
 		mic_hdr->seq_ctrl = cpu_to_le16(pMACHeader->seq_ctrl & 0xf);
 
-		if (pDevice->bLongHeader)
+		if (ieee80211_has_a4(pMACHeader->frame_control))
 			memcpy(mic_hdr->addr4, pMACHeader->addr4, ETH_ALEN);
 	}
 }
@@ -790,7 +790,6 @@ static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
 {
 	struct vnt_tx_fifo_head *pFifoHead = &tx_buffer->fifo_head;
 	union vnt_tx_data_head *head = NULL;
-	u32 cbMACHdLen = WLAN_HDR_ADDR3_LEN; /* 24 */
 	u16 wFifoCtl;
 	u8 byFBOption = AUTO_FB_NONE;
 
@@ -805,9 +804,6 @@ static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
 	if (!pFifoHead)
 		return 0;
 
-	if (pDevice->bLongHeader)
-		cbMACHdLen = WLAN_HDR_ADDR3_LEN + 6;
-
 	if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
 		if (need_rts) {
 			struct vnt_rrv_time_rts *pBuf =
@@ -1007,16 +1003,9 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 
     pTxBufHead->wTimeStamp = DEFAULT_MSDU_LIFETIME_RES_64us;
 
-    //Set FIFOCTL_LHEAD
-    if (pDevice->bLongHeader)
-        pTxBufHead->wFIFOCtl |= FIFOCTL_LHEAD;
-
     //Set FRAGCTL_MACHDCNT
-    if (pDevice->bLongHeader) {
-        cbMACHdLen = WLAN_HDR_ADDR3_LEN + 6;
-    } else {
-        cbMACHdLen = WLAN_HDR_ADDR3_LEN;
-    }
+	cbMACHdLen = WLAN_HDR_ADDR3_LEN;
+
     pTxBufHead->wFragCtl |= (u16)(cbMACHdLen << 10);
 
     //Set FIFOCTL_GrpAckPolicy
@@ -1336,11 +1325,6 @@ static void s_vGenerateMACHeader(struct vnt_private *pDevice,
 
     pMACHeader->duration_id = cpu_to_le16(wDuration);
 
-    if (pDevice->bLongHeader) {
-        PWLAN_80211HDR_A4 pMACA4Header  = (PWLAN_80211HDR_A4) pbyBufferAddr;
-        pMACHeader->frame_control |= (FC_TODS | FC_FROMDS);
-        memcpy(pMACA4Header->abyAddr4, pDevice->abyBSSID, WLAN_ADDR_LEN);
-    }
     pMACHeader->seq_ctrl = cpu_to_le16(pDevice->wSeqCounter << 4);
 
     //Set FragNumber in Sequence Control
-- 
1.8.4.4

