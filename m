Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:58363 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972AbaLUM5P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2014 07:57:15 -0500
Received: by mail-wi0-f181.google.com with SMTP id r20so5718809wiv.14
        for <linux-wireless@vger.kernel.org>; Sun, 21 Dec 2014 04:57:14 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/2 bug fix] staging: vt6655: Fix loss of distant/weak access points on channel change.
Date: Sun, 21 Dec 2014 12:56:35 +0000
Message-Id: <1419166595-3096-2-git-send-email-tvboxspy@gmail.com> (sfid-20141221_135720_498332_AB13BF23)
In-Reply-To: <1419166595-3096-1-git-send-email-tvboxspy@gmail.com>
References: <1419166595-3096-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the asssocated access point is strong byBBVGACurrent will be adjusted
accordingly.

Users will nolonger see distant access points without taking down interface.

When changing channel reset byBBVGACurrent back to pDevice->abyBBVGA[0] for
max sensitivity.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/channel.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/staging/vt6655/channel.c b/drivers/staging/vt6655/channel.c
index c8f739d..70f8705 100644
--- a/drivers/staging/vt6655/channel.c
+++ b/drivers/staging/vt6655/channel.c
@@ -182,6 +182,14 @@ bool set_channel(void *pDeviceHandler, unsigned int uConnectionChannel)
 	if (pDevice->byCurrentCh == uConnectionChannel)
 		return bResult;
 
+	/* Set VGA to max sensitivity */
+	if (pDevice->bUpdateBBVGA &&
+	    pDevice->byBBVGACurrent != pDevice->abyBBVGA[0]) {
+		pDevice->byBBVGACurrent = pDevice->abyBBVGA[0];
+
+		BBvSetVGAGainOffset(pDevice, pDevice->byBBVGACurrent);
+	}
+
 	/* clear NAV */
 	MACvRegBitsOn(pDevice->PortOffset, MAC_REG_MACCR, MACCR_CLRNAV);
 
-- 
2.1.0

