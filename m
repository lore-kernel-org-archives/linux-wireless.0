Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53314 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab1JYKiF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 06:38:05 -0400
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH 2/7] ath6kl: Add wmi functions to configure wow mode and host sleep mode
Date: Tue, 25 Oct 2011 16:07:22 +0530
Message-ID: <1319539047-8756-3-git-send-email-rmani@qca.qualcomm.com> (sfid-20111025_123809_545081_E6AD8304)
In-Reply-To: <1319539047-8756-1-git-send-email-rmani@qca.qualcomm.com>
References: <1319539047-8756-1-git-send-email-rmani@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c |   88 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h |   30 +++++++++++
 2 files changed, 118 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index f38b30e..fceb801 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2356,6 +2356,94 @@ int ath6kl_wmi_set_ip_cmd(struct wmi *wmi, struct wmi_set_ip_cmd *ip_cmd)
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
+	spin_lock_bh(&wmi->lock);
+	wmi->fat_pipe_exist = stream_exist;
+	spin_unlock_bh(&wmi->lock);
+}
+
+int ath6kl_wmi_set_host_sleep_mode_cmd(struct wmi *wmi,
+				  struct wmi_set_host_sleep_mode_cmd *host_mode)
+{
+	struct sk_buff *skb;
+	struct wmi_set_host_sleep_mode_cmd *cmd;
+	int ret;
+
+	if (host_mode->awake == host_mode->asleep)
+		return -EINVAL;
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*cmd));
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct wmi_set_host_sleep_mode_cmd *) skb->data;
+	memcpy(cmd, host_mode, sizeof(*cmd));
+
+	if (host_mode->asleep)
+		ath6kl_wmi_relinquish_implicit_pstream_credits(wmi);
+
+	ret = ath6kl_wmi_cmd_send(wmi, skb, WMI_SET_HOST_SLEEP_MODE_CMDID,
+				  NO_SYNC_WMIFLAG);
+	return ret;
+}
+
+int ath6kl_wmi_set_wow_mode_cmd(struct wmi *wmi,
+				struct wmi_set_wow_mode_cmd *wow_mode)
+{
+	struct sk_buff *skb;
+	struct wmi_set_wow_mode_cmd *cmd;
+	int ret;
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*cmd));
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct wmi_set_wow_mode_cmd *) skb->data;
+	memcpy(cmd, wow_mode, sizeof(*cmd));
+
+	ret = ath6kl_wmi_cmd_send(wmi, skb, WMI_SET_WOW_MODE_CMDID,
+				  NO_SYNC_WMIFLAG);
+	return ret;
+}
+
 int ath6kl_wmi_add_wow_pattern_cmd(struct wmi *wmi,
 				   struct wmi_add_wow_pattern_cmd *add_wow_cmd,
 				   u8 *pattern, u8 *mask)
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 3a54933..2ca3a18 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1796,6 +1796,32 @@ struct wmi_set_ip_cmd {
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
+struct wmi_set_host_sleep_mode_cmd {
+	__le32 awake;
+	__le32 asleep;
+} __packed;
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
@@ -2255,6 +2281,10 @@ int ath6kl_wmi_test_cmd(struct wmi *wmi, void *buf, size_t len);
 s32 ath6kl_wmi_get_rate(s8 rate_index);
 
 int ath6kl_wmi_set_ip_cmd(struct wmi *wmi, struct wmi_set_ip_cmd *ip_cmd);
+int ath6kl_wmi_set_host_sleep_mode_cmd(struct wmi *wmi,
+				struct wmi_set_host_sleep_mode_cmd *host_mode);
+int ath6kl_wmi_set_wow_mode_cmd(struct wmi *wmi,
+				struct wmi_set_wow_mode_cmd *wow_mode);
 int ath6kl_wmi_add_wow_pattern_cmd(struct wmi *wmi,
 				   struct wmi_add_wow_pattern_cmd *add_wow_cmd,
 				   u8 *pattern, u8 *mask);
-- 
1.7.0.4

