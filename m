Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51169 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758131Ab2EJJPh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:15:37 -0400
Received: by mail-wi0-f172.google.com with SMTP id hr2so244170wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:15:37 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 31/78] wl18xx: add module param for overriding HT caps
Date: Thu, 10 May 2012 12:13:36 +0300
Message-Id: <1336641263-5761-32-git-send-email-arik@wizery.com> (sfid-20120510_112246_161869_AF943B24)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set an alternate HT cap allowing MIMO rates (but only 20mhz) channels,
when the module is loaded with ht_mode=mimo.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index a0bec8f..17792e2 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -41,6 +41,8 @@
 
 #define WL18XX_RX_CHECKSUM_MASK      0x40
 
+static char *ht_mode_param;
+
 static const u8 wl18xx_rate_to_idx_2ghz[] = {
 	/* MCS rates are used only with 11n */
 	15,                            /* WL18XX_CONF_HW_RXTX_RATE_MCS15 */
@@ -936,6 +938,19 @@ static struct ieee80211_sta_ht_cap wl18xx_ht_cap = {
 		},
 };
 
+/* HT cap appropriate for MIMO rates in 20mhz channel */
+static struct ieee80211_sta_ht_cap wl18xx_mimo_ht_cap = {
+	.cap = IEEE80211_HT_CAP_SGI_20,
+	.ht_supported = true,
+	.ampdu_factor = IEEE80211_HT_MAX_AMPDU_16K,
+	.ampdu_density = IEEE80211_HT_MPDU_DENSITY_16,
+	.mcs = {
+		.rx_mask = { 0xff, 0xff, 0, 0, 0, 0, 0, 0, 0, 0, },
+		.rx_highest = cpu_to_le16(144),
+		.tx_params = IEEE80211_HT_MCS_TX_DEFINED,
+		},
+};
+
 int __devinit wl18xx_probe(struct platform_device *pdev)
 {
 	struct wl1271 *wl;
@@ -960,6 +975,10 @@ int __devinit wl18xx_probe(struct platform_device *pdev)
 	wl->hw_min_ht_rate = WL18XX_CONF_HW_RXTX_RATE_MCS0;
 	wl->fw_status_priv_len = sizeof(struct wl18xx_fw_status_priv);
 	memcpy(&wl->ht_cap, &wl18xx_ht_cap, sizeof(wl18xx_ht_cap));
+	if (ht_mode_param && !strcmp(ht_mode_param, "mimo"))
+		memcpy(&wl->ht_cap, &wl18xx_mimo_ht_cap,
+		       sizeof(wl18xx_mimo_ht_cap));
+
 	wl18xx_conf_init(wl);
 
 	return wlcore_probe(wl, pdev);
@@ -993,6 +1012,9 @@ static void __exit wl18xx_exit(void)
 }
 module_exit(wl18xx_exit);
 
+module_param_named(ht_mode, ht_mode_param, charp, S_IRUSR);
+MODULE_PARM_DESC(ht_mode, "Force HT mode: wide or mimo");
+
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Luciano Coelho <coelho@ti.com>");
 MODULE_FIRMWARE(WL18XX_FW_NAME);
-- 
1.7.9.5

