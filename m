Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:39233 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaIDN46 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 09:56:58 -0400
Subject: [PATCH v3 2/2] ath10k: add testmode
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 04 Sep 2014 16:56:54 +0300
Message-ID: <20140904135654.26750.69133.stgit@potku.adurom.net> (sfid-20140904_155701_544430_BB5B9FD2)
In-Reply-To: <20140904135447.26750.52873.stgit@potku.adurom.net>
References: <20140904135447.26750.52873.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add testmode interface for starting and using UTF firmware which is used to run
factory tests. This is implemented by adding new state ATH10K_STATE_UTF and user
space can enable this state with ATH10K_TM_CMD_UTF_START command. To go back to
normal mode user space can send ATH10K_TM_CMD_UTF_STOP.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/Makefile     |    1 
 drivers/net/wireless/ath/ath10k/core.c       |   88 ++++--
 drivers/net/wireless/ath/ath10k/core.h       |   22 +-
 drivers/net/wireless/ath/ath10k/debug.c      |    5 
 drivers/net/wireless/ath/ath10k/debug.h      |    1 
 drivers/net/wireless/ath/ath10k/hw.h         |    2 
 drivers/net/wireless/ath/ath10k/mac.c        |    9 +
 drivers/net/wireless/ath/ath10k/testmode.c   |  375 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/testmode.h   |   46 +++
 drivers/net/wireless/ath/ath10k/testmode_i.h |   70 +++++
 drivers/net/wireless/ath/ath10k/wmi.c        |   17 +
 11 files changed, 606 insertions(+), 30 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath10k/testmode.c
 create mode 100644 drivers/net/wireless/ath/ath10k/testmode.h
 create mode 100644 drivers/net/wireless/ath/ath10k/testmode_i.h

diff --git a/drivers/net/wireless/ath/ath10k/Makefile b/drivers/net/wireless/ath/ath10k/Makefile
index 2cfb63ca9327..8b1b1adb477a 100644
--- a/drivers/net/wireless/ath/ath10k/Makefile
+++ b/drivers/net/wireless/ath/ath10k/Makefile
@@ -11,6 +11,7 @@ ath10k_core-y += mac.o \
 		 bmi.o
 
 ath10k_core-$(CONFIG_ATH10K_DEBUGFS) += spectral.o
+ath10k_core-$(CONFIG_NL80211_TESTMODE) += testmode.o
 ath10k_core-$(CONFIG_ATH10K_TRACING) += trace.o
 
 obj-$(CONFIG_ATH10K_PCI) += ath10k_pci.o
diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 651a6da8adf5..c01a37526ad5 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -26,6 +26,7 @@
 #include "bmi.h"
 #include "debug.h"
 #include "htt.h"
+#include "testmode.h"
 
 unsigned int ath10k_debug_mask;
 static bool uart_print;
@@ -257,21 +258,42 @@ static int ath10k_download_and_run_otp(struct ath10k *ar)
 	return 0;
 }
 
-static int ath10k_download_fw(struct ath10k *ar)
+static int ath10k_download_fw(struct ath10k *ar, enum ath10k_firmware_mode mode)
 {
-	u32 address;
+	u32 address, data_len;
+	const char *mode_name;
+	const void *data;
 	int ret;
 
 	address = ar->hw_params.patch_load_addr;
 
-	ret = ath10k_bmi_fast_download(ar, address, ar->firmware_data,
-				       ar->firmware_len);
+	switch (mode) {
+	case ATH10K_FIRMWARE_MODE_NORMAL:
+		data = ar->firmware_data;
+		data_len = ar->firmware_len;
+		mode_name = "normal";
+		break;
+	case ATH10K_FIRMWARE_MODE_UTF:
+		data = ar->testmode.utf->data;
+		data_len = ar->testmode.utf->size;
+		mode_name = "utf";
+		break;
+	default:
+		ath10k_err(ar, "unknown firmware mode: %d\n", mode);
+		return -EINVAL;
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_BOOT,
+		   "boot uploading firmware image %p len %d mode %s\n",
+		   data, data_len, mode_name);
+
+	ret = ath10k_bmi_fast_download(ar, address, data, data_len);
 	if (ret) {
-		ath10k_err(ar, "could not write fw (%d)\n", ret);
-		goto exit;
+		ath10k_err(ar, "failed to download %s firmware: %d\n",
+			   mode_name, ret);
+		return ret;
 	}
 
-exit:
 	return ret;
 }
 
@@ -567,7 +589,8 @@ success:
 	return 0;
 }
 
-static int ath10k_init_download_firmware(struct ath10k *ar)
+static int ath10k_init_download_firmware(struct ath10k *ar,
+					 enum ath10k_firmware_mode mode)
 {
 	int ret;
 
@@ -583,7 +606,7 @@ static int ath10k_init_download_firmware(struct ath10k *ar)
 		return ret;
 	}
 
-	ret = ath10k_download_fw(ar);
+	ret = ath10k_download_fw(ar, mode);
 	if (ret) {
 		ath10k_err(ar, "failed to download firmware: %d\n", ret);
 		return ret;
@@ -685,12 +708,15 @@ static void ath10k_core_restart(struct work_struct *work)
 	case ATH10K_STATE_WEDGED:
 		ath10k_warn(ar, "device is wedged, will not restart\n");
 		break;
+	case ATH10K_STATE_UTF:
+		ath10k_warn(ar, "firmware restart in UTF mode not supported\n");
+		break;
 	}
 
 	mutex_unlock(&ar->conf_mutex);
 }
 
-int ath10k_core_start(struct ath10k *ar)
+int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode)
 {
 	int status;
 
@@ -703,7 +729,7 @@ int ath10k_core_start(struct ath10k *ar)
 		goto err;
 	}
 
-	status = ath10k_init_download_firmware(ar);
+	status = ath10k_init_download_firmware(ar, mode);
 	if (status)
 		goto err;
 
@@ -760,10 +786,12 @@ int ath10k_core_start(struct ath10k *ar)
 		goto err_hif_stop;
 	}
 
-	status = ath10k_htt_connect(&ar->htt);
-	if (status) {
-		ath10k_err(ar, "failed to connect htt (%d)\n", status);
-		goto err_hif_stop;
+	if (mode == ATH10K_FIRMWARE_MODE_NORMAL) {
+		status = ath10k_htt_connect(&ar->htt);
+		if (status) {
+			ath10k_err(ar, "failed to connect htt (%d)\n", status);
+			goto err_hif_stop;
+		}
 	}
 
 	status = ath10k_wmi_connect(ar);
@@ -778,11 +806,13 @@ int ath10k_core_start(struct ath10k *ar)
 		goto err_hif_stop;
 	}
 
-	status = ath10k_wmi_wait_for_service_ready(ar);
-	if (status <= 0) {
-		ath10k_warn(ar, "wmi service ready event not received");
-		status = -ETIMEDOUT;
-		goto err_hif_stop;
+	if (mode == ATH10K_FIRMWARE_MODE_NORMAL) {
+		status = ath10k_wmi_wait_for_service_ready(ar);
+		if (status <= 0) {
+			ath10k_warn(ar, "wmi service ready event not received");
+			status = -ETIMEDOUT;
+			goto err_hif_stop;
+		}
 	}
 
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "firmware %s booted\n",
@@ -802,10 +832,13 @@ int ath10k_core_start(struct ath10k *ar)
 		goto err_hif_stop;
 	}
 
-	status = ath10k_htt_setup(&ar->htt);
-	if (status) {
-		ath10k_err(ar, "failed to setup htt: %d\n", status);
-		goto err_hif_stop;
+	/* we don't care about HTT in UTF mode */
+	if (mode == ATH10K_FIRMWARE_MODE_NORMAL) {
+		status = ath10k_htt_setup(&ar->htt);
+		if (status) {
+			ath10k_err(ar, "failed to setup htt: %d\n", status);
+			goto err_hif_stop;
+		}
 	}
 
 	status = ath10k_debug_start(ar);
@@ -861,7 +894,8 @@ void ath10k_core_stop(struct ath10k *ar)
 	lockdep_assert_held(&ar->conf_mutex);
 
 	/* try to suspend target */
-	if (ar->state != ATH10K_STATE_RESTARTING)
+	if (ar->state != ATH10K_STATE_RESTARTING &&
+	    ar->state != ATH10K_STATE_UTF)
 		ath10k_wait_for_suspend(ar, WMI_PDEV_SUSPEND_AND_DISABLE_INTR);
 
 	ath10k_debug_stop(ar);
@@ -914,7 +948,7 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 
 	mutex_lock(&ar->conf_mutex);
 
-	ret = ath10k_core_start(ar);
+	ret = ath10k_core_start(ar, ATH10K_FIRMWARE_MODE_NORMAL);
 	if (ret) {
 		ath10k_err(ar, "could not init core (%d)\n", ret);
 		ath10k_core_free_firmware_files(ar);
@@ -1041,6 +1075,8 @@ void ath10k_core_unregister(struct ath10k *ar)
 	 * unhappy about callback failures. */
 	ath10k_mac_unregister(ar);
 
+	ath10k_testmode_destroy(ar);
+
 	ath10k_core_free_firmware_files(ar);
 
 	ath10k_debug_destroy(ar);
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 797741d762be..30b53aa7a2d3 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -330,6 +330,17 @@ enum ath10k_state {
 	 * prevents completion timeouts and makes the driver more responsive to
 	 * userspace commands. This is also prevents recursive recovery. */
 	ATH10K_STATE_WEDGED,
+
+	/* factory tests */
+	ATH10K_STATE_UTF,
+};
+
+enum ath10k_firmware_mode {
+	/* the default mode, standard 802.11 functionality */
+	ATH10K_FIRMWARE_MODE_NORMAL,
+
+	/* factory tests etc */
+	ATH10K_FIRMWARE_MODE_UTF,
 };
 
 enum ath10k_fw_features {
@@ -543,6 +554,15 @@ struct ath10k {
 		struct ath10k_spec_scan config;
 	} spectral;
 
+	struct {
+		/* protected by conf_mutex */
+		const struct firmware *utf;
+		DECLARE_BITMAP(orig_fw_features, ATH10K_FW_FEATURE_COUNT);
+
+		/* protected by data_lock */
+		bool utf_monitor;
+	} testmode;
+
 	/* must be last */
 	u8 drv_priv[0] __aligned(sizeof(void *));
 };
@@ -551,7 +571,7 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 				  const struct ath10k_hif_ops *hif_ops);
 void ath10k_core_destroy(struct ath10k *ar);
 
-int ath10k_core_start(struct ath10k *ar);
+int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode);
 int ath10k_wait_for_suspend(struct ath10k *ar, u32 suspend_opt);
 void ath10k_core_stop(struct ath10k *ar);
 int ath10k_core_register(struct ath10k *ar, u32 chip_id);
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index d922ef457498..570dce3902ae 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -134,11 +134,12 @@ void ath10k_print_driver_info(struct ath10k *ar)
 		    ar->fw_api,
 		    ar->htt.target_version_major,
 		    ar->htt.target_version_minor);
-	ath10k_info(ar, "debug %d debugfs %d tracing %d dfs %d\n",
+	ath10k_info(ar, "debug %d debugfs %d tracing %d dfs %d testmode %d\n",
 		    config_enabled(CONFIG_ATH10K_DEBUG),
 		    config_enabled(CONFIG_ATH10K_DEBUGFS),
 		    config_enabled(CONFIG_ATH10K_TRACING),
-		    config_enabled(CONFIG_ATH10K_DFS_CERTIFIED));
+		    config_enabled(CONFIG_ATH10K_DFS_CERTIFIED),
+		    config_enabled(CONFIG_NL80211_TESTMODE));
 }
 EXPORT_SYMBOL(ath10k_print_driver_info);
 
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 56746539bea2..fdc8ba23301a 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -34,6 +34,7 @@ enum ath10k_debug_mask {
 	ATH10K_DBG_DATA		= 0x00000200,
 	ATH10K_DBG_BMI		= 0x00000400,
 	ATH10K_DBG_REGULATORY	= 0x00000800,
+	ATH10K_DBG_TESTMODE	= 0x00001000,
 	ATH10K_DBG_ANY		= 0xffffffff,
 };
 
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 13568b01de9f..3cf5702c1e7e 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -36,6 +36,8 @@
 #define ATH10K_FW_API2_FILE		"firmware-2.bin"
 #define ATH10K_FW_API3_FILE		"firmware-3.bin"
 
+#define ATH10K_FW_UTF_FILE		"utf.bin"
+
 /* includes also the null byte */
 #define ATH10K_FIRMWARE_MAGIC               "QCA-ATH10K"
 
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index f80eeed16cb6..5b35fff8127f 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -26,6 +26,7 @@
 #include "wmi.h"
 #include "htt.h"
 #include "txrx.h"
+#include "testmode.h"
 
 /**********/
 /* Crypto */
@@ -2480,6 +2481,9 @@ static int ath10k_start(struct ieee80211_hw *hw)
 		WARN_ON(1);
 		ret = -EINVAL;
 		goto err;
+	case ATH10K_STATE_UTF:
+		ret = -EBUSY;
+		goto err;
 	}
 
 	ret = ath10k_hif_power_up(ar);
@@ -2488,7 +2492,7 @@ static int ath10k_start(struct ieee80211_hw *hw)
 		goto err_off;
 	}
 
-	ret = ath10k_core_start(ar);
+	ret = ath10k_core_start(ar, ATH10K_FIRMWARE_MODE_NORMAL);
 	if (ret) {
 		ath10k_err(ar, "Could not init core: %d\n", ret);
 		goto err_power_down;
@@ -4456,6 +4460,9 @@ static const struct ieee80211_ops ath10k_ops = {
 	.sta_rc_update			= ath10k_sta_rc_update,
 	.get_tsf			= ath10k_get_tsf,
 	.ampdu_action			= ath10k_ampdu_action,
+
+	CFG80211_TESTMODE_CMD(ath10k_tm_cmd)
+
 #ifdef CONFIG_PM
 	.suspend			= ath10k_suspend,
 	.resume				= ath10k_resume,
diff --git a/drivers/net/wireless/ath/ath10k/testmode.c b/drivers/net/wireless/ath/ath10k/testmode.c
new file mode 100644
index 000000000000..da9a924beff6
--- /dev/null
+++ b/drivers/net/wireless/ath/ath10k/testmode.c
@@ -0,0 +1,375 @@
+/*
+ * Copyright (c) 2014 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "testmode.h"
+
+#include <net/netlink.h>
+#include <linux/firmware.h>
+
+#include "debug.h"
+#include "wmi.h"
+#include "hif.h"
+#include "hw.h"
+
+#include "testmode_i.h"
+
+static const struct nla_policy ath10k_tm_policy[ATH10K_TM_ATTR_MAX + 1] = {
+	[ATH10K_TM_ATTR_CMD]		= { .type = NLA_U32 },
+	[ATH10K_TM_ATTR_DATA]		= { .type = NLA_BINARY,
+					    .len = ATH10K_TM_DATA_MAX_LEN },
+	[ATH10K_TM_ATTR_WMI_CMDID]	= { .type = NLA_U32 },
+	[ATH10K_TM_ATTR_VERSION_MAJOR]	= { .type = NLA_U32 },
+	[ATH10K_TM_ATTR_VERSION_MINOR]	= { .type = NLA_U32 },
+};
+
+/* Returns true if callee consumes the skb and the skb should be discarded.
+ * Returns false if skb is not used. Does not sleep.
+ */
+bool ath10k_tm_event_wmi(struct ath10k *ar, u32 cmd_id, struct sk_buff *skb)
+{
+	struct sk_buff *nl_skb;
+	bool consumed;
+	int ret;
+
+	ath10k_dbg(ar, ATH10K_DBG_TESTMODE,
+		   "testmode event wmi cmd_id %d skb %p skb->len %d\n",
+		   cmd_id, skb, skb->len);
+
+	ath10k_dbg_dump(ar, ATH10K_DBG_TESTMODE, NULL, "", skb->data, skb->len);
+
+	spin_lock_bh(&ar->data_lock);
+
+	if (!ar->testmode.utf_monitor) {
+		consumed = false;
+		goto out;
+	}
+
+	/* Only testmode.c should be handling events from utf firmware,
+	 * otherwise all sort of problems will arise as mac80211 operations
+	 * are not initialised. */
+	consumed = true;
+
+	nl_skb = cfg80211_testmode_alloc_event_skb(ar->hw->wiphy,
+						   2 * sizeof(u32) + skb->len,
+						   GFP_ATOMIC);
+	if (!nl_skb) {
+		ath10k_warn(ar,
+			    "failed to allocate skb for testmode wmi event\n");
+		goto out;
+	}
+
+	ret = nla_put_u32(nl_skb, ATH10K_TM_ATTR_CMD, ATH10K_TM_CMD_WMI);
+	if (ret) {
+		ath10k_warn(ar,
+			    "failed to to put testmode wmi event cmd attribute: %d\n",
+			    ret);
+		kfree_skb(nl_skb);
+		goto out;
+	}
+
+	ret = nla_put_u32(nl_skb, ATH10K_TM_ATTR_WMI_CMDID, cmd_id);
+	if (ret) {
+		ath10k_warn(ar,
+			    "failed to to put testmode wmi even cmd_id: %d\n",
+			    ret);
+		kfree_skb(nl_skb);
+		goto out;
+	}
+
+	ret = nla_put(nl_skb, ATH10K_TM_ATTR_DATA, skb->len, skb->data);
+	if (ret) {
+		ath10k_warn(ar,
+			    "failed to copy skb to testmode wmi event: %d\n",
+			    ret);
+		kfree_skb(nl_skb);
+		goto out;
+	}
+
+	cfg80211_testmode_event(nl_skb, GFP_ATOMIC);
+
+out:
+	spin_unlock_bh(&ar->data_lock);
+
+	return consumed;
+}
+
+static int ath10k_tm_cmd_get_version(struct ath10k *ar, struct nlattr *tb[])
+{
+	struct sk_buff *skb;
+	int ret;
+
+	ath10k_dbg(ar, ATH10K_DBG_TESTMODE,
+		   "testmode cmd get version_major %d version_minor %d\n",
+		   ATH10K_TESTMODE_VERSION_MAJOR,
+		   ATH10K_TESTMODE_VERSION_MINOR);
+
+	skb = cfg80211_testmode_alloc_reply_skb(ar->hw->wiphy,
+						nla_total_size(sizeof(u32)));
+	if (!skb)
+		return -ENOMEM;
+
+	ret = nla_put_u32(skb, ATH10K_TM_ATTR_VERSION_MAJOR,
+			  ATH10K_TESTMODE_VERSION_MAJOR);
+	if (ret) {
+		kfree_skb(skb);
+		return ret;
+	}
+
+	ret = nla_put_u32(skb, ATH10K_TM_ATTR_VERSION_MINOR,
+			  ATH10K_TESTMODE_VERSION_MINOR);
+	if (ret) {
+		kfree_skb(skb);
+		return ret;
+	}
+
+	return cfg80211_testmode_reply(skb);
+}
+
+static int ath10k_tm_cmd_utf_start(struct ath10k *ar, struct nlattr *tb[])
+{
+	char filename[100];
+	int ret;
+
+	ath10k_dbg(ar, ATH10K_DBG_TESTMODE, "testmode cmd utf start\n");
+
+	mutex_lock(&ar->conf_mutex);
+
+	if (ar->state == ATH10K_STATE_UTF) {
+		ret = -EALREADY;
+		goto err;
+	}
+
+	/* start utf only when the driver is not in use  */
+	if (ar->state != ATH10K_STATE_OFF) {
+		ret = -EBUSY;
+		goto err;
+	}
+
+	if (ar->testmode.utf != NULL)
+		/* utf image is already downloaded */
+		goto power_up;
+
+	snprintf(filename, sizeof(filename), "%s/%s",
+		 ar->hw_params.fw.dir, ATH10K_FW_UTF_FILE);
+
+	/* load utf firmware image */
+	ret = request_firmware(&ar->testmode.utf, filename, ar->dev);
+	if (ret) {
+		ath10k_warn(ar, "failed to retrieve utf firmware '%s': %d\n",
+			    filename, ret);
+		goto err;
+	}
+
+power_up:
+	spin_lock_bh(&ar->data_lock);
+
+	ar->testmode.utf_monitor = true;
+
+	spin_unlock_bh(&ar->data_lock);
+
+	BUILD_BUG_ON(sizeof(ar->fw_features) !=
+		     sizeof(ar->testmode.orig_fw_features));
+
+	memcpy(ar->testmode.orig_fw_features, ar->fw_features,
+	       sizeof(ar->fw_features));
+
+	/* utf.bin firmware image does not advertise firmware features. Do
+	 * an ugly hack where we force the firmware features so that wmi.c
+	 * will use the correct WMI interface.
+	 */
+	memset(ar->fw_features, 0, sizeof(ar->fw_features));
+	__set_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features);
+
+	ret = ath10k_hif_power_up(ar);
+	if (ret) {
+		ath10k_err(ar, "failed to power up hif (testmode): %d\n", ret);
+		ar->state = ATH10K_STATE_OFF;
+		goto err_fw_features;
+	}
+
+	ret = ath10k_core_start(ar, ATH10K_FIRMWARE_MODE_UTF);
+	if (ret) {
+		ath10k_err(ar, "failed to start core (testmode): %d\n", ret);
+		ar->state = ATH10K_STATE_OFF;
+		goto err_power_down;
+	}
+
+	ar->state = ATH10K_STATE_UTF;
+
+	ath10k_info(ar, "UTF firmware started\n");
+
+	mutex_unlock(&ar->conf_mutex);
+
+	return 0;
+
+err_power_down:
+	ath10k_hif_power_down(ar);
+
+err_fw_features:
+	/* return the original firmware features */
+	memcpy(ar->fw_features, ar->testmode.orig_fw_features,
+	       sizeof(ar->fw_features));
+
+	release_firmware(ar->testmode.utf);
+	ar->testmode.utf = NULL;
+
+err:
+	mutex_unlock(&ar->conf_mutex);
+
+	return ret;
+}
+
+static int ath10k_tm_cmd_utf_stop(struct ath10k *ar, struct nlattr *tb[])
+{
+	int ret;
+
+	ath10k_dbg(ar, ATH10K_DBG_TESTMODE, "testmode cmd utf stop\n");
+
+	mutex_lock(&ar->conf_mutex);
+
+	if (ar->state != ATH10K_STATE_UTF) {
+		ret = -ENETDOWN;
+		goto out;
+	}
+
+	ath10k_core_stop(ar);
+	ath10k_hif_power_down(ar);
+
+	spin_lock_bh(&ar->data_lock);
+
+	ar->testmode.utf_monitor = false;
+
+	spin_unlock_bh(&ar->data_lock);
+
+	/* return the original firmware features */
+	memcpy(ar->fw_features, ar->testmode.orig_fw_features,
+	       sizeof(ar->fw_features));
+
+	release_firmware(ar->testmode.utf);
+	ar->testmode.utf = NULL;
+
+	ar->state = ATH10K_STATE_OFF;
+	ret = 0;
+
+	ath10k_info(ar, "UTF firmware stopped\n");
+
+out:
+	mutex_unlock(&ar->conf_mutex);
+	return ret;
+}
+
+static int ath10k_tm_cmd_wmi(struct ath10k *ar, struct nlattr *tb[])
+{
+	struct sk_buff *skb;
+	int ret, buf_len;
+	u32 cmd_id;
+	void *buf;
+
+	mutex_lock(&ar->conf_mutex);
+
+	if (ar->state != ATH10K_STATE_UTF) {
+		ret = -ENETDOWN;
+		goto out;
+	}
+
+	if (!tb[ATH10K_TM_ATTR_DATA]) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (!tb[ATH10K_TM_ATTR_WMI_CMDID]) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	buf = nla_data(tb[ATH10K_TM_ATTR_DATA]);
+	buf_len = nla_len(tb[ATH10K_TM_ATTR_DATA]);
+	cmd_id = nla_get_u32(tb[ATH10K_TM_ATTR_WMI_CMDID]);
+
+	ath10k_dbg(ar, ATH10K_DBG_TESTMODE,
+		   "testmode cmd wmi cmd_id %d buf %p buf_len %d\n",
+		   cmd_id, buf, buf_len);
+
+	ath10k_dbg_dump(ar, ATH10K_DBG_TESTMODE, NULL, "", buf, buf_len);
+
+	skb = ath10k_wmi_alloc_skb(ar, buf_len);
+	if (!skb) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	memcpy(skb->data, buf, buf_len);
+
+	ret = ath10k_wmi_cmd_send(ar, skb, cmd_id);
+	if (ret) {
+		ath10k_warn(ar, "failed to transmit wmi command (testmode): %d\n",
+			    ret);
+		goto out;
+	}
+
+	ret = 0;
+
+out:
+	mutex_unlock(&ar->conf_mutex);
+	return ret;
+}
+
+int ath10k_tm_cmd(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		  void *data, int len)
+{
+	struct ath10k *ar = hw->priv;
+	struct nlattr *tb[ATH10K_TM_ATTR_MAX + 1];
+	int ret;
+
+	ret = nla_parse(tb, ATH10K_TM_ATTR_MAX, data, len,
+			ath10k_tm_policy);
+	if (ret)
+		return ret;
+
+	if (!tb[ATH10K_TM_ATTR_CMD])
+		return -EINVAL;
+
+	switch (nla_get_u32(tb[ATH10K_TM_ATTR_CMD])) {
+	case ATH10K_TM_CMD_GET_VERSION:
+		return ath10k_tm_cmd_get_version(ar, tb);
+	case ATH10K_TM_CMD_UTF_START:
+		return ath10k_tm_cmd_utf_start(ar, tb);
+	case ATH10K_TM_CMD_UTF_STOP:
+		return ath10k_tm_cmd_utf_stop(ar, tb);
+	case ATH10K_TM_CMD_WMI:
+		return ath10k_tm_cmd_wmi(ar, tb);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+void ath10k_testmode_destroy(struct ath10k *ar)
+{
+	mutex_lock(&ar->conf_mutex);
+
+	release_firmware(ar->testmode.utf);
+	ar->testmode.utf = NULL;
+
+	if (ar->state != ATH10K_STATE_UTF) {
+		/* utf firmware is not running, nothing to do */
+		goto out;
+	}
+
+	ath10k_core_stop(ar);
+
+out:
+	mutex_unlock(&ar->conf_mutex);
+}
diff --git a/drivers/net/wireless/ath/ath10k/testmode.h b/drivers/net/wireless/ath/ath10k/testmode.h
new file mode 100644
index 000000000000..9cdd150815db
--- /dev/null
+++ b/drivers/net/wireless/ath/ath10k/testmode.h
@@ -0,0 +1,46 @@
+/*
+ * Copyright (c) 2014 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "core.h"
+
+#ifdef CONFIG_NL80211_TESTMODE
+
+void ath10k_testmode_destroy(struct ath10k *ar);
+
+bool ath10k_tm_event_wmi(struct ath10k *ar, u32 cmd_id, struct sk_buff *skb);
+int ath10k_tm_cmd(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		  void *data, int len);
+
+#else
+
+static inline void ath10k_testmode_destroy(struct ath10k *ar)
+{
+}
+
+static inline bool ath10k_tm_event_wmi(struct ath10k *ar, u32 cmd_id,
+				       struct sk_buff *skb)
+{
+	return false;
+}
+
+static inline int ath10k_tm_cmd(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				void *data, int len)
+{
+	return 0;
+}
+
+#endif
diff --git a/drivers/net/wireless/ath/ath10k/testmode_i.h b/drivers/net/wireless/ath/ath10k/testmode_i.h
new file mode 100644
index 000000000000..ba81bf66ce85
--- /dev/null
+++ b/drivers/net/wireless/ath/ath10k/testmode_i.h
@@ -0,0 +1,70 @@
+/*
+ * Copyright (c) 2014 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+/* "API" level of the ath10k testmode interface. Bump it after every
+ * incompatible interface change.
+ */
+#define ATH10K_TESTMODE_VERSION_MAJOR 1
+
+/* Bump this after every _compatible_ interface change, for example
+ * addition of a new command or an attribute.
+ */
+#define ATH10K_TESTMODE_VERSION_MINOR 0
+
+#define ATH10K_TM_DATA_MAX_LEN		5000
+
+enum ath10k_tm_attr {
+	__ATH10K_TM_ATTR_INVALID	= 0,
+	ATH10K_TM_ATTR_CMD		= 1,
+	ATH10K_TM_ATTR_DATA		= 2,
+	ATH10K_TM_ATTR_WMI_CMDID	= 3,
+	ATH10K_TM_ATTR_VERSION_MAJOR	= 4,
+	ATH10K_TM_ATTR_VERSION_MINOR	= 5,
+
+	/* keep last */
+	__ATH10K_TM_ATTR_AFTER_LAST,
+	ATH10K_TM_ATTR_MAX		= __ATH10K_TM_ATTR_AFTER_LAST - 1,
+};
+
+/* All ath10k testmode interface commands specified in
+ * ATH10K_TM_ATTR_CMD
+ */
+enum ath10k_tm_cmd {
+	/* Returns the supported ath10k testmode interface version in
+	 * ATH10K_TM_ATTR_VERSION. Always guaranteed to work. User space
+	 * uses this to verify it's using the correct version of the
+	 * testmode interface
+	 */
+	ATH10K_TM_CMD_GET_VERSION = 0,
+
+	/* Boots the UTF firmware, the netdev interface must be down at the
+	 * time.
+	 */
+	ATH10K_TM_CMD_UTF_START = 1,
+
+	/* Shuts down the UTF firmware and puts the driver back into OFF
+	 * state.
+	 */
+	ATH10K_TM_CMD_UTF_STOP = 2,
+
+	/* The command used to transmit a WMI command to the firmware and
+	 * the event to receive WMI events from the firmware. Without
+	 * struct wmi_cmd_hdr header, only the WMI payload. Command id is
+	 * provided with ATH10K_TM_ATTR_WMI_CMDID and payload in
+	 * ATH10K_TM_ATTR_DATA.
+	 */
+	ATH10K_TM_CMD_WMI = 3,
+};
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index f80959419525..f3a366a26c93 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -23,6 +23,7 @@
 #include "debug.h"
 #include "wmi.h"
 #include "mac.h"
+#include "testmode.h"
 
 /* MAIN WMI cmd track */
 static struct wmi_cmd_map wmi_cmd_map = {
@@ -2479,6 +2480,7 @@ static void ath10k_wmi_10x_process_rx(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_cmd_hdr *cmd_hdr;
 	enum wmi_10x_event_id id;
+	bool consumed;
 
 	cmd_hdr = (struct wmi_cmd_hdr *)skb->data;
 	id = MS(__le32_to_cpu(cmd_hdr->cmd_id), WMI_CMD_HDR_CMD_ID);
@@ -2488,6 +2490,17 @@ static void ath10k_wmi_10x_process_rx(struct ath10k *ar, struct sk_buff *skb)
 
 	trace_ath10k_wmi_event(ar, id, skb->data, skb->len);
 
+	consumed = ath10k_tm_event_wmi(ar, id, skb);
+
+	/* Ready event must be handled normally also in UTF mode so that we
+	 * know the UTF firmware has booted, others we are just bypass WMI
+	 * events to testmode. */
+	if (consumed && id != WMI_10X_READY_EVENTID) {
+		ath10k_dbg(ar, ATH10K_DBG_WMI,
+			   "wmi testmode consumed 0x%x\n", id);
+		goto out;
+	}
+
 	switch (id) {
 	case WMI_10X_MGMT_RX_EVENTID:
 		ath10k_wmi_event_mgmt_rx(ar, skb);
@@ -2574,11 +2587,15 @@ static void ath10k_wmi_10x_process_rx(struct ath10k *ar, struct sk_buff *skb)
 	case WMI_10X_READY_EVENTID:
 		ath10k_wmi_ready_event_rx(ar, skb);
 		break;
+	case WMI_10X_PDEV_UTF_EVENTID:
+		/* ignore utf events */
+		break;
 	default:
 		ath10k_warn(ar, "Unknown eventid: %d\n", id);
 		break;
 	}
 
+out:
 	dev_kfree_skb(skb);
 }
 

