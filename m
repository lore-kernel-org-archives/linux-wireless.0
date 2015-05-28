Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57338 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbbE1TZl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 15:25:41 -0400
From: Yanbo Li <yanbol@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <dreamfly281@gmail.com>, <ath10k@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] ath10k: Ignore the adjacent radio's activity when surveying a channel
Date: Thu, 28 May 2015 12:23:06 -0700
Message-ID: <1432840986-21918-2-git-send-email-yanbol@qca.qualcomm.com> (sfid-20150528_212545_843032_68AC3B34)
In-Reply-To: <1432840986-21918-1-git-send-email-yanbol@qca.qualcomm.com>
References: <1432840986-21918-1-git-send-email-yanbol@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The overall goal for a scanning radio is to evaluate the outside radio
environment. Some platforms integrate several radios together. When one radio
wants to survey the current channel, the adjacent radio's activity will make
this survey result inaccurate. the switcher can be used to enable the FW to
ignore the survey time slot when the adjacent radio is active, especially for
TX. This skipped scan approach will make the survey result more accurate.

This technique requires a precondition that the scanning and adjacent radio
have some physical connection to make them aware of each other's activity from
within the FW layer, and the FW claimed supporting this capability.

To enable this feature, execute:
echo 2 > /sys/kernel/debug/ieee80211/phyX/ath10k/adjacent_wlan_interfrc

Then run the survey scan and dump the stastics:
iw dev wifiX survey dump
The TX&RX counter showed already deducted the time slot be interfered

To check whether the feature is enabled, execute:
cat /sys/kernel/debug/ieee80211/phyX/ath10k/adjacent_wlan_interfrc
INTERFRC DETECT FOR SURVEY SCAN: Enable/Disable

Signed-off-by: Yanbo Li <yanbol@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.h  | 1 +
 drivers/net/wireless/ath/ath10k/debug.c | 4 ++++
 drivers/net/wireless/ath/ath10k/wmi.c   | 5 +++++
 drivers/net/wireless/ath/ath10k/wmi.h   | 7 +++++++
 4 files changed, 17 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index fb0e8521fc45..164160aaf8a7 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -491,6 +491,7 @@ enum ath10k_cal_mode {
 
 enum ath10k_wlan_interfrc_mask {
 	ATH10K_SPECTRAL_INTERFRC	= 0x00000001,
+	ATH10K_SURVEY_INTERFRC		= 0x00000002,
 };
 
 static inline const char *ath10k_cal_mode_str(enum ath10k_cal_mode mode)
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 534dfb8ada95..3051cbaebc74 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -2190,6 +2190,10 @@ static ssize_t ath10k_read_adjacent_wlan_interfrc(struct file *file,
 			 interfrc_5g);
 	len += scnprintf(buf + len, buf_len - len, "2G INTERFRC: %d\n",
 			 interfrc_2g);
+	len += scnprintf(buf + len, buf_len - len,
+			 "INTERFRC DETECT FOR SURVEY SCAN: %s\n",
+			 ar->wlan_interfrc_mask & ATH10K_SURVEY_INTERFRC ?
+			 "Enable" : "Disable");
 
 	mutex_unlock(&ar->conf_mutex);
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 1fb850817589..dbd394422905 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3942,6 +3942,11 @@ static struct sk_buff *ath10k_wmi_10_2_op_gen_init(struct ath10k *ar)
 		      ar->wmi.svc_map)))
 		features |= WMI_10_2_ADJ_RADIO_SPECTRAL_INTERFRC;
 
+	if ((ar->wlan_interfrc_mask & ATH10K_SURVEY_INTERFRC) &&
+	    (test_bit(WMI_SERVICE_ADJ_RADIO_SURVEY_INTERFRC, ar->wmi.svc_map)))
+		features |= WMI_10_2_ADJ_RADIO_SURVEY_INTERFRC;
+
+
 	cmd->resource_config.feature_mask = __cpu_to_le32(features);
 
 	memcpy(&cmd->resource_config.common, &config, sizeof(config));
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 36bb0768d87f..7cbad1932bf5 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -151,6 +151,7 @@ enum wmi_service {
 	WMI_SERVICE_ATF,
 	WMI_SERVICE_COEX_GPIO,
 	WMI_SERVICE_ADJ_RADIO_SPECTRAL_INTERFRC,
+	WMI_SERVICE_ADJ_RADIO_SURVEY_INTERFRC,
 
 	/* keep last */
 	WMI_SERVICE_MAX,
@@ -183,6 +184,7 @@ enum wmi_10x_service {
 	WMI_10X_SERVICE_ATF,
 	WMI_10X_SERVICE_COEX_GPIO,
 	WMI_10X_SERVICE_ADJ_RADIO_SPECTRAL_INTERFRC,
+	WMI_10X_SERVICE_ADJ_RADIO_SURVEY_INTERFRC,
 };
 
 enum wmi_main_service {
@@ -302,6 +304,7 @@ static inline char *wmi_service_name(int service_id)
 	SVCSTR(WMI_SERVICE_ATF);
 	SVCSTR(WMI_SERVICE_COEX_GPIO);
 	SVCSTR(WMI_SERVICE_ADJ_RADIO_SPECTRAL_INTERFRC);
+	SVCSTR(WMI_SERVICE_ADJ_RADIO_SURVEY_INTERFRC);
 
 	default:
 		return NULL;
@@ -372,6 +375,9 @@ static inline void wmi_10x_svc_map(const __le32 *in, unsigned long *out,
 	       WMI_SERVICE_COEX_GPIO, len);
 	SVCMAP(WMI_10X_SERVICE_ADJ_RADIO_SPECTRAL_INTERFRC,
 	       WMI_SERVICE_ADJ_RADIO_SPECTRAL_INTERFRC, len);
+	SVCMAP(WMI_10X_SERVICE_ADJ_RADIO_SURVEY_INTERFRC,
+	       WMI_SERVICE_ADJ_RADIO_SURVEY_INTERFRC, len);
+
 }
 
 static inline void wmi_main_svc_map(const __le32 *in, unsigned long *out,
@@ -1973,6 +1979,7 @@ enum wmi_10_2_feature_mask {
 	WMI_10_2_ATF_CONFIG    = BIT(1),
 	WMI_10_2_COEX_GPIO     = BIT(3),
 	WMI_10_2_ADJ_RADIO_SPECTRAL_INTERFRC	= BIT(4),
+	WMI_10_2_ADJ_RADIO_SURVEY_INTERFRC	= BIT(5),
 };
 
 struct wmi_resource_config_10_2 {
-- 
1.9.1

