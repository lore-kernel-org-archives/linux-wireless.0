Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:44515 "EHLO aibo.runbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997AbbCOAPW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2015 20:15:22 -0400
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: joe@perches.com, Larry.Finger@lwfinger.net,
	gregkh@linuxfoundation.org, Jes.Sorensen@redhat.com,
	m.v.b@runbox.com
Subject: [PATCH v2 08/16] staging: rtl8723au: Remove unneeded curly braces
Date: Sat, 14 Mar 2015 20:10:33 -0400
Message-Id: <1426378241-32469-9-git-send-email-m.v.b@runbox.com> (sfid-20150315_011902_312712_D7E46204)
In-Reply-To: <1426378241-32469-1-git-send-email-m.v.b@runbox.com>
References: <1426378241-32469-1-git-send-email-m.v.b@runbox.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Correct a number of checkpatch.pl warnings in rtl8723au's rtw_security.c
related to the existence of unnecessary curly braces around single
statement blocks:
	WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
---
 drivers/staging/rtl8723au/core/rtw_security.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
index f7571cf091..b4327aaf71 100644
--- a/drivers/staging/rtl8723au/core/rtw_security.c
+++ b/drivers/staging/rtl8723au/core/rtw_security.c
@@ -113,9 +113,8 @@ static void crc32_init(void)
 	for (i = 0; i < 256; ++i) {
 		k = crc32_reverseBit((u8)i);
 
-		for (c = ((u32)k) << 24, j = 8; j > 0; --j) {
+		for (c = ((u32)k) << 24, j = 8; j > 0; --j)
 			c = c & 0x80000000 ? (c << 1) ^ CRC32_POLY : (c << 1);
-		}
 
 		p1 = (u8 *)&crc32_table[i];
 
@@ -267,9 +266,8 @@ static u32 secmicgetuint32(u8 *p)
 	s32 i;
 	u32 res = 0;
 
-	for (i = 0; i < 4; i++) {
+	for (i = 0; i < 4; i++)
 		res |= ((u32)(*p++)) << (8 * i);
-	}
 
 	return res;
 }
@@ -353,9 +351,8 @@ void rtw_secgetmic23a(struct mic_data *pmicdata, u8 *dst)
 	rtw_secmicappend23abyte23a(pmicdata, 0);
 	rtw_secmicappend23abyte23a(pmicdata, 0);
 	/*  and then zeroes until the length is a multiple of 4 */
-	while (pmicdata->nBytesInM != 0) {
+	while (pmicdata->nBytesInM != 0)
 		rtw_secmicappend23abyte23a(pmicdata, 0);
-	}
 	/*  The appendByte function has already computed the result. */
 	secmicputuint32(dst, pmicdata->L);
 	secmicputuint32(dst + 4, pmicdata->R);
@@ -871,10 +868,8 @@ static void byte_sub(u8 *in, u8 *out)
 {
 	int i;
 
-	for (i = 0; i < 16; i++) {
+	for (i = 0; i < 16; i++)
 		out[i] = sbox(in[i]);
-	}
-
 }
 
 static void shift_row(u8 *in, u8 *out)
@@ -935,9 +930,8 @@ static void mix_column(u8 *in, u8 *out)
 
 	for (i = 3; i > 0; i--) { /* logical shift left 1 bit */
 		andf7[i] = andf7[i] << 1;
-		if ((andf7[i - 1] & 0x80) == 0x80) {
+		if ((andf7[i - 1] & 0x80) == 0x80)
 			andf7[i] = (andf7[i] | 0x01);
-		}
 	}
 	andf7[0] = andf7[0] << 1;
 	andf7[0] = andf7[0] & 0xfe;
-- 
2.1.4

