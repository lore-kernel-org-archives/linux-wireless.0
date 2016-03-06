Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35829 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbcCFM5e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2016 07:57:34 -0500
Received: by mail-wm0-f68.google.com with SMTP id 1so6277449wmg.2
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2016 04:57:33 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 08/13] staging: vt6655: MACvSetLoopbackMode replace byOrgValue with ioread8
Date: Sun,  6 Mar 2016 12:57:07 +0000
Message-Id: <1457269032-2681-8-git-send-email-tvboxspy@gmail.com> (sfid-20160306_135744_298200_E33ECF1B)
In-Reply-To: <1457269032-2681-1-git-send-email-tvboxspy@gmail.com>
References: <1457269032-2681-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing VNSvInPortB and nesting inside iowrite8.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/mac.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6655/mac.c b/drivers/staging/vt6655/mac.c
index 6499709..ece2bf0 100644
--- a/drivers/staging/vt6655/mac.c
+++ b/drivers/staging/vt6655/mac.c
@@ -184,14 +184,11 @@ void MACvSetLongRetryLimit(struct vnt_private *priv, unsigned char byRetryLimit)
 void MACvSetLoopbackMode(struct vnt_private *priv, unsigned char byLoopbackMode)
 {
 	void __iomem *io_base = priv->PortOffset;
-	unsigned char byOrgValue;
 
 	byLoopbackMode <<= 6;
 	/* set TCR */
-	VNSvInPortB(io_base + MAC_REG_TEST, &byOrgValue);
-	byOrgValue = byOrgValue & 0x3F;
-	byOrgValue = byOrgValue | byLoopbackMode;
-	iowrite8(byOrgValue, io_base + MAC_REG_TEST);
+	iowrite8((ioread8(io_base + MAC_REG_TEST) & 0x3f) | byLoopbackMode,
+		 io_base + MAC_REG_TEST);
 }
 
 /*
-- 
2.7.0

