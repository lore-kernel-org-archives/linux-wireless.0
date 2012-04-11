Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:49128 "EHLO
	psmtp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754765Ab2DKJi2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 05:38:28 -0400
Received: by lagr15 with SMTP id r15so594678lag.2
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 02:38:25 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, linville@tuxdriver.com, coelho@ti.com
Subject: [PATCH 11/16] wlcore/wl12xx: move MAC address reading operation to lower driver
Date: Wed, 11 Apr 2012 12:37:58 +0300
Message-Id: <1334137083-13490-12-git-send-email-coelho@ti.com> (sfid-20120411_113848_761825_C0B96542)
In-Reply-To: <1334137083-13490-1-git-send-email-coelho@ti.com>
References: <1334137083-13490-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Different chip families have the factory MAC address written in
different places.  Add a new hardware operation to read the MAC
address, if available.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |   52 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wlcore/main.c   |   52 +-----------------------------
 drivers/net/wireless/ti/wlcore/wlcore.h |    1 +
 3 files changed, 55 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index d235da2..cef2884 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -571,6 +571,51 @@ out:
 	return ret;
 }
 
+static bool wl12xx_mac_in_fuse(struct wl1271 *wl)
+{
+	bool supported = false;
+	u8 major, minor;
+
+	if (wl->chip.id == CHIP_ID_1283_PG20) {
+		major = WL128X_PG_GET_MAJOR(wl->hw_pg_ver);
+		minor = WL128X_PG_GET_MINOR(wl->hw_pg_ver);
+
+		/* in wl128x we have the MAC address if the PG is >= (2, 1) */
+		if (major > 2 || (major == 2 && minor >= 1))
+			supported = true;
+	} else {
+		major = WL127X_PG_GET_MAJOR(wl->hw_pg_ver);
+		minor = WL127X_PG_GET_MINOR(wl->hw_pg_ver);
+
+		/* in wl127x we have the MAC address if the PG is >= (3, 1) */
+		if (major == 3 && minor >= 1)
+			supported = true;
+	}
+
+	wl1271_debug(DEBUG_PROBE,
+		     "PG Ver major = %d minor = %d, MAC %s present",
+		     major, minor, supported ? "is" : "is not");
+
+	return supported;
+}
+
+static void wl12xx_get_fuse_mac(struct wl1271 *wl)
+{
+	u32 mac1, mac2;
+
+	wlcore_set_partition(wl, &wl->ptable[PART_DRPW]);
+
+	mac1 = wl1271_read32(wl, WL12XX_REG_FUSE_BD_ADDR_1);
+	mac2 = wl1271_read32(wl, WL12XX_REG_FUSE_BD_ADDR_2);
+
+	/* these are the two parts of the BD_ADDR */
+	wl->fuse_oui_addr = ((mac2 & 0xffff) << 8) +
+		((mac1 & 0xff000000) >> 24);
+	wl->fuse_nic_addr = mac1 & 0xffffff;
+
+	wlcore_set_partition(wl, &wl->ptable[PART_DOWN]);
+}
+
 static s8 wl12xx_get_pg_ver(struct wl1271 *wl)
 {
 	u32 die_info;
@@ -583,10 +628,17 @@ static s8 wl12xx_get_pg_ver(struct wl1271 *wl)
 	return (s8) (die_info & PG_VER_MASK) >> PG_VER_OFFSET;
 }
 
+static void wl12xx_get_mac(struct wl1271 *wl)
+{
+	if (wl12xx_mac_in_fuse(wl))
+		wl12xx_get_fuse_mac(wl);
+}
+
 static struct wlcore_ops wl12xx_ops = {
 	.identify_chip	= wl12xx_identify_chip,
 	.boot		= wl12xx_boot,
 	.get_pg_ver	= wl12xx_get_pg_ver,
+	.get_mac	= wl12xx_get_mac,
 };
 
 static int __devinit wl12xx_probe(struct platform_device *pdev)
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index f761a61..5a20292 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -50,9 +50,6 @@
 #include "testmode.h"
 #include "scan.h"
 
-/* TODO: remove this once the FUSE definitions are separated */
-#include "../wl12xx/reg.h"
-
 #define WL1271_BOOT_RETRIES 3
 
 static struct conf_drv_settings default_conf = {
@@ -4993,34 +4990,6 @@ static struct bin_attribute fwlog_attr = {
 	.read = wl1271_sysfs_read_fwlog,
 };
 
-static bool wl12xx_mac_in_fuse(struct wl1271 *wl)
-{
-	bool supported = false;
-	u8 major, minor;
-
-	if (wl->chip.id == CHIP_ID_1283_PG20) {
-		major = WL128X_PG_GET_MAJOR(wl->hw_pg_ver);
-		minor = WL128X_PG_GET_MINOR(wl->hw_pg_ver);
-
-		/* in wl128x we have the MAC address if the PG is >= (2, 1) */
-		if (major > 2 || (major == 2 && minor >= 1))
-			supported = true;
-	} else {
-		major = WL127X_PG_GET_MAJOR(wl->hw_pg_ver);
-		minor = WL127X_PG_GET_MINOR(wl->hw_pg_ver);
-
-		/* in wl127x we have the MAC address if the PG is >= (3, 1) */
-		if (major == 3 && minor >= 1)
-			supported = true;
-	}
-
-	wl1271_debug(DEBUG_PROBE,
-		     "PG Ver major = %d minor = %d, MAC %s present",
-		     major, minor, supported ? "is" : "is not");
-
-	return supported;
-}
-
 static void wl12xx_derive_mac_addresses(struct wl1271 *wl,
 					u32 oui, u32 nic, int n)
 {
@@ -5046,23 +5015,6 @@ static void wl12xx_derive_mac_addresses(struct wl1271 *wl,
 	wl->hw->wiphy->addresses = wl->addresses;
 }
 
-static void wl12xx_get_fuse_mac(struct wl1271 *wl)
-{
-	u32 mac1, mac2;
-
-	wlcore_set_partition(wl, &wl->ptable[PART_DRPW]);
-
-	mac1 = wl1271_read32(wl, WL12XX_REG_FUSE_BD_ADDR_1);
-	mac2 = wl1271_read32(wl, WL12XX_REG_FUSE_BD_ADDR_2);
-
-	/* these are the two parts of the BD_ADDR */
-	wl->fuse_oui_addr = ((mac2 & 0xffff) << 8) +
-		((mac1 & 0xff000000) >> 24);
-	wl->fuse_nic_addr = mac1 & 0xffffff;
-
-	wlcore_set_partition(wl, &wl->ptable[PART_DOWN]);
-}
-
 static int wl12xx_get_hw_info(struct wl1271 *wl)
 {
 	int ret;
@@ -5078,8 +5030,8 @@ static int wl12xx_get_hw_info(struct wl1271 *wl)
 
 	wl->hw_pg_ver = wl->ops->get_pg_ver(wl);
 
-	if (wl12xx_mac_in_fuse(wl))
-		wl12xx_get_fuse_mac(wl);
+	if (wl->ops->get_mac)
+		wl->ops->get_mac(wl);
 
 	wl1271_power_off(wl);
 out:
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index f2b18be..38d1ed2 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -31,6 +31,7 @@ struct wlcore_ops {
 	int (*identify_chip)(struct wl1271 *wl);
 	int (*boot)(struct wl1271 *wl);
 	s8 (*get_pg_ver)(struct wl1271 *wl);
+	void (*get_mac)(struct wl1271 *wl);
 };
 
 enum wlcore_partitions {
-- 
1.7.5.4

