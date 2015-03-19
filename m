Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:41534 "EHLO aibo.runbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbbCSEjs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2015 00:39:48 -0400
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: Jes.Sorensen@redhat.com, joe@perches.com,
	Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
	mail@beyermatthias.de, m.v.b@runbox.com
Subject: [PATCH v3 03/15] staging: rtl8723au: else should follow close brace
Date: Thu, 19 Mar 2015 00:39:06 -0400
Message-Id: <1426739958-18949-4-git-send-email-m.v.b@runbox.com> (sfid-20150319_054238_444755_3ECCA98C)
In-Reply-To: <1426739958-18949-1-git-send-email-m.v.b@runbox.com>
References: <1426739958-18949-1-git-send-email-m.v.b@runbox.com>
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
index cb78d6dd9c..17234e0bf1 100644
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

