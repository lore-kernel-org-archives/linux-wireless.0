Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:55939 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049AbaIRNcR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2014 09:32:17 -0400
Received: by mail-wi0-f169.google.com with SMTP id hi2so157889wib.0
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2014 06:32:16 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 9/9] ath10k: re-work scan start command building
Date: Thu, 18 Sep 2014 15:21:27 +0200
Message-Id: <1411046487-19544-10-git-send-email-michal.kazior@tieto.com> (sfid-20140918_153225_452023_8E312CEC)
In-Reply-To: <1411046487-19544-1-git-send-email-michal.kazior@tieto.com>
References: <1411046487-19544-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This gets rid of the ugly scan structure building
and uses a saner way to do it.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 191 ++++++++++++++++++----------------
 drivers/net/wireless/ath/ath10k/wmi.h | 100 +++---------------
 2 files changed, 119 insertions(+), 172 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 6819255..5537523 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3157,52 +3157,50 @@ int ath10k_wmi_cmd_init(struct ath10k *ar)
 	return ret;
 }
 
-static int ath10k_wmi_start_scan_calc_len(struct ath10k *ar,
-					  const struct wmi_start_scan_arg *arg)
+static int ath10k_wmi_start_scan_verify(const struct wmi_start_scan_arg *arg)
 {
-	int len;
+	if (arg->ie_len && !arg->ie)
+		return -EINVAL;
+	if (arg->n_channels && !arg->channels)
+		return -EINVAL;
+	if (arg->n_ssids && !arg->ssids)
+		return -EINVAL;
+	if (arg->n_bssids && !arg->bssids)
+		return -EINVAL;
 
-	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features))
-		len = sizeof(struct wmi_start_scan_cmd_10x);
-	else
-		len = sizeof(struct wmi_start_scan_cmd);
+	if (arg->ie_len > WLAN_SCAN_PARAMS_MAX_IE_LEN)
+		return -EINVAL;
+	if (arg->n_channels > ARRAY_SIZE(arg->channels))
+		return -EINVAL;
+	if (arg->n_ssids > WLAN_SCAN_PARAMS_MAX_SSID)
+		return -EINVAL;
+	if (arg->n_bssids > WLAN_SCAN_PARAMS_MAX_BSSID)
+		return -EINVAL;
 
-	if (arg->ie_len) {
-		if (!arg->ie)
-			return -EINVAL;
-		if (arg->ie_len > WLAN_SCAN_PARAMS_MAX_IE_LEN)
-			return -EINVAL;
+	return 0;
+}
 
+static size_t
+ath10k_wmi_start_scan_tlvs_len(const struct wmi_start_scan_arg *arg)
+{
+	int len = 0;
+
+	if (arg->ie_len) {
 		len += sizeof(struct wmi_ie_data);
 		len += roundup(arg->ie_len, 4);
 	}
 
 	if (arg->n_channels) {
-		if (!arg->channels)
-			return -EINVAL;
-		if (arg->n_channels > ARRAY_SIZE(arg->channels))
-			return -EINVAL;
-
 		len += sizeof(struct wmi_chan_list);
 		len += sizeof(__le32) * arg->n_channels;
 	}
 
 	if (arg->n_ssids) {
-		if (!arg->ssids)
-			return -EINVAL;
-		if (arg->n_ssids > WLAN_SCAN_PARAMS_MAX_SSID)
-			return -EINVAL;
-
 		len += sizeof(struct wmi_ssid_list);
 		len += sizeof(struct wmi_ssid) * arg->n_ssids;
 	}
 
 	if (arg->n_bssids) {
-		if (!arg->bssids)
-			return -EINVAL;
-		if (arg->n_bssids > WLAN_SCAN_PARAMS_MAX_BSSID)
-			return -EINVAL;
-
 		len += sizeof(struct wmi_bssid_list);
 		len += sizeof(struct wmi_mac_addr) * arg->n_bssids;
 	}
@@ -3210,28 +3208,12 @@ static int ath10k_wmi_start_scan_calc_len(struct ath10k *ar,
 	return len;
 }
 
-int ath10k_wmi_start_scan(struct ath10k *ar,
-			  const struct wmi_start_scan_arg *arg)
+static void
+ath10k_wmi_put_start_scan_common(struct wmi_start_scan_common *cmn,
+				 const struct wmi_start_scan_arg *arg)
 {
-	struct wmi_start_scan_cmd *cmd;
-	struct sk_buff *skb;
-	struct wmi_ie_data *ie;
-	struct wmi_chan_list *channels;
-	struct wmi_ssid_list *ssids;
-	struct wmi_bssid_list *bssids;
 	u32 scan_id;
 	u32 scan_req_id;
-	int off;
-	int len = 0;
-	int i;
-
-	len = ath10k_wmi_start_scan_calc_len(ar, arg);
-	if (len < 0)
-		return len; /* len contains error code here */
-
-	skb = ath10k_wmi_alloc_skb(ar, len);
-	if (!skb)
-		return -ENOMEM;
 
 	scan_id  = WMI_HOST_SCAN_REQ_ID_PREFIX;
 	scan_id |= arg->scan_id;
@@ -3239,35 +3221,36 @@ int ath10k_wmi_start_scan(struct ath10k *ar,
 	scan_req_id  = WMI_HOST_SCAN_REQUESTOR_ID_PREFIX;
 	scan_req_id |= arg->scan_req_id;
 
-	cmd = (struct wmi_start_scan_cmd *)skb->data;
-	cmd->scan_id            = __cpu_to_le32(scan_id);
-	cmd->scan_req_id        = __cpu_to_le32(scan_req_id);
-	cmd->vdev_id            = __cpu_to_le32(arg->vdev_id);
-	cmd->scan_priority      = __cpu_to_le32(arg->scan_priority);
-	cmd->notify_scan_events = __cpu_to_le32(arg->notify_scan_events);
-	cmd->dwell_time_active  = __cpu_to_le32(arg->dwell_time_active);
-	cmd->dwell_time_passive = __cpu_to_le32(arg->dwell_time_passive);
-	cmd->min_rest_time      = __cpu_to_le32(arg->min_rest_time);
-	cmd->max_rest_time      = __cpu_to_le32(arg->max_rest_time);
-	cmd->repeat_probe_time  = __cpu_to_le32(arg->repeat_probe_time);
-	cmd->probe_spacing_time = __cpu_to_le32(arg->probe_spacing_time);
-	cmd->idle_time          = __cpu_to_le32(arg->idle_time);
-	cmd->max_scan_time      = __cpu_to_le32(arg->max_scan_time);
-	cmd->probe_delay        = __cpu_to_le32(arg->probe_delay);
-	cmd->scan_ctrl_flags    = __cpu_to_le32(arg->scan_ctrl_flags);
-
-	/* TLV list starts after fields included in the struct */
-	/* There's just one filed that differes the two start_scan
-	 * structures - burst_duration, which we are not using btw,
-	   no point to make the split here, just shift the buffer to fit with
-	   given FW */
-	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features))
-		off = sizeof(struct wmi_start_scan_cmd_10x);
-	else
-		off = sizeof(struct wmi_start_scan_cmd);
+	cmn->scan_id            = __cpu_to_le32(scan_id);
+	cmn->scan_req_id        = __cpu_to_le32(scan_req_id);
+	cmn->vdev_id            = __cpu_to_le32(arg->vdev_id);
+	cmn->scan_priority      = __cpu_to_le32(arg->scan_priority);
+	cmn->notify_scan_events = __cpu_to_le32(arg->notify_scan_events);
+	cmn->dwell_time_active  = __cpu_to_le32(arg->dwell_time_active);
+	cmn->dwell_time_passive = __cpu_to_le32(arg->dwell_time_passive);
+	cmn->min_rest_time      = __cpu_to_le32(arg->min_rest_time);
+	cmn->max_rest_time      = __cpu_to_le32(arg->max_rest_time);
+	cmn->repeat_probe_time  = __cpu_to_le32(arg->repeat_probe_time);
+	cmn->probe_spacing_time = __cpu_to_le32(arg->probe_spacing_time);
+	cmn->idle_time          = __cpu_to_le32(arg->idle_time);
+	cmn->max_scan_time      = __cpu_to_le32(arg->max_scan_time);
+	cmn->probe_delay        = __cpu_to_le32(arg->probe_delay);
+	cmn->scan_ctrl_flags    = __cpu_to_le32(arg->scan_ctrl_flags);
+}
+
+static void
+ath10k_wmi_put_start_scan_tlvs(struct wmi_start_scan_tlvs *tlvs,
+			       const struct wmi_start_scan_arg *arg)
+{
+	struct wmi_ie_data *ie;
+	struct wmi_chan_list *channels;
+	struct wmi_ssid_list *ssids;
+	struct wmi_bssid_list *bssids;
+	void *ptr = tlvs->tlvs;
+	int i;
 
 	if (arg->n_channels) {
-		channels = (void *)skb->data + off;
+		channels = ptr;
 		channels->tag = __cpu_to_le32(WMI_CHAN_LIST_TAG);
 		channels->num_chan = __cpu_to_le32(arg->n_channels);
 
@@ -3275,12 +3258,12 @@ int ath10k_wmi_start_scan(struct ath10k *ar,
 			channels->channel_list[i].freq =
 				__cpu_to_le16(arg->channels[i]);
 
-		off += sizeof(*channels);
-		off += sizeof(__le32) * arg->n_channels;
+		ptr += sizeof(*channels);
+		ptr += sizeof(__le32) * arg->n_channels;
 	}
 
 	if (arg->n_ssids) {
-		ssids = (void *)skb->data + off;
+		ssids = ptr;
 		ssids->tag = __cpu_to_le32(WMI_SSID_LIST_TAG);
 		ssids->num_ssids = __cpu_to_le32(arg->n_ssids);
 
@@ -3292,12 +3275,12 @@ int ath10k_wmi_start_scan(struct ath10k *ar,
 			       arg->ssids[i].len);
 		}
 
-		off += sizeof(*ssids);
-		off += sizeof(struct wmi_ssid) * arg->n_ssids;
+		ptr += sizeof(*ssids);
+		ptr += sizeof(struct wmi_ssid) * arg->n_ssids;
 	}
 
 	if (arg->n_bssids) {
-		bssids = (void *)skb->data + off;
+		bssids = ptr;
 		bssids->tag = __cpu_to_le32(WMI_BSSID_LIST_TAG);
 		bssids->num_bssid = __cpu_to_le32(arg->n_bssids);
 
@@ -3306,23 +3289,57 @@ int ath10k_wmi_start_scan(struct ath10k *ar,
 			       arg->bssids[i].bssid,
 			       ETH_ALEN);
 
-		off += sizeof(*bssids);
-		off += sizeof(struct wmi_mac_addr) * arg->n_bssids;
+		ptr += sizeof(*bssids);
+		ptr += sizeof(struct wmi_mac_addr) * arg->n_bssids;
 	}
 
 	if (arg->ie_len) {
-		ie = (void *)skb->data + off;
+		ie = ptr;
 		ie->tag = __cpu_to_le32(WMI_IE_TAG);
 		ie->ie_len = __cpu_to_le32(arg->ie_len);
 		memcpy(ie->ie_data, arg->ie, arg->ie_len);
 
-		off += sizeof(*ie);
-		off += roundup(arg->ie_len, 4);
+		ptr += sizeof(*ie);
+		ptr += roundup(arg->ie_len, 4);
 	}
+}
 
-	if (off != skb->len) {
-		dev_kfree_skb(skb);
-		return -EINVAL;
+int ath10k_wmi_start_scan(struct ath10k *ar,
+			  const struct wmi_start_scan_arg *arg)
+{
+	struct sk_buff *skb;
+	size_t len;
+	int ret;
+
+	ret = ath10k_wmi_start_scan_verify(arg);
+	if (ret)
+		return ret;
+
+	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features))
+		len = sizeof(struct wmi_start_scan_cmd) +
+		      ath10k_wmi_start_scan_tlvs_len(arg);
+	else
+		len = sizeof(struct wmi_10x_start_scan_cmd) +
+		      ath10k_wmi_start_scan_tlvs_len(arg);
+
+	skb = ath10k_wmi_alloc_skb(ar, len);
+	if (!skb)
+		return -ENOMEM;
+
+	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features)) {
+		struct wmi_10x_start_scan_cmd *cmd;
+
+		cmd = (struct wmi_10x_start_scan_cmd *)skb->data;
+		ath10k_wmi_put_start_scan_common(&cmd->common, arg);
+		ath10k_wmi_put_start_scan_tlvs(&cmd->tlvs, arg);
+	} else {
+		struct wmi_start_scan_cmd *cmd;
+
+		cmd = (struct wmi_start_scan_cmd *)skb->data;
+		cmd->burst_duration_ms = __cpu_to_le32(0);
+
+		ath10k_wmi_put_start_scan_common(&cmd->common, arg);
+		ath10k_wmi_put_start_scan_tlvs(&cmd->tlvs, arg);
 	}
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi start scan\n");
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index a041567..d896bd3 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -1963,7 +1963,7 @@ enum wmi_scan_priority {
 	WMI_SCAN_PRIORITY_COUNT   /* number of priorities supported */
 };
 
-struct wmi_start_scan_cmd {
+struct wmi_start_scan_common {
 	/* Scan ID */
 	__le32 scan_id;
 	/* Scan requestor ID */
@@ -2021,95 +2021,25 @@ struct wmi_start_scan_cmd {
 	__le32 probe_delay;
 	/* Scan control flags */
 	__le32 scan_ctrl_flags;
-
-	/* Burst duration time in msecs */
-	__le32 burst_duration;
-	/*
-	 * TLV (tag length value )  paramerters follow the scan_cmd structure.
-	 * TLV can contain channel list, bssid list, ssid list and
-	 * ie. the TLV tags are defined above;
-	 */
 } __packed;
 
-/* This is the definition from 10.X firmware branch */
-struct wmi_start_scan_cmd_10x {
-	/* Scan ID */
-	__le32 scan_id;
-
-	/* Scan requestor ID */
-	__le32 scan_req_id;
-
-	/* VDEV id(interface) that is requesting scan */
-	__le32 vdev_id;
-
-	/* Scan Priority, input to scan scheduler */
-	__le32 scan_priority;
-
-	/* Scan events subscription */
-	__le32 notify_scan_events;
-
-	/* dwell time in msec on active channels */
-	__le32 dwell_time_active;
-
-	/* dwell time in msec on passive channels */
-	__le32 dwell_time_passive;
-
-	/*
-	 * min time in msec on the BSS channel,only valid if atleast one
-	 * VDEV is active
-	 */
-	__le32 min_rest_time;
-
-	/*
-	 * max rest time in msec on the BSS channel,only valid if at least
-	 * one VDEV is active
-	 */
-	/*
-	 * the scanner will rest on the bss channel at least min_rest_time
-	 * after min_rest_time the scanner will start checking for tx/rx
-	 * activity on all VDEVs. if there is no activity the scanner will
-	 * switch to off channel. if there is activity the scanner will let
-	 * the radio on the bss channel until max_rest_time expires.at
-	 * max_rest_time scanner will switch to off channel irrespective of
-	 * activity. activity is determined by the idle_time parameter.
-	 */
-	__le32 max_rest_time;
-
-	/*
-	 * time before sending next set of probe requests.
-	 * The scanner keeps repeating probe requests transmission with
-	 * period specified by repeat_probe_time.
-	 * The number of probe requests specified depends on the ssid_list
-	 * and bssid_list
-	 */
-	__le32 repeat_probe_time;
-
-	/* time in msec between 2 consequetive probe requests with in a set. */
-	__le32 probe_spacing_time;
-
-	/*
-	 * data inactivity time in msec on bss channel that will be used by
-	 * scanner for measuring the inactivity.
-	 */
-	__le32 idle_time;
-
-	/* maximum time in msec allowed for scan  */
-	__le32 max_scan_time;
-
-	/*
-	 * delay in msec before sending first probe request after switching
-	 * to a channel
+struct wmi_start_scan_tlvs {
+	/* TLV parameters. These includes channel list, ssid list, bssid list,
+	 * extra ies.
 	 */
-	__le32 probe_delay;
+	u8 tlvs[0];
+} __packed;
 
-	/* Scan control flags */
-	__le32 scan_ctrl_flags;
+struct wmi_start_scan_cmd {
+	struct wmi_start_scan_common common;
+	__le32 burst_duration_ms;
+	struct wmi_start_scan_tlvs tlvs;
+} __packed;
 
-	/*
-	 * TLV (tag length value )  paramerters follow the scan_cmd structure.
-	 * TLV can contain channel list, bssid list, ssid list and
-	 * ie. the TLV tags are defined above;
-	 */
+/* This is the definition from 10.X firmware branch */
+struct wmi_10x_start_scan_cmd {
+	struct wmi_start_scan_common common;
+	struct wmi_start_scan_tlvs tlvs;
 } __packed;
 
 struct wmi_ssid_arg {
-- 
1.8.5.3

