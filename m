Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:34130 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717Ab1CFO2X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 09:28:23 -0500
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id p26ESMaU019840
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Sun, 6 Mar 2011 08:28:22 -0600
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>
Subject: [PATCH 11/15] wl12xx: 1281/1283 support - Add chip interrupt pacing
Date: Sun,  6 Mar 2011 16:32:16 +0200
Message-Id: <1299421940-26292-12-git-send-email-shahar_levi@ti.com>
In-Reply-To: <1299421940-26292-1-git-send-email-shahar_levi@ti.com>
References: <1299421940-26292-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set data path interrupt pacing for wl128x

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
 drivers/net/wireless/wl12xx/acx.c  |    8 +++++++-
 drivers/net/wireless/wl12xx/conf.h |   10 +++++++++-
 drivers/net/wireless/wl12xx/main.c |    3 ++-
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index e970b71..4341f6e 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -943,8 +943,14 @@ int wl1271_acx_tx_config_options(struct wl1271 *wl)
 		goto out;
 	}
 
+	if (wl->chip.id == CHIP_ID_1283_PG20)
+		acx->tx_compl_threshold =
+			cpu_to_le16(wl->conf.tx.wl128x_tx_compl_threshold);
+	else
+		acx->tx_compl_threshold =
+			cpu_to_le16(wl->conf.tx.wl127x_tx_compl_threshold);
+
 	acx->tx_compl_timeout = cpu_to_le16(wl->conf.tx.tx_compl_timeout);
-	acx->tx_compl_threshold = cpu_to_le16(wl->conf.tx.tx_compl_threshold);
 	ret = wl1271_cmd_configure(wl, ACX_TX_CONFIG_OPT, acx, sizeof(*acx));
 	if (ret < 0) {
 		wl1271_warning("Setting of tx options failed: %d", ret);
diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index 743bd0b..ef8b220 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -714,7 +714,15 @@ struct conf_tx_settings {
 	 *
 	 * Range: u16
 	 */
-	u16 tx_compl_threshold;
+	u16 wl127x_tx_compl_threshold;
+
+	/*
+	 * Completed TX packet count which requires to issue the TX-Complete
+	 * interrupt.
+	 *
+	 * Range: u16
+	 */
+	u16 wl128x_tx_compl_threshold;
 
 	/*
 	 * The rate used for control messages and scanning on the 2.4GHz band
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index f8e9e3f..6fda932 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -233,7 +233,8 @@ static struct conf_drv_settings default_conf = {
 		},
 		.frag_threshold              = IEEE80211_MAX_FRAG_THRESHOLD,
 		.tx_compl_timeout            = 700,
-		.tx_compl_threshold          = 4,
+		.wl127x_tx_compl_threshold   = 4,
+		.wl128x_tx_compl_threshold   = 3,
 		.basic_rate                  = CONF_HW_BIT_RATE_1MBPS,
 		.basic_rate_5                = CONF_HW_BIT_RATE_6MBPS,
 		.tmpl_short_retry_limit      = 10,
-- 
1.7.0.4

