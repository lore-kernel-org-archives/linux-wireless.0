Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:65082 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbaB0XHO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 18:07:14 -0500
Received: by mail-wg0-f45.google.com with SMTP id m15so13325wgh.16
        for <linux-wireless@vger.kernel.org>; Thu, 27 Feb 2014 15:07:12 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/7] staging: vt6656: struct vnt_usb_send_context remove sEthHeader.
Date: Thu, 27 Feb 2014 23:06:11 +0000
Message-Id: <1393542375-13110-3-git-send-email-tvboxspy@gmail.com> (sfid-20140228_000719_279805_03F25611)
In-Reply-To: <1393542375-13110-1-git-send-email-tvboxspy@gmail.com>
References: <1393542375-13110-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In nsDMA_tx_packet and bRelayPacketSend s_vSaveTxPktInfo points
to sEthHeader.h_dest which is the wrong viable.

Correct and point to pDevice->sTxEthHeader.

This is only relevant in the non fuctioning hostapd access point
mode, shortly to be removed from driver.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h | 1 -
 drivers/staging/vt6656/rxtx.c   | 4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 2574029..72bcafb 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -179,7 +179,6 @@ struct vnt_usb_send_context {
 	void *pDevice;
 	struct sk_buff *pPacket;
 	struct urb *pUrb;
-	struct ethhdr sEthHeader;
 	unsigned int uBufLen;
 	u8 type;
 	bool bBoolInUse;
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index ba0184a..7083af3 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -2444,7 +2444,7 @@ int nsDMA_tx_packet(struct vnt_private *pDevice,
     pContext->uBufLen = (u16)BytesToWrite + 4 ; //USB header
 
     s_vSaveTxPktInfo(pDevice, (u8)(pTX_Buffer->byPKTNO & 0x0F),
-			&pContext->sEthHeader.h_dest[0],
+			&pDevice->sTxEthHeader.h_dest[0],
 			(u16)(BytesToWrite-uHeaderLen),
 			pTX_Buffer->fifo_head.wFIFOCtl);
 
@@ -2598,7 +2598,7 @@ int bRelayPacketSend(struct vnt_private *pDevice, u8 *pbySkbData, u32 uDataLen,
     pContext->uBufLen = (u16)BytesToWrite + 4 ; //USB header
 
     s_vSaveTxPktInfo(pDevice, (u8)(pTX_Buffer->byPKTNO & 0x0F),
-		&pContext->sEthHeader.h_dest[0],
+		&pDevice->sTxEthHeader.h_dest[0],
 		(u16)(BytesToWrite - uHeaderLen),
 		pTX_Buffer->fifo_head.wFIFOCtl);
 
-- 
1.9.0

