Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36869 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757119Ab2KVTdo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 14:33:44 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so3059175eek.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2012 11:33:43 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 08/13] wlcore: update events enum/struct to new fw api
Date: Thu, 22 Nov 2012 14:05:23 +0200
Message-Id: <1353585928-28666-9-git-send-email-eliad@wizery.com> (sfid-20121122_203355_175851_2817D160)
In-Reply-To: <1353585928-28666-1-git-send-email-eliad@wizery.com>
References: <1353585928-28666-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The event mailbox in wl18xx has a different
(non-compatible) structure.

Create common functions in wlcore to handle the
events, and call them from the chip-specific
event mailbox parsers.

This way, each driver (wl12xx/wl18xx) extracts
the event mailbox by itself according to its
own structure, and then calls the common
wlcore functions to handle it.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/Makefile   |    2 +-
 drivers/net/wireless/ti/wl12xx/event.c    |  112 ++++++++++
 drivers/net/wireless/ti/wl12xx/event.h    |  111 ++++++++++
 drivers/net/wireless/ti/wl12xx/main.c     |   24 ++-
 drivers/net/wireless/ti/wl18xx/Makefile   |    2 +-
 drivers/net/wireless/ti/wl18xx/event.c    |   99 +++++++++
 drivers/net/wireless/ti/wl18xx/event.h    |   76 +++++++
 drivers/net/wireless/ti/wl18xx/main.c     |   19 ++-
 drivers/net/wireless/ti/wlcore/boot.c     |   19 +--
 drivers/net/wireless/ti/wlcore/cmd.c      |   44 +---
 drivers/net/wireless/ti/wlcore/cmd.h      |    2 +
 drivers/net/wireless/ti/wlcore/event.c    |  338 +++++++++++++----------------
 drivers/net/wireless/ti/wlcore/event.h    |  100 ++-------
 drivers/net/wireless/ti/wlcore/main.c     |  133 ++++++++----
 drivers/net/wireless/ti/wlcore/scan.c     |    8 +-
 drivers/net/wireless/ti/wlcore/wlcore.h   |   15 +-
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    3 +
 17 files changed, 735 insertions(+), 372 deletions(-)
 create mode 100644 drivers/net/wireless/ti/wl12xx/event.c
 create mode 100644 drivers/net/wireless/ti/wl12xx/event.h
 create mode 100644 drivers/net/wireless/ti/wl18xx/event.c
 create mode 100644 drivers/net/wireless/ti/wl18xx/event.h

diff --git a/drivers/net/wireless/ti/wl12xx/Makefile b/drivers/net/wireless/ti/wl12xx/Makefile
index 8d9afd2..e6a2405 100644
--- a/drivers/net/wireless/ti/wl12xx/Makefile
+++ b/drivers/net/wireless/ti/wl12xx/Makefile
@@ -1,3 +1,3 @@
-wl12xx-objs	= main.o cmd.o acx.o debugfs.o scan.o
+wl12xx-objs	= main.o cmd.o acx.o debugfs.o scan.o event.o
 
 obj-$(CONFIG_WL12XX)		+= wl12xx.o
diff --git a/drivers/net/wireless/ti/wl12xx/event.c b/drivers/net/wireless/ti/wl12xx/event.c
new file mode 100644
index 0000000..6437dac
--- /dev/null
+++ b/drivers/net/wireless/ti/wl12xx/event.c
@@ -0,0 +1,112 @@
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (C) 2012 Texas Instruments. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include "event.h"
+#include "scan.h"
+#include "../wlcore/cmd.h"
+#include "../wlcore/debug.h"
+
+int wl12xx_wait_for_event(struct wl1271 *wl, enum wlcore_wait_event event,
+			  bool *timeout)
+{
+	u32 local_event;
+
+	switch (event) {
+	case WLCORE_EVENT_ROLE_STOP_COMPLETE:
+		local_event = ROLE_STOP_COMPLETE_EVENT_ID;
+		break;
+
+	case WLCORE_EVENT_PEER_REMOVE_COMPLETE:
+		local_event = PEER_REMOVE_COMPLETE_EVENT_ID;
+		break;
+
+	default:
+		/* event not implemented */
+		return 0;
+	}
+	return wlcore_cmd_wait_for_event_or_timeout(wl, local_event, timeout);
+}
+
+int wl12xx_process_mailbox_events(struct wl1271 *wl)
+{
+	struct wl12xx_event_mailbox *mbox = wl->mbox;
+	u32 vector;
+
+
+	vector = le32_to_cpu(mbox->events_vector);
+	vector &= ~(le32_to_cpu(mbox->events_mask));
+
+	wl1271_debug(DEBUG_EVENT, "MBOX vector: 0x%x", vector);
+
+	if (vector & SCAN_COMPLETE_EVENT_ID) {
+		wl1271_debug(DEBUG_EVENT, "status: 0x%x",
+			     mbox->scheduled_scan_status);
+
+		if (wl->scan_wlvif)
+			wl12xx_scan_completed(wl, wl->scan_wlvif);
+	}
+
+	if (vector & PERIODIC_SCAN_REPORT_EVENT_ID)
+		wlcore_event_sched_scan_report(wl,
+					       mbox->scheduled_scan_status);
+
+	if (vector & PERIODIC_SCAN_COMPLETE_EVENT_ID)
+		wlcore_event_sched_scan_completed(wl,
+						  mbox->scheduled_scan_status);
+	if (vector & SOFT_GEMINI_SENSE_EVENT_ID)
+		wlcore_event_soft_gemini_sense(wl,
+					       mbox->soft_gemini_sense_info);
+
+	if (vector & BSS_LOSE_EVENT_ID)
+		wlcore_event_beacon_loss(wl, 0xff);
+
+	if (vector & RSSI_SNR_TRIGGER_0_EVENT_ID)
+		wlcore_event_rssi_trigger(wl, mbox->rssi_snr_trigger_metric);
+
+	if (vector & BA_SESSION_RX_CONSTRAINT_EVENT_ID)
+		wlcore_event_ba_rx_constraint(wl,
+					      BIT(mbox->role_id),
+					      mbox->rx_ba_allowed);
+
+	if (vector & CHANNEL_SWITCH_COMPLETE_EVENT_ID)
+		wlcore_event_channel_switch(wl, 0xff,
+					    mbox->channel_switch_status);
+
+	if (vector & DUMMY_PACKET_EVENT_ID)
+		wlcore_event_dummy_packet(wl);
+
+	/*
+	 * "TX retries exceeded" has a different meaning according to mode.
+	 * In AP mode the offending station is disconnected.
+	 */
+	if (vector & MAX_TX_RETRY_EVENT_ID)
+		wlcore_event_max_tx_failure(wl,
+				le16_to_cpu(mbox->sta_tx_retry_exceeded));
+
+	if (vector & INACTIVE_STA_EVENT_ID)
+		wlcore_event_inactive_sta(wl,
+					  le16_to_cpu(mbox->sta_aging_status));
+
+	if (vector & REMAIN_ON_CHANNEL_COMPLETE_EVENT_ID)
+		wlcore_event_roc_complete(wl);
+
+	return 0;
+}
diff --git a/drivers/net/wireless/ti/wl12xx/event.h b/drivers/net/wireless/ti/wl12xx/event.h
new file mode 100644
index 0000000..a5cc3fc
--- /dev/null
+++ b/drivers/net/wireless/ti/wl12xx/event.h
@@ -0,0 +1,111 @@
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (C) 2012 Texas Instruments. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __WL12XX_EVENT_H__
+#define __WL12XX_EVENT_H__
+
+#include "../wlcore/wlcore.h"
+
+enum {
+	MEASUREMENT_START_EVENT_ID		 = BIT(8),
+	MEASUREMENT_COMPLETE_EVENT_ID		 = BIT(9),
+	SCAN_COMPLETE_EVENT_ID			 = BIT(10),
+	WFD_DISCOVERY_COMPLETE_EVENT_ID		 = BIT(11),
+	AP_DISCOVERY_COMPLETE_EVENT_ID		 = BIT(12),
+	RESERVED1			         = BIT(13),
+	PSPOLL_DELIVERY_FAILURE_EVENT_ID	 = BIT(14),
+	ROLE_STOP_COMPLETE_EVENT_ID		 = BIT(15),
+	RADAR_DETECTED_EVENT_ID                  = BIT(16),
+	CHANNEL_SWITCH_COMPLETE_EVENT_ID	 = BIT(17),
+	BSS_LOSE_EVENT_ID			 = BIT(18),
+	REGAINED_BSS_EVENT_ID			 = BIT(19),
+	MAX_TX_RETRY_EVENT_ID			 = BIT(20),
+	DUMMY_PACKET_EVENT_ID			 = BIT(21),
+	SOFT_GEMINI_SENSE_EVENT_ID		 = BIT(22),
+	CHANGE_AUTO_MODE_TIMEOUT_EVENT_ID	 = BIT(23),
+	SOFT_GEMINI_AVALANCHE_EVENT_ID		 = BIT(24),
+	PLT_RX_CALIBRATION_COMPLETE_EVENT_ID	 = BIT(25),
+	INACTIVE_STA_EVENT_ID			 = BIT(26),
+	PEER_REMOVE_COMPLETE_EVENT_ID		 = BIT(27),
+	PERIODIC_SCAN_COMPLETE_EVENT_ID		 = BIT(28),
+	PERIODIC_SCAN_REPORT_EVENT_ID		 = BIT(29),
+	BA_SESSION_RX_CONSTRAINT_EVENT_ID	 = BIT(30),
+	REMAIN_ON_CHANNEL_COMPLETE_EVENT_ID	 = BIT(31),
+};
+
+struct wl12xx_event_mailbox {
+	__le32 events_vector;
+	__le32 events_mask;
+	__le32 reserved_1;
+	__le32 reserved_2;
+
+	u8 number_of_scan_results;
+	u8 scan_tag;
+	u8 completed_scan_status;
+	u8 reserved_3;
+
+	u8 soft_gemini_sense_info;
+	u8 soft_gemini_protective_info;
+	s8 rssi_snr_trigger_metric[NUM_OF_RSSI_SNR_TRIGGERS];
+	u8 change_auto_mode_timeout;
+	u8 scheduled_scan_status;
+	u8 reserved4;
+	/* tuned channel (roc) */
+	u8 roc_channel;
+
+	__le16 hlid_removed_bitmap;
+
+	/* bitmap of aged stations (by HLID) */
+	__le16 sta_aging_status;
+
+	/* bitmap of stations (by HLID) which exceeded max tx retries */
+	__le16 sta_tx_retry_exceeded;
+
+	/* discovery completed results */
+	u8 discovery_tag;
+	u8 number_of_preq_results;
+	u8 number_of_prsp_results;
+	u8 reserved_5;
+
+	/* rx ba constraint */
+	u8 role_id; /* 0xFF means any role. */
+	u8 rx_ba_allowed;
+	u8 reserved_6[2];
+
+	/* Channel switch results */
+
+	u8 channel_switch_role_id;
+	u8 channel_switch_status;
+	u8 reserved_7[2];
+
+	u8 ps_poll_delivery_failure_role_ids;
+	u8 stopped_role_ids;
+	u8 started_role_ids;
+
+	u8 reserved_8[9];
+} __packed;
+
+int wl12xx_wait_for_event(struct wl1271 *wl, enum wlcore_wait_event event,
+			  bool *timeout);
+int wl12xx_process_mailbox_events(struct wl1271 *wl);
+
+#endif
+
diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index b93de04..7138fe4 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -39,6 +39,7 @@
 #include "cmd.h"
 #include "acx.h"
 #include "scan.h"
+#include "event.h"
 #include "debugfs.h"
 
 static char *fref_param;
@@ -1229,6 +1230,23 @@ static int wl12xx_boot(struct wl1271 *wl)
 	if (ret < 0)
 		goto out;
 
+	wl->event_mask = BSS_LOSE_EVENT_ID |
+		REGAINED_BSS_EVENT_ID |
+		SCAN_COMPLETE_EVENT_ID |
+		ROLE_STOP_COMPLETE_EVENT_ID |
+		RSSI_SNR_TRIGGER_0_EVENT_ID |
+		PSPOLL_DELIVERY_FAILURE_EVENT_ID |
+		SOFT_GEMINI_SENSE_EVENT_ID |
+		PERIODIC_SCAN_REPORT_EVENT_ID |
+		PERIODIC_SCAN_COMPLETE_EVENT_ID |
+		DUMMY_PACKET_EVENT_ID |
+		PEER_REMOVE_COMPLETE_EVENT_ID |
+		BA_SESSION_RX_CONSTRAINT_EVENT_ID |
+		REMAIN_ON_CHANNEL_COMPLETE_EVENT_ID |
+		INACTIVE_STA_EVENT_ID |
+		MAX_TX_RETRY_EVENT_ID |
+		CHANNEL_SWITCH_COMPLETE_EVENT_ID;
+
 	ret = wlcore_boot_run_firmware(wl);
 	if (ret < 0)
 		goto out;
@@ -1609,6 +1627,8 @@ static struct wlcore_ops wl12xx_ops = {
 	.plt_init		= wl12xx_plt_init,
 	.trigger_cmd		= wl12xx_trigger_cmd,
 	.ack_event		= wl12xx_ack_event,
+	.wait_for_event		= wl12xx_wait_for_event,
+	.process_mailbox_events	= wl12xx_process_mailbox_events,
 	.calc_tx_blocks		= wl12xx_calc_tx_blocks,
 	.set_tx_desc_blocks	= wl12xx_set_tx_desc_blocks,
 	.set_tx_desc_data_len	= wl12xx_set_tx_desc_data_len,
@@ -1627,7 +1647,6 @@ static struct wlcore_ops wl12xx_ops = {
 	.debugfs_init		= wl12xx_debugfs_add_files,
 	.scan_start		= wl12xx_scan_start,
 	.scan_stop		= wl12xx_scan_stop,
-	.scan_completed		= wl12xx_scan_completed,
 	.sched_scan_start	= wl12xx_sched_scan_start,
 	.sched_scan_stop	= wl12xx_scan_sched_scan_stop,
 	.get_spare_blocks	= wl12xx_get_spare_blocks,
@@ -1719,7 +1738,8 @@ static int __devinit wl12xx_probe(struct platform_device *pdev)
 	int ret;
 
 	hw = wlcore_alloc_hw(sizeof(struct wl12xx_priv),
-			     WL12XX_AGGR_BUFFER_SIZE);
+			     WL12XX_AGGR_BUFFER_SIZE,
+			     sizeof(struct wl12xx_event_mailbox));
 	if (IS_ERR(hw)) {
 		wl1271_error("can't allocate hw");
 		ret = PTR_ERR(hw);
diff --git a/drivers/net/wireless/ti/wl18xx/Makefile b/drivers/net/wireless/ti/wl18xx/Makefile
index 81a864f..ae2b817 100644
--- a/drivers/net/wireless/ti/wl18xx/Makefile
+++ b/drivers/net/wireless/ti/wl18xx/Makefile
@@ -1,3 +1,3 @@
-wl18xx-objs	= main.o acx.o tx.o io.o debugfs.o scan.o cmd.o
+wl18xx-objs	= main.o acx.o tx.o io.o debugfs.o scan.o cmd.o event.o
 
 obj-$(CONFIG_WL18XX)		+= wl18xx.o
diff --git a/drivers/net/wireless/ti/wl18xx/event.c b/drivers/net/wireless/ti/wl18xx/event.c
new file mode 100644
index 0000000..bf4233c
--- /dev/null
+++ b/drivers/net/wireless/ti/wl18xx/event.c
@@ -0,0 +1,99 @@
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (C) 2012 Texas Instruments. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include "event.h"
+#include "scan.h"
+#include "../wlcore/cmd.h"
+#include "../wlcore/debug.h"
+
+int wl18xx_wait_for_event(struct wl1271 *wl, enum wlcore_wait_event event,
+			  bool *timeout)
+{
+	u32 local_event;
+
+	switch (event) {
+	case WLCORE_EVENT_PEER_REMOVE_COMPLETE:
+		local_event = PEER_REMOVE_COMPLETE_EVENT_ID;
+		break;
+
+	default:
+		/* event not implemented */
+		return 0;
+	}
+	return wlcore_cmd_wait_for_event_or_timeout(wl, local_event, timeout);
+}
+
+int wl18xx_process_mailbox_events(struct wl1271 *wl)
+{
+	struct wl18xx_event_mailbox *mbox = wl->mbox;
+	u32 vector;
+
+	vector = le32_to_cpu(mbox->events_vector);
+	wl1271_debug(DEBUG_EVENT, "MBOX vector: 0x%x", vector);
+
+	if (vector & SCAN_COMPLETE_EVENT_ID) {
+		wl1271_debug(DEBUG_EVENT, "scan results: %d",
+			     mbox->number_of_scan_results);
+
+		if (wl->scan_wlvif)
+			wl18xx_scan_completed(wl, wl->scan_wlvif);
+	}
+
+	if (vector & PERIODIC_SCAN_COMPLETE_EVENT_ID)
+		wlcore_event_sched_scan_completed(wl, 1);
+
+	if (vector & RSSI_SNR_TRIGGER_0_EVENT_ID)
+		wlcore_event_rssi_trigger(wl, mbox->rssi_snr_trigger_metric);
+
+	if (vector & BA_SESSION_RX_CONSTRAINT_EVENT_ID)
+		wlcore_event_ba_rx_constraint(wl,
+				le16_to_cpu(mbox->rx_ba_role_id_bitmap),
+				le16_to_cpu(mbox->rx_ba_allowed_bitmap));
+
+	if (vector & BSS_LOSS_EVENT_ID)
+		wlcore_event_beacon_loss(wl,
+					 le16_to_cpu(mbox->bss_loss_bitmap));
+
+	if (vector & CHANNEL_SWITCH_COMPLETE_EVENT_ID)
+		wlcore_event_channel_switch(wl,
+			le16_to_cpu(mbox->channel_switch_role_id_bitmap),
+			true);
+
+	if (vector & DUMMY_PACKET_EVENT_ID)
+		wlcore_event_dummy_packet(wl);
+
+	/*
+	 * "TX retries exceeded" has a different meaning according to mode.
+	 * In AP mode the offending station is disconnected.
+	 */
+	if (vector & MAX_TX_FAILURE_EVENT_ID)
+		wlcore_event_max_tx_failure(wl,
+				le32_to_cpu(mbox->tx_retry_exceeded_bitmap));
+
+	if (vector & INACTIVE_STA_EVENT_ID)
+		wlcore_event_inactive_sta(wl,
+				le32_to_cpu(mbox->inactive_sta_bitmap));
+
+	if (vector & REMAIN_ON_CHANNEL_COMPLETE_EVENT_ID)
+		wlcore_event_roc_complete(wl);
+
+	return 0;
+}
diff --git a/drivers/net/wireless/ti/wl18xx/event.h b/drivers/net/wireless/ti/wl18xx/event.h
new file mode 100644
index 0000000..b55fd31
--- /dev/null
+++ b/drivers/net/wireless/ti/wl18xx/event.h
@@ -0,0 +1,76 @@
+/*
+ * This file is part of wl18xx
+ *
+ * Copyright (C) 2012 Texas Instruments. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __WL18XX_EVENT_H__
+#define __WL18XX_EVENT_H__
+
+#include "../wlcore/wlcore.h"
+
+enum {
+	SCAN_COMPLETE_EVENT_ID                   = BIT(8),
+	RADAR_DETECTED_EVENT_ID                  = BIT(9),
+	CHANNEL_SWITCH_COMPLETE_EVENT_ID         = BIT(10),
+	BSS_LOSS_EVENT_ID                        = BIT(11),
+	MAX_TX_FAILURE_EVENT_ID                  = BIT(12),
+	DUMMY_PACKET_EVENT_ID                    = BIT(13),
+	INACTIVE_STA_EVENT_ID                    = BIT(14),
+	PEER_REMOVE_COMPLETE_EVENT_ID            = BIT(15),
+	PERIODIC_SCAN_COMPLETE_EVENT_ID          = BIT(16),
+	BA_SESSION_RX_CONSTRAINT_EVENT_ID        = BIT(17),
+	REMAIN_ON_CHANNEL_COMPLETE_EVENT_ID      = BIT(18),
+	DFS_CHANNELS_CONFIG_COMPLETE_EVENT       = BIT(19),
+};
+
+struct wl18xx_event_mailbox {
+	__le32 events_vector;
+
+	u8 number_of_scan_results;
+	u8 number_of_sched_scan_results;
+
+	__le16 channel_switch_role_id_bitmap;
+
+	s8 rssi_snr_trigger_metric[NUM_OF_RSSI_SNR_TRIGGERS];
+
+	/* bitmap of removed links */
+	__le32 hlid_removed_bitmap;
+
+	/* rx ba constraint */
+	__le16 rx_ba_role_id_bitmap; /* 0xfff means any role. */
+	__le16 rx_ba_allowed_bitmap;
+
+	/* bitmap of roc completed (by role id) */
+	__le16 roc_completed_bitmap;
+
+	/* bitmap of stations (by role id) with bss loss */
+	__le16 bss_loss_bitmap;
+
+	/* bitmap of stations (by HLID) which exceeded max tx retries */
+	__le32 tx_retry_exceeded_bitmap;
+
+	/* bitmap of inactive stations (by HLID) */
+	__le32 inactive_sta_bitmap;
+} __packed;
+
+int wl18xx_wait_for_event(struct wl1271 *wl, enum wlcore_wait_event event,
+			  bool *timeout);
+int wl18xx_process_mailbox_events(struct wl1271 *wl);
+
+#endif
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 2e54a3e..0895ffa 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -40,6 +40,7 @@
 #include "wl18xx.h"
 #include "io.h"
 #include "scan.h"
+#include "event.h"
 #include "debugfs.h"
 
 #define WL18XX_RX_CHECKSUM_MASK      0x40
@@ -851,6 +852,18 @@ static int wl18xx_boot(struct wl1271 *wl)
 	if (ret < 0)
 		goto out;
 
+	wl->event_mask = BSS_LOSS_EVENT_ID |
+		SCAN_COMPLETE_EVENT_ID |
+		RSSI_SNR_TRIGGER_0_EVENT_ID |
+		PERIODIC_SCAN_COMPLETE_EVENT_ID |
+		DUMMY_PACKET_EVENT_ID |
+		PEER_REMOVE_COMPLETE_EVENT_ID |
+		BA_SESSION_RX_CONSTRAINT_EVENT_ID |
+		REMAIN_ON_CHANNEL_COMPLETE_EVENT_ID |
+		INACTIVE_STA_EVENT_ID |
+		MAX_TX_FAILURE_EVENT_ID |
+		CHANNEL_SWITCH_COMPLETE_EVENT_ID;
+
 	ret = wlcore_boot_run_firmware(wl);
 	if (ret < 0)
 		goto out;
@@ -1313,6 +1326,8 @@ static struct wlcore_ops wl18xx_ops = {
 	.plt_init	= wl18xx_plt_init,
 	.trigger_cmd	= wl18xx_trigger_cmd,
 	.ack_event	= wl18xx_ack_event,
+	.wait_for_event	= wl18xx_wait_for_event,
+	.process_mailbox_events = wl18xx_process_mailbox_events,
 	.calc_tx_blocks = wl18xx_calc_tx_blocks,
 	.set_tx_desc_blocks = wl18xx_set_tx_desc_blocks,
 	.set_tx_desc_data_len = wl18xx_set_tx_desc_data_len,
@@ -1330,7 +1345,6 @@ static struct wlcore_ops wl18xx_ops = {
 	.debugfs_init	= wl18xx_debugfs_add_files,
 	.scan_start	= wl18xx_scan_start,
 	.scan_stop	= wl18xx_scan_stop,
-	.scan_completed	= wl18xx_scan_completed,
 	.sched_scan_start	= wl18xx_sched_scan_start,
 	.sched_scan_stop	= wl18xx_scan_sched_scan_stop,
 	.handle_static_data	= wl18xx_handle_static_data,
@@ -1524,7 +1538,8 @@ static int __devinit wl18xx_probe(struct platform_device *pdev)
 	int ret;
 
 	hw = wlcore_alloc_hw(sizeof(struct wl18xx_priv),
-			     WL18XX_AGGR_BUFFER_SIZE);
+			     WL18XX_AGGR_BUFFER_SIZE,
+			     sizeof(struct wl18xx_event_mailbox));
 	if (IS_ERR(hw)) {
 		wl1271_error("can't allocate hw");
 		ret = PTR_ERR(hw);
diff --git a/drivers/net/wireless/ti/wlcore/boot.c b/drivers/net/wireless/ti/wlcore/boot.c
index 375ea57..230c765 100644
--- a/drivers/net/wireless/ti/wlcore/boot.c
+++ b/drivers/net/wireless/ti/wlcore/boot.c
@@ -491,7 +491,7 @@ int wlcore_boot_run_firmware(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
-	wl->mbox_ptr[1] = wl->mbox_ptr[0] + sizeof(struct event_mailbox);
+	wl->mbox_ptr[1] = wl->mbox_ptr[0] + wl->mbox_size;
 
 	wl1271_debug(DEBUG_MAILBOX, "MBOX ptrs: 0x%x 0x%x",
 		     wl->mbox_ptr[0], wl->mbox_ptr[1]);
@@ -508,23 +508,6 @@ int wlcore_boot_run_firmware(struct wl1271 *wl)
 	 */
 
 	/* unmask required mbox events  */
-	wl->event_mask = BSS_LOSE_EVENT_ID |
-		REGAINED_BSS_EVENT_ID |
-		SCAN_COMPLETE_EVENT_ID |
-		ROLE_STOP_COMPLETE_EVENT_ID |
-		RSSI_SNR_TRIGGER_0_EVENT_ID |
-		PSPOLL_DELIVERY_FAILURE_EVENT_ID |
-		SOFT_GEMINI_SENSE_EVENT_ID |
-		PERIODIC_SCAN_REPORT_EVENT_ID |
-		PERIODIC_SCAN_COMPLETE_EVENT_ID |
-		DUMMY_PACKET_EVENT_ID |
-		PEER_REMOVE_COMPLETE_EVENT_ID |
-		BA_SESSION_RX_CONSTRAINT_EVENT_ID |
-		REMAIN_ON_CHANNEL_COMPLETE_EVENT_ID |
-		INACTIVE_STA_EVENT_ID |
-		MAX_TX_RETRY_EVENT_ID |
-		CHANNEL_SWITCH_COMPLETE_EVENT_ID;
-
 	ret = wl1271_event_unmask(wl);
 	if (ret < 0) {
 		wl1271_error("EVENT mask setting failed");
diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 9796765..63102f2 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -137,8 +137,8 @@ EXPORT_SYMBOL_GPL(wl1271_cmd_send);
  * Poll the mailbox event field until any of the bits in the mask is set or a
  * timeout occurs (WL1271_EVENT_TIMEOUT in msecs)
  */
-static int wl1271_cmd_wait_for_event_or_timeout(struct wl1271 *wl,
-						u32 mask, bool *timeout)
+int wlcore_cmd_wait_for_event_or_timeout(struct wl1271 *wl,
+					 u32 mask, bool *timeout)
 {
 	u32 *events_vector;
 	u32 event;
@@ -188,20 +188,7 @@ out:
 	kfree(events_vector);
 	return ret;
 }
-
-static int wl1271_cmd_wait_for_event(struct wl1271 *wl, u32 mask)
-{
-	int ret;
-	bool timeout = false;
-
-	ret = wl1271_cmd_wait_for_event_or_timeout(wl, mask, &timeout);
-	if (ret != 0 || timeout) {
-		wl12xx_queue_recovery_work(wl);
-		return ret;
-	}
-
-	return 0;
-}
+EXPORT_SYMBOL_GPL(wlcore_cmd_wait_for_event_or_timeout);
 
 int wl12xx_cmd_role_enable(struct wl1271 *wl, u8 *addr, u8 role_type,
 			   u8 *role_id)
@@ -423,12 +410,6 @@ static int wl12xx_cmd_role_stop_dev(struct wl1271 *wl,
 		goto out_free;
 	}
 
-	ret = wl1271_cmd_wait_for_event(wl, ROLE_STOP_COMPLETE_EVENT_ID);
-	if (ret < 0) {
-		wl1271_error("cmd role stop dev event completion error");
-		goto out_free;
-	}
-
 	wl12xx_free_link(wl, wlvif, &wlvif->dev_hlid);
 
 out_free:
@@ -516,7 +497,6 @@ int wl12xx_cmd_role_stop_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	struct wl12xx_cmd_role_stop *cmd;
 	int ret;
-	bool timeout = false;
 
 	if (WARN_ON(wlvif->sta.hlid == WL12XX_INVALID_LINK_ID))
 		return -EINVAL;
@@ -539,17 +519,6 @@ int wl12xx_cmd_role_stop_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		goto out_free;
 	}
 
-	/*
-	 * Sometimes the firmware doesn't send this event, so we just
-	 * time out without failing.  Queue recovery for other
-	 * failures.
-	 */
-	ret = wl1271_cmd_wait_for_event_or_timeout(wl,
-						   ROLE_STOP_COMPLETE_EVENT_ID,
-						   &timeout);
-	if (ret)
-		wl12xx_queue_recovery_work(wl);
-
 	wl12xx_free_link(wl, wlvif, &wlvif->sta.hlid);
 
 out_free:
@@ -1505,9 +1474,10 @@ int wl12xx_cmd_remove_peer(struct wl1271 *wl, u8 hlid)
 		goto out_free;
 	}
 
-	ret = wl1271_cmd_wait_for_event_or_timeout(wl,
-					   PEER_REMOVE_COMPLETE_EVENT_ID,
-					   &timeout);
+	ret = wl->ops->wait_for_event(wl,
+				      WLCORE_EVENT_PEER_REMOVE_COMPLETE,
+				      &timeout);
+
 	/*
 	 * We are ok with a timeout here. The event is sometimes not sent
 	 * due to a firmware bug. In case of another error (like SDIO timeout)
diff --git a/drivers/net/wireless/ti/wlcore/cmd.h b/drivers/net/wireless/ti/wlcore/cmd.h
index 96d53a7..46513da 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.h
+++ b/drivers/net/wireless/ti/wlcore/cmd.h
@@ -94,6 +94,8 @@ int wl12xx_cmd_stop_channel_switch(struct wl1271 *wl,
 int wl12xx_allocate_link(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			 u8 *hlid);
 void wl12xx_free_link(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 *hlid);
+int wlcore_cmd_wait_for_event_or_timeout(struct wl1271 *wl,
+					 u32 mask, bool *timeout);
 
 enum wl1271_commands {
 	CMD_INTERROGATE	= 1, /* use this to read information elements */
diff --git a/drivers/net/wireless/ti/wlcore/event.c b/drivers/net/wireless/ti/wlcore/event.c
index d9353da..3c20393 100644
--- a/drivers/net/wireless/ti/wlcore/event.c
+++ b/drivers/net/wireless/ti/wlcore/event.c
@@ -29,25 +29,29 @@
 #include "scan.h"
 #include "wl12xx_80211.h"
 
-static void wl1271_event_rssi_trigger(struct wl1271 *wl,
-				      struct wl12xx_vif *wlvif,
-				      struct event_mailbox *mbox)
+void wlcore_event_rssi_trigger(struct wl1271 *wl, s8 *metric_arr)
 {
-	struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
+	struct wl12xx_vif *wlvif;
+	struct ieee80211_vif *vif;
 	enum nl80211_cqm_rssi_threshold_event event;
-	s8 metric = mbox->rssi_snr_trigger_metric[0];
+	s8 metric = metric_arr[0];
 
 	wl1271_debug(DEBUG_EVENT, "RSSI trigger metric: %d", metric);
 
-	if (metric <= wlvif->rssi_thold)
-		event = NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW;
-	else
-		event = NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH;
-
-	if (event != wlvif->last_rssi_event)
-		ieee80211_cqm_rssi_notify(vif, event, GFP_KERNEL);
-	wlvif->last_rssi_event = event;
+	/* TODO: check actual multi-role support */
+	wl12xx_for_each_wlvif_sta(wl, wlvif) {
+		if (metric <= wlvif->rssi_thold)
+			event = NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW;
+		else
+			event = NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH;
+
+		vif = wl12xx_wlvif_to_vif(wlvif);
+		if (event != wlvif->last_rssi_event)
+			ieee80211_cqm_rssi_notify(vif, event, GFP_KERNEL);
+		wlvif->last_rssi_event = event;
+	}
 }
+EXPORT_SYMBOL_GPL(wlcore_event_rssi_trigger);
 
 static void wl1271_stop_ba_event(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
@@ -74,8 +78,7 @@ static void wl1271_stop_ba_event(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	}
 }
 
-static void wl12xx_event_soft_gemini_sense(struct wl1271 *wl,
-					       u8 enable)
+void wlcore_event_soft_gemini_sense(struct wl1271 *wl, u8 enable)
 {
 	struct wl12xx_vif *wlvif;
 
@@ -87,210 +90,179 @@ static void wl12xx_event_soft_gemini_sense(struct wl1271 *wl,
 			wl1271_recalc_rx_streaming(wl, wlvif);
 		}
 	}
-
 }
+EXPORT_SYMBOL_GPL(wlcore_event_soft_gemini_sense);
 
-static void wl1271_event_mbox_dump(struct event_mailbox *mbox)
+void wlcore_event_sched_scan_report(struct wl1271 *wl,
+				    u8 status)
 {
-	wl1271_debug(DEBUG_EVENT, "MBOX DUMP:");
-	wl1271_debug(DEBUG_EVENT, "\tvector: 0x%x", mbox->events_vector);
-	wl1271_debug(DEBUG_EVENT, "\tmask: 0x%x", mbox->events_mask);
+	wl1271_debug(DEBUG_EVENT, "PERIODIC_SCAN_REPORT_EVENT (status 0x%0x)",
+		     status);
+
+	wl1271_scan_sched_scan_results(wl);
 }
+EXPORT_SYMBOL_GPL(wlcore_event_sched_scan_report);
 
-static int wl1271_event_process(struct wl1271 *wl)
+void wlcore_event_sched_scan_completed(struct wl1271 *wl,
+				       u8 status)
 {
-	struct event_mailbox *mbox = wl->mbox;
-	struct ieee80211_vif *vif;
-	struct wl12xx_vif *wlvif;
-	u32 vector;
-	bool disconnect_sta = false;
-	unsigned long sta_bitmap = 0;
-	int ret;
+	wl1271_debug(DEBUG_EVENT, "PERIODIC_SCAN_COMPLETE_EVENT (status 0x%0x)",
+		     status);
 
-	wl1271_event_mbox_dump(mbox);
+	if (wl->sched_scanning) {
+		ieee80211_sched_scan_stopped(wl->hw);
+		wl->sched_scanning = false;
+	}
+}
+EXPORT_SYMBOL_GPL(wlcore_event_sched_scan_completed);
 
-	vector = le32_to_cpu(mbox->events_vector);
-	vector &= ~(le32_to_cpu(mbox->events_mask));
-	wl1271_debug(DEBUG_EVENT, "vector: 0x%x", vector);
+void wlcore_event_ba_rx_constraint(struct wl1271 *wl,
+				   unsigned long roles_bitmap,
+				   unsigned long allowed_bitmap)
+{
+	struct wl12xx_vif *wlvif;
 
-	if (vector & SCAN_COMPLETE_EVENT_ID) {
-		wl1271_debug(DEBUG_EVENT, "status: 0x%x",
-			     mbox->scheduled_scan_status);
+	wl1271_debug(DEBUG_EVENT, "%s: roles=0x%lx allowed=0x%lx",
+		     __func__, roles_bitmap, allowed_bitmap);
 
-		if (wl->scan_vif)
-			wl->ops->scan_completed(wl,
-					wl12xx_vif_to_data(wl->scan_vif));
-	}
+	wl12xx_for_each_wlvif(wl, wlvif) {
+		if (wlvif->role_id == WL12XX_INVALID_ROLE_ID ||
+		    !test_bit(wlvif->role_id , &roles_bitmap))
+			continue;
 
-	if (vector & PERIODIC_SCAN_REPORT_EVENT_ID) {
-		wl1271_debug(DEBUG_EVENT, "PERIODIC_SCAN_REPORT_EVENT "
-			     "(status 0x%0x)", mbox->scheduled_scan_status);
-
-		wl1271_scan_sched_scan_results(wl);
+		wlvif->ba_allowed = !!test_bit(wlvif->role_id,
+					       &allowed_bitmap);
+		if (!wlvif->ba_allowed)
+			wl1271_stop_ba_event(wl, wlvif);
 	}
+}
+EXPORT_SYMBOL_GPL(wlcore_event_ba_rx_constraint);
 
-	if (vector & PERIODIC_SCAN_COMPLETE_EVENT_ID) {
-		wl1271_debug(DEBUG_EVENT, "PERIODIC_SCAN_COMPLETE_EVENT "
-			     "(status 0x%0x)", mbox->scheduled_scan_status);
-		if (wl->sched_scanning) {
-			ieee80211_sched_scan_stopped(wl->hw);
-			wl->sched_scanning = false;
-		}
-	}
+void wlcore_event_channel_switch(struct wl1271 *wl,
+				 unsigned long roles_bitmap,
+				 bool success)
+{
+	struct wl12xx_vif *wlvif;
+	struct ieee80211_vif *vif;
 
-	if (vector & SOFT_GEMINI_SENSE_EVENT_ID)
-		wl12xx_event_soft_gemini_sense(wl,
-					       mbox->soft_gemini_sense_info);
+	wl1271_debug(DEBUG_EVENT, "%s: roles=0x%lx success=%d",
+		     __func__, roles_bitmap, success);
 
-	/*
-	 * We are HW_MONITOR device. On beacon loss - queue
-	 * connection loss work. Cancel it on REGAINED event.
-	 */
-	if (vector & BSS_LOSE_EVENT_ID) {
-		/* TODO: check for multi-role */
-		int delay = wl->conf.conn.synch_fail_thold *
-					wl->conf.conn.bss_lose_timeout;
-		wl1271_info("Beacon loss detected.");
+	wl12xx_for_each_wlvif_sta(wl, wlvif) {
+		if (wlvif->role_id == WL12XX_INVALID_ROLE_ID ||
+		    !test_bit(wlvif->role_id , &roles_bitmap))
+			continue;
 
-		/*
-		 * if the work is already queued, it should take place. We
-		 * don't want to delay the connection loss indication
-		 * any more.
-		 */
-		ieee80211_queue_delayed_work(wl->hw, &wl->connection_loss_work,
-					     msecs_to_jiffies(delay));
+		if (!test_and_clear_bit(WLVIF_FLAG_CS_PROGRESS,
+					&wlvif->flags))
+			continue;
 
-		wl12xx_for_each_wlvif_sta(wl, wlvif) {
-			vif = wl12xx_wlvif_to_vif(wlvif);
+		vif = wl12xx_wlvif_to_vif(wlvif);
 
-			ieee80211_cqm_rssi_notify(
-					vif,
-					NL80211_CQM_RSSI_BEACON_LOSS_EVENT,
-					GFP_KERNEL);
-		}
+		ieee80211_chswitch_done(vif, success);
+		cancel_delayed_work(&wlvif->channel_switch_work);
 	}
+}
+EXPORT_SYMBOL_GPL(wlcore_event_channel_switch);
 
-	if (vector & REGAINED_BSS_EVENT_ID) {
-		/* TODO: check for multi-role */
-		wl1271_info("Beacon regained.");
-		cancel_delayed_work(&wl->connection_loss_work);
-
-		/* sanity check - we can't lose and gain the beacon together */
-		WARN(vector & BSS_LOSE_EVENT_ID,
-		     "Concurrent beacon loss and gain from FW");
-	}
+void wlcore_event_dummy_packet(struct wl1271 *wl)
+{
+	wl1271_debug(DEBUG_EVENT, "DUMMY_PACKET_ID_EVENT_ID");
+	wl1271_tx_dummy_packet(wl);
+}
+EXPORT_SYMBOL_GPL(wlcore_event_dummy_packet);
 
-	if (vector & RSSI_SNR_TRIGGER_0_EVENT_ID) {
-		/* TODO: check actual multi-role support */
-		wl1271_debug(DEBUG_EVENT, "RSSI_SNR_TRIGGER_0_EVENT");
-		wl12xx_for_each_wlvif_sta(wl, wlvif) {
-			wl1271_event_rssi_trigger(wl, wlvif, mbox);
+static void wlcore_disconnect_sta(struct wl1271 *wl, unsigned long sta_bitmap)
+{
+	u32 num_packets = wl->conf.tx.max_tx_retries;
+	struct wl12xx_vif *wlvif;
+	struct ieee80211_vif *vif;
+	struct ieee80211_sta *sta;
+	const u8 *addr;
+	int h;
+
+	for_each_set_bit(h, &sta_bitmap, WL12XX_MAX_LINKS) {
+		bool found = false;
+		/* find the ap vif connected to this sta */
+		wl12xx_for_each_wlvif_ap(wl, wlvif) {
+			if (!test_bit(h, wlvif->ap.sta_hlid_map))
+				continue;
+			found = true;
+			break;
 		}
-	}
-
-	if (vector & BA_SESSION_RX_CONSTRAINT_EVENT_ID) {
-		u8 role_id = mbox->role_id;
-		wl1271_debug(DEBUG_EVENT, "BA_SESSION_RX_CONSTRAINT_EVENT_ID. "
-			     "ba_allowed = 0x%x, role_id=%d",
-			     mbox->rx_ba_allowed, role_id);
+		if (!found)
+			continue;
 
-		wl12xx_for_each_wlvif(wl, wlvif) {
-			if (role_id != 0xff && role_id != wlvif->role_id)
-				continue;
+		vif = wl12xx_wlvif_to_vif(wlvif);
+		addr = wl->links[h].addr;
 
-			wlvif->ba_allowed = !!mbox->rx_ba_allowed;
-			if (!wlvif->ba_allowed)
-				wl1271_stop_ba_event(wl, wlvif);
+		rcu_read_lock();
+		sta = ieee80211_find_sta(vif, addr);
+		if (sta) {
+			wl1271_debug(DEBUG_EVENT, "remove sta %d", h);
+			ieee80211_report_low_ack(sta, num_packets);
 		}
+		rcu_read_unlock();
 	}
+}
 
-	if (vector & CHANNEL_SWITCH_COMPLETE_EVENT_ID) {
-		wl1271_debug(DEBUG_EVENT, "CHANNEL_SWITCH_COMPLETE_EVENT_ID. "
-					  "status = 0x%x",
-					  mbox->channel_switch_status);
-		/*
-		 * That event uses for two cases:
-		 * 1) channel switch complete with status=0
-		 * 2) channel switch failed status=1
-		 */
-
-		/* TODO: configure only the relevant vif */
-		wl12xx_for_each_wlvif_sta(wl, wlvif) {
-			bool success;
-
-			if (!test_and_clear_bit(WLVIF_FLAG_CS_PROGRESS,
-						&wlvif->flags))
-				continue;
-
-			success = mbox->channel_switch_status ? false : true;
-			vif = wl12xx_wlvif_to_vif(wlvif);
+void wlcore_event_max_tx_failure(struct wl1271 *wl, unsigned long sta_bitmap)
+{
+	wl1271_debug(DEBUG_EVENT, "MAX_TX_FAILURE_EVENT_ID");
+	wlcore_disconnect_sta(wl, sta_bitmap);
+}
+EXPORT_SYMBOL_GPL(wlcore_event_max_tx_failure);
 
-			ieee80211_chswitch_done(vif, success);
-		}
-	}
+void wlcore_event_inactive_sta(struct wl1271 *wl, unsigned long sta_bitmap)
+{
+	wl1271_debug(DEBUG_EVENT, "INACTIVE_STA_EVENT_ID");
+	wlcore_disconnect_sta(wl, sta_bitmap);
+}
+EXPORT_SYMBOL_GPL(wlcore_event_inactive_sta);
 
-	if ((vector & DUMMY_PACKET_EVENT_ID)) {
-		wl1271_debug(DEBUG_EVENT, "DUMMY_PACKET_ID_EVENT_ID");
-		ret = wl1271_tx_dummy_packet(wl);
-		if (ret < 0)
-			return ret;
-	}
+void wlcore_event_roc_complete(struct wl1271 *wl)
+{
+	wl1271_debug(DEBUG_EVENT, "REMAIN_ON_CHANNEL_COMPLETE_EVENT_ID");
+	if (wl->roc_vif)
+		ieee80211_ready_on_channel(wl->hw);
+}
+EXPORT_SYMBOL_GPL(wlcore_event_roc_complete);
 
+void wlcore_event_beacon_loss(struct wl1271 *wl, unsigned long roles_bitmap)
+{
 	/*
-	 * "TX retries exceeded" has a different meaning according to mode.
-	 * In AP mode the offending station is disconnected.
+	 * We are HW_MONITOR device. On beacon loss - queue
+	 * connection loss work. Cancel it on REGAINED event.
 	 */
-	if (vector & MAX_TX_RETRY_EVENT_ID) {
-		wl1271_debug(DEBUG_EVENT, "MAX_TX_RETRY_EVENT_ID");
-		sta_bitmap |= le16_to_cpu(mbox->sta_tx_retry_exceeded);
-		disconnect_sta = true;
-	}
-
-	if (vector & INACTIVE_STA_EVENT_ID) {
-		wl1271_debug(DEBUG_EVENT, "INACTIVE_STA_EVENT_ID");
-		sta_bitmap |= le16_to_cpu(mbox->sta_aging_status);
-		disconnect_sta = true;
-	}
+	struct wl12xx_vif *wlvif;
+	struct ieee80211_vif *vif;
+	int delay = wl->conf.conn.synch_fail_thold *
+				wl->conf.conn.bss_lose_timeout;
 
-	if (vector & REMAIN_ON_CHANNEL_COMPLETE_EVENT_ID) {
-		wl1271_debug(DEBUG_EVENT,
-			     "REMAIN_ON_CHANNEL_COMPLETE_EVENT_ID");
-		if (wl->roc_vif)
-			ieee80211_ready_on_channel(wl->hw);
-	}
+	wl1271_info("Beacon loss detected. roles:0x%lx", roles_bitmap);
 
-	if (disconnect_sta) {
-		u32 num_packets = wl->conf.tx.max_tx_retries;
-		struct ieee80211_sta *sta;
-		const u8 *addr;
-		int h;
-
-		for_each_set_bit(h, &sta_bitmap, WL12XX_MAX_LINKS) {
-			bool found = false;
-			/* find the ap vif connected to this sta */
-			wl12xx_for_each_wlvif_ap(wl, wlvif) {
-				if (!test_bit(h, wlvif->ap.sta_hlid_map))
-					continue;
-				found = true;
-				break;
-			}
-			if (!found)
-				continue;
+	wl12xx_for_each_wlvif_sta(wl, wlvif) {
+		if (wlvif->role_id == WL12XX_INVALID_ROLE_ID ||
+		    !test_bit(wlvif->role_id , &roles_bitmap))
+			continue;
 
-			vif = wl12xx_wlvif_to_vif(wlvif);
-			addr = wl->links[h].addr;
+		/*
+		 * if the work is already queued, it should take place.
+		 * We don't want to delay the connection loss
+		 * indication any more.
+		 */
+		ieee80211_queue_delayed_work(wl->hw,
+					     &wlvif->connection_loss_work,
+					     msecs_to_jiffies(delay));
 
-			rcu_read_lock();
-			sta = ieee80211_find_sta(vif, addr);
-			if (sta) {
-				wl1271_debug(DEBUG_EVENT, "remove sta %d", h);
-				ieee80211_report_low_ack(sta, num_packets);
-			}
-			rcu_read_unlock();
-		}
+		vif = wl12xx_wlvif_to_vif(wlvif);
+		ieee80211_cqm_rssi_notify(
+				vif,
+				NL80211_CQM_RSSI_BEACON_LOSS_EVENT,
+				GFP_KERNEL);
 	}
-	return 0;
 }
+EXPORT_SYMBOL_GPL(wlcore_event_beacon_loss);
 
 int wl1271_event_unmask(struct wl1271 *wl)
 {
@@ -314,12 +286,12 @@ int wl1271_event_handle(struct wl1271 *wl, u8 mbox_num)
 
 	/* first we read the mbox descriptor */
 	ret = wlcore_read(wl, wl->mbox_ptr[mbox_num], wl->mbox,
-			  sizeof(*wl->mbox), false);
+			  wl->mbox_size, false);
 	if (ret < 0)
 		return ret;
 
 	/* process the descriptor */
-	ret = wl1271_event_process(wl);
+	ret = wl->ops->process_mailbox_events(wl);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/net/wireless/ti/wlcore/event.h b/drivers/net/wireless/ti/wlcore/event.h
index 8adf18d..766b02f 100644
--- a/drivers/net/wireless/ti/wlcore/event.h
+++ b/drivers/net/wireless/ti/wlcore/event.h
@@ -46,33 +46,16 @@ enum {
 	RSSI_SNR_TRIGGER_5_EVENT_ID              = BIT(5),
 	RSSI_SNR_TRIGGER_6_EVENT_ID              = BIT(6),
 	RSSI_SNR_TRIGGER_7_EVENT_ID              = BIT(7),
-	MEASUREMENT_START_EVENT_ID		 = BIT(8),
-	MEASUREMENT_COMPLETE_EVENT_ID		 = BIT(9),
-	SCAN_COMPLETE_EVENT_ID			 = BIT(10),
-	WFD_DISCOVERY_COMPLETE_EVENT_ID		 = BIT(11),
-	AP_DISCOVERY_COMPLETE_EVENT_ID		 = BIT(12),
-	RESERVED1			         = BIT(13),
-	PSPOLL_DELIVERY_FAILURE_EVENT_ID	 = BIT(14),
-	ROLE_STOP_COMPLETE_EVENT_ID		 = BIT(15),
-	RADAR_DETECTED_EVENT_ID                  = BIT(16),
-	CHANNEL_SWITCH_COMPLETE_EVENT_ID	 = BIT(17),
-	BSS_LOSE_EVENT_ID			 = BIT(18),
-	REGAINED_BSS_EVENT_ID			 = BIT(19),
-	MAX_TX_RETRY_EVENT_ID			 = BIT(20),
-	DUMMY_PACKET_EVENT_ID			 = BIT(21),
-	SOFT_GEMINI_SENSE_EVENT_ID		 = BIT(22),
-	CHANGE_AUTO_MODE_TIMEOUT_EVENT_ID	 = BIT(23),
-	SOFT_GEMINI_AVALANCHE_EVENT_ID		 = BIT(24),
-	PLT_RX_CALIBRATION_COMPLETE_EVENT_ID	 = BIT(25),
-	INACTIVE_STA_EVENT_ID			 = BIT(26),
-	PEER_REMOVE_COMPLETE_EVENT_ID		 = BIT(27),
-	PERIODIC_SCAN_COMPLETE_EVENT_ID		 = BIT(28),
-	PERIODIC_SCAN_REPORT_EVENT_ID		 = BIT(29),
-	BA_SESSION_RX_CONSTRAINT_EVENT_ID	 = BIT(30),
-	REMAIN_ON_CHANNEL_COMPLETE_EVENT_ID	 = BIT(31),
+
 	EVENT_MBOX_ALL_EVENT_ID			 = 0x7fffffff,
 };
 
+/* events the driver might want to wait for */
+enum wlcore_wait_event {
+	WLCORE_EVENT_ROLE_STOP_COMPLETE,
+	WLCORE_EVENT_PEER_REMOVE_COMPLETE,
+};
+
 enum {
 	EVENT_ENTER_POWER_SAVE_FAIL = 0,
 	EVENT_ENTER_POWER_SAVE_SUCCESS,
@@ -80,61 +63,26 @@ enum {
 
 #define NUM_OF_RSSI_SNR_TRIGGERS 8
 
-struct event_mailbox {
-	__le32 events_vector;
-	__le32 events_mask;
-	__le32 reserved_1;
-	__le32 reserved_2;
-
-	u8 number_of_scan_results;
-	u8 scan_tag;
-	u8 completed_scan_status;
-	u8 reserved_3;
-
-	u8 soft_gemini_sense_info;
-	u8 soft_gemini_protective_info;
-	s8 rssi_snr_trigger_metric[NUM_OF_RSSI_SNR_TRIGGERS];
-	u8 change_auto_mode_timeout;
-	u8 scheduled_scan_status;
-	u8 reserved4;
-	/* tuned channel (roc) */
-	u8 roc_channel;
-
-	__le16 hlid_removed_bitmap;
-
-	/* bitmap of aged stations (by HLID) */
-	__le16 sta_aging_status;
-
-	/* bitmap of stations (by HLID) which exceeded max tx retries */
-	__le16 sta_tx_retry_exceeded;
-
-	/* discovery completed results */
-	u8 discovery_tag;
-	u8 number_of_preq_results;
-	u8 number_of_prsp_results;
-	u8 reserved_5;
-
-	/* rx ba constraint */
-	u8 role_id; /* 0xFF means any role. */
-	u8 rx_ba_allowed;
-	u8 reserved_6[2];
-
-	/* Channel switch results */
-
-	u8 channel_switch_role_id;
-	u8 channel_switch_status;
-	u8 reserved_7[2];
-
-	u8 ps_poll_delivery_failure_role_ids;
-	u8 stopped_role_ids;
-	u8 started_role_ids;
-
-	u8 reserved_8[9];
-} __packed;
-
 struct wl1271;
 
 int wl1271_event_unmask(struct wl1271 *wl);
 int wl1271_event_handle(struct wl1271 *wl, u8 mbox);
 
+void wlcore_event_soft_gemini_sense(struct wl1271 *wl, u8 enable);
+void wlcore_event_sched_scan_report(struct wl1271 *wl,
+				    u8 status);
+void wlcore_event_sched_scan_completed(struct wl1271 *wl,
+				       u8 status);
+void wlcore_event_ba_rx_constraint(struct wl1271 *wl,
+				   unsigned long roles_bitmap,
+				   unsigned long allowed_bitmap);
+void wlcore_event_channel_switch(struct wl1271 *wl,
+				 unsigned long roles_bitmap,
+				 bool success);
+void wlcore_event_beacon_loss(struct wl1271 *wl, unsigned long roles_bitmap);
+void wlcore_event_dummy_packet(struct wl1271 *wl);
+void wlcore_event_max_tx_failure(struct wl1271 *wl, unsigned long sta_bitmap);
+void wlcore_event_inactive_sta(struct wl1271 *wl, unsigned long sta_bitmap);
+void wlcore_event_roc_complete(struct wl1271 *wl);
+void wlcore_event_rssi_trigger(struct wl1271 *wl, s8 *metric_arr);
 #endif
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 7c596dd..7b43c6c 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1139,7 +1139,6 @@ int wl1271_plt_stop(struct wl1271 *wl)
 	cancel_work_sync(&wl->recovery_work);
 	cancel_delayed_work_sync(&wl->elp_work);
 	cancel_delayed_work_sync(&wl->tx_watchdog_work);
-	cancel_delayed_work_sync(&wl->connection_loss_work);
 
 	mutex_lock(&wl->mutex);
 	wl1271_power_off(wl);
@@ -1841,7 +1840,6 @@ static void wlcore_op_stop_locked(struct wl1271 *wl)
 	cancel_work_sync(&wl->tx_work);
 	cancel_delayed_work_sync(&wl->elp_work);
 	cancel_delayed_work_sync(&wl->tx_watchdog_work);
-	cancel_delayed_work_sync(&wl->connection_loss_work);
 
 	/* let's notify MAC80211 about the remaining pending TX frames */
 	wl12xx_tx_reset(wl);
@@ -1916,6 +1914,71 @@ static void wlcore_op_stop(struct ieee80211_hw *hw)
 	mutex_unlock(&wl->mutex);
 }
 
+static void wlcore_channel_switch_work(struct work_struct *work)
+{
+	struct delayed_work *dwork;
+	struct wl1271 *wl;
+	struct ieee80211_vif *vif;
+	struct wl12xx_vif *wlvif;
+	int ret;
+
+	dwork = container_of(work, struct delayed_work, work);
+	wlvif = container_of(dwork, struct wl12xx_vif, channel_switch_work);
+	wl = wlvif->wl;
+
+	wl1271_info("channel switch failed (role_id: %d).", wlvif->role_id);
+
+	mutex_lock(&wl->mutex);
+
+	if (unlikely(wl->state != WLCORE_STATE_ON))
+		goto out;
+
+	/* check the channel switch is still ongoing */
+	if (!test_and_clear_bit(WLVIF_FLAG_CS_PROGRESS, &wlvif->flags))
+		goto out;
+
+	vif = wl12xx_wlvif_to_vif(wlvif);
+	ieee80211_chswitch_done(vif, false);
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	wl12xx_cmd_stop_channel_switch(wl, wlvif);
+
+	wl1271_ps_elp_sleep(wl);
+out:
+	mutex_unlock(&wl->mutex);
+}
+
+static void wl1271_connection_loss_work(struct work_struct *work)
+{
+	struct delayed_work *dwork;
+	struct wl1271 *wl;
+	struct ieee80211_vif *vif;
+	struct wl12xx_vif *wlvif;
+
+	dwork = container_of(work, struct delayed_work, work);
+	wlvif = container_of(dwork, struct wl12xx_vif, connection_loss_work);
+	wl = wlvif->wl;
+
+	wl1271_info("Connection loss work (role_id: %d).", wlvif->role_id);
+
+	mutex_lock(&wl->mutex);
+
+	if (unlikely(wl->state != WLCORE_STATE_ON))
+		goto out;
+
+	/* Call mac80211 connection loss */
+	if (!test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags))
+		goto out;
+
+	vif = wl12xx_wlvif_to_vif(wlvif);
+	ieee80211_connection_loss(vif);
+out:
+	mutex_unlock(&wl->mutex);
+}
+
 static int wl12xx_allocate_rate_policy(struct wl1271 *wl, u8 *idx)
 {
 	u8 policy = find_first_zero_bit(wl->rate_policies_map,
@@ -2063,6 +2126,10 @@ static int wl12xx_init_vif_data(struct wl1271 *wl, struct ieee80211_vif *vif)
 		  wl1271_rx_streaming_enable_work);
 	INIT_WORK(&wlvif->rx_streaming_disable_work,
 		  wl1271_rx_streaming_disable_work);
+	INIT_DELAYED_WORK(&wlvif->channel_switch_work,
+			  wlcore_channel_switch_work);
+	INIT_DELAYED_WORK(&wlvif->connection_loss_work,
+			  wl1271_connection_loss_work);
 	INIT_LIST_HEAD(&wlvif->list);
 
 	setup_timer(&wlvif->rx_streaming_timer, wl1271_rx_streaming_timer,
@@ -2312,7 +2379,7 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 	wl1271_info("down");
 
 	if (wl->scan.state != WL1271_SCAN_STATE_IDLE &&
-	    wl->scan_vif == vif) {
+	    wl->scan_wlvif == wlvif) {
 		/*
 		 * Rearm the tx watchdog just before idling scan. This
 		 * prevents just-finished scans from triggering the watchdog
@@ -2321,7 +2388,7 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 
 		wl->scan.state = WL1271_SCAN_STATE_IDLE;
 		memset(wl->scan.scanned_ch, 0, sizeof(wl->scan.scanned_ch));
-		wl->scan_vif = NULL;
+		wl->scan_wlvif = NULL;
 		wl->scan.req = NULL;
 		ieee80211_scan_completed(wl->hw, true);
 	}
@@ -2408,6 +2475,7 @@ unlock:
 	del_timer_sync(&wlvif->rx_streaming_timer);
 	cancel_work_sync(&wlvif->rx_streaming_enable_work);
 	cancel_work_sync(&wlvif->rx_streaming_disable_work);
+	cancel_delayed_work_sync(&wlvif->connection_loss_work);
 
 	mutex_lock(&wl->mutex);
 }
@@ -2675,6 +2743,7 @@ static int wlcore_unset_assoc(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 
 		wl12xx_cmd_stop_channel_switch(wl, wlvif);
 		ieee80211_chswitch_done(vif, false);
+		cancel_delayed_work(&wlvif->channel_switch_work);
 	}
 
 	/* invalidate keep-alive template */
@@ -3296,7 +3365,7 @@ static void wl1271_op_cancel_hw_scan(struct ieee80211_hw *hw,
 
 	wl->scan.state = WL1271_SCAN_STATE_IDLE;
 	memset(wl->scan.scanned_ch, 0, sizeof(wl->scan.scanned_ch));
-	wl->scan_vif = NULL;
+	wl->scan_wlvif = NULL;
 	wl->scan.req = NULL;
 	ieee80211_scan_completed(wl->hw, true);
 
@@ -4087,7 +4156,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 	 * state changed
 	 */
 	if (!is_ap && (changed & BSS_CHANGED_ASSOC))
-		cancel_delayed_work_sync(&wl->connection_loss_work);
+		cancel_delayed_work_sync(&wlvif->connection_loss_work);
 
 	if (is_ap && (changed & BSS_CHANGED_BEACON_ENABLED) &&
 	    !bss_conf->enable_beacon)
@@ -4680,11 +4749,23 @@ static void wl12xx_op_channel_switch(struct ieee80211_hw *hw,
 
 	/* TODO: change mac80211 to pass vif as param */
 	wl12xx_for_each_wlvif_sta(wl, wlvif) {
+		unsigned long delay_usec;
+
 		ret = wl->ops->channel_switch(wl, wlvif, ch_switch);
-		if (!ret)
-			set_bit(WLVIF_FLAG_CS_PROGRESS, &wlvif->flags);
+		if (ret)
+			goto out_sleep;
+
+		set_bit(WLVIF_FLAG_CS_PROGRESS, &wlvif->flags);
+
+		/* indicate failure 5 seconds after channel switch time */
+		delay_usec = ieee80211_tu_to_usec(wlvif->beacon_int) *
+			     ch_switch->count;
+		ieee80211_queue_delayed_work(hw, &wlvif->channel_switch_work,
+				usecs_to_jiffies(delay_usec) +
+				msecs_to_jiffies(5000));
 	}
 
+out_sleep:
 	wl1271_ps_elp_sleep(wl);
 
 out:
@@ -5193,34 +5274,6 @@ static struct bin_attribute fwlog_attr = {
 	.read = wl1271_sysfs_read_fwlog,
 };
 
-static void wl1271_connection_loss_work(struct work_struct *work)
-{
-	struct delayed_work *dwork;
-	struct wl1271 *wl;
-	struct ieee80211_vif *vif;
-	struct wl12xx_vif *wlvif;
-
-	dwork = container_of(work, struct delayed_work, work);
-	wl = container_of(dwork, struct wl1271, connection_loss_work);
-
-	wl1271_info("Connection loss work.");
-
-	mutex_lock(&wl->mutex);
-
-	if (unlikely(wl->state != WLCORE_STATE_ON))
-		goto out;
-
-	/* Call mac80211 connection loss */
-	wl12xx_for_each_wlvif_sta(wl, wlvif) {
-		if (!test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags))
-			goto out;
-		vif = wl12xx_wlvif_to_vif(wlvif);
-		ieee80211_connection_loss(vif);
-	}
-out:
-	mutex_unlock(&wl->mutex);
-}
-
 static void wl12xx_derive_mac_addresses(struct wl1271 *wl, u32 oui, u32 nic)
 {
 	int i;
@@ -5478,7 +5531,8 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 
 #define WL1271_DEFAULT_CHANNEL 0
 
-struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size)
+struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size,
+				     u32 mbox_size)
 {
 	struct ieee80211_hw *hw;
 	struct wl1271 *wl;
@@ -5522,8 +5576,6 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size)
 	INIT_DELAYED_WORK(&wl->scan_complete_work, wl1271_scan_complete_work);
 	INIT_DELAYED_WORK(&wl->roc_complete_work, wlcore_roc_complete_work);
 	INIT_DELAYED_WORK(&wl->tx_watchdog_work, wl12xx_tx_watchdog_work);
-	INIT_DELAYED_WORK(&wl->connection_loss_work,
-			  wl1271_connection_loss_work);
 
 	wl->freezable_wq = create_freezable_workqueue("wl12xx_wq");
 	if (!wl->freezable_wq) {
@@ -5586,7 +5638,8 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size)
 		goto err_dummy_packet;
 	}
 
-	wl->mbox = kmalloc(sizeof(*wl->mbox), GFP_KERNEL | GFP_DMA);
+	wl->mbox_size = mbox_size;
+	wl->mbox = kmalloc(wl->mbox_size, GFP_KERNEL | GFP_DMA);
 	if (!wl->mbox) {
 		ret = -ENOMEM;
 		goto err_fwlog;
diff --git a/drivers/net/wireless/ti/wlcore/scan.c b/drivers/net/wireless/ti/wlcore/scan.c
index e7d0a02..eeb6188 100644
--- a/drivers/net/wireless/ti/wlcore/scan.c
+++ b/drivers/net/wireless/ti/wlcore/scan.c
@@ -35,7 +35,6 @@ void wl1271_scan_complete_work(struct work_struct *work)
 {
 	struct delayed_work *dwork;
 	struct wl1271 *wl;
-	struct ieee80211_vif *vif;
 	struct wl12xx_vif *wlvif;
 	int ret;
 
@@ -52,8 +51,7 @@ void wl1271_scan_complete_work(struct work_struct *work)
 	if (wl->scan.state == WL1271_SCAN_STATE_IDLE)
 		goto out;
 
-	vif = wl->scan_vif;
-	wlvif = wl12xx_vif_to_data(vif);
+	wlvif = wl->scan_wlvif;
 
 	/*
 	 * Rearm the tx watchdog just before idling scan. This
@@ -64,7 +62,7 @@ void wl1271_scan_complete_work(struct work_struct *work)
 	wl->scan.state = WL1271_SCAN_STATE_IDLE;
 	memset(wl->scan.scanned_ch, 0, sizeof(wl->scan.scanned_ch));
 	wl->scan.req = NULL;
-	wl->scan_vif = NULL;
+	wl->scan_wlvif = NULL;
 
 	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
@@ -295,7 +293,7 @@ int wlcore_scan(struct wl1271 *wl, struct ieee80211_vif *vif,
 		wl->scan.ssid_len = 0;
 	}
 
-	wl->scan_vif = vif;
+	wl->scan_wlvif = wlvif;
 	wl->scan.req = req;
 	memset(wl->scan.scanned_ch, 0, sizeof(wl->scan.scanned_ch));
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 1ad49c9..d47eb6c 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -51,6 +51,9 @@ struct wlcore_ops {
 	int (*trigger_cmd)(struct wl1271 *wl, int cmd_box_addr,
 			   void *buf, size_t len);
 	int (*ack_event)(struct wl1271 *wl);
+	int (*wait_for_event)(struct wl1271 *wl, enum wlcore_wait_event event,
+			      bool *timeout);
+	int (*process_mailbox_events)(struct wl1271 *wl);
 	u32 (*calc_tx_blocks)(struct wl1271 *wl, u32 len, u32 spare_blks);
 	void (*set_tx_desc_blocks)(struct wl1271 *wl,
 				   struct wl1271_tx_hw_descr *desc,
@@ -85,7 +88,6 @@ struct wlcore_ops {
 	int (*scan_start)(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			  struct cfg80211_scan_request *req);
 	int (*scan_stop)(struct wl1271 *wl, struct wl12xx_vif *wlvif);
-	void (*scan_completed)(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 	int (*sched_scan_start)(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 				struct cfg80211_sched_scan_request *req,
 				struct ieee80211_sched_scan_ies *ies);
@@ -281,22 +283,20 @@ struct wl1271 {
 	bool watchdog_recovery;
 
 	/* Pointer that holds DMA-friendly block for the mailbox */
-	struct event_mailbox *mbox;
+	void *mbox;
 
 	/* The mbox event mask */
 	u32 event_mask;
 
 	/* Mailbox pointers */
+	u32 mbox_size;
 	u32 mbox_ptr[2];
 
 	/* Are we currently scanning */
-	struct ieee80211_vif *scan_vif;
+	struct wl12xx_vif *scan_wlvif;
 	struct wl1271_scan scan;
 	struct delayed_work scan_complete_work;
 
-	/* Connection loss work */
-	struct delayed_work connection_loss_work;
-
 	struct ieee80211_vif *roc_vif;
 	struct delayed_work roc_complete_work;
 
@@ -436,7 +436,8 @@ struct wl1271 {
 
 int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev);
 int __devexit wlcore_remove(struct platform_device *pdev);
-struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size);
+struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size,
+				     u32 mbox_size);
 int wlcore_free_hw(struct wl1271 *wl);
 int wlcore_set_key(struct wl1271 *wl, enum set_key_cmd cmd,
 		   struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index 6678d4b..bc3b5f4 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -421,6 +421,9 @@ struct wl12xx_vif {
 	struct work_struct rx_streaming_disable_work;
 	struct timer_list rx_streaming_timer;
 
+	struct delayed_work channel_switch_work;
+	struct delayed_work connection_loss_work;
+
 	/*
 	 * This struct must be last!
 	 * data that has to be saved acrossed reconfigs (e.g. recovery)
-- 
1.7.6.401.g6a319

