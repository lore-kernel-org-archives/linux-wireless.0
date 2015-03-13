Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:36437 "EHLO aibo.runbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756573AbbCMDhV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 23:37:21 -0400
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: m.v.b@runbox.com
Subject: [PATCH 14/16] staging: rtl8723au: Improve readability of two very long lines
Date: Thu, 12 Mar 2015 23:15:30 -0400
Message-Id: <1426216532-24058-15-git-send-email-m.v.b@runbox.com> (sfid-20150313_043809_733562_AB7C610C)
In-Reply-To: <1426216532-24058-1-git-send-email-m.v.b@runbox.com>
References: <1426216532-24058-1-git-send-email-m.v.b@runbox.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Improve the readability of an if statement and its very long trace
output line in rtl8723au's rtw_security.c.

Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
---
 drivers/staging/rtl8723au/core/rtw_security.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
index dbbe7b348d..fd04ae78bb 100644
--- a/drivers/staging/rtl8723au/core/rtw_security.c
+++ b/drivers/staging/rtl8723au/core/rtw_security.c
@@ -759,9 +759,21 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
 
 	*((u32 *)crc) = le32_to_cpu(getcrc32(payload, length-4));
 
-	if (crc[3] != payload[length - 1] || crc[2] != payload[length - 2] || crc[1] != payload[length - 3] || crc[0] != payload[length - 4]) {
-		RT_TRACE(_module_rtl871x_security_c_, _drv_err_, ("rtw_wep_decrypt23a:icv error crc[3](%x)!= payload[length-1](%x) || crc[2](%x)!= payload[length-2](%x) || crc[1](%x)!= payload[length-3](%x) || crc[0](%x)!= payload[length-4](%x)\n",
-				crc[3], payload[length - 1], crc[2], payload[length - 2], crc[1], payload[length - 3], crc[0], payload[length - 4]));
+	if (crc[3] != payload[length - 1] ||
+			crc[2] != payload[length - 2] ||
+			crc[1] != payload[length - 3] ||
+			crc[0] != payload[length - 4]) {
+
+		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
+				("rtw_wep_decrypt23a:icv error "
+				 "crc[3](%x)!= payload[length-1](%x) || "
+				 "crc[2](%x)!= payload[length-2](%x) || "
+				 "crc[1](%x)!= payload[length-3](%x) || "
+				 "crc[0](%x)!= payload[length-4](%x)\n",
+				 crc[3], payload[length - 1],
+				 crc[2], payload[length - 2],
+				 crc[1], payload[length - 3],
+				 crc[0], payload[length - 4]));
 		res = _FAIL;
 	}
 
-- 
2.1.4

