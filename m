Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:16939 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932869Ab0I0Iie (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 04:38:34 -0400
Received: from esebh105.NOE.Nokia.com (esebh105.ntc.nokia.com [172.21.138.211])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o8R8cJPe025709
	for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 03:38:33 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 18/25] wl1271: Fix AC/TID default configuration
Date: Mon, 27 Sep 2010 11:37:42 +0300
Message-Id: <1285576669-8070-19-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
References: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

The WMM queue default configuration was incorrect, and caused uapsd mode
problems (among possible others.)

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_conf.h |    2 +-
 drivers/net/wireless/wl12xx/wl1271_init.c |   20 +++----
 drivers/net/wireless/wl12xx/wl1271_main.c |   84 ++++++++++-------------------
 3 files changed, 39 insertions(+), 67 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_conf.h b/drivers/net/wireless/wl12xx/wl1271_conf.h
index 0435ffd..feb493e 100644
--- a/drivers/net/wireless/wl12xx/wl1271_conf.h
+++ b/drivers/net/wireless/wl12xx/wl1271_conf.h
@@ -595,7 +595,7 @@ struct conf_tx_ac_category {
 	u16 tx_op_limit;
 };
 
-#define CONF_TX_MAX_TID_COUNT 7
+#define CONF_TX_MAX_TID_COUNT 8
 
 enum {
 	CONF_CHANNEL_TYPE_DCF = 0,   /* DC/LEGACY*/
diff --git a/drivers/net/wireless/wl12xx/wl1271_init.c b/drivers/net/wireless/wl12xx/wl1271_init.c
index 5614a35..349571f 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.c
+++ b/drivers/net/wireless/wl12xx/wl1271_init.c
@@ -290,8 +290,16 @@ int wl1271_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		goto out_free_memmap;
 
-	/* Default TID configuration */
+	/* Default TID/AC configuration */
+	BUG_ON(wl->conf.tx.tid_conf_count != wl->conf.tx.ac_conf_count);
 	for (i = 0; i < wl->conf.tx.tid_conf_count; i++) {
+		conf_ac = &wl->conf.tx.ac_conf[i];
+		ret = wl1271_acx_ac_cfg(wl, conf_ac->ac, conf_ac->cw_min,
+					conf_ac->cw_max, conf_ac->aifsn,
+					conf_ac->tx_op_limit);
+		if (ret < 0)
+			goto out_free_memmap;
+
 		conf_tid = &wl->conf.tx.tid_conf[i];
 		ret = wl1271_acx_tid_cfg(wl, conf_tid->queue_id,
 					 conf_tid->channel_type,
@@ -304,16 +312,6 @@ int wl1271_hw_init(struct wl1271 *wl)
 			goto out_free_memmap;
 	}
 
-	/* Default AC configuration */
-	for (i = 0; i < wl->conf.tx.ac_conf_count; i++) {
-		conf_ac = &wl->conf.tx.ac_conf[i];
-		ret = wl1271_acx_ac_cfg(wl, conf_ac->ac, conf_ac->cw_min,
-					conf_ac->cw_max, conf_ac->aifsn,
-					conf_ac->tx_op_limit);
-		if (ret < 0)
-			goto out_free_memmap;
-	}
-
 	/* Configure TX rate classes */
 	ret = wl1271_acx_rate_policies(wl);
 	if (ret < 0)
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 39b5985..44915ee 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -124,28 +124,28 @@ static struct conf_drv_settings default_conf = {
 		},
 		.ac_conf_count               = 4,
 		.ac_conf                     = {
-			[0] = {
+			[CONF_TX_AC_BE] = {
 				.ac          = CONF_TX_AC_BE,
 				.cw_min      = 15,
 				.cw_max      = 63,
 				.aifsn       = 3,
 				.tx_op_limit = 0,
 			},
-			[1] = {
+			[CONF_TX_AC_BK] = {
 				.ac          = CONF_TX_AC_BK,
 				.cw_min      = 15,
 				.cw_max      = 63,
 				.aifsn       = 7,
 				.tx_op_limit = 0,
 			},
-			[2] = {
+			[CONF_TX_AC_VI] = {
 				.ac          = CONF_TX_AC_VI,
 				.cw_min      = 15,
 				.cw_max      = 63,
 				.aifsn       = CONF_TX_AIFS_PIFS,
 				.tx_op_limit = 3008,
 			},
-			[3] = {
+			[CONF_TX_AC_VO] = {
 				.ac          = CONF_TX_AC_VO,
 				.cw_min      = 15,
 				.cw_max      = 63,
@@ -153,64 +153,40 @@ static struct conf_drv_settings default_conf = {
 				.tx_op_limit = 1504,
 			},
 		},
-		.tid_conf_count = 7,
+		.tid_conf_count = 4,
 		.tid_conf = {
-			[0] = {
-				.queue_id    = 0,
-				.channel_type = CONF_CHANNEL_TYPE_DCF,
-				.tsid        = CONF_TX_AC_BE,
-				.ps_scheme   = CONF_PS_SCHEME_LEGACY,
-				.ack_policy  = CONF_ACK_POLICY_LEGACY,
-				.apsd_conf   = {0, 0},
-			},
-			[1] = {
-				.queue_id    = 1,
-				.channel_type = CONF_CHANNEL_TYPE_DCF,
-				.tsid        = CONF_TX_AC_BE,
-				.ps_scheme   = CONF_PS_SCHEME_LEGACY,
-				.ack_policy  = CONF_ACK_POLICY_LEGACY,
-				.apsd_conf   = {0, 0},
-			},
-			[2] = {
-				.queue_id    = 2,
-				.channel_type = CONF_CHANNEL_TYPE_DCF,
+			[CONF_TX_AC_BE] = {
+				.queue_id    = CONF_TX_AC_BE,
+				.channel_type = CONF_CHANNEL_TYPE_EDCF,
 				.tsid        = CONF_TX_AC_BE,
 				.ps_scheme   = CONF_PS_SCHEME_LEGACY,
 				.ack_policy  = CONF_ACK_POLICY_LEGACY,
 				.apsd_conf   = {0, 0},
 			},
-			[3] = {
-				.queue_id    = 3,
-				.channel_type = CONF_CHANNEL_TYPE_DCF,
-				.tsid        = CONF_TX_AC_BE,
+			[CONF_TX_AC_BK] = {
+				.queue_id    = CONF_TX_AC_BK,
+				.channel_type = CONF_CHANNEL_TYPE_EDCF,
+				.tsid        = CONF_TX_AC_BK,
 				.ps_scheme   = CONF_PS_SCHEME_LEGACY,
 				.ack_policy  = CONF_ACK_POLICY_LEGACY,
 				.apsd_conf   = {0, 0},
 			},
-			[4] = {
-				.queue_id    = 4,
-				.channel_type = CONF_CHANNEL_TYPE_DCF,
-				.tsid        = CONF_TX_AC_BE,
+			[CONF_TX_AC_VI] = {
+				.queue_id    = CONF_TX_AC_VI,
+				.channel_type = CONF_CHANNEL_TYPE_EDCF,
+				.tsid        = CONF_TX_AC_VI,
 				.ps_scheme   = CONF_PS_SCHEME_LEGACY,
 				.ack_policy  = CONF_ACK_POLICY_LEGACY,
 				.apsd_conf   = {0, 0},
 			},
-			[5] = {
-				.queue_id    = 5,
-				.channel_type = CONF_CHANNEL_TYPE_DCF,
-				.tsid        = CONF_TX_AC_BE,
+			[CONF_TX_AC_VO] = {
+				.queue_id    = CONF_TX_AC_VO,
+				.channel_type = CONF_CHANNEL_TYPE_EDCF,
+				.tsid        = CONF_TX_AC_VO,
 				.ps_scheme   = CONF_PS_SCHEME_LEGACY,
 				.ack_policy  = CONF_ACK_POLICY_LEGACY,
 				.apsd_conf   = {0, 0},
 			},
-			[6] = {
-				.queue_id    = 6,
-				.channel_type = CONF_CHANNEL_TYPE_DCF,
-				.tsid        = CONF_TX_AC_BE,
-				.ps_scheme   = CONF_PS_SCHEME_LEGACY,
-				.ack_policy  = CONF_ACK_POLICY_LEGACY,
-				.apsd_conf   = {0, 0},
-			}
 		},
 		.frag_threshold              = IEEE80211_MAX_FRAG_THRESHOLD,
 		.tx_compl_timeout            = 700,
@@ -406,8 +382,16 @@ static int wl1271_plt_init(struct wl1271 *wl)
 	if (ret < 0)
 		goto out_free_memmap;
 
-	/* Default TID configuration */
+	/* Default TID/AC configuration */
+	BUG_ON(wl->conf.tx.tid_conf_count != wl->conf.tx.ac_conf_count);
 	for (i = 0; i < wl->conf.tx.tid_conf_count; i++) {
+		conf_ac = &wl->conf.tx.ac_conf[i];
+		ret = wl1271_acx_ac_cfg(wl, conf_ac->ac, conf_ac->cw_min,
+					conf_ac->cw_max, conf_ac->aifsn,
+					conf_ac->tx_op_limit);
+		if (ret < 0)
+			goto out_free_memmap;
+
 		conf_tid = &wl->conf.tx.tid_conf[i];
 		ret = wl1271_acx_tid_cfg(wl, conf_tid->queue_id,
 					 conf_tid->channel_type,
@@ -420,16 +404,6 @@ static int wl1271_plt_init(struct wl1271 *wl)
 			goto out_free_memmap;
 	}
 
-	/* Default AC configuration */
-	for (i = 0; i < wl->conf.tx.ac_conf_count; i++) {
-		conf_ac = &wl->conf.tx.ac_conf[i];
-		ret = wl1271_acx_ac_cfg(wl, conf_ac->ac, conf_ac->cw_min,
-					conf_ac->cw_max, conf_ac->aifsn,
-					conf_ac->tx_op_limit);
-		if (ret < 0)
-			goto out_free_memmap;
-	}
-
 	/* Enable data path */
 	ret = wl1271_cmd_data_path(wl, 1);
 	if (ret < 0)
-- 
1.6.3.3

