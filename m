Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:44562 "EHLO aibo.runbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbbCOAPn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2015 20:15:43 -0400
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: joe@perches.com, Larry.Finger@lwfinger.net,
	gregkh@linuxfoundation.org, Jes.Sorensen@redhat.com,
	m.v.b@runbox.com
Subject: [PATCH v2 15/16] staging: rtl8723au: Correct a typo in a trace log line
Date: Sat, 14 Mar 2015 20:10:40 -0400
Message-Id: <1426378241-32469-16-git-send-email-m.v.b@runbox.com> (sfid-20150315_011831_429063_4973863B)
In-Reply-To: <1426378241-32469-1-git-send-email-m.v.b@runbox.com>
References: <1426378241-32469-1-git-send-email-m.v.b@runbox.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Correct a typo in rtl8723au's rtw_security.c which was most likely
caused by a copy and paste mistake. Prior to this commit, the TKIP
decryption function referred to WEP in its trace log output.

Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
---
 drivers/staging/rtl8723au/core/rtw_security.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
index eb3544866a..e8d3ce53bb 100644
--- a/drivers/staging/rtl8723au/core/rtw_security.c
+++ b/drivers/staging/rtl8723au/core/rtw_security.c
@@ -757,7 +757,7 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
 
 	if (actual_crc != expected_crc) {
 		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
-			 ("rtw_wep_decrypt23a:icv CRC mismatch: "
+			 ("rtw_tkip_decrypt23a:icv CRC mismatch: "
 			  "actual: %08x, expected: %08x\n",
 			  actual_crc, expected_crc));
 		res = _FAIL;
-- 
2.1.4

