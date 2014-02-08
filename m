Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:30262 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750745AbaBHAas (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 19:30:48 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 29/30] mwifiex: parse API version from FW
Date: Fri, 7 Feb 2014 16:30:42 -0800
Message-ID: <1391819442-21239-10-git-send-email-bzhao@marvell.com> (sfid-20140208_020009_154521_4A95C7CB)
In-Reply-To: <1391819442-21239-1-git-send-email-bzhao@marvell.com>
References: <1391819442-21239-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch adds support to parse FW API version TLVs.
Currently only API version for key_material is supported.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c | 45 ++++++++++++++++++++++++++++++++++-
 drivers/net/wireless/mwifiex/fw.h     | 13 ++++++++++
 drivers/net/wireless/mwifiex/init.c   |  2 ++
 drivers/net/wireless/mwifiex/main.h   |  1 +
 4 files changed, 60 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 7711b11..2154460 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -1455,7 +1455,10 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 {
 	struct host_cmd_ds_get_hw_spec *hw_spec = &resp->params.hw_spec;
 	struct mwifiex_adapter *adapter = priv->adapter;
-	int i;
+	struct mwifiex_ie_types_header *tlv;
+	struct hw_spec_fw_api_rev *api_rev;
+	u16 resp_size, api_id;
+	int i, left_len, parsed_len = 0;
 
 	adapter->fw_cap_info = le32_to_cpu(hw_spec->fw_cap_info);
 
@@ -1513,6 +1516,46 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 		adapter->is_hw_11ac_capable = false;
 	}
 
+	resp_size = le16_to_cpu(resp->size) - S_DS_GEN;
+	if (resp_size > sizeof(struct host_cmd_ds_get_hw_spec)) {
+		/* we have variable HW SPEC information */
+		left_len = resp_size - sizeof(struct host_cmd_ds_get_hw_spec);
+		while (left_len > sizeof(struct mwifiex_ie_types_header)) {
+			tlv = (void *)&hw_spec->tlvs + parsed_len;
+			switch (le16_to_cpu(tlv->type)) {
+			case TLV_TYPE_FW_API_REV:
+				api_rev = (struct hw_spec_fw_api_rev *)tlv;
+				api_id = le16_to_cpu(api_rev->api_id);
+				switch (api_id) {
+				case KEY_API_VER_ID:
+					adapter->fw_key_api_major_ver =
+							api_rev->major_ver;
+					adapter->fw_key_api_minor_ver =
+							api_rev->minor_ver;
+					dev_dbg(adapter->dev,
+						"fw_key_api v%d.%d\n",
+						adapter->fw_key_api_major_ver,
+						adapter->fw_key_api_minor_ver);
+					break;
+				default:
+					dev_warn(adapter->dev,
+						 "Unknown FW api_id: %d\n",
+						 api_id);
+					break;
+				}
+				break;
+			default:
+				dev_warn(adapter->dev,
+					 "Unknown GET_HW_SPEC TLV type: %#x\n",
+					 le16_to_cpu(tlv->type));
+				break;
+			}
+			parsed_len += le16_to_cpu(tlv->len) +
+				      sizeof(struct mwifiex_ie_types_header);
+			left_len -= parsed_len;
+		}
+	}
+
 	dev_dbg(adapter->dev, "info: GET_HW_SPEC: fw_release_number- %#x\n",
 		adapter->fw_release_number);
 	dev_dbg(adapter->dev, "info: GET_HW_SPEC: permanent addr: %pM\n",
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 2344abd..5808f23 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -159,6 +159,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define TLV_TYPE_PWK_CIPHER         (PROPRIETARY_TLV_BASE_ID + 145)
 #define TLV_TYPE_GWK_CIPHER         (PROPRIETARY_TLV_BASE_ID + 146)
 #define TLV_TYPE_COALESCE_RULE      (PROPRIETARY_TLV_BASE_ID + 154)
+#define TLV_TYPE_FW_API_REV         (PROPRIETARY_TLV_BASE_ID + 199)
 
 #define MWIFIEX_TX_DATA_BUF_SIZE_2K        2048
 
@@ -751,6 +752,17 @@ struct host_cmd_ds_802_11_ps_mode_enh {
 	} params;
 } __packed;
 
+enum FW_API_VER_ID {
+	KEY_API_VER_ID = 1,
+};
+
+struct hw_spec_fw_api_rev {
+	struct mwifiex_ie_types_header header;
+	__le16 api_id;
+	u8 major_ver;
+	u8 minor_ver;
+} __packed;
+
 struct host_cmd_ds_get_hw_spec {
 	__le16 hw_if_version;
 	__le16 version;
@@ -772,6 +784,7 @@ struct host_cmd_ds_get_hw_spec {
 	__le32 reserved_6;
 	__le32 dot_11ac_dev_cap;
 	__le32 dot_11ac_mcs_support;
+	u8 tlvs[0];
 } __packed;
 
 struct host_cmd_ds_802_11_rssi_info {
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 9dc8059..a4cd2cb 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -283,6 +283,8 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	adapter->max_mgmt_ie_index = MAX_MGMT_IE_INDEX;
 	adapter->empty_tx_q_cnt = 0;
 	adapter->ext_scan = true;
+	adapter->fw_key_api_major_ver = 0;
+	adapter->fw_key_api_minor_ver = 0;
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 9bb66ea..a221fd3 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -801,6 +801,7 @@ struct mwifiex_adapter {
 	atomic_t pending_bridged_pkts;
 	struct semaphore *card_sem;
 	bool ext_scan;
+	u8 fw_key_api_major_ver, fw_key_api_minor_ver;
 };
 
 int mwifiex_init_lock_list(struct mwifiex_adapter *adapter);
-- 
1.8.2.3

