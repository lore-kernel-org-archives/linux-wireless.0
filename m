Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:59130 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab3IIJY5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Sep 2013 05:24:57 -0400
Received: by mail-we0-f171.google.com with SMTP id t61so3945567wes.16
        for <linux-wireless@vger.kernel.org>; Mon, 09 Sep 2013 02:24:56 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luca@coelho.fi>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 04/13] wlcore: fix interrogate command length
Date: Mon,  9 Sep 2013 12:24:35 +0300
Message-Id: <1378718684-14430-4-git-send-email-eliad@wizery.com> (sfid-20130909_112501_368142_1DBB42B2)
In-Reply-To: <1378718684-14430-1-git-send-email-eliad@wizery.com>
References: <1378718684-14430-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igal Chernobelsky <igalc@ti.com>

Change interrogate command prototype to have command size
and returned buffer length.
This fixes the issue when command parameters are needed to
be passed to FW in addition to acx header as in the case with
get RSSI command, where role_id has to be passed.

Signed-off-by: Igal Chernobelsky <igalc@ti.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/acx.c      | 10 ++++++----
 drivers/net/wireless/ti/wlcore/cmd.c      |  9 +++++----
 drivers/net/wireless/ti/wlcore/cmd.h      |  3 ++-
 drivers/net/wireless/ti/wlcore/testmode.c |  3 ++-
 4 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/acx.c b/drivers/net/wireless/ti/wlcore/acx.c
index 7a970cd..ec83675 100644
--- a/drivers/net/wireless/ti/wlcore/acx.c
+++ b/drivers/net/wireless/ti/wlcore/acx.c
@@ -162,7 +162,8 @@ int wl1271_acx_mem_map(struct wl1271 *wl, struct acx_header *mem_map,
 
 	wl1271_debug(DEBUG_ACX, "acx mem map");
 
-	ret = wl1271_cmd_interrogate(wl, ACX_MEM_MAP, mem_map, len);
+	ret = wl1271_cmd_interrogate(wl, ACX_MEM_MAP, mem_map,
+				     sizeof(struct acx_header), len);
 	if (ret < 0)
 		return ret;
 
@@ -722,6 +723,7 @@ int wl1271_acx_statistics(struct wl1271 *wl, void *stats)
 	wl1271_debug(DEBUG_ACX, "acx statistics");
 
 	ret = wl1271_cmd_interrogate(wl, ACX_STATISTICS, stats,
+				     sizeof(struct acx_header),
 				     wl->stats.fw_stats_len);
 	if (ret < 0) {
 		wl1271_warning("acx statistics failed: %d", ret);
@@ -1470,8 +1472,8 @@ int wl12xx_acx_tsf_info(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 
 	tsf_info->role_id = wlvif->role_id;
 
-	ret = wl1271_cmd_interrogate(wl, ACX_TSF_INFO,
-				     tsf_info, sizeof(*tsf_info));
+	ret = wl1271_cmd_interrogate(wl, ACX_TSF_INFO, tsf_info,
+				sizeof(struct acx_header), sizeof(*tsf_info));
 	if (ret < 0) {
 		wl1271_warning("acx tsf info interrogate failed");
 		goto out;
@@ -1752,7 +1754,7 @@ int wlcore_acx_average_rssi(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 
 	acx->role_id = wlvif->role_id;
 	ret = wl1271_cmd_interrogate(wl, ACX_ROAMING_STATISTICS_TBL,
-				     acx, sizeof(*acx));
+				     acx, sizeof(*acx), sizeof(*acx));
 	if (ret	< 0) {
 		wl1271_warning("acx roaming statistics failed: %d", ret);
 		ret = -ENOMEM;
diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 1cb3296..f6a3d7d 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -845,7 +845,8 @@ EXPORT_SYMBOL_GPL(wl1271_cmd_test);
  * @buf: buffer for the response, including all headers, must work with dma
  * @len: length of buf
  */
-int wl1271_cmd_interrogate(struct wl1271 *wl, u16 id, void *buf, size_t len)
+int wl1271_cmd_interrogate(struct wl1271 *wl, u16 id, void *buf,
+			   size_t cmd_len, size_t res_len)
 {
 	struct acx_header *acx = buf;
 	int ret;
@@ -854,10 +855,10 @@ int wl1271_cmd_interrogate(struct wl1271 *wl, u16 id, void *buf, size_t len)
 
 	acx->id = cpu_to_le16(id);
 
-	/* payload length, does not include any headers */
-	acx->len = cpu_to_le16(len - sizeof(*acx));
+	/* response payload length, does not include any headers */
+	acx->len = cpu_to_le16(res_len - sizeof(*acx));
 
-	ret = wl1271_cmd_send(wl, CMD_INTERROGATE, acx, sizeof(*acx), len);
+	ret = wl1271_cmd_send(wl, CMD_INTERROGATE, acx, cmd_len, res_len);
 	if (ret < 0)
 		wl1271_error("INTERROGATE command failed");
 
diff --git a/drivers/net/wireless/ti/wlcore/cmd.h b/drivers/net/wireless/ti/wlcore/cmd.h
index fd34123..323d4a8 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.h
+++ b/drivers/net/wireless/ti/wlcore/cmd.h
@@ -45,7 +45,8 @@ int wl12xx_start_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		     enum ieee80211_band band, int channel);
 int wl12xx_stop_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 int wl1271_cmd_test(struct wl1271 *wl, void *buf, size_t buf_len, u8 answer);
-int wl1271_cmd_interrogate(struct wl1271 *wl, u16 id, void *buf, size_t len);
+int wl1271_cmd_interrogate(struct wl1271 *wl, u16 id, void *buf,
+			   size_t cmd_len, size_t res_len);
 int wl1271_cmd_configure(struct wl1271 *wl, u16 id, void *buf, size_t len);
 int wlcore_cmd_configure_failsafe(struct wl1271 *wl, u16 id, void *buf,
 				  size_t len, unsigned long valid_rets);
diff --git a/drivers/net/wireless/ti/wlcore/testmode.c b/drivers/net/wireless/ti/wlcore/testmode.c
index a3b7d95..ddad58f 100644
--- a/drivers/net/wireless/ti/wlcore/testmode.c
+++ b/drivers/net/wireless/ti/wlcore/testmode.c
@@ -179,7 +179,8 @@ static int wl1271_tm_cmd_interrogate(struct wl1271 *wl, struct nlattr *tb[])
 		goto out_sleep;
 	}
 
-	ret = wl1271_cmd_interrogate(wl, ie_id, cmd, sizeof(*cmd));
+	ret = wl1271_cmd_interrogate(wl, ie_id, cmd,
+				     sizeof(struct acx_header), sizeof(*cmd));
 	if (ret < 0) {
 		wl1271_warning("testmode cmd interrogate failed: %d", ret);
 		goto out_free;
-- 
1.8.3.rc1.35.g9b79519

