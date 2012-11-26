Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:39058 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab2KZQGH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 11:06:07 -0500
Received: by mail-wi0-f174.google.com with SMTP id hm9so3611509wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2012 08:06:06 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 05/11] wlcore/wl18xx/wl12xx: separate channel count between chips
Date: Mon, 26 Nov 2012 18:05:44 +0200
Message-Id: <1353945950-3899-6-git-send-email-arik@wizery.com> (sfid-20121126_170637_803238_000468F4)
In-Reply-To: <1353945950-3899-1-git-send-email-arik@wizery.com>
References: <1353945950-3899-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

18xx chips are capable of staying on 2 channels at the same time.
Introduce a chip-family specific parameter to set the number of channels
in the interface-combinations published by the driver.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |    1 +
 drivers/net/wireless/ti/wl18xx/main.c   |    1 +
 drivers/net/wireless/ti/wlcore/main.c   |    4 ++--
 drivers/net/wireless/ti/wlcore/wlcore.h |    3 +++
 4 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 032a639..dafcdf6 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1676,6 +1676,7 @@ static int wl12xx_setup(struct wl1271 *wl)
 	wl->rtable = wl12xx_rtable;
 	wl->num_tx_desc = WL12XX_NUM_TX_DESCRIPTORS;
 	wl->num_rx_desc = WL12XX_NUM_RX_DESCRIPTORS;
+	wl->num_channels = 1;
 	wl->num_mac_addr = WL12XX_NUM_MAC_ADDRESSES;
 	wl->band_rate_to_idx = wl12xx_band_rate_to_idx;
 	wl->hw_tx_rate_tbl_size = WL12XX_CONF_HW_RXTX_RATE_MAX;
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 5e81d9c..9d2fa91 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1456,6 +1456,7 @@ static int wl18xx_setup(struct wl1271 *wl)
 	wl->rtable = wl18xx_rtable;
 	wl->num_tx_desc = WL18XX_NUM_TX_DESCRIPTORS;
 	wl->num_rx_desc = WL18XX_NUM_TX_DESCRIPTORS;
+	wl->num_channels = 2;
 	wl->num_mac_addr = WL18XX_NUM_MAC_ADDRESSES;
 	wl->band_rate_to_idx = wl18xx_band_rate_to_idx;
 	wl->hw_tx_rate_tbl_size = WL18XX_CONF_HW_RXTX_RATE_MAX;
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 49ff7ee..f628297c 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5464,10 +5464,9 @@ static const struct ieee80211_iface_limit wlcore_iface_limits[] = {
 	},
 };
 
-static const struct ieee80211_iface_combination
+static struct ieee80211_iface_combination
 wlcore_iface_combinations[] = {
 	{
-	  .num_different_channels = 1,
 	  .max_interfaces = 3,
 	  .limits = wlcore_iface_limits,
 	  .n_limits = ARRAY_SIZE(wlcore_iface_limits),
@@ -5570,6 +5569,7 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_P2P;
 
 	/* allowed interface combinations */
+	wlcore_iface_combinations[0].num_different_channels = wl->num_channels;
 	wl->hw->wiphy->iface_combinations = wlcore_iface_combinations;
 	wl->hw->wiphy->n_iface_combinations =
 		ARRAY_SIZE(wlcore_iface_combinations);
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 037c56e..5f580e5 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -441,6 +441,9 @@ struct wl1271 {
 	unsigned int min_fw_ver[NUM_FW_VER];
 
 	struct completion nvs_loading_complete;
+
+	/* number of concurrent channels the HW supports */
+	u32 num_channels;
 };
 
 int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev);
-- 
1.7.9.5

