Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:35294 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbbIAXfI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2015 19:35:08 -0400
From: =?UTF-8?q?Micha=C5=82=20Bartoszkiewicz?=
	<mbartoszkiewicz@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8723au: remove unnecessary le32_to_cpu
Date: Wed,  2 Sep 2015 01:35:00 +0200
Message-Id: <1441150500-14023-1-git-send-email-mbartoszkiewicz@gmail.com> (sfid-20150902_013513_857295_55255CE4)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The values passed to le32_to_cpu are already in the correct byte order.
This fixes four "cast to restricted __le32" sparse warnings.

Signed-off-by: Michał Bartoszkiewicz <mbartoszkiewicz@gmail.com>
---
 drivers/staging/rtl8723au/core/rtw_security.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
index 3d40bab..9d1cce1 100644
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
@@ -773,8 +773,8 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
 	arcfour_init(&mycontext, rc4key, 16);
 	arcfour_encrypt(&mycontext, payload, payload, length);
 
-	actual_crc = le32_to_cpu(getcrc32(payload, length - 4));
-	expected_crc = le32_to_cpu(get_unaligned_le32(&payload[length - 4]));
+	actual_crc = getcrc32(payload, length - 4);
+	expected_crc = get_unaligned_le32(&payload[length - 4]);
 
 	if (actual_crc != expected_crc) {
 		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
-- 
2.5.1

