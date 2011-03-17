Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:42499 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab1CQAGQ (ORCPT
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
Subject: [PATCH 06/11] mwifiex: remove passphrase command from debugfs
Date: Wed, 16 Mar 2011 17:09:29 -0700
Message-Id: <1300320574-10793-7-git-send-email-bzhao@marvell.com>
In-Reply-To: <1300320574-10793-1-git-send-email-bzhao@marvell.com>
References: <1300320574-10793-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

and get rid of all remaining embedded supplicant related code.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/README        |   41 -------
 drivers/net/wireless/mwifiex/debugfs.c     |  173 ----------------------------
 drivers/net/wireless/mwifiex/fw.h          |   35 ------
 drivers/net/wireless/mwifiex/init.c        |    1 -
 drivers/net/wireless/mwifiex/ioctl.h       |   29 -----
 drivers/net/wireless/mwifiex/main.c        |  112 ------------------
 drivers/net/wireless/mwifiex/main.h        |   15 ---
 drivers/net/wireless/mwifiex/scan.c        |   33 +-----
 drivers/net/wireless/mwifiex/sta_cmd.c     |  117 -------------------
 drivers/net/wireless/mwifiex/sta_cmdresp.c |  112 ------------------
 drivers/net/wireless/mwifiex/sta_ioctl.c   |  100 ----------------
 11 files changed, 5 insertions(+), 763 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/README b/drivers/net/wireless/mwifiex/README
index bd79765..91fe1f9 100644
--- a/drivers/net/wireless/mwifiex/README
+++ b/drivers/net/wireless/mwifiex/README
@@ -361,45 +361,4 @@ getlog
 
 	cat getlog
 
-passphrase
-	This command is used to set/get passphrase for WPA-PSK/WPA2-PSK mode.
-	echo "<m>" > passphrase
-	cat passphrase
-
-	Where <m>
-		ASCII string for ssid/passphrase/psk.
-
-	1) "0;<ssid=valid ssid>" - This will get the passphrase, AKMP
-	for specified ssid. "cat passphrase" will show the get results.
-
-	Example:
-		echo "0;ssid=Mrvl" > passphrase
-		cat passphrase
-
-	2) "1;<psk=64 byte hexpsk>;<passphrase=1-63 byte passphare>
-	<ssid=valid ssid>" - Passphrase and psk cannot be provided for the same SSID.
-	This command takes only one SSID at a time, If ssid= is present it should contain
-	a passphrase or psk. If no arguments are provided then AKMP=802.1x, and passphrase
-	should be provided after association.
-	End of each parameter should be followed by a ';'(except for the last parameter)
-	as the delimiter. If ';' or '/' has to be used in an SSID then a '/' should be preceded
-	to ';' or '/' as a escape.
-
-	Examples:
-		echo "1;ssid=mrvlAP;passphrase=abcdefgd" > passphrase
-		echo "1;ssid=mrvl AP;psk=<64 bytes hexpsk>" > passphrase
-
-		If user wants to input the ssid as "mrvl; AP" then command has to be
-		echo "1;ssid=Mrvl/; AP;passphrase=abcdefgh" > passphrase
-
-		If user wants to input the ssid as "//;" then command has to be
-		echo "1;ssid=/////;;passphrase=abcdefgh" > passphrase
-
-	3) "2;<ssid=valid ssid>" - This will clear the passphrase
-	for specified ssid, if none specified then it will clear all.
-
-	Examples:
-		echo "2;ssid=Mrvl" > passphrase
-		echo "2" > passphrase    : Clear all profiles and disable embedded supplicant
-
 ===============================================================================
diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index 35786a7..48e3f72 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -1072,177 +1072,6 @@ mwifiex_txbufcfg_read(struct file *file, char __user *ubuf,
 	return ret;
 }
 
-static struct mwifiex_ds_passphrase saved_ds_passphrase;
-
-/*
- * Proc passphrase file write handler.
- *
- * This function is called when the 'passphrase' file is opened for writing
- *
- * This function can be used to get/set/clear passphrase/psk for specified SSID.
- */
-static ssize_t
-mwifiex_passphrase_write(struct file *file,
-		      const char __user *ubuf, size_t count, loff_t *ppos)
-{
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) file->private_data;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *) addr;
-	size_t buf_size = min(count, (size_t) (PAGE_SIZE - 1));
-	int action = -1, ret = 0;
-	char *begin, *end, *opt;
-	struct mwifiex_ds_passphrase ds_passphrase;
-
-	if (!buf)
-		return -ENOMEM;
-
-	memset(&ds_passphrase, 0, sizeof(struct mwifiex_ds_passphrase));
-
-	if (copy_from_user(buf, ubuf, buf_size)) {
-		ret = -EFAULT;
-		goto done;
-	}
-	/* Overwrite last charactor '\n' in buf by '\0' */
-	buf[buf_size - 1] = '\0';
-
-	/* Parse the buf to get the cmd_action */
-	begin = buf;
-	end = mwifiex_strsep(&begin, ';', '/');
-	if (end)
-		action = mwifiex_atox(end);
-
-	if (action < 0 || action > 2 || end[1] != '\0') {
-		dev_err(priv->adapter->dev,
-				"invalid action argument %s\n", end);
-		ret = -EINVAL;
-		goto done;
-	}
-	while (begin) {
-		end = mwifiex_strsep(&begin, ';', '/');
-		opt = mwifiex_strsep(&end, '=', '/');
-		if (!opt || !end || !end[0]) {
-			dev_err(priv->adapter->dev, "invalid option\n");
-			ret = -EINVAL;
-			break;
-		} else if (!strnicmp(opt, "ssid", strlen(opt))) {
-			if (strlen(end) > IEEE80211_MAX_SSID_LEN) {
-				dev_err(priv->adapter->dev, "SSID length "
-						"exceeds max length\n");
-				ret = -EFAULT;
-				break;
-			}
-			ds_passphrase.ssid.ssid_len = strlen(end);
-			strcpy((char *)ds_passphrase.ssid.ssid, end);
-			dev_dbg(priv->adapter->dev, "info: ssid=%s, len=%d\n",
-					ds_passphrase.ssid.ssid,
-					(int)ds_passphrase.ssid.ssid_len);
-		} else if (!strnicmp(opt, "bssid", strlen(opt))) {
-			mwifiex_mac2u8((u8 *)&ds_passphrase.bssid, end);
-		} else if (!strnicmp(opt, "psk", strlen(opt))) {
-			if (strlen(end) != (MWIFIEX_MAX_PMK_LENGTH * 2)) {
-				dev_err(priv->adapter->dev, "invalid PMK length\n");
-				ret = -EINVAL;
-				break;
-			}
-			mwifiex_ascii2hex(ds_passphrase.psk.pmk.pmk, end,
-					  MWIFIEX_MAX_PMK_LENGTH * 2);
-			ds_passphrase.psk_type = MWIFIEX_PSK_PMK;
-		} else if (!strnicmp(opt, "passphrase", strlen(opt))) {
-			if (strlen(end) < MWIFIEX_MIN_PASSPHRASE_LENGTH  ||
-				strlen(end) > MWIFIEX_MAX_PASSPHRASE_LENGTH) {
-				dev_err(priv->adapter->dev,
-						"invalid passphrase length\n");
-				ret = -EINVAL;
-				break;
-			}
-			ds_passphrase.psk_type = MWIFIEX_PSK_PASSPHRASE;
-			strcpy(ds_passphrase.psk.passphrase.passphrase, end);
-			ds_passphrase.psk.passphrase.passphrase_len =
-								strlen(end);
-			dev_dbg(priv->adapter->dev, "info: passphrase=%s, len=%d\n",
-				ds_passphrase.psk.passphrase.passphrase,
-				(int)ds_passphrase.psk.passphrase
-				.passphrase_len);
-		} else {
-			dev_err(priv->adapter->dev, "invalid option %s\n", opt);
-			ret = -EINVAL;
-			break;
-		}
-	}
-	if (ret)
-		goto done;
-
-	if (action == 2)
-		ds_passphrase.psk_type = MWIFIEX_PSK_CLEAR;
-
-	ret = mwifiex_set_passphrase(priv, action, &ds_passphrase);
-	if (ret)
-		goto done;
-
-	ret = count;
-
-	if (action == 0)
-		memcpy(&saved_ds_passphrase, &ds_passphrase,
-				sizeof(struct mwifiex_ds_passphrase));
-
-done:
-	free_page(addr);
-	return ret;
-}
-
-/*
- * Proc passphrase file read handler.
- *
- * This function is called when the 'passphrase' file is opened for reading
- *
- * This function can be used to get passphrase for specific SSID
- */
-static ssize_t
-mwifiex_passphrase_read(struct file *file, char __user *ubuf,
-		     size_t count, loff_t *ppos)
-{
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *) addr;
-	int i, ret = 0, len = 0;
-	char zero_mac[] = {0, 0, 0, 0, 0, 0 };
-	char *mac = NULL;
-
-	if (!buf)
-		return -ENOMEM;
-
-	memset(buf, 0, sizeof(buf));
-	if (saved_ds_passphrase.ssid.ssid_len) {
-		len += sprintf(buf+len, "ssid:");
-		memcpy(buf+len, saved_ds_passphrase.ssid.ssid,
-				saved_ds_passphrase.ssid.ssid_len);
-		len += saved_ds_passphrase.ssid.ssid_len;
-		len += sprintf(buf+len, " ");
-	}
-	if (memcmp(&saved_ds_passphrase.bssid, zero_mac, sizeof(zero_mac))) {
-		mac = (u8 *)&saved_ds_passphrase.bssid;
-		len += sprintf(buf+len, "bssid:");
-		for (i = 0; i < ETH_ALEN-1; ++i)
-			len += sprintf(buf+len, "%02x:", mac[i]);
-		len += sprintf(buf+len, "%02x ", mac[i]);
-	}
-	if (saved_ds_passphrase.psk_type == MWIFIEX_PSK_PMK) {
-		len += sprintf(buf+len, "psk:");
-		for (i = 0; i < MWIFIEX_MAX_PMK_LENGTH; ++i)
-			len += sprintf(buf+len, "%02x",
-					saved_ds_passphrase.psk.pmk.pmk[i]);
-		len += sprintf(buf+len, "\n");
-	}
-	if (saved_ds_passphrase.psk_type ==  MWIFIEX_PSK_PASSPHRASE)
-		len += sprintf(buf+len, "passphrase:%s\n",
-				saved_ds_passphrase.psk.passphrase.passphrase);
-
-	ret = simple_read_from_buffer(ubuf, count, ppos, buf, len);
-
-	free_page(addr);
-	return ret;
-}
-
 #define MWIFIEX_DFS_ADD_FILE(name) do {                                 \
 	if (!debugfs_create_file(#name, 0644, priv->dfs_dev_dir,        \
 			priv, &mwifiex_dfs_##name##_fops))              \
@@ -1279,7 +1108,6 @@ MWIFIEX_DFS_FILE_READ_OPS(getlog);
 MWIFIEX_DFS_FILE_OPS(regrdwr);
 MWIFIEX_DFS_FILE_OPS(rdeeprom);
 MWIFIEX_DFS_FILE_OPS(txbufcfg);
-MWIFIEX_DFS_FILE_OPS(passphrase);
 
 /*
  * This function creates the debug FS directory structure and the files.
@@ -1306,7 +1134,6 @@ mwifiex_dev_debugfs_init(struct mwifiex_private *priv)
 	MWIFIEX_DFS_ADD_FILE(regrdwr);
 	MWIFIEX_DFS_ADD_FILE(rdeeprom);
 	MWIFIEX_DFS_ADD_FILE(txbufcfg);
-	MWIFIEX_DFS_ADD_FILE(passphrase);
 
 	return;
 }
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index e3b62bb..49d76fd 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -154,8 +154,6 @@ enum MWIFIEX_802_11_WEP_STATUS {
 
 #define TLV_TYPE_CHANNELBANDLIST    (PROPRIETARY_TLV_BASE_ID + 42)
 #define TLV_TYPE_WAPI_IE            (PROPRIETARY_TLV_BASE_ID + 94)
-#define TLV_TYPE_PMK                (PROPRIETARY_TLV_BASE_ID + 68)
-#define TLV_TYPE_PASSPHRASE         (PROPRIETARY_TLV_BASE_ID + 60)
 #define TLV_TYPE_BSSID              (PROPRIETARY_TLV_BASE_ID + 35)
 
 #define MWIFIEX_TX_DATA_BUF_SIZE_2K        2048
@@ -320,7 +318,6 @@ enum MWIFIEX_802_11_WEP_STATUS {
 #define HostCmd_CMD_RSSI_INFO                         0x00a4
 #define HostCmd_CMD_FUNC_INIT                         0x00a9
 #define HostCmd_CMD_FUNC_SHUTDOWN                     0x00aa
-#define HostCmd_CMD_SUPPLICANT_PMK                    0x00c4
 #define HostCmd_CMD_11N_CFG                           0x00cd
 #define HostCmd_CMD_11N_ADDBA_REQ                     0x00ce
 #define HostCmd_CMD_11N_ADDBA_RSP                     0x00cf
@@ -1256,37 +1253,6 @@ struct mwifiex_ie_types_extcap {
 	u8 ext_cap;
 } __packed;
 
-struct mwifiex_ie_types_pmk {
-	struct mwifiex_ie_types_header header;
-	u8 pmk[1];
-} __packed;
-
-struct mwifiex_ie_types_passphrase {
-	struct mwifiex_ie_types_header header;
-	char passphrase[1];
-} __packed;
-
-struct mwifiex_ie_types_bssid {
-	struct mwifiex_ie_types_header header;
-	u8 bssid[ETH_ALEN];
-} __packed;
-
-/*
- * This struct will handle GET,SET,CLEAR function for embedded
- * supplicant.
- * Define data structure for host_cmd_ds_802_11_supplicant_pmk
- */
-struct host_cmd_ds_802_11_supplicant_pmk {
-	__le16 action;				/* GET/SET/CLEAR */
-	__le16 cache_result;			/* initialized to 0 */
-	u8 tlv_buffer[1];
-	/* mwifiex_ie_types_ssid_param_set	ssid_param_set;
-	 * mwifiex_ie_types_pmk			pmk;
-	 * mwifiex_ie_types_passphrase		passphrase;
-	 * mwifiex_ie_types_bssid		bssid;
-	 */
-} __packed;
-
 struct host_cmd_ds_mac_reg_access {
 	__le16 action;
 	__le16 offset;
@@ -1391,7 +1357,6 @@ struct host_cmd_ds_command {
 		struct host_cmd_ds_11n_cfg htcfg;
 		struct host_cmd_ds_wmm_get_status get_wmm_status;
 		struct host_cmd_ds_802_11_key_material key_material;
-		struct host_cmd_ds_802_11_supplicant_pmk esupp_psk;
 		struct host_cmd_ds_version_ext verext;
 		struct host_cmd_ds_802_11_ibss_status ibss_coalescing;
 		struct host_cmd_ds_mac_reg_access mac_reg;
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 0dfc147..07ebc97 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -90,7 +90,6 @@ static int mwifiex_init_priv(struct mwifiex_private *priv)
 	for (i = 0; i < ARRAY_SIZE(priv->wep_key); i++)
 		memset(&priv->wep_key[i], 0, sizeof(struct mwifiex_wep_key));
 	priv->wep_key_curr_index = 0;
-	priv->ewpa_query = false;
 	priv->curr_pkt_filter = HostCmd_ACT_MAC_RX_ON | HostCmd_ACT_MAC_TX_ON |
 				HostCmd_ACT_MAC_ETHERNETII_ENABLE;
 
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index 0f61791..f4227dd 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -289,19 +289,9 @@ enum {
 	MWIFIEX_ENCRYPTION_MODE_WEP104 = 4,
 };
 
-enum {
-	MWIFIEX_PSK_PASSPHRASE = 1,
-	MWIFIEX_PSK_PMK,
-	MWIFIEX_PSK_CLEAR,
-	MWIFIEX_PSK_QUERY,
-};
-
 #define MWIFIEX_KEY_INDEX_UNICAST	0x40000000
 #define MWIFIEX_MAX_KEY_LENGTH		32
 #define WAPI_RXPN_LEN			16
-#define MWIFIEX_MIN_PASSPHRASE_LENGTH	8
-#define MWIFIEX_MAX_PASSPHRASE_LENGTH	63
-#define MWIFIEX_MAX_PMK_LENGTH		32
 
 struct mwifiex_ds_encrypt_key {
 	u32 key_disable;
@@ -314,25 +304,6 @@ struct mwifiex_ds_encrypt_key {
 	u8 wapi_rxpn[WAPI_RXPN_LEN];
 };
 
-struct mwifiex_passphrase {
-	u32 passphrase_len;
-	u8 passphrase[MWIFIEX_MAX_PASSPHRASE_LENGTH];
-};
-
-struct mwifiex_pmk {
-	u8 pmk[MWIFIEX_MAX_PMK_LENGTH];
-};
-
-struct mwifiex_ds_passphrase {
-	struct mwifiex_802_11_ssid        ssid;
-	u8 bssid[ETH_ALEN];
-	u16  psk_type;
-	union {
-		struct mwifiex_passphrase   passphrase;
-		struct mwifiex_pmk          pmk;
-	} psk;
-};
-
 struct mwifiex_rate_cfg {
 	u32 action;
 	u32 is_rate_auto;
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 7b7f344..ed89ca4 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -834,118 +834,6 @@ int mwifiex_shutdown_fw(struct mwifiex_private *priv, u8 wait_option)
 EXPORT_SYMBOL_GPL(mwifiex_shutdown_fw);
 
 /*
- *  The function converts ascii string to Hex integer
- */
-int mwifiex_ascii2hex(u8 *d, char *s, u32 dlen)
-{
-	unsigned int i;
-	u8 n;
-
-	memset(d, 0x00, dlen);
-
-	for (i = 0; i < dlen * 2; i++) {
-		if ((s[i] >= 48) && (s[i] <= 57))
-			n = s[i] - 48;
-		else if ((s[i] >= 65) && (s[i] <= 70))
-			n = s[i] - 55;
-		else if ((s[i] >= 97) && (s[i] <= 102))
-			n = s[i] - 87;
-		else
-			break;
-		if (!(i % 2))
-			n = n * 16;
-		d[i / 2] += n;
-	}
-
-	return i;
-}
-
-/*
- *  The function gives hex value of a give character
- */
-static int mwifiex_hexval(char chr)
-{
-	if (chr >= '0' && chr <= '9')
-		return chr - '0';
-	if (chr >= 'A' && chr <= 'F')
-		return chr - 'A' + 10;
-	if (chr >= 'a' && chr <= 'f')
-		return chr - 'a' + 10;
-
-	return 0;
-}
-
-/*
- *  The function gives hex value of a given ascii string
- */
-int mwifiex_atox(char *a)
-{
-	int i = 0;
-
-	while (isxdigit(*a))
-		i = i*16 + mwifiex_hexval(*a++);
-
-	return i;
-}
-
-/*
- *  This function is an extension of strsep lib command. The function will also
- *  take care of an escape character
- */
-char *mwifiex_strsep(char **s, char delim, char esc)
-{
-	char *se = *s, *sb;
-
-	if (!(*s) || (*se == '\0'))
-		return NULL;
-
-	for (sb = *s; *sb != '\0'; ++sb) {
-		if (*sb == esc && *(sb+1) == esc) {
-			/*
-			 * We get a esc + esc seq then keep the one esc
-			 * and chop off the other esc character
-			 */
-			memmove(sb, sb+1, strlen(sb));
-			continue;
-		}
-		if (*sb == esc && *(sb+1) == delim) {
-			/*
-			 * We get a delim + esc seq then keep the delim
-			 * and chop off the esc character
-			 */
-			memmove(sb, sb+1, strlen(sb));
-			continue;
-		}
-		if (*sb == delim)
-			break;
-	}
-
-	if (*sb == '\0')
-		sb = NULL;
-	else
-		*sb++ = '\0';
-
-	*s = sb;
-
-	return se;
-}
-
-/*
- *  The function converts mac address from string to u8 buffer.
- */
-void mwifiex_mac2u8(u8 *mac_addr, char *buf)
-{
-	char *begin = buf, *end;
-	int i;
-
-	for (i = 0; i < ETH_ALEN; ++i) {
-		end = mwifiex_strsep(&begin, ':', '/');
-		if (end)
-			mac_addr[i] = mwifiex_atox(end);
-	}
-}
-
-/*
  * This function check if command is pending.
  */
 int is_command_pending(struct mwifiex_adapter *adapter)
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index e6016b1..f074f5c 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -436,7 +436,6 @@ struct mwifiex_private {
 	struct mwifiex_802_11_security sec_info;
 	struct mwifiex_wep_key wep_key[NUM_WEP_KEYS];
 	u16 wep_key_curr_index;
-	u8 ewpa_query;
 	u8 wpa_ie[256];
 	u8 wpa_ie_len;
 	u8 wpa_is_gtk_set;
@@ -737,8 +736,6 @@ int mwifiex_misc_ioctl_init_shutdown(struct mwifiex_adapter *adapter,
 int mwifiex_get_debug_info(struct mwifiex_private *,
 			   struct mwifiex_debug_info *);
 
-int mwifiex_set_ewpa_mode_from_passphrase(struct mwifiex_private *priv,
-					  struct mwifiex_ds_passphrase *);
 int mwifiex_alloc_cmd_buffer(struct mwifiex_adapter *adapter);
 int mwifiex_free_cmd_buffer(struct mwifiex_adapter *adapter);
 void mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter);
@@ -964,11 +961,6 @@ struct mwifiex_private *mwifiex_bss_index_to_priv(struct mwifiex_adapter
 						*adapter, u8 bss_index);
 int mwifiex_shutdown_fw(struct mwifiex_private *, u8);
 
-char *mwifiex_strsep(char **s, char delim, char esc);
-int mwifiex_atox(char *a);
-void mwifiex_mac2u8(u8 *mac_addr, char *buf);
-int mwifiex_ascii2hex(u8 *d, char *s, u32 dlen);
-
 int mwifiex_add_card(void *, struct semaphore *, struct mwifiex_if_ops *);
 int mwifiex_remove_card(struct mwifiex_adapter *, struct semaphore *);
 
@@ -1080,9 +1072,6 @@ int mwifiex_set_tx_power(struct mwifiex_private *priv, int type, int dbm);
 
 int mwifiex_main_process(struct mwifiex_adapter *);
 
-int mwifiex_set_passphrase(struct mwifiex_private *priv, int action,
-			   struct mwifiex_ds_passphrase *ds_passphrase);
-
 int mwifiex_bss_ioctl_mode(struct mwifiex_private *,
 			   struct mwifiex_wait_queue *,
 			   u16 action, int *mode);
@@ -1100,10 +1089,6 @@ int mwifiex_snmp_mib_ioctl(struct mwifiex_private *,
 			   u32 cmd_oid, u16 action, u32 *value);
 int mwifiex_get_bss_info(struct mwifiex_private *,
 			 struct mwifiex_bss_info *);
-int mwifiex_sec_ioctl_passphrase(struct mwifiex_private *,
-				 struct mwifiex_wait_queue *,
-				 struct mwifiex_ds_passphrase *,
-				 u16 action);
 
 #ifdef CONFIG_DEBUG_FS
 void mwifiex_debugfs_init(void);
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index ea86762..c0d5823 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -180,43 +180,22 @@ mwifiex_ssid_cmp(struct mwifiex_802_11_ssid *ssid1,
 int mwifiex_find_best_bss(struct mwifiex_private *priv,
 			  u8 wait_option, struct mwifiex_ssid_bssid *ssid_bssid)
 {
-	struct mwifiex_wait_queue *wait1 = NULL, *wait2 = NULL;
+	struct mwifiex_wait_queue *wait = NULL;
 	struct mwifiex_ssid_bssid tmp_ssid_bssid;
-	struct mwifiex_ds_passphrase passphrase;
 	int ret = 0;
 	u8 *mac = NULL;
 
 	if (!ssid_bssid)
 		return -1;
 
-	if (priv->ewpa_query) {
-		/* Allocate wait request buffer */
-		wait1 = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-		if (!wait1)
-			return -ENOMEM;
-
-		memset(&passphrase, 0, sizeof(passphrase));
-		passphrase.psk_type = MWIFIEX_PSK_QUERY;
-		memcpy(&passphrase.ssid, &ssid_bssid->ssid,
-				sizeof(struct mwifiex_802_11_ssid));
-		memcpy(passphrase.bssid, ssid_bssid->bssid, ETH_ALEN);
-		ret = mwifiex_sec_ioctl_passphrase(priv, wait1, &passphrase,
-						   HostCmd_ACT_GEN_GET);
-
-		ret = mwifiex_request_ioctl(priv, wait1, ret, wait_option);
-		if (ret)
-			goto done;
-		mwifiex_set_ewpa_mode_from_passphrase(priv, &passphrase);
-	}
-
 	/* Allocate wait request buffer */
-	wait2 = mwifiex_alloc_fill_wait_queue(priv, wait_option);
-	if (!wait2)
+	wait = mwifiex_alloc_fill_wait_queue(priv, wait_option);
+	if (!wait)
 		return -ENOMEM;
 
 	memcpy(&tmp_ssid_bssid, ssid_bssid,
 	       sizeof(struct mwifiex_ssid_bssid));
-	ret = mwifiex_bss_ioctl_find_bss(priv, wait2, &tmp_ssid_bssid);
+	ret = mwifiex_bss_ioctl_find_bss(priv, wait, &tmp_ssid_bssid);
 
 	if (!ret) {
 		memcpy(ssid_bssid, &tmp_ssid_bssid,
@@ -226,9 +205,7 @@ int mwifiex_find_best_bss(struct mwifiex_private *priv,
 				" %pM\n", ssid_bssid->ssid.ssid, mac);
 	}
 
-done:
-	kfree(wait1);
-	kfree(wait2);
+	kfree(wait);
 	return ret;
 }
 
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index db87b7d..d4befb9 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -710,119 +710,6 @@ static int mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
 }
 
 /*
- * This function prepares command of supplicant pmk.
- *
- * Preparation includes -
- *      - Setting command ID and proper size
- *      - Setting SSID, passphrase and cmd action
- *      - Ensuring correct endian-ness
- */
-static int
-mwifiex_cmd_802_11_supplicant_pmk(struct mwifiex_private  *priv,
-				  struct host_cmd_ds_command *cmd,
-				  u16 cmd_action, void *pdata_buf)
-{
-	struct mwifiex_ie_types_pmk *ppmk_tlv = NULL;
-	struct mwifiex_ie_types_passphrase *ppassphrase_tlv = NULL;
-	struct mwifiex_ie_types_ssid_param_set *pssid_tlv = NULL;
-	struct mwifiex_ie_types_bssid *pbssid_tlv = NULL;
-	struct host_cmd_ds_802_11_supplicant_pmk *pesupp_psk =
-				&cmd->params.esupp_psk;
-	u8 *ptlv_buffer = (u8 *)(pesupp_psk->tlv_buffer);
-	struct mwifiex_ds_passphrase *psk =
-				(struct mwifiex_ds_passphrase *)pdata_buf;
-	u8 zero_mac[] = {0, 0, 0, 0, 0, 0 };
-
-	/*
-	 * Parse the rest of the buf here
-	 *      1)  <ssid="valid ssid"> - This will get the passphrase, AKMP
-	 *          for specified ssid, if none specified then it will get all.
-	 *          Eg: echo "0;ssid=marvell" > passphrase
-	 *      2)  <psk="psk">:<passphrase="passphare">:<bssid="00:50:43:ef:
-	 *          23:f3"> <ssid="valid ssid"> - passphrase and psk cannot be
-	 *          provided to the same SSID, Takes one SSID at a time, If
-	 *          ssid= is present the it should contain a passphrase or psk.
-	 *          If no arguments are provided then AKMP=802.1x, and
-	 *          passphrase should be provided after association. End of each
-	 *          parameter should be followed by a ';'(except for the last
-	 *          parameter) as the delimiter. If ';' has to be used in an
-	 *          SSID then a '/' should be preceded to ';' as a escape.
-	 *          Eg: echo "1;ssid=mrvl AP;psk=abcdefgh" > passphrase
-	 *          echo "1;ssid=mrvl/; AP;psk=abcdefgd" > passphrase
-	 *          echo "1:ssid=mrvlAP:psk=abcdefgd" > passphrase
-	 *      3)  <ssid="valid ssid"> - This will clear the passphrase
-	 *          for specified ssid, if none specified then it will clear
-	 *          all.
-	 *          Eg: echo "2:ssid=marvell" > passphrase
-	 */
-
-	/* -1 is for u8 TlvBuffer[1] as this should not be included */
-	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_802_11_supplicant_pmk)
-				+ S_DS_GEN - 1);
-	if (psk->ssid.ssid_len) {
-		pssid_tlv = (struct mwifiex_ie_types_ssid_param_set *)
-					ptlv_buffer;
-		pssid_tlv->header.type = cpu_to_le16(WLAN_EID_SSID);
-		pssid_tlv->header.len = cpu_to_le16((u16)psk->ssid.ssid_len);
-		memcpy((char *)pssid_tlv->ssid, psk->ssid.ssid,
-					psk->ssid.ssid_len);
-		ptlv_buffer += (le16_to_cpu(pssid_tlv->header.len) +
-					sizeof(struct mwifiex_ie_types_header));
-		cmd->size = cpu_to_le16(le16_to_cpu(cmd->size) +
-					le16_to_cpu(pssid_tlv->header.len) +
-					sizeof(struct mwifiex_ie_types_header));
-	}
-	if (memcmp((u8 *)&psk->bssid, zero_mac, sizeof(zero_mac))) {
-		pbssid_tlv = (struct mwifiex_ie_types_bssid *) ptlv_buffer;
-		pbssid_tlv->header.type = cpu_to_le16(TLV_TYPE_BSSID);
-		pbssid_tlv->header.len = cpu_to_le16(ETH_ALEN);
-		memcpy(pbssid_tlv->bssid, (u8 *)&psk->bssid, ETH_ALEN);
-		ptlv_buffer += (le16_to_cpu(pbssid_tlv->header.len) +
-					sizeof(struct mwifiex_ie_types_header));
-		cmd->size = cpu_to_le16(le16_to_cpu(cmd->size) +
-					le16_to_cpu(pbssid_tlv->header.len) +
-					sizeof(struct mwifiex_ie_types_header));
-	}
-	if (psk->psk_type == MWIFIEX_PSK_PASSPHRASE) {
-		ppassphrase_tlv = (struct mwifiex_ie_types_passphrase *)
-					ptlv_buffer;
-		ppassphrase_tlv->header.type = cpu_to_le16(TLV_TYPE_PASSPHRASE);
-		ppassphrase_tlv->header.len =
-			cpu_to_le16((u16)psk->psk.passphrase.passphrase_len);
-		memcpy(ppassphrase_tlv->passphrase,
-				psk->psk.passphrase.passphrase,
-				psk->psk.passphrase.passphrase_len);
-		ptlv_buffer += (le16_to_cpu(ppassphrase_tlv->header.len) +
-					sizeof(struct mwifiex_ie_types_header));
-		cmd->size = cpu_to_le16(le16_to_cpu(cmd->size) +
-				le16_to_cpu(ppassphrase_tlv->header.len) +
-				sizeof(struct mwifiex_ie_types_header));
-	}
-	if (psk->psk_type == MWIFIEX_PSK_PMK) {
-		ppmk_tlv = (struct mwifiex_ie_types_pmk *) ptlv_buffer;
-		ppmk_tlv->header.type = cpu_to_le16(TLV_TYPE_PMK);
-		ppmk_tlv->header.len = cpu_to_le16(MWIFIEX_MAX_PMK_LENGTH);
-		memcpy(ppmk_tlv->pmk, psk->psk.pmk.pmk, MWIFIEX_MAX_PMK_LENGTH);
-		ptlv_buffer += (le16_to_cpu(ppmk_tlv->header.len) +
-					sizeof(struct mwifiex_ie_types_header));
-		cmd->size = cpu_to_le16(le16_to_cpu(cmd->size) +
-					le16_to_cpu(ppmk_tlv->header.len) +
-					sizeof(struct mwifiex_ie_types_header));
-	}
-	if ((cmd_action == HostCmd_ACT_GEN_SET) && ((pssid_tlv || pbssid_tlv)
-				&& (!ppmk_tlv && !ppassphrase_tlv))) {
-		dev_err(priv->adapter->dev,
-			"invalid case, ssid/bssid present without"
-			" pmk or passphrase\n");
-		return -1;
-	}
-	cmd->command = cpu_to_le16(HostCmd_CMD_SUPPLICANT_PMK);
-	pesupp_psk->action = cpu_to_le16(cmd_action);
-	pesupp_psk->cache_result = 0;
-	return 0;
-}
-
-/*
  * This function prepares command to set/get 11d domain information.
  *
  * Preparation includes -
@@ -1194,10 +1081,6 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 						cmd_action, cmd_oid,
 						data_buf);
 		break;
-	case HostCmd_CMD_SUPPLICANT_PMK:
-		ret = mwifiex_cmd_802_11_supplicant_pmk(priv, cmd_ptr,
-						cmd_action, data_buf);
-		break;
 	case HostCmd_CMD_802_11D_DOMAIN_INFO:
 		ret = mwifiex_cmd_802_11d_domain_info(priv, cmd_ptr,
 						cmd_action);
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index f94439d..15a306c 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -631,115 +631,6 @@ static int mwifiex_ret_802_11_key_material(struct mwifiex_private *priv,
 }
 
 /*
- * This function retrieves passphrase information for specified SSID from
- * command response.
- */
-static int mwifiex_get_passphrase_from_cmdresp(struct mwifiex_private *priv,
-					       struct host_cmd_ds_command *resp,
-					       void *data_buf)
-{
-	struct host_cmd_ds_802_11_supplicant_pmk *supplicant_pmk_resp =
-		&resp->params.esupp_psk;
-	struct mwifiex_ds_passphrase *passphrase = NULL;
-	struct mwifiex_ie_types_pmk *ppmk_tlv = NULL;
-	struct mwifiex_ie_types_passphrase *passphrase_tlv = NULL;
-	struct mwifiex_ie_types_ssid_param_set *pssid_tlv = NULL;
-	struct mwifiex_ie_types_bssid *pbssid_tlv = NULL;
-	u8 *tlv_buf = (u8 *)supplicant_pmk_resp->tlv_buffer;
-	int  tlv_buf_len = 0;
-	u16 tlv;
-
-	tlv_buf_len = le16_to_cpu(resp->size) -
-			(sizeof(struct host_cmd_ds_802_11_supplicant_pmk) +
-			S_DS_GEN-1);
-	passphrase = (struct mwifiex_ds_passphrase *)data_buf;
-
-	while (tlv_buf_len > 0) {
-		tlv = (*tlv_buf) | (*(tlv_buf + 1) << 8);
-		if ((tlv != WLAN_EID_SSID) && (tlv != TLV_TYPE_BSSID)
-		    && (tlv != TLV_TYPE_PASSPHRASE) && (tlv != TLV_TYPE_PMK))
-			break;
-		switch (tlv) {
-		case WLAN_EID_SSID:
-			pssid_tlv =
-			      (struct mwifiex_ie_types_ssid_param_set *)tlv_buf;
-			memcpy(passphrase->ssid.ssid, pssid_tlv->ssid,
-				le16_to_cpu(pssid_tlv->header.len));
-			passphrase->ssid.ssid_len =
-				le16_to_cpu(pssid_tlv->header.len);
-			tlv_buf += le16_to_cpu(pssid_tlv->header.len) +
-				sizeof(struct mwifiex_ie_types_header);
-			tlv_buf_len -= (le16_to_cpu(pssid_tlv->header.len)
-				+ sizeof(struct mwifiex_ie_types_header));
-			break;
-		case TLV_TYPE_BSSID:
-			pbssid_tlv = (struct mwifiex_ie_types_bssid *)tlv_buf;
-			memcpy(&passphrase->bssid, pbssid_tlv->bssid, ETH_ALEN);
-			tlv_buf += le16_to_cpu(pbssid_tlv->header.len) +
-				sizeof(struct mwifiex_ie_types_header);
-			tlv_buf_len -= (le16_to_cpu(pbssid_tlv->header.len) +
-				sizeof(struct mwifiex_ie_types_header));
-			break;
-		case TLV_TYPE_PASSPHRASE:
-			passphrase_tlv =
-				(struct mwifiex_ie_types_passphrase *)tlv_buf;
-			passphrase->psk_type = MWIFIEX_PSK_PASSPHRASE;
-			passphrase->psk.passphrase.passphrase_len =
-				le16_to_cpu(passphrase_tlv->header.len);
-			memcpy(passphrase->psk.passphrase.passphrase,
-				passphrase_tlv->passphrase,
-				le16_to_cpu(passphrase_tlv->header.len));
-			tlv_buf += le16_to_cpu(passphrase_tlv->header.len)
-				+  sizeof(struct mwifiex_ie_types_header);
-			tlv_buf_len -= (le16_to_cpu(passphrase_tlv->header.len)
-				+ sizeof(struct mwifiex_ie_types_header));
-			break;
-		case TLV_TYPE_PMK:
-			ppmk_tlv = (struct mwifiex_ie_types_pmk *)tlv_buf;
-			passphrase->psk_type = MWIFIEX_PSK_PMK;
-			memcpy(passphrase->psk.pmk.pmk, ppmk_tlv->pmk,
-				le16_to_cpu(ppmk_tlv->header.len));
-			tlv_buf += le16_to_cpu(ppmk_tlv->header.len)
-				+ sizeof(struct mwifiex_ie_types_header);
-			tlv_buf_len -= (le16_to_cpu(ppmk_tlv->header.len)
-				+ sizeof(struct mwifiex_ie_types_header));
-			break;
-
-		}
-	}
-return 0;
-}
-
-/*
- * This function handles the command response of set/get passphrase.
- *
- * Handling includes updating driver's private flag 'ewpa_query' (for action
- * SET) and retrieving passphrase (for action GET) for specified
- * SSID
- */
-static int mwifiex_ret_802_11_supplicant_pmk(struct mwifiex_private *priv,
-					     struct host_cmd_ds_command *resp,
-					     void *data_buf)
-{
-	struct host_cmd_ds_802_11_supplicant_pmk *supplicant_pmk_resp =
-		&resp->params.esupp_psk;
-	u16 action = le16_to_cpu(supplicant_pmk_resp->action);
-
-	if (data_buf) {
-		if (action == HostCmd_ACT_GEN_GET) {
-			mwifiex_get_passphrase_from_cmdresp(priv, resp,
-							    data_buf);
-		} else if (action == HostCmd_ACT_GEN_SET) {
-			dev_dbg(priv->adapter->dev,
-				"info: Esupp PMK set: enable ewpa query\n");
-			priv->ewpa_query = true;
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
@@ -1072,9 +963,6 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv,
 	case HostCmd_CMD_802_11_KEY_MATERIAL:
 		ret = mwifiex_ret_802_11_key_material(priv, resp);
 		break;
-	case HostCmd_CMD_SUPPLICANT_PMK:
-		ret = mwifiex_ret_802_11_supplicant_pmk(priv, resp, data_buf);
-		break;
 	case HostCmd_CMD_802_11D_DOMAIN_INFO:
 		ret = mwifiex_ret_802_11d_domain_info(priv, resp);
 		break;
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 605dd37..d69bb98 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -1981,60 +1981,6 @@ mwifiex_sec_ioctl_encrypt_key(struct mwifiex_private *priv,
 }
 
 /*
- * IOCTL request handler to set/get/clear passphrase for esupplicant.
- *
- * This function prepares corresponding firmware command and
- * issues it.
- */
-int mwifiex_sec_ioctl_passphrase(struct mwifiex_private *priv,
-				 struct mwifiex_wait_queue *wait,
-				 struct mwifiex_ds_passphrase *passphrase,
-				 u16 action)
-{
-	int ret = 0;
-	struct mwifiex_adapter *adapter = priv->adapter;
-	struct mwifiex_bssdescriptor *pbss_desc;
-	u16 cmd_action = 0;
-	int i = 0;
-
-	if (action == HostCmd_ACT_GEN_SET) {
-		if (passphrase->psk_type == MWIFIEX_PSK_CLEAR)
-			cmd_action = HostCmd_ACT_GEN_REMOVE;
-		else
-			cmd_action = HostCmd_ACT_GEN_SET;
-	} else {
-		if (passphrase->psk_type == MWIFIEX_PSK_QUERY) {
-			if (passphrase->ssid.ssid_len == 0) {
-				i = mwifiex_find_bssid_in_list(priv,
-						passphrase->bssid,
-						MWIFIEX_BSS_MODE_AUTO);
-				if (i >= 0) {
-					pbss_desc = &adapter->scan_table[i];
-					memcpy(&passphrase->ssid,
-					&pbss_desc->ssid,
-					sizeof(struct mwifiex_802_11_ssid));
-					memset(passphrase->bssid, 0, ETH_ALEN);
-					dev_dbg(adapter->dev, "info: PSK_QUERY:"
-							" found ssid=%s\n",
-						      passphrase->ssid.ssid);
-				}
-			} else {
-				memset(passphrase->bssid, 0, ETH_ALEN);
-			}
-		}
-		cmd_action = HostCmd_ACT_GEN_GET;
-	}
-
-	/* Send request to firmware */
-	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_SUPPLICANT_PMK, cmd_action,
-				  0, wait, passphrase);
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
@@ -2730,52 +2676,6 @@ done:
 }
 
 /*
- * Set eWPA mode if passphrase/psk is set
- */
-int mwifiex_set_ewpa_mode_from_passphrase(struct mwifiex_private *priv,
-					  struct mwifiex_ds_passphrase *psec_pp)
-{
-	if ((psec_pp->psk_type == MWIFIEX_PSK_PASSPHRASE &&
-			psec_pp->psk.passphrase.passphrase_len > 0) ||
-			(psec_pp->psk_type == MWIFIEX_PSK_PMK))
-		priv->sec_info.ewpa_enabled = true;
-	else
-		priv->sec_info.ewpa_enabled = false;
-
-	dev_dbg(priv->adapter->dev, "info: set ewpa mode = %d\n",
-				priv->sec_info.ewpa_enabled);
-
-	return 0;
-}
-
-/*
- * Sends IOCTL request to get/set/clear passphrase for specified SSID.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-int mwifiex_set_passphrase(struct mwifiex_private *priv, int action,
-			   struct mwifiex_ds_passphrase *ds_passphrase)
-{
-	int ret = 0;
-	int status = 0;
-	struct mwifiex_wait_queue  *wait = NULL;
-
-	wait = mwifiex_alloc_fill_wait_queue(priv, MWIFIEX_IOCTL_WAIT);
-	if (!wait)
-		return -ENOMEM;
-
-	status = mwifiex_sec_ioctl_passphrase(priv, wait, ds_passphrase,
-					      action);
-
-	if (mwifiex_request_ioctl(priv, wait, status, MWIFIEX_IOCTL_WAIT))
-		ret = -EFAULT;
-
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

