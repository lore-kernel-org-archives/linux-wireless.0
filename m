Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:60961 "EHLO aibo.runbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbbC2BIl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2015 21:08:41 -0400
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: joe@perches.com, gregkh@linuxfoundation.org,
	Jes.Sorensen@redhat.com, Larry.Finger@lwfinger.net,
	mail@beyermatthias.de, m.v.b@runbox.com
Subject: [PATCH v5 14/15] staging: rtl8723au: Use __func__ in trace logs
Date: Sat, 28 Mar 2015 21:07:57 -0400
Message-Id: <1427591278-982-15-git-send-email-m.v.b@runbox.com> (sfid-20150329_031102_840434_A68C3377)
In-Reply-To: <1427591278-982-1-git-send-email-m.v.b@runbox.com>
References: <1427591278-982-1-git-send-email-m.v.b@runbox.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rework the trace log-related lines in rtl8723au's rtw_security.c
to use the __func__ GCC magic variable instead of hardcoding the
function names into the trace log strings. This also corrects a
copy-paste-related typo in the function named rtw_tkip_decrypt23a.

Thanks to Jes Sorensen for the suggestion to use __func__.

Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
---
 drivers/staging/rtl8723au/core/rtw_security.c | 41 ++++++++++++++-------------
 1 file changed, 22 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
index 0ed048fcb36f..5ef16bb30dc4 100644
--- a/drivers/staging/rtl8723au/core/rtw_security.c
+++ b/drivers/staging/rtl8723au/core/rtw_security.c
@@ -248,9 +248,9 @@ void rtw_wep_decrypt23a(struct rtw_adapter *padapter,
 
 	if (actual_crc != expected_crc) {
 		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
-			 "rtw_wep_decrypt23a:icv CRC mismatch: "
+			 "%s:icv CRC mismatch: "
 			 "actual: %08x, expected: %08x\n",
-			 actual_crc, expected_crc);
+			 __func__, actual_crc, expected_crc);
 	}
 }
 
@@ -635,13 +635,13 @@ int rtw_tkip_encrypt23a(struct rtw_adapter *padapter,
 
 	if (stainfo == NULL) {
 		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
-			 "rtw_tkip_encrypt23a: stainfo == NULL!!!\n");
+			 "%s: stainfo == NULL!!!\n", __func__);
 		DBG_8723A("%s, psta == NUL\n", __func__);
 		return _FAIL;
 	}
 
 	RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
-		 "rtw_tkip_encrypt23a: stainfo!= NULL!!!\n");
+		 "%s: stainfo!= NULL!!!\n", __func__);
 
 	if (!(stainfo->state & _FW_LINKED)) {
 		DBG_8723A("%s, psta->state(0x%x) != _FW_LINKED\n", __func__, stainfo->state);
@@ -733,7 +733,7 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
 				     &prxattrib->ta[0]);
 	if (stainfo == NULL) {
 		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
-			 "rtw_tkip_decrypt23a: stainfo == NULL!!!\n");
+			 "%s: stainfo == NULL!!!\n", __func__);
 		return _FAIL;
 	}
 
@@ -748,7 +748,7 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
 		prwskeylen = 16;
 	} else {
 		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
-			 "rtw_tkip_decrypt23a: stainfo!= NULL!!!\n");
+			 "%s: stainfo!= NULL!!!\n", __func__);
 		prwskey = &stainfo->dot118021x_UncstKey.skey[0];
 		prwskeylen = 16;
 	}
@@ -774,9 +774,9 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
 
 	if (actual_crc != expected_crc) {
 		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
-			 "rtw_wep_decrypt23a:icv CRC mismatch: "
+			 "%s:icv CRC mismatch: "
 			 "actual: %08x, expected: %08x\n",
-			 actual_crc, expected_crc);
+			 __func__, actual_crc, expected_crc);
 		res = _FAIL;
 	}
 
@@ -1313,7 +1313,7 @@ int rtw_aes_encrypt23a(struct rtw_adapter *padapter,
 
 	if (!stainfo) {
 		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
-			 "rtw_aes_encrypt23a: stainfo == NULL!!!\n");
+			 "%s: stainfo == NULL!!!\n", __func__);
 		DBG_8723A("%s, psta == NUL\n", __func__);
 		res = _FAIL;
 		goto out;
@@ -1324,7 +1324,7 @@ int rtw_aes_encrypt23a(struct rtw_adapter *padapter,
 		return _FAIL;
 	}
 	RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
-		 "rtw_aes_encrypt23a: stainfo!= NULL!!!\n");
+		 "%s: stainfo!= NULL!!!\n", __func__);
 
 	if (is_multicast_ether_addr(pattrib->ra))
 		prwskey = psecuritypriv->dot118021XGrpKey[psecuritypriv->dot118021XGrpKeyid].skey;
@@ -1552,11 +1552,14 @@ static int aes_decipher(u8 *key, uint hdrlen, u8 *pframe, uint plen)
 	for (i = 0; i < 8; i++) {
 		if (pframe[hdrlen + 8 + plen - 8 + i] != message[hdrlen + 8 + plen - 8 + i]) {
 			RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
-				 "aes_decipher:mic check error mic[%d]: pframe(%x) != message(%x)\n",
-				 i, pframe[hdrlen + 8 + plen - 8 + i],
+				 "%s:mic check error mic[%d]: pframe(%x) != message(%x)\n",
+				 __func__, i,
+				 pframe[hdrlen + 8 + plen - 8 + i],
 				 message[hdrlen + 8 + plen - 8 + i]);
-			DBG_8723A("aes_decipher:mic check error mic[%d]: pframe(%x) != message(%x)\n",
-				  i, pframe[hdrlen + 8 + plen - 8 + i], message[hdrlen + 8 + plen - 8 + i]);
+			DBG_8723A("%s:mic check error mic[%d]: pframe(%x) != message(%x)\n",
+				  __func__, i,
+				  pframe[hdrlen + 8 + plen - 8 + i],
+				  message[hdrlen + 8 + plen - 8 + i]);
 			res = _FAIL;
 		}
 	}
@@ -1582,13 +1585,13 @@ int rtw_aes_decrypt23a(struct rtw_adapter *padapter,
 	stainfo = rtw_get_stainfo23a(&padapter->stapriv, &prxattrib->ta[0]);
 	if (!stainfo) {
 		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
-			 "rtw_aes_encrypt23a: stainfo == NULL!!!\n");
+			 "%s: stainfo == NULL!!!\n", __func__);
 		res = _FAIL;
 		goto exit;
 	}
 
 	RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
-		 "rtw_aes_decrypt23a: stainfo!= NULL!!!\n");
+		 "%s: stainfo!= NULL!!!\n", __func__);
 
 	if (is_multicast_ether_addr(prxattrib->ra)) {
 		/* in concurrent we should use sw decrypt in
@@ -1624,9 +1627,9 @@ void rtw_use_tkipkey_handler23a(void *FunctionContext)
 	struct rtw_adapter *padapter = (struct rtw_adapter *)FunctionContext;
 
 	RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
-		 "^^^rtw_use_tkipkey_handler23a ^^^\n");
+		 "^^^%s ^^^\n", __func__);
 	padapter->securitypriv.busetkipkey = 1;
 	RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
-		 "^^^rtw_use_tkipkey_handler23a padapter->securitypriv.busetkipkey =%d^^^\n",
-		 padapter->securitypriv.busetkipkey);
+		 "^^^%s padapter->securitypriv.busetkipkey =%d^^^\n",
+		 __func__, padapter->securitypriv.busetkipkey);
 }
-- 
2.1.4

