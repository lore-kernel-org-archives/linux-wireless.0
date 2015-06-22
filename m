Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:56854 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbbFVOlD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 10:41:03 -0400
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH v2 01/10] ath10k: include new wmi op version for 10.4 fw
Date: Mon, 22 Jun 2015 20:10:09 +0530
Message-ID: <1434984018-24057-2-git-send-email-rmani@qti.qualcomm.com> (sfid-20150622_164107_202113_605A9115)
In-Reply-To: <1434984018-24057-1-git-send-email-rmani@qti.qualcomm.com>
References: <1434984018-24057-1-git-send-email-rmani@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

qca99X0 chip uses firmware version 10.4. Define a new macro
ATH10K_FW_WMI_OP_VERSION_10_4 for 10.4 firmware and include
in switch cases where ATH10K_FW_WMI_OP_VERSION_* is used
to avoid compilation error.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 2 ++
 drivers/net/wireless/ath/ath10k/hw.h   | 1 +
 drivers/net/wireless/ath/ath10k/mac.c  | 2 ++
 drivers/net/wireless/ath/ath10k/wmi.c  | 2 ++
 4 files changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 80f38b5..5e8d8af 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1115,6 +1115,7 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 		ar->fw_stats_req_mask = WMI_STAT_PDEV | WMI_STAT_VDEV |
 			WMI_STAT_PEER;
 		break;
+	case ATH10K_FW_WMI_OP_VERSION_10_4:
 	case ATH10K_FW_WMI_OP_VERSION_UNSET:
 	case ATH10K_FW_WMI_OP_VERSION_MAX:
 		WARN_ON(1);
@@ -1137,6 +1138,7 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 		case ATH10K_FW_WMI_OP_VERSION_TLV:
 			ar->htt.op_version = ATH10K_FW_HTT_OP_VERSION_TLV;
 			break;
+		case ATH10K_FW_WMI_OP_VERSION_10_4:
 		case ATH10K_FW_WMI_OP_VERSION_UNSET:
 		case ATH10K_FW_WMI_OP_VERSION_MAX:
 			WARN_ON(1);
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 3e27781..b0c89b4 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -137,6 +137,7 @@ enum ath10k_fw_wmi_op_version {
 	ATH10K_FW_WMI_OP_VERSION_10_2 = 3,
 	ATH10K_FW_WMI_OP_VERSION_TLV = 4,
 	ATH10K_FW_WMI_OP_VERSION_10_2_4 = 5,
+	ATH10K_FW_WMI_OP_VERSION_10_4 = 6,
 
 	/* keep last */
 	ATH10K_FW_WMI_OP_VERSION_MAX,
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 2ec2b0b..f9989d1 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6943,6 +6943,8 @@ int ath10k_mac_register(struct ath10k *ar)
 		ar->hw->wiphy->n_iface_combinations =
 			ARRAY_SIZE(ath10k_10x_if_comb);
 		break;
+	case ATH10K_FW_WMI_OP_VERSION_10_4:
+		break;
 	case ATH10K_FW_WMI_OP_VERSION_UNSET:
 	case ATH10K_FW_WMI_OP_VERSION_MAX:
 		WARN_ON(1);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 6c046c2..b32bb68 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -5415,6 +5415,8 @@ static const struct wmi_ops wmi_10_2_4_ops = {
 int ath10k_wmi_attach(struct ath10k *ar)
 {
 	switch (ar->wmi.op_version) {
+	case ATH10K_FW_WMI_OP_VERSION_10_4:
+		break;
 	case ATH10K_FW_WMI_OP_VERSION_10_2_4:
 		ar->wmi.cmd = &wmi_10_2_4_cmd_map;
 		ar->wmi.ops = &wmi_10_2_4_ops;
-- 
1.8.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
