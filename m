Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:50235 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbaGTOex (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 10:34:53 -0400
Received: by mail-we0-f175.google.com with SMTP id t60so6344603wes.6
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 07:34:52 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 18/25] staging: vt6656: struct vnt_private rename byBBPreEDIndex with bb_pre_ed_index
Date: Sun, 20 Jul 2014 15:33:28 +0100
Message-Id: <1405866815-2687-18-git-send-email-tvboxspy@gmail.com> (sfid-20140720_165109_143693_1EBD6AED)
In-Reply-To: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
References: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing type prefix and camel case.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 6 +++---
 drivers/staging/vt6656/device.h   | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index e15e842..e6c7b60 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -568,7 +568,7 @@ void vnt_exit_deep_sleep(struct vnt_private *priv)
 void vnt_update_pre_ed_threshold(struct vnt_private *priv, int scanning)
 {
 	u8 cr_201 = 0x0, cr_206 = 0x0;
-	u8 ed_inx = priv->byBBPreEDIndex;
+	u8 ed_inx = priv->bb_pre_ed_index;
 
 	switch (priv->rf_type) {
 	case RF_AL2230:
@@ -816,10 +816,10 @@ void vnt_update_pre_ed_threshold(struct vnt_private *priv, int scanning)
 
 	}
 
-	if (ed_inx == priv->byBBPreEDIndex && !scanning)
+	if (ed_inx == priv->bb_pre_ed_index && !scanning)
 		return;
 
-	priv->byBBPreEDIndex = ed_inx;
+	priv->bb_pre_ed_index = ed_inx;
 
 	dev_dbg(&priv->usb->dev, "%s bb_pre_ed_rssi %d\n",
 					__func__, priv->bb_pre_ed_rssi);
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index e97283b..101d0ca 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -386,7 +386,7 @@ struct vnt_private {
 	u8 bb_vga[BB_VGA_LEVEL];
 
 	u8 bb_pre_ed_rssi;
-	u8 byBBPreEDIndex;
+	u8 bb_pre_ed_index;
 
 	/* command timer */
 	struct delayed_work run_command_work;
-- 
2.0.1

