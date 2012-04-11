Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:38981 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754257Ab2DKJiW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 05:38:22 -0400
Received: by lahi5 with SMTP id i5so838209lah.39
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 02:38:18 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, linville@tuxdriver.com, coelho@ti.com
Subject: [PATCH 05/16] wl12xx/wlcore: move wl1271 struct to wlcore and add ops
Date: Wed, 11 Apr 2012 12:37:52 +0300
Message-Id: <1334137083-13490-6-git-send-email-coelho@ti.com> (sfid-20120411_113827_464792_CB06DCFD)
In-Reply-To: <1334137083-13490-1-git-send-email-coelho@ti.com>
References: <1334137083-13490-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to add chip-specific operations and prepare for future
elements that need to be set by the lower driver, move the wl1271
structure to the wlcore.h file and add an empty placeholder for the
operations structure.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c     |    4 +
 drivers/net/wireless/ti/wlcore/acx.c      |    2 +-
 drivers/net/wireless/ti/wlcore/acx.h      |    2 +-
 drivers/net/wireless/ti/wlcore/boot.h     |    2 +-
 drivers/net/wireless/ti/wlcore/cmd.c      |    2 +-
 drivers/net/wireless/ti/wlcore/cmd.h      |    2 +-
 drivers/net/wireless/ti/wlcore/debugfs.c  |    2 +-
 drivers/net/wireless/ti/wlcore/debugfs.h  |    2 +-
 drivers/net/wireless/ti/wlcore/event.c    |    2 +-
 drivers/net/wireless/ti/wlcore/init.h     |    2 +-
 drivers/net/wireless/ti/wlcore/io.c       |    2 +-
 drivers/net/wireless/ti/wlcore/main.c     |    7 +-
 drivers/net/wireless/ti/wlcore/ps.h       |    2 +-
 drivers/net/wireless/ti/wlcore/rx.c       |    2 +-
 drivers/net/wireless/ti/wlcore/scan.c     |    2 +-
 drivers/net/wireless/ti/wlcore/scan.h     |    2 +-
 drivers/net/wireless/ti/wlcore/sdio.c     |    2 +-
 drivers/net/wireless/ti/wlcore/spi.c      |    2 +-
 drivers/net/wireless/ti/wlcore/testmode.c |    2 +-
 drivers/net/wireless/ti/wlcore/tx.c       |    2 +-
 drivers/net/wireless/ti/wlcore/wl12xx.h   |  211 ---------------------------
 drivers/net/wireless/ti/wlcore/wlcore.h   |  219 +++++++++++++++++++++++++++++
 22 files changed, 247 insertions(+), 230 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index c4fc93f..0d30150 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -27,6 +27,9 @@
 #include "../wlcore/wlcore.h"
 #include "../wlcore/debug.h"
 
+static struct wlcore_ops wl12xx_ops = {
+};
+
 static int __devinit wl12xx_probe(struct platform_device *pdev)
 {
 	struct wl1271 *wl;
@@ -39,6 +42,7 @@ static int __devinit wl12xx_probe(struct platform_device *pdev)
 	}
 
 	wl = hw->priv;
+	wl->ops = &wl12xx_ops;
 
 	return wlcore_probe(wl, pdev);
 }
diff --git a/drivers/net/wireless/ti/wlcore/acx.c b/drivers/net/wireless/ti/wlcore/acx.c
index bc96db0..43cc6a2 100644
--- a/drivers/net/wireless/ti/wlcore/acx.c
+++ b/drivers/net/wireless/ti/wlcore/acx.c
@@ -28,7 +28,7 @@
 #include <linux/spi/spi.h>
 #include <linux/slab.h>
 
-#include "wl12xx.h"
+#include "wlcore.h"
 #include "debug.h"
 #include "wl12xx_80211.h"
 #include "reg.h"
diff --git a/drivers/net/wireless/ti/wlcore/acx.h b/drivers/net/wireless/ti/wlcore/acx.h
index a28fc04..e24511a 100644
--- a/drivers/net/wireless/ti/wlcore/acx.h
+++ b/drivers/net/wireless/ti/wlcore/acx.h
@@ -25,7 +25,7 @@
 #ifndef __ACX_H__
 #define __ACX_H__
 
-#include "wl12xx.h"
+#include "wlcore.h"
 #include "cmd.h"
 
 /*************************************************************************
diff --git a/drivers/net/wireless/ti/wlcore/boot.h b/drivers/net/wireless/ti/wlcore/boot.h
index c3adc09..a39e0e2 100644
--- a/drivers/net/wireless/ti/wlcore/boot.h
+++ b/drivers/net/wireless/ti/wlcore/boot.h
@@ -24,7 +24,7 @@
 #ifndef __BOOT_H__
 #define __BOOT_H__
 
-#include "wl12xx.h"
+#include "wlcore.h"
 
 int wl1271_boot(struct wl1271 *wl);
 int wl1271_load_firmware(struct wl1271 *wl);
diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 82cb90a..68e686f 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -28,7 +28,7 @@
 #include <linux/ieee80211.h>
 #include <linux/slab.h>
 
-#include "wl12xx.h"
+#include "wlcore.h"
 #include "debug.h"
 #include "reg.h"
 #include "io.h"
diff --git a/drivers/net/wireless/ti/wlcore/cmd.h b/drivers/net/wireless/ti/wlcore/cmd.h
index de217d9..58d2a8b 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.h
+++ b/drivers/net/wireless/ti/wlcore/cmd.h
@@ -25,7 +25,7 @@
 #ifndef __CMD_H__
 #define __CMD_H__
 
-#include "wl12xx.h"
+#include "wlcore.h"
 
 struct acx_header;
 
diff --git a/drivers/net/wireless/ti/wlcore/debugfs.c b/drivers/net/wireless/ti/wlcore/debugfs.c
index 564d495..9db0813 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.c
+++ b/drivers/net/wireless/ti/wlcore/debugfs.c
@@ -26,7 +26,7 @@
 #include <linux/skbuff.h>
 #include <linux/slab.h>
 
-#include "wl12xx.h"
+#include "wlcore.h"
 #include "debug.h"
 #include "acx.h"
 #include "ps.h"
diff --git a/drivers/net/wireless/ti/wlcore/debugfs.h b/drivers/net/wireless/ti/wlcore/debugfs.h
index 254c5b2..a8d3aef 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.h
+++ b/drivers/net/wireless/ti/wlcore/debugfs.h
@@ -24,7 +24,7 @@
 #ifndef __DEBUGFS_H__
 #define __DEBUGFS_H__
 
-#include "wl12xx.h"
+#include "wlcore.h"
 
 int wl1271_debugfs_init(struct wl1271 *wl);
 void wl1271_debugfs_exit(struct wl1271 *wl);
diff --git a/drivers/net/wireless/ti/wlcore/event.c b/drivers/net/wireless/ti/wlcore/event.c
index 96f06a8..8d79af9 100644
--- a/drivers/net/wireless/ti/wlcore/event.c
+++ b/drivers/net/wireless/ti/wlcore/event.c
@@ -21,7 +21,7 @@
  *
  */
 
-#include "wl12xx.h"
+#include "wlcore.h"
 #include "debug.h"
 #include "reg.h"
 #include "io.h"
diff --git a/drivers/net/wireless/ti/wlcore/init.h b/drivers/net/wireless/ti/wlcore/init.h
index 2da0f40..a45fbfd 100644
--- a/drivers/net/wireless/ti/wlcore/init.h
+++ b/drivers/net/wireless/ti/wlcore/init.h
@@ -24,7 +24,7 @@
 #ifndef __INIT_H__
 #define __INIT_H__
 
-#include "wl12xx.h"
+#include "wlcore.h"
 
 int wl1271_hw_init_power_auth(struct wl1271 *wl);
 int wl1271_init_templates_config(struct wl1271 *wl);
diff --git a/drivers/net/wireless/ti/wlcore/io.c b/drivers/net/wireless/ti/wlcore/io.c
index c574a3b..b0701fb 100644
--- a/drivers/net/wireless/ti/wlcore/io.c
+++ b/drivers/net/wireless/ti/wlcore/io.c
@@ -26,7 +26,7 @@
 #include <linux/spi/spi.h>
 #include <linux/interrupt.h>
 
-#include "wl12xx.h"
+#include "wlcore.h"
 #include "debug.h"
 #include "wl12xx_80211.h"
 #include "io.h"
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 3cbc774..194a8b0 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -35,7 +35,7 @@
 #include <linux/sched.h>
 #include <linux/interrupt.h>
 
-#include "wl12xx.h"
+#include "wlcore.h"
 #include "debug.h"
 #include "wl12xx_80211.h"
 #include "reg.h"
@@ -5485,6 +5485,11 @@ int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev)
 	unsigned long irqflags;
 	int ret;
 
+	if (!wl->ops) {
+		ret = -EINVAL;
+		goto out_free_hw;
+	}
+
 	wl->irq = platform_get_irq(pdev, 0);
 	wl->ref_clock = pdata->board_ref_clock;
 	wl->tcxo_clock = pdata->board_tcxo_clock;
diff --git a/drivers/net/wireless/ti/wlcore/ps.h b/drivers/net/wireless/ti/wlcore/ps.h
index 5f19d4f..de4f9da 100644
--- a/drivers/net/wireless/ti/wlcore/ps.h
+++ b/drivers/net/wireless/ti/wlcore/ps.h
@@ -24,7 +24,7 @@
 #ifndef __PS_H__
 #define __PS_H__
 
-#include "wl12xx.h"
+#include "wlcore.h"
 #include "acx.h"
 
 int wl1271_ps_set_mode(struct wl1271 *wl, struct wl12xx_vif *wlvif,
diff --git a/drivers/net/wireless/ti/wlcore/rx.c b/drivers/net/wireless/ti/wlcore/rx.c
index cfa6071..4fc37f9 100644
--- a/drivers/net/wireless/ti/wlcore/rx.c
+++ b/drivers/net/wireless/ti/wlcore/rx.c
@@ -24,7 +24,7 @@
 #include <linux/gfp.h>
 #include <linux/sched.h>
 
-#include "wl12xx.h"
+#include "wlcore.h"
 #include "debug.h"
 #include "acx.h"
 #include "reg.h"
diff --git a/drivers/net/wireless/ti/wlcore/scan.c b/drivers/net/wireless/ti/wlcore/scan.c
index a57f333..ade21a0 100644
--- a/drivers/net/wireless/ti/wlcore/scan.c
+++ b/drivers/net/wireless/ti/wlcore/scan.c
@@ -23,7 +23,7 @@
 
 #include <linux/ieee80211.h>
 
-#include "wl12xx.h"
+#include "wlcore.h"
 #include "debug.h"
 #include "cmd.h"
 #include "scan.h"
diff --git a/drivers/net/wireless/ti/wlcore/scan.h b/drivers/net/wireless/ti/wlcore/scan.h
index 2b300f4..81ee36a 100644
--- a/drivers/net/wireless/ti/wlcore/scan.h
+++ b/drivers/net/wireless/ti/wlcore/scan.h
@@ -24,7 +24,7 @@
 #ifndef __SCAN_H__
 #define __SCAN_H__
 
-#include "wl12xx.h"
+#include "wlcore.h"
 
 int wl1271_scan(struct wl1271 *wl, struct ieee80211_vif *vif,
 		const u8 *ssid, size_t ssid_len,
diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index 4b3c327..e407acf 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -33,7 +33,7 @@
 #include <linux/wl12xx.h>
 #include <linux/pm_runtime.h>
 
-#include "wl12xx.h"
+#include "wlcore.h"
 #include "wl12xx_80211.h"
 #include "io.h"
 
diff --git a/drivers/net/wireless/ti/wlcore/spi.c b/drivers/net/wireless/ti/wlcore/spi.c
index 2fc18a8..9eeb394 100644
--- a/drivers/net/wireless/ti/wlcore/spi.c
+++ b/drivers/net/wireless/ti/wlcore/spi.c
@@ -30,7 +30,7 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 
-#include "wl12xx.h"
+#include "wlcore.h"
 #include "wl12xx_80211.h"
 #include "io.h"
 
diff --git a/drivers/net/wireless/ti/wlcore/testmode.c b/drivers/net/wireless/ti/wlcore/testmode.c
index 1e93bb9..2ea4013 100644
--- a/drivers/net/wireless/ti/wlcore/testmode.c
+++ b/drivers/net/wireless/ti/wlcore/testmode.c
@@ -25,7 +25,7 @@
 #include <linux/slab.h>
 #include <net/genetlink.h>
 
-#include "wl12xx.h"
+#include "wlcore.h"
 #include "debug.h"
 #include "acx.h"
 #include "reg.h"
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 43ae491..83cb83c 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -25,7 +25,7 @@
 #include <linux/module.h>
 #include <linux/etherdevice.h>
 
-#include "wl12xx.h"
+#include "wlcore.h"
 #include "debug.h"
 #include "io.h"
 #include "reg.h"
diff --git a/drivers/net/wireless/ti/wlcore/wl12xx.h b/drivers/net/wireless/ti/wlcore/wl12xx.h
index 82802d1..37b2d64 100644
--- a/drivers/net/wireless/ti/wlcore/wl12xx.h
+++ b/drivers/net/wireless/ti/wlcore/wl12xx.h
@@ -34,7 +34,6 @@
 
 #include "conf.h"
 #include "ini.h"
-#include "event.h"
 
 #define WL127X_FW_NAME_MULTI "ti-connectivity/wl127x-fw-4-mr.bin"
 #define WL127X_FW_NAME_SINGLE "ti-connectivity/wl127x-fw-4-sr.bin"
@@ -293,216 +292,6 @@ struct wl1271_link {
 	u8 ba_bitmap;
 };
 
-struct wl1271 {
-	struct ieee80211_hw *hw;
-	bool mac80211_registered;
-
-	struct device *dev;
-
-	void *if_priv;
-
-	struct wl1271_if_operations *if_ops;
-
-	void (*set_power)(bool enable);
-	int irq;
-	int ref_clock;
-
-	spinlock_t wl_lock;
-
-	enum wl1271_state state;
-	enum wl12xx_fw_type fw_type;
-	bool plt;
-	u8 last_vif_count;
-	struct mutex mutex;
-
-	unsigned long flags;
-
-	struct wl1271_partition_set part;
-
-	struct wl1271_chip chip;
-
-	int cmd_box_addr;
-	int event_box_addr;
-
-	u8 *fw;
-	size_t fw_len;
-	void *nvs;
-	size_t nvs_len;
-
-	s8 hw_pg_ver;
-
-	/* address read from the fuse ROM */
-	u32 fuse_oui_addr;
-	u32 fuse_nic_addr;
-
-	/* we have up to 2 MAC addresses */
-	struct mac_address addresses[2];
-	int channel;
-	u8 system_hlid;
-
-	unsigned long links_map[BITS_TO_LONGS(WL12XX_MAX_LINKS)];
-	unsigned long roles_map[BITS_TO_LONGS(WL12XX_MAX_ROLES)];
-	unsigned long roc_map[BITS_TO_LONGS(WL12XX_MAX_ROLES)];
-	unsigned long rate_policies_map[
-			BITS_TO_LONGS(WL12XX_MAX_RATE_POLICIES)];
-
-	struct list_head wlvif_list;
-
-	u8 sta_count;
-	u8 ap_count;
-
-	struct wl1271_acx_mem_map *target_mem_map;
-
-	/* Accounting for allocated / available TX blocks on HW */
-	u32 tx_blocks_freed;
-	u32 tx_blocks_available;
-	u32 tx_allocated_blocks;
-	u32 tx_results_count;
-
-	/* amount of spare TX blocks to use */
-	u32 tx_spare_blocks;
-
-	/* Accounting for allocated / available Tx packets in HW */
-	u32 tx_pkts_freed[NUM_TX_QUEUES];
-	u32 tx_allocated_pkts[NUM_TX_QUEUES];
-
-	/* Transmitted TX packets counter for chipset interface */
-	u32 tx_packets_count;
-
-	/* Time-offset between host and chipset clocks */
-	s64 time_offset;
-
-	/* Frames scheduled for transmission, not handled yet */
-	int tx_queue_count[NUM_TX_QUEUES];
-	long stopped_queues_map;
-
-	/* Frames received, not handled yet by mac80211 */
-	struct sk_buff_head deferred_rx_queue;
-
-	/* Frames sent, not returned yet to mac80211 */
-	struct sk_buff_head deferred_tx_queue;
-
-	struct work_struct tx_work;
-	struct workqueue_struct *freezable_wq;
-
-	/* Pending TX frames */
-	unsigned long tx_frames_map[BITS_TO_LONGS(ACX_TX_DESCRIPTORS)];
-	struct sk_buff *tx_frames[ACX_TX_DESCRIPTORS];
-	int tx_frames_cnt;
-
-	/* FW Rx counter */
-	u32 rx_counter;
-
-	/* Rx memory pool address */
-	struct wl1271_rx_mem_pool_addr rx_mem_pool_addr;
-
-	/* Intermediate buffer, used for packet aggregation */
-	u8 *aggr_buf;
-
-	/* Reusable dummy packet template */
-	struct sk_buff *dummy_packet;
-
-	/* Network stack work  */
-	struct work_struct netstack_work;
-
-	/* FW log buffer */
-	u8 *fwlog;
-
-	/* Number of valid bytes in the FW log buffer */
-	ssize_t fwlog_size;
-
-	/* Sysfs FW log entry readers wait queue */
-	wait_queue_head_t fwlog_waitq;
-
-	/* Hardware recovery work */
-	struct work_struct recovery_work;
-
-	struct event_mailbox *mbox;
-
-	/* The mbox event mask */
-	u32 event_mask;
-
-	/* Mailbox pointers */
-	u32 mbox_ptr[2];
-
-	/* Are we currently scanning */
-	struct ieee80211_vif *scan_vif;
-	struct wl1271_scan scan;
-	struct delayed_work scan_complete_work;
-
-	bool sched_scanning;
-
-	/* The current band */
-	enum ieee80211_band band;
-
-	struct completion *elp_compl;
-	struct delayed_work elp_work;
-
-	/* in dBm */
-	int power_level;
-
-	struct wl1271_stats stats;
-
-	__le32 buffer_32;
-	u32 buffer_cmd;
-	u32 buffer_busyword[WL1271_BUSY_WORD_CNT];
-
-	struct wl12xx_fw_status *fw_status;
-	struct wl1271_tx_hw_res_if *tx_res_if;
-
-	/* Current chipset configuration */
-	struct conf_drv_settings conf;
-
-	bool sg_enabled;
-
-	bool enable_11a;
-
-	/* Most recently reported noise in dBm */
-	s8 noise;
-
-	/* bands supported by this instance of wl12xx */
-	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
-
-	int tcxo_clock;
-
-	/*
-	 * wowlan trigger was configured during suspend.
-	 * (currently, only "ANY" trigger is supported)
-	 */
-	bool wow_enabled;
-	bool irq_wake_enabled;
-
-	/*
-	 * AP-mode - links indexed by HLID. The global and broadcast links
-	 * are always active.
-	 */
-	struct wl1271_link links[WL12XX_MAX_LINKS];
-
-	/* AP-mode - a bitmap of links currently in PS mode according to FW */
-	u32 ap_fw_ps_map;
-
-	/* AP-mode - a bitmap of links currently in PS mode in mac80211 */
-	unsigned long ap_ps_map;
-
-	/* Quirks of specific hardware revisions */
-	unsigned int quirks;
-
-	/* Platform limitations */
-	unsigned int platform_quirks;
-
-	/* number of currently active RX BA sessions */
-	int ba_rx_session_count;
-
-	/* AP-mode - number of currently connected stations */
-	int active_sta_count;
-
-	/* last wlvif we transmitted from */
-	struct wl12xx_vif *last_wlvif;
-
-	/* work to fire when Tx is stuck */
-	struct delayed_work tx_watchdog_work;
-};
-
 struct wl1271_station {
 	u8 hlid;
 };
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 4cabf97..0bcc6ad 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -22,7 +22,226 @@
 #ifndef __WLCORE_H__
 #define __WLCORE_H__
 
+#include <linux/platform_device.h>
+
 #include "wl12xx.h"
+#include "event.h"
+
+struct wlcore_ops {
+};
+
+struct wl1271 {
+	struct ieee80211_hw *hw;
+	bool mac80211_registered;
+
+	struct device *dev;
+
+	void *if_priv;
+
+	struct wl1271_if_operations *if_ops;
+
+	void (*set_power)(bool enable);
+	int irq;
+	int ref_clock;
+
+	spinlock_t wl_lock;
+
+	enum wl1271_state state;
+	enum wl12xx_fw_type fw_type;
+	bool plt;
+	u8 last_vif_count;
+	struct mutex mutex;
+
+	unsigned long flags;
+
+	struct wl1271_partition_set part;
+
+	struct wl1271_chip chip;
+
+	int cmd_box_addr;
+	int event_box_addr;
+
+	u8 *fw;
+	size_t fw_len;
+	void *nvs;
+	size_t nvs_len;
+
+	s8 hw_pg_ver;
+
+	/* address read from the fuse ROM */
+	u32 fuse_oui_addr;
+	u32 fuse_nic_addr;
+
+	/* we have up to 2 MAC addresses */
+	struct mac_address addresses[2];
+	int channel;
+	u8 system_hlid;
+
+	unsigned long links_map[BITS_TO_LONGS(WL12XX_MAX_LINKS)];
+	unsigned long roles_map[BITS_TO_LONGS(WL12XX_MAX_ROLES)];
+	unsigned long roc_map[BITS_TO_LONGS(WL12XX_MAX_ROLES)];
+	unsigned long rate_policies_map[
+			BITS_TO_LONGS(WL12XX_MAX_RATE_POLICIES)];
+
+	struct list_head wlvif_list;
+
+	u8 sta_count;
+	u8 ap_count;
+
+	struct wl1271_acx_mem_map *target_mem_map;
+
+	/* Accounting for allocated / available TX blocks on HW */
+	u32 tx_blocks_freed;
+	u32 tx_blocks_available;
+	u32 tx_allocated_blocks;
+	u32 tx_results_count;
+
+	/* amount of spare TX blocks to use */
+	u32 tx_spare_blocks;
+
+	/* Accounting for allocated / available Tx packets in HW */
+	u32 tx_pkts_freed[NUM_TX_QUEUES];
+	u32 tx_allocated_pkts[NUM_TX_QUEUES];
+
+	/* Transmitted TX packets counter for chipset interface */
+	u32 tx_packets_count;
+
+	/* Time-offset between host and chipset clocks */
+	s64 time_offset;
+
+	/* Frames scheduled for transmission, not handled yet */
+	int tx_queue_count[NUM_TX_QUEUES];
+	long stopped_queues_map;
+
+	/* Frames received, not handled yet by mac80211 */
+	struct sk_buff_head deferred_rx_queue;
+
+	/* Frames sent, not returned yet to mac80211 */
+	struct sk_buff_head deferred_tx_queue;
+
+	struct work_struct tx_work;
+	struct workqueue_struct *freezable_wq;
+
+	/* Pending TX frames */
+	unsigned long tx_frames_map[BITS_TO_LONGS(ACX_TX_DESCRIPTORS)];
+	struct sk_buff *tx_frames[ACX_TX_DESCRIPTORS];
+	int tx_frames_cnt;
+
+	/* FW Rx counter */
+	u32 rx_counter;
+
+	/* Rx memory pool address */
+	struct wl1271_rx_mem_pool_addr rx_mem_pool_addr;
+
+	/* Intermediate buffer, used for packet aggregation */
+	u8 *aggr_buf;
+
+	/* Reusable dummy packet template */
+	struct sk_buff *dummy_packet;
+
+	/* Network stack work  */
+	struct work_struct netstack_work;
+
+	/* FW log buffer */
+	u8 *fwlog;
+
+	/* Number of valid bytes in the FW log buffer */
+	ssize_t fwlog_size;
+
+	/* Sysfs FW log entry readers wait queue */
+	wait_queue_head_t fwlog_waitq;
+
+	/* Hardware recovery work */
+	struct work_struct recovery_work;
+
+	/* Pointer that holds DMA-friendly block for the mailbox */
+	struct event_mailbox *mbox;
+
+	/* The mbox event mask */
+	u32 event_mask;
+
+	/* Mailbox pointers */
+	u32 mbox_ptr[2];
+
+	/* Are we currently scanning */
+	struct ieee80211_vif *scan_vif;
+	struct wl1271_scan scan;
+	struct delayed_work scan_complete_work;
+
+	bool sched_scanning;
+
+	/* The current band */
+	enum ieee80211_band band;
+
+	struct completion *elp_compl;
+	struct delayed_work elp_work;
+
+	/* in dBm */
+	int power_level;
+
+	struct wl1271_stats stats;
+
+	__le32 buffer_32;
+	u32 buffer_cmd;
+	u32 buffer_busyword[WL1271_BUSY_WORD_CNT];
+
+	struct wl12xx_fw_status *fw_status;
+	struct wl1271_tx_hw_res_if *tx_res_if;
+
+	/* Current chipset configuration */
+	struct conf_drv_settings conf;
+
+	bool sg_enabled;
+
+	bool enable_11a;
+
+	/* Most recently reported noise in dBm */
+	s8 noise;
+
+	/* bands supported by this instance of wl12xx */
+	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
+
+	int tcxo_clock;
+
+	/*
+	 * wowlan trigger was configured during suspend.
+	 * (currently, only "ANY" trigger is supported)
+	 */
+	bool wow_enabled;
+	bool irq_wake_enabled;
+
+	/*
+	 * AP-mode - links indexed by HLID. The global and broadcast links
+	 * are always active.
+	 */
+	struct wl1271_link links[WL12XX_MAX_LINKS];
+
+	/* AP-mode - a bitmap of links currently in PS mode according to FW */
+	u32 ap_fw_ps_map;
+
+	/* AP-mode - a bitmap of links currently in PS mode in mac80211 */
+	unsigned long ap_ps_map;
+
+	/* Quirks of specific hardware revisions */
+	unsigned int quirks;
+
+	/* Platform limitations */
+	unsigned int platform_quirks;
+
+	/* number of currently active RX BA sessions */
+	int ba_rx_session_count;
+
+	/* AP-mode - number of currently connected stations */
+	int active_sta_count;
+
+	/* last wlvif we transmitted from */
+	struct wl12xx_vif *last_wlvif;
+
+	/* work to fire when Tx is stuck */
+	struct delayed_work tx_watchdog_work;
+
+	struct wlcore_ops *ops;
+};
 
 int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev);
 int __devexit wlcore_remove(struct platform_device *pdev);
-- 
1.7.5.4

