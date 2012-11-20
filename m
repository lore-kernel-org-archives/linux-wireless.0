Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:52484 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab2KTLUN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 06:20:13 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so2346757eaa.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2012 03:20:12 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 02/11] wlcore: workaround start_sta problem in wl12xx fw
Date: Tue, 20 Nov 2012 13:20:02 +0200
Message-Id: <1353410411-18833-3-git-send-email-eliad@wizery.com> (sfid-20121120_122019_686525_1BB5777F)
In-Reply-To: <1353410411-18833-1-git-send-email-eliad@wizery.com>
References: <1353410411-18833-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

for some reason, the wl12xx fw is not able to rx/tx
on the first start_sta cmd.
Workaround it by issuing a dummy start_sta + stop_sta
before starting the sta for the final time.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |    9 ++++++---
 drivers/net/wireless/ti/wlcore/main.c   |   15 ++++++++++++++-
 drivers/net/wireless/ti/wlcore/wlcore.h |    3 +++
 3 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index dadf1db..6c9fba4 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -637,7 +637,8 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
 
 		wl->quirks |= WLCORE_QUIRK_LEGACY_NVS |
 			      WLCORE_QUIRK_DUAL_PROBE_TMPL |
-			      WLCORE_QUIRK_TKIP_HEADER_SPACE;
+			      WLCORE_QUIRK_TKIP_HEADER_SPACE |
+			      WLCORE_QUIRK_START_STA_FAILS;
 		wl->sr_fw_name = WL127X_FW_NAME_SINGLE;
 		wl->mr_fw_name = WL127X_FW_NAME_MULTI;
 		memcpy(&wl->conf.mem, &wl12xx_default_priv_conf.mem_wl127x,
@@ -657,7 +658,8 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
 
 		wl->quirks |= WLCORE_QUIRK_LEGACY_NVS |
 			      WLCORE_QUIRK_DUAL_PROBE_TMPL |
-			      WLCORE_QUIRK_TKIP_HEADER_SPACE;
+			      WLCORE_QUIRK_TKIP_HEADER_SPACE |
+			      WLCORE_QUIRK_START_STA_FAILS;
 		wl->plt_fw_name = WL127X_PLT_FW_NAME;
 		wl->sr_fw_name = WL127X_FW_NAME_SINGLE;
 		wl->mr_fw_name = WL127X_FW_NAME_MULTI;
@@ -682,7 +684,8 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
 		/* wl128x requires TX blocksize alignment */
 		wl->quirks |= WLCORE_QUIRK_TX_BLOCKSIZE_ALIGN |
 			      WLCORE_QUIRK_DUAL_PROBE_TMPL |
-			      WLCORE_QUIRK_TKIP_HEADER_SPACE;
+			      WLCORE_QUIRK_TKIP_HEADER_SPACE |
+			      WLCORE_QUIRK_START_STA_FAILS;
 
 		wlcore_set_min_fw_ver(wl, WL128X_CHIP_VER, WL128X_IFTYPE_VER,
 				      WL128X_MAJOR_VER, WL128X_SUBTYPE_VER,
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 2690fe9..be60394 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -2490,8 +2490,21 @@ static int wlcore_join(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 
 	if (is_ibss)
 		ret = wl12xx_cmd_role_start_ibss(wl, wlvif);
-	else
+	else {
+		if (wl->quirks & WLCORE_QUIRK_START_STA_FAILS) {
+			/*
+			 * TODO: this is an ugly workaround for wl12xx fw
+			 * bug - we are not able to tx/rx after the first
+			 * start_sta, so make dummy start+stop calls,
+			 * and then call start_sta again.
+			 * this should be fixed in the fw.
+			 */
+			wl12xx_cmd_role_start_sta(wl, wlvif);
+			wl12xx_cmd_role_stop_sta(wl, wlvif);
+		}
+
 		ret = wl12xx_cmd_role_start_sta(wl, wlvif);
+	}
 
 	return ret;
 }
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 68584aa..1030b6b 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -450,6 +450,9 @@ wlcore_set_min_fw_ver(struct wl1271 *wl, unsigned int chip,
 /* Each RX/TX transaction requires an end-of-transaction transfer */
 #define WLCORE_QUIRK_END_OF_TRANSACTION		BIT(0)
 
+/* the first start_role(sta) sometimes doesn't work on wl12xx */
+#define WLCORE_QUIRK_START_STA_FAILS		BIT(1)
+
 /* wl127x and SPI don't support SDIO block size alignment */
 #define WLCORE_QUIRK_TX_BLOCKSIZE_ALIGN		BIT(2)
 
-- 
1.7.6.401.g6a319

