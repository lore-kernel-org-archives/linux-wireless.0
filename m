Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:33834 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbbJCTap (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Oct 2015 15:30:45 -0400
Received: by wicfx3 with SMTP id fx3so71872590wic.1
        for <linux-wireless@vger.kernel.org>; Sat, 03 Oct 2015 12:30:44 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 5/6] staging: vt6655: device_main replace pTDInfo with td_info.
Date: Sat,  3 Oct 2015 20:30:26 +0100
Message-Id: <1443900627-2924-5-git-send-email-tvboxspy@gmail.com> (sfid-20151003_213049_661608_6E7C2CA9)
In-Reply-To: <1443900627-2924-1-git-send-email-tvboxspy@gmail.com>
References: <1443900627-2924-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing camel case.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 7e76176..ff329bd 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -678,9 +678,9 @@ static void device_free_td0_ring(struct vnt_private *priv)
 
 	for (i = 0; i < priv->sOpts.nTxDescs[0]; i++) {
 		struct vnt_tx_desc *desc = &priv->apTD0Rings[i];
-		struct vnt_td_info *pTDInfo = desc->td_info;
+		struct vnt_td_info *td_info = desc->td_info;
 
-		dev_kfree_skb(pTDInfo->skb);
+		dev_kfree_skb(td_info->skb);
 		kfree(desc->td_info);
 	}
 }
@@ -691,9 +691,9 @@ static void device_free_td1_ring(struct vnt_private *priv)
 
 	for (i = 0; i < priv->sOpts.nTxDescs[1]; i++) {
 		struct vnt_tx_desc *desc = &priv->apTD1Rings[i];
-		struct vnt_td_info *pTDInfo = desc->td_info;
+		struct vnt_td_info *td_info = desc->td_info;
 
-		dev_kfree_skb(pTDInfo->skb);
+		dev_kfree_skb(td_info->skb);
 		kfree(desc->td_info);
 	}
 }
@@ -892,14 +892,14 @@ static void device_error(struct vnt_private *priv, unsigned short status)
 static void device_free_tx_buf(struct vnt_private *priv,
 			       struct vnt_tx_desc *desc)
 {
-	struct vnt_td_info *pTDInfo = desc->td_info;
-	struct sk_buff *skb = pTDInfo->skb;
+	struct vnt_td_info *td_info = desc->td_info;
+	struct sk_buff *skb = td_info->skb;
 
 	if (skb)
 		ieee80211_tx_status_irqsafe(priv->hw, skb);
 
-	pTDInfo->skb = NULL;
-	pTDInfo->flags = 0;
+	td_info->skb = NULL;
+	td_info->flags = 0;
 }
 
 static void vnt_check_bb_vga(struct vnt_private *priv)
-- 
2.5.0

