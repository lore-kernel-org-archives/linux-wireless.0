Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:36693 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbaHVVfz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 17:35:55 -0400
Received: by mail-we0-f171.google.com with SMTP id p10so11187365wes.2
        for <linux-wireless@vger.kernel.org>; Fri, 22 Aug 2014 14:35:54 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/3] staging: vt6655: rxtx create new structure vnt_tx_short_buf_head for csBeacon_xmit
Date: Fri, 22 Aug 2014 22:35:11 +0100
Message-Id: <1408743311-13177-3-git-send-email-tvboxspy@gmail.com> (sfid-20140822_233558_826110_3FFDB900)
In-Reply-To: <1408743311-13177-1-git-send-email-tvboxspy@gmail.com>
References: <1408743311-13177-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a merger of PSTxDataHead_ab and PSTxShortBufHead of which typedef struct tagSTxShortBufHead
is removed.

This is formed as fifo_ctl, time_stamp, struct vnt_phy_field, duration and time_stamp_off.

Replacing stuctures in csBeacon_xmit and doing endian correction where necessary.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/desc.h |  7 -------
 drivers/staging/vt6655/rxtx.c | 37 ++++++++++++++++++++-----------------
 drivers/staging/vt6655/rxtx.h |  8 ++++++++
 3 files changed, 28 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index 10bd564..b5730df 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -483,13 +483,6 @@ typedef struct tagSTxBufHead {
 STxBufHead, *PSTxBufHead;
 typedef const STxBufHead *PCSTxBufHead;
 
-typedef struct tagSTxShortBufHead {
-	unsigned short wFIFOCtl;
-	unsigned short wTimeStamp;
-} __attribute__ ((__packed__))
-STxShortBufHead, *PSTxShortBufHead;
-typedef const STxShortBufHead *PCSTxShortBufHead;
-
 //
 // Tx data header
 //
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 04cf9e9..7493db1 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -2334,13 +2334,12 @@ CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice, PSTxMgmtPacket pPacket)
 	unsigned char *pbyBuffer = (unsigned char *)pDevice->tx_beacon_bufs;
 	unsigned int cbFrameSize = pPacket->cbMPDULen + WLAN_FCS_LEN;
 	unsigned int cbHeaderSize = 0;
-	unsigned short wTxBufSize = sizeof(STxShortBufHead);
-	PSTxShortBufHead pTxBufHead = (PSTxShortBufHead) pbyBuffer;
-	PSTxDataHead_ab  pTxDataHead = (PSTxDataHead_ab) (pbyBuffer + wTxBufSize);
+	struct vnt_tx_short_buf_head *short_head =
+				(struct vnt_tx_short_buf_head *)pbyBuffer;
 	PS802_11Header   pMACHeader;
 	unsigned short wCurrentRate;
 
-	memset(pTxBufHead, 0, wTxBufSize);
+	memset(short_head, 0, sizeof(*short_head));
 
 	if (pDevice->eCurrentPHYType == PHY_TYPE_11A) {
 		wCurrentRate = RATE_6M;
@@ -2353,26 +2352,30 @@ CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice, PSTxMgmtPacket pPacket)
 	//Set Preamble type always long
 	pDevice->byPreambleType = PREAMBLE_LONG;
 
-	//Set FIFOCTL_GENINT
-
-	pTxBufHead->wFIFOCtl |= FIFOCTL_GENINT;
+	/* Set FIFOCTL_GENINT */
+	short_head->fifo_ctl |= cpu_to_le16(FIFOCTL_GENINT);
 
-	//Set packet type & Get Duration
+	/* Set packet type & Get Duration */
 	if (byPktType == PK_TYPE_11A) {//0000 0000 0000 0000
-		pTxDataHead->wDuration = cpu_to_le16((unsigned short)s_uGetDataDuration(pDevice, DATADUR_A, cbFrameSize, byPktType,
-											wCurrentRate, false, 0, 0, 1, AUTO_FB_NONE));
+		short_head->duration =
+			cpu_to_le16((u16)s_uGetDataDuration(pDevice, DATADUR_A,
+				    cbFrameSize, byPktType, wCurrentRate, false,
+				    0, 0, 1, AUTO_FB_NONE));
 	} else if (byPktType == PK_TYPE_11B) {//0000 0001 0000 0000
-		pTxBufHead->wFIFOCtl |= FIFOCTL_11B;
-		pTxDataHead->wDuration = cpu_to_le16((unsigned short)s_uGetDataDuration(pDevice, DATADUR_B, cbFrameSize, byPktType,
-											wCurrentRate, false, 0, 0, 1, AUTO_FB_NONE));
+		short_head->fifo_ctl |= cpu_to_le16(FIFOCTL_11B);
+
+		short_head->duration =
+			cpu_to_le16((u16)s_uGetDataDuration(pDevice, DATADUR_B,
+				    cbFrameSize, byPktType, wCurrentRate, false,
+				    0, 0, 1, AUTO_FB_NONE));
 	}
 
 	vnt_get_phy_field(pDevice, cbFrameSize,
-			  wCurrentRate, byPktType, &pTxDataHead->ab);
+			  wCurrentRate, byPktType, &short_head->ab);
 
-	//Get TimeStampOff
-	pTxDataHead->wTimeStampOff = cpu_to_le16(wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE]);
-	cbHeaderSize = wTxBufSize + sizeof(STxDataHead_ab);
+	/* Get TimeStampOff */
+	short_head->time_stamp_off = cpu_to_le16(wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE]);
+	cbHeaderSize = sizeof(struct vnt_tx_short_buf_head);
 
 	//Generate Beacon Header
 	pMACHeader = (PS802_11Header)(pbyBuffer + cbHeaderSize);
diff --git a/drivers/staging/vt6655/rxtx.h b/drivers/staging/vt6655/rxtx.h
index 4accb78..789fae7 100644
--- a/drivers/staging/vt6655/rxtx.h
+++ b/drivers/staging/vt6655/rxtx.h
@@ -56,6 +56,14 @@ struct vnt_mic_hdr {
 	u16 packing; /* packing to 48 bytes */
 } __packed;
 
+struct vnt_tx_short_buf_head {
+	__le16 fifo_ctl;
+	u16 time_stamp;
+	struct vnt_phy_field ab;
+	__le16 duration;
+	__le16 time_stamp_off;
+} __packed;
+
 void
 vGenerateMACHeader(
 	struct vnt_private *,
-- 
1.9.1

