Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:33384 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaJYTKd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 15:10:33 -0400
Received: by mail-wi0-f181.google.com with SMTP id n3so3558840wiv.8
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 12:10:32 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 26/31] staging: vt6655: MACvSetDefaultKeyEntry replace WLAN_WEP104_KEYLEN
Date: Sat, 25 Oct 2014 09:20:36 +0100
Message-Id: <1414225241-5480-27-git-send-email-tvboxspy@gmail.com> (sfid-20141025_211036_305194_E9F60DEC)
In-Reply-To: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
References: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
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
1.9.1

