Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:33250 "EHLO
	mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933166AbbHITVO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Aug 2015 15:21:14 -0400
Received: by qkfj126 with SMTP id j126so1031378qkf.0
        for <linux-wireless@vger.kernel.org>; Sun, 09 Aug 2015 12:21:13 -0700 (PDT)
From: Jacob Kiefer <jtk54@cornell.edu>
Cc: Jacob Kiefer <jtk54@cornell.edu>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"M. Vefa Bicakci" <m.v.b@runbox.com>,
	Greg Donald <gdonald@gmail.com>, Joe Perches <joe@perches.com>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	linux-wireless@vger.kernel.org (open list:STAGING - REALTEK RTL8723U
	WIRELESS DRIVER),
	devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH V2] staging: rtl8723au: Fix Sparse errors in rtw_security.c
Date: Sun,  9 Aug 2015 15:20:28 -0400
Message-Id: <1439148046-25790-1-git-send-email-jtk54@cornell.edu> (sfid-20150809_212146_276233_631B30C0)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the following sparse errors:

  CHECK   drivers/staging/rtl8723au/core/rtw_security.c
drivers/staging/rtl8723au/core/rtw_security.c:189:39: \
  warning: incorrect type in assignment (different base types)
drivers/staging/rtl8723au/core/rtw_security.c:189:39:    \
  expected unsigned int [unsigned] [usertype] <noident>
drivers/staging/rtl8723au/core/rtw_security.c:189:39:    \
  got restricted __le32 [usertype] <noident>
drivers/staging/rtl8723au/core/rtw_security.c:197:39: \
  warning: incorrect type in assignment (different base types)
drivers/staging/rtl8723au/core/rtw_security.c:197:39:    \
  expected unsigned int [unsigned] [usertype] <noident>
drivers/staging/rtl8723au/core/rtw_security.c:197:39:    \
  got restricted __le32 [usertype] <noident>
drivers/staging/rtl8723au/core/rtw_security.c:682:39: \
  warning: incorrect type in assignment (different base types)
drivers/staging/rtl8723au/core/rtw_security.c:682:39:    \
  expected unsigned int [unsigned] [usertype] <noident>
drivers/staging/rtl8723au/core/rtw_security.c:682:39:    \
  got restricted __le32 [usertype] <noident>
drivers/staging/rtl8723au/core/rtw_security.c:694:39: \
  warning: incorrect type in assignment (different base types)
drivers/staging/rtl8723au/core/rtw_security.c:694:39:    \
  expected unsigned int [unsigned] [usertype] <noident>
drivers/staging/rtl8723au/core/rtw_security.c:694:39:    \
  got restricted __le32 [usertype] <noident>

Signed-off-by: Jacob Kiefer <jtk54@cornell.edu>
---
In V2, rather than getting rid of the endian conversions (cpu_to_le32,
etc), changed the types of the variables the conversions were stored in.
Additionally, removed the changes that dealt with le32_to_cpu
causing "cast to restricted __le32" sparse errors.
---
 drivers/staging/rtl8723au/core/rtw_security.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
index af53c92..3d40bab 100644
--- a/drivers/staging/rtl8723au/core/rtw_security.c
+++ b/drivers/staging/rtl8723au/core/rtw_security.c
@@ -148,7 +148,7 @@ void rtw_wep_encrypt23a(struct rtw_adapter *padapter,
 		     struct xmit_frame *pxmitframe)
 {
 	/*  exclude ICV */
-	unsigned char crc[4];
+	__le32 crc;
 	struct arc4context mycontext;
 	int curfragnum, length, index;
 	u32 keylength;
@@ -186,18 +186,20 @@ void rtw_wep_encrypt23a(struct rtw_adapter *padapter,
 			length = pattrib->last_txcmdsz - pattrib->hdrlen -
 				pattrib->iv_len - pattrib->icv_len;
 
-			*((u32 *)crc) = cpu_to_le32(getcrc32(payload, length));
+			crc = cpu_to_le32(getcrc32(payload, length));
 
 			arcfour_init(&mycontext, wepkey, 3 + keylength);
 			arcfour_encrypt(&mycontext, payload, payload, length);
-			arcfour_encrypt(&mycontext, payload + length, crc, 4);
+			arcfour_encrypt(&mycontext, payload + length,
+					(char *)&crc, 4);
 		} else {
 			length = pxmitpriv->frag_len - pattrib->hdrlen -
 				pattrib->iv_len - pattrib->icv_len;
-			*((u32 *)crc) = cpu_to_le32(getcrc32(payload, length));
+			crc = cpu_to_le32(getcrc32(payload, length));
 			arcfour_init(&mycontext, wepkey, 3 + keylength);
 			arcfour_encrypt(&mycontext, payload, payload, length);
-			arcfour_encrypt(&mycontext, payload + length, crc, 4);
+			arcfour_encrypt(&mycontext, payload + length,
+					(char *)&crc, 4);
 
 			pframe += pxmitpriv->frag_len;
 			pframe = PTR_ALIGN(pframe, 4);
@@ -602,7 +604,7 @@ int rtw_tkip_encrypt23a(struct rtw_adapter *padapter,
 	u32 pnh;
 	u8 rc4key[16];
 	u8 ttkey[16];
-	u8 crc[4];
+	__le32 crc;
 	u8 hw_hdr_offset = 0;
 	struct arc4context mycontext;
 	int curfragnum, length;
@@ -679,11 +681,12 @@ int rtw_tkip_encrypt23a(struct rtw_adapter *padapter,
 				 "pattrib->iv_len =%x, pattrib->icv_len =%x\n",
 				 pattrib->iv_len,
 				 pattrib->icv_len);
-			*((u32 *)crc) = cpu_to_le32(getcrc32(payload, length));
+			crc = cpu_to_le32(getcrc32(payload, length));
 
 			arcfour_init(&mycontext, rc4key, 16);
 			arcfour_encrypt(&mycontext, payload, payload, length);
-			arcfour_encrypt(&mycontext, payload + length, crc, 4);
+			arcfour_encrypt(&mycontext, payload + length,
+					(char *)&crc, 4);
 
 		} else {
 			length = (pxmitpriv->frag_len -
@@ -691,10 +694,11 @@ int rtw_tkip_encrypt23a(struct rtw_adapter *padapter,
 				  pattrib->iv_len -
 				  pattrib->icv_len);
 
-			*((u32 *)crc) = cpu_to_le32(getcrc32(payload, length));
+			crc = cpu_to_le32(getcrc32(payload, length));
 			arcfour_init(&mycontext, rc4key, 16);
 			arcfour_encrypt(&mycontext, payload, payload, length);
-			arcfour_encrypt(&mycontext, payload + length, crc, 4);
+			arcfour_encrypt(&mycontext, payload + length,
+					(char *)&crc, 4);
 
 			pframe += pxmitpriv->frag_len;
 			pframe  = PTR_ALIGN(pframe, 4);
-- 
1.8.3.2

