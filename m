Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:60180 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382AbaEaMfz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2014 08:35:55 -0400
Received: by mail-wi0-f169.google.com with SMTP id hi2so2279214wib.2
        for <linux-wireless@vger.kernel.org>; Sat, 31 May 2014 05:35:54 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/4] staging: vt6656: rxtx add mac header to vnt_tx_datahead_* structures
Date: Sat, 31 May 2014 13:34:58 +0100
Message-Id: <1401539700-3183-2-git-send-email-tvboxspy@gmail.com> (sfid-20140531_143603_468465_EA2CC9FD)
In-Reply-To: <1401539700-3183-1-git-send-email-tvboxspy@gmail.com>
References: <1401539700-3183-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add vnt_mac_hdr_pos to set mac header pointer and the calculate header size.

Pass ieee80211 hdr pointer and tx_hdr_size in vnt_usb_send_context.

Remove old pointer arithmetic and attach pMACHeader to hdr.

cbHeaderLength/cbHeaderSize now uses the value of tx_hdr_size.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h |   2 +
 drivers/staging/vt6656/rxtx.c   | 122 ++++++++++++++++------------------------
 drivers/staging/vt6656/rxtx.h   |   4 ++
 3 files changed, 55 insertions(+), 73 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 5b64ca7..11b863d 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -241,7 +241,9 @@ struct vnt_usb_send_context {
 	void *priv;
 	struct sk_buff *skb;
 	struct urb *urb;
+	struct ieee80211_hdr *hdr;
 	unsigned int buf_len;
+	u16 tx_hdr_size;
 	u8 type;
 	bool in_use;
 	unsigned char data[MAX_TOTAL_SIZE_WITH_ALL_HEADERS];
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index fa04894..e4cc1ff 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -102,8 +102,9 @@ static u16 s_vGenerateTxParameter(struct vnt_usb_send_context *tx_context,
 	int bNeedACK, struct ethhdr *psEthHeader, bool need_rts);
 
 static void s_vGenerateMACHeader(struct vnt_private *pDevice,
-	u8 *pbyBufferAddr, u16 wDuration, struct ethhdr *psEthHeader,
-	int bNeedEncrypt, u16 wFragType, u32 uFragIdx);
+	struct ieee80211_hdr *pMACHeader, u16 wDuration,
+	struct ethhdr *psEthHeader, int bNeedEncrypt, u16 wFragType,
+	u32 uFragIdx);
 
 static void s_vFillTxKey(struct vnt_private *pDevice,
 	struct vnt_tx_fifo_head *fifo_head, u8 *pbyIVHead,
@@ -151,6 +152,9 @@ static struct vnt_usb_send_context
 			context->in_use = true;
 			memset(context->data, 0,
 					MAX_TOTAL_SIZE_WITH_ALL_HEADERS);
+
+			context->hdr = NULL;
+
 			return context;
 		}
 	}
@@ -470,6 +474,19 @@ static __le16 s_uGetRTSCTSDuration(struct vnt_private *pDevice, u8 byDurType,
 	return cpu_to_le16((u16)uDurTime);
 }
 
+static u16 vnt_mac_hdr_pos(struct vnt_usb_send_context *tx_context,
+	struct ieee80211_hdr *hdr)
+{
+	u8 *head = tx_context->data + offsetof(struct vnt_tx_buffer, fifo_head);
+	u8 *hdr_pos = (u8 *)hdr;
+
+	tx_context->hdr = hdr;
+	if (!tx_context->hdr)
+		return 0;
+
+	return (u16)(hdr_pos - head);
+}
+
 static u16 vnt_rxtx_datahead_g(struct vnt_usb_send_context *tx_context,
 		u8 pkt_type, u16 rate, struct vnt_tx_datahead_g *buf,
 		u32 frame_len, int need_ack)
@@ -490,6 +507,8 @@ static u16 vnt_rxtx_datahead_g(struct vnt_usb_send_context *tx_context,
 	buf->time_stamp_off_b = vnt_time_stamp_off(priv,
 					priv->byTopCCKBasicRate);
 
+	tx_context->tx_hdr_size = vnt_mac_hdr_pos(tx_context, &buf->hdr);
+
 	return le16_to_cpu(buf->duration_a);
 }
 
@@ -516,6 +535,8 @@ static u16 vnt_rxtx_datahead_g_fb(struct vnt_usb_send_context *tx_context,
 	buf->time_stamp_off_b = vnt_time_stamp_off(priv,
 						priv->byTopCCKBasicRate);
 
+	tx_context->tx_hdr_size = vnt_mac_hdr_pos(tx_context, &buf->hdr);
+
 	return le16_to_cpu(buf->duration_a);
 }
 
@@ -535,6 +556,8 @@ static u16 vnt_rxtx_datahead_a_fb(struct vnt_usb_send_context *tx_context,
 
 	buf->time_stamp_off = vnt_time_stamp_off(priv, rate);
 
+	tx_context->tx_hdr_size = vnt_mac_hdr_pos(tx_context, &buf->hdr);
+
 	return le16_to_cpu(buf->duration);
 }
 
@@ -551,6 +574,8 @@ static u16 vnt_rxtx_datahead_ab(struct vnt_usb_send_context *tx_context,
 
 	buf->time_stamp_off = vnt_time_stamp_off(priv, rate);
 
+	tx_context->tx_hdr_size = vnt_mac_hdr_pos(tx_context, &buf->hdr);
+
 	return le16_to_cpu(buf->duration);
 }
 
@@ -979,7 +1004,7 @@ static int s_bPacketToWirelessUsb(struct vnt_usb_send_context *tx_context,
 	u32 cbFCSlen = 4, cbMICHDR = 0;
 	int bNeedACK;
 	bool bRTS = false;
-	u8 *pbyType, *pbyMacHdr, *pbyIVHead, *pbyPayloadHead, *pbyTxBufferAddr;
+	u8 *pbyType, *pbyMacHdr, *pbyIVHead, *pbyPayloadHead;
 	u8 abySNAP_RFC1042[ETH_ALEN] = {0xAA, 0xAA, 0x03, 0x00, 0x00, 0x00};
 	u8 abySNAP_Bridgetunnel[ETH_ALEN]
 		= {0xAA, 0xAA, 0x03, 0x00, 0x00, 0xF8};
@@ -987,7 +1012,6 @@ static int s_bPacketToWirelessUsb(struct vnt_usb_send_context *tx_context,
 	u32 cbHeaderLength = 0, uPadding = 0;
 	struct vnt_mic_hdr *pMICHDR;
 	u8 byFBOption = AUTO_FB_NONE, byFragType;
-	u16 wTxBufSize;
 	u32 dwMICKey0, dwMICKey1, dwMIC_Priority;
 	u32 *pdwMIC_L, *pdwMIC_R;
 	int bSoftWEP = false;
@@ -1106,58 +1130,6 @@ static int s_bPacketToWirelessUsb(struct vnt_usb_send_context *tx_context,
         pTxBufHead->wFIFOCtl |= (FIFOCTL_RTS | FIFOCTL_LRETRY);
     }
 
-    pbyTxBufferAddr = (u8 *) &(pTxBufHead->adwTxKey[0]);
-	wTxBufSize = sizeof(struct vnt_tx_fifo_head);
-
-    if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {//802.11g packet
-        if (byFBOption == AUTO_FB_NONE) {
-            if (bRTS == true) {//RTS_need
-		cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_rts) +
-			cbMICHDR + sizeof(struct vnt_rts_g);
-            }
-            else { //RTS_needless
-		cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_cts) +
-			cbMICHDR + sizeof(struct vnt_cts);
-            }
-        } else {
-            // Auto Fall Back
-            if (bRTS == true) {//RTS_need
-		cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_rts) +
-			cbMICHDR + sizeof(struct vnt_rts_g_fb);
-            }
-            else if (bRTS == false) { //RTS_needless
-		cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_cts) +
-				cbMICHDR + sizeof(struct vnt_cts_fb);
-            }
-        } // Auto Fall Back
-    }
-    else {//802.11a/b packet
-        if (byFBOption == AUTO_FB_NONE) {
-            if (bRTS == true) {//RTS_need
-		cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_ab) +
-			cbMICHDR + sizeof(struct vnt_rts_ab);
-            }
-            else if (bRTS == false) { //RTS_needless, no MICHDR
-		cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_ab) +
-				cbMICHDR + sizeof(struct vnt_tx_datahead_ab);
-            }
-        } else {
-            // Auto Fall Back
-            if (bRTS == true) {//RTS_need
-		cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_ab) +
-			cbMICHDR + sizeof(struct vnt_rts_a_fb);
-            }
-            else if (bRTS == false) { //RTS_needless
-		cbHeaderLength = wTxBufSize + sizeof(struct vnt_rrv_time_ab) +
-			cbMICHDR + sizeof(struct vnt_tx_datahead_a_fb);
-            }
-        } // Auto Fall Back
-    }
-
-    pbyMacHdr = (u8 *)(pbyTxBufferAddr + cbHeaderLength);
-    pbyIVHead = (u8 *)(pbyMacHdr + cbMACHdLen + uPadding);
-    pbyPayloadHead = (u8 *)(pbyMacHdr + cbMACHdLen + uPadding + cbIVlen);
-
     //=========================
     //    No Fragmentation
     //=========================
@@ -1170,9 +1142,17 @@ static int s_bPacketToWirelessUsb(struct vnt_usb_send_context *tx_context,
 			tx_buffer, &pMICHDR, cbMICHDR,
 			cbFrameSize, bNeedACK, psEthHeader, bRTS);
 
-    // Generate TX MAC Header
-    s_vGenerateMACHeader(pDevice, pbyMacHdr, (u16)uDuration, psEthHeader, bNeedEncryption,
-		byFragType, 0);
+	cbHeaderLength = tx_context->tx_hdr_size;
+	if (!cbHeaderLength)
+		return false;
+
+	pbyMacHdr = (u8 *)tx_context->hdr;
+	pbyIVHead = (u8 *)(pbyMacHdr + cbMACHdLen + uPadding);
+	pbyPayloadHead = (u8 *)(pbyMacHdr + cbMACHdLen + uPadding + cbIVlen);
+
+	/* Generate TX MAC Header */
+	s_vGenerateMACHeader(pDevice, tx_context->hdr, (u16)uDuration,
+		psEthHeader, bNeedEncryption, byFragType, 0);
 
     if (bNeedEncryption == true) {
         //Fill TXKEY
@@ -1298,10 +1278,10 @@ static int s_bPacketToWirelessUsb(struct vnt_usb_send_context *tx_context,
 -*/
 
 static void s_vGenerateMACHeader(struct vnt_private *pDevice,
-	u8 *pbyBufferAddr, u16 wDuration, struct ethhdr *psEthHeader,
-	int bNeedEncrypt, u16 wFragType, u32 uFragIdx)
+	struct ieee80211_hdr *pMACHeader, u16 wDuration,
+	struct ethhdr *psEthHeader, int bNeedEncrypt, u16 wFragType,
+	u32 uFragIdx)
 {
-	struct ieee80211_hdr *pMACHeader = (struct ieee80211_hdr *)pbyBufferAddr;
 
 	pMACHeader->frame_control = TYPE_802_11_DATA;
 
@@ -1516,16 +1496,6 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
     }
     //the rest of pTxBufHead->wFragCtl:FragTyp will be set later in s_vFillFragParameter()
 
-    //Set RrvTime/RTS/CTS Buffer
-    if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {//802.11g packet
-	cbHeaderSize = wTxBufSize + sizeof(struct vnt_rrv_time_cts) +
-		sizeof(struct vnt_cts);
-    }
-    else { // 802.11a/b packet
-	cbHeaderSize = wTxBufSize + sizeof(struct vnt_rrv_time_ab) +
-		sizeof(struct vnt_tx_datahead_ab);
-    }
-
     memcpy(&(sEthHeader.h_dest[0]),
 	   &(pPacket->p80211Header->sA3.abyAddr1[0]),
 	   ETH_ALEN);
@@ -1542,7 +1512,13 @@ CMD_STATUS csMgmt_xmit(struct vnt_private *pDevice,
 		pTX_Buffer, &pMICHDR, 0,
 		cbFrameSize, bNeedACK, &sEthHeader, false);
 
-    pMACHeader = (struct ieee80211_hdr *) (pbyTxBufferAddr + cbHeaderSize);
+	cbHeaderSize = pContext->tx_hdr_size;
+	if (!cbHeaderSize) {
+		pContext->in_use = false;
+		return CMD_STATUS_RESOURCES;
+	}
+
+	pMACHeader = pContext->hdr;
 
     cbReqCount = cbHeaderSize + cbMacHdLen + uPadding + cbIVlen + cbFrameBodySize;
 
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index 6db3337..30e1437 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -81,6 +81,7 @@ struct vnt_tx_datahead_g {
 	__le16 duration_a;
 	__le16 time_stamp_off_b;
 	__le16 time_stamp_off_a;
+	struct ieee80211_hdr hdr;
 } __packed;
 
 struct vnt_tx_datahead_g_fb {
@@ -92,12 +93,14 @@ struct vnt_tx_datahead_g_fb {
 	__le16 duration_a_f1;
 	__le16 time_stamp_off_b;
 	__le16 time_stamp_off_a;
+	struct ieee80211_hdr hdr;
 } __packed;
 
 struct vnt_tx_datahead_ab {
 	struct vnt_phy_field ab;
 	__le16 duration;
 	__le16 time_stamp_off;
+	struct ieee80211_hdr hdr;
 } __packed;
 
 struct vnt_tx_datahead_a_fb {
@@ -106,6 +109,7 @@ struct vnt_tx_datahead_a_fb {
 	__le16 time_stamp_off;
 	__le16 duration_f0;
 	__le16 duration_f1;
+	struct ieee80211_hdr hdr;
 } __packed;
 
 /* RTS buffer header */
-- 
1.9.1

