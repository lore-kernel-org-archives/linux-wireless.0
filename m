Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from jptorel01.sonyericsson.com ([124.215.201.70]:4033 "EHLO
	jptorel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753549AbbIXHLl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2015 03:11:41 -0400
From: Lars Svensson <lars1.svensson@sonymobile.com>
To: <Larry.Finger@lwfinger.net>
CC: <Jes.Sorensen@redhat.com>, <gregkh@linuxfoundation.org>,
	<m.v.b@runbox.com>, <gdonald@gmail.com>, <joe@perches.com>,
	<ruchandani.tina@gmail.com>, <linux-wireless@vger.kernel.org>,
	<devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>,
	Lars Svensson <lars1.svensson@sonymobile.com>,
	Lars Svensson <Lars1.Svensson@sonymobile.com>
Subject: [PATCH V2] staging: rtl8723au: Remove unneeded endianness conversions
Date: Thu, 24 Sep 2015 09:11:12 +0200
Message-ID: <1443078672-23970-1-git-send-email-lars1.svensson@sonymobile.com> (sfid-20150924_091157_844259_B733FDA5)
In-Reply-To: <20150923101109.GA1107@sonymobile.com>
References: <20150923101109.GA1107@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixing Sparse warnings in rtw_security.c. When checking crc, both
actual and expected value was converted to cpu endianness before
comparing, causing sparse warnings as below. Since the values are
read from the buffer in correct byte order the extra conversions
should not be needed.

Thanks to Larry Finger for help sorting this out.

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
Patch V2: Reworked as adviced.
---
 drivers/staging/rtl8723au/core/rtw_security.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
index 3d40bab..a44c606 100644
--- a/drivers/staging/rtl8723au/core/rtw_security.c
+++ b/drivers/staging/rtl8723au/core/rtw_security.c
@@ -245,8 +245,8 @@ void rtw_wep_decrypt23a(struct rtw_adapter *padapter,
 	arcfour_encrypt(&mycontext, payload, payload, length);
 
 	/* calculate icv and compare the icv */
-	actual_crc = le32_to_cpu(getcrc32(payload, length - 4));
-	expected_crc = le32_to_cpu(get_unaligned_le32(&payload[length - 4]));
+	actual_crc = getcrc32(payload, length - 4);
+	expected_crc = get_unaligned_le32(&payload[length - 4]);
 
 	if (actual_crc != expected_crc) {
 		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
@@ -772,9 +772,8 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
 	/* 4 decrypt payload include icv */
 	arcfour_init(&mycontext, rc4key, 16);
 	arcfour_encrypt(&mycontext, payload, payload, length);
-
-	actual_crc = le32_to_cpu(getcrc32(payload, length - 4));
-	expected_crc = le32_to_cpu(get_unaligned_le32(&payload[length - 4]));
+	actual_crc = getcrc32(payload, length - 4);
+	expected_crc = get_unaligned_le32(&payload[length - 4]);
 
 	if (actual_crc != expected_crc) {
 		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
-- 
2.4.2

