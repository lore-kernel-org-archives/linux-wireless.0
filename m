Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:43707 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756716Ab1CROUt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 10:20:49 -0400
Received: by eye27 with SMTP id 27so834647eye.6
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 07:20:47 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: shahar_levi@ti.com, ruthyz@ti.com
Subject: [PATCH v2 14/14] wl12xx: use 1 spare TX block instead of two
Date: Fri, 18 Mar 2011 16:19:29 +0200
Message-Id: <1300457969-19601-15-git-send-email-coelho@ti.com>
In-Reply-To: <1300457969-19601-1-git-send-email-coelho@ti.com>
References: <1300457969-19601-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All the new firmware versions (>=6.1.3.50.58 for STA and >=6.2.0.0.47
for AP) use 1 spare TX block.  We still want to support older
firmwares that require 2 spare blocks, so added a quirk to handle the
difference.

Also implemented a generic way of setting quirks that depend on the
firmware revision.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/main.c   |   24 ++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/tx.c     |   10 ++++++++--
 drivers/net/wireless/wl12xx/tx.h     |    1 -
 drivers/net/wireless/wl12xx/wl12xx.h |   28 +++++++++++++++++++++++++---
 4 files changed, 57 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 0b9d41f..a5548c8 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1040,6 +1040,24 @@ out:
 	return ret;
 }
 
+static unsigned int wl1271_get_fw_ver_quirks(struct wl1271 *wl)
+{
+	unsigned int quirks = 0;
+	unsigned int *fw_ver = wl->chip.fw_ver;
+
+	/* Only for wl127x */
+	if ((fw_ver[FW_VER_CHIP] == FW_VER_CHIP_WL127X) &&
+	    /* Check STA version */
+	    (((fw_ver[FW_VER_IF_TYPE] == FW_VER_IF_TYPE_STA) &&
+	      (fw_ver[FW_VER_MINOR] < FW_VER_MINOR_1_SPARE_STA_MIN)) ||
+	     /* Check AP version */
+	     ((fw_ver[FW_VER_IF_TYPE] == FW_VER_IF_TYPE_AP) &&
+	      (fw_ver[FW_VER_MINOR] < FW_VER_MINOR_1_SPARE_AP_MIN))))
+		  quirks |= WL12XX_QUIRK_USE_2_SPARE_BLOCKS;
+
+	return quirks;
+}
+
 int wl1271_plt_start(struct wl1271 *wl)
 {
 	int retries = WL1271_BOOT_RETRIES;
@@ -1075,6 +1093,9 @@ int wl1271_plt_start(struct wl1271 *wl)
 		wl->state = WL1271_STATE_PLT;
 		wl1271_notice("firmware booted in PLT mode (%s)",
 			      wl->chip.fw_ver_str);
+
+		/* Check if any quirks are needed with older fw versions */
+		wl->quirks |= wl1271_get_fw_ver_quirks(wl);
 		goto out;
 
 irq_disable:
@@ -1353,6 +1374,9 @@ power_off:
 	strncpy(wiphy->fw_version, wl->chip.fw_ver_str,
 		sizeof(wiphy->fw_version));
 
+	/* Check if any quirks are needed with older fw versions */
+	wl->quirks |= wl1271_get_fw_ver_quirks(wl);
+
 	/*
 	 * Now we know if 11a is supported (info from the NVS), so disable
 	 * 11a channels if not supported
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 75222a6..109878c 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -135,6 +135,12 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
 	u32 len;
 	u32 total_blocks;
 	int id, ret = -EBUSY;
+	u32 spare_blocks;
+
+	if (unlikely(wl->quirks & WL12XX_QUIRK_USE_2_SPARE_BLOCKS))
+		spare_blocks = 2;
+	else
+		spare_blocks = 1;
 
 	if (buf_offset + total_len > WL1271_AGGR_BUFFER_SIZE)
 		return -EAGAIN;
@@ -152,7 +158,7 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
 		len = total_len;
 
 	total_blocks = (len + TX_HW_BLOCK_SIZE - 1) / TX_HW_BLOCK_SIZE +
-		TX_HW_BLOCK_SPARE;
+		spare_blocks;
 
 	if (total_blocks <= wl->tx_blocks_available) {
 		desc = (struct wl1271_tx_hw_descr *)skb_push(
@@ -162,7 +168,7 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
 		if (wl->chip.id == CHIP_ID_1283_PG20) {
 			desc->wl128x_mem.total_mem_blocks = total_blocks;
 		} else {
-			desc->wl127x_mem.extra_blocks = TX_HW_BLOCK_SPARE;
+			desc->wl127x_mem.extra_blocks = spare_blocks;
 			desc->wl127x_mem.total_mem_blocks = total_blocks;
 		}
 
diff --git a/drivers/net/wireless/wl12xx/tx.h b/drivers/net/wireless/wl12xx/tx.h
index 6f45e91..a3877ba 100644
--- a/drivers/net/wireless/wl12xx/tx.h
+++ b/drivers/net/wireless/wl12xx/tx.h
@@ -25,7 +25,6 @@
 #ifndef __TX_H__
 #define __TX_H__
 
-#define TX_HW_BLOCK_SPARE                2
 #define TX_HW_BLOCK_SIZE                 252
 
 #define TX_HW_MGMT_PKT_LIFETIME_TU       2000
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 890c1a5..6262ede 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -207,13 +207,29 @@ struct wl1271_partition_set {
 
 struct wl1271;
 
-#define WL12XX_NUM_FW_VER 5
+enum {
+	FW_VER_CHIP,
+	FW_VER_IF_TYPE,
+	FW_VER_MAJOR,
+	FW_VER_SUBTYPE,
+	FW_VER_MINOR,
+
+	NUM_FW_VER
+};
+
+#define FW_VER_CHIP_WL127X 6
+#define FW_VER_CHIP_WL128X 7
+
+#define FW_VER_IF_TYPE_STA 1
+#define FW_VER_IF_TYPE_AP  2
+
+#define FW_VER_MINOR_1_SPARE_STA_MIN 58
+#define FW_VER_MINOR_1_SPARE_AP_MIN  47
 
-/* FIXME: I'm not sure about this structure name */
 struct wl1271_chip {
 	u32 id;
 	char fw_ver_str[ETHTOOL_BUSINFO_LEN];
-	unsigned int fw_ver[WL12XX_NUM_FW_VER];
+	unsigned int fw_ver[NUM_FW_VER];
 };
 
 struct wl1271_stats {
@@ -594,4 +610,10 @@ int wl1271_plt_stop(struct wl1271 *wl);
 /* Each RX/TX transaction requires an end-of-transaction transfer */
 #define WL12XX_QUIRK_END_OF_TRANSACTION	BIT(0)
 
+/*
+ * Older firmwares use 2 spare TX blocks 
+ * (for STA < 6.1.3.50.58 or for AP < 6.2.0.0.47)
+ */
+#define WL12XX_QUIRK_USE_2_SPARE_BLOCKS BIT(1)
+
 #endif
-- 
1.7.1

