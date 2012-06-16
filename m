Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:53710 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819Ab2FPTb7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jun 2012 15:31:59 -0400
Received: by mail-we0-f174.google.com with SMTP id u7so2780503wey.19
        for <linux-wireless@vger.kernel.org>; Sat, 16 Jun 2012 12:31:59 -0700 (PDT)
From: Grazvydas Ignotas <notasas@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH 3/3] wl1251: send filters to firmware as they are set
Date: Sat, 16 Jun 2012 22:31:50 +0300
Message-Id: <1339875110-10260-4-git-send-email-notasas@gmail.com> (sfid-20120616_213204_454338_FF6BF390)
In-Reply-To: <1339875110-10260-1-git-send-email-notasas@gmail.com>
References: <1339875110-10260-1-git-send-email-notasas@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware supports changing filters using ACX_RX_CFG command,
so use it in .configure_filter callback. Firmware also supports
probe request filtering, so add it too along the way.
This will also re-enable BSSID filter which is now removed by
join command while associating.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/net/wireless/ti/wl1251/main.c |   27 +++++++++++++++++++++++----
 1 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index 6094e3f..3118c42 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -659,13 +659,15 @@ out:
 				  FIF_FCSFAIL | \
 				  FIF_BCN_PRBRESP_PROMISC | \
 				  FIF_CONTROL | \
-				  FIF_OTHER_BSS)
+				  FIF_OTHER_BSS | \
+				  FIF_PROBE_REQ)
 
 static void wl1251_op_configure_filter(struct ieee80211_hw *hw,
 				       unsigned int changed,
 				       unsigned int *total,u64 multicast)
 {
 	struct wl1251 *wl = hw->priv;
+	int ret;
 
 	wl1251_debug(DEBUG_MAC80211, "mac80211 configure filter");
 
@@ -676,7 +678,7 @@ static void wl1251_op_configure_filter(struct ieee80211_hw *hw,
 		/* no filters which we support changed */
 		return;
 
-	/* FIXME: wl->rx_config and wl->rx_filter are not protected */
+	mutex_lock(&wl->mutex);
 
 	wl->rx_config = WL1251_DEFAULT_RX_CONFIG;
 	wl->rx_filter = WL1251_DEFAULT_RX_FILTER;
@@ -699,8 +701,25 @@ static void wl1251_op_configure_filter(struct ieee80211_hw *hw,
 	}
 	if (*total & FIF_CONTROL)
 		wl->rx_filter |= CFG_RX_CTL_EN;
-	if (*total & FIF_OTHER_BSS)
-		wl->rx_filter &= ~CFG_BSSID_FILTER_EN;
+	if (*total & FIF_OTHER_BSS || is_zero_ether_addr(wl->bssid))
+		wl->rx_config &= ~CFG_BSSID_FILTER_EN;
+	if (*total & FIF_PROBE_REQ)
+		wl->rx_filter |= CFG_RX_PREQ_EN;
+
+	if (wl->state == WL1251_STATE_OFF)
+		goto out;
+
+	ret = wl1251_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	/* send filters to firmware */
+	wl1251_acx_rx_config(wl, wl->rx_config, wl->rx_filter);
+
+	wl1251_ps_elp_sleep(wl);
+
+out:
+	mutex_unlock(&wl->mutex);
 }
 
 /* HW encryption */
-- 
1.7.0.4

