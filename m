Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49133 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab2KDWll (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Nov 2012 17:41:41 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr13so3550842wgb.1
        for <linux-wireless@vger.kernel.org>; Sun, 04 Nov 2012 14:41:40 -0800 (PST)
Message-ID: <1352068893.14226.7.camel@Route3278> (sfid-20121104_234153_076669_A8FD31C8)
Subject: [PATCH] staging: vt6656: [BUG] nsDMA_tx_packet:  free tx context
 bBoolInUse
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sun, 04 Nov 2012 22:41:33 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reduces the number of free TX urbs when key is not found.

---
 drivers/staging/vt6656/rxtx.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 3a4933e..0f35a9a 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -3045,6 +3045,7 @@ int nsDMA_tx_packet(PSDevice pDevice, unsigned int uDMAIdx, struct sk_buff *skb)
 
             if (pTransmitKey == NULL) {
                 DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"return no tx key\n");
+		pContext->bBoolInUse = FALSE;
                 dev_kfree_skb_irq(skb);
                 pStats->tx_dropped++;
                 return STATUS_FAILURE;
-- 
1.7.10.4


