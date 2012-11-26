Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:39058 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab2KZQGS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 11:06:18 -0500
Received: by mail-wi0-f174.google.com with SMTP id hm9so3611509wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2012 08:06:17 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 10/11] wlcore: gather information about firmware stability
Date: Mon, 26 Nov 2012 18:05:49 +0200
Message-Id: <1353945950-3899-11-git-send-email-arik@wizery.com> (sfid-20121126_170630_740900_80A2C53F)
In-Reply-To: <1353945950-3899-1-git-send-email-arik@wizery.com>
References: <1353945950-3899-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

It's sometimes useful to gather information about the firmware
stability in long test runs, especially to see if problems are
recurring frequently or not.  With this commit we count the number of
times a hardware recovery was issued and print it out during recovery
and in the driver_state in debugfs.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Igal Chernobelsky <igalc@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/debugfs.c |    1 +
 drivers/net/wireless/ti/wlcore/main.c    |    4 +++-
 drivers/net/wireless/ti/wlcore/wlcore.h  |    2 ++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/debugfs.c b/drivers/net/wireless/ti/wlcore/debugfs.c
index 7fbab3c..78d2eb3 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.c
+++ b/drivers/net/wireless/ti/wlcore/debugfs.c
@@ -490,6 +490,7 @@ static ssize_t driver_state_read(struct file *file, char __user *user_buf,
 	DRIVER_STATE_PRINT_HEX(chip.id);
 	DRIVER_STATE_PRINT_STR(chip.fw_ver_str);
 	DRIVER_STATE_PRINT_STR(chip.phy_fw_ver_str);
+	DRIVER_STATE_PRINT_INT(recovery_count);
 
 #undef DRIVER_STATE_PRINT_INT
 #undef DRIVER_STATE_PRINT_LONG
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index a6283df..a48a36c 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -879,7 +879,8 @@ static void wlcore_print_recovery(struct wl1271 *wl)
 	if (ret < 0)
 		return;
 
-	wl1271_info("pc: 0x%x, hint_sts: 0x%08x", pc, hint_sts);
+	wl1271_info("pc: 0x%x, hint_sts: 0x%08x count: %d",
+				pc, hint_sts, ++wl->recovery_count);
 
 	wlcore_set_partition(wl, &wl->ptable[PART_WORK]);
 }
@@ -5685,6 +5686,7 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size,
 	wl->flags = 0;
 	wl->sg_enabled = true;
 	wl->sleep_auth = WL1271_PSM_ILLEGAL;
+	wl->recovery_count = 0;
 	wl->hw_pg_ver = -1;
 	wl->ap_ps_map = 0;
 	wl->ap_fw_ps_map = 0;
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 5f580e5..4d5c69e 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -337,6 +337,8 @@ struct wl1271 {
 
 	bool enable_11a;
 
+	int recovery_count;
+
 	/* Most recently reported noise in dBm */
 	s8 noise;
 
-- 
1.7.9.5

