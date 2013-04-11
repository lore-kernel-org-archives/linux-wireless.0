Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4971 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754675Ab3DKL3Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 07:29:25 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 05/15] brcmfmac: adopt new d11 interface
Date: Thu, 11 Apr 2013 13:28:50 +0200
Message-ID: <1365679740-25679-6-git-send-email-arend@broadcom.com> (sfid-20130411_133114_989705_1E15052A)
In-Reply-To: <1365679740-25679-1-git-send-email-arend@broadcom.com>
References: <1365679740-25679-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Adopting the new d11 interface for 11ac fullmac chip support.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |   98 +++++++-------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  134 ++++++++++----------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |    7 +-
 4 files changed, 125 insertions(+), 115 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 5249c67..28db9cf 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -28,6 +28,7 @@
 /*******************************************************************************
  * IO codes that are interpreted by dongle firmware
  ******************************************************************************/
+#define BRCMF_C_GET_VERSION			1
 #define BRCMF_C_UP				2
 #define BRCMF_C_DOWN				3
 #define BRCMF_C_SET_PROMISC			10
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index 94ff045..2b90da0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -424,29 +424,6 @@ static void brcmf_p2p_print_actframe(bool tx, void *frame, u32 frame_len)
 
 
 /**
- * brcmf_p2p_chnr_to_chspec() - convert channel number to chanspec.
- *
- * @channel: channel number
- */
-static u16 brcmf_p2p_chnr_to_chspec(u16 channel)
-{
-	u16 chanspec;
-
-	chanspec = channel & WL_CHANSPEC_CHAN_MASK;
-
-	if (channel <= CH_MAX_2G_CHANNEL)
-		chanspec |= WL_CHANSPEC_BAND_2G;
-	else
-		chanspec |= WL_CHANSPEC_BAND_5G;
-
-	chanspec |= WL_CHANSPEC_BW_20;
-	chanspec |= WL_CHANSPEC_CTL_SB_NONE;
-
-	return chanspec;
-}
-
-
-/**
  * brcmf_p2p_set_firmware() - prepare firmware for peer-to-peer operation.
  *
  * @ifp: ifp to use for iovars (primary).
@@ -837,7 +814,8 @@ static s32 brcmf_p2p_run_escan(struct brcmf_cfg80211_info *cfg,
 					   IEEE80211_CHAN_PASSIVE_SCAN))
 				continue;
 
-			chanspecs[i] = channel_to_chanspec(chan);
+			chanspecs[i] = channel_to_chanspec(&p2p->cfg->d11inf,
+							   chan);
 			brcmf_dbg(INFO, "%d: chan=%d, channel spec=%x\n",
 				  num_nodfs, chan->hw_value, chanspecs[i]);
 			num_nodfs++;
@@ -945,8 +923,8 @@ static s32
 brcmf_p2p_discover_listen(struct brcmf_p2p_info *p2p, u16 channel, u32 duration)
 {
 	struct brcmf_cfg80211_vif *vif;
+	struct brcmu_chan ch;
 	s32 err = 0;
-	u16 chanspec;
 
 	vif = p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
 	if (!vif) {
@@ -961,9 +939,11 @@ brcmf_p2p_discover_listen(struct brcmf_p2p_info *p2p, u16 channel, u32 duration)
 		goto exit;
 	}
 
-	chanspec = brcmf_p2p_chnr_to_chspec(channel);
+	ch.chnum = channel;
+	ch.bw = BRCMU_CHAN_BW_20;
+	p2p->cfg->d11inf.encchspec(&ch);
 	err = brcmf_p2p_set_discover_state(vif->ifp, WL_P2P_DISC_ST_LISTEN,
-					   chanspec, (u16)duration);
+					   ch.chspec, (u16)duration);
 	if (!err) {
 		set_bit(BRCMF_P2P_STATUS_DISCOVER_LISTEN, &p2p->status);
 		p2p->remain_on_channel_cookie++;
@@ -1075,6 +1055,7 @@ static s32 brcmf_p2p_act_frm_search(struct brcmf_p2p_info *p2p, u16 channel)
 	u32 channel_cnt;
 	u16 *default_chan_list;
 	u32 i;
+	struct brcmu_chan ch;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -1089,15 +1070,23 @@ static s32 brcmf_p2p_act_frm_search(struct brcmf_p2p_info *p2p, u16 channel)
 		err = -ENOMEM;
 		goto exit;
 	}
+	ch.bw = BRCMU_CHAN_BW_20;
 	if (channel) {
+		ch.chnum = channel;
+		p2p->cfg->d11inf.encchspec(&ch);
 		/* insert same channel to the chan_list */
 		for (i = 0; i < channel_cnt; i++)
-			default_chan_list[i] =
-					brcmf_p2p_chnr_to_chspec(channel);
+			default_chan_list[i] = ch.chspec;
 	} else {
-		default_chan_list[0] = brcmf_p2p_chnr_to_chspec(SOCIAL_CHAN_1);
-		default_chan_list[1] = brcmf_p2p_chnr_to_chspec(SOCIAL_CHAN_2);
-		default_chan_list[2] = brcmf_p2p_chnr_to_chspec(SOCIAL_CHAN_3);
+		ch.chnum = SOCIAL_CHAN_1;
+		p2p->cfg->d11inf.encchspec(&ch);
+		default_chan_list[0] = ch.chspec;
+		ch.chnum = SOCIAL_CHAN_2;
+		p2p->cfg->d11inf.encchspec(&ch);
+		default_chan_list[1] = ch.chspec;
+		ch.chnum = SOCIAL_CHAN_3;
+		p2p->cfg->d11inf.encchspec(&ch);
+		default_chan_list[2] = ch.chspec;
 	}
 	err = brcmf_p2p_escan(p2p, channel_cnt, default_chan_list,
 			      WL_P2P_DISC_ST_SEARCH, WL_ESCAN_ACTION_START,
@@ -1227,6 +1216,7 @@ bool brcmf_p2p_scan_finding_common_channel(struct brcmf_cfg80211_info *cfg,
 {
 	struct brcmf_p2p_info *p2p = &cfg->p2p;
 	struct afx_hdl *afx_hdl = &p2p->afx_hdl;
+	struct brcmu_chan ch;
 	u8 *ie;
 	s32 err;
 	u8 p2p_dev_addr[ETH_ALEN];
@@ -1252,8 +1242,12 @@ bool brcmf_p2p_scan_finding_common_channel(struct brcmf_cfg80211_info *cfg,
 					    p2p_dev_addr, sizeof(p2p_dev_addr));
 	if ((err >= 0) &&
 	    (!memcmp(p2p_dev_addr, afx_hdl->tx_dst_addr, ETH_ALEN))) {
-		afx_hdl->peer_chan = bi->ctl_ch ? bi->ctl_ch :
-				      CHSPEC_CHANNEL(le16_to_cpu(bi->chanspec));
+		if (!bi->ctl_ch) {
+			ch.chspec = le16_to_cpu(bi->chanspec);
+			cfg->d11inf.decchspec(&ch);
+			bi->ctl_ch = ch.chnum;
+		}
+		afx_hdl->peer_chan = bi->ctl_ch;
 		brcmf_dbg(TRACE, "ACTION FRAME SCAN : Peer %pM found, channel : %d\n",
 			  afx_hdl->tx_dst_addr, afx_hdl->peer_chan);
 		complete(&afx_hdl->act_frm_scan);
@@ -1360,12 +1354,14 @@ int brcmf_p2p_notify_action_frame_rx(struct brcmf_if *ifp,
 	u8 *frame = (u8 *)(rxframe + 1);
 	struct brcmf_p2p_pub_act_frame *act_frm;
 	struct brcmf_p2psd_gas_pub_act_frame *sd_act_frm;
-	u16 chanspec = be16_to_cpu(rxframe->chanspec);
+	struct brcmu_chan ch;
 	struct ieee80211_mgmt *mgmt_frame;
 	s32 freq;
 	u16 mgmt_type;
 	u8 action;
 
+	ch.chspec = be16_to_cpu(rxframe->chanspec);
+	cfg->d11inf.decchspec(&ch);
 	/* Check if wpa_supplicant has registered for this frame */
 	brcmf_dbg(INFO, "ifp->vif->mgmt_rx_reg %04x\n", ifp->vif->mgmt_rx_reg);
 	mgmt_type = (IEEE80211_STYPE_ACTION & IEEE80211_FCTL_STYPE) >> 4;
@@ -1384,7 +1380,7 @@ int brcmf_p2p_notify_action_frame_rx(struct brcmf_if *ifp,
 				     &p2p->status) &&
 			    (memcmp(afx_hdl->tx_dst_addr, e->addr,
 				    ETH_ALEN) == 0)) {
-				afx_hdl->peer_chan = CHSPEC_CHANNEL(chanspec);
+				afx_hdl->peer_chan = ch.chnum;
 				brcmf_dbg(INFO, "GON request: Peer found, channel=%d\n",
 					  afx_hdl->peer_chan);
 				complete(&afx_hdl->act_frm_scan);
@@ -1427,8 +1423,8 @@ int brcmf_p2p_notify_action_frame_rx(struct brcmf_if *ifp,
 	memcpy(&mgmt_frame->u, frame, mgmt_frame_len);
 	mgmt_frame_len += offsetof(struct ieee80211_mgmt, u);
 
-	freq = ieee80211_channel_to_frequency(CHSPEC_CHANNEL(chanspec),
-					      CHSPEC_IS2G(chanspec) ?
+	freq = ieee80211_channel_to_frequency(ch.chnum,
+					      ch.band == BRCMU_CHAN_BAND_2G ?
 					      IEEE80211_BAND_2GHZ :
 					      IEEE80211_BAND_5GHZ);
 
@@ -1854,6 +1850,7 @@ s32 brcmf_p2p_notify_rx_mgmt_p2p_probereq(struct brcmf_if *ifp,
 	struct brcmf_cfg80211_vif *vif = ifp->vif;
 	struct brcmf_rx_mgmt_data *rxframe = (struct brcmf_rx_mgmt_data *)data;
 	u16 chanspec = be16_to_cpu(rxframe->chanspec);
+	struct brcmu_chan ch;
 	u8 *mgmt_frame;
 	u32 mgmt_frame_len;
 	s32 freq;
@@ -1862,9 +1859,12 @@ s32 brcmf_p2p_notify_rx_mgmt_p2p_probereq(struct brcmf_if *ifp,
 	brcmf_dbg(INFO, "Enter: event %d reason %d\n", e->event_code,
 		  e->reason);
 
+	ch.chspec = be16_to_cpu(rxframe->chanspec);
+	cfg->d11inf.decchspec(&ch);
+
 	if (test_bit(BRCMF_P2P_STATUS_FINDING_COMMON_CHANNEL, &p2p->status) &&
 	    (memcmp(afx_hdl->tx_dst_addr, e->addr, ETH_ALEN) == 0)) {
-		afx_hdl->peer_chan = CHSPEC_CHANNEL(chanspec);
+		afx_hdl->peer_chan = ch.chnum;
 		brcmf_dbg(INFO, "PROBE REQUEST: Peer found, channel=%d\n",
 			  afx_hdl->peer_chan);
 		complete(&afx_hdl->act_frm_scan);
@@ -1889,8 +1889,8 @@ s32 brcmf_p2p_notify_rx_mgmt_p2p_probereq(struct brcmf_if *ifp,
 
 	mgmt_frame = (u8 *)(rxframe + 1);
 	mgmt_frame_len = e->datalen - sizeof(*rxframe);
-	freq = ieee80211_channel_to_frequency(CHSPEC_CHANNEL(chanspec),
-					      CHSPEC_IS2G(chanspec) ?
+	freq = ieee80211_channel_to_frequency(ch.chnum,
+					      ch.band == BRCMU_CHAN_BAND_2G ?
 					      IEEE80211_BAND_2GHZ :
 					      IEEE80211_BAND_5GHZ);
 
@@ -2014,21 +2014,19 @@ static void brcmf_p2p_get_current_chanspec(struct brcmf_p2p_info *p2p,
 {
 	struct brcmf_if *ifp;
 	struct brcmf_fil_chan_info_le ci;
+	struct brcmu_chan ch;
 	s32 err;
 
 	ifp = p2p->bss_idx[P2PAPI_BSSCFG_PRIMARY].vif->ifp;
 
-	*chanspec = 11 & WL_CHANSPEC_CHAN_MASK;
+	ch.chnum = 11;
 
 	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_CHANNEL, &ci, sizeof(ci));
-	if (!err) {
-		*chanspec = le32_to_cpu(ci.hw_channel) & WL_CHANSPEC_CHAN_MASK;
-		if (*chanspec < CH_MAX_2G_CHANNEL)
-			*chanspec |= WL_CHANSPEC_BAND_2G;
-		else
-			*chanspec |= WL_CHANSPEC_BAND_5G;
-	}
-	*chanspec |= WL_CHANSPEC_BW_20 | WL_CHANSPEC_CTL_SB_NONE;
+	if (!err)
+		ch.chnum = le32_to_cpu(ci.hw_channel);
+	ch.bw = BRCMU_CHAN_BW_20;
+	p2p->cfg->d11inf.encchspec(&ch);
+	*chanspec = ch.chspec;
 }
 
 /**
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 6269920..6c06d0d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -334,22 +334,16 @@ static u8 brcmf_mw_to_qdbm(u16 mw)
 	return qdbm;
 }
 
-u16 channel_to_chanspec(struct ieee80211_channel *ch)
+u16 channel_to_chanspec(struct brcmu_d11inf *d11inf,
+			struct ieee80211_channel *ch)
 {
-	u16 chanspec;
-
-	chanspec = ieee80211_frequency_to_channel(ch->center_freq);
-	chanspec &= WL_CHANSPEC_CHAN_MASK;
+	struct brcmu_chan ch_inf;
 
-	if (ch->band == IEEE80211_BAND_2GHZ)
-		chanspec |= WL_CHANSPEC_BAND_2G;
-	else
-		chanspec |= WL_CHANSPEC_BAND_5G;
+	ch_inf.chnum = ieee80211_frequency_to_channel(ch->center_freq);
+	ch_inf.bw = BRCMU_CHAN_BW_20;
+	d11inf->encchspec(&ch_inf);
 
-	chanspec |= WL_CHANSPEC_BW_20;
-	chanspec |= WL_CHANSPEC_CTL_SB_NONE;
-
-	return chanspec;
+	return ch_inf.chspec;
 }
 
 /* Traverse a string of 1-byte tag/1-byte length/variable-length value
@@ -680,7 +674,8 @@ done:
 	return err;
 }
 
-static void brcmf_escan_prep(struct brcmf_scan_params_le *params_le,
+static void brcmf_escan_prep(struct brcmf_cfg80211_info *cfg,
+			     struct brcmf_scan_params_le *params_le,
 			     struct cfg80211_scan_request *request)
 {
 	u32 n_ssids;
@@ -712,7 +707,8 @@ static void brcmf_escan_prep(struct brcmf_scan_params_le *params_le,
 		  n_channels);
 	if (n_channels > 0) {
 		for (i = 0; i < n_channels; i++) {
-			chanspec = channel_to_chanspec(request->channels[i]);
+			chanspec = channel_to_chanspec(&cfg->d11inf,
+						       request->channels[i]);
 			brcmf_dbg(SCAN, "Chan : %d, Channel spec: %x\n",
 				  request->channels[i]->hw_value, chanspec);
 			params_le->channel_list[i] = cpu_to_le16(chanspec);
@@ -784,7 +780,7 @@ brcmf_run_escan(struct brcmf_cfg80211_info *cfg, struct brcmf_if *ifp,
 		goto exit;
 	}
 	BUG_ON(params_size + sizeof("escan") >= BRCMF_DCMD_MEDLEN);
-	brcmf_escan_prep(&params->params_le, request);
+	brcmf_escan_prep(cfg, &params->params_le, request);
 	params->version = cpu_to_le32(BRCMF_ESCAN_REQ_VERSION);
 	params->action = cpu_to_le16(action);
 	params->sync_id = cpu_to_le16(0x1234);
@@ -1182,7 +1178,8 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 				params->chandef.chan->center_freq);
 		if (params->channel_fixed) {
 			/* adding chanspec */
-			chanspec = channel_to_chanspec(params->chandef.chan);
+			chanspec = channel_to_chanspec(&cfg->d11inf,
+						       params->chandef.chan);
 			join_params.params_le.chanspec_list[0] =
 				cpu_to_le16(chanspec);
 			join_params.params_le.chanspec_num = cpu_to_le32(1);
@@ -1572,7 +1569,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 	if (chan) {
 		cfg->channel =
 			ieee80211_frequency_to_channel(chan->center_freq);
-		chanspec = channel_to_chanspec(chan);
+		chanspec = channel_to_chanspec(&cfg->d11inf, chan);
 		brcmf_dbg(CONN, "channel=%d, center_req=%d, chanspec=0x%04x\n",
 			  cfg->channel, chan->center_freq, chanspec);
 	} else {
@@ -2231,6 +2228,7 @@ static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_info *cfg,
 	struct ieee80211_channel *notify_channel;
 	struct cfg80211_bss *bss;
 	struct ieee80211_supported_band *band;
+	struct brcmu_chan ch;
 	s32 err = 0;
 	u16 channel;
 	u32 freq;
@@ -2245,8 +2243,12 @@ static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_info *cfg,
 		return 0;
 	}
 
-	channel = bi->ctl_ch ? bi->ctl_ch :
-				CHSPEC_CHANNEL(le16_to_cpu(bi->chanspec));
+	if (!bi->ctl_ch) {
+		ch.chspec = le16_to_cpu(bi->chanspec);
+		cfg->d11inf.decchspec(&ch);
+		bi->ctl_ch = ch.chnum;
+	}
+	channel = bi->ctl_ch;
 
 	if (channel <= CH_MAX_2G_CHANNEL)
 		band = wiphy->bands[IEEE80211_BAND_2GHZ];
@@ -2321,9 +2323,9 @@ static s32 wl_inform_ibss(struct brcmf_cfg80211_info *cfg,
 	struct brcmf_bss_info_le *bi = NULL;
 	struct ieee80211_supported_band *band;
 	struct cfg80211_bss *bss;
+	struct brcmu_chan ch;
 	u8 *buf = NULL;
 	s32 err = 0;
-	u16 channel;
 	u32 freq;
 	u16 notify_capability;
 	u16 notify_interval;
@@ -2350,15 +2352,15 @@ static s32 wl_inform_ibss(struct brcmf_cfg80211_info *cfg,
 
 	bi = (struct brcmf_bss_info_le *)(buf + 4);
 
-	channel = bi->ctl_ch ? bi->ctl_ch :
-				CHSPEC_CHANNEL(le16_to_cpu(bi->chanspec));
+	ch.chspec = le16_to_cpu(bi->chanspec);
+	cfg->d11inf.decchspec(&ch);
 
-	if (channel <= CH_MAX_2G_CHANNEL)
+	if (ch.band == BRCMU_CHAN_BAND_2G)
 		band = wiphy->bands[IEEE80211_BAND_2GHZ];
 	else
 		band = wiphy->bands[IEEE80211_BAND_5GHZ];
 
-	freq = ieee80211_channel_to_frequency(channel, band->band);
+	freq = ieee80211_channel_to_frequency(ch.chnum, band->band);
 	notify_channel = ieee80211_get_channel(wiphy, freq);
 
 	notify_capability = le16_to_cpu(bi->capability);
@@ -2367,7 +2369,7 @@ static s32 wl_inform_ibss(struct brcmf_cfg80211_info *cfg,
 	notify_ielen = le32_to_cpu(bi->ie_length);
 	notify_signal = (s16)le16_to_cpu(bi->RSSI) * 100;
 
-	brcmf_dbg(CONN, "channel: %d(%d)\n", channel, freq);
+	brcmf_dbg(CONN, "channel: %d(%d)\n", ch.chnum, freq);
 	brcmf_dbg(CONN, "capability: %X\n", notify_capability);
 	brcmf_dbg(CONN, "beacon interval: %d\n", notify_interval);
 	brcmf_dbg(CONN, "signal: %d\n", notify_signal);
@@ -2490,12 +2492,19 @@ static void brcmf_escan_timeout(unsigned long data)
 }
 
 static s32
-brcmf_compare_update_same_bss(struct brcmf_bss_info_le *bss,
+brcmf_compare_update_same_bss(struct brcmf_cfg80211_info *cfg,
+			      struct brcmf_bss_info_le *bss,
 			      struct brcmf_bss_info_le *bss_info_le)
 {
+	struct brcmu_chan ch_bss, ch_bss_info_le;
+
+	ch_bss.chspec = le16_to_cpu(bss->chanspec);
+	cfg->d11inf.decchspec(&ch_bss);
+	ch_bss_info_le.chspec = le16_to_cpu(bss_info_le->chanspec);
+	cfg->d11inf.decchspec(&ch_bss_info_le);
+
 	if (!memcmp(&bss_info_le->BSSID, &bss->BSSID, ETH_ALEN) &&
-		(CHSPEC_BAND(le16_to_cpu(bss_info_le->chanspec)) ==
-		CHSPEC_BAND(le16_to_cpu(bss->chanspec))) &&
+		ch_bss.band == ch_bss_info_le.band &&
 		bss_info_le->SSID_len == bss->SSID_len &&
 		!memcmp(bss_info_le->SSID, bss->SSID, bss_info_le->SSID_len)) {
 		if ((bss->flags & WLC_BSS_RSSI_ON_CHANNEL) ==
@@ -2593,7 +2602,8 @@ brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 			bss = bss ? (struct brcmf_bss_info_le *)
 				((unsigned char *)bss +
 				le32_to_cpu(bss->length)) : list->bss_info_le;
-			if (brcmf_compare_update_same_bss(bss, bss_info_le))
+			if (brcmf_compare_update_same_bss(cfg, bss,
+							  bss_info_le))
 				goto exit;
 		}
 		memcpy(&(cfg->escan_info.escan_buf[list->buflen]),
@@ -4342,9 +4352,9 @@ brcmf_bss_roaming_done(struct brcmf_cfg80211_info *cfg,
 	struct ieee80211_channel *notify_channel = NULL;
 	struct ieee80211_supported_band *band;
 	struct brcmf_bss_info_le *bi;
+	struct brcmu_chan ch;
 	u32 freq;
 	s32 err = 0;
-	u32 target_channel;
 	u8 *buf;
 
 	brcmf_dbg(TRACE, "Enter\n");
@@ -4368,15 +4378,15 @@ brcmf_bss_roaming_done(struct brcmf_cfg80211_info *cfg,
 		goto done;
 
 	bi = (struct brcmf_bss_info_le *)(buf + 4);
-	target_channel = bi->ctl_ch ? bi->ctl_ch :
-				      CHSPEC_CHANNEL(le16_to_cpu(bi->chanspec));
+	ch.chspec = le16_to_cpu(bi->chanspec);
+	cfg->d11inf.decchspec(&ch);
 
-	if (target_channel <= CH_MAX_2G_CHANNEL)
+	if (ch.band == BRCMU_CHAN_BAND_2G)
 		band = wiphy->bands[IEEE80211_BAND_2GHZ];
 	else
 		band = wiphy->bands[IEEE80211_BAND_5GHZ];
 
-	freq = ieee80211_channel_to_frequency(target_channel, band->band);
+	freq = ieee80211_channel_to_frequency(ch.chnum, band->band);
 	notify_channel = ieee80211_get_channel(wiphy, freq);
 
 done:
@@ -4730,6 +4740,7 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 	struct brcmf_cfg80211_vif *vif;
 	struct brcmf_if *ifp;
 	s32 err = 0;
+	s32 io_type;
 
 	if (!ndev) {
 		brcmf_err("ndev is invalid\n");
@@ -4771,6 +4782,15 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 		goto cfg80211_p2p_attach_out;
 	}
 
+	err = brcmf_fil_cmd_int_get(ifp, BRCMF_C_GET_VERSION,
+				    &io_type);
+	if (err) {
+		brcmf_err("Failed to get D11 version (%d)\n", err);
+		goto cfg80211_p2p_attach_out;
+	}
+	cfg->d11inf.io_type = (u8)io_type;
+	brcmu_d11_attach(&cfg->d11inf);
+
 	return cfg;
 
 cfg80211_p2p_attach_out:
@@ -4890,11 +4910,11 @@ static s32 brcmf_construct_reginfo(struct brcmf_cfg80211_info *cfg, u32 bw_cap)
 	struct brcmf_if *ifp = netdev_priv(cfg_to_ndev(cfg));
 	struct ieee80211_channel *band_chan_arr;
 	struct brcmf_chanspec_list *list;
+	struct brcmu_chan ch;
 	s32 err;
 	u8 *pbuf;
 	u32 i, j;
 	u32 total;
-	u16 chanspec;
 	enum ieee80211_band band;
 	u32 channel;
 	u32 *n_cnt;
@@ -4923,42 +4943,30 @@ static s32 brcmf_construct_reginfo(struct brcmf_cfg80211_info *cfg, u32 bw_cap)
 
 	total = le32_to_cpu(list->count);
 	for (i = 0; i < total; i++) {
-		chanspec = (u16)le32_to_cpu(list->element[i]);
-		channel = CHSPEC_CHANNEL(chanspec);
+		ch.chspec = (u16)le32_to_cpu(list->element[i]);
+		cfg->d11inf.decchspec(&ch);
 
-		if (CHSPEC_IS40(chanspec)) {
-			if (CHSPEC_SB_UPPER(chanspec))
-				channel += CH_10MHZ_APART;
-			else
-				channel -= CH_10MHZ_APART;
-		} else if (CHSPEC_IS80(chanspec)) {
-			brcmf_dbg(INFO, "HT80 center channel : %d\n",
-				  channel);
-			continue;
-		}
-		if (CHSPEC_IS2G(chanspec) && (channel >= CH_MIN_2G_CHANNEL) &&
-		    (channel <= CH_MAX_2G_CHANNEL)) {
+		if (ch.band == BRCMU_CHAN_BAND_2G) {
 			band_chan_arr = __wl_2ghz_channels;
 			array_size = ARRAY_SIZE(__wl_2ghz_channels);
 			n_cnt = &__wl_band_2ghz.n_channels;
 			band = IEEE80211_BAND_2GHZ;
 			ht40_allowed = (bw_cap == WLC_N_BW_40ALL);
-		} else if (CHSPEC_IS5G(chanspec) &&
-			   channel >= CH_MIN_5G_CHANNEL) {
+		} else if (ch.band == BRCMU_CHAN_BAND_5G) {
 			band_chan_arr = __wl_5ghz_a_channels;
 			array_size = ARRAY_SIZE(__wl_5ghz_a_channels);
 			n_cnt = &__wl_band_5ghz_a.n_channels;
 			band = IEEE80211_BAND_5GHZ;
 			ht40_allowed = !(bw_cap == WLC_N_BW_20ALL);
 		} else {
-			brcmf_err("Invalid channel Sepc. 0x%x.\n", chanspec);
+			brcmf_err("Invalid channel Sepc. 0x%x.\n", ch.chspec);
 			continue;
 		}
-		if (!ht40_allowed && CHSPEC_IS40(chanspec))
+		if (!ht40_allowed && ch.bw == BRCMU_CHAN_BW_40)
 			continue;
 		update = false;
 		for (j = 0; (j < *n_cnt && (*n_cnt < array_size)); j++) {
-			if (band_chan_arr[j].hw_value == channel) {
+			if (band_chan_arr[j].hw_value == ch.chnum) {
 				update = true;
 				break;
 			}
@@ -4969,16 +4977,16 @@ static s32 brcmf_construct_reginfo(struct brcmf_cfg80211_info *cfg, u32 bw_cap)
 			index = *n_cnt;
 		if (index <  array_size) {
 			band_chan_arr[index].center_freq =
-				ieee80211_channel_to_frequency(channel, band);
-			band_chan_arr[index].hw_value = channel;
+				ieee80211_channel_to_frequency(ch.chnum, band);
+			band_chan_arr[index].hw_value = ch.chnum;
 
-			if (CHSPEC_IS40(chanspec) && ht40_allowed) {
+			if (ch.bw == BRCMU_CHAN_BW_40 && ht40_allowed) {
 				/* assuming the order is HT20, HT40 Upper,
 				 * HT40 lower from chanspecs
 				 */
 				ht40_flag = band_chan_arr[index].flags &
 					    IEEE80211_CHAN_NO_HT40;
-				if (CHSPEC_SB_UPPER(chanspec)) {
+				if (ch.sb == BRCMU_CHAN_SB_U) {
 					if (ht40_flag == IEEE80211_CHAN_NO_HT40)
 						band_chan_arr[index].flags &=
 							~IEEE80211_CHAN_NO_HT40;
@@ -4998,11 +5006,9 @@ static s32 brcmf_construct_reginfo(struct brcmf_cfg80211_info *cfg, u32 bw_cap)
 			} else {
 				band_chan_arr[index].flags =
 							IEEE80211_CHAN_NO_HT40;
-				if (band == IEEE80211_BAND_2GHZ)
-					channel |= WL_CHANSPEC_BAND_2G;
-				else
-					channel |= WL_CHANSPEC_BAND_5G;
-				channel |= WL_CHANSPEC_BW_20;
+				ch.bw = BRCMU_CHAN_BW_20;
+				cfg->d11inf.encchspec(&ch);
+				channel = ch.chspec;
 				err = brcmf_fil_bsscfg_int_get(ifp,
 							       "per_chan_info",
 							       &channel);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index 2907437..3e474c2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -17,6 +17,9 @@
 #ifndef _wl_cfg80211_h_
 #define _wl_cfg80211_h_
 
+/* for brcmu_d11inf */
+#include <brcmu_d11.h>
+
 #define WL_NUM_SCAN_MAX			10
 #define WL_NUM_PMKIDS_MAX		MAXPMKID
 #define WL_TLV_INFO_MAX			1024
@@ -408,6 +411,7 @@ struct brcmf_cfg80211_info {
 	u8 vif_cnt;
 	struct brcmf_cfg80211_vif_event vif_event;
 	struct completion vif_disabled;
+	struct brcmu_d11inf d11inf;
 };
 
 /**
@@ -484,7 +488,8 @@ s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
 			  const u8 *vndr_ie_buf, u32 vndr_ie_len);
 s32 brcmf_vif_clear_mgmt_ies(struct brcmf_cfg80211_vif *vif);
 struct brcmf_tlv *brcmf_parse_tlvs(void *buf, int buflen, uint key);
-u16 channel_to_chanspec(struct ieee80211_channel *ch);
+u16 channel_to_chanspec(struct brcmu_d11inf *d11inf,
+			struct ieee80211_channel *ch);
 u32 wl_get_vif_state_all(struct brcmf_cfg80211_info *cfg, unsigned long state);
 void brcmf_cfg80211_arm_vif_event(struct brcmf_cfg80211_info *cfg,
 				  struct brcmf_cfg80211_vif *vif);
-- 
1.7.10.4


