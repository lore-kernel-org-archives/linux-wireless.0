Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:42483 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab1CQAGQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 20:06:16 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 05/11] mwifiex: remove esuppmode command from debugfs
Date: Wed, 16 Mar 2011 17:09:28 -0700
Message-Id: <1300320574-10793-6-git-send-email-bzhao@marvell.com>
In-Reply-To: <1300320574-10793-1-git-send-email-bzhao@marvell.com>
References: <1300320574-10793-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

The command was used to get current security configuration
when embedded supplicant is enabled. As we are removing embedded
supplicant support, the command is no longer useful.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/README        |   27 ------------
 drivers/net/wireless/mwifiex/debugfs.c     |   46 --------------------
 drivers/net/wireless/mwifiex/fw.h          |   51 ----------------------
 drivers/net/wireless/mwifiex/ioctl.h       |    6 ---
 drivers/net/wireless/mwifiex/main.h        |    3 -
 drivers/net/wireless/mwifiex/sta_cmd.c     |   27 ------------
 drivers/net/wireless/mwifiex/sta_cmdresp.c |   63 ----------------------------
 drivers/net/wireless/mwifiex/sta_ioctl.c   |   59 --------------------------
 8 files changed, 0 insertions(+), 282 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/README b/drivers/net/wireless/mwifiex/README
index 7f25d1a..bd79765 100644
--- a/drivers/net/wireless/mwifiex/README
+++ b/drivers/net/wireless/mwifiex/README
@@ -402,31 +402,4 @@ passphrase
 		echo "2;ssid=Mrvl" > passphrase
 		echo "2" > passphrase    : Clear all profiles and disable embedded supplicant
 
-esuppmode
-	This command is used to get the current RSN mode and active pairwise/group
-	cipher for WPA/WPA2 mode.
-	Note: This command is available only when STA is connected.
-
-	These are bits settings used to indicate each RSN mode.
-		Bit 0    : No RSN
-		Bit 1-2  : RFU
-		Bit 3    : WPA
-		Bit 4    : WPA-NONE
-		Bit 5    : WPA2
-		Bit 6    : AES CCKM
-		Bit 7-15 : RFU
-
-	These are bits settings used to indicate each pairwise and group cipher.
-		Bit 0    : RFU
-		Bit 1    : RFU
-		Bit 2    : TKIP
-		Bit 3    : AES CCKM
-		Bit 2-7  : RFU
-
-	Example:
-		cat esuppmode          : Get RSN mode and pairwise/group cipher
-		8 4 4
-		(The current RSN mode is WPA, active pairwise cipher is TKIP and
-		 active group cipher is TKIP.)
-
 ===============================================================================
diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index cccaf93..35786a7 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -1243,50 +1243,6 @@ mwifiex_passphrase_read(struct file *file, char __user *ubuf,
 	return ret;
 }
 
-/*
- * Proc esuppmode file read handler.
- *
- * This function is called when the 'esuppmode' file is opened for reading
- * It prints following security information -
- *      - RSN mode
- *      - active pairwise cipher
- *      - active groupwise cipher
- */
-static ssize_t
-mwifiex_esuppmode_read(struct file *file, char __user *ubuf,
-		    size_t count, loff_t *ppos)
-{
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) file->private_data;
-	unsigned long page = get_zeroed_page(GFP_KERNEL);
-	char *p = (char *) page;
-	ssize_t ret = 0;
-	struct mwifiex_ds_esupp_mode esupp_mode;
-
-	if (!p)
-		return -ENOMEM;
-
-	memset(&esupp_mode, 0, sizeof(struct mwifiex_ds_esupp_mode));
-	ret = mwifiex_get_esupp_mode(priv, &esupp_mode);
-	if (ret)
-		goto free_and_exit;
-
-	p += sprintf(p, "\n"
-		     "RSN mode               %u\n"
-		     "active pairwise cipher %u\n"
-		     "active group cipher    %u\n",
-		     esupp_mode.rsn_mode,
-		     esupp_mode.act_paircipher,
-		     esupp_mode.act_groupcipher);
-
-	ret = simple_read_from_buffer(ubuf, count, ppos, (char *) page,
-				      (unsigned long) p - page);
-
-free_and_exit:
-	free_page(page);
-	return ret;
-}
-
 #define MWIFIEX_DFS_ADD_FILE(name) do {                                 \
 	if (!debugfs_create_file(#name, 0644, priv->dfs_dev_dir,        \
 			priv, &mwifiex_dfs_##name##_fops))              \
@@ -1324,7 +1280,6 @@ MWIFIEX_DFS_FILE_OPS(regrdwr);
 MWIFIEX_DFS_FILE_OPS(rdeeprom);
 MWIFIEX_DFS_FILE_OPS(txbufcfg);
 MWIFIEX_DFS_FILE_OPS(passphrase);
-MWIFIEX_DFS_FILE_READ_OPS(esuppmode);
 
 /*
  * This function creates the debug FS directory structure and the files.
@@ -1352,7 +1307,6 @@ mwifiex_dev_debugfs_init(struct mwifiex_private *priv)
 	MWIFIEX_DFS_ADD_FILE(rdeeprom);
 	MWIFIEX_DFS_ADD_FILE(txbufcfg);
 	MWIFIEX_DFS_ADD_FILE(passphrase);
-	MWIFIEX_DFS_ADD_FILE(esuppmode);
 
 	return;
 }
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 11d2539..e3b62bb 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -154,8 +154,6 @@ enum MWIFIEX_802_11_WEP_STATUS {
 
 #define TLV_TYPE_CHANNELBANDLIST    (PROPRIETARY_TLV_BASE_ID + 42)
 #define TLV_TYPE_WAPI_IE            (PROPRIETARY_TLV_BASE_ID + 94)
-#define TLV_TYPE_ENCRYPTION_PROTO   (PROPRIETARY_TLV_BASE_ID + 64)
-#define TLV_TYPE_CIPHER             (PROPRIETARY_TLV_BASE_ID + 66)
 #define TLV_TYPE_PMK                (PROPRIETARY_TLV_BASE_ID + 68)
 #define TLV_TYPE_PASSPHRASE         (PROPRIETARY_TLV_BASE_ID + 60)
 #define TLV_TYPE_BSSID              (PROPRIETARY_TLV_BASE_ID + 35)
@@ -323,7 +321,6 @@ enum MWIFIEX_802_11_WEP_STATUS {
 #define HostCmd_CMD_FUNC_INIT                         0x00a9
 #define HostCmd_CMD_FUNC_SHUTDOWN                     0x00aa
 #define HostCmd_CMD_SUPPLICANT_PMK                    0x00c4
-#define HostCmd_CMD_SUPPLICANT_PROFILE                0x00c5
 #define HostCmd_CMD_11N_CFG                           0x00cd
 #define HostCmd_CMD_11N_ADDBA_REQ                     0x00ce
 #define HostCmd_CMD_11N_ADDBA_RSP                     0x00cf
@@ -352,7 +349,6 @@ enum ENH_PS_MODES {
 #define HostCmd_RET_BIT                       0x8000
 #define HostCmd_ACT_GEN_GET                   0x0000
 #define HostCmd_ACT_GEN_SET                   0x0001
-#define HostCmd_ACT_GEN_GET_CURRENT           0x0003
 #define HostCmd_ACT_GEN_REMOVE                0x0004
 #define HostCmd_ACT_SET_BOTH                  0x0003
 #define HostCmd_ACT_GET_BOTH                  0x000c
@@ -1270,39 +1266,6 @@ struct mwifiex_ie_types_passphrase {
 	char passphrase[1];
 } __packed;
 
-/* unicastcipher:
- *      Bit 0   : RFU
- *      Bit 1   : RFU
- *      Bit 2   : TKIP
- *      Bit 3   : AES CCKM
- *      Bit 2-7 : RFU
- * multicastcipher:
- *      Bit 0   : WEP40
- *      Bit 1   : WEP104
- *      Bit 2   : TKIP
- *      Bit 3   : AES
- *      Bit 4-7 : Reserved for now
- */
-struct mwifiex_ie_types_cipher {
-	struct mwifiex_ie_types_header header;
-	u8 pair_cipher;
-	u8 group_cipher;
-} __packed;
-
-/* rsnMode:
- *      Bit 0    : No RSN
- *      Bit 1-2  : RFU
- *      Bit 3    : WPA
- *      Bit 4    : WPA-NONE
- *      Bit 5    : WPA2
- *      Bit 6    : AES CCKM
- *      Bit 7-15 : RFU
- */
-struct mwifiex_ie_types_encrproto {
-	struct mwifiex_ie_types_header header;
-	__le16 rsn_mode;
-} __packed;
-
 struct mwifiex_ie_types_bssid {
 	struct mwifiex_ie_types_header header;
 	u8 bssid[ETH_ALEN];
@@ -1324,19 +1287,6 @@ struct host_cmd_ds_802_11_supplicant_pmk {
 	 */
 } __packed;
 
-/*
- * This struct will GET the Supplicant supported bitmaps
- * The GET_CURRENT action will get the network profile used
- * for the current assocation.
- * Define data structure for host_cmd_ds_802_11_supplicant_profile
- */
-struct host_cmd_ds_802_11_supplicant_profile {
-	__le16 action;				/* GET/SET/GET_CURRENT */
-	__le16 reserved;
-	u8 tlv_buf[1];
-	/* mwifiex_ie_types_encrproto */
-} __packed;
-
 struct host_cmd_ds_mac_reg_access {
 	__le16 action;
 	__le16 offset;
@@ -1442,7 +1392,6 @@ struct host_cmd_ds_command {
 		struct host_cmd_ds_wmm_get_status get_wmm_status;
 		struct host_cmd_ds_802_11_key_material key_material;
 		struct host_cmd_ds_802_11_supplicant_pmk esupp_psk;
-		struct host_cmd_ds_802_11_supplicant_profile esupp_profile;
 		struct host_cmd_ds_version_ext verext;
 		struct host_cmd_ds_802_11_ibss_status ibss_coalescing;
 		struct host_cmd_ds_mac_reg_access mac_reg;
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index 115476a..0f61791 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -333,12 +333,6 @@ struct mwifiex_ds_passphrase {
 	} psk;
 };
 
-struct mwifiex_ds_esupp_mode {
-	u32 rsn_mode;
-	u32 act_paircipher;
-	u32 act_groupcipher;
-};
-
 struct mwifiex_rate_cfg {
 	u32 action;
 	u32 is_rate_auto;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 7f29708..e6016b1 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1083,9 +1083,6 @@ int mwifiex_main_process(struct mwifiex_adapter *);
 int mwifiex_set_passphrase(struct mwifiex_private *priv, int action,
 			   struct mwifiex_ds_passphrase *ds_passphrase);
 
-int mwifiex_get_esupp_mode(struct mwifiex_private *priv,
-			   struct mwifiex_ds_esupp_mode *esupp_mode);
-
 int mwifiex_bss_ioctl_mode(struct mwifiex_private *,
 			   struct mwifiex_wait_queue *,
 			   u16 action, int *mode);
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 1d12fc9..db87b7d 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -823,29 +823,6 @@ mwifiex_cmd_802_11_supplicant_pmk(struct mwifiex_private  *priv,
 }
 
 /*
- * This function prepares supplicant profile command.
- *
- * Preparation includes -
- *      - Setting command ID and proper size
- *      - Ensuring correct endian-ness
- */
-static int mwifiex_cmd_802_11_supplicant_profile(
-		struct mwifiex_private *priv,
-		struct host_cmd_ds_command *cmd,
-		u16 cmd_action)
-{
-	struct host_cmd_ds_802_11_supplicant_profile *sup_profile =
-					&cmd->params.esupp_profile;
-
-	cmd->size = cpu_to_le16(
-			sizeof(struct host_cmd_ds_802_11_supplicant_profile) +
-			S_DS_GEN - 1);
-	cmd->command = cpu_to_le16(HostCmd_CMD_SUPPLICANT_PROFILE);
-	sup_profile->action = cpu_to_le16(cmd_action);
-	return 0;
-}
-
-/*
  * This function prepares command to set/get 11d domain information.
  *
  * Preparation includes -
@@ -1221,10 +1198,6 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 		ret = mwifiex_cmd_802_11_supplicant_pmk(priv, cmd_ptr,
 						cmd_action, data_buf);
 		break;
-	case HostCmd_CMD_SUPPLICANT_PROFILE:
-		ret = mwifiex_cmd_802_11_supplicant_profile(priv, cmd_ptr,
-						cmd_action);
-		break;
 	case HostCmd_CMD_802_11D_DOMAIN_INFO:
 		ret = mwifiex_cmd_802_11d_domain_info(priv, cmd_ptr,
 						cmd_action);
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 6850ea8..f94439d 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -740,65 +740,6 @@ static int mwifiex_ret_802_11_supplicant_pmk(struct mwifiex_private *priv,
 }
 
 /*
- * This function handles the command response of get supllicant profile
- *
- * Handling includes saving following supllicant profile information in
- * driver
- *         - RSN mode
- *         - pairwise cipher
- *         - group cipher
- */
-static int mwifiex_ret_802_11_supplicant_profile(struct mwifiex_private *priv,
-						 struct host_cmd_ds_command
-						 *resp, void *data_buf)
-{
-	struct host_cmd_ds_802_11_supplicant_profile *psup_profile =
-		&resp->params.esupp_profile;
-	struct mwifiex_ie_types_header *head;
-	struct mwifiex_ie_types_encrproto *encr_proto_tlv = NULL;
-	struct mwifiex_ie_types_cipher *pcipher_tlv = NULL;
-	struct mwifiex_ds_esupp_mode *esupp_mode = NULL;
-	u8 *tlv;
-	int len;
-
-	len = le16_to_cpu(resp->size) - S_DS_GEN - sizeof(u16);
-	tlv = psup_profile->tlv_buf;
-	if (data_buf) {
-		esupp_mode = (struct mwifiex_ds_esupp_mode *)data_buf;
-		while (len > 0) {
-			head = (struct mwifiex_ie_types_header *) tlv;
-			switch (le16_to_cpu(head->type)) {
-			case TLV_TYPE_ENCRYPTION_PROTO:
-				encr_proto_tlv =
-					(struct mwifiex_ie_types_encrproto *)
-					head;
-				esupp_mode->rsn_mode =
-					le16_to_cpu(encr_proto_tlv->rsn_mode);
-				dev_dbg(priv->adapter->dev, "info: rsn_mode=0x%x\n",
-					esupp_mode->rsn_mode);
-				break;
-			case TLV_TYPE_CIPHER:
-				pcipher_tlv =
-					(struct mwifiex_ie_types_cipher *)head;
-				esupp_mode->act_paircipher =
-					pcipher_tlv->pair_cipher;
-				esupp_mode->act_groupcipher =
-					pcipher_tlv->group_cipher;
-				dev_dbg(priv->adapter->dev,
-					"info: paircipher=0x%x, groupcipher=0x%x\n",
-					      esupp_mode->act_paircipher,
-					      esupp_mode->act_groupcipher);
-				break;
-			}
-			len -= (le16_to_cpu(head->len) - sizeof(*head));
-			tlv = tlv + (le16_to_cpu(head->len) + sizeof(*head));
-		}
-	}
-
-	return 0;
-}
-
-/*
  * This function handles the command response of get 11d domain information.
  */
 static int mwifiex_ret_802_11d_domain_info(struct mwifiex_private *priv,
@@ -1134,10 +1075,6 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv,
 	case HostCmd_CMD_SUPPLICANT_PMK:
 		ret = mwifiex_ret_802_11_supplicant_pmk(priv, resp, data_buf);
 		break;
-	case HostCmd_CMD_SUPPLICANT_PROFILE:
-		ret = mwifiex_ret_802_11_supplicant_profile(priv, resp,
-								data_buf);
-		break;
 	case HostCmd_CMD_802_11D_DOMAIN_INFO:
 		ret = mwifiex_ret_802_11d_domain_info(priv, resp);
 		break;
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 5bf005c..605dd37 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -2035,32 +2035,6 @@ int mwifiex_sec_ioctl_passphrase(struct mwifiex_private *priv,
 }
 
 /*
- * IOCTL request handler to get esupplicant mode.
- *
- * This function prepares corresponding firmware command and
- * issues it.
- */
-static int
-mwifiex_sec_ioctl_esupp_mode(struct mwifiex_private *priv,
-			     struct mwifiex_wait_queue *wait,
-			     struct mwifiex_ds_esupp_mode *esupp_mode)
-{
-	int ret = 0;
-
-	if (priv->media_connected != true)
-		return -1;
-
-	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_SUPPLICANT_PROFILE,
-				  HostCmd_ACT_GEN_GET_CURRENT, 0,
-				  wait, esupp_mode);
-	if (!ret)
-		ret = -EINPROGRESS;
-
-	return ret;
-}
-
-/*
  * Sends IOCTL request to set host sleep configurations.
  *
  * This function allocates the IOCTL request buffer, fills it
@@ -2802,39 +2776,6 @@ int mwifiex_set_passphrase(struct mwifiex_private *priv, int action,
 }
 
 /*
- * Sends IOCTL request to get esupplicant mode.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-int mwifiex_get_esupp_mode(struct mwifiex_private *priv,
-				  struct mwifiex_ds_esupp_mode *esupp_mode)
-{
-	int ret = 0;
-	int status = 0;
-	struct mwifiex_ds_esupp_mode esuppmode;
-	struct mwifiex_wait_queue *wait = NULL;
-
-	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
-	if (!wait)
-		return -ENOMEM;
-	status = mwifiex_sec_ioctl_esupp_mode(priv, wait, &esuppmode);
-
-	if (mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT)) {
-		ret =  -EFAULT;
-		goto done;
-	}
-
-	if (esupp_mode)
-		memcpy(esupp_mode, &esuppmode,
-				sizeof(struct mwifiex_ds_esupp_mode));
-
-done:
-	kfree(wait);
-	return ret;
-}
-
-/*
  * This function sets a generic IE. In addition to generic IE, it can
  * also handle WPA, WPA2 and WAPI IEs.
  */
-- 
1.7.0.2

