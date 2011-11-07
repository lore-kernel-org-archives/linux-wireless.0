Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34598 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab1KGF3o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 00:29:44 -0500
From: Raja Mani <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH v2 03/11] ath6kl: Add WOW suspend/resume implementation
Date: Mon, 7 Nov 2011 10:55:39 +0530
Message-ID: <1320643547-3578-4-git-send-email-rmani@qca.qualcomm.com> (sfid-20111107_062958_574201_4F26377C)
In-Reply-To: <1320643547-3578-1-git-send-email-rmani@qca.qualcomm.com>
References: <1320643547-3578-1-git-send-email-rmani@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the core WOW suspend/resume functions will be called
in PM suspend/resume path.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |  109 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/core.h     |    3 +
 2 files changed, 112 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 04d24d4..68cfb81 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1644,6 +1644,115 @@ static int ath6kl_flush_pmksa(struct wiphy *wiphy, struct net_device *netdev)
 	return 0;
 }
 
+static int ath6kl_wow_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
+{
+	struct ath6kl_vif *vif;
+	int ret, pos, left;
+	u32 filter = 0;
+	u16 i;
+	u8 mask[WOW_MASK_SIZE];
+
+	vif = ath6kl_vif_first(ar);
+	if (!vif)
+		return -EIO;
+
+	if (!ath6kl_cfg80211_ready(vif))
+		return -EIO;
+
+	if (!test_bit(CONNECTED, &vif->flags))
+		return -EINVAL;
+
+	/* Clear existing WOW patterns */
+	for (i = 0; i < WOW_MAX_FILTERS_PER_LIST; i++)
+		ath6kl_wmi_del_wow_pattern_cmd(ar->wmi, vif->fw_vif_idx,
+					       WOW_LIST_ID, i);
+	/* Configure new WOW patterns */
+	for (i = 0; i < wow->n_patterns; i++) {
+
+		/*
+		 * Convert given nl80211 specific mask value to equivalent
+		 * driver specific mask value and send it to the chip along
+		 * with patterns. For example, If the mask value defined in
+		 * struct cfg80211_wowlan is 0xA (equivalent binary is 1010),
+		 * then equivalent driver specific mask value is
+		 * "0xFF 0x00 0xFF 0x00".
+		 */
+		memset(&mask, 0, sizeof(mask));
+		for (pos = 0; pos < wow->patterns[i].pattern_len; pos++) {
+			if (wow->patterns[i].mask[pos / 8] & (0x1 << (pos % 8)))
+				mask[pos] = 0xFF;
+		}
+		/*
+		 * Note: Pattern's offset is not passed as part of wowlan
+		 * parameter from CFG layer. So it's always passed as ZERO
+		 * to the firmware. It means, given WOW patterns are always
+		 * matched from the first byte of received pkt in the firmware.
+		 */
+		ret = ath6kl_wmi_add_wow_pattern_cmd(ar->wmi,
+					vif->fw_vif_idx, WOW_LIST_ID,
+					wow->patterns[i].pattern_len,
+					0 /* pattern offset */,
+					wow->patterns[i].pattern, mask);
+		if (ret)
+			return ret;
+	}
+
+	if (wow->disconnect)
+		filter |= WOW_FILTER_OPTION_NWK_DISASSOC;
+
+	if (wow->magic_pkt)
+		filter |= WOW_FILTER_OPTION_MAGIC_PACKET;
+
+	if (wow->gtk_rekey_failure)
+		filter |= WOW_FILTER_OPTION_GTK_ERROR;
+
+	if (wow->eap_identity_req)
+		filter |= WOW_FILTER_OPTION_EAP_REQ;
+
+	if (wow->four_way_handshake)
+		filter |= WOW_FILTER_OPTION_8021X_4WAYHS;
+
+	ret = ath6kl_wmi_set_wow_mode_cmd(ar->wmi, vif->fw_vif_idx,
+					  ATH6KL_WOW_MODE_ENABLE,
+					  filter,
+					  WOW_HOST_REQ_DELAY);
+	if (ret)
+		return ret;
+
+	ret = ath6kl_wmi_set_host_sleep_mode_cmd(ar->wmi, vif->fw_vif_idx,
+						 ATH6KL_HOST_MODE_ASLEEP);
+	if (ret)
+		return ret;
+
+	if (ar->tx_pending[ar->ctrl_ep]) {
+		left = wait_event_interruptible_timeout(ar->event_wq,
+				ar->tx_pending[ar->ctrl_ep] == 0, WMI_TIMEOUT);
+		if (left == 0) {
+			ath6kl_warn("clear wmi ctrl data timeout\n");
+			ret = -ETIMEDOUT;
+		} else if (left < 0) {
+			ath6kl_warn("clear wmi ctrl data failed: %d\n", left);
+			ret = left;
+		}
+	}
+
+	return ret;
+}
+
+static int ath6kl_wow_resume(struct ath6kl *ar)
+{
+	struct ath6kl_vif *vif;
+	int ret;
+
+	vif = ath6kl_vif_first(ar);
+	if (!vif)
+		return -EIO;
+
+	ret = ath6kl_wmi_set_host_sleep_mode_cmd(ar->wmi, vif->fw_vif_idx,
+						 ATH6KL_HOST_MODE_AWAKE);
+	return ret;
+}
+
 int ath6kl_cfg80211_suspend(struct ath6kl *ar,
 			    enum ath6kl_cfg_suspend_mode mode)
 {
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index c30642e..b6442c1 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -439,6 +439,9 @@ struct ath6kl_vif {
 	struct target_stats target_stats;
 };
 
+#define WOW_LIST_ID		0
+#define WOW_HOST_REQ_DELAY	500 /* ms */
+
 /* Flag info */
 enum ath6kl_dev_state {
 	WMI_ENABLED,
-- 
1.7.1

