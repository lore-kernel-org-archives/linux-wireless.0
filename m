Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44746 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab1DRNk1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 09:40:27 -0400
Received: by wya21 with SMTP id 21so3916813wya.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 06:40:26 -0700 (PDT)
From: Ido Yariv <ido@wizery.com>
To: "Luciano Coelho" <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, Ido Yariv <ido@wizery.com>
Subject: [PATCH] wl12xx: Modify memory configuration for 128x/AP
Date: Mon, 18 Apr 2011 16:40:14 +0300
Message-Id: <1303134014-31393-1-git-send-email-ido@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 128x/AP firmware does not yet support dynamic memory. Temporarily,
the memory configuration for the 127x was used both for 127x/AP as well
as 128x/AP. Since the two chips don't have the same number of memory
blocks, TP was significantly degraded.

This hasn't been fine tuned yet, but using the base 128x numbers
(without dynamic memory) seems to yield much better results (around 30%
more). Additional fine tuning will be required in the future.

Signed-off-by: Ido Yariv <ido@wizery.com>
---
 drivers/net/wireless/wl12xx/acx.c |   22 +++++++++++++++-------
 1 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index b277947..ab7b731 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -954,6 +954,7 @@ out:
 int wl1271_acx_ap_mem_cfg(struct wl1271 *wl)
 {
 	struct wl1271_acx_ap_config_memory *mem_conf;
+	struct conf_memory_settings *mem;
 	int ret;
 
 	wl1271_debug(DEBUG_ACX, "wl1271 mem cfg");
@@ -964,14 +965,21 @@ int wl1271_acx_ap_mem_cfg(struct wl1271 *wl)
 		goto out;
 	}
 
+	if (wl->chip.id == CHIP_ID_1283_PG20)
+		/*
+		 * FIXME: The 128x AP FW does not yet support dynamic memory.
+		 * Use the base memory configuration for 128x for now. This
+		 * should be fine tuned in the future.
+		 */
+		mem = &wl->conf.mem_wl128x;
+	else
+		mem = &wl->conf.mem_wl127x;
+
 	/* memory config */
-	/* FIXME: for now we always use mem_wl127x for AP, because it
-	 * doesn't support dynamic memory and we don't have the
-	 * optimal values for wl128x without dynamic memory yet */
-	mem_conf->num_stations = wl->conf.mem_wl127x.num_stations;
-	mem_conf->rx_mem_block_num = wl->conf.mem_wl127x.rx_block_num;
-	mem_conf->tx_min_mem_block_num = wl->conf.mem_wl127x.tx_min_block_num;
-	mem_conf->num_ssid_profiles = wl->conf.mem_wl127x.ssid_profiles;
+	mem_conf->num_stations = mem->num_stations;
+	mem_conf->rx_mem_block_num = mem->rx_block_num;
+	mem_conf->tx_min_mem_block_num = mem->tx_min_block_num;
+	mem_conf->num_ssid_profiles = mem->ssid_profiles;
 	mem_conf->total_tx_descriptors = cpu_to_le32(ACX_TX_DESCRIPTORS);
 
 	ret = wl1271_cmd_configure(wl, ACX_MEM_CFG, mem_conf,
-- 
1.7.1

