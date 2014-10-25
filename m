Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:39788 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbaJYTnc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 15:43:32 -0400
Received: by mail-wi0-f169.google.com with SMTP id q5so3380441wiv.4
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 12:43:31 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 28/31] staging: vt6655: s_vGenerateTxParameter remove unused cbMACHdLen
Date: Sat, 25 Oct 2014 09:20:38 +0100
Message-Id: <1414225241-5480-29-git-send-email-tvboxspy@gmail.com> (sfid-20141025_214335_837780_7A49E626)
In-Reply-To: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
References: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/rxtx.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 23ee379..9beabea 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -1132,7 +1132,6 @@ s_vGenerateTxParameter(
 	unsigned short wCurrentRate
 )
 {
-	unsigned int cbMACHdLen = WLAN_HDR_ADDR3_LEN; //24
 	unsigned short wFifoCtl;
 	bool bDisCRC = false;
 	unsigned char byFBOption = AUTO_FB_NONE;
@@ -1150,9 +1149,6 @@ s_vGenerateTxParameter(
 	else if (wFifoCtl & FIFOCTL_AUTO_FB_1)
 		byFBOption = AUTO_FB_1;
 
-	if (pDevice->bLongHeader)
-		cbMACHdLen = WLAN_HDR_ADDR3_LEN + 6;
-
 	if (!pvRrvTime)
 		return;
 
-- 
1.9.1

