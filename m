Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:53381 "HELO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755408Ab2ECHX7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 03:23:59 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Bing Zhao <bzhao@marvell.com>,
	harvey yang <harvey.huawei.yang@gmail.com>
Subject: [PATCH 16/18] mwifiex: add custom IE framework
Date: Thu,  3 May 2012 00:22:38 -0700
Message-Id: <1336029760-22565-17-git-send-email-bzhao@marvell.com> (sfid-20120503_092406_753620_58595206)
In-Reply-To: <1336029760-22565-1-git-send-email-bzhao@marvell.com>
References: <1336029760-22565-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

1. support for setting custom IE from application hostapd etc.
Custom IE addition using auto-indexing and Custom IE deletion using
static indices (which are allocated during IE addition and stored in
driver) are supported.
2. Separate file for handling IE related execution.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/Makefile  |    1 +
 drivers/net/wireless/mwifiex/fw.h      |   17 ++++
 drivers/net/wireless/mwifiex/ie.c      |  149 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/init.c    |    1 +
 drivers/net/wireless/mwifiex/ioctl.h   |    2 +
 drivers/net/wireless/mwifiex/main.c    |    2 +
 drivers/net/wireless/mwifiex/main.h    |    2 +
 drivers/net/wireless/mwifiex/uap_cmd.c |   28 ++++++-
 8 files changed, 201 insertions(+), 1 deletions(-)
 create mode 100644 drivers/net/wireless/mwifiex/ie.c

diff --git a/drivers/net/wireless/mwifiex/Makefile b/drivers/net/wireless/mwifiex/Makefile
index 3ec71ae..3f66ebb 100644
--- a/drivers/net/wireless/mwifiex/Makefile
+++ b/drivers/net/wireless/mwifiex/Makefile
@@ -30,6 +30,7 @@ mwifiex-y += join.o
 mwifiex-y += sta_ioctl.o
 mwifiex-y += sta_cmd.o
 mwifiex-y += uap_cmd.o
+mwifiex-y += ie.o
 mwifiex-y += sta_cmdresp.o
 mwifiex-y += sta_event.o
 mwifiex-y += sta_tx.o
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 4fd7a05..0cb2b0c 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -94,6 +94,9 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define CAL_SNR(RSSI, NF)		((s16)((s16)(RSSI)-(s16)(NF)))
 
 #define UAP_BSS_PARAMS_I			0
+#define UAP_CUSTOM_IE_I				1
+#define MWIFIEX_AUTO_IDX_MASK			0xffff
+#define MWIFIEX_DELETE_MASK			0x0000
 
 #define TLV_TYPE_UAP_SSID			0x0000
 
@@ -1299,6 +1302,20 @@ struct host_cmd_ds_802_11_subsc_evt {
 	__le16 events;
 } __packed;
 
+struct mwifiex_ie {
+	__le16 ie_index;
+	__le16 mgmt_subtype_mask;
+	__le16 ie_length;
+	u8 ie_buffer[IEEE_MAX_IE_SIZE];
+} __packed;
+
+#define MAX_MGMT_IE_INDEX	16
+struct mwifiex_ie_list {
+	__le16 type;
+	__le16 len;
+	struct mwifiex_ie ie_list[MAX_MGMT_IE_INDEX];
+} __packed;
+
 struct host_cmd_ds_command {
 	__le16 command;
 	__le16 size;
diff --git a/drivers/net/wireless/mwifiex/ie.c b/drivers/net/wireless/mwifiex/ie.c
new file mode 100644
index 0000000..772bf3e
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/ie.c
@@ -0,0 +1,149 @@
+/*
+ * Marvell Wireless LAN device driver: management IE handling- setting and
+ * deleting IE.
+ *
+ * Copyright (C) 2012, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#include "main.h"
+
+/* This function checks if current IE index is used by any on other interface.
+ * Return: -1: yes, current IE index is used by someone else.
+ *          0: no, current IE index is NOT used by other interface.
+ */
+static int
+mwifiex_ie_index_used_by_other_intf(struct mwifiex_private *priv, u16 idx)
+{
+	int i;
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct mwifiex_ie *ie;
+
+	for (i = 0; i < adapter->priv_num; i++) {
+		if (adapter->priv[i] != priv) {
+			ie = &adapter->priv[i]->mgmt_ie[idx];
+			if (ie->mgmt_subtype_mask && ie->ie_length)
+				return -1;
+		}
+	}
+
+	return 0;
+}
+
+/* Get unused IE index. This index will be used for setting new IE */
+static int
+mwifiex_ie_get_autoidx(struct mwifiex_private *priv, u16 subtype_mask,
+		       struct mwifiex_ie *ie, u16 *index)
+{
+	u16 mask, len, i;
+
+	for (i = 0; i < priv->adapter->max_mgmt_ie_index; i++) {
+		mask = le16_to_cpu(priv->mgmt_ie[i].mgmt_subtype_mask);
+		len = le16_to_cpu(priv->mgmt_ie[i].ie_length) +
+		      le16_to_cpu(ie->ie_length);
+
+		if (mask == MWIFIEX_AUTO_IDX_MASK)
+			continue;
+
+		if (mask == subtype_mask) {
+			if (len > IEEE_MAX_IE_SIZE)
+				continue;
+
+			*index = i;
+			return 0;
+		}
+
+		if (!priv->mgmt_ie[i].ie_length) {
+			if (mwifiex_ie_index_used_by_other_intf(priv, i))
+				continue;
+
+			*index = i;
+			return 0;
+		}
+	}
+
+	return -1;
+}
+
+/* This function prepares IE data buffer for command to be sent to FW */
+static int
+mwifiex_update_autoindex_ies(struct mwifiex_private *priv,
+			     struct mwifiex_ie_list *ie_list)
+{
+	u16 travel_len, index, mask;
+	s16 input_len;
+	struct mwifiex_ie *ie;
+	u8 *tmp;
+
+	input_len = le16_to_cpu(ie_list->len);
+	travel_len = sizeof(struct host_cmd_tlv);
+
+	ie_list->len = 0;
+
+	while (input_len > 0) {
+		ie = (struct mwifiex_ie *)(((u8 *)ie_list) + travel_len);
+		input_len -= le16_to_cpu(ie->ie_length) + MWIFIEX_IE_HDR_SIZE;
+		travel_len += le16_to_cpu(ie->ie_length) + MWIFIEX_IE_HDR_SIZE;
+
+		index = le16_to_cpu(ie->ie_index);
+		mask = le16_to_cpu(ie->mgmt_subtype_mask);
+
+		if (index == MWIFIEX_AUTO_IDX_MASK) {
+			/* automatic addition */
+			if (mwifiex_ie_get_autoidx(priv, mask, ie, &index))
+				return -1;
+			if (index == MWIFIEX_AUTO_IDX_MASK)
+				return -1;
+
+			tmp = (u8 *)&priv->mgmt_ie[index].ie_buffer;
+			tmp += le16_to_cpu(priv->mgmt_ie[index].ie_length);
+			memcpy(tmp, &ie->ie_buffer, le16_to_cpu(ie->ie_length));
+			le16_add_cpu(&priv->mgmt_ie[index].ie_length,
+				     le16_to_cpu(ie->ie_length));
+			priv->mgmt_ie[index].ie_index = cpu_to_le16(index);
+			priv->mgmt_ie[index].mgmt_subtype_mask =
+							cpu_to_le16(mask);
+
+			ie->ie_index = cpu_to_le16(index);
+			ie->ie_length = priv->mgmt_ie[index].ie_length;
+			memcpy(&ie->ie_buffer, &priv->mgmt_ie[index].ie_buffer,
+			       le16_to_cpu(priv->mgmt_ie[index].ie_length));
+		} else {
+			if (mask != MWIFIEX_DELETE_MASK)
+				return -1;
+			/*
+			 * Check if this index is being used on any
+			 * other interface.
+			 */
+			if (mwifiex_ie_index_used_by_other_intf(priv, index))
+				return -1;
+
+			ie->ie_length = 0;
+			memcpy(&priv->mgmt_ie[index], ie,
+			       sizeof(struct mwifiex_ie));
+		}
+
+		le16_add_cpu(&ie_list->len,
+			     le16_to_cpu(priv->mgmt_ie[index].ie_length) +
+			     MWIFIEX_IE_HDR_SIZE);
+	}
+
+	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_UAP)
+		return mwifiex_send_cmd_async(priv, HostCmd_CMD_UAP_SYS_CONFIG,
+					      HostCmd_ACT_GEN_SET,
+					      UAP_CUSTOM_IE_I, ie_list);
+
+	return 0;
+}
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index d440c3e..c1cb004 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -279,6 +279,7 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	memset(&adapter->arp_filter, 0, sizeof(adapter->arp_filter));
 	adapter->arp_filter_size = 0;
 	adapter->channel_type = NL80211_CHAN_HT20;
+	adapter->max_mgmt_ie_index = MAX_MGMT_IE_INDEX;
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index eb14f55..e6be6ee 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -299,6 +299,8 @@ struct mwifiex_ds_read_eeprom {
 
 #define IEEE_MAX_IE_SIZE		256
 
+#define MWIFIEX_IE_HDR_SIZE	(sizeof(struct mwifiex_ie) - IEEE_MAX_IE_SIZE)
+
 struct mwifiex_ds_misc_gen_ie {
 	u32 type;
 	u32 len;
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 43e4efa..49598e6 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -640,6 +640,8 @@ void mwifiex_init_priv_params(struct mwifiex_private *priv,
 	priv->current_key_index = 0;
 	priv->media_connected = false;
 	memset(&priv->nick_name, 0, sizeof(priv->nick_name));
+	memset(priv->mgmt_ie, 0,
+	       sizeof(struct mwifiex_ie) * MAX_MGMT_IE_INDEX);
 	priv->num_tx_timeout = 0;
 	memcpy(dev->dev_addr, priv->curr_addr, ETH_ALEN);
 }
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 824bd43..988d31d 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -477,6 +477,7 @@ struct mwifiex_private {
 	s32 cqm_rssi_thold;
 	u32 cqm_rssi_hyst;
 	u8 subsc_evt_rssi_state;
+	struct mwifiex_ie mgmt_ie[MAX_MGMT_IE_INDEX];
 };
 
 enum mwifiex_ba_status {
@@ -680,6 +681,7 @@ struct mwifiex_adapter {
 	spinlock_t queue_lock;		/* lock for tx queues */
 	struct completion fw_load;
 	u8 country_code[IEEE80211_COUNTRY_STRING_LEN];
+	u16 max_mgmt_ie_index;
 };
 
 int mwifiex_init_lock_list(struct mwifiex_adapter *adapter);
diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
index 4890f5f..049d779 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -315,6 +315,26 @@ mwifiex_uap_bss_param_prepare(u8 *tlv, void *cmd_buf, u16 *param_size)
 	return 0;
 }
 
+/* This function parses custom IEs from IE list and prepares command buffer */
+static int mwifiex_uap_custom_ie_prepare(u8 *tlv, void *cmd_buf, u16 *ie_size)
+{
+	struct mwifiex_ie_list *ap_ie = cmd_buf;
+	struct host_cmd_tlv *tlv_ie = (struct host_cmd_tlv *)tlv;
+
+	if (!ap_ie || !ap_ie->len || !ap_ie->ie_list)
+		return -1;
+
+	*ie_size += le16_to_cpu(ap_ie->len) + sizeof(struct host_cmd_tlv);
+
+	tlv_ie->type = cpu_to_le16(TLV_TYPE_MGMT_IE);
+	tlv_ie->len = ap_ie->len;
+	tlv += sizeof(struct host_cmd_tlv);
+
+	memcpy(tlv, ap_ie->ie_list, le16_to_cpu(ap_ie->len));
+
+	return 0;
+}
+
 /* Parse AP config structure and prepare TLV based command structure
  * to be sent to FW for uAP configuration
  */
@@ -323,7 +343,7 @@ mwifiex_cmd_uap_sys_config(struct host_cmd_ds_command *cmd, u16 cmd_action,
 			   u32 type, void *cmd_buf)
 {
 	u8 *tlv;
-	u16 cmd_size, param_size;
+	u16 cmd_size, param_size, ie_size;
 	struct host_cmd_ds_sys_config *sys_cfg;
 
 	cmd->command = cpu_to_le16(HostCmd_CMD_UAP_SYS_CONFIG);
@@ -339,6 +359,12 @@ mwifiex_cmd_uap_sys_config(struct host_cmd_ds_command *cmd, u16 cmd_action,
 			return -1;
 		cmd->size = cpu_to_le16(param_size);
 		break;
+	case UAP_CUSTOM_IE_I:
+		ie_size = cmd_size;
+		if (mwifiex_uap_custom_ie_prepare(tlv, cmd_buf, &ie_size))
+			return -1;
+		cmd->size = cpu_to_le16(ie_size);
+		break;
 	default:
 		return -1;
 	}
-- 
1.7.0.2

