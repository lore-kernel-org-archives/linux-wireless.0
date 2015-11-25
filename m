Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:1707 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbbKYKcw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2015 05:32:52 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 01/11] brcmfmac: Cleanup ssid storage.
Date: Wed, 25 Nov 2015 11:32:37 +0100
Message-ID: <1448447567-12189-2-git-send-email-arend@broadcom.com> (sfid-20151125_115251_890410_DF81422C)
In-Reply-To: <1448447567-12189-1-git-send-email-arend@broadcom.com>
References: <1448447567-12189-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

SSIDs used for connect and p2p got stored, but never used.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 41 ++++++++--------------
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         |  2 --
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       |  7 +---
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 20 +++++------
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.h |  2 --
 5 files changed, 24 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 998c521..49dfc00 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -960,7 +960,7 @@ brcmf_run_escan(struct brcmf_cfg80211_info *cfg, struct brcmf_if *ifp,
 		params_size += sizeof(u32) * ((request->n_channels + 1) / 2);
 
 		/* Allocate space for populating ssids in struct */
-		params_size += sizeof(struct brcmf_ssid) * request->n_ssids;
+		params_size += sizeof(struct brcmf_ssid_le) * request->n_ssids;
 	}
 
 	params = kzalloc(params_size, GFP_KERNEL);
@@ -1292,6 +1292,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 	s32 wsec = 0;
 	s32 bcnprd;
 	u16 chanspec;
+	u32 ssid_len;
 
 	brcmf_dbg(TRACE, "Enter\n");
 	if (!check_vif_up(ifp->vif))
@@ -1369,17 +1370,15 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 	memset(&join_params, 0, sizeof(struct brcmf_join_params));
 
 	/* SSID */
-	profile->ssid.SSID_len = min_t(u32, params->ssid_len, 32);
-	memcpy(profile->ssid.SSID, params->ssid, profile->ssid.SSID_len);
-	memcpy(join_params.ssid_le.SSID, params->ssid, profile->ssid.SSID_len);
-	join_params.ssid_le.SSID_len = cpu_to_le32(profile->ssid.SSID_len);
+	ssid_len = min_t(u32, params->ssid_len, IEEE80211_MAX_SSID_LEN);
+	memcpy(join_params.ssid_le.SSID, params->ssid, ssid_len);
+	join_params.ssid_le.SSID_len = cpu_to_le32(ssid_len);
 	join_params_size = sizeof(join_params.ssid_le);
 
 	/* BSSID */
 	if (params->bssid) {
 		memcpy(join_params.params_le.bssid, params->bssid, ETH_ALEN);
-		join_params_size = sizeof(join_params.ssid_le) +
-				   BRCMF_ASSOC_PARAMS_FIXED_SIZE;
+		join_params_size += BRCMF_ASSOC_PARAMS_FIXED_SIZE;
 		memcpy(profile->bssid, params->bssid, ETH_ALEN);
 	} else {
 		eth_broadcast_addr(join_params.params_le.bssid);
@@ -1729,7 +1728,6 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct brcmf_cfg80211_profile *profile = &ifp->vif->profile;
 	struct ieee80211_channel *chan = sme->channel;
 	struct brcmf_join_params join_params;
 	size_t join_params_size;
@@ -1740,6 +1738,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 	struct brcmf_ext_join_params_le *ext_join_params;
 	u16 chanspec;
 	s32 err = 0;
+	u32 ssid_len;
 
 	brcmf_dbg(TRACE, "Enter\n");
 	if (!check_vif_up(ifp->vif))
@@ -1825,15 +1824,6 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 		goto done;
 	}
 
-	profile->ssid.SSID_len = min_t(u32, (u32)sizeof(profile->ssid.SSID),
-				       (u32)sme->ssid_len);
-	memcpy(&profile->ssid.SSID, sme->ssid, profile->ssid.SSID_len);
-	if (profile->ssid.SSID_len < IEEE80211_MAX_SSID_LEN) {
-		profile->ssid.SSID[profile->ssid.SSID_len] = 0;
-		brcmf_dbg(CONN, "SSID \"%s\", len (%d)\n", profile->ssid.SSID,
-			  profile->ssid.SSID_len);
-	}
-
 	/* Join with specific BSSID and cached SSID
 	 * If SSID is zero join based on BSSID only
 	 */
@@ -1846,9 +1836,12 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 		err = -ENOMEM;
 		goto done;
 	}
-	ext_join_params->ssid_le.SSID_len = cpu_to_le32(profile->ssid.SSID_len);
-	memcpy(&ext_join_params->ssid_le.SSID, sme->ssid,
-	       profile->ssid.SSID_len);
+	ssid_len = min_t(u32, sme->ssid_len, IEEE80211_MAX_SSID_LEN);
+	ext_join_params->ssid_le.SSID_len = cpu_to_le32(ssid_len);
+	memcpy(&ext_join_params->ssid_le.SSID, sme->ssid, ssid_len);
+	if (ssid_len < IEEE80211_MAX_SSID_LEN)
+		brcmf_dbg(CONN, "SSID \"%s\", len (%d)\n",
+			  ext_join_params->ssid_le.SSID, ssid_len);
 
 	/* Set up join scan parameters */
 	ext_join_params->scan_le.scan_type = -1;
@@ -1896,8 +1889,8 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 	memset(&join_params, 0, sizeof(join_params));
 	join_params_size = sizeof(join_params.ssid_le);
 
-	memcpy(&join_params.ssid_le.SSID, sme->ssid, profile->ssid.SSID_len);
-	join_params.ssid_le.SSID_len = cpu_to_le32(profile->ssid.SSID_len);
+	memcpy(&join_params.ssid_le.SSID, sme->ssid, ssid_len);
+	join_params.ssid_le.SSID_len = cpu_to_le32(ssid_len);
 
 	if (sme->bssid)
 		memcpy(join_params.params_le.bssid, sme->bssid, ETH_ALEN);
@@ -2776,9 +2769,7 @@ CleanUp:
 static s32 brcmf_update_bss_info(struct brcmf_cfg80211_info *cfg,
 				 struct brcmf_if *ifp)
 {
-	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ifp->ndev);
 	struct brcmf_bss_info_le *bi;
-	struct brcmf_ssid *ssid;
 	const struct brcmf_tlv *tim;
 	u16 beacon_interval;
 	u8 dtim_period;
@@ -2790,8 +2781,6 @@ static s32 brcmf_update_bss_info(struct brcmf_cfg80211_info *cfg,
 	if (brcmf_is_ibssmode(ifp->vif))
 		return err;
 
-	ssid = &profile->ssid;
-
 	*(__le32 *)cfg->extra_buf = cpu_to_le32(WL_EXTRA_BUF_MAX);
 	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_BSS_INFO,
 				     cfg->extra_buf, WL_EXTRA_BUF_MAX);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
index 6a878c8..98c8920 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
@@ -124,13 +124,11 @@ struct brcmf_cfg80211_security {
 /**
  * struct brcmf_cfg80211_profile - profile information.
  *
- * @ssid: ssid of associated/associating ap.
  * @bssid: bssid of joined/joining ibss.
  * @sec: security information.
  * @key: key information
  */
 struct brcmf_cfg80211_profile {
-	struct brcmf_ssid ssid;
 	u8 bssid[ETH_ALEN];
 	struct brcmf_cfg80211_security sec;
 	struct brcmf_wsec_key key[BRCMF_MAX_DEFAULT_KEYS];
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
index 92ee1ad..2bcd187 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
@@ -282,14 +282,9 @@ struct brcm_rateset_le {
 	u8 rates[BRCMF_MAXRATES_IN_SET];
 };
 
-struct brcmf_ssid {
-	u32 SSID_len;
-	unsigned char SSID[32];
-};
-
 struct brcmf_ssid_le {
 	__le32 SSID_len;
-	unsigned char SSID[32];
+	unsigned char SSID[IEEE80211_MAX_SSID_LEN];
 };
 
 struct brcmf_scan_params_le {
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index 98cf1d0..a5902c3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -642,7 +642,6 @@ static s32 brcmf_p2p_escan(struct brcmf_p2p_info *p2p, u32 num_chans,
 	struct brcmf_cfg80211_vif *vif;
 	struct brcmf_p2p_scan_le *p2p_params;
 	struct brcmf_scan_params_le *sparams;
-	struct brcmf_ssid ssid;
 
 	memsize += num_chans * sizeof(__le16);
 	memblk = kzalloc(memsize, GFP_KERNEL);
@@ -655,16 +654,16 @@ static s32 brcmf_p2p_escan(struct brcmf_p2p_info *p2p, u32 num_chans,
 		ret = -EINVAL;
 		goto exit;
 	}
+	p2p_params = (struct brcmf_p2p_scan_le *)memblk;
+	sparams = &p2p_params->eparams.params_le;
 
 	switch (search_state) {
 	case WL_P2P_DISC_ST_SEARCH:
 		/*
 		 * If we in SEARCH STATE, we don't need to set SSID explictly
-		 * because dongle use P2P WILDCARD internally by default
+		 * because dongle use P2P WILDCARD internally by default, use
+		 * null ssid, which it is already due to kzalloc.
 		 */
-		/* use null ssid */
-		ssid.SSID_len = 0;
-		memset(ssid.SSID, 0, sizeof(ssid.SSID));
 		break;
 	case WL_P2P_DISC_ST_SCAN:
 		/*
@@ -673,8 +672,10 @@ static s32 brcmf_p2p_escan(struct brcmf_p2p_info *p2p, u32 num_chans,
 		 * P2P WILDCARD because we just do broadcast scan unless
 		 * setting SSID.
 		 */
-		ssid.SSID_len = BRCMF_P2P_WILDCARD_SSID_LEN;
-		memcpy(ssid.SSID, BRCMF_P2P_WILDCARD_SSID, ssid.SSID_len);
+		sparams->ssid_le.SSID_len =
+				cpu_to_le32(BRCMF_P2P_WILDCARD_SSID_LEN);
+		memcpy(sparams->ssid_le.SSID, BRCMF_P2P_WILDCARD_SSID,
+		       BRCMF_P2P_WILDCARD_SSID_LEN);
 		break;
 	default:
 		brcmf_err(" invalid search state %d\n", search_state);
@@ -687,11 +688,9 @@ static s32 brcmf_p2p_escan(struct brcmf_p2p_info *p2p, u32 num_chans,
 	/*
 	 * set p2p scan parameters.
 	 */
-	p2p_params = (struct brcmf_p2p_scan_le *)memblk;
 	p2p_params->type = 'E';
 
 	/* determine the scan engine parameters */
-	sparams = &p2p_params->eparams.params_le;
 	sparams->bss_type = DOT11_BSSTYPE_ANY;
 	if (p2p->cfg->active_scan)
 		sparams->scan_type = 0;
@@ -699,9 +698,6 @@ static s32 brcmf_p2p_escan(struct brcmf_p2p_info *p2p, u32 num_chans,
 		sparams->scan_type = 1;
 
 	eth_broadcast_addr(sparams->bssid);
-	if (ssid.SSID_len)
-		memcpy(sparams->ssid_le.SSID, ssid.SSID, ssid.SSID_len);
-	sparams->ssid_le.SSID_len = cpu_to_le32(ssid.SSID_len);
 	sparams->home_time = cpu_to_le32(P2PAPI_SCAN_HOME_TIME_MS);
 
 	/*
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.h
index 5d49059..a3bd18c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.h
@@ -112,7 +112,6 @@ struct afx_hdl {
  * @int_addr: P2P interface address.
  * @bss_idx: informate for P2P bss types.
  * @listen_timer: timer for @WL_P2P_DISC_ST_LISTEN discover state.
- * @ssid: ssid for P2P GO.
  * @listen_channel: channel for @WL_P2P_DISC_ST_LISTEN discover state.
  * @remain_on_channel: contains copy of struct used by cfg80211.
  * @remain_on_channel_cookie: cookie counter for remain on channel cmd
@@ -133,7 +132,6 @@ struct brcmf_p2p_info {
 	u8 int_addr[ETH_ALEN];
 	struct p2p_bss bss_idx[P2PAPI_BSSCFG_MAX];
 	struct timer_list listen_timer;
-	struct brcmf_ssid ssid;
 	u8 listen_channel;
 	struct ieee80211_channel remain_on_channel;
 	u32 remain_on_channel_cookie;
-- 
1.9.1

