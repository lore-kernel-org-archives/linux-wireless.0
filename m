Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:48096 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754178Ab2DKJiZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 05:38:25 -0400
Received: by lboj14 with SMTP id j14so625147lbo.36
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 02:38:23 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, linville@tuxdriver.com, coelho@ti.com
Subject: [PATCH 09/16] wlcore/wl12xx: move get_pg_ver to the lower driver
Date: Wed, 11 Apr 2012 12:37:56 +0300
Message-Id: <1334137083-13490-10-git-send-email-coelho@ti.com> (sfid-20120411_113841_429838_DF835343)
In-Reply-To: <1334137083-13490-1-git-send-email-coelho@ti.com>
References: <1334137083-13490-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The PG version depends on the actual hardware.  This commit moves the
code used to read the PG version to the lower driver, by adding the
get_pg_ver hardware operation.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |   14 ++++++++++++++
 drivers/net/wireless/ti/wlcore/io.c     |    1 +
 drivers/net/wireless/ti/wlcore/main.c   |   12 +-----------
 drivers/net/wireless/ti/wlcore/wlcore.h |    1 +
 4 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 83ed48d..880615f 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -26,6 +26,7 @@
 
 #include "../wlcore/wlcore.h"
 #include "../wlcore/debug.h"
+#include "../wlcore/io.h"
 
 #include "reg.h"
 
@@ -180,8 +181,21 @@ out:
 	return ret;
 }
 
+static s8 wl12xx_get_pg_ver(struct wl1271 *wl)
+{
+	u32 die_info;
+
+	if (wl->chip.id == CHIP_ID_1283_PG20)
+		die_info = wl1271_top_reg_read(wl, WL128X_REG_FUSE_DATA_2_1);
+	else
+		die_info = wl1271_top_reg_read(wl, WL127X_REG_FUSE_DATA_2_1);
+
+	return (s8) (die_info & PG_VER_MASK) >> PG_VER_OFFSET;
+}
+
 static struct wlcore_ops wl12xx_ops = {
 	.identify_chip = wl12xx_identify_chip,
+	.get_pg_ver     = wl12xx_get_pg_ver,
 };
 
 static int __devinit wl12xx_probe(struct platform_device *pdev)
diff --git a/drivers/net/wireless/ti/wlcore/io.c b/drivers/net/wireless/ti/wlcore/io.c
index 30c60e3..08cfa39 100644
--- a/drivers/net/wireless/ti/wlcore/io.c
+++ b/drivers/net/wireless/ti/wlcore/io.c
@@ -219,3 +219,4 @@ u16 wl1271_top_reg_read(struct wl1271 *wl, int addr)
 		return 0xffff;
 	}
 }
+EXPORT_SYMBOL_GPL(wl1271_top_reg_read);
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 95d2471..20f3d22 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5066,7 +5066,6 @@ static void wl12xx_get_fuse_mac(struct wl1271 *wl)
 static int wl12xx_get_hw_info(struct wl1271 *wl)
 {
 	int ret;
-	u32 die_info;
 
 	ret = wl12xx_set_power_on(wl);
 	if (ret < 0)
@@ -5077,20 +5076,11 @@ static int wl12xx_get_hw_info(struct wl1271 *wl)
 	wl->fuse_oui_addr = 0;
 	wl->fuse_nic_addr = 0;
 
-	/* TODO: properly detect PG ver and read MAC addr in other families */
-	if (wl->chip.id == CHIP_ID_1283_PG20)
-		die_info = wl1271_top_reg_read(wl, WL128X_REG_FUSE_DATA_2_1);
-	else if (wl->chip.id < CHIP_ID_1283_PG20)
-		die_info = wl1271_top_reg_read(wl, WL127X_REG_FUSE_DATA_2_1);
-	else
-		goto skip_mac;
-
-	wl->hw_pg_ver = (s8) (die_info & PG_VER_MASK) >> PG_VER_OFFSET;
+	wl->hw_pg_ver = wl->ops->get_pg_ver(wl);
 
 	if (wl12xx_mac_in_fuse(wl))
 		wl12xx_get_fuse_mac(wl);
 
-skip_mac:
 	wl1271_power_off(wl);
 out:
 	return ret;
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 92455e9..f49e035 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -29,6 +29,7 @@
 
 struct wlcore_ops {
 	int (*identify_chip)(struct wl1271 *wl);
+	s8 (*get_pg_ver)(struct wl1271 *wl);
 };
 
 enum wlcore_partitions {
-- 
1.7.5.4

