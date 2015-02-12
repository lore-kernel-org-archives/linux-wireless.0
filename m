Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:22890 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755034AbbBLMq1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2015 07:46:27 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t1CChfEx030023
	for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2015 04:46:27 -0800
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0b-0016f401.pphosted.com with ESMTP id 1sfwqx466s-5
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2015 04:46:27 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	"Avinash Patil" <patila@marvell.com>
Subject: [PATCH 3/3] mwifiex: add cfg80211 set_mac_acl handler for AP mode
Date: Thu, 12 Feb 2015 23:45:54 +0530
Message-ID: <1423764954-30412-3-git-send-email-patila@marvell.com> (sfid-20150212_134632_496284_278A40DA)
In-Reply-To: <1423764954-30412-1-git-send-email-patila@marvell.com>
References: <1423764954-30412-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

This patch add cfg80211 set_mac_acl handler for AP mode, this handler
will be used by user space application to configure accept/deny mac
address list throgh nl80211/cfg80211.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 61 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/decl.h     |  5 +++
 drivers/net/wireless/mwifiex/fw.h       |  9 +++++
 drivers/net/wireless/mwifiex/ioctl.h    |  6 ++++
 drivers/net/wireless/mwifiex/uap_cmd.c  | 25 ++++++++++++++
 5 files changed, 106 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index f933159..d1a684a 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1621,6 +1621,64 @@ static int mwifiex_cfg80211_set_txq_params(struct wiphy *wiphy,
 	return 0;
 }
 
+/* cfg80211 operation handler for set_mac_acl.
+ * function sets station mac address filter params to FW.
+ */
+static int mwifiex_cfg80211_set_mac_acl(struct wiphy *wiphy,
+					struct net_device *dev,
+					const struct cfg80211_acl_data *params)
+{
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+	struct mwifiex_ds_mac_filter *mac_filter;
+
+	if (!priv || !params)
+		return -EINVAL;
+
+	if (GET_BSS_ROLE(priv) != MWIFIEX_BSS_ROLE_UAP) {
+		wiphy_err(wiphy, "%s: bss_type mismatched\n", __func__);
+		return -EINVAL;
+	}
+
+	mac_filter = kzalloc(sizeof(*mac_filter), GFP_KERNEL);
+	if (!mac_filter)
+		return -ENOMEM;
+
+	wiphy_dbg(wiphy, "set_mac_acl, n_acl_entries=%d, acl_policy=%d\n",
+		  params->n_acl_entries, params->acl_policy);
+
+	mac_filter->mac_count = (params->n_acl_entries <=
+				 MWIFIEX_MAX_MAC_FILTER_NUM) ?
+				 params->n_acl_entries :
+				 MWIFIEX_MAX_MAC_FILTER_NUM;
+
+	switch (params->acl_policy) {
+	case NL80211_ACL_POLICY_DENY_UNLESS_LISTED:
+		mac_filter->filter_mode = MWIFIEX_MAC_FILTER_MODE_ALLOW_MAC;
+		break;
+	case NL80211_ACL_POLICY_ACCEPT_UNLESS_LISTED:
+		mac_filter->filter_mode = MWIFIEX_MAC_FILTER_MODE_BLOCK_MAC;
+		break;
+	default:
+		wiphy_err(wiphy, "unknown ACL policy\n");
+		kfree(mac_filter);
+		return -EINVAL;
+	}
+
+	memcpy(mac_filter->mac_list, params->mac_addrs,
+	       sizeof(struct mac_address) * mac_filter->mac_count);
+
+	if (mwifiex_send_cmd(priv, HostCmd_CMD_UAP_SYS_CONFIG,
+			     HostCmd_ACT_GEN_SET,
+			     UAP_MAC_FILTER_I, mac_filter, false)) {
+		wiphy_err(wiphy, "Failed to set AP mac acl params\n");
+		kfree(mac_filter);
+		return -1;
+	}
+
+	kfree(mac_filter);
+	return 0;
+}
+
 /* cfg80211 operation handler for del_station.
  * Function deauthenticates station which value is provided in mac parameter.
  * If mac is NULL/broadcast, all stations in associated station list are
@@ -3374,6 +3432,7 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
 	.stop_ap = mwifiex_cfg80211_stop_ap,
 	.change_beacon = mwifiex_cfg80211_change_beacon,
 	.set_txq_params = mwifiex_cfg80211_set_txq_params,
+	.set_mac_acl = mwifiex_cfg80211_set_mac_acl,
 	.set_cqm_rssi_config = mwifiex_cfg80211_set_cqm_rssi_config,
 	.set_antenna = mwifiex_cfg80211_set_antenna,
 	.del_station = mwifiex_cfg80211_del_station,
@@ -3487,6 +3546,8 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 	wiphy->cipher_suites = mwifiex_cipher_suites;
 	wiphy->n_cipher_suites = ARRAY_SIZE(mwifiex_cipher_suites);
 
+	wiphy->max_acl_mac_addrs = MWIFIEX_MAX_MAC_FILTER_NUM;
+
 	ether_addr_copy(wiphy->perm_addr, adapter->perm_addr);
 	wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
 	wiphy->flags |= WIPHY_FLAG_HAVE_AP_SME |
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index 0059d6f..b364a2c 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -110,6 +110,11 @@
 
 #define MWIFIEX_A_BAND_START_FREQ	5000
 
+#define MWIFIEX_MAC_FILTER_MODE_DISABLE		0
+#define MWIFIEX_MAC_FILTER_MODE_ALLOW_MAC	1
+#define MWIFIEX_MAC_FILTER_MODE_BLOCK_MAC	2
+#define MWIFIEX_MAX_MAC_FILTER_NUM		16
+
 enum mwifiex_bss_type {
 	MWIFIEX_BSS_TYPE_STA = 0,
 	MWIFIEX_BSS_TYPE_UAP = 1,
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 2a38964..408c1eb 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -117,6 +117,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define UAP_BSS_PARAMS_I			0
 #define UAP_CUSTOM_IE_I				1
 #define UAP_WMM_PARAMS_I				2
+#define UAP_MAC_FILTER_I				3
 #define MWIFIEX_AUTO_IDX_MASK			0xffff
 #define MWIFIEX_DELETE_MASK			0x0000
 #define MGMT_MASK_ASSOC_REQ			0x01
@@ -148,6 +149,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define TLV_TYPE_UAP_DTIM_PERIOD    (PROPRIETARY_TLV_BASE_ID + 45)
 #define TLV_TYPE_UAP_BCAST_SSID     (PROPRIETARY_TLV_BASE_ID + 48)
 #define TLV_TYPE_UAP_RTS_THRESHOLD  (PROPRIETARY_TLV_BASE_ID + 51)
+#define TLV_TYPE_UAP_MAC_FILTER     (PROPRIETARY_TLV_BASE_ID + 56)
 #define TLV_TYPE_UAP_AO_TIMER       (PROPRIETARY_TLV_BASE_ID + 57)
 #define TLV_TYPE_UAP_WEP_KEY        (PROPRIETARY_TLV_BASE_ID + 59)
 #define TLV_TYPE_UAP_WPA_PASSPHRASE (PROPRIETARY_TLV_BASE_ID + 60)
@@ -1553,6 +1555,13 @@ struct mwifiex_ie_types_wmmcap {
 	struct mwifiex_types_wmm_info wmm_info;
 } __packed;
 
+struct mwifiex_ie_types_mac_filter {
+	struct mwifiex_ie_types_header header;
+	u8 filter_mode;
+	u8 mac_count;
+	u8 mac_list[0];
+} __packed;
+
 struct mwifiex_ie_types_htinfo {
 	struct mwifiex_ie_types_header header;
 	struct ieee80211_ht_operation ht_oper;
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index 9795220..4d51775 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -402,6 +402,12 @@ struct mwifiex_ds_mef_cfg {
 	struct mwifiex_mef_entry *mef_entry;
 };
 
+struct mwifiex_ds_mac_filter {
+	u8 filter_mode;
+	u8 mac_count;
+	struct mac_address mac_list[MWIFIEX_MAX_MAC_FILTER_NUM];
+};
+
 #define MWIFIEX_MAX_VSIE_LEN       (256)
 #define MWIFIEX_MAX_VSIE_NUM       (8)
 #define MWIFIEX_VSIE_MASK_CLEAR    0x00
diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
index 82e4797..0cffcb9 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -677,6 +677,27 @@ static int mwifiex_uap_wmm_ie_prepare(u8 *tlv, void *cmd_buf, u16 *cmd_size)
 	return 0;
 }
 
+/* This function prepare mac address filter tlv */
+static int
+mwifiex_uap_mac_filter_prepare(u8 *tlv, void *cmd_buf, u16 *cmd_size)
+{
+	struct mwifiex_ds_mac_filter *mac_acl  = cmd_buf;
+	struct mwifiex_ie_types_mac_filter *mac_filter = (void *)tlv;
+
+	mac_filter->header.type = cpu_to_le16(TLV_TYPE_UAP_MAC_FILTER);
+	mac_filter->filter_mode = mac_acl->filter_mode;
+	mac_filter->mac_count = mac_acl->mac_count;
+	memcpy(&mac_filter->mac_list, mac_acl->mac_list,
+	       ETH_ALEN * mac_filter->mac_count);
+	mac_filter->header.len =
+		cpu_to_le16(sizeof(mac_filter->filter_mode) +
+			    sizeof(mac_filter->mac_count) +
+			    ETH_ALEN * mac_filter->mac_count);
+	*cmd_size += sizeof(*mac_filter) + ETH_ALEN * mac_filter->mac_count;
+
+	return 0;
+}
+
 /* This function parses custom IEs from IE list and prepares command buffer */
 static int mwifiex_uap_custom_ie_prepare(u8 *tlv, void *cmd_buf, u16 *ie_size)
 {
@@ -732,6 +753,10 @@ mwifiex_cmd_uap_sys_config(struct host_cmd_ds_command *cmd, u16 cmd_action,
 		mwifiex_uap_wmm_ie_prepare(tlv, cmd_buf, &cmd_size);
 		cmd->size = cpu_to_le16(cmd_size);
 		break;
+	case UAP_MAC_FILTER_I:
+		mwifiex_uap_mac_filter_prepare(tlv, cmd_buf, &cmd_size);
+		cmd->size = cpu_to_le16(cmd_size);
+		break;
 	default:
 		return -1;
 	}
-- 
1.8.1.4

