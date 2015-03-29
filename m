Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:60882 "EHLO aibo.runbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbbC2BIU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2015 21:08:20 -0400
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: joe@perches.com, gregkh@linuxfoundation.org,
	Jes.Sorensen@redhat.com, Larry.Finger@lwfinger.net,
	mail@beyermatthias.de, m.v.b@runbox.com
Subject: [PATCH v5 06/15] staging: rtl8723au: else is not generally useful after a return
Date: Sat, 28 Mar 2015 21:07:49 -0400
Message-Id: <1427591278-982-7-git-send-email-m.v.b@runbox.com> (sfid-20150329_031202_771737_6353FE67)
In-Reply-To: <1427591278-982-1-git-send-email-m.v.b@runbox.com>
References: <1427591278-982-1-git-send-email-m.v.b@runbox.com>
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
index df7261c045fe..b85e5de5f136 100644
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

