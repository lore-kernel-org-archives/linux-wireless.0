Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57233 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab2KKP4J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Nov 2012 10:56:09 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so2944750eek.19
        for <linux-wireless@vger.kernel.org>; Sun, 11 Nov 2012 07:56:08 -0800 (PST)
Message-ID: <1352649362.6460.24.camel@canaries32-MCP7A> (sfid-20121111_165613_789899_33CA42FE)
Subject: [PATCH 12/14] staging: vt6656: 64 bit fixes TKIPvMixKey remove
 unsigned long
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sun, 11 Nov 2012 15:56:02 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


 Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

---
 drivers/staging/vt6656/tkip.c | 40 +++++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/vt6656/tkip.c b/drivers/staging/vt6656/tkip.c
index 003123e..282c08d 100644
--- a/drivers/staging/vt6656/tkip.c
+++ b/drivers/staging/vt6656/tkip.c
@@ -189,27 +189,25 @@ void TKIPvMixKey(
     PBYTE   pbyRC4Key
     )
 {
-    unsigned int p1k[5];
-//    unsigned int ttak0, ttak1, ttak2, ttak3, ttak4;
-    unsigned int tsc0, tsc1, tsc2;
-    unsigned int ppk0, ppk1, ppk2, ppk3, ppk4, ppk5;
-    unsigned long int pnl,pnh;
-
-    int i, j;
-
-    pnl = wTSC15_0;
-    pnh = dwTSC47_16;
-
-    tsc0 = (unsigned int)((pnh >> 16) % 65536); /* msb */
-    tsc1 = (unsigned int)(pnh % 65536);
-    tsc2 = (unsigned int)(pnl % 65536); /* lsb */
-
-    /* Phase 1, step 1 */
-    p1k[0] = tsc1;
-    p1k[1] = tsc0;
-    p1k[2] = (unsigned int)(pbyTA[0] + (pbyTA[1]*256));
-    p1k[3] = (unsigned int)(pbyTA[2] + (pbyTA[3]*256));
-    p1k[4] = (unsigned int)(pbyTA[4] + (pbyTA[5]*256));
+	u32 p1k[5];
+	u32 tsc0, tsc1, tsc2;
+	u32 ppk0, ppk1, ppk2, ppk3, ppk4, ppk5;
+	u32 pnl, pnh;
+	int i, j;
+
+	pnl = (u32)wTSC15_0;
+	pnh = (u32)(dwTSC47_16 & 0xffffffff);
+
+	tsc0 = (u32)((pnh >> 16) % 65536); /* msb */
+	tsc1 = (u32)(pnh % 65536);
+	tsc2 = (u32)(pnl % 65536); /* lsb */
+
+	/* Phase 1, step 1 */
+	p1k[0] = tsc1;
+	p1k[1] = tsc0;
+	p1k[2] = (u32)(pbyTA[0] + (pbyTA[1]*256));
+	p1k[3] = (u32)(pbyTA[2] + (pbyTA[3]*256));
+	p1k[4] = (u32)(pbyTA[4] + (pbyTA[5]*256));
 
     /* Phase 1, step 2 */
     for (i=0; i<8; i++) {
-- 
1.8.0




