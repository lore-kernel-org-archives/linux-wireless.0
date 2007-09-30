Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:27371 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbXI3Ska (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2007 14:40:30 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 17/26] at76_usb: Move some parts from at76_usb.h to at76_usb.c
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 30 Sep 2007 14:40:27 -0400
Message-ID: <20070930184027.23921.49109.stgit@tt.roinet.com>
In-Reply-To: <20070930183409.23921.97762.stgit@tt.roinet.com>
References: <20070930183409.23921.97762.stgit@tt.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't include anything from at76_usb.h.  Keep DRIVER_NAME and
DRIVER_VERSION together.  Define at76_dbg() after DRIVER_NAME.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |   47 +++++++++++++++++++++++++++++++++++++--
 drivers/net/wireless/at76_usb.h |   46 --------------------------------------
 2 files changed, 45 insertions(+), 48 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index f470964..fc1b331 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -36,13 +36,56 @@
 #include <net/ieee80211_radiotap.h>
 #include <linux/firmware.h>
 #include <linux/leds.h>
+#include <net/ieee80211.h>
 
 #include "at76_usb.h"
 
 /* Version information */
 #define DRIVER_NAME "at76_usb"
+#define DRIVER_VERSION	"0.16"
 #define DRIVER_DESC "Atmel at76x USB Wireless LAN Driver"
 
+/* at76_debug bits */
+#define DBG_PROGRESS		0x00000001	/* authentication/accociation */
+#define DBG_BSS_TABLE		0x00000002	/* show BSS table after scans */
+#define DBG_IOCTL		0x00000004	/* ioctl calls / settings */
+#define DBG_MAC_STATE		0x00000008	/* MAC state transitions */
+#define DBG_TX_DATA		0x00000010	/* tx header */
+#define DBG_TX_DATA_CONTENT	0x00000020	/* tx content */
+#define DBG_TX_MGMT		0x00000040	/* tx management */
+#define DBG_RX_DATA		0x00000080	/* rx data header */
+#define DBG_RX_DATA_CONTENT	0x00000100	/* rx data content */
+#define DBG_RX_MGMT		0x00000200	/* rx mgmt frame headers */
+#define DBG_RX_BEACON		0x00000400	/* rx beacon */
+#define DBG_RX_CTRL		0x00000800	/* rx control */
+#define DBG_RX_MGMT_CONTENT	0x00001000	/* rx mgmt content */
+#define DBG_RX_FRAGS		0x00002000	/* rx data fragment handling */
+#define DBG_DEVSTART		0x00004000	/* fw download, device start */
+#define DBG_URB			0x00008000	/* rx urb status, ... */
+#define DBG_RX_ATMEL_HDR	0x00010000	/* Atmel-specific Rx headers */
+#define DBG_PROC_ENTRY		0x00020000	/* procedure entries/exits */
+#define DBG_PM			0x00040000	/* power management settings */
+#define DBG_BSS_MATCH		0x00080000	/* BSS match failures */
+#define DBG_PARAMS		0x00100000	/* show configured parameters */
+#define DBG_WAIT_COMPLETE	0x00200000	/* command completion */
+#define DBG_RX_FRAGS_SKB	0x00400000	/* skb header of Rx fragments */
+#define DBG_BSS_TABLE_RM	0x00800000	/* purging bss table entries */
+#define DBG_MONITOR_MODE	0x01000000	/* monitor mode */
+#define DBG_MIB			0x02000000	/* dump all MIBs on startup */
+#define DBG_MGMT_TIMER		0x04000000	/* dump mgmt_timer ops */
+#define DBG_WE_EVENTS		0x08000000	/* dump wireless events */
+#define DBG_FW			0x10000000	/* firmware download */
+#define DBG_DFU			0x20000000	/* device firmware upgrade */
+
+#define DBG_DEFAULTS		0
+
+/* Use our own dbg macro */
+#define at76_dbg(bits, format, arg...) \
+	do { \
+		if (at76_debug & (bits)) \
+		printk(KERN_DEBUG DRIVER_NAME ": " format "\n" , ## arg); \
+	} while (0)
+
 static int at76_debug = DBG_DEFAULTS;
 
 /* Protect against concurrent firmware loading and parsing */
@@ -199,6 +242,8 @@ static const long channel_frequency[] = {
 	2447, 2452, 2457, 2462, 2467, 2472, 2484
 };
 
+#define NUM_CHANNELS ARRAY_SIZE(channel_frequency)
+
 static const char *const preambles[] = { "long", "short", "auto" };
 
 static const char *const mac_states[] = {
@@ -211,8 +256,6 @@ static const char *const mac_states[] = {
 	[MAC_OWN_IBSS] = "OWN_IBSS"
 };
 
-#define NUM_CHANNELS ARRAY_SIZE(channel_frequency)
-
 /* Firmware download */
 /* DFU states */
 #define STATE_IDLE			0x00
diff --git a/drivers/net/wireless/at76_usb.h b/drivers/net/wireless/at76_usb.h
index 2737e85..6c3b76b 100644
--- a/drivers/net/wireless/at76_usb.h
+++ b/drivers/net/wireless/at76_usb.h
@@ -22,11 +22,6 @@
 #ifndef _AT76_USB_H
 #define _AT76_USB_H
 
-#include <net/ieee80211.h>
-
-/* current driver version */
-#define DRIVER_VERSION	"0.16"
-
 /* Board types */
 enum board_type {
 	BOARD_503_ISL3861 = 1,
@@ -621,45 +616,4 @@ struct at76_rx_radiotap {
 /* the max padding size for tx in bytes (see calc_padding) */
 #define MAX_PADDING_SIZE	53
 
-/* at76_debug bits */
-#define DBG_PROGRESS		0x00000001	/* authentication/accociation */
-#define DBG_BSS_TABLE		0x00000002	/* show BSS table after scans */
-#define DBG_IOCTL		0x00000004	/* ioctl calls / settings */
-#define DBG_MAC_STATE		0x00000008	/* MAC state transitions */
-#define DBG_TX_DATA		0x00000010	/* tx header */
-#define DBG_TX_DATA_CONTENT	0x00000020	/* tx content */
-#define DBG_TX_MGMT		0x00000040	/* tx management */
-#define DBG_RX_DATA		0x00000080	/* rx data header */
-#define DBG_RX_DATA_CONTENT	0x00000100	/* rx data content */
-#define DBG_RX_MGMT		0x00000200	/* rx mgmt frame headers */
-#define DBG_RX_BEACON		0x00000400	/* rx beacon */
-#define DBG_RX_CTRL		0x00000800	/* rx control */
-#define DBG_RX_MGMT_CONTENT	0x00001000	/* rx mgmt content */
-#define DBG_RX_FRAGS		0x00002000	/* rx data fragment handling */
-#define DBG_DEVSTART		0x00004000	/* fw download, device start */
-#define DBG_URB			0x00008000	/* rx urb status, ... */
-#define DBG_RX_ATMEL_HDR	0x00010000	/* Atmel-specific Rx headers */
-#define DBG_PROC_ENTRY		0x00020000	/* procedure entries/exits */
-#define DBG_PM			0x00040000	/* power management settings */
-#define DBG_BSS_MATCH		0x00080000	/* BSS match failures */
-#define DBG_PARAMS		0x00100000	/* show configured parameters */
-#define DBG_WAIT_COMPLETE	0x00200000	/* command completion */
-#define DBG_RX_FRAGS_SKB	0x00400000	/* skb header of Rx fragments */
-#define DBG_BSS_TABLE_RM	0x00800000	/* purging bss table entries */
-#define DBG_MONITOR_MODE	0x01000000	/* monitor mode */
-#define DBG_MIB			0x02000000	/* dump all MIBs on startup */
-#define DBG_MGMT_TIMER		0x04000000	/* dump mgmt_timer ops */
-#define DBG_WE_EVENTS		0x08000000	/* dump wireless events */
-#define DBG_FW			0x10000000	/* firmware download */
-#define DBG_DFU			0x20000000	/* device firmware upgrade */
-
-#define DBG_DEFAULTS		0
-
-/* Use our own dbg macro */
-#define at76_dbg(bits, format, arg...) \
-	do { \
-		if (at76_debug & (bits)) \
-		printk(KERN_DEBUG DRIVER_NAME ": " format "\n" , ## arg); \
-	} while (0)
-
 #endif				/* _AT76_USB_H */
