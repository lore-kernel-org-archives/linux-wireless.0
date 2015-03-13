Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:36425 "EHLO aibo.runbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756490AbbCMDhM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 23:37:12 -0400
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: m.v.b@runbox.com
Subject: [PATCH 16/16] staging: rtl8723au: Remove unneeded comments
Date: Thu, 12 Mar 2015 23:15:32 -0400
Message-Id: <1426216532-24058-17-git-send-email-m.v.b@runbox.com> (sfid-20150313_043858_925353_BBF1BA2D)
In-Reply-To: <1426216532-24058-1-git-send-email-m.v.b@runbox.com>
References: <1426216532-24058-1-git-send-email-m.v.b@runbox.com>
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
index 7b4044fbe0..da4c975f6e 100644
--- a/drivers/staging/rtl8723au/core/rtw_security.c
+++ b/drivers/staging/rtl8723au/core/rtw_security.c
@@ -674,14 +674,14 @@ int rtw_tkip_encrypt23a(struct rtw_adapter *padapter,
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
@@ -1282,7 +1282,7 @@ int rtw_aes_encrypt23a(struct rtw_adapter *padapter,
 	/* Intermediate Buffers */
 	int curfragnum, length;
 	u32 prwskeylen;
-	u8 *pframe, *prwskey; /* *payload, *iv */
+	u8 *pframe, *prwskey;
 	u8 hw_hdr_offset = 0;
 	struct sta_info *stainfo;
 	struct pkt_attrib *pattrib = &pxmitframe->attrib;
@@ -1567,7 +1567,7 @@ int rtw_aes_decrypt23a(struct rtw_adapter *padapter,
 	struct security_priv *psecuritypriv = &padapter->securitypriv;
 	struct sk_buff *skb = precvframe->pkt;
 	int length;
-	u8 *pframe, *prwskey; /* *payload, *iv */
+	u8 *pframe, *prwskey;
 	int res = _SUCCESS;
 
 	pframe = skb->data;
-- 
2.1.4

