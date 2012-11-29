Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:43666 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab2K2WuL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 17:50:11 -0500
Received: by mail-we0-f174.google.com with SMTP id d7so5137890wer.19
        for <linux-wireless@vger.kernel.org>; Thu, 29 Nov 2012 14:50:10 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] wlcore/wl12xx: make sure session id is always zero for AP
Date: Fri, 30 Nov 2012 00:50:06 +0200
Message-Id: <1354229406-7992-1-git-send-email-arik@wizery.com> (sfid-20121129_235016_077177_06765D18)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 12xx FW doesn't support non-zero session ids for AP-mode. Introduce
an appropriate quirk to make sure the session id is always zero when
needed.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
This fixes AP mode for 12xx. I've tested a branch based on
Luca's git with part1+2+3 applied in addition to this patch.
Both AP and STA work well on 12xx and 18xx.

 drivers/net/wireless/ti/wl12xx/main.c   |    9 ++++++---
 drivers/net/wireless/ti/wlcore/tx.c     |    9 +++++++--
 drivers/net/wireless/ti/wlcore/wlcore.h |    2 ++
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 6953888..3ef9bd5 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -648,7 +648,8 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
 		wl->quirks |= WLCORE_QUIRK_LEGACY_NVS |
 			      WLCORE_QUIRK_DUAL_PROBE_TMPL |
 			      WLCORE_QUIRK_TKIP_HEADER_SPACE |
-			      WLCORE_QUIRK_START_STA_FAILS;
+			      WLCORE_QUIRK_START_STA_FAILS |
+			      WLCORE_QUIRK_AP_ZERO_SESSION_ID;
 		wl->sr_fw_name = WL127X_FW_NAME_SINGLE;
 		wl->mr_fw_name = WL127X_FW_NAME_MULTI;
 		memcpy(&wl->conf.mem, &wl12xx_default_priv_conf.mem_wl127x,
@@ -671,7 +672,8 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
 		wl->quirks |= WLCORE_QUIRK_LEGACY_NVS |
 			      WLCORE_QUIRK_DUAL_PROBE_TMPL |
 			      WLCORE_QUIRK_TKIP_HEADER_SPACE |
-			      WLCORE_QUIRK_START_STA_FAILS;
+			      WLCORE_QUIRK_START_STA_FAILS |
+			      WLCORE_QUIRK_AP_ZERO_SESSION_ID;
 		wl->plt_fw_name = WL127X_PLT_FW_NAME;
 		wl->sr_fw_name = WL127X_FW_NAME_SINGLE;
 		wl->mr_fw_name = WL127X_FW_NAME_MULTI;
@@ -699,7 +701,8 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
 		wl->quirks |= WLCORE_QUIRK_TX_BLOCKSIZE_ALIGN |
 			      WLCORE_QUIRK_DUAL_PROBE_TMPL |
 			      WLCORE_QUIRK_TKIP_HEADER_SPACE |
-			      WLCORE_QUIRK_START_STA_FAILS;
+			      WLCORE_QUIRK_START_STA_FAILS |
+			      WLCORE_QUIRK_AP_ZERO_SESSION_ID;
 
 		wlcore_set_min_fw_ver(wl, WL128X_CHIP_VER,
 			      WL128X_IFTYPE_SR_VER,  WL128X_MAJOR_SR_VER,
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 07bd1f4..60ee1b0 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -288,9 +288,14 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 
 		tx_attr |= TX_HW_ATTR_TX_DUMMY_REQ;
 	} else if (wlvif) {
+		u8 session_id = wl->session_ids[hlid];
+
+		if ((wl->quirks & WLCORE_QUIRK_AP_ZERO_SESSION_ID) &&
+		    (wlvif->bss_type == BSS_TYPE_AP_BSS))
+			session_id = 0;
+
 		/* configure the tx attributes */
-		tx_attr = wl->session_ids[hlid] <<
-			  TX_HW_ATTR_OFST_SESSION_COUNTER;
+		tx_attr = session_id << TX_HW_ATTR_OFST_SESSION_COUNTER;
 	}
 
 	desc->hlid = hlid;
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index cd57f10..fac3299 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -555,6 +555,8 @@ wlcore_set_min_fw_ver(struct wl1271 *wl, unsigned int chip,
 /* Firmware requires reg domain configuration for active calibration */
 #define WLCORE_QUIRK_REGDOMAIN_CONF		BIT(11)
 
+/* The FW only support a zero session id for AP */
+#define WLCORE_QUIRK_AP_ZERO_SESSION_ID		BIT(12)
 
 /* TODO: move all these common registers and values elsewhere */
 #define HW_ACCESS_ELP_CTRL_REG		0x1FFFC
-- 
1.7.9.5

