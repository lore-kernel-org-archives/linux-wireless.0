Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:42484 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab1CQAGQ (ORCPT
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
Subject: [PATCH 07/11] mwifiex: remove unnecessary flag ewpa_enabled
Date: Wed, 16 Mar 2011 17:09:30 -0700
Message-Id: <1300320574-10793-8-git-send-email-bzhao@marvell.com>
In-Reply-To: <1300320574-10793-1-git-send-email-bzhao@marvell.com>
References: <1300320574-10793-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

'priv->sec_info.ewpa_enabled' flag was used to store embedded
supplicant status. Now remove ewpa_enable from priv->sec_info
since embedded supplicant has already been removed.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c  |    3 -
 drivers/net/wireless/mwifiex/join.c      |   97 +----------------------------
 drivers/net/wireless/mwifiex/main.h      |    1 -
 drivers/net/wireless/mwifiex/scan.c      |   51 ----------------
 drivers/net/wireless/mwifiex/sta_event.c |    1 -
 drivers/net/wireless/mwifiex/sta_ioctl.c |   13 +---
 drivers/net/wireless/mwifiex/wmm.c       |    5 +-
 7 files changed, 10 insertions(+), 161 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index ad95d53..fe03baa 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1046,9 +1046,6 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 				mwifiex_channels_to_cfg80211_channel_type
 				(priv->adapter->chan_offset));
 
-	/* reset eWPA mode */
-	priv->sec_info.ewpa_enabled = false;
-
 	if (!sme && (mode != MWIFIEX_BSS_MODE_IBSS)) {
 		BUG_ON(sme == NULL);
 		return ret;
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 34623d1..fb189ba 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -334,76 +334,6 @@ static int mwifiex_append_rsn_ie_wpa_wpa2(struct mwifiex_private *priv,
 }
 
 /*
- * This function appends rsn ie tlv for embedded supplicant.
- * It is called from the network join command preparation routine.
- */
-static int
-mwifiex_append_rsn_ie_ewpa(struct mwifiex_private *priv, u8 **buffer,
-			   struct mwifiex_bssdescriptor *bss_desc)
-{
-	struct mwifiex_ie_types_rsn_param_set *rsn_ie_tlv;
-	int rsn_ie_len = 0;
-
-	if (!buffer || !(*buffer))
-		return 0;
-
-	rsn_ie_tlv = (struct mwifiex_ie_types_rsn_param_set *) (*buffer);
-	if (bss_desc->bcn_wpa_ie) {
-		rsn_ie_tlv->header.type =
-			cpu_to_le16((u16) (*(bss_desc->bcn_wpa_ie))
-					.vend_hdr.element_id);
-		rsn_ie_tlv->header.type =
-			cpu_to_le16(le16_to_cpu(rsn_ie_tlv->header.type)
-					& 0x00FF);
-		rsn_ie_tlv->header.len =
-			cpu_to_le16((u16) (*(bss_desc->bcn_wpa_ie))
-					.vend_hdr.len);
-		rsn_ie_tlv->header.len =
-			cpu_to_le16(le16_to_cpu(rsn_ie_tlv->header.len)
-					& 0x00FF);
-		if (le16_to_cpu(rsn_ie_tlv->header.len)
-				<= (sizeof(priv->wpa_ie)))
-			memcpy(rsn_ie_tlv->rsn_ie, &((*(bss_desc->bcn_wpa_ie))
-					.vend_hdr.oui[0]),
-					le16_to_cpu(rsn_ie_tlv->header.len));
-		else
-			return -1;
-
-		rsn_ie_len += sizeof(rsn_ie_tlv->header) +
-					le16_to_cpu(rsn_ie_tlv->header.len);
-		*buffer += rsn_ie_len;
-	}
-	if (bss_desc->bcn_rsn_ie) {
-		rsn_ie_tlv = (struct mwifiex_ie_types_rsn_param_set *)
-								(*buffer);
-		rsn_ie_tlv->header.type =
-				cpu_to_le16((u16) (*(bss_desc->bcn_rsn_ie))
-					.ieee_hdr.element_id);
-		rsn_ie_tlv->header.type =
-				cpu_to_le16(le16_to_cpu(rsn_ie_tlv->header.type)
-					& 0x00FF);
-		rsn_ie_tlv->header.len =
-				cpu_to_le16((u16) (*(bss_desc->bcn_rsn_ie))
-					.ieee_hdr.len);
-		rsn_ie_tlv->header.len =
-			cpu_to_le16(le16_to_cpu(rsn_ie_tlv->header.len)
-					& 0x00FF);
-		if (le16_to_cpu(rsn_ie_tlv->header.len)
-				<= (sizeof(priv->wpa_ie)))
-			memcpy(rsn_ie_tlv->rsn_ie,
-				&((*(bss_desc->bcn_rsn_ie)).data[0]),
-				le16_to_cpu(rsn_ie_tlv->header.len));
-		else
-			return -1;
-
-		rsn_ie_len += sizeof(rsn_ie_tlv->header) +
-				le16_to_cpu(rsn_ie_tlv->header.len);
-		buffer += rsn_ie_len;
-	}
-	return rsn_ie_len;
-}
-
-/*
  * This function prepares command for association.
  *
  * This sets the following parameters -
@@ -560,9 +490,6 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 	if (!priv->wps.session_enable) {
 		if (priv->sec_info.wpa_enabled || priv->sec_info.wpa2_enabled)
 			rsn_ie_len = mwifiex_append_rsn_ie_wpa_wpa2(priv, &pos);
-		else if (priv->sec_info.ewpa_enabled)
-			rsn_ie_len = mwifiex_append_rsn_ie_ewpa(priv, &pos,
-								bss_desc);
 
 		if (rsn_ie_len == -1)
 			return -1;
@@ -789,9 +716,7 @@ int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 	if (netif_queue_stopped(priv->netdev))
 		netif_wake_queue(priv->netdev);
 
-	if (priv->sec_info.ewpa_enabled ||
-			priv->sec_info.wpa_enabled ||
-				priv->sec_info.wpa2_enabled)
+	if (priv->sec_info.wpa_enabled || priv->sec_info.wpa2_enabled)
 		priv->scan_block = true;
 
 done:
@@ -846,12 +771,6 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 
 	struct mwifiex_ie_types_htcap *ht_cap;
 	struct mwifiex_ie_types_htinfo *ht_info;
-	/* wpa ie for WPA_NONE AES */
-	const u8 wpa_ie[24] = { 0xdd, 0x16, 0x00, 0x50, 0xf2,
-		0x01, 0x01, 0x00, 0x00, 0x50, 0xf2, 0x04, 0x01,
-		0x00, 0x00, 0x50, 0xf2, 0x00, 0x01, 0x00, 0x00,
-		0x50, 0xf2, 0x00
-	};
 	u8 *pos = (u8 *) adhoc_start +
 			sizeof(struct host_cmd_ds_802_11_ad_hoc_start);
 
@@ -954,8 +873,7 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 
 	/* Set up privacy in bss_desc */
 	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_ENABLED
-			|| priv->sec_info.wpa_enabled
-			|| priv->sec_info.ewpa_enabled) {
+			|| priv->sec_info.wpa_enabled) {
 		/* Ad-Hoc capability privacy on */
 		dev_dbg(adapter->dev,
 			"info: ADHOC_S_CMD: wep_status set privacy to WEP\n");
@@ -1038,12 +956,7 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 	cmd_append_size += mwifiex_cmd_append_vsie_tlv(priv,
 				MWIFIEX_VSIE_MASK_ADHOC, &pos);
 
-	if (priv->sec_info.ewpa_enabled) {
-		memcpy(priv->wpa_ie, wpa_ie, sizeof(wpa_ie));
-		priv->wpa_ie_len = sizeof(wpa_ie);
-	}
-
-	if (priv->sec_info.wpa_enabled || priv->sec_info.ewpa_enabled) {
+	if (priv->sec_info.wpa_enabled) {
 		rsn_ie_len = mwifiex_append_rsn_ie_wpa_wpa2(priv, &pos);
 		if (rsn_ie_len == -1)
 			return -1;
@@ -1222,7 +1135,7 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 	priv->curr_bss_params.band = (u8) bss_desc->bss_band;
 
 	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_ENABLED
-	    || priv->sec_info.wpa_enabled || priv->sec_info.ewpa_enabled)
+	    || priv->sec_info.wpa_enabled)
 		tmp_cap |= WLAN_CAPABILITY_PRIVACY;
 
 	if (IS_SUPPORT_MULTI_BANDS(priv->adapter)) {
@@ -1252,8 +1165,6 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 
 	if (priv->sec_info.wpa_enabled)
 		rsn_ie_len = mwifiex_append_rsn_ie_wpa_wpa2(priv, &pos);
-	else if (priv->sec_info.ewpa_enabled)
-		rsn_ie_len = mwifiex_append_rsn_ie_ewpa(priv, &pos, bss_desc);
 	if (rsn_ie_len == -1)
 		return -1;
 	cmd_append_size += rsn_ie_len;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index f074f5c..f13ae51 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -228,7 +228,6 @@ struct mwifiex_wmm_desc {
 
 struct mwifiex_802_11_security {
 	u8 wpa_enabled;
-	u8 ewpa_enabled;
 	u8 wpa2_enabled;
 	u8 wapi_enabled;
 	u8 wapi_key_on;
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index c0d5823..1152beb 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -241,26 +241,6 @@ int mwifiex_set_user_scan_ioctl(struct mwifiex_private *priv,
 }
 
 /*
- * This function checks if ewpa is enabled in driver and scanned network is
- * compatible with it.
- */
-static bool
-mwifiex_is_network_compatible_for_ewpa(struct mwifiex_private *priv,
-				       struct mwifiex_bssdescriptor *bss_desc)
-{
-	if (priv->sec_info.ewpa_enabled) {
-		if (((bss_desc->bcn_wpa_ie) &&
-		     ((*(bss_desc->bcn_wpa_ie)).vend_hdr.element_id ==
-		     WLAN_EID_WPA)) || ((bss_desc->bcn_rsn_ie) &&
-		     ((*(bss_desc->bcn_rsn_ie)).ieee_hdr.element_id ==
-		     WLAN_EID_RSN))) {
-			return true;
-		}
-	}
-	return false;
-}
-
-/*
  * This function checks if wapi is enabled in driver and scanned network is
  * compatible with it.
  */
@@ -485,37 +465,6 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index, u32 mode)
 		return index;
 	}
 
-	if (bss_desc->bss_mode == mode) {
-		if (mwifiex_is_network_compatible_for_ewpa(priv, bss_desc)) {
-			if (((priv->adapter->config_bands & BAND_GN ||
-			      priv->adapter->config_bands & BAND_AN) &&
-			     bss_desc->bcn_ht_cap)
-			    && !mwifiex_is_wpa_oui_present(bss_desc,
-					CIPHER_SUITE_CCMP)
-			    && !mwifiex_is_rsn_oui_present(bss_desc,
-					CIPHER_SUITE_CCMP)) {
-
-				if (mwifiex_is_wpa_oui_present(bss_desc,
-					CIPHER_SUITE_TKIP) ||
-				   mwifiex_is_rsn_oui_present(bss_desc,
-					CIPHER_SUITE_TKIP)) {
-					dev_dbg(adapter->dev,
-						"info: disable 11n if AES "
-						"is not supported by AP\n");
-					bss_desc->disable_11n = true;
-
-				} else {
-					return -1;
-				}
-			}
-			return index;
-		} else if (priv->sec_info.ewpa_enabled) {
-			dev_dbg(adapter->dev,
-				"info: ewpa_enabled: ignore none WPA/WPA2 AP\n");
-			return -1;
-		}
-	}
-
 	if (mwifiex_is_network_compatible_for_wapi(priv, bss_desc)) {
 		dev_dbg(adapter->dev, "info: return success for WAPI AP\n");
 		return index;
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index 5af2bc4..d4a5c1f 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -68,7 +68,6 @@ mwifiex_reset_connect_state(struct mwifiex_private *priv)
 	priv->bcn_nf_avg = 0;
 	priv->rxpd_rate = 0;
 	priv->rxpd_htinfo = 0;
-	priv->sec_info.ewpa_enabled = false;
 	priv->sec_info.wpa_enabled = false;
 	priv->sec_info.wpa2_enabled = false;
 	priv->wpa_ie_len = 0;
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index d69bb98..3ca5705 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -1894,7 +1894,6 @@ static int mwifiex_sec_ioctl_get_key(struct mwifiex_adapter *adapter,
 
 	if ((priv->sec_info.wep_status == MWIFIEX_802_11_WEP_ENABLED)
 	    || (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_KEY_ABSENT)
-	    || priv->sec_info.ewpa_enabled
 	    || priv->sec_info.wpa_enabled || priv->sec_info.wpa2_enabled)
 		encrypt_key->key_disable = false;
 	else
@@ -1912,10 +1911,8 @@ static int mwifiex_sec_ioctl_get_key(struct mwifiex_adapter *adapter,
 			       priv->wep_key[index].key_length);
 			encrypt_key->key_len =
 				priv->wep_key[index].key_length;
-		} else if ((priv->sec_info.wpa_enabled)
-			   || (priv->sec_info.ewpa_enabled)
-			   || (priv->sec_info.wpa2_enabled)
-			) {
+		} else if (priv->sec_info.wpa_enabled
+			   || priv->sec_info.wpa2_enabled) {
 			/* Return WPA enabled */
 			encrypt_key->key_disable = false;
 			memcpy(encrypt_key->key_material,
@@ -1935,10 +1932,8 @@ static int mwifiex_sec_ioctl_get_key(struct mwifiex_adapter *adapter,
 			       priv->wep_key[index].key_material,
 			       priv->wep_key[index].key_length);
 			encrypt_key->key_len = priv->wep_key[index].key_length;
-		} else if ((priv->sec_info.wpa_enabled)
-			   || (priv->sec_info.ewpa_enabled)
-			   || (priv->sec_info.wpa2_enabled)
-			) {
+		} else if (priv->sec_info.wpa_enabled
+			   || priv->sec_info.wpa2_enabled) {
 			/* Return WPA enabled */
 			encrypt_key->key_disable = false;
 		} else {
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 376fede..1cfbc6b 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -1179,9 +1179,8 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 	}
 
 	if (!ptr->is_11n_enabled || mwifiex_is_ba_stream_setup(priv, ptr, tid)
-	    || (!priv->sec_info.ewpa_enabled &&
-		((priv->sec_info.wpa_enabled
-		  || priv->sec_info.wpa2_enabled) && !priv->wpa_is_gtk_set))
+	    || ((priv->sec_info.wpa_enabled
+		  || priv->sec_info.wpa2_enabled) && !priv->wpa_is_gtk_set)
 		) {
 		mwifiex_send_single_packet(priv, ptr, ptr_index, flags);
 		/* ra_list_spinlock has been freed in
-- 
1.7.0.2

