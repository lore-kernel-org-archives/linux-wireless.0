Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:60900 "EHLO aibo.runbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610AbbC2BIV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2015 21:08:21 -0400
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: joe@perches.com, gregkh@linuxfoundation.org,
	Jes.Sorensen@redhat.com, Larry.Finger@lwfinger.net,
	mail@beyermatthias.de, m.v.b@runbox.com
Subject: [PATCH v5 03/15] staging: rtl8723au: else should follow close brace
Date: Sat, 28 Mar 2015 21:07:46 -0400
Message-Id: <1427591278-982-4-git-send-email-m.v.b@runbox.com> (sfid-20150329_031151_917153_5391E268)
In-Reply-To: <1427591278-982-1-git-send-email-m.v.b@runbox.com>
References: <1427591278-982-1-git-send-email-m.v.b@runbox.com>
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
index 572fcf3f936d..9faf78bf23d8 100644
--- a/drivers/staging/rtl8723au/core/rtw_security.c
+++ b/drivers/staging/rtl8723au/core/rtw_security.c
@@ -376,8 +376,7 @@ void rtw_seccalctkipmic23a(u8 *key, u8 *header, u8 *data, u32 data_len,
 			rtw_secmicappend23a(&micdata, &header[24], 6);
 		else
 			rtw_secmicappend23a(&micdata, &header[10], 6);
-	}
-	else{	/* ToDS == 0 */
+	} else {	/* ToDS == 0 */
 		rtw_secmicappend23a(&micdata, &header[4], 6);   /* DA */
 		if (header[1]&2)  /* From Ds == 1 */
 			rtw_secmicappend23a(&micdata, &header[16], 6);
@@ -678,8 +677,7 @@ int rtw_tkip_encrypt23a(struct rtw_adapter *padapter,
 					arcfour_encrypt(&mycontext, payload, payload, length);
 					arcfour_encrypt(&mycontext, payload + length, crc, 4);
 
-				}
-				else {
+				} else {
 					length = (pxmitpriv->frag_len -
 						  pattrib->hdrlen -
 						  pattrib->iv_len -
@@ -695,8 +693,7 @@ int rtw_tkip_encrypt23a(struct rtw_adapter *padapter,
 				}
 			}
 
-		}
-		else {
+		} else {
 			RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
 				 "rtw_tkip_encrypt23a: stainfo == NULL!!!\n");
 			DBG_8723A("%s, psta == NUL\n", __func__);
-- 
2.1.4

