Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:44492 "EHLO aibo.runbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbbCOAPT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2015 20:15:19 -0400
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: joe@perches.com, Larry.Finger@lwfinger.net,
	gregkh@linuxfoundation.org, Jes.Sorensen@redhat.com,
	m.v.b@runbox.com
Subject: [PATCH v2 03/16] staging: rtl8723au: else should follow close brace
Date: Sat, 14 Mar 2015 20:10:28 -0400
Message-Id: <1426378241-32469-4-git-send-email-m.v.b@runbox.com> (sfid-20150315_011544_507741_3AF0662C)
In-Reply-To: <1426378241-32469-1-git-send-email-m.v.b@runbox.com>
References: <1426378241-32469-1-git-send-email-m.v.b@runbox.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Correct checkpatch.pl errors in rtl8723au's rtw_security.c indicating
that an else statement should follow the closing brace of the previous
if/else if code block:
	ERROR: else should follow close brace '}'

Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
---
 drivers/staging/rtl8723au/core/rtw_security.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
index 0306c3896a..d04a1cf6d7 100644
--- a/drivers/staging/rtl8723au/core/rtw_security.c
+++ b/drivers/staging/rtl8723au/core/rtw_security.c
@@ -379,8 +379,7 @@ void rtw_seccalctkipmic23a(u8 *key, u8 *header, u8 *data, u32 data_len,
 			rtw_secmicappend23a(&micdata, &header[24], 6);
 		else
 			rtw_secmicappend23a(&micdata, &header[10], 6);
-	}
-	else{	/* ToDS == 0 */
+	} else {	/* ToDS == 0 */
 		rtw_secmicappend23a(&micdata, &header[4], 6);   /* DA */
 		if (header[1]&2)  /* From Ds == 1 */
 			rtw_secmicappend23a(&micdata, &header[16], 6);
@@ -673,8 +672,7 @@ int rtw_tkip_encrypt23a(struct rtw_adapter *padapter,
 					arcfour_encrypt(&mycontext, payload, payload, length);
 					arcfour_encrypt(&mycontext, payload+length, crc, 4);
 
-				}
-				else {
+				} else {
 					length = pxmitpriv->frag_len-pattrib->hdrlen-pattrib->iv_len-pattrib->icv_len;
 					*((u32 *)crc) = cpu_to_le32(getcrc32(payload, length));/* modified by Amy*/
 					arcfour_init(&mycontext, rc4key, 16);
@@ -686,8 +684,7 @@ int rtw_tkip_encrypt23a(struct rtw_adapter *padapter,
 				}
 			}
 
-		}
-		else {
+		} else {
 			RT_TRACE(_module_rtl871x_security_c_, _drv_err_, ("rtw_tkip_encrypt23a: stainfo == NULL!!!\n"));
 			DBG_8723A("%s, psta == NUL\n", __func__);
 			res = _FAIL;
-- 
2.1.4

