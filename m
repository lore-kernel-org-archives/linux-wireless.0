Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:50729 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354Ab0BRL2P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 06:28:15 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kalle.valo@nokia.com>
Subject: [PATCH 05/22] wl1271: modify wl1271_acx_tid_cfg() to use function parameters
Date: Thu, 18 Feb 2010 13:25:40 +0200
Message-Id: <1266492357-462-6-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

For WMM we need to configure each tid separately so modify
wl1271_acx_tid_cfg() to take the configuration from function parameters
instead.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_acx.c  |   31 ++++++++++++++---------------
 drivers/net/wireless/wl12xx/wl1271_acx.h  |    4 ++-
 drivers/net/wireless/wl12xx/wl1271_init.c |   16 ++++++++++++--
 3 files changed, 31 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index 4b052ee..60f10dc 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -863,10 +863,12 @@ out:
 	return ret;
 }
 
-int wl1271_acx_tid_cfg(struct wl1271 *wl)
+int wl1271_acx_tid_cfg(struct wl1271 *wl, u8 queue_id, u8 channel_type,
+		       u8 tsid, u8 ps_scheme, u8 ack_policy,
+		       u32 apsd_conf0, u32 apsd_conf1)
 {
 	struct acx_tid_config *acx;
-	int i, ret = 0;
+	int ret = 0;
 
 	wl1271_debug(DEBUG_ACX, "acx tid config");
 
@@ -877,21 +879,18 @@ int wl1271_acx_tid_cfg(struct wl1271 *wl)
 		goto out;
 	}
 
-	for (i = 0; i < wl->conf.tx.tid_conf_count; i++) {
-		struct conf_tx_tid *c = &(wl->conf.tx.tid_conf[i]);
-		acx->queue_id = c->queue_id;
-		acx->channel_type = c->channel_type;
-		acx->tsid = c->tsid;
-		acx->ps_scheme = c->ps_scheme;
-		acx->ack_policy = c->ack_policy;
-		acx->apsd_conf[0] = cpu_to_le32(c->apsd_conf[0]);
-		acx->apsd_conf[1] = cpu_to_le32(c->apsd_conf[1]);
+	acx->queue_id = queue_id;
+	acx->channel_type = channel_type;
+	acx->tsid = tsid;
+	acx->ps_scheme = ps_scheme;
+	acx->ack_policy = ack_policy;
+	acx->apsd_conf[0] = cpu_to_le32(apsd_conf0);
+	acx->apsd_conf[1] = cpu_to_le32(apsd_conf1);
 
-		ret = wl1271_cmd_configure(wl, ACX_TID_CFG, acx, sizeof(*acx));
-		if (ret < 0) {
-			wl1271_warning("Setting of tid config failed: %d", ret);
-			goto out;
-		}
+	ret = wl1271_cmd_configure(wl, ACX_TID_CFG, acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("Setting of tid config failed: %d", ret);
+		goto out;
 	}
 
 out:
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index e5f5cbd..ac94a13 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -1072,7 +1072,9 @@ int wl1271_acx_statistics(struct wl1271 *wl, struct acx_statistics *stats);
 int wl1271_acx_rate_policies(struct wl1271 *wl);
 int wl1271_acx_ac_cfg(struct wl1271 *wl, u8 ac, u8 cw_min, u16 cw_max,
 		      u8 aifsn, u16 txop);
-int wl1271_acx_tid_cfg(struct wl1271 *wl);
+int wl1271_acx_tid_cfg(struct wl1271 *wl, u8 queue_id, u8 channel_type,
+		       u8 tsid, u8 ps_scheme, u8 ack_policy,
+		       u32 apsd_conf0, u32 apsd_conf1);
 int wl1271_acx_frag_threshold(struct wl1271 *wl);
 int wl1271_acx_tx_config_options(struct wl1271 *wl);
 int wl1271_acx_mem_cfg(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/wl1271_init.c b/drivers/net/wireless/wl12xx/wl1271_init.c
index 2b56a9e..78403da 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.c
+++ b/drivers/net/wireless/wl12xx/wl1271_init.c
@@ -196,6 +196,7 @@ static int wl1271_init_beacon_broadcast(struct wl1271 *wl)
 int wl1271_hw_init(struct wl1271 *wl)
 {
 	struct conf_tx_ac_category *conf_ac;
+	struct conf_tx_tid *conf_tid;
 	int ret, i;
 
 	ret = wl1271_cmd_general_parms(wl);
@@ -275,9 +276,18 @@ int wl1271_hw_init(struct wl1271 *wl)
 		goto out_free_memmap;
 
 	/* Default TID configuration */
-	ret = wl1271_acx_tid_cfg(wl);
-	if (ret < 0)
-		goto out_free_memmap;
+	for (i = 0; i < wl->conf.tx.tid_conf_count; i++) {
+		conf_tid = &wl->conf.tx.tid_conf[i];
+		ret = wl1271_acx_tid_cfg(wl, conf_tid->queue_id,
+					 conf_tid->channel_type,
+					 conf_tid->tsid,
+					 conf_tid->ps_scheme,
+					 conf_tid->ack_policy,
+					 conf_tid->apsd_conf[0],
+					 conf_tid->apsd_conf[1]);
+		if (ret < 0)
+			goto out_free_memmap;
+	}
 
 	/* Default AC configuration */
 	for (i = 0; i < wl->conf.tx.ac_conf_count; i++) {
-- 
1.6.3.3

