Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40220 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab1DRLPu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 07:15:50 -0400
Received: by wya21 with SMTP id 21so3798215wya.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 04:15:48 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 03/10] wl12xx: AP-mode - disable beacon filtering on start up
Date: Mon, 18 Apr 2011 14:15:22 +0300
Message-Id: <1303125329-27214-3-git-send-email-arik@wizery.com>
In-Reply-To: <1303125329-27214-1-git-send-email-arik@wizery.com>
References: <1303125329-27214-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New AP-mode FWs filter external beacons by default. Disable this
filtering on start up so we can properly configure ERP protection.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/acx.c  |   25 +++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/acx.h  |   10 +++++++++-
 drivers/net/wireless/wl12xx/init.c |    8 ++++++++
 3 files changed, 42 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index 6a0fd18..e9bc995 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -1646,3 +1646,28 @@ out:
 	kfree(acx);
 	return ret;
 }
+
+int wl1271_acx_set_ap_beacon_filter(struct wl1271 *wl, bool enable)
+{
+	struct acx_ap_beacon_filter *acx = NULL;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx set ap beacon filter: %d", enable);
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx)
+		return -ENOMEM;
+
+	acx->enable = enable ? 1 : 0;
+
+	ret = wl1271_cmd_configure(wl, ACX_AP_BEACON_FILTER_OPT,
+				   acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("acx set ap beacon filter failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index 31cb8c2..abbb214 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -303,7 +303,6 @@ struct acx_beacon_filter_option {
 	struct acx_header header;
 
 	u8 enable;
-
 	/*
 	 * The number of beacons without the unicast TIM
 	 * bit set that the firmware buffers before
@@ -1181,6 +1180,13 @@ struct wl1271_acx_inconnection_sta {
 	u8 padding1[2];
 } __packed;
 
+struct acx_ap_beacon_filter {
+	struct acx_header header;
+
+	u8 enable;
+	u8 pad[3];
+} __packed;
+
 enum {
 	ACX_WAKE_UP_CONDITIONS      = 0x0002,
 	ACX_MEM_CFG                 = 0x0003,
@@ -1199,6 +1205,7 @@ enum {
 	ACX_TID_CFG                 = 0x001A,
 	ACX_PS_RX_STREAMING         = 0x001B,
 	ACX_BEACON_FILTER_OPT       = 0x001F,
+	ACX_AP_BEACON_FILTER_OPT    = 0x0020,
 	ACX_NOISE_HIST              = 0x0021,
 	ACX_HDK_VERSION             = 0x0022, /* ??? */
 	ACX_PD_THRESHOLD            = 0x0023,
@@ -1320,5 +1327,6 @@ int wl1271_acx_tsf_info(struct wl1271 *wl, u64 *mactime);
 int wl1271_acx_max_tx_retry(struct wl1271 *wl);
 int wl1271_acx_config_ps(struct wl1271 *wl);
 int wl1271_acx_set_inconnection_sta(struct wl1271 *wl, u8 *addr);
+int wl1271_acx_set_ap_beacon_filter(struct wl1271 *wl, bool enable);
 
 #endif /* __WL1271_ACX_H__ */
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index 40015d0..645f740 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -466,6 +466,14 @@ static int wl1271_ap_hw_init_post_mem(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
+	/*
+	 * when operating as AP we want to receive external beacons for
+	 * configuring ERP protection.
+	 */
+	ret = wl1271_acx_set_ap_beacon_filter(wl, false);
+	if (ret < 0)
+		return ret;
+
 	return 0;
 }
 
-- 
1.7.1

