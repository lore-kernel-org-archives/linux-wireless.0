Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:34468 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbbJQKdZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Oct 2015 06:33:25 -0400
Received: by wicgb1 with SMTP id gb1so38241023wic.1
        for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2015 03:33:23 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 6/9] staging: vt6655: remove static inline alloc_rd_info.
Date: Sat, 17 Oct 2015 11:32:59 +0100
Message-Id: <1445077982-17832-6-git-send-email-tvboxspy@gmail.com> (sfid-20151017_123328_961356_5D65E8FC)
In-Reply-To: <1445077982-17832-1-git-send-email-tvboxspy@gmail.com>
References: <1445077982-17832-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since this only contains one function and only used twice
remove inline altogether.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h      | 5 -----
 drivers/staging/vt6655/device_main.c | 4 ++--
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index aca6e00..0002049 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -306,11 +306,6 @@ struct vnt_private {
 	struct ieee80211_low_level_stats low_stats;
 };
 
-static inline struct vnt_rd_info *alloc_rd_info(void)
-{
-	return kzalloc(sizeof(struct vnt_rd_info), GFP_ATOMIC);
-}
-
 static inline struct vnt_td_info *alloc_td_info(void)
 {
 	return kzalloc(sizeof(struct vnt_td_info), GFP_ATOMIC);
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 8bca3fc..aa8f750 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -551,7 +551,7 @@ static void device_init_rd0_ring(struct vnt_private *priv)
 	for (i = 0; i < priv->sOpts.rx_descs0;
 	     i ++, curr += sizeof(struct vnt_rx_desc)) {
 		desc = &priv->aRD0Ring[i];
-		desc->rd_info = alloc_rd_info();
+		desc->rd_info = kzalloc(sizeof(*desc->rd_info), GFP_ATOMIC);
 
 		if (!device_alloc_rx_buf(priv, desc))
 			dev_err(&priv->pcid->dev, "can not alloc rx bufs\n");
@@ -575,7 +575,7 @@ static void device_init_rd1_ring(struct vnt_private *priv)
 	for (i = 0; i < priv->sOpts.rx_descs1;
 	     i ++, curr += sizeof(struct vnt_rx_desc)) {
 		desc = &priv->aRD1Ring[i];
-		desc->rd_info = alloc_rd_info();
+		desc->rd_info = kzalloc(sizeof(*desc->rd_info), GFP_ATOMIC);
 
 		if (!device_alloc_rx_buf(priv, desc))
 			dev_err(&priv->pcid->dev, "can not alloc rx bufs\n");
-- 
2.5.0

