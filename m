Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35664 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbbHVK6u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Aug 2015 06:58:50 -0400
Received: by pacdd16 with SMTP id dd16so61632124pac.2
        for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2015 03:58:49 -0700 (PDT)
From: Shraddha Barke <shraddha.6596@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Donald <gdonald@gmail.com>,
	linux-wireless@vger.kernel.org, Joe Perches <joe@perches.com>
Cc: Shraddha Barke <shraddha.6596@gmail.com>
Subject: [PATCH 4/4] Staging: rtl8723au: core: Remove unused variable
Date: Sat, 22 Aug 2015 16:28:14 +0530
Message-Id: <1440241094-5927-4-git-send-email-shraddha.6596@gmail.com> (sfid-20150822_125858_193385_EE4D202A)
In-Reply-To: <1440241094-5927-1-git-send-email-shraddha.6596@gmail.com>
References: <1440241094-5927-1-git-send-email-shraddha.6596@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch discards the variable as it is not used anywhere throughout
the kernel.

Signed-off-by: Shraddha Barke <shraddha.6596@gmail.com>
---
 drivers/staging/rtl8723au/core/rtw_security.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
index 3d40bab..82518cd 100644
--- a/drivers/staging/rtl8723au/core/rtw_security.c
+++ b/drivers/staging/rtl8723au/core/rtw_security.c
@@ -608,7 +608,6 @@ int rtw_tkip_encrypt23a(struct rtw_adapter *padapter,
 	u8 hw_hdr_offset = 0;
 	struct arc4context mycontext;
 	int curfragnum, length;
-	u32 prwskeylen;
 	u8 *pframe, *payload, *iv, *prwskey;
 	union pn48 dot11txpn;
 	struct sta_info *stainfo;
@@ -655,8 +654,6 @@ int rtw_tkip_encrypt23a(struct rtw_adapter *padapter,
 	else
 		prwskey = &stainfo->dot118021x_UncstKey.skey[0];
 
-	prwskeylen = 16;
-
 	/* 4 start to encrypt each fragment */
 	for (curfragnum = 0; curfragnum < pattrib->nr_frags; curfragnum++) {
 		iv = pframe + pattrib->hdrlen;
@@ -719,7 +716,6 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
 	u32 actual_crc, expected_crc;
 	struct arc4context mycontext;
 	int length;
-	u32 prwskeylen;
 	u8 *pframe, *payload, *iv, *prwskey;
 	union pn48 dot11txpn;
 	struct sta_info *stainfo;
@@ -749,12 +745,10 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
 			goto exit;
 		}
 		prwskey = psecuritypriv->dot118021XGrpKey[prxattrib->key_index].skey;
-		prwskeylen = 16;
 	} else {
 		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
 			 "%s: stainfo!= NULL!!!\n", __func__);
 		prwskey = &stainfo->dot118021x_UncstKey.skey[0];
-		prwskeylen = 16;
 	}
 
 	iv = pframe + prxattrib->hdrlen;
@@ -1288,7 +1282,6 @@ int rtw_aes_encrypt23a(struct rtw_adapter *padapter,
 {	/* exclude ICV */
 	/* Intermediate Buffers */
 	int curfragnum, length;
-	u32 prwskeylen;
 	u8 *pframe, *prwskey;
 	u8 hw_hdr_offset = 0;
 	struct sta_info *stainfo;
@@ -1335,8 +1328,6 @@ int rtw_aes_encrypt23a(struct rtw_adapter *padapter,
 	else
 		prwskey = &stainfo->dot118021x_UncstKey.skey[0];
 
-	prwskeylen = 16;
-
 	for (curfragnum = 0; curfragnum < pattrib->nr_frags; curfragnum++) {
 		/* 4 the last fragment */
 		if ((curfragnum + 1) == pattrib->nr_frags) {
-- 
2.1.4

