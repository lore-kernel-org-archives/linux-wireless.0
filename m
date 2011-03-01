Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36990 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914Ab1CANPJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 08:15:09 -0500
Received: by mail-ww0-f44.google.com with SMTP id 22so4420741wwb.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2011 05:15:09 -0800 (PST)
From: Ido Yariv <ido@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, Ido Yariv <ido@wizery.com>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v2 2/7] wl12xx: Do end-of-transactions transfers only if needed
Date: Tue,  1 Mar 2011 15:14:39 +0200
Message-Id: <1298985284-6048-3-git-send-email-ido@wizery.com>
In-Reply-To: <1298985284-6048-1-git-send-email-ido@wizery.com>
References: <1298985284-6048-1-git-send-email-ido@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On newer hardware revisions, there is no need to write the host's
counter at the end of a RX transaction. The same applies to writing the
number of packets at the end of a TX transaction.

It is generally a good idea to avoid unnecessary SDIO/SPI transfers.
Throughput and CPU usage are improved when avoiding these.

Send the host's RX counter and the TX packet count only if needed, based
on the hardware revision.

Signed-off-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/net/wireless/wl12xx/boot.c   |    3 +++
 drivers/net/wireless/wl12xx/boot.h   |    5 +++++
 drivers/net/wireless/wl12xx/main.c   |    1 +
 drivers/net/wireless/wl12xx/rx.c     |    8 +++++++-
 drivers/net/wireless/wl12xx/tx.c     |   10 ++++++++--
 drivers/net/wireless/wl12xx/wl12xx.h |    8 ++++++++
 6 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index 1ffbad6..6934dff 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -488,6 +488,9 @@ static void wl1271_boot_hw_version(struct wl1271 *wl)
 	fuse = (fuse & PG_VER_MASK) >> PG_VER_OFFSET;
 
 	wl->hw_pg_ver = (s8)fuse;
+
+	if (((wl->hw_pg_ver & PG_MAJOR_VER_MASK) >> PG_MAJOR_VER_OFFSET) < 3)
+		wl->quirks |= WL12XX_QUIRK_END_OF_TRANSACTION;
 }
 
 /* uploads NVS and firmware */
diff --git a/drivers/net/wireless/wl12xx/boot.h b/drivers/net/wireless/wl12xx/boot.h
index d67dcff..17229b8 100644
--- a/drivers/net/wireless/wl12xx/boot.h
+++ b/drivers/net/wireless/wl12xx/boot.h
@@ -59,6 +59,11 @@ struct wl1271_static_data {
 #define PG_VER_MASK          0x3c
 #define PG_VER_OFFSET        2
 
+#define PG_MAJOR_VER_MASK    0x3
+#define PG_MAJOR_VER_OFFSET  0x0
+#define PG_MINOR_VER_MASK    0xc
+#define PG_MINOR_VER_OFFSET  0x2
+
 #define CMD_MBOX_ADDRESS     0x407B4
 
 #define POLARITY_LOW         BIT(1)
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 443f829..ad5ea77 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3406,6 +3406,7 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->last_tx_hlid = 0;
 	wl->ap_ps_map = 0;
 	wl->ap_fw_ps_map = 0;
+	wl->quirks = 0;
 
 	memset(wl->tx_frames_map, 0, sizeof(wl->tx_frames_map));
 	for (i = 0; i < ACX_TX_DESCRIPTORS; i++)
diff --git a/drivers/net/wireless/wl12xx/rx.c b/drivers/net/wireless/wl12xx/rx.c
index 3d13d7a..4e7a3b3 100644
--- a/drivers/net/wireless/wl12xx/rx.c
+++ b/drivers/net/wireless/wl12xx/rx.c
@@ -198,7 +198,13 @@ void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_common_status *status)
 			pkt_offset += pkt_length;
 		}
 	}
-	wl1271_write32(wl, RX_DRIVER_COUNTER_ADDRESS, wl->rx_counter);
+
+	/*
+	 * Write the driver's packet counter to the FW. This is only required
+	 * for older hardware revisions
+	 */
+	if (wl->quirks & WL12XX_QUIRK_END_OF_TRANSACTION)
+		wl1271_write32(wl, RX_DRIVER_COUNTER_ADDRESS, wl->rx_counter);
 }
 
 void wl1271_set_default_filters(struct wl1271 *wl)
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index ac60d57..e7ada41 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -506,8 +506,14 @@ out_ack:
 		sent_packets = true;
 	}
 	if (sent_packets) {
-		/* interrupt the firmware with the new packets */
-		wl1271_write32(wl, WL1271_HOST_WR_ACCESS, wl->tx_packets_count);
+		/*
+		 * Interrupt the firmware with the new packets. This is only
+		 * required for older hardware revisions
+		 */
+		if (wl->quirks & WL12XX_QUIRK_END_OF_TRANSACTION)
+			wl1271_write32(wl, WL1271_HOST_WR_ACCESS,
+				       wl->tx_packets_count);
+
 		wl1271_handle_tx_low_watermark(wl);
 	}
 
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 338acc9..6ee4de8 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -535,6 +535,9 @@ struct wl1271 {
 
 	/* AP-mode - a bitmap of links currently in PS mode in mac80211 */
 	unsigned long ap_ps_map;
+
+	/* Quirks of specific hardware revisions */
+	unsigned int quirks;
 };
 
 struct wl1271_station {
@@ -562,4 +565,9 @@ int wl1271_plt_stop(struct wl1271 *wl);
 #define HW_BG_RATES_MASK	0xffff
 #define HW_HT_RATES_OFFSET	16
 
+/* Quirks */
+
+/* Each RX/TX transaction requires an end-of-transaction transfer */
+#define WL12XX_QUIRK_END_OF_TRANSACTION	BIT(1)
+
 #endif
-- 
1.7.1

