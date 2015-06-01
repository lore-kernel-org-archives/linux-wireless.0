Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:7795 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752504AbbFAMdt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 08:33:49 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t51CUM7e028423
	for <linux-wireless@vger.kernel.org>; Mon, 1 Jun 2015 05:33:48 -0700
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0b-0016f401.pphosted.com with ESMTP id 1urjjr0nef-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 01 Jun 2015 05:33:47 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCHv4 11/17] mwifiex: parse power constraint IE from Tail
Date: Mon, 1 Jun 2015 23:32:09 +0530
Message-ID: <1433181735-15712-12-git-send-email-patila@marvell.com> (sfid-20150601_150350_669572_00EA357B)
In-Reply-To: <1433181735-15712-1-git-send-email-patila@marvell.com>
References: <1433181735-15712-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support to parse power constraint IEs from
Tail buffer. This power constraint is then set to FW during
bss_config download.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |  3 +++
 drivers/net/wireless/mwifiex/fw.h       |  6 ++++++
 drivers/net/wireless/mwifiex/ioctl.h    |  1 +
 drivers/net/wireless/mwifiex/main.h     |  3 +++
 drivers/net/wireless/mwifiex/uap_cmd.c  | 27 +++++++++++++++++++++++++++
 5 files changed, 40 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 5274502..f14cad7 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1867,6 +1867,9 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 
 	mwifiex_set_wmm_params(priv, bss_cfg, params);
 
+	if (mwifiex_is_11h_active(priv))
+		mwifiex_set_tpc_params(priv, bss_cfg, params);
+
 	if (mwifiex_is_11h_active(priv) &&
 	    !cfg80211_chandef_dfs_required(wiphy, &params->chandef,
 					   priv->bss_mode)) {
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index bcf08c9..72f161e 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -128,6 +128,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 
 #define TLV_TYPE_UAP_SSID			0x0000
 #define TLV_TYPE_UAP_RATES			0x0001
+#define TLV_TYPE_PWR_CONSTRAINT			0x0020
 
 #define PROPRIETARY_TLV_BASE_ID                 0x0100
 #define TLV_TYPE_KEY_MATERIAL       (PROPRIETARY_TLV_BASE_ID + 0)
@@ -1780,6 +1781,11 @@ struct host_cmd_tlv_ageout_timer {
 	__le32 sta_ao_timer;
 } __packed;
 
+struct host_cmd_tlv_power_constraint {
+	struct mwifiex_ie_types_header header;
+	u8 constraint;
+} __packed;
+
 struct host_cmd_ds_version_ext {
 	u8 version_str_sel;
 	char version_str[128];
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index 6f11a25..4f0174c 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -113,6 +113,7 @@ struct mwifiex_uap_bss_param {
 	u32 sta_ao_timer;
 	u32 ps_sta_ao_timer;
 	u8 qos_info;
+	u8 power_constraint;
 	struct mwifiex_types_wmm_info wmm_info;
 };
 
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 837e610..d92c527 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1149,6 +1149,9 @@ void mwifiex_set_ht_params(struct mwifiex_private *priv,
 void mwifiex_set_vht_params(struct mwifiex_private *priv,
 			    struct mwifiex_uap_bss_param *bss_cfg,
 			    struct cfg80211_ap_settings *params);
+void mwifiex_set_tpc_params(struct mwifiex_private *priv,
+			    struct mwifiex_uap_bss_param *bss_cfg,
+			    struct cfg80211_ap_settings *params);
 void mwifiex_set_uap_rates(struct mwifiex_uap_bss_param *bss_cfg,
 			   struct cfg80211_ap_settings *params);
 void mwifiex_set_vht_width(struct mwifiex_private *priv,
diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
index 9510f1e..a62b43e 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -222,6 +222,23 @@ void mwifiex_set_vht_params(struct mwifiex_private *priv,
 	return;
 }
 
+/* This function updates 11ac related parameters from IE
+ * and sets them into bss_config structure.
+ */
+void mwifiex_set_tpc_params(struct mwifiex_private *priv,
+			    struct mwifiex_uap_bss_param *bss_cfg,
+			    struct cfg80211_ap_settings *params)
+{
+	const u8 *tpc_ie;
+
+	tpc_ie = cfg80211_find_ie(WLAN_EID_TPC_REQUEST, params->beacon.tail,
+				  params->beacon.tail_len);
+	if (tpc_ie)
+		bss_cfg->power_constraint = *(tpc_ie + 2);
+	else
+		bss_cfg->power_constraint = 0;
+}
+
 /* Enable VHT only when cfg80211_ap_settings has VHT IE.
  * Otherwise disable VHT.
  */
@@ -466,6 +483,7 @@ mwifiex_uap_bss_param_prepare(u8 *tlv, void *cmd_buf, u16 *param_size)
 	struct host_cmd_tlv_auth_type *auth_type;
 	struct host_cmd_tlv_rates *tlv_rates;
 	struct host_cmd_tlv_ageout_timer *ao_timer, *ps_ao_timer;
+	struct host_cmd_tlv_power_constraint *pwr_ct;
 	struct mwifiex_ie_types_htcap *htcap;
 	struct mwifiex_ie_types_wmmcap *wmm_cap;
 	struct mwifiex_uap_bss_param *bss_cfg = cmd_buf;
@@ -644,6 +662,15 @@ mwifiex_uap_bss_param_prepare(u8 *tlv, void *cmd_buf, u16 *param_size)
 		tlv += sizeof(*ao_timer);
 	}
 
+	if (bss_cfg->power_constraint) {
+		pwr_ct = (void *)tlv;
+		pwr_ct->header.type = cpu_to_le16(TLV_TYPE_PWR_CONSTRAINT);
+		pwr_ct->header.len = cpu_to_le16(sizeof(u8));
+		pwr_ct->constraint = bss_cfg->power_constraint;
+		cmd_size += sizeof(*pwr_ct);
+		tlv += sizeof(*pwr_ct);
+	}
+
 	if (bss_cfg->ps_sta_ao_timer) {
 		ps_ao_timer = (struct host_cmd_tlv_ageout_timer *)tlv;
 		ps_ao_timer->header.type =
-- 
1.8.1.4

