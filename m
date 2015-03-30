Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33453 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbbC3SO5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 14:14:57 -0400
From: Yanbo Li <yanbol@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <dreamfly281@gmail.com>, <michal.kazior@tieto.com>,
	<ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] ath10k: Enable the BT-coex feature
Date: Mon, 30 Mar 2015 11:14:06 -0700
Message-ID: <1427739246-2734-2-git-send-email-yanbol@qca.qualcomm.com> (sfid-20150330_201503_571843_8EA330FC)
In-Reply-To: <1427739246-2734-1-git-send-email-yanbol@qca.qualcomm.com>
References: <1427739246-2734-1-git-send-email-yanbol@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The new 10.2.4 FW support the BT-coex feature with external BT module,
The external BT modules can communicate with it via the GPIO. This patch
check the BT-coex capability of the FW and enable it by default.

Signed-off-by: Yanbo Li <yanbol@qca.qualcomm.com>

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 54430a1a3f73..bff55188af9b 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3960,6 +3960,8 @@ static struct sk_buff *ath10k_wmi_10_2_op_gen_init(struct ath10k *ar)
 	cmd = (struct wmi_init_cmd_10_2 *)buf->data;
 
 	features = WMI_10_2_RX_BATCH_MODE;
+	if (test_bit(WMI_SERVICE_COEX_GPIO, ar->wmi.svc_map))
+		features |= WMI_10_2_COEX_GPIO;
 	cmd->resource_config.feature_mask = __cpu_to_le32(features);
 
 	memcpy(&cmd->resource_config.common, &config, sizeof(config));
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index a8f39d69eee2..b570dd391efa 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -149,6 +149,7 @@ enum wmi_service {
 	WMI_SERVICE_MDNS_OFFLOAD,
 	WMI_SERVICE_SAP_AUTH_OFFLOAD,
 	WMI_SERVICE_ATF,
+	WMI_SERVICE_COEX_GPIO,
 
 	/* keep last */
 	WMI_SERVICE_MAX,
@@ -179,6 +180,7 @@ enum wmi_10x_service {
 	WMI_10X_SERVICE_FORCE_FW_HANG,
 	WMI_10X_SERVICE_SMART_ANTENNA_HW_SUPPORT,
 	WMI_10X_SERVICE_ATF,
+	WMI_10X_SERVICE_COEX_GPIO,
 };
 
 enum wmi_main_service {
@@ -296,6 +298,7 @@ static inline char *wmi_service_name(int service_id)
 	SVCSTR(WMI_SERVICE_MDNS_OFFLOAD);
 	SVCSTR(WMI_SERVICE_SAP_AUTH_OFFLOAD);
 	SVCSTR(WMI_SERVICE_ATF);
+	SVCSTR(WMI_SERVICE_COEX_GPIO);
 	default:
 		return NULL;
 	}
@@ -361,6 +364,8 @@ static inline void wmi_10x_svc_map(const __le32 *in, unsigned long *out,
 	       WMI_SERVICE_SMART_ANTENNA_HW_SUPPORT, len);
 	SVCMAP(WMI_10X_SERVICE_ATF,
 	       WMI_SERVICE_ATF, len);
+	SVCMAP(WMI_10X_SERVICE_COEX_GPIO,
+	       WMI_SERVICE_COEX_GPIO, len);
 }
 
 static inline void wmi_main_svc_map(const __le32 *in, unsigned long *out,
@@ -1957,6 +1962,7 @@ struct wmi_resource_config_10x {
 enum wmi_10_2_feature_mask {
 	WMI_10_2_RX_BATCH_MODE = BIT(0),
 	WMI_10_2_ATF_CONFIG    = BIT(1),
+	WMI_10_2_COEX_GPIO     = BIT(3),
 };
 
 struct wmi_resource_config_10_2 {
-- 
1.9.1

