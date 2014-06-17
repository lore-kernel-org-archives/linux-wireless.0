Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:36040 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932652AbaFQJQs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2014 05:16:48 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [RFC 1/3] brcmfmac: move attach and detach functions in wl_cfg80211.c
Date: Tue, 17 Jun 2014 11:16:19 +0200
Message-ID: <1402996581-10764-2-git-send-email-arend@broadcom.com> (sfid-20140617_111700_359060_3F5A34E3)
In-Reply-To: <1402996581-10764-1-git-send-email-arend@broadcom.com>
References: <1402996581-10764-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simply moving the functions so subsequent patches are more clear.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  | 213 +++++++++++----------
 1 file changed, 108 insertions(+), 105 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index d8fa276..2464e7e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -4990,111 +4990,6 @@ static int brcmf_enable_bw40_2g(struct brcmf_if *ifp)
 	return err;
 }
 
-struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
-						  struct device *busdev)
-{
-	struct net_device *ndev = drvr->iflist[0]->ndev;
-	struct brcmf_cfg80211_info *cfg;
-	struct wiphy *wiphy;
-	struct brcmf_cfg80211_vif *vif;
-	struct brcmf_if *ifp;
-	s32 err = 0;
-	s32 io_type;
-
-	if (!ndev) {
-		brcmf_err("ndev is invalid\n");
-		return NULL;
-	}
-
-	ifp = netdev_priv(ndev);
-	wiphy = brcmf_setup_wiphy(busdev);
-	if (IS_ERR(wiphy))
-		return NULL;
-
-	cfg = wiphy_priv(wiphy);
-	cfg->wiphy = wiphy;
-	cfg->pub = drvr;
-	init_vif_event(&cfg->vif_event);
-	INIT_LIST_HEAD(&cfg->vif_list);
-
-	vif = brcmf_alloc_vif(cfg, NL80211_IFTYPE_STATION, false);
-	if (IS_ERR(vif)) {
-		wiphy_free(wiphy);
-		return NULL;
-	}
-
-	vif->ifp = ifp;
-	vif->wdev.netdev = ndev;
-	ndev->ieee80211_ptr = &vif->wdev;
-	SET_NETDEV_DEV(ndev, wiphy_dev(cfg->wiphy));
-
-	err = wl_init_priv(cfg);
-	if (err) {
-		brcmf_err("Failed to init iwm_priv (%d)\n", err);
-		goto cfg80211_attach_out;
-	}
-	ifp->vif = vif;
-
-	err = brcmf_p2p_attach(cfg);
-	if (err) {
-		brcmf_err("P2P initilisation failed (%d)\n", err);
-		goto cfg80211_p2p_attach_out;
-	}
-	err = brcmf_btcoex_attach(cfg);
-	if (err) {
-		brcmf_err("BT-coex initialisation failed (%d)\n", err);
-		brcmf_p2p_detach(&cfg->p2p);
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
-	}
-
-	err = brcmf_fil_iovar_int_set(ifp, "tdls_enable", 1);
-	if (err) {
-		brcmf_dbg(INFO, "TDLS not enabled (%d)\n", err);
-		wiphy->flags &= ~WIPHY_FLAG_SUPPORTS_TDLS;
-	}
-
-	err = brcmf_fil_cmd_int_get(ifp, BRCMF_C_GET_VERSION,
-				    &io_type);
-	if (err) {
-		brcmf_err("Failed to get D11 version (%d)\n", err);
-		goto cfg80211_p2p_attach_out;
-	}
-	cfg->d11inf.io_type = (u8)io_type;
-	brcmu_d11_attach(&cfg->d11inf);
-
-	return cfg;
-
-cfg80211_p2p_attach_out:
-	wl_deinit_priv(cfg);
-
-cfg80211_attach_out:
-	brcmf_free_vif(vif);
-	return NULL;
-}
-
-void brcmf_cfg80211_detach(struct brcmf_cfg80211_info *cfg)
-{
-	if (!cfg)
-		return;
-
-	WARN_ON(!list_empty(&cfg->vif_list));
-	wiphy_unregister(cfg->wiphy);
-	brcmf_btcoex_detach(cfg);
-	wl_deinit_priv(cfg);
-	wiphy_free(cfg->wiphy);
-}
-
 static s32
 brcmf_dongle_roam(struct brcmf_if *ifp, u32 bcn_timeout)
 {
@@ -5679,3 +5574,111 @@ int brcmf_cfg80211_wait_vif_event_timeout(struct brcmf_cfg80211_info *cfg,
 				  vif_event_equals(event, action), timeout);
 }
 
+struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
+						  struct device *busdev)
+{
+	struct net_device *ndev = drvr->iflist[0]->ndev;
+	struct brcmf_cfg80211_info *cfg;
+	struct wiphy *wiphy;
+	struct brcmf_cfg80211_vif *vif;
+	struct brcmf_if *ifp;
+	s32 err = 0;
+	s32 io_type;
+
+	if (!ndev) {
+		brcmf_err("ndev is invalid\n");
+		return NULL;
+	}
+
+	ifp = netdev_priv(ndev);
+	wiphy = brcmf_setup_wiphy(busdev);
+	if (IS_ERR(wiphy))
+		return NULL;
+
+	cfg = wiphy_priv(wiphy);
+	cfg->wiphy = wiphy;
+	cfg->pub = drvr;
+	init_vif_event(&cfg->vif_event);
+	INIT_LIST_HEAD(&cfg->vif_list);
+
+	vif = brcmf_alloc_vif(cfg, NL80211_IFTYPE_STATION, false);
+	if (IS_ERR(vif)) {
+		wiphy_free(wiphy);
+		return NULL;
+	}
+
+	vif->ifp = ifp;
+	vif->wdev.netdev = ndev;
+	ndev->ieee80211_ptr = &vif->wdev;
+	SET_NETDEV_DEV(ndev, wiphy_dev(cfg->wiphy));
+
+	err = wl_init_priv(cfg);
+	if (err) {
+		brcmf_err("Failed to init iwm_priv (%d)\n", err);
+		goto cfg80211_attach_out;
+	}
+	ifp->vif = vif;
+
+	err = brcmf_p2p_attach(cfg);
+	if (err) {
+		brcmf_err("P2P initilisation failed (%d)\n", err);
+		goto cfg80211_p2p_attach_out;
+	}
+	err = brcmf_btcoex_attach(cfg);
+	if (err) {
+		brcmf_err("BT-coex initialisation failed (%d)\n", err);
+		brcmf_p2p_detach(&cfg->p2p);
+		goto cfg80211_p2p_attach_out;
+	}
+
+	/* If cfg80211 didn't disable 40MHz HT CAP in wiphy_register(),
+	 * setup 40MHz in 2GHz band and enable OBSS scanning.
+	 */
+	if (wiphy->bands[IEEE80211_BAND_2GHZ]->ht_cap.cap &
+	    IEEE80211_HT_CAP_SUP_WIDTH_20_40) {
+		err = brcmf_enable_bw40_2g(ifp);
+		if (!err)
+			err = brcmf_fil_iovar_int_set(ifp, "obss_coex",
+						      BRCMF_OBSS_COEX_AUTO);
+	}
+	/* clear for now and rely on update later */
+	wiphy->bands[IEEE80211_BAND_2GHZ]->ht_cap.ht_supported = false;
+	wiphy->bands[IEEE80211_BAND_2GHZ]->ht_cap.cap = 0;
+
+	err = brcmf_fil_iovar_int_set(ifp, "tdls_enable", 1);
+	if (err) {
+		brcmf_dbg(INFO, "TDLS not enabled (%d)\n", err);
+		wiphy->flags &= ~WIPHY_FLAG_SUPPORTS_TDLS;
+	}
+
+	err = brcmf_fil_cmd_int_get(ifp, BRCMF_C_GET_VERSION,
+				    &io_type);
+	if (err) {
+		brcmf_err("Failed to get D11 version (%d)\n", err);
+		goto cfg80211_p2p_attach_out;
+	}
+	cfg->d11inf.io_type = (u8)io_type;
+	brcmu_d11_attach(&cfg->d11inf);
+
+	return cfg;
+
+cfg80211_p2p_attach_out:
+	wl_deinit_priv(cfg);
+
+cfg80211_attach_out:
+	brcmf_free_vif(vif);
+	return NULL;
+}
+
+void brcmf_cfg80211_detach(struct brcmf_cfg80211_info *cfg)
+{
+	if (!cfg)
+		return;
+
+	WARN_ON(!list_empty(&cfg->vif_list));
+	wiphy_unregister(cfg->wiphy);
+	brcmf_btcoex_detach(cfg);
+	wl_deinit_priv(cfg);
+	wiphy_free(cfg->wiphy);
+}
+
-- 
1.9.1

