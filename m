Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:42900 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322Ab3HXMB7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Aug 2013 08:01:59 -0400
Received: by mail-wi0-f170.google.com with SMTP id ex4so2538wid.3
        for <linux-wireless@vger.kernel.org>; Sat, 24 Aug 2013 05:01:58 -0700 (PDT)
Message-ID: <1377345708.23229.16.camel@canaries32-MCP7A> (sfid-20130824_140202_645189_5CD43435)
Subject: [PATCH 4/5] staging: vt6656: s_vGenerateTxParameter dead code
 bDisCRC
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sat, 24 Aug 2013 13:01:48 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As result of patch
vt6656: rxtx.c s_vFillCTSHead remove dead code bDisCRC

bDisCRC is unused.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 7b94a77..64ce7f0 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -846,7 +846,6 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
 {
 	u32 cbMACHdLen = WLAN_HDR_ADDR3_LEN; /* 24 */
 	u16 wFifoCtl;
-	int bDisCRC = false;
 	u8 byFBOption = AUTO_FB_NONE;
 
     //DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"s_vGenerateTxParameter...\n");
@@ -854,10 +853,6 @@ static void s_vGenerateTxParameter(struct vnt_private *pDevice,
     pFifoHead->wReserved = wCurrentRate;
     wFifoCtl = pFifoHead->wFIFOCtl;
 
-    if (wFifoCtl & FIFOCTL_CRCDIS) {
-        bDisCRC = true;
-    }
-
     if (wFifoCtl & FIFOCTL_AUTO_FB_0) {
         byFBOption = AUTO_FB_0;
     }
-- 
1.8.1.2

