Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51169 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757883Ab2EJJQQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:16:16 -0400
Received: by mail-wi0-f172.google.com with SMTP id hr2so244170wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:16:15 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 48/78] wl18xx: add module parameter to disable TCP checksum
Date: Thu, 10 May 2012 12:13:53 +0300
Message-Id: <1336641263-5761-49-git-send-email-arik@wizery.com> (sfid-20120510_112045_609920_2E805307)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

Add a new module parameter to disable TCP checksum offload.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 2f0cbf8..b76b6ac 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -47,6 +47,7 @@ static char *board_type_param;
 static bool dc2dc_param = false;
 static int n_antennas_2_param = 1;
 static int n_antennas_5_param = 1;
+static bool checksum_param = true;
 
 static const u8 wl18xx_rate_to_idx_2ghz[] = {
 	/* MCS rates are used only with 11n */
@@ -865,9 +866,11 @@ static int wl18xx_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
-	ret = wl18xx_acx_set_checksum_state(wl);
-	if (ret != 0)
-		return ret;
+	if (checksum_param) {
+		ret = wl18xx_acx_set_checksum_state(wl);
+		if (ret != 0)
+			return ret;
+	}
 
 	return ret;
 }
@@ -879,6 +882,11 @@ static void wl18xx_set_tx_desc_csum(struct wl1271 *wl,
 	u32 ip_hdr_offset;
 	struct iphdr *ip_hdr;
 
+	if (!checksum_param) {
+		desc->wl18xx_checksum_data = 0;
+		return;
+	}
+
 	if (skb->ip_summed != CHECKSUM_PARTIAL) {
 		desc->wl18xx_checksum_data = 0;
 		return;
@@ -1065,6 +1073,11 @@ int __devinit wl18xx_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
+	if (!checksum_param) {
+		wl18xx_ops.set_rx_csum = NULL;
+		wl18xx_ops.init_vif = NULL;
+	}
+
 	wl18xx_conf_init(wl);
 
 	return wlcore_probe(wl, pdev);
@@ -1114,6 +1127,9 @@ MODULE_PARM_DESC(n_antennas_2, "Number of installed 2.4GHz antennas: 1 (default)
 module_param_named(n_antennas_5, n_antennas_5_param, uint, S_IRUSR);
 MODULE_PARM_DESC(n_antennas_5, "Number of installed 5GHz antennas: 1 (default) or 2");
 
+module_param_named(checksum, checksum_param, bool, S_IRUSR);
+MODULE_PARM_DESC(checksum, "Enable TCP checksum: boolean (defaults to true)");
+
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Luciano Coelho <coelho@ti.com>");
 MODULE_FIRMWARE(WL18XX_FW_NAME);
-- 
1.7.9.5

