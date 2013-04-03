Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4485 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760584Ab3DCKlU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 06:41:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 04/25] brcmfmac: determine the wiphy->bands property
 correctly.
Date: Wed, 3 Apr 2013 12:40:29 +0200
Message-ID: <1364985650-11719-5-git-send-email-arend@broadcom.com> (sfid-20130403_124134_167008_F8D700FA)
In-Reply-To: <1364985650-11719-1-git-send-email-arend@broadcom.com>
References: <1364985650-11719-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Use information from the device to determine the bands property
of the wiphy object. After this change the support of 80211n is
correctly presented in the bands property.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    6 +
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  326 +++++++++++++++-----
 .../net/wireless/brcm80211/include/brcmu_wifi.h    |   28 +-
 3 files changed, 278 insertions(+), 82 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index c7fa208..b4b9700 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -72,6 +72,7 @@
 #define BRCMF_C_SET_WSEC			134
 #define BRCMF_C_GET_PHY_NOISE			135
 #define BRCMF_C_GET_BSS_INFO			136
+#define BRCMF_C_GET_BANDLIST			140
 #define BRCMF_C_SET_SCB_TIMEOUT			158
 #define BRCMF_C_GET_PHYLIST			180
 #define BRCMF_C_SET_SCAN_CHANNEL_TIME		185
@@ -475,6 +476,11 @@ struct brcmf_sta_info_le {
 	__le32	rx_decrypt_failures;	/* # of packet decrypted failed */
 };
 
+struct brcmf_chanspec_list {
+	__le32	count;		/* # of entries */
+	__le32	element[1];	/* variable length uint32 list */
+};
+
 /*
  * WLC_E_PROBRESP_MSG
  * WLC_E_P2P_PROBREQ_MSG
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 804473f..c7459ae 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -182,64 +182,6 @@ static struct ieee80211_channel __wl_5ghz_a_channels[] = {
 	CHAN5G(216, 0),
 };
 
-static struct ieee80211_channel __wl_5ghz_n_channels[] = {
-	CHAN5G(32, 0), CHAN5G(34, 0),
-	CHAN5G(36, 0), CHAN5G(38, 0),
-	CHAN5G(40, 0), CHAN5G(42, 0),
-	CHAN5G(44, 0), CHAN5G(46, 0),
-	CHAN5G(48, 0), CHAN5G(50, 0),
-	CHAN5G(52, 0), CHAN5G(54, 0),
-	CHAN5G(56, 0), CHAN5G(58, 0),
-	CHAN5G(60, 0), CHAN5G(62, 0),
-	CHAN5G(64, 0), CHAN5G(66, 0),
-	CHAN5G(68, 0), CHAN5G(70, 0),
-	CHAN5G(72, 0), CHAN5G(74, 0),
-	CHAN5G(76, 0), CHAN5G(78, 0),
-	CHAN5G(80, 0), CHAN5G(82, 0),
-	CHAN5G(84, 0), CHAN5G(86, 0),
-	CHAN5G(88, 0), CHAN5G(90, 0),
-	CHAN5G(92, 0), CHAN5G(94, 0),
-	CHAN5G(96, 0), CHAN5G(98, 0),
-	CHAN5G(100, 0), CHAN5G(102, 0),
-	CHAN5G(104, 0), CHAN5G(106, 0),
-	CHAN5G(108, 0), CHAN5G(110, 0),
-	CHAN5G(112, 0), CHAN5G(114, 0),
-	CHAN5G(116, 0), CHAN5G(118, 0),
-	CHAN5G(120, 0), CHAN5G(122, 0),
-	CHAN5G(124, 0), CHAN5G(126, 0),
-	CHAN5G(128, 0), CHAN5G(130, 0),
-	CHAN5G(132, 0), CHAN5G(134, 0),
-	CHAN5G(136, 0), CHAN5G(138, 0),
-	CHAN5G(140, 0), CHAN5G(142, 0),
-	CHAN5G(144, 0), CHAN5G(145, 0),
-	CHAN5G(146, 0), CHAN5G(147, 0),
-	CHAN5G(148, 0), CHAN5G(149, 0),
-	CHAN5G(150, 0), CHAN5G(151, 0),
-	CHAN5G(152, 0), CHAN5G(153, 0),
-	CHAN5G(154, 0), CHAN5G(155, 0),
-	CHAN5G(156, 0), CHAN5G(157, 0),
-	CHAN5G(158, 0), CHAN5G(159, 0),
-	CHAN5G(160, 0), CHAN5G(161, 0),
-	CHAN5G(162, 0), CHAN5G(163, 0),
-	CHAN5G(164, 0), CHAN5G(165, 0),
-	CHAN5G(166, 0), CHAN5G(168, 0),
-	CHAN5G(170, 0), CHAN5G(172, 0),
-	CHAN5G(174, 0), CHAN5G(176, 0),
-	CHAN5G(178, 0), CHAN5G(180, 0),
-	CHAN5G(182, 0), CHAN5G(184, 0),
-	CHAN5G(186, 0), CHAN5G(188, 0),
-	CHAN5G(190, 0), CHAN5G(192, 0),
-	CHAN5G(194, 0), CHAN5G(196, 0),
-	CHAN5G(198, 0), CHAN5G(200, 0),
-	CHAN5G(202, 0), CHAN5G(204, 0),
-	CHAN5G(206, 0), CHAN5G(208, 0),
-	CHAN5G(210, 0), CHAN5G(212, 0),
-	CHAN5G(214, 0), CHAN5G(216, 0),
-	CHAN5G(218, 0), CHAN5G(220, 0),
-	CHAN5G(222, 0), CHAN5G(224, 0),
-	CHAN5G(226, 0), CHAN5G(228, 0),
-};
-
 static struct ieee80211_supported_band __wl_band_2ghz = {
 	.band = IEEE80211_BAND_2GHZ,
 	.channels = __wl_2ghz_channels,
@@ -256,12 +198,28 @@ static struct ieee80211_supported_band __wl_band_5ghz_a = {
 	.n_bitrates = wl_a_rates_size,
 };
 
-static struct ieee80211_supported_band __wl_band_5ghz_n = {
-	.band = IEEE80211_BAND_5GHZ,
-	.channels = __wl_5ghz_n_channels,
-	.n_channels = ARRAY_SIZE(__wl_5ghz_n_channels),
-	.bitrates = wl_a_rates,
-	.n_bitrates = wl_a_rates_size,
+/* This is to override regulatory domains defined in cfg80211 module (reg.c)
+ * By default world regulatory domain defined in reg.c puts the flags
+ * NL80211_RRF_PASSIVE_SCAN and NL80211_RRF_NO_IBSS for 5GHz channels (for
+ * 36..48 and 149..165). With respect to these flags, wpa_supplicant doesn't
+ * start p2p operations on 5GHz channels. All the changes in world regulatory
+ * domain are to be done here.
+ */
+static const struct ieee80211_regdomain brcmf_regdom = {
+	.n_reg_rules = 4,
+	.alpha2 =  "99",
+	.reg_rules = {
+		/* IEEE 802.11b/g, channels 1..11 */
+		REG_RULE(2412-10, 2472+10, 40, 6, 20, 0),
+		/* If any */
+		/* IEEE 802.11 channel 14 - Only JP enables
+		 * this and for 802.11b only
+		 */
+		REG_RULE(2484-10, 2484+10, 20, 6, 20, 0),
+		/* IEEE 802.11a, channel 36..64 */
+		REG_RULE(5150-10, 5350+10, 40, 6, 20, 0),
+		/* IEEE 802.11a, channel 100..165 */
+		REG_RULE(5470-10, 5850+10, 40, 6, 20, 0), }
 };
 
 static const u32 __wl_cipher_suites[] = {
@@ -4188,13 +4146,6 @@ static struct wiphy *brcmf_setup_wiphy(struct device *phydev)
 	wiphy->iface_combinations = brcmf_iface_combos;
 	wiphy->n_iface_combinations = ARRAY_SIZE(brcmf_iface_combos);
 	wiphy->bands[IEEE80211_BAND_2GHZ] = &__wl_band_2ghz;
-	wiphy->bands[IEEE80211_BAND_5GHZ] = &__wl_band_5ghz_a;	/* Set
-						* it as 11a by default.
-						* This will be updated with
-						* 11n phy tables in
-						* "ifconfig up"
-						* if phy has 11n capability
-						*/
 	wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
 	wiphy->cipher_suites = __wl_cipher_suites;
 	wiphy->n_cipher_suites = ARRAY_SIZE(__wl_cipher_suites);
@@ -4204,6 +4155,9 @@ static struct wiphy *brcmf_setup_wiphy(struct device *phydev)
 	wiphy->mgmt_stypes = brcmf_txrx_stypes;
 	wiphy->max_remain_on_channel_duration = 5000;
 	brcmf_wiphy_pno_params(wiphy);
+	brcmf_dbg(INFO, "Registering custom regulatory\n");
+	wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
+	wiphy_apply_custom_regulatory(wiphy, &brcmf_regdom);
 	err = wiphy_register(wiphy);
 	if (err < 0) {
 		brcmf_err("Could not register wiphy device (%d)\n", err);
@@ -4927,34 +4881,248 @@ dongle_scantime_out:
 	return err;
 }
 
-static s32 wl_update_wiphybands(struct brcmf_cfg80211_info *cfg)
+
+static s32 brcmf_construct_reginfo(struct brcmf_cfg80211_info *cfg, u32 bw_cap)
+{
+	struct brcmf_if *ifp = netdev_priv(cfg_to_ndev(cfg));
+	struct ieee80211_channel *band_chan_arr;
+	struct brcmf_chanspec_list *list;
+	s32 err;
+	u8 *pbuf;
+	u32 i, j;
+	u32 total;
+	u16 chanspec;
+	enum ieee80211_band band;
+	u32 channel;
+	u32 *n_cnt;
+	bool ht40_allowed;
+	u32 index;
+	u32 ht40_flag;
+	bool update;
+	u32 array_size;
+
+	pbuf = kzalloc(BRCMF_DCMD_MEDLEN, GFP_KERNEL);
+
+	if (pbuf == NULL)
+		return -ENOMEM;
+
+	list = (struct brcmf_chanspec_list *)pbuf;
+
+	err = brcmf_fil_iovar_data_get(ifp, "chanspecs", pbuf,
+				       BRCMF_DCMD_MEDLEN);
+	if (err) {
+		brcmf_err("get chanspecs error (%d)\n", err);
+		goto exit;
+	}
+
+	__wl_band_2ghz.n_channels = 0;
+	__wl_band_5ghz_a.n_channels = 0;
+
+	total = le32_to_cpu(list->count);
+	for (i = 0; i < total; i++) {
+		chanspec = (u16)le32_to_cpu(list->element[i]);
+		channel = CHSPEC_CHANNEL(chanspec);
+
+		if (CHSPEC_IS40(chanspec)) {
+			if (CHSPEC_SB_UPPER(chanspec))
+				channel += CH_10MHZ_APART;
+			else
+				channel -= CH_10MHZ_APART;
+		} else if (CHSPEC_IS80(chanspec)) {
+			brcmf_dbg(INFO, "HT80 center channel : %d\n",
+				  channel);
+			continue;
+		}
+		if (CHSPEC_IS2G(chanspec) && (channel >= CH_MIN_2G_CHANNEL) &&
+		    (channel <= CH_MAX_2G_CHANNEL)) {
+			band_chan_arr = __wl_2ghz_channels;
+			array_size = ARRAY_SIZE(__wl_2ghz_channels);
+			n_cnt = &__wl_band_2ghz.n_channels;
+			band = IEEE80211_BAND_2GHZ;
+			ht40_allowed = (bw_cap == WLC_N_BW_40ALL);
+		} else if (CHSPEC_IS5G(chanspec) &&
+			   channel >= CH_MIN_5G_CHANNEL) {
+			band_chan_arr = __wl_5ghz_a_channels;
+			array_size = ARRAY_SIZE(__wl_5ghz_a_channels);
+			n_cnt = &__wl_band_5ghz_a.n_channels;
+			band = IEEE80211_BAND_5GHZ;
+			ht40_allowed = !(bw_cap == WLC_N_BW_20ALL);
+		} else {
+			brcmf_err("Invalid channel Sepc. 0x%x.\n", chanspec);
+			continue;
+		}
+		if (!ht40_allowed && CHSPEC_IS40(chanspec))
+			continue;
+		update = false;
+		for (j = 0; (j < *n_cnt && (*n_cnt < array_size)); j++) {
+			if (band_chan_arr[j].hw_value == channel) {
+				update = true;
+				break;
+			}
+		}
+		if (update)
+			index = j;
+		else
+			index = *n_cnt;
+		if (index <  array_size) {
+			band_chan_arr[index].center_freq =
+				ieee80211_channel_to_frequency(channel, band);
+			band_chan_arr[index].hw_value = channel;
+
+			if (CHSPEC_IS40(chanspec) && ht40_allowed) {
+				/* assuming the order is HT20, HT40 Upper,
+				 * HT40 lower from chanspecs
+				 */
+				ht40_flag = band_chan_arr[index].flags &
+					    IEEE80211_CHAN_NO_HT40;
+				if (CHSPEC_SB_UPPER(chanspec)) {
+					if (ht40_flag == IEEE80211_CHAN_NO_HT40)
+						band_chan_arr[index].flags &=
+							~IEEE80211_CHAN_NO_HT40;
+					band_chan_arr[index].flags |=
+						IEEE80211_CHAN_NO_HT40PLUS;
+				} else {
+					/* It should be one of
+					 * IEEE80211_CHAN_NO_HT40 or
+					 * IEEE80211_CHAN_NO_HT40PLUS
+					 */
+					band_chan_arr[index].flags &=
+							~IEEE80211_CHAN_NO_HT40;
+					if (ht40_flag == IEEE80211_CHAN_NO_HT40)
+						band_chan_arr[index].flags |=
+						    IEEE80211_CHAN_NO_HT40MINUS;
+				}
+			} else {
+				band_chan_arr[index].flags =
+							IEEE80211_CHAN_NO_HT40;
+				if (band == IEEE80211_BAND_2GHZ)
+					channel |= WL_CHANSPEC_BAND_2G;
+				else
+					channel |= WL_CHANSPEC_BAND_5G;
+				channel |= WL_CHANSPEC_BW_20;
+				err = brcmf_fil_bsscfg_int_get(ifp,
+							       "per_chan_info",
+							       &channel);
+				if (!err) {
+					if (channel & WL_CHAN_RADAR)
+						band_chan_arr[index].flags |=
+							(IEEE80211_CHAN_RADAR |
+							IEEE80211_CHAN_NO_IBSS);
+					if (channel & WL_CHAN_PASSIVE)
+						band_chan_arr[index].flags |=
+						    IEEE80211_CHAN_PASSIVE_SCAN;
+				}
+			}
+			if (!update)
+				(*n_cnt)++;
+		}
+	}
+exit:
+	kfree(pbuf);
+	return err;
+}
+
+
+static s32 brcmf_update_wiphybands(struct brcmf_cfg80211_info *cfg)
 {
 	struct brcmf_if *ifp = netdev_priv(cfg_to_ndev(cfg));
 	struct wiphy *wiphy;
 	s32 phy_list;
+	u32 band_list[3];
+	u32 nmode;
+	u32 bw_cap = 0;
 	s8 phy;
-	s32 err = 0;
+	s32 err;
+	u32 nband;
+	s32 i;
+	struct ieee80211_supported_band *bands[IEEE80211_NUM_BANDS];
+	s32 index;
 
 	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_PHYLIST,
 				     &phy_list, sizeof(phy_list));
 	if (err) {
-		brcmf_err("error (%d)\n", err);
+		brcmf_err("BRCMF_C_GET_PHYLIST error (%d)\n", err);
 		return err;
 	}
 
 	phy = ((char *)&phy_list)[0];
-	brcmf_dbg(INFO, "%c phy\n", phy);
-	if (phy == 'n' || phy == 'a') {
-		wiphy = cfg_to_wiphy(cfg);
-		wiphy->bands[IEEE80211_BAND_5GHZ] = &__wl_band_5ghz_n;
+	brcmf_dbg(INFO, "BRCMF_C_GET_PHYLIST reported: %c phy\n", phy);
+
+
+	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_BANDLIST,
+				     &band_list, sizeof(band_list));
+	if (err) {
+		brcmf_err("BRCMF_C_GET_BANDLIST error (%d)\n", err);
+		return err;
 	}
+	brcmf_dbg(INFO, "BRCMF_C_GET_BANDLIST reported: 0x%08x 0x%08x 0x%08x phy\n",
+		  band_list[0], band_list[1], band_list[2]);
+
+	err = brcmf_fil_iovar_int_get(ifp, "nmode", &nmode);
+	if (err) {
+		brcmf_err("nmode error (%d)\n", err);
+	} else {
+		err = brcmf_fil_iovar_int_get(ifp, "mimo_bw_cap", &bw_cap);
+		if (err)
+			brcmf_err("mimo_bw_cap error (%d)\n", err);
+	}
+	brcmf_dbg(INFO, "nmode=%d, mimo_bw_cap=%d\n", nmode, bw_cap);
+
+	err = brcmf_construct_reginfo(cfg, bw_cap);
+	if (err) {
+		brcmf_err("brcmf_construct_reginfo failed (%d)\n", err);
+		return err;
+	}
+
+	nband = band_list[0];
+	memset(bands, 0, sizeof(bands));
+
+	for (i = 1; i <= nband && i < ARRAY_SIZE(band_list); i++) {
+		index = -1;
+		if ((band_list[i] == WLC_BAND_5G) &&
+		    (__wl_band_5ghz_a.n_channels > 0)) {
+			index = IEEE80211_BAND_5GHZ;
+			bands[index] = &__wl_band_5ghz_a;
+			if ((bw_cap == WLC_N_BW_40ALL) ||
+			    (bw_cap == WLC_N_BW_20IN2G_40IN5G))
+				bands[index]->ht_cap.cap |=
+							IEEE80211_HT_CAP_SGI_40;
+		} else if ((band_list[i] == WLC_BAND_2G) &&
+			   (__wl_band_2ghz.n_channels > 0)) {
+			index = IEEE80211_BAND_2GHZ;
+			bands[index] = &__wl_band_2ghz;
+			if (bw_cap == WLC_N_BW_40ALL)
+				bands[index]->ht_cap.cap |=
+							IEEE80211_HT_CAP_SGI_40;
+		}
+
+		if ((index >= 0) && nmode) {
+			bands[index]->ht_cap.cap |= IEEE80211_HT_CAP_SGI_20;
+			bands[index]->ht_cap.cap |= IEEE80211_HT_CAP_DSSSCCK40;
+			bands[index]->ht_cap.ht_supported = true;
+			bands[index]->ht_cap.ampdu_factor =
+						IEEE80211_HT_MAX_AMPDU_64K;
+			bands[index]->ht_cap.ampdu_density =
+						IEEE80211_HT_MPDU_DENSITY_16;
+			/* An HT shall support all EQM rates for one spatial
+			 * stream
+			 */
+			bands[index]->ht_cap.mcs.rx_mask[0] = 0xff;
+		}
+	}
+
+	wiphy = cfg_to_wiphy(cfg);
+	wiphy->bands[IEEE80211_BAND_2GHZ] = bands[IEEE80211_BAND_2GHZ];
+	wiphy->bands[IEEE80211_BAND_5GHZ] = bands[IEEE80211_BAND_5GHZ];
+	wiphy_apply_custom_regulatory(wiphy, &brcmf_regdom);
 
 	return err;
 }
 
+
 static s32 brcmf_dongle_probecap(struct brcmf_cfg80211_info *cfg)
 {
-	return wl_update_wiphybands(cfg);
+	return brcmf_update_wiphybands(cfg);
 }
 
 static s32 brcmf_config_dongle(struct brcmf_cfg80211_info *cfg)
diff --git a/drivers/net/wireless/brcm80211/include/brcmu_wifi.h b/drivers/net/wireless/brcm80211/include/brcmu_wifi.h
index c11a290..0505cc0 100644
--- a/drivers/net/wireless/brcm80211/include/brcmu_wifi.h
+++ b/drivers/net/wireless/brcm80211/include/brcmu_wifi.h
@@ -32,8 +32,9 @@
 #define CH_20MHZ_APART			4
 #define CH_10MHZ_APART			2
 #define CH_5MHZ_APART			1 /* 2G band channels are 5 Mhz apart */
+#define CH_MIN_2G_CHANNEL		1
 #define CH_MAX_2G_CHANNEL		14	/* Max channel in 2G band */
-#define BRCM_MAX_2G_CHANNEL	CH_MAX_2G_CHANNEL	/* legacy define */
+#define CH_MIN_5G_CHANNEL		34
 
 /* bandstate array indices */
 #define BAND_2G_INDEX		0	/* wlc->bandstate[x] index */
@@ -60,6 +61,7 @@
 #define WL_CHANSPEC_BW_10		0x0400
 #define WL_CHANSPEC_BW_20		0x0800
 #define WL_CHANSPEC_BW_40		0x0C00
+#define WL_CHANSPEC_BW_80		0x2000
 
 #define WL_CHANSPEC_BAND_MASK		0xf000
 #define WL_CHANSPEC_BAND_SHIFT		12
@@ -67,6 +69,25 @@
 #define WL_CHANSPEC_BAND_2G		0x2000
 #define INVCHANSPEC			255
 
+#define WL_CHAN_VALID_HW		(1 << 0) /* valid with current HW */
+#define WL_CHAN_VALID_SW		(1 << 1) /* valid with country sett. */
+#define WL_CHAN_BAND_5G			(1 << 2) /* 5GHz-band channel */
+#define WL_CHAN_RADAR			(1 << 3) /* radar sensitive  channel */
+#define WL_CHAN_INACTIVE		(1 << 4) /* inactive due to radar */
+#define WL_CHAN_PASSIVE			(1 << 5) /* channel in passive mode */
+#define WL_CHAN_RESTRICTED		(1 << 6) /* restricted use channel */
+
+/* values for band specific 40MHz capabilities  */
+#define WLC_N_BW_20ALL			0
+#define WLC_N_BW_40ALL			1
+#define WLC_N_BW_20IN2G_40IN5G		2
+
+/* band types */
+#define	WLC_BAND_AUTO			0	/* auto-select */
+#define	WLC_BAND_5G			1	/* 5 Ghz */
+#define	WLC_BAND_2G			2	/* 2.4 Ghz */
+#define	WLC_BAND_ALL			3	/* all bands */
+
 #define CHSPEC_CHANNEL(chspec)	((u8)((chspec) & WL_CHANSPEC_CHAN_MASK))
 #define CHSPEC_BAND(chspec)	((chspec) & WL_CHANSPEC_BAND_MASK)
 
@@ -79,10 +100,11 @@
 #define CHSPEC_IS20(chspec) \
 	(((chspec) & WL_CHANSPEC_BW_MASK) == WL_CHANSPEC_BW_20)
 
-#ifndef CHSPEC_IS40
 #define CHSPEC_IS40(chspec) \
 	(((chspec) & WL_CHANSPEC_BW_MASK) == WL_CHANSPEC_BW_40)
-#endif
+
+#define CHSPEC_IS80(chspec) \
+	(((chspec) & WL_CHANSPEC_BW_MASK) == WL_CHANSPEC_BW_80)
 
 #define CHSPEC_IS5G(chspec) \
 	(((chspec) & WL_CHANSPEC_BAND_MASK) == WL_CHANSPEC_BAND_5G)
-- 
1.7.10.4


