Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:33591 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbbGVSR7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 14:17:59 -0400
Received: by wicmv11 with SMTP id mv11so92408681wic.0
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2015 11:17:58 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 14/15] staging: vt6655: s_cbFillTxBufHead replace STxBufHead
Date: Wed, 22 Jul 2015 19:16:46 +0100
Message-Id: <1437589007-5479-14-git-send-email-tvboxspy@gmail.com> (sfid-20150722_201808_749904_F925AA13)
In-Reply-To: <1437589007-5479-1-git-send-email-tvboxspy@gmail.com>
References: <1437589007-5479-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

vnt_tx_fifo_head has now replaced STxBufHead

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/rxtx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 82380f3..380b879 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -1088,7 +1088,7 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 
 
 	/* Set RrvTime/RTS/CTS Buffer */
-	wTxBufSize = sizeof(STxBufHead);
+	wTxBufSize = sizeof(struct vnt_tx_fifo_head);
 	if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {/* 802.11g packet */
 
 		if (byFBOption == AUTO_FB_NONE) {
-- 
2.1.4

