Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:44365 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab1CFO21 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 09:28:27 -0500
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 14/15] wl12xx: 1281/1283 support - disable TX aggregation for AP mode in wl128x
Date: Sun,  6 Mar 2011 16:32:19 +0200
Message-Id: <1299421940-26292-15-git-send-email-shahar_levi@ti.com>
In-Reply-To: <1299421940-26292-1-git-send-email-shahar_levi@ti.com>
References: <1299421940-26292-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

This is a workaround for the HW bug we're encountering when operating
with 48Mhz SDIO clocks. This workaround is currently employed by the MCP
driver as well.

This is not healthy for CPU usage, and UDP TX seems hurt by this change.
TCP RX/TX seems unchanged from Trio or the 1-spare-block FW variant.

With this workaround we get a working AP on Blaze.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/tx.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 9c0ec06..831248e 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -568,6 +568,11 @@ void wl1271_tx_work_locked(struct wl1271 *wl)
 		}
 		buf_offset += ret;
 		wl->tx_packets_count++;
+
+		/* Disable packet aggregation for 1283 AP-mode */
+		if (wl->chip.id == CHIP_ID_1283_PG20 &&
+		    wl->bss_type == BSS_TYPE_AP_BSS)
+			break;
 	}
 
 out_ack:
-- 
1.7.0.4

