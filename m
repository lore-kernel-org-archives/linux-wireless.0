Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:44924 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaCVJCe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Mar 2014 05:02:34 -0400
Received: by mail-wi0-f180.google.com with SMTP id hn9so1141419wib.1
        for <linux-wireless@vger.kernel.org>; Sat, 22 Mar 2014 02:02:33 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 08/10] staging: vt6656: rxtx Replace vnt_tx_fifo_head wReserved
Date: Sat, 22 Mar 2014 09:01:30 +0000
Message-Id: <1395478892-3419-8-git-send-email-tvboxspy@gmail.com> (sfid-20140322_100241_098919_46BE6369)
In-Reply-To: <1395478892-3419-1-git-send-email-tvboxspy@gmail.com>
References: <1395478892-3419-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

At run time wReserved has the value of wCurrentRate.

Replace with current_rate with __le16 base type and endian correct
wCurrentRate.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 2 +-
 drivers/staging/vt6656/rxtx.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 4bb13a7..2b67b1b 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -800,7 +800,7 @@ static u16 s_vGenerateTxParameter(struct vnt_private *pDevice,
 	u16 wFifoCtl;
 	u8 byFBOption = AUTO_FB_NONE;
 
-	pFifoHead->wReserved = wCurrentRate;
+	pFifoHead->current_rate = cpu_to_le16(wCurrentRate);
 	wFifoCtl = pFifoHead->wFIFOCtl;
 
 	if (wFifoCtl & FIFOCTL_AUTO_FB_0)
diff --git a/drivers/staging/vt6656/rxtx.h b/drivers/staging/vt6656/rxtx.h
index 779c672..4dfb2e0 100644
--- a/drivers/staging/vt6656/rxtx.h
+++ b/drivers/staging/vt6656/rxtx.h
@@ -219,7 +219,7 @@ struct vnt_tx_fifo_head {
 	u16 wFIFOCtl;
 	__le16 time_stamp;
 	u16 wFragCtl;
-	u16 wReserved;
+	__le16 current_rate;
 } __packed;
 
 struct vnt_tx_buffer {
-- 
1.9.0

