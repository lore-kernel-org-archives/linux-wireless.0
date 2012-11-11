Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59769 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab2KKPxW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Nov 2012 10:53:22 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so2944024eek.19
        for <linux-wireless@vger.kernel.org>; Sun, 11 Nov 2012 07:53:21 -0800 (PST)
Message-ID: <1352649194.6460.23.camel@canaries32-MCP7A> (sfid-20121111_165325_455062_CB58FC1F)
Subject: [PATCH 11/14] staging: vt6656: 64 bit fixes pdwIV is now u32
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sun, 11 Nov 2012 15:53:14 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


 Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

---
 drivers/staging/vt6656/rxtx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 0c7e638..20fbd2b 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -355,7 +355,7 @@ s_vFillTxKey (
         }
         // Append IV after Mac Header
         *pdwIV &= WEP_IV_MASK;//00000000 11111111 11111111 11111111
-        *pdwIV |= (unsigned long)pDevice->byKeyIndex << 30;
+	*pdwIV |= (u32)pDevice->byKeyIndex << 30;
         *pdwIV = cpu_to_le32(*pdwIV);
         pDevice->dwIVCounter++;
         if (pDevice->dwIVCounter > WEP_IV_MASK) {
-- 
1.8.0




