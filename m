Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:60976 "EHLO aibo.runbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866AbbC2BIm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2015 21:08:42 -0400
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: joe@perches.com, gregkh@linuxfoundation.org,
	Jes.Sorensen@redhat.com, Larry.Finger@lwfinger.net,
	mail@beyermatthias.de, m.v.b@runbox.com
Subject: [PATCH v5 12/15] staging: rtl8723au: suspect code indent for conditional statements
Date: Sat, 28 Mar 2015 21:07:55 -0400
Message-Id: <1427591278-982-13-git-send-email-m.v.b@runbox.com> (sfid-20150329_030953_980760_11D6698D)
In-Reply-To: <1427591278-982-1-git-send-email-m.v.b@runbox.com>
References: <1427591278-982-1-git-send-email-m.v.b@runbox.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Correct a number of indentation-with-spaces-and-tabs issues in
rtl8723au's rtw_security.c, according to checkpatch.pl:
	WARNING: suspect code indent for conditional statements

Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>

---

v3: Make sure that all edited lines are at most 80 characters wide.
---
 drivers/staging/rtl8723au/core/rtw_security.c | 34 +++++++++++++--------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
index 8e0e9fa0efdc..bcb5ea68acbe 100644
--- a/drivers/staging/rtl8723au/core/rtw_security.c
+++ b/drivers/staging/rtl8723au/core/rtw_security.c
@@ -929,9 +929,9 @@ static void mix_column(u8 *in, u8 *out)
 
 	for (i = 0; i < 4; i++) {
 		if ((in[i] & 0x80) == 0x80)
-		    add1b[i] = 0x1b;
+			add1b[i] = 0x1b;
 		else
-		    add1b[i] = 0x00;
+			add1b[i] = 0x00;
 	}
 
 	swap_halfs[0] = in[2]; /* Swap halfs */
@@ -986,21 +986,21 @@ static void aes128k128d(u8 *key, u8 *data, u8 *ciphertext)
 
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
 
@@ -1501,7 +1501,7 @@ static int aes_decipher(u8 *key, uint hdrlen, u8 *pframe, uint plen)
 		for (j = 0; j < 16; j++)
 			padded_buffer[j] = 0x00;
 		for (j = 0; j < payload_remainder; j++)
-		    padded_buffer[j] = message[payload_index++];
+			padded_buffer[j] = message[payload_index++];
 		bitwise_xor(aes_out, padded_buffer, chain_buffer);
 		aes128k128d(key, chain_buffer, aes_out);
 	}
@@ -1531,7 +1531,7 @@ static int aes_decipher(u8 *key, uint hdrlen, u8 *pframe, uint plen)
 				      message, pn_vector, num_blocks + 1);
 
 		for (j = 0; j < 16; j++)
-			 padded_buffer[j] = 0x00;
+			padded_buffer[j] = 0x00;
 		for (j = 0; j < payload_remainder; j++)
 			padded_buffer[j] = message[payload_index + j];
 		aes128k128d(key, ctr_preload, aes_out);
-- 
2.1.4

