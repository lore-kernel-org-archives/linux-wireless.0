Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:57386 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755662Ab2FUONd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 10:13:33 -0400
Received: by lbbgk8 with SMTP id gk8so2382260lbb.12
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jun 2012 07:13:26 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 05/12] wl18xx: increase Rx descriptors for PG2
Date: Thu, 21 Jun 2012 17:13:04 +0300
Message-Id: <1340287991-15241-6-git-send-email-coelho@ti.com> (sfid-20120621_161423_874484_973EF880)
In-Reply-To: <1340287991-15241-1-git-send-email-coelho@ti.com>
References: <1340287991-15241-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

New PG2 firmwares have additional Rx descriptors.

Add a module parameter to manually set the number of Rx descriptors for
older versions (PG1). We cannot discriminate based on chip-id, since
this value must be set on probe.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index d3f171d..18cf19c 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -47,6 +47,7 @@ static char *ht_mode_param = "wide";
 static char *board_type_param = "hdk";
 static bool checksum_param = false;
 static bool enable_11a_param = true;
+static int num_rx_desc_param = -1;
 
 /* phy paramters */
 static int dc2dc_param = -1;
@@ -1286,7 +1287,7 @@ static int __devinit wl18xx_probe(struct platform_device *pdev)
 	wl->ptable = wl18xx_ptable;
 	wl->rtable = wl18xx_rtable;
 	wl->num_tx_desc = 32;
-	wl->num_rx_desc = 16;
+	wl->num_rx_desc = 32;
 	wl->band_rate_to_idx = wl18xx_band_rate_to_idx;
 	wl->hw_tx_rate_tbl_size = WL18XX_CONF_HW_RXTX_RATE_MAX;
 	wl->hw_min_ht_rate = WL18XX_CONF_HW_RXTX_RATE_MCS0;
@@ -1294,6 +1295,9 @@ static int __devinit wl18xx_probe(struct platform_device *pdev)
 	wl->stats.fw_stats_len = sizeof(struct wl18xx_acx_statistics);
 	wl->static_data_priv_len = sizeof(struct wl18xx_static_data_priv);
 
+	if (num_rx_desc_param != -1)
+		wl->num_rx_desc = num_rx_desc_param;
+
 	if (!strcmp(ht_mode_param, "wide")) {
 		memcpy(&wl->ht_cap[IEEE80211_BAND_2GHZ],
 		       &wl18xx_siso40_ht_cap,
@@ -1458,6 +1462,11 @@ module_param_named(pwr_limit_reference_11_abg,
 MODULE_PARM_DESC(pwr_limit_reference_11_abg, "Power limit reference: u8 "
 		 "(default is 0xc8)");
 
+module_param_named(num_rx_desc,
+		   num_rx_desc_param, int, S_IRUSR);
+MODULE_PARM_DESC(num_rx_desc_param,
+		 "Number of Rx descriptors: u8 (default is 32)");
+
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Luciano Coelho <coelho@ti.com>");
 MODULE_FIRMWARE(WL18XX_FW_NAME);
-- 
1.7.10

