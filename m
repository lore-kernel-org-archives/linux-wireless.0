Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:36439 "EHLO aibo.runbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756568AbbCMDh1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 23:37:27 -0400
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: m.v.b@runbox.com
Subject: [PATCH 07/16] staging: rtl8723au: else is not generally useful after a return
Date: Thu, 12 Mar 2015 23:15:23 -0400
Message-Id: <1426216532-24058-8-git-send-email-m.v.b@runbox.com> (sfid-20150313_043746_348490_A6B98EB5)
In-Reply-To: <1426216532-24058-1-git-send-email-m.v.b@runbox.com>
References: <1426216532-24058-1-git-send-email-m.v.b@runbox.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Correct a checkpatch.pl warning regarding rtl8723au's
rtw_security.c::crc32_init pointing out that having an else statement
after a break or a return is not useful.

drivers/staging/rtl8723au/core/rtw_security.c:105:
	WARNING: else is not generally useful after a break or return

Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
---
 drivers/staging/rtl8723au/core/rtw_security.c | 42 ++++++++++++++-------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
index 3e812a67e2..6d2f037ba4 100644
--- a/drivers/staging/rtl8723au/core/rtw_security.c
+++ b/drivers/staging/rtl8723au/core/rtw_security.c
@@ -99,31 +99,33 @@ static u8 crc32_reverseBit(u8 data)
 
 static void crc32_init(void)
 {
+	int i, j;
+	u32 c;
+	u8 *p, *p1;
+	u8 k;
 
 	if (bcrc32initialized == 1)
 		return;
-	else{
-		int i, j;
-		u32 c;
-		u8 *p = (u8 *)&c, *p1;
-		u8 k;
-
-		c = 0x12340000;
-
-		for (i = 0; i < 256; ++i) {
-			k = crc32_reverseBit((u8)i);
-			for (c = ((u32)k) << 24, j = 8; j > 0; --j) {
-				c = c & 0x80000000 ? (c << 1) ^ CRC32_POLY : (c << 1);
-			}
-			p1 = (u8 *)&crc32_table[i];
-
-			p1[0] = crc32_reverseBit(p[3]);
-			p1[1] = crc32_reverseBit(p[2]);
-			p1[2] = crc32_reverseBit(p[1]);
-			p1[3] = crc32_reverseBit(p[0]);
+
+	p = (u8 *) &c;
+	c = 0x12340000;
+
+	for (i = 0; i < 256; ++i) {
+		k = crc32_reverseBit((u8)i);
+
+		for (c = ((u32)k) << 24, j = 8; j > 0; --j) {
+			c = c & 0x80000000 ? (c << 1) ^ CRC32_POLY : (c << 1);
 		}
-		bcrc32initialized = 1;
+
+		p1 = (u8 *)&crc32_table[i];
+
+		p1[0] = crc32_reverseBit(p[3]);
+		p1[1] = crc32_reverseBit(p[2]);
+		p1[2] = crc32_reverseBit(p[1]);
+		p1[3] = crc32_reverseBit(p[0]);
 	}
+
+	bcrc32initialized = 1;
 }
 
 static u32 getcrc32(u8 *buf, int len)
-- 
2.1.4

