Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:53607 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932981AbcAMJtw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2016 04:49:52 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [RFC V2 3/3] brcmfmac: add support for nl80211 BSS_SELECT feature
Date: Wed, 13 Jan 2016 10:49:43 +0100
Message-ID: <1452678583-20086-4-git-send-email-arend@broadcom.com> (sfid-20160113_104959_176951_84F19410)
In-Reply-To: <1452678583-20086-1-git-send-email-arend@broadcom.com>
References: <1452678583-20086-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Announce support for extended nl80211 feature BSS_SELECT and
process BSS selection criteria provided in .connect() callback.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Lei Zhang <leizh@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 63 ++++++++++++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/common.c   | 38 +++++++------
 drivers/net/wireless/brcm80211/brcmfmac/core.h     |  1 +
 3 files changed, 87 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index deb5f78..a339e41 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -237,6 +237,20 @@ module_param_named(roamoff, brcmf_roamoff, int, S_IRUSR);
 MODULE_PARM_DESC(roamoff, "do not use internal roaming engine");
 
 
+static u8 nl80211_band_to_fwil(enum nl80211_band band)
+{
+	switch (band) {
+	case NL80211_BAND_2GHZ:
+		return WLC_BAND_2G;
+	case NL80211_BAND_5GHZ:
+		return WLC_BAND_5G;
+	default:
+		WARN_ON(1);
+		break;
+	}
+	return 0;
+}
+
 static u16 chandef_to_chanspec(struct brcmu_d11inf *d11inf,
 			       struct cfg80211_chan_def *ch)
 {
@@ -1722,6 +1736,48 @@ enum nl80211_auth_type brcmf_war_auth_type(struct brcmf_if *ifp,
 	return type;
 }
 
+static void brcmf_set_join_pref(struct brcmf_if *ifp,
+				struct cfg80211_bss_selection *bss_select)
+{
+	struct brcmf_join_pref_params join_pref_params[2];
+	enum nl80211_band band;
+	int err, i = 0;
+
+	if (!bss_select->primitive) {
+		brcmf_c_set_joinpref_default(ifp);
+		return;
+	}
+
+	join_pref_params[i].len = 2;
+	join_pref_params[i].rssi_gain = 0;
+	switch (bss_select->primitive) {
+	case NL80211_BSS_SELECT_BAND_PREF:
+		join_pref_params[i].type = BRCMF_JOIN_PREF_BAND;
+		band = bss_select->param.band_pref;
+		join_pref_params[i].band = nl80211_band_to_fwil(band);
+		i++;
+		break;
+	case NL80211_BSS_SELECT_ADJUST_RSSI:
+		join_pref_params[i].type = BRCMF_JOIN_PREF_RSSI_DELTA;
+		band = bss_select->param.adjust.band;
+		join_pref_params[i].band = nl80211_band_to_fwil(band);
+		join_pref_params[i].rssi_gain = bss_select->param.adjust.delta;
+		i++;
+		break;
+	case NL80211_BSS_SELECT_RSSI:
+	default:
+		break;
+	}
+	join_pref_params[i].type = BRCMF_JOIN_PREF_RSSI;
+	join_pref_params[i].len = 2;
+	join_pref_params[i].rssi_gain = 0;
+	join_pref_params[i].band = 0;
+	err = brcmf_fil_iovar_data_set(ifp, "join_pref", join_pref_params,
+				       sizeof(join_pref_params));
+	if (err)
+		brcmf_err("Set join_pref error (%d)\n", err);
+}
+
 static s32
 brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 		       struct cfg80211_connect_params *sme)
@@ -1858,6 +1914,8 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 	else
 		eth_broadcast_addr(ext_join_params->assoc_le.bssid);
 
+	brcmf_set_join_pref(ifp, &sme->bss_select);
+
 	if (cfg->channel) {
 		ext_join_params->assoc_le.chanspec_num = cpu_to_le32(1);
 
@@ -5920,6 +5978,11 @@ static int brcmf_setup_wiphy(struct wiphy *wiphy, struct brcmf_if *ifp)
 	wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
 	wiphy->cipher_suites = __wl_cipher_suites;
 	wiphy->n_cipher_suites = ARRAY_SIZE(__wl_cipher_suites);
+	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_BSS_SELECT);
+	wiphy->bss_select_support = BIT(NL80211_BSS_SELECT_RSSI) |
+				    BIT(NL80211_BSS_SELECT_BAND_PREF) |
+				    BIT(NL80211_BSS_SELECT_ADJUST_RSSI);
+
 	wiphy->flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT |
 			WIPHY_FLAG_OFFCHAN_TX |
 			WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/common.c b/drivers/net/wireless/brcm80211/brcmfmac/common.c
index fe54844..7c40979 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/common.c
@@ -33,14 +33,34 @@ const u8 ALLFFMAC[ETH_ALEN] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
 #define BRCMF_DEFAULT_SCAN_CHANNEL_TIME	40
 #define BRCMF_DEFAULT_SCAN_UNASSOC_TIME	40
 
-/* boost value for RSSI_DELTA in preferred join selection */
+/* default boost value for RSSI_DELTA in preferred join selection */
 #define BRCMF_JOIN_PREF_RSSI_BOOST	8
 
+void brcmf_c_set_joinpref_default(struct brcmf_if *ifp)
+{
+	struct brcmf_join_pref_params join_pref_params[2];
+	int err;
+
+	/* Setup join_pref to select target by RSSI (boost on 5GHz) */
+	join_pref_params[0].type = BRCMF_JOIN_PREF_RSSI_DELTA;
+	join_pref_params[0].len = 2;
+	join_pref_params[0].rssi_gain = BRCMF_JOIN_PREF_RSSI_BOOST;
+	join_pref_params[0].band = WLC_BAND_5G;
+
+	join_pref_params[1].type = BRCMF_JOIN_PREF_RSSI;
+	join_pref_params[1].len = 2;
+	join_pref_params[1].rssi_gain = 0;
+	join_pref_params[1].band = 0;
+	err = brcmf_fil_iovar_data_set(ifp, "join_pref", join_pref_params,
+				       sizeof(join_pref_params));
+	if (err)
+		brcmf_err("Set join_pref error (%d)\n", err);
+}
+
 int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 {
 	s8 eventmask[BRCMF_EVENTING_MASK_LEN];
 	u8 buf[BRCMF_DCMD_SMLEN];
-	struct brcmf_join_pref_params join_pref_params[2];
 	struct brcmf_rev_info_le revinfo;
 	struct brcmf_rev_info *ri;
 	char *ptr;
@@ -127,19 +147,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 		goto done;
 	}
 
-	/* Setup join_pref to select target by RSSI(with boost on 5GHz) */
-	join_pref_params[0].type = BRCMF_JOIN_PREF_RSSI_DELTA;
-	join_pref_params[0].len = 2;
-	join_pref_params[0].rssi_gain = BRCMF_JOIN_PREF_RSSI_BOOST;
-	join_pref_params[0].band = WLC_BAND_5G;
-	join_pref_params[1].type = BRCMF_JOIN_PREF_RSSI;
-	join_pref_params[1].len = 2;
-	join_pref_params[1].rssi_gain = 0;
-	join_pref_params[1].band = 0;
-	err = brcmf_fil_iovar_data_set(ifp, "join_pref", join_pref_params,
-				       sizeof(join_pref_params));
-	if (err)
-		brcmf_err("Set join_pref error (%d)\n", err);
+	brcmf_c_set_joinpref_default(ifp);
 
 	/* Setup event_msgs, enable E_IF */
 	err = brcmf_fil_iovar_data_get(ifp, "event_msgs", eventmask,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.h b/drivers/net/wireless/brcm80211/brcmfmac/core.h
index 2f9101b..f8b4925 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.h
@@ -217,5 +217,6 @@ void brcmf_txflowblock_if(struct brcmf_if *ifp,
 void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success);
 void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb);
 void brcmf_net_setcarrier(struct brcmf_if *ifp, bool on);
+void brcmf_c_set_joinpref_default(struct brcmf_if *ifp);
 
 #endif /* BRCMFMAC_CORE_H */
-- 
1.9.1

