Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:50072 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754564Ab1GNMsD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 08:48:03 -0400
Received: by mail-ww0-f44.google.com with SMTP id 5so200041wwe.13
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jul 2011 05:48:01 -0700 (PDT)
From: Gery Kahn <geryk@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>
Subject: [PATCH 1/2] wl12xx: Fix for PG version and sysfs files
Date: Thu, 14 Jul 2011 15:47:52 +0300
Message-Id: <1310647673-10144-1-git-send-email-geryk@ti.com> (sfid-20110714_144807_972285_654C10F6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix the value of PG version for 128x at sysfs, remove write permissions
from PG version (hw_pg_ver) in sysfs and add remove files
(hw_pg_ver,bt_coex_state) from sysfs while freeing hardware.
New macro names for register Fuse_data_2_1 depend on architecture.

Signed-off-by: Gery Kahn <geryk@ti.com>
---
 drivers/net/wireless/wl12xx/boot.c |   13 ++++++++-----
 drivers/net/wireless/wl12xx/boot.h |    3 ++-
 drivers/net/wireless/wl12xx/main.c |    6 +++++-
 3 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index 4bcee1c..74ed1b3 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -524,13 +524,13 @@ static void wl1271_boot_hw_version(struct wl1271 *wl)
 {
 	u32 fuse;
 
-	fuse = wl1271_top_reg_read(wl, REG_FUSE_DATA_2_1);
+	if (wl->chip.id == CHIP_ID_1283_PG20)
+		fuse = wl1271_top_reg_read(wl, WL128X_REG_FUSE_DATA_2_1);
+	else
+		fuse = wl1271_top_reg_read(wl, WL127X_REG_FUSE_DATA_2_1);
 	fuse = (fuse & PG_VER_MASK) >> PG_VER_OFFSET;
 
 	wl->hw_pg_ver = (s8)fuse;
-
-	if (((wl->hw_pg_ver & PG_MAJOR_VER_MASK) >> PG_MAJOR_VER_OFFSET) < 3)
-		wl->quirks |= WL12XX_QUIRK_END_OF_TRANSACTION;
 }
 
 static int wl128x_switch_tcxo_to_fref(struct wl1271 *wl)
@@ -671,7 +671,8 @@ static int wl127x_boot_clk(struct wl1271 *wl)
 	u32 pause;
 	u32 clk;
 
-	wl1271_boot_hw_version(wl);
+	if (((wl->hw_pg_ver & PG_MAJOR_VER_MASK) >> PG_MAJOR_VER_OFFSET) < 3)
+		wl->quirks |= WL12XX_QUIRK_END_OF_TRANSACTION;
 
 	if (wl->ref_clock == CONF_REF_CLK_19_2_E ||
 	    wl->ref_clock == CONF_REF_CLK_38_4_E ||
@@ -725,6 +726,8 @@ int wl1271_load_firmware(struct wl1271 *wl)
 	u32 tmp, clk;
 	int selected_clock = -1;
 
+	wl1271_boot_hw_version(wl);
+
 	if (wl->chip.id == CHIP_ID_1283_PG20) {
 		ret = wl128x_boot_clk(wl, &selected_clock);
 		if (ret < 0)
diff --git a/drivers/net/wireless/wl12xx/boot.h b/drivers/net/wireless/wl12xx/boot.h
index e8f8255..06dad93 100644
--- a/drivers/net/wireless/wl12xx/boot.h
+++ b/drivers/net/wireless/wl12xx/boot.h
@@ -55,7 +55,8 @@ struct wl1271_static_data {
 #define OCP_REG_CLK_POLARITY 0x0cb2
 #define OCP_REG_CLK_PULL     0x0cb4
 
-#define REG_FUSE_DATA_2_1    0x050a
+#define WL127X_REG_FUSE_DATA_2_1    0x050a
+#define WL128X_REG_FUSE_DATA_2_1    0x2152
 #define PG_VER_MASK          0x3c
 #define PG_VER_OFFSET        2
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 85b3385..d65fef6 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -4434,7 +4434,7 @@ static ssize_t wl1271_sysfs_show_hw_pg_ver(struct device *dev,
 	return len;
 }
 
-static DEVICE_ATTR(hw_pg_ver, S_IRUGO | S_IWUSR,
+static DEVICE_ATTR(hw_pg_ver, S_IRUGO,
 		   wl1271_sysfs_show_hw_pg_ver, NULL);
 
 static ssize_t wl1271_sysfs_read_fwlog(struct file *filp, struct kobject *kobj,
@@ -4848,6 +4848,10 @@ int wl1271_free_hw(struct wl1271 *wl)
 	mutex_unlock(&wl->mutex);
 
 	device_remove_bin_file(&wl->plat_dev->dev, &fwlog_attr);
+
+	device_remove_file(&wl->plat_dev->dev, &dev_attr_hw_pg_ver);
+
+	device_remove_file(&wl->plat_dev->dev, &dev_attr_bt_coex_state);
 	platform_device_unregister(wl->plat_dev);
 	free_page((unsigned long)wl->fwlog);
 	dev_kfree_skb(wl->dummy_packet);
-- 
1.7.0.4

