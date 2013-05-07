Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:58923 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758336Ab3EGNgO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 May 2013 09:36:14 -0400
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>, <arik@wizery.com>, <eliad@wizery.com>
Subject: [PATCH 1/2] wlcore: some non-functional clean-ups in main.c
Date: Tue, 7 May 2013 16:34:49 +0300
Message-ID: <1367933690-6169-1-git-send-email-coelho@ti.com> (sfid-20130507_153617_983864_9C1AC86E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove unnecessary includes; remove duplicate and useless defines; fix
copyright notice and remove some unnecessary line breaks.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/main.c |   30 ++++++------------------------
 1 file changed, 6 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 953111a..04074f7 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1,10 +1,9 @@
 
 /*
- * This file is part of wl1271
+ * This file is part of wlcore
  *
  * Copyright (C) 2008-2010 Nokia Corporation
- *
- * Contact: Luciano Coelho <luciano.coelho@nokia.com>
+ * Copyright (C) 2011-2013 Texas Instruments Inc.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -24,37 +23,25 @@
 
 #include <linux/module.h>
 #include <linux/firmware.h>
-#include <linux/delay.h>
-#include <linux/spi/spi.h>
-#include <linux/crc32.h>
 #include <linux/etherdevice.h>
 #include <linux/vmalloc.h>
-#include <linux/platform_device.h>
-#include <linux/slab.h>
 #include <linux/wl12xx.h>
-#include <linux/sched.h>
 #include <linux/interrupt.h>
 
 #include "wlcore.h"
 #include "debug.h"
 #include "wl12xx_80211.h"
 #include "io.h"
-#include "event.h"
 #include "tx.h"
-#include "rx.h"
 #include "ps.h"
 #include "init.h"
 #include "debugfs.h"
-#include "cmd.h"
-#include "boot.h"
 #include "testmode.h"
 #include "scan.h"
 #include "hw_ops.h"
 
 #define WL1271_BOOT_RETRIES 3
 
-#define WL1271_BOOT_RETRIES 3
-
 static char *fwlog_param;
 static int bug_on_recovery = -1;
 static int no_recovery     = -1;
@@ -65,8 +52,7 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 static void wlcore_op_stop_locked(struct wl1271 *wl);
 static void wl1271_free_ap_keys(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 
-static int wl12xx_set_authorized(struct wl1271 *wl,
-				 struct wl12xx_vif *wlvif)
+static int wl12xx_set_authorized(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	int ret;
 
@@ -1668,8 +1654,7 @@ static int wl1271_configure_suspend(struct wl1271 *wl,
 	return 0;
 }
 
-static void wl1271_configure_resume(struct wl1271 *wl,
-				    struct wl12xx_vif *wlvif)
+static void wl1271_configure_resume(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	int ret = 0;
 	bool is_ap = wlvif->bss_type == BSS_TYPE_AP_BSS;
@@ -3782,8 +3767,7 @@ static int wlcore_set_beacon_template(struct wl1271 *wl,
 	struct ieee80211_hdr *hdr;
 	u32 min_rate;
 	int ret;
-	int ieoffset = offsetof(struct ieee80211_mgmt,
-				u.beacon.variable);
+	int ieoffset = offsetof(struct ieee80211_mgmt, u.beacon.variable);
 	struct sk_buff *beacon = ieee80211_beacon_get(wl->hw, vif);
 	u16 tmpl_id;
 
@@ -5827,8 +5811,6 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 	return 0;
 }
 
-#define WL1271_DEFAULT_CHANNEL 0
-
 struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size,
 				     u32 mbox_size)
 {
@@ -5881,7 +5863,7 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size,
 		goto err_hw;
 	}
 
-	wl->channel = WL1271_DEFAULT_CHANNEL;
+	wl->channel = 0;
 	wl->rx_counter = 0;
 	wl->power_level = WL1271_DEFAULT_POWER_LEVEL;
 	wl->band = IEEE80211_BAND_2GHZ;
-- 
1.7.10.4

