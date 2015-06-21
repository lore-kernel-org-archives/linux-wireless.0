Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:35019 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbbFUKGV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Jun 2015 06:06:21 -0400
Received: by wiga1 with SMTP id a1so52553915wig.0
        for <linux-wireless@vger.kernel.org>; Sun, 21 Jun 2015 03:06:20 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/3] staging: vt6655: vnt_tx_packet don't wakeup from power saving.
Date: Sun, 21 Jun 2015 11:05:54 +0100
Message-Id: <1434881155-3464-2-git-send-email-tvboxspy@gmail.com> (sfid-20150621_120625_745359_49A5DB16)
In-Reply-To: <1434881155-3464-1-git-send-email-tvboxspy@gmail.com>
References: <1434881155-3464-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 changes the wake state before attempting to tx data

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index b1357af..c421f78 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1211,9 +1211,6 @@ static int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 
 	vnt_generate_fifo_header(priv, dma_idx, head_td, skb);
 
-	if (MACbIsRegBitsOn(priv->PortOffset, MAC_REG_PSCTL, PSCTL_PS))
-		MACbPSWakeup(priv->PortOffset);
-
 	spin_lock_irqsave(&priv->lock, flags);
 
 	priv->bPWBitOn = false;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
