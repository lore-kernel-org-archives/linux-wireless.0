Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34798 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbcCFM5e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2016 07:57:34 -0500
Received: by mail-wm0-f65.google.com with SMTP id p65so6295132wmp.1
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2016 04:57:33 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 09/13] staging: vt6655: mac.c replace VNSvInPortB with ioread8
Date: Sun,  6 Mar 2016 12:57:08 +0000
Message-Id: <1457269032-2681-9-git-send-email-tvboxspy@gmail.com> (sfid-20160306_135746_050072_A57ABC21)
In-Reply-To: <1457269032-2681-1-git-send-email-tvboxspy@gmail.com>
References: <1457269032-2681-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing the macro from functions.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/mac.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6655/mac.c b/drivers/staging/vt6655/mac.c
index ece2bf0..a1be62d 100644
--- a/drivers/staging/vt6655/mac.c
+++ b/drivers/staging/vt6655/mac.c
@@ -558,7 +558,7 @@ void MACvSetCurrRx0DescAddr(struct vnt_private *priv, u32 dwCurrDescAddr)
 	unsigned short ww;
 	unsigned char byOrgDMACtl;
 
-	VNSvInPortB(io_base + MAC_REG_RXDMACTL0, &byOrgDMACtl);
+	byOrgDMACtl = ioread8(io_base + MAC_REG_RXDMACTL0);
 	if (byOrgDMACtl & DMACTL_RUN)
 		iowrite8(DMACTL_RUN, io_base + MAC_REG_RXDMACTL0 + 2);
 
@@ -592,7 +592,7 @@ void MACvSetCurrRx1DescAddr(struct vnt_private *priv, u32 dwCurrDescAddr)
 	unsigned short ww;
 	unsigned char byOrgDMACtl;
 
-	VNSvInPortB(io_base + MAC_REG_RXDMACTL1, &byOrgDMACtl);
+	byOrgDMACtl = ioread8(io_base + MAC_REG_RXDMACTL1);
 	if (byOrgDMACtl & DMACTL_RUN)
 		iowrite8(DMACTL_RUN, io_base + MAC_REG_RXDMACTL1 + 2);
 
@@ -628,7 +628,7 @@ void MACvSetCurrTx0DescAddrEx(struct vnt_private *priv,
 	unsigned short ww;
 	unsigned char byOrgDMACtl;
 
-	VNSvInPortB(io_base + MAC_REG_TXDMACTL0, &byOrgDMACtl);
+	byOrgDMACtl = ioread8(io_base + MAC_REG_TXDMACTL0);
 	if (byOrgDMACtl & DMACTL_RUN)
 		iowrite8(DMACTL_RUN, io_base + MAC_REG_TXDMACTL0 + 2);
 
@@ -664,7 +664,7 @@ void MACvSetCurrAC0DescAddrEx(struct vnt_private *priv,
 	unsigned short ww;
 	unsigned char byOrgDMACtl;
 
-	VNSvInPortB(io_base + MAC_REG_AC0DMACTL, &byOrgDMACtl);
+	byOrgDMACtl = ioread8(io_base + MAC_REG_AC0DMACTL);
 	if (byOrgDMACtl & DMACTL_RUN)
 		iowrite8(DMACTL_RUN, io_base + MAC_REG_AC0DMACTL + 2);
 
@@ -713,7 +713,7 @@ void MACvTimer0MicroSDelay(struct vnt_private *priv, unsigned int uDelay)
 	iowrite8((TMCTL_TMD | TMCTL_TE), io_base + MAC_REG_TMCTL0);
 	for (ii = 0; ii < 66; ii++) {  /* assume max PCI clock is 66Mhz */
 		for (uu = 0; uu < uDelay; uu++) {
-			VNSvInPortB(io_base + MAC_REG_TMCTL0, &byValue);
+			byValue = ioread8(io_base + MAC_REG_TMCTL0);
 			if ((byValue == 0) ||
 			    (byValue & TMCTL_TSUSP)) {
 				iowrite8(0, io_base + MAC_REG_TMCTL0);
-- 
2.7.0

