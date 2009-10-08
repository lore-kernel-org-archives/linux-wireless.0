Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:56652 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759724AbZJHS6p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2009 14:58:45 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 17/20] wl1271: Add connection monitoring configuration
Date: Thu,  8 Oct 2009 21:56:33 +0300
Message-Id: <1255028196-6565-18-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255028196-6565-1-git-send-email-luciano.coelho@nokia.com>
References: <1255028196-6565-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Add configuration for connection monitor (number of allowed beacons, and
timeout after last received beacon.)

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_acx.c  |   30 +++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_acx.h  |   11 ++++++++++
 drivers/net/wireless/wl12xx/wl1271_init.c |    6 +++++
 3 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index a457123..4b5fd94 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -442,6 +442,36 @@ out:
 	return ret;
 }
 
+int wl1271_acx_conn_monit_params(struct wl1271 *wl)
+{
+	struct acx_conn_monit_params *acx;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx connection monitor parameters");
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	acx->synch_fail_thold = SYNCH_FAIL_DEFAULT_THRESHOLD;
+	acx->bss_lose_timeout = NO_BEACON_DEFAULT_TIMEOUT;
+
+	ret = wl1271_cmd_configure(wl, ACX_CONN_MONIT_PARAMS,
+				   acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("failed to set connection monitor "
+			       "parameters: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
+
+
 int wl1271_acx_sg_enable(struct wl1271 *wl)
 {
 	struct acx_bt_wlan_coex *pta;
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index dae1fed..bb21bcb 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -406,6 +406,16 @@ struct acx_beacon_filter_ie_table {
 	u8 pad[3];
 } __attribute__ ((packed));
 
+#define SYNCH_FAIL_DEFAULT_THRESHOLD    5     /* number of beacons */
+#define NO_BEACON_DEFAULT_TIMEOUT       (100) /* TU */
+
+struct acx_conn_monit_params {
+       struct acx_header header;
+
+       u32 synch_fail_thold; /* number of beacons missed */
+       u32 bss_lose_timeout; /* number of TU's from synch fail */
+};
+
 enum {
 	SG_ENABLE = 0,
 	SG_DISABLE,
@@ -1198,6 +1208,7 @@ int wl1271_acx_service_period_timeout(struct wl1271 *wl);
 int wl1271_acx_rts_threshold(struct wl1271 *wl, u16 rts_threshold);
 int wl1271_acx_beacon_filter_opt(struct wl1271 *wl);
 int wl1271_acx_beacon_filter_table(struct wl1271 *wl);
+int wl1271_acx_conn_monit_params(struct wl1271 *wl);
 int wl1271_acx_sg_enable(struct wl1271 *wl);
 int wl1271_acx_sg_cfg(struct wl1271 *wl);
 int wl1271_acx_cca_threshold(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/wl1271_init.c b/drivers/net/wireless/wl12xx/wl1271_init.c
index 49ff407..d3db3fb 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.c
+++ b/drivers/net/wireless/wl12xx/wl1271_init.c
@@ -323,6 +323,11 @@ int wl1271_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		goto out_free_memmap;
 
+	/* Initialize connection monitoring thresholds */
+	ret = wl1271_acx_conn_monit_params(wl);
+	if (ret < 0)
+		goto out_free_memmap;
+
 	/* Beacon filtering */
 	ret = wl1271_init_beacon_filter(wl);
 	if (ret < 0)
@@ -392,6 +397,7 @@ int wl1271_hw_init(struct wl1271 *wl)
 
  out_free_memmap:
 	kfree(wl->target_mem_map);
+	wl->target_mem_map = NULL;
 
 	return ret;
 }
-- 
1.5.6.5

