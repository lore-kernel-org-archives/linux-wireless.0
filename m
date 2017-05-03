Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:35250 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751177AbdECKm0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 May 2017 06:42:26 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH V2 7/9] brcmfmac: support 4-way handshake offloading for 802.1X
Date: Wed,  3 May 2017 11:42:12 +0100
Message-Id: <1493808134-4074-8-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170503_124326_575432_C75939AD)
In-Reply-To: <1493808134-4074-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1493808134-4074-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding callbacks for PMK provisioning. If firmware supports offloading
it is indicated to user-space that 802.1X offload is supported.

Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 61 ++++++++++++++++++++--
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         |  3 +-
 2 files changed, 60 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 27a89dc..cc5b8ba 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -1704,6 +1704,7 @@ static s32 brcmf_set_auth_type(struct net_device *ndev,
 brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_cfg80211_profile *profile = &ifp->vif->profile;
 	s32 val;
 	s32 err;
 	const struct brcmf_tlv *rsn_ie;
@@ -1714,6 +1715,8 @@ static s32 brcmf_set_auth_type(struct net_device *ndev,
 	u32 mfp;
 	u16 count;
 
+	profile->use_fwsup = BRCMF_PROFILE_FWSUP_NONE;
+
 	if (!sme->crypto.n_akm_suites)
 		return 0;
 
@@ -1726,6 +1729,8 @@ static s32 brcmf_set_auth_type(struct net_device *ndev,
 		switch (sme->crypto.akm_suites[0]) {
 		case WLAN_AKM_SUITE_8021X:
 			val = WPA_AUTH_UNSPECIFIED;
+			if (sme->want_1x)
+				profile->use_fwsup = BRCMF_PROFILE_FWSUP_1X;
 			break;
 		case WLAN_AKM_SUITE_PSK:
 			val = WPA_AUTH_PSK;
@@ -1739,9 +1744,13 @@ static s32 brcmf_set_auth_type(struct net_device *ndev,
 		switch (sme->crypto.akm_suites[0]) {
 		case WLAN_AKM_SUITE_8021X:
 			val = WPA2_AUTH_UNSPECIFIED;
+			if (sme->want_1x)
+				profile->use_fwsup = BRCMF_PROFILE_FWSUP_1X;
 			break;
 		case WLAN_AKM_SUITE_8021X_SHA256:
 			val = WPA2_AUTH_1X_SHA256;
+			if (sme->want_1x)
+				profile->use_fwsup = BRCMF_PROFILE_FWSUP_1X;
 			break;
 		case WLAN_AKM_SUITE_PSK_SHA256:
 			val = WPA2_AUTH_PSK_SHA256;
@@ -1756,6 +1765,9 @@ static s32 brcmf_set_auth_type(struct net_device *ndev,
 		}
 	}
 
+	if (profile->use_fwsup == BRCMF_PROFILE_FWSUP_1X)
+		brcmf_dbg(INFO, "using 1X offload\n");
+
 	if (!brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MFP))
 		goto skip_mfp_config;
 	/* The MFP mode (1 or 2) needs to be determined, parse IEs. The
@@ -1928,6 +1940,7 @@ static void brcmf_set_join_pref(struct brcmf_if *ifp,
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_cfg80211_profile *profile = &ifp->vif->profile;
 	struct ieee80211_channel *chan = sme->channel;
 	struct brcmf_join_params join_params;
 	size_t join_params_size;
@@ -2025,16 +2038,24 @@ static void brcmf_set_join_pref(struct brcmf_if *ifp,
 	}
 
 	if (sme->crypto.psk) {
+		if (WARN_ON(profile->use_fwsup != BRCMF_PROFILE_FWSUP_NONE)) {
+			err = -EINVAL;
+			goto done;
+		}
 		brcmf_dbg(INFO, "using PSK offload\n");
+		profile->use_fwsup = BRCMF_PROFILE_FWSUP_PSK;
+	}
 
+	if (profile->use_fwsup != BRCMF_PROFILE_FWSUP_NONE) {
 		/* enable firmware supplicant for this interface */
 		err = brcmf_fil_iovar_int_set(ifp, "sup_wpa", 1);
 		if (err < 0) {
 			brcmf_err("failed to enable fw supplicant\n");
 			goto done;
 		}
-		ifp->vif->profile.use_fwsup = BRCMF_PROFILE_FWSUP_PSK;
+	}
 
+	if (profile->use_fwsup == BRCMF_PROFILE_FWSUP_PSK) {
 		err = brcmf_set_pmk(ifp, sme->crypto.psk,
 				    BRCMF_WSEC_MAX_PSK_LEN);
 		if (err)
@@ -5173,6 +5194,34 @@ static int brcmf_cfg80211_tdls_oper(struct wiphy *wiphy,
 }
 #endif
 
+static int brcmf_cfg80211_set_pmk(struct wiphy *wiphy, struct net_device *dev,
+				  const struct cfg80211_pmk_conf *conf)
+{
+	struct brcmf_if *ifp;
+
+	brcmf_dbg(TRACE, "enter\n");
+
+	/* expect using firmware supplicant for 1X */
+	ifp = netdev_priv(dev);
+	if (WARN_ON(ifp->vif->profile.use_fwsup != BRCMF_PROFILE_FWSUP_1X))
+		return -EINVAL;
+
+	return brcmf_set_pmk(ifp, conf->pmk, conf->pmk_len);
+}
+
+static int brcmf_cfg80211_del_pmk(struct wiphy *wiphy, struct net_device *dev,
+				  const u8 *aa)
+{
+	struct brcmf_if *ifp;
+
+	brcmf_dbg(TRACE, "enter\n");
+	ifp = netdev_priv(dev);
+	if (WARN_ON(ifp->vif->profile.use_fwsup != BRCMF_PROFILE_FWSUP_1X))
+		return -EINVAL;
+
+	return brcmf_set_pmk(ifp, NULL, 0);
+}
+
 static struct cfg80211_ops brcmf_cfg80211_ops = {
 	.add_virtual_intf = brcmf_cfg80211_add_iface,
 	.del_virtual_intf = brcmf_cfg80211_del_iface,
@@ -5216,6 +5265,8 @@ static int brcmf_cfg80211_tdls_oper(struct wiphy *wiphy,
 	.crit_proto_stop = brcmf_cfg80211_crit_proto_stop,
 	.tdls_oper = brcmf_cfg80211_tdls_oper,
 	.update_connect_params = brcmf_cfg80211_update_conn_params,
+	.set_pmk = brcmf_cfg80211_set_pmk,
+	.del_pmk = brcmf_cfg80211_del_pmk,
 };
 
 struct brcmf_cfg80211_vif *brcmf_alloc_vif(struct brcmf_cfg80211_info *cfg,
@@ -5276,7 +5327,8 @@ static bool brcmf_is_linkup(struct brcmf_cfg80211_vif *vif,
 	u32 event = e->event_code;
 	u32 status = e->status;
 
-	if (event == BRCMF_E_PSK_SUP &&
+	if (vif->profile.use_fwsup == BRCMF_PROFILE_FWSUP_PSK &&
+	    event == BRCMF_E_PSK_SUP &&
 	    status == BRCMF_E_STATUS_FWSUP_COMPLETED)
 		set_bit(BRCMF_VIF_STATUS_EAP_SUCCESS, &vif->sme_state);
 	if (event == BRCMF_E_SET_SSID && status == BRCMF_E_STATUS_SUCCESS) {
@@ -6545,9 +6597,12 @@ static int brcmf_setup_wiphy(struct wiphy *wiphy, struct brcmf_if *ifp)
 		wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS;
 	if (!ifp->drvr->settings->roamoff)
 		wiphy->flags |= WIPHY_FLAG_SUPPORTS_FW_ROAM;
-	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_FWSUP))
+	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_FWSUP)) {
 		wiphy_ext_feature_set(wiphy,
 				      NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_PSK);
+		wiphy_ext_feature_set(wiphy,
+				      NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_1X);
+	}
 	wiphy->mgmt_stypes = brcmf_txrx_stypes;
 	wiphy->max_remain_on_channel_duration = 5000;
 	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_PNO))
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
index 779e9b5..c6b6fbb 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
@@ -115,7 +115,8 @@ struct brcmf_cfg80211_security {
 
 enum brcmf_profile_fwsup {
 	BRCMF_PROFILE_FWSUP_NONE,
-	BRCMF_PROFILE_FWSUP_PSK
+	BRCMF_PROFILE_FWSUP_PSK,
+	BRCMF_PROFILE_FWSUP_1X
 };
 
 /**
-- 
1.9.1
