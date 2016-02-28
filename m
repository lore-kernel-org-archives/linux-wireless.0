Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35497 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187AbcB1TDN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2016 14:03:13 -0500
Received: by mail-wm0-f66.google.com with SMTP id 1so1583469wmg.2
        for <linux-wireless@vger.kernel.org>; Sun, 28 Feb 2016 11:03:13 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4/4] staging: vt6655: MACvSaveContext use memcpy_fromio to read context.
Date: Sun, 28 Feb 2016 19:02:57 +0000
Message-Id: <1456686177-3167-4-git-send-email-tvboxspy@gmail.com> (sfid-20160228_200317_875080_CAFBFA66)
In-Reply-To: <1456686177-3167-1-git-send-email-tvboxspy@gmail.com>
References: <1456686177-3167-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use memcpy_fromio to store data removing the need for local count.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/mac.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6655/mac.c b/drivers/staging/vt6655/mac.c
index c935922..66ae991 100644
--- a/drivers/staging/vt6655/mac.c
+++ b/drivers/staging/vt6655/mac.c
@@ -210,18 +210,15 @@ void MACvSetLoopbackMode(struct vnt_private *priv, unsigned char byLoopbackMode)
 void MACvSaveContext(struct vnt_private *priv, unsigned char *pbyCxtBuf)
 {
 	void __iomem *io_base = priv->PortOffset;
-	int         ii;
 
 	/* read page0 register */
-	for (ii = 0; ii < MAC_MAX_CONTEXT_SIZE_PAGE0; ii++)
-		VNSvInPortB((io_base + ii), (pbyCxtBuf + ii));
+	memcpy_fromio(pbyCxtBuf, io_base, MAC_MAX_CONTEXT_SIZE_PAGE0);
 
 	MACvSelectPage1(io_base);
 
 	/* read page1 register */
-	for (ii = 0; ii < MAC_MAX_CONTEXT_SIZE_PAGE1; ii++)
-		VNSvInPortB((io_base + ii),
-			    (pbyCxtBuf + MAC_MAX_CONTEXT_SIZE_PAGE0 + ii));
+	memcpy_fromio(pbyCxtBuf + MAC_MAX_CONTEXT_SIZE_PAGE0, io_base,
+		      MAC_MAX_CONTEXT_SIZE_PAGE1);
 
 	MACvSelectPage0(io_base);
 }
-- 
2.7.0

