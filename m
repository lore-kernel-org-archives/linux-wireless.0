Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:55912 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267Ab3IYJid (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 05:38:33 -0400
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH 13/13] ath10k: handle FW API differences for scan structures
Date: Wed, 25 Sep 2013 11:38:11 +0200
Message-ID: <1380101891-18312-14-git-send-email-bartosz.markowski@tieto.com> (sfid-20130925_113845_498153_9E46C716)
In-Reply-To: <1380101891-18312-1-git-send-email-bartosz.markowski@tieto.com>
References: <1380101891-18312-1-git-send-email-bartosz.markowski@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wmi_start_scan_cmd has an extra filed in our main
firmware track, reflact that to not have a mismatch in
case of 10.x track.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c |   19 ++++++--
 drivers/net/wireless/ath/ath10k/wmi.h |   82 +++++++++++++++++++++++++++++++++
 2 files changed, 97 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 2a55bc8..d4ba78546 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2377,11 +2377,15 @@ out:
 	return ath10k_wmi_cmd_send(ar, buf, ar->wmi.cmd->wmi_init_cmdid);
 }
 
-static int ath10k_wmi_start_scan_calc_len(const struct wmi_start_scan_arg *arg)
+static int ath10k_wmi_start_scan_calc_len(struct ath10k *ar,
+					  const struct wmi_start_scan_arg *arg)
 {
 	int len;
 
-	len = sizeof(struct wmi_start_scan_cmd);
+	if (test_bit(ATH10K_FW_FEATURE_10X, ar->fw_features))
+		len = sizeof(struct wmi_start_scan_cmd_10x);
+	else
+		len = sizeof(struct wmi_start_scan_cmd);
 
 	if (arg->ie_len) {
 		if (!arg->ie)
@@ -2441,7 +2445,7 @@ int ath10k_wmi_start_scan(struct ath10k *ar,
 	int len = 0;
 	int i;
 
-	len = ath10k_wmi_start_scan_calc_len(arg);
+	len = ath10k_wmi_start_scan_calc_len(ar, arg);
 	if (len < 0)
 		return len; /* len contains error code here */
 
@@ -2473,7 +2477,14 @@ int ath10k_wmi_start_scan(struct ath10k *ar,
 	cmd->scan_ctrl_flags    = __cpu_to_le32(arg->scan_ctrl_flags);
 
 	/* TLV list starts after fields included in the struct */
-	off = sizeof(*cmd);
+	/* There's just one filed that differes the two start_scan
+	 * structures - burst_duration, which we are not using btw,
+	   no point to make the split here, just shift the buffer to fit with
+	   given FW */
+	if (test_bit(ATH10K_FW_FEATURE_10X, ar->fw_features))
+		off = sizeof(struct wmi_start_scan_cmd_10x);
+	else
+		off = sizeof(struct wmi_start_scan_cmd);
 
 	if (arg->n_channels) {
 		channels = (void *)skb->data + off;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index fcada27..75b9978 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -1715,6 +1715,88 @@ struct wmi_start_scan_cmd {
 	 */
 } __packed;
 
+/* This is the definition from 10.X firmware branch */
+struct wmi_start_scan_cmd_10x {
+	/* Scan ID */
+	__le32 scan_id;
+
+	/* Scan requestor ID */
+	__le32 scan_req_id;
+
+	/* VDEV id(interface) that is requesting scan */
+	__le32 vdev_id;
+
+	/* Scan Priority, input to scan scheduler */
+	__le32 scan_priority;
+
+	/* Scan events subscription */
+	__le32 notify_scan_events;
+
+	/* dwell time in msec on active channels */
+	__le32 dwell_time_active;
+
+	/* dwell time in msec on passive channels */
+	__le32 dwell_time_passive;
+
+	/*
+	 * min time in msec on the BSS channel,only valid if atleast one
+	 * VDEV is active
+	 */
+	__le32 min_rest_time;
+
+	/*
+	 * max rest time in msec on the BSS channel,only valid if at least
+	 * one VDEV is active
+	 */
+	/*
+	 * the scanner will rest on the bss channel at least min_rest_time
+	 * after min_rest_time the scanner will start checking for tx/rx
+	 * activity on all VDEVs. if there is no activity the scanner will
+	 * switch to off channel. if there is activity the scanner will let
+	 * the radio on the bss channel until max_rest_time expires.at
+	 * max_rest_time scanner will switch to off channel irrespective of
+	 * activity. activity is determined by the idle_time parameter.
+	 */
+	__le32 max_rest_time;
+
+	/*
+	 * time before sending next set of probe requests.
+	 * The scanner keeps repeating probe requests transmission with
+	 * period specified by repeat_probe_time.
+	 * The number of probe requests specified depends on the ssid_list
+	 * and bssid_list
+	 */
+	__le32 repeat_probe_time;
+
+	/* time in msec between 2 consequetive probe requests with in a set. */
+	__le32 probe_spacing_time;
+
+	/*
+	 * data inactivity time in msec on bss channel that will be used by
+	 * scanner for measuring the inactivity.
+	 */
+	__le32 idle_time;
+
+	/* maximum time in msec allowed for scan  */
+	__le32 max_scan_time;
+
+	/*
+	 * delay in msec before sending first probe request after switching
+	 * to a channel
+	 */
+	__le32 probe_delay;
+
+	/* Scan control flags */
+	__le32 scan_ctrl_flags;
+
+	/*
+	 * TLV (tag length value )  paramerters follow the scan_cmd structure.
+	 * TLV can contain channel list, bssid list, ssid list and
+	 * ie. the TLV tags are defined above;
+	 */
+} __packed;
+
+
 struct wmi_ssid_arg {
 	int len;
 	const u8 *ssid;
-- 
1.7.10

