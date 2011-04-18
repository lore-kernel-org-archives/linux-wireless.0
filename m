Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41741 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab1DRLPp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 07:15:45 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so5506533wwa.1
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 04:15:44 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 02/10] wl12xx: use wiphy values for setting rts, frag thresholds on init
Date: Mon, 18 Apr 2011 14:15:21 +0300
Message-Id: <1303125329-27214-2-git-send-email-arik@wizery.com>
In-Reply-To: <1303125329-27214-1-git-send-email-arik@wizery.com>
References: <1303125329-27214-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the wiphy RTS and fragmentation thresholds for initializing the FW
when possible. This mitigates a bug where previously set values are
forgotten after interface down/up.

Add checks before settings these values to ensure they are valid. Use
default values when invalid thresholds are configured.

Update the default RTS threshold to the maximum value given by the
specification.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/acx.c  |   26 ++++++++++++++++++++------
 drivers/net/wireless/wl12xx/acx.h  |    4 ++--
 drivers/net/wireless/wl12xx/init.c |    4 ++--
 drivers/net/wireless/wl12xx/main.c |    6 +++---
 4 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index cda546b..6a0fd18 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -325,12 +325,19 @@ out:
 	return ret;
 }
 
-int wl1271_acx_rts_threshold(struct wl1271 *wl, u16 rts_threshold)
+int wl1271_acx_rts_threshold(struct wl1271 *wl, u32 rts_threshold)
 {
 	struct acx_rts_threshold *rts;
 	int ret;
 
-	wl1271_debug(DEBUG_ACX, "acx rts threshold");
+	/*
+	 * If the RTS threshold is not configured or out of range, use the
+	 * default value.
+	 */
+	if (rts_threshold > IEEE80211_MAX_RTS_THRESHOLD)
+		rts_threshold = wl->conf.rx.rts_threshold;
+
+	wl1271_debug(DEBUG_ACX, "acx rts threshold: %d", rts_threshold);
 
 	rts = kzalloc(sizeof(*rts), GFP_KERNEL);
 	if (!rts) {
@@ -338,7 +345,7 @@ int wl1271_acx_rts_threshold(struct wl1271 *wl, u16 rts_threshold)
 		goto out;
 	}
 
-	rts->threshold = cpu_to_le16(rts_threshold);
+	rts->threshold = cpu_to_le16((u16)rts_threshold);
 
 	ret = wl1271_cmd_configure(wl, DOT11_RTS_THRESHOLD, rts, sizeof(*rts));
 	if (ret < 0) {
@@ -928,12 +935,19 @@ out:
 	return ret;
 }
 
-int wl1271_acx_frag_threshold(struct wl1271 *wl, u16 frag_threshold)
+int wl1271_acx_frag_threshold(struct wl1271 *wl, u32 frag_threshold)
 {
 	struct acx_frag_threshold *acx;
 	int ret = 0;
 
-	wl1271_debug(DEBUG_ACX, "acx frag threshold");
+	/*
+	 * If the fragmentation is not configured or out of range, use the
+	 * default value.
+	 */
+	if (frag_threshold > IEEE80211_MAX_FRAG_THRESHOLD)
+		frag_threshold = wl->conf.tx.frag_threshold;
+
+	wl1271_debug(DEBUG_ACX, "acx frag threshold: %d", frag_threshold);
 
 	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
 
@@ -942,7 +956,7 @@ int wl1271_acx_frag_threshold(struct wl1271 *wl, u16 frag_threshold)
 		goto out;
 	}
 
-	acx->frag_threshold = cpu_to_le16(frag_threshold);
+	acx->frag_threshold = cpu_to_le16((u16)frag_threshold);
 	ret = wl1271_cmd_configure(wl, ACX_FRAG_CFG, acx, sizeof(*acx));
 	if (ret < 0) {
 		wl1271_warning("Setting of frag threshold failed: %d", ret);
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index b35ebf5..31cb8c2 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -1266,7 +1266,7 @@ int wl1271_acx_slot(struct wl1271 *wl, enum acx_slot_type slot_time);
 int wl1271_acx_group_address_tbl(struct wl1271 *wl, bool enable,
 				 void *mc_list, u32 mc_list_len);
 int wl1271_acx_service_period_timeout(struct wl1271 *wl);
-int wl1271_acx_rts_threshold(struct wl1271 *wl, u16 rts_threshold);
+int wl1271_acx_rts_threshold(struct wl1271 *wl, u32 rts_threshold);
 int wl1271_acx_dco_itrim_params(struct wl1271 *wl);
 int wl1271_acx_beacon_filter_opt(struct wl1271 *wl, bool enable_filter);
 int wl1271_acx_beacon_filter_table(struct wl1271 *wl);
@@ -1290,7 +1290,7 @@ int wl1271_acx_ac_cfg(struct wl1271 *wl, u8 ac, u8 cw_min, u16 cw_max,
 int wl1271_acx_tid_cfg(struct wl1271 *wl, u8 queue_id, u8 channel_type,
 		       u8 tsid, u8 ps_scheme, u8 ack_policy,
 		       u32 apsd_conf0, u32 apsd_conf1);
-int wl1271_acx_frag_threshold(struct wl1271 *wl, u16 frag_threshold);
+int wl1271_acx_frag_threshold(struct wl1271 *wl, u32 frag_threshold);
 int wl1271_acx_tx_config_options(struct wl1271 *wl);
 int wl1271_acx_ap_mem_cfg(struct wl1271 *wl);
 int wl1271_acx_sta_mem_cfg(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index e8c979d..40015d0 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -258,7 +258,7 @@ int wl1271_init_phy_config(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_acx_rts_threshold(wl, wl->conf.rx.rts_threshold);
+	ret = wl1271_acx_rts_threshold(wl, wl->hw->wiphy->rts_threshold);
 	if (ret < 0)
 		return ret;
 
@@ -605,7 +605,7 @@ int wl1271_hw_init(struct wl1271 *wl)
 		goto out_free_memmap;
 
 	/* Default fragmentation threshold */
-	ret = wl1271_acx_frag_threshold(wl, wl->conf.tx.frag_threshold);
+	ret = wl1271_acx_frag_threshold(wl, wl->hw->wiphy->frag_threshold);
 	if (ret < 0)
 		goto out_free_memmap;
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 1c206ae..a2a26df 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -163,7 +163,7 @@ static struct conf_drv_settings default_conf = {
 		.packet_detection_threshold  = 0,
 		.ps_poll_timeout             = 15,
 		.upsd_timeout                = 15,
-		.rts_threshold               = 2347,
+		.rts_threshold               = IEEE80211_MAX_RTS_THRESHOLD,
 		.rx_cca_threshold            = 0,
 		.irq_blk_threshold           = 0xFFFF,
 		.irq_pkt_threshold           = 0,
@@ -2337,7 +2337,7 @@ static int wl1271_op_set_frag_threshold(struct ieee80211_hw *hw, u32 value)
 	if (ret < 0)
 		goto out;
 
-	ret = wl1271_acx_frag_threshold(wl, (u16)value);
+	ret = wl1271_acx_frag_threshold(wl, value);
 	if (ret < 0)
 		wl1271_warning("wl1271_op_set_frag_threshold failed: %d", ret);
 
@@ -2365,7 +2365,7 @@ static int wl1271_op_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 	if (ret < 0)
 		goto out;
 
-	ret = wl1271_acx_rts_threshold(wl, (u16) value);
+	ret = wl1271_acx_rts_threshold(wl, value);
 	if (ret < 0)
 		wl1271_warning("wl1271_op_set_rts_threshold failed: %d", ret);
 
-- 
1.7.1

