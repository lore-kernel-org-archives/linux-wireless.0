Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:32946 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab0LGVnL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 16:43:11 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/2 v2] mwifiex: remove some element ID's definitions
Date: Tue,  7 Dec 2010 13:43:04 -0800
Message-Id: <1291758184-649-2-git-send-email-bzhao@marvell.com>
In-Reply-To: <1291758184-649-1-git-send-email-bzhao@marvell.com>
References: <1291758184-649-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Those are already defined in include/linux/ieee80211.h
under "enum ieee80211_eid".

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c         |    9 ++--
 drivers/net/wireless/mwifiex/cfg80211.c    |   20 +++----
 drivers/net/wireless/mwifiex/fw.h          |   10 +---
 drivers/net/wireless/mwifiex/ieee.h        |   29 ----------
 drivers/net/wireless/mwifiex/join.c        |   22 ++++----
 drivers/net/wireless/mwifiex/scan.c        |   80 ++++++++++++++-------------
 drivers/net/wireless/mwifiex/sta_cmd.c     |    4 +-
 drivers/net/wireless/mwifiex/sta_cmdresp.c |    4 +-
 drivers/net/wireless/mwifiex/sta_event.c   |    2 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c   |   16 +++---
 drivers/net/wireless/mwifiex/wmm.c         |   12 +++--
 11 files changed, 88 insertions(+), 120 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 00ab56c..d1494bf 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -829,7 +829,7 @@ mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 	if (bss_desc->bcn_ht_cap) {
 		ht_cap = (struct mwifiex_ie_types_htcap *) *buffer;
 		memset(ht_cap, 0, sizeof(struct mwifiex_ie_types_htcap));
-		ht_cap->header.type = cpu_to_le16(HT_CAPABILITY);
+		ht_cap->header.type = cpu_to_le16(WLAN_EID_HT_CAPABILITY);
 		ht_cap->header.len = cpu_to_le16(sizeof(struct ieee_htcap));
 		memcpy((u8 *) ht_cap + sizeof(struct mwifiex_ie_types_header),
 		       (u8 *) bss_desc->bcn_ht_cap +
@@ -849,7 +849,8 @@ mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 			ht_info = (struct mwifiex_ie_types_htinfo *) *buffer;
 			memset(ht_info, 0,
 			       sizeof(struct mwifiex_ie_types_htinfo));
-			ht_info->header.type = cpu_to_le16(HT_OPERATION);
+			ht_info->header.type =
+					cpu_to_le16(WLAN_EID_HT_INFORMATION);
 			ht_info->header.len =
 				cpu_to_le16(sizeof(struct ieee_htinfo));
 
@@ -904,7 +905,7 @@ mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 		bss_co_2040 = (struct mwifiex_ie_types_2040bssco *) *buffer;
 		memset(bss_co_2040, 0,
 		       sizeof(struct mwifiex_ie_types_2040bssco));
-		bss_co_2040->header.type = cpu_to_le16(BSSCO_2040);
+		bss_co_2040->header.type = cpu_to_le16(WLAN_EID_BSS_COEX_2040);
 		bss_co_2040->header.len =
 		       cpu_to_le16(sizeof(struct ieee_bssco_2040));
 
@@ -923,7 +924,7 @@ mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 	if (bss_desc->bcn_ext_cap) {
 		ext_cap = (struct mwifiex_ie_types_extcap *) *buffer;
 		memset(ext_cap, 0, sizeof(struct mwifiex_ie_types_extcap));
-		ext_cap->header.type = cpu_to_le16(EXT_CAPABILITY);
+		ext_cap->header.type = cpu_to_le16(WLAN_EID_EXT_CAPABILITY);
 		ext_cap->header.len = cpu_to_le16(sizeof(struct ieee_extcap));
 
 		memcpy((u8 *) ext_cap +
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index d3b2b3e..4a42493 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1254,7 +1254,7 @@ mwifiex_inform_bss_from_scan_result(struct mwifiex_private *priv,
 	u8 *cap;
 	u8 *beacon;
 	int beacon_size;
-	enum ieee_types_elementid_e element_id;
+	u8 element_id;
 	u8 element_len;
 
 	ENTER();
@@ -1322,10 +1322,8 @@ mwifiex_inform_bss_from_scan_result(struct mwifiex_private *priv,
 
 		while (beacon_size >= sizeof(struct ieee_types_header)) {
 			ie = ie_buf + ie_len;
-			element_id =
-				(enum ieee_types_elementid_e) (*(u8 *)
-							       beacon);
-			element_len = *((u8 *) beacon + 1);
+			element_id = *beacon;
+			element_len = *(beacon + 1);
 			if (beacon_size <
 			    (int) element_len +
 			    sizeof(struct ieee_types_header)) {
@@ -1335,12 +1333,12 @@ mwifiex_inform_bss_from_scan_result(struct mwifiex_private *priv,
 				break;
 			}
 			switch (element_id) {
-			case EXT_CAPABILITY:
-			case DS_PARAM_SET:
-			case HT_CAPABILITY:
-			case VENDOR_SPECIFIC_221:
-			case RSN_IE:
-			case WAPI_IE:
+			case WLAN_EID_EXT_CAPABILITY:
+			case WLAN_EID_DS_PARAMS:
+			case WLAN_EID_HT_CAPABILITY:
+			case WLAN_EID_VENDOR_SPECIFIC:
+			case WLAN_EID_RSN:
+			case WLAN_EID_BSS_AC_ACCESS_DELAY:
 				ie[0] = element_id;
 				ie[1] = element_len;
 				tmp = (u8 *) beacon;
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index bafeafb..ed691ac 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -134,14 +134,6 @@ enum MWIFIEX_802_11_WEP_STATUS {
 #define CAL_SNR(RSSI, NF)		((s16)((s16)(RSSI)-(s16)(NF)))
 
 #define PROPRIETARY_TLV_BASE_ID                 0x0100
-#define TLV_TYPE_SSID                           0x0000
-#define TLV_TYPE_RATES                          0x0001
-#define TLV_TYPE_PHY_FH                         0x0002
-#define TLV_TYPE_PHY_DS                         0x0003
-#define TLV_TYPE_CF                             0x0004
-#define TLV_TYPE_IBSS                           0x0006
-#define TLV_TYPE_DOMAIN                         0x0007
-
 #define TLV_TYPE_KEY_MATERIAL       (PROPRIETARY_TLV_BASE_ID + 0)
 #define TLV_TYPE_CHANLIST           (PROPRIETARY_TLV_BASE_ID + 1)
 #define TLV_TYPE_NUMPROBES          (PROPRIETARY_TLV_BASE_ID + 2)
@@ -1006,7 +998,7 @@ struct mwifiex_scan_cmd_config {
 	 *  SSID TLV(s) and ChanList TLVs to be sent in the firmware command
 	 *
 	 *  TLV_TYPE_CHANLIST, mwifiex_ie_types_chan_list_param_set
-	 *  TLV_TYPE_SSID, mwifiex_ie_types_ssid_param_set
+	 *  WLAN_EID_SSID, mwifiex_ie_types_ssid_param_set
 	 */
 	u8 tlv_buf[1];	/* SSID TLV(s) and ChanList TLVs are stored
 				   here */
diff --git a/drivers/net/wireless/mwifiex/ieee.h b/drivers/net/wireless/mwifiex/ieee.h
index 21e4fc2..ed9e03d 100644
--- a/drivers/net/wireless/mwifiex/ieee.h
+++ b/drivers/net/wireless/mwifiex/ieee.h
@@ -32,35 +32,6 @@ enum MWIFIEX_802_11_NETWORK_TYPE {
 
 #define IEEE_MAX_IE_SIZE			256
 
-enum ieee_types_elementid_e {
-	SSID = 0,
-	SUPPORTED_RATES = 1,
-	FH_PARAM_SET = 2,
-	DS_PARAM_SET = 3,
-	CF_PARAM_SET = 4,
-
-	IBSS_PARAM_SET = 6,
-
-	HT_CAPABILITY = 45,
-	HT_OPERATION = 61,
-	BSSCO_2040 = 72,
-	OVERLAP_BSS_SCAN_PARAM = 74,
-	EXT_CAPABILITY = 127,
-
-	ERP_INFO = 42,
-
-	EXTENDED_SUPPORTED_RATES = 50,
-
-	VENDOR_SPECIFIC_221 = 221,
-	WMM_IE = VENDOR_SPECIFIC_221,
-
-	WPS_IE = VENDOR_SPECIFIC_221,
-	WPA_IE = VENDOR_SPECIFIC_221,
-	RSN_IE = 48,
-	VS_IE = VENDOR_SPECIFIC_221,
-	WAPI_IE = 68,
-} __attribute__ ((packed));
-
 struct ieee_types_header {
 	u8 element_id;
 	u8 len;
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index aa26105..917f368 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -387,14 +387,14 @@ mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 	pos += sizeof(assoc->dtim_period);
 
 	ssid_tlv = (struct mwifiex_ie_types_ssid_param_set *) pos;
-	ssid_tlv->header.type = cpu_to_le16(TLV_TYPE_SSID);
+	ssid_tlv->header.type = cpu_to_le16(WLAN_EID_SSID);
 	ssid_tlv->header.len = cpu_to_le16((u16) bss_desc->ssid.ssid_len);
 	memcpy(ssid_tlv->ssid, bss_desc->ssid.ssid,
 		le16_to_cpu(ssid_tlv->header.len));
 	pos += sizeof(ssid_tlv->header) + le16_to_cpu(ssid_tlv->header.len);
 
 	phy_tlv = (struct mwifiex_ie_types_phy_param_set *) pos;
-	phy_tlv->header.type = cpu_to_le16(TLV_TYPE_PHY_DS);
+	phy_tlv->header.type = cpu_to_le16(WLAN_EID_DS_PARAMS);
 	phy_tlv->header.len = cpu_to_le16(sizeof(phy_tlv->fh_ds.ds_param_set));
 	memcpy(&phy_tlv->fh_ds.ds_param_set,
 	       &bss_desc->phy_param_set.ds_param_set.current_chan,
@@ -402,7 +402,7 @@ mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 	pos += sizeof(phy_tlv->header) + le16_to_cpu(phy_tlv->header.len);
 
 	ss_tlv = (struct mwifiex_ie_types_ss_param_set *) pos;
-	ss_tlv->header.type = cpu_to_le16(TLV_TYPE_CF);
+	ss_tlv->header.type = cpu_to_le16(WLAN_EID_CF_PARAMS);
 	ss_tlv->header.len = cpu_to_le16(sizeof(ss_tlv->cf_ibss.cf_param_set));
 	pos += sizeof(ss_tlv->header) + le16_to_cpu(ss_tlv->header.len);
 
@@ -419,7 +419,7 @@ mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 
 	/* Setup the Rates TLV in the association command */
 	rates_tlv = (struct mwifiex_ie_types_rates_param_set *) pos;
-	rates_tlv->header.type = cpu_to_le16(TLV_TYPE_RATES);
+	rates_tlv->header.type = cpu_to_le16(WLAN_EID_SUPP_RATES);
 	rates_tlv->header.len = cpu_to_le16((u16) rates_size);
 	memcpy(rates_tlv->rates, rates, rates_size);
 	pos += sizeof(rates_tlv->header) + rates_size;
@@ -477,7 +477,6 @@ mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 					priv->sec_info.wpa2_enabled)) {
 			rsn_ie_tlv =
 				(struct mwifiex_ie_types_rsn_param_set *) pos;
-			/* WPA_IE or WPA2_IE */
 			rsn_ie_tlv->header.type =
 				cpu_to_le16((u16) priv->wpa_ie[0]);
 			rsn_ie_tlv->header.type =
@@ -748,14 +747,15 @@ mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 	 */
 	mwifiex_update_tsf_timestamps(priv, bss_desc);
 
-	if (bss_desc->wmm_ie.vend_hdr.element_id == WMM_IE)
+	if (bss_desc->wmm_ie.vend_hdr.element_id == WLAN_EID_VENDOR_SPECIFIC)
 		priv->curr_bss_params.wmm_enabled = true;
 	else
 		priv->curr_bss_params.wmm_enabled = false;
 
 	if ((priv->wmm_required
 	     || (bss_desc->bcn_ht_cap &&
-		 (bss_desc->bcn_ht_cap->ieee_hdr.element_id == HT_CAPABILITY))
+		 (bss_desc->bcn_ht_cap->ieee_hdr.element_id ==
+			WLAN_EID_HT_CAPABILITY))
 	    ) && priv->curr_bss_params.wmm_enabled)
 		priv->wmm_enabled = true;
 	else
@@ -1093,7 +1093,6 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 
 	if (priv->sec_info.wpa_enabled || priv->sec_info.ewpa_enabled) {
 		rsn_ie_tlv = (struct mwifiex_ie_types_rsn_param_set *) pos;
-			/* WPA_IE or  WPA2_IE */
 		rsn_ie_tlv->header.type = cpu_to_le16((u16) priv->wpa_ie[0]);
 		rsn_ie_tlv->header.type =
 			cpu_to_le16(le16_to_cpu(rsn_ie_tlv->header.type)
@@ -1126,7 +1125,8 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 			ht_cap = (struct mwifiex_ie_types_htcap *) pos;
 			memset(ht_cap, 0,
 			       sizeof(struct mwifiex_ie_types_htcap));
-			ht_cap->header.type = cpu_to_le16(HT_CAPABILITY);
+			ht_cap->header.type =
+				cpu_to_le16(WLAN_EID_HT_CAPABILITY);
 			ht_cap->header.len =
 			       cpu_to_le16(sizeof(struct ieee_htcap));
 			ht_cap_info = le16_to_cpu(ht_cap->ht_cap.ht_cap_info);
@@ -1152,7 +1152,8 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 			ht_info = (struct mwifiex_ie_types_htinfo *) pos;
 			memset(ht_info, 0,
 			       sizeof(struct mwifiex_ie_types_htinfo));
-			ht_info->header.type = cpu_to_le16(HT_OPERATION);
+			ht_info->header.type =
+				cpu_to_le16(WLAN_EID_HT_INFORMATION);
 			ht_info->header.len =
 				cpu_to_le16(sizeof(struct ieee_htinfo));
 			ht_info->ht_info.pri_chan =
@@ -1351,7 +1352,6 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 
 	if (priv->sec_info.wpa_enabled) {
 		rsn_ie_tlv = (struct mwifiex_ie_types_rsn_param_set *) pos;
-		/* WPA_IE or WPA2_IE */
 		rsn_ie_tlv->header.type = cpu_to_le16((u16) priv->wpa_ie[0]);
 		rsn_ie_tlv->header.type =
 			cpu_to_le16(le16_to_cpu(rsn_ie_tlv->header.type)
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index ddde627..8ed3677 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -125,7 +125,7 @@ mwifiex_is_rsn_oui_present(struct mwifiex_bssdescriptor *bss_desc, u32 cipher)
 	u8 ret = MWIFIEX_OUI_NOT_PRESENT;
 
 	if (((bss_desc->bcn_rsn_ie) && ((*(bss_desc->bcn_rsn_ie)).
-					ieee_hdr.element_id == RSN_IE))) {
+					ieee_hdr.element_id == WLAN_EID_RSN))) {
 		iebody =
 			(struct ie_body *)
 			(((u8 *) bss_desc->bcn_rsn_ie->data) +
@@ -153,7 +153,7 @@ mwifiex_is_wpa_oui_present(struct mwifiex_bssdescriptor *bss_desc, u32 cipher)
 	u8 ret = MWIFIEX_OUI_NOT_PRESENT;
 
 	if (((bss_desc->bcn_wpa_ie) && ((*(bss_desc->bcn_wpa_ie)).
-				      vend_hdr.element_id == WPA_IE))) {
+				      vend_hdr.element_id == WLAN_EID_WPA))) {
 		iebody = (struct ie_body *) bss_desc->bcn_wpa_ie->data;
 		oui = &mwifiex_wpa_oui[cipher][0];
 		ret = mwifiex_search_oui_in_ie(iebody, oui);
@@ -396,10 +396,10 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index,
 	if ((bss_desc->bss_mode == mode) && priv->sec_info.ewpa_enabled) {
 		if (((bss_desc->bcn_wpa_ie) &&
 		     ((*(bss_desc->bcn_wpa_ie)).vend_hdr.element_id ==
-		     WPA_IE)) ||
+		     WLAN_EID_WPA)) ||
 		    ((bss_desc->bcn_rsn_ie) &&
 		     ((*(bss_desc->bcn_rsn_ie)).ieee_hdr.element_id ==
-		     RSN_IE))) {
+		     WLAN_EID_RSN))) {
 			if (((priv->adapter->config_bands & BAND_GN ||
 			      priv->adapter->config_bands & BAND_AN) &&
 			     bss_desc->bcn_ht_cap)
@@ -433,7 +433,8 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index,
 
 	if (priv->sec_info.wapi_enabled &&
 	    (bss_desc->bcn_wapi_ie &&
-	     ((*(bss_desc->bcn_wapi_ie)).ieee_hdr.element_id == WAPI_IE))) {
+	     ((*(bss_desc->bcn_wapi_ie)).ieee_hdr.element_id ==
+			WLAN_EID_BSS_AC_ACCESS_DELAY))) {
 		PRINTM(MINFO, "Return success for WAPI AP\n");
 		LEAVE();
 		return index;
@@ -445,10 +446,10 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index,
 		    && !priv->sec_info.wpa2_enabled
 		    && ((!bss_desc->bcn_wpa_ie) ||
 			((*(bss_desc->bcn_wpa_ie)).vend_hdr.element_id !=
-		    WPA_IE))
+		    WLAN_EID_WPA))
 		    && ((!bss_desc->bcn_rsn_ie) ||
 			((*(bss_desc->bcn_rsn_ie)).ieee_hdr.element_id !=
-		    RSN_IE))
+		    WLAN_EID_RSN))
 		    && priv->sec_info.encryption_mode ==
 		    MWIFIEX_ENCRYPTION_MODE_NONE && !bss_desc->privacy) {
 			/* No security */
@@ -470,7 +471,7 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index,
 			   && !priv->sec_info.wpa2_enabled
 			   && ((bss_desc->bcn_wpa_ie)
 			       && ((*(bss_desc->bcn_wpa_ie)).vend_hdr.
-				   element_id == WPA_IE))
+				   element_id == WLAN_EID_WPA))
 			   /*
 			    * Privacy bit may NOT be set in some APs like
 			    * LinkSys WRT54G && bss_desc->privacy
@@ -517,7 +518,7 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index,
 			   && priv->sec_info.wpa2_enabled
 			   && ((bss_desc->bcn_rsn_ie)
 			       && ((*(bss_desc->bcn_rsn_ie)).ieee_hdr.
-				   element_id == RSN_IE))
+				   element_id == WLAN_EID_RSN))
 			   /*
 			    * Privacy bit may NOT be set in some APs like
 			    * LinkSys WRT54G && bss_desc->privacy
@@ -564,10 +565,10 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index,
 			   && !priv->sec_info.wpa2_enabled
 			   && ((!bss_desc->bcn_wpa_ie)
 			       || ((*(bss_desc->bcn_wpa_ie)).vend_hdr.
-				   element_id != WPA_IE))
+				   element_id != WLAN_EID_WPA))
 			   && ((!bss_desc->bcn_rsn_ie)
 			       || ((*(bss_desc->bcn_rsn_ie)).ieee_hdr.
-				   element_id != RSN_IE))
+				   element_id != WLAN_EID_RSN))
 			   && priv->sec_info.encryption_mode ==
 			   MWIFIEX_ENCRYPTION_MODE_NONE && bss_desc->privacy) {
 			/* Ad-hoc AES enabled */
@@ -579,10 +580,10 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index,
 			   && !priv->sec_info.wpa2_enabled
 			   && ((!bss_desc->bcn_wpa_ie)
 			       || ((*(bss_desc->bcn_wpa_ie)).vend_hdr.
-				   element_id != WPA_IE))
+				   element_id != WLAN_EID_WPA))
 			   && ((!bss_desc->bcn_rsn_ie)
 			       || ((*(bss_desc->bcn_rsn_ie)).ieee_hdr.
-				   element_id != RSN_IE))
+				   element_id != WLAN_EID_RSN))
 			   && priv->sec_info.encryption_mode !=
 			   MWIFIEX_ENCRYPTION_MODE_NONE && bss_desc->privacy) {
 			/* Dynamic WEP enabled */
@@ -1117,7 +1118,7 @@ mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
 	rates_size = mwifiex_get_supported_rates(priv, rates);
 
 	rates_tlv = (struct mwifiex_ie_types_rates_param_set *) tlv_pos;
-	rates_tlv->header.type = cpu_to_le16(TLV_TYPE_RATES);
+	rates_tlv->header.type = cpu_to_le16(WLAN_EID_SUPP_RATES);
 	rates_tlv->header.len = cpu_to_le16((u16) rates_size);
 	memcpy(rates_tlv->rates, rates, rates_size);
 	tlv_pos += sizeof(rates_tlv->header) + rates_size;
@@ -1129,7 +1130,7 @@ mwifiex_scan_setup_scan_config(struct mwifiex_private *priv,
 		|| priv->adapter->config_bands & BAND_AN)) {
 		ht_cap = (struct mwifiex_ie_types_htcap *) tlv_pos;
 		memset(ht_cap, 0, sizeof(struct mwifiex_ie_types_htcap));
-		ht_cap->header.type = cpu_to_le16(HT_CAPABILITY);
+		ht_cap->header.type = cpu_to_le16(WLAN_EID_HT_CAPABILITY);
 		ht_cap->header.len = cpu_to_le16(sizeof(struct ieee_htcap));
 		mwifiex_fill_cap_info(priv, ht_cap);
 		HEXDUMP("SCAN: HT_CAPABILITIES IE", (u8 *) ht_cap,
@@ -1328,7 +1329,7 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 				   u8 **beacon_info, u32 *bytes_left)
 {
 	enum mwifiex_status ret = MWIFIEX_STATUS_SUCCESS;
-	enum ieee_types_elementid_e element_id;
+	u8 element_id;
 	struct ieee_types_fh_param_set *fh_param_set;
 	struct ieee_types_ds_param_set *ds_param_set;
 	struct ieee_types_cf_param_set *cf_param_set;
@@ -1461,10 +1462,8 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 
 	/* Process variable IE */
 	while (bytes_left_for_current_beacon >= 2) {
-		element_id =
-			(enum
-			 ieee_types_elementid_e) (*((u8 *) current_ptr));
-		element_len = *((u8 *) current_ptr + 1);
+		element_id = *current_ptr;
+		element_len = *(current_ptr + 1);
 		total_ie_len = element_len + sizeof(struct ieee_types_header);
 
 		if (bytes_left_for_current_beacon < total_ie_len) {
@@ -1476,7 +1475,7 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 		}
 
 		switch (element_id) {
-		case SSID:
+		case WLAN_EID_SSID:
 			bss_entry->ssid.ssid_len = element_len;
 			memcpy(bss_entry->ssid.ssid, (current_ptr + 2),
 			       element_len);
@@ -1484,7 +1483,7 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 			       bss_entry->ssid.ssid);
 			break;
 
-		case SUPPORTED_RATES:
+		case WLAN_EID_SUPP_RATES:
 			memcpy(bss_entry->data_rates, current_ptr + 2,
 			       element_len);
 			memcpy(bss_entry->supported_rates, current_ptr + 2,
@@ -1495,7 +1494,7 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 			found_data_rate_ie = true;
 			break;
 
-		case FH_PARAM_SET:
+		case WLAN_EID_FH_PARAMS:
 			fh_param_set =
 				(struct ieee_types_fh_param_set *) current_ptr;
 			bss_entry->network_type_use = MWIFIEX_802_11_FH;
@@ -1504,7 +1503,7 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 			       sizeof(struct ieee_types_fh_param_set));
 			break;
 
-		case DS_PARAM_SET:
+		case WLAN_EID_DS_PARAMS:
 			ds_param_set =
 				(struct ieee_types_ds_param_set *) current_ptr;
 
@@ -1516,7 +1515,7 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 			       sizeof(struct ieee_types_ds_param_set));
 			break;
 
-		case CF_PARAM_SET:
+		case WLAN_EID_CF_PARAMS:
 			cf_param_set =
 				(struct ieee_types_cf_param_set *) current_ptr;
 			memcpy(&bss_entry->ss_param_set.cf_param_set,
@@ -1524,7 +1523,7 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 			       sizeof(struct ieee_types_cf_param_set));
 			break;
 
-		case IBSS_PARAM_SET:
+		case WLAN_EID_IBSS_PARAMS:
 			ibss_param_set =
 				(struct ieee_types_ibss_param_set *)
 				current_ptr;
@@ -1533,12 +1532,12 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 			       sizeof(struct ieee_types_ibss_param_set));
 			break;
 
-		case ERP_INFO:
+		case WLAN_EID_ERP_INFO:
 			erp_info = (struct ieee_types_erp_info *) current_ptr;
 			bss_entry->erp_flags = erp_info->erp_flags;
 			break;
 
-		case EXTENDED_SUPPORTED_RATES:
+		case WLAN_EID_EXT_SUPP_RATES:
 			/*
 			 * Only process extended supported rate
 			 * if data rate is already found.
@@ -1568,7 +1567,7 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 				element_len + rate_size);
 			break;
 
-		case VENDOR_SPECIFIC_221:
+		case WLAN_EID_VENDOR_SPECIFIC:
 			vendor_ie =
 				(struct ieee_types_vendor_specific *)
 				current_ptr;
@@ -1582,7 +1581,7 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 				bss_entry->wpa_offset =
 					(u16) (current_ptr -
 						 bss_entry->beacon_buf);
-				HEXDUMP("InterpretIE: Resp WPA_IE",
+				HEXDUMP("InterpretIE: Resp WLAN_EID_WPA",
 					(u8 *) bss_entry->bcn_wpa_ie,
 					((*(bss_entry->bcn_wpa_ie))
 					.vend_hdr.len +
@@ -1608,29 +1607,30 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 				}
 			}
 			break;
-		case RSN_IE:
+		case WLAN_EID_RSN:
 			bss_entry->bcn_rsn_ie =
 				(struct ieee_types_generic *) current_ptr;
 			bss_entry->rsn_offset =
 				(u16) (current_ptr -
 					 bss_entry->beacon_buf);
-			HEXDUMP("InterpretIE: Resp RSN_IE",
+			HEXDUMP("InterpretIE: Resp WLAN_EID_RSN",
 				(u8 *) bss_entry->bcn_rsn_ie,
 				(*(bss_entry->bcn_rsn_ie)).ieee_hdr.len +
 				sizeof(struct ieee_types_header));
 			break;
-		case WAPI_IE:
+		case WLAN_EID_BSS_AC_ACCESS_DELAY:
 			bss_entry->bcn_wapi_ie =
 				(struct ieee_types_generic *) current_ptr;
 			bss_entry->wapi_offset =
 				(u16) (current_ptr -
 					 bss_entry->beacon_buf);
-			HEXDUMP("InterpretIE: Resp WAPI_IE",
+			HEXDUMP("InterpretIE: "
+				"Resp WLAN_EID_BSS_AC_ACCESS_DELAY",
 				(u8 *) bss_entry->bcn_wapi_ie,
 				(*(bss_entry->bcn_wapi_ie)).ieee_hdr.len +
 				sizeof(struct ieee_types_header));
 			break;
-		case HT_CAPABILITY:
+		case WLAN_EID_HT_CAPABILITY:
 			bss_entry->bcn_ht_cap =
 				(struct ieee_types_htcap *) current_ptr;
 			bss_entry->ht_cap_offset =
@@ -1641,7 +1641,7 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 				(*(bss_entry->bcn_ht_cap)).ieee_hdr.len +
 				sizeof(struct ieee_types_header));
 			break;
-		case HT_OPERATION:
+		case WLAN_EID_HT_INFORMATION:
 			bss_entry->bcn_ht_info =
 				(struct ieee_types_htinfo *) current_ptr;
 			bss_entry->ht_info_offset =
@@ -1652,7 +1652,7 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 				(*(bss_entry->bcn_ht_info)).ieee_hdr.len +
 				sizeof(struct ieee_types_header));
 			break;
-		case BSSCO_2040:
+		case WLAN_EID_BSS_COEX_2040:
 			bss_entry->bcn_bss_co_2040 =
 				(struct ieee_types_2040bssco *) current_ptr;
 			bss_entry->bss_co_2040_offset =
@@ -1663,7 +1663,7 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 				(*(bss_entry->bcn_bss_co_2040)).ieee_hdr.len +
 				sizeof(struct ieee_types_header));
 			break;
-		case EXT_CAPABILITY:
+		case WLAN_EID_EXT_CAPABILITY:
 			bss_entry->bcn_ext_cap =
 				(struct ieee_types_extcap *) current_ptr;
 			bss_entry->ext_cap_offset =
@@ -1674,7 +1674,7 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 				(*(bss_entry->bcn_ext_cap)).ieee_hdr.len +
 				sizeof(struct ieee_types_header));
 			break;
-		case OVERLAP_BSS_SCAN_PARAM:
+		case WLAN_EID_OVERLAP_BSS_SCAN_PARAM:
 			bss_entry->bcn_obss_scan =
 				(struct ieee_types_obss_scan_param *)
 				current_ptr;
@@ -1687,6 +1687,8 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 				ieee_hdr.len +
 				sizeof(struct ieee_types_header));
 			break;
+		default:
+			break;
 		}
 
 		current_ptr += element_len + 2;
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 51206db..955b960 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -860,7 +860,7 @@ static enum mwifiex_status mwifiex_cmd_802_11_supplicant_pmk(
 	if (psk->ssid.ssid_len) {
 		pssid_tlv = (struct mwifiex_ie_types_ssid_param_set *)
 					ptlv_buffer;
-		pssid_tlv->header.type = cpu_to_le16(TLV_TYPE_SSID);
+		pssid_tlv->header.type = cpu_to_le16(WLAN_EID_SSID);
 		pssid_tlv->header.len = cpu_to_le16((u16)psk->ssid.ssid_len);
 		memcpy((char *)pssid_tlv->ssid, psk->ssid.ssid,
 					psk->ssid.ssid_len);
@@ -984,7 +984,7 @@ mwifiex_cmd_802_11d_domain_info(struct mwifiex_private *priv,
 	}
 
 	/* Set domain info fields */
-	domain->header.type = cpu_to_le16(TLV_TYPE_DOMAIN);
+	domain->header.type = cpu_to_le16(WLAN_EID_COUNTRY);
 	memcpy(domain->country_code,
 			adapter->domain_reg.country_code,
 			sizeof(domain->country_code));
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 5ae2c8e..ed8e1aa 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -877,13 +877,13 @@ mwifiex_ret_802_11_supplicant_pmk(struct mwifiex_private *priv,
 		if (action == HostCmd_ACT_GEN_GET) {
 			while (tlv_buf_len > 0) {
 				tlv = (*tlv_buf) | (*(tlv_buf + 1) << 8);
-				if ((tlv != TLV_TYPE_SSID)
+				if ((tlv != WLAN_EID_SSID)
 						&& (tlv != TLV_TYPE_BSSID)
 						&& (tlv != TLV_TYPE_PASSPHRASE)
 						&& (tlv != TLV_TYPE_PMK))
 					break;
 				switch (tlv) {
-				case TLV_TYPE_SSID:
+				case WLAN_EID_SSID:
 					pssid_tlv =
 						(struct
 						mwifiex_ie_types_ssid_param_set
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index 005f522..f4384d5 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -162,7 +162,7 @@ mwifiex_2040_coex_event(struct mwifiex_private *priv)
 
 	if (priv->curr_bss_params.bss_descriptor.bcn_obss_scan &&
 	    priv->curr_bss_params.bss_descriptor.bcn_obss_scan->
-	    ieee_hdr.element_id == OVERLAP_BSS_SCAN_PARAM) {
+	    ieee_hdr.element_id == WLAN_EID_OVERLAP_BSS_SCAN_PARAM) {
 		ele_len =
 			priv->curr_bss_params.bss_descriptor.
 			bcn_obss_scan->ieee_hdr.len;
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 0bcb1ac..cad23c3 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -3182,9 +3182,9 @@ mwifiex_set_wpa_ie_helper(struct mwifiex_private *priv, u8 *ie_data_ptr,
 		PRINTM(MCMND, "Set Wpa_ie_len=%d IE=%#x\n", priv->wpa_ie_len,
 		       priv->wpa_ie[0]);
 		DBG_HEXDUMP(MCMD_D, "Wpa_ie", priv->wpa_ie, priv->wpa_ie_len);
-		if (priv->wpa_ie[0] == WPA_IE) {
+		if (priv->wpa_ie[0] == WLAN_EID_WPA) {
 			priv->sec_info.wpa_enabled = true;
-		} else if (priv->wpa_ie[0] == RSN_IE) {
+		} else if (priv->wpa_ie[0] == WLAN_EID_RSN) {
 			priv->sec_info.wpa2_enabled = true;
 		} else {
 			priv->sec_info.wpa_enabled = false;
@@ -3227,7 +3227,7 @@ mwifiex_set_wapi_ie(struct mwifiex_private *priv, u8 *ie_data_ptr,
 		       priv->wapi_ie[0]);
 		DBG_HEXDUMP(MCMD_D, "wapi_ie", priv->wapi_ie,
 			    priv->wapi_ie_len);
-		if (priv->wapi_ie[0] == WAPI_IE)
+		if (priv->wapi_ie[0] == WLAN_EID_BSS_AC_ACCESS_DELAY)
 			priv->sec_info.wapi_enabled = true;
 	} else {
 		memset(priv->wapi_ie, 0, sizeof(priv->wapi_ie));
@@ -5743,16 +5743,17 @@ mwifiex_set_gen_ie_helper(struct mwifiex_private *priv, u8 *ie_data_ptr,
 	} else {
 		pvendor_ie = (struct ieee_types_vendor_header *) ie_data_ptr;
 		/* Test to see if it is a WPA IE, if not, then it is a gen IE */
-		if (((pvendor_ie->element_id == WPA_IE)
+		if (((pvendor_ie->element_id == WLAN_EID_WPA)
 		     && (!memcmp(pvendor_ie->oui, wpa_oui, sizeof(wpa_oui))))
-		    || (pvendor_ie->element_id == RSN_IE)
+		    || (pvendor_ie->element_id == WLAN_EID_RSN)
 			) {
 
 			/* IE is a WPA/WPA2 IE so call set_wpa function */
 			ret = mwifiex_set_wpa_ie_helper(priv, ie_data_ptr,
 							ie_len);
 			priv->wps.session_enable = false;
-		} else if (pvendor_ie->element_id == WAPI_IE) {
+		} else if (pvendor_ie->element_id ==
+				WLAN_EID_BSS_AC_ACCESS_DELAY) {
 			/* IE is a WAPI IE so call set_wapi function */
 			ret = mwifiex_set_wapi_ie(priv, ie_data_ptr, ie_len);
 		} else {
@@ -5769,7 +5770,8 @@ mwifiex_set_gen_ie_helper(struct mwifiex_private *priv, u8 *ie_data_ptr,
 				pvendor_ie = (struct
 					      ieee_types_vendor_header
 					      *) ie_data_ptr;
-				if ((pvendor_ie->element_id == WPS_IE)
+				if ((pvendor_ie->element_id ==
+						WLAN_EID_VENDOR_SPECIFIC)
 						&& (!memcmp(pvendor_ie->oui,
 						wps_oui, sizeof(wps_oui)))) {
 					priv->wps.session_enable = true;
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 7a47eab..4758151 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -39,7 +39,7 @@
 #define IPTOS_OFFSET 5
 
 /** WMM information IE */
-static const u8 wmm_info_ie[] = { WMM_IE, 0x07,
+static const u8 wmm_info_ie[] = { WLAN_EID_VENDOR_SPECIFIC, 0x07,
 	0x00, 0x50, 0xf2, 0x02,
 	0x00, 0x01, 0x00
 };
@@ -871,7 +871,7 @@ mwifiex_ret_wmm_get_status(struct mwifiex_private *priv,
 			ac_status->flow_created = tlv_wmm_qstatus->flow_created;
 			break;
 
-		case WMM_IE:
+		case WLAN_EID_VENDOR_SPECIFIC:
 			/*
 			 * Point the regular IEEE IE 2 bytes into the Marvell IE
 			 *   and setup the IEEE IE type and length byte fields
@@ -883,7 +883,8 @@ mwifiex_ret_wmm_get_status(struct mwifiex_private *priv,
 				(struct ieee_types_wmm_parameter *) (curr +
 								    2);
 			wmm_param_ie->vend_hdr.len = (u8) tlv_len;
-			wmm_param_ie->vend_hdr.element_id = WMM_IE;
+			wmm_param_ie->vend_hdr.element_id =
+						WLAN_EID_VENDOR_SPECIFIC;
 
 			PRINTM(MINFO, "CMD_RESP: WMM_GET_STATUS: WMM Parameter "
 					"Set: %d\n",
@@ -950,11 +951,12 @@ mwifiex_wmm_process_association_req(struct mwifiex_private *priv,
 	       wmm_ie->vend_hdr.element_id);
 
 	if ((priv->wmm_required
-	     || (ht_cap && (ht_cap->ieee_hdr.element_id == HT_CAPABILITY)
+	     || (ht_cap && (ht_cap->ieee_hdr.element_id ==
+		WLAN_EID_HT_CAPABILITY)
 		 && (priv->adapter->config_bands & BAND_GN
 		     || priv->adapter->config_bands & BAND_AN))
 	    )
-	    && wmm_ie->vend_hdr.element_id == WMM_IE) {
+	    && wmm_ie->vend_hdr.element_id == WLAN_EID_VENDOR_SPECIFIC) {
 		wmm_tlv = (struct mwifiex_ie_types_wmm_param_set *) *assoc_buf;
 		wmm_tlv->header.type = cpu_to_le16((u16) wmm_info_ie[0]);
 		wmm_tlv->header.len = cpu_to_le16((u16) wmm_info_ie[1]);
-- 
1.7.0.2

