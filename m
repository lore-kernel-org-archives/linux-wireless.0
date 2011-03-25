Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:41184 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab1CYDqD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2011 23:46:03 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/2] mwifiex: remove unnecessary _set_auth functions
Date: Thu, 24 Mar 2011 20:49:39 -0700
Message-Id: <1301024979-28987-2-git-send-email-bzhao@marvell.com>
In-Reply-To: <1301024979-28987-1-git-send-email-bzhao@marvell.com>
References: <1301024979-28987-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Marc Yang <yangyang@marvell.com>

mwifiex_set_encrypt_mode()
mwifiex_set_auth_mode()
mwifiex_set_auth()
These functions are confusing and misleading.
And they are really not needed at all.

Some unused definitions are also removed.

Signed-off-by: Marc Yang <yangyang@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c  |   17 +++++------
 drivers/net/wireless/mwifiex/ioctl.h     |    2 -
 drivers/net/wireless/mwifiex/join.c      |   25 +++++++---------
 drivers/net/wireless/mwifiex/main.h      |    8 -----
 drivers/net/wireless/mwifiex/sta_ioctl.c |   44 ------------------------------
 5 files changed, 19 insertions(+), 77 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 80f367f..84e33f1 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1055,11 +1055,10 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 			 * scan. The cfg80211 does not give us the encryption
 			 * mode at this stage so just setting it to WEP here.
 			 */
-			wpa_enabled = 0;
-			auth_type = MWIFIEX_AUTH_MODE_OPEN;
-			ret = mwifiex_set_auth(priv,
-						MWIFIEX_ENCRYPTION_MODE_WEP104,
-						auth_type, wpa_enabled);
+			priv->sec_info.encryption_mode =
+					MWIFIEX_ENCRYPTION_MODE_WEP104;
+			priv->sec_info.authentication_mode =
+					MWIFIEX_AUTH_MODE_OPEN;
 		}
 
 		goto done;
@@ -1075,15 +1074,15 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 	if (sme->crypto.n_ciphers_pairwise) {
 		pairwise_encrypt_mode = mwifiex_get_mwifiex_cipher(sme->crypto.
 					ciphers_pairwise[0], &wpa_enabled);
-		ret = mwifiex_set_auth(priv, pairwise_encrypt_mode, auth_type,
-								wpa_enabled);
+		priv->sec_info.encryption_mode = pairwise_encrypt_mode;
+		priv->sec_info.authentication_mode = auth_type;
 	}
 
 	if (sme->crypto.cipher_group) {
 		group_encrypt_mode = mwifiex_get_mwifiex_cipher(sme->crypto.
 						   cipher_group, &wpa_enabled);
-		ret = mwifiex_set_auth(priv, group_encrypt_mode, auth_type,
-								wpa_enabled);
+		priv->sec_info.encryption_mode = group_encrypt_mode;
+		priv->sec_info.authentication_mode = auth_type;
 	}
 	if (sme->ie)
 		ret = mwifiex_set_gen_ie(priv, sme->ie, sme->ie_len);
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index d6babfb..b7e4571 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -277,8 +277,6 @@ struct mwifiex_debug_info {
 enum {
 	MWIFIEX_AUTH_MODE_OPEN = 0x00,
 	MWIFIEX_AUTH_MODE_SHARED = 0x01,
-	MWIFIEX_AUTH_MODE_NETWORKEAP = 0x80,
-	MWIFIEX_AUTH_MODE_AUTO = 0xFF,
 };
 
 enum {
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index d06f4c2..98d76d8 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -441,20 +441,17 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 	dev_dbg(priv->adapter->dev, "info: ASSOC_CMD: rates size = %d\n",
 					rates_size);
 
-	/* Add the Authentication type to be used for Auth frames if needed */
-	if (priv->sec_info.authentication_mode != MWIFIEX_AUTH_MODE_AUTO) {
-		auth_tlv = (struct mwifiex_ie_types_auth_type *) pos;
-		auth_tlv->header.type = cpu_to_le16(TLV_TYPE_AUTH_TYPE);
-		auth_tlv->header.len = cpu_to_le16(sizeof(auth_tlv->auth_type));
-		if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_ENABLED)
-			auth_tlv->auth_type = cpu_to_le16((u16) priv->sec_info.
-							  authentication_mode);
-		else
-			auth_tlv->auth_type =
-				cpu_to_le16(MWIFIEX_AUTH_MODE_OPEN);
-		pos += sizeof(auth_tlv->header) +
-			le16_to_cpu(auth_tlv->header.len);
-	}
+	/* Add the Authentication type to be used for Auth frames */
+	auth_tlv = (struct mwifiex_ie_types_auth_type *) pos;
+	auth_tlv->header.type = cpu_to_le16(TLV_TYPE_AUTH_TYPE);
+	auth_tlv->header.len = cpu_to_le16(sizeof(auth_tlv->auth_type));
+	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_ENABLED)
+		auth_tlv->auth_type = cpu_to_le16(
+				(u16) priv->sec_info.authentication_mode);
+	else
+		auth_tlv->auth_type = cpu_to_le16(MWIFIEX_AUTH_MODE_OPEN);
+
+	pos += sizeof(auth_tlv->header) + le16_to_cpu(auth_tlv->header.len);
 
 	if (IS_SUPPORT_MULTI_BANDS(priv->adapter)
 	    && !(ISSUPP_11NENABLED(priv->adapter->fw_cap_info)
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 2b0ad8e..f6fe105 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -994,11 +994,6 @@ int mwifiex_get_channel_list(struct mwifiex_private *priv,
 int mwifiex_get_scan_table(struct mwifiex_private *priv,
 			   u8 wait_option,
 			   struct mwifiex_scan_resp *scanresp);
-int mwifiex_get_auth_mode(struct mwifiex_private *priv,
-			  u8 wait_option, u32 *auth_mode);
-int mwifiex_get_encrypt_mode(struct mwifiex_private *priv,
-			     u8 wait_option,
-			     u32 *encrypt_mode);
 int mwifiex_enable_wep_key(struct mwifiex_private *priv, u8 wait_option);
 int mwifiex_find_best_bss(struct mwifiex_private *priv, u8 wait_option,
 			  struct mwifiex_ssid_bssid *ssid_bssid);
@@ -1014,9 +1009,6 @@ int mwifiex_drv_get_mode(struct mwifiex_private *priv, u8 wait_option);
 
 int mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, int channel);
 
-int mwifiex_set_auth(struct mwifiex_private *priv, int encrypt_mode,
-		     int auth_mode, int wpa_enabled);
-
 int mwifiex_set_encode(struct mwifiex_private *priv, const u8 *key,
 		       int key_len, u8 key_index, int disable);
 
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 665a519..362301f 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -1691,20 +1691,6 @@ static int mwifiex_sec_ioctl_set_wapi_key(struct mwifiex_adapter *adapter,
 }
 
 /*
- * IOCTL request handler to set/get authentication mode.
- */
-static int mwifiex_set_auth_mode(struct mwifiex_private *priv, u32 auth_mode)
-{
-	int ret = 0;
-
-	priv->sec_info.authentication_mode = auth_mode;
-	if (priv->sec_info.authentication_mode == MWIFIEX_AUTH_MODE_NETWORKEAP)
-		ret = mwifiex_set_wpa_ie_helper(priv, NULL, 0);
-
-	return ret;
-}
-
-/*
  * IOCTL request handler to set WEP network key.
  *
  * This function prepares the correct firmware command and
@@ -1999,36 +1985,6 @@ int mwifiex_get_signal_info(struct mwifiex_private *priv, u8 wait_option,
 }
 
 /*
- * Sends IOCTL request to set encryption mode.
- *
- * This function allocates the IOCTL request buffer, fills it
- * with requisite parameters and calls the IOCTL handler.
- */
-static int mwifiex_set_encrypt_mode(struct mwifiex_private *priv,
-				    u8 wait_option, u32 encrypt_mode)
-{
-	priv->sec_info.encryption_mode = encrypt_mode;
-	return 0;
-}
-
-/*
- * This function set the authentication parameters. It sets both encryption
- * mode and authentication mode, and also enables WPA if required.
- */
-int
-mwifiex_set_auth(struct mwifiex_private *priv, int encrypt_mode,
-		 int auth_mode, int wpa_enabled)
-{
-	if (mwifiex_set_encrypt_mode(priv, MWIFIEX_IOCTL_WAIT, encrypt_mode))
-		return -EFAULT;
-
-	if (mwifiex_set_auth_mode(priv, auth_mode))
-		return -EFAULT;
-
-	return 0;
-}
-
-/*
  * Sends IOCTL request to set encoding parameters.
  *
  * This function allocates the IOCTL request buffer, fills it
-- 
1.7.0.2

