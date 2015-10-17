Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:36756 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbbJQKdZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Oct 2015 06:33:25 -0400
Received: by wicgb1 with SMTP id gb1so37171168wic.1
        for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2015 03:33:24 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 7/9] staging: vt6655: remove static inline alloc_td_info.
Date: Sat, 17 Oct 2015 11:33:00 +0100
Message-Id: <1445077982-17832-7-git-send-email-tvboxspy@gmail.com> (sfid-20151017_123333_559167_D16443ED)
In-Reply-To: <1445077982-17832-1-git-send-email-tvboxspy@gmail.com>
References: <1445077982-17832-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since this only contains one function and used only twice remove
inline altogether.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h      | 4 ----
 drivers/staging/vt6655/device_main.c | 4 ++--
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 0002049..8be3e21 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -306,8 +306,4 @@ struct vnt_private {
 	struct ieee80211_low_level_stats low_stats;
 };
 
-static inline struct vnt_td_info *alloc_td_info(void)
-{
-	return kzalloc(sizeof(struct vnt_td_info), GFP_ATOMIC);
-}
 #endif
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index aa8f750..d305d7a 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -633,7 +633,7 @@ static void device_init_td0_ring(struct vnt_private *priv)
 	for (i = 0; i < priv->sOpts.tx_descs[0];
 	     i++, curr += sizeof(struct vnt_tx_desc)) {
 		desc = &priv->apTD0Rings[i];
-		desc->td_info = alloc_td_info();
+		desc->td_info = kzalloc(sizeof(*desc->td_info), GFP_ATOMIC);
 
 		desc->td_info->buf = priv->tx0_bufs + i * PKT_BUF_SZ;
 		desc->td_info->buf_dma = priv->tx_bufs_dma0 + i * PKT_BUF_SZ;
@@ -658,7 +658,7 @@ static void device_init_td1_ring(struct vnt_private *priv)
 	for (i = 0; i < priv->sOpts.tx_descs[1];
 	     i++, curr += sizeof(struct vnt_tx_desc)) {
 		desc = &priv->apTD1Rings[i];
-		desc->td_info = alloc_td_info();
+		desc->td_info = kzalloc(sizeof(*desc->td_info), GFP_ATOMIC);
 
 		desc->td_info->buf = priv->tx1_bufs + i * PKT_BUF_SZ;
 		desc->td_info->buf_dma = priv->tx_bufs_dma1 + i * PKT_BUF_SZ;
-- 
2.5.0

