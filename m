Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:52212 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751974Ab1GRLWi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2011 07:22:38 -0400
Received: by mail-wy0-f177.google.com with SMTP id 23so2331472wyf.8
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jul 2011 04:22:36 -0700 (PDT)
From: Gery Kahn <geryk@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Kalle Valo <kvalo@adurom.com>
Subject: [PATCH] wl12xx: fixes for hw_pg_ver and chip id reporting
Date: Mon, 18 Jul 2011 14:21:49 +0300
Message-Id: <1310988109-13729-1-git-send-email-geryk@ti.com> (sfid-20110718_132241_425659_29FB9659)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix the value of PG version for 128x at sysfs, remove write permissions
from PG version (hw_pg_ver) in sysfs and add remove files
(hw_pg_ver,bt_coex_state) from sysfs while freeing hardware.
New macro names for register Fuse_data_2_1 depend on architecture.
Propagate chip id through wiphy in PLT mode which still not work of
a bug in ethtool.


Signed-off-by: Gery Kahn <geryk@ti.com>
---
The patch replacing the other patch "wl12xx: Fix for PG version and sysfs files"

 drivers/net/wireless/wl12xx/boot.c |   13 ++++++++-----
 drivers/net/wireless/wl12xx/boot.h |    3 ++-
 drivers/net/wireless/wl12xx/main.c |   12 +++++++++++-
 3 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index 5ebc64d..a816f2f 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -549,13 +549,13 @@ static void wl1271_boot_hw_version(struct wl1271 *wl)
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
@@ -696,7 +696,8 @@ static int wl127x_boot_clk(struct wl1271 *wl)
 	u32 pause;
 	u32 clk;
 
-	wl1271_boot_hw_version(wl);
+	if (((wl->hw_pg_ver & PG_MAJOR_VER_MASK) >> PG_MAJOR_VER_OFFSET) < 3)
+		wl->quirks |= WL12XX_QUIRK_END_OF_TRANSACTION;
 
 	if (wl->ref_clock == CONF_REF_CLK_19_2_E ||
 	    wl->ref_clock == CONF_REF_CLK_38_4_E ||
@@ -750,6 +751,8 @@ int wl1271_load_firmware(struct wl1271 *wl)
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
index e58c22d..1bed104 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1395,6 +1395,7 @@ out:
 int wl1271_plt_start(struct wl1271 *wl)
 {
 	int retries = WL1271_BOOT_RETRIES;
+	struct wiphy *wiphy = wl->hw->wiphy;
 	int ret;
 
 	mutex_lock(&wl->mutex);
@@ -1428,6 +1429,11 @@ int wl1271_plt_start(struct wl1271 *wl)
 		wl1271_notice("firmware booted in PLT mode (%s)",
 			      wl->chip.fw_ver_str);
 
+		/* update hw/fw version info in wiphy struct */
+		wiphy->hw_version = wl->chip.id;
+		strncpy(wiphy->fw_version, wl->chip.fw_ver_str,
+			sizeof(wiphy->fw_version));
+
 		goto out;
 
 irq_disable:
@@ -4126,7 +4132,7 @@ static ssize_t wl1271_sysfs_show_hw_pg_ver(struct device *dev,
 	return len;
 }
 
-static DEVICE_ATTR(hw_pg_ver, S_IRUGO | S_IWUSR,
+static DEVICE_ATTR(hw_pg_ver, S_IRUGO,
 		   wl1271_sysfs_show_hw_pg_ver, NULL);
 
 static ssize_t wl1271_sysfs_read_fwlog(struct file *filp, struct kobject *kobj,
@@ -4522,6 +4528,10 @@ int wl1271_free_hw(struct wl1271 *wl)
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

