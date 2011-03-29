Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:36018 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab1C2Av5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2011 20:51:57 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/4] mwifiex: remove MWIFIEX_AUTH_MODE_ macros
Date: Mon, 28 Mar 2011 17:55:42 -0700
Message-Id: <1301360144-4986-2-git-send-email-bzhao@marvell.com>
In-Reply-To: <1301360144-4986-1-git-send-email-bzhao@marvell.com>
References: <1301360144-4986-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Marc Yang <yangyang@marvell.com>

replace them with NL80211_AUTHTYPE_ macros

Signed-off-by: Marc Yang <yangyang@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    8 ++++----
 drivers/net/wireless/mwifiex/init.c     |    2 +-
 drivers/net/wireless/mwifiex/ioctl.h    |    5 -----
 drivers/net/wireless/mwifiex/join.c     |    2 +-
 4 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 701c179..2d96800 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -600,7 +600,7 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 
 	mwifiex_deauthenticate(priv, wait, NULL);
 
-	priv->sec_info.authentication_mode = MWIFIEX_AUTH_MODE_OPEN;
+	priv->sec_info.authentication_mode = NL80211_AUTHTYPE_OPEN_SYSTEM;
 
 	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_SET_BSS_MODE,
 				  HostCmd_ACT_GEN_SET, 0, wait, NULL);
@@ -1056,7 +1056,7 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 			priv->sec_info.encryption_mode =
 					MWIFIEX_ENCRYPTION_MODE_WEP104;
 			priv->sec_info.authentication_mode =
-					MWIFIEX_AUTH_MODE_OPEN;
+					NL80211_AUTHTYPE_OPEN_SYSTEM;
 		}
 
 		goto done;
@@ -1065,9 +1065,9 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 	/* Now handle infra mode. "sme" is valid for infra mode only */
 	if (sme->auth_type == NL80211_AUTHTYPE_AUTOMATIC
 			|| sme->auth_type == NL80211_AUTHTYPE_OPEN_SYSTEM)
-		auth_type = MWIFIEX_AUTH_MODE_OPEN;
+		auth_type = NL80211_AUTHTYPE_OPEN_SYSTEM;
 	else if (sme->auth_type == NL80211_AUTHTYPE_SHARED_KEY)
-		auth_type = MWIFIEX_AUTH_MODE_SHARED;
+		auth_type = NL80211_AUTHTYPE_SHARED_KEY;
 
 	if (sme->crypto.n_ciphers_pairwise) {
 		pairwise_encrypt_mode = mwifiex_get_mwifiex_cipher(sme->crypto.
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 00e73ea..bad436d 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -85,7 +85,7 @@ static int mwifiex_init_priv(struct mwifiex_private *priv)
 	priv->data_avg_factor = DEFAULT_DATA_AVG_FACTOR;
 
 	priv->sec_info.wep_status = MWIFIEX_802_11_WEP_DISABLED;
-	priv->sec_info.authentication_mode = MWIFIEX_AUTH_MODE_OPEN;
+	priv->sec_info.authentication_mode = NL80211_AUTHTYPE_OPEN_SYSTEM;
 	priv->sec_info.encryption_mode = MWIFIEX_ENCRYPTION_MODE_NONE;
 	for (i = 0; i < ARRAY_SIZE(priv->wep_key); i++)
 		memset(&priv->wep_key[i], 0, sizeof(struct mwifiex_wep_key));
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index 7fb81df..7e0d316 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -269,11 +269,6 @@ struct mwifiex_debug_info {
 };
 
 enum {
-	MWIFIEX_AUTH_MODE_OPEN = 0x00,
-	MWIFIEX_AUTH_MODE_SHARED = 0x01,
-};
-
-enum {
 	MWIFIEX_ENCRYPTION_MODE_NONE = 0,
 	MWIFIEX_ENCRYPTION_MODE_WEP40 = 1,
 	MWIFIEX_ENCRYPTION_MODE_TKIP = 2,
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index d8c7c5f..8a1eb2a 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -449,7 +449,7 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 		auth_tlv->auth_type = cpu_to_le16(
 				(u16) priv->sec_info.authentication_mode);
 	else
-		auth_tlv->auth_type = cpu_to_le16(MWIFIEX_AUTH_MODE_OPEN);
+		auth_tlv->auth_type = cpu_to_le16(NL80211_AUTHTYPE_OPEN_SYSTEM);
 
 	pos += sizeof(auth_tlv->header) + le16_to_cpu(auth_tlv->header.len);
 
-- 
1.7.0.2

