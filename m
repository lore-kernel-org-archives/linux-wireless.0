Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:52754 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755604Ab3ENBRx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 May 2013 21:17:53 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Daniel Drake <dsd@laptop.org>, Paul Fox <pgf@laptop.org>,
	Tim Shepard <shep@laptop.org>,
	Jason Abele <jabele@chromium.org>,
	John Rhodes <jrhodes@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 06/17] mwifiex: add del_station handler
Date: Mon, 13 May 2013 18:14:50 -0700
Message-ID: <1368494101-23651-7-git-send-email-bzhao@marvell.com> (sfid-20130514_031756_354209_B9B943C7)
In-Reply-To: <1368494101-23651-1-git-send-email-bzhao@marvell.com>
References: <1368494101-23651-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch adds cfg80211 del_station handler for mwifiex.
If bss is not started or there are no stations in associated
stations list, no action is taken. If argument received is
null/broadcast mac, all stations in associated station list are
deauthenticated.

Patch also deletes related RxReorder stream and TxBA stream tables
for related station.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c    | 46 ++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/cmdevt.c      |  1 +
 drivers/net/wireless/mwifiex/fw.h          |  7 +++++
 drivers/net/wireless/mwifiex/main.h        |  2 ++
 drivers/net/wireless/mwifiex/sta_cmdresp.c |  2 ++
 drivers/net/wireless/mwifiex/uap_cmd.c     | 21 ++++++++++++++
 drivers/net/wireless/mwifiex/uap_event.c   | 16 +++++++++++
 7 files changed, 95 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index e493f89..00a8281 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1231,6 +1231,51 @@ static int mwifiex_cfg80211_change_beacon(struct wiphy *wiphy,
 	return 0;
 }
 
+/* cfg80211 operation handler for del_station.
+ * Function deauthenticates station which value is provided in mac parameter.
+ * If mac is NULL/broadcast, all stations in associated station list are
+ * deauthenticated. If bss is not started or there are no stations in
+ * associated stations list, no action is taken.
+ */
+static int
+mwifiex_cfg80211_del_station(struct wiphy *wiphy, struct net_device *dev,
+			     u8 *mac)
+{
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+	struct mwifiex_sta_node *sta_node;
+	unsigned long flags;
+
+	if (list_empty(&priv->sta_list) || !priv->bss_started)
+		return 0;
+
+	if (!mac || is_broadcast_ether_addr(mac)) {
+		wiphy_dbg(wiphy, "%s: NULL/broadcast mac address\n", __func__);
+		list_for_each_entry(sta_node, &priv->sta_list, list) {
+			if (mwifiex_send_cmd_sync(priv,
+						  HostCmd_CMD_UAP_STA_DEAUTH,
+						  HostCmd_ACT_GEN_SET, 0,
+						  sta_node->mac_addr))
+				return -1;
+			mwifiex_uap_del_sta_data(priv, sta_node);
+		}
+	} else {
+		wiphy_dbg(wiphy, "%s: mac address %pM\n", __func__, mac);
+		spin_lock_irqsave(&priv->sta_list_spinlock, flags);
+		sta_node = mwifiex_get_sta_entry(priv, mac);
+		spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
+		if (sta_node) {
+			if (mwifiex_send_cmd_sync(priv,
+						  HostCmd_CMD_UAP_STA_DEAUTH,
+						  HostCmd_ACT_GEN_SET, 0,
+						  sta_node->mac_addr))
+				return -1;
+			mwifiex_uap_del_sta_data(priv, sta_node);
+		}
+	}
+
+	return 0;
+}
+
 static int
 mwifiex_cfg80211_set_antenna(struct wiphy *wiphy, u32 tx_ant, u32 rx_ant)
 {
@@ -2422,6 +2467,7 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
 	.change_beacon = mwifiex_cfg80211_change_beacon,
 	.set_cqm_rssi_config = mwifiex_cfg80211_set_cqm_rssi_config,
 	.set_antenna = mwifiex_cfg80211_set_antenna,
+	.del_station = mwifiex_cfg80211_del_station,
 #ifdef CONFIG_PM
 	.suspend = mwifiex_cfg80211_suspend,
 	.resume = mwifiex_cfg80211_resume,
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 26755d9..2d76147 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -570,6 +570,7 @@ int mwifiex_send_cmd_async(struct mwifiex_private *priv, uint16_t cmd_no,
 		case HostCmd_CMD_UAP_SYS_CONFIG:
 		case HostCmd_CMD_UAP_BSS_START:
 		case HostCmd_CMD_UAP_BSS_STOP:
+		case HostCmd_CMD_UAP_STA_DEAUTH:
 			ret = mwifiex_uap_prepare_cmd(priv, cmd_no, cmd_action,
 						      cmd_oid, data_buf,
 						      cmd_ptr);
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 1f7578d..d3c1e01 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -279,6 +279,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define HostCmd_CMD_UAP_SYS_CONFIG                    0x00b0
 #define HostCmd_CMD_UAP_BSS_START                     0x00b1
 #define HostCmd_CMD_UAP_BSS_STOP                      0x00b2
+#define HostCmd_CMD_UAP_STA_DEAUTH                    0x00b5
 #define HostCmd_CMD_11N_CFG                           0x00cd
 #define HostCmd_CMD_11N_ADDBA_REQ                     0x00ce
 #define HostCmd_CMD_11N_ADDBA_RSP                     0x00cf
@@ -1197,6 +1198,11 @@ struct host_cmd_ds_amsdu_aggr_ctrl {
 	__le16 curr_buf_size;
 } __packed;
 
+struct host_cmd_ds_sta_deauth {
+	u8 mac[ETH_ALEN];
+	__le16 reason;
+} __packed;
+
 struct mwifiex_ie_types_wmm_param_set {
 	struct mwifiex_ie_types_header header;
 	u8 wmm_ie[1];
@@ -1630,6 +1636,7 @@ struct host_cmd_ds_command {
 		struct host_cmd_ds_802_11_eeprom_access eeprom;
 		struct host_cmd_ds_802_11_subsc_evt subsc_evt;
 		struct host_cmd_ds_sys_config uap_sys_config;
+		struct host_cmd_ds_sta_deauth sta_deauth;
 		struct host_cmd_11ac_vht_cfg vht_cfg;
 	} params;
 } __packed;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 81251d9..9cf6852 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1115,6 +1115,8 @@ int mwifiex_set_mgmt_ies(struct mwifiex_private *priv,
 			 struct cfg80211_beacon_data *data);
 int mwifiex_del_mgmt_ies(struct mwifiex_private *priv);
 u8 *mwifiex_11d_code_2_region(u8 code);
+void mwifiex_uap_del_sta_data(struct mwifiex_private *priv,
+			      struct mwifiex_sta_node *node);
 
 extern const struct ethtool_ops mwifiex_ethtool_ops;
 
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 9f990e1..c710a1b 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -978,6 +978,8 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 	case HostCmd_CMD_UAP_BSS_STOP:
 		priv->bss_started = 0;
 		break;
+	case HostCmd_CMD_UAP_STA_DEAUTH:
+		break;
 	case HostCmd_CMD_MEF_CFG:
 		break;
 	default:
diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
index b04b1db..2de882d 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -689,6 +689,23 @@ mwifiex_cmd_uap_sys_config(struct host_cmd_ds_command *cmd, u16 cmd_action,
 	return 0;
 }
 
+/* This function prepares AP specific deauth command with mac supplied in
+ * function parameter.
+ */
+static int mwifiex_cmd_uap_sta_deauth(struct mwifiex_private *priv,
+				      struct host_cmd_ds_command *cmd, u8 *mac)
+{
+	struct host_cmd_ds_sta_deauth *sta_deauth = &cmd->params.sta_deauth;
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_UAP_STA_DEAUTH);
+	memcpy(sta_deauth->mac, mac, ETH_ALEN);
+	sta_deauth->reason = cpu_to_le16(WLAN_REASON_DEAUTH_LEAVING);
+
+	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_sta_deauth) +
+				S_DS_GEN);
+	return 0;
+}
+
 /* This function prepares the AP specific commands before sending them
  * to the firmware.
  * This is a generic function which calls specific command preparation
@@ -710,6 +727,10 @@ int mwifiex_uap_prepare_cmd(struct mwifiex_private *priv, u16 cmd_no,
 		cmd->command = cpu_to_le16(cmd_no);
 		cmd->size = cpu_to_le16(S_DS_GEN);
 		break;
+	case HostCmd_CMD_UAP_STA_DEAUTH:
+		if (mwifiex_cmd_uap_sta_deauth(priv, cmd, data_buf))
+			return -1;
+		break;
 	default:
 		dev_err(priv->adapter->dev,
 			"PREP_CMD: unknown cmd %#x\n", cmd_no);
diff --git a/drivers/net/wireless/mwifiex/uap_event.c b/drivers/net/wireless/mwifiex/uap_event.c
index 77fb533..7180665 100644
--- a/drivers/net/wireless/mwifiex/uap_event.c
+++ b/drivers/net/wireless/mwifiex/uap_event.c
@@ -292,3 +292,19 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 
 	return 0;
 }
+
+/* This function deletes station entry from associated station list.
+ * Also if both AP and STA are 11n enabled, RxReorder tables and TxBA stream
+ * tables created for this station are deleted.
+ */
+void mwifiex_uap_del_sta_data(struct mwifiex_private *priv,
+			      struct mwifiex_sta_node *node)
+{
+	if (priv->ap_11n_enabled && node->is_11n_enabled) {
+		mwifiex_11n_del_rx_reorder_tbl_by_ta(priv, node->mac_addr);
+		mwifiex_del_tx_ba_stream_tbl_by_ra(priv, node->mac_addr);
+	}
+	mwifiex_del_sta_entry(priv, node->mac_addr);
+
+	return;
+}
-- 
1.8.2.3

