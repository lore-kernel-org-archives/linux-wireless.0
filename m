Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:36392 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932695AbaFQJQr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2014 05:16:47 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [RFC 3/3] brcmfmac: update band and regulatory info before wiphy_register()
Date: Tue, 17 Jun 2014 11:16:21 +0200
Message-ID: <1402996581-10764-4-git-send-email-arend@broadcom.com> (sfid-20140617_111657_800334_0CC69B11)
In-Reply-To: <1402996581-10764-1-git-send-email-arend@broadcom.com>
References: <1402996581-10764-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The band information was determined when bringing up the wireless
interface. According description of wiphy_apply_custom_regulatory()
it should be called before wiphy_register(). Currently, the driver
calls the function twice. Once before calling wiphy_register() and
once upon bringing up the interface. This is changed so it will
determine band information and custom regulatory info before the
wiphy_register() call.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  | 93 ++++++++++------------
 1 file changed, 40 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 2464e7e..dbe391c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -191,7 +191,6 @@ static struct ieee80211_supported_band __wl_band_2ghz = {
 	.n_channels = ARRAY_SIZE(__wl_2ghz_channels),
 	.bitrates = wl_g_rates,
 	.n_bitrates = wl_g_rates_size,
-	.ht_cap = {IEEE80211_HT_CAP_SUP_WIDTH_20_40, true},
 };
 
 static struct ieee80211_supported_band __wl_band_5ghz_a = {
@@ -4377,7 +4376,6 @@ brcmf_txrx_stypes[NUM_NL80211_IFTYPES] = {
 static struct wiphy *brcmf_setup_wiphy(struct device *phydev)
 {
 	struct wiphy *wiphy;
-	s32 err = 0;
 
 	wiphy = wiphy_new(&wl_cfg80211_ops, sizeof(struct brcmf_cfg80211_info));
 	if (!wiphy) {
@@ -4409,15 +4407,6 @@ static struct wiphy *brcmf_setup_wiphy(struct device *phydev)
 	wiphy->mgmt_stypes = brcmf_txrx_stypes;
 	wiphy->max_remain_on_channel_duration = 5000;
 	brcmf_wiphy_pno_params(wiphy);
-	brcmf_dbg(INFO, "Registering custom regulatory\n");
-	wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG;
-	wiphy_apply_custom_regulatory(wiphy, &brcmf_regdom);
-	err = wiphy_register(wiphy);
-	if (err < 0) {
-		brcmf_err("Could not register wiphy device (%d)\n", err);
-		wiphy_free(wiphy);
-		return ERR_PTR(err);
-	}
 	return wiphy;
 }
 
@@ -5397,17 +5386,11 @@ static s32 brcmf_update_wiphybands(struct brcmf_cfg80211_info *cfg)
 	wiphy = cfg_to_wiphy(cfg);
 	wiphy->bands[IEEE80211_BAND_2GHZ] = bands[IEEE80211_BAND_2GHZ];
 	wiphy->bands[IEEE80211_BAND_5GHZ] = bands[IEEE80211_BAND_5GHZ];
-	wiphy_apply_custom_regulatory(wiphy, &brcmf_regdom);
 
 	return err;
 }
 
 
-static s32 brcmf_dongle_probecap(struct brcmf_cfg80211_info *cfg)
-{
-	return brcmf_update_wiphybands(cfg);
-}
-
 static s32 brcmf_config_dongle(struct brcmf_cfg80211_info *cfg)
 {
 	struct net_device *ndev;
@@ -5443,9 +5426,6 @@ static s32 brcmf_config_dongle(struct brcmf_cfg80211_info *cfg)
 					  NULL, NULL);
 	if (err)
 		goto default_conf_out;
-	err = brcmf_dongle_probecap(cfg);
-	if (err)
-		goto default_conf_out;
 
 	brcmf_configure_arp_offload(ifp, true);
 
@@ -5602,10 +5582,8 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 	INIT_LIST_HEAD(&cfg->vif_list);
 
 	vif = brcmf_alloc_vif(cfg, NL80211_IFTYPE_STATION, false);
-	if (IS_ERR(vif)) {
-		wiphy_free(wiphy);
-		return NULL;
-	}
+	if (IS_ERR(vif))
+		goto wiphy_out;
 
 	vif->ifp = ifp;
 	vif->wdev.netdev = ndev;
@@ -5615,35 +5593,51 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 	err = wl_init_priv(cfg);
 	if (err) {
 		brcmf_err("Failed to init iwm_priv (%d)\n", err);
-		goto cfg80211_attach_out;
+		brcmf_free_vif(vif);
+		goto wiphy_out;
 	}
 	ifp->vif = vif;
 
+	if (wiphy_is_40mhz_24ghz_disabled(wiphy) == false) {
+		err = brcmf_enable_bw40_2g(ifp);
+		if (!err)
+			err = brcmf_fil_iovar_int_set(ifp, "obss_coex",
+						      BRCMF_OBSS_COEX_AUTO);
+	}
+
+	/* determine d11 io type before updating bands */
+	err = brcmf_fil_cmd_int_get(ifp, BRCMF_C_GET_VERSION, &io_type);
+	if (err) {
+		brcmf_err("Failed to get D11 version (%d)\n", err);
+		goto priv_out;
+	}
+	cfg->d11inf.io_type = (u8)io_type;
+	brcmu_d11_attach(&cfg->d11inf);
+
+	err = brcmf_update_wiphybands(cfg);
+	if (err)
+		goto priv_out;
+
+	brcmf_dbg(INFO, "Registering custom regulatory\n");
+	wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG;
+	wiphy_apply_custom_regulatory(wiphy, &brcmf_regdom);
+	err = wiphy_register(wiphy);
+	if (err < 0) {
+		brcmf_err("Could not register wiphy device (%d)\n", err);
+		goto priv_out;
+	}
+
 	err = brcmf_p2p_attach(cfg);
 	if (err) {
 		brcmf_err("P2P initilisation failed (%d)\n", err);
-		goto cfg80211_p2p_attach_out;
+		goto unreg_out;
 	}
 	err = brcmf_btcoex_attach(cfg);
 	if (err) {
 		brcmf_err("BT-coex initialisation failed (%d)\n", err);
 		brcmf_p2p_detach(&cfg->p2p);
-		goto cfg80211_p2p_attach_out;
-	}
-
-	/* If cfg80211 didn't disable 40MHz HT CAP in wiphy_register(),
-	 * setup 40MHz in 2GHz band and enable OBSS scanning.
-	 */
-	if (wiphy->bands[IEEE80211_BAND_2GHZ]->ht_cap.cap &
-	    IEEE80211_HT_CAP_SUP_WIDTH_20_40) {
-		err = brcmf_enable_bw40_2g(ifp);
-		if (!err)
-			err = brcmf_fil_iovar_int_set(ifp, "obss_coex",
-						      BRCMF_OBSS_COEX_AUTO);
+		goto unreg_out;
 	}
-	/* clear for now and rely on update later */
-	wiphy->bands[IEEE80211_BAND_2GHZ]->ht_cap.ht_supported = false;
-	wiphy->bands[IEEE80211_BAND_2GHZ]->ht_cap.cap = 0;
 
 	err = brcmf_fil_iovar_int_set(ifp, "tdls_enable", 1);
 	if (err) {
@@ -5651,22 +5645,15 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 		wiphy->flags &= ~WIPHY_FLAG_SUPPORTS_TDLS;
 	}
 
-	err = brcmf_fil_cmd_int_get(ifp, BRCMF_C_GET_VERSION,
-				    &io_type);
-	if (err) {
-		brcmf_err("Failed to get D11 version (%d)\n", err);
-		goto cfg80211_p2p_attach_out;
-	}
-	cfg->d11inf.io_type = (u8)io_type;
-	brcmu_d11_attach(&cfg->d11inf);
-
 	return cfg;
 
-cfg80211_p2p_attach_out:
+unreg_out:
+	wiphy_unregister(wiphy);
+priv_out:
 	wl_deinit_priv(cfg);
-
-cfg80211_attach_out:
 	brcmf_free_vif(vif);
+wiphy_out:
+	wiphy_free(wiphy);
 	return NULL;
 }
 
-- 
1.9.1

