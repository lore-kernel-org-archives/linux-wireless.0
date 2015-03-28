Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:57354 "EHLO aibo.runbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397AbbC1Mxk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2015 08:53:40 -0400
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: gregkh@linuxfoundation.org, Jes.Sorensen@redhat.com,
	joe@perches.com, Larry.Finger@lwfinger.net, mail@beyermatthias.de,
	m.v.b@runbox.com
Subject: [PATCH v4 09/15] staging: rtl8723au: that open brace should be on the previous line
Date: Sat, 28 Mar 2015 08:52:42 -0400
Message-Id: <1427547168-12078-10-git-send-email-m.v.b@runbox.com> (sfid-20150328_135720_304389_F216F070)
In-Reply-To: <1427547168-12078-1-git-send-email-m.v.b@runbox.com>
References: <1427547168-12078-1-git-send-email-m.v.b@runbox.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Correct two instances of the checkpatch.pl error indicating that the
opening curly braces should not be on new lines:
	ERROR: that open brace { should be on the previous line

Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>

---

v3: Make sure that all edited lines are at most 80 characters wide.
---
 drivers/staging/rtl8723au/core/rtw_security.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
index 803f8965a4..0557a0df52 100644
--- a/drivers/staging/rtl8723au/core/rtw_security.c
+++ b/drivers/staging/rtl8723au/core/rtw_security.c
@@ -760,8 +760,8 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
 
 	*((u32 *)crc) = le32_to_cpu(getcrc32(payload, length - 4));
 
-	if (crc[3] != payload[length - 1] || crc[2] != payload[length - 2] || crc[1] != payload[length - 3] || crc[0] != payload[length - 4])
-	{
+	if (crc[3] != payload[length - 1] || crc[2] != payload[length - 2] ||
+	    crc[1] != payload[length - 3] || crc[0] != payload[length - 4]) {
 	    RT_TRACE(_module_rtl871x_security_c_, _drv_err_, ("rtw_wep_decrypt23a:icv error crc[3](%x)!= payload[length-1](%x) || crc[2](%x)!= payload[length-2](%x) || crc[1](%x)!= payload[length-3](%x) || crc[0](%x)!= payload[length-4](%x)\n",
 				crc[3], payload[length - 1], crc[2], payload[length - 2], crc[1], payload[length - 3], crc[0], payload[length - 4]));
 		res = _FAIL;
@@ -845,8 +845,7 @@ static void next_key(u8 *key, int round)
 {
 	u8 rcon;
 	u8 sbox_key[4];
-	u8 rcon_table[12] =
-	{
+	u8 rcon_table[12] = {
 		0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80,
 		0x1b, 0x36, 0x36, 0x36
 	};
-- 
2.1.4

