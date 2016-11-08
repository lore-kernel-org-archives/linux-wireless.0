Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:16435 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752158AbcKHPEA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Nov 2016 10:04:00 -0500
From: <c_traja@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <tamizhchelvam@codeaurora.org>,
        "Tamizh chelvam" <c_traja@qti.qualcomm.com>
Subject: [PATCH 4/4] ath10k: Add support to read btcoex related data from DT
Date: Tue, 8 Nov 2016 20:34:45 +0530
Message-ID: <1478617485-28223-1-git-send-email-c_traja@qti.qualcomm.com> (sfid-20161108_160403_405409_C9B5A5F4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tamizh chelvam <c_traja@qti.qualcomm.com>

BTCOEX feature is not supported by all qca40xx chipsets.
Since btcoex enabled by default in firmware, host needs to
enable COEX support depends on the hardware. This patch is
used to read btcoex_support flag and btcoex gpio pin
number from DT. Depends on the btcoex_support flag value
host will expose BTCOEX support and btcoex gpio pin
number to target.

Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c  |   44 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/core.h  |    9 +++++++
 drivers/net/wireless/ath/ath10k/debug.c |    3 +++
 drivers/net/wireless/ath/ath10k/mac.c   |    4 ++-
 drivers/net/wireless/ath/ath10k/wmi.c   |    1 +
 drivers/net/wireless/ath/ath10k/wmi.h   |    2 ++
 6 files changed, 61 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 7005e2a..eec2436 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1439,6 +1439,39 @@ static int ath10k_download_cal_data(struct ath10k *ar)
 	return 0;
 }
 
+static void ath10k_core_fetch_btcoex_dt(struct ath10k *ar)
+{
+	struct device_node *node;
+	u32 btcoex_support = 0;
+	int ret;
+
+	node = ar->dev->of_node;
+	if (!node)
+		goto out;
+
+	ret = of_property_read_u32(node, "btcoex_support", &btcoex_support);
+	if (ret) {
+		ar->btcoex_support = ATH10K_DT_BTCOEX_NOT_FOUND;
+		goto out;
+	}
+
+	if (btcoex_support)
+		ar->btcoex_support = ATH10K_DT_BTCOEX_SUPPORTED;
+	else
+		ar->btcoex_support = ATH10K_DT_BTCOEX_NOT_SUPPORTED;
+
+	ret = of_property_read_u32(node, "btcoex_gpio_pin",
+				   &ar->btcoex_gpio_pin);
+	if (ret) {
+		ar->btcoex_gpio_pin = -1;
+		goto out;
+	}
+
+out:
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "btcoex support flag :%d gpio %d\n",
+		   ar->btcoex_support, ar->btcoex_gpio_pin);
+}
+
 static int ath10k_init_uart(struct ath10k *ar)
 {
 	int ret;
@@ -1920,14 +1953,23 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
 		if (test_bit(WMI_SERVICE_BSS_CHANNEL_INFO_64, ar->wmi.svc_map))
 			val |= WMI_10_4_BSS_CHANNEL_INFO_64;
 
+		ath10k_core_fetch_btcoex_dt(ar);
+
 		/* 10.4 firmware supports BT-Coex without reloading firmware
 		 * via pdev param. To support Bluetooth coexistence pdev param,
 		 * WMI_COEX_GPIO_SUPPORT of extended resource config should be
 		 * enabled always.
 		 */
+
+		/* we can still enable BTCOEX if firmware has the support
+		 * eventhough btceox_support value is
+		 * ATH10K_DT_BTCOEX_NOT_FOUND
+		 */
+
 		if (test_bit(WMI_SERVICE_COEX_GPIO, ar->wmi.svc_map) &&
 		    test_bit(ATH10K_FW_FEATURE_BTCOEX_PARAM,
-			     ar->running_fw->fw_file.fw_features))
+			     ar->running_fw->fw_file.fw_features) &&
+		    ar->btcoex_support != ATH10K_DT_BTCOEX_NOT_SUPPORTED)
 			val |= WMI_10_4_COEX_GPIO_SUPPORT;
 
 		status = ath10k_mac_ext_resource_config(ar, val);
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index b7067cc..66824c73 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -658,6 +658,12 @@ enum ath10k_tx_pause_reason {
 	ATH10K_TX_PAUSE_MAX,
 };
 
+enum ath10k_dt_btcoex_support_flag {
+	ATH10K_DT_BTCOEX_NOT_FOUND,
+	ATH10K_DT_BTCOEX_SUPPORTED,
+	ATH10K_DT_BTCOEX_NOT_SUPPORTED,
+};
+
 struct ath10k_fw_file {
 	const struct firmware *firmware;
 
@@ -926,6 +932,9 @@ struct ath10k {
 		u32 reg_ack_cts_timeout_orig;
 	} fw_coverage;
 
+	enum ath10k_dt_btcoex_support_flag btcoex_support;
+	int btcoex_gpio_pin;
+
 	/* must be last */
 	u8 drv_priv[0] __aligned(sizeof(void *));
 };
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index ea30fbe..e0e316c 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -2149,6 +2149,9 @@ static ssize_t ath10k_write_btcoex(struct file *file,
 	if (strtobool(buf, &val) != 0)
 		return -EINVAL;
 
+	if (ar->btcoex_support == ATH10K_DT_BTCOEX_NOT_SUPPORTED)
+		return -EOPNOTSUPP;
+
 	mutex_lock(&ar->conf_mutex);
 	ret = ath10k_mac_set_btcoex(ar, val);
 	if (!ret)
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 6b0f1ea..e021951 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4564,9 +4564,11 @@ static int ath10k_start(struct ieee80211_hw *hw)
 	}
 
 	param = ar->wmi.pdev_param->enable_btcoex;
+
 	if (test_bit(WMI_SERVICE_COEX_GPIO, ar->wmi.svc_map) &&
 	    test_bit(ATH10K_FW_FEATURE_BTCOEX_PARAM,
-		     ar->running_fw->fw_file.fw_features)) {
+		     ar->running_fw->fw_file.fw_features) &&
+	    ar->btcoex_support != ATH10K_DT_BTCOEX_NOT_SUPPORTED) {
 		ret = ath10k_wmi_pdev_set_param(ar, param, 0);
 		if (ret) {
 			ath10k_warn(ar,
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index de35c17..1eb5678 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -7811,6 +7811,7 @@ static int ath10k_wmi_10_4_op_get_vdev_subtype(struct ath10k *ar,
 	cmd = (struct wmi_ext_resource_config_10_4_cmd *)skb->data;
 	cmd->host_platform_config = __cpu_to_le32(type);
 	cmd->fw_feature_bitmap = __cpu_to_le32(fw_feature_bitmap);
+	cmd->btcoex_gpio_pin = __cpu_to_le32(ar->btcoex_gpio_pin);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi ext resource config host type %d firmware feature bitmap %08x\n",
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 3a739e3..f83a21e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -2734,6 +2734,8 @@ struct wmi_ext_resource_config_10_4_cmd {
 	__le32 host_platform_config;
 	/* see enum wmi_10_4_feature_mask */
 	__le32 fw_feature_bitmap;
+	/* Contains btcoex gpio pin number */
+	__le32 btcoex_gpio_pin;
 };
 
 struct wmi_set_coex_param_10_4_cmd {
-- 
1.7.9.5
