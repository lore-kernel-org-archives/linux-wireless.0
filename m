Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:47226 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab3HXLmO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Aug 2013 07:42:14 -0400
Received: by mail-we0-f174.google.com with SMTP id q54so1367800wes.19
        for <linux-wireless@vger.kernel.org>; Sat, 24 Aug 2013 04:42:12 -0700 (PDT)
Message-ID: <1377344521.23229.5.camel@canaries32-MCP7A> (sfid-20130824_134223_398572_9ED14715)
Subject: [PATCH 1/5] staging: vt6656: device.h Remove dead code
 bSoftwareGenCrcErr.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sat, 24 Aug 2013 12:42:01 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Probably an error in earlier firmware is never enabled so remove.

bPacketToWirelessUsb remove dead if/else and variables.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h |  1 -
 drivers/staging/vt6656/rxtx.c   | 21 +--------------------
 2 files changed, 1 insertion(+), 21 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 4986910..e8f4b19 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -596,7 +596,6 @@ struct vnt_private {
 	int bCCK;
 	int bEncryptionEnable;
 	int bLongHeader;
-	int bSoftwareGenCrcErr;
 	int bShortSlotTime;
 	int bProtectMode;
 	int bNonERPPresent;
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 14b7def..80741c0 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -1003,7 +1003,7 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 	void *pvTxDataHd;
 	u8 byFBOption = AUTO_FB_NONE, byFragType;
 	u16 wTxBufSize;
-	u32 dwMICKey0, dwMICKey1, dwMIC_Priority, dwCRC;
+	u32 dwMICKey0, dwMICKey1, dwMIC_Priority;
 	u32 *pdwMIC_L, *pdwMIC_R;
 	int bSoftWEP = false;
 
@@ -1058,10 +1058,6 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
     if (pDevice->bLongHeader)
         pTxBufHead->wFIFOCtl |= FIFOCTL_LHEAD;
 
-    if (pDevice->bSoftwareGenCrcErr) {
-        pTxBufHead->wFIFOCtl |= FIFOCTL_CRCDIS; // set tx descriptors to NO hardware CRC
-    }
-
     //Set FRAGCTL_MACHDCNT
     if (pDevice->bLongHeader) {
         cbMACHdLen = WLAN_HDR_ADDR3_LEN + 6;
@@ -1386,22 +1382,7 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
         cbFrameSize -= cbICVlen;
     }
 
-    if (pDevice->bSoftwareGenCrcErr == true) {
-	unsigned int cbLen;
-        u32 * pdwCRC;
-
-        dwCRC = 0xFFFFFFFFL;
-        cbLen = cbFrameSize - cbFCSlen;
-        // calculate CRC, and wrtie CRC value to end of TD
-        dwCRC = CRCdwGetCrc32Ex(pbyMacHdr, cbLen, dwCRC);
-        pdwCRC = (u32 *)(pbyMacHdr + cbLen);
-        // finally, we must invert dwCRC to get the correct answer
-        *pdwCRC = ~dwCRC;
-        // Force Error
-        *pdwCRC -= 1;
-    } else {
         cbFrameSize -= cbFCSlen;
-    }
 
     *pcbHeaderLen = cbHeaderLength;
     *pcbTotalLen = cbHeaderLength + cbFrameSize ;
-- 
1.8.1.2


