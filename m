Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:34073 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbbGIQBn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2015 12:01:43 -0400
Received: by wifm2 with SMTP id m2so23076816wif.1
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2015 09:01:42 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/4] staging: vt6655: vnt_tx_packet don't wakeup from power saving.
Date: Thu,  9 Jul 2015 17:01:26 +0100
Message-Id: <1436457687-3113-3-git-send-email-tvboxspy@gmail.com> (sfid-20150709_180149_373992_65E6B537)
In-Reply-To: <1436457687-3113-1-git-send-email-tvboxspy@gmail.com>
References: <1436457687-3113-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 changes the wake state before attempting to tx data

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index e78bd5e..c245dea 100644
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

