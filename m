Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38391 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbaAON4y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 08:56:54 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: make connect ie param const
Date: Wed, 15 Jan 2014 14:56:49 +0100
Message-Id: <1389794209-25680-1-git-send-email-johannes@sipsolutions.net> (sfid-20140115_145659_671668_F14171F2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This required liberally sprinkling 'const' over brcmfmac
and mwifiex but seems like a useful thing to do since the
pointer can't really be written.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c     |  5 ++-
 drivers/net/wireless/brcm80211/brcmfmac/fwil.h     |  2 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  | 46 +++++++++++-----------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |  3 +-
 drivers/net/wireless/mwifiex/main.h                |  2 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c           |  2 +-
 include/net/cfg80211.h                             |  2 +-
 7 files changed, 32 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
index b72d339..d6e04c6 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
@@ -124,7 +124,8 @@ brcmf_fil_cmd_int_get(struct brcmf_if *ifp, u32 cmd, u32 *data)
 }
 
 static u32
-brcmf_create_iovar(char *name, char *data, u32 datalen, char *buf, u32 buflen)
+brcmf_create_iovar(char *name, const char *data, u32 datalen,
+		   char *buf, u32 buflen)
 {
 	u32 len;
 
@@ -144,7 +145,7 @@ brcmf_create_iovar(char *name, char *data, u32 datalen, char *buf, u32 buflen)
 
 
 s32
-brcmf_fil_iovar_data_set(struct brcmf_if *ifp, char *name, void *data,
+brcmf_fil_iovar_data_set(struct brcmf_if *ifp, char *name, const void *data,
 			 u32 len)
 {
 	struct brcmf_pub *drvr = ifp->drvr;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil.h b/drivers/net/wireless/brcm80211/brcmfmac/fwil.h
index 77eae86..a30be68 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil.h
@@ -83,7 +83,7 @@ s32 brcmf_fil_cmd_data_get(struct brcmf_if *ifp, u32 cmd, void *data, u32 len);
 s32 brcmf_fil_cmd_int_set(struct brcmf_if *ifp, u32 cmd, u32 data);
 s32 brcmf_fil_cmd_int_get(struct brcmf_if *ifp, u32 cmd, u32 *data);
 
-s32 brcmf_fil_iovar_data_set(struct brcmf_if *ifp, char *name, void *data,
+s32 brcmf_fil_iovar_data_set(struct brcmf_if *ifp, char *name, const void *data,
 			     u32 len);
 s32 brcmf_fil_iovar_data_get(struct brcmf_if *ifp, char *name, void *data,
 			     u32 len);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 3966fe0..711524e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -351,13 +351,11 @@ u16 channel_to_chanspec(struct brcmu_d11inf *d11inf,
  * triples, returning a pointer to the substring whose first element
  * matches tag
  */
-struct brcmf_tlv *brcmf_parse_tlvs(void *buf, int buflen, uint key)
+const struct brcmf_tlv *
+brcmf_parse_tlvs(const void *buf, int buflen, uint key)
 {
-	struct brcmf_tlv *elt;
-	int totlen;
-
-	elt = (struct brcmf_tlv *)buf;
-	totlen = buflen;
+	const struct brcmf_tlv *elt = buf;
+	int totlen = buflen;
 
 	/* find tagged parameter */
 	while (totlen >= TLV_HDR_LEN) {
@@ -378,8 +376,8 @@ struct brcmf_tlv *brcmf_parse_tlvs(void *buf, int buflen, uint key)
  * not update the tlvs buffer pointer/length.
  */
 static bool
-brcmf_tlv_has_ie(u8 *ie, u8 **tlvs, u32 *tlvs_len,
-		 u8 *oui, u32 oui_len, u8 type)
+brcmf_tlv_has_ie(const u8 *ie, const u8 **tlvs, u32 *tlvs_len,
+		 const u8 *oui, u32 oui_len, u8 type)
 {
 	/* If the contents match the OUI and the type */
 	if (ie[TLV_LEN_OFF] >= oui_len + 1 &&
@@ -401,12 +399,12 @@ brcmf_tlv_has_ie(u8 *ie, u8 **tlvs, u32 *tlvs_len,
 }
 
 static struct brcmf_vs_tlv *
-brcmf_find_wpaie(u8 *parse, u32 len)
+brcmf_find_wpaie(const u8 *parse, u32 len)
 {
-	struct brcmf_tlv *ie;
+	const struct brcmf_tlv *ie;
 
 	while ((ie = brcmf_parse_tlvs(parse, len, WLAN_EID_VENDOR_SPECIFIC))) {
-		if (brcmf_tlv_has_ie((u8 *)ie, &parse, &len,
+		if (brcmf_tlv_has_ie((const u8 *)ie, &parse, &len,
 				     WPA_OUI, TLV_OUI_LEN, WPA_OUI_TYPE))
 			return (struct brcmf_vs_tlv *)ie;
 	}
@@ -414,9 +412,9 @@ brcmf_find_wpaie(u8 *parse, u32 len)
 }
 
 static struct brcmf_vs_tlv *
-brcmf_find_wpsie(u8 *parse, u32 len)
+brcmf_find_wpsie(const u8 *parse, u32 len)
 {
-	struct brcmf_tlv *ie;
+	const struct brcmf_tlv *ie;
 
 	while ((ie = brcmf_parse_tlvs(parse, len, WLAN_EID_VENDOR_SPECIFIC))) {
 		if (brcmf_tlv_has_ie((u8 *)ie, &parse, &len,
@@ -1562,9 +1560,9 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 	struct ieee80211_channel *chan = sme->channel;
 	struct brcmf_join_params join_params;
 	size_t join_params_size;
-	struct brcmf_tlv *rsn_ie;
-	struct brcmf_vs_tlv *wpa_ie;
-	void *ie;
+	const struct brcmf_tlv *rsn_ie;
+	const struct brcmf_vs_tlv *wpa_ie;
+	const void *ie;
 	u32 ie_len;
 	struct brcmf_ext_join_params_le *ext_join_params;
 	u16 chanspec;
@@ -1591,7 +1589,8 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 			ie_len = wpa_ie->len + TLV_HDR_LEN;
 		} else {
 			/* find the RSN_IE */
-			rsn_ie = brcmf_parse_tlvs((u8 *)sme->ie, sme->ie_len,
+			rsn_ie = brcmf_parse_tlvs((const u8 *)sme->ie,
+						  sme->ie_len,
 						  WLAN_EID_RSN);
 			if (rsn_ie) {
 				ie = rsn_ie;
@@ -2454,7 +2453,7 @@ static s32 brcmf_update_bss_info(struct brcmf_cfg80211_info *cfg,
 	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ifp->ndev);
 	struct brcmf_bss_info_le *bi;
 	struct brcmf_ssid *ssid;
-	struct brcmf_tlv *tim;
+	const struct brcmf_tlv *tim;
 	u16 beacon_interval;
 	u8 dtim_period;
 	size_t ie_len;
@@ -3218,8 +3217,9 @@ static bool brcmf_valid_wpa_oui(u8 *oui, bool is_rsn_ie)
 }
 
 static s32
-brcmf_configure_wpaie(struct net_device *ndev, struct brcmf_vs_tlv *wpa_ie,
-		     bool is_rsn_ie)
+brcmf_configure_wpaie(struct net_device *ndev,
+		      const struct brcmf_vs_tlv *wpa_ie,
+		      bool is_rsn_ie)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	u32 auth = 0; /* d11 open authentication */
@@ -3705,11 +3705,11 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	s32 ie_offset;
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct brcmf_tlv *ssid_ie;
+	const struct brcmf_tlv *ssid_ie;
 	struct brcmf_ssid_le ssid_le;
 	s32 err = -EPERM;
-	struct brcmf_tlv *rsn_ie;
-	struct brcmf_vs_tlv *wpa_ie;
+	const struct brcmf_tlv *rsn_ie;
+	const struct brcmf_vs_tlv *wpa_ie;
 	struct brcmf_join_params join_params;
 	enum nl80211_iftype dev_role;
 	struct brcmf_fil_bss_enable_le bss_enable;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index d9bdaf9..633ad41 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -493,7 +493,8 @@ void brcmf_free_vif(struct brcmf_cfg80211_info *cfg,
 s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
 			  const u8 *vndr_ie_buf, u32 vndr_ie_len);
 s32 brcmf_vif_clear_mgmt_ies(struct brcmf_cfg80211_vif *vif);
-struct brcmf_tlv *brcmf_parse_tlvs(void *buf, int buflen, uint key);
+const struct brcmf_tlv *
+brcmf_parse_tlvs(const void *buf, int buflen, uint key);
 u16 channel_to_chanspec(struct brcmu_d11inf *d11inf,
 			struct ieee80211_channel *ch);
 u32 wl_get_vif_state_all(struct brcmf_cfg80211_info *cfg, unsigned long state);
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index dc34457..2fdffdf 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1076,7 +1076,7 @@ int mwifiex_set_encode(struct mwifiex_private *priv, struct key_params *kp,
 		       const u8 *key, int key_len, u8 key_index,
 		       const u8 *mac_addr, int disable);
 
-int mwifiex_set_gen_ie(struct mwifiex_private *priv, u8 *ie, int ie_len);
+int mwifiex_set_gen_ie(struct mwifiex_private *priv, const u8 *ie, int ie_len);
 
 int mwifiex_get_ver_ext(struct mwifiex_private *priv);
 
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index a09398f..42b403b 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -1371,7 +1371,7 @@ static int mwifiex_misc_ioctl_gen_ie(struct mwifiex_private *priv,
  * with requisite parameters and calls the IOCTL handler.
  */
 int
-mwifiex_set_gen_ie(struct mwifiex_private *priv, u8 *ie, int ie_len)
+mwifiex_set_gen_ie(struct mwifiex_private *priv, const u8 *ie, int ie_len)
 {
 	struct mwifiex_ds_misc_gen_ie gen_ie;
 
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9237b26..d10ba3a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1737,7 +1737,7 @@ struct cfg80211_connect_params {
 	const u8 *ssid;
 	size_t ssid_len;
 	enum nl80211_auth_type auth_type;
-	u8 *ie;
+	const u8 *ie;
 	size_t ie_len;
 	bool privacy;
 	enum nl80211_mfp mfp;
-- 
1.8.5.1

