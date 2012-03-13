Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:52284 "HELO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758329Ab2CMCiX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 22:38:23 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Joe Perches <joe@perches.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 11/15] mwifiex: fix checkpatch --strict warnings/errors  Part 5
Date: Mon, 12 Mar 2012 19:38:07 -0700
Message-Id: <1331606291-322-2-git-send-email-bzhao@marvell.com> (sfid-20120313_033826_566847_5C233F57)
In-Reply-To: <1331606291-322-1-git-send-email-bzhao@marvell.com>
References: <1331606291-322-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

For file scan.c

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/scan.c |  324 +++++++++++++++++------------------
 1 files changed, 160 insertions(+), 164 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 0a0c289..41ad99b 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -125,7 +125,7 @@ mwifiex_is_rsn_oui_present(struct mwifiex_bssdescriptor *bss_desc, u32 cipher)
 					ieee_hdr.element_id == WLAN_EID_RSN))) {
 		iebody = (struct ie_body *)
 			 (((u8 *) bss_desc->bcn_rsn_ie->data) +
-			 RSN_GTK_OUI_OFFSET);
+			  RSN_GTK_OUI_OFFSET);
 		oui = &mwifiex_rsn_oui[cipher][0];
 		ret = mwifiex_search_oui_in_ie(iebody, oui);
 		if (ret)
@@ -148,8 +148,9 @@ mwifiex_is_wpa_oui_present(struct mwifiex_bssdescriptor *bss_desc, u32 cipher)
 	struct ie_body *iebody;
 	u8 ret = MWIFIEX_OUI_NOT_PRESENT;
 
-	if (((bss_desc->bcn_wpa_ie) && ((*(bss_desc->bcn_wpa_ie)).
-				      vend_hdr.element_id == WLAN_EID_WPA))) {
+	if (((bss_desc->bcn_wpa_ie) &&
+	     ((*(bss_desc->bcn_wpa_ie)).vend_hdr.element_id ==
+	      WLAN_EID_WPA))) {
 		iebody = (struct ie_body *) bss_desc->bcn_wpa_ie->data;
 		oui = &mwifiex_wpa_oui[cipher][0];
 		ret = mwifiex_search_oui_in_ie(iebody, oui);
@@ -175,8 +176,8 @@ mwifiex_ssid_cmp(struct cfg80211_ssid *ssid1, struct cfg80211_ssid *ssid2)
  * compatible with it.
  */
 static bool
-mwifiex_is_network_compatible_for_wapi(struct mwifiex_private *priv,
-				       struct mwifiex_bssdescriptor *bss_desc)
+mwifiex_is_bss_wapi(struct mwifiex_private *priv,
+		    struct mwifiex_bssdescriptor *bss_desc)
 {
 	if (priv->sec_info.wapi_enabled &&
 	    (bss_desc->bcn_wapi_ie &&
@@ -192,18 +193,17 @@ mwifiex_is_network_compatible_for_wapi(struct mwifiex_private *priv,
  * scanned network is compatible with it.
  */
 static bool
-mwifiex_is_network_compatible_for_no_sec(struct mwifiex_private *priv,
-				       struct mwifiex_bssdescriptor *bss_desc)
+mwifiex_is_bss_no_sec(struct mwifiex_private *priv,
+		      struct mwifiex_bssdescriptor *bss_desc)
 {
 	if (!priv->sec_info.wep_enabled && !priv->sec_info.wpa_enabled &&
 	    !priv->sec_info.wpa2_enabled && ((!bss_desc->bcn_wpa_ie) ||
 		((*(bss_desc->bcn_wpa_ie)).vend_hdr.element_id !=
-	    WLAN_EID_WPA))
-	    && ((!bss_desc->bcn_rsn_ie) ||
+		 WLAN_EID_WPA)) &&
+	    ((!bss_desc->bcn_rsn_ie) ||
 		((*(bss_desc->bcn_rsn_ie)).ieee_hdr.element_id !=
-	    WLAN_EID_RSN))
-	    && !priv->sec_info.encryption_mode
-	    && !bss_desc->privacy) {
+		 WLAN_EID_RSN)) &&
+	    !priv->sec_info.encryption_mode && !bss_desc->privacy) {
 		return true;
 	}
 	return false;
@@ -214,8 +214,8 @@ mwifiex_is_network_compatible_for_no_sec(struct mwifiex_private *priv,
  * is compatible with it.
  */
 static bool
-mwifiex_is_network_compatible_for_static_wep(struct mwifiex_private *priv,
-				       struct mwifiex_bssdescriptor *bss_desc)
+mwifiex_is_bss_static_wep(struct mwifiex_private *priv,
+			  struct mwifiex_bssdescriptor *bss_desc)
 {
 	if (priv->sec_info.wep_enabled && !priv->sec_info.wpa_enabled &&
 	    !priv->sec_info.wpa2_enabled && bss_desc->privacy) {
@@ -229,8 +229,8 @@ mwifiex_is_network_compatible_for_static_wep(struct mwifiex_private *priv,
  * compatible with it.
  */
 static bool
-mwifiex_is_network_compatible_for_wpa(struct mwifiex_private *priv,
-				      struct mwifiex_bssdescriptor *bss_desc)
+mwifiex_is_bss_wpa(struct mwifiex_private *priv,
+		   struct mwifiex_bssdescriptor *bss_desc)
 {
 	if (!priv->sec_info.wep_enabled && priv->sec_info.wpa_enabled &&
 	    !priv->sec_info.wpa2_enabled && ((bss_desc->bcn_wpa_ie) &&
@@ -264,17 +264,18 @@ mwifiex_is_network_compatible_for_wpa(struct mwifiex_private *priv,
  * compatible with it.
  */
 static bool
-mwifiex_is_network_compatible_for_wpa2(struct mwifiex_private *priv,
-				       struct mwifiex_bssdescriptor *bss_desc)
+mwifiex_is_bss_wpa2(struct mwifiex_private *priv,
+		    struct mwifiex_bssdescriptor *bss_desc)
 {
-	if (!priv->sec_info.wep_enabled && !priv->sec_info.wpa_enabled &&
-	    priv->sec_info.wpa2_enabled && ((bss_desc->bcn_rsn_ie) &&
-	    ((*(bss_desc->bcn_rsn_ie)).ieee_hdr.element_id == WLAN_EID_RSN))
-	   /*
-	    * Privacy bit may NOT be set in some APs like
-	    * LinkSys WRT54G && bss_desc->privacy
-	    */
-	 ) {
+	if (!priv->sec_info.wep_enabled &&
+	    !priv->sec_info.wpa_enabled &&
+	    priv->sec_info.wpa2_enabled &&
+	    ((bss_desc->bcn_rsn_ie) &&
+	     ((*(bss_desc->bcn_rsn_ie)).ieee_hdr.element_id == WLAN_EID_RSN))) {
+		/*
+		 * Privacy bit may NOT be set in some APs like
+		 * LinkSys WRT54G && bss_desc->privacy
+		 */
 		dev_dbg(priv->adapter->dev, "info: %s: WPA2: "
 			" wpa_ie=%#x wpa2_ie=%#x WEP=%s WPA=%s WPA2=%s "
 			"EncMode=%#x privacy=%#x\n", __func__,
@@ -299,16 +300,16 @@ mwifiex_is_network_compatible_for_wpa2(struct mwifiex_private *priv,
  * compatible with it.
  */
 static bool
-mwifiex_is_network_compatible_for_adhoc_aes(struct mwifiex_private *priv,
-				       struct mwifiex_bssdescriptor *bss_desc)
+mwifiex_is_bss_adhoc_aes(struct mwifiex_private *priv,
+			 struct mwifiex_bssdescriptor *bss_desc)
 {
 	if (!priv->sec_info.wep_enabled && !priv->sec_info.wpa_enabled &&
-	    !priv->sec_info.wpa2_enabled && ((!bss_desc->bcn_wpa_ie) ||
-	    ((*(bss_desc->bcn_wpa_ie)).vend_hdr.element_id != WLAN_EID_WPA))
-	    && ((!bss_desc->bcn_rsn_ie) || ((*(bss_desc->bcn_rsn_ie)).ieee_hdr.
-		   element_id != WLAN_EID_RSN))
-	    && !priv->sec_info.encryption_mode
-	    && bss_desc->privacy) {
+	    !priv->sec_info.wpa2_enabled &&
+	    ((!bss_desc->bcn_wpa_ie) ||
+	     ((*(bss_desc->bcn_wpa_ie)).vend_hdr.element_id != WLAN_EID_WPA)) &&
+	    ((!bss_desc->bcn_rsn_ie) ||
+	     ((*(bss_desc->bcn_rsn_ie)).ieee_hdr.element_id != WLAN_EID_RSN)) &&
+	    !priv->sec_info.encryption_mode && bss_desc->privacy) {
 		return true;
 	}
 	return false;
@@ -319,16 +320,16 @@ mwifiex_is_network_compatible_for_adhoc_aes(struct mwifiex_private *priv,
  * is compatible with it.
  */
 static bool
-mwifiex_is_network_compatible_for_dynamic_wep(struct mwifiex_private *priv,
-				       struct mwifiex_bssdescriptor *bss_desc)
+mwifiex_is_bss_dynamic_wep(struct mwifiex_private *priv,
+			   struct mwifiex_bssdescriptor *bss_desc)
 {
 	if (!priv->sec_info.wep_enabled && !priv->sec_info.wpa_enabled &&
-	    !priv->sec_info.wpa2_enabled && ((!bss_desc->bcn_wpa_ie) ||
-	    ((*(bss_desc->bcn_wpa_ie)).vend_hdr.element_id != WLAN_EID_WPA))
-	    && ((!bss_desc->bcn_rsn_ie) || ((*(bss_desc->bcn_rsn_ie)).ieee_hdr.
-		   element_id != WLAN_EID_RSN))
-	    && priv->sec_info.encryption_mode
-	    && bss_desc->privacy) {
+	    !priv->sec_info.wpa2_enabled &&
+	    ((!bss_desc->bcn_wpa_ie) ||
+	     ((*(bss_desc->bcn_wpa_ie)).vend_hdr.element_id != WLAN_EID_WPA)) &&
+	    ((!bss_desc->bcn_rsn_ie) ||
+	     ((*(bss_desc->bcn_rsn_ie)).ieee_hdr.element_id != WLAN_EID_RSN)) &&
+	    priv->sec_info.encryption_mode && bss_desc->privacy) {
 		dev_dbg(priv->adapter->dev, "info: %s: dynamic "
 			"WEP: wpa_ie=%#x wpa2_ie=%#x "
 			"EncMode=%#x privacy=%#x\n",
@@ -373,8 +374,9 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv,
 	bss_desc->disable_11n = false;
 
 	/* Don't check for compatibility if roaming */
-	if (priv->media_connected && (priv->bss_mode == NL80211_IFTYPE_STATION)
-	    && (bss_desc->bss_mode == NL80211_IFTYPE_STATION))
+	if (priv->media_connected &&
+	    (priv->bss_mode == NL80211_IFTYPE_STATION) &&
+	    (bss_desc->bss_mode == NL80211_IFTYPE_STATION))
 		return 0;
 
 	if (priv->wps.session_enable) {
@@ -383,32 +385,30 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv,
 		return 0;
 	}
 
-	if (mwifiex_is_network_compatible_for_wapi(priv, bss_desc)) {
+	if (mwifiex_is_bss_wapi(priv, bss_desc)) {
 		dev_dbg(adapter->dev, "info: return success for WAPI AP\n");
 		return 0;
 	}
 
 	if (bss_desc->bss_mode == mode) {
-		if (mwifiex_is_network_compatible_for_no_sec(priv, bss_desc)) {
+		if (mwifiex_is_bss_no_sec(priv, bss_desc)) {
 			/* No security */
 			return 0;
-		} else if (mwifiex_is_network_compatible_for_static_wep(priv,
-								bss_desc)) {
+		} else if (mwifiex_is_bss_static_wep(priv, bss_desc)) {
 			/* Static WEP enabled */
 			dev_dbg(adapter->dev, "info: Disable 11n in WEP mode.\n");
 			bss_desc->disable_11n = true;
 			return 0;
-		} else if (mwifiex_is_network_compatible_for_wpa(priv,
-								 bss_desc)) {
+		} else if (mwifiex_is_bss_wpa(priv, bss_desc)) {
 			/* WPA enabled */
-			if (((priv->adapter->config_bands & BAND_GN
-			      || priv->adapter->config_bands & BAND_AN)
-			      && bss_desc->bcn_ht_cap)
-			      && !mwifiex_is_wpa_oui_present(bss_desc,
-					CIPHER_SUITE_CCMP)) {
-
-				if (mwifiex_is_wpa_oui_present(bss_desc,
-					    CIPHER_SUITE_TKIP)) {
+			if (((priv->adapter->config_bands & BAND_GN ||
+			      priv->adapter->config_bands & BAND_AN) &&
+			     bss_desc->bcn_ht_cap) &&
+			    !mwifiex_is_wpa_oui_present(bss_desc,
+							 CIPHER_SUITE_CCMP)) {
+
+				if (mwifiex_is_wpa_oui_present
+						(bss_desc, CIPHER_SUITE_TKIP)) {
 					dev_dbg(adapter->dev,
 						"info: Disable 11n if AES "
 						"is not supported by AP\n");
@@ -418,17 +418,16 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv,
 				}
 			}
 			return 0;
-		} else if (mwifiex_is_network_compatible_for_wpa2(priv,
-							bss_desc)) {
+		} else if (mwifiex_is_bss_wpa2(priv, bss_desc)) {
 			/* WPA2 enabled */
-			if (((priv->adapter->config_bands & BAND_GN
-			      || priv->adapter->config_bands & BAND_AN)
-			      && bss_desc->bcn_ht_cap)
-			      && !mwifiex_is_rsn_oui_present(bss_desc,
-					CIPHER_SUITE_CCMP)) {
-
-				if (mwifiex_is_rsn_oui_present(bss_desc,
-					    CIPHER_SUITE_TKIP)) {
+			if (((priv->adapter->config_bands & BAND_GN ||
+			      priv->adapter->config_bands & BAND_AN) &&
+			     bss_desc->bcn_ht_cap) &&
+			    !mwifiex_is_rsn_oui_present(bss_desc,
+							CIPHER_SUITE_CCMP)) {
+
+				if (mwifiex_is_rsn_oui_present
+						(bss_desc, CIPHER_SUITE_TKIP)) {
 					dev_dbg(adapter->dev,
 						"info: Disable 11n if AES "
 						"is not supported by AP\n");
@@ -438,31 +437,27 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv,
 				}
 			}
 			return 0;
-		} else if (mwifiex_is_network_compatible_for_adhoc_aes(priv,
-								bss_desc)) {
+		} else if (mwifiex_is_bss_adhoc_aes(priv, bss_desc)) {
 			/* Ad-hoc AES enabled */
 			return 0;
-		} else if (mwifiex_is_network_compatible_for_dynamic_wep(priv,
-							bss_desc)) {
+		} else if (mwifiex_is_bss_dynamic_wep(priv, bss_desc)) {
 			/* Dynamic WEP enabled */
 			return 0;
 		}
 
 		/* Security doesn't match */
 		dev_dbg(adapter->dev, "info: %s: failed: "
-		       "wpa_ie=%#x wpa2_ie=%#x WEP=%s WPA=%s WPA2=%s EncMode"
-		       "=%#x privacy=%#x\n",
-		       __func__,
-		       (bss_desc->bcn_wpa_ie) ?
-		       (*(bss_desc->bcn_wpa_ie)).vend_hdr.
-		       element_id : 0,
-		       (bss_desc->bcn_rsn_ie) ?
-		       (*(bss_desc->bcn_rsn_ie)).ieee_hdr.
-		       element_id : 0,
-		       (priv->sec_info.wep_enabled) ? "e" : "d",
-		       (priv->sec_info.wpa_enabled) ? "e" : "d",
-		       (priv->sec_info.wpa2_enabled) ? "e" : "d",
-		       priv->sec_info.encryption_mode, bss_desc->privacy);
+			"wpa_ie=%#x wpa2_ie=%#x WEP=%s WPA=%s WPA2=%s EncMode"
+			"=%#x privacy=%#x\n",
+			__func__,
+			(bss_desc->bcn_wpa_ie) ?
+			(*(bss_desc->bcn_wpa_ie)).vend_hdr.element_id : 0,
+			(bss_desc->bcn_rsn_ie) ?
+			(*(bss_desc->bcn_rsn_ie)).ieee_hdr.element_id : 0,
+			(priv->sec_info.wep_enabled) ? "e" : "d",
+			(priv->sec_info.wpa_enabled) ? "e" : "d",
+			(priv->sec_info.wpa2_enabled) ? "e" : "d",
+			priv->sec_info.encryption_mode, bss_desc->privacy);
 		return -1;
 	}
 
@@ -479,11 +474,11 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv,
  */
 static void
 mwifiex_scan_create_channel_list(struct mwifiex_private *priv,
-				const struct mwifiex_user_scan_cfg
-				*user_scan_in,
-				struct mwifiex_chan_scan_param_set
-				*scan_chan_list,
-				u8 filtered_scan)
+				 const struct mwifiex_user_scan_cfg
+							*user_scan_in,
+				 struct mwifiex_chan_scan_param_set
+							*scan_chan_list,
+				 u8 filtered_scan)
 {
 	enum ieee80211_band band;
 	struct ieee80211_supported_band *sband;
@@ -505,7 +500,7 @@ mwifiex_scan_create_channel_list(struct mwifiex_private *priv,
 			scan_chan_list[chan_idx].radio_type = band;
 
 			if (user_scan_in &&
-				user_scan_in->chan_list[0].scan_time)
+			    user_scan_in->chan_list[0].scan_time)
 				scan_chan_list[chan_idx].max_scan_time =
 					cpu_to_le16((u16) user_scan_in->
 					chan_list[0].scan_time);
@@ -594,19 +589,19 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
 		 *   - done_early is set (controlling individual scanning of
 		 *     1,6,11)
 		 */
-		while (tlv_idx < max_chan_per_scan
-		       && tmp_chan_list->chan_number && !done_early) {
+		while (tlv_idx < max_chan_per_scan &&
+		       tmp_chan_list->chan_number && !done_early) {
 
 			dev_dbg(priv->adapter->dev,
 				"info: Scan: Chan(%3d), Radio(%d),"
 				" Mode(%d, %d), Dur(%d)\n",
-			       tmp_chan_list->chan_number,
-			       tmp_chan_list->radio_type,
-			       tmp_chan_list->chan_scan_mode_bitmap
-			       & MWIFIEX_PASSIVE_SCAN,
-			       (tmp_chan_list->chan_scan_mode_bitmap
-			       & MWIFIEX_DISABLE_CHAN_FILT) >> 1,
-			       le16_to_cpu(tmp_chan_list->max_scan_time));
+				tmp_chan_list->chan_number,
+				tmp_chan_list->radio_type,
+				tmp_chan_list->chan_scan_mode_bitmap
+				& MWIFIEX_PASSIVE_SCAN,
+				(tmp_chan_list->chan_scan_mode_bitmap
+				 & MWIFIEX_DISABLE_CHAN_FILT) >> 1,
+				le16_to_cpu(tmp_chan_list->max_scan_time));
 
 			/* Copy the current channel TLV to the command being
 			   prepared */
@@ -648,9 +643,10 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
 			/* Stop the loop if the *current* channel is in the
 			   1,6,11 set and we are not filtering on a BSSID
 			   or SSID. */
-			if (!filtered_scan && (tmp_chan_list->chan_number == 1
-				|| tmp_chan_list->chan_number == 6
-				|| tmp_chan_list->chan_number == 11))
+			if (!filtered_scan &&
+			    (tmp_chan_list->chan_number == 1 ||
+			     tmp_chan_list->chan_number == 6 ||
+			     tmp_chan_list->chan_number == 11))
 				done_early = true;
 
 			/* Increment the tmp pointer to the next channel to
@@ -660,9 +656,10 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
 			/* Stop the loop if the *next* channel is in the 1,6,11
 			   set.  This will cause it to be the only channel
 			   scanned on the next interation */
-			if (!filtered_scan && (tmp_chan_list->chan_number == 1
-				|| tmp_chan_list->chan_number == 6
-				|| tmp_chan_list->chan_number == 11))
+			if (!filtered_scan &&
+			    (tmp_chan_list->chan_number == 1 ||
+			     tmp_chan_list->chan_number == 6 ||
+			     tmp_chan_list->chan_number == 11))
 				done_early = true;
 		}
 
@@ -714,15 +711,13 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
  * If the number of probes is not set, adapter default setting is used.
  */
 static void
-mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
-			       const struct mwifiex_user_scan_cfg *user_scan_in,
-			       struct mwifiex_scan_cmd_config *scan_cfg_out,
-			       struct mwifiex_ie_types_chan_list_param_set
-			       **chan_list_out,
-			       struct mwifiex_chan_scan_param_set
-			       *scan_chan_list,
-			       u8 *max_chan_per_scan, u8 *filtered_scan,
-			       u8 *scan_current_only)
+mwifiex_config_scan(struct mwifiex_private *priv,
+		    const struct mwifiex_user_scan_cfg *user_scan_in,
+		    struct mwifiex_scan_cmd_config *scan_cfg_out,
+		    struct mwifiex_ie_types_chan_list_param_set **chan_list_out,
+		    struct mwifiex_chan_scan_param_set *scan_chan_list,
+		    u8 *max_chan_per_scan, u8 *filtered_scan,
+		    u8 *scan_current_only)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct mwifiex_ie_types_num_probes *num_probes_tlv;
@@ -840,9 +835,9 @@ mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
 		 *  truncate scan results.  That is not an issue with an SSID
 		 *  or BSSID filter applied to the scan results in the firmware.
 		 */
-		if ((i && ssid_filter)
-		    || memcmp(scan_cfg_out->specific_bssid, &zero_mac,
-			      sizeof(zero_mac)))
+		if ((i && ssid_filter) ||
+		    memcmp(scan_cfg_out->specific_bssid, &zero_mac,
+			   sizeof(zero_mac)))
 			*filtered_scan = true;
 	} else {
 		scan_cfg_out->bss_mode = (u8) adapter->scan_mode;
@@ -863,7 +858,7 @@ mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
 	if (num_probes) {
 
 		dev_dbg(adapter->dev, "info: scan: num_probes = %d\n",
-						num_probes);
+			num_probes);
 
 		num_probes_tlv = (struct mwifiex_ie_types_num_probes *) tlv_pos;
 		num_probes_tlv->header.type = cpu_to_le16(TLV_TYPE_NUMPROBES);
@@ -889,9 +884,9 @@ mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
 
 	dev_dbg(adapter->dev, "info: SCAN_CMD: Rates size = %d\n", rates_size);
 
-	if (ISSUPP_11NENABLED(priv->adapter->fw_cap_info)
-	    && (priv->adapter->config_bands & BAND_GN
-		|| priv->adapter->config_bands & BAND_AN)) {
+	if (ISSUPP_11NENABLED(priv->adapter->fw_cap_info) &&
+	    (priv->adapter->config_bands & BAND_GN ||
+	     priv->adapter->config_bands & BAND_AN)) {
 		ht_cap = (struct mwifiex_ie_types_htcap *) tlv_pos;
 		memset(ht_cap, 0, sizeof(struct mwifiex_ie_types_htcap));
 		ht_cap->header.type = cpu_to_le16(WLAN_EID_HT_CAPABILITY);
@@ -920,8 +915,8 @@ mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
 		dev_dbg(adapter->dev, "info: Scan: Using supplied channel list\n");
 
 		for (chan_idx = 0;
-		     chan_idx < MWIFIEX_USER_SCAN_CHAN_MAX
-		     && user_scan_in->chan_list[chan_idx].chan_number;
+		     chan_idx < MWIFIEX_USER_SCAN_CHAN_MAX &&
+		     user_scan_in->chan_list[chan_idx].chan_number;
 		     chan_idx++) {
 
 			channel = user_scan_in->chan_list[chan_idx].chan_number;
@@ -961,9 +956,9 @@ mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
 		}
 
 		/* Check if we are only scanning the current channel */
-		if ((chan_idx == 1)
-		    && (user_scan_in->chan_list[0].chan_number
-			== priv->curr_bss_params.bss_descriptor.channel)) {
+		if ((chan_idx == 1) &&
+		    (user_scan_in->chan_list[0].chan_number ==
+		     priv->curr_bss_params.bss_descriptor.channel)) {
 			*scan_current_only = true;
 			dev_dbg(adapter->dev,
 				"info: Scan: Scanning current channel only\n");
@@ -971,7 +966,7 @@ mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
 
 	} else {
 		dev_dbg(adapter->dev,
-				"info: Scan: Creating full region channel list\n");
+			"info: Scan: Creating full region channel list\n");
 		mwifiex_scan_create_channel_list(priv, user_scan_in,
 						 scan_chan_list,
 						 *filtered_scan);
@@ -1003,7 +998,7 @@ mwifiex_ret_802_11_scan_get_tlv_ptrs(struct mwifiex_adapter *adapter,
 	*tlv_data = NULL;
 
 	dev_dbg(adapter->dev, "info: SCAN_RESP: tlv_buf_size = %d\n",
-						tlv_buf_size);
+		tlv_buf_size);
 
 	while (tlv_buf_left >= sizeof(struct mwifiex_ie_types_header)) {
 
@@ -1101,7 +1096,7 @@ mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 			memcpy(bss_entry->ssid.ssid, (current_ptr + 2),
 			       element_len);
 			dev_dbg(adapter->dev, "info: InterpretIE: ssid: "
-					      "%-32s\n", bss_entry->ssid.ssid);
+				"%-32s\n", bss_entry->ssid.ssid);
 			break;
 
 		case WLAN_EID_SUPP_RATES:
@@ -1189,13 +1184,13 @@ mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 				bss_entry->bcn_wpa_ie =
 					(struct ieee_types_vendor_specific *)
 					current_ptr;
-				bss_entry->wpa_offset = (u16) (current_ptr -
-							bss_entry->beacon_buf);
+				bss_entry->wpa_offset = (u16)
+					(current_ptr - bss_entry->beacon_buf);
 			} else if (!memcmp(vendor_ie->vend_hdr.oui, wmm_oui,
 				    sizeof(wmm_oui))) {
 				if (total_ie_len ==
-				    sizeof(struct ieee_types_wmm_parameter)
-				    || total_ie_len ==
+				    sizeof(struct ieee_types_wmm_parameter) ||
+				    total_ie_len ==
 				    sizeof(struct ieee_types_wmm_info))
 					/*
 					 * Only accept and copy the WMM IE if
@@ -1316,14 +1311,14 @@ static int mwifiex_scan_networks(struct mwifiex_private *priv,
 	}
 
 	scan_cfg_out = kzalloc(sizeof(union mwifiex_scan_cmd_config_tlv),
-					GFP_KERNEL);
+								GFP_KERNEL);
 	if (!scan_cfg_out) {
 		dev_err(adapter->dev, "failed to alloc scan_cfg_out\n");
 		return -ENOMEM;
 	}
 
 	buf_size = sizeof(struct mwifiex_chan_scan_param_set) *
-			MWIFIEX_USER_SCAN_CHAN_MAX;
+						MWIFIEX_USER_SCAN_CHAN_MAX;
 	scan_chan_list = kzalloc(buf_size, GFP_KERNEL);
 	if (!scan_chan_list) {
 		dev_err(adapter->dev, "failed to alloc scan_chan_list\n");
@@ -1331,10 +1326,9 @@ static int mwifiex_scan_networks(struct mwifiex_private *priv,
 		return -ENOMEM;
 	}
 
-	mwifiex_scan_setup_scan_config(priv, user_scan_in,
-				       &scan_cfg_out->config, &chan_list_out,
-				       scan_chan_list, &max_chan_per_scan,
-				       &filtered_scan, &scan_current_chan_only);
+	mwifiex_config_scan(priv, user_scan_in, &scan_cfg_out->config,
+			    &chan_list_out, scan_chan_list, &max_chan_per_scan,
+			    &filtered_scan, &scan_current_chan_only);
 
 	ret = mwifiex_scan_channel_list(priv, max_chan_per_scan, filtered_scan,
 					&scan_cfg_out->config, chan_list_out,
@@ -1345,10 +1339,10 @@ static int mwifiex_scan_networks(struct mwifiex_private *priv,
 		spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
 		if (!list_empty(&adapter->scan_pending_q)) {
 			cmd_node = list_first_entry(&adapter->scan_pending_q,
-						struct cmd_ctrl_node, list);
+						    struct cmd_ctrl_node, list);
 			list_del(&cmd_node->list);
 			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
-									flags);
+					       flags);
 			adapter->cmd_queued = cmd_node;
 			mwifiex_insert_cmd_to_pending_q(adapter, cmd_node,
 							true);
@@ -1514,7 +1508,7 @@ mwifiex_update_curr_bss_params(struct mwifiex_private *priv, u8 *bssid,
 
 	/* Make a copy of current BSSID descriptor */
 	memcpy(&priv->curr_bss_params.bss_descriptor, bss_desc,
-		sizeof(priv->curr_bss_params.bss_descriptor));
+	       sizeof(priv->curr_bss_params.bss_descriptor));
 	mwifiex_save_curr_bcn(priv);
 	spin_unlock_irqrestore(&priv->curr_bcn_buf_lock, flags);
 
@@ -1565,7 +1559,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 	struct cfg80211_bss *bss;
 
 	is_bgscan_resp = (le16_to_cpu(resp->command)
-		== HostCmd_CMD_802_11_BG_SCAN_QUERY);
+			  == HostCmd_CMD_802_11_BG_SCAN_QUERY);
 	if (is_bgscan_resp)
 		scan_rsp = &resp->params.bg_scan_query_resp.scan_resp;
 	else
@@ -1574,20 +1568,20 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 
 	if (scan_rsp->number_of_sets > MWIFIEX_MAX_AP) {
 		dev_err(adapter->dev, "SCAN_RESP: too many AP returned (%d)\n",
-		       scan_rsp->number_of_sets);
+			scan_rsp->number_of_sets);
 		ret = -1;
 		goto done;
 	}
 
 	bytes_left = le16_to_cpu(scan_rsp->bss_descript_size);
 	dev_dbg(adapter->dev, "info: SCAN_RESP: bss_descript_size %d\n",
-						bytes_left);
+		bytes_left);
 
 	scan_resp_size = le16_to_cpu(resp->size);
 
 	dev_dbg(adapter->dev,
 		"info: SCAN_RESP: returned %d APs before parsing\n",
-	       scan_rsp->number_of_sets);
+		scan_rsp->number_of_sets);
 
 	bss_info = scan_rsp->bss_desc_and_tlv_buffer;
 
@@ -1674,19 +1668,19 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 
 		rssi = (s32) (bcn_param->rssi);
 		dev_dbg(adapter->dev, "info: InterpretIE: RSSI=%02X\n",
-					rssi);
+			rssi);
 
 		beacon_period = le16_to_cpu(bcn_param->beacon_period);
 
 		cap_info_bitmap = le16_to_cpu(bcn_param->cap_info_bitmap);
 		dev_dbg(adapter->dev, "info: InterpretIE: capabilities=0x%X\n",
-				cap_info_bitmap);
+			cap_info_bitmap);
 
 		/* Rest of the current buffer are IE's */
 		ie_buf = current_ptr;
 		ie_len = curr_bcn_bytes;
 		dev_dbg(adapter->dev, "info: InterpretIE: IELength for this AP"
-				      " = %d\n", curr_bcn_bytes);
+			" = %d\n", curr_bcn_bytes);
 
 		while (curr_bcn_bytes >= sizeof(struct ieee_types_header)) {
 			u8 element_id, element_len;
@@ -1720,8 +1714,8 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 		 */
 		if (tsf_tlv)
 			memcpy(&network_tsf,
-					&tsf_tlv->tsf_data[idx * TSF_DATA_SIZE],
-					sizeof(network_tsf));
+			       &tsf_tlv->tsf_data[idx * TSF_DATA_SIZE],
+			       sizeof(network_tsf));
 
 		if (channel) {
 			struct ieee80211_channel *chan;
@@ -1750,13 +1744,15 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 				*(u8 *)bss->priv = band;
 				cfg80211_put_bss(bss);
 
-				if (priv->media_connected && !memcmp(bssid,
-					priv->curr_bss_params.bss_descriptor
-						     .mac_address, ETH_ALEN))
-					mwifiex_update_curr_bss_params(priv,
-							bssid, rssi, ie_buf,
-							ie_len, beacon_period,
-							cap_info_bitmap, band);
+				if (priv->media_connected &&
+				    !memcmp(bssid,
+					    priv->curr_bss_params.bss_descriptor
+					    .mac_address, ETH_ALEN))
+					mwifiex_update_curr_bss_params
+							(priv, bssid, rssi,
+							 ie_buf, ie_len,
+							 beacon_period,
+							 cap_info_bitmap, band);
 			}
 		} else {
 			dev_dbg(adapter->dev, "missing BSS channel IE\n");
@@ -1900,7 +1896,7 @@ int mwifiex_request_scan(struct mwifiex_private *priv,
 
 	if (down_interruptible(&priv->async_sem)) {
 		dev_err(priv->adapter->dev, "%s: acquire semaphore\n",
-						__func__);
+			__func__);
 		return -1;
 	}
 	priv->scan_pending_on_block = true;
@@ -1985,21 +1981,21 @@ mwifiex_save_curr_bcn(struct mwifiex_private *priv)
 
 	/* allocate beacon buffer at 1st time; or if it's size has changed */
 	if (!priv->curr_bcn_buf ||
-			priv->curr_bcn_size != curr_bss->beacon_buf_size) {
+	    priv->curr_bcn_size != curr_bss->beacon_buf_size) {
 		priv->curr_bcn_size = curr_bss->beacon_buf_size;
 
 		kfree(priv->curr_bcn_buf);
 		priv->curr_bcn_buf = kmalloc(curr_bss->beacon_buf_size,
-						GFP_ATOMIC);
+					     GFP_ATOMIC);
 		if (!priv->curr_bcn_buf) {
 			dev_err(priv->adapter->dev,
-					"failed to alloc curr_bcn_buf\n");
+				"failed to alloc curr_bcn_buf\n");
 			return;
 		}
 	}
 
 	memcpy(priv->curr_bcn_buf, curr_bss->beacon_buf,
-		curr_bss->beacon_buf_size);
+	       curr_bss->beacon_buf_size);
 	dev_dbg(priv->adapter->dev, "info: current beacon saved %d\n",
 		priv->curr_bcn_size);
 
-- 
1.7.0.2

