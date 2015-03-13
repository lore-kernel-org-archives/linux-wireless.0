Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:36438 "EHLO aibo.runbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756490AbbCMDhY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 23:37:24 -0400
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: m.v.b@runbox.com
Subject: [PATCH 15/16] staging: rtl8723au: Correct a typo in a trace log line
Date: Thu, 12 Mar 2015 23:15:31 -0400
Message-Id: <1426216532-24058-16-git-send-email-m.v.b@runbox.com> (sfid-20150313_043830_746307_083333BE)
In-Reply-To: <1426216532-24058-1-git-send-email-m.v.b@runbox.com>
References: <1426216532-24058-1-git-send-email-m.v.b@runbox.com>
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
index fd04ae78bb..7b4044fbe0 100644
--- a/drivers/staging/rtl8723au/core/rtw_security.c
+++ b/drivers/staging/rtl8723au/core/rtw_security.c
@@ -765,7 +765,7 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
 			crc[0] != payload[length - 4]) {
 
 		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
-				("rtw_wep_decrypt23a:icv error "
+				("rtw_tkip_decrypt23a:icv error "
 				 "crc[3](%x)!= payload[length-1](%x) || "
 				 "crc[2](%x)!= payload[length-2](%x) || "
 				 "crc[1](%x)!= payload[length-3](%x) || "
-- 
2.1.4

