Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37683 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab2KVTCT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 14:02:19 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so3047979eek.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2012 11:02:18 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 06/14] wl18xx: increase MAX_CHANNELS_5GHZ
Date: Thu, 22 Nov 2012 18:06:16 +0200
Message-Id: <1353600384-32462-7-git-send-email-eliad@wizery.com> (sfid-20121122_200237_540662_EED92FDA)
In-Reply-To: <1353600384-32462-1-git-send-email-eliad@wizery.com>
References: <1353600384-32462-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some regdomains have more than 23 valid 5ghz channels,
so 18xx's MAX_CHANNELS_5GHZ was increased to 32.

Since now we have different max 5ghz channels values
for wl12xx and wl18xx, add a new wl->max_channels_5ghz
field, and use it for scan channels configuration.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |    1 +
 drivers/net/wireless/ti/wl12xx/scan.h   |    4 +++-
 drivers/net/wireless/ti/wl18xx/main.c   |    1 +
 drivers/net/wireless/ti/wl18xx/scan.h   |    4 +++-
 drivers/net/wireless/ti/wlcore/scan.c   |    6 +++---
 drivers/net/wireless/ti/wlcore/scan.h   |   10 +++++++++-
 drivers/net/wireless/ti/wlcore/wlcore.h |    1 +
 7 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index ada7031..0c81eeb 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -704,6 +704,7 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
 	wl->scan_templ_id_5 = CMD_TEMPL_APP_PROBE_REQ_5_LEGACY;
 	wl->sched_scan_templ_id_2_4 = CMD_TEMPL_CFG_PROBE_REQ_2_4;
 	wl->sched_scan_templ_id_5 = CMD_TEMPL_CFG_PROBE_REQ_5;
+	wl->max_channels_5 = WL12XX_MAX_CHANNELS_5GHZ;
 out:
 	return ret;
 }
diff --git a/drivers/net/wireless/ti/wl12xx/scan.h b/drivers/net/wireless/ti/wl12xx/scan.h
index bd075de..264af7a 100644
--- a/drivers/net/wireless/ti/wl12xx/scan.h
+++ b/drivers/net/wireless/ti/wl12xx/scan.h
@@ -26,6 +26,8 @@
 #include "../wlcore/cmd.h"
 #include "../wlcore/scan.h"
 
+#define WL12XX_MAX_CHANNELS_5GHZ 23
+
 struct basic_scan_params {
 	/* Scan option flags (WL1271_SCAN_OPT_*) */
 	__le16 scan_options;
@@ -107,7 +109,7 @@ struct wl1271_cmd_sched_scan_config {
 	u8 role_id;
 	u8 padding[1];
 	struct conn_scan_ch_params channels_2[MAX_CHANNELS_2GHZ];
-	struct conn_scan_ch_params channels_5[MAX_CHANNELS_5GHZ];
+	struct conn_scan_ch_params channels_5[WL12XX_MAX_CHANNELS_5GHZ];
 	struct conn_scan_ch_params channels_4[MAX_CHANNELS_4GHZ];
 } __packed;
 
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 97c23c8..e81b351 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -636,6 +636,7 @@ static int wl18xx_identify_chip(struct wl1271 *wl)
 	wl->scan_templ_id_5 = CMD_TEMPL_CFG_PROBE_REQ_5;
 	wl->sched_scan_templ_id_2_4 = CMD_TEMPL_PROBE_REQ_2_4_PERIODIC;
 	wl->sched_scan_templ_id_5 = CMD_TEMPL_PROBE_REQ_5_PERIODIC;
+	wl->max_channels_5 = WL18XX_MAX_CHANNELS_5GHZ;
 out:
 	return ret;
 }
diff --git a/drivers/net/wireless/ti/wl18xx/scan.h b/drivers/net/wireless/ti/wl18xx/scan.h
index 404baf1..0e026ec 100644
--- a/drivers/net/wireless/ti/wl18xx/scan.h
+++ b/drivers/net/wireless/ti/wl18xx/scan.h
@@ -50,6 +50,8 @@ enum
 	WL18XX_SCAN_RATE_6	= 2,
 };
 
+#define WL18XX_MAX_CHANNELS_5GHZ 32
+
 struct wl18xx_cmd_scan_params {
 	struct wl1271_cmd_header header;
 
@@ -89,7 +91,7 @@ struct wl18xx_cmd_scan_params {
 	union {
 		struct {
 			struct conn_scan_ch_params channels_2[MAX_CHANNELS_2GHZ];
-			struct conn_scan_ch_params channels_5[MAX_CHANNELS_5GHZ];
+			struct conn_scan_ch_params channels_5[WL18XX_MAX_CHANNELS_5GHZ];
 			struct conn_scan_ch_params channels_4[MAX_CHANNELS_4GHZ];
 		};
 		struct tracking_ch_params channels_tracking[WL1271_SCAN_MAX_CHANNELS];
diff --git a/drivers/net/wireless/ti/wlcore/scan.c b/drivers/net/wireless/ti/wlcore/scan.c
index 9eab64d..e7d0a02 100644
--- a/drivers/net/wireless/ti/wlcore/scan.c
+++ b/drivers/net/wireless/ti/wlcore/scan.c
@@ -228,7 +228,7 @@ wlcore_set_scan_chan_params(struct wl1271 *wl,
 					 cfg->channels_5,
 					 IEEE80211_BAND_5GHZ,
 					 false, true, 0,
-					 MAX_CHANNELS_5GHZ,
+					 wl->max_channels_5,
 					 &n_pactive_ch);
 	cfg->dfs =
 		wlcore_scan_get_channels(wl,
@@ -239,7 +239,7 @@ wlcore_set_scan_chan_params(struct wl1271 *wl,
 					 IEEE80211_BAND_5GHZ,
 					 true, true,
 					 cfg->passive[1],
-					 MAX_CHANNELS_5GHZ,
+					 wl->max_channels_5,
 					 &n_pactive_ch);
 	cfg->active[1] =
 		wlcore_scan_get_channels(wl,
@@ -250,7 +250,7 @@ wlcore_set_scan_chan_params(struct wl1271 *wl,
 					 IEEE80211_BAND_5GHZ,
 					 false, false,
 					 cfg->passive[1] + cfg->dfs,
-					 MAX_CHANNELS_5GHZ,
+					 wl->max_channels_5,
 					 &n_pactive_ch);
 
 	/* 802.11j channels are not supported yet */
diff --git a/drivers/net/wireless/ti/wlcore/scan.h b/drivers/net/wireless/ti/wlcore/scan.h
index 25b0422..8465f35 100644
--- a/drivers/net/wireless/ti/wlcore/scan.h
+++ b/drivers/net/wireless/ti/wlcore/scan.h
@@ -71,9 +71,17 @@ struct wl1271_cmd_trigger_scan_to {
 } __packed;
 
 #define MAX_CHANNELS_2GHZ	14
-#define MAX_CHANNELS_5GHZ	23
 #define MAX_CHANNELS_4GHZ	4
 
+/*
+ * This max value here is used only for the struct definition of
+ * wlcore_scan_channels. This struct is used by both 12xx
+ * and 18xx (which have different max 5ghz channels value).
+ * In order to make sure this is large enough, just use the
+ * max possible 5ghz channels.
+ */
+#define MAX_CHANNELS_5GHZ	42
+
 #define SCAN_MAX_CYCLE_INTERVALS 16
 #define SCAN_MAX_BANDS 3
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 9f82ee3..36fde4e 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -382,6 +382,7 @@ struct wl1271 {
 	u8 scan_templ_id_5;
 	u8 sched_scan_templ_id_2_4;
 	u8 sched_scan_templ_id_5;
+	u8 max_channels_5;
 
 	/* per-chip-family private structure */
 	void *priv;
-- 
1.7.6.401.g6a319

