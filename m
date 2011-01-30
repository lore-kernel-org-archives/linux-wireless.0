Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.platinumzone24.at ([88.198.159.93]:57983 "EHLO
	mail.platinumzone24.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab1A3TLA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 14:11:00 -0500
Message-ID: <4D45B7BA.9080402@davizone.at>
Date: Sun, 30 Jan 2011 20:10:50 +0100
From: David Gnedt <david.gnedt@davizone.at>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: [PATCH 03/18] wl1251: fix scan behaviour while not associated
References: <4D45A598.20709@davizone.at>
In-Reply-To: <4D45A598.20709@davizone.at>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With a dissacociated card I often encoutered very long scan delays.

My guess is that it has something to do with the cards DTIM handling and
another firmware bug mentioned in the TI WLAN driver, which is described as
the card may never end scanning if the channel is overloaded because it
can't send probe requests. I think the firmware somehow also tries to
receive DTIM messages when the BSSID is not set. Therefore most of the time
it waits for DTIM messages and can't do scanning work.

Anyway we can workaround this misbehaviour by setting the HIGH_PRIORITY
bit for scans in disassociated state.

Signed-off-by: David Gnedt <david.gnedt@davizone.at>
---
Sorry for the partly broken patches, I thought I configured my client the
right way. I tried to stop the mails at my mailserver, but it was mostly
already too late.
---
 drivers/net/wireless/wl1251/cmd.c  |   12 +++++++++++-
 drivers/net/wireless/wl1251/cmd.h  |    5 +++++
 drivers/net/wireless/wl1251/main.c |    1 +
 3 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl1251/cmd.c b/drivers/net/wireless/wl1251/cmd.c
index 0ade4bd..4e4987d 100644
--- a/drivers/net/wireless/wl1251/cmd.c
+++ b/drivers/net/wireless/wl1251/cmd.c
@@ -419,7 +419,10 @@ int wl1251_cmd_scan(struct wl1251 *wl, u8 *ssid, size_t ssid_len,
 	struct wl1251_cmd_scan *cmd;
 	int i, ret = 0;
 
-	wl1251_debug(DEBUG_CMD, "cmd scan");
+	wl1251_debug(DEBUG_CMD, "cmd scan channels %d ssid(%d) '%s'",
+		     n_channels, ssid_len, ssid);
+
+	WARN_ON(n_channels > SCAN_MAX_NUM_OF_CHANNELS);
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (!cmd)
@@ -430,6 +433,13 @@ int wl1251_cmd_scan(struct wl1251 *wl, u8 *ssid, size_t ssid_len,
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
diff --git a/drivers/net/wireless/wl1251/cmd.h b/drivers/net/wireless/wl1251/cmd.h
index e5c74c6..c4ed9cd 100644
--- a/drivers/net/wireless/wl1251/cmd.h
+++ b/drivers/net/wireless/wl1251/cmd.h
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
 
diff --git a/drivers/net/wireless/wl1251/main.c b/drivers/net/wireless/wl1251/main.c
index 012e1a4..2c95b90 100644
--- a/drivers/net/wireless/wl1251/main.c
+++ b/drivers/net/wireless/wl1251/main.c
@@ -906,6 +906,7 @@ static int wl1251_op_hw_scan(struct ieee80211_hw *hw,
 	ret = wl1251_cmd_scan(wl, ssid, ssid_len, req->channels,
 			      req->n_channels, WL1251_SCAN_NUM_PROBES);
 	if (ret < 0) {
+		wl1251_debug(DEBUG_SCAN, "scan failed %d", ret);
 		wl->scanning = false;
 		goto out_sleep;
 	}
-- 
1.7.0.4


