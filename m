Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:34128 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936Ab1CFO2V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 09:28:21 -0500
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id p26ESL0X019835
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Sun, 6 Mar 2011 08:28:21 -0600
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>
Subject: [PATCH 10/15] wl12xx: 1281/1283 support - Set WiFi & BT cox
Date: Sun,  6 Mar 2011 16:32:15 +0200
Message-Id: <1299421940-26292-11-git-send-email-shahar_levi@ti.com>
In-Reply-To: <1299421940-26292-1-git-send-email-shahar_levi@ti.com>
References: <1299421940-26292-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set different Cox setting between wl127x and wl128x.

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
 drivers/net/wireless/wl12xx/acx.c  |    5 +++++
 drivers/net/wireless/wl12xx/main.c |    6 +++++-
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index f0345e6..e970b71 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -554,6 +554,11 @@ int wl1271_acx_sg_cfg(struct wl1271 *wl)
 		goto out;
 	}
 
+	if (wl->chip.id == CHIP_ID_1283_PG20)
+		c->params[CONF_SG_BT_LOAD_RATIO] = 50;
+	else
+		c->params[CONF_SG_BT_LOAD_RATIO] = 200;
+
 	/* BT-WLAN coext parameters */
 	for (i = 0; i < CONF_SG_PARAMS_MAX; i++)
 		param->params[i] = cpu_to_le32(c->params[i]);
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 32d963d..f8e9e3f 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -54,7 +54,11 @@ static struct conf_drv_settings default_conf = {
 			[CONF_SG_BT_PER_THRESHOLD]                  = 7500,
 			[CONF_SG_HV3_MAX_OVERRIDE]                  = 0,
 			[CONF_SG_BT_NFS_SAMPLE_INTERVAL]            = 400,
-			[CONF_SG_BT_LOAD_RATIO]                     = 50,
+			/*
+			 * CONF_SG_BT_LOAD_RATIO has wl127x or wl128x dependency
+			 * (set in wl1271_acx_sg_cfg()
+			 */
+			[CONF_SG_BT_LOAD_RATIO]                     = 0,
 			[CONF_SG_AUTO_PS_MODE]                      = 1,
 			[CONF_SG_AUTO_SCAN_PROBE_REQ]               = 170,
 			[CONF_SG_ACTIVE_SCAN_DURATION_FACTOR_HV3]   = 50,
-- 
1.7.0.4

