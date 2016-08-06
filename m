Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17060 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbcHFVSQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Aug 2016 17:18:16 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
	"Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>
Subject: [PATCH] ath10k: fix group privacy action frame decryption for qca4019
Date: Sat, 6 Aug 2016 09:49:36 +0530
Message-ID: <20160806041936.26924-1-rmanohar@qti.qualcomm.com> (sfid-20160806_231820_713853_A0688692)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recent commit 'mac80211: Encrypt "Group addressed privacy" action frames'
encrypts group privacy action frames. But qca99x0 family chipset delivers
broadcast/multicast management frames as encrypted and it should be
decrypted by mac80211. Setting RX_FLAG_DECRYPTED stats for those frames
is breaking mesh connection establishment.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |  4 ++++
 drivers/net/wireless/ath/ath10k/core.h |  5 +++++
 drivers/net/wireless/ath/ath10k/wmi.c  | 30 +++++++++++++++++++++++++-----
 3 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 0ca58cf0ffea..c4d1a5ba216e 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -182,6 +182,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 			.board_size = QCA99X0_BOARD_DATA_SZ,
 			.board_ext_size = QCA99X0_BOARD_EXT_DATA_SZ,
 		},
+		.sw_decrypt_mcast_mgmt = true,
 	},
 	{
 		.id = QCA9984_HW_1_0_DEV_VERSION,
@@ -205,6 +206,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 			.board_size = QCA99X0_BOARD_DATA_SZ,
 			.board_ext_size = QCA99X0_BOARD_EXT_DATA_SZ,
 		},
+		.sw_decrypt_mcast_mgmt = true,
 	},
 	{
 		.id = QCA9888_HW_2_0_DEV_VERSION,
@@ -227,6 +229,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 			.board_size = QCA99X0_BOARD_DATA_SZ,
 			.board_ext_size = QCA99X0_BOARD_EXT_DATA_SZ,
 		},
+		.sw_decrypt_mcast_mgmt = true,
 	},
 	{
 		.id = QCA9377_HW_1_0_DEV_VERSION,
@@ -285,6 +288,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 			.board_size = QCA4019_BOARD_DATA_SZ,
 			.board_ext_size = QCA4019_BOARD_EXT_DATA_SZ,
 		},
+		.sw_decrypt_mcast_mgmt = true,
 	},
 };
 
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index f36c2b274ee5..7254bd3e7c82 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -765,6 +765,11 @@ struct ath10k {
 			size_t board_size;
 			size_t board_ext_size;
 		} fw;
+
+		/* qca99x0 family chips deliver broadcast/multicast management
+		 * frames encrypted and expect software do decryption.
+		 */
+		bool sw_decrypt_mcast_mgmt;
 	} hw_params;
 
 	/* contains the firmware images used with ATH10K_FIRMWARE_MODE_NORMAL */
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 169cd2e783eb..bced8ac7ed94 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2240,6 +2240,30 @@ static int ath10k_wmi_10_4_op_pull_mgmt_rx_ev(struct ath10k *ar,
 	return 0;
 }
 
+static bool ath10k_wmi_rx_is_decrypted(struct ath10k *ar,
+				       struct ieee80211_hdr *hdr)
+{
+	if (!ieee80211_has_protected(hdr->frame_control))
+		return false;
+
+	/* FW delivers WEP Shared Auth frame with Protected Bit set and
+	 * encrypted payload. However in case of PMF it delivers decrypted
+	 * frames with Protected Bit set.
+	 */
+	if (ieee80211_is_auth(hdr->frame_control))
+		return false;
+
+	/* qca99x0 based FW delivers broadcast or multicast management frames
+	 * (ex: group privacy action frames in mesh) as encrypted payload.
+	 */
+	if ((is_broadcast_ether_addr(ieee80211_get_DA(hdr)) ||
+	     is_multicast_ether_addr(ieee80211_get_DA(hdr))) &&
+	    ar->hw_params.sw_decrypt_mcast_mgmt)
+		return false;
+
+	return true;
+}
+
 int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_mgmt_rx_ev_arg arg = {};
@@ -2326,11 +2350,7 @@ int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 
 	ath10k_wmi_handle_wep_reauth(ar, skb, status);
 
-	/* FW delivers WEP Shared Auth frame with Protected Bit set and
-	 * encrypted payload. However in case of PMF it delivers decrypted
-	 * frames with Protected Bit set. */
-	if (ieee80211_has_protected(hdr->frame_control) &&
-	    !ieee80211_is_auth(hdr->frame_control)) {
+	if (ath10k_wmi_rx_is_decrypted(ar, hdr)) {
 		status->flag |= RX_FLAG_DECRYPTED;
 
 		if (!ieee80211_is_action(hdr->frame_control) &&
-- 
2.9.2

