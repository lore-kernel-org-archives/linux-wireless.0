Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:4463 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753374AbaBDAkf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 19:40:35 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 19/30] mwifiex: add cfg80211 tdls_oper handler support
Date: Mon, 3 Feb 2014 16:40:03 -0800
Message-ID: <1391474403-8060-9-git-send-email-bzhao@marvell.com> (sfid-20140204_014040_080309_FC653E77)
In-Reply-To: <1391474403-8060-1-git-send-email-bzhao@marvell.com>
References: <1391474403-8060-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch adds cfg80211 handler tdls_oper handler support to
mwifiex. Upon enable link, driver sets status as TDLS status as
setup complete and also sets AMSDU size, AMPDU params for direct
link. Upon disable link, driver issues command to FW to delete
this link in FW.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c    | 49 +++++++++++++++
 drivers/net/wireless/mwifiex/decl.h        | 14 +++++
 drivers/net/wireless/mwifiex/fw.h          | 12 ++++
 drivers/net/wireless/mwifiex/ioctl.h       | 12 ++++
 drivers/net/wireless/mwifiex/main.h        |  2 +
 drivers/net/wireless/mwifiex/sta_cmd.c     | 32 ++++++++++
 drivers/net/wireless/mwifiex/sta_cmdresp.c | 28 +++++++++
 drivers/net/wireless/mwifiex/tdls.c        | 96 ++++++++++++++++++++++++++++++
 8 files changed, 245 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 53e5874..4b52842 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2667,6 +2667,54 @@ mwifiex_cfg80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	return ret;
 }
 
+static int
+mwifiex_cfg80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
+			   u8 *peer, enum nl80211_tdls_operation action)
+{
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+
+	if (!(wiphy->flags & WIPHY_FLAG_SUPPORTS_TDLS) ||
+	    !(wiphy->flags & WIPHY_FLAG_TDLS_EXTERNAL_SETUP))
+		return -ENOTSUPP;
+
+	/* make sure we are in station mode and connected */
+	if (!(priv->bss_type == MWIFIEX_BSS_TYPE_STA && priv->media_connected))
+		return -ENOTSUPP;
+
+	dev_dbg(priv->adapter->dev,
+		"TDLS peer=%pM, oper=%d\n", peer, action);
+
+	switch (action) {
+	case NL80211_TDLS_ENABLE_LINK:
+		action = MWIFIEX_TDLS_ENABLE_LINK;
+		break;
+	case NL80211_TDLS_DISABLE_LINK:
+		action = MWIFIEX_TDLS_DISABLE_LINK;
+		break;
+	case NL80211_TDLS_TEARDOWN:
+		/* shouldn't happen!*/
+		dev_warn(priv->adapter->dev,
+			 "tdls_oper: teardown from driver not supported\n");
+		return -EINVAL;
+	case NL80211_TDLS_SETUP:
+		/* shouldn't happen!*/
+		dev_warn(priv->adapter->dev,
+			 "tdls_oper: setup from driver not supported\n");
+		return -EINVAL;
+	case NL80211_TDLS_DISCOVERY_REQ:
+		/* shouldn't happen!*/
+		dev_warn(priv->adapter->dev,
+			 "tdls_oper: discovery from driver not supported\n");
+		return -EINVAL;
+	default:
+		dev_err(priv->adapter->dev,
+			"tdls_oper: operation not supported\n");
+		return -ENOTSUPP;
+	}
+
+	return mwifiex_tdls_oper(priv, peer, action);
+}
+
 /* station cfg80211 operations */
 static struct cfg80211_ops mwifiex_cfg80211_ops = {
 	.add_virtual_intf = mwifiex_add_virtual_intf,
@@ -2703,6 +2751,7 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
 #endif
 	.set_coalesce = mwifiex_cfg80211_set_coalesce,
 	.tdls_mgmt = mwifiex_cfg80211_tdls_mgmt,
+	.tdls_oper = mwifiex_cfg80211_tdls_oper,
 };
 
 #ifdef CONFIG_PM
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index efcd1b8..e7b3e16 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -80,6 +80,11 @@
 #define MWIFIEX_BRIDGED_PKTS_THR_HIGH      1024
 #define MWIFIEX_BRIDGED_PKTS_THR_LOW        128
 
+#define MWIFIEX_TDLS_DISABLE_LINK             0x00
+#define MWIFIEX_TDLS_ENABLE_LINK              0x01
+#define MWIFIEX_TDLS_CREATE_LINK              0x02
+#define MWIFIEX_TDLS_CONFIG_LINK              0x03
+
 enum mwifiex_bss_type {
 	MWIFIEX_BSS_TYPE_STA = 0,
 	MWIFIEX_BSS_TYPE_UAP = 1,
@@ -101,6 +106,15 @@ enum mwifiex_tdls_status {
 	TDLS_LINK_TEARDOWN,
 };
 
+enum mwifiex_tdls_error_code {
+	TDLS_ERR_NO_ERROR = 0,
+	TDLS_ERR_INTERNAL_ERROR,
+	TDLS_ERR_MAX_LINKS_EST,
+	TDLS_ERR_LINK_EXISTS,
+	TDLS_ERR_LINK_NONEXISTENT,
+	TDLS_ERR_PEER_STA_UNREACHABLE = 25,
+};
+
 #define BSS_ROLE_BIT_MASK    BIT(0)
 
 #define GET_BSS_ROLE(priv)   ((priv)->bss_role & BSS_ROLE_BIT_MASK)
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 416518a..3180fc6 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -316,6 +316,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define HostCmd_CMD_MGMT_FRAME_REG                    0x010c
 #define HostCmd_CMD_REMAIN_ON_CHAN                    0x010d
 #define HostCmd_CMD_11AC_CFG			      0x0112
+#define HostCmd_CMD_TDLS_OPER                         0x0122
 
 #define PROTOCOL_NO_SECURITY        0x01
 #define PROTOCOL_STATIC_WEP         0x02
@@ -486,6 +487,10 @@ enum P2P_MODES {
 #define MWIFIEX_CRITERIA_UNICAST	BIT(1)
 #define MWIFIEX_CRITERIA_MULTICAST	BIT(3)
 
+#define ACT_TDLS_DELETE            0x00
+#define ACT_TDLS_CREATE            0x01
+#define ACT_TDLS_CONFIG            0x02
+
 struct mwifiex_ie_types_header {
 	__le16 type;
 	__le16 len;
@@ -1066,6 +1071,12 @@ struct host_cmd_ds_rf_ant_siso {
 	__le16 ant_mode;
 };
 
+struct host_cmd_ds_tdls_oper {
+	__le16 tdls_action;
+	__le16 reason;
+	u8 peer_mac[ETH_ALEN];
+} __packed;
+
 struct mwifiex_fixed_bcn_param {
 	__le64 timestamp;
 	__le16 beacon_period;
@@ -1726,6 +1737,7 @@ struct host_cmd_ds_command {
 		struct host_cmd_ds_sta_deauth sta_deauth;
 		struct host_cmd_11ac_vht_cfg vht_cfg;
 		struct host_cmd_ds_coalesce_cfg coalesce_cfg;
+		struct host_cmd_ds_tdls_oper tdls_oper;
 	} params;
 } __packed;
 
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index fe12274..6ed1e13 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -435,4 +435,16 @@ struct mwifiex_ds_coalesce_cfg {
 	struct mwifiex_coalesce_rule rule[MWIFIEX_COALESCE_MAX_RULES];
 };
 
+struct mwifiex_ds_tdls_oper {
+	u16 tdls_action;
+	u8 peer_mac[ETH_ALEN];
+	u16 capability;
+	u8 qos_info;
+	u8 *ext_capab;
+	u8 ext_capab_len;
+	u8 *supp_rates;
+	u8 supp_rates_len;
+	u8 *ht_capab;
+};
+
 #endif /* !_MWIFIEX_IOCTL_H_ */
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index fd0f3b5..69f8e72 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -617,6 +617,7 @@ struct mwifiex_sta_node {
 	u8 ampdu_sta[MAX_NUM_TID];
 	u16 rx_seq[MAX_NUM_TID];
 	u16 max_amsdu;
+	u8 tdls_status;
 	struct mwifiex_tdls_capab tdls_cap;
 };
 
@@ -1209,6 +1210,7 @@ int mwifiex_send_tdls_action_frame(struct mwifiex_private *priv,
 				 size_t extra_ies_len);
 void mwifiex_process_tdls_action_frame(struct mwifiex_private *priv,
 				       u8 *buf, int len);
+int mwifiex_tdls_oper(struct mwifiex_private *priv, u8 *peer, u8 action);
 
 #ifdef CONFIG_DEBUG_FS
 void mwifiex_debugfs_init(void);
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 1b29912..4559f84 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -1280,6 +1280,35 @@ mwifiex_cmd_coalesce_cfg(struct mwifiex_private *priv,
 	return 0;
 }
 
+static int
+mwifiex_cmd_tdls_oper(struct mwifiex_private *priv,
+		      struct host_cmd_ds_command *cmd,
+		      void *data_buf)
+{
+	struct host_cmd_ds_tdls_oper *tdls_oper = &cmd->params.tdls_oper;
+	struct mwifiex_ds_tdls_oper *oper = data_buf;
+	struct mwifiex_sta_node *sta_ptr;
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_TDLS_OPER);
+	cmd->size = cpu_to_le16(S_DS_GEN);
+
+	tdls_oper->reason = 0;
+	memcpy(tdls_oper->peer_mac, oper->peer_mac, ETH_ALEN);
+	sta_ptr = mwifiex_get_sta_entry(priv, oper->peer_mac);
+
+	switch (oper->tdls_action) {
+	case MWIFIEX_TDLS_DISABLE_LINK:
+		tdls_oper->tdls_action = cpu_to_le16(ACT_TDLS_DELETE);
+		break;
+	default:
+		dev_err(priv->adapter->dev, "Unknown TDLS operation\n");
+		return -ENOTSUPP;
+	}
+
+	le16_add_cpu(&cmd->size, sizeof(struct host_cmd_ds_tdls_oper));
+
+	return 0;
+}
 /*
  * This function prepares the commands before sending them to the firmware.
  *
@@ -1510,6 +1539,9 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 		ret = mwifiex_cmd_coalesce_cfg(priv, cmd_ptr, cmd_action,
 					       data_buf);
 		break;
+	case HostCmd_CMD_TDLS_OPER:
+		ret = mwifiex_cmd_tdls_oper(priv, cmd_ptr, data_buf);
+		break;
 	default:
 		dev_err(priv->adapter->dev,
 			"PREP_CMD: unknown cmd- %#x\n", cmd_no);
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 857fa69..f41a1f1 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -802,7 +802,32 @@ static int mwifiex_ret_ibss_coalescing_status(struct mwifiex_private *priv,
 
 	return 0;
 }
+static int mwifiex_ret_tdls_oper(struct mwifiex_private *priv,
+				 struct host_cmd_ds_command *resp)
+{
+	struct host_cmd_ds_tdls_oper *cmd_tdls_oper = &resp->params.tdls_oper;
+	u16 reason = le16_to_cpu(cmd_tdls_oper->reason);
+	u16 action = le16_to_cpu(cmd_tdls_oper->tdls_action);
 
+	switch (action) {
+	case ACT_TDLS_DELETE:
+		if (reason)
+			dev_err(priv->adapter->dev,
+				"TDLS link delete for %pM failed: reason %d\n",
+				cmd_tdls_oper->peer_mac, reason);
+		else
+			dev_dbg(priv->adapter->dev,
+				"TDLS link config for %pM successful\n",
+				cmd_tdls_oper->peer_mac);
+		break;
+	default:
+		dev_err(priv->adapter->dev,
+			"Unknown TDLS command action respnse %d", action);
+		return -1;
+	}
+
+	return 0;
+}
 /*
  * This function handles the command response for subscribe event command.
  */
@@ -1005,6 +1030,9 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 		break;
 	case HostCmd_CMD_COALESCE_CFG:
 		break;
+	case HostCmd_CMD_TDLS_OPER:
+		ret = mwifiex_ret_tdls_oper(priv, resp);
+		break;
 	default:
 		dev_err(adapter->dev, "CMD_RESP: unknown cmd response %#x\n",
 			resp->command);
diff --git a/drivers/net/wireless/mwifiex/tdls.c b/drivers/net/wireless/mwifiex/tdls.c
index ba54037..123e51b 100644
--- a/drivers/net/wireless/mwifiex/tdls.c
+++ b/drivers/net/wireless/mwifiex/tdls.c
@@ -17,6 +17,8 @@
 
 #include "main.h"
 #include "wmm.h"
+#include "11n.h"
+#include "11n_rxreorder.h"
 
 #define TDLS_REQ_FIX_LEN      6
 #define TDLS_RESP_FIX_LEN     8
@@ -540,3 +542,97 @@ void mwifiex_process_tdls_action_frame(struct mwifiex_private *priv,
 
 	return;
 }
+
+static int
+mwifiex_tdls_process_disable_link(struct mwifiex_private *priv, u8 *peer)
+{
+	struct mwifiex_sta_node *sta_ptr;
+	struct mwifiex_ds_tdls_oper tdls_oper;
+	unsigned long flags;
+
+	memset(&tdls_oper, 0, sizeof(struct mwifiex_ds_tdls_oper));
+	sta_ptr = mwifiex_get_sta_entry(priv, peer);
+
+	if (sta_ptr) {
+		if (sta_ptr->is_11n_enabled) {
+			mwifiex_11n_cleanup_reorder_tbl(priv);
+			spin_lock_irqsave(&priv->wmm.ra_list_spinlock,
+					  flags);
+			mwifiex_11n_delete_all_tx_ba_stream_tbl(priv);
+			spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+					       flags);
+		}
+		mwifiex_del_sta_entry(priv, peer);
+	}
+
+	memcpy(&tdls_oper.peer_mac, peer, ETH_ALEN);
+	tdls_oper.tdls_action = MWIFIEX_TDLS_DISABLE_LINK;
+	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_TDLS_OPER,
+				     HostCmd_ACT_GEN_SET, 0, &tdls_oper);
+}
+
+static int
+mwifiex_tdls_process_enable_link(struct mwifiex_private *priv, u8 *peer)
+{
+	struct mwifiex_sta_node *sta_ptr;
+	struct ieee80211_mcs_info mcs;
+	unsigned long flags;
+	int i;
+
+	sta_ptr = mwifiex_get_sta_entry(priv, peer);
+
+	if (sta_ptr && (sta_ptr->tdls_status != TDLS_SETUP_FAILURE)) {
+		dev_dbg(priv->adapter->dev,
+			"tdls: enable link %pM success\n", peer);
+
+		sta_ptr->tdls_status = TDLS_SETUP_COMPLETE;
+
+		mcs = sta_ptr->tdls_cap.ht_capb.mcs;
+		if (mcs.rx_mask[0] != 0xff)
+			sta_ptr->is_11n_enabled = true;
+		if (sta_ptr->is_11n_enabled) {
+			if (le16_to_cpu(sta_ptr->tdls_cap.ht_capb.cap_info) &
+			    IEEE80211_HT_CAP_MAX_AMSDU)
+				sta_ptr->max_amsdu =
+					MWIFIEX_TX_DATA_BUF_SIZE_8K;
+			else
+				sta_ptr->max_amsdu =
+					MWIFIEX_TX_DATA_BUF_SIZE_4K;
+
+			for (i = 0; i < MAX_NUM_TID; i++)
+				sta_ptr->ampdu_sta[i] =
+					      priv->aggr_prio_tbl[i].ampdu_user;
+		} else {
+			sta_ptr->ampdu_sta[i] = BA_STREAM_NOT_ALLOWED;
+		}
+
+		memset(sta_ptr->rx_seq, 0xff, sizeof(sta_ptr->rx_seq));
+	} else {
+		dev_dbg(priv->adapter->dev,
+			"tdls: enable link %pM failed\n", peer);
+		if (sta_ptr) {
+			mwifiex_11n_cleanup_reorder_tbl(priv);
+			spin_lock_irqsave(&priv->wmm.ra_list_spinlock,
+					  flags);
+			mwifiex_11n_delete_all_tx_ba_stream_tbl(priv);
+			spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+					       flags);
+			mwifiex_del_sta_entry(priv, peer);
+		}
+
+		return -1;
+	}
+
+	return 0;
+}
+
+int mwifiex_tdls_oper(struct mwifiex_private *priv, u8 *peer, u8 action)
+{
+	switch (action) {
+	case MWIFIEX_TDLS_ENABLE_LINK:
+		return mwifiex_tdls_process_enable_link(priv, peer);
+	case MWIFIEX_TDLS_DISABLE_LINK:
+		return mwifiex_tdls_process_disable_link(priv, peer);
+	}
+	return 0;
+}
-- 
1.8.2.3

