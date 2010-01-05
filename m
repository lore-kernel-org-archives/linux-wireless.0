Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:44685 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017Ab0AESQy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 13:16:54 -0500
Received: from saunalahti-vams (vs3-12.mail.saunalahti.fi [62.142.5.96])
	by emh02-2.mail.saunalahti.fi (Postfix) with SMTP id E3E9DEF550
	for <linux-wireless@vger.kernel.org>; Tue,  5 Jan 2010 20:16:52 +0200 (EET)
Received: from [127.0.1.1] (a91-155-131-184.elisa-laajakaista.fi [91.155.131.184])
	by emh01.mail.saunalahti.fi (Postfix) with ESMTP id B92B24064
	for <linux-wireless@vger.kernel.org>; Tue,  5 Jan 2010 20:16:51 +0200 (EET)
Subject: [PATCH v2 6/9] wl1251: cleanup scanning code
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 05 Jan 2010 20:16:51 +0200
Message-ID: <20100105181651.27418.32061.stgit@tikku>
In-Reply-To: <20100105181522.27418.97100.stgit@tikku>
References: <20100105181522.27418.97100.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

The current scanning code wasn't following the preferred style. Move code
related to scan and trigger scan to commans to wl1251_cmd.c. Because
there's now less code in wl1251_hw_scan(), the function can be now
merged with wl1251_op_hw_scan().

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1251_cmd.c  |   82 +++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1251_cmd.h  |   17 +++-
 drivers/net/wireless/wl12xx/wl1251_main.c |  125 ++++++-----------------------
 3 files changed, 117 insertions(+), 107 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_cmd.c b/drivers/net/wireless/wl12xx/wl1251_cmd.c
index 770f260..fcbfbd7 100644
--- a/drivers/net/wireless/wl12xx/wl1251_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1251_cmd.c
@@ -410,3 +410,85 @@ out:
 	kfree(cmd);
 	return ret;
 }
+
+int wl1251_cmd_scan(struct wl1251 *wl, u8 *ssid, size_t ssid_len,
+		    unsigned int n_channels, unsigned int n_probes)
+{
+	struct wl1251_cmd_scan *cmd;
+	int i, ret = 0;
+
+	wl1251_debug(DEBUG_CMD, "cmd scan");
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+
+	cmd->params.rx_config_options = cpu_to_le32(CFG_RX_ALL_GOOD);
+	cmd->params.rx_filter_options = cpu_to_le32(CFG_RX_PRSP_EN |
+						    CFG_RX_MGMT_EN |
+						    CFG_RX_BCN_EN);
+	cmd->params.scan_options = 0;
+	cmd->params.num_channels = n_channels;
+	cmd->params.num_probe_requests = n_probes;
+	cmd->params.tx_rate = cpu_to_le16(1 << 1); /* 2 Mbps */
+	cmd->params.tid_trigger = 0;
+
+	for (i = 0; i < n_channels; i++) {
+		cmd->channels[i].min_duration =
+			cpu_to_le32(WL1251_SCAN_MIN_DURATION);
+		cmd->channels[i].max_duration =
+			cpu_to_le32(WL1251_SCAN_MAX_DURATION);
+		memset(&cmd->channels[i].bssid_lsb, 0xff, 4);
+		memset(&cmd->channels[i].bssid_msb, 0xff, 2);
+		cmd->channels[i].early_termination = 0;
+		cmd->channels[i].tx_power_att = 0;
+		cmd->channels[i].channel = i + 1;
+	}
+
+	cmd->params.ssid_len = ssid_len;
+	if (ssid)
+		memcpy(cmd->params.ssid, ssid, ssid_len);
+
+	ret = wl1251_cmd_send(wl, CMD_SCAN, cmd, sizeof(*cmd));
+	if (ret < 0) {
+		wl1251_error("cmd scan failed: %d", ret);
+		goto out;
+	}
+
+	wl1251_mem_read(wl, wl->cmd_box_addr, cmd, sizeof(*cmd));
+
+	if (cmd->header.status != CMD_STATUS_SUCCESS) {
+		wl1251_error("cmd scan status wasn't success: %d",
+			     cmd->header.status);
+		ret = -EIO;
+		goto out;
+	}
+
+out:
+	kfree(cmd);
+	return ret;
+}
+
+int wl1251_cmd_trigger_scan_to(struct wl1251 *wl, u32 timeout)
+{
+	struct wl1251_cmd_trigger_scan_to *cmd;
+	int ret;
+
+	wl1251_debug(DEBUG_CMD, "cmd trigger scan to");
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+
+	cmd->timeout = timeout;
+
+	ret = wl1251_cmd_send(wl, CMD_SCAN, cmd, sizeof(*cmd));
+	if (ret < 0) {
+		wl1251_error("cmd trigger scan to failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(cmd);
+	return ret;
+}
diff --git a/drivers/net/wireless/wl12xx/wl1251_cmd.h b/drivers/net/wireless/wl12xx/wl1251_cmd.h
index dff798a..63ae319 100644
--- a/drivers/net/wireless/wl12xx/wl1251_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1251_cmd.h
@@ -43,6 +43,9 @@ int wl1251_cmd_read_memory(struct wl1251 *wl, u32 addr, void *answer,
 			   size_t len);
 int wl1251_cmd_template_set(struct wl1251 *wl, u16 cmd_id,
 			    void *buf, size_t buf_len);
+int wl1251_cmd_scan(struct wl1251 *wl, u8 *ssid, size_t ssid_len,
+		    unsigned int n_channels, unsigned int n_probes);
+int wl1251_cmd_trigger_scan_to(struct wl1251 *wl, u32 timeout);
 
 /* unit ms */
 #define WL1251_COMMAND_TIMEOUT 2000
@@ -163,8 +166,10 @@ struct cmd_read_write_memory {
 #define CMDMBOX_HEADER_LEN 4
 #define CMDMBOX_INFO_ELEM_HEADER_LEN 4
 
+#define WL1251_SCAN_MIN_DURATION 30000
+#define WL1251_SCAN_MAX_DURATION 60000
 
-struct basic_scan_parameters {
+struct wl1251_scan_parameters {
 	u32 rx_config_options;
 	u32 rx_filter_options;
 
@@ -189,11 +194,11 @@ struct basic_scan_parameters {
 
 	u8 tid_trigger;
 	u8 ssid_len;
-	u32 ssid[8];
+	u8 ssid[32];
 
 } __attribute__ ((packed));
 
-struct basic_scan_channel_parameters {
+struct wl1251_scan_ch_parameters {
 	u32 min_duration; /* in TU */
 	u32 max_duration; /* in TU */
 	u32 bssid_lsb;
@@ -213,11 +218,11 @@ struct basic_scan_channel_parameters {
 /* SCAN parameters */
 #define SCAN_MAX_NUM_OF_CHANNELS 16
 
-struct cmd_scan {
+struct wl1251_cmd_scan {
 	struct wl1251_cmd_header header;
 
-	struct basic_scan_parameters params;
-	struct basic_scan_channel_parameters channels[SCAN_MAX_NUM_OF_CHANNELS];
+	struct wl1251_scan_parameters params;
+	struct wl1251_scan_ch_parameters channels[SCAN_MAX_NUM_OF_CHANNELS];
 } __attribute__ ((packed));
 
 enum {
diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index 6cce864..e038707 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -903,111 +903,13 @@ static int wl1251_build_probe_req(struct wl1251 *wl, u8 *ssid, size_t ssid_len)
 				      size);
 }
 
-static int wl1251_hw_scan(struct wl1251 *wl, u8 *ssid, size_t len,
-			  u8 active_scan, u8 high_prio, u8 num_channels,
-			  u8 probe_requests)
-{
-	struct wl1251_cmd_trigger_scan_to *trigger = NULL;
-	struct cmd_scan *params = NULL;
-	int i, ret;
-	u16 scan_options = 0;
-
-	if (wl->scanning)
-		return -EINVAL;
-
-	params = kzalloc(sizeof(*params), GFP_KERNEL);
-	if (!params)
-		return -ENOMEM;
-
-	params->params.rx_config_options = cpu_to_le32(CFG_RX_ALL_GOOD);
-	params->params.rx_filter_options =
-		cpu_to_le32(CFG_RX_PRSP_EN | CFG_RX_MGMT_EN | CFG_RX_BCN_EN);
-
-	/* High priority scan */
-	if (!active_scan)
-		scan_options |= SCAN_PASSIVE;
-	if (high_prio)
-		scan_options |= SCAN_PRIORITY_HIGH;
-	params->params.scan_options = scan_options;
-
-	params->params.num_channels = num_channels;
-	params->params.num_probe_requests = probe_requests;
-	params->params.tx_rate = cpu_to_le16(1 << 1); /* 2 Mbps */
-	params->params.tid_trigger = 0;
-
-	for (i = 0; i < num_channels; i++) {
-		params->channels[i].min_duration = cpu_to_le32(30000);
-		params->channels[i].max_duration = cpu_to_le32(60000);
-		memset(&params->channels[i].bssid_lsb, 0xff, 4);
-		memset(&params->channels[i].bssid_msb, 0xff, 2);
-		params->channels[i].early_termination = 0;
-		params->channels[i].tx_power_att = 0;
-		params->channels[i].channel = i + 1;
-		memset(params->channels[i].pad, 0, 3);
-	}
-
-	for (i = num_channels; i < SCAN_MAX_NUM_OF_CHANNELS; i++)
-		memset(&params->channels[i], 0,
-		       sizeof(struct basic_scan_channel_parameters));
-
-	if (len && ssid) {
-		params->params.ssid_len = len;
-		memcpy(params->params.ssid, ssid, len);
-	} else {
-		params->params.ssid_len = 0;
-		memset(params->params.ssid, 0, 32);
-	}
-
-	ret = wl1251_build_probe_req(wl, ssid, len);
-	if (ret < 0) {
-		wl1251_error("PROBE request template failed");
-		goto out;
-	}
-
-	trigger = kzalloc(sizeof(*trigger), GFP_KERNEL);
-	if (!trigger)
-		goto out;
-
-	trigger->timeout = 0;
-
-	ret = wl1251_cmd_send(wl, CMD_TRIGGER_SCAN_TO, trigger,
-			      sizeof(*trigger));
-	if (ret < 0) {
-		wl1251_error("trigger scan to failed for hw scan");
-		goto out;
-	}
-
-	wl1251_dump(DEBUG_SCAN, "SCAN: ", params, sizeof(*params));
-
-	wl->scanning = true;
-
-	ret = wl1251_cmd_send(wl, CMD_SCAN, params, sizeof(*params));
-	if (ret < 0)
-		wl1251_error("SCAN failed");
-
-	wl1251_mem_read(wl, wl->cmd_box_addr, params, sizeof(*params));
-
-	if (params->header.status != CMD_STATUS_SUCCESS) {
-		wl1251_error("TEST command answer error: %d",
-			     params->header.status);
-		wl->scanning = false;
-		ret = -EIO;
-		goto out;
-	}
-
-out:
-	kfree(params);
-	return ret;
-
-}
-
 static int wl1251_op_hw_scan(struct ieee80211_hw *hw,
 			     struct cfg80211_scan_request *req)
 {
 	struct wl1251 *wl = hw->priv;
-	int ret;
-	u8 *ssid = NULL;
 	size_t ssid_len = 0;
+	u8 *ssid = NULL;
+	int ret;
 
 	wl1251_debug(DEBUG_MAC80211, "mac80211 hw scan");
 
@@ -1018,12 +920,33 @@ static int wl1251_op_hw_scan(struct ieee80211_hw *hw,
 
 	mutex_lock(&wl->mutex);
 
+	if (wl->scanning) {
+		wl1251_debug(DEBUG_SCAN, "scan already in progress");
+		ret = -EINVAL;
+		goto out;
+	}
+
 	ret = wl1251_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out;
 
-	ret = wl1251_hw_scan(hw->priv, ssid, ssid_len, 1, 0, 13, 3);
+	ret = wl1251_build_probe_req(wl, ssid, ssid_len);
+	if (ret < 0)
+		wl1251_error("probe request template build failed");
+
+	ret = wl1251_cmd_trigger_scan_to(wl, 0);
+	if (ret < 0)
+		goto out_sleep;
+
+	wl->scanning = true;
 
+	ret = wl1251_cmd_scan(wl, ssid, ssid_len, 13, 3);
+	if (ret < 0) {
+		wl->scanning = false;
+		goto out_sleep;
+	}
+
+out_sleep:
 	wl1251_ps_elp_sleep(wl);
 
 out:

