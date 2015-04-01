Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:34841 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbbDAVd2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2015 17:33:28 -0400
Received: by wgdm6 with SMTP id m6so66974851wgd.2
        for <linux-wireless@vger.kernel.org>; Wed, 01 Apr 2015 14:33:27 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/2] staging: vt6655: s_vGenerateTxParameter Replace PSTxBufHead with struct vnt_tx_fifo_head
Date: Wed,  1 Apr 2015 22:32:51 +0100
Message-Id: <1427923972-11947-1-git-send-email-tvboxspy@gmail.com> (sfid-20150401_233331_943599_BCB85997)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With endian correction on fifo_ctl and current_rate.

Removing pTxBufHead, pFifoHead and wFifoCtl

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/rxtx.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 5b869d1..195dcc9 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -116,7 +116,7 @@ void
 s_vGenerateTxParameter(
 	struct vnt_private *pDevice,
 	unsigned char byPktType,
-	void *pTxBufHead,
+	struct vnt_tx_fifo_head *,
 	void *pvRrvTime,
 	void *pvRTS,
 	void *pvCTS,
@@ -944,7 +944,7 @@ void
 s_vGenerateTxParameter(
 	struct vnt_private *pDevice,
 	unsigned char byPktType,
-	void *pTxBufHead,
+	struct vnt_tx_fifo_head *tx_buffer_head,
 	void *pvRrvTime,
 	void *pvRTS,
 	void *pvCTS,
@@ -955,21 +955,18 @@ s_vGenerateTxParameter(
 	unsigned short wCurrentRate
 )
 {
-	unsigned short wFifoCtl;
+	u16 fifo_ctl = le16_to_cpu(tx_buffer_head->fifo_ctl);
 	bool bDisCRC = false;
 	unsigned char byFBOption = AUTO_FB_NONE;
 
-	PSTxBufHead pFifoHead = (PSTxBufHead)pTxBufHead;
-
-	pFifoHead->wReserved = wCurrentRate;
-	wFifoCtl = pFifoHead->wFIFOCtl;
+	tx_buffer_head->current_rate = cpu_to_le16(wCurrentRate);
 
-	if (wFifoCtl & FIFOCTL_CRCDIS)
+	if (fifo_ctl & FIFOCTL_CRCDIS)
 		bDisCRC = true;
 
-	if (wFifoCtl & FIFOCTL_AUTO_FB_0)
+	if (fifo_ctl & FIFOCTL_AUTO_FB_0)
 		byFBOption = AUTO_FB_0;
-	else if (wFifoCtl & FIFOCTL_AUTO_FB_1)
+	else if (fifo_ctl & FIFOCTL_AUTO_FB_1)
 		byFBOption = AUTO_FB_1;
 
 	if (!pvRrvTime)
-- 
2.1.0

