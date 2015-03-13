Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:36388 "EHLO aibo.runbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755195AbbCMDgp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 23:36:45 -0400
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: m.v.b@runbox.com
Subject: [PATCH 09/16] staging: rtl8723au: trailing statements should be on next line
Date: Thu, 12 Mar 2015 23:15:25 -0400
Message-Id: <1426216532-24058-10-git-send-email-m.v.b@runbox.com> (sfid-20150313_044146_678798_3A9668B3)
In-Reply-To: <1426216532-24058-1-git-send-email-m.v.b@runbox.com>
References: <1426216532-24058-1-git-send-email-m.v.b@runbox.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Correct a number of checkpatch.pl errors in rtl8723au's rtw_security.c
related to trailing statements:
	ERROR: trailing statements should be on next line

Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
---
 drivers/staging/rtl8723au/core/rtw_security.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
index 61f6c2896f..66ab3c4fdd 100644
--- a/drivers/staging/rtl8723au/core/rtw_security.c
+++ b/drivers/staging/rtl8723au/core/rtw_security.c
@@ -132,7 +132,8 @@ static u32 getcrc32(u8 *buf, int len)
 	u8 *p;
 	u32 crc;
 
-	if (bcrc32initialized == 0) crc32_init();
+	if (bcrc32initialized == 0)
+		crc32_init();
 
 	crc = 0xffffffff;       /* preload shift register, per CRC-32 spec */
 
@@ -559,8 +560,10 @@ static void phase2(u8 *rc4key, const u8 *tk, const u16 *p1k, u16 iv16)
 	u16 PPK[6];                          /* temporary key for mixing    */
 
 	/* Note: all adds in the PPK[] equations below are mod 2**16         */
-	for (i = 0; i < 5; i++) PPK[i] = p1k[i];    /* first, copy P1K to PPK      */
-		PPK[5] = p1k[4] + iv16;             /* next,  add in IV16          */
+	for (i = 0; i < 5; i++)
+		PPK[i] = p1k[i];    /* first, copy P1K to PPK      */
+
+	PPK[5] = p1k[4] + iv16;     /* next,  add in IV16          */
 
 	/* Bijective non-linear mixing of the 96 bits of PPK[0..5]           */
 	PPK[0] +=    _S_(PPK[5] ^ TK16(0));   /* Mix key in each "round"     */
@@ -960,7 +963,8 @@ static void aes128k128d(u8 *key, u8 *data, u8 *ciphertext)
 	u8 intermediateb[16];
 	u8 round_key[16];
 
-	for (i = 0; i < 16; i++) round_key[i] = key[i];
+	for (i = 0; i < 16; i++)
+		round_key[i] = key[i];
 
 	for (round = 0; round < 11; round++) {
 		if (round == 0) {
@@ -1044,7 +1048,8 @@ static void construct_mic_header2(u8 *mic_header2, u8 *mpdu, int a4_exists,
 {
 	int i;
 
-	for (i = 0; i < 16; i++) mic_header2[i] = 0x00;
+	for (i = 0; i < 16; i++)
+		mic_header2[i] = 0x00;
 
 	mic_header2[0] = mpdu[16];    /* A3 */
 	mic_header2[1] = mpdu[17];
@@ -1057,7 +1062,8 @@ static void construct_mic_header2(u8 *mic_header2, u8 *mpdu, int a4_exists,
 	mic_header2[7] = 0x00; /* mpdu[23]; */
 
 	if (!qc_exists && a4_exists) {
-		for (i = 0; i < 6; i++) mic_header2[8+i] = mpdu[24+i];   /* A4 */
+		for (i = 0; i < 6; i++)
+			mic_header2[8+i] = mpdu[24+i];   /* A4 */
 	}
 
 	if (qc_exists && !a4_exists) {
@@ -1066,7 +1072,8 @@ static void construct_mic_header2(u8 *mic_header2, u8 *mpdu, int a4_exists,
 	}
 
 	if (qc_exists && a4_exists) {
-		for (i = 0; i < 6; i++) mic_header2[8+i] = mpdu[24+i];   /* A4 */
+		for (i = 0; i < 6; i++)
+			mic_header2[8+i] = mpdu[24+i];   /* A4 */
 
 		mic_header2[14] = mpdu[30] & 0x0f;
 		mic_header2[15] = mpdu[31] & 0x00;
@@ -1084,7 +1091,9 @@ static void construct_ctr_preload(u8 *ctr_preload, int a4_exists, int qc_exists,
 {
 	int i = 0;
 
-	for (i = 0; i < 16; i++) ctr_preload[i] = 0x00;
+	for (i = 0; i < 16; i++)
+		ctr_preload[i] = 0x00;
+
 	i = 0;
 
 	ctr_preload[0] = 0x01;                                  /* flag */
-- 
2.1.4

