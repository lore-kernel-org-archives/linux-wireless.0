Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:17149 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255Ab0I0Ijp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 04:39:45 -0400
Received: from esebh106.NOE.Nokia.com (esebh106.ntc.nokia.com [172.21.138.213])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o8R8deIj026986
	for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 03:39:44 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 10/25] wl1271: Remove acx_fw_version function
Date: Mon, 27 Sep 2010 11:37:34 +0300
Message-Id: <1285576669-8070-11-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
References: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

It's not used anywhere.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_acx.c |   34 ------------------------------
 drivers/net/wireless/wl12xx/wl1271_acx.h |   30 --------------------------
 2 files changed, 0 insertions(+), 64 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index f03ad08..6189934 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -86,40 +86,6 @@ out:
 	return ret;
 }
 
-int wl1271_acx_fw_version(struct wl1271 *wl, char *buf, size_t len)
-{
-	struct acx_revision *rev;
-	int ret;
-
-	wl1271_debug(DEBUG_ACX, "acx fw rev");
-
-	rev = kzalloc(sizeof(*rev), GFP_KERNEL);
-	if (!rev) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	ret = wl1271_cmd_interrogate(wl, ACX_FW_REV, rev, sizeof(*rev));
-	if (ret < 0) {
-		wl1271_warning("ACX_FW_REV interrogate failed");
-		goto out;
-	}
-
-	/* be careful with the buffer sizes */
-	strncpy(buf, rev->fw_version, min(len, sizeof(rev->fw_version)));
-
-	/*
-	 * if the firmware version string is exactly
-	 * sizeof(rev->fw_version) long or fw_len is less than
-	 * sizeof(rev->fw_version) it won't be null terminated
-	 */
-	buf[min(len, sizeof(rev->fw_version)) - 1] = '\0';
-
-out:
-	kfree(rev);
-	return ret;
-}
-
 int wl1271_acx_tx_power(struct wl1271 *wl, int power)
 {
 	struct acx_current_tx_power *acx;
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index 5c8bb7f..ebb341d 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -100,35 +100,6 @@ struct acx_error_counter {
 	__le32 seq_num_miss;
 } __packed;
 
-struct acx_revision {
-	struct acx_header header;
-
-	/*
-	 * The WiLink firmware version, an ASCII string x.x.x.x,
-	 * that uniquely identifies the current firmware.
-	 * The left most digit is incremented each time a
-	 * significant change is made to the firmware, such as
-	 * code redesign or new platform support.
-	 * The second digit is incremented when major enhancements
-	 * are added or major fixes are made.
-	 * The third digit is incremented for each GA release.
-	 * The fourth digit is incremented for each build.
-	 * The first two digits identify a firmware release version,
-	 * in other words, a unique set of features.
-	 * The first three digits identify a GA release.
-	 */
-	char fw_version[20];
-
-	/*
-	 * This 4 byte field specifies the WiLink hardware version.
-	 * bits 0  - 15: Reserved.
-	 * bits 16 - 23: Version ID - The WiLink version ID
-	 *              (1 = first spin, 2 = second spin, and so on).
-	 * bits 24 - 31: Chip ID - The WiLink chip ID.
-	 */
-	__le32 hw_version;
-} __packed;
-
 enum wl1271_psm_mode {
 	/* Active mode */
 	WL1271_PSM_CAM = 0,
@@ -1076,7 +1047,6 @@ enum {
 
 int wl1271_acx_wake_up_conditions(struct wl1271 *wl);
 int wl1271_acx_sleep_auth(struct wl1271 *wl, u8 sleep_auth);
-int wl1271_acx_fw_version(struct wl1271 *wl, char *buf, size_t len);
 int wl1271_acx_tx_power(struct wl1271 *wl, int power);
 int wl1271_acx_feature_cfg(struct wl1271 *wl);
 int wl1271_acx_mem_map(struct wl1271 *wl,
-- 
1.6.3.3

