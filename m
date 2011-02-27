Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:35232 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab1B0WbA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Feb 2011 17:31:00 -0500
Received: by wwe15 with SMTP id 15so2538990wwe.1
        for <linux-wireless@vger.kernel.org>; Sun, 27 Feb 2011 14:30:59 -0800 (PST)
From: Ido Yariv <ido@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, Ido Yariv <ido@wizery.com>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 2/7] wl12xx: Do end-of-transactions transfers only if needed
Date: Mon, 28 Feb 2011 00:30:40 +0200
Message-Id: <1298845845-12191-3-git-send-email-ido@wizery.com>
In-Reply-To: <1298845845-12191-1-git-send-email-ido@wizery.com>
References: <1298845845-12191-1-git-send-email-ido@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On newer hardware revisions, there is no need to write the host's
counter at the end of a RX transaction. The same applies to writing the
number of packets at the end of a TX transaction.

It is generally a good idea to avoid unnecessary SDIO/SPI transfers.
Throughput and CPU usage are improved when avoiding these.

Send the host's RX counter and the TX packet count only if needed, based
on the hardware revision.

The PG version mask was incorrect, so fix that as well.

Signed-off-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/net/wireless/wl12xx/boot.h |    2 +-
 drivers/net/wireless/wl12xx/rx.c   |    8 +++++++-
 drivers/net/wireless/wl12xx/tx.c   |   10 ++++++++--
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/boot.h b/drivers/net/wireless/wl12xx/boot.h
index d67dcff..55d7521 100644
--- a/drivers/net/wireless/wl12xx/boot.h
+++ b/drivers/net/wireless/wl12xx/boot.h
@@ -56,7 +56,7 @@ struct wl1271_static_data {
 #define OCP_REG_CLK_PULL     0x0cb4
 
 #define REG_FUSE_DATA_2_1    0x050a
-#define PG_VER_MASK          0x3c
+#define PG_VER_MASK          0xc
 #define PG_VER_OFFSET        2
 
 #define CMD_MBOX_ADDRESS     0x407B4
diff --git a/drivers/net/wireless/wl12xx/rx.c b/drivers/net/wireless/wl12xx/rx.c
index 3d13d7a..a07e3f9 100644
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
+	if (wl->hw_pg_ver < 3)
+		wl1271_write32(wl, RX_DRIVER_COUNTER_ADDRESS, wl->rx_counter);
 }
 
 void wl1271_set_default_filters(struct wl1271 *wl)
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index ac60d57..57bd3bd 100644
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
+		if (wl->hw_pg_ver < 3)
+			wl1271_write32(wl, WL1271_HOST_WR_ACCESS,
+				       wl->tx_packets_count);
+
 		wl1271_handle_tx_low_watermark(wl);
 	}
 
-- 
1.7.1

