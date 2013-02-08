Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4654 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760206Ab3BHO4m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 09:56:42 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 11/27] brcmfmac: Update connect setup/handling routines
 for multiple bss.
Date: Fri, 8 Feb 2013 15:53:46 +0100
Message-ID: <1360335242-12608-12-git-send-email-arend@broadcom.com> (sfid-20130208_163812_446182_BAB451FE)
In-Reply-To: <1360335242-12608-1-git-send-email-arend@broadcom.com>
References: <1360335242-12608-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

In preparation of p2p connections update the sta connect setup and
handling routines. Use join iovar and bsscfg commands where
applicable. Handle assoc ind per bsscfg (vif) and generalize
vndr ie setup to support assoc IEs and support all setup types,
e.g. sta, ap and p2p.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |   22 ++
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  366 +++++++++++++-------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |    2 +
 3 files changed, 258 insertions(+), 132 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index c4f30bd..c4a6083 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -377,6 +377,28 @@ struct brcmf_join_params {
 	struct brcmf_assoc_params_le params_le;
 };
 
+/* scan params for extended join */
+struct brcmf_join_scan_params_le {
+	u8 scan_type;		/* 0 use default, active or passive scan */
+	__le32 nprobes;		/* -1 use default, nr of probes per channel */
+	__le32 active_time;	/* -1 use default, dwell time per channel for
+				 * active scanning
+				 */
+	__le32 passive_time;	/* -1 use default, dwell time per channel
+				 * for passive scanning
+				 */
+	__le32 home_time;	/* -1 use default, dwell time for the home
+				 * channel between channel scans
+				 */
+};
+
+/* extended join params */
+struct brcmf_ext_join_params_le {
+	struct brcmf_ssid_le ssid_le;	/* {0, ""}: wildcard scan */
+	struct brcmf_join_scan_params_le scan_le;
+	struct brcmf_assoc_params_le assoc_le;
+};
+
 struct brcmf_wsec_key {
 	u32 index;		/* key index */
 	u32 len;		/* key length */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 9a82dd4..3112265 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -49,6 +49,7 @@
 #define WPA_OUI_TYPE			1
 #define RSN_OUI				"\x00\x0F\xAC"	/* RSN OUI */
 #define	WME_OUI_TYPE			2
+#define WPS_OUI_TYPE			4
 
 #define VS_IE_FIXED_HDR_LEN		6
 #define WPA_IE_VERSION_LEN		2
@@ -79,6 +80,10 @@
 #define	DOT11_MGMT_HDR_LEN		24	/* d11 management header len */
 #define	DOT11_BCN_PRB_FIXED_LEN		12	/* beacon/probe fixed length */
 
+#define BRCMF_SCAN_JOIN_ACTIVE_DWELL_TIME_MS	320
+#define BRCMF_SCAN_JOIN_PASSIVE_DWELL_TIME_MS	400
+#define BRCMF_SCAN_JOIN_PROBE_INTERVAL_MS	20
+
 #define BRCMF_ASSOC_PARAMS_FIXED_SIZE \
 	(sizeof(struct brcmf_assoc_params_le) - sizeof(u16))
 
@@ -388,6 +393,86 @@ u16 channel_to_chanspec(struct ieee80211_channel *ch)
 	return chanspec;
 }
 
+/* Traverse a string of 1-byte tag/1-byte length/variable-length value
+ * triples, returning a pointer to the substring whose first element
+ * matches tag
+ */
+struct brcmf_tlv *brcmf_parse_tlvs(void *buf, int buflen, uint key)
+{
+	struct brcmf_tlv *elt;
+	int totlen;
+
+	elt = (struct brcmf_tlv *)buf;
+	totlen = buflen;
+
+	/* find tagged parameter */
+	while (totlen >= TLV_HDR_LEN) {
+		int len = elt->len;
+
+		/* validate remaining totlen */
+		if ((elt->id == key) && (totlen >= (len + TLV_HDR_LEN)))
+			return elt;
+
+		elt = (struct brcmf_tlv *)((u8 *)elt + (len + TLV_HDR_LEN));
+		totlen -= (len + TLV_HDR_LEN);
+	}
+
+	return NULL;
+}
+
+/* Is any of the tlvs the expected entry? If
+ * not update the tlvs buffer pointer/length.
+ */
+static bool
+brcmf_tlv_has_ie(u8 *ie, u8 **tlvs, u32 *tlvs_len,
+		 u8 *oui, u32 oui_len, u8 type)
+{
+	/* If the contents match the OUI and the type */
+	if (ie[TLV_LEN_OFF] >= oui_len + 1 &&
+	    !memcmp(&ie[TLV_BODY_OFF], oui, oui_len) &&
+	    type == ie[TLV_BODY_OFF + oui_len]) {
+		return true;
+	}
+
+	if (tlvs == NULL)
+		return false;
+	/* point to the next ie */
+	ie += ie[TLV_LEN_OFF] + TLV_HDR_LEN;
+	/* calculate the length of the rest of the buffer */
+	*tlvs_len -= (int)(ie - *tlvs);
+	/* update the pointer to the start of the buffer */
+	*tlvs = ie;
+
+	return false;
+}
+
+static struct brcmf_vs_tlv *
+brcmf_find_wpaie(u8 *parse, u32 len)
+{
+	struct brcmf_tlv *ie;
+
+	while ((ie = brcmf_parse_tlvs(parse, len, WLAN_EID_VENDOR_SPECIFIC))) {
+		if (brcmf_tlv_has_ie((u8 *)ie, &parse, &len,
+				     WPA_OUI, TLV_OUI_LEN, WPA_OUI_TYPE))
+			return (struct brcmf_vs_tlv *)ie;
+	}
+	return NULL;
+}
+
+static struct brcmf_vs_tlv *
+brcmf_find_wpsie(u8 *parse, u32 len)
+{
+	struct brcmf_tlv *ie;
+
+	while ((ie = brcmf_parse_tlvs(parse, len, WLAN_EID_VENDOR_SPECIFIC))) {
+		if (brcmf_tlv_has_ie((u8 *)ie, &parse, &len,
+				     WPA_OUI, TLV_OUI_LEN, WPS_OUI_TYPE))
+			return (struct brcmf_vs_tlv *)ie;
+	}
+	return NULL;
+}
+
+
 static void convert_key_from_CPU(struct brcmf_wsec_key *key,
 				 struct brcmf_wsec_key_le *key_le)
 {
@@ -1201,7 +1286,7 @@ static s32 brcmf_set_wpa_version(struct net_device *ndev,
 	else
 		val = WPA_AUTH_DISABLED;
 	brcmf_dbg(CONN, "setting wpa_auth to 0x%0x\n", val);
-	err = brcmf_fil_iovar_int_set(netdev_priv(ndev), "wpa_auth", val);
+	err = brcmf_fil_bsscfg_int_set(netdev_priv(ndev), "wpa_auth", val);
 	if (err) {
 		brcmf_err("set wpa_auth failed (%d)\n", err);
 		return err;
@@ -1240,7 +1325,7 @@ static s32 brcmf_set_auth_type(struct net_device *ndev,
 		break;
 	}
 
-	err = brcmf_fil_iovar_int_set(netdev_priv(ndev), "auth", val);
+	err = brcmf_fil_bsscfg_int_set(netdev_priv(ndev), "auth", val);
 	if (err) {
 		brcmf_err("set auth failed (%d)\n", err);
 		return err;
@@ -1304,7 +1389,12 @@ brcmf_set_set_cipher(struct net_device *ndev,
 	}
 
 	brcmf_dbg(CONN, "pval (%d) gval (%d)\n", pval, gval);
-	err = brcmf_fil_iovar_int_set(netdev_priv(ndev), "wsec", pval | gval);
+	/* In case of privacy, but no security and WPS then simulate */
+	/* setting AES. WPS-2.0 allows no security                   */
+	if (brcmf_find_wpsie(sme->ie, sme->ie_len) && !pval && !gval &&
+	    sme->privacy)
+		pval = AES_ENABLED;
+	err = brcmf_fil_bsscfg_int_set(netdev_priv(ndev), "wsec", pval | gval);
 	if (err) {
 		brcmf_err("error (%d)\n", err);
 		return err;
@@ -1326,8 +1416,8 @@ brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 	s32 err = 0;
 
 	if (sme->crypto.n_akm_suites) {
-		err = brcmf_fil_iovar_int_get(netdev_priv(ndev),
-					      "wpa_auth", &val);
+		err = brcmf_fil_bsscfg_int_get(netdev_priv(ndev),
+					       "wpa_auth", &val);
 		if (err) {
 			brcmf_err("could not get wpa_auth (%d)\n", err);
 			return err;
@@ -1361,8 +1451,8 @@ brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 		}
 
 		brcmf_dbg(CONN, "setting wpa_auth to %d\n", val);
-		err = brcmf_fil_iovar_int_set(netdev_priv(ndev),
-					      "wpa_auth", val);
+		err = brcmf_fil_bsscfg_int_set(netdev_priv(ndev),
+					       "wpa_auth", val);
 		if (err) {
 			brcmf_err("could not set wpa_auth (%d)\n", err);
 			return err;
@@ -1468,7 +1558,11 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 	struct ieee80211_channel *chan = sme->channel;
 	struct brcmf_join_params join_params;
 	size_t join_params_size;
-	struct brcmf_ssid ssid;
+	struct brcmf_tlv *rsn_ie;
+	struct brcmf_vs_tlv *wpa_ie;
+	void *ie;
+	u32 ie_len;
+	struct brcmf_ext_join_params_le *ext_join_params;
 	u16 chanspec;
 
 	s32 err = 0;
@@ -1482,6 +1576,34 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 		return -EOPNOTSUPP;
 	}
 
+	if (ifp->vif == cfg->p2p.bss_idx[P2PAPI_BSSCFG_PRIMARY].vif) {
+		/* A normal (non P2P) connection request setup. */
+		ie = NULL;
+		ie_len = 0;
+		/* find the WPA_IE */
+		wpa_ie = brcmf_find_wpaie((u8 *)sme->ie, sme->ie_len);
+		if (wpa_ie) {
+			ie = wpa_ie;
+			ie_len = wpa_ie->len + TLV_HDR_LEN;
+		} else {
+			/* find the RSN_IE */
+			rsn_ie = brcmf_parse_tlvs((u8 *)sme->ie, sme->ie_len,
+						  WLAN_EID_RSN);
+			if (rsn_ie) {
+				ie = rsn_ie;
+				ie_len = rsn_ie->len + TLV_HDR_LEN;
+			}
+		}
+		brcmf_fil_iovar_data_set(ifp, "wpaie", ie, ie_len);
+	}
+
+	err = brcmf_vif_set_mgmt_ie(ifp->vif, BRCMF_VNDR_IE_ASSOCREQ_FLAG,
+				    sme->ie, sme->ie_len);
+	if (err)
+		brcmf_err("Set Assoc REQ IE Failed\n");
+	else
+		brcmf_dbg(TRACE, "Applied Vndr IEs for Assoc request\n");
+
 	set_bit(BRCMF_VIF_STATUS_CONNECTING, &ifp->vif->sme_state);
 
 	if (chan) {
@@ -1528,20 +1650,78 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 		goto done;
 	}
 
+	profile->ssid.SSID_len = min_t(u32, (u32)sizeof(profile->ssid.SSID),
+				       (u32)sme->ssid_len);
+	memcpy(&profile->ssid.SSID, sme->ssid, profile->ssid.SSID_len);
+	if (profile->ssid.SSID_len < IEEE80211_MAX_SSID_LEN) {
+		profile->ssid.SSID[profile->ssid.SSID_len] = 0;
+		brcmf_dbg(CONN, "SSID \"%s\", len (%d)\n", profile->ssid.SSID,
+			  profile->ssid.SSID_len);
+	}
+
+	/* Join with specific BSSID and cached SSID
+	 * If SSID is zero join based on BSSID only
+	 */
+	join_params_size = offsetof(struct brcmf_ext_join_params_le, assoc_le) +
+		offsetof(struct brcmf_assoc_params_le, chanspec_list);
+	if (cfg->channel)
+		join_params_size += sizeof(u16);
+	ext_join_params = kzalloc(join_params_size, GFP_KERNEL);
+	if (ext_join_params == NULL) {
+		err = -ENOMEM;
+		goto done;
+	}
+	ext_join_params->ssid_le.SSID_len = cpu_to_le32(profile->ssid.SSID_len);
+	memcpy(&ext_join_params->ssid_le.SSID, sme->ssid,
+	       profile->ssid.SSID_len);
+	/*increase dwell time to receive probe response or detect Beacon
+	 * from target AP at a noisy air only during connect command
+	 */
+	ext_join_params->scan_le.active_time =
+		cpu_to_le32(BRCMF_SCAN_JOIN_ACTIVE_DWELL_TIME_MS);
+	ext_join_params->scan_le.passive_time =
+		cpu_to_le32(BRCMF_SCAN_JOIN_PASSIVE_DWELL_TIME_MS);
+	/* Set up join scan parameters */
+	ext_join_params->scan_le.scan_type = -1;
+	/* to sync with presence period of VSDB GO.
+	 * Send probe request more frequently. Probe request will be stopped
+	 * when it gets probe response from target AP/GO.
+	 */
+	ext_join_params->scan_le.nprobes =
+		cpu_to_le32(BRCMF_SCAN_JOIN_ACTIVE_DWELL_TIME_MS /
+			    BRCMF_SCAN_JOIN_PROBE_INTERVAL_MS);
+	ext_join_params->scan_le.home_time = cpu_to_le32(-1);
+
+	if (sme->bssid)
+		memcpy(&ext_join_params->assoc_le.bssid, sme->bssid, ETH_ALEN);
+	else
+		memset(&ext_join_params->assoc_le.bssid, 0xFF, ETH_ALEN);
+
+	if (cfg->channel) {
+		ext_join_params->assoc_le.chanspec_num = cpu_to_le32(1);
+
+		ext_join_params->assoc_le.chanspec_list[0] =
+			cpu_to_le16(chanspec);
+	}
+
+	err  = brcmf_fil_bsscfg_data_set(ifp, "join", ext_join_params,
+					 join_params_size);
+	kfree(ext_join_params);
+	if (!err)
+		/* This is it. join command worked, we are done */
+		goto done;
+
+	/* join command failed, fallback to set ssid */
 	memset(&join_params, 0, sizeof(join_params));
 	join_params_size = sizeof(join_params.ssid_le);
 
-	profile->ssid.SSID_len = min_t(u32,
-				       sizeof(ssid.SSID), (u32)sme->ssid_len);
 	memcpy(&join_params.ssid_le.SSID, sme->ssid, profile->ssid.SSID_len);
-	memcpy(&profile->ssid.SSID, sme->ssid, profile->ssid.SSID_len);
 	join_params.ssid_le.SSID_len = cpu_to_le32(profile->ssid.SSID_len);
 
-	memset(join_params.params_le.bssid, 0xFF, ETH_ALEN);
-
-	if (ssid.SSID_len < IEEE80211_MAX_SSID_LEN)
-		brcmf_dbg(CONN, "ssid \"%s\", len (%d)\n",
-			  ssid.SSID, ssid.SSID_len);
+	if (sme->bssid)
+		memcpy(join_params.params_le.bssid, sme->bssid, ETH_ALEN);
+	else
+		memset(join_params.params_le.bssid, 0xFF, ETH_ALEN);
 
 	if (cfg->channel) {
 		join_params.params_le.chanspec_list[0] = cpu_to_le16(chanspec);
@@ -1551,7 +1731,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_SSID,
 				     &join_params, join_params_size);
 	if (err)
-		brcmf_err("WLC_SET_SSID failed (%d)\n", err);
+		brcmf_err("BRCMF_C_SET_SSID failed (%d)\n", err);
 
 done:
 	if (err)
@@ -2010,7 +2190,7 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 			goto done;
 		}
 		/* Report the current tx rate */
-	err = brcmf_fil_cmd_int_get(ifp, BRCMF_C_GET_RATE, &rate);
+		err = brcmf_fil_cmd_int_get(ifp, BRCMF_C_GET_RATE, &rate);
 		if (err) {
 			brcmf_err("Could not get rate (%d)\n", err);
 			goto done;
@@ -2255,78 +2435,10 @@ static bool brcmf_is_ibssmode(struct brcmf_cfg80211_vif *vif)
 	return vif->mode == WL_MODE_IBSS;
 }
 
-/*
- * Traverse a string of 1-byte tag/1-byte length/variable-length value
- * triples, returning a pointer to the substring whose first element
- * matches tag
- */
-struct brcmf_tlv *brcmf_parse_tlvs(void *buf, int buflen, uint key)
-{
-	struct brcmf_tlv *elt;
-	int totlen;
-
-	elt = (struct brcmf_tlv *) buf;
-	totlen = buflen;
-
-	/* find tagged parameter */
-	while (totlen >= TLV_HDR_LEN) {
-		int len = elt->len;
-
-		/* validate remaining totlen */
-		if ((elt->id == key) && (totlen >= (len + TLV_HDR_LEN)))
-			return elt;
-
-		elt = (struct brcmf_tlv *) ((u8 *) elt + (len + TLV_HDR_LEN));
-		totlen -= (len + TLV_HDR_LEN);
-	}
-
-	return NULL;
-}
-
-/* Is any of the tlvs the expected entry? If
- * not update the tlvs buffer pointer/length.
- */
-static bool
-brcmf_tlv_has_ie(u8 *ie, u8 **tlvs, u32 *tlvs_len,
-		 u8 *oui, u32 oui_len, u8 type)
-{
-	/* If the contents match the OUI and the type */
-	if (ie[TLV_LEN_OFF] >= oui_len + 1 &&
-	    !memcmp(&ie[TLV_BODY_OFF], oui, oui_len) &&
-	    type == ie[TLV_BODY_OFF + oui_len]) {
-		return true;
-	}
-
-	if (tlvs == NULL)
-		return false;
-	/* point to the next ie */
-	ie += ie[TLV_LEN_OFF] + TLV_HDR_LEN;
-	/* calculate the length of the rest of the buffer */
-	*tlvs_len -= (int)(ie - *tlvs);
-	/* update the pointer to the start of the buffer */
-	*tlvs = ie;
-
-	return false;
-}
-
-static struct brcmf_vs_tlv *
-brcmf_find_wpaie(u8 *parse, u32 len)
+static s32 brcmf_update_bss_info(struct brcmf_cfg80211_info *cfg,
+				 struct brcmf_if *ifp)
 {
-	struct brcmf_tlv *ie;
-
-	while ((ie = brcmf_parse_tlvs(parse, len, WLAN_EID_VENDOR_SPECIFIC))) {
-		if (brcmf_tlv_has_ie((u8 *)ie, &parse, &len,
-				     WPA_OUI, TLV_OUI_LEN, WPA_OUI_TYPE))
-			return (struct brcmf_vs_tlv *)ie;
-	}
-	return NULL;
-}
-
-static s32 brcmf_update_bss_info(struct brcmf_cfg80211_info *cfg)
-{
-	struct net_device *ndev = cfg_to_ndev(cfg);
-	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ndev);
-	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ifp->ndev);
 	struct brcmf_bss_info_le *bi;
 	struct brcmf_ssid *ssid;
 	struct brcmf_tlv *tim;
@@ -3366,40 +3478,31 @@ s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
 	if (!iovar_ie_buf)
 		return -ENOMEM;
 	curr_ie_buf = iovar_ie_buf;
-	if (ifp->vif->mode == WL_MODE_AP) {
-		switch (pktflag) {
-		case BRCMF_VNDR_IE_PRBRSP_FLAG:
-			mgmt_ie_buf = saved_ie->probe_res_ie;
-			mgmt_ie_len = &saved_ie->probe_res_ie_len;
-			mgmt_ie_buf_len = sizeof(saved_ie->probe_res_ie);
-			break;
-		case BRCMF_VNDR_IE_BEACON_FLAG:
-			mgmt_ie_buf = saved_ie->beacon_ie;
-			mgmt_ie_len = &saved_ie->beacon_ie_len;
-			mgmt_ie_buf_len = sizeof(saved_ie->beacon_ie);
-			break;
-		default:
-			err = -EPERM;
-			brcmf_err("not suitable type\n");
-			goto exit;
-		}
-	} else {
-		switch (pktflag) {
-		case BRCMF_VNDR_IE_PRBREQ_FLAG:
-			mgmt_ie_buf = saved_ie->probe_req_ie;
-			mgmt_ie_len = &saved_ie->probe_req_ie_len;
-			mgmt_ie_buf_len = sizeof(saved_ie->probe_req_ie);
-			break;
-		case BRCMF_VNDR_IE_PRBRSP_FLAG:
-			mgmt_ie_buf = saved_ie->probe_res_ie;
-			mgmt_ie_len = &saved_ie->probe_res_ie_len;
-			mgmt_ie_buf_len = sizeof(saved_ie->probe_res_ie);
-			break;
-		default:
-			err = -EPERM;
-			brcmf_err("not suitable type\n");
-			goto exit;
-		}
+	switch (pktflag) {
+	case BRCMF_VNDR_IE_PRBREQ_FLAG:
+		mgmt_ie_buf = saved_ie->probe_req_ie;
+		mgmt_ie_len = &saved_ie->probe_req_ie_len;
+		mgmt_ie_buf_len = sizeof(saved_ie->probe_req_ie);
+		break;
+	case BRCMF_VNDR_IE_PRBRSP_FLAG:
+		mgmt_ie_buf = saved_ie->probe_res_ie;
+		mgmt_ie_len = &saved_ie->probe_res_ie_len;
+		mgmt_ie_buf_len = sizeof(saved_ie->probe_res_ie);
+		break;
+	case BRCMF_VNDR_IE_BEACON_FLAG:
+		mgmt_ie_buf = saved_ie->beacon_ie;
+		mgmt_ie_len = &saved_ie->beacon_ie_len;
+		mgmt_ie_buf_len = sizeof(saved_ie->beacon_ie);
+		break;
+	case BRCMF_VNDR_IE_ASSOCREQ_FLAG:
+		mgmt_ie_buf = saved_ie->assoc_req_ie;
+		mgmt_ie_len = &saved_ie->assoc_req_ie_len;
+		mgmt_ie_buf_len = sizeof(saved_ie->assoc_req_ie);
+		break;
+	default:
+		err = -EPERM;
+		brcmf_err("not suitable type\n");
+		goto exit;
 	}
 
 	if (vndr_ie_len > mgmt_ie_buf_len) {
@@ -4138,9 +4241,9 @@ static void brcmf_clear_assoc_ies(struct brcmf_cfg80211_info *cfg)
 	conn_info->resp_ie_len = 0;
 }
 
-static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_info *cfg)
+static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_info *cfg,
+			       struct brcmf_if *ifp)
 {
-	struct brcmf_if *ifp = netdev_priv(cfg_to_ndev(cfg));
 	struct brcmf_cfg80211_assoc_ielen_le *assoc_info;
 	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg);
 	u32 req_len;
@@ -4216,9 +4319,9 @@ brcmf_bss_roaming_done(struct brcmf_cfg80211_info *cfg,
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	brcmf_get_assoc_ies(cfg);
+	brcmf_get_assoc_ies(cfg, ifp);
 	memcpy(profile->bssid, e->addr, ETH_ALEN);
-	brcmf_update_bss_info(cfg);
+	brcmf_update_bss_info(cfg, ifp);
 
 	buf = kzalloc(WL_BSS_INFO_MAX, GFP_KERNEL);
 	if (buf == NULL) {
@@ -4273,9 +4376,11 @@ brcmf_bss_connect_done(struct brcmf_cfg80211_info *cfg,
 	if (test_and_clear_bit(BRCMF_VIF_STATUS_CONNECTING,
 			       &ifp->vif->sme_state)) {
 		if (completed) {
-			brcmf_get_assoc_ies(cfg);
+			brcmf_get_assoc_ies(cfg, ifp);
 			memcpy(profile->bssid, e->addr, ETH_ALEN);
-			brcmf_update_bss_info(cfg);
+			brcmf_update_bss_info(cfg, ifp);
+			set_bit(BRCMF_VIF_STATUS_CONNECTED,
+				&ifp->vif->sme_state);
 		}
 		cfg80211_connect_result(ndev,
 					(u8 *)profile->bssid,
@@ -4286,9 +4391,6 @@ brcmf_bss_connect_done(struct brcmf_cfg80211_info *cfg,
 					completed ? WLAN_STATUS_SUCCESS :
 						    WLAN_STATUS_AUTH_TIMEOUT,
 					GFP_KERNEL);
-		if (completed)
-			set_bit(BRCMF_VIF_STATUS_CONNECTED,
-				&ifp->vif->sme_state);
 		brcmf_dbg(CONN, "Report connect result - connection %s\n",
 			  completed ? "succeeded" : "failed");
 	}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index 2155308..2595712 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -175,9 +175,11 @@ struct vif_saved_ie {
 	u8  probe_req_ie[VNDR_IES_BUF_LEN];
 	u8  probe_res_ie[IE_MAX_LEN];
 	u8  beacon_ie[IE_MAX_LEN];
+	u8  assoc_req_ie[IE_MAX_LEN];
 	u32 probe_req_ie_len;
 	u32 probe_res_ie_len;
 	u32 beacon_ie_len;
+	u32 assoc_req_ie_len;
 };
 
 /**
-- 
1.7.10.4


