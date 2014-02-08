Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:30314 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751223AbaBHAbC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 19:31:02 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 21/30] mwifiex: add cfg80211 change_station handler support
Date: Fri, 7 Feb 2014 16:30:34 -0800
Message-ID: <1391819442-21239-2-git-send-email-bzhao@marvell.com> (sfid-20140208_020007_772982_28B08A20)
In-Reply-To: <1391819442-21239-1-git-send-email-bzhao@marvell.com>
References: <1391819442-21239-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch adds cfg80211 change_station handler support for mwifiex
which is needed for TDLS link setup. Driver creates a command to
modify peer link capabilities and issues command to FW.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c    | 25 +++++++++++
 drivers/net/wireless/mwifiex/fw.h          |  5 +++
 drivers/net/wireless/mwifiex/main.h        |  1 +
 drivers/net/wireless/mwifiex/sta_cmd.c     | 71 +++++++++++++++++++++++++++++-
 drivers/net/wireless/mwifiex/sta_cmdresp.c | 13 ++++++
 drivers/net/wireless/mwifiex/tdls.c        | 23 ++++++++++
 6 files changed, 137 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index a29606a..9a9e25a 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2732,6 +2732,30 @@ mwifiex_cfg80211_add_station(struct wiphy *wiphy,
 	return mwifiex_tdls_oper(priv, mac, MWIFIEX_TDLS_CREATE_LINK);
 }
 
+static int
+mwifiex_cfg80211_change_station(struct wiphy *wiphy,
+				struct net_device *dev,
+				u8 *mac, struct station_parameters *params)
+{
+	int ret;
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+
+	/* we support change_station handler only for TDLS peers*/
+	if (!(params->sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER)))
+		return -ENOTSUPP;
+
+	/* make sure we are in station mode and connected */
+	if ((priv->bss_type != MWIFIEX_BSS_TYPE_STA) || !priv->media_connected)
+		return -ENOTSUPP;
+
+	priv->sta_params = params;
+
+	ret = mwifiex_tdls_oper(priv, mac, MWIFIEX_TDLS_CONFIG_LINK);
+	priv->sta_params = NULL;
+
+	return ret;
+}
+
 /* station cfg80211 operations */
 static struct cfg80211_ops mwifiex_cfg80211_ops = {
 	.add_virtual_intf = mwifiex_add_virtual_intf,
@@ -2770,6 +2794,7 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
 	.tdls_mgmt = mwifiex_cfg80211_tdls_mgmt,
 	.tdls_oper = mwifiex_cfg80211_tdls_oper,
 	.add_station = mwifiex_cfg80211_add_station,
+	.change_station = mwifiex_cfg80211_change_station,
 };
 
 #ifdef CONFIG_PM
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 3180fc6..8c119bc 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -1391,6 +1391,11 @@ struct mwifiex_ie_types_extcap {
 	u8 ext_capab[0];
 } __packed;
 
+struct mwifiex_ie_types_qos_info {
+	struct mwifiex_ie_types_header header;
+	u8 qos_info;
+} __packed;
+
 struct host_cmd_ds_mac_reg_access {
 	__le16 action;
 	__le16 offset;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 69f8e72..fe26ff3 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -529,6 +529,7 @@ struct mwifiex_private {
 	unsigned long csa_expire_time;
 	u8 del_list_idx;
 	bool hs2_enabled;
+	struct station_parameters *sta_params;
 };
 
 enum mwifiex_ba_status {
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 1e36fa7..8f1bcc3 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -1288,14 +1288,24 @@ mwifiex_cmd_tdls_oper(struct mwifiex_private *priv,
 	struct host_cmd_ds_tdls_oper *tdls_oper = &cmd->params.tdls_oper;
 	struct mwifiex_ds_tdls_oper *oper = data_buf;
 	struct mwifiex_sta_node *sta_ptr;
+	struct host_cmd_tlv_rates *tlv_rates;
+	struct mwifiex_ie_types_htcap *ht_capab;
+	struct mwifiex_ie_types_qos_info *wmm_qos_info;
+	struct mwifiex_ie_types_extcap *extcap;
+	u8 *pos, qos_info;
+	u16 config_len = 0;
+	struct station_parameters *params = priv->sta_params;
 
 	cmd->command = cpu_to_le16(HostCmd_CMD_TDLS_OPER);
 	cmd->size = cpu_to_le16(S_DS_GEN);
+	le16_add_cpu(&cmd->size, sizeof(struct host_cmd_ds_tdls_oper));
 
 	tdls_oper->reason = 0;
 	memcpy(tdls_oper->peer_mac, oper->peer_mac, ETH_ALEN);
 	sta_ptr = mwifiex_get_sta_entry(priv, oper->peer_mac);
 
+	pos = (u8 *)tdls_oper + sizeof(struct host_cmd_ds_tdls_oper);
+
 	switch (oper->tdls_action) {
 	case MWIFIEX_TDLS_DISABLE_LINK:
 		tdls_oper->tdls_action = cpu_to_le16(ACT_TDLS_DELETE);
@@ -1303,12 +1313,71 @@ mwifiex_cmd_tdls_oper(struct mwifiex_private *priv,
 	case MWIFIEX_TDLS_CREATE_LINK:
 		tdls_oper->tdls_action = cpu_to_le16(ACT_TDLS_CREATE);
 		break;
+	case MWIFIEX_TDLS_CONFIG_LINK:
+		tdls_oper->tdls_action = cpu_to_le16(ACT_TDLS_CONFIG);
+
+		if (!params) {
+			dev_err(priv->adapter->dev,
+				"TDLS config params not available for %pM\n",
+				oper->peer_mac);
+			return -ENODATA;
+		}
+
+		*(__le16 *)pos = cpu_to_le16(params->capability);
+		config_len += sizeof(params->capability);
+
+		qos_info = params->uapsd_queues | (params->max_sp << 5);
+		wmm_qos_info = (struct mwifiex_ie_types_qos_info *)(pos +
+								    config_len);
+		wmm_qos_info->header.type = cpu_to_le16(WLAN_EID_QOS_CAPA);
+		wmm_qos_info->header.len = cpu_to_le16(sizeof(qos_info));
+		wmm_qos_info->qos_info = qos_info;
+		config_len += sizeof(struct mwifiex_ie_types_qos_info);
+
+		if (params->ht_capa) {
+			ht_capab = (struct mwifiex_ie_types_htcap *)(pos +
+								    config_len);
+			ht_capab->header.type =
+					    cpu_to_le16(WLAN_EID_HT_CAPABILITY);
+			ht_capab->header.len =
+				   cpu_to_le16(sizeof(struct ieee80211_ht_cap));
+			memcpy(&ht_capab->ht_cap, params->ht_capa,
+			       sizeof(struct ieee80211_ht_cap));
+			config_len += sizeof(struct mwifiex_ie_types_htcap);
+		}
+
+		if (params->supported_rates && params->supported_rates_len) {
+			tlv_rates = (struct host_cmd_tlv_rates *)(pos +
+								  config_len);
+			tlv_rates->header.type =
+					       cpu_to_le16(WLAN_EID_SUPP_RATES);
+			tlv_rates->header.len =
+				       cpu_to_le16(params->supported_rates_len);
+			memcpy(tlv_rates->rates, params->supported_rates,
+			       params->supported_rates_len);
+			config_len += sizeof(struct host_cmd_tlv_rates) +
+				      params->supported_rates_len;
+		}
+
+		if (params->ext_capab && params->ext_capab_len) {
+			extcap = (struct mwifiex_ie_types_extcap *)(pos +
+								    config_len);
+			extcap->header.type =
+					   cpu_to_le16(WLAN_EID_EXT_CAPABILITY);
+			extcap->header.len = cpu_to_le16(params->ext_capab_len);
+			memcpy(extcap->ext_capab, params->ext_capab,
+			       params->ext_capab_len);
+			config_len += sizeof(struct mwifiex_ie_types_extcap) +
+				      params->ext_capab_len;
+		}
+
+		break;
 	default:
 		dev_err(priv->adapter->dev, "Unknown TDLS operation\n");
 		return -ENOTSUPP;
 	}
 
-	le16_add_cpu(&cmd->size, sizeof(struct host_cmd_ds_tdls_oper));
+	le16_add_cpu(&cmd->size, config_len);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 396b936..48abab6 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -834,6 +834,19 @@ static int mwifiex_ret_tdls_oper(struct mwifiex_private *priv,
 				cmd_tdls_oper->peer_mac);
 		}
 		break;
+	case ACT_TDLS_CONFIG:
+		if (reason) {
+			dev_err(priv->adapter->dev,
+				"TDLS link config for %pM failed, reason %d\n",
+				cmd_tdls_oper->peer_mac, reason);
+			if (node)
+				node->tdls_status = TDLS_SETUP_FAILURE;
+		} else {
+			dev_dbg(priv->adapter->dev,
+				"TDLS link config for %pM successful\n",
+				cmd_tdls_oper->peer_mac);
+		}
+		break;
 	default:
 		dev_err(priv->adapter->dev,
 			"Unknown TDLS command action respnse %d", action);
diff --git a/drivers/net/wireless/mwifiex/tdls.c b/drivers/net/wireless/mwifiex/tdls.c
index 1d5ed70..f37862b 100644
--- a/drivers/net/wireless/mwifiex/tdls.c
+++ b/drivers/net/wireless/mwifiex/tdls.c
@@ -544,6 +544,27 @@ void mwifiex_process_tdls_action_frame(struct mwifiex_private *priv,
 }
 
 static int
+mwifiex_tdls_process_config_link(struct mwifiex_private *priv, u8 *peer)
+{
+	struct mwifiex_sta_node *sta_ptr;
+	struct mwifiex_ds_tdls_oper tdls_oper;
+
+	memset(&tdls_oper, 0, sizeof(struct mwifiex_ds_tdls_oper));
+	sta_ptr = mwifiex_get_sta_entry(priv, peer);
+
+	if (!sta_ptr || sta_ptr->tdls_status == TDLS_SETUP_FAILURE) {
+		dev_err(priv->adapter->dev,
+			"link absent for peer %pM; cannot config\n", peer);
+		return -EINVAL;
+	}
+
+	memcpy(&tdls_oper.peer_mac, peer, ETH_ALEN);
+	tdls_oper.tdls_action = MWIFIEX_TDLS_CONFIG_LINK;
+	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_TDLS_OPER,
+				     HostCmd_ACT_GEN_SET, 0, &tdls_oper);
+}
+
+static int
 mwifiex_tdls_process_create_link(struct mwifiex_private *priv, u8 *peer)
 {
 	struct mwifiex_sta_node *sta_ptr;
@@ -662,6 +683,8 @@ int mwifiex_tdls_oper(struct mwifiex_private *priv, u8 *peer, u8 action)
 		return mwifiex_tdls_process_disable_link(priv, peer);
 	case MWIFIEX_TDLS_CREATE_LINK:
 		return mwifiex_tdls_process_create_link(priv, peer);
+	case MWIFIEX_TDLS_CONFIG_LINK:
+		return mwifiex_tdls_process_config_link(priv, peer);
 	}
 	return 0;
 }
-- 
1.8.2.3

