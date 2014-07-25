Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:47222 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761158AbaGYTwk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jul 2014 15:52:40 -0400
Received: by mail-we0-f176.google.com with SMTP id q58so4737574wes.21
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jul 2014 12:52:38 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 06/12] staging: vt6656: rename device_alloc_bufs to vnt_alloc_bufs
Date: Fri, 25 Jul 2014 20:51:50 +0100
Message-Id: <1406317916-21884-6-git-send-email-tvboxspy@gmail.com> (sfid-20140725_215244_447875_19928F39)
In-Reply-To: <1406317916-21884-1-git-send-email-tvboxspy@gmail.com>
References: <1406317916-21884-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

changing device to vnt

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 50955d2..fa0128f 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -441,7 +441,7 @@ static void vnt_free_int_bufs(struct vnt_private *priv)
 	return;
 }
 
-static bool device_alloc_bufs(struct vnt_private *priv)
+static bool vnt_alloc_bufs(struct vnt_private *priv)
 {
 	struct vnt_usb_send_context *tx_context;
 	struct vnt_rcb *rcb;
@@ -546,8 +546,8 @@ static int vnt_start(struct ieee80211_hw *hw)
 
 	priv->rx_buf_sz = MAX_TOTAL_SIZE_WITH_ALL_HEADERS;
 
-	if (device_alloc_bufs(priv) == false) {
-		dev_dbg(&priv->usb->dev, "device_alloc_bufs fail...\n");
+	if (vnt_alloc_bufs(priv) == false) {
+		dev_dbg(&priv->usb->dev, "vnt_alloc_bufs fail...\n");
 		return -ENOMEM;
 	}
 
-- 
2.0.1

