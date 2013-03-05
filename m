Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:59821 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753742Ab3CEA2n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 19:28:43 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Paul Fox <pgf@laptop.org>, Daniel Drake <dsd@laptop.org>,
	John Rhodes <jrhodes@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 7/7] mwifiex: add WOWLAN support
Date: Mon,  4 Mar 2013 16:27:59 -0800
Message-Id: <1362443279-6064-8-git-send-email-bzhao@marvell.com> (sfid-20130305_012846_680335_2B281704)
In-Reply-To: <1362443279-6064-1-git-send-email-bzhao@marvell.com>
References: <1362443279-6064-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Currently 'magic-packet' and 'patterns' options in 'iw wowlan'
command are supported.

Appropriate packet filters for wowlan are configured in firmware
based on provided patterns and/or magic-packet option.

For examples,

wake-on ARP request for 192.168.0.100:
iw phy0 wowlan enable patterns ff:ff:ff:ff:ff:ff 20+08:06
  46+c0:a8:00:64

wake-on RX packets sent from IP address 192.168.0.88:
iw phy0 wowlan enable patterns 34+c0:a8:00:58

wake-on RX packets with TCP destination port 80
iw phy0 wowlan enable patterns 44+50

wake-on MagicPacket:
iw phy0 wowlan enable magic-packet

wake-on MagicPacket or patterns:
iw phy0 wowlan enable magic-packet patterns 12+00:11:22:33:44:55
  18+00:50:43:21

wake-on IPv4 multicast packets:
iw phy0 wowlan enable patterns 01:00:5e

wake-on IPv6 multicast packets:
iw phy0 wowlan enable patterns 33:33

disable all wowlan options
iw phy0 wowlan disable

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c    |  156 ++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/fw.h          |   32 ++++++
 drivers/net/wireless/mwifiex/ioctl.h       |   23 ++++
 drivers/net/wireless/mwifiex/main.h        |    2 +
 drivers/net/wireless/mwifiex/sta_cmd.c     |   77 ++++++++++++++
 drivers/net/wireless/mwifiex/sta_cmdresp.c |    2 +
 6 files changed, 292 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 45790fa..df30107 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2294,6 +2294,149 @@ int mwifiex_del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 }
 EXPORT_SYMBOL_GPL(mwifiex_del_virtual_intf);
 
+#ifdef CONFIG_PM
+static bool
+mwifiex_is_pattern_supported(struct cfg80211_wowlan_trig_pkt_pattern *pat,
+			     s8 *byte_seq)
+{
+	int j, k, valid_byte_cnt = 0;
+	bool dont_care_byte = false;
+
+	for (j = 0; j < DIV_ROUND_UP(pat->pattern_len, 8); j++) {
+		for (k = 0; k < 8; k++) {
+			if (pat->mask[j] & 1 << k) {
+				memcpy(byte_seq + valid_byte_cnt,
+				       &pat->pattern[j * 8 + k], 1);
+				valid_byte_cnt++;
+				if (dont_care_byte)
+					return false;
+			} else {
+				if (valid_byte_cnt)
+					dont_care_byte = true;
+			}
+
+			if (valid_byte_cnt > MAX_BYTESEQ)
+				return false;
+		}
+	}
+
+	byte_seq[MAX_BYTESEQ] = valid_byte_cnt;
+
+	return true;
+}
+
+static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
+				    struct cfg80211_wowlan *wowlan)
+{
+	struct mwifiex_adapter *adapter = mwifiex_cfg80211_get_adapter(wiphy);
+	struct mwifiex_ds_mef_cfg mef_cfg;
+	struct mwifiex_mef_entry *mef_entry;
+	int i, filt_num = 0, ret;
+	bool first_pat = true;
+	u8 byte_seq[MAX_BYTESEQ + 1];
+	const u8 ipv4_mc_mac[] = {0x33, 0x33};
+	const u8 ipv6_mc_mac[] = {0x01, 0x00, 0x5e};
+	struct mwifiex_private *priv =
+			mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA);
+
+	if (!wowlan) {
+		dev_warn(adapter->dev, "None of the WOWLAN triggers enabled\n");
+		return 0;
+	}
+
+	if (!priv->media_connected) {
+		dev_warn(adapter->dev,
+			 "Can not configure WOWLAN in disconnected state\n");
+		return 0;
+	}
+
+	memset(&mef_cfg, 0, sizeof(mef_cfg));
+	mef_cfg.num_entries = 1;
+	mef_entry = kzalloc(sizeof(*mef_entry), GFP_KERNEL);
+	mef_cfg.mef_entry = mef_entry;
+	mef_entry->mode = MEF_MODE_HOST_SLEEP;
+	mef_entry->action = MEF_ACTION_ALLOW_AND_WAKEUP_HOST;
+
+	for (i = 0; i < wowlan->n_patterns; i++) {
+		memset(byte_seq, 0, sizeof(byte_seq));
+		if (!mwifiex_is_pattern_supported(&wowlan->patterns[i],
+						  byte_seq)) {
+			wiphy_err(wiphy, "Pattern not supported\n");
+			kfree(mef_entry);
+			return -EOPNOTSUPP;
+		}
+
+		if (!wowlan->patterns[i].pkt_offset) {
+			if (!(byte_seq[0] & 0x01) &&
+			    (byte_seq[MAX_BYTESEQ] == 1)) {
+				mef_cfg.criteria |= MWIFIEX_CRITERIA_UNICAST;
+				continue;
+			} else if (is_broadcast_ether_addr(byte_seq)) {
+				mef_cfg.criteria |= MWIFIEX_CRITERIA_BROADCAST;
+				continue;
+			} else if ((!memcmp(byte_seq, ipv4_mc_mac, 2) &&
+				    (byte_seq[MAX_BYTESEQ] == 2)) ||
+				   (!memcmp(byte_seq, ipv6_mc_mac, 3) &&
+				    (byte_seq[MAX_BYTESEQ] == 3))) {
+				mef_cfg.criteria |= MWIFIEX_CRITERIA_MULTICAST;
+				continue;
+			}
+		}
+
+		mef_entry->filter[filt_num].repeat = 1;
+		mef_entry->filter[filt_num].offset =
+						wowlan->patterns[i].pkt_offset;
+		memcpy(mef_entry->filter[filt_num].byte_seq, byte_seq,
+		       sizeof(byte_seq));
+		mef_entry->filter[filt_num].filt_type = TYPE_EQ;
+
+		if (first_pat)
+			first_pat = false;
+		else
+			mef_entry->filter[filt_num].filt_action = TYPE_AND;
+
+		filt_num++;
+	}
+
+	if (wowlan->magic_pkt) {
+		mef_cfg.criteria |= MWIFIEX_CRITERIA_UNICAST;
+		mef_entry->filter[filt_num].repeat = 16;
+		memcpy(mef_entry->filter[filt_num].byte_seq, priv->curr_addr,
+		       ETH_ALEN);
+		mef_entry->filter[filt_num].byte_seq[MAX_BYTESEQ] = ETH_ALEN;
+		mef_entry->filter[filt_num].offset = 14;
+		mef_entry->filter[filt_num].filt_type = TYPE_EQ;
+		if (filt_num)
+			mef_entry->filter[filt_num].filt_action = TYPE_OR;
+	}
+
+	if (!mef_cfg.criteria)
+		mef_cfg.criteria = MWIFIEX_CRITERIA_BROADCAST |
+				   MWIFIEX_CRITERIA_UNICAST |
+				   MWIFIEX_CRITERIA_MULTICAST;
+
+	ret =  mwifiex_send_cmd_sync(priv, HostCmd_CMD_MEF_CFG,
+				     HostCmd_ACT_GEN_SET, 0,
+				     &mef_cfg);
+
+	kfree(mef_entry);
+	return ret;
+}
+
+static int mwifiex_cfg80211_resume(struct wiphy *wiphy)
+{
+	return 0;
+}
+
+static void mwifiex_cfg80211_set_wakeup(struct wiphy *wiphy,
+				       bool enabled)
+{
+	struct mwifiex_adapter *adapter = mwifiex_cfg80211_get_adapter(wiphy);
+
+	device_set_wakeup_enable(adapter->dev, enabled);
+}
+#endif
+
 /* station cfg80211 operations */
 static struct cfg80211_ops mwifiex_cfg80211_ops = {
 	.add_virtual_intf = mwifiex_add_virtual_intf,
@@ -2322,6 +2465,11 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
 	.change_beacon = mwifiex_cfg80211_change_beacon,
 	.set_cqm_rssi_config = mwifiex_cfg80211_set_cqm_rssi_config,
 	.set_antenna = mwifiex_cfg80211_set_antenna,
+#ifdef CONFIG_PM
+	.suspend = mwifiex_cfg80211_suspend,
+	.resume = mwifiex_cfg80211_resume,
+	.set_wakeup = mwifiex_cfg80211_set_wakeup,
+#endif
 };
 
 /*
@@ -2380,6 +2528,14 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 
 	wiphy_apply_custom_regulatory(wiphy, &mwifiex_world_regdom_custom);
 
+#ifdef CONFIG_PM
+	wiphy->wowlan.flags = WIPHY_WOWLAN_MAGIC_PKT;
+	wiphy->wowlan.n_patterns = MWIFIEX_MAX_FILTERS;
+	wiphy->wowlan.pattern_min_len = 1;
+	wiphy->wowlan.pattern_max_len = MWIFIEX_MAX_PATTERN_LEN;
+	wiphy->wowlan.max_pkt_offset = MWIFIEX_MAX_OFFSET_LEN;
+#endif
+
 	wiphy->probe_resp_offload = NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS |
 				    NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2 |
 				    NL80211_PROBE_RESP_OFFLOAD_SUPPORT_P2P;
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 5a5d066..6d6e5ae 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -300,6 +300,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define HostCmd_CMD_802_11_TX_RATE_QUERY              0x007f
 #define HostCmd_CMD_802_11_IBSS_COALESCING_STATUS     0x0083
 #define HostCmd_CMD_VERSION_EXT                       0x0097
+#define HostCmd_CMD_MEF_CFG                           0x009a
 #define HostCmd_CMD_RSSI_INFO                         0x00a4
 #define HostCmd_CMD_FUNC_INIT                         0x00a9
 #define HostCmd_CMD_FUNC_SHUTDOWN                     0x00aa
@@ -473,6 +474,23 @@ enum P2P_MODES {
 #define EVENT_GET_BSS_TYPE(event_cause)         \
 	(((event_cause) >> 24) & 0x00ff)
 
+#define MWIFIEX_MAX_PATTERN_LEN		20
+#define MWIFIEX_MAX_OFFSET_LEN		50
+#define STACK_NBYTES			100
+#define TYPE_DNUM			1
+#define TYPE_BYTESEQ			2
+#define MAX_OPERAND			0x40
+#define TYPE_EQ				(MAX_OPERAND+1)
+#define TYPE_EQ_DNUM			(MAX_OPERAND+2)
+#define TYPE_EQ_BIT			(MAX_OPERAND+3)
+#define TYPE_AND			(MAX_OPERAND+4)
+#define TYPE_OR				(MAX_OPERAND+5)
+#define MEF_MODE_HOST_SLEEP			1
+#define MEF_ACTION_ALLOW_AND_WAKEUP_HOST	3
+#define MWIFIEX_CRITERIA_BROADCAST	BIT(0)
+#define MWIFIEX_CRITERIA_UNICAST	BIT(1)
+#define MWIFIEX_CRITERIA_MULTICAST	BIT(3)
+
 struct mwifiex_ie_types_header {
 	__le16 type;
 	__le16 len;
@@ -1503,6 +1521,19 @@ struct host_cmd_ds_802_11_ibss_status {
 	__le16 use_g_rate_protect;
 } __packed;
 
+struct mwifiex_fw_mef_entry {
+	u8 mode;
+	u8 action;
+	__le16 exprsize;
+	u8 expr[0];
+} __packed;
+
+struct host_cmd_ds_mef_cfg {
+	__le32 criteria;
+	__le16 num_entries;
+	struct mwifiex_fw_mef_entry mef_entry[0];
+} __packed;
+
 #define CONNECTION_TYPE_INFRA   0
 #define CONNECTION_TYPE_ADHOC   1
 #define CONNECTION_TYPE_AP      2
@@ -1607,6 +1638,7 @@ struct host_cmd_ds_command {
 		struct host_cmd_ds_remain_on_chan roc_cfg;
 		struct host_cmd_ds_p2p_mode_cfg mode_cfg;
 		struct host_cmd_ds_802_11_ibss_status ibss_coalescing;
+		struct host_cmd_ds_mef_cfg mef_cfg;
 		struct host_cmd_ds_mac_reg_access mac_reg;
 		struct host_cmd_ds_bbp_reg_access bbp_reg;
 		struct host_cmd_ds_rf_reg_access rf_reg;
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index d85e6eb..91d522c 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -354,6 +354,29 @@ struct mwifiex_ds_misc_subsc_evt {
 	struct subsc_evt_cfg bcn_h_rssi_cfg;
 };
 
+#define MAX_BYTESEQ		6	/* non-adjustable */
+#define MWIFIEX_MAX_FILTERS	10
+
+struct mwifiex_mef_filter {
+	u16 repeat;
+	u16 offset;
+	s8 byte_seq[MAX_BYTESEQ + 1];
+	u8 filt_type;
+	u8 filt_action;
+};
+
+struct mwifiex_mef_entry {
+	u8 mode;
+	u8 action;
+	struct mwifiex_mef_filter filter[MWIFIEX_MAX_FILTERS];
+};
+
+struct mwifiex_ds_mef_cfg {
+	u32 criteria;
+	u16 num_entries;
+	struct mwifiex_mef_entry *mef_entry;
+};
+
 #define MWIFIEX_MAX_VSIE_LEN       (256)
 #define MWIFIEX_MAX_VSIE_NUM       (8)
 #define MWIFIEX_VSIE_MASK_CLEAR    0x00
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 989e05e..560cf73 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1098,6 +1098,8 @@ int mwifiex_del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev);
 
 void mwifiex_set_sys_config_invalid_data(struct mwifiex_uap_bss_param *config);
 
+int mwifiex_add_wowlan_magic_pkt_filter(struct mwifiex_adapter *adapter);
+
 int mwifiex_set_mgmt_ies(struct mwifiex_private *priv,
 			 struct cfg80211_beacon_data *data);
 int mwifiex_del_mgmt_ies(struct mwifiex_private *priv);
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 3d51721..a2ae690 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -1059,6 +1059,80 @@ mwifiex_cmd_802_11_subsc_evt(struct mwifiex_private *priv,
 	return 0;
 }
 
+static int
+mwifiex_cmd_append_rpn_expression(struct mwifiex_private *priv,
+				  struct mwifiex_mef_entry *mef_entry,
+				  u8 **buffer)
+{
+	struct mwifiex_mef_filter *filter = mef_entry->filter;
+	int i, byte_len;
+	u8 *stack_ptr = *buffer;
+
+	for (i = 0; i < MWIFIEX_MAX_FILTERS; i++) {
+		filter = &mef_entry->filter[i];
+		if (!filter->filt_type)
+			break;
+		*(__le32 *)stack_ptr = cpu_to_le32((u32)filter->repeat);
+		stack_ptr += 4;
+		*stack_ptr = TYPE_DNUM;
+		stack_ptr += 1;
+
+		byte_len = filter->byte_seq[MAX_BYTESEQ];
+		memcpy(stack_ptr, filter->byte_seq, byte_len);
+		stack_ptr += byte_len;
+		*stack_ptr = byte_len;
+		stack_ptr += 1;
+		*stack_ptr = TYPE_BYTESEQ;
+		stack_ptr += 1;
+
+		*(__le32 *)stack_ptr = cpu_to_le32((u32)filter->offset);
+		stack_ptr += 4;
+		*stack_ptr = TYPE_DNUM;
+		stack_ptr += 1;
+
+		*stack_ptr = filter->filt_type;
+		stack_ptr += 1;
+
+		if (filter->filt_action) {
+			*stack_ptr = filter->filt_action;
+			stack_ptr += 1;
+		}
+
+		if (stack_ptr - *buffer > STACK_NBYTES)
+			return -1;
+	}
+
+	*buffer = stack_ptr;
+	return 0;
+}
+
+static int
+mwifiex_cmd_mef_cfg(struct mwifiex_private *priv,
+		    struct host_cmd_ds_command *cmd,
+		    struct mwifiex_ds_mef_cfg *mef)
+{
+	struct host_cmd_ds_mef_cfg *mef_cfg = &cmd->params.mef_cfg;
+	u8 *pos = (u8 *)mef_cfg;
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_MEF_CFG);
+
+	mef_cfg->criteria = cpu_to_le32(mef->criteria);
+	mef_cfg->num_entries = cpu_to_le16(mef->num_entries);
+	pos += sizeof(*mef_cfg);
+	mef_cfg->mef_entry->mode = mef->mef_entry->mode;
+	mef_cfg->mef_entry->action = mef->mef_entry->action;
+	pos += sizeof(*(mef_cfg->mef_entry));
+
+	if (mwifiex_cmd_append_rpn_expression(priv, mef->mef_entry, &pos))
+		return -1;
+
+	mef_cfg->mef_entry->exprsize =
+			cpu_to_le16(pos - mef_cfg->mef_entry->expr);
+	cmd->size = cpu_to_le16((u16) (pos - (u8 *)mef_cfg) + S_DS_GEN);
+
+	return 0;
+}
+
 /*
  * This function prepares the commands before sending them to the firmware.
  *
@@ -1273,6 +1347,9 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 	case HostCmd_CMD_802_11_SUBSCRIBE_EVENT:
 		ret = mwifiex_cmd_802_11_subsc_evt(priv, cmd_ptr, data_buf);
 		break;
+	case HostCmd_CMD_MEF_CFG:
+		ret = mwifiex_cmd_mef_cfg(priv, cmd_ptr, data_buf);
+		break;
 	default:
 		dev_err(priv->adapter->dev,
 			"PREP_CMD: unknown cmd- %#x\n", cmd_no);
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 4669f8d..80b9f22 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -976,6 +976,8 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 	case HostCmd_CMD_UAP_BSS_STOP:
 		priv->bss_started = 0;
 		break;
+	case HostCmd_CMD_MEF_CFG:
+		break;
 	default:
 		dev_err(adapter->dev, "CMD_RESP: unknown cmd response %#x\n",
 			resp->command);
-- 
1.7.0.2

