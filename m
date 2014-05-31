Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:62287 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756507AbaEaMf6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2014 08:35:58 -0400
Received: by mail-wg0-f50.google.com with SMTP id x12so3103726wgg.33
        for <linux-wireless@vger.kernel.org>; Sat, 31 May 2014 05:35:57 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4/4] staging: vt6656: rxtx replace adwTxKey[4]
Date: Sat, 31 May 2014 13:35:00 +0100
Message-Id: <1401539700-3183-4-git-send-email-tvboxspy@gmail.com> (sfid-20140531_143606_696051_74DCF033)
In-Reply-To: <1401539700-3183-1-git-send-email-tvboxspy@gmail.com>
References: <1401539700-3183-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace with tx_key with size of WLAN_KEY_LEN_CCMP(16)

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 4 ++--
 drivers/staging/vt6656/rxtx.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 26cc57e..22cb642 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -182,7 +182,7 @@ static void s_vFillTxKey(struct vnt_usb_send_context *tx_context,
 {
 	struct vnt_private *pDevice = tx_context->priv;
 	struct ieee80211_hdr *pMACHeader = tx_context->hdr;
-	u8 *pbyBuf = (u8 *)&fifo_head->adwTxKey[0];
+	u8 *pbyBuf = fifo_head->tx_key;
 	__le32 *pdwIV = (__le32 *)pbyIVHead;
 	__le32 *pdwExtIV = (__le32 *)((u8 *)pbyIVHead + 4);
 	__le32 rev_iv_counter;
@@ -1404,7 +1404,7 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 	pTX_Buffer = (struct vnt_tx_buffer *)&pContext->data[0];
     cbFrameBodySize = pPacket->cbPayloadLen;
 	pTxBufHead = &pTX_Buffer->fifo_head;
-	pbyTxBufferAddr = (u8 *)&pTxBufHead->adwTxKey[0];
+	pbyTxBufferAddr = (u8 *)pTxBufHead;
 	wTxBufSize = sizeof(struct vnt_tx_fifo_head);
 
 
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index 30e1437..95a4e2c 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -219,7 +219,7 @@ union vnt_tx_head {
 };
 
 struct vnt_tx_fifo_head {
-	u32 adwTxKey[4];
+	u8 tx_key[WLAN_KEY_LEN_CCMP];
 	u16 wFIFOCtl;
 	__le16 time_stamp;
 	u16 wFragCtl;
-- 
1.9.1

