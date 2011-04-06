Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:45398 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757095Ab1DFXmu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2011 19:42:50 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/2] mwifiex: use common keyinfo bitmap for different key types
Date: Wed,  6 Apr 2011 16:46:56 -0700
Message-Id: <1302133616-6595-2-git-send-email-bzhao@marvell.com>
In-Reply-To: <1302133616-6595-1-git-send-email-bzhao@marvell.com>
References: <1302133616-6595-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

Instead of having separate key information definitions for
each type of key, a common key information bitmap is used.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h          |   27 +++------------------------
 drivers/net/wireless/mwifiex/sta_cmd.c     |   27 +++++++++++++--------------
 drivers/net/wireless/mwifiex/sta_cmdresp.c |    3 +--
 drivers/net/wireless/mwifiex/sta_ioctl.c   |    3 +--
 4 files changed, 18 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 2b93811..f8c008f 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -72,33 +72,12 @@ enum KEY_TYPE_ID {
 	KEY_TYPE_ID_AES,
 	KEY_TYPE_ID_WAPI,
 };
-
-enum KEY_INFO_WEP {
-	KEY_INFO_WEP_MCAST = 0x01,
-	KEY_INFO_WEP_UNICAST = 0x02,
-	KEY_INFO_WEP_ENABLED = 0x04
-};
-
-enum KEY_INFO_TKIP {
-	KEY_INFO_TKIP_MCAST = 0x01,
-	KEY_INFO_TKIP_UNICAST = 0x02,
-	KEY_INFO_TKIP_ENABLED = 0x04
-};
-
-enum KEY_INFO_AES {
-	KEY_INFO_AES_MCAST = 0x01,
-	KEY_INFO_AES_UNICAST = 0x02,
-	KEY_INFO_AES_ENABLED = 0x04
-};
+#define KEY_MCAST	BIT(0)
+#define KEY_UNICAST	BIT(1)
+#define KEY_ENABLED	BIT(2)
 
 #define WAPI_KEY_LEN			50
 
-enum KEY_INFO_WAPI {
-	KEY_INFO_WAPI_MCAST = 0x01,
-	KEY_INFO_WAPI_UNICAST = 0x02,
-	KEY_INFO_WAPI_ENABLED = 0x04
-};
-
 #define MAX_POLL_TRIES			100
 
 #define MAX_MULTI_INTERFACE_POLL_TRIES  1000
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 6fff261..19de652 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -500,9 +500,8 @@ mwifiex_set_keyparamset_wep(struct mwifiex_private *priv,
 			key_param_set->key_type_id =
 				cpu_to_le16(KEY_TYPE_ID_WEP);
 			key_param_set->key_info =
-				cpu_to_le16(KEY_INFO_WEP_ENABLED |
-					    KEY_INFO_WEP_UNICAST |
-					    KEY_INFO_WEP_MCAST);
+				cpu_to_le16(KEY_ENABLED | KEY_UNICAST |
+					    KEY_MCAST);
 			key_param_set->key_len =
 				cpu_to_le16(priv->wep_key[i].key_length);
 			/* Set WEP key index */
@@ -589,10 +588,10 @@ static int mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
 			cpu_to_le16(KEY_TYPE_ID_WAPI);
 		if (cmd_oid == KEY_INFO_ENABLED)
 			key_material->key_param_set.key_info =
-				cpu_to_le16(KEY_INFO_WAPI_ENABLED);
+				cpu_to_le16(KEY_ENABLED);
 		else
 			key_material->key_param_set.key_info =
-				cpu_to_le16(!KEY_INFO_WAPI_ENABLED);
+				cpu_to_le16(!KEY_ENABLED);
 
 		key_material->key_param_set.key[0] = enc_key->key_index;
 		if (!priv->sec_info.wapi_key_on)
@@ -604,10 +603,10 @@ static int mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
 		if (0 != memcmp(enc_key->mac_addr, bc_mac, sizeof(bc_mac))) {
 			/* WAPI pairwise key: unicast */
 			key_material->key_param_set.key_info |=
-				cpu_to_le16(KEY_INFO_WAPI_UNICAST);
+				cpu_to_le16(KEY_UNICAST);
 		} else {	/* WAPI group key: multicast */
 			key_material->key_param_set.key_info |=
-				cpu_to_le16(KEY_INFO_WAPI_MCAST);
+				cpu_to_le16(KEY_MCAST);
 			priv->sec_info.wapi_key_on = true;
 		}
 
@@ -634,32 +633,32 @@ static int mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
 			cpu_to_le16(KEY_TYPE_ID_AES);
 		if (cmd_oid == KEY_INFO_ENABLED)
 			key_material->key_param_set.key_info =
-				cpu_to_le16(KEY_INFO_AES_ENABLED);
+				cpu_to_le16(KEY_ENABLED);
 		else
 			key_material->key_param_set.key_info =
-				cpu_to_le16(!KEY_INFO_AES_ENABLED);
+				cpu_to_le16(!KEY_ENABLED);
 
 		if (enc_key->key_index & MWIFIEX_KEY_INDEX_UNICAST)
 				/* AES pairwise key: unicast */
 			key_material->key_param_set.key_info |=
-				cpu_to_le16(KEY_INFO_AES_UNICAST);
+				cpu_to_le16(KEY_UNICAST);
 		else		/* AES group key: multicast */
 			key_material->key_param_set.key_info |=
-				cpu_to_le16(KEY_INFO_AES_MCAST);
+				cpu_to_le16(KEY_MCAST);
 	} else if (enc_key->key_len == WLAN_KEY_LEN_TKIP) {
 		dev_dbg(priv->adapter->dev, "cmd: WPA_TKIP\n");
 		key_material->key_param_set.key_type_id =
 			cpu_to_le16(KEY_TYPE_ID_TKIP);
 		key_material->key_param_set.key_info =
-			cpu_to_le16(KEY_INFO_TKIP_ENABLED);
+			cpu_to_le16(KEY_ENABLED);
 
 		if (enc_key->key_index & MWIFIEX_KEY_INDEX_UNICAST)
 				/* TKIP pairwise key: unicast */
 			key_material->key_param_set.key_info |=
-				cpu_to_le16(KEY_INFO_TKIP_UNICAST);
+				cpu_to_le16(KEY_UNICAST);
 		else		/* TKIP group key: multicast */
 			key_material->key_param_set.key_info |=
-				cpu_to_le16(KEY_INFO_TKIP_MCAST);
+				cpu_to_le16(KEY_MCAST);
 	}
 
 	if (key_material->key_param_set.key_type_id) {
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 74add45..648df69 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -574,8 +574,7 @@ static int mwifiex_ret_802_11_key_material(struct mwifiex_private *priv,
 		&resp->params.key_material;
 
 	if (le16_to_cpu(key->action) == HostCmd_ACT_GEN_SET) {
-		if ((le16_to_cpu(key->key_param_set.key_info) &
-		     KEY_INFO_TKIP_MCAST)) {
+		if ((le16_to_cpu(key->key_param_set.key_info) & KEY_MCAST)) {
 			dev_dbg(priv->adapter->dev, "info: key: GTK is set\n");
 			priv->wpa_is_gtk_set = true;
 			priv->scan_block = false;
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index b163507..2fcdbc2 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -1729,8 +1729,7 @@ static int mwifiex_sec_ioctl_set_wpa_key(struct mwifiex_adapter *adapter,
 		       sizeof(ibss_key->key_param_set.key_len));
 		ibss_key->key_param_set.key_type_id
 			= cpu_to_le16(KEY_TYPE_ID_TKIP);
-		ibss_key->key_param_set.key_info
-			= cpu_to_le16(KEY_INFO_TKIP_ENABLED);
+		ibss_key->key_param_set.key_info = cpu_to_le16(KEY_ENABLED);
 
 		/* Send the key as GTK to firmware */
 		encrypt_key->key_index = ~MWIFIEX_KEY_INDEX_UNICAST;
-- 
1.7.0.2

