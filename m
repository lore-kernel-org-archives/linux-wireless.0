Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:34811 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751410Ab2IZDbk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2012 23:31:40 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Bing Zhao <bzhao@marvell.com>, Kevin Gan <ganhy@marvell.com>
Subject: [PATCH 15/15] mwifiex: add inactivity deauth support for ap
Date: Tue, 25 Sep 2012 20:23:45 -0700
Message-Id: <1348629825-12001-16-git-send-email-bzhao@marvell.com> (sfid-20120926_053142_961473_228EE52E)
In-Reply-To: <1348629825-12001-1-git-send-email-bzhao@marvell.com>
References: <1348629825-12001-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kevin Gan <ganhy@marvell.com>

The firmware has support for this feature, so we offload it to
firmware. In start_ap, driver passes the inactivity timeout
value to firmware via TLVs and firmware will report STA_DEAUTH
event to driver when inactivity timer is fired.

Signed-off-by: Kevin Gan <ganhy@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    9 ++++++++-
 drivers/net/wireless/mwifiex/fw.h       |    7 +++++++
 drivers/net/wireless/mwifiex/ioctl.h    |    2 ++
 drivers/net/wireless/mwifiex/uap_cmd.c  |   22 ++++++++++++++++++++++
 4 files changed, 39 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 94ac40c..2691620 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1331,6 +1331,12 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 
 	mwifiex_set_ht_params(priv, bss_cfg, params);
 
+	if (params->inactivity_timeout > 0) {
+		/* sta_ao_timer/ps_sta_ao_timer is in unit of 100ms */
+		bss_cfg->sta_ao_timer = 10 * params->inactivity_timeout;
+		bss_cfg->ps_sta_ao_timer = 10 * params->inactivity_timeout;
+	}
+
 	if (mwifiex_send_cmd_sync(priv, HostCmd_CMD_UAP_BSS_STOP,
 				  HostCmd_ACT_GEN_SET, 0, NULL)) {
 		wiphy_err(wiphy, "Failed to stop the BSS\n");
@@ -2229,7 +2235,8 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 	wiphy->available_antennas_tx = BIT(adapter->number_of_antenna) - 1;
 	wiphy->available_antennas_rx = BIT(adapter->number_of_antenna) - 1;
 
-	wiphy->features = NL80211_FEATURE_HT_IBSS;
+	wiphy->features = NL80211_FEATURE_HT_IBSS |
+			  NL80211_FEATURE_INACTIVITY_TIMER;
 
 	/* Reserve space for mwifiex specific private data for BSS */
 	wiphy->bss_priv_size = sizeof(struct mwifiex_bss_priv);
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 857af0f..dda588b 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -128,6 +128,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define TLV_TYPE_UAP_DTIM_PERIOD    (PROPRIETARY_TLV_BASE_ID + 45)
 #define TLV_TYPE_UAP_BCAST_SSID     (PROPRIETARY_TLV_BASE_ID + 48)
 #define TLV_TYPE_UAP_RTS_THRESHOLD  (PROPRIETARY_TLV_BASE_ID + 51)
+#define TLV_TYPE_UAP_AO_TIMER       (PROPRIETARY_TLV_BASE_ID + 57)
 #define TLV_TYPE_UAP_WEP_KEY        (PROPRIETARY_TLV_BASE_ID + 59)
 #define TLV_TYPE_UAP_WPA_PASSPHRASE (PROPRIETARY_TLV_BASE_ID + 60)
 #define TLV_TYPE_UAP_ENCRY_PROTOCOL (PROPRIETARY_TLV_BASE_ID + 64)
@@ -142,6 +143,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define TLV_TYPE_MGMT_IE            (PROPRIETARY_TLV_BASE_ID + 105)
 #define TLV_TYPE_AUTO_DS_PARAM      (PROPRIETARY_TLV_BASE_ID + 113)
 #define TLV_TYPE_PS_PARAM           (PROPRIETARY_TLV_BASE_ID + 114)
+#define TLV_TYPE_UAP_PS_AO_TIMER    (PROPRIETARY_TLV_BASE_ID + 123)
 #define TLV_TYPE_PWK_CIPHER         (PROPRIETARY_TLV_BASE_ID + 145)
 #define TLV_TYPE_GWK_CIPHER         (PROPRIETARY_TLV_BASE_ID + 146)
 
@@ -1344,6 +1346,11 @@ struct host_cmd_tlv_channel_band {
 	u8 channel;
 } __packed;
 
+struct host_cmd_tlv_ageout_timer {
+	struct host_cmd_tlv tlv;
+	__le32 sta_ao_timer;
+} __packed;
+
 struct host_cmd_ds_version_ext {
 	u8 version_str_sel;
 	char version_str[128];
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index 8688535..4e31c60 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -105,6 +105,8 @@ struct mwifiex_uap_bss_param {
 	struct wep_key wep_cfg[NUM_WEP_KEYS];
 	struct ieee80211_ht_cap ht_cap;
 	u8 rates[MWIFIEX_SUPPORTED_RATES];
+	u32 sta_ao_timer;
+	u32 ps_sta_ao_timer;
 };
 
 enum {
diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
index 8a627d8..d95a2d5 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -343,6 +343,7 @@ mwifiex_uap_bss_param_prepare(u8 *tlv, void *cmd_buf, u16 *param_size)
 	struct host_cmd_tlv_encrypt_protocol *encrypt_protocol;
 	struct host_cmd_tlv_auth_type *auth_type;
 	struct host_cmd_tlv_rates *tlv_rates;
+	struct host_cmd_tlv_ageout_timer *ao_timer, *ps_ao_timer;
 	struct mwifiex_ie_types_htcap *htcap;
 	struct mwifiex_uap_bss_param *bss_cfg = cmd_buf;
 	int i;
@@ -497,6 +498,27 @@ mwifiex_uap_bss_param_prepare(u8 *tlv, void *cmd_buf, u16 *param_size)
 		tlv += sizeof(struct mwifiex_ie_types_htcap);
 	}
 
+	if (bss_cfg->sta_ao_timer) {
+		ao_timer = (struct host_cmd_tlv_ageout_timer *)tlv;
+		ao_timer->tlv.type = cpu_to_le16(TLV_TYPE_UAP_AO_TIMER);
+		ao_timer->tlv.len = cpu_to_le16(sizeof(*ao_timer) -
+						sizeof(struct host_cmd_tlv));
+		ao_timer->sta_ao_timer = cpu_to_le32(bss_cfg->sta_ao_timer);
+		cmd_size += sizeof(*ao_timer);
+		tlv += sizeof(*ao_timer);
+	}
+
+	if (bss_cfg->ps_sta_ao_timer) {
+		ps_ao_timer = (struct host_cmd_tlv_ageout_timer *)tlv;
+		ps_ao_timer->tlv.type = cpu_to_le16(TLV_TYPE_UAP_PS_AO_TIMER);
+		ps_ao_timer->tlv.len = cpu_to_le16(sizeof(*ps_ao_timer) -
+						   sizeof(struct host_cmd_tlv));
+		ps_ao_timer->sta_ao_timer =
+					cpu_to_le32(bss_cfg->ps_sta_ao_timer);
+		cmd_size += sizeof(*ps_ao_timer);
+		tlv += sizeof(*ps_ao_timer);
+	}
+
 	*param_size = cmd_size;
 
 	return 0;
-- 
1.7.0.2

