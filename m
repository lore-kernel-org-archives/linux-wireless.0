Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:40125 "EHLO comal.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755690AbcHXLaC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Aug 2016 07:30:02 -0400
Received: from dflxv15.itg.ti.com ([128.247.5.124])
        by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id u7OBRuIN021175
        for <linux-wireless@vger.kernel.org>; Wed, 24 Aug 2016 06:27:56 -0500
Received: from DFLE72.ent.ti.com (dfle72.ent.ti.com [128.247.5.109])
        by dflxv15.itg.ti.com (8.14.3/8.13.8) with ESMTP id u7OBRtjt028199
        for <linux-wireless@vger.kernel.org>; Wed, 24 Aug 2016 06:27:55 -0500
From: Guy Mishol <guym@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: Guy Mishol <guym@ti.com>
Subject: [PATCH] wl18xx: add time sync configuration api
Date: Wed, 24 Aug 2016 14:35:27 +0300
Message-ID: <20160824113527.5040-1-guym@ti.com> (sfid-20160824_133006_291361_4B8BD023)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add time sync configuration api.
The new api allows to configure the synchronization
mode (STA/AP/MESH) and (in case of Mesh mode) the
master address of each zone.

Signed-off-by: Guy Mishol <guym@ti.com>
---
 drivers/net/wireless/ti/wl18xx/acx.c    | 29 +++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wl18xx/acx.h    | 13 +++++++++++++
 drivers/net/wireless/ti/wl18xx/event.c  |  1 +
 drivers/net/wireless/ti/wlcore/wlcore.h |  3 +++
 4 files changed, 46 insertions(+)

diff --git a/drivers/net/wireless/ti/wl18xx/acx.c b/drivers/net/wireless/ti/wl18xx/acx.c
index 4be0409..b5525a3 100644
--- a/drivers/net/wireless/ti/wl18xx/acx.c
+++ b/drivers/net/wireless/ti/wl18xx/acx.c
@@ -309,3 +309,32 @@ out:
 	kfree(acx);
 	return ret;
 }
+
+int wl18xx_acx_time_sync_cfg(struct wl1271 *wl)
+{
+	struct acx_time_sync_cfg *acx;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx time sync cfg: mode %d, addr: %pM",
+		     wl->conf.sg.params[WL18XX_CONF_SG_TIME_SYNC],
+		     wl->zone_master_mac_addr);
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	acx->sync_mode = wl->conf.sg.params[WL18XX_CONF_SG_TIME_SYNC];
+	memcpy(acx->zone_mac_addr, wl->zone_master_mac_addr, ETH_ALEN);
+
+	ret = wl1271_cmd_configure(wl, ACX_TIME_SYNC_CFG,
+				   acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("acx time sync cfg failed: %d", ret);
+		goto out;
+	}
+out:
+	kfree(acx);
+	return ret;
+}
diff --git a/drivers/net/wireless/ti/wl18xx/acx.h b/drivers/net/wireless/ti/wl18xx/acx.h
index 342a299..2edbbbf 100644
--- a/drivers/net/wireless/ti/wl18xx/acx.h
+++ b/drivers/net/wireless/ti/wl18xx/acx.h
@@ -37,6 +37,7 @@ enum {
 	ACX_RX_BA_FILTER		 = 0x0058,
 	ACX_AP_SLEEP_CFG                 = 0x0059,
 	ACX_DYNAMIC_TRACES_CFG		 = 0x005A,
+	ACX_TIME_SYNC_CFG		 = 0x005B,
 };
 
 /* numbers of bits the length field takes (add 1 for the actual number) */
@@ -388,6 +389,17 @@ struct acx_dynamic_fw_traces_cfg {
 	__le32 dynamic_fw_traces;
 } __packed;
 
+/*
+ * ACX_TIME_SYNC_CFG
+ * configure the time sync parameters
+ */
+struct acx_time_sync_cfg {
+	struct acx_header header;
+	u8 sync_mode;
+	u8 zone_mac_addr[ETH_ALEN];
+	u8 padding[1];
+} __packed;
+
 int wl18xx_acx_host_if_cfg_bitmap(struct wl1271 *wl, u32 host_cfg_bitmap,
 				  u32 sdio_blk_size, u32 extra_mem_blks,
 				  u32 len_field_size);
@@ -402,5 +414,6 @@ int wl18xx_acx_interrupt_notify_config(struct wl1271 *wl, bool action);
 int wl18xx_acx_rx_ba_filter(struct wl1271 *wl, bool action);
 int wl18xx_acx_ap_sleep(struct wl1271 *wl);
 int wl18xx_acx_dynamic_fw_traces(struct wl1271 *wl);
+int wl18xx_acx_time_sync_cfg(struct wl1271 *wl);
 
 #endif /* __WL18XX_ACX_H__ */
diff --git a/drivers/net/wireless/ti/wl18xx/event.c b/drivers/net/wireless/ti/wl18xx/event.c
index 2c5df43..b36ce18 100644
--- a/drivers/net/wireless/ti/wl18xx/event.c
+++ b/drivers/net/wireless/ti/wl18xx/event.c
@@ -22,6 +22,7 @@
 #include <net/genetlink.h>
 #include "event.h"
 #include "scan.h"
+#include "conf.h"
 #include "../wlcore/cmd.h"
 #include "../wlcore/debug.h"
 #include "../wlcore/vendor_cmd.h"
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 8f28aa0..1827546 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -501,6 +501,9 @@ struct wl1271 {
 
 	/* dynamic fw traces */
 	u32 dynamic_fw_traces;
+
+	/* time sync zone master */
+	u8 zone_master_mac_addr[ETH_ALEN];
 };
 
 int wlcore_probe(struct wl1271 *wl, struct platform_device *pdev);
-- 
2.6.4
