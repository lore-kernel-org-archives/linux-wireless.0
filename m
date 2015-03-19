Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:41579 "EHLO aibo.runbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290AbbCSEjz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2015 00:39:55 -0400
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: Jes.Sorensen@redhat.com, joe@perches.com,
	Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
	mail@beyermatthias.de, m.v.b@runbox.com
Subject: [PATCH v3 12/15] staging: rtl8723au: suspect code indent for conditional statements
Date: Thu, 19 Mar 2015 00:39:15 -0400
Message-Id: <1426739958-18949-13-git-send-email-m.v.b@runbox.com> (sfid-20150319_054159_526348_16B4E9B7)
In-Reply-To: <1426739958-18949-1-git-send-email-m.v.b@runbox.com>
References: <1426739958-18949-1-git-send-email-m.v.b@runbox.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Correct a number of indentation-with-spaces-and-tabs issues in
rtl8723au's rtw_security.c, according to checkpatch.pl:
	WARNING: suspect code indent for conditional statements

v3: Make sure that all edited lines are at most 80 characters wide.

Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
---
 drivers/staging/rtl8723au/core/rtw_security.c | 46 ++++++++++++++++-----------
 1 file changed, 27 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
index 8591b49664..4330479ee0 100644
--- a/drivers/staging/rtl8723au/core/rtw_security.c
+++ b/drivers/staging/rtl8723au/core/rtw_security.c
@@ -761,8 +761,16 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
 
 	if (crc[3] != payload[length - 1] || crc[2] != payload[length - 2] ||
 	    crc[1] != payload[length - 3] || crc[0] != payload[length - 4]) {
-	    RT_TRACE(_module_rtl871x_security_c_, _drv_err_, ("rtw_wep_decrypt23a:icv error crc[3](%x)!= payload[length-1](%x) || crc[2](%x)!= payload[length-2](%x) || crc[1](%x)!= payload[length-3](%x) || crc[0](%x)!= payload[length-4](%x)\n",
-				crc[3], payload[length - 1], crc[2], payload[length - 2], crc[1], payload[length - 3], crc[0], payload[length - 4]));
+		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
+			 ("rtw_wep_decrypt23a:icv error "
+			  "crc[3](%x)!= payload[length-1](%x) || "
+			  "crc[2](%x)!= payload[length-2](%x) || "
+			  "crc[1](%x)!= payload[length-3](%x) || "
+			  "crc[0](%x)!= payload[length-4](%x)\n",
+			  crc[3], payload[length - 1],
+			  crc[2], payload[length - 2],
+			  crc[1], payload[length - 3],
+			  crc[0], payload[length - 4]));
 		res = _FAIL;
 	}
 
@@ -909,9 +917,9 @@ static void mix_column(u8 *in, u8 *out)
 
 	for (i = 0; i < 4; i++) {
 		if ((in[i] & 0x80) == 0x80)
-		    add1b[i] = 0x1b;
+			add1b[i] = 0x1b;
 		else
-		    add1b[i] = 0x00;
+			add1b[i] = 0x00;
 	}
 
 	swap_halfs[0] = in[2]; /* Swap halfs */
@@ -966,21 +974,21 @@ static void aes128k128d(u8 *key, u8 *data, u8 *ciphertext)
 
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
 
@@ -1481,7 +1489,7 @@ static int aes_decipher(u8 *key, uint hdrlen, u8 *pframe, uint plen)
 		for (j = 0; j < 16; j++)
 			padded_buffer[j] = 0x00;
 		for (j = 0; j < payload_remainder; j++)
-		    padded_buffer[j] = message[payload_index++];
+			padded_buffer[j] = message[payload_index++];
 		bitwise_xor(aes_out, padded_buffer, chain_buffer);
 		aes128k128d(key, chain_buffer, aes_out);
 	}
@@ -1511,7 +1519,7 @@ static int aes_decipher(u8 *key, uint hdrlen, u8 *pframe, uint plen)
 				      message, pn_vector, num_blocks+1);
 
 		for (j = 0; j < 16; j++)
-			 padded_buffer[j] = 0x00;
+			padded_buffer[j] = 0x00;
 		for (j = 0; j < payload_remainder; j++)
 			padded_buffer[j] = message[payload_index + j];
 		aes128k128d(key, ctr_preload, aes_out);
-- 
2.1.4

