Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:57444 "EHLO aibo.runbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbbC1Mx7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2015 08:53:59 -0400
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: gregkh@linuxfoundation.org, Jes.Sorensen@redhat.com,
	joe@perches.com, Larry.Finger@lwfinger.net, mail@beyermatthias.de,
	m.v.b@runbox.com
Subject: [PATCH v4 14/15] staging: rtl8723au: Use __func__ in trace logs
Date: Sat, 28 Mar 2015 08:52:47 -0400
Message-Id: <1427547168-12078-15-git-send-email-m.v.b@runbox.com> (sfid-20150328_135439_764145_688AF786)
In-Reply-To: <1427547168-12078-1-git-send-email-m.v.b@runbox.com>
References: <1427547168-12078-1-git-send-email-m.v.b@runbox.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rework the trace log-related lines in rtl8723au's rtw_security.c
to use the __func__ GCC magic variable instead of hardcoding the
function names into the trace log strings. This also corrects a
copy-paste-related typo in the function named rtw_tkip_decrypt23a.

Thanks to Jes Sorensen for the suggestion to use __func__.

Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
---
 drivers/staging/rtl8723au/core/rtw_security.c | 49 ++++++++++++++++-----------
 1 file changed, 30 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
index eb3544866a..cdb3707fb2 100644
--- a/drivers/staging/rtl8723au/core/rtw_security.c
+++ b/drivers/staging/rtl8723au/core/rtw_security.c
@@ -248,9 +248,9 @@ void rtw_wep_decrypt23a(struct rtw_adapter *padapter,
 
 	if (actual_crc != expected_crc) {
 		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
-			 ("rtw_wep_decrypt23a:icv CRC mismatch: "
+			 ("%s:icv CRC mismatch: "
 			  "actual: %08x, expected: %08x\n",
-			  actual_crc, expected_crc));
+			  __func__, actual_crc, expected_crc));
 	}
 }
 
@@ -634,7 +634,8 @@ int rtw_tkip_encrypt23a(struct rtw_adapter *padapter,
 	}
 
 	if (stainfo == NULL) {
-		RT_TRACE(_module_rtl871x_security_c_, _drv_err_, ("rtw_tkip_encrypt23a: stainfo == NULL!!!\n"));
+		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
+			 ("%s: stainfo == NULL!!!\n", __func__));
 		DBG_8723A("%s, psta == NUL\n", __func__);
 		return _FAIL;
 	}
@@ -644,7 +645,8 @@ int rtw_tkip_encrypt23a(struct rtw_adapter *padapter,
 		return _FAIL;
 	}
 
-	RT_TRACE(_module_rtl871x_security_c_, _drv_err_, ("rtw_tkip_encrypt23a: stainfo!= NULL!!!\n"));
+	RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
+		 ("%s: stainfo!= NULL!!!\n", __func__));
 
 	if (is_multicast_ether_addr(pattrib->ra))
 		prwskey = psecuritypriv->dot118021XGrpKey[psecuritypriv->dot118021XGrpKeyid].skey;
@@ -718,7 +720,8 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
 	stainfo = rtw_get_stainfo23a(&padapter->stapriv,
 				     &prxattrib->ta[0]);
 	if (stainfo == NULL) {
-		RT_TRACE(_module_rtl871x_security_c_, _drv_err_, ("rtw_tkip_decrypt23a: stainfo == NULL!!!\n"));
+		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
+			 ("%s: stainfo == NULL!!!\n", __func__));
 		return _FAIL;
 	}
 
@@ -731,7 +734,8 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
 		prwskey = psecuritypriv->dot118021XGrpKey[prxattrib->key_index].skey;
 		prwskeylen = 16;
 	} else {
-		RT_TRACE(_module_rtl871x_security_c_, _drv_err_, ("rtw_tkip_decrypt23a: stainfo!= NULL!!!\n"));
+		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
+			 ("%s: stainfo!= NULL!!!\n", __func__));
 		prwskey = &stainfo->dot118021x_UncstKey.skey[0];
 		prwskeylen = 16;
 	}
@@ -757,9 +761,9 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
 
 	if (actual_crc != expected_crc) {
 		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
-			 ("rtw_wep_decrypt23a:icv CRC mismatch: "
+			 ("%s:icv CRC mismatch: "
 			  "actual: %08x, expected: %08x\n",
-			  actual_crc, expected_crc));
+			  __func__, actual_crc, expected_crc));
 		res = _FAIL;
 	}
 
@@ -1296,7 +1300,7 @@ int rtw_aes_encrypt23a(struct rtw_adapter *padapter,
 
 	if (!stainfo) {
 		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
-			 ("rtw_aes_encrypt23a: stainfo == NULL!!!\n"));
+			 ("%s: stainfo == NULL!!!\n", __func__));
 		DBG_8723A("%s, psta == NUL\n", __func__);
 		res = _FAIL;
 		goto out;
@@ -1307,7 +1311,7 @@ int rtw_aes_encrypt23a(struct rtw_adapter *padapter,
 		return _FAIL;
 	}
 	RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
-		 ("rtw_aes_encrypt23a: stainfo!= NULL!!!\n"));
+		 ("%s: stainfo!= NULL!!!\n", __func__));
 
 	if (is_multicast_ether_addr(pattrib->ra))
 		prwskey = psecuritypriv->dot118021XGrpKey[psecuritypriv->dot118021XGrpKeyid].skey;
@@ -1535,10 +1539,16 @@ static int aes_decipher(u8 *key, uint hdrlen, u8 *pframe, uint plen)
 	for (i = 0; i < 8; i++) {
 		if (pframe[hdrlen + 8 + plen - 8 + i] != message[hdrlen + 8 + plen - 8 + i]) {
 			RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
-				 ("aes_decipher:mic check error mic[%d]: pframe(%x) != message(%x)\n",
-				 i, pframe[hdrlen + 8 + plen - 8 + i], message[hdrlen + 8 + plen - 8 + i]));
-			DBG_8723A("aes_decipher:mic check error mic[%d]: pframe(%x) != message(%x)\n",
-				  i, pframe[hdrlen + 8 + plen - 8 + i], message[hdrlen + 8 + plen - 8 + i]);
+				 ("%s:mic check error mic[%d]: "
+				  "pframe(%x) != message(%x)\n",
+				  __func__, i,
+				  pframe[hdrlen + 8 + plen - 8 + i],
+				  message[hdrlen + 8 + plen - 8 + i]));
+			DBG_8723A("%s:mic check error mic[%d]: "
+				  "pframe(%x) != message(%x)\n",
+				  __func__, i,
+				  pframe[hdrlen + 8 + plen - 8 + i],
+				  message[hdrlen + 8 + plen - 8 + i]);
 			res = _FAIL;
 		}
 	}
@@ -1564,13 +1574,13 @@ int rtw_aes_decrypt23a(struct rtw_adapter *padapter,
 	stainfo = rtw_get_stainfo23a(&padapter->stapriv, &prxattrib->ta[0]);
 	if (!stainfo) {
 		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
-			 ("rtw_aes_encrypt23a: stainfo == NULL!!!\n"));
+			 ("%s: stainfo == NULL!!!\n", __func__));
 		res = _FAIL;
 		goto exit;
 	}
 
 	RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
-		 ("rtw_aes_decrypt23a: stainfo!= NULL!!!\n"));
+		 ("%s: stainfo!= NULL!!!\n", __func__));
 
 	if (is_multicast_ether_addr(prxattrib->ra)) {
 		/* in concurrent we should use sw decrypt in
@@ -1605,9 +1615,10 @@ void rtw_use_tkipkey_handler23a(void *FunctionContext)
 {
 	struct rtw_adapter *padapter = (struct rtw_adapter *)FunctionContext;
 
-	RT_TRACE(_module_rtl871x_security_c_, _drv_err_, ("^^^rtw_use_tkipkey_handler23a ^^^\n"));
+	RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
+		 ("^^^%s^^^\n", __func__));
 	padapter->securitypriv.busetkipkey = 1;
 	RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
-		 ("^^^rtw_use_tkipkey_handler23a padapter->securitypriv.busetkipkey =%d^^^\n",
-		 padapter->securitypriv.busetkipkey));
+		 ("^^^%s padapter->securitypriv.busetkipkey =%d^^^\n",
+		  __func__, padapter->securitypriv.busetkipkey));
 }
-- 
2.1.4

