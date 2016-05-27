Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23030 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbcE0OrN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2016 10:47:13 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
	"Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>
Subject: [PATCH 5/5] ath10k: add pdev param support to enable/disable btcoex
Date: Fri, 27 May 2016 20:15:59 +0530
Message-ID: <20160527144559.4053-5-rmanohar@qti.qualcomm.com> (sfid-20160527_164719_292945_23DA2F3B)
In-Reply-To: <20160527144559.4053-1-rmanohar@qti.qualcomm.com>
References: <20160527144559.4053-1-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

10.4 firmware has support to enable or disable btcoex functionality
without reloading firmware via wmi pdev param. Add provision to send
pdev param command via existing btcoex knob.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c  | 10 ++++++++++
 drivers/net/wireless/ath/ath10k/debug.c | 18 +++++++++++++++---
 drivers/net/wireless/ath/ath10k/mac.c   | 13 +++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c   |  4 ++++
 drivers/net/wireless/ath/ath10k/wmi.h   |  4 ++++
 5 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 88b51225a52a..cedf127df168 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1756,6 +1756,16 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
 		if (test_bit(WMI_SERVICE_BSS_CHANNEL_INFO_64, ar->wmi.svc_map))
 			val |= WMI_10_4_BSS_CHANNEL_INFO_64;
 
+		/* 10.4 firmware supports BT-Coex without reloading firmware
+		 * via pdev param. To support Bluetooth coexistence pdev param,
+		 * WMI_COEX_GPIO_SUPPORT of extended resource config should be
+		 * enabled always.
+		 */
+		if (test_bit(WMI_SERVICE_COEX_GPIO, ar->wmi.svc_map) &&
+		    test_bit(ATH10K_FW_FEATURE_BTCOEX_PARAM,
+			     ar->running_fw->fw_file.fw_features))
+			val |= WMI_10_4_COEX_GPIO_SUPPORT;
+
 		status = ath10k_mac_ext_resource_config(ar, val);
 		if (status) {
 			ath10k_err(ar,
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index e2511550fbb8..775547fde956 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -2127,6 +2127,7 @@ static ssize_t ath10k_write_btcoex(struct file *file,
 	size_t buf_size;
 	int ret;
 	bool val;
+	u32 pdev_param;
 
 	buf_size = min(count, (sizeof(buf) - 1));
 	if (copy_from_user(buf, ubuf, buf_size))
@@ -2150,14 +2151,25 @@ static ssize_t ath10k_write_btcoex(struct file *file,
 		goto exit;
 	}
 
+	pdev_param = ar->wmi.pdev_param->enable_btcoex;
+	if (test_bit(ATH10K_FW_FEATURE_BTCOEX_PARAM,
+		     ar->running_fw->fw_file.fw_features)) {
+		ret = ath10k_wmi_pdev_set_param(ar, pdev_param, val);
+		if (ret) {
+			ath10k_warn(ar, "failed to enable btcoex: %d\n", ret);
+			ret = count;
+			goto exit;
+		}
+	} else {
+		ath10k_info(ar, "restarting firmware due to btcoex change");
+		queue_work(ar->workqueue, &ar->restart_work);
+	}
+
 	if (val)
 		set_bit(ATH10K_FLAG_BTCOEX, &ar->dev_flags);
 	else
 		clear_bit(ATH10K_FLAG_BTCOEX, &ar->dev_flags);
 
-	ath10k_info(ar, "restarting firmware due to btcoex change");
-
-	queue_work(ar->workqueue, &ar->restart_work);
 	ret = count;
 
 exit:
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 6829a08638b2..19eb77859eb4 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4468,6 +4468,19 @@ static int ath10k_start(struct ieee80211_hw *hw)
 		}
 	}
 
+	param = ar->wmi.pdev_param->enable_btcoex;
+	if (test_bit(WMI_SERVICE_COEX_GPIO, ar->wmi.svc_map) &&
+	    test_bit(ATH10K_FW_FEATURE_BTCOEX_PARAM,
+		     ar->running_fw->fw_file.fw_features)) {
+		ret = ath10k_wmi_pdev_set_param(ar, param, 0);
+		if (ret) {
+			ath10k_warn(ar,
+				    "failed to set btcoex param: %d\n", ret);
+			goto err_core_stop;
+		}
+		clear_bit(ATH10K_FLAG_BTCOEX, &ar->dev_flags);
+	}
+
 	ar->num_started_vdevs = 0;
 	ath10k_regd_update(ar);
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 2c300329ebc3..6279ab4a760e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1104,6 +1104,7 @@ static struct wmi_pdev_param_map wmi_pdev_param_map = {
 	.wapi_mbssid_offset = WMI_PDEV_PARAM_UNSUPPORTED,
 	.arp_srcaddr = WMI_PDEV_PARAM_UNSUPPORTED,
 	.arp_dstaddr = WMI_PDEV_PARAM_UNSUPPORTED,
+	.enable_btcoex = WMI_PDEV_PARAM_UNSUPPORTED,
 };
 
 static struct wmi_pdev_param_map wmi_10x_pdev_param_map = {
@@ -1199,6 +1200,7 @@ static struct wmi_pdev_param_map wmi_10x_pdev_param_map = {
 	.wapi_mbssid_offset = WMI_PDEV_PARAM_UNSUPPORTED,
 	.arp_srcaddr = WMI_PDEV_PARAM_UNSUPPORTED,
 	.arp_dstaddr = WMI_PDEV_PARAM_UNSUPPORTED,
+	.enable_btcoex = WMI_PDEV_PARAM_UNSUPPORTED,
 };
 
 static struct wmi_pdev_param_map wmi_10_2_4_pdev_param_map = {
@@ -1294,6 +1296,7 @@ static struct wmi_pdev_param_map wmi_10_2_4_pdev_param_map = {
 	.wapi_mbssid_offset = WMI_PDEV_PARAM_UNSUPPORTED,
 	.arp_srcaddr = WMI_PDEV_PARAM_UNSUPPORTED,
 	.arp_dstaddr = WMI_PDEV_PARAM_UNSUPPORTED,
+	.enable_btcoex = WMI_PDEV_PARAM_UNSUPPORTED,
 };
 
 /* firmware 10.2 specific mappings */
@@ -1550,6 +1553,7 @@ static struct wmi_pdev_param_map wmi_10_4_pdev_param_map = {
 	.wapi_mbssid_offset = WMI_10_4_PDEV_PARAM_WAPI_MBSSID_OFFSET,
 	.arp_srcaddr = WMI_10_4_PDEV_PARAM_ARP_SRCADDR,
 	.arp_dstaddr = WMI_10_4_PDEV_PARAM_ARP_DSTADDR,
+	.enable_btcoex = WMI_10_4_PDEV_PARAM_ENABLE_BTCOEX,
 };
 
 static const struct wmi_peer_flags_map wmi_peer_flags_map = {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 9fdf47ea27d0..90f594e89f94 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -3447,6 +3447,7 @@ struct wmi_pdev_param_map {
 	u32 wapi_mbssid_offset;
 	u32 arp_srcaddr;
 	u32 arp_dstaddr;
+	u32 enable_btcoex;
 };
 
 #define WMI_PDEV_PARAM_UNSUPPORTED 0
@@ -3760,6 +3761,9 @@ enum wmi_10_4_pdev_param {
 	WMI_10_4_PDEV_PARAM_ATF_OBSS_NOISE_SCH,
 	WMI_10_4_PDEV_PARAM_ATF_OBSS_NOISE_SCALING_FACTOR,
 	WMI_10_4_PDEV_PARAM_CUST_TXPOWER_SCALE,
+	WMI_10_4_PDEV_PARAM_ATF_DYNAMIC_ENABLE,
+	WMI_10_4_PDEV_PARAM_ATF_SSID_GROUP_POLICY,
+	WMI_10_4_PDEV_PARAM_ENABLE_BTCOEX,
 };
 
 struct wmi_pdev_set_param_cmd {
-- 
2.8.3

