Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:30698 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab0CZKyI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 06:54:08 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 14/24] wl1271: Disable connection monitoring while not associated
Date: Fri, 26 Mar 2010 12:53:23 +0200
Message-Id: <1269600813-32145-15-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
References: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

The wl1271 does not support disabling the connection monitor feature.
Perform the next best thing by increasing the beacon-loss threshold and
BSS_LOSE event timeout to the maximum values.

This is needed, because we really don't want any random probe-requests during
scanning or especially while in ad-hoc mode and not beaconing.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_acx.c  |   18 ++++++++++++++----
 drivers/net/wireless/wl12xx/wl1271_acx.h  |    2 +-
 drivers/net/wireless/wl12xx/wl1271_init.c |    2 +-
 drivers/net/wireless/wl12xx/wl1271_main.c |   12 +++++++++++-
 4 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index 7e337ce..e7d1181 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -504,12 +504,17 @@ out:
 	return ret;
 }
 
-int wl1271_acx_conn_monit_params(struct wl1271 *wl)
+#define ACX_CONN_MONIT_DISABLE_VALUE  0xffffffff
+
+int wl1271_acx_conn_monit_params(struct wl1271 *wl, bool enable)
 {
 	struct acx_conn_monit_params *acx;
+	u32 threshold = ACX_CONN_MONIT_DISABLE_VALUE;
+	u32 timeout = ACX_CONN_MONIT_DISABLE_VALUE;
 	int ret;
 
-	wl1271_debug(DEBUG_ACX, "acx connection monitor parameters");
+	wl1271_debug(DEBUG_ACX, "acx connection monitor parameters: %s",
+		     enable ? "enabled" : "disabled");
 
 	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
 	if (!acx) {
@@ -517,8 +522,13 @@ int wl1271_acx_conn_monit_params(struct wl1271 *wl)
 		goto out;
 	}
 
-	acx->synch_fail_thold = cpu_to_le32(wl->conf.conn.synch_fail_thold);
-	acx->bss_lose_timeout = cpu_to_le32(wl->conf.conn.bss_lose_timeout);
+	if (enable) {
+		threshold = wl->conf.conn.synch_fail_thold;
+		timeout = wl->conf.conn.bss_lose_timeout;
+	}
+
+	acx->synch_fail_thold = cpu_to_le32(threshold);
+	acx->bss_lose_timeout = cpu_to_le32(timeout);
 
 	ret = wl1271_cmd_configure(wl, ACX_CONN_MONIT_PARAMS,
 				   acx, sizeof(*acx));
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index 8e5870f..b6eb0c1 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -1004,7 +1004,7 @@ int wl1271_acx_rts_threshold(struct wl1271 *wl, u16 rts_threshold);
 int wl1271_acx_dco_itrim_params(struct wl1271 *wl);
 int wl1271_acx_beacon_filter_opt(struct wl1271 *wl, bool enable_filter);
 int wl1271_acx_beacon_filter_table(struct wl1271 *wl);
-int wl1271_acx_conn_monit_params(struct wl1271 *wl);
+int wl1271_acx_conn_monit_params(struct wl1271 *wl, bool enable);
 int wl1271_acx_sg_enable(struct wl1271 *wl, bool enable);
 int wl1271_acx_sg_cfg(struct wl1271 *wl);
 int wl1271_acx_cca_threshold(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/wl1271_init.c b/drivers/net/wireless/wl12xx/wl1271_init.c
index d9335fc..987978c 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.c
+++ b/drivers/net/wireless/wl12xx/wl1271_init.c
@@ -236,7 +236,7 @@ int wl1271_hw_init(struct wl1271 *wl)
 		goto out_free_memmap;
 
 	/* Initialize connection monitoring thresholds */
-	ret = wl1271_acx_conn_monit_params(wl);
+	ret = wl1271_acx_conn_monit_params(wl, false);
 	if (ret < 0)
 		goto out_free_memmap;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 4a2f1d7..00e856c 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -348,7 +348,7 @@ static int wl1271_plt_init(struct wl1271 *wl)
 		goto out_free_memmap;
 
 	/* Initialize connection monitoring thresholds */
-	ret = wl1271_acx_conn_monit_params(wl);
+	ret = wl1271_acx_conn_monit_params(wl, false);
 	if (ret < 0)
 		goto out_free_memmap;
 
@@ -1651,6 +1651,11 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			if (ret < 0)
 				goto out_sleep;
 
+			/* enable the connection monitoring feature */
+			ret = wl1271_acx_conn_monit_params(wl, true);
+			if (ret < 0)
+				goto out_sleep;
+
 			/* If we want to go in PSM but we're not there yet */
 			if (test_bit(WL1271_FLAG_PSM_REQUESTED, &wl->flags) &&
 			    !test_bit(WL1271_FLAG_PSM, &wl->flags)) {
@@ -1663,6 +1668,11 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			/* use defaults when not associated */
 			clear_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags);
 			wl->aid = 0;
+
+			/* disable connection monitor features */
+			ret = wl1271_acx_conn_monit_params(wl, false);
+			if (ret < 0)
+				goto out_sleep;
 		}
 
 	}
-- 
1.6.3.3

