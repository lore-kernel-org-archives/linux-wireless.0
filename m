Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:64603 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbaCAAAK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 19:00:10 -0500
Received: by mail-we0-f172.google.com with SMTP id u56so1148041wes.3
        for <linux-wireless@vger.kernel.org>; Fri, 28 Feb 2014 16:00:09 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 9/9] staging: vt6656: Remove unused tasklets tasklet_struct CmdWorkItem and EventWorkItem are not used.
Date: Fri, 28 Feb 2014 23:58:39 +0000
Message-Id: <1393631919-16182-9-git-send-email-tvboxspy@gmail.com> (sfid-20140301_010019_231160_5776CBDA)
In-Reply-To: <1393631919-16182-1-git-send-email-tvboxspy@gmail.com>
References: <1393631919-16182-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   | 2 --
 drivers/staging/vt6656/main_usb.c | 4 ----
 2 files changed, 6 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index a9784ff..e2abe3d 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -355,8 +355,6 @@ struct vnt_private {
 
 	OPTIONS sOpts;
 
-	struct tasklet_struct CmdWorkItem;
-	struct tasklet_struct EventWorkItem;
 	struct work_struct read_work_item;
 	struct work_struct rx_mng_work_item;
 
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 0475a20..7dd885f 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1005,8 +1005,6 @@ static int  device_open(struct net_device *dev)
 
     vMgrObjectInit(pDevice);
 
-    tasklet_init(&pDevice->EventWorkItem, (void *)INTvWorkItem, (unsigned long)pDevice);
-
 	schedule_delayed_work(&pDevice->second_callback_work, HZ);
 
 	pDevice->int_interval = 100;  /* max 100 microframes */
@@ -1108,8 +1106,6 @@ static int device_close(struct net_device *dev)
 	cancel_work_sync(&pDevice->rx_mng_work_item);
 	cancel_work_sync(&pDevice->read_work_item);
 
-    tasklet_kill(&pDevice->EventWorkItem);
-
    pDevice->bRoaming = false;
    pDevice->bIsRoaming = false;
    pDevice->bEnableRoaming = false;
-- 
1.9.0

