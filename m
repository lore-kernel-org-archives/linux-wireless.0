Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:40102 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752914Ab3HFBxn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Aug 2013 21:53:43 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 4/4] mwifiex: add packet coalesce support
Date: Mon, 5 Aug 2013 18:52:00 -0700
Message-ID: <1375753920-10100-4-git-send-email-bzhao@marvell.com> (sfid-20130806_035346_750316_D4FF01E5)
In-Reply-To: <1375753920-10100-1-git-send-email-bzhao@marvell.com>
References: <1375753920-10100-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Coalesce filters are configured in firmware based on settings
received from cfg80211.

Packet type which is required by firmware is determined based on
provided patterns in a rule:

Unicast: if pattern '01' with offset 0 is found
Multicast: if pattern '33:33' or '01:00:5e' with offset 0 is found
Broadcast: if pattern 'ff:ff:ff:ff' with offset 0 is found

Some example coalesce configuration files:

1) Coalesce Rx data packets from 192.168.0.88
mac address of our device is 00:50:43:21:53:7A
Source IP address offset comes out as 52 after following
calculations:
    32 bytes of HW 802.11 header + 8 bytes LLC +
    12 bytes in IPV4 header till source IP address
Destination mac is at offset 6 in HW header.

delay=100
condition=1
patterns=01,6+00:50:43:22,10+53:7A,52+c0:a8:00:58

2) Coalesce all broadcast and multicast packets(Multiple packet
types are not allowed in a single rule. Hence created separate
rules)

delay=400
condition=1
patterns=33:33
delay=400
condition=1
patterns=ff:ff:ff:ff

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c    | 125 +++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/fw.h          |  24 ++++++
 drivers/net/wireless/mwifiex/ioctl.h       |  35 ++++++++
 drivers/net/wireless/mwifiex/sta_cmd.c     |  68 ++++++++++++++++
 drivers/net/wireless/mwifiex/sta_cmdresp.c |   2 +
 5 files changed, 254 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 62c3d98..07d2318 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2455,6 +2455,119 @@ static void mwifiex_cfg80211_set_wakeup(struct wiphy *wiphy,
 }
 #endif
 
+static int mwifiex_get_coalesce_pkt_type(u8 *byte_seq)
+{
+	const u8 ipv4_mc_mac[] = {0x33, 0x33};
+	const u8 ipv6_mc_mac[] = {0x01, 0x00, 0x5e};
+	const u8 bc_mac[] = {0xff, 0xff, 0xff, 0xff};
+
+	if ((byte_seq[0] & 0x01) &&
+	    (byte_seq[MWIFIEX_COALESCE_MAX_BYTESEQ] == 1))
+		return PACKET_TYPE_UNICAST;
+	else if (!memcmp(byte_seq, bc_mac, 4))
+		return PACKET_TYPE_BROADCAST;
+	else if ((!memcmp(byte_seq, ipv4_mc_mac, 2) &&
+		  byte_seq[MWIFIEX_COALESCE_MAX_BYTESEQ] == 2) ||
+		 (!memcmp(byte_seq, ipv6_mc_mac, 3) &&
+		  byte_seq[MWIFIEX_COALESCE_MAX_BYTESEQ] == 3))
+		return PACKET_TYPE_MULTICAST;
+
+	return 0;
+}
+
+static int
+mwifiex_fill_coalesce_rule_info(struct mwifiex_private *priv,
+				struct cfg80211_coalesce_rules *crule,
+				struct mwifiex_coalesce_rule *mrule)
+{
+	u8 byte_seq[MWIFIEX_COALESCE_MAX_BYTESEQ + 1];
+	struct filt_field_param *param;
+	int i;
+
+	mrule->max_coalescing_delay = crule->delay;
+
+	param = mrule->params;
+
+	for (i = 0; i < crule->n_patterns; i++) {
+		memset(byte_seq, 0, sizeof(byte_seq));
+		if (!mwifiex_is_pattern_supported(&crule->patterns[i],
+						  byte_seq,
+						MWIFIEX_COALESCE_MAX_BYTESEQ)) {
+			dev_err(priv->adapter->dev, "Pattern not supported\n");
+			return -EOPNOTSUPP;
+		}
+
+		if (!crule->patterns[i].pkt_offset) {
+			u8 pkt_type;
+
+			pkt_type = mwifiex_get_coalesce_pkt_type(byte_seq);
+			if (pkt_type && mrule->pkt_type) {
+				dev_err(priv->adapter->dev,
+					"Multiple packet types not allowed\n");
+				return -EOPNOTSUPP;
+			} else if (pkt_type) {
+				mrule->pkt_type = pkt_type;
+				continue;
+			}
+		}
+
+		if (crule->condition == NL80211_COALESCE_CONDITION_MATCH)
+			param->operation = RECV_FILTER_MATCH_TYPE_EQ;
+		else
+			param->operation = RECV_FILTER_MATCH_TYPE_NE;
+
+		param->operand_len = byte_seq[MWIFIEX_COALESCE_MAX_BYTESEQ];
+		memcpy(param->operand_byte_stream, byte_seq,
+		       param->operand_len);
+		param->offset = crule->patterns[i].pkt_offset;
+		param++;
+
+		mrule->num_of_fields++;
+	}
+
+	if (!mrule->pkt_type) {
+		dev_err(priv->adapter->dev,
+			"Packet type can not be determined\n");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int mwifiex_cfg80211_set_coalesce(struct wiphy *wiphy,
+					 struct cfg80211_coalesce *coalesce)
+{
+	struct mwifiex_adapter *adapter = mwifiex_cfg80211_get_adapter(wiphy);
+	int i, ret;
+	struct mwifiex_ds_coalesce_cfg coalesce_cfg;
+	struct mwifiex_private *priv =
+			mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA);
+
+	memset(&coalesce_cfg, 0, sizeof(coalesce_cfg));
+	if (!coalesce) {
+		dev_dbg(adapter->dev,
+			"Disable coalesce and reset all previous rules\n");
+		return mwifiex_send_cmd_sync(priv, HostCmd_CMD_COALESCE_CFG,
+					     HostCmd_ACT_GEN_SET, 0,
+					     &coalesce_cfg);
+	}
+
+	coalesce_cfg.num_of_rules = coalesce->n_rules;
+	for (i = 0; i < coalesce->n_rules; i++) {
+		ret = mwifiex_fill_coalesce_rule_info(priv, &coalesce->rules[i],
+						      &coalesce_cfg.rule[i]);
+		if (ret) {
+			dev_err(priv->adapter->dev,
+				"Recheck the patterns provided for rule %d\n",
+				i + 1);
+			return ret;
+		}
+	}
+
+	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_COALESCE_CFG,
+				     HostCmd_ACT_GEN_SET, 0, &coalesce_cfg);
+}
+
 /* station cfg80211 operations */
 static struct cfg80211_ops mwifiex_cfg80211_ops = {
 	.add_virtual_intf = mwifiex_add_virtual_intf,
@@ -2488,6 +2601,7 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
 	.suspend = mwifiex_cfg80211_suspend,
 	.resume = mwifiex_cfg80211_resume,
 	.set_wakeup = mwifiex_cfg80211_set_wakeup,
+	.set_coalesce = mwifiex_cfg80211_set_coalesce,
 #endif
 };
 
@@ -2512,6 +2626,15 @@ static bool mwifiex_is_valid_alpha2(const char *alpha2)
 	return false;
 }
 
+static const struct wiphy_coalesce_support mwifiex_coalesce_support = {
+	.n_rules = MWIFIEX_COALESCE_MAX_RULES,
+	.max_delay = MWIFIEX_MAX_COALESCING_DELAY,
+	.n_patterns = MWIFIEX_COALESCE_MAX_FILTERS,
+	.pattern_min_len = 1,
+	.pattern_max_len = MWIFIEX_MAX_PATTERN_LEN,
+	.max_pkt_offset = MWIFIEX_MAX_OFFSET_LEN,
+};
+
 /*
  * This function registers the device with CFG802.11 subsystem.
  *
@@ -2573,6 +2696,8 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 	wiphy->wowlan = &mwifiex_wowlan_support;
 #endif
 
+	wiphy->coalesce = &mwifiex_coalesce_support;
+
 	wiphy->probe_resp_offload = NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS |
 				    NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2 |
 				    NL80211_PROBE_RESP_OFFLOAD_SUPPORT_P2P;
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 12c6223..c9ad1c0 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -153,6 +153,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define TLV_TYPE_UAP_PS_AO_TIMER    (PROPRIETARY_TLV_BASE_ID + 123)
 #define TLV_TYPE_PWK_CIPHER         (PROPRIETARY_TLV_BASE_ID + 145)
 #define TLV_TYPE_GWK_CIPHER         (PROPRIETARY_TLV_BASE_ID + 146)
+#define TLV_TYPE_COALESCE_RULE      (PROPRIETARY_TLV_BASE_ID + 154)
 
 #define MWIFIEX_TX_DATA_BUF_SIZE_2K        2048
 
@@ -294,6 +295,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define HostCmd_CMD_CAU_REG_ACCESS                    0x00ed
 #define HostCmd_CMD_SET_BSS_MODE                      0x00f7
 #define HostCmd_CMD_PCIE_DESC_DETAILS                 0x00fa
+#define HostCmd_CMD_COALESCE_CFG                      0x010a
 #define HostCmd_CMD_MGMT_FRAME_REG                    0x010c
 #define HostCmd_CMD_REMAIN_ON_CHAN                    0x010d
 #define HostCmd_CMD_11AC_CFG			      0x0112
@@ -1596,6 +1598,27 @@ struct host_cmd_ds_802_11_cfg_data {
 	__le16 data_len;
 } __packed;
 
+struct coalesce_filt_field_param {
+	u8 operation;
+	u8 operand_len;
+	__le16 offset;
+	u8 operand_byte_stream[4];
+};
+
+struct coalesce_receive_filt_rule {
+	struct mwifiex_ie_types_header header;
+	u8 num_of_fields;
+	u8 pkt_type;
+	__le16 max_coalescing_delay;
+	struct coalesce_filt_field_param params[0];
+} __packed;
+
+struct host_cmd_ds_coalesce_cfg {
+	__le16 action;
+	__le16 num_of_rules;
+	struct coalesce_receive_filt_rule rule[0];
+} __packed;
+
 struct host_cmd_ds_command {
 	__le16 command;
 	__le16 size;
@@ -1656,6 +1679,7 @@ struct host_cmd_ds_command {
 		struct host_cmd_ds_sta_deauth sta_deauth;
 		struct host_cmd_11ac_vht_cfg vht_cfg;
 		struct host_cmd_ds_802_11_cfg_data cfg_data;
+		struct host_cmd_ds_coalesce_cfg coalesce_cfg;
 	} params;
 } __packed;
 
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index 5ecda45..00a95f4 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -397,4 +397,39 @@ enum {
 	MWIFIEX_FUNC_SHUTDOWN,
 };
 
+enum COALESCE_OPERATION {
+	RECV_FILTER_MATCH_TYPE_EQ = 0x80,
+	RECV_FILTER_MATCH_TYPE_NE,
+};
+
+enum COALESCE_PACKET_TYPE {
+	PACKET_TYPE_UNICAST = 1,
+	PACKET_TYPE_MULTICAST = 2,
+	PACKET_TYPE_BROADCAST = 3
+};
+
+#define MWIFIEX_COALESCE_MAX_RULES	8
+#define MWIFIEX_COALESCE_MAX_BYTESEQ	4	/* non-adjustable */
+#define MWIFIEX_COALESCE_MAX_FILTERS	4
+#define MWIFIEX_MAX_COALESCING_DELAY	100     /* in msecs */
+
+struct filt_field_param {
+	u8 operation;
+	u8 operand_len;
+	u16 offset;
+	u8 operand_byte_stream[MWIFIEX_COALESCE_MAX_BYTESEQ];
+};
+
+struct mwifiex_coalesce_rule {
+	u16 max_coalescing_delay;
+	u8 num_of_fields;
+	u8 pkt_type;
+	struct filt_field_param params[MWIFIEX_COALESCE_MAX_FILTERS];
+};
+
+struct mwifiex_ds_coalesce_cfg {
+	u16 num_of_rules;
+	struct mwifiex_coalesce_rule rule[MWIFIEX_COALESCE_MAX_RULES];
+};
+
 #endif /* !_MWIFIEX_IOCTL_H_ */
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 448baf1..c0268b5 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -1184,6 +1184,70 @@ static int mwifiex_cmd_cfg_data(struct mwifiex_private *priv,
 	return 0;
 }
 
+static int
+mwifiex_cmd_coalesce_cfg(struct mwifiex_private *priv,
+			 struct host_cmd_ds_command *cmd,
+			 u16 cmd_action, void *data_buf)
+{
+	struct host_cmd_ds_coalesce_cfg *coalesce_cfg =
+						&cmd->params.coalesce_cfg;
+	struct mwifiex_ds_coalesce_cfg *cfg = data_buf;
+	struct coalesce_filt_field_param *param;
+	u16 cnt, idx, length;
+	struct coalesce_receive_filt_rule *rule;
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_COALESCE_CFG);
+	cmd->size = cpu_to_le16(S_DS_GEN);
+
+	coalesce_cfg->action = cpu_to_le16(cmd_action);
+	coalesce_cfg->num_of_rules = cpu_to_le16(cfg->num_of_rules);
+	rule = coalesce_cfg->rule;
+
+	for (cnt = 0; cnt < cfg->num_of_rules; cnt++) {
+		rule->header.type = cpu_to_le16(TLV_TYPE_COALESCE_RULE);
+		rule->max_coalescing_delay =
+			cpu_to_le16(cfg->rule[cnt].max_coalescing_delay);
+		rule->pkt_type = cfg->rule[cnt].pkt_type;
+		rule->num_of_fields = cfg->rule[cnt].num_of_fields;
+
+		length = 0;
+
+		param = rule->params;
+		for (idx = 0; idx < cfg->rule[cnt].num_of_fields; idx++) {
+			param->operation = cfg->rule[cnt].params[idx].operation;
+			param->operand_len =
+					cfg->rule[cnt].params[idx].operand_len;
+			param->offset =
+				cpu_to_le16(cfg->rule[cnt].params[idx].offset);
+			memcpy(param->operand_byte_stream,
+			       cfg->rule[cnt].params[idx].operand_byte_stream,
+			       param->operand_len);
+
+			length += sizeof(struct coalesce_filt_field_param);
+
+			param++;
+		}
+
+		/* Total rule length is sizeof max_coalescing_delay(u16),
+		 * num_of_fields(u8), pkt_type(u8) and total length of the all
+		 * params
+		 */
+		rule->header.len = cpu_to_le16(length + sizeof(u16) +
+					       sizeof(u8) + sizeof(u8));
+
+		/* Add the rule length to the command size*/
+		le16_add_cpu(&cmd->size, le16_to_cpu(rule->header.len) +
+			     sizeof(struct mwifiex_ie_types_header));
+
+		rule = (void *)((u8 *)rule->params + length);
+	}
+
+	/* Add sizeof action, num_of_rules to total command length */
+	le16_add_cpu(&cmd->size, sizeof(u16) + sizeof(u16));
+
+	return 0;
+}
+
 /*
  * This function prepares the commands before sending them to the firmware.
  *
@@ -1407,6 +1471,10 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 	case HostCmd_CMD_MEF_CFG:
 		ret = mwifiex_cmd_mef_cfg(priv, cmd_ptr, data_buf);
 		break;
+	case HostCmd_CMD_COALESCE_CFG:
+		ret = mwifiex_cmd_coalesce_cfg(priv, cmd_ptr, cmd_action,
+					       data_buf);
+		break;
 	default:
 		dev_err(priv->adapter->dev,
 			"PREP_CMD: unknown cmd- %#x\n", cmd_no);
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index d85df15..6a814eb 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -997,6 +997,8 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 		break;
 	case HostCmd_CMD_MEF_CFG:
 		break;
+	case HostCmd_CMD_COALESCE_CFG:
+		break;
 	default:
 		dev_err(adapter->dev, "CMD_RESP: unknown cmd response %#x\n",
 			resp->command);
-- 
1.8.2.3

