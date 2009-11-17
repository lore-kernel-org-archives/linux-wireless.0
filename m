Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:17856 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbZKQQsT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 11:48:19 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 01/16] wl1251: Add connection monitoring configuration
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Nov 2009 18:48:14 +0200
Message-ID: <20091117164813.2236.91626.stgit@tikku>
In-Reply-To: <20091117164614.2236.8543.stgit@tikku>
References: <20091117164614.2236.8543.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Add configuration for connection monitor (number of allowed beacons, and
timeout after last received beacon.)

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251_acx.c  |   29 +++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1251_acx.h  |   11 +++++++++++
 drivers/net/wireless/wl12xx/wl1251_init.c |    5 +++++
 3 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_acx.c b/drivers/net/wireless/wl12xx/wl1251_acx.c
index 10b26c4..4a9c708 100644
--- a/drivers/net/wireless/wl12xx/wl1251_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1251_acx.c
@@ -550,6 +550,35 @@ out:
 	return ret;
 }
 
+int wl1251_acx_conn_monit_params(struct wl1251 *wl)
+{
+	struct acx_conn_monit_params *acx;
+	int ret;
+
+	wl1251_debug(DEBUG_ACX, "acx connection monitor parameters");
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
+	ret = wl1251_cmd_configure(wl, ACX_CONN_MONIT_PARAMS,
+				   acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1251_warning("failed to set connection monitor "
+			       "parameters: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
+
 int wl1251_acx_sg_enable(struct wl1251 *wl)
 {
 	struct acx_bt_wlan_coex *pta;
diff --git a/drivers/net/wireless/wl12xx/wl1251_acx.h b/drivers/net/wireless/wl12xx/wl1251_acx.h
index cafb914..926789c 100644
--- a/drivers/net/wireless/wl12xx/wl1251_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1251_acx.h
@@ -458,6 +458,16 @@ struct acx_beacon_filter_ie_table {
 	u8 pad[3];
 } __attribute__ ((packed));
 
+#define SYNCH_FAIL_DEFAULT_THRESHOLD    5     /* number of beacons */
+#define NO_BEACON_DEFAULT_TIMEOUT       (100) /* TU */
+
+struct acx_conn_monit_params {
+	struct acx_header header;
+
+	u32 synch_fail_thold; /* number of beacons missed */
+	u32 bss_lose_timeout; /* number of TU's from synch fail */
+};
+
 enum {
 	SG_ENABLE = 0,
 	SG_DISABLE,
@@ -1275,6 +1285,7 @@ int wl1251_acx_service_period_timeout(struct wl1251 *wl);
 int wl1251_acx_rts_threshold(struct wl1251 *wl, u16 rts_threshold);
 int wl1251_acx_beacon_filter_opt(struct wl1251 *wl);
 int wl1251_acx_beacon_filter_table(struct wl1251 *wl);
+int wl1251_acx_conn_monit_params(struct wl1251 *wl);
 int wl1251_acx_sg_enable(struct wl1251 *wl);
 int wl1251_acx_sg_cfg(struct wl1251 *wl);
 int wl1251_acx_cca_threshold(struct wl1251 *wl);
diff --git a/drivers/net/wireless/wl12xx/wl1251_init.c b/drivers/net/wireless/wl12xx/wl1251_init.c
index b2ee4f4..035ab11 100644
--- a/drivers/net/wireless/wl12xx/wl1251_init.c
+++ b/drivers/net/wireless/wl12xx/wl1251_init.c
@@ -364,6 +364,11 @@ int wl1251_hw_init(struct wl1251 *wl)
 	if (ret < 0)
 		goto out_free_data_path;
 
+	/* Initialize connection monitoring thresholds */
+	ret = wl1251_acx_conn_monit_params(wl);
+	if (ret < 0)
+		goto out_free_data_path;
+
 	/* Beacon filtering */
 	ret = wl1251_hw_init_beacon_filter(wl);
 	if (ret < 0)

