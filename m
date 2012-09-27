Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4917 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579Ab2I0MSS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 08:18:18 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 11/11] brcmfmac: remove brcmf_update_prof() function
Date: Thu, 27 Sep 2012 14:17:57 +0200
Message-ID: <1348748277-21460-12-git-send-email-arend@broadcom.com> (sfid-20120927_141832_243397_DBB349ED)
In-Reply-To: <1348748277-21460-1-git-send-email-arend@broadcom.com>
References: <1348748277-21460-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function brcmf_update_prof() only add complexity that is not
needed.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   81 +++++---------------
 1 file changed, 19 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index d8af418..619c932 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -1285,47 +1285,6 @@ done:
 	return err;
 }
 
-static s32
-brcmf_update_prof(struct brcmf_cfg80211_info *cfg,
-		  const struct brcmf_event_msg *e, void *data, s32 item)
-{
-	s32 err = 0;
-	struct brcmf_ssid *ssid;
-
-	switch (item) {
-	case WL_PROF_SSID:
-		ssid = (struct brcmf_ssid *) data;
-		memset(cfg->profile->ssid.SSID, 0,
-		       sizeof(cfg->profile->ssid.SSID));
-		memcpy(cfg->profile->ssid.SSID,
-		       ssid->SSID, ssid->SSID_len);
-		cfg->profile->ssid.SSID_len = ssid->SSID_len;
-		break;
-	case WL_PROF_BSSID:
-		if (data)
-			memcpy(cfg->profile->bssid, data, ETH_ALEN);
-		else
-			memset(cfg->profile->bssid, 0, ETH_ALEN);
-		break;
-	case WL_PROF_SEC:
-		memcpy(&cfg->profile->sec, data,
-		       sizeof(cfg->profile->sec));
-		break;
-	case WL_PROF_BEACONINT:
-		cfg->profile->beacon_interval = *(u16 *)data;
-		break;
-	case WL_PROF_DTIMPERIOD:
-		cfg->profile->dtim_period = *(u8 *)data;
-		break;
-	default:
-		WL_ERR("unsupported item (%d)\n", item);
-		err = -EOPNOTSUPP;
-		break;
-	}
-
-	return err;
-}
-
 static void brcmf_init_prof(struct brcmf_cfg80211_profile *prof)
 {
 	memset(prof, 0, sizeof(*prof));
@@ -1381,12 +1340,12 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 		      struct cfg80211_ibss_params *params)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_cfg80211_profile *profile = cfg->profile;
 	struct brcmf_join_params join_params;
 	size_t join_params_size = 0;
 	s32 err = 0;
 	s32 wsec = 0;
 	s32 bcnprd;
-	struct brcmf_ssid ssid;
 
 	WL_TRACE("Enter\n");
 	if (!check_sys_up(wiphy))
@@ -1462,25 +1421,23 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 	memset(&join_params, 0, sizeof(struct brcmf_join_params));
 
 	/* SSID */
-	ssid.SSID_len = min_t(u32, params->ssid_len, 32);
-	memcpy(ssid.SSID, params->ssid, ssid.SSID_len);
-	memcpy(join_params.ssid_le.SSID, params->ssid, ssid.SSID_len);
-	join_params.ssid_le.SSID_len = cpu_to_le32(ssid.SSID_len);
+	profile->ssid.SSID_len = min_t(u32, params->ssid_len, 32);
+	memcpy(profile->ssid.SSID, params->ssid, profile->ssid.SSID_len);
+	memcpy(join_params.ssid_le.SSID, params->ssid, profile->ssid.SSID_len);
+	join_params.ssid_le.SSID_len = cpu_to_le32(profile->ssid.SSID_len);
 	join_params_size = sizeof(join_params.ssid_le);
-	brcmf_update_prof(cfg, NULL, &ssid, WL_PROF_SSID);
 
 	/* BSSID */
 	if (params->bssid) {
 		memcpy(join_params.params_le.bssid, params->bssid, ETH_ALEN);
 		join_params_size = sizeof(join_params.ssid_le) +
 				   BRCMF_ASSOC_PARAMS_FIXED_SIZE;
+		memcpy(profile->bssid, params->bssid, ETH_ALEN);
 	} else {
 		memcpy(join_params.params_le.bssid, ether_bcast, ETH_ALEN);
+		memset(profile->bssid, 0, ETH_ALEN);
 	}
 
-	brcmf_update_prof(cfg, NULL,
-			  &join_params.params_le.bssid, WL_PROF_BSSID);
-
 	/* Channel */
 	if (params->channel) {
 		u32 target_channel;
@@ -1802,6 +1759,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 		    struct cfg80211_connect_params *sme)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_cfg80211_profile *profile = cfg->profile;
 	struct ieee80211_channel *chan = sme->channel;
 	struct brcmf_join_params join_params;
 	size_t join_params_size;
@@ -1863,11 +1821,11 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 	memset(&join_params, 0, sizeof(join_params));
 	join_params_size = sizeof(join_params.ssid_le);
 
-	ssid.SSID_len = min_t(u32, sizeof(ssid.SSID), (u32)sme->ssid_len);
-	memcpy(&join_params.ssid_le.SSID, sme->ssid, ssid.SSID_len);
-	memcpy(&ssid.SSID, sme->ssid, ssid.SSID_len);
-	join_params.ssid_le.SSID_len = cpu_to_le32(ssid.SSID_len);
-	brcmf_update_prof(cfg, NULL, &ssid, WL_PROF_SSID);
+	profile->ssid.SSID_len = min_t(u32,
+				       sizeof(ssid.SSID), (u32)sme->ssid_len);
+	memcpy(&join_params.ssid_le.SSID, sme->ssid, profile->ssid.SSID_len);
+	memcpy(&profile->ssid.SSID, sme->ssid, profile->ssid.SSID_len);
+	join_params.ssid_le.SSID_len = cpu_to_le32(profile->ssid.SSID_len);
 
 	memcpy(join_params.params_le.bssid, ether_bcast, ETH_ALEN);
 
@@ -2783,8 +2741,8 @@ static s32 brcmf_update_bss_info(struct brcmf_cfg80211_info *cfg)
 		dtim_period = (u8)var;
 	}
 
-	brcmf_update_prof(cfg, NULL, &beacon_interval, WL_PROF_BEACONINT);
-	brcmf_update_prof(cfg, NULL, &dtim_period, WL_PROF_DTIMPERIOD);
+	profile->beacon_interval = beacon_interval;
+	profile->dtim_period = dtim_period;
 
 update_bss_info_out:
 	WL_TRACE("Exit");
@@ -4658,7 +4616,7 @@ brcmf_bss_roaming_done(struct brcmf_cfg80211_info *cfg,
 	WL_TRACE("Enter\n");
 
 	brcmf_get_assoc_ies(cfg);
-	brcmf_update_prof(cfg, NULL, &e->addr, WL_PROF_BSSID);
+	memcpy(profile->bssid, e->addr, ETH_ALEN);
 	brcmf_update_bss_info(cfg);
 
 	brcmf_exec_dcmd(ndev, BRCMF_C_GET_CHANNEL, &channel_le,
@@ -4699,8 +4657,7 @@ brcmf_bss_connect_done(struct brcmf_cfg80211_info *cfg,
 	if (test_and_clear_bit(WL_STATUS_CONNECTING, &cfg->status)) {
 		if (completed) {
 			brcmf_get_assoc_ies(cfg);
-			brcmf_update_prof(cfg, NULL, &e->addr,
-					  WL_PROF_BSSID);
+			memcpy(profile->bssid, e->addr, ETH_ALEN);
 			brcmf_update_bss_info(cfg);
 		}
 		cfg80211_connect_result(ndev,
@@ -4765,6 +4722,7 @@ brcmf_notify_connect_status(struct brcmf_cfg80211_info *cfg,
 			    struct net_device *ndev,
 			    const struct brcmf_event_msg *e, void *data)
 {
+	struct brcmf_cfg80211_profile *profile = cfg->profile;
 	s32 err = 0;
 
 	if (cfg->conf->mode == WL_MODE_AP) {
@@ -4772,8 +4730,7 @@ brcmf_notify_connect_status(struct brcmf_cfg80211_info *cfg,
 	} else if (brcmf_is_linkup(cfg, e)) {
 		WL_CONN("Linkup\n");
 		if (brcmf_is_ibssmode(cfg)) {
-			brcmf_update_prof(cfg, NULL, (void *)e->addr,
-				WL_PROF_BSSID);
+			memcpy(profile->bssid, e->addr, ETH_ALEN);
 			wl_inform_ibss(cfg, ndev, e->addr);
 			cfg80211_ibss_joined(ndev, e->addr, GFP_KERNEL);
 			clear_bit(WL_STATUS_CONNECTING, &cfg->status);
-- 
1.7.9.5


