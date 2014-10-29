Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:55793 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809AbaJ2RqK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:46:10 -0400
Received: by mail-wi0-f177.google.com with SMTP id ex7so5288098wid.4
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:46:09 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 32/34] staging: vt6655: vnt_rx_data: uCurrRSSI should have the value of *rssi
Date: Wed, 29 Oct 2014 17:44:07 +0000
Message-Id: <1414604649-9105-33-git-send-email-tvboxspy@gmail.com> (sfid-20141029_184622_424743_12E2BF76)
In-Reply-To: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
References: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes issue of byBBVGANew is wrong in device_intr

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/dpc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/dpc.c b/drivers/staging/vt6655/dpc.c
index 036bbb0..11153ef 100644
--- a/drivers/staging/vt6655/dpc.c
+++ b/drivers/staging/vt6655/dpc.c
@@ -1382,7 +1382,7 @@ static bool vnt_rx_data(struct vnt_private *priv, struct sk_buff *skb,
 	RFvRSSITodBm(priv, *rssi, &rx_dbm);
 
 	priv->byBBPreEDRSSI = (u8)rx_dbm + 1;
-	priv->uCurrRSSI = priv->byBBPreEDRSSI;
+	priv->uCurrRSSI = *rssi;
 
 	skb_pull(skb, 4);
 	skb_trim(skb, frame_size);
-- 
2.1.0

