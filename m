Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:25521 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbaGLGts (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jul 2014 02:49:48 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 8/9] brcmfmac: rework wiphy structure setup
Date: Sat, 12 Jul 2014 08:49:41 +0200
Message-ID: <1405147782-12768-9-git-send-email-arend@broadcom.com> (sfid-20140712_085005_841921_6C729ED2)
In-Reply-To: <1405147782-12768-1-git-send-email-arend@broadcom.com>
References: <1405147782-12768-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of waiting for IFF_UP of the primary net device to determine
the band and channel information of the wiphy structure, this is now
done during driver initialization in brcmf_cfg80211_attach(). The
channel information is obtained from the device and the 2G band is
updated when 40MHz bandwidth is enabled for that band. Before this
change the band and channel objects were common between multiple
brcmfmac devices in the system, which make that information rather
unreliable. That is also fixed with this reworked implementation.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  | 567 +++++++++++----------
 1 file changed, 298 insertions(+), 269 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index f1501a2..d3bb4e0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -103,24 +103,6 @@ static bool check_vif_up(struct brcmf_cfg80211_vif *vif)
 	return true;
 }
 
-#define CHAN2G(_channel, _freq, _flags) {			\
-	.band			= IEEE80211_BAND_2GHZ,		\
-	.center_freq		= (_freq),			\
-	.hw_value		= (_channel),			\
-	.flags			= (_flags),			\
-	.max_antenna_gain	= 0,				\
-	.max_power		= 30,				\
-}
-
-#define CHAN5G(_channel, _flags) {				\
-	.band			= IEEE80211_BAND_5GHZ,		\
-	.center_freq		= 5000 + (5 * (_channel)),	\
-	.hw_value		= (_channel),			\
-	.flags			= (_flags),			\
-	.max_antenna_gain	= 0,				\
-	.max_power		= 30,				\
-}
-
 #define RATE_TO_BASE100KBPS(rate)   (((rate) * 10) / 2)
 #define RATETAB_ENT(_rateid, _flags) \
 	{                                                               \
@@ -149,58 +131,17 @@ static struct ieee80211_rate __wl_rates[] = {
 #define wl_g_rates		(__wl_rates + 0)
 #define wl_g_rates_size	12
 
-static struct ieee80211_channel __wl_2ghz_channels[] = {
-	CHAN2G(1, 2412, 0),
-	CHAN2G(2, 2417, 0),
-	CHAN2G(3, 2422, 0),
-	CHAN2G(4, 2427, 0),
-	CHAN2G(5, 2432, 0),
-	CHAN2G(6, 2437, 0),
-	CHAN2G(7, 2442, 0),
-	CHAN2G(8, 2447, 0),
-	CHAN2G(9, 2452, 0),
-	CHAN2G(10, 2457, 0),
-	CHAN2G(11, 2462, 0),
-	CHAN2G(12, 2467, 0),
-	CHAN2G(13, 2472, 0),
-	CHAN2G(14, 2484, 0),
-};
-
-static struct ieee80211_channel __wl_5ghz_a_channels[] = {
-	CHAN5G(34, 0), CHAN5G(36, 0),
-	CHAN5G(38, 0), CHAN5G(40, 0),
-	CHAN5G(42, 0), CHAN5G(44, 0),
-	CHAN5G(46, 0), CHAN5G(48, 0),
-	CHAN5G(52, 0), CHAN5G(56, 0),
-	CHAN5G(60, 0), CHAN5G(64, 0),
-	CHAN5G(100, 0), CHAN5G(104, 0),
-	CHAN5G(108, 0), CHAN5G(112, 0),
-	CHAN5G(116, 0), CHAN5G(120, 0),
-	CHAN5G(124, 0), CHAN5G(128, 0),
-	CHAN5G(132, 0), CHAN5G(136, 0),
-	CHAN5G(140, 0), CHAN5G(149, 0),
-	CHAN5G(153, 0), CHAN5G(157, 0),
-	CHAN5G(161, 0), CHAN5G(165, 0),
-	CHAN5G(184, 0), CHAN5G(188, 0),
-	CHAN5G(192, 0), CHAN5G(196, 0),
-	CHAN5G(200, 0), CHAN5G(204, 0),
-	CHAN5G(208, 0), CHAN5G(212, 0),
-	CHAN5G(216, 0),
-};
-
-static struct ieee80211_supported_band __wl_band_2ghz = {
+/* Band templates duplicated per wiphy. The channel info
+ * is filled in after querying the device.
+ */
+static const struct ieee80211_supported_band __wl_band_2ghz = {
 	.band = IEEE80211_BAND_2GHZ,
-	.channels = __wl_2ghz_channels,
-	.n_channels = ARRAY_SIZE(__wl_2ghz_channels),
 	.bitrates = wl_g_rates,
 	.n_bitrates = wl_g_rates_size,
-	.ht_cap = {IEEE80211_HT_CAP_SUP_WIDTH_20_40, true},
 };
 
-static struct ieee80211_supported_band __wl_band_5ghz_a = {
+static const struct ieee80211_supported_band __wl_band_5ghz_a = {
 	.band = IEEE80211_BAND_5GHZ,
-	.channels = __wl_5ghz_a_channels,
-	.n_channels = ARRAY_SIZE(__wl_5ghz_a_channels),
 	.bitrates = wl_a_rates,
 	.n_bitrates = wl_a_rates_size,
 };
@@ -4913,25 +4854,77 @@ dongle_scantime_out:
 	return err;
 }
 
+/* Filter the list of channels received from firmware counting only
+ * the 20MHz channels. The wiphy band data only needs those which get
+ * flagged to indicate if they can take part in higher bandwidth.
+ */
+static void brcmf_count_20mhz_channels(struct brcmf_cfg80211_info *cfg,
+				       struct brcmf_chanspec_list *chlist,
+				       u32 chcnt[])
+{
+	u32 total = le32_to_cpu(chlist->count);
+	struct brcmu_chan ch;
+	int i;
+
+	for (i = 0; i <= total; i++) {
+		ch.chspec = (u16)le32_to_cpu(chlist->element[i]);
+		cfg->d11inf.decchspec(&ch);
+
+		/* Firmware gives a ordered list. We skip non-20MHz
+		 * channels is 2G. For 5G we can abort upon reaching
+		 * a non-20MHz channel in the list.
+		 */
+		if (ch.bw != BRCMU_CHAN_BW_20) {
+			if (ch.band == BRCMU_CHAN_BAND_5G)
+				break;
+			else
+				continue;
+		}
+
+		if (ch.band == BRCMU_CHAN_BAND_2G)
+			chcnt[0] += 1;
+		else if (ch.band == BRCMU_CHAN_BAND_5G)
+			chcnt[1] += 1;
+	}
+}
+
+static void brcmf_update_bw40_channel_flag(struct ieee80211_channel *channel,
+					   struct brcmu_chan *ch)
+{
+	u32 ht40_flag;
 
-static s32 brcmf_construct_reginfo(struct brcmf_cfg80211_info *cfg,
-				   u32 bw_cap[])
+	ht40_flag = channel->flags & IEEE80211_CHAN_NO_HT40;
+	if (ch->sb == BRCMU_CHAN_SB_U) {
+		if (ht40_flag == IEEE80211_CHAN_NO_HT40)
+			channel->flags &= ~IEEE80211_CHAN_NO_HT40;
+		channel->flags |= IEEE80211_CHAN_NO_HT40PLUS;
+	} else {
+		/* It should be one of
+		 * IEEE80211_CHAN_NO_HT40 or
+		 * IEEE80211_CHAN_NO_HT40PLUS
+		 */
+		channel->flags &= ~IEEE80211_CHAN_NO_HT40;
+		if (ht40_flag == IEEE80211_CHAN_NO_HT40)
+			channel->flags |= IEEE80211_CHAN_NO_HT40MINUS;
+	}
+}
+
+static int brcmf_construct_chaninfo(struct brcmf_cfg80211_info *cfg,
+				    u32 bw_cap[])
 {
 	struct brcmf_if *ifp = netdev_priv(cfg_to_ndev(cfg));
-	struct ieee80211_channel *band_chan_arr;
+	struct ieee80211_supported_band *band;
+	struct ieee80211_channel *channel;
+	struct wiphy *wiphy;
 	struct brcmf_chanspec_list *list;
 	struct brcmu_chan ch;
-	s32 err;
+	int err;
 	u8 *pbuf;
 	u32 i, j;
 	u32 total;
-	enum ieee80211_band band;
-	u32 channel;
-	u32 *n_cnt;
+	u32 chaninfo;
+	u32 chcnt[2] = { 0, 0 };
 	u32 index;
-	u32 ht40_flag;
-	bool update;
-	u32 array_size;
 
 	pbuf = kzalloc(BRCMF_DCMD_MEDLEN, GFP_KERNEL);
 
@@ -4944,11 +4937,45 @@ static s32 brcmf_construct_reginfo(struct brcmf_cfg80211_info *cfg,
 				       BRCMF_DCMD_MEDLEN);
 	if (err) {
 		brcmf_err("get chanspecs error (%d)\n", err);
-		goto exit;
+		goto fail_pbuf;
 	}
 
-	__wl_band_2ghz.n_channels = 0;
-	__wl_band_5ghz_a.n_channels = 0;
+	brcmf_count_20mhz_channels(cfg, list, chcnt);
+	wiphy = cfg_to_wiphy(cfg);
+	if (chcnt[0]) {
+		band = kmemdup(&__wl_band_2ghz, sizeof(__wl_band_2ghz),
+			       GFP_KERNEL);
+		if (band == NULL) {
+			err = -ENOMEM;
+			goto fail_pbuf;
+		}
+		band->channels = kcalloc(chcnt[0], sizeof(*channel),
+					 GFP_KERNEL);
+		if (band->channels == NULL) {
+			kfree(band);
+			err = -ENOMEM;
+			goto fail_pbuf;
+		}
+		band->n_channels = 0;
+		wiphy->bands[IEEE80211_BAND_2GHZ] = band;
+	}
+	if (chcnt[1]) {
+		band = kmemdup(&__wl_band_5ghz_a, sizeof(__wl_band_5ghz_a),
+			       GFP_KERNEL);
+		if (band == NULL) {
+			err = -ENOMEM;
+			goto fail_band2g;
+		}
+		band->channels = kcalloc(chcnt[1], sizeof(*channel),
+					 GFP_KERNEL);
+		if (band->channels == NULL) {
+			kfree(band);
+			err = -ENOMEM;
+			goto fail_band2g;
+		}
+		band->n_channels = 0;
+		wiphy->bands[IEEE80211_BAND_5GHZ] = band;
+	}
 
 	total = le32_to_cpu(list->count);
 	for (i = 0; i < total; i++) {
@@ -4956,105 +4983,88 @@ static s32 brcmf_construct_reginfo(struct brcmf_cfg80211_info *cfg,
 		cfg->d11inf.decchspec(&ch);
 
 		if (ch.band == BRCMU_CHAN_BAND_2G) {
-			band_chan_arr = __wl_2ghz_channels;
-			array_size = ARRAY_SIZE(__wl_2ghz_channels);
-			n_cnt = &__wl_band_2ghz.n_channels;
-			band = IEEE80211_BAND_2GHZ;
+			band = wiphy->bands[IEEE80211_BAND_2GHZ];
 		} else if (ch.band == BRCMU_CHAN_BAND_5G) {
-			band_chan_arr = __wl_5ghz_a_channels;
-			array_size = ARRAY_SIZE(__wl_5ghz_a_channels);
-			n_cnt = &__wl_band_5ghz_a.n_channels;
-			band = IEEE80211_BAND_5GHZ;
+			band = wiphy->bands[IEEE80211_BAND_5GHZ];
 		} else {
 			brcmf_err("Invalid channel Spec. 0x%x.\n", ch.chspec);
 			continue;
 		}
-		if (!(bw_cap[band] & WLC_BW_40MHZ_BIT) &&
+		if (!(bw_cap[band->band] & WLC_BW_40MHZ_BIT) &&
 		    ch.bw == BRCMU_CHAN_BW_40)
 			continue;
-		if (!(bw_cap[band] & WLC_BW_80MHZ_BIT) &&
+		if (!(bw_cap[band->band] & WLC_BW_80MHZ_BIT) &&
 		    ch.bw == BRCMU_CHAN_BW_80)
 			continue;
-		update = false;
-		for (j = 0; (j < *n_cnt && (*n_cnt < array_size)); j++) {
-			if (band_chan_arr[j].hw_value == ch.chnum) {
-				update = true;
+
+		channel = band->channels;
+		index = band->n_channels;
+		for (j = 0; j < band->n_channels; j++) {
+			if (channel[j].hw_value == ch.chnum) {
+				index = j;
 				break;
 			}
 		}
-		if (update)
-			index = j;
-		else
-			index = *n_cnt;
-		if (index <  array_size) {
-			band_chan_arr[index].center_freq =
-				ieee80211_channel_to_frequency(ch.chnum, band);
-			band_chan_arr[index].hw_value = ch.chnum;
-
-			/* assuming the chanspecs order is HT20,
-			 * HT40 upper, HT40 lower, and VHT80.
+		channel[index].center_freq =
+			ieee80211_channel_to_frequency(ch.chnum, band->band);
+		channel[index].hw_value = ch.chnum;
+
+		/* assuming the chanspecs order is HT20,
+		 * HT40 upper, HT40 lower, and VHT80.
+		 */
+		if (ch.bw == BRCMU_CHAN_BW_80) {
+			channel[index].flags &= ~IEEE80211_CHAN_NO_80MHZ;
+		} else if (ch.bw == BRCMU_CHAN_BW_40) {
+			brcmf_update_bw40_channel_flag(&channel[index], &ch);
+		} else {
+			/* disable other bandwidths for now as mentioned
+			 * order assure they are enabled for subsequent
+			 * chanspecs.
 			 */
-			if (ch.bw == BRCMU_CHAN_BW_80) {
-				band_chan_arr[index].flags &=
-					~IEEE80211_CHAN_NO_80MHZ;
-			} else if (ch.bw == BRCMU_CHAN_BW_40) {
-				ht40_flag = band_chan_arr[index].flags &
-					    IEEE80211_CHAN_NO_HT40;
-				if (ch.sb == BRCMU_CHAN_SB_U) {
-					if (ht40_flag == IEEE80211_CHAN_NO_HT40)
-						band_chan_arr[index].flags &=
-							~IEEE80211_CHAN_NO_HT40;
-					band_chan_arr[index].flags |=
-						IEEE80211_CHAN_NO_HT40PLUS;
-				} else {
-					/* It should be one of
-					 * IEEE80211_CHAN_NO_HT40 or
-					 * IEEE80211_CHAN_NO_HT40PLUS
-					 */
-					band_chan_arr[index].flags &=
-							~IEEE80211_CHAN_NO_HT40;
-					if (ht40_flag == IEEE80211_CHAN_NO_HT40)
-						band_chan_arr[index].flags |=
-						    IEEE80211_CHAN_NO_HT40MINUS;
-				}
-			} else {
-				/* disable other bandwidths for now as mentioned
-				 * order assure they are enabled for subsequent
-				 * chanspecs.
-				 */
-				band_chan_arr[index].flags =
-						IEEE80211_CHAN_NO_HT40 |
-						IEEE80211_CHAN_NO_80MHZ;
-				ch.bw = BRCMU_CHAN_BW_20;
-				cfg->d11inf.encchspec(&ch);
-				channel = ch.chspec;
-				err = brcmf_fil_bsscfg_int_get(ifp,
-							       "per_chan_info",
-							       &channel);
-				if (!err) {
-					if (channel & WL_CHAN_RADAR)
-						band_chan_arr[index].flags |=
-							(IEEE80211_CHAN_RADAR |
-							IEEE80211_CHAN_NO_IR);
-					if (channel & WL_CHAN_PASSIVE)
-						band_chan_arr[index].flags |=
-						    IEEE80211_CHAN_NO_IR;
-				}
+			channel[index].flags = IEEE80211_CHAN_NO_HT40 |
+					       IEEE80211_CHAN_NO_80MHZ;
+			ch.bw = BRCMU_CHAN_BW_20;
+			cfg->d11inf.encchspec(&ch);
+			chaninfo = ch.chspec;
+			err = brcmf_fil_bsscfg_int_get(ifp, "per_chan_info",
+						       &chaninfo);
+			if (!err) {
+				if (chaninfo & WL_CHAN_RADAR)
+					channel[index].flags |=
+						(IEEE80211_CHAN_RADAR |
+						 IEEE80211_CHAN_NO_IR);
+				if (chaninfo & WL_CHAN_PASSIVE)
+					channel[index].flags |=
+						IEEE80211_CHAN_NO_IR;
 			}
-			if (!update)
-				(*n_cnt)++;
 		}
+		if (index == band->n_channels)
+			band->n_channels++;
 	}
-exit:
+	kfree(pbuf);
+	return 0;
+
+fail_band2g:
+	kfree(wiphy->bands[IEEE80211_BAND_2GHZ]->channels);
+	kfree(wiphy->bands[IEEE80211_BAND_2GHZ]);
+	wiphy->bands[IEEE80211_BAND_2GHZ] = NULL;
+fail_pbuf:
 	kfree(pbuf);
 	return err;
 }
 
-static int brcmf_enable_bw40_2g(struct brcmf_if *ifp)
+static int brcmf_enable_bw40_2g(struct brcmf_cfg80211_info *cfg)
 {
+	struct brcmf_if *ifp = netdev_priv(cfg_to_ndev(cfg));
+	struct ieee80211_supported_band *band;
 	struct brcmf_fil_bwcap_le band_bwcap;
+	struct brcmf_chanspec_list *list;
+	u8 *pbuf;
 	u32 val;
 	int err;
+	struct brcmu_chan ch;
+	u32 num_chan;
+	int i, j;
 
 	/* verify support for bw_cap command */
 	val = WLC_BAND_5G;
@@ -5071,6 +5081,50 @@ static int brcmf_enable_bw40_2g(struct brcmf_if *ifp)
 		val = WLC_N_BW_40ALL;
 		err = brcmf_fil_iovar_int_set(ifp, "mimo_bw_cap", val);
 	}
+
+	if (!err) {
+		/* update channel info in 2G band */
+		pbuf = kzalloc(BRCMF_DCMD_MEDLEN, GFP_KERNEL);
+
+		if (pbuf == NULL)
+			return -ENOMEM;
+
+		ch.band = BRCMU_CHAN_BAND_2G;
+		ch.bw = BRCMU_CHAN_BW_40;
+		ch.chnum = 0;
+		cfg->d11inf.encchspec(&ch);
+
+		/* pass encoded chanspec in query */
+		*(__le16 *)pbuf = cpu_to_le16(ch.chspec);
+
+		err = brcmf_fil_iovar_data_get(ifp, "chanspecs", pbuf,
+					       BRCMF_DCMD_MEDLEN);
+		if (err) {
+			brcmf_err("get chanspecs error (%d)\n", err);
+			kfree(pbuf);
+			return err;
+		}
+
+		band = cfg_to_wiphy(cfg)->bands[IEEE80211_BAND_2GHZ];
+		list = (struct brcmf_chanspec_list *)pbuf;
+		num_chan = le32_to_cpu(list->count);
+		for (i = 0; i < num_chan; i++) {
+			ch.chspec = (u16)le32_to_cpu(list->element[i]);
+			cfg->d11inf.decchspec(&ch);
+			if (WARN_ON(ch.band != BRCMU_CHAN_BAND_2G))
+				continue;
+			if (WARN_ON(ch.bw != BRCMU_CHAN_BW_40))
+				continue;
+			for (j = 0; j < band->n_channels; j++) {
+				if (band->channels[j].hw_value == ch.chnum)
+					break;
+			}
+			if (WARN_ON(j == band->n_channels))
+				continue;
+
+			brcmf_update_bw40_channel_flag(&band->channels[j], &ch);
+		}
+	}
 	return err;
 }
 
@@ -5164,44 +5218,19 @@ static void brcmf_update_vht_cap(struct ieee80211_supported_band *band,
 	band->vht_cap.vht_mcs.tx_mcs_map = mcs_map;
 }
 
-static s32 brcmf_update_wiphybands(struct brcmf_cfg80211_info *cfg)
+static int brcmf_setup_wiphybands(struct wiphy *wiphy)
 {
+	struct brcmf_cfg80211_info *cfg = wiphy_priv(wiphy);
 	struct brcmf_if *ifp = netdev_priv(cfg_to_ndev(cfg));
-	struct wiphy *wiphy;
-	s32 phy_list;
-	u32 band_list[3];
 	u32 nmode = 0;
 	u32 vhtmode = 0;
-	u32 bw_cap[2] = { 0, 0 };
+	u32 bw_cap[2] = { WLC_BW_20MHZ_BIT, WLC_BW_20MHZ_BIT };
 	u32 rxchain;
 	u32 nchain;
-	s8 phy;
-	s32 err;
-	u32 nband;
+	int err;
 	s32 i;
-	struct ieee80211_supported_band *bands[2] = { NULL, NULL };
 	struct ieee80211_supported_band *band;
 
-	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_PHYLIST,
-				     &phy_list, sizeof(phy_list));
-	if (err) {
-		brcmf_err("BRCMF_C_GET_PHYLIST error (%d)\n", err);
-		return err;
-	}
-
-	phy = ((char *)&phy_list)[0];
-	brcmf_dbg(INFO, "BRCMF_C_GET_PHYLIST reported: %c phy\n", phy);
-
-
-	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_BANDLIST,
-				     &band_list, sizeof(band_list));
-	if (err) {
-		brcmf_err("BRCMF_C_GET_BANDLIST error (%d)\n", err);
-		return err;
-	}
-	brcmf_dbg(INFO, "BRCMF_C_GET_BANDLIST reported: 0x%08x 0x%08x 0x%08x phy\n",
-		  band_list[0], band_list[1], band_list[2]);
-
 	(void)brcmf_fil_iovar_int_get(ifp, "vhtmode", &vhtmode);
 	err = brcmf_fil_iovar_int_get(ifp, "nmode", &nmode);
 	if (err) {
@@ -5223,38 +5252,25 @@ static s32 brcmf_update_wiphybands(struct brcmf_cfg80211_info *cfg)
 	}
 	brcmf_dbg(INFO, "nchain=%d\n", nchain);
 
-	err = brcmf_construct_reginfo(cfg, bw_cap);
+	err = brcmf_construct_chaninfo(cfg, bw_cap);
 	if (err) {
-		brcmf_err("brcmf_construct_reginfo failed (%d)\n", err);
+		brcmf_err("brcmf_construct_chaninfo failed (%d)\n", err);
 		return err;
 	}
 
-	nband = band_list[0];
-
-	for (i = 1; i <= nband && i < ARRAY_SIZE(band_list); i++) {
-		band = NULL;
-		if ((band_list[i] == WLC_BAND_5G) &&
-		    (__wl_band_5ghz_a.n_channels > 0))
-			band = &__wl_band_5ghz_a;
-		else if ((band_list[i] == WLC_BAND_2G) &&
-			 (__wl_band_2ghz.n_channels > 0))
-			band = &__wl_band_2ghz;
-		else
+	wiphy = cfg_to_wiphy(cfg);
+	for (i = 0; i < ARRAY_SIZE(wiphy->bands); i++) {
+		band = wiphy->bands[i];
+		if (band == NULL)
 			continue;
 
 		if (nmode)
 			brcmf_update_ht_cap(band, bw_cap, nchain);
 		if (vhtmode)
 			brcmf_update_vht_cap(band, bw_cap, nchain);
-		bands[band->band] = band;
 	}
 
-	wiphy = cfg_to_wiphy(cfg);
-	wiphy->bands[IEEE80211_BAND_2GHZ] = bands[IEEE80211_BAND_2GHZ];
-	wiphy->bands[IEEE80211_BAND_5GHZ] = bands[IEEE80211_BAND_5GHZ];
-	wiphy_apply_custom_regulatory(wiphy, &brcmf_regdom);
-
-	return err;
+	return 0;
 }
 
 static const struct ieee80211_iface_limit brcmf_iface_limits[] = {
@@ -5321,18 +5337,9 @@ static void brcmf_wiphy_pno_params(struct wiphy *wiphy)
 	wiphy->flags |= WIPHY_FLAG_SUPPORTS_SCHED_SCAN;
 }
 
-static struct wiphy *brcmf_setup_wiphy(struct brcmf_if *ifp,
-				       struct device *phydev)
+static int brcmf_setup_wiphy(struct wiphy *wiphy, struct brcmf_if *ifp)
 {
-	struct wiphy *wiphy;
-	s32 err = 0;
-
-	wiphy = wiphy_new(&wl_cfg80211_ops, sizeof(struct brcmf_cfg80211_info));
-	if (!wiphy) {
-		brcmf_err("Could not allocate wiphy device\n");
-		return ERR_PTR(-ENOMEM);
-	}
-	set_wiphy_dev(wiphy, phydev);
+	struct ieee80211_iface_combination ifc_combo;
 	wiphy->max_scan_ssids = WL_NUM_SCAN_MAX;
 	wiphy->max_scan_ie_len = BRCMF_SCAN_IE_LEN_MAX;
 	wiphy->max_num_pmkids = WL_NUM_PMKIDS_MAX;
@@ -5343,11 +5350,13 @@ static struct wiphy *brcmf_setup_wiphy(struct brcmf_if *ifp,
 				 BIT(NL80211_IFTYPE_P2P_GO) |
 				 BIT(NL80211_IFTYPE_P2P_DEVICE);
 	/* need VSDB firmware feature for concurrent channels */
+	ifc_combo = brcmf_iface_combos[0];
 	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MCHAN))
-		brcmf_iface_combos[0].num_different_channels = 2;
-	wiphy->iface_combinations = brcmf_iface_combos;
+		ifc_combo.num_different_channels = 2;
+	wiphy->iface_combinations = kmemdup(&ifc_combo,
+					    sizeof(ifc_combo),
+					    GFP_KERNEL);
 	wiphy->n_iface_combinations = ARRAY_SIZE(brcmf_iface_combos);
-	wiphy->bands[IEEE80211_BAND_2GHZ] = &__wl_band_2ghz;
 	wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
 	wiphy->cipher_suites = __wl_cipher_suites;
 	wiphy->n_cipher_suites = ARRAY_SIZE(__wl_cipher_suites);
@@ -5360,27 +5369,12 @@ static struct wiphy *brcmf_setup_wiphy(struct brcmf_if *ifp,
 	wiphy->mgmt_stypes = brcmf_txrx_stypes;
 	wiphy->max_remain_on_channel_duration = 5000;
 	brcmf_wiphy_pno_params(wiphy);
-	brcmf_dbg(INFO, "Registering custom regulatory\n");
-	wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG;
-	wiphy_apply_custom_regulatory(wiphy, &brcmf_regdom);
 
 	/* vendor commands/events support */
 	wiphy->vendor_commands = brcmf_vendor_cmds;
 	wiphy->n_vendor_commands = BRCMF_VNDR_CMDS_LAST - 1;
 
-	err = wiphy_register(wiphy);
-	if (err < 0) {
-		brcmf_err("Could not register wiphy device (%d)\n", err);
-		wiphy_free(wiphy);
-		return ERR_PTR(err);
-	}
-	return wiphy;
-}
-
-
-static s32 brcmf_dongle_probecap(struct brcmf_cfg80211_info *cfg)
-{
-	return brcmf_update_wiphybands(cfg);
+	return brcmf_setup_wiphybands(wiphy);
 }
 
 static s32 brcmf_config_dongle(struct brcmf_cfg80211_info *cfg)
@@ -5418,9 +5412,6 @@ static s32 brcmf_config_dongle(struct brcmf_cfg80211_info *cfg)
 					  NULL, NULL);
 	if (err)
 		goto default_conf_out;
-	err = brcmf_dongle_probecap(cfg);
-	if (err)
-		goto default_conf_out;
 
 	brcmf_configure_arp_offload(ifp, true);
 
@@ -5548,6 +5539,20 @@ int brcmf_cfg80211_wait_vif_event_timeout(struct brcmf_cfg80211_info *cfg,
 				  vif_event_equals(event, action), timeout);
 }
 
+static void brcmf_free_wiphy(struct wiphy *wiphy)
+{
+	kfree(wiphy->iface_combinations);
+	if (wiphy->bands[IEEE80211_BAND_2GHZ]) {
+		kfree(wiphy->bands[IEEE80211_BAND_2GHZ]->channels);
+		kfree(wiphy->bands[IEEE80211_BAND_2GHZ]);
+	}
+	if (wiphy->bands[IEEE80211_BAND_5GHZ]) {
+		kfree(wiphy->bands[IEEE80211_BAND_5GHZ]->channels);
+		kfree(wiphy->bands[IEEE80211_BAND_5GHZ]);
+	}
+	wiphy_free(wiphy);
+}
+
 struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 						  struct device *busdev)
 {
@@ -5558,6 +5563,7 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 	struct brcmf_if *ifp;
 	s32 err = 0;
 	s32 io_type;
+	u16 *cap = NULL;
 
 	if (!ndev) {
 		brcmf_err("ndev is invalid\n");
@@ -5565,9 +5571,12 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 	}
 
 	ifp = netdev_priv(ndev);
-	wiphy = brcmf_setup_wiphy(ifp, busdev);
-	if (IS_ERR(wiphy))
+	wiphy = wiphy_new(&wl_cfg80211_ops, sizeof(struct brcmf_cfg80211_info));
+	if (!wiphy) {
+		brcmf_err("Could not allocate wiphy device\n");
 		return NULL;
+	}
+	set_wiphy_dev(wiphy, busdev);
 
 	cfg = wiphy_priv(wiphy);
 	cfg->wiphy = wiphy;
@@ -5576,10 +5585,8 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
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
@@ -5589,58 +5596,81 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 	err = wl_init_priv(cfg);
 	if (err) {
 		brcmf_err("Failed to init iwm_priv (%d)\n", err);
-		goto cfg80211_attach_out;
+		brcmf_free_vif(vif);
+		goto wiphy_out;
 	}
 	ifp->vif = vif;
 
-	err = brcmf_p2p_attach(cfg);
+	/* determine d11 io type before wiphy setup */
+	err = brcmf_fil_cmd_int_get(ifp, BRCMF_C_GET_VERSION, &io_type);
 	if (err) {
-		brcmf_err("P2P initilisation failed (%d)\n", err);
-		goto cfg80211_p2p_attach_out;
+		brcmf_err("Failed to get D11 version (%d)\n", err);
+		goto priv_out;
 	}
-	err = brcmf_btcoex_attach(cfg);
-	if (err) {
-		brcmf_err("BT-coex initialisation failed (%d)\n", err);
-		brcmf_p2p_detach(&cfg->p2p);
-		goto cfg80211_p2p_attach_out;
+	cfg->d11inf.io_type = (u8)io_type;
+	brcmu_d11_attach(&cfg->d11inf);
+
+	err = brcmf_setup_wiphy(wiphy, ifp);
+	if (err < 0)
+		goto priv_out;
+
+	brcmf_dbg(INFO, "Registering custom regulatory\n");
+	wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG;
+	wiphy_apply_custom_regulatory(wiphy, &brcmf_regdom);
+
+	/* firmware defaults to 40MHz disabled in 2G band. We signal
+	 * cfg80211 here that we do and have it decide we can enable
+	 * it. But first check if device does support 2G operation.
+	 */
+	if (wiphy->bands[IEEE80211_BAND_2GHZ]) {
+		cap = &wiphy->bands[IEEE80211_BAND_2GHZ]->ht_cap.cap;
+		*cap |= IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+	}
+	err = wiphy_register(wiphy);
+	if (err < 0) {
+		brcmf_err("Could not register wiphy device (%d)\n", err);
+		goto priv_out;
 	}
 
 	/* If cfg80211 didn't disable 40MHz HT CAP in wiphy_register(),
 	 * setup 40MHz in 2GHz band and enable OBSS scanning.
 	 */
-	if (wiphy->bands[IEEE80211_BAND_2GHZ]->ht_cap.cap &
-	    IEEE80211_HT_CAP_SUP_WIDTH_20_40) {
-		err = brcmf_enable_bw40_2g(ifp);
+	if (cap && (*cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)) {
+		err = brcmf_enable_bw40_2g(cfg);
 		if (!err)
 			err = brcmf_fil_iovar_int_set(ifp, "obss_coex",
 						      BRCMF_OBSS_COEX_AUTO);
+		else
+			*cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
 	}
-	/* clear for now and rely on update later */
-	wiphy->bands[IEEE80211_BAND_2GHZ]->ht_cap.ht_supported = false;
-	wiphy->bands[IEEE80211_BAND_2GHZ]->ht_cap.cap = 0;
 
-	err = brcmf_fil_iovar_int_set(ifp, "tdls_enable", 1);
+	err = brcmf_p2p_attach(cfg);
 	if (err) {
-		brcmf_dbg(INFO, "TDLS not enabled (%d)\n", err);
-		wiphy->flags &= ~WIPHY_FLAG_SUPPORTS_TDLS;
+		brcmf_err("P2P initilisation failed (%d)\n", err);
+		goto wiphy_unreg_out;
+	}
+	err = brcmf_btcoex_attach(cfg);
+	if (err) {
+		brcmf_err("BT-coex initialisation failed (%d)\n", err);
+		brcmf_p2p_detach(&cfg->p2p);
+		goto wiphy_unreg_out;
 	}
 
-	err = brcmf_fil_cmd_int_get(ifp, BRCMF_C_GET_VERSION,
-				    &io_type);
+	err = brcmf_fil_iovar_int_set(ifp, "tdls_enable", 1);
 	if (err) {
-		brcmf_err("Failed to get D11 version (%d)\n", err);
-		goto cfg80211_p2p_attach_out;
+		brcmf_dbg(INFO, "TDLS not enabled (%d)\n", err);
+		wiphy->flags &= ~WIPHY_FLAG_SUPPORTS_TDLS;
 	}
-	cfg->d11inf.io_type = (u8)io_type;
-	brcmu_d11_attach(&cfg->d11inf);
 
 	return cfg;
 
-cfg80211_p2p_attach_out:
+wiphy_unreg_out:
+	wiphy_unregister(cfg->wiphy);
+priv_out:
 	wl_deinit_priv(cfg);
-
-cfg80211_attach_out:
 	brcmf_free_vif(vif);
+wiphy_out:
+	brcmf_free_wiphy(wiphy);
 	return NULL;
 }
 
@@ -5653,6 +5683,5 @@ void brcmf_cfg80211_detach(struct brcmf_cfg80211_info *cfg)
 	wiphy_unregister(cfg->wiphy);
 	brcmf_btcoex_detach(cfg);
 	wl_deinit_priv(cfg);
-	wiphy_free(cfg->wiphy);
+	brcmf_free_wiphy(cfg->wiphy);
 }
-
-- 
1.9.1

