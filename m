Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:48760 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933025Ab2DKTyH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 15:54:07 -0400
Received: by lban1 with SMTP id n1so1049502lba.40
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 12:54:04 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, coelho@ti.com
Subject: [PATCH 17/24] wlcore/wl12xx: move extended radio configuration parameters to wl12xx
Date: Wed, 11 Apr 2012 22:53:33 +0300
Message-Id: <1334174020-18957-18-git-send-email-coelho@ti.com> (sfid-20120411_215420_074325_5C6F1CB8)
In-Reply-To: <1334174020-18957-1-git-send-email-coelho@ti.com>
References: <1334174020-18957-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The extended radio configuration parameters are only used by the
wl127x chipsets, which are handled by the wl12xx driver.  Move the rf
configuration settings from wlcore to wl12xx.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/cmd.c    |    4 ++-
 drivers/net/wireless/ti/wl12xx/cmd.h    |    2 +
 drivers/net/wireless/ti/wl12xx/conf.h   |   49 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wl12xx/main.c   |   14 +--------
 drivers/net/wireless/ti/wl12xx/wl12xx.h |   31 +++++++++++++++++++
 drivers/net/wireless/ti/wlcore/conf.h   |   21 -------------
 6 files changed, 86 insertions(+), 35 deletions(-)
 create mode 100644 drivers/net/wireless/ti/wl12xx/conf.h
 create mode 100644 drivers/net/wireless/ti/wl12xx/wl12xx.h

diff --git a/drivers/net/wireless/ti/wl12xx/cmd.c b/drivers/net/wireless/ti/wl12xx/cmd.c
index e46512d..8ffaeb5 100644
--- a/drivers/net/wireless/ti/wl12xx/cmd.c
+++ b/drivers/net/wireless/ti/wl12xx/cmd.c
@@ -23,12 +23,14 @@
 #include "../wlcore/cmd.h"
 #include "../wlcore/debug.h"
 
+#include "wl12xx.h"
 #include "cmd.h"
 
 int wl1271_cmd_ext_radio_parms(struct wl1271 *wl)
 {
 	struct wl1271_ext_radio_parms_cmd *ext_radio_parms;
-	struct conf_rf_settings *rf = &wl->conf.rf;
+	struct wl12xx_priv *priv = wl->priv;
+	struct wl12xx_conf_rf *rf = &priv->conf.rf;
 	int ret;
 
 	if (!wl->nvs)
diff --git a/drivers/net/wireless/ti/wl12xx/cmd.h b/drivers/net/wireless/ti/wl12xx/cmd.h
index ff45830..140a0e8 100644
--- a/drivers/net/wireless/ti/wl12xx/cmd.h
+++ b/drivers/net/wireless/ti/wl12xx/cmd.h
@@ -23,6 +23,8 @@
 #ifndef __WL12XX_CMD_H__
 #define __WL12XX_CMD_H__
 
+#include "conf.h"
+
 #define TEST_CMD_INI_FILE_RADIO_PARAM       0x19
 #define TEST_CMD_INI_FILE_GENERAL_PARAM     0x1E
 
diff --git a/drivers/net/wireless/ti/wl12xx/conf.h b/drivers/net/wireless/ti/wl12xx/conf.h
new file mode 100644
index 0000000..cb618b9
--- /dev/null
+++ b/drivers/net/wireless/ti/wl12xx/conf.h
@@ -0,0 +1,49 @@
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (C) 2011 Texas Instruments Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __WL12XX_CONF_H__
+#define __WL12XX_CONF_H__
+
+/* these are number of channels on the band divided by two, rounded up */
+#define CONF_TX_PWR_COMPENSATION_LEN_2 7
+#define CONF_TX_PWR_COMPENSATION_LEN_5 18
+
+struct wl12xx_conf_rf {
+	/*
+	 * Per channel power compensation for 2.4GHz
+	 *
+	 * Range: s8
+	 */
+	u8 tx_per_channel_power_compensation_2[CONF_TX_PWR_COMPENSATION_LEN_2];
+
+	/*
+	 * Per channel power compensation for 5GHz
+	 *
+	 * Range: s8
+	 */
+	u8 tx_per_channel_power_compensation_5[CONF_TX_PWR_COMPENSATION_LEN_5];
+};
+
+struct wl12xx_priv_conf {
+	struct wl12xx_conf_rf rf;
+};
+
+#endif /* __WL12XX_CONF_H__ */
diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 242bb5f..d9057f8 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -35,6 +35,7 @@
 #include "../wlcore/io.h"
 #include "../wlcore/boot.h"
 
+#include "wl12xx.h"
 #include "reg.h"
 #include "cmd.h"
 #include "acx.h"
@@ -278,16 +279,6 @@ static struct wlcore_conf wl12xx_conf = {
 		.rssi_threshold			= -90,
 		.snr_threshold			= 0,
 	},
-	.rf = {
-		.tx_per_channel_power_compensation_2 = {
-			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-		},
-		.tx_per_channel_power_compensation_5 = {
-			0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-			0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-			0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-		},
-	},
 	.ht = {
 		.rx_ba_win_size = 8,
 		.tx_ba_win_size = 64,
@@ -1266,9 +1257,6 @@ static struct wlcore_ops wl12xx_ops = {
 	.get_mac		= wl12xx_get_mac,
 };
 
-struct wl12xx_priv {
-};
-
 static int __devinit wl12xx_probe(struct platform_device *pdev)
 {
 	struct wl1271 *wl;
diff --git a/drivers/net/wireless/ti/wl12xx/wl12xx.h b/drivers/net/wireless/ti/wl12xx/wl12xx.h
new file mode 100644
index 0000000..74cd332
--- /dev/null
+++ b/drivers/net/wireless/ti/wl12xx/wl12xx.h
@@ -0,0 +1,31 @@
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (C) 2011 Texas Instruments Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __WL12XX_PRIV_H__
+#define __WL12XX_PRIV_H__
+
+#include "conf.h"
+
+struct wl12xx_priv {
+	struct wl12xx_priv_conf conf;
+};
+
+#endif /* __WL12XX_PRIV_H__ */
diff --git a/drivers/net/wireless/ti/wlcore/conf.h b/drivers/net/wireless/ti/wlcore/conf.h
index 4e04e86..aa2da45 100644
--- a/drivers/net/wireless/ti/wlcore/conf.h
+++ b/drivers/net/wireless/ti/wlcore/conf.h
@@ -1104,26 +1104,6 @@ struct conf_sched_scan_settings {
 	s8 snr_threshold;
 };
 
-/* these are number of channels on the band divided by two, rounded up */
-#define CONF_TX_PWR_COMPENSATION_LEN_2 7
-#define CONF_TX_PWR_COMPENSATION_LEN_5 18
-
-struct conf_rf_settings {
-	/*
-	 * Per channel power compensation for 2.4GHz
-	 *
-	 * Range: s8
-	 */
-	u8 tx_per_channel_power_compensation_2[CONF_TX_PWR_COMPENSATION_LEN_2];
-
-	/*
-	 * Per channel power compensation for 5GHz
-	 *
-	 * Range: s8
-	 */
-	u8 tx_per_channel_power_compensation_5[CONF_TX_PWR_COMPENSATION_LEN_5];
-};
-
 struct conf_ht_setting {
 	u8 rx_ba_win_size;
 	u8 tx_ba_win_size;
@@ -1282,7 +1262,6 @@ struct wlcore_conf {
 	struct conf_roam_trigger_settings roam_trigger;
 	struct conf_scan_settings scan;
 	struct conf_sched_scan_settings sched_scan;
-	struct conf_rf_settings rf;
 	struct conf_ht_setting ht;
 	struct conf_memory_settings mem_wl127x;
 	struct conf_memory_settings mem_wl128x;
-- 
1.7.5.4

