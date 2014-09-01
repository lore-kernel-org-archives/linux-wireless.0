Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:39059 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752521AbaIAHbz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2014 03:31:55 -0400
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<huxm@marvell.com>, <yangyang@marvell.com>, <cluo@marvell.com>,
	<maithili@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 09/17] mwifiex: rename macro and variables related to API revision
Date: Mon, 1 Sep 2014 18:28:57 +0530
Message-ID: <1409576345-13717-10-git-send-email-patila@marvell.com> (sfid-20140901_093158_045747_2491606B)
In-Reply-To: <1409576345-13717-1-git-send-email-patila@marvell.com>
References: <1409576345-13717-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

We will remove 'fw' prefix from these variable and macro
names and make them generic.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c      | 18 +++++++++---------
 drivers/net/wireless/mwifiex/fw.h          |  8 ++++----
 drivers/net/wireless/mwifiex/init.c        |  4 ++--
 drivers/net/wireless/mwifiex/main.h        |  2 +-
 drivers/net/wireless/mwifiex/sta_cmd.c     |  2 +-
 drivers/net/wireless/mwifiex/sta_cmdresp.c |  2 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c   |  4 ++--
 7 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 0c21239..720e519 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -1470,7 +1470,7 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 	struct host_cmd_ds_get_hw_spec *hw_spec = &resp->params.hw_spec;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct mwifiex_ie_types_header *tlv;
-	struct hw_spec_fw_api_rev *api_rev;
+	struct hw_spec_api_rev *api_rev;
 	u16 resp_size, api_id;
 	int i, left_len, parsed_len = 0;
 
@@ -1538,23 +1538,23 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 		while (left_len > sizeof(struct mwifiex_ie_types_header)) {
 			tlv = (void *)&hw_spec->tlvs + parsed_len;
 			switch (le16_to_cpu(tlv->type)) {
-			case TLV_TYPE_FW_API_REV:
-				api_rev = (struct hw_spec_fw_api_rev *)tlv;
+			case TLV_TYPE_API_REV:
+				api_rev = (struct hw_spec_api_rev *)tlv;
 				api_id = le16_to_cpu(api_rev->api_id);
 				switch (api_id) {
 				case KEY_API_VER_ID:
-					adapter->fw_key_api_major_ver =
+					adapter->key_api_major_ver =
 							api_rev->major_ver;
-					adapter->fw_key_api_minor_ver =
+					adapter->key_api_minor_ver =
 							api_rev->minor_ver;
 					dev_dbg(adapter->dev,
-						"fw_key_api v%d.%d\n",
-						adapter->fw_key_api_major_ver,
-						adapter->fw_key_api_minor_ver);
+						"key_api v%d.%d\n",
+						adapter->key_api_major_ver,
+						adapter->key_api_minor_ver);
 					break;
 				default:
 					dev_warn(adapter->dev,
-						 "Unknown FW api_id: %d\n",
+						 "Unknown api_id: %d\n",
 						 api_id);
 					break;
 				}
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 49da2d5..adc47f3 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -83,7 +83,7 @@ enum KEY_TYPE_ID {
 #define WPA_PN_SIZE		8
 #define KEY_PARAMS_FIXED_LEN	10
 #define KEY_INDEX_MASK		0xf
-#define FW_KEY_API_VER_MAJOR_V2	2
+#define KEY_API_VER_MAJOR_V2	2
 
 #define KEY_MCAST	BIT(0)
 #define KEY_UNICAST	BIT(1)
@@ -170,7 +170,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define TLV_TYPE_COALESCE_RULE      (PROPRIETARY_TLV_BASE_ID + 154)
 #define TLV_TYPE_KEY_PARAM_V2       (PROPRIETARY_TLV_BASE_ID + 156)
 #define TLV_TYPE_TDLS_IDLE_TIMEOUT  (PROPRIETARY_TLV_BASE_ID + 194)
-#define TLV_TYPE_FW_API_REV         (PROPRIETARY_TLV_BASE_ID + 199)
+#define TLV_TYPE_API_REV	    (PROPRIETARY_TLV_BASE_ID + 199)
 
 #define MWIFIEX_TX_DATA_BUF_SIZE_2K        2048
 
@@ -844,11 +844,11 @@ struct host_cmd_ds_802_11_ps_mode_enh {
 	} params;
 } __packed;
 
-enum FW_API_VER_ID {
+enum API_VER_ID {
 	KEY_API_VER_ID = 1,
 };
 
-struct hw_spec_fw_api_rev {
+struct hw_spec_api_rev {
 	struct mwifiex_ie_types_header header;
 	__le16 api_id;
 	u8 major_ver;
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 269a277..80bda80 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -282,8 +282,8 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	adapter->max_mgmt_ie_index = MAX_MGMT_IE_INDEX;
 	adapter->empty_tx_q_cnt = 0;
 	adapter->ext_scan = true;
-	adapter->fw_key_api_major_ver = 0;
-	adapter->fw_key_api_minor_ver = 0;
+	adapter->key_api_major_ver = 0;
+	adapter->key_api_minor_ver = 0;
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index a2733b1..5439963 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -833,7 +833,7 @@ struct mwifiex_adapter {
 	struct semaphore *card_sem;
 	bool ext_scan;
 	u8 fw_api_ver;
-	u8 fw_key_api_major_ver, fw_key_api_minor_ver;
+	u8 key_api_major_ver, key_api_minor_ver;
 	struct work_struct iface_work;
 	unsigned long iface_work_flags;
 	struct memory_type_mapping *mem_type_mapping_tbl;
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 733de92..225f749 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -965,7 +965,7 @@ mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
 				u16 cmd_action, u32 cmd_oid,
 				struct mwifiex_ds_encrypt_key *enc_key)
 {
-	if (priv->adapter->fw_key_api_major_ver == FW_KEY_API_VER_MAJOR_V2)
+	if (priv->adapter->key_api_major_ver == KEY_API_VER_MAJOR_V2)
 		return mwifiex_cmd_802_11_key_material_v2(priv, cmd,
 							  cmd_action, cmd_oid,
 							  enc_key);
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 08b78ba..62866b0 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -637,7 +637,7 @@ static int mwifiex_ret_802_11_key_material_v2(struct mwifiex_private *priv,
 static int mwifiex_ret_802_11_key_material(struct mwifiex_private *priv,
 					   struct host_cmd_ds_command *resp)
 {
-	if (priv->adapter->fw_key_api_major_ver == FW_KEY_API_VER_MAJOR_V2)
+	if (priv->adapter->key_api_major_ver == KEY_API_VER_MAJOR_V2)
 		return mwifiex_ret_802_11_key_material_v2(priv, resp);
 	else
 		return mwifiex_ret_802_11_key_material_v1(priv, resp);
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 0b998fd..92f3eb8 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -880,7 +880,7 @@ static int mwifiex_sec_ioctl_set_wep_key(struct mwifiex_private *priv,
 			return -1;
 		}
 
-		if (adapter->fw_key_api_major_ver == FW_KEY_API_VER_MAJOR_V2) {
+		if (adapter->key_api_major_ver == KEY_API_VER_MAJOR_V2) {
 			memcpy(encrypt_key->key_material,
 			       wep_key->key_material, wep_key->key_length);
 			encrypt_key->key_len = wep_key->key_length;
@@ -906,7 +906,7 @@ static int mwifiex_sec_ioctl_set_wep_key(struct mwifiex_private *priv,
 			memset(&priv->wep_key[index], 0,
 			       sizeof(struct mwifiex_wep_key));
 
-		if (adapter->fw_key_api_major_ver == FW_KEY_API_VER_MAJOR_V2)
+		if (adapter->key_api_major_ver == KEY_API_VER_MAJOR_V2)
 			enc_key = encrypt_key;
 		else
 			enc_key = NULL;
-- 
1.8.1.4

