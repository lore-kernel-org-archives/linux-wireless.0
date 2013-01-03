Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:57106 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753050Ab3ACA43 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 19:56:29 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/2] mwifiex: parse WMM IEs from hostapd for mwifiex AP
Date: Wed,  2 Jan 2013 16:56:01 -0800
Message-Id: <1357174561-28898-2-git-send-email-bzhao@marvell.com> (sfid-20130103_015637_973661_B4551387)
In-Reply-To: <1357174561-28898-1-git-send-email-bzhao@marvell.com>
References: <1357174561-28898-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch adds support for parsing WMM IEs from hostapd
and setting them to FW via sys configure command.

Patch also sets wiphy flag to advertise AP uAPSD support.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    2 +
 drivers/net/wireless/mwifiex/decl.h     |   18 ++++++++++++
 drivers/net/wireless/mwifiex/fw.h       |   11 +++----
 drivers/net/wireless/mwifiex/ioctl.h    |    3 +-
 drivers/net/wireless/mwifiex/main.h     |    4 +++
 drivers/net/wireless/mwifiex/uap_cmd.c  |   44 +++++++++++++++++++++++++++++++
 6 files changed, 75 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index a875499..c4edb28 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1327,6 +1327,7 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 	}
 
 	mwifiex_set_ht_params(priv, bss_cfg, params);
+	mwifiex_set_wmm_params(priv, bss_cfg, params);
 
 	if (params->inactivity_timeout > 0) {
 		/* sta_ao_timer/ps_sta_ao_timer is in unit of 100ms */
@@ -2261,6 +2262,7 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 	wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
 	wiphy->flags |= WIPHY_FLAG_HAVE_AP_SME |
 			WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD |
+			WIPHY_FLAG_AP_UAPSD |
 			WIPHY_FLAG_CUSTOM_REGULATORY |
 			WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
 
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index e9357d8..e8a569a 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -26,6 +26,7 @@
 #include <linux/wait.h>
 #include <linux/timer.h>
 #include <linux/ieee80211.h>
+#include <net/mac80211.h>
 
 
 #define MWIFIEX_MAX_BSS_NUM         (3)
@@ -58,6 +59,8 @@
 #define MWIFIEX_RTS_MAX_VALUE              (2347)
 #define MWIFIEX_FRAG_MIN_VALUE             (256)
 #define MWIFIEX_FRAG_MAX_VALUE             (2346)
+#define MWIFIEX_WMM_VERSION                0x01
+#define MWIFIEX_WMM_SUBTYPE                0x01
 
 #define MWIFIEX_RETRY_LIMIT                14
 #define MWIFIEX_SDIO_BLOCK_SIZE            256
@@ -126,4 +129,19 @@ enum mwifiex_wmm_ac_e {
 	WMM_AC_VI,
 	WMM_AC_VO
 } __packed;
+
+struct ieee_types_wmm_ac_parameters {
+	u8 aci_aifsn_bitmap;
+	u8 ecw_bitmap;
+	__le16 tx_op_limit;
+} __packed;
+
+struct mwifiex_types_wmm_info {
+	u8 oui[4];
+	u8 subtype;
+	u8 version;
+	u8 qos_info;
+	u8 reserved;
+	struct ieee_types_wmm_ac_parameters ac_params[IEEE80211_NUM_ACS];
+} __packed;
 #endif /* !_MWIFIEX_DECL_H_ */
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 4dc8e2e..41c85dd 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -1131,12 +1131,6 @@ struct ieee_types_vendor_header {
 	u8 version;
 } __packed;
 
-struct ieee_types_wmm_ac_parameters {
-	u8 aci_aifsn_bitmap;
-	u8 ecw_bitmap;
-	__le16 tx_op_limit;
-} __packed;
-
 struct ieee_types_wmm_parameter {
 	/*
 	 * WMM Parameter IE - Vendor Specific Header:
@@ -1186,6 +1180,11 @@ struct mwifiex_ie_types_htcap {
 	struct ieee80211_ht_cap ht_cap;
 } __packed;
 
+struct mwifiex_ie_types_wmmcap {
+	struct mwifiex_ie_types_header header;
+	struct mwifiex_types_wmm_info wmm_info;
+} __packed;
+
 struct mwifiex_ie_types_htinfo {
 	struct mwifiex_ie_types_header header;
 	struct ieee80211_ht_operation ht_oper;
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index 4e31c60..6095b3e 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -20,7 +20,6 @@
 #ifndef _MWIFIEX_IOCTL_H_
 #define _MWIFIEX_IOCTL_H_
 
-#include <net/mac80211.h>
 #include <net/lib80211.h>
 
 enum {
@@ -107,6 +106,8 @@ struct mwifiex_uap_bss_param {
 	u8 rates[MWIFIEX_SUPPORTED_RATES];
 	u32 sta_ao_timer;
 	u32 ps_sta_ao_timer;
+	u8 qos_info;
+	struct mwifiex_types_wmm_info wmm_info;
 };
 
 enum {
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 1b3cfc8..d717c98 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -890,6 +890,10 @@ void mwifiex_set_ht_params(struct mwifiex_private *priv,
 			   struct cfg80211_ap_settings *params);
 void mwifiex_set_uap_rates(struct mwifiex_uap_bss_param *bss_cfg,
 			   struct cfg80211_ap_settings *params);
+void
+mwifiex_set_wmm_params(struct mwifiex_private *priv,
+		       struct mwifiex_uap_bss_param *bss_cfg,
+		       struct cfg80211_ap_settings *params);
 
 /*
  * This function checks if the queuing is RA based or not.
diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
index 8dd7224..6e76a15 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -219,6 +219,7 @@ void mwifiex_set_sys_config_invalid_data(struct mwifiex_uap_bss_param *config)
 	config->rts_threshold = 0x7FFF;
 	config->frag_threshold = 0x7FFF;
 	config->retry_limit = 0x7F;
+	config->qos_info = 0xFF;
 }
 
 /* This function parses BSS related parameters from structure
@@ -297,6 +298,38 @@ mwifiex_uap_bss_wpa(u8 **tlv_buf, void *cmd_buf, u16 *param_size)
 	return;
 }
 
+/* This function parses WMM related parameters from cfg80211_ap_settings
+ * structure and updates bss_config structure.
+ */
+void
+mwifiex_set_wmm_params(struct mwifiex_private *priv,
+		       struct mwifiex_uap_bss_param *bss_cfg,
+		       struct cfg80211_ap_settings *params)
+{
+	const u8 *vendor_ie;
+	struct ieee_types_header *wmm_ie;
+	u8 wmm_oui[] = {0x00, 0x50, 0xf2, 0x02};
+
+	vendor_ie = cfg80211_find_vendor_ie(WLAN_OUI_MICROSOFT,
+					    WLAN_OUI_TYPE_MICROSOFT_WMM,
+					    params->beacon.tail,
+					    params->beacon.tail_len);
+	if (vendor_ie) {
+		wmm_ie = (struct ieee_types_header *)vendor_ie;
+		memcpy(&bss_cfg->wmm_info, wmm_ie + 1,
+		       sizeof(bss_cfg->wmm_info));
+		priv->wmm_enabled = 1;
+	} else {
+		memset(&bss_cfg->wmm_info, 0, sizeof(bss_cfg->wmm_info));
+		memcpy(&bss_cfg->wmm_info.oui, wmm_oui, sizeof(wmm_oui));
+		bss_cfg->wmm_info.subtype = MWIFIEX_WMM_SUBTYPE;
+		bss_cfg->wmm_info.version = MWIFIEX_WMM_VERSION;
+		priv->wmm_enabled = 0;
+	}
+
+	bss_cfg->qos_info = 0x00;
+	return;
+}
 /* This function parses BSS related parameters from structure
  * and prepares TLVs specific to WEP encryption.
  * These TLVs are appended to command buffer.
@@ -354,6 +387,7 @@ mwifiex_uap_bss_param_prepare(u8 *tlv, void *cmd_buf, u16 *param_size)
 	struct host_cmd_tlv_rates *tlv_rates;
 	struct host_cmd_tlv_ageout_timer *ao_timer, *ps_ao_timer;
 	struct mwifiex_ie_types_htcap *htcap;
+	struct mwifiex_ie_types_wmmcap *wmm_cap;
 	struct mwifiex_uap_bss_param *bss_cfg = cmd_buf;
 	int i;
 	u16 cmd_size = *param_size;
@@ -507,6 +541,16 @@ mwifiex_uap_bss_param_prepare(u8 *tlv, void *cmd_buf, u16 *param_size)
 		tlv += sizeof(struct mwifiex_ie_types_htcap);
 	}
 
+	if (bss_cfg->wmm_info.qos_info != 0xFF) {
+		wmm_cap = (struct mwifiex_ie_types_wmmcap *)tlv;
+		wmm_cap->header.type = cpu_to_le16(WLAN_EID_VENDOR_SPECIFIC);
+		wmm_cap->header.len = cpu_to_le16(sizeof(wmm_cap->wmm_info));
+		memcpy(&wmm_cap->wmm_info, &bss_cfg->wmm_info,
+		       sizeof(wmm_cap->wmm_info));
+		cmd_size += sizeof(struct mwifiex_ie_types_wmmcap);
+		tlv += sizeof(struct mwifiex_ie_types_wmmcap);
+	}
+
 	if (bss_cfg->sta_ao_timer) {
 		ao_timer = (struct host_cmd_tlv_ageout_timer *)tlv;
 		ao_timer->tlv.type = cpu_to_le16(TLV_TYPE_UAP_AO_TIMER);
-- 
1.7.0.2

