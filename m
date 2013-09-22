Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:36636 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab3IVTQK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Sep 2013 15:16:10 -0400
Received: by mail-we0-f177.google.com with SMTP id t60so2298926wes.36
        for <linux-wireless@vger.kernel.org>; Sun, 22 Sep 2013 12:16:09 -0700 (PDT)
Message-ID: <1379877358.6139.31.camel@canaries32-MCP7A> (sfid-20130922_211617_323500_BE025FCB)
Subject: [PATCH ] staging: vt6656: rxtx.c [BUG] s_vGetFreeContext dead lock
 on null apTD.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sun, 22 Sep 2013 20:15:58 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There seems to be race condition that the device is ndo_start_xmit
at a point where the device is closing and apTD is NULL resulting
in dead lock.

Add a NULL check to apTD and return NULL to calling functions.

This is more likely on 64 bit systems.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index fb743a8..14f3e85 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -148,6 +148,8 @@ static void *s_vGetFreeContext(struct vnt_private *pDevice)
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"GetFreeContext()\n");
 
     for (ii = 0; ii < pDevice->cbTD; ii++) {
+	if (!pDevice->apTD[ii])
+		return NULL;
         pContext = pDevice->apTD[ii];
         if (pContext->bBoolInUse == false) {
             pContext->bBoolInUse = true;
-- 
1.8.3.2

