Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from seldrel01.sonyericsson.com ([37.139.156.2]:11839 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757848AbbIVN4s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 09:56:48 -0400
From: Lars Svensson <lars1.svensson@sonymobile.com>
To: <Larry.Finger@lwfinger.net>
CC: <Jes.Sorensen@redhat.com>, <gregkh@linuxfoundation.org>,
	<m.v.b@runbox.com>, <gdonald@gmail.com>, <joe@perches.com>,
	<ruchandani.tina@gmail.com>, <linux-wireless@vger.kernel.org>,
	<devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>,
	Lars Svensson <lars1.svensson@sonymobile.com>,
	Lars Svensson <Lars1.Svensson@sonymobile.com>
Subject: [PATCH] staging: rtl8723au: Mark type casts to __le32 as intentional
Date: Tue, 22 Sep 2015 09:24:01 +0200
Message-ID: <1442906641-22824-1-git-send-email-lars1.svensson@sonymobile.com> (sfid-20150922_155705_093966_5557F551)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixing Sparse warnings about intentional type casts in rtw_security.c
as below.

  CHECK   drivers/staging/rtl8723au/core/rtw_security.c
drivers/staging/rtl8723au/core/rtw_security.c:248:22: \
warning: cast to restricted __le32
drivers/staging/rtl8723au/core/rtw_security.c:249:24: \
warning: cast to restricted __le32
drivers/staging/rtl8723au/core/rtw_security.c:776:22: \
warning: cast to restricted __le32
drivers/staging/rtl8723au/core/rtw_security.c:777:24: \
warning: cast to restricted __le32

Signed-off-by: Lars Svensson <Lars1.Svensson@sonymobile.com>
---
 drivers/staging/rtl8723au/core/rtw_security.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
index 3d40bab..311dfc1 100644
--- a/drivers/staging/rtl8723au/core/rtw_security.c
+++ b/drivers/staging/rtl8723au/core/rtw_security.c
@@ -213,6 +213,7 @@ void rtw_wep_decrypt23a(struct rtw_adapter *padapter,
 {
 	/*  exclude ICV */
 	u32 actual_crc, expected_crc;
+	__le32 crc_le;
 	struct arc4context mycontext;
 	int length;
 	u32 keylength;
@@ -245,8 +246,10 @@ void rtw_wep_decrypt23a(struct rtw_adapter *padapter,
 	arcfour_encrypt(&mycontext, payload, payload, length);
 
 	/* calculate icv and compare the icv */
-	actual_crc = le32_to_cpu(getcrc32(payload, length - 4));
-	expected_crc = le32_to_cpu(get_unaligned_le32(&payload[length - 4]));
+	crc_le = (__force __le32)getcrc32(payload, length - 4);
+	actual_crc = le32_to_cpu(crc_le);
+	crc_le = (__force __le32)get_unaligned_le32(&payload[length - 4]);
+	expected_crc = le32_to_cpu(crc_le);
 
 	if (actual_crc != expected_crc) {
 		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
@@ -717,6 +720,7 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
 	u8 rc4key[16];
 	u8 ttkey[16];
 	u32 actual_crc, expected_crc;
+	__le32 crc_le;
 	struct arc4context mycontext;
 	int length;
 	u32 prwskeylen;
@@ -772,9 +776,10 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
 	/* 4 decrypt payload include icv */
 	arcfour_init(&mycontext, rc4key, 16);
 	arcfour_encrypt(&mycontext, payload, payload, length);
-
-	actual_crc = le32_to_cpu(getcrc32(payload, length - 4));
-	expected_crc = le32_to_cpu(get_unaligned_le32(&payload[length - 4]));
+	crc_le = (__force __le32)getcrc32(payload, length - 4);
+	actual_crc = le32_to_cpu(crc_le);
+	crc_le = (__force __le32)get_unaligned_le32(&payload[length - 4]);
+	expected_crc = le32_to_cpu(crc_le);
 
 	if (actual_crc != expected_crc) {
 		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
-- 
2.4.2

