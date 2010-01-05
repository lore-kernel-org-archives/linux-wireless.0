Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:50381 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab0AESRG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 13:17:06 -0500
Received: from saunalahti-vams (vs3-11.mail.saunalahti.fi [62.142.5.95])
	by emh05-2.mail.saunalahti.fi (Postfix) with SMTP id 5CE228C3F7
	for <linux-wireless@vger.kernel.org>; Tue,  5 Jan 2010 20:17:05 +0200 (EET)
Received: from [127.0.1.1] (a91-155-131-184.elisa-laajakaista.fi [91.155.131.184])
	by emh05.mail.saunalahti.fi (Postfix) with ESMTP id 4B4A727D97
	for <linux-wireless@vger.kernel.org>; Tue,  5 Jan 2010 20:17:04 +0200 (EET)
Subject: [PATCH v2 8/9] wl1251: use mac80211 provided channel parameters in
	scanning
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 05 Jan 2010 20:17:03 +0200
Message-ID: <20100105181703.27418.85459.stgit@tikku>
In-Reply-To: <20100105181522.27418.97100.stgit@tikku>
References: <20100105181522.27418.97100.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

The number of channels to be used in scan was hard coded in wl1251. The
proper way is to use the channels array provided by mac80211.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1251_cmd.c  |    3 ++-
 drivers/net/wireless/wl12xx/wl1251_cmd.h  |    5 +++++
 drivers/net/wireless/wl12xx/wl1251_main.c |    3 ++-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_cmd.c b/drivers/net/wireless/wl12xx/wl1251_cmd.c
index fcbfbd7..0320b47 100644
--- a/drivers/net/wireless/wl12xx/wl1251_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1251_cmd.c
@@ -412,6 +412,7 @@ out:
 }
 
 int wl1251_cmd_scan(struct wl1251 *wl, u8 *ssid, size_t ssid_len,
+		    struct ieee80211_channel *channels[],
 		    unsigned int n_channels, unsigned int n_probes)
 {
 	struct wl1251_cmd_scan *cmd;
@@ -442,7 +443,7 @@ int wl1251_cmd_scan(struct wl1251 *wl, u8 *ssid, size_t ssid_len,
 		memset(&cmd->channels[i].bssid_msb, 0xff, 2);
 		cmd->channels[i].early_termination = 0;
 		cmd->channels[i].tx_power_att = 0;
-		cmd->channels[i].channel = i + 1;
+		cmd->channels[i].channel = channels[i]->hw_value;
 	}
 
 	cmd->params.ssid_len = ssid_len;
diff --git a/drivers/net/wireless/wl12xx/wl1251_cmd.h b/drivers/net/wireless/wl12xx/wl1251_cmd.h
index 63ae319..4ad67ca 100644
--- a/drivers/net/wireless/wl12xx/wl1251_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1251_cmd.h
@@ -27,6 +27,8 @@
 
 #include "wl1251.h"
 
+#include <net/cfg80211.h>
+
 struct acx_header;
 
 int wl1251_cmd_send(struct wl1251 *wl, u16 type, void *buf, size_t buf_len);
@@ -44,6 +46,7 @@ int wl1251_cmd_read_memory(struct wl1251 *wl, u32 addr, void *answer,
 int wl1251_cmd_template_set(struct wl1251 *wl, u16 cmd_id,
 			    void *buf, size_t buf_len);
 int wl1251_cmd_scan(struct wl1251 *wl, u8 *ssid, size_t ssid_len,
+		    struct ieee80211_channel *channels[],
 		    unsigned int n_channels, unsigned int n_probes);
 int wl1251_cmd_trigger_scan_to(struct wl1251 *wl, u32 timeout);
 
@@ -169,6 +172,8 @@ struct cmd_read_write_memory {
 #define WL1251_SCAN_MIN_DURATION 30000
 #define WL1251_SCAN_MAX_DURATION 60000
 
+#define WL1251_SCAN_NUM_PROBES 3
+
 struct wl1251_scan_parameters {
 	u32 rx_config_options;
 	u32 rx_filter_options;
diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index 1db9722..4728983 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -878,7 +878,8 @@ static int wl1251_op_hw_scan(struct ieee80211_hw *hw,
 
 	wl->scanning = true;
 
-	ret = wl1251_cmd_scan(wl, ssid, ssid_len, 13, 3);
+	ret = wl1251_cmd_scan(wl, ssid, ssid_len, req->channels,
+			      req->n_channels, WL1251_SCAN_NUM_PROBES);
 	if (ret < 0) {
 		wl->scanning = false;
 		goto out_sleep;

