Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:27722 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaGLGtr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jul 2014 02:49:47 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 7/9] brcmfmac: moving some functions around
Date: Sat, 12 Jul 2014 08:49:40 +0200
Message-ID: <1405147782-12768-8-git-send-email-arend@broadcom.com> (sfid-20140712_085005_033342_D1A37D11)
In-Reply-To: <1405147782-12768-1-git-send-email-arend@broadcom.com>
References: <1405147782-12768-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just reordering the functions in preparation of subsequent changes.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  | 288 ++++++++++-----------
 1 file changed, 144 insertions(+), 144 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index c1695cf..f1501a2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -4278,126 +4278,6 @@ static struct cfg80211_ops wl_cfg80211_ops = {
 	.tdls_oper = brcmf_cfg80211_tdls_oper,
 };
 
-static void brcmf_wiphy_pno_params(struct wiphy *wiphy)
-{
-	/* scheduled scan settings */
-	wiphy->max_sched_scan_ssids = BRCMF_PNO_MAX_PFN_COUNT;
-	wiphy->max_match_sets = BRCMF_PNO_MAX_PFN_COUNT;
-	wiphy->max_sched_scan_ie_len = BRCMF_SCAN_IE_LEN_MAX;
-	wiphy->flags |= WIPHY_FLAG_SUPPORTS_SCHED_SCAN;
-}
-
-static const struct ieee80211_iface_limit brcmf_iface_limits[] = {
-	{
-		.max = 2,
-		.types = BIT(NL80211_IFTYPE_STATION) |
-			 BIT(NL80211_IFTYPE_ADHOC) |
-			 BIT(NL80211_IFTYPE_AP)
-	},
-	{
-		.max = 1,
-		.types = BIT(NL80211_IFTYPE_P2P_CLIENT) |
-			 BIT(NL80211_IFTYPE_P2P_GO)
-	},
-	{
-		.max = 1,
-		.types = BIT(NL80211_IFTYPE_P2P_DEVICE)
-	}
-};
-static struct ieee80211_iface_combination brcmf_iface_combos[] = {
-	{
-		 .max_interfaces = BRCMF_IFACE_MAX_CNT,
-		 .num_different_channels = 1,
-		 .n_limits = ARRAY_SIZE(brcmf_iface_limits),
-		 .limits = brcmf_iface_limits
-	}
-};
-
-static const struct ieee80211_txrx_stypes
-brcmf_txrx_stypes[NUM_NL80211_IFTYPES] = {
-	[NL80211_IFTYPE_STATION] = {
-		.tx = 0xffff,
-		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
-		      BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
-	},
-	[NL80211_IFTYPE_P2P_CLIENT] = {
-		.tx = 0xffff,
-		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
-		      BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
-	},
-	[NL80211_IFTYPE_P2P_GO] = {
-		.tx = 0xffff,
-		.rx = BIT(IEEE80211_STYPE_ASSOC_REQ >> 4) |
-		      BIT(IEEE80211_STYPE_REASSOC_REQ >> 4) |
-		      BIT(IEEE80211_STYPE_PROBE_REQ >> 4) |
-		      BIT(IEEE80211_STYPE_DISASSOC >> 4) |
-		      BIT(IEEE80211_STYPE_AUTH >> 4) |
-		      BIT(IEEE80211_STYPE_DEAUTH >> 4) |
-		      BIT(IEEE80211_STYPE_ACTION >> 4)
-	},
-	[NL80211_IFTYPE_P2P_DEVICE] = {
-		.tx = 0xffff,
-		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
-		      BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
-	}
-};
-
-static
-struct wiphy *brcmf_setup_wiphy(struct brcmf_if *ifp, struct device *phydev)
-{
-	struct wiphy *wiphy;
-	s32 err = 0;
-
-	wiphy = wiphy_new(&wl_cfg80211_ops, sizeof(struct brcmf_cfg80211_info));
-	if (!wiphy) {
-		brcmf_err("Could not allocate wiphy device\n");
-		return ERR_PTR(-ENOMEM);
-	}
-	set_wiphy_dev(wiphy, phydev);
-	wiphy->max_scan_ssids = WL_NUM_SCAN_MAX;
-	wiphy->max_scan_ie_len = BRCMF_SCAN_IE_LEN_MAX;
-	wiphy->max_num_pmkids = WL_NUM_PMKIDS_MAX;
-	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
-				 BIT(NL80211_IFTYPE_ADHOC) |
-				 BIT(NL80211_IFTYPE_AP) |
-				 BIT(NL80211_IFTYPE_P2P_CLIENT) |
-				 BIT(NL80211_IFTYPE_P2P_GO) |
-				 BIT(NL80211_IFTYPE_P2P_DEVICE);
-	/* need VSDB firmware feature for concurrent channels */
-	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MCHAN))
-		brcmf_iface_combos[0].num_different_channels = 2;
-	wiphy->iface_combinations = brcmf_iface_combos;
-	wiphy->n_iface_combinations = ARRAY_SIZE(brcmf_iface_combos);
-	wiphy->bands[IEEE80211_BAND_2GHZ] = &__wl_band_2ghz;
-	wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
-	wiphy->cipher_suites = __wl_cipher_suites;
-	wiphy->n_cipher_suites = ARRAY_SIZE(__wl_cipher_suites);
-	wiphy->flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT |
-			WIPHY_FLAG_OFFCHAN_TX |
-			WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
-			WIPHY_FLAG_SUPPORTS_TDLS;
-	if (!brcmf_roamoff)
-		wiphy->flags |= WIPHY_FLAG_SUPPORTS_FW_ROAM;
-	wiphy->mgmt_stypes = brcmf_txrx_stypes;
-	wiphy->max_remain_on_channel_duration = 5000;
-	brcmf_wiphy_pno_params(wiphy);
-	brcmf_dbg(INFO, "Registering custom regulatory\n");
-	wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG;
-	wiphy_apply_custom_regulatory(wiphy, &brcmf_regdom);
-
-	/* vendor commands/events support */
-	wiphy->vendor_commands = brcmf_vendor_cmds;
-	wiphy->n_vendor_commands = BRCMF_VNDR_CMDS_LAST - 1;
-
-	err = wiphy_register(wiphy);
-	if (err < 0) {
-		brcmf_err("Could not register wiphy device (%d)\n", err);
-		wiphy_free(wiphy);
-		return ERR_PTR(err);
-	}
-	return wiphy;
-}
-
 struct brcmf_cfg80211_vif *brcmf_alloc_vif(struct brcmf_cfg80211_info *cfg,
 					   enum nl80211_iftype type,
 					   bool pm_block)
@@ -4941,30 +4821,6 @@ static void init_vif_event(struct brcmf_cfg80211_vif_event *event)
 	mutex_init(&event->vif_event_lock);
 }
 
-static int brcmf_enable_bw40_2g(struct brcmf_if *ifp)
-{
-	struct brcmf_fil_bwcap_le band_bwcap;
-	u32 val;
-	int err;
-
-	/* verify support for bw_cap command */
-	val = WLC_BAND_5G;
-	err = brcmf_fil_iovar_int_get(ifp, "bw_cap", &val);
-
-	if (!err) {
-		/* only set 2G bandwidth using bw_cap command */
-		band_bwcap.band = cpu_to_le32(WLC_BAND_2G);
-		band_bwcap.bw_cap = cpu_to_le32(WLC_BW_CAP_40MHZ);
-		err = brcmf_fil_iovar_data_set(ifp, "bw_cap", &band_bwcap,
-					       sizeof(band_bwcap));
-	} else {
-		brcmf_dbg(INFO, "fallback to mimo_bw_cap\n");
-		val = WLC_N_BW_40ALL;
-		err = brcmf_fil_iovar_int_set(ifp, "mimo_bw_cap", val);
-	}
-	return err;
-}
-
 static s32
 brcmf_dongle_roam(struct brcmf_if *ifp, u32 bcn_timeout)
 {
@@ -5194,6 +5050,30 @@ exit:
 	return err;
 }
 
+static int brcmf_enable_bw40_2g(struct brcmf_if *ifp)
+{
+	struct brcmf_fil_bwcap_le band_bwcap;
+	u32 val;
+	int err;
+
+	/* verify support for bw_cap command */
+	val = WLC_BAND_5G;
+	err = brcmf_fil_iovar_int_get(ifp, "bw_cap", &val);
+
+	if (!err) {
+		/* only set 2G bandwidth using bw_cap command */
+		band_bwcap.band = cpu_to_le32(WLC_BAND_2G);
+		band_bwcap.bw_cap = cpu_to_le32(WLC_BW_CAP_40MHZ);
+		err = brcmf_fil_iovar_data_set(ifp, "bw_cap", &band_bwcap,
+					       sizeof(band_bwcap));
+	} else {
+		brcmf_dbg(INFO, "fallback to mimo_bw_cap\n");
+		val = WLC_N_BW_40ALL;
+		err = brcmf_fil_iovar_int_set(ifp, "mimo_bw_cap", val);
+	}
+	return err;
+}
+
 static void brcmf_get_bwcap(struct brcmf_if *ifp, u32 bw_cap[])
 {
 	u32 band, mimo_bwcap;
@@ -5377,6 +5257,126 @@ static s32 brcmf_update_wiphybands(struct brcmf_cfg80211_info *cfg)
 	return err;
 }
 
+static const struct ieee80211_iface_limit brcmf_iface_limits[] = {
+	{
+		.max = 2,
+		.types = BIT(NL80211_IFTYPE_STATION) |
+			 BIT(NL80211_IFTYPE_ADHOC) |
+			 BIT(NL80211_IFTYPE_AP)
+	},
+	{
+		.max = 1,
+		.types = BIT(NL80211_IFTYPE_P2P_CLIENT) |
+			 BIT(NL80211_IFTYPE_P2P_GO)
+	},
+	{
+		.max = 1,
+		.types = BIT(NL80211_IFTYPE_P2P_DEVICE)
+	}
+};
+static struct ieee80211_iface_combination brcmf_iface_combos[] = {
+	{
+		 .max_interfaces = BRCMF_IFACE_MAX_CNT,
+		 .num_different_channels = 1,
+		 .n_limits = ARRAY_SIZE(brcmf_iface_limits),
+		 .limits = brcmf_iface_limits
+	}
+};
+
+static const struct ieee80211_txrx_stypes
+brcmf_txrx_stypes[NUM_NL80211_IFTYPES] = {
+	[NL80211_IFTYPE_STATION] = {
+		.tx = 0xffff,
+		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+		      BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
+	},
+	[NL80211_IFTYPE_P2P_CLIENT] = {
+		.tx = 0xffff,
+		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+		      BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
+	},
+	[NL80211_IFTYPE_P2P_GO] = {
+		.tx = 0xffff,
+		.rx = BIT(IEEE80211_STYPE_ASSOC_REQ >> 4) |
+		      BIT(IEEE80211_STYPE_REASSOC_REQ >> 4) |
+		      BIT(IEEE80211_STYPE_PROBE_REQ >> 4) |
+		      BIT(IEEE80211_STYPE_DISASSOC >> 4) |
+		      BIT(IEEE80211_STYPE_AUTH >> 4) |
+		      BIT(IEEE80211_STYPE_DEAUTH >> 4) |
+		      BIT(IEEE80211_STYPE_ACTION >> 4)
+	},
+	[NL80211_IFTYPE_P2P_DEVICE] = {
+		.tx = 0xffff,
+		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+		      BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
+	}
+};
+
+static void brcmf_wiphy_pno_params(struct wiphy *wiphy)
+{
+	/* scheduled scan settings */
+	wiphy->max_sched_scan_ssids = BRCMF_PNO_MAX_PFN_COUNT;
+	wiphy->max_match_sets = BRCMF_PNO_MAX_PFN_COUNT;
+	wiphy->max_sched_scan_ie_len = BRCMF_SCAN_IE_LEN_MAX;
+	wiphy->flags |= WIPHY_FLAG_SUPPORTS_SCHED_SCAN;
+}
+
+static struct wiphy *brcmf_setup_wiphy(struct brcmf_if *ifp,
+				       struct device *phydev)
+{
+	struct wiphy *wiphy;
+	s32 err = 0;
+
+	wiphy = wiphy_new(&wl_cfg80211_ops, sizeof(struct brcmf_cfg80211_info));
+	if (!wiphy) {
+		brcmf_err("Could not allocate wiphy device\n");
+		return ERR_PTR(-ENOMEM);
+	}
+	set_wiphy_dev(wiphy, phydev);
+	wiphy->max_scan_ssids = WL_NUM_SCAN_MAX;
+	wiphy->max_scan_ie_len = BRCMF_SCAN_IE_LEN_MAX;
+	wiphy->max_num_pmkids = WL_NUM_PMKIDS_MAX;
+	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
+				 BIT(NL80211_IFTYPE_ADHOC) |
+				 BIT(NL80211_IFTYPE_AP) |
+				 BIT(NL80211_IFTYPE_P2P_CLIENT) |
+				 BIT(NL80211_IFTYPE_P2P_GO) |
+				 BIT(NL80211_IFTYPE_P2P_DEVICE);
+	/* need VSDB firmware feature for concurrent channels */
+	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MCHAN))
+		brcmf_iface_combos[0].num_different_channels = 2;
+	wiphy->iface_combinations = brcmf_iface_combos;
+	wiphy->n_iface_combinations = ARRAY_SIZE(brcmf_iface_combos);
+	wiphy->bands[IEEE80211_BAND_2GHZ] = &__wl_band_2ghz;
+	wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
+	wiphy->cipher_suites = __wl_cipher_suites;
+	wiphy->n_cipher_suites = ARRAY_SIZE(__wl_cipher_suites);
+	wiphy->flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT |
+			WIPHY_FLAG_OFFCHAN_TX |
+			WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
+			WIPHY_FLAG_SUPPORTS_TDLS;
+	if (!brcmf_roamoff)
+		wiphy->flags |= WIPHY_FLAG_SUPPORTS_FW_ROAM;
+	wiphy->mgmt_stypes = brcmf_txrx_stypes;
+	wiphy->max_remain_on_channel_duration = 5000;
+	brcmf_wiphy_pno_params(wiphy);
+	brcmf_dbg(INFO, "Registering custom regulatory\n");
+	wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG;
+	wiphy_apply_custom_regulatory(wiphy, &brcmf_regdom);
+
+	/* vendor commands/events support */
+	wiphy->vendor_commands = brcmf_vendor_cmds;
+	wiphy->n_vendor_commands = BRCMF_VNDR_CMDS_LAST - 1;
+
+	err = wiphy_register(wiphy);
+	if (err < 0) {
+		brcmf_err("Could not register wiphy device (%d)\n", err);
+		wiphy_free(wiphy);
+		return ERR_PTR(err);
+	}
+	return wiphy;
+}
+
 
 static s32 brcmf_dongle_probecap(struct brcmf_cfg80211_info *cfg)
 {
-- 
1.9.1

