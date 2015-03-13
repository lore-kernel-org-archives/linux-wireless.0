Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:36400 "EHLO aibo.runbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756213AbbCMDg4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 23:36:56 -0400
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: m.v.b@runbox.com
Subject: [PATCH 06/16] staging: rtl8723au: Do not initialize a static to 0
Date: Thu, 12 Mar 2015 23:15:22 -0400
Message-Id: <1426216532-24058-7-git-send-email-m.v.b@runbox.com> (sfid-20150313_044102_423331_BBD13EBD)
In-Reply-To: <1426216532-24058-1-git-send-email-m.v.b@runbox.com>
References: <1426216532-24058-1-git-send-email-m.v.b@runbox.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prior to this commit, a static integer named bcrc32initialized in
rtl8723au's rtw_security.c was explicitly initialized to zero, even
though this is not necessary. Remove the unneeded initialization.

Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
---
 drivers/staging/rtl8723au/core/rtw_security.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
index 0e87e1c10b..3e812a67e2 100644
--- a/drivers/staging/rtl8723au/core/rtw_security.c
+++ b/drivers/staging/rtl8723au/core/rtw_security.c
@@ -85,7 +85,7 @@ static void arcfour_encrypt(struct arc4context *parc4ctx,
 		dest[i] = src[i] ^ (unsigned char)arcfour_byte(parc4ctx);
 }
 
-static int bcrc32initialized = 0;
+static int bcrc32initialized;
 static u32 crc32_table[256];
 
 static u8 crc32_reverseBit(u8 data)
-- 
2.1.4

