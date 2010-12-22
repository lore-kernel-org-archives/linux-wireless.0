Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62245 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab0LVO2R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 09:28:17 -0500
Received: by wwa36 with SMTP id 36so5334430wwa.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Dec 2010 06:28:16 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2 08/18] wl1271: Add AP related definitions to HOST-FW interface
Date: Wed, 22 Dec 2010 16:27:27 +0200
Message-Id: <1293028057-6212-9-git-send-email-arik@wizery.com>
In-Reply-To: <1293028057-6212-1-git-send-email-arik@wizery.com>
References: <1293028057-6212-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change structures in a non-destructive manner. This means no
changes in size or location of existing members used by STA.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/event.h  |    7 ++++++-
 drivers/net/wireless/wl12xx/rx.h     |   12 ++++++++----
 drivers/net/wireless/wl12xx/tx.h     |    9 +++++++--
 drivers/net/wireless/wl12xx/wl12xx.h |   18 +++++++++++++++++-
 4 files changed, 38 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/event.h b/drivers/net/wireless/wl12xx/event.h
index fd955f3..1d5ef67 100644
--- a/drivers/net/wireless/wl12xx/event.h
+++ b/drivers/net/wireless/wl12xx/event.h
@@ -116,7 +116,12 @@ struct event_mailbox {
 	u8 scheduled_scan_status;
 	u8 ps_status;
 
-	u8 reserved_5[29];
+	/* AP FW only */
+	u8 hlid_removed;
+	__le16 sta_aging_status;
+	__le16 sta_tx_retry_exceeded;
+
+	u8 reserved_5[24];
 } __packed;
 
 int wl1271_event_unmask(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/rx.h b/drivers/net/wireless/wl12xx/rx.h
index 3abb26f..19fd591 100644
--- a/drivers/net/wireless/wl12xx/rx.h
+++ b/drivers/net/wireless/wl12xx/rx.h
@@ -86,10 +86,11 @@
 /*
  * RX Descriptor status
  *
- * Bits 0-2 - status
- * Bits 3-7 - reserved
+ * Bits 0-2 - error code
+ * Bits 3-5 - process_id tag (AP mode FW)
+ * Bits 6-7 - reserved
  */
-#define WL1271_RX_DESC_STATUS_MASK      0x07
+#define WL1271_RX_DESC_STATUS_MASK      0x03
 
 #define WL1271_RX_DESC_SUCCESS          0x00
 #define WL1271_RX_DESC_DECRYPT_FAIL     0x01
@@ -110,7 +111,10 @@ struct wl1271_rx_descriptor {
 	u8  snr;
 	__le32 timestamp;
 	u8  packet_class;
-	u8  process_id;
+	union {
+		u8  process_id; /* STA FW */
+		u8  hlid; /* AP FW */
+	} __packed;
 	u8  pad_len;
 	u8  reserved;
 } __packed;
diff --git a/drivers/net/wireless/wl12xx/tx.h b/drivers/net/wireless/wl12xx/tx.h
index 903e5dc..0662b19 100644
--- a/drivers/net/wireless/wl12xx/tx.h
+++ b/drivers/net/wireless/wl12xx/tx.h
@@ -29,6 +29,7 @@
 #define TX_HW_BLOCK_SIZE                 252
 
 #define TX_HW_MGMT_PKT_LIFETIME_TU       2000
+#define TX_HW_AP_MODE_PKT_LIFETIME_TU    8000
 /* The chipset reference driver states, that the "aid" value 1
  * is for infra-BSS, but is still always used */
 #define TX_HW_DEFAULT_AID                1
@@ -77,8 +78,12 @@ struct wl1271_tx_hw_descr {
 	u8 id;
 	/* The packet TID value (as User-Priority) */
 	u8 tid;
-	/* Identifier of the remote STA in IBSS, 1 in infra-BSS */
-	u8 aid;
+	union {
+		/* STA - Identifier of the remote STA in IBSS, 1 in infra-BSS */
+		u8 aid;
+		/* AP - host link ID (HLID) */
+		u8 hlid;
+	} __packed;
 	u8 reserved;
 } __packed;
 
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 136e87b..ebb4a4d 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -195,6 +195,11 @@ struct wl1271_stats {
 #define NUM_TX_QUEUES              4
 #define NUM_RX_PKT_DESC            8
 
+#define AP_MAX_STATIONS            5
+
+/* Broadcast and Global links + links to stations */
+#define AP_MAX_LINKS               (AP_MAX_STATIONS + 2)
+
 /* FW status registers */
 struct wl1271_fw_status {
 	__le32 intr;
@@ -205,7 +210,18 @@ struct wl1271_fw_status {
 	__le32 rx_pkt_descs[NUM_RX_PKT_DESC];
 	__le32 tx_released_blks[NUM_TX_QUEUES];
 	__le32 fw_localtime;
-	__le32 padding[2];
+
+	/* Next fields valid only in AP FW */
+
+	/*
+	 * A bitmap (where each bit represents a single HLID)
+	 * to indicate if the station is in PS mode.
+	 */
+	__le32 link_ps_bitmap;
+
+	/* Number of freed MBs per HLID */
+	u8 tx_lnk_free_blks[AP_MAX_LINKS];
+	u8 padding_1[1];
 } __packed;
 
 struct wl1271_rx_mem_pool_addr {
-- 
1.7.1

