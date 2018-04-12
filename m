Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:23202 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752406AbeDLIJA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Apr 2018 04:09:00 -0400
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Dedy Lansky <dlansky@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH 06/10] wil6210: use country specific board file upon reg domain change
Date: Thu, 12 Apr 2018 11:08:42 +0300
Message-Id: <1523520526-24997-7-git-send-email-merez@codeaurora.org> (sfid-20180412_100939_343576_5CE447D6)
In-Reply-To: <1523520526-24997-1-git-send-email-merez@codeaurora.org>
References: <1523520526-24997-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dedy Lansky <dlansky@codeaurora.org>

wil6210 device needs to use country specific board file while in China
regulatory domain.
Register cfg80211 reg_notifier and switch board file if needed
according to new regulatory domain.
This feature is disabled by default and can be enabled with a new
country_specific_board_file module parameter.

Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 66 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/main.c     | 37 +++++++++++++---
 drivers/net/wireless/ath/wil6210/wil6210.h  |  6 +++
 3 files changed, 104 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index c2da159..ba9a81c 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -24,11 +24,16 @@
 #include "fw.h"
 
 #define WIL_MAX_ROC_DURATION_MS 5000
+#define CTRY_CHINA "CN"
 
 bool disable_ap_sme;
 module_param(disable_ap_sme, bool, 0444);
 MODULE_PARM_DESC(disable_ap_sme, " let user space handle AP mode SME");
 
+static bool country_specific_board_file;
+module_param(country_specific_board_file, bool, 0444);
+MODULE_PARM_DESC(country_specific_board_file, " switch board file upon regulatory domain change (Default: false)");
+
 #ifdef CONFIG_PM
 static struct wiphy_wowlan_support wil_wowlan_support = {
 	.flags = WIPHY_WOWLAN_ANY | WIPHY_WOWLAN_DISCONNECT,
@@ -2124,6 +2129,65 @@ static int wil_cfg80211_resume(struct wiphy *wiphy)
 	return 0;
 }
 
+static int wil_switch_board_file(struct wil6210_priv *wil,
+				 const u8 *new_regdomain)
+{
+	int rc = 0;
+
+	if (!country_specific_board_file)
+		return 0;
+
+	if (memcmp(wil->regdomain, CTRY_CHINA, 2) == 0) {
+		wil_info(wil, "moving out of China reg domain, use default board file\n");
+		wil->board_file_country[0] = '\0';
+	} else if (memcmp(new_regdomain, CTRY_CHINA, 2) == 0) {
+		wil_info(wil, "moving into China reg domain, use country specific board file\n");
+		strlcpy(wil->board_file_country, CTRY_CHINA,
+			sizeof(wil->board_file_country));
+	} else {
+		return 0;
+	}
+
+	/* need to switch board file - reset the device */
+
+	mutex_lock(&wil->mutex);
+
+	if (!wil_has_active_ifaces(wil, true, false) ||
+	    wil_is_recovery_blocked(wil))
+		/* new board file will be used in next FW load */
+		goto out;
+
+	__wil_down(wil);
+	rc = __wil_up(wil);
+
+out:
+	mutex_unlock(&wil->mutex);
+	return rc;
+}
+
+static void wil_cfg80211_reg_notify(struct wiphy *wiphy,
+				    struct regulatory_request *request)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+	int rc;
+
+	wil_info(wil, "cfg reg_notify %c%c%s%s initiator %d hint_type %d\n",
+		 request->alpha2[0], request->alpha2[1],
+		 request->intersect ? " intersect" : "",
+		 request->processed ? " processed" : "",
+		 request->initiator, request->user_reg_hint_type);
+
+	if (memcmp(wil->regdomain, request->alpha2, 2) == 0)
+		/* reg domain did not change */
+		return;
+
+	rc = wil_switch_board_file(wil, request->alpha2);
+	if (rc)
+		wil_err(wil, "switch board file failed %d\n", rc);
+
+	memcpy(wil->regdomain, request->alpha2, sizeof(wil->regdomain));
+}
+
 static const struct cfg80211_ops wil_cfg80211_ops = {
 	.add_virtual_intf = wil_cfg80211_add_iface,
 	.del_virtual_intf = wil_cfg80211_del_iface,
@@ -2198,6 +2262,8 @@ static void wil_wiphy_init(struct wiphy *wiphy)
 	wiphy->n_vendor_commands = ARRAY_SIZE(wil_nl80211_vendor_commands);
 	wiphy->vendor_commands = wil_nl80211_vendor_commands;
 
+	wiphy->reg_notifier = wil_cfg80211_reg_notify;
+
 #ifdef CONFIG_PM
 	wiphy->wowlan = &wil_wowlan_support;
 #endif
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 82aec6b..52f12c6 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -26,6 +26,7 @@
 
 #define WAIT_FOR_HALP_VOTE_MS 100
 #define WAIT_FOR_SCAN_ABORT_MS 1000
+#define WIL_BOARD_FILE_MAX_NAMELEN 128
 
 bool debug_fw; /* = false; */
 module_param(debug_fw, bool, 0444);
@@ -943,6 +944,30 @@ void wil_mbox_ring_le2cpus(struct wil6210_mbox_ring *r)
 	le32_to_cpus(&r->head);
 }
 
+/* construct actual board file name to use */
+void wil_get_board_file(struct wil6210_priv *wil, char *buf, size_t len)
+{
+	const char *board_file = WIL_BOARD_FILE_NAME;
+	const char *ext;
+	int prefix_len;
+
+	if (wil->board_file_country[0] == '\0') {
+		strlcpy(buf, board_file, len);
+		return;
+	}
+
+	/* use country specific board file */
+	if (len < strlen(board_file) + 4 /* for _XX and terminating null */)
+		return;
+
+	ext = strrchr(board_file, '.');
+	prefix_len = (ext ? ext - board_file : strlen(board_file));
+	snprintf(buf, len, "%.*s_%.2s",
+		 prefix_len, board_file, wil->board_file_country);
+	if (ext)
+		strlcat(buf, ext, len);
+}
+
 static int wil_get_bl_info(struct wil6210_priv *wil)
 {
 	struct net_device *ndev = wil->main_ndev;
@@ -1302,8 +1327,12 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 
 	wil_set_oob_mode(wil, oob_mode);
 	if (load_fw) {
+		char board_file[WIL_BOARD_FILE_MAX_NAMELEN];
+
+		board_file[0] = '\0';
+		wil_get_board_file(wil, board_file, sizeof(board_file));
 		wil_info(wil, "Use firmware <%s> + board <%s>\n",
-			 wil->wil_fw_name, WIL_BOARD_FILE_NAME);
+			 wil->wil_fw_name, board_file);
 
 		if (!no_flash)
 			wil_bl_prepare_halt(wil);
@@ -1315,11 +1344,9 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 		if (rc)
 			goto out;
 		if (wil->brd_file_addr)
-			rc = wil_request_board(wil, WIL_BOARD_FILE_NAME);
+			rc = wil_request_board(wil, board_file);
 		else
-			rc = wil_request_firmware(wil,
-						  WIL_BOARD_FILE_NAME,
-						  true);
+			rc = wil_request_firmware(wil, board_file, true);
 		if (rc)
 			goto out;
 
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index c81fe1d..633eb71 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -720,6 +720,7 @@ struct wil6210_priv {
 	const char *hw_name;
 	const char *wil_fw_name;
 	char *board_file;
+	char board_file_country[3]; /* alpha2 */
 	u32 brd_file_addr;
 	u32 brd_file_max_size;
 	DECLARE_BITMAP(hw_capa, hw_capa_last);
@@ -812,6 +813,9 @@ struct wil6210_priv {
 
 	int fw_calib_result;
 
+	/* current reg domain configured in kernel */
+	char regdomain[3]; /* alpha2 */
+
 	struct notifier_block pm_notify;
 
 	bool suspend_resp_rcvd;
@@ -905,6 +909,8 @@ static inline void wil_c(struct wil6210_priv *wil, u32 reg, u32 val)
 	wil_w(wil, reg, wil_r(wil, reg) & ~val);
 }
 
+void wil_get_board_file(struct wil6210_priv *wil, char *buf, size_t len);
+
 #if defined(CONFIG_DYNAMIC_DEBUG)
 #define wil_hex_dump_txrx(prefix_str, prefix_type, rowsize,	\
 			  groupsize, buf, len, ascii)		\
-- 
1.9.1
