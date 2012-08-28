Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:53989 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751441Ab2H1Df0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2012 23:35:26 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/4] mwifiex: parse rate info for AP
Date: Mon, 27 Aug 2012 20:32:53 -0700
Message-Id: <1346124774-17701-3-git-send-email-bzhao@marvell.com> (sfid-20120828_054602_368723_07962067)
In-Reply-To: <1346124774-17701-1-git-send-email-bzhao@marvell.com>
References: <1346124774-17701-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch adds support for parsing rates from cfg80211_ap_settings
of start_ap handler. This in turn adds support for 11a and 11b phy
configurations.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    6 ++++-
 drivers/net/wireless/mwifiex/fw.h       |    6 ++++
 drivers/net/wireless/mwifiex/ioctl.h    |    7 ++++-
 drivers/net/wireless/mwifiex/main.h     |    7 ++---
 drivers/net/wireless/mwifiex/uap_cmd.c  |   39 ++++++++++++++++++++++++++++++-
 5 files changed, 58 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index e57f543..f7a06d2 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -969,15 +969,18 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 
 	bss_cfg->channel =
 	    (u8)ieee80211_frequency_to_channel(params->channel->center_freq);
-	bss_cfg->band_cfg = BAND_CONFIG_MANUAL;
 
 	/* Set appropriate bands */
 	if (params->channel->band == IEEE80211_BAND_2GHZ) {
+		bss_cfg->band_cfg = BAND_CONFIG_BG;
+
 		if (params->channel_type == NL80211_CHAN_NO_HT)
 			config_bands = BAND_B | BAND_G;
 		else
 			config_bands = BAND_B | BAND_G | BAND_GN;
 	} else {
+		bss_cfg->band_cfg = BAND_CONFIG_A;
+
 		if (params->channel_type == NL80211_CHAN_NO_HT)
 			config_bands = BAND_A;
 		else
@@ -988,6 +991,7 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 	      ~priv->adapter->fw_bands))
 		priv->adapter->config_bands = config_bands;
 
+	mwifiex_set_uap_rates(bss_cfg, params);
 	mwifiex_send_domain_info_cmd_fw(wiphy);
 
 	if (mwifiex_set_secure_params(priv, bss_cfg, params)) {
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index ae06f31..1a4a694 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -108,6 +108,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define MGMT_MASK_BEACON			0x100
 
 #define TLV_TYPE_UAP_SSID			0x0000
+#define TLV_TYPE_UAP_RATES			0x0001
 
 #define PROPRIETARY_TLV_BASE_ID                 0x0100
 #define TLV_TYPE_KEY_MATERIAL       (PROPRIETARY_TLV_BASE_ID + 0)
@@ -1284,6 +1285,11 @@ struct host_cmd_tlv_ssid {
 	u8 ssid[0];
 } __packed;
 
+struct host_cmd_tlv_rates {
+	struct host_cmd_tlv tlv;
+	u8 rates[0];
+} __packed;
+
 struct host_cmd_tlv_bcast_ssid {
 	struct host_cmd_tlv tlv;
 	u8 bcast_ctl;
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index 6a5eded..8688535 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -81,7 +81,11 @@ struct wep_key {
 
 #define KEY_MGMT_ON_HOST        0x03
 #define MWIFIEX_AUTH_MODE_AUTO  0xFF
-#define BAND_CONFIG_MANUAL      0x00
+#define BAND_CONFIG_BG          0x00
+#define BAND_CONFIG_A           0x01
+#define MWIFIEX_SUPPORTED_RATES                 14
+#define MWIFIEX_SUPPORTED_RATES_EXT             32
+
 struct mwifiex_uap_bss_param {
 	u8 channel;
 	u8 band_cfg;
@@ -100,6 +104,7 @@ struct mwifiex_uap_bss_param {
 	struct wpa_param wpa_cfg;
 	struct wep_key wep_cfg[NUM_WEP_KEYS];
 	struct ieee80211_ht_cap ht_cap;
+	u8 rates[MWIFIEX_SUPPORTED_RATES];
 };
 
 enum {
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 994bc4f..ede0c65 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -116,6 +116,7 @@ enum {
 #define MAX_BITMAP_RATES_SIZE			10
 
 #define MAX_CHANNEL_BAND_BG     14
+#define MAX_CHANNEL_BAND_A      165
 
 #define MAX_FREQUENCY_BAND_BG   2484
 
@@ -249,10 +250,6 @@ struct ieee_types_header {
 	u8 len;
 } __packed;
 
-#define MWIFIEX_SUPPORTED_RATES                 14
-
-#define MWIFIEX_SUPPORTED_RATES_EXT             32
-
 struct ieee_types_vendor_specific {
 	struct ieee_types_vendor_header vend_hdr;
 	u8 data[IEEE_MAX_IE_SIZE - sizeof(struct ieee_types_vendor_header)];
@@ -872,6 +869,8 @@ int mwifiex_set_secure_params(struct mwifiex_private *priv,
 void mwifiex_set_ht_params(struct mwifiex_private *priv,
 			   struct mwifiex_uap_bss_param *bss_cfg,
 			   struct cfg80211_ap_settings *params);
+void mwifiex_set_uap_rates(struct mwifiex_uap_bss_param *bss_cfg,
+			   struct cfg80211_ap_settings *params);
 
 /*
  * This function checks if the queuing is RA based or not.
diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
index c10aac0..8a627d8 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -177,6 +177,25 @@ mwifiex_set_ht_params(struct mwifiex_private *priv,
 	return;
 }
 
+/* This function finds supported rates IE from beacon parameter and sets
+ * these rates into bss_config structure.
+ */
+void
+mwifiex_set_uap_rates(struct mwifiex_uap_bss_param *bss_cfg,
+		      struct cfg80211_ap_settings *params)
+{
+	struct ieee_types_header *rate_ie;
+	int var_offset = offsetof(struct ieee80211_mgmt, u.beacon.variable);
+	const u8 *var_pos = params->beacon.head + var_offset;
+	int len = params->beacon.head_len - var_offset;
+
+	rate_ie = (void *)cfg80211_find_ie(WLAN_EID_SUPP_RATES, var_pos, len);
+	if (rate_ie)
+		memcpy(bss_cfg->rates, rate_ie + 1, rate_ie->len);
+
+	return;
+}
+
 /* This function initializes some of mwifiex_uap_bss_param variables.
  * This helps FW in ignoring invalid values. These values may or may not
  * be get updated to valid ones at later stage.
@@ -323,8 +342,10 @@ mwifiex_uap_bss_param_prepare(u8 *tlv, void *cmd_buf, u16 *param_size)
 	struct host_cmd_tlv_retry_limit *retry_limit;
 	struct host_cmd_tlv_encrypt_protocol *encrypt_protocol;
 	struct host_cmd_tlv_auth_type *auth_type;
+	struct host_cmd_tlv_rates *tlv_rates;
 	struct mwifiex_ie_types_htcap *htcap;
 	struct mwifiex_uap_bss_param *bss_cfg = cmd_buf;
+	int i;
 	u16 cmd_size = *param_size;
 
 	if (bss_cfg->ssid.ssid_len) {
@@ -344,7 +365,23 @@ mwifiex_uap_bss_param_prepare(u8 *tlv, void *cmd_buf, u16 *param_size)
 		cmd_size += sizeof(struct host_cmd_tlv_bcast_ssid);
 		tlv += sizeof(struct host_cmd_tlv_bcast_ssid);
 	}
-	if (bss_cfg->channel && bss_cfg->channel <= MAX_CHANNEL_BAND_BG) {
+	if (bss_cfg->rates[0]) {
+		tlv_rates = (struct host_cmd_tlv_rates *)tlv;
+		tlv_rates->tlv.type = cpu_to_le16(TLV_TYPE_UAP_RATES);
+
+		for (i = 0; i < MWIFIEX_SUPPORTED_RATES && bss_cfg->rates[i];
+		     i++)
+			tlv_rates->rates[i] = bss_cfg->rates[i];
+
+		tlv_rates->tlv.len = cpu_to_le16(i);
+		cmd_size += sizeof(struct host_cmd_tlv_rates) + i;
+		tlv += sizeof(struct host_cmd_tlv_rates) + i;
+	}
+	if (bss_cfg->channel &&
+	    ((bss_cfg->band_cfg == BAND_CONFIG_BG &&
+	      bss_cfg->channel <= MAX_CHANNEL_BAND_BG) ||
+	    (bss_cfg->band_cfg == BAND_CONFIG_A &&
+	     bss_cfg->channel <= MAX_CHANNEL_BAND_A))) {
 		chan_band = (struct host_cmd_tlv_channel_band *)tlv;
 		chan_band->tlv.type = cpu_to_le16(TLV_TYPE_CHANNELBANDLIST);
 		chan_band->tlv.len =
-- 
1.7.0.2

