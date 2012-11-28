Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58302 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab2K1JnC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 04:43:02 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr13so3507300wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 01:43:01 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Igal Chernobelsky <igalc@ti.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 03/20] wlcore/wl18xx/wl12xx: FW log params per chip arch
Date: Wed, 28 Nov 2012 11:42:32 +0200
Message-Id: <1354095769-8724-4-git-send-email-arik@wizery.com> (sfid-20121128_104315_122051_63D0F1BE)
In-Reply-To: <1354095769-8724-1-git-send-email-arik@wizery.com>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igal Chernobelsky <igalc@ti.com>

FW memory block size and FW log end marker parameters
are added to wl structure and are initialized per
chip architecture. convert_hwaddr hw operation is added
to convert chip dependent FW internal address.
Copy from FW log is also simplified to copy the entire
memory block as FW logger utility is repsponsible
for parsing of FW log content.

Signed-off-by: Igal Chernobelsky <igalc@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/main.c     |    9 ++++++
 drivers/net/wireless/ti/wl18xx/main.c     |    9 ++++++
 drivers/net/wireless/ti/wlcore/hw_ops.h   |    9 ++++++
 drivers/net/wireless/ti/wlcore/io.h       |    4 +--
 drivers/net/wireless/ti/wlcore/main.c     |   44 ++++++++++++++++-------------
 drivers/net/wireless/ti/wlcore/wlcore.h   |    8 +++++-
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    2 --
 7 files changed, 61 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 951b88c..5e3c808 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -706,6 +706,9 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
 		goto out;
 	}
 
+	wl->fw_mem_block_size = 256;
+	wl->fwlog_end = 0x2000000;
+
 	/* common settings */
 	wl->scan_templ_id_2_4 = CMD_TEMPL_APP_PROBE_REQ_2_4_LEGACY;
 	wl->scan_templ_id_5 = CMD_TEMPL_APP_PROBE_REQ_5_LEGACY;
@@ -1632,6 +1635,11 @@ static int wl12xx_set_peer_cap(struct wl1271 *wl,
 					      hlid);
 }
 
+static u32 wl12xx_convert_hwaddr(struct wl1271 *wl, u32 hwaddr)
+{
+	return hwaddr << 5;
+}
+
 static int wl12xx_setup(struct wl1271 *wl);
 
 static struct wlcore_ops wl12xx_ops = {
@@ -1669,6 +1677,7 @@ static struct wlcore_ops wl12xx_ops = {
 	.channel_switch		= wl12xx_cmd_channel_switch,
 	.pre_pkt_send		= NULL,
 	.set_peer_cap		= wl12xx_set_peer_cap,
+	.convert_hwaddr = wl12xx_convert_hwaddr,
 };
 
 static struct ieee80211_sta_ht_cap wl12xx_ht_cap = {
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index df8de71..d806241 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -667,6 +667,9 @@ static int wl18xx_identify_chip(struct wl1271 *wl)
 		goto out;
 	}
 
+	wl->fw_mem_block_size = 272;
+	wl->fwlog_end = 0x40000000;
+
 	wl->scan_templ_id_2_4 = CMD_TEMPL_CFG_PROBE_REQ_2_4;
 	wl->scan_templ_id_5 = CMD_TEMPL_CFG_PROBE_REQ_5;
 	wl->sched_scan_templ_id_2_4 = CMD_TEMPL_PROBE_REQ_2_4_PERIODIC;
@@ -1423,6 +1426,11 @@ static int wl18xx_set_peer_cap(struct wl1271 *wl,
 				       rate_set, hlid);
 }
 
+static u32 wl18xx_convert_hwaddr(struct wl1271 *wl, u32 hwaddr)
+{
+	return hwaddr & ~0x80000000;
+}
+
 static int wl18xx_setup(struct wl1271 *wl);
 
 static struct wlcore_ops wl18xx_ops = {
@@ -1460,6 +1468,7 @@ static struct wlcore_ops wl18xx_ops = {
 	.pre_pkt_send	= wl18xx_pre_pkt_send,
 	.sta_rc_update	= wl18xx_sta_rc_update,
 	.set_peer_cap	= wl18xx_set_peer_cap,
+	.convert_hwaddr = wl18xx_convert_hwaddr,
 };
 
 /* HT cap appropriate for wide channels in 2Ghz */
diff --git a/drivers/net/wireless/ti/wlcore/hw_ops.h b/drivers/net/wireless/ti/wlcore/hw_ops.h
index 4db03e1..802a345 100644
--- a/drivers/net/wireless/ti/wlcore/hw_ops.h
+++ b/drivers/net/wireless/ti/wlcore/hw_ops.h
@@ -222,4 +222,13 @@ wlcore_hw_set_peer_cap(struct wl1271 *wl,
 	return 0;
 }
 
+static inline u32
+wlcore_hw_convert_hwaddr(struct wl1271 *wl, u32 hwaddr)
+{
+	if (!wl->ops->convert_hwaddr)
+		BUG_ON(1);
+
+	return wl->ops->convert_hwaddr(wl, hwaddr);
+}
+
 #endif
diff --git a/drivers/net/wireless/ti/wlcore/io.h b/drivers/net/wireless/ti/wlcore/io.h
index f48530f..5897747 100644
--- a/drivers/net/wireless/ti/wlcore/io.h
+++ b/drivers/net/wireless/ti/wlcore/io.h
@@ -165,8 +165,8 @@ static inline int __must_check wlcore_read_hwaddr(struct wl1271 *wl, int hwaddr,
 	int physical;
 	int addr;
 
-	/* Addresses are stored internally as addresses to 32 bytes blocks */
-	addr = hwaddr << 5;
+	/* Convert from FW internal address which is chip arch dependent */
+	addr = wl->ops->convert_hwaddr(wl, hwaddr);
 
 	physical = wlcore_translate_addr(wl, addr);
 
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 4ef7ea7..5e070ff 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -787,19 +787,10 @@ void wl12xx_queue_recovery_work(struct wl1271 *wl)
 
 size_t wl12xx_copy_fwlog(struct wl1271 *wl, u8 *memblock, size_t maxlen)
 {
-	size_t len = 0;
-
-	/* The FW log is a length-value list, find where the log end */
-	while (len < maxlen) {
-		if (memblock[len] == 0)
-			break;
-		if (len + memblock[len] + 1 > maxlen)
-			break;
-		len += memblock[len] + 1;
-	}
+	size_t len;
 
 	/* Make sure we have enough room */
-	len = min(len, (size_t)(PAGE_SIZE - wl->fwlog_size));
+	len = min(maxlen, (size_t)(PAGE_SIZE - wl->fwlog_size));
 
 	/* Fill the FW log file, consumed by the sysfs fwlog entry */
 	memcpy(wl->fwlog + wl->fwlog_size, memblock, len);
@@ -808,10 +799,9 @@ size_t wl12xx_copy_fwlog(struct wl1271 *wl, u8 *memblock, size_t maxlen)
 	return len;
 }
 
-#define WLCORE_FW_LOG_END 0x2000000
-
 static void wl12xx_read_fwlog_panic(struct wl1271 *wl)
 {
+	struct wlcore_partition_set part, old_part;
 	u32 addr;
 	u32 offset;
 	u32 end_of_log;
@@ -824,7 +814,7 @@ static void wl12xx_read_fwlog_panic(struct wl1271 *wl)
 
 	wl1271_info("Reading FW panic log");
 
-	block = kmalloc(WL12XX_HW_BLOCK_SIZE, GFP_KERNEL);
+	block = kmalloc(wl->fw_mem_block_size, GFP_KERNEL);
 	if (!block)
 		return;
 
@@ -850,17 +840,31 @@ static void wl12xx_read_fwlog_panic(struct wl1271 *wl)
 
 	if (wl->conf.fwlog.mode == WL12XX_FWLOG_CONTINUOUS) {
 		offset = sizeof(addr) + sizeof(struct wl1271_rx_descriptor);
-		end_of_log = WLCORE_FW_LOG_END;
+		end_of_log = wl->fwlog_end;
 	} else {
 		offset = sizeof(addr);
 		end_of_log = addr;
 	}
 
+	old_part = wl->curr_part;
+	memset(&part, 0, sizeof(part));
+
 	/* Traverse the memory blocks linked list */
 	do {
-		memset(block, 0, WL12XX_HW_BLOCK_SIZE);
-		ret = wlcore_read_hwaddr(wl, addr, block, WL12XX_HW_BLOCK_SIZE,
-					 false);
+		part.mem.start = wlcore_hw_convert_hwaddr(wl, addr);
+		part.mem.size  = PAGE_SIZE;
+
+		ret = wlcore_set_partition(wl, &part);
+		if (ret < 0) {
+			wl1271_error("%s: set_partition start=0x%X size=%d",
+				__func__, part.mem.start, part.mem.size);
+			goto out;
+		}
+
+		memset(block, 0, wl->fw_mem_block_size);
+		ret = wlcore_read_hwaddr(wl, addr, block,
+					wl->fw_mem_block_size, false);
+
 		if (ret < 0)
 			goto out;
 
@@ -871,8 +875,9 @@ static void wl12xx_read_fwlog_panic(struct wl1271 *wl)
 		 * on demand mode and is equal to 0x2000000 in continuous mode.
 		 */
 		addr = le32_to_cpup((__le32 *)block);
+
 		if (!wl12xx_copy_fwlog(wl, block + offset,
-				       WL12XX_HW_BLOCK_SIZE - offset))
+					wl->fw_mem_block_size - offset))
 			break;
 	} while (addr && (addr != end_of_log));
 
@@ -880,6 +885,7 @@ static void wl12xx_read_fwlog_panic(struct wl1271 *wl)
 
 out:
 	kfree(block);
+	wlcore_set_partition(wl, &old_part);
 }
 
 static void wlcore_print_recovery(struct wl1271 *wl)
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index ecdd5e6..f48f57a 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -110,7 +110,7 @@ struct wlcore_ops {
 			    struct ieee80211_sta_ht_cap *ht_cap,
 			    bool allow_ht_operation,
 			    u32 rate_set, u8 hlid);
-
+	u32 (*convert_hwaddr)(struct wl1271 *wl, u32 hwaddr);
 };
 
 enum wlcore_partitions {
@@ -287,6 +287,12 @@ struct wl1271 {
 	/* Number of valid bytes in the FW log buffer */
 	ssize_t fwlog_size;
 
+	/* FW log end marker */
+	u32 fwlog_end;
+
+	/* FW memory block size */
+	u32 fw_mem_block_size;
+
 	/* Sysfs FW log entry readers wait queue */
 	wait_queue_head_t fwlog_waitq;
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index a664662..a8647bd 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -523,6 +523,4 @@ void wl1271_rx_filter_flatten_fields(struct wl12xx_rx_filter *filter,
 #define HW_HT_RATES_OFFSET	16
 #define HW_MIMO_RATES_OFFSET	24
 
-#define WL12XX_HW_BLOCK_SIZE	256
-
 #endif /* __WLCORE_I_H__ */
-- 
1.7.9.5

