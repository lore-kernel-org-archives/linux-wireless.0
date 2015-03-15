Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:44568 "EHLO aibo.runbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826AbbCOAPu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2015 20:15:50 -0400
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: joe@perches.com, Larry.Finger@lwfinger.net,
	gregkh@linuxfoundation.org, Jes.Sorensen@redhat.com,
	m.v.b@runbox.com
Subject: [PATCH v2 14/16] staging: rtl8723au: Rework two byte array comparisons
Date: Sat, 14 Mar 2015 20:10:39 -0400
Message-Id: <1426378241-32469-15-git-send-email-m.v.b@runbox.com> (sfid-20150315_011728_553929_1AA9333E)
In-Reply-To: <1426378241-32469-1-git-send-email-m.v.b@runbox.com>
References: <1426378241-32469-1-git-send-email-m.v.b@runbox.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prior to this commit, rtl8723au's rtw_security.c had two instances of
byte array comparisons (for CRC checks) where the individual elements
of the byte arrays were compared one by one and an error trace would
be output if the byte arrays were determined to be different.

This commit improves the readability of the CRC verification by
placing the individual 4 bytes of each byte array into an 32-bit
unsigned integer and comparing the two resulting integers.

Thanks to Larry Finger for spotting the code style issues in the
previous version of this commit, and thanks to Joe Perches for
suggesting the use of 32-bit integer comparisons instead of byte
array comparisons.

v2: Correct code style issues and compare 32-bit integers instead of
    byte arrays. Update the commit message to better reflect the nature
    of the changes.

Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
---
 drivers/staging/rtl8723au/core/rtw_security.c | 32 +++++++++++++--------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
index a9657e1425..eb3544866a 100644
--- a/drivers/staging/rtl8723au/core/rtw_security.c
+++ b/drivers/staging/rtl8723au/core/rtw_security.c
@@ -210,7 +210,7 @@ void rtw_wep_decrypt23a(struct rtw_adapter *padapter,
 		     struct recv_frame *precvframe)
 {
 	/*  exclude ICV */
-	u8 crc[4];
+	u32 actual_crc, expected_crc;
 	struct arc4context mycontext;
 	int length;
 	u32 keylength;
@@ -243,19 +243,14 @@ void rtw_wep_decrypt23a(struct rtw_adapter *padapter,
 	arcfour_encrypt(&mycontext, payload, payload, length);
 
 	/* calculate icv and compare the icv */
-	*((u32 *)crc) = le32_to_cpu(getcrc32(payload, length - 4));
+	actual_crc = le32_to_cpu(getcrc32(payload, length - 4));
+	expected_crc = le32_to_cpu(get_unaligned_le32(&payload[length - 4]));
 
-	if (crc[3] != payload[length - 1] || crc[2] != payload[length - 2] ||
-	    crc[1] != payload[length - 3] || crc[0] != payload[length - 4]) {
+	if (actual_crc != expected_crc) {
 		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
-			 ("rtw_wep_decrypt23a:icv error crc[3](%x)!= payload"
-			  "[length-1](%x) || crc[2](%x)!= payload[length-2](%x)"
-			  " || crc[1](%x)!= payload[length-3](%x) || crc[0](%x)"
-			  "!= payload[length-4](%x)\n",
-			  crc[3], payload[length - 1],
-			  crc[2], payload[length - 2],
-			  crc[1], payload[length - 3],
-			  crc[0], payload[length - 4]));
+			 ("rtw_wep_decrypt23a:icv CRC mismatch: "
+			  "actual: %08x, expected: %08x\n",
+			  actual_crc, expected_crc));
 	}
 }
 
@@ -702,7 +697,7 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
 	u32 pnh;
 	u8 rc4key[16];
 	u8 ttkey[16];
-	u8 crc[4];
+	u32 actual_crc, expected_crc;
 	struct arc4context mycontext;
 	int length;
 	u32 prwskeylen;
@@ -757,11 +752,14 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
 	arcfour_init(&mycontext, rc4key, 16);
 	arcfour_encrypt(&mycontext, payload, payload, length);
 
-	*((u32 *)crc) = le32_to_cpu(getcrc32(payload, length - 4));
+	actual_crc = le32_to_cpu(getcrc32(payload, length - 4));
+	expected_crc = le32_to_cpu(get_unaligned_le32(&payload[length - 4]));
 
-	if (crc[3] != payload[length - 1] || crc[2] != payload[length - 2] || crc[1] != payload[length - 3] || crc[0] != payload[length - 4]) {
-		RT_TRACE(_module_rtl871x_security_c_, _drv_err_, ("rtw_wep_decrypt23a:icv error crc[3](%x)!= payload[length-1](%x) || crc[2](%x)!= payload[length-2](%x) || crc[1](%x)!= payload[length-3](%x) || crc[0](%x)!= payload[length-4](%x)\n",
-				crc[3], payload[length - 1], crc[2], payload[length - 2], crc[1], payload[length - 3], crc[0], payload[length - 4]));
+	if (actual_crc != expected_crc) {
+		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
+			 ("rtw_wep_decrypt23a:icv CRC mismatch: "
+			  "actual: %08x, expected: %08x\n",
+			  actual_crc, expected_crc));
 		res = _FAIL;
 	}
 
-- 
2.1.4

