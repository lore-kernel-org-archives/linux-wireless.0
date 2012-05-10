Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:35858 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758738Ab2EJJRG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:17:06 -0400
Received: by wgbds11 with SMTP id ds11so232996wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:17:05 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 70/78] wl18xx: add module parameter to force SISO 20MHz
Date: Thu, 10 May 2012 12:14:15 +0300
Message-Id: <1336641263-5761-71-git-send-email-arik@wizery.com> (sfid-20120510_111735_373358_B4337B22)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

In some cases it may be useful to force narrow-band SISO channels.
Add a new value to the ht_mode module parameter to force the device to
operate in SISO 20MHz.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |   38 +++++++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 6a81edf..0795598 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1055,7 +1055,7 @@ static struct wlcore_ops wl18xx_ops = {
 };
 
 /* HT cap appropriate for wide channels */
-static struct ieee80211_sta_ht_cap wl18xx_ht_cap = {
+static struct ieee80211_sta_ht_cap wl18xx_siso40_ht_cap = {
 	.cap = IEEE80211_HT_CAP_SGI_20 | IEEE80211_HT_CAP_SGI_40 |
 	       IEEE80211_HT_CAP_SUP_WIDTH_20_40 | IEEE80211_HT_CAP_DSSSCCK40,
 	.ht_supported = true,
@@ -1068,6 +1068,19 @@ static struct ieee80211_sta_ht_cap wl18xx_ht_cap = {
 		},
 };
 
+/* HT cap appropriate for SISO 20 */
+static struct ieee80211_sta_ht_cap wl18xx_siso20_ht_cap = {
+	.cap = IEEE80211_HT_CAP_SGI_20,
+	.ht_supported = true,
+	.ampdu_factor = IEEE80211_HT_MAX_AMPDU_16K,
+	.ampdu_density = IEEE80211_HT_MPDU_DENSITY_16,
+	.mcs = {
+		.rx_mask = { 0xff, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
+		.rx_highest = cpu_to_le16(72),
+		.tx_params = IEEE80211_HT_MCS_TX_DEFINED,
+		},
+};
+
 /* HT cap appropriate for MIMO rates in 20mhz channel */
 static struct ieee80211_sta_ht_cap wl18xx_mimo_ht_cap = {
 	.cap = IEEE80211_HT_CAP_SGI_20,
@@ -1108,10 +1121,20 @@ int __devinit wl18xx_probe(struct platform_device *pdev)
 	wl->fw_status_priv_len = sizeof(struct wl18xx_fw_status_priv);
 	wl->stats.fw_stats_len = sizeof(struct wl18xx_acx_statistics);
 	wl->static_data_priv_len = sizeof(struct wl18xx_static_data_priv);
-	memcpy(&wl->ht_cap, &wl18xx_ht_cap, sizeof(wl18xx_ht_cap));
-	if (!strcmp(ht_mode_param, "mimo"))
+
+	if (!strcmp(ht_mode_param, "wide")) {
+		memcpy(&wl->ht_cap, &wl18xx_siso40_ht_cap,
+		       sizeof(wl18xx_siso40_ht_cap));
+	} else if (!strcmp(ht_mode_param, "mimo")) {
 		memcpy(&wl->ht_cap, &wl18xx_mimo_ht_cap,
 		       sizeof(wl18xx_mimo_ht_cap));
+	} else if (!strcmp(ht_mode_param, "siso20")) {
+		memcpy(&wl->ht_cap, &wl18xx_siso20_ht_cap,
+		       sizeof(wl18xx_siso20_ht_cap));
+	} else {
+		wl1271_error("invalid ht_mode '%s'", ht_mode_param);
+		goto out_free;
+	}
 
 	wl18xx_conf_init(wl);
 
@@ -1131,8 +1154,7 @@ int __devinit wl18xx_probe(struct platform_device *pdev)
 		priv->conf.phy.low_band_component_type = 0x06;
 	} else {
 		wl1271_error("invalid board type '%s'", board_type_param);
-		wlcore_free_hw(wl);
-		return -EINVAL;
+		goto out_free;
 	}
 
 	if (!checksum_param) {
@@ -1143,6 +1165,10 @@ int __devinit wl18xx_probe(struct platform_device *pdev)
 	wl->enable_11a = enable_11a_param;
 
 	return wlcore_probe(wl, pdev);
+
+out_free:
+	wlcore_free_hw(wl);
+	return -EINVAL;
 }
 
 static const struct platform_device_id wl18xx_id_table[] __devinitconst = {
@@ -1174,7 +1200,7 @@ static void __exit wl18xx_exit(void)
 module_exit(wl18xx_exit);
 
 module_param_named(ht_mode, ht_mode_param, charp, S_IRUSR);
-MODULE_PARM_DESC(ht_mode, "Force HT mode: wide or mimo");
+MODULE_PARM_DESC(ht_mode, "Force HT mode: wide (default), mimo or siso20");
 
 module_param_named(board_type, board_type_param, charp, S_IRUSR);
 MODULE_PARM_DESC(board_type, "Board type: fpga, hdk (default), evb, com8 or "
-- 
1.7.9.5

