Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36108 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab1HNKRb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 06:17:31 -0400
Received: by mail-ww0-f44.google.com with SMTP id 5so4060970wwf.1
        for <linux-wireless@vger.kernel.org>; Sun, 14 Aug 2011 03:17:30 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 14/40] wl12xx: use wl1271_acx_beacon_filter_opt for both sta and ap
Date: Sun, 14 Aug 2011 13:17:13 +0300
Message-Id: <1313317059-16567-15-git-send-email-eliad@wizery.com> (sfid-20110814_121737_972389_000D0310)
In-Reply-To: <1313317059-16567-1-git-send-email-eliad@wizery.com>
References: <1313317059-16567-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use ACX_BEACON_FILTER_OPT for both station and ap roles
(use the generic wl1271_acx_beacon_filter_opt()
instead of wl1271_acx_set_ap_beacon_filter() ).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/acx.c  |   25 -------------------------
 drivers/net/wireless/wl12xx/acx.h  |    9 ---------
 drivers/net/wireless/wl12xx/init.c |    2 +-
 drivers/net/wireless/wl12xx/main.c |    4 ++--
 4 files changed, 3 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index dfb1cbb..968d219 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -1657,37 +1657,12 @@ int wl1271_acx_set_inconnection_sta(struct wl1271 *wl, u8 *addr)
 
 out:
 	kfree(acx);
 	return ret;
 }
 
-int wl1271_acx_set_ap_beacon_filter(struct wl1271 *wl, bool enable)
-{
-	struct acx_ap_beacon_filter *acx = NULL;
-	int ret;
-
-	wl1271_debug(DEBUG_ACX, "acx set ap beacon filter: %d", enable);
-
-	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
-	if (!acx)
-		return -ENOMEM;
-
-	acx->enable = enable ? 1 : 0;
-
-	ret = wl1271_cmd_configure(wl, ACX_AP_BEACON_FILTER_OPT,
-				   acx, sizeof(*acx));
-	if (ret < 0) {
-		wl1271_warning("acx set ap beacon filter failed: %d", ret);
-		goto out;
-	}
-
-out:
-	kfree(acx);
-	return ret;
-}
-
 int wl1271_acx_fm_coex(struct wl1271 *wl)
 {
 	struct wl1271_acx_fm_coex *acx;
 	int ret;
 
 	wl1271_debug(DEBUG_ACX, "acx fm coex setting");
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index 67258a1..3aec410 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -1093,19 +1093,12 @@ struct wl1271_acx_inconnection_sta {
 	struct acx_header header;
 
 	u8 addr[ETH_ALEN];
 	u8 padding1[2];
 } __packed;
 
-struct acx_ap_beacon_filter {
-	struct acx_header header;
-
-	u8 enable;
-	u8 pad[3];
-} __packed;
-
 /*
  * ACX_FM_COEX_CFG
  * set the FM co-existence parameters.
  */
 struct wl1271_acx_fm_coex {
 	struct acx_header header;
@@ -1174,13 +1167,12 @@ enum {
 	ACX_STATISTICS              = 0x0013, /* Debug API */
 	ACX_PWR_CONSUMPTION_STATISTICS = 0x0014,
 	ACX_FEATURE_CFG             = 0x0015,
 	ACX_TID_CFG                 = 0x001A,
 	ACX_PS_RX_STREAMING         = 0x001B,
 	ACX_BEACON_FILTER_OPT       = 0x001F,
-	ACX_AP_BEACON_FILTER_OPT    = 0x0020,
 	ACX_NOISE_HIST              = 0x0021,
 	ACX_HDK_VERSION             = 0x0022, /* ??? */
 	ACX_PD_THRESHOLD            = 0x0023,
 	ACX_TX_CONFIG_OPT           = 0x0024,
 	ACX_CCA_THRESHOLD           = 0x0025,
 	ACX_EVENT_MBOX_MASK         = 0x0026,
@@ -1298,10 +1290,9 @@ int wl1271_acx_set_ba_receiver_session(struct wl1271 *wl, u8 tid_index, u16 ssn,
 				       bool enable);
 int wl1271_acx_tsf_info(struct wl1271 *wl, u64 *mactime);
 int wl1271_acx_ps_rx_streaming(struct wl1271 *wl, bool enable);
 int wl1271_acx_ap_max_tx_retry(struct wl1271 *wl);
 int wl1271_acx_config_ps(struct wl1271 *wl);
 int wl1271_acx_set_inconnection_sta(struct wl1271 *wl, u8 *addr);
-int wl1271_acx_set_ap_beacon_filter(struct wl1271 *wl, bool enable);
 int wl1271_acx_fm_coex(struct wl1271 *wl);
 
 #endif /* __WL1271_ACX_H__ */
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index 683c8d1..3a66609 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -466,13 +466,13 @@ int wl1271_ap_init_templates(struct wl1271 *wl)
 		return ret;
 
 	/*
 	 * when operating as AP we want to receive external beacons for
 	 * configuring ERP protection.
 	 */
-	ret = wl1271_acx_set_ap_beacon_filter(wl, false);
+	ret = wl1271_acx_beacon_filter_opt(wl, false);
 	if (ret < 0)
 		return ret;
 
 	return 0;
 }
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 1389c5c..d683bca 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1636,13 +1636,13 @@ static int wl1271_configure_suspend_ap(struct wl1271 *wl)
 		goto out_unlock;
 
 	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out_unlock;
 
-	ret = wl1271_acx_set_ap_beacon_filter(wl, true);
+	ret = wl1271_acx_beacon_filter_opt(wl, true);
 
 	wl1271_ps_elp_sleep(wl);
 out_unlock:
 	mutex_unlock(&wl->mutex);
 	return ret;
 
@@ -1674,13 +1674,13 @@ static void wl1271_configure_resume(struct wl1271 *wl)
 	if (is_sta) {
 		/* exit psm if it wasn't configured */
 		if (!test_bit(WL1271_FLAG_PSM_REQUESTED, &wl->flags))
 			wl1271_ps_set_mode(wl, STATION_ACTIVE_MODE,
 					   wl->basic_rate, true);
 	} else if (is_ap) {
-		wl1271_acx_set_ap_beacon_filter(wl, false);
+		wl1271_acx_beacon_filter_opt(wl, false);
 	}
 
 	wl1271_ps_elp_sleep(wl);
 out:
 	mutex_unlock(&wl->mutex);
 }
-- 
1.7.6.401.g6a319

