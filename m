Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46316 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153Ab2FPTb6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jun 2012 15:31:58 -0400
Received: by wgbdr13 with SMTP id dr13so4229776wgb.1
        for <linux-wireless@vger.kernel.org>; Sat, 16 Jun 2012 12:31:57 -0700 (PDT)
From: Grazvydas Ignotas <notasas@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH 2/3] wl1251: fix filtering support
Date: Sat, 16 Jun 2012 22:31:49 +0300
Message-Id: <1339875110-10260-3-git-send-email-notasas@gmail.com> (sfid-20120616_213201_960907_F00BC340)
In-Reply-To: <1339875110-10260-1-git-send-email-notasas@gmail.com>
References: <1339875110-10260-1-git-send-email-notasas@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This driver has a hack in cmd.c which effectively disables all filtering.
This seems to be triggering a firmware bug where it stops reporting any
rx packets after random time on some routers, which is eliminated (or at
least appears much more rarely) when filtering is on.
I have found that only BSSID filter needs to be disabled for association
to work, so disable only that instead of all filtering.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/net/wireless/ti/wl1251/cmd.c  |    9 ---------
 drivers/net/wireless/ti/wl1251/main.c |    6 ++++++
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/cmd.c b/drivers/net/wireless/ti/wl1251/cmd.c
index d14d69d..6822b84 100644
--- a/drivers/net/wireless/ti/wl1251/cmd.c
+++ b/drivers/net/wireless/ti/wl1251/cmd.c
@@ -277,15 +277,6 @@ int wl1251_cmd_join(struct wl1251 *wl, u8 bss_type, u8 channel,
 	join->rx_config_options = wl->rx_config;
 	join->rx_filter_options = wl->rx_filter;
 
-	/*
-	 * FIXME: disable temporarily all filters because after commit
-	 * 9cef8737 "mac80211: fix managed mode BSSID handling" broke
-	 * association. The filter logic needs to be implemented properly
-	 * and once that is done, this hack can be removed.
-	 */
-	join->rx_config_options = 0;
-	join->rx_filter_options = WL1251_DEFAULT_RX_FILTER;
-
 	join->basic_rate_set = RATE_MASK_1MBPS | RATE_MASK_2MBPS |
 		RATE_MASK_5_5MBPS | RATE_MASK_11MBPS;
 
diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index ff60a7a..6094e3f 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -334,6 +334,12 @@ static int wl1251_join(struct wl1251 *wl, u8 bss_type, u8 channel,
 	if (ret < 0)
 		goto out;
 
+	/*
+	 * Join command applies filters, and if we are not associated,
+	 * BSSID filter must be disabled for association to work.
+	 */
+	if (is_zero_ether_addr(wl->bssid))
+		wl->rx_config &= ~CFG_BSSID_FILTER_EN;
 
 	ret = wl1251_cmd_join(wl, bss_type, channel, beacon_interval,
 			      dtim_period);
-- 
1.7.0.4

