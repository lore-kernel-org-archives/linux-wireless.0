Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:60943 "EHLO aibo.runbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846AbbC2BIj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2015 21:08:39 -0400
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: joe@perches.com, gregkh@linuxfoundation.org,
	Jes.Sorensen@redhat.com, Larry.Finger@lwfinger.net,
	mail@beyermatthias.de, m.v.b@runbox.com
Subject: [PATCH v5 13/15] staging: rtl8723au: Rework two byte array comparisons
Date: Sat, 28 Mar 2015 21:07:56 -0400
Message-Id: <1427591278-982-14-git-send-email-m.v.b@runbox.com> (sfid-20150329_031131_340438_F10F358A)
In-Reply-To: <1427591278-982-1-git-send-email-m.v.b@runbox.com>
References: <1427591278-982-1-git-send-email-m.v.b@runbox.com>
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

Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>

---

v2: Correct code style issues and compare 32-bit integers instead of
    byte arrays. Update the commit message to better reflect the nature
    of the changes.
---
 drivers/staging/rtl8723au/core/rtw_security.c | 34 +++++++++++----------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
index bcb5ea68acbe..0ed048fcb36f 100644
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
@@ -243,16 +243,14 @@ void rtw_wep_decrypt23a(struct rtw_adapter *padapter,
 	arcfour_encrypt(&mycontext, payload, payload, length);
 
 	/* calculate icv and compare the icv */
-	*((u32 *)crc) = le32_to_cpu(getcrc32(payload, length - 4));
+	actual_crc = le32_to_cpu(getcrc32(payload, length - 4));
+	expected_crc = le32_to_cpu(get_unaligned_le32(&payload[length - 4]));
 
-	if (crc[3] != payload[length - 1] || crc[2] != payload[length - 2] ||
-	    crc[1] != payload[length - 3] || crc[0] != payload[length - 4]) {
+	if (actual_crc != expected_crc) {
 		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
-			 "rtw_wep_decrypt23a:icv error crc[3](%x)!= payload[length-1](%x) || crc[2](%x)!= payload[length-2](%x) || crc[1](%x)!= payload[length-3](%x) || crc[0](%x)!= payload[length-4](%x)\n",
-			 crc[3], payload[length - 1],
-			 crc[2], payload[length - 2],
-			 crc[1], payload[length - 3],
-			 crc[0], payload[length - 4]);
+			 "rtw_wep_decrypt23a:icv CRC mismatch: "
+			 "actual: %08x, expected: %08x\n",
+			 actual_crc, expected_crc);
 	}
 }
 
@@ -714,7 +712,7 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
 	u32 pnh;
 	u8 rc4key[16];
 	u8 ttkey[16];
-	u8 crc[4];
+	u32 actual_crc, expected_crc;
 	struct arc4context mycontext;
 	int length;
 	u32 prwskeylen;
@@ -771,18 +769,14 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
 	arcfour_init(&mycontext, rc4key, 16);
 	arcfour_encrypt(&mycontext, payload, payload, length);
 
-	*((u32 *)crc) = le32_to_cpu(getcrc32(payload, length - 4));
+	actual_crc = le32_to_cpu(getcrc32(payload, length - 4));
+	expected_crc = le32_to_cpu(get_unaligned_le32(&payload[length - 4]));
 
-	if (crc[3] != payload[length - 1] ||
-	    crc[2] != payload[length - 2] ||
-	    crc[1] != payload[length - 3] ||
-	    crc[0] != payload[length - 4]) {
+	if (actual_crc != expected_crc) {
 		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
-			 "rtw_wep_decrypt23a:icv error crc[3](%x)!= payload[length-1](%x) || crc[2](%x)!= payload[length-2](%x) || crc[1](%x)!= payload[length-3](%x) || crc[0](%x)!= payload[length-4](%x)\n",
-			 crc[3], payload[length - 1],
-			 crc[2], payload[length - 2],
-			 crc[1], payload[length - 3],
-			 crc[0], payload[length - 4]);
+			 "rtw_wep_decrypt23a:icv CRC mismatch: "
+			 "actual: %08x, expected: %08x\n",
+			 actual_crc, expected_crc);
 		res = _FAIL;
 	}
 
-- 
2.1.4

