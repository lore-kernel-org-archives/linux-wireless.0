Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:36278 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933140AbaGOSzm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2014 14:55:42 -0400
Received: by mail-we0-f177.google.com with SMTP id w62so2636196wes.36
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jul 2014 11:55:41 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 03/12] staging: vt6656: int rename INTnsProcessData to vnt_int_process_data
Date: Tue, 15 Jul 2014 19:54:34 +0100
Message-Id: <1405450483-2875-3-git-send-email-tvboxspy@gmail.com> (sfid-20140715_205545_936181_6EF32EFD)
In-Reply-To: <1405450483-2875-1-git-send-email-tvboxspy@gmail.com>
References: <1405450483-2875-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/int.c     | 2 +-
 drivers/staging/vt6656/int.h     | 2 +-
 drivers/staging/vt6656/usbpipe.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index ddf58f7..36be526 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -145,7 +145,7 @@ static int vnt_int_report_rate(struct vnt_private *priv, u8 pkt_no, u8 tsr)
 	return 0;
 }
 
-void INTnsProcessData(struct vnt_private *priv)
+void vnt_int_process_data(struct vnt_private *priv)
 {
 	struct vnt_interrupt_data *int_data;
 	struct ieee80211_low_level_stats *low_stats = &priv->low_stats;
diff --git a/drivers/staging/vt6656/int.h b/drivers/staging/vt6656/int.h
index 08db868..008545c 100644
--- a/drivers/staging/vt6656/int.h
+++ b/drivers/staging/vt6656/int.h
@@ -56,6 +56,6 @@ struct vnt_interrupt_data {
 } __packed;
 
 void INTvWorkItem(struct vnt_private *);
-void INTnsProcessData(struct vnt_private *);
+void vnt_int_process_data(struct vnt_private *);
 
 #endif /* __INT_H__ */
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index dd031bb..13b6852 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -198,7 +198,7 @@ static void s_nsInterruptUsbIoCompleteRead(struct urb *urb)
 
 		dev_dbg(&priv->usb->dev, "%s status = %d\n", __func__, status);
 	} else {
-		INTnsProcessData(priv);
+		vnt_int_process_data(priv);
 	}
 
 	status = usb_submit_urb(priv->pInterruptURB, GFP_ATOMIC);
-- 
2.0.1

