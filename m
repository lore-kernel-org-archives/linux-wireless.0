Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:57357 "EHLO aibo.runbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398AbbC1Mxk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2015 08:53:40 -0400
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: gregkh@linuxfoundation.org, Jes.Sorensen@redhat.com,
	joe@perches.com, Larry.Finger@lwfinger.net, mail@beyermatthias.de,
	m.v.b@runbox.com
Subject: [PATCH v4 05/15] staging: rtl8723au: Reorganize a few functions to remove indentation
Date: Sat, 28 Mar 2015 08:52:38 -0400
Message-Id: <1427547168-12078-6-git-send-email-m.v.b@runbox.com> (sfid-20150328_135729_075884_D3D5D1E1)
In-Reply-To: <1427547168-12078-1-git-send-email-m.v.b@runbox.com>
References: <1427547168-12078-1-git-send-email-m.v.b@runbox.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prior to this commit, functions rtw_tkip_encrypt23a and rtw_tkip_decrypt23a had
large if blocks which contained the majority of the logic in the functions.

Rework these functions so that if the negated version of the aforementioned if
blocks' conditions are true, we return from the function with _FAIL, as
expected by the calling code.

This lets us remove two levels of indentation from the functions in
question, making them more readable.

Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
---
 drivers/staging/rtl8723au/core/rtw_security.c | 178 +++++++++++++-------------
 1 file changed, 88 insertions(+), 90 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
index df1787f20e..f7b1d45981 100644
--- a/drivers/staging/rtl8723au/core/rtw_security.c
+++ b/drivers/staging/rtl8723au/core/rtw_security.c
@@ -618,6 +618,9 @@ int rtw_tkip_encrypt23a(struct rtw_adapter *padapter,
 	struct xmit_priv *pxmitpriv = &padapter->xmitpriv;
 	int res = _SUCCESS;
 
+	if (pattrib->encrypt != WLAN_CIPHER_SUITE_TKIP)
+		return _FAIL;
+
 	if (!pxmitframe->buf_addr)
 		return _FAIL;
 
@@ -625,71 +628,66 @@ int rtw_tkip_encrypt23a(struct rtw_adapter *padapter,
 
 	pframe = pxmitframe->buf_addr + hw_hdr_offset;
 	/* 4 start to encrypt each fragment */
-	if (pattrib->encrypt == WLAN_CIPHER_SUITE_TKIP) {
-		if (pattrib->psta)
-			stainfo = pattrib->psta;
-		else {
-			DBG_8723A("%s, call rtw_get_stainfo()\n", __func__);
-			stainfo = rtw_get_stainfo23a(&padapter->stapriv,
-						     &pattrib->ra[0]);
-		}
-
-		if (stainfo != NULL) {
-
-			if (!(stainfo->state & _FW_LINKED)) {
-				DBG_8723A("%s, psta->state(0x%x) != _FW_LINKED\n", __func__, stainfo->state);
-				return _FAIL;
-			}
+	if (pattrib->psta)
+		stainfo = pattrib->psta;
+	else {
+		DBG_8723A("%s, call rtw_get_stainfo()\n", __func__);
+		stainfo = rtw_get_stainfo23a(&padapter->stapriv,
+					     &pattrib->ra[0]);
+	}
 
-			RT_TRACE(_module_rtl871x_security_c_, _drv_err_, ("rtw_tkip_encrypt23a: stainfo!= NULL!!!\n"));
+	if (stainfo == NULL) {
+		RT_TRACE(_module_rtl871x_security_c_, _drv_err_, ("rtw_tkip_encrypt23a: stainfo == NULL!!!\n"));
+		DBG_8723A("%s, psta == NUL\n", __func__);
+		return _FAIL;
+	}
 
-			if (is_multicast_ether_addr(pattrib->ra))
-				prwskey = psecuritypriv->dot118021XGrpKey[psecuritypriv->dot118021XGrpKeyid].skey;
-			else
-				prwskey = &stainfo->dot118021x_UncstKey.skey[0];
+	if (!(stainfo->state & _FW_LINKED)) {
+		DBG_8723A("%s, psta->state(0x%x) != _FW_LINKED\n", __func__, stainfo->state);
+		return _FAIL;
+	}
 
-			prwskeylen = 16;
+	RT_TRACE(_module_rtl871x_security_c_, _drv_err_, ("rtw_tkip_encrypt23a: stainfo!= NULL!!!\n"));
 
-			for (curfragnum = 0; curfragnum < pattrib->nr_frags; curfragnum++) {
-				iv = pframe+pattrib->hdrlen;
-				payload = pframe+pattrib->iv_len+pattrib->hdrlen;
+	if (is_multicast_ether_addr(pattrib->ra))
+		prwskey = psecuritypriv->dot118021XGrpKey[psecuritypriv->dot118021XGrpKeyid].skey;
+	else
+		prwskey = &stainfo->dot118021x_UncstKey.skey[0];
 
-				GET_TKIP_PN(iv, dot11txpn);
+	prwskeylen = 16;
 
-				pnl = (u16)(dot11txpn.val);
-				pnh = (u32)(dot11txpn.val>>16);
+	for (curfragnum = 0; curfragnum < pattrib->nr_frags; curfragnum++) {
+		iv = pframe+pattrib->hdrlen;
+		payload = pframe+pattrib->iv_len+pattrib->hdrlen;
 
-				phase1((u16 *)&ttkey[0], prwskey, &pattrib->ta[0], pnh);
+		GET_TKIP_PN(iv, dot11txpn);
 
-				phase2(&rc4key[0], prwskey, (u16 *)&ttkey[0], pnl);
+		pnl = (u16)(dot11txpn.val);
+		pnh = (u32)(dot11txpn.val>>16);
 
-				if ((curfragnum + 1) == pattrib->nr_frags) {	/* 4 the last fragment */
-					length = pattrib->last_txcmdsz-pattrib->hdrlen-pattrib->iv_len - pattrib->icv_len;
-					RT_TRACE(_module_rtl871x_security_c_, _drv_info_, ("pattrib->iv_len =%x, pattrib->icv_len =%x\n", pattrib->iv_len, pattrib->icv_len));
-					*((u32 *)crc) = cpu_to_le32(getcrc32(payload, length));/* modified by Amy*/
+		phase1((u16 *)&ttkey[0], prwskey, &pattrib->ta[0], pnh);
 
-					arcfour_init(&mycontext, rc4key, 16);
-					arcfour_encrypt(&mycontext, payload, payload, length);
-					arcfour_encrypt(&mycontext, payload+length, crc, 4);
+		phase2(&rc4key[0], prwskey, (u16 *)&ttkey[0], pnl);
 
-				} else {
-					length = pxmitpriv->frag_len-pattrib->hdrlen-pattrib->iv_len-pattrib->icv_len;
-					*((u32 *)crc) = cpu_to_le32(getcrc32(payload, length));/* modified by Amy*/
-					arcfour_init(&mycontext, rc4key, 16);
-					arcfour_encrypt(&mycontext, payload, payload, length);
-					arcfour_encrypt(&mycontext, payload+length, crc, 4);
+		if ((curfragnum+1) == pattrib->nr_frags) {	/* 4 the last fragment */
+			length = pattrib->last_txcmdsz-pattrib->hdrlen-pattrib->iv_len - pattrib->icv_len;
+			RT_TRACE(_module_rtl871x_security_c_, _drv_info_, ("pattrib->iv_len =%x, pattrib->icv_len =%x\n", pattrib->iv_len, pattrib->icv_len));
+			*((u32 *)crc) = cpu_to_le32(getcrc32(payload, length));/* modified by Amy*/
 
-					pframe += pxmitpriv->frag_len;
-					pframe  = PTR_ALIGN(pframe, 4);
-				}
-			}
+			arcfour_init(&mycontext, rc4key, 16);
+			arcfour_encrypt(&mycontext, payload, payload, length);
+			arcfour_encrypt(&mycontext, payload+length, crc, 4);
 
 		} else {
-			RT_TRACE(_module_rtl871x_security_c_, _drv_err_, ("rtw_tkip_encrypt23a: stainfo == NULL!!!\n"));
-			DBG_8723A("%s, psta == NUL\n", __func__);
-			res = _FAIL;
-		}
+			length = pxmitpriv->frag_len-pattrib->hdrlen-pattrib->iv_len-pattrib->icv_len;
+			*((u32 *)crc) = cpu_to_le32(getcrc32(payload, length));/* modified by Amy*/
+			arcfour_init(&mycontext, rc4key, 16);
+			arcfour_encrypt(&mycontext, payload, payload, length);
+			arcfour_encrypt(&mycontext, payload+length, crc, 4);
 
+			pframe += pxmitpriv->frag_len;
+			pframe  = PTR_ALIGN(pframe, 4);
+		}
 	}
 
 	return res;
@@ -715,58 +713,58 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
 	struct sk_buff *skb = precvframe->pkt;
 	int res = _SUCCESS;
 
+	if (prxattrib->encrypt != WLAN_CIPHER_SUITE_TKIP)
+		return _FAIL;
+
 	pframe = skb->data;
 
 	/* 4 start to decrypt recvframe */
-	if (prxattrib->encrypt == WLAN_CIPHER_SUITE_TKIP) {
+	stainfo = rtw_get_stainfo23a(&padapter->stapriv,
+				     &prxattrib->ta[0]);
+	if (stainfo == NULL) {
+		RT_TRACE(_module_rtl871x_security_c_, _drv_err_, ("rtw_tkip_decrypt23a: stainfo == NULL!!!\n"));
+		return _FAIL;
+	}
 
-		stainfo = rtw_get_stainfo23a(&padapter->stapriv,
-					     &prxattrib->ta[0]);
-		if (stainfo!= NULL) {
-
-			if (is_multicast_ether_addr(prxattrib->ra)) {
-				if (psecuritypriv->binstallGrpkey == 0) {
-					res = _FAIL;
-					DBG_8723A("%s:rx bc/mc packets, but didn't install group key!!!!!!!!!!\n", __func__);
-					goto exit;
-				}
-				prwskey = psecuritypriv->dot118021XGrpKey[prxattrib->key_index].skey;
-				prwskeylen = 16;
-			} else {
-			        RT_TRACE(_module_rtl871x_security_c_, _drv_err_, ("rtw_tkip_decrypt23a: stainfo!= NULL!!!\n"));
-				prwskey = &stainfo->dot118021x_UncstKey.skey[0];
-				prwskeylen = 16;
-			}
+	if (is_multicast_ether_addr(prxattrib->ra)) {
+		if (psecuritypriv->binstallGrpkey == 0) {
+			res = _FAIL;
+			DBG_8723A("%s:rx bc/mc packets, but didn't install group key!!!!!!!!!!\n", __func__);
+			goto exit;
+		}
+		prwskey = psecuritypriv->dot118021XGrpKey[prxattrib->key_index].skey;
+		prwskeylen = 16;
+	} else {
+		RT_TRACE(_module_rtl871x_security_c_, _drv_err_, ("rtw_tkip_decrypt23a: stainfo!= NULL!!!\n"));
+		prwskey = &stainfo->dot118021x_UncstKey.skey[0];
+		prwskeylen = 16;
+	}
 
-			iv = pframe+prxattrib->hdrlen;
-			payload = pframe+prxattrib->iv_len+prxattrib->hdrlen;
-			length = skb->len - prxattrib->hdrlen-prxattrib->iv_len;
+	iv = pframe+prxattrib->hdrlen;
+	payload = pframe+prxattrib->iv_len+prxattrib->hdrlen;
+	length = skb->len - prxattrib->hdrlen-prxattrib->iv_len;
 
-			GET_TKIP_PN(iv, dot11txpn);
+	GET_TKIP_PN(iv, dot11txpn);
 
-			pnl = (u16)(dot11txpn.val);
-			pnh = (u32)(dot11txpn.val>>16);
+	pnl = (u16)(dot11txpn.val);
+	pnh = (u32)(dot11txpn.val>>16);
 
-			phase1((u16 *)&ttkey[0], prwskey, &prxattrib->ta[0], pnh);
-			phase2(&rc4key[0], prwskey, (unsigned short *)&ttkey[0], pnl);
+	phase1((u16 *)&ttkey[0], prwskey, &prxattrib->ta[0], pnh);
+	phase2(&rc4key[0], prwskey, (unsigned short *)&ttkey[0], pnl);
 
-			/* 4 decrypt payload include icv */
-			arcfour_init(&mycontext, rc4key, 16);
-			arcfour_encrypt(&mycontext, payload, payload, length);
+	/* 4 decrypt payload include icv */
+	arcfour_init(&mycontext, rc4key, 16);
+	arcfour_encrypt(&mycontext, payload, payload, length);
 
-			*((u32 *)crc) = le32_to_cpu(getcrc32(payload, length - 4));
+	*((u32 *)crc) = le32_to_cpu(getcrc32(payload, length - 4));
 
-			if (crc[3] != payload[length - 1] || crc[2] != payload[length - 2] || crc[1] != payload[length - 3] || crc[0] != payload[length - 4])
-			{
-			    RT_TRACE(_module_rtl871x_security_c_, _drv_err_, ("rtw_wep_decrypt23a:icv error crc[3](%x)!= payload[length-1](%x) || crc[2](%x)!= payload[length-2](%x) || crc[1](%x)!= payload[length-3](%x) || crc[0](%x)!= payload[length-4](%x)\n",
-						crc[3], payload[length - 1], crc[2], payload[length - 2], crc[1], payload[length - 3], crc[0], payload[length - 4]));
-				res = _FAIL;
-			}
-		} else {
-			RT_TRACE(_module_rtl871x_security_c_, _drv_err_, ("rtw_tkip_decrypt23a: stainfo == NULL!!!\n"));
-			res = _FAIL;
-		}
+	if (crc[3] != payload[length - 1] || crc[2] != payload[length - 2] || crc[1] != payload[length - 3] || crc[0] != payload[length - 4])
+	{
+	    RT_TRACE(_module_rtl871x_security_c_, _drv_err_, ("rtw_wep_decrypt23a:icv error crc[3](%x)!= payload[length-1](%x) || crc[2](%x)!= payload[length-2](%x) || crc[1](%x)!= payload[length-3](%x) || crc[0](%x)!= payload[length-4](%x)\n",
+				crc[3], payload[length - 1], crc[2], payload[length - 2], crc[1], payload[length - 3], crc[0], payload[length - 4]));
+		res = _FAIL;
 	}
+
 exit:
 	return res;
 }
-- 
2.1.4

