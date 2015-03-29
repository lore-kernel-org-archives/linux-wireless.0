Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:60958 "EHLO aibo.runbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856AbbC2BIl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2015 21:08:41 -0400
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: joe@perches.com, gregkh@linuxfoundation.org,
	Jes.Sorensen@redhat.com, Larry.Finger@lwfinger.net,
	mail@beyermatthias.de, m.v.b@runbox.com
Subject: [PATCH v5 15/15] staging: rtl8723au: Remove unneeded comments
Date: Sat, 28 Mar 2015 21:07:58 -0400
Message-Id: <1427591278-982-16-git-send-email-m.v.b@runbox.com> (sfid-20150329_030958_682432_3508492E)
In-Reply-To: <1427591278-982-1-git-send-email-m.v.b@runbox.com>
References: <1427591278-982-1-git-send-email-m.v.b@runbox.com>
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
index 5ef16bb30dc4..af53c92fc3a2 100644
--- a/drivers/staging/rtl8723au/core/rtw_security.c
+++ b/drivers/staging/rtl8723au/core/rtw_security.c
@@ -679,7 +679,7 @@ int rtw_tkip_encrypt23a(struct rtw_adapter *padapter,
 				 "pattrib->iv_len =%x, pattrib->icv_len =%x\n",
 				 pattrib->iv_len,
 				 pattrib->icv_len);
-			*((u32 *)crc) = cpu_to_le32(getcrc32(payload, length)); /* modified by Amy */
+			*((u32 *)crc) = cpu_to_le32(getcrc32(payload, length));
 
 			arcfour_init(&mycontext, rc4key, 16);
 			arcfour_encrypt(&mycontext, payload, payload, length);
@@ -691,7 +691,7 @@ int rtw_tkip_encrypt23a(struct rtw_adapter *padapter,
 				  pattrib->iv_len -
 				  pattrib->icv_len);
 
-			*((u32 *)crc) = cpu_to_le32(getcrc32(payload, length)); /* modified by Amy */
+			*((u32 *)crc) = cpu_to_le32(getcrc32(payload, length));
 			arcfour_init(&mycontext, rc4key, 16);
 			arcfour_encrypt(&mycontext, payload, payload, length);
 			arcfour_encrypt(&mycontext, payload + length, crc, 4);
@@ -1285,7 +1285,7 @@ int rtw_aes_encrypt23a(struct rtw_adapter *padapter,
 	/* Intermediate Buffers */
 	int curfragnum, length;
 	u32 prwskeylen;
-	u8 *pframe, *prwskey; /* *payload, *iv */
+	u8 *pframe, *prwskey;
 	u8 hw_hdr_offset = 0;
 	struct sta_info *stainfo;
 	struct pkt_attrib *pattrib = &pxmitframe->attrib;
@@ -1574,7 +1574,7 @@ int rtw_aes_decrypt23a(struct rtw_adapter *padapter,
 	struct security_priv *psecuritypriv = &padapter->securitypriv;
 	struct sk_buff *skb = precvframe->pkt;
 	int length;
-	u8 *pframe, *prwskey; /* *payload, *iv */
+	u8 *pframe, *prwskey;
 	int res = _SUCCESS;
 
 	pframe = skb->data;
-- 
2.1.4

