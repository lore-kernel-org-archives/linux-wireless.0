Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50831 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758712Ab2EJJQ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:16:57 -0400
Received: by mail-wi0-f178.google.com with SMTP id hn19so247958wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:16:56 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 66/78] wl18xx: print the PHY firmware version from the private static data
Date: Thu, 10 May 2012 12:14:11 +0300
Message-Id: <1336641263-5761-67-git-send-email-arik@wizery.com> (sfid-20120510_111725_624105_9C29A06D)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

The wl18xx firmware writes the PHY firmware version in the static
data.  Add an operation to parse the static data and print the PHY
firmware version when booting.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c   |   13 +++++++++++++
 drivers/net/wireless/ti/wl18xx/wl18xx.h |    6 ++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 24673e3..8262a4f 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1016,6 +1016,17 @@ static int wl18xx_debugfs_init(struct wl1271 *wl, struct dentry *rootdir)
 	return wl18xx_debugfs_add_files(wl, rootdir);
 }
 
+static int wl18xx_handle_static_data(struct wl1271 *wl,
+				     struct wl1271_static_data *static_data)
+{
+	struct wl18xx_static_data_priv *static_data_priv =
+		(struct wl18xx_static_data_priv *) static_data->priv;
+
+	wl1271_info("PHY firmware version: %s", static_data_priv->phy_version);
+
+	return 0;
+}
+
 static struct wlcore_ops wl18xx_ops = {
 	.identify_chip	= wl18xx_identify_chip,
 	.boot		= wl18xx_boot,
@@ -1037,6 +1048,7 @@ static struct wlcore_ops wl18xx_ops = {
 	.ap_get_mimo_wide_rate_mask = wl18xx_ap_get_mimo_wide_rate_mask,
 	.get_mac	= wl18xx_get_mac,
 	.debugfs_init	= wl18xx_debugfs_init,
+	.handle_static_data	= wl18xx_handle_static_data,
 };
 
 /* HT cap appropriate for wide channels */
@@ -1092,6 +1104,7 @@ int __devinit wl18xx_probe(struct platform_device *pdev)
 	wl->hw_min_ht_rate = WL18XX_CONF_HW_RXTX_RATE_MCS0;
 	wl->fw_status_priv_len = sizeof(struct wl18xx_fw_status_priv);
 	wl->stats.fw_stats_len = sizeof(struct wl18xx_acx_statistics);
+	wl->static_data_priv_len = sizeof(struct wl18xx_static_data_priv);
 	memcpy(&wl->ht_cap, &wl18xx_ht_cap, sizeof(wl18xx_ht_cap));
 	if (ht_mode_param && !strcmp(ht_mode_param, "mimo"))
 		memcpy(&wl->ht_cap, &wl18xx_mimo_ht_cap,
diff --git a/drivers/net/wireless/ti/wl18xx/wl18xx.h b/drivers/net/wireless/ti/wl18xx/wl18xx.h
index 75abb5b..34e202b 100644
--- a/drivers/net/wireless/ti/wl18xx/wl18xx.h
+++ b/drivers/net/wireless/ti/wl18xx/wl18xx.h
@@ -56,6 +56,12 @@ struct wl18xx_fw_status_priv {
 	u8 padding[2];
 };
 
+#define WL18XX_PHY_VERSION_MAX_LEN 20
+
+struct wl18xx_static_data_priv {
+	char phy_version[WL18XX_PHY_VERSION_MAX_LEN];
+};
+
 struct wl18xx_clk_cfg {
 	u32 n;
 	u32 m;
-- 
1.7.9.5

