Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44415 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbcFWQin (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2016 12:38:43 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
	"Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>,
	Tamizh chelvam <c_traja@qti.qualcomm.com>
Subject: [PATCH 2/2] ath10k: Fix sending NULL/ Qos NULL data frames for QCA99X0 and later
Date: Thu, 23 Jun 2016 22:10:01 +0530
Message-ID: <1466700001-4883-2-git-send-email-mohammed@qca.qualcomm.com> (sfid-20160623_183847_161753_26817A82)
In-Reply-To: <1466700001-4883-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1466700001-4883-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

For chipsets like QCA99X0, IPQ4019 and later we are not getting proper
NULL func status (always acked/successs !!) when hostapd does a
PROBE_CLIENT via nullfunc frames when the station is powered off
abruptly (inactive timer probes client via null func after the inactive
time reaches beyond the threshold). Fix this by disabling the workaround
(getting the ACK status of NULL func frames by sending via HTT mgmt-tx
 path) introduced by the change ("ath10k: fix beacon loss handling ")
for QCA99X0 and later chipsets. The normal tx path provides the proper
ACK status for NULL data frames. As of now disable this workaround for
chipsets QCA99X0 and later, once the 10.1 firmware is obselete we can
completely get rid of this workaround for all the chipsets

Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 3 +++
 drivers/net/wireless/ath/ath10k/core.h | 6 ++++++
 drivers/net/wireless/ath/ath10k/mac.c  | 1 +
 3 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 689d6ce..9978e4a 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -181,6 +181,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 			.board = QCA99X0_HW_2_0_BOARD_DATA_FILE,
 			.board_size = QCA99X0_BOARD_DATA_SZ,
 			.board_ext_size = QCA99X0_BOARD_EXT_DATA_SZ,
+			.disable_null_func_workaround = true,
 		},
 	},
 	{
@@ -204,6 +205,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 			.board = QCA9984_HW_1_0_BOARD_DATA_FILE,
 			.board_size = QCA99X0_BOARD_DATA_SZ,
 			.board_ext_size = QCA99X0_BOARD_EXT_DATA_SZ,
+			.disable_null_func_workaround = true,
 		},
 	},
 	{
@@ -262,6 +264,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 			.board = QCA4019_HW_1_0_BOARD_DATA_FILE,
 			.board_size = QCA4019_BOARD_DATA_SZ,
 			.board_ext_size = QCA4019_BOARD_EXT_DATA_SZ,
+			.disable_null_func_workaround = true,
 		},
 	},
 };
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 3da18c9..e8c728c 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -750,6 +750,12 @@ struct ath10k {
 			const char *board;
 			size_t board_size;
 			size_t board_ext_size;
+			/* Workaround of sending NULL data frames via
+			 * HTT mgmt TX and getting the proper ACK status does
+			 * not works for chipsets QCA99X0 and later, while
+			 * Tx data path reports the ACK status properly.
+			 */
+			bool disable_null_func_workaround;
 		} fw;
 	} hw_params;
 
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index d4b7a16..f1e9672 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3236,6 +3236,7 @@ ath10k_mac_tx_h_get_txmode(struct ath10k *ar,
 	 * mode though because AP don't sleep.
 	 */
 	if (ar->htt.target_version_major < 3 &&
+	    !ar->hw_params.fw.disable_null_func_workaround &&
 	    (ieee80211_is_nullfunc(fc) || ieee80211_is_qos_nullfunc(fc)) &&
 	    !test_bit(ATH10K_FW_FEATURE_HAS_WMI_MGMT_TX,
 		      ar->running_fw->fw_file.fw_features))
-- 
1.9.1

