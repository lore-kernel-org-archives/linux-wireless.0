Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:34161 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300AbbFJWMb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 18:12:31 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Pontus Fuchs <pontusf@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 2/7] brcmfmac: Build wiphy mode and interface combinations dynamically
Date: Thu, 11 Jun 2015 00:12:18 +0200
Message-ID: <1433974343-16982-3-git-send-email-arend@broadcom.com> (sfid-20150611_001238_150791_227658D2)
In-Reply-To: <1433974343-16982-1-git-send-email-arend@broadcom.com>
References: <1433974343-16982-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pontus Fuchs <pontusf@broadcom.com>

Switch from using semi hard coded interface combinations. This makes
it easier to announce what the firmware actually supports. This fixes
the case where brcmfmac announces p2p but the firmware doesn't
support it.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Pontus Fuchs <pontusf@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 136 ++++++++++-----------
 1 file changed, 68 insertions(+), 68 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index 5cecd67..a668a35 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -52,8 +52,6 @@
 #define BRCMF_PNO_SCAN_COMPLETE		1
 #define BRCMF_PNO_SCAN_INCOMPLETE	0
 
-#define BRCMF_IFACE_MAX_CNT		3
-
 #define WPA_OUI				"\x00\x50\xF2"	/* WPA OUI */
 #define WPA_OUI_TYPE			1
 #define RSN_OUI				"\x00\x0F\xAC"	/* RSN OUI */
@@ -5640,53 +5638,6 @@ static int brcmf_setup_wiphybands(struct wiphy *wiphy)
 	return 0;
 }
 
-static const struct ieee80211_iface_limit brcmf_iface_limits_mbss[] = {
-	{
-		.max = 1,
-		.types = BIT(NL80211_IFTYPE_STATION) |
-			 BIT(NL80211_IFTYPE_ADHOC)
-	},
-	{
-		.max = 4,
-		.types = BIT(NL80211_IFTYPE_AP)
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
-
-static const struct ieee80211_iface_limit brcmf_iface_limits_sbss[] = {
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
-		 .n_limits = ARRAY_SIZE(brcmf_iface_limits_sbss),
-		 .limits = brcmf_iface_limits_sbss,
-	}
-};
-
 static const struct ieee80211_txrx_stypes
 brcmf_txrx_stypes[NUM_NL80211_IFTYPES] = {
 	[NL80211_IFTYPE_STATION] = {
@@ -5716,6 +5667,67 @@ brcmf_txrx_stypes[NUM_NL80211_IFTYPES] = {
 	}
 };
 
+static int brcmf_setup_ifmodes(struct wiphy *wiphy, struct brcmf_if *ifp)
+{
+	struct ieee80211_iface_combination *combo = NULL;
+	struct ieee80211_iface_limit *limits = NULL;
+	int i = 0, max_iface_cnt;
+
+	combo = kzalloc(sizeof(*combo), GFP_KERNEL);
+	if (!combo)
+		goto err;
+
+	limits = kzalloc(sizeof(*limits) * 4, GFP_KERNEL);
+	if (!limits)
+		goto err;
+
+	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
+				 BIT(NL80211_IFTYPE_ADHOC) |
+				 BIT(NL80211_IFTYPE_AP);
+
+	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MCHAN))
+		combo->num_different_channels = 2;
+	else
+		combo->num_different_channels = 1;
+
+	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MBSS)) {
+		limits[i].max = 1;
+		limits[i++].types = BIT(NL80211_IFTYPE_STATION);
+		limits[i].max = 4;
+		limits[i++].types = BIT(NL80211_IFTYPE_AP);
+		max_iface_cnt = 5;
+	} else {
+		limits[i].max = 2;
+		limits[i++].types = BIT(NL80211_IFTYPE_STATION) |
+				    BIT(NL80211_IFTYPE_AP);
+		max_iface_cnt = 2;
+	}
+
+	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_P2P)) {
+		wiphy->interface_modes |= BIT(NL80211_IFTYPE_P2P_CLIENT) |
+					  BIT(NL80211_IFTYPE_P2P_GO) |
+					  BIT(NL80211_IFTYPE_P2P_DEVICE);
+		limits[i].max = 1;
+		limits[i++].types = BIT(NL80211_IFTYPE_P2P_CLIENT) |
+				    BIT(NL80211_IFTYPE_P2P_GO);
+		limits[i].max = 1;
+		limits[i++].types = BIT(NL80211_IFTYPE_P2P_DEVICE);
+		max_iface_cnt += 2;
+	}
+	combo->max_interfaces = max_iface_cnt;
+	combo->limits = limits;
+	combo->n_limits = i;
+
+	wiphy->iface_combinations = combo;
+	wiphy->n_iface_combinations = 1;
+	return 0;
+
+err:
+	kfree(limits);
+	kfree(combo);
+	return -ENOMEM;
+}
+
 static void brcmf_wiphy_pno_params(struct wiphy *wiphy)
 {
 	/* scheduled scan settings */
@@ -5746,7 +5758,6 @@ static void brcmf_wiphy_wowl_params(struct wiphy *wiphy)
 static int brcmf_setup_wiphy(struct wiphy *wiphy, struct brcmf_if *ifp)
 {
 	struct ieee80211_supported_band *band;
-	struct ieee80211_iface_combination ifc_combo;
 	__le32 bandlist[3];
 	u32 n_bands;
 	int err, i;
@@ -5754,24 +5765,11 @@ static int brcmf_setup_wiphy(struct wiphy *wiphy, struct brcmf_if *ifp)
 	wiphy->max_scan_ssids = WL_NUM_SCAN_MAX;
 	wiphy->max_scan_ie_len = BRCMF_SCAN_IE_LEN_MAX;
 	wiphy->max_num_pmkids = WL_NUM_PMKIDS_MAX;
-	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
-				 BIT(NL80211_IFTYPE_ADHOC) |
-				 BIT(NL80211_IFTYPE_AP) |
-				 BIT(NL80211_IFTYPE_P2P_CLIENT) |
-				 BIT(NL80211_IFTYPE_P2P_GO) |
-				 BIT(NL80211_IFTYPE_P2P_DEVICE);
-	/* need VSDB firmware feature for concurrent channels */
-	ifc_combo = brcmf_iface_combos[0];
-	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MCHAN))
-		ifc_combo.num_different_channels = 2;
-	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MBSS)) {
-		ifc_combo.n_limits = ARRAY_SIZE(brcmf_iface_limits_mbss),
-		ifc_combo.limits = brcmf_iface_limits_mbss;
-	}
-	wiphy->iface_combinations = kmemdup(&ifc_combo,
-					    sizeof(ifc_combo),
-					    GFP_KERNEL);
-	wiphy->n_iface_combinations = ARRAY_SIZE(brcmf_iface_combos);
+
+	err = brcmf_setup_ifmodes(wiphy, ifp);
+	if (err)
+		return err;
+
 	wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
 	wiphy->cipher_suites = __wl_cipher_suites;
 	wiphy->n_cipher_suites = ARRAY_SIZE(__wl_cipher_suites);
@@ -6036,6 +6034,8 @@ static void brcmf_free_wiphy(struct wiphy *wiphy)
 	if (!wiphy)
 		return;
 
+	if (wiphy->iface_combinations)
+		kfree(wiphy->iface_combinations->limits);
 	kfree(wiphy->iface_combinations);
 	if (wiphy->bands[IEEE80211_BAND_2GHZ]) {
 		kfree(wiphy->bands[IEEE80211_BAND_2GHZ]->channels);
-- 
1.9.1

