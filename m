Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4924 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969Ab2I0MSS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 08:18:18 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 10/11] brcmfmac: remove brcmf_read_prof() function
Date: Thu, 27 Sep 2012 14:17:56 +0200
Message-ID: <1348748277-21460-11-git-send-email-arend@broadcom.com> (sfid-20120927_141830_852555_8180DE78)
In-Reply-To: <1348748277-21460-1-git-send-email-arend@broadcom.com>
References: <1348748277-21460-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function brcmf_read_prof() provided access to fields
with brcmf_cfg80211_profile structure using a field id,
but the calling function can easily access that structure
directly. This patch removes the function.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   49 +++++++++-----------
 1 file changed, 22 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 1e1637a..d8af418 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -1285,20 +1285,6 @@ done:
 	return err;
 }
 
-static void *brcmf_read_prof(struct brcmf_cfg80211_info *cfg, s32 item)
-{
-	switch (item) {
-	case WL_PROF_SEC:
-		return &cfg->profile->sec;
-	case WL_PROF_BSSID:
-		return &cfg->profile->bssid;
-	case WL_PROF_SSID:
-		return &cfg->profile->ssid;
-	}
-	WL_ERR("invalid item (%d)\n", item);
-	return NULL;
-}
-
 static s32
 brcmf_update_prof(struct brcmf_cfg80211_info *cfg,
 		  const struct brcmf_event_msg *e, void *data, s32 item)
@@ -1557,6 +1543,7 @@ static s32 brcmf_set_wpa_version(struct net_device *ndev,
 				 struct cfg80211_connect_params *sme)
 {
 	struct brcmf_cfg80211_info *cfg = ndev_to_cfg(ndev);
+	struct brcmf_cfg80211_profile *profile = cfg->profile;
 	struct brcmf_cfg80211_security *sec;
 	s32 val = 0;
 	s32 err = 0;
@@ -1573,7 +1560,7 @@ static s32 brcmf_set_wpa_version(struct net_device *ndev,
 		WL_ERR("set wpa_auth failed (%d)\n", err);
 		return err;
 	}
-	sec = brcmf_read_prof(cfg, WL_PROF_SEC);
+	sec = &profile->sec;
 	sec->wpa_versions = sme->crypto.wpa_versions;
 	return err;
 }
@@ -1582,6 +1569,7 @@ static s32 brcmf_set_auth_type(struct net_device *ndev,
 			       struct cfg80211_connect_params *sme)
 {
 	struct brcmf_cfg80211_info *cfg = ndev_to_cfg(ndev);
+	struct brcmf_cfg80211_profile *profile = cfg->profile;
 	struct brcmf_cfg80211_security *sec;
 	s32 val = 0;
 	s32 err = 0;
@@ -1612,7 +1600,7 @@ static s32 brcmf_set_auth_type(struct net_device *ndev,
 		WL_ERR("set auth failed (%d)\n", err);
 		return err;
 	}
-	sec = brcmf_read_prof(cfg, WL_PROF_SEC);
+	sec = &profile->sec;
 	sec->auth_type = sme->auth_type;
 	return err;
 }
@@ -1622,6 +1610,7 @@ brcmf_set_set_cipher(struct net_device *ndev,
 		     struct cfg80211_connect_params *sme)
 {
 	struct brcmf_cfg80211_info *cfg = ndev_to_cfg(ndev);
+	struct brcmf_cfg80211_profile *profile = cfg->profile;
 	struct brcmf_cfg80211_security *sec;
 	s32 pval = 0;
 	s32 gval = 0;
@@ -1677,7 +1666,7 @@ brcmf_set_set_cipher(struct net_device *ndev,
 		return err;
 	}
 
-	sec = brcmf_read_prof(cfg, WL_PROF_SEC);
+	sec = &profile->sec;
 	sec->cipher_pairwise = sme->crypto.ciphers_pairwise[0];
 	sec->cipher_group = sme->crypto.cipher_group;
 
@@ -1688,6 +1677,7 @@ static s32
 brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 {
 	struct brcmf_cfg80211_info *cfg = ndev_to_cfg(ndev);
+	struct brcmf_cfg80211_profile *profile = cfg->profile;
 	struct brcmf_cfg80211_security *sec;
 	s32 val = 0;
 	s32 err = 0;
@@ -1733,7 +1723,7 @@ brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 			return err;
 		}
 	}
-	sec = brcmf_read_prof(cfg, WL_PROF_SEC);
+	sec = &profile->sec;
 	sec->wpa_auth = sme->crypto.akm_suites[0];
 
 	return err;
@@ -1744,6 +1734,7 @@ brcmf_set_sharedkey(struct net_device *ndev,
 		    struct cfg80211_connect_params *sme)
 {
 	struct brcmf_cfg80211_info *cfg = ndev_to_cfg(ndev);
+	struct brcmf_cfg80211_profile *profile = cfg->profile;
 	struct brcmf_cfg80211_security *sec;
 	struct brcmf_wsec_key key;
 	s32 val;
@@ -1755,7 +1746,7 @@ brcmf_set_sharedkey(struct net_device *ndev,
 	if (sme->key_len == 0)
 		return 0;
 
-	sec = brcmf_read_prof(cfg, WL_PROF_SEC);
+	sec = &profile->sec;
 	WL_CONN("wpa_versions 0x%x cipher_pairwise 0x%x\n",
 		sec->wpa_versions, sec->cipher_pairwise);
 
@@ -1903,6 +1894,7 @@ brcmf_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *ndev,
 		       u16 reason_code)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_cfg80211_profile *profile = cfg->profile;
 	struct brcmf_scb_val_le scbval;
 	s32 err = 0;
 
@@ -1912,7 +1904,7 @@ brcmf_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *ndev,
 
 	clear_bit(WL_STATUS_CONNECTED, &cfg->status);
 
-	memcpy(&scbval.ea, brcmf_read_prof(cfg, WL_PROF_BSSID), ETH_ALEN);
+	memcpy(&scbval.ea, &profile->bssid, ETH_ALEN);
 	scbval.val = cpu_to_le32(reason_code);
 	err = brcmf_exec_dcmd(ndev, BRCMF_C_DISASSOC, &scbval,
 			      sizeof(struct brcmf_scb_val_le));
@@ -2264,6 +2256,7 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev,
 {
 	struct key_params params;
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_cfg80211_profile *profile = cfg->profile;
 	struct brcmf_cfg80211_security *sec;
 	s32 wsec;
 	s32 err = 0;
@@ -2286,7 +2279,7 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev,
 	}
 	switch (wsec & ~SES_OW_ENABLED) {
 	case WEP_ENABLED:
-		sec = brcmf_read_prof(cfg, WL_PROF_SEC);
+		sec = &profile->sec;
 		if (sec->cipher_pairwise & WLAN_CIPHER_SUITE_WEP40) {
 			params.cipher = WLAN_CIPHER_SUITE_WEP40;
 			WL_CONN("WLAN_CIPHER_SUITE_WEP40\n");
@@ -2329,11 +2322,12 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 			   u8 *mac, struct station_info *sinfo)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_cfg80211_profile *profile = cfg->profile;
 	struct brcmf_scb_val_le scb_val;
 	int rssi;
 	s32 rate;
 	s32 err = 0;
-	u8 *bssid = brcmf_read_prof(cfg, WL_PROF_BSSID);
+	u8 *bssid = profile->bssid;
 	struct brcmf_sta_info_le *sta_info_le;
 
 	WL_TRACE("Enter, MAC %pM\n", mac);
@@ -2737,6 +2731,7 @@ brcmf_find_wpaie(u8 *parse, u32 len)
 
 static s32 brcmf_update_bss_info(struct brcmf_cfg80211_info *cfg)
 {
+	struct brcmf_cfg80211_profile *profile = cfg->profile;
 	struct brcmf_bss_info_le *bi;
 	struct brcmf_ssid *ssid;
 	struct brcmf_tlv *tim;
@@ -2750,7 +2745,7 @@ static s32 brcmf_update_bss_info(struct brcmf_cfg80211_info *cfg)
 	if (brcmf_is_ibssmode(cfg))
 		return err;
 
-	ssid = (struct brcmf_ssid *)brcmf_read_prof(cfg, WL_PROF_SSID);
+	ssid = &profile->ssid;
 
 	*(__le32 *)cfg->extra_buf = cpu_to_le32(WL_EXTRA_BUF_MAX);
 	err = brcmf_exec_dcmd(cfg_to_ndev(cfg), BRCMF_C_GET_BSS_INFO,
@@ -4650,6 +4645,7 @@ brcmf_bss_roaming_done(struct brcmf_cfg80211_info *cfg,
 		       struct net_device *ndev,
 		       const struct brcmf_event_msg *e)
 {
+	struct brcmf_cfg80211_profile *profile = cfg->profile;
 	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg);
 	struct wiphy *wiphy = cfg_to_wiphy(cfg);
 	struct brcmf_channel_info_le channel_le;
@@ -4679,8 +4675,7 @@ brcmf_bss_roaming_done(struct brcmf_cfg80211_info *cfg,
 	freq = ieee80211_channel_to_frequency(target_channel, band->band);
 	notify_channel = ieee80211_get_channel(wiphy, freq);
 
-	cfg80211_roamed(ndev, notify_channel,
-			(u8 *)brcmf_read_prof(cfg, WL_PROF_BSSID),
+	cfg80211_roamed(ndev, notify_channel, (u8 *)profile->bssid,
 			conn_info->req_ie, conn_info->req_ie_len,
 			conn_info->resp_ie, conn_info->resp_ie_len, GFP_KERNEL);
 	WL_CONN("Report roaming result\n");
@@ -4695,6 +4690,7 @@ brcmf_bss_connect_done(struct brcmf_cfg80211_info *cfg,
 		       struct net_device *ndev, const struct brcmf_event_msg *e,
 		       bool completed)
 {
+	struct brcmf_cfg80211_profile *profile = cfg->profile;
 	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg);
 	s32 err = 0;
 
@@ -4708,8 +4704,7 @@ brcmf_bss_connect_done(struct brcmf_cfg80211_info *cfg,
 			brcmf_update_bss_info(cfg);
 		}
 		cfg80211_connect_result(ndev,
-					(u8 *)brcmf_read_prof(cfg,
-							      WL_PROF_BSSID),
+					(u8 *)profile->bssid,
 					conn_info->req_ie,
 					conn_info->req_ie_len,
 					conn_info->resp_ie,
-- 
1.7.9.5


