Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47827 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab1KGF21 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 00:28:27 -0500
From: Raja Mani <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH v2 02/11] ath6kl: Add wmi functions to configure WOW mode and host sleep mode
Date: Mon, 7 Nov 2011 10:55:38 +0530
Message-ID: <1320643547-3578-3-git-send-email-rmani@qca.qualcomm.com> (sfid-20111107_062830_072857_EDBB3ECD)
In-Reply-To: <1320643547-3578-1-git-send-email-rmani@qca.qualcomm.com>
References: <1320643547-3578-1-git-send-email-rmani@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It will be used in WOW suspend/resume functions to
active/deactivate WOW suspend mode.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c |  108 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h |   41 ++++++++++++
 2 files changed, 149 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 925ef4c..3da1fb5 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2412,6 +2412,114 @@ int ath6kl_wmi_set_ip_cmd(struct wmi *wmi, struct wmi_set_ip_cmd *ip_cmd)
 	return ret;
 }
 
+static void ath6kl_wmi_relinquish_implicit_pstream_credits(struct wmi *wmi)
+{
+	u16 active_tsids;
+	u8 stream_exist;
+	int i;
+
+	/*
+	 * Relinquish credits from all implicitly created pstreams
+	 * since when we go to sleep. If user created explicit
+	 * thinstreams exists with in a fatpipe leave them intact
+	 * for the user to delete.
+	 */
+	spin_lock_bh(&wmi->lock);
+	stream_exist = wmi->fat_pipe_exist;
+	spin_unlock_bh(&wmi->lock);
+
+	for (i = 0; i < WMM_NUM_AC; i++) {
+		if (stream_exist & (1 << i)) {
+
+			/*
+			 * FIXME: Is this lock & unlock inside
+			 * for loop correct? may need rework.
+			 */
+			spin_lock_bh(&wmi->lock);
+			active_tsids = wmi->stream_exist_for_ac[i];
+			spin_unlock_bh(&wmi->lock);
+
+			/*
+			 * If there are no user created thin streams
+			 * delete the fatpipe
+			 */
+			if (!active_tsids) {
+				stream_exist &= ~(1 << i);
+				/*
+				 * Indicate inactivity to driver layer for
+				 * this fatpipe (pstream)
+				 */
+				ath6kl_indicate_tx_activity(wmi->parent_dev,
+							    i, false);
+			}
+		}
+	}
+
+	/* FIXME: Can we do this assignment without locking ? */
+	spin_lock_bh(&wmi->lock);
+	wmi->fat_pipe_exist = stream_exist;
+	spin_unlock_bh(&wmi->lock);
+}
+
+int ath6kl_wmi_set_host_sleep_mode_cmd(struct wmi *wmi, u8 if_idx,
+				       enum ath6kl_host_mode host_mode)
+{
+	struct sk_buff *skb;
+	struct wmi_set_host_sleep_mode_cmd *cmd;
+	int ret;
+
+	if ((host_mode != ATH6KL_HOST_MODE_ASLEEP) &&
+	    (host_mode != ATH6KL_HOST_MODE_AWAKE)) {
+		ath6kl_err("invalid host sleep mode: %d\n", host_mode);
+		return -EINVAL;
+	}
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*cmd));
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct wmi_set_host_sleep_mode_cmd *) skb->data;
+
+	if (host_mode == ATH6KL_HOST_MODE_ASLEEP) {
+		ath6kl_wmi_relinquish_implicit_pstream_credits(wmi);
+		cmd->asleep = cpu_to_le32(1);
+	} else
+		cmd->awake = cpu_to_le32(1);
+
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb,
+				  WMI_SET_HOST_SLEEP_MODE_CMDID,
+				  NO_SYNC_WMIFLAG);
+	return ret;
+}
+
+int ath6kl_wmi_set_wow_mode_cmd(struct wmi *wmi, u8 if_idx,
+				enum ath6kl_wow_mode wow_mode,
+				u32 filter, u16 host_req_delay)
+{
+	struct sk_buff *skb;
+	struct wmi_set_wow_mode_cmd *cmd;
+	int ret;
+
+	if ((wow_mode != ATH6KL_WOW_MODE_ENABLE) &&
+	     wow_mode != ATH6KL_WOW_MODE_DISABLE) {
+		ath6kl_err("invalid wow mode: %d\n", wow_mode);
+		return -EINVAL;
+	}
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*cmd));
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct wmi_set_wow_mode_cmd *) skb->data;
+	cmd->enable_wow = cpu_to_le32(wow_mode);
+	cmd->filter = cpu_to_le32(filter);
+	cmd->host_req_delay = cpu_to_le16(host_req_delay);
+
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_SET_WOW_MODE_CMDID,
+				  NO_SYNC_WMIFLAG);
+	return ret;
+}
+
 int ath6kl_wmi_add_wow_pattern_cmd(struct wmi *wmi, u8 if_idx,
 				   u8 list_id, u8 filter_size,
 				   u8 filter_offset, u8 *filter, u8 *mask)
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index df42e4b..a65eee2 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1818,6 +1818,42 @@ struct wmi_set_ip_cmd {
 	__le32 ips[MAX_IP_ADDRS];
 } __packed;
 
+enum ath6kl_wow_filters {
+	WOW_FILTER_SSID			= BIT(0),
+	WOW_FILTER_OPTION_MAGIC_PACKET  = BIT(2),
+	WOW_FILTER_OPTION_EAP_REQ	= BIT(3),
+	WOW_FILTER_OPTION_PATTERNS	= BIT(4),
+	WOW_FILTER_OPTION_OFFLOAD_ARP	= BIT(5),
+	WOW_FILTER_OPTION_OFFLOAD_NS	= BIT(6),
+	WOW_FILTER_OPTION_OFFLOAD_GTK	= BIT(7),
+	WOW_FILTER_OPTION_8021X_4WAYHS	= BIT(8),
+	WOW_FILTER_OPTION_NLO_DISCVRY	= BIT(9),
+	WOW_FILTER_OPTION_NWK_DISASSOC	= BIT(10),
+	WOW_FILTER_OPTION_GTK_ERROR	= BIT(11),
+	WOW_FILTER_OPTION_TEST_MODE	= BIT(15),
+};
+
+enum ath6kl_host_mode {
+	ATH6KL_HOST_MODE_AWAKE,
+	ATH6KL_HOST_MODE_ASLEEP,
+};
+
+struct wmi_set_host_sleep_mode_cmd {
+	__le32 awake;
+	__le32 asleep;
+} __packed;
+
+enum ath6kl_wow_mode {
+	ATH6KL_WOW_MODE_DISABLE,
+	ATH6KL_WOW_MODE_ENABLE,
+};
+
+struct wmi_set_wow_mode_cmd {
+	__le32 enable_wow;
+	__le32 filter;
+	__le16 host_req_delay;
+} __packed;
+
 struct wmi_add_wow_pattern_cmd {
 	u8 filter_list_id;
 	u8 filter_size;
@@ -2285,6 +2321,11 @@ int ath6kl_wmi_test_cmd(struct wmi *wmi, void *buf, size_t len);
 s32 ath6kl_wmi_get_rate(s8 rate_index);
 
 int ath6kl_wmi_set_ip_cmd(struct wmi *wmi, struct wmi_set_ip_cmd *ip_cmd);
+int ath6kl_wmi_set_host_sleep_mode_cmd(struct wmi *wmi, u8 if_idx,
+				       enum ath6kl_host_mode host_mode);
+int ath6kl_wmi_set_wow_mode_cmd(struct wmi *wmi, u8 if_idx,
+				enum ath6kl_wow_mode wow_mode,
+				u32 filter, u16 host_req_delay);
 int ath6kl_wmi_add_wow_pattern_cmd(struct wmi *wmi, u8 if_idx,
 				   u8 list_id, u8 filter_size,
 				   u8 filter_offset, u8 *filter, u8 *mask);
-- 
1.7.1

