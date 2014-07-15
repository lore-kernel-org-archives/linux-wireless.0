Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:54373 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932854AbaGOSzv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2014 14:55:51 -0400
Received: by mail-wg0-f45.google.com with SMTP id x12so6105870wgg.16
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jul 2014 11:55:50 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 04/12] staging: vt6656: rename INTvWorkItem to vnt_int_start_interrupt
Date: Tue, 15 Jul 2014 19:54:35 +0100
Message-Id: <1405450483-2875-4-git-send-email-tvboxspy@gmail.com> (sfid-20140715_205554_300340_E4083DDB)
In-Reply-To: <1405450483-2875-1-git-send-email-tvboxspy@gmail.com>
References: <1405450483-2875-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function does run as work item, it starts interrupts from the
device.

Rename to vnt_int_start_interrupt

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/int.c      | 2 +-
 drivers/staging/vt6656/int.h      | 2 +-
 drivers/staging/vt6656/main_usb.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index 36be526..363e464 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -75,7 +75,7 @@ static const u8 fallback_rate1[5][5] = {
  *  if we've gotten no data
  *
 -*/
-void INTvWorkItem(struct vnt_private *priv)
+void vnt_int_start_interrupt(struct vnt_private *priv)
 {
 	unsigned long flags;
 	int status;
diff --git a/drivers/staging/vt6656/int.h b/drivers/staging/vt6656/int.h
index 008545c..154605c 100644
--- a/drivers/staging/vt6656/int.h
+++ b/drivers/staging/vt6656/int.h
@@ -55,7 +55,7 @@ struct vnt_interrupt_data {
 	u8 sw[2];
 } __packed;
 
-void INTvWorkItem(struct vnt_private *);
+void vnt_int_start_interrupt(struct vnt_private *);
 void vnt_int_process_data(struct vnt_private *);
 
 #endif /* __INT_H__ */
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index f0388d6..9890f7d 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -667,7 +667,7 @@ static int vnt_start(struct ieee80211_hw *hw)
 
 	priv->int_interval = 1;  /* bInterval is set to 1 */
 
-	INTvWorkItem(priv);
+	vnt_int_start_interrupt(priv);
 
 	priv->flags |= DEVICE_FLAGS_OPENED;
 
-- 
2.0.1

