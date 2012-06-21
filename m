Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:34646 "EHLO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754578Ab2FUON3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 10:13:29 -0400
Received: by bkty8 with SMTP id y8so901174bkt.17
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jun 2012 07:13:23 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 03/12] wlcore: allow setting sleep_auth before interface init
Date: Thu, 21 Jun 2012 17:13:02 +0300
Message-Id: <1340287991-15241-4-git-send-email-coelho@ti.com> (sfid-20120621_161406_823056_394A626E)
In-Reply-To: <1340287991-15241-1-git-send-email-coelho@ti.com>
References: <1340287991-15241-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Hold a value for sta_sleep_auth that is amenable to change by debugfs.
When detecting a legal value in this variable on interface init, use it
as an override value for sleep_auth.

This makes debugging more intuitive using the debugfs value.

Increment the conf version since we added an element to the conf
structure.

Note: An AP going up will always set sleep_auth to PSM_CAM.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c    |    1 +
 drivers/net/wireless/ti/wl18xx/main.c    |    1 +
 drivers/net/wireless/ti/wlcore/acx.c     |    2 +-
 drivers/net/wireless/ti/wlcore/acx.h     |    3 +++
 drivers/net/wireless/ti/wlcore/conf.h    |    8 +++++++-
 drivers/net/wireless/ti/wlcore/debugfs.c |    7 ++++++-
 drivers/net/wireless/ti/wlcore/init.c    |    8 +++++++-
 drivers/net/wireless/ti/wlcore/main.c    |    2 +-
 8 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 85d1600..7974ed5 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -246,6 +246,7 @@ static struct wlcore_conf wl12xx_conf = {
 		.forced_ps                   = false,
 		.keep_alive_interval         = 55000,
 		.max_listen_interval         = 20,
+		.sta_sleep_auth              = WL1271_PSM_ILLEGAL,
 	},
 	.itrim = {
 		.enable = false,
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index b2ccff7..d3f171d 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -372,6 +372,7 @@ static struct wlcore_conf wl18xx_conf = {
 		.forced_ps                   = false,
 		.keep_alive_interval         = 55000,
 		.max_listen_interval         = 20,
+		.sta_sleep_auth              = WL1271_PSM_ILLEGAL,
 	},
 	.itrim = {
 		.enable = false,
diff --git a/drivers/net/wireless/ti/wlcore/acx.c b/drivers/net/wireless/ti/wlcore/acx.c
index b56217f..3384bc1 100644
--- a/drivers/net/wireless/ti/wlcore/acx.c
+++ b/drivers/net/wireless/ti/wlcore/acx.c
@@ -70,7 +70,7 @@ int wl1271_acx_sleep_auth(struct wl1271 *wl, u8 sleep_auth)
 	struct acx_sleep_auth *auth;
 	int ret;
 
-	wl1271_debug(DEBUG_ACX, "acx sleep auth");
+	wl1271_debug(DEBUG_ACX, "acx sleep auth %d", sleep_auth);
 
 	auth = kzalloc(sizeof(*auth), GFP_KERNEL);
 	if (!auth) {
diff --git a/drivers/net/wireless/ti/wlcore/acx.h b/drivers/net/wireless/ti/wlcore/acx.h
index 168e046..d03215d 100644
--- a/drivers/net/wireless/ti/wlcore/acx.h
+++ b/drivers/net/wireless/ti/wlcore/acx.h
@@ -120,6 +120,9 @@ enum wl1271_psm_mode {
 	WL1271_PSM_ELP = 2,
 
 	WL1271_PSM_MAX = WL1271_PSM_ELP,
+
+	/* illegal out of band value of PSM mode */
+	WL1271_PSM_ILLEGAL = 0xff
 };
 
 struct acx_sleep_auth {
diff --git a/drivers/net/wireless/ti/wlcore/conf.h b/drivers/net/wireless/ti/wlcore/conf.h
index 03c6358..d77224f 100644
--- a/drivers/net/wireless/ti/wlcore/conf.h
+++ b/drivers/net/wireless/ti/wlcore/conf.h
@@ -951,6 +951,12 @@ struct conf_conn_settings {
 	 * Range: u16
 	 */
 	u8 max_listen_interval;
+
+	/*
+	 * Default sleep authorization for a new STA interface. This determines
+	 * whether we can go to ELP.
+	 */
+	u8 sta_sleep_auth;
 } __packed;
 
 enum {
@@ -1276,7 +1282,7 @@ struct conf_hangover_settings {
  * version, the two LSB are the lower driver's private conf
  * version.
  */
-#define WLCORE_CONF_VERSION	(0x0001 << 16)
+#define WLCORE_CONF_VERSION	(0x0002 << 16)
 #define WLCORE_CONF_MASK	0xffff0000
 #define WLCORE_CONF_SIZE	(sizeof(struct wlcore_conf_header) +	\
 				 sizeof(struct wlcore_conf))
diff --git a/drivers/net/wireless/ti/wlcore/debugfs.c b/drivers/net/wireless/ti/wlcore/debugfs.c
index 91e43de..1768f37 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.c
+++ b/drivers/net/wireless/ti/wlcore/debugfs.c
@@ -995,8 +995,13 @@ static ssize_t sleep_auth_write(struct file *file,
 
 	mutex_lock(&wl->mutex);
 
-	if (wl->state == WL1271_STATE_OFF)
+	wl->conf.conn.sta_sleep_auth = value;
+
+	if (wl->state == WL1271_STATE_OFF) {
+		/* this will show up on "read" in case we are off */
+		wl->sleep_auth = value;
 		goto out;
+	}
 
 	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
diff --git a/drivers/net/wireless/ti/wlcore/init.c b/drivers/net/wireless/ti/wlcore/init.c
index 645abd4..3fb9352 100644
--- a/drivers/net/wireless/ti/wlcore/init.c
+++ b/drivers/net/wireless/ti/wlcore/init.c
@@ -565,7 +565,13 @@ int wl1271_init_vif_specific(struct wl1271 *wl, struct ieee80211_vif *vif)
 			if (ret < 0)
 				return ret;
 		} else if (!wl->sta_count) {
-			if (wl->quirks & WLCORE_QUIRK_NO_ELP) {
+			u8 sta_auth = wl->conf.conn.sta_sleep_auth;
+			if (sta_auth != WL1271_PSM_ILLEGAL) {
+				/* Configure for power according to debugfs */
+				ret = wl1271_acx_sleep_auth(wl, sta_auth);
+				if (ret < 0)
+					return ret;
+			} else if (wl->quirks & WLCORE_QUIRK_NO_ELP) {
 				/* Configure for power always on */
 				ret = wl1271_acx_sleep_auth(wl, WL1271_PSM_CAM);
 				if (ret < 0)
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 7677cd5..69643d1 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5176,7 +5176,7 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size)
 	wl->channel_type = NL80211_CHAN_NO_HT;
 	wl->flags = 0;
 	wl->sg_enabled = true;
-	wl->sleep_auth = WL1271_PSM_CAM;
+	wl->sleep_auth = WL1271_PSM_ILLEGAL;
 	wl->hw_pg_ver = -1;
 	wl->ap_ps_map = 0;
 	wl->ap_fw_ps_map = 0;
-- 
1.7.10

