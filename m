Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37756 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928Ab1JYKiU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 06:38:20 -0400
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH 4/7] ath6kl: Add new functions to handle wow suspend/resume operations
Date: Tue, 25 Oct 2011 16:07:24 +0530
Message-ID: <1319539047-8756-5-git-send-email-rmani@qca.qualcomm.com> (sfid-20111025_123822_650184_AC493316)
In-Reply-To: <1319539047-8756-1-git-send-email-rmani@qca.qualcomm.com>
References: <1319539047-8756-1-git-send-email-rmani@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |  121 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/core.h     |    3 +
 2 files changed, 124 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 0680d2b..aaf8d0f 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1481,6 +1481,127 @@ static int ath6kl_flush_pmksa(struct wiphy *wiphy, struct net_device *netdev)
 }
 
 #ifdef CONFIG_PM
+
+int ath6kl_pm_wow_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
+{
+	struct wmi_set_wow_mode_cmd wakeup_filter_cmd;
+	struct wmi_add_wow_pattern_cmd add_pattern_cmd;
+	struct wmi_del_wow_pattern_cmd del_pattern_cmd;
+	struct wmi_set_host_sleep_mode_cmd hsleep_cmd;
+	int i, ret, pos, left;
+	u8 mask[WOW_PATTERN_SIZE];
+
+	if (WARN_ON(!wow))
+		return -EINVAL;
+
+	if (ar->wow_state != ATH6KL_WOW_STATE_NONE)
+		return -EINVAL;
+
+	ar->wow_state = ATH6KL_WOW_STATE_SUSPENDING;
+
+	/* Clear existing WOW patterns */
+	for (i = 0; i < WOW_MAX_FILTERS_PER_LIST; i++) {
+		del_pattern_cmd.filter_list_id = cpu_to_le16(WOW_LIST_ID);
+		del_pattern_cmd.filter_id = cpu_to_le16(i);
+		ath6kl_wmi_del_wow_pattern_cmd(ar->wmi, &del_pattern_cmd);
+	}
+
+	/* Configure new WOW patterns */
+	memset(&wakeup_filter_cmd, 0, sizeof(wakeup_filter_cmd));
+	wakeup_filter_cmd.enable_wow = cpu_to_le32(0x1);
+	wakeup_filter_cmd.host_req_delay = cpu_to_le32(WOW_HOST_REQ_DELAY);
+
+	if (wow->disconnect)
+		wakeup_filter_cmd.filter |=
+			cpu_to_le32(WOW_FILTER_OPTION_NWK_DISASSOC);
+
+	if (wow->magic_pkt)
+		wakeup_filter_cmd.filter |=
+			cpu_to_le32(WOW_FILTER_OPTION_MAGIC_PACKET);
+
+	if (wow->gtk_rekey_failure)
+		wakeup_filter_cmd.filter |=
+			cpu_to_le32(WOW_FILTER_OPTION_GTK_ERROR);
+
+	if (wow->eap_identity_req)
+		wakeup_filter_cmd.filter |=
+			cpu_to_le32(WOW_FILTER_OPTION_EAP_REQ);
+
+	if (wow->four_way_handshake)
+		wakeup_filter_cmd.filter |=
+			cpu_to_le32(WOW_FILTER_OPTION_8021X_4WAYHS);
+
+	for (i = 0; i < wow->n_patterns; i++) {
+		memset(&add_pattern_cmd, 0, sizeof(add_pattern_cmd));
+		add_pattern_cmd.filter_list_id = WOW_LIST_ID;
+		add_pattern_cmd.filter_offset = 0;
+		add_pattern_cmd.filter_size = wow->patterns[i].pattern_len;
+
+		memset(&mask, 0, sizeof(mask));
+		for (pos = 0; pos < wow->patterns[i].pattern_len;
+				pos++) {
+			if (wow->patterns[i].mask[pos / 8] & (0x1 << (pos % 8)))
+				mask[pos] = 0xFF;
+		}
+
+		ret = ath6kl_wmi_add_wow_pattern_cmd(ar->wmi,
+				&add_pattern_cmd,
+				wow->patterns[i].pattern, mask);
+		if (ret)
+			return ret;
+	}
+
+	if (wakeup_filter_cmd.filter || wow->n_patterns) {
+		ret = ath6kl_wmi_set_wow_mode_cmd(ar->wmi, &wakeup_filter_cmd);
+		if (ret)
+			goto wow_setup_failed;
+	}
+
+	hsleep_cmd.awake  = cpu_to_le32(0);
+	hsleep_cmd.asleep = cpu_to_le32(1);
+	ret = ath6kl_wmi_set_host_sleep_mode_cmd(ar->wmi, &hsleep_cmd);
+	if (ret)
+		goto wow_setup_failed;
+
+	if (ar->tx_pending[ar->ctrl_ep]) {
+		left = wait_event_interruptible_timeout(ar->event_wq,
+				ar->tx_pending[ar->ctrl_ep] == 0, WMI_TIMEOUT);
+		if (left == 0) {
+			ret = -ETIMEDOUT;
+			goto wow_setup_failed;
+		} else if (left < 0) {
+			ret = left;
+			goto wow_setup_failed;
+		}
+	}
+
+	ar->wow_state = ATH6KL_WOW_STATE_SUSPENDED;
+	return 0;
+
+wow_setup_failed:
+	ar->wow_state = ATH6KL_WOW_STATE_NONE;
+	return ret;
+}
+
+int ath6kl_pm_wow_resume(struct ath6kl *ar)
+{
+	struct wmi_set_host_sleep_mode_cmd hsleep_cmd;
+	int ret;
+
+	if (ar->wow_state == ATH6KL_WOW_STATE_NONE)
+		return -EINVAL;
+
+	hsleep_cmd.awake  = cpu_to_le32(1);
+	hsleep_cmd.asleep = cpu_to_le32(0);
+	ret = ath6kl_wmi_set_host_sleep_mode_cmd(ar->wmi, &hsleep_cmd);
+	if (ret)
+		return ret;
+
+	ar->wow_state = ATH6KL_WOW_STATE_NONE;
+
+	return 0;
+}
+
 static int ar6k_cfg80211_suspend(struct wiphy *wiphy,
 				 struct cfg80211_wowlan *wow)
 {
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 706443c..cefb233 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -386,6 +386,9 @@ enum ath6kl_wow_state {
 	ATH6KL_WOW_STATE_SUSPENDED
 };
 
+#define WOW_LIST_ID		0
+#define WOW_HOST_REQ_DELAY	500 /* 500 ms */
+
 /* Flag info */
 #define WMI_ENABLED	0
 #define WMI_READY	1
-- 
1.7.0.4

