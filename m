Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:50715 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751Ab0BRL2J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 06:28:09 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kalle.valo@nokia.com>
Subject: [PATCH 04/22] wl1271: modify wl1271_acx_ac_cfg() to use function parameters
Date: Thu, 18 Feb 2010 13:25:39 +0200
Message-Id: <1266492357-462-5-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

For WMM we need to configure each queue separately so modify
wl1271_acx_ac_cfg() to take the configuration from function parameters
instead.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_acx.c  |   31 +++++++++++++---------------
 drivers/net/wireless/wl12xx/wl1271_acx.h  |    3 +-
 drivers/net/wireless/wl12xx/wl1271_init.c |   14 +++++++++---
 3 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index 0b34348..4b052ee 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -830,12 +830,14 @@ out:
 	return ret;
 }
 
-int wl1271_acx_ac_cfg(struct wl1271 *wl)
+int wl1271_acx_ac_cfg(struct wl1271 *wl, u8 ac, u8 cw_min, u16 cw_max,
+		      u8 aifsn, u16 txop)
 {
 	struct acx_ac_cfg *acx;
-	int i, ret = 0;
+	int ret = 0;
 
-	wl1271_debug(DEBUG_ACX, "acx access category config");
+	wl1271_debug(DEBUG_ACX, "acx ac cfg %d cw_ming %d cw_max %d "
+		     "aifs %d txop %d", ac, cw_min, cw_max, aifsn, txop);
 
 	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
 
@@ -844,21 +846,16 @@ int wl1271_acx_ac_cfg(struct wl1271 *wl)
 		goto out;
 	}
 
-	for (i = 0; i < wl->conf.tx.ac_conf_count; i++) {
-		struct conf_tx_ac_category *c = &(wl->conf.tx.ac_conf[i]);
-		acx->ac = c->ac;
-		acx->cw_min = c->cw_min;
-		acx->cw_max = cpu_to_le16(c->cw_max);
-		acx->aifsn = c->aifsn;
-		acx->reserved = 0;
-		acx->tx_op_limit = cpu_to_le16(c->tx_op_limit);
+	acx->ac = ac;
+	acx->cw_min = cw_min;
+	acx->cw_max = cpu_to_le16(cw_max);
+	acx->aifsn = aifsn;
+	acx->tx_op_limit = cpu_to_le16(txop);
 
-		ret = wl1271_cmd_configure(wl, ACX_AC_CFG, acx, sizeof(*acx));
-		if (ret < 0) {
-			wl1271_warning("Setting of access category "
-				       "config: %d", ret);
-			goto out;
-		}
+	ret = wl1271_cmd_configure(wl, ACX_AC_CFG, acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("acx ac cfg failed: %d", ret);
+		goto out;
 	}
 
 out:
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index 1bb63af..e5f5cbd 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -1070,7 +1070,8 @@ int wl1271_acx_cts_protect(struct wl1271 *wl,
 			   enum acx_ctsprotect_type ctsprotect);
 int wl1271_acx_statistics(struct wl1271 *wl, struct acx_statistics *stats);
 int wl1271_acx_rate_policies(struct wl1271 *wl);
-int wl1271_acx_ac_cfg(struct wl1271 *wl);
+int wl1271_acx_ac_cfg(struct wl1271 *wl, u8 ac, u8 cw_min, u16 cw_max,
+		      u8 aifsn, u16 txop);
 int wl1271_acx_tid_cfg(struct wl1271 *wl);
 int wl1271_acx_frag_threshold(struct wl1271 *wl);
 int wl1271_acx_tx_config_options(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/wl1271_init.c b/drivers/net/wireless/wl12xx/wl1271_init.c
index c9848ee..2b56a9e 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.c
+++ b/drivers/net/wireless/wl12xx/wl1271_init.c
@@ -195,7 +195,8 @@ static int wl1271_init_beacon_broadcast(struct wl1271 *wl)
 
 int wl1271_hw_init(struct wl1271 *wl)
 {
-	int ret;
+	struct conf_tx_ac_category *conf_ac;
+	int ret, i;
 
 	ret = wl1271_cmd_general_parms(wl);
 	if (ret < 0)
@@ -279,9 +280,14 @@ int wl1271_hw_init(struct wl1271 *wl)
 		goto out_free_memmap;
 
 	/* Default AC configuration */
-	ret = wl1271_acx_ac_cfg(wl);
-	if (ret < 0)
-		goto out_free_memmap;
+	for (i = 0; i < wl->conf.tx.ac_conf_count; i++) {
+		conf_ac = &wl->conf.tx.ac_conf[i];
+		ret = wl1271_acx_ac_cfg(wl, conf_ac->ac, conf_ac->cw_min,
+					conf_ac->cw_max, conf_ac->aifsn,
+					conf_ac->tx_op_limit);
+		if (ret < 0)
+			goto out_free_memmap;
+	}
 
 	/* Configure TX rate classes */
 	ret = wl1271_acx_rate_policies(wl);
-- 
1.6.3.3

