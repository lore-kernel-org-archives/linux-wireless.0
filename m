Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51169 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758738Ab2EJJRB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:17:01 -0400
Received: by mail-wi0-f172.google.com with SMTP id hr2so244170wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:17:01 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 68/78] wl18xx: don't use MIMO when ht_mode is set to wide
Date: Thu, 10 May 2012 12:14:13 +0300
Message-Id: <1336641263-5761-69-git-send-email-arik@wizery.com> (sfid-20120510_111711_611758_721C525A)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

If the wl18xx module is loaded with ht_mode=wide (the default), we
shouldn't use MIMO rates when the channel type is not HT40.  Fix this
by checking the ht_mode before deciding which rates to used.
Additionally, set the ht_mode parameter explicitly to "wide" as the
default.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 8262a4f..6a81edf 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -42,7 +42,7 @@
 
 #define WL18XX_RX_CHECKSUM_MASK      0x40
 
-static char *ht_mode_param;
+static char *ht_mode_param = "wide";
 static char *board_type_param = "hdk";
 static bool dc2dc_param = false;
 static int n_antennas_2_param = 1;
@@ -941,11 +941,12 @@ static u32 wl18xx_sta_get_ap_rate_mask(struct wl1271 *wl,
 static u32 wl18xx_ap_get_mimo_wide_rate_mask(struct wl1271 *wl,
 					     struct wl12xx_vif *wlvif)
 {
-	if (wlvif->channel_type == NL80211_CHAN_HT40MINUS ||
-	    wlvif->channel_type == NL80211_CHAN_HT40PLUS) {
+	if ((wlvif->channel_type == NL80211_CHAN_HT40MINUS ||
+	     wlvif->channel_type == NL80211_CHAN_HT40PLUS) &&
+	    !strcmp(ht_mode_param, "wide")) {
 		wl1271_debug(DEBUG_ACX, "using wide channel rate mask");
 		return CONF_TX_RATE_USE_WIDE_CHAN;
-	} else {
+	} else if (!strcmp(ht_mode_param, "mimo")) {
 		wl1271_debug(DEBUG_ACX, "using MIMO rate mask");
 
 		/*
@@ -959,6 +960,8 @@ static u32 wl18xx_ap_get_mimo_wide_rate_mask(struct wl1271 *wl,
 			return CONF_TX_MIMO_RATES & ~CONF_HW_BIT_RATE_MCS_13;
 
 		return CONF_TX_MIMO_RATES;
+	} else {
+		return 0;
 	}
 }
 
@@ -1106,7 +1109,7 @@ int __devinit wl18xx_probe(struct platform_device *pdev)
 	wl->stats.fw_stats_len = sizeof(struct wl18xx_acx_statistics);
 	wl->static_data_priv_len = sizeof(struct wl18xx_static_data_priv);
 	memcpy(&wl->ht_cap, &wl18xx_ht_cap, sizeof(wl18xx_ht_cap));
-	if (ht_mode_param && !strcmp(ht_mode_param, "mimo"))
+	if (!strcmp(ht_mode_param, "mimo"))
 		memcpy(&wl->ht_cap, &wl18xx_mimo_ht_cap,
 		       sizeof(wl18xx_mimo_ht_cap));
 
-- 
1.7.9.5

