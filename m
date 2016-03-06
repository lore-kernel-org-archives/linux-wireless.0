Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36746 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbcCFM5c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2016 07:57:32 -0500
Received: by mail-wm0-f65.google.com with SMTP id l68so6277001wml.3
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2016 04:57:31 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 07/13] staging: vt6655: MACbPSWakeup replace VNSvInPortB byOrgValue with ioread8
Date: Sun,  6 Mar 2016 12:57:06 +0000
Message-Id: <1457269032-2681-7-git-send-email-tvboxspy@gmail.com> (sfid-20160306_135742_082477_D01C1E57)
In-Reply-To: <1457269032-2681-1-git-send-email-tvboxspy@gmail.com>
References: <1457269032-2681-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

removing byOrgValue variable.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/mac.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/vt6655/mac.c b/drivers/staging/vt6655/mac.c
index a1be5a7..6499709 100644
--- a/drivers/staging/vt6655/mac.c
+++ b/drivers/staging/vt6655/mac.c
@@ -765,7 +765,6 @@ void MACvSetMISCFifo(struct vnt_private *priv, unsigned short wOffset,
 bool MACbPSWakeup(struct vnt_private *priv)
 {
 	void __iomem *io_base = priv->PortOffset;
-	unsigned char byOrgValue;
 	unsigned int ww;
 	/* Read PSCTL */
 	if (MACbIsRegBitsOff(priv, MAC_REG_PSCTL, PSCTL_PS))
@@ -776,8 +775,7 @@ bool MACbPSWakeup(struct vnt_private *priv)
 
 	/* Check if SyncFlushOK */
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
-		VNSvInPortB(io_base + MAC_REG_PSCTL, &byOrgValue);
-		if (byOrgValue & PSCTL_WAKEDONE)
+		if (ioread8(io_base + MAC_REG_PSCTL) & PSCTL_WAKEDONE)
 			break;
 	}
 	if (ww == W_MAX_TIMEOUT) {
-- 
2.7.0

