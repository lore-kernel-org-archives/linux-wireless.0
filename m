Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33394 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932329AbcKQLoS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 06:44:18 -0500
From: <c_traja@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <tamizhchelvam@codeaurora.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <robh@kernel.org>, Tamizh chelvam <c_traja@qti.qualcomm.com>
Subject: [PATCHv2 1/4] ath10k: Add support to enable or disable btcoex via nl80211
Date: Thu, 17 Nov 2016 17:14:21 +0530
Message-ID: <1479383064-25718-2-git-send-email-c_traja@qti.qualcomm.com> (sfid-20161117_124903_799821_2EC25FFA)
In-Reply-To: <1479383064-25718-1-git-send-email-c_traja@qti.qualcomm.com>
References: <1479383064-25718-1-git-send-email-c_traja@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tamizh chelvam <c_traja@qti.qualcomm.com>

This patch add support to enable or disable btcoex via nl80211.
The firmware support this feature since 10.2.4.54 on 2G-only board,
dual band or 5G boards don't support this. WMI service
WMI_SERVICE_COEX_GPIO is used to identify the firmware support of this
feature.

Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/debug.c |   37 ++------------------
 drivers/net/wireless/ath/ath10k/mac.c   |   58 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/mac.h   |    1 +
 3 files changed, 62 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 82a4c67..ea30fbe 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -26,6 +26,7 @@
 #include "debug.h"
 #include "hif.h"
 #include "wmi-ops.h"
+#include "mac.h"
 
 /* ms */
 #define ATH10K_DEBUG_HTT_STATS_INTERVAL 1000
@@ -2138,7 +2139,6 @@ static ssize_t ath10k_write_btcoex(struct file *file,
 	size_t buf_size;
 	int ret;
 	bool val;
-	u32 pdev_param;
 
 	buf_size = min(count, (sizeof(buf) - 1));
 	if (copy_from_user(buf, ubuf, buf_size))
@@ -2150,40 +2150,9 @@ static ssize_t ath10k_write_btcoex(struct file *file,
 		return -EINVAL;
 
 	mutex_lock(&ar->conf_mutex);
-
-	if (ar->state != ATH10K_STATE_ON &&
-	    ar->state != ATH10K_STATE_RESTARTED) {
-		ret = -ENETDOWN;
-		goto exit;
-	}
-
-	if (!(test_bit(ATH10K_FLAG_BTCOEX, &ar->dev_flags) ^ val)) {
+	ret = ath10k_mac_set_btcoex(ar, val);
+	if (!ret)
 		ret = count;
-		goto exit;
-	}
-
-	pdev_param = ar->wmi.pdev_param->enable_btcoex;
-	if (test_bit(ATH10K_FW_FEATURE_BTCOEX_PARAM,
-		     ar->running_fw->fw_file.fw_features)) {
-		ret = ath10k_wmi_pdev_set_param(ar, pdev_param, val);
-		if (ret) {
-			ath10k_warn(ar, "failed to enable btcoex: %d\n", ret);
-			ret = count;
-			goto exit;
-		}
-	} else {
-		ath10k_info(ar, "restarting firmware due to btcoex change");
-		queue_work(ar->workqueue, &ar->restart_work);
-	}
-
-	if (val)
-		set_bit(ATH10K_FLAG_BTCOEX, &ar->dev_flags);
-	else
-		clear_bit(ATH10K_FLAG_BTCOEX, &ar->dev_flags);
-
-	ret = count;
-
-exit:
 	mutex_unlock(&ar->conf_mutex);
 
 	return ret;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 717b2fa..e7131b9 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -7445,6 +7445,63 @@ struct ath10k_mac_change_chanctx_arg {
 	return 0;
 }
 
+static inline void ath10k_mac_update_btcoex_flag(struct ath10k *ar, bool val)
+{
+	if (val)
+		set_bit(ATH10K_FLAG_BTCOEX, &ar->dev_flags);
+	else
+		clear_bit(ATH10K_FLAG_BTCOEX, &ar->dev_flags);
+}
+
+int ath10k_mac_set_btcoex(struct ath10k *ar, bool val)
+{
+	u32 pdev_param;
+	int ret;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	if (ar->state != ATH10K_STATE_ON &&
+	    ar->state != ATH10K_STATE_RESTARTED)
+		return -ENETDOWN;
+
+	if (!(test_bit(ATH10K_FLAG_BTCOEX, &ar->dev_flags) ^ val))
+		return 0;
+
+	pdev_param = ar->wmi.pdev_param->enable_btcoex;
+	if (test_bit(ATH10K_FW_FEATURE_BTCOEX_PARAM,
+		     ar->running_fw->fw_file.fw_features)) {
+		ret = ath10k_wmi_pdev_set_param(ar, pdev_param, val);
+
+		if (ret) {
+			ath10k_warn(ar,
+				    "failed to modify btcoex state: %d\n", ret);
+			return ret;
+		}
+		ath10k_mac_update_btcoex_flag(ar, val);
+	} else {
+		ath10k_info(ar, "restarting firmware due to btcoex change");
+		ath10k_mac_update_btcoex_flag(ar, val);
+		queue_work(ar->workqueue, &ar->restart_work);
+	}
+
+	return 0;
+}
+
+static int ath10k_mac_op_set_btcoex(struct ieee80211_hw *hw, bool enabled)
+{
+	int ret;
+	struct ath10k *ar = hw->priv;
+
+	if (!test_bit(WMI_SERVICE_COEX_GPIO, ar->wmi.svc_map))
+		return -EOPNOTSUPP;
+
+	mutex_lock(&ar->conf_mutex);
+	ret = ath10k_mac_set_btcoex(ar, enabled);
+	mutex_unlock(&ar->conf_mutex);
+
+	return ret;
+}
+
 static const struct ieee80211_ops ath10k_ops = {
 	.tx				= ath10k_mac_op_tx,
 	.wake_tx_queue			= ath10k_mac_op_wake_tx_queue,
@@ -7486,6 +7543,7 @@ struct ath10k_mac_change_chanctx_arg {
 	.assign_vif_chanctx		= ath10k_mac_op_assign_vif_chanctx,
 	.unassign_vif_chanctx		= ath10k_mac_op_unassign_vif_chanctx,
 	.switch_vif_chanctx		= ath10k_mac_op_switch_vif_chanctx,
+	.set_btcoex                     = ath10k_mac_op_set_btcoex,
 
 	CFG80211_TESTMODE_CMD(ath10k_tm_cmd)
 
diff --git a/drivers/net/wireless/ath/ath10k/mac.h b/drivers/net/wireless/ath/ath10k/mac.h
index 1bd29ec..de1fa72 100644
--- a/drivers/net/wireless/ath/ath10k/mac.h
+++ b/drivers/net/wireless/ath/ath10k/mac.h
@@ -82,6 +82,7 @@ struct ieee80211_txq *ath10k_mac_txq_lookup(struct ath10k *ar,
 					    u16 peer_id,
 					    u8 tid);
 int ath10k_mac_ext_resource_config(struct ath10k *ar, u32 val);
+int ath10k_mac_set_btcoex(struct ath10k *ar, bool val);
 
 static inline struct ath10k_vif *ath10k_vif_to_arvif(struct ieee80211_vif *vif)
 {
-- 
1.7.9.5
