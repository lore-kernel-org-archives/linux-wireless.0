Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:44574 "EHLO aibo.runbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249AbbCOAPu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2015 20:15:50 -0400
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: joe@perches.com, Larry.Finger@lwfinger.net,
	gregkh@linuxfoundation.org, Jes.Sorensen@redhat.com,
	m.v.b@runbox.com
Subject: [PATCH v2 16/16] staging: rtl8723au: Remove unneeded comments
Date: Sat, 14 Mar 2015 20:10:41 -0400
Message-Id: <1426378241-32469-17-git-send-email-m.v.b@runbox.com> (sfid-20150315_011708_301644_081820B7)
In-Reply-To: <1426378241-32469-1-git-send-email-m.v.b@runbox.com>
References: <1426378241-32469-1-git-send-email-m.v.b@runbox.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This commit removes a number of unneeded comments. Two of the
aforementioned comments were most likely meant to aid with version
control, whereas the remaining two comments relate to (now unused)
local variable names.

Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
---
 drivers/staging/rtl8723au/core/rtw_security.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
index e8d3ce53bb..9d8a5ff4f7 100644
--- a/drivers/staging/rtl8723au/core/rtw_security.c
+++ b/drivers/staging/rtl8723au/core/rtw_security.c
@@ -669,14 +669,14 @@ int rtw_tkip_encrypt23a(struct rtw_adapter *padapter,
 		if ((curfragnum+1) == pattrib->nr_frags) { /* 4 the last fragment */
 			length = pattrib->last_txcmdsz-pattrib->hdrlen-pattrib->iv_len - pattrib->icv_len;
 			RT_TRACE(_module_rtl871x_security_c_, _drv_info_, ("pattrib->iv_len =%x, pattrib->icv_len =%x\n", pattrib->iv_len, pattrib->icv_len));
-			*((u32 *)crc) = cpu_to_le32(getcrc32(payload, length)); /* modified by Amy */
+			*((u32 *)crc) = cpu_to_le32(getcrc32(payload, length));
 
 			arcfour_init(&mycontext, rc4key, 16);
 			arcfour_encrypt(&mycontext, payload, payload, length);
 			arcfour_encrypt(&mycontext, payload+length, crc, 4);
 		} else {
 			length = pxmitpriv->frag_len-pattrib->hdrlen-pattrib->iv_len-pattrib->icv_len;
-			*((u32 *)crc) = cpu_to_le32(getcrc32(payload, length)); /* modified by Amy */
+			*((u32 *)crc) = cpu_to_le32(getcrc32(payload, length));
 			arcfour_init(&mycontext, rc4key, 16);
 			arcfour_encrypt(&mycontext, payload, payload, length);
 			arcfour_encrypt(&mycontext, payload+length, crc, 4);
@@ -1268,7 +1268,7 @@ int rtw_aes_encrypt23a(struct rtw_adapter *padapter,
 	/* Intermediate Buffers */
 	int curfragnum, length;
 	u32 prwskeylen;
-	u8 *pframe, *prwskey; /* *payload, *iv */
+	u8 *pframe, *prwskey;
 	u8 hw_hdr_offset = 0;
 	struct sta_info *stainfo;
 	struct pkt_attrib *pattrib = &pxmitframe->attrib;
@@ -1553,7 +1553,7 @@ int rtw_aes_decrypt23a(struct rtw_adapter *padapter,
 	struct security_priv *psecuritypriv = &padapter->securitypriv;
 	struct sk_buff *skb = precvframe->pkt;
 	int length;
-	u8 *pframe, *prwskey; /* *payload, *iv */
+	u8 *pframe, *prwskey;
 	int res = _SUCCESS;
 
 	pframe = skb->data;
-- 
2.1.4

