Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:49327 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756321AbaJ2Rp7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:45:59 -0400
Received: by mail-wg0-f49.google.com with SMTP id x13so3864738wgg.8
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:45:58 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 26/34] staging: vt6655: MACvSetDefaultKeyEntry replace WLAN_WEP104_KEYLEN
Date: Wed, 29 Oct 2014 17:44:01 +0000
Message-Id: <1414604649-9105-27-git-send-email-tvboxspy@gmail.com> (sfid-20141029_184607_509517_6693FA0C)
In-Reply-To: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
References: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

with WLAN_KEY_LEN_WEP40

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/mac.c b/drivers/staging/vt6655/mac.c
index e3b0b7f..a347f39 100644
--- a/drivers/staging/vt6655/mac.c
+++ b/drivers/staging/vt6655/mac.c
@@ -1526,7 +1526,7 @@ void MACvSetDefaultKeyEntry(void __iomem *dwIoBase, unsigned int uKeyLen,
 		VNSvOutPortW(dwIoBase + MAC_REG_MISCFFCTL, MISCFFCTL_WRITE);
 	}
 	dwData = *pdwKey;
-	if (uKeyLen == WLAN_WEP104_KEYLEN)
+	if (uKeyLen == WLAN_KEY_LEN_WEP40)
 		dwData |= 0x80000000;
 
 	VNSvOutPortW(dwIoBase + MAC_REG_MISCFFNDEX, wOffset+3);
-- 
2.1.0

