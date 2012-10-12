Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1612 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933826Ab2JLK23 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2012 06:28:29 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>,
	"Kalle Valo" <kvalo@qca.qualcomm.com>, "Jouni Malinen" <j@w1.fi>,
	"Stanislav Yakovlev" <stas.yakovlev@gmail.com>,
	"Dan Williams" <dcbw@redhat.com>, "Bing Zhao" <bzhao@marvell.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>
Subject: [PATCH 1/3] wireless: drivers: make use of
 WLAN_EID_VENDOR_SPECIFIC
Date: Fri, 12 Oct 2012 12:28:14 +0200
Message-ID: <1350037696-23747-2-git-send-email-arend@broadcom.com> (sfid-20121012_124539_460105_06CF076E)
In-Reply-To: <1350037696-23747-1-git-send-email-arend@broadcom.com>
References: <1350037696-23747-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The include file linux/ieee80211.h contains three definitions for
the same thing in enum ieee80211_eid due to historic changes:

/* Information Element IDs */
enum ieee80211_eid {
    :
    WLAN_EID_WPA = 221,
    WLAN_EID_GENERIC = 221,
    WLAN_EID_VENDOR_SPECIFIC = 221,
    :
};

The standard refers to this as "vendor specific" element so the
other two definitions are better not used. This patch changes the
wireless drivers to use one definition, ie. WLAN_EID_VENDOR_SPECIFIC.

Cc: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Jouni Malinen <j@w1.fi>
Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>
Cc: Bing Zhao <bzhao@marvell.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
The prism54 and rtl8712 drivers use WLAN_EID_GENERIC as well, but have
their own definition so those are not changed. They may consider using
linux/ieee80211.h.

Gr. AvS
---
 drivers/net/wireless/airo.c                        |    2 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |    2 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    2 +-
 drivers/net/wireless/hostap/hostap_80211_rx.c      |    2 +-
 drivers/net/wireless/ipw2x00/libipw_rx.c           |    4 ++--
 drivers/net/wireless/libertas/mesh.c               |    2 +-
 drivers/net/wireless/mwifiex/scan.c                |   13 ++++++++-----
 drivers/net/wireless/mwifiex/sta_ioctl.c           |    4 ++--
 drivers/net/wireless/orinoco/main.h                |    2 +-
 9 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index ac1eda6..37abea3 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -7425,7 +7425,7 @@ static inline char *airo_translate_scan(struct net_device *dev,
 					num_null_ies++;
 				break;
 
-			case WLAN_EID_GENERIC:
+			case WLAN_EID_VENDOR_SPECIFIC:
 				if (ie[1] >= 4 &&
 				    ie[2] == 0x00 &&
 				    ie[3] == 0x50 &&
diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 7089f81..ad252d0 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -301,7 +301,7 @@ static bool ath6kl_cfg80211_ready(struct ath6kl_vif *vif)
 
 static bool ath6kl_is_wpa_ie(const u8 *pos)
 {
-	return pos[0] == WLAN_EID_WPA && pos[1] >= 4 &&
+	return pos[0] == WLAN_EID_VENDOR_SPECIFIC && pos[1] >= 4 &&
 		pos[2] == 0x00 && pos[3] == 0x50 &&
 		pos[4] == 0xf2 && pos[5] == 0x01;
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index c1abaa6..0e95209 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -2679,7 +2679,7 @@ brcmf_find_wpaie(u8 *parse, u32 len)
 {
 	struct brcmf_tlv *ie;
 
-	while ((ie = brcmf_parse_tlvs(parse, len, WLAN_EID_WPA))) {
+	while ((ie = brcmf_parse_tlvs(parse, len, WLAN_EID_VENDOR_SPECIFIC))) {
 		if (brcmf_tlv_has_ie((u8 *)ie, &parse, &len,
 				     WPA_OUI, TLV_OUI_LEN, WPA_OUI_TYPE))
 			return (struct brcmf_vs_tlv *)ie;
diff --git a/drivers/net/wireless/hostap/hostap_80211_rx.c b/drivers/net/wireless/hostap/hostap_80211_rx.c
index df7050a..d39e3e2 100644
--- a/drivers/net/wireless/hostap/hostap_80211_rx.c
+++ b/drivers/net/wireless/hostap/hostap_80211_rx.c
@@ -415,7 +415,7 @@ static void hostap_rx_sta_beacon(local_info_t *local, struct sk_buff *skb,
 			ssid = pos + 2;
 			ssid_len = pos[1];
 			break;
-		case WLAN_EID_GENERIC:
+		case WLAN_EID_VENDOR_SPECIFIC:
 			if (pos[1] >= 4 &&
 			    pos[2] == 0x00 && pos[3] == 0x50 &&
 			    pos[4] == 0xf2 && pos[5] == 1) {
diff --git a/drivers/net/wireless/ipw2x00/libipw_rx.c b/drivers/net/wireless/ipw2x00/libipw_rx.c
index 02e0579..c287ce2 100644
--- a/drivers/net/wireless/ipw2x00/libipw_rx.c
+++ b/drivers/net/wireless/ipw2x00/libipw_rx.c
@@ -1248,8 +1248,8 @@ static int libipw_parse_info_param(struct libipw_info_element
 			LIBIPW_DEBUG_MGMT("WLAN_EID_CHALLENGE: ignored\n");
 			break;
 
-		case WLAN_EID_GENERIC:
-			LIBIPW_DEBUG_MGMT("WLAN_EID_GENERIC: %d bytes\n",
+		case WLAN_EID_VENDOR_SPECIFIC:
+			LIBIPW_DEBUG_MGMT("WLAN_EID_VENDOR_SPECIFIC: %d bytes\n",
 					     info_element->len);
 			if (!libipw_parse_qos_info_param_IE(info_element,
 							       network))
diff --git a/drivers/net/wireless/libertas/mesh.c b/drivers/net/wireless/libertas/mesh.c
index 9780775..3e81264 100644
--- a/drivers/net/wireless/libertas/mesh.c
+++ b/drivers/net/wireless/libertas/mesh.c
@@ -101,7 +101,7 @@ static int lbs_mesh_config(struct lbs_private *priv, uint16_t action,
 
 	switch (action) {
 	case CMD_ACT_MESH_CONFIG_START:
-		ie->id = WLAN_EID_GENERIC;
+		ie->id = WLAN_EID_VENDOR_SPECIFIC;
 		ie->val.oui[0] = 0x00;
 		ie->val.oui[1] = 0x50;
 		ie->val.oui[2] = 0x43;
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 00b658d..5896b1f 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -153,7 +153,7 @@ mwifiex_is_wpa_oui_present(struct mwifiex_bssdescriptor *bss_desc, u32 cipher)
 
 	if (((bss_desc->bcn_wpa_ie) &&
 	     ((*(bss_desc->bcn_wpa_ie)).vend_hdr.element_id ==
-	      WLAN_EID_WPA))) {
+	      WLAN_EID_VENDOR_SPECIFIC))) {
 		iebody = (struct ie_body *) bss_desc->bcn_wpa_ie->data;
 		oui = &mwifiex_wpa_oui[cipher][0];
 		ret = mwifiex_search_oui_in_ie(iebody, oui);
@@ -202,7 +202,7 @@ mwifiex_is_bss_no_sec(struct mwifiex_private *priv,
 	if (!priv->sec_info.wep_enabled && !priv->sec_info.wpa_enabled &&
 	    !priv->sec_info.wpa2_enabled && ((!bss_desc->bcn_wpa_ie) ||
 		((*(bss_desc->bcn_wpa_ie)).vend_hdr.element_id !=
-		 WLAN_EID_WPA)) &&
+		 WLAN_EID_VENDOR_SPECIFIC)) &&
 	    ((!bss_desc->bcn_rsn_ie) ||
 		((*(bss_desc->bcn_rsn_ie)).ieee_hdr.element_id !=
 		 WLAN_EID_RSN)) &&
@@ -237,7 +237,8 @@ mwifiex_is_bss_wpa(struct mwifiex_private *priv,
 {
 	if (!priv->sec_info.wep_enabled && priv->sec_info.wpa_enabled &&
 	    !priv->sec_info.wpa2_enabled && ((bss_desc->bcn_wpa_ie) &&
-	    ((*(bss_desc->bcn_wpa_ie)).vend_hdr.element_id == WLAN_EID_WPA))
+	    ((*(bss_desc->bcn_wpa_ie)).
+	     vend_hdr.element_id == WLAN_EID_VENDOR_SPECIFIC))
 	   /*
 	    * Privacy bit may NOT be set in some APs like
 	    * LinkSys WRT54G && bss_desc->privacy
@@ -309,7 +310,8 @@ mwifiex_is_bss_adhoc_aes(struct mwifiex_private *priv,
 	if (!priv->sec_info.wep_enabled && !priv->sec_info.wpa_enabled &&
 	    !priv->sec_info.wpa2_enabled &&
 	    ((!bss_desc->bcn_wpa_ie) ||
-	     ((*(bss_desc->bcn_wpa_ie)).vend_hdr.element_id != WLAN_EID_WPA)) &&
+	     ((*(bss_desc->bcn_wpa_ie)).
+	      vend_hdr.element_id != WLAN_EID_VENDOR_SPECIFIC)) &&
 	    ((!bss_desc->bcn_rsn_ie) ||
 	     ((*(bss_desc->bcn_rsn_ie)).ieee_hdr.element_id != WLAN_EID_RSN)) &&
 	    !priv->sec_info.encryption_mode && bss_desc->privacy) {
@@ -329,7 +331,8 @@ mwifiex_is_bss_dynamic_wep(struct mwifiex_private *priv,
 	if (!priv->sec_info.wep_enabled && !priv->sec_info.wpa_enabled &&
 	    !priv->sec_info.wpa2_enabled &&
 	    ((!bss_desc->bcn_wpa_ie) ||
-	     ((*(bss_desc->bcn_wpa_ie)).vend_hdr.element_id != WLAN_EID_WPA)) &&
+	     ((*(bss_desc->bcn_wpa_ie)).
+	      vend_hdr.element_id != WLAN_EID_VENDOR_SPECIFIC)) &&
 	    ((!bss_desc->bcn_rsn_ie) ||
 	     ((*(bss_desc->bcn_rsn_ie)).ieee_hdr.element_id != WLAN_EID_RSN)) &&
 	    priv->sec_info.encryption_mode && bss_desc->privacy) {
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 0c9f70b..552d72e 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -713,7 +713,7 @@ static int mwifiex_set_wpa_ie_helper(struct mwifiex_private *priv,
 		dev_dbg(priv->adapter->dev, "cmd: Set Wpa_ie_len=%d IE=%#x\n",
 			priv->wpa_ie_len, priv->wpa_ie[0]);
 
-		if (priv->wpa_ie[0] == WLAN_EID_WPA) {
+		if (priv->wpa_ie[0] == WLAN_EID_VENDOR_SPECIFIC) {
 			priv->sec_info.wpa_enabled = true;
 		} else if (priv->wpa_ie[0] == WLAN_EID_RSN) {
 			priv->sec_info.wpa2_enabled = true;
@@ -1253,7 +1253,7 @@ mwifiex_set_gen_ie_helper(struct mwifiex_private *priv, u8 *ie_data_ptr,
 	}
 	pvendor_ie = (struct ieee_types_vendor_header *) ie_data_ptr;
 	/* Test to see if it is a WPA IE, if not, then it is a gen IE */
-	if (((pvendor_ie->element_id == WLAN_EID_WPA) &&
+	if (((pvendor_ie->element_id == WLAN_EID_VENDOR_SPECIFIC) &&
 	     (!memcmp(pvendor_ie->oui, wpa_oui, sizeof(wpa_oui)))) ||
 	    (pvendor_ie->element_id == WLAN_EID_RSN)) {
 
diff --git a/drivers/net/wireless/orinoco/main.h b/drivers/net/wireless/orinoco/main.h
index 4dadf98..5a8fec2 100644
--- a/drivers/net/wireless/orinoco/main.h
+++ b/drivers/net/wireless/orinoco/main.h
@@ -39,7 +39,7 @@ static inline u8 *orinoco_get_wpa_ie(u8 *data, size_t len)
 {
 	u8 *p = data;
 	while ((p + 2 + WPA_SELECTOR_LEN) < (data + len)) {
-		if ((p[0] == WLAN_EID_GENERIC) &&
+		if ((p[0] == WLAN_EID_VENDOR_SPECIFIC) &&
 		    (memcmp(&p[2], WPA_OUI_TYPE, WPA_SELECTOR_LEN) == 0))
 			return p;
 		p += p[1] + 2;
-- 
1.7.9.5


