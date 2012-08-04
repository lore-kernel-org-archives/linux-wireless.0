Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na6sys009bog028.obsmtp.com ([74.125.150.102]:41064 "EHLO
	na6sys009bog028.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753404Ab2HDBUQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2012 21:20:16 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 16/16] mwifiex: add AES_CMAC support in key_material cmd
Date: Fri,  3 Aug 2012 18:06:14 -0700
Message-Id: <1344042374-6892-17-git-send-email-bzhao@marvell.com> (sfid-20120804_032021_983452_565A3419)
In-Reply-To: <1344042374-6892-1-git-send-email-bzhao@marvell.com>
References: <1344042374-6892-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ying Luo <luoy@marvell.com>

The sequence counter will be sent to firmware via key_material
command.

Signed-off-by: Ying Luo <luoy@marvell.com>
Signed-off-by: Stone Piao <piaoyun@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h      |    9 +++++
 drivers/net/wireless/mwifiex/sta_cmd.c |   53 ++++++++++++++++++++++++++------
 2 files changed, 52 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 1c1274d..ae06f31 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -65,10 +65,12 @@ enum KEY_TYPE_ID {
 	KEY_TYPE_ID_TKIP,
 	KEY_TYPE_ID_AES,
 	KEY_TYPE_ID_WAPI,
+	KEY_TYPE_ID_AES_CMAC,
 };
 #define KEY_MCAST	BIT(0)
 #define KEY_UNICAST	BIT(1)
 #define KEY_ENABLED	BIT(2)
+#define KEY_IGTK	BIT(10)
 
 #define WAPI_KEY_LEN			50
 
@@ -583,6 +585,13 @@ struct mwifiex_ie_type_key_param_set {
 	u8 key[50];
 } __packed;
 
+#define IGTK_PN_LEN		8
+
+struct mwifiex_cmac_param {
+	u8 ipn[IGTK_PN_LEN];
+	u8 key[WLAN_KEY_LEN_AES_CMAC];
+} __packed;
+
 struct host_cmd_ds_802_11_key_material {
 	__le16 action;
 	struct mwifiex_ie_type_key_param_set key_param_set;
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index a4a4a19..9af9692 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -621,23 +621,38 @@ mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
 		return ret;
 	}
 	if (enc_key->key_len == WLAN_KEY_LEN_CCMP) {
-		dev_dbg(priv->adapter->dev, "cmd: WPA_AES\n");
-		key_material->key_param_set.key_type_id =
+		if (enc_key->is_igtk_key) {
+			dev_dbg(priv->adapter->dev, "cmd: CMAC_AES\n");
+			key_material->key_param_set.key_type_id =
+					cpu_to_le16(KEY_TYPE_ID_AES_CMAC);
+			if (cmd_oid == KEY_INFO_ENABLED)
+				key_material->key_param_set.key_info =
+						cpu_to_le16(KEY_ENABLED);
+			else
+				key_material->key_param_set.key_info =
+						cpu_to_le16(!KEY_ENABLED);
+
+			key_material->key_param_set.key_info |=
+							cpu_to_le16(KEY_IGTK);
+		} else {
+			dev_dbg(priv->adapter->dev, "cmd: WPA_AES\n");
+			key_material->key_param_set.key_type_id =
 						cpu_to_le16(KEY_TYPE_ID_AES);
-		if (cmd_oid == KEY_INFO_ENABLED)
-			key_material->key_param_set.key_info =
+			if (cmd_oid == KEY_INFO_ENABLED)
+				key_material->key_param_set.key_info =
 						cpu_to_le16(KEY_ENABLED);
-		else
-			key_material->key_param_set.key_info =
+			else
+				key_material->key_param_set.key_info =
 						cpu_to_le16(!KEY_ENABLED);
 
-		if (enc_key->key_index & MWIFIEX_KEY_INDEX_UNICAST)
+			if (enc_key->key_index & MWIFIEX_KEY_INDEX_UNICAST)
 				/* AES pairwise key: unicast */
-			key_material->key_param_set.key_info |=
+				key_material->key_param_set.key_info |=
 						cpu_to_le16(KEY_UNICAST);
-		else		/* AES group key: multicast */
-			key_material->key_param_set.key_info |=
+			else	/* AES group key: multicast */
+				key_material->key_param_set.key_info |=
 							cpu_to_le16(KEY_MCAST);
+		}
 	} else if (enc_key->key_len == WLAN_KEY_LEN_TKIP) {
 		dev_dbg(priv->adapter->dev, "cmd: WPA_TKIP\n");
 		key_material->key_param_set.key_type_id =
@@ -668,6 +683,24 @@ mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
 		key_param_len = (u16)(enc_key->key_len + KEYPARAMSET_FIXED_LEN)
 				+ sizeof(struct mwifiex_ie_types_header);
 
+		if (le16_to_cpu(key_material->key_param_set.key_type_id) ==
+							KEY_TYPE_ID_AES_CMAC) {
+			struct mwifiex_cmac_param *param =
+					(void *)key_material->key_param_set.key;
+
+			memcpy(param->ipn, enc_key->pn, IGTK_PN_LEN);
+			memcpy(param->key, enc_key->key_material,
+			       enc_key->key_len);
+
+			key_param_len = sizeof(struct mwifiex_cmac_param);
+			key_material->key_param_set.key_len =
+						cpu_to_le16(key_param_len);
+			key_param_len += KEYPARAMSET_FIXED_LEN;
+			key_material->key_param_set.length =
+						cpu_to_le16(key_param_len);
+			key_param_len += sizeof(struct mwifiex_ie_types_header);
+		}
+
 		cmd->size = cpu_to_le16(sizeof(key_material->action) + S_DS_GEN
 					+ key_param_len);
 
-- 
1.7.0.2

