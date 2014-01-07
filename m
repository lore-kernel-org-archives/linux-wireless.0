Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57694 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaAGMEz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 07:04:55 -0500
Date: Tue, 7 Jan 2014 13:04:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH v3 01/13] wl1251: fix scan behaviour while not associated
Message-ID: <20140107120453.GA10836@amd.pavel.ucw.cz> (sfid-20140107_130459_289492_108C380E)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Gnedt <david.gnedt@davizone.at>

With a dissasociated card I often encoutered very long scan delays.

My guess is that it has something to do with the cards DTIM handling and
another firmware bug mentioned in the TI WLAN driver, which is described as
the card may never end scanning if the channel is overloaded because it
can't send probe requests. I think the firmware somehow also tries to
receive DTIM messages when the BSSID is not set. Therefore most of the time
it waits for DTIM messages and can't do scanning work.

Anyway we can workaround this misbehaviour by setting the HIGH_PRIORITY
bit for scans in disassociated state.

Signed-off-by: David Gnedt <david.gnedt@davizone.at>
Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>

---
 drivers/net/wireless/ti/wl1251/cmd.c  |   13 ++++++++++++-
 drivers/net/wireless/ti/wl1251/cmd.h  |    5 +++++
 drivers/net/wireless/ti/wl1251/main.c |    1 +
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl1251/cmd.c b/drivers/net/wireless/ti/wl1251/cmd.c
index 6822b84..16b6479 100644
--- a/drivers/net/wireless/ti/wl1251/cmd.c
+++ b/drivers/net/wireless/ti/wl1251/cmd.c
@@ -3,6 +3,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/crc7.h>
+#include <linux/etherdevice.h>
 
 #include "wl1251.h"
 #include "reg.h"
@@ -410,7 +411,9 @@ int wl1251_cmd_scan(struct wl1251 *wl, u8 *ssid, size_t ssid_len,
 	struct wl1251_cmd_scan *cmd;
 	int i, ret = 0;
 
-	wl1251_debug(DEBUG_CMD, "cmd scan");
+	wl1251_debug(DEBUG_CMD, "cmd scan channels %d", n_channels);
+
+	WARN_ON(n_channels > SCAN_MAX_NUM_OF_CHANNELS);
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (!cmd)
@@ -421,6 +425,13 @@ int wl1251_cmd_scan(struct wl1251 *wl, u8 *ssid, size_t ssid_len,
 						    CFG_RX_MGMT_EN |
 						    CFG_RX_BCN_EN);
 	cmd->params.scan_options = 0;
+	/*
+	 * Use high priority scan when not associated to prevent fw issue
+	 * causing never-ending scans (sometimes 20+ minutes).
+	 * Note: This bug may be caused by the fw's DTIM handling.
+	 */
+	if (is_zero_ether_addr(wl->bssid))
+		cmd->params.scan_options |= WL1251_SCAN_OPT_PRIORITY_HIGH;
 	cmd->params.num_channels = n_channels;
 	cmd->params.num_probe_requests = n_probes;
 	cmd->params.tx_rate = cpu_to_le16(1 << 1); /* 2 Mbps */
diff --git a/drivers/net/wireless/ti/wl1251/cmd.h b/drivers/net/wireless/ti/wl1251/cmd.h
index ee4f2b3..126f273 100644
--- a/drivers/net/wireless/ti/wl1251/cmd.h
+++ b/drivers/net/wireless/ti/wl1251/cmd.h
@@ -167,6 +167,11 @@ struct cmd_read_write_memory {
 #define CMDMBOX_HEADER_LEN 4
 #define CMDMBOX_INFO_ELEM_HEADER_LEN 4
 
+#define WL1251_SCAN_OPT_PASSIVE		1
+#define WL1251_SCAN_OPT_5GHZ_BAND	2
+#define WL1251_SCAN_OPT_TRIGGERD_SCAN	4
+#define WL1251_SCAN_OPT_PRIORITY_HIGH	8
+
 #define WL1251_SCAN_MIN_DURATION 30000
 #define WL1251_SCAN_MAX_DURATION 60000
 
diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index 3291ffa..4d89ac8 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -930,6 +930,7 @@ static int wl1251_op_hw_scan(struct ieee80211_hw *hw,
 	ret = wl1251_cmd_scan(wl, ssid, ssid_len, req->channels,
 			      req->n_channels, WL1251_SCAN_NUM_PROBES);
 	if (ret < 0) {
+		wl1251_debug(DEBUG_SCAN, "scan failed %d", ret);
 		wl->scanning = false;
 		goto out_idle;
 	}
-- 
1.7.9.5
