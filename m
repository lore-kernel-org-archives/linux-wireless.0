Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:34020 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754789Ab2DKJia (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 05:38:30 -0400
Received: by lahc1 with SMTP id c1so568893lah.40
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 02:38:28 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, linville@tuxdriver.com, coelho@ti.com
Subject: [PATCH 14/16] wlcore: remove some unnecessary event mailbox address reads
Date: Wed, 11 Apr 2012 12:38:01 +0300
Message-Id: <1334137083-13490-15-git-send-email-coelho@ti.com> (sfid-20120411_113850_885525_99EB4C78)
In-Reply-To: <1334137083-13490-1-git-send-email-coelho@ti.com>
References: <1334137083-13490-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We were reading the even mailbox address three times, which was
completely unnecessary and complicated things regarding partition
selection.  Remove the unnecessry reads and set the address for
mailbox 1 and 2 after the first read.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/boot.c   |   18 ++++++++++++------
 drivers/net/wireless/ti/wlcore/event.c  |    9 ---------
 drivers/net/wireless/ti/wlcore/event.h  |    1 -
 drivers/net/wireless/ti/wlcore/wlcore.h |    1 -
 4 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/boot.c b/drivers/net/wireless/ti/wlcore/boot.c
index 9520073..3cb75db 100644
--- a/drivers/net/wireless/ti/wlcore/boot.c
+++ b/drivers/net/wireless/ti/wlcore/boot.c
@@ -399,14 +399,19 @@ int wlcore_boot_run_firmware(struct wl1271 *wl)
 	/* get hardware config command mail box */
 	wl->cmd_box_addr = wlcore_read_reg(wl, REG_COMMAND_MAILBOX_PTR);
 
+	wl1271_debug(DEBUG_MAILBOX, "cmd_box_addr 0x%x", wl->cmd_box_addr);
+
 	/* get hardware config event mail box */
-	wl->event_box_addr = wlcore_read_reg(wl, REG_EVENT_MAILBOX_PTR);
+	wl->mbox_ptr[0] = wlcore_read_reg(wl, REG_EVENT_MAILBOX_PTR);
+	wl->mbox_ptr[1] = wl->mbox_ptr[0] + sizeof(struct event_mailbox);
 
-	/* set the working partition to its "running" mode offset */
-	wlcore_set_partition(wl, &wl->ptable[PART_WORK]);
+	wl1271_debug(DEBUG_MAILBOX, "MBOX ptrs: 0x%x 0x%x",
+		     wl->mbox_ptr[0], wl->mbox_ptr[1]);
 
-	wl1271_debug(DEBUG_MAILBOX, "cmd_box_addr 0x%x event_box_addr 0x%x",
-		     wl->cmd_box_addr, wl->event_box_addr);
+	/*
+	 * TODO: wl12xx used to set the partition here, but it seems
+	 * that it can be done later.  Make sure this is okay.
+	 */
 
 	wl1271_boot_fw_version(wl);
 
@@ -438,7 +443,8 @@ int wlcore_boot_run_firmware(struct wl1271 *wl)
 		return ret;
 	}
 
-	wl1271_event_mbox_config(wl);
+	/* set the working partition to its "running" mode offset */
+	wlcore_set_partition(wl, &wl->ptable[PART_WORK]);
 
 	/* firmware startup completed */
 	return 0;
diff --git a/drivers/net/wireless/ti/wlcore/event.c b/drivers/net/wireless/ti/wlcore/event.c
index e3f572c..292632d 100644
--- a/drivers/net/wireless/ti/wlcore/event.c
+++ b/drivers/net/wireless/ti/wlcore/event.c
@@ -278,15 +278,6 @@ int wl1271_event_unmask(struct wl1271 *wl)
 	return 0;
 }
 
-void wl1271_event_mbox_config(struct wl1271 *wl)
-{
-	wl->mbox_ptr[0] = wlcore_read_reg(wl, REG_EVENT_MAILBOX_PTR);
-	wl->mbox_ptr[1] = wl->mbox_ptr[0] + sizeof(struct event_mailbox);
-
-	wl1271_debug(DEBUG_EVENT, "MBOX ptrs: 0x%x 0x%x",
-		     wl->mbox_ptr[0], wl->mbox_ptr[1]);
-}
-
 int wl1271_event_handle(struct wl1271 *wl, u8 mbox_num)
 {
 	int ret;
diff --git a/drivers/net/wireless/ti/wlcore/event.h b/drivers/net/wireless/ti/wlcore/event.h
index 8acba0d..8adf18d 100644
--- a/drivers/net/wireless/ti/wlcore/event.h
+++ b/drivers/net/wireless/ti/wlcore/event.h
@@ -135,7 +135,6 @@ struct event_mailbox {
 struct wl1271;
 
 int wl1271_event_unmask(struct wl1271 *wl);
-void wl1271_event_mbox_config(struct wl1271 *wl);
 int wl1271_event_handle(struct wl1271 *wl, u8 mbox);
 
 #endif
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 5f5dadb..984dda7 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -111,7 +111,6 @@ struct wl1271 {
 	struct wl1271_chip chip;
 
 	int cmd_box_addr;
-	int event_box_addr;
 
 	u8 *fw;
 	size_t fw_len;
-- 
1.7.5.4

