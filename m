Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:59744 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752288AbdLLTEN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Dec 2017 14:04:13 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 4/9] wil6210: set platform features based on FW capabilities
Date: Tue, 12 Dec 2017 21:03:57 +0200
Message-Id: <1513105442-28041-5-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20171212_200418_469553_484C2FE5)
In-Reply-To: <1513105442-28041-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1513105442-28041-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In some cases the platform should be aware of the FW capabilities
to decide which feature to enable.
For example, FW can control the external REF clock for power saving.
Driver should notify the platform about that, to allow platform
power management optimization.

Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c         | 11 +++++++++++
 drivers/net/wireless/ath/wil6210/wil_platform.h |  6 ++++++
 drivers/net/wireless/ath/wil6210/wmi.h          |  1 +
 3 files changed, 18 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index bafd8d5..7a8f8c2 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -771,6 +771,7 @@ static void wil_collect_fw_info(struct wil6210_priv *wil)
 void wil_refresh_fw_capabilities(struct wil6210_priv *wil)
 {
 	struct wiphy *wiphy = wil_to_wiphy(wil);
+	int features;
 
 	wil->keep_radio_on_during_sleep =
 		test_bit(WIL_PLATFORM_CAPA_RADIO_ON_IN_SUSPEND,
@@ -792,6 +793,16 @@ void wil_refresh_fw_capabilities(struct wil6210_priv *wil)
 		wiphy->max_sched_scan_ie_len = WMI_MAX_IE_LEN;
 		wiphy->max_sched_scan_plans = WMI_MAX_PLANS_NUM;
 	}
+
+	if (wil->platform_ops.set_features) {
+		features = (test_bit(WMI_FW_CAPABILITY_REF_CLOCK_CONTROL,
+				     wil->fw_capabilities) &&
+			    test_bit(WIL_PLATFORM_CAPA_EXT_CLK,
+				     wil->platform_capa)) ?
+			BIT(WIL_PLATFORM_FEATURE_FW_EXT_CLK_CONTROL) : 0;
+
+		wil->platform_ops.set_features(wil->platform_handle, features);
+	}
 }
 
 void wil_mbox_ring_le2cpus(struct wil6210_mbox_ring *r)
diff --git a/drivers/net/wireless/ath/wil6210/wil_platform.h b/drivers/net/wireless/ath/wil6210/wil_platform.h
index 5cfb946..177026e 100644
--- a/drivers/net/wireless/ath/wil6210/wil_platform.h
+++ b/drivers/net/wireless/ath/wil6210/wil_platform.h
@@ -27,6 +27,11 @@ enum wil_platform_event {
 	WIL_PLATFORM_EVT_POST_SUSPEND = 4,
 };
 
+enum wil_platform_features {
+	WIL_PLATFORM_FEATURE_FW_EXT_CLK_CONTROL = 0,
+	WIL_PLATFORM_FEATURE_MAX,
+};
+
 enum wil_platform_capa {
 	WIL_PLATFORM_CAPA_RADIO_ON_IN_SUSPEND = 0,
 	WIL_PLATFORM_CAPA_T_PWR_ON_0 = 1,
@@ -45,6 +50,7 @@ struct wil_platform_ops {
 	void (*uninit)(void *handle);
 	int (*notify)(void *handle, enum wil_platform_event evt);
 	int (*get_capa)(void *handle);
+	void (*set_features)(void *handle, int features);
 };
 
 /**
diff --git a/drivers/net/wireless/ath/wil6210/wmi.h b/drivers/net/wireless/ath/wil6210/wmi.h
index 7c6ac9c..adb317f 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.h
+++ b/drivers/net/wireless/ath/wil6210/wmi.h
@@ -72,6 +72,7 @@ enum wmi_fw_capability {
 	WMI_FW_CAPABILITY_SET_SILENT_RSSI_TABLE		= 13,
 	WMI_FW_CAPABILITY_LO_POWER_CALIB_FROM_OTP	= 14,
 	WMI_FW_CAPABILITY_PNO				= 15,
+	WMI_FW_CAPABILITY_REF_CLOCK_CONTROL		= 18,
 	WMI_FW_CAPABILITY_MAX,
 };
 
-- 
1.9.1
