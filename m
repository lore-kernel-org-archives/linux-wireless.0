Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:36405 "EHLO aibo.runbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756274AbbCMDg6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 23:36:58 -0400
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: m.v.b@runbox.com
Subject: [PATCH 13/16] staging: rtl8723au: suspect code indent for conditional statements
Date: Thu, 12 Mar 2015 23:15:29 -0400
Message-Id: <1426216532-24058-14-git-send-email-m.v.b@runbox.com> (sfid-20150313_043720_920457_A87C8C13)
In-Reply-To: <1426216532-24058-1-git-send-email-m.v.b@runbox.com>
References: <1426216532-24058-1-git-send-email-m.v.b@runbox.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Correct a number of indentation-with-spaces-and-tabs issues in
rtl8723au's rtw_security.c, according to checkpatch.pl:
	WARNING: suspect code indent for conditional statements

Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
---
 drivers/staging/rtl8723au/core/rtw_security.c | 36 +++++++++++++--------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
index fd5c4da2c4..dbbe7b348d 100644
--- a/drivers/staging/rtl8723au/core/rtw_security.c
+++ b/drivers/staging/rtl8723au/core/rtw_security.c
@@ -760,7 +760,7 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
 	*((u32 *)crc) = le32_to_cpu(getcrc32(payload, length-4));
 
 	if (crc[3] != payload[length - 1] || crc[2] != payload[length - 2] || crc[1] != payload[length - 3] || crc[0] != payload[length - 4]) {
-	    RT_TRACE(_module_rtl871x_security_c_, _drv_err_, ("rtw_wep_decrypt23a:icv error crc[3](%x)!= payload[length-1](%x) || crc[2](%x)!= payload[length-2](%x) || crc[1](%x)!= payload[length-3](%x) || crc[0](%x)!= payload[length-4](%x)\n",
+		RT_TRACE(_module_rtl871x_security_c_, _drv_err_, ("rtw_wep_decrypt23a:icv error crc[3](%x)!= payload[length-1](%x) || crc[2](%x)!= payload[length-2](%x) || crc[1](%x)!= payload[length-3](%x) || crc[0](%x)!= payload[length-4](%x)\n",
 				crc[3], payload[length - 1], crc[2], payload[length - 2], crc[1], payload[length - 3], crc[0], payload[length - 4]));
 		res = _FAIL;
 	}
@@ -908,9 +908,9 @@ static void mix_column(u8 *in, u8 *out)
 
 	for (i = 0; i < 4; i++) {
 		if ((in[i] & 0x80) == 0x80)
-		    add1b[i] = 0x1b;
+			add1b[i] = 0x1b;
 		else
-		    add1b[i] = 0x00;
+			add1b[i] = 0x00;
 	}
 
 	swap_halfs[0] = in[2]; /* Swap halfs */
@@ -965,21 +965,21 @@ static void aes128k128d(u8 *key, u8 *data, u8 *ciphertext)
 
 	for (round = 0; round < 11; round++) {
 		if (round == 0) {
-		    xor_128(round_key, data, ciphertext);
-		    next_key(round_key, round);
+			xor_128(round_key, data, ciphertext);
+			next_key(round_key, round);
 		} else if (round == 10) {
-		    byte_sub(ciphertext, intermediatea);
-		    shift_row(intermediatea, intermediateb);
-		    xor_128(intermediateb, round_key, ciphertext);
+			byte_sub(ciphertext, intermediatea);
+			shift_row(intermediatea, intermediateb);
+			xor_128(intermediateb, round_key, ciphertext);
 		} else { /* 1 - 9 */
-		    byte_sub(ciphertext, intermediatea);
-		    shift_row(intermediatea, intermediateb);
-		    mix_column(&intermediateb[0], &intermediatea[0]);
-		    mix_column(&intermediateb[4], &intermediatea[4]);
-		    mix_column(&intermediateb[8], &intermediatea[8]);
-		    mix_column(&intermediateb[12], &intermediatea[12]);
-		    xor_128(intermediatea, round_key, ciphertext);
-		    next_key(round_key, round);
+			byte_sub(ciphertext, intermediatea);
+			shift_row(intermediatea, intermediateb);
+			mix_column(&intermediateb[0], &intermediatea[0]);
+			mix_column(&intermediateb[4], &intermediatea[4]);
+			mix_column(&intermediateb[8], &intermediatea[8]);
+			mix_column(&intermediateb[12], &intermediatea[12]);
+			xor_128(intermediatea, round_key, ciphertext);
+			next_key(round_key, round);
 		}
 	}
 
@@ -1480,7 +1480,7 @@ static int aes_decipher(u8 *key, uint hdrlen, u8 *pframe, uint plen)
 		for (j = 0; j < 16; j++)
 			padded_buffer[j] = 0x00;
 		for (j = 0; j < payload_remainder; j++)
-		    padded_buffer[j] = message[payload_index++];
+			padded_buffer[j] = message[payload_index++];
 		bitwise_xor(aes_out, padded_buffer, chain_buffer);
 		aes128k128d(key, chain_buffer, aes_out);
 	}
@@ -1510,7 +1510,7 @@ static int aes_decipher(u8 *key, uint hdrlen, u8 *pframe, uint plen)
 				      message, pn_vector, num_blocks+1);
 
 		for (j = 0; j < 16; j++)
-			 padded_buffer[j] = 0x00;
+			padded_buffer[j] = 0x00;
 		for (j = 0; j < payload_remainder; j++)
 			padded_buffer[j] = message[payload_index + j];
 		aes128k128d(key, ctr_preload, aes_out);
-- 
2.1.4

