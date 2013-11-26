Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:43687 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822Ab3KZTGl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Nov 2013 14:06:41 -0500
Received: by mail-we0-f181.google.com with SMTP id x55so5711018wes.40
        for <linux-wireless@vger.kernel.org>; Tue, 26 Nov 2013 11:06:40 -0800 (PST)
Message-ID: <1385492795.6446.2.camel@canaries32-MCP7A> (sfid-20131126_200644_825509_201ADC7E)
Subject: [PATCH 1/3] staging: vt6656: remove void pointer from
 s_vGetFreeContext
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 26 Nov 2013 19:06:35 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace with struct vnt_usb_send_context.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index cc23029..0e4b6fb 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -96,7 +96,8 @@ static const u16 wFB_Opt1[2][5] = {
 static void s_vSaveTxPktInfo(struct vnt_private *pDevice, u8 byPktNum,
 	u8 *pbyDestAddr, u16 wPktLength, u16 wFIFOCtl);
 
-static void *s_vGetFreeContext(struct vnt_private *pDevice);
+static struct vnt_usb_send_context
+		*s_vGetFreeContext(struct vnt_private *pDevice);
 
 static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
 	u8 byPktType, u16 wCurrentRate,	struct vnt_tx_buffer *tx_buffer,
@@ -136,7 +137,8 @@ static u16 s_uGetRTSCTSDuration(struct vnt_private *pDevice,
 	u8 byDurType, u32 cbFrameLength, u8 byPktType, u16 wRate,
 	int bNeedAck, u8 byFBOption);
 
-static void *s_vGetFreeContext(struct vnt_private *pDevice)
+static struct vnt_usb_send_context
+	*s_vGetFreeContext(struct vnt_private *pDevice)
 {
 	struct vnt_usb_send_context *pContext = NULL;
 	struct vnt_usb_send_context *pReturnContext = NULL;
@@ -158,7 +160,8 @@ static void *s_vGetFreeContext(struct vnt_private *pDevice)
     if ( ii == pDevice->cbTD ) {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"No Free Tx Context\n");
     }
-    return (void *) pReturnContext;
+
+	return pReturnContext;
 }
 
 static void s_vSaveTxPktInfo(struct vnt_private *pDevice, u8 byPktNum,
@@ -1377,7 +1380,7 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 	u32 cbMacHdLen;
 	u16 wCurrentRate = RATE_1M;
 
-	pContext = (struct vnt_usb_send_context *)s_vGetFreeContext(pDevice);
+	pContext = s_vGetFreeContext(pDevice);
 
     if (NULL == pContext) {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"ManagementSend TX...NO CONTEXT!\n");
@@ -1635,7 +1638,7 @@ CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice,
 	struct vnt_usb_send_context *pContext;
 	CMD_STATUS status;
 
-	pContext = (struct vnt_usb_send_context *)s_vGetFreeContext(pDevice);
+	pContext = s_vGetFreeContext(pDevice);
     if (NULL == pContext) {
         status = CMD_STATUS_RESOURCES;
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"ManagementSend TX...NO CONTEXT!\n");
@@ -1745,7 +1748,7 @@ void vDMA0_tx_80211(struct vnt_private *pDevice, struct sk_buff *skb)
     }
     p80211Header = (PUWLAN_80211HDR)skb->data;
 
-	pContext = (struct vnt_usb_send_context *)s_vGetFreeContext(pDevice);
+	pContext = s_vGetFreeContext(pDevice);
 
     if (NULL == pContext) {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"DMA0 TX...NO CONTEXT!\n");
@@ -2166,7 +2169,7 @@ int nsDMA_tx_packet(struct vnt_private *pDevice,
         }
     }
 
-	pContext = (struct vnt_usb_send_context *)s_vGetFreeContext(pDevice);
+	pContext = s_vGetFreeContext(pDevice);
 
     if (pContext == NULL) {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_DEBUG" pContext == NULL\n");
@@ -2491,7 +2494,7 @@ int bRelayPacketSend(struct vnt_private *pDevice, u8 *pbySkbData, u32 uDataLen,
 	u32 status;
 	u16 wKeepRate = pDevice->wCurrentRate;
 
-	pContext = (struct vnt_usb_send_context *)s_vGetFreeContext(pDevice);
+	pContext = s_vGetFreeContext(pDevice);
 
     if (NULL == pContext) {
         return false;
-- 
1.8.4.4

