Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:44896 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756160Ab2F0PhP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 11:37:15 -0400
Received: by lboj14 with SMTP id j14so2472403lbo.21
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jun 2012 08:36:28 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com,
	Yoni Divinsky <yoni.divinsky@ti.com>
Subject: [PATCH 7/8] wlcore: add probe request templates for sched and one-shot scans
Date: Wed, 27 Jun 2012 18:36:01 +0300
Message-Id: <1340811362-30441-8-git-send-email-coelho@ti.com> (sfid-20120627_173720_576935_26CFABC3)
In-Reply-To: <1340811362-30441-1-git-send-email-coelho@ti.com>
References: <1340811362-30441-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yoni Divinsky <yoni.divinsky@ti.com>

The driver configures the firmware template for probe requests during
the scan process.  If the same template is used for one-shot and sched
scans they will override each other when running scans simultaneously.

This fix works only on firmwares later than X.3.9.2.112 for single
role and X.3.9.2.23 for multi-role.

[Some cleaning-up and renaming of the quirk to something smaller --
Luca.]

Signed-off-by: Yoni Divinsky <yoni.divinsky@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |    3 +++
 drivers/net/wireless/ti/wlcore/cmd.c    |   14 +++++++++++---
 drivers/net/wireless/ti/wlcore/cmd.h    |    6 +++---
 drivers/net/wireless/ti/wlcore/init.c   |   16 ++++++++++++++++
 drivers/net/wireless/ti/wlcore/scan.c   |    6 +++---
 drivers/net/wireless/ti/wlcore/wlcore.h |    3 +++
 6 files changed, 39 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 1c56d1d..b11c4b3 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -637,6 +637,7 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
 			       wl->chip.id);
 
 		wl->quirks |= WLCORE_QUIRK_LEGACY_NVS |
+			      WLCORE_QUIRK_DUAL_PROBE_TMPL |
 			      WLCORE_QUIRK_TKIP_HEADER_SPACE;
 		wl->sr_fw_name = WL127X_FW_NAME_SINGLE;
 		wl->mr_fw_name = WL127X_FW_NAME_MULTI;
@@ -656,6 +657,7 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
 			     wl->chip.id);
 
 		wl->quirks |= WLCORE_QUIRK_LEGACY_NVS |
+			      WLCORE_QUIRK_DUAL_PROBE_TMPL |
 			      WLCORE_QUIRK_TKIP_HEADER_SPACE;
 		wl->plt_fw_name = WL127X_PLT_FW_NAME;
 		wl->sr_fw_name = WL127X_FW_NAME_SINGLE;
@@ -680,6 +682,7 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
 
 		/* wl128x requires TX blocksize alignment */
 		wl->quirks |= WLCORE_QUIRK_TX_BLOCKSIZE_ALIGN |
+			      WLCORE_QUIRK_DUAL_PROBE_TMPL |
 			      WLCORE_QUIRK_TKIP_HEADER_SPACE;
 
 		wlcore_set_min_fw_ver(wl, WL128X_CHIP_VER, WL128X_IFTYPE_VER,
diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 56c7a23..087cb01 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -1007,12 +1007,14 @@ out:
 int wl12xx_cmd_build_probe_req(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			       u8 role_id, u8 band,
 			       const u8 *ssid, size_t ssid_len,
-			       const u8 *ie, size_t ie_len)
+			       const u8 *ie, size_t ie_len, bool sched_scan)
 {
 	struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
 	struct sk_buff *skb;
 	int ret;
 	u32 rate;
+	u16 template_id_2_4 = CMD_TEMPL_CFG_PROBE_REQ_2_4;
+	u16 template_id_5 = CMD_TEMPL_CFG_PROBE_REQ_5;
 
 	skb = ieee80211_probereq_get(wl->hw, vif, ssid, ssid_len,
 				     ie, ie_len);
@@ -1023,14 +1025,20 @@ int wl12xx_cmd_build_probe_req(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 
 	wl1271_dump(DEBUG_SCAN, "PROBE REQ: ", skb->data, skb->len);
 
+	if (!sched_scan &&
+	    (wl->quirks & WLCORE_QUIRK_DUAL_PROBE_TMPL)) {
+		template_id_2_4 = CMD_TEMPL_APP_PROBE_REQ_2_4;
+		template_id_5 = CMD_TEMPL_APP_PROBE_REQ_5;
+	}
+
 	rate = wl1271_tx_min_rate_get(wl, wlvif->bitrate_masks[band]);
 	if (band == IEEE80211_BAND_2GHZ)
 		ret = wl1271_cmd_template_set(wl, role_id,
-					      CMD_TEMPL_CFG_PROBE_REQ_2_4,
+					      template_id_2_4,
 					      skb->data, skb->len, 0, rate);
 	else
 		ret = wl1271_cmd_template_set(wl, role_id,
-					      CMD_TEMPL_CFG_PROBE_REQ_5,
+					      template_id_5,
 					      skb->data, skb->len, 0, rate);
 
 out:
diff --git a/drivers/net/wireless/ti/wlcore/cmd.h b/drivers/net/wireless/ti/wlcore/cmd.h
index c8a6510..d7d9f80 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.h
+++ b/drivers/net/wireless/ti/wlcore/cmd.h
@@ -58,7 +58,7 @@ int wl1271_cmd_build_ps_poll(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 int wl12xx_cmd_build_probe_req(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			       u8 role_id, u8 band,
 			       const u8 *ssid, size_t ssid_len,
-			       const u8 *ie, size_t ie_len);
+			       const u8 *ie, size_t ie_len, bool sched_scan);
 struct sk_buff *wl1271_cmd_build_ap_probe_req(struct wl1271 *wl,
 					      struct wl12xx_vif *wlvif,
 					      struct sk_buff *skb);
@@ -172,8 +172,8 @@ enum cmd_templ {
 	CMD_TEMPL_PS_POLL,
 	CMD_TEMPL_KLV,
 	CMD_TEMPL_DISCONNECT,
-	CMD_TEMPL_PROBE_REQ_2_4, /* for firmware internal use only */
-	CMD_TEMPL_PROBE_REQ_5,   /* for firmware internal use only */
+	CMD_TEMPL_APP_PROBE_REQ_2_4,
+	CMD_TEMPL_APP_PROBE_REQ_5,
 	CMD_TEMPL_BAR,           /* for firmware internal use only */
 	CMD_TEMPL_CTS,           /*
 				  * For CTS-to-self (FastCTS) mechanism
diff --git a/drivers/net/wireless/ti/wlcore/init.c b/drivers/net/wireless/ti/wlcore/init.c
index 8a8a897..a3c8677 100644
--- a/drivers/net/wireless/ti/wlcore/init.c
+++ b/drivers/net/wireless/ti/wlcore/init.c
@@ -54,6 +54,22 @@ int wl1271_init_templates_config(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
+	if (wl->quirks & WLCORE_QUIRK_DUAL_PROBE_TMPL) {
+		ret = wl1271_cmd_template_set(wl, WL12XX_INVALID_ROLE_ID,
+					      CMD_TEMPL_APP_PROBE_REQ_2_4, NULL,
+					      WL1271_CMD_TEMPL_MAX_SIZE,
+					      0, WL1271_RATE_AUTOMATIC);
+		if (ret < 0)
+			return ret;
+
+		ret = wl1271_cmd_template_set(wl, WL12XX_INVALID_ROLE_ID,
+					      CMD_TEMPL_APP_PROBE_REQ_5, NULL,
+					      WL1271_CMD_TEMPL_MAX_SIZE,
+					      0, WL1271_RATE_AUTOMATIC);
+		if (ret < 0)
+			return ret;
+	}
+
 	ret = wl1271_cmd_template_set(wl, WL12XX_INVALID_ROLE_ID,
 				      CMD_TEMPL_NULL_DATA, NULL,
 				      sizeof(struct wl12xx_null_data_template),
diff --git a/drivers/net/wireless/ti/wlcore/scan.c b/drivers/net/wireless/ti/wlcore/scan.c
index 5702d99..b03eb9a 100644
--- a/drivers/net/wireless/ti/wlcore/scan.c
+++ b/drivers/net/wireless/ti/wlcore/scan.c
@@ -226,7 +226,7 @@ static int wl1271_scan_send(struct wl1271 *wl, struct ieee80211_vif *vif,
 					 cmd->params.role_id, band,
 					 wl->scan.ssid, wl->scan.ssid_len,
 					 wl->scan.req->ie,
-					 wl->scan.req->ie_len);
+					 wl->scan.req->ie_len, false);
 	if (ret < 0) {
 		wl1271_error("PROBE request template failed");
 		goto out;
@@ -722,7 +722,7 @@ int wl1271_scan_sched_scan_config(struct wl1271 *wl,
 						 req->ssids[0].ssid,
 						 req->ssids[0].ssid_len,
 						 ies->ie[band],
-						 ies->len[band]);
+						 ies->len[band], true);
 		if (ret < 0) {
 			wl1271_error("2.4GHz PROBE request template failed");
 			goto out;
@@ -736,7 +736,7 @@ int wl1271_scan_sched_scan_config(struct wl1271 *wl,
 						 req->ssids[0].ssid,
 						 req->ssids[0].ssid_len,
 						 ies->ie[band],
-						 ies->len[band]);
+						 ies->len[band], true);
 		if (ret < 0) {
 			wl1271_error("5GHz PROBE request template failed");
 			goto out;
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 942cef1..0df731a 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -455,6 +455,9 @@ wlcore_set_min_fw_ver(struct wl1271 *wl, unsigned int chip,
 /* Some firmwares not support sched scans while connected */
 #define WLCORE_QUIRK_NO_SCHED_SCAN_WHILE_CONN	BIT(9)
 
+/* separate probe response templates for one-shot and sched scans */
+#define WLCORE_QUIRK_DUAL_PROBE_TMPL		BIT(10)
+
 /* TODO: move to the lower drivers when all usages are abstracted */
 #define CHIP_ID_1271_PG10              (0x4030101)
 #define CHIP_ID_1271_PG20              (0x4030111)
-- 
1.7.10

