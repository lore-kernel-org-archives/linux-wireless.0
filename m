Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:58739 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758102Ab2EJJPf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:15:35 -0400
Received: by mail-wg0-f42.google.com with SMTP id ds11so231730wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:15:35 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 30/78] wl18xx: set HT capabilities
Date: Thu, 10 May 2012 12:13:35 +0300
Message-Id: <1336641263-5761-31-git-send-email-arik@wizery.com> (sfid-20120510_112311_313957_AD8F2BBC)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Define the default HT capabilities of the 18xx chip family - these include
support for wide-channel.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 9da94e6..a0bec8f 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -922,6 +922,20 @@ static struct wlcore_ops wl18xx_ops = {
 	.ap_get_mimo_wide_rate_mask = wl18xx_ap_get_mimo_wide_rate_mask,
 };
 
+/* HT cap appropriate for wide channels */
+static struct ieee80211_sta_ht_cap wl18xx_ht_cap = {
+	.cap = IEEE80211_HT_CAP_SGI_20 | IEEE80211_HT_CAP_SGI_40 |
+	       IEEE80211_HT_CAP_SUP_WIDTH_20_40 | IEEE80211_HT_CAP_DSSSCCK40,
+	.ht_supported = true,
+	.ampdu_factor = IEEE80211_HT_MAX_AMPDU_16K,
+	.ampdu_density = IEEE80211_HT_MPDU_DENSITY_16,
+	.mcs = {
+		.rx_mask = { 0xff, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
+		.rx_highest = cpu_to_le16(150),
+		.tx_params = IEEE80211_HT_MCS_TX_DEFINED,
+		},
+};
+
 int __devinit wl18xx_probe(struct platform_device *pdev)
 {
 	struct wl1271 *wl;
@@ -945,6 +959,7 @@ int __devinit wl18xx_probe(struct platform_device *pdev)
 	wl->hw_tx_rate_tbl_size = WL18XX_CONF_HW_RXTX_RATE_MAX;
 	wl->hw_min_ht_rate = WL18XX_CONF_HW_RXTX_RATE_MCS0;
 	wl->fw_status_priv_len = sizeof(struct wl18xx_fw_status_priv);
+	memcpy(&wl->ht_cap, &wl18xx_ht_cap, sizeof(wl18xx_ht_cap));
 	wl18xx_conf_init(wl);
 
 	return wlcore_probe(wl, pdev);
-- 
1.7.9.5

