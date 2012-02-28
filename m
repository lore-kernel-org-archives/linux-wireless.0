Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:39163 "HELO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753218Ab2B1GFX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 01:05:23 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/6 RESEND] mwifiex: remove unnecessary enum MWIFIEX_802_11_WEP_STATUS
Date: Mon, 27 Feb 2012 22:04:12 -0800
Message-Id: <1330409056-4399-3-git-send-email-bzhao@marvell.com> (sfid-20120228_070527_573346_C8C300F1)
In-Reply-To: <1330409056-4399-1-git-send-email-bzhao@marvell.com>
References: <1330409056-4399-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Instead of defining an 'enum', we can simply use 'u8' flag for WEP
status. Rename 'wep_status' to 'wep_enabled' to match with
'wpa_enabled' and 'wpa2_enabled'.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c  |    2 +-
 drivers/net/wireless/mwifiex/fw.h        |    5 ---
 drivers/net/wireless/mwifiex/init.c      |    2 +-
 drivers/net/wireless/mwifiex/join.c      |    5 +--
 drivers/net/wireless/mwifiex/main.h      |    2 +-
 drivers/net/wireless/mwifiex/scan.c      |   47 ++++++++++++------------------
 drivers/net/wireless/mwifiex/sta_ioctl.c |   10 +++---
 7 files changed, 29 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 2a1fc32..9f3d8aa 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -146,7 +146,7 @@ mwifiex_cfg80211_set_default_key(struct wiphy *wiphy, struct net_device *netdev,
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(netdev);
 
 	/* Return if WEP key not configured */
-	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_DISABLED)
+	if (!priv->sec_info.wep_enabled)
 		return 0;
 
 	if (mwifiex_set_encode(priv, NULL, 0, key_index, 0)) {
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 51c5417..c826200 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -86,11 +86,6 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 	MWIFIEX_802_11_PRIV_FILTER_8021X_WEP
 };
 
-enum MWIFIEX_802_11_WEP_STATUS {
-	MWIFIEX_802_11_WEP_ENABLED,
-	MWIFIEX_802_11_WEP_DISABLED,
-};
-
 #define CAL_SNR(RSSI, NF)		((s16)((s16)(RSSI)-(s16)(NF)))
 
 #define PROPRIETARY_TLV_BASE_ID                 0x0100
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index ca59cc0..e81bf6e 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -82,7 +82,7 @@ static int mwifiex_init_priv(struct mwifiex_private *priv)
 	priv->bcn_avg_factor = DEFAULT_BCN_AVG_FACTOR;
 	priv->data_avg_factor = DEFAULT_DATA_AVG_FACTOR;
 
-	priv->sec_info.wep_status = MWIFIEX_802_11_WEP_DISABLED;
+	priv->sec_info.wep_enabled = 0;
 	priv->sec_info.authentication_mode = NL80211_AUTHTYPE_OPEN_SYSTEM;
 	priv->sec_info.encryption_mode = 0;
 	for (i = 0; i < ARRAY_SIZE(priv->wep_key); i++)
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 0b0eb5e..ee439fc 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -417,7 +417,7 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 	auth_tlv = (struct mwifiex_ie_types_auth_type *) pos;
 	auth_tlv->header.type = cpu_to_le16(TLV_TYPE_AUTH_TYPE);
 	auth_tlv->header.len = cpu_to_le16(sizeof(auth_tlv->auth_type));
-	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_ENABLED)
+	if (priv->sec_info.wep_enabled)
 		auth_tlv->auth_type = cpu_to_le16(
 				(u16) priv->sec_info.authentication_mode);
 	else
@@ -1069,8 +1069,7 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 	priv->curr_bss_params.bss_descriptor.channel = bss_desc->channel;
 	priv->curr_bss_params.band = (u8) bss_desc->bss_band;
 
-	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_ENABLED
-	    || priv->sec_info.wpa_enabled)
+	if (priv->sec_info.wep_enabled || priv->sec_info.wpa_enabled)
 		tmp_cap |= WLAN_CAPABILITY_PRIVACY;
 
 	if (IS_SUPPORT_MULTI_BANDS(priv->adapter)) {
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 52810b1..4c86217 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -217,7 +217,7 @@ struct mwifiex_802_11_security {
 	u8 wpa2_enabled;
 	u8 wapi_enabled;
 	u8 wapi_key_on;
-	enum MWIFIEX_802_11_WEP_STATUS wep_status;
+	u8 wep_enabled;
 	u32 authentication_mode;
 	u32 encryption_mode;
 };
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 98f1ca9..8f10038 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -196,9 +196,8 @@ static bool
 mwifiex_is_network_compatible_for_no_sec(struct mwifiex_private *priv,
 				       struct mwifiex_bssdescriptor *bss_desc)
 {
-	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_DISABLED
-	    && !priv->sec_info.wpa_enabled && !priv->sec_info.wpa2_enabled
-	    && ((!bss_desc->bcn_wpa_ie) ||
+	if (!priv->sec_info.wep_enabled && !priv->sec_info.wpa_enabled &&
+	    !priv->sec_info.wpa2_enabled && ((!bss_desc->bcn_wpa_ie) ||
 		((*(bss_desc->bcn_wpa_ie)).vend_hdr.element_id !=
 	    WLAN_EID_WPA))
 	    && ((!bss_desc->bcn_rsn_ie) ||
@@ -219,9 +218,8 @@ static bool
 mwifiex_is_network_compatible_for_static_wep(struct mwifiex_private *priv,
 				       struct mwifiex_bssdescriptor *bss_desc)
 {
-	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_ENABLED
-	    && !priv->sec_info.wpa_enabled && !priv->sec_info.wpa2_enabled
-	    && bss_desc->privacy) {
+	if (priv->sec_info.wep_enabled && !priv->sec_info.wpa_enabled &&
+	    !priv->sec_info.wpa2_enabled && bss_desc->privacy) {
 		return true;
 	}
 	return false;
@@ -235,10 +233,9 @@ static bool
 mwifiex_is_network_compatible_for_wpa(struct mwifiex_private *priv,
 				      struct mwifiex_bssdescriptor *bss_desc)
 {
-	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_DISABLED
-	    && priv->sec_info.wpa_enabled && !priv->sec_info.wpa2_enabled
-	    && ((bss_desc->bcn_wpa_ie) && ((*(bss_desc->bcn_wpa_ie)).vend_hdr.
-						element_id == WLAN_EID_WPA))
+	if (!priv->sec_info.wep_enabled && priv->sec_info.wpa_enabled &&
+	    !priv->sec_info.wpa2_enabled && ((bss_desc->bcn_wpa_ie) &&
+	    ((*(bss_desc->bcn_wpa_ie)).vend_hdr.element_id == WLAN_EID_WPA))
 	   /*
 	    * Privacy bit may NOT be set in some APs like
 	    * LinkSys WRT54G && bss_desc->privacy
@@ -253,8 +250,7 @@ mwifiex_is_network_compatible_for_wpa(struct mwifiex_private *priv,
 			(bss_desc->bcn_rsn_ie) ?
 			(*(bss_desc->bcn_rsn_ie)).
 			ieee_hdr.element_id : 0,
-			(priv->sec_info.wep_status ==
-			MWIFIEX_802_11_WEP_ENABLED) ? "e" : "d",
+			(priv->sec_info.wep_enabled) ? "e" : "d",
 			(priv->sec_info.wpa_enabled) ? "e" : "d",
 			(priv->sec_info.wpa2_enabled) ? "e" : "d",
 			priv->sec_info.encryption_mode,
@@ -272,10 +268,9 @@ static bool
 mwifiex_is_network_compatible_for_wpa2(struct mwifiex_private *priv,
 				       struct mwifiex_bssdescriptor *bss_desc)
 {
-	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_DISABLED
-	   && !priv->sec_info.wpa_enabled && priv->sec_info.wpa2_enabled
-	   && ((bss_desc->bcn_rsn_ie) && ((*(bss_desc->bcn_rsn_ie)).ieee_hdr.
-						element_id == WLAN_EID_RSN))
+	if (!priv->sec_info.wep_enabled && !priv->sec_info.wpa_enabled &&
+	    priv->sec_info.wpa2_enabled && ((bss_desc->bcn_rsn_ie) &&
+	    ((*(bss_desc->bcn_rsn_ie)).ieee_hdr.element_id == WLAN_EID_RSN))
 	   /*
 	    * Privacy bit may NOT be set in some APs like
 	    * LinkSys WRT54G && bss_desc->privacy
@@ -290,8 +285,7 @@ mwifiex_is_network_compatible_for_wpa2(struct mwifiex_private *priv,
 			(bss_desc->bcn_rsn_ie) ?
 			(*(bss_desc->bcn_rsn_ie)).
 			ieee_hdr.element_id : 0,
-			(priv->sec_info.wep_status ==
-			MWIFIEX_802_11_WEP_ENABLED) ? "e" : "d",
+			(priv->sec_info.wep_enabled) ? "e" : "d",
 			(priv->sec_info.wpa_enabled) ? "e" : "d",
 			(priv->sec_info.wpa2_enabled) ? "e" : "d",
 			priv->sec_info.encryption_mode,
@@ -309,10 +303,9 @@ static bool
 mwifiex_is_network_compatible_for_adhoc_aes(struct mwifiex_private *priv,
 				       struct mwifiex_bssdescriptor *bss_desc)
 {
-	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_DISABLED
-	    && !priv->sec_info.wpa_enabled && !priv->sec_info.wpa2_enabled
-	    && ((!bss_desc->bcn_wpa_ie) || ((*(bss_desc->bcn_wpa_ie)).vend_hdr.
-		   element_id != WLAN_EID_WPA))
+	if (!priv->sec_info.wep_enabled && !priv->sec_info.wpa_enabled &&
+	    !priv->sec_info.wpa2_enabled && ((!bss_desc->bcn_wpa_ie) ||
+	    ((*(bss_desc->bcn_wpa_ie)).vend_hdr.element_id != WLAN_EID_WPA))
 	    && ((!bss_desc->bcn_rsn_ie) || ((*(bss_desc->bcn_rsn_ie)).ieee_hdr.
 		   element_id != WLAN_EID_RSN))
 	    && !priv->sec_info.encryption_mode
@@ -330,10 +323,9 @@ static bool
 mwifiex_is_network_compatible_for_dynamic_wep(struct mwifiex_private *priv,
 				       struct mwifiex_bssdescriptor *bss_desc)
 {
-	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_DISABLED
-	    && !priv->sec_info.wpa_enabled && !priv->sec_info.wpa2_enabled
-	    && ((!bss_desc->bcn_wpa_ie) || ((*(bss_desc->bcn_wpa_ie)).vend_hdr.
-		   element_id != WLAN_EID_WPA))
+	if (!priv->sec_info.wep_enabled && !priv->sec_info.wpa_enabled &&
+	    !priv->sec_info.wpa2_enabled && ((!bss_desc->bcn_wpa_ie) ||
+	    ((*(bss_desc->bcn_wpa_ie)).vend_hdr.element_id != WLAN_EID_WPA))
 	    && ((!bss_desc->bcn_rsn_ie) || ((*(bss_desc->bcn_rsn_ie)).ieee_hdr.
 		   element_id != WLAN_EID_RSN))
 	    && priv->sec_info.encryption_mode
@@ -468,8 +460,7 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv,
 		       (bss_desc->bcn_rsn_ie) ?
 		       (*(bss_desc->bcn_rsn_ie)).ieee_hdr.
 		       element_id : 0,
-		       (priv->sec_info.wep_status ==
-				MWIFIEX_802_11_WEP_ENABLED) ? "e" : "d",
+		       (priv->sec_info.wep_enabled) ? "e" : "d",
 		       (priv->sec_info.wpa_enabled) ? "e" : "d",
 		       (priv->sec_info.wpa2_enabled) ? "e" : "d",
 		       priv->sec_info.encryption_mode, bss_desc->privacy);
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index b0fbf5d..866026e 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -471,7 +471,7 @@ int mwifiex_get_bss_info(struct mwifiex_private *priv,
 
 	info->bcn_nf_last = priv->bcn_nf_last;
 
-	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_ENABLED)
+	if (priv->sec_info.wep_enabled)
 		info->wep_status = true;
 	else
 		info->wep_status = false;
@@ -1020,7 +1020,7 @@ static int mwifiex_sec_ioctl_set_wep_key(struct mwifiex_private *priv,
 	wep_key = &priv->wep_key[priv->wep_key_curr_index];
 	index = encrypt_key->key_index;
 	if (encrypt_key->key_disable) {
-		priv->sec_info.wep_status = MWIFIEX_802_11_WEP_DISABLED;
+		priv->sec_info.wep_enabled = 0;
 	} else if (!encrypt_key->key_len) {
 		/* Copy the required key as the current key */
 		wep_key = &priv->wep_key[index];
@@ -1030,7 +1030,7 @@ static int mwifiex_sec_ioctl_set_wep_key(struct mwifiex_private *priv,
 			return -1;
 		}
 		priv->wep_key_curr_index = (u16) index;
-		priv->sec_info.wep_status = MWIFIEX_802_11_WEP_ENABLED;
+		priv->sec_info.wep_enabled = 1;
 	} else {
 		wep_key = &priv->wep_key[index];
 		memset(wep_key, 0, sizeof(struct mwifiex_wep_key));
@@ -1040,7 +1040,7 @@ static int mwifiex_sec_ioctl_set_wep_key(struct mwifiex_private *priv,
 		       encrypt_key->key_len);
 		wep_key->key_index = index;
 		wep_key->key_length = encrypt_key->key_len;
-		priv->sec_info.wep_status = MWIFIEX_802_11_WEP_ENABLED;
+		priv->sec_info.wep_enabled = 1;
 	}
 	if (wep_key->key_length) {
 		/* Send request to firmware */
@@ -1050,7 +1050,7 @@ static int mwifiex_sec_ioctl_set_wep_key(struct mwifiex_private *priv,
 		if (ret)
 			return ret;
 	}
-	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_ENABLED)
+	if (priv->sec_info.wep_enabled)
 		priv->curr_pkt_filter |= HostCmd_ACT_MAC_WEP_ENABLE;
 	else
 		priv->curr_pkt_filter &= ~HostCmd_ACT_MAC_WEP_ENABLE;
-- 
1.7.0.2

