Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2954 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140Ab1GEWDV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 18:03:21 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 19/31] staging: brcm80211: replaced Broadcom specific
 acronym WLC
Date: Wed, 6 Jul 2011 00:02:46 +0200
Message-ID: <1309903378-29021-20-git-send-email-arend@broadcom.com> (sfid-20110706_000424_867843_3E7DB94A)
In-Reply-To: <1309903378-29021-1-git-send-email-arend@broadcom.com>
References: <1309903378-29021-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

WLC (caps) was replaced, wlc (small caps) has not been replaced yet.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h         |    2 +-
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |   40 +-
 drivers/staging/brcm80211/brcmsmac/alloc.c       |   15 +-
 drivers/staging/brcm80211/brcmsmac/ampdu.c       |   44 +-
 drivers/staging/brcm80211/brcmsmac/antsel.c      |   13 +-
 drivers/staging/brcm80211/brcmsmac/bmac.c        |  138 +++---
 drivers/staging/brcm80211/brcmsmac/channel.c     |  206 ++++----
 drivers/staging/brcm80211/brcmsmac/channel.h     |   44 +-
 drivers/staging/brcm80211/brcmsmac/d11.h         |   12 +-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |   26 +-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.h |    2 +-
 drivers/staging/brcm80211/brcmsmac/main.c        |  595 +++++++++++-----------
 drivers/staging/brcm80211/brcmsmac/main.h        |  155 +++---
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c |  106 ++--
 drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h |   44 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h |    2 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c |    6 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c   |   31 +-
 drivers/staging/brcm80211/brcmsmac/phy_shim.c    |    4 +-
 drivers/staging/brcm80211/brcmsmac/phy_shim.h    |   10 +-
 drivers/staging/brcm80211/brcmsmac/pub.h         |  165 +++----
 drivers/staging/brcm80211/brcmsmac/rate.c        |  129 +++---
 drivers/staging/brcm80211/brcmsmac/rate.h        |   32 +-
 drivers/staging/brcm80211/brcmsmac/stf.c         |   37 +-
 drivers/staging/brcm80211/brcmsmac/types.h       |   30 +-
 drivers/staging/brcm80211/include/brcmu_wifi.h   |   37 +-
 drivers/staging/brcm80211/include/defs.h         |   26 +-
 27 files changed, 995 insertions(+), 956 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index b4d786f..0a3c6e5 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -590,7 +590,7 @@ struct brcmf_pub {
 	char *pktfilter[100];
 	int pktfilter_count;
 
-	u8 country_code[WLC_CNTRY_BUF_SZ];
+	u8 country_code[BRCM_CNTRY_BUF_SZ];
 	char eventmask[BRCMF_EVENTING_MASK_LEN];
 
 };
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 12c6ee3..f6118d1 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -363,18 +363,18 @@ do {									\
 	}
 
 static struct ieee80211_rate __wl_rates[] = {
-	RATETAB_ENT(WLC_RATE_1M, 0),
-	RATETAB_ENT(WLC_RATE_2M, IEEE80211_RATE_SHORT_PREAMBLE),
-	RATETAB_ENT(WLC_RATE_5M5, IEEE80211_RATE_SHORT_PREAMBLE),
-	RATETAB_ENT(WLC_RATE_11M, IEEE80211_RATE_SHORT_PREAMBLE),
-	RATETAB_ENT(WLC_RATE_6M, 0),
-	RATETAB_ENT(WLC_RATE_9M, 0),
-	RATETAB_ENT(WLC_RATE_12M, 0),
-	RATETAB_ENT(WLC_RATE_18M, 0),
-	RATETAB_ENT(WLC_RATE_24M, 0),
-	RATETAB_ENT(WLC_RATE_36M, 0),
-	RATETAB_ENT(WLC_RATE_48M, 0),
-	RATETAB_ENT(WLC_RATE_54M, 0),
+	RATETAB_ENT(BRCM_RATE_1M, 0),
+	RATETAB_ENT(BRCM_RATE_2M, IEEE80211_RATE_SHORT_PREAMBLE),
+	RATETAB_ENT(BRCM_RATE_5M5, IEEE80211_RATE_SHORT_PREAMBLE),
+	RATETAB_ENT(BRCM_RATE_11M, IEEE80211_RATE_SHORT_PREAMBLE),
+	RATETAB_ENT(BRCM_RATE_6M, 0),
+	RATETAB_ENT(BRCM_RATE_9M, 0),
+	RATETAB_ENT(BRCM_RATE_12M, 0),
+	RATETAB_ENT(BRCM_RATE_18M, 0),
+	RATETAB_ENT(BRCM_RATE_24M, 0),
+	RATETAB_ENT(BRCM_RATE_36M, 0),
+	RATETAB_ENT(BRCM_RATE_48M, 0),
+	RATETAB_ENT(BRCM_RATE_54M, 0),
 };
 
 #define wl_a_rates		(__wl_rates + 4)
@@ -895,7 +895,7 @@ static s32 brcmf_set_frag(struct net_device *dev, u32 frag_threshold)
 static s32 brcmf_set_retry(struct net_device *dev, u32 retry, bool l)
 {
 	s32 err = 0;
-	u32 cmd = (l ? WLC_SET_LRL : WLC_SET_SRL);
+	u32 cmd = (l ? BRCM_SET_LRL : BRCM_SET_SRL);
 
 	retry = cpu_to_le32(retry);
 	err = brcmf_dev_ioctl(dev, cmd, &retry, sizeof(retry));
@@ -1025,7 +1025,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 	else
 		bcnprd = cpu_to_le32(100);
 
-	err = brcmf_dev_ioctl(dev, WLC_SET_BCNPRD, &bcnprd, sizeof(bcnprd));
+	err = brcmf_dev_ioctl(dev, BRCM_SET_BCNPRD, &bcnprd, sizeof(bcnprd));
 	if (unlikely(err)) {
 		WL_ERR("WLC_SET_BCNPRD failed (%d)\n", err);
 		goto done;
@@ -1068,7 +1068,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 
 		/* set channel for starter */
 		target_channel = cpu_to_le32(cfg_priv->channel);
-		err = brcmf_dev_ioctl(dev, WLC_SET_CHANNEL,
+		err = brcmf_dev_ioctl(dev, BRCM_SET_CHANNEL,
 			&target_channel, sizeof(target_channel));
 		if (unlikely(err)) {
 			WL_ERR("WLC_SET_CHANNEL failed (%d)\n", err);
@@ -2039,7 +2039,7 @@ brcmf_cfg80211_set_bitrate_mask(struct wiphy *wiphy, struct net_device *dev,
 
 	/* addr param is always NULL. ignore it */
 	/* Get current rateset */
-	err = brcmf_dev_ioctl(dev, WLC_GET_CURR_RATESET, &rateset,
+	err = brcmf_dev_ioctl(dev, BRCM_GET_CURR_RATESET, &rateset,
 			sizeof(rateset));
 	if (unlikely(err)) {
 		WL_ERR("could not get current rateset (%d)\n", err);
@@ -3755,7 +3755,7 @@ brcmf_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 	}
 
 	roamtrigger[0] = WL_ROAM_TRIGGER_LEVEL;
-	roamtrigger[1] = WLC_BAND_ALL;
+	roamtrigger[1] = BRCM_BAND_ALL;
 	err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_ROAM_TRIGGER,
 			(void *)roamtrigger, sizeof(roamtrigger));
 	if (unlikely(err)) {
@@ -3764,7 +3764,7 @@ brcmf_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 	}
 
 	roam_delta[0] = WL_ROAM_DELTA;
-	roam_delta[1] = WLC_BAND_ALL;
+	roam_delta[1] = BRCM_BAND_ALL;
 	err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_ROAM_DELTA,
 				(void *)roam_delta, sizeof(roam_delta));
 	if (unlikely(err)) {
@@ -3865,8 +3865,8 @@ static s32 wl_update_wiphybands(struct brcmf_cfg80211_priv *cfg_priv)
 	s8 phy;
 	s32 err = 0;
 
-	err = brcmf_dev_ioctl(cfg_to_ndev(cfg_priv), WLC_GET_PHYLIST, &phy_list,
-			sizeof(phy_list));
+	err = brcmf_dev_ioctl(cfg_to_ndev(cfg_priv), BRCM_GET_PHYLIST,
+			      &phy_list, sizeof(phy_list));
 	if (unlikely(err)) {
 		WL_ERR("error (%d)\n", err);
 		return err;
diff --git a/drivers/staging/brcm80211/brcmsmac/alloc.c b/drivers/staging/brcm80211/brcmsmac/alloc.c
index bf01ba0..7f8dd7b 100644
--- a/drivers/staging/brcm80211/brcmsmac/alloc.c
+++ b/drivers/staging/brcm80211/brcmsmac/alloc.c
@@ -36,11 +36,11 @@ static void brcms_c_tunables_init(struct brcms_tunables *tunables, uint devid)
 	tunables->maxscb = MAXSCB;
 	tunables->ampdunummpdu = AMPDU_NUM_MPDU;
 	tunables->maxpktcb = MAXPKTCB;
-	tunables->maxucodebss = WLC_MAX_UCODE_BSS;
-	tunables->maxucodebss4 = WLC_MAX_UCODE_BSS4;
+	tunables->maxucodebss = BRCMS_MAX_UCODE_BSS;
+	tunables->maxucodebss4 = BRCMS_MAX_UCODE_BSS4;
 	tunables->maxbss = MAXBSS;
-	tunables->datahiwat = WLC_DATAHIWAT;
-	tunables->ampdudatahiwat = WLC_AMPDUDATAHIWAT;
+	tunables->datahiwat = BRCMS_DATAHIWAT;
+	tunables->ampdudatahiwat = BRCMS_AMPDUDATAHIWAT;
 	tunables->rxbnd = RXBND;
 	tunables->txsbnd = TXSBND;
 }
@@ -169,7 +169,7 @@ struct brcms_c_info *brcms_c_attach_malloc(uint unit, uint *err, uint devid)
 	}
 
 	wlc->modulecb =
-		kzalloc(sizeof(struct modulecb) * WLC_MAXMODULES, GFP_ATOMIC);
+		kzalloc(sizeof(struct modulecb) * BRCMS_MAXMODULES, GFP_ATOMIC);
 	if (wlc->modulecb == NULL) {
 		*err = 1009;
 		goto fail;
@@ -189,13 +189,14 @@ struct brcms_c_info *brcms_c_attach_malloc(uint unit, uint *err, uint devid)
 	brcms_c_bsscfg_ID_assign(wlc, wlc->cfg);
 
 	wlc->wsec_def_keys[0] =
-		kzalloc(sizeof(struct wsec_key) * WLC_DEFAULT_KEYS, GFP_ATOMIC);
+		kzalloc(sizeof(struct wsec_key) * BRCMS_DEFAULT_KEYS,
+			GFP_ATOMIC);
 	if (wlc->wsec_def_keys[0] == NULL) {
 		*err = 1015;
 		goto fail;
 	} else {
 		int i;
-		for (i = 1; i < WLC_DEFAULT_KEYS; i++) {
+		for (i = 1; i < BRCMS_DEFAULT_KEYS; i++) {
 			wlc->wsec_def_keys[i] = (struct wsec_key *)
 			    ((unsigned long)wlc->wsec_def_keys[0] +
 			     (sizeof(struct wsec_key) * i));
diff --git a/drivers/staging/brcm80211/brcmsmac/ampdu.c b/drivers/staging/brcm80211/brcmsmac/ampdu.c
index 599f6e9..fcaf61e 100644
--- a/drivers/staging/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/ampdu.c
@@ -164,7 +164,7 @@ struct ampdu_info *brcms_c_ampdu_attach(struct brcms_c_info *wlc)
 
 	ampdu->ffpld_rsvd = AMPDU_DEF_FFPLD_RSVD;
 	/* bump max ampdu rcv size to 64k for all 11n devices except 4321A0 and 4321A1 */
-	if (WLCISNPHY(wlc->band) && NREV_LT(wlc->band->phyrev, 2))
+	if (BRCMS_ISNPHY(wlc->band) && NREV_LT(wlc->band->phyrev, 2))
 		ampdu->rx_factor = IEEE80211_HT_MAX_AMPDU_32K;
 	else
 		ampdu->rx_factor = IEEE80211_HT_MAX_AMPDU_64K;
@@ -443,10 +443,10 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
 	struct sk_buff *p, *pkt[AMPDU_MAX_MPDU];
 	u8 tid, ndelim;
 	int err = 0;
-	u8 preamble_type = WLC_GF_PREAMBLE;
-	u8 fbr_preamble_type = WLC_GF_PREAMBLE;
-	u8 rts_preamble_type = WLC_LONG_PREAMBLE;
-	u8 rts_fbr_preamble_type = WLC_LONG_PREAMBLE;
+	u8 preamble_type = BRCMS_GF_PREAMBLE;
+	u8 fbr_preamble_type = BRCMS_GF_PREAMBLE;
+	u8 rts_preamble_type = BRCMS_LONG_PREAMBLE;
+	u8 rts_fbr_preamble_type = BRCMS_LONG_PREAMBLE;
 
 	bool rr = true, fbr = false;
 	uint i, count = 0, fifo, seg_cnt = 0;
@@ -551,8 +551,8 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
 		}
 
 		/* extract the length info */
-		len = fbr_iscck ? WLC_GET_CCK_PLCP_LEN(txh->FragPLCPFallback)
-		    : WLC_GET_MIMO_PLCP_LEN(txh->FragPLCPFallback);
+		len = fbr_iscck ? BRCMS_GET_CCK_PLCP_LEN(txh->FragPLCPFallback)
+		    : BRCMS_GET_MIMO_PLCP_LEN(txh->FragPLCPFallback);
 
 		/* retrieve null delimiter count */
 		ndelim = txh->RTSPLCPFallback[AMPDU_FBR_NULL_DELIM];
@@ -622,8 +622,8 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
 
 			if (is40)
 				mimo_ctlchbw =
-				    CHSPEC_SB_UPPER(WLC_BAND_PI_RADIO_CHANSPEC)
-				    ? PHY_TXC1_BW_20MHZ_UP : PHY_TXC1_BW_20MHZ;
+				   CHSPEC_SB_UPPER(BRCMS_BAND_PI_RADIO_CHANSPEC)
+				   ? PHY_TXC1_BW_20MHZ_UP : PHY_TXC1_BW_20MHZ;
 
 			/* rebuild the rspec and rspec_fallback */
 			rspec = RSPEC_MIMORATE;
@@ -717,31 +717,31 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
 
 		/* remove the pad len from last mpdu */
 		fbr_iscck = ((le16_to_cpu(txh->XtraFrameTypes) & 0x3) == 0);
-		len = fbr_iscck ? WLC_GET_CCK_PLCP_LEN(txh->FragPLCPFallback)
-		    : WLC_GET_MIMO_PLCP_LEN(txh->FragPLCPFallback);
+		len = fbr_iscck ? BRCMS_GET_CCK_PLCP_LEN(txh->FragPLCPFallback)
+		    : BRCMS_GET_MIMO_PLCP_LEN(txh->FragPLCPFallback);
 		ampdu_len -= roundup(len, 4) - len;
 
 		/* patch up the first txh & plcp */
 		txh = (struct d11txh *) pkt[0]->data;
 		plcp = (u8 *) (txh + 1);
 
-		WLC_SET_MIMO_PLCP_LEN(plcp, ampdu_len);
+		BRCMS_SET_MIMO_PLCP_LEN(plcp, ampdu_len);
 		/* mark plcp to indicate ampdu */
-		WLC_SET_MIMO_PLCP_AMPDU(plcp);
+		BRCMS_SET_MIMO_PLCP_AMPDU(plcp);
 
 		/* reset the mixed mode header durations */
 		if (txh->MModeLen) {
 			u16 mmodelen =
 			    brcms_c_calc_lsig_len(wlc, rspec, ampdu_len);
 			txh->MModeLen = cpu_to_le16(mmodelen);
-			preamble_type = WLC_MM_PREAMBLE;
+			preamble_type = BRCMS_MM_PREAMBLE;
 		}
 		if (txh->MModeFbrLen) {
 			u16 mmfbrlen =
 			    brcms_c_calc_lsig_len(wlc, rspec_fallback,
 						  ampdu_len);
 			txh->MModeFbrLen = cpu_to_le16(mmfbrlen);
-			fbr_preamble_type = WLC_MM_PREAMBLE;
+			fbr_preamble_type = BRCMS_MM_PREAMBLE;
 		}
 
 		/* set the preload length */
@@ -759,11 +759,11 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
 			rts = (struct ieee80211_rts *)&txh->rts_frame;
 			if ((mch & TXC_PREAMBLE_RTS_MAIN_SHORT) ==
 			    TXC_PREAMBLE_RTS_MAIN_SHORT)
-				rts_preamble_type = WLC_SHORT_PREAMBLE;
+				rts_preamble_type = BRCMS_SHORT_PREAMBLE;
 
 			if ((mch & TXC_PREAMBLE_RTS_FB_SHORT) ==
 			    TXC_PREAMBLE_RTS_FB_SHORT)
-				rts_fbr_preamble_type = WLC_SHORT_PREAMBLE;
+				rts_fbr_preamble_type = BRCMS_SHORT_PREAMBLE;
 
 			durid =
 			    brcms_c_compute_rtscts_dur(wlc, use_cts, rts_rspec,
@@ -788,8 +788,8 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
 		if (fbr) {
 			mch |= TXC_AMPDU_FBR;
 			txh->MacTxControlHigh = cpu_to_le16(mch);
-			WLC_SET_MIMO_PLCP_AMPDU(plcp);
-			WLC_SET_MIMO_PLCP_AMPDU(txh->FragPLCPFallback);
+			BRCMS_SET_MIMO_PLCP_AMPDU(plcp);
+			BRCMS_SET_MIMO_PLCP_AMPDU(txh->FragPLCPFallback);
 		}
 
 		BCMMSG(wlc->wiphy, "wl%d: count %d ampdu_len %d\n",
@@ -1046,9 +1046,9 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 				ini->tx_in_transit--;
 				/* Use high prededence for retransmit to give some punch */
 				/* brcms_c_txq_enq(wlc, scb, p,
-				 * WLC_PRIO_TO_PREC(tid)); */
+				 * BRCMS_PRIO_TO_PREC(tid)); */
 				brcms_c_txq_enq(wlc, scb, p,
-					    WLC_PRIO_TO_HI_PREC(tid));
+					    BRCMS_PRIO_TO_HI_PREC(tid));
 			} else {
 				/* Retry timeout */
 				ini->tx_in_transit--;
@@ -1108,7 +1108,7 @@ static int brcms_c_ampdu_set(struct ampdu_info *ampdu, bool on)
 
 static bool brcms_c_ampdu_cap(struct ampdu_info *ampdu)
 {
-	if (WLC_PHY_11N_CAP(ampdu->wlc->band))
+	if (BRCMS_PHY_11N_CAP(ampdu->wlc->band))
 		return true;
 	else
 		return false;
diff --git a/drivers/staging/brcm80211/brcmsmac/antsel.c b/drivers/staging/brcm80211/brcmsmac/antsel.c
index e93d8ae..c4e76c0 100644
--- a/drivers/staging/brcm80211/brcmsmac/antsel.c
+++ b/drivers/staging/brcm80211/brcmsmac/antsel.c
@@ -31,11 +31,12 @@
 #define ANT_SELCFG_RX_DEF	3	/* default rx antenna configuration */
 
 /* useful macros */
-#define WLC_ANTSEL_11N_0(ant)	((((ant) & ANT_SELCFG_MASK) >> 4) & 0xf)
-#define WLC_ANTSEL_11N_1(ant)	(((ant) & ANT_SELCFG_MASK) & 0xf)
-#define WLC_ANTIDX_11N(ant)	(((WLC_ANTSEL_11N_0(ant)) << 2) + (WLC_ANTSEL_11N_1(ant)))
-#define WLC_ANT_ISAUTO_11N(ant)	(((ant) & ANT_SELCFG_AUTO) == ANT_SELCFG_AUTO)
-#define WLC_ANTSEL_11N(ant)	((ant) & ANT_SELCFG_MASK)
+#define BRCMS_ANTSEL_11N_0(ant)	((((ant) & ANT_SELCFG_MASK) >> 4) & 0xf)
+#define BRCMS_ANTSEL_11N_1(ant)	(((ant) & ANT_SELCFG_MASK) & 0xf)
+#define BRCMS_ANTIDX_11N(ant)	(((BRCMS_ANTSEL_11N_0(ant)) << 2) +\
+				(BRCMS_ANTSEL_11N_1(ant)))
+#define BRCMS_ANT_ISAUTO_11N(ant) (((ant) & ANT_SELCFG_AUTO) == ANT_SELCFG_AUTO)
+#define BRCMS_ANTSEL_11N(ant)	((ant) & ANT_SELCFG_MASK)
 
 /* antenna switch */
 /* defines for no boardlevel antenna diversity */
@@ -263,7 +264,7 @@ static u8 brcms_c_antsel_id2antcfg(struct antsel_info *asi, u8 id)
 /* boardlevel antenna selection: convert ant_cfg to mimo_antsel (ucode interface) */
 static u16 brcms_c_antsel_antcfg2antsel(struct antsel_info *asi, u8 ant_cfg)
 {
-	u8 idx = WLC_ANTIDX_11N(WLC_ANTSEL_11N(ant_cfg));
+	u8 idx = BRCMS_ANTIDX_11N(BRCMS_ANTSEL_11N(ant_cfg));
 	u16 mimo_antsel = 0;
 
 	if (asi->antsel_type == ANTSEL_2x4) {
diff --git a/drivers/staging/brcm80211/brcmsmac/bmac.c b/drivers/staging/brcm80211/brcmsmac/bmac.c
index 412611e..225178e 100644
--- a/drivers/staging/brcm80211/brcmsmac/bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/bmac.c
@@ -38,7 +38,6 @@
 #define	SYNTHPU_DLY_PHY_US_QT	100	/* QT synthpu_dly time in us */
 
 #ifndef BMAC_DUP_TO_REMOVE
-#define WLC_RM_WAIT_TX_SUSPEND		4	/* Wait Tx Suspend */
 
 #define	ANTCNT			10	/* vanilla M_MAX_ANTCNT value */
 
@@ -186,7 +185,7 @@ static void WLBANDINITFN(brcms_c_ucode_bsinit) (struct brcms_hardware *wlc_hw)
 
 	/* do band-specific ucode IHR, SHM, and SCR inits */
 	if (D11REV_IS(wlc_hw->corerev, 23)) {
-		if (WLCISNPHY(wlc_hw->band)) {
+		if (BRCMS_ISNPHY(wlc_hw->band)) {
 			brcms_c_write_inits(wlc_hw, d11n0bsinitvals16);
 		} else {
 			wiphy_err(wiphy, "%s: wl%d: unsupported phy in corerev"
@@ -195,7 +194,7 @@ static void WLBANDINITFN(brcms_c_ucode_bsinit) (struct brcms_hardware *wlc_hw)
 		}
 	} else {
 		if (D11REV_IS(wlc_hw->corerev, 24)) {
-			if (WLCISLCNPHY(wlc_hw->band)) {
+			if (BRCMS_ISLCNPHY(wlc_hw->band)) {
 				brcms_c_write_inits(wlc_hw,
 						    d11lcn0bsinitvals24);
 			} else
@@ -421,7 +420,7 @@ brcms_b_set_chanspec(struct brcms_hardware *wlc_hw, chanspec_t chanspec,
 
 	/* Switch bands if necessary */
 	if (NBANDS_HW(wlc_hw) > 1) {
-		bandunit = CHSPEC_WLCBANDUNIT(chanspec);
+		bandunit = CHSPEC_BANDUNIT(chanspec);
 		if (wlc_hw->band->bandunit != bandunit) {
 			/* brcms_b_setband disables other bandunit,
 			 *  use light band switch if not up yet
@@ -501,7 +500,7 @@ static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 					    NULL), DMAREG(wlc_hw, DMA_RX, 0),
 					   (wme ? tune->ntxd : 0), tune->nrxd,
 					   tune->rxbufsz, -1, tune->nrxbufpost,
-					   WL_HWRXOFF, &brcm_msg_level);
+					   BRCMS_HWRXOFF, &brcm_msg_level);
 		dma_attach_err |= (NULL == wlc_hw->di[0]);
 
 		/*
@@ -681,7 +680,7 @@ int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device, uint unit,
 	 *   But it will be called again inside wlc_corereset, after d11 is out of reset.
 	 */
 	brcms_b_clkctl_clk(wlc_hw, CLK_FAST);
-	brcms_b_corereset(wlc_hw, WLC_USE_COREFLAGS);
+	brcms_b_corereset(wlc_hw, BRCMS_USE_COREFLAGS);
 
 	if (!brcms_b_validate_chip_access(wlc_hw)) {
 		wiphy_err(wiphy, "wl%d: brcms_b_attach: validate_chip_access "
@@ -708,7 +707,7 @@ int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device, uint unit,
 	wlc_hw->boardflags2 = (u32) getintvar(vars, "boardflags2");
 
 	if (wlc_hw->boardflags & BFL_NOPLLDOWN)
-		brcms_b_pllreq(wlc_hw, true, WLC_PLLREQ_SHARED);
+		brcms_b_pllreq(wlc_hw, true, BRCMS_PLLREQ_SHARED);
 
 	if ((wlc_hw->sih->bustype == PCI_BUS)
 	    && (ai_pci_war16165(wlc_hw->sih)))
@@ -788,9 +787,9 @@ int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device, uint unit,
 		brcms_c_setxband(wlc_hw, j);
 
 		wlc_hw->band->bandunit = j;
-		wlc_hw->band->bandtype = j ? WLC_BAND_5G : WLC_BAND_2G;
+		wlc_hw->band->bandtype = j ? BRCM_BAND_5G : BRCM_BAND_2G;
 		wlc->band->bandunit = j;
-		wlc->band->bandtype = j ? WLC_BAND_5G : WLC_BAND_2G;
+		wlc->band->bandtype = j ? BRCM_BAND_5G : BRCM_BAND_2G;
 		wlc->core->coreidx = ai_coreidx(wlc_hw->sih);
 
 		wlc_hw->machwcap = R_REG(&regs->machwcap);
@@ -824,12 +823,12 @@ int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device, uint unit,
 		    wlc_phy_get_coreflags(wlc_hw->band->pi);
 
 		/* verify good phy_type & supported phy revision */
-		if (WLCISNPHY(wlc_hw->band)) {
+		if (BRCMS_ISNPHY(wlc_hw->band)) {
 			if (NCONF_HAS(wlc_hw->band->phyrev))
 				goto good_phy;
 			else
 				goto bad_phy;
-		} else if (WLCISLCNPHY(wlc_hw->band)) {
+		} else if (BRCMS_ISLCNPHY(wlc_hw->band)) {
 			if (LCNCONF_HAS(wlc_hw->band->phyrev))
 				goto good_phy;
 			else
@@ -1002,7 +1001,7 @@ void brcms_b_reset(struct brcms_hardware *wlc_hw)
 
 	/* reset the core */
 	if (!DEVICEREMOVED(wlc_hw->wlc))
-		brcms_b_corereset(wlc_hw, WLC_USE_COREFLAGS);
+		brcms_b_corereset(wlc_hw, BRCMS_USE_COREFLAGS);
 
 	/* purge the dma rings */
 	brcms_c_flushqueues(wlc_hw->wlc);
@@ -1028,7 +1027,7 @@ brcms_b_init(struct brcms_hardware *wlc_hw, chanspec_t chanspec,
 	macintmask = brcms_intrsoff(wlc->wl);
 
 	/* set up the specified band and chanspec */
-	brcms_c_setxband(wlc_hw, CHSPEC_WLCBANDUNIT(chanspec));
+	brcms_c_setxband(wlc_hw, CHSPEC_BANDUNIT(chanspec));
 	wlc_phy_chanspec_radio_set(wlc_hw->band->pi, chanspec);
 
 	/* do one-time phy inits and calibration */
@@ -1047,10 +1046,10 @@ brcms_b_init(struct brcms_hardware *wlc_hw, chanspec_t chanspec,
 	/* restore macintmask */
 	brcms_intrsrestore(wlc->wl, macintmask);
 
-	/* seed wake_override with WLC_WAKE_OVERRIDE_MACSUSPEND since the mac is suspended
-	 * and brcms_c_enable_mac() will clear this override bit.
+	/* seed wake_override with BRCMS_WAKE_OVERRIDE_MACSUSPEND since the mac
+	 * is suspended and brcms_c_enable_mac() will clear this override bit.
 	 */
-	mboolset(wlc_hw->wake_override, WLC_WAKE_OVERRIDE_MACSUSPEND);
+	mboolset(wlc_hw->wake_override, BRCMS_WAKE_OVERRIDE_MACSUSPEND);
 
 	/*
 	 * initialize mac_suspend_depth to 1 to match ucode initial suspended state
@@ -1101,7 +1100,7 @@ int brcms_b_up_prep(struct brcms_hardware *wlc_hw)
 		ai_pci_up(wlc_hw->sih);
 
 	/* reset the d11 core */
-	brcms_b_corereset(wlc_hw, WLC_USE_COREFLAGS);
+	brcms_b_corereset(wlc_hw, BRCMS_USE_COREFLAGS);
 
 	return 0;
 }
@@ -1274,10 +1273,10 @@ static void brcms_b_clkctl_clk(struct brcms_hardware *wlc_hw, uint mode)
 		 */
 		if (wlc_hw->forcefastclk)
 			mboolset(wlc_hw->wake_override,
-				 WLC_WAKE_OVERRIDE_FORCEFAST);
+				 BRCMS_WAKE_OVERRIDE_FORCEFAST);
 		else
 			mboolclr(wlc_hw->wake_override,
-				 WLC_WAKE_OVERRIDE_FORCEFAST);
+				 BRCMS_WAKE_OVERRIDE_FORCEFAST);
 	}
 }
 
@@ -1295,7 +1294,7 @@ brcms_c_mhfdef(struct brcms_c_info *wlc, u16 *mhfs, u16 mhf2_init)
 	if (wlc_hw->boardflags & BFL_NOPLLDOWN)
 		mhfs[MHF1] |= MHF1_FORCEFASTCLK;
 
-	if (WLCISNPHY(wlc_hw->band) && NREV_LT(wlc_hw->band->phyrev, 2)) {
+	if (BRCMS_ISNPHY(wlc_hw->band) && NREV_LT(wlc_hw->band->phyrev, 2)) {
 		mhfs[MHF2] |= MHF2_NPHY40MHZ_WAR;
 		mhfs[MHF1] |= MHF1_IQSWAP_WAR;
 	}
@@ -1307,10 +1306,10 @@ brcms_c_mhfdef(struct brcms_c_info *wlc, u16 *mhfs, u16 mhf2_init)
  * pre-CLK changes should use wlc_write_mhf to get around the optimization
  *
  *
- * bands values are: WLC_BAND_AUTO <--- Current band only
- *                   WLC_BAND_5G   <--- 5G band only
- *                   WLC_BAND_2G   <--- 2G band only
- *                   WLC_BAND_ALL  <--- All bands
+ * bands values are: BRCM_BAND_AUTO <--- Current band only
+ *                   BRCM_BAND_5G   <--- 5G band only
+ *                   BRCM_BAND_2G   <--- 2G band only
+ *                   BRCM_BAND_ALL  <--- All bands
  */
 void
 brcms_b_mhf(struct brcms_hardware *wlc_hw, u8 idx, u16 mask, u16 val,
@@ -1330,14 +1329,14 @@ brcms_b_mhf(struct brcms_hardware *wlc_hw, u8 idx, u16 mask, u16 val,
 		/* Current band only or all bands,
 		 * then set the band to current band
 		 */
-	case WLC_BAND_AUTO:
-	case WLC_BAND_ALL:
+	case BRCM_BAND_AUTO:
+	case BRCM_BAND_ALL:
 		band = wlc_hw->band;
 		break;
-	case WLC_BAND_5G:
+	case BRCM_BAND_5G:
 		band = wlc_hw->bandstate[BAND_5G_INDEX];
 		break;
-	case WLC_BAND_2G:
+	case BRCM_BAND_2G:
 		band = wlc_hw->bandstate[BAND_2G_INDEX];
 		break;
 	default:
@@ -1357,7 +1356,7 @@ brcms_b_mhf(struct brcms_hardware *wlc_hw, u8 idx, u16 mask, u16 val,
 					   (u16) band->mhfs[idx]);
 	}
 
-	if (bands == WLC_BAND_ALL) {
+	if (bands == BRCM_BAND_ALL) {
 		wlc_hw->bandstate[0]->mhfs[idx] =
 		    (wlc_hw->bandstate[0]->mhfs[idx] & ~mask) | val;
 		wlc_hw->bandstate[1]->mhfs[idx] =
@@ -1372,13 +1371,13 @@ u16 brcms_b_mhf_get(struct brcms_hardware *wlc_hw, u8 idx, int bands)
 	if (idx >= MHFMAX)
 		return 0; /* error condition */
 	switch (bands) {
-	case WLC_BAND_AUTO:
+	case BRCM_BAND_AUTO:
 		band = wlc_hw->band;
 		break;
-	case WLC_BAND_5G:
+	case BRCM_BAND_5G:
 		band = wlc_hw->bandstate[BAND_5G_INDEX];
 		break;
-	case WLC_BAND_2G:
+	case BRCM_BAND_2G:
 		band = wlc_hw->bandstate[BAND_2G_INDEX];
 		break;
 	default:
@@ -1678,9 +1677,9 @@ static void WLBANDINITFN(brcms_b_upd_synthpu) (struct brcms_hardware *wlc_hw)
 	struct brcms_c_info *wlc = wlc_hw->wlc;
 	/* update SYNTHPU_DLY */
 
-	if (WLCISLCNPHY(wlc->band)) {
+	if (BRCMS_ISLCNPHY(wlc->band)) {
 		v = SYNTHPU_DLY_LPPHY_US;
-	} else if (WLCISNPHY(wlc->band) && (NREV_GE(wlc->band->phyrev, 3))) {
+	} else if (BRCMS_ISNPHY(wlc->band) && (NREV_GE(wlc->band->phyrev, 3))) {
 		v = SYNTHPU_DLY_NPHY_US;
 	} else {
 		v = SYNTHPU_DLY_BPHY_US;
@@ -1772,7 +1771,7 @@ void brcms_b_core_phypll_reset(struct brcms_hardware *wlc_hw)
 void brcms_b_phyclk_fgc(struct brcms_hardware *wlc_hw, bool clk)
 {
 	/* support(necessary for NPHY and HYPHY) only */
-	if (!WLCISNPHY(wlc_hw->band))
+	if (!BRCMS_ISNPHY(wlc_hw->band))
 		return;
 
 	if (ON == clk)
@@ -1804,7 +1803,7 @@ void brcms_b_phy_reset(struct brcms_hardware *wlc_hw)
 	phy_bw_clkbits = wlc_phy_clk_bwbits(wlc_hw->band->pi);
 
 	/* Specific reset sequence required for NPHY rev 3 and 4 */
-	if (WLCISNPHY(wlc_hw->band) && NREV_GE(wlc_hw->band->phyrev, 3) &&
+	if (BRCMS_ISNPHY(wlc_hw->band) && NREV_GE(wlc_hw->band->phyrev, 3) &&
 	    NREV_LE(wlc_hw->band->phyrev, 4)) {
 		/* Set the PHY bandwidth */
 		ai_core_cflags(wlc_hw->sih, SICF_BWMASK, phy_bw_clkbits);
@@ -2065,7 +2064,7 @@ void brcms_b_corereset(struct brcms_hardware *wlc_hw, u32 flags)
 	bool fastclk;
 	u32 resetbits = 0;
 
-	if (flags == WLC_USE_COREFLAGS)
+	if (flags == BRCMS_USE_COREFLAGS)
 		flags = (wlc_hw->band->pi ? wlc_hw->band->core_flags : 0);
 
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
@@ -2238,14 +2237,14 @@ static void brcms_b_coreinit(struct brcms_c_info *wlc)
 	sflags = ai_core_sflags(wlc_hw->sih, 0, 0);
 
 	if (D11REV_IS(wlc_hw->corerev, 23)) {
-		if (WLCISNPHY(wlc_hw->band))
+		if (BRCMS_ISNPHY(wlc_hw->band))
 			brcms_c_write_inits(wlc_hw, d11n0initvals16);
 		else
 			wiphy_err(wiphy, "%s: wl%d: unsupported phy in corerev"
 				  " %d\n", __func__, wlc_hw->unit,
 				  wlc_hw->corerev);
 	} else if (D11REV_IS(wlc_hw->corerev, 24)) {
-		if (WLCISLCNPHY(wlc_hw->band)) {
+		if (BRCMS_ISLCNPHY(wlc_hw->band)) {
 			brcms_c_write_inits(wlc_hw, d11lcn0initvals24);
 		} else {
 			wiphy_err(wiphy, "%s: wl%d: unsupported phy in corerev"
@@ -2403,7 +2402,7 @@ void brcms_b_switch_macfreq(struct brcms_hardware *wlc_hw, u8 spurmode)
 			W_REG(&regs->tsf_clk_frac_l, 0x8889);
 			W_REG(&regs->tsf_clk_frac_h, 0x8);
 		}
-	} else if (WLCISLCNPHY(wlc_hw->band)) {
+	} else if (BRCMS_ISLCNPHY(wlc_hw->band)) {
 		if (spurmode == WL_SPURAVOID_ON1) {	/* 82Mhz */
 			W_REG(&regs->tsf_clk_frac_l, 0x7CE0);
 			W_REG(&regs->tsf_clk_frac_h, 0xC);
@@ -2440,9 +2439,9 @@ static void brcms_c_gpio_init(struct brcms_c_info *wlc)
 	if (wlc_hw->antsel_type == ANTSEL_2x3) {
 		/* Enable antenna diversity, use 2x3 mode */
 		brcms_b_mhf(wlc_hw, MHF3, MHF3_ANTSEL_EN,
-			     MHF3_ANTSEL_EN, WLC_BAND_ALL);
+			     MHF3_ANTSEL_EN, BRCM_BAND_ALL);
 		brcms_b_mhf(wlc_hw, MHF3, MHF3_ANTSEL_MODE,
-			     MHF3_ANTSEL_MODE, WLC_BAND_ALL);
+			     MHF3_ANTSEL_MODE, BRCM_BAND_ALL);
 
 		/* init superswitch control */
 		wlc_phy_antsel_init(wlc_hw->band->pi, false);
@@ -2460,9 +2459,9 @@ static void brcms_c_gpio_init(struct brcms_c_info *wlc)
 
 		/* Enable antenna diversity, use 2x4 mode */
 		brcms_b_mhf(wlc_hw, MHF3, MHF3_ANTSEL_EN,
-			     MHF3_ANTSEL_EN, WLC_BAND_ALL);
+			     MHF3_ANTSEL_EN, BRCM_BAND_ALL);
 		brcms_b_mhf(wlc_hw, MHF3, MHF3_ANTSEL_MODE, 0,
-			     WLC_BAND_ALL);
+			     BRCM_BAND_ALL);
 
 		/* Configure the desired clock to be 4Mhz */
 		brcms_b_write_shm(wlc_hw, M_ANTSEL_CLKDIV,
@@ -2486,7 +2485,7 @@ static void brcms_ucode_download(struct brcms_hardware *wlc_hw)
 		return;
 
 	if (D11REV_IS(wlc_hw->corerev, 23)) {
-		if (WLCISNPHY(wlc_hw->band)) {
+		if (BRCMS_ISNPHY(wlc_hw->band)) {
 			brcms_ucode_write(wlc_hw, bcm43xx_16_mimo,
 					bcm43xx_16_mimosz);
 			wlc_hw->ucode_loaded = true;
@@ -2495,7 +2494,7 @@ static void brcms_ucode_download(struct brcms_hardware *wlc_hw)
 				  "corerev %d\n",
 				  __func__, wlc_hw->unit, wlc_hw->corerev);
 	} else if (D11REV_IS(wlc_hw->corerev, 24)) {
-		if (WLCISLCNPHY(wlc_hw->band)) {
+		if (BRCMS_ISLCNPHY(wlc_hw->band)) {
 			brcms_ucode_write(wlc_hw, bcm43xx_24_lcn,
 					bcm43xx_24_lcnsz);
 			wlc_hw->ucode_loaded = true;
@@ -2796,7 +2795,7 @@ static void brcms_b_tx_fifo_suspend(struct brcms_hardware *wlc_hw,
 	/* force the core awake only if not already */
 	if (wlc_hw->suspended_fifos == 0)
 		brcms_c_ucode_wake_override_set(wlc_hw,
-						WLC_WAKE_OVERRIDE_TXFIFO);
+						BRCMS_WAKE_OVERRIDE_TXFIFO);
 
 	wlc_hw->suspended_fifos |= fifo;
 
@@ -2805,12 +2804,12 @@ static void brcms_b_tx_fifo_suspend(struct brcms_hardware *wlc_hw,
 		 * which may result in mismatch between ucode and driver
 		 * so suspend the mac before suspending the FIFO
 		 */
-		if (WLC_PHY_11N_CAP(wlc_hw->band))
+		if (BRCMS_PHY_11N_CAP(wlc_hw->band))
 			brcms_c_suspend_mac_and_wait(wlc_hw->wlc);
 
 		dma_txsuspend(wlc_hw->di[tx_fifo]);
 
-		if (WLC_PHY_11N_CAP(wlc_hw->band))
+		if (BRCMS_PHY_11N_CAP(wlc_hw->band))
 			brcms_c_enable_mac(wlc_hw->wlc);
 	}
 }
@@ -2818,7 +2817,7 @@ static void brcms_b_tx_fifo_suspend(struct brcms_hardware *wlc_hw,
 static void brcms_b_tx_fifo_resume(struct brcms_hardware *wlc_hw,
 				   uint tx_fifo)
 {
-	/* BMAC_NOTE: WLC_TX_FIFO_ENAB is done in brcms_c_dpc() for DMA case
+	/* BMAC_NOTE: BRCMS_TX_FIFO_ENAB is done in brcms_c_dpc() for DMA case
 	 * but need to be done here for PIO otherwise the watchdog will catch
 	 * the inconsistency and fire
 	 */
@@ -2833,7 +2832,7 @@ static void brcms_b_tx_fifo_resume(struct brcms_hardware *wlc_hw,
 		wlc_hw->suspended_fifos &= ~(1 << tx_fifo);
 		if (wlc_hw->suspended_fifos == 0)
 			brcms_c_ucode_wake_override_clear(wlc_hw,
-						      WLC_WAKE_OVERRIDE_TXFIFO);
+						BRCMS_WAKE_OVERRIDE_TXFIFO);
 	}
 }
 
@@ -3048,7 +3047,7 @@ void brcms_c_suspend_mac_and_wait(struct brcms_c_info *wlc)
 		return;
 
 	/* force the core awake */
-	brcms_c_ucode_wake_override_set(wlc_hw, WLC_WAKE_OVERRIDE_MACSUSPEND);
+	brcms_c_ucode_wake_override_set(wlc_hw, BRCMS_WAKE_OVERRIDE_MACSUSPEND);
 
 	mc = R_REG(&regs->maccontrol);
 
@@ -3074,12 +3073,12 @@ void brcms_c_suspend_mac_and_wait(struct brcms_c_info *wlc)
 	brcms_b_mctrl(wlc_hw, MCTL_EN_MAC, 0);
 
 	SPINWAIT(!(R_REG(&regs->macintstatus) & MI_MACSSPNDD),
-		 WLC_MAX_MAC_SUSPEND);
+		 BRCMS_MAX_MAC_SUSPEND);
 
 	if (!(R_REG(&regs->macintstatus) & MI_MACSSPNDD)) {
 		wiphy_err(wiphy, "wl%d: wlc_suspend_mac_and_wait: waited %d uS"
 			  " and MI_MACSSPNDD is still not on.\n",
-			  wlc_hw->unit, WLC_MAX_MAC_SUSPEND);
+			  wlc_hw->unit, BRCMS_MAX_MAC_SUSPEND);
 		wiphy_err(wiphy, "wl%d: psmdebug 0x%08x, phydebug 0x%08x, "
 			  "psm_brc 0x%04x\n", wlc_hw->unit,
 			  R_REG(&regs->psmdebug),
@@ -3131,21 +3130,22 @@ void brcms_c_enable_mac(struct brcms_c_info *wlc)
 	mi = R_REG(&regs->macintstatus);
 	WARN_ON(mi & MI_MACSSPNDD);
 
-	brcms_c_ucode_wake_override_clear(wlc_hw, WLC_WAKE_OVERRIDE_MACSUSPEND);
+	brcms_c_ucode_wake_override_clear(wlc_hw,
+					  BRCMS_WAKE_OVERRIDE_MACSUSPEND);
 }
 
 static void brcms_upd_ofdm_pctl1_table(struct brcms_hardware *wlc_hw)
 {
 	u8 rate;
 	u8 rates[8] = {
-		WLC_RATE_6M, WLC_RATE_9M, WLC_RATE_12M, WLC_RATE_18M,
-		WLC_RATE_24M, WLC_RATE_36M, WLC_RATE_48M, WLC_RATE_54M
+		BRCM_RATE_6M, BRCM_RATE_9M, BRCM_RATE_12M, BRCM_RATE_18M,
+		BRCM_RATE_24M, BRCM_RATE_36M, BRCM_RATE_48M, BRCM_RATE_54M
 	};
 	u16 entry_ptr;
 	u16 pctl1;
 	uint i;
 
-	if (!WLC_PHY_11N_CAP(wlc_hw->band))
+	if (!BRCMS_PHY_11N_CAP(wlc_hw->band))
 		return;
 
 	/* walk the phy rate table and update the entries */
@@ -3179,14 +3179,14 @@ static u16 brcms_b_ofdm_ratetable_offset(struct brcms_hardware *wlc_hw,
 	};
 	/* OFDM RATE sub-field of PLCP SIGNAL field, per 802.11 sec 17.3.4.1 */
 	const struct plcp_signal_rate_lookup rate_lookup[] = {
-		{WLC_RATE_6M, 0xB},
-		{WLC_RATE_9M, 0xF},
-		{WLC_RATE_12M, 0xA},
-		{WLC_RATE_18M, 0xE},
-		{WLC_RATE_24M, 0x9},
-		{WLC_RATE_36M, 0xD},
-		{WLC_RATE_48M, 0x8},
-		{WLC_RATE_54M, 0xC}
+		{BRCM_RATE_6M, 0xB},
+		{BRCM_RATE_9M, 0xF},
+		{BRCM_RATE_12M, 0xA},
+		{BRCM_RATE_18M, 0xE},
+		{BRCM_RATE_24M, 0x9},
+		{BRCM_RATE_36M, 0xD},
+		{BRCM_RATE_48M, 0x8},
+		{BRCM_RATE_54M, 0xC}
 	};
 
 	for (i = 0; i < ARRAY_SIZE(rate_lookup); i++) {
@@ -3543,7 +3543,7 @@ void brcms_b_pllreq(struct brcms_hardware *wlc_hw, bool set, mbool req_bit)
 
 		mboolset(wlc_hw->pllreq, req_bit);
 
-		if (mboolisset(wlc_hw->pllreq, WLC_PLLREQ_FLIP)) {
+		if (mboolisset(wlc_hw->pllreq, BRCMS_PLLREQ_FLIP)) {
 			if (!wlc_hw->sbclk) {
 				brcms_b_xtal(wlc_hw, ON);
 			}
@@ -3554,7 +3554,7 @@ void brcms_b_pllreq(struct brcms_hardware *wlc_hw, bool set, mbool req_bit)
 
 		mboolclr(wlc_hw->pllreq, req_bit);
 
-		if (mboolisset(wlc_hw->pllreq, WLC_PLLREQ_FLIP)) {
+		if (mboolisset(wlc_hw->pllreq, BRCMS_PLLREQ_FLIP)) {
 			if (wlc_hw->sbclk) {
 				brcms_b_xtal(wlc_hw, OFF);
 			}
@@ -3578,7 +3578,7 @@ u16 brcms_b_rate_shm_offset(struct brcms_hardware *wlc_hw, u8 rate)
 	/* for a given rate, the LS-nibble of the PLCP SIGNAL field is
 	 * the index into the rate table.
 	 */
-	phy_rate = rate_info[rate] & WLC_RATE_MASK;
+	phy_rate = rate_info[rate] & BRCMS_RATE_MASK;
 	index = phy_rate & 0xf;
 
 	/* Find the SHM pointer to the rate table entry by looking in the
diff --git a/drivers/staging/brcm80211/brcmsmac/channel.c b/drivers/staging/brcm80211/brcmsmac/channel.c
index ba245d8..f59693e 100644
--- a/drivers/staging/brcm80211/brcmsmac/channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/channel.c
@@ -41,12 +41,12 @@ struct brcms_cm_band {
 struct brcms_cm_info {
 	struct brcms_pub *pub;
 	struct brcms_c_info *wlc;
-	char srom_ccode[WLC_CNTRY_BUF_SZ];	/* Country Code in SROM */
+	char srom_ccode[BRCM_CNTRY_BUF_SZ];	/* Country Code in SROM */
 	uint srom_regrev;	/* Regulatory Rev for the SROM ccode */
 	const struct country_info *country;	/* current country def */
-	char ccode[WLC_CNTRY_BUF_SZ];	/* current internal Country Code */
+	char ccode[BRCM_CNTRY_BUF_SZ];	/* current internal Country Code */
 	uint regrev;		/* current Regulatory Revision */
-	char country_abbrev[WLC_CNTRY_BUF_SZ];	/* current advertised ccode */
+	char country_abbrev[BRCM_CNTRY_BUF_SZ];	/* current advertised ccode */
 	/* per-band state (one per phy/radio) */
 	struct brcms_cm_band bandstate[MAXBANDS];
 	/* quiet channels currently for radar sensitivity or 11h support */
@@ -106,7 +106,7 @@ static const struct locale_mimo_info *brcms_c_get_mimo_5g(u8 locale_idx);
 #ifdef QDB
 #undef QDB
 #endif
-#define QDB(n) ((n) * WLC_TXPWR_DB_FACTOR)
+#define QDB(n) ((n) * BRCMS_TXPWR_DB_FACTOR)
 
 /* Regulatory Matrix Spreadsheet (CLM) MIMO v3.7.9 */
 
@@ -422,7 +422,7 @@ static const struct locale_info locale_i = {	/* locale i. channel 1 - 13 */
 	{QDB(19), QDB(19), QDB(19),
 	 QDB(19), QDB(19), QDB(19)},
 	{20, 20, 20, 0},
-	WLC_EIRP
+	BRCMS_EIRP
 };
 
 /*
@@ -435,7 +435,7 @@ static const struct locale_info locale_11 = {
 	LOCALE_RESTRICTED_NONE,
 	{QDB(21), QDB(21), QDB(21), QDB(21), QDB(21)},
 	{23, 23, 23, 30, 30},
-	WLC_EIRP | WLC_DFS_EU
+	BRCMS_EIRP | BRCMS_DFS_EU
 };
 
 #define LOCALE_2G_IDX_i			0
@@ -500,7 +500,7 @@ static const struct locale_mimo_info *g_mimo_5g_table[] = {
 #define LOCALES(band2, band5, mimo2, mimo5)     {LC_2G(band2), LC_5G(band5), LC(mimo2), LC(mimo5)}
 
 static const struct {
-	char abbrev[WLC_CNTRY_BUF_SZ];	/* country abbreviation */
+	char abbrev[BRCM_CNTRY_BUF_SZ];	/* country abbreviation */
 	struct country_info country;
 } cntry_locales[] = {
 	{
@@ -619,7 +619,7 @@ static const struct locale_mimo_info *brcms_c_get_mimo_5g(u8 locale_idx)
 struct brcms_cm_info *brcms_c_channel_mgr_attach(struct brcms_c_info *wlc)
 {
 	struct brcms_cm_info *wlc_cm;
-	char country_abbrev[WLC_CNTRY_BUF_SZ];
+	char country_abbrev[BRCM_CNTRY_BUF_SZ];
 	const struct country_info *country;
 	struct brcms_pub *pub = wlc->pub;
 	char *ccode;
@@ -639,19 +639,19 @@ struct brcms_cm_info *brcms_c_channel_mgr_attach(struct brcms_c_info *wlc)
 	/* store the country code for passing up as a regulatory hint */
 	ccode = getvar(wlc->pub->vars, "ccode");
 	if (ccode) {
-		strncpy(wlc->pub->srom_ccode, ccode, WLC_CNTRY_BUF_SZ - 1);
+		strncpy(wlc->pub->srom_ccode, ccode, BRCM_CNTRY_BUF_SZ - 1);
 	}
 
 	/* internal country information which must match regulatory constraints in firmware */
-	memset(country_abbrev, 0, WLC_CNTRY_BUF_SZ);
+	memset(country_abbrev, 0, BRCM_CNTRY_BUF_SZ);
 	strncpy(country_abbrev, "X2", sizeof(country_abbrev) - 1);
 	country = brcms_c_country_lookup(wlc, country_abbrev);
 
 	/* save default country for exiting 11d regulatory mode */
-	strncpy(wlc->country_default, country_abbrev, WLC_CNTRY_BUF_SZ - 1);
+	strncpy(wlc->country_default, country_abbrev, BRCM_CNTRY_BUF_SZ - 1);
 
 	/* initialize autocountry_default to driver default */
-	strncpy(wlc->autocountry_default, "X2", WLC_CNTRY_BUF_SZ - 1);
+	strncpy(wlc->autocountry_default, "X2", BRCM_CNTRY_BUF_SZ - 1);
 
 	brcms_c_set_countrycode(wlc_cm, country_abbrev);
 
@@ -676,8 +676,8 @@ brcms_c_channel_locale_flags_in_band(struct brcms_cm_info *wlc_cm,
 static int
 brcms_c_set_countrycode(struct brcms_cm_info *wlc_cm, const char *ccode)
 {
-	char country_abbrev[WLC_CNTRY_BUF_SZ];
-	strncpy(country_abbrev, ccode, WLC_CNTRY_BUF_SZ);
+	char country_abbrev[BRCM_CNTRY_BUF_SZ];
+	strncpy(country_abbrev, ccode, BRCM_CNTRY_BUF_SZ);
 	return brcms_c_set_countrycode_rev(wlc_cm, country_abbrev, ccode, -1);
 }
 
@@ -687,7 +687,7 @@ brcms_c_set_countrycode_rev(struct brcms_cm_info *wlc_cm,
 			const char *ccode, int regrev)
 {
 	const struct country_info *country;
-	char mapped_ccode[WLC_CNTRY_BUF_SZ];
+	char mapped_ccode[BRCM_CNTRY_BUF_SZ];
 	uint mapped_regrev;
 
 	/* if regrev is -1, lookup the mapped country code,
@@ -701,7 +701,7 @@ brcms_c_set_countrycode_rev(struct brcms_cm_info *wlc_cm,
 	} else {
 		/* find the matching built-in country definition */
 		country = brcms_c_country_lookup_direct(ccode, regrev);
-		strncpy(mapped_ccode, ccode, WLC_CNTRY_BUF_SZ);
+		strncpy(mapped_ccode, ccode, BRCM_CNTRY_BUF_SZ);
 		mapped_regrev = regrev;
 	}
 
@@ -727,22 +727,22 @@ brcms_c_set_country_common(struct brcms_cm_info *wlc_cm,
 	const struct locale_mimo_info *li_mimo;
 	const struct locale_info *locale;
 	struct brcms_c_info *wlc = wlc_cm->wlc;
-	char prev_country_abbrev[WLC_CNTRY_BUF_SZ];
+	char prev_country_abbrev[BRCM_CNTRY_BUF_SZ];
 
 	/* save current country state */
 	wlc_cm->country = country;
 
-	memset(&prev_country_abbrev, 0, WLC_CNTRY_BUF_SZ);
+	memset(&prev_country_abbrev, 0, BRCM_CNTRY_BUF_SZ);
 	strncpy(prev_country_abbrev, wlc_cm->country_abbrev,
-		WLC_CNTRY_BUF_SZ - 1);
+		BRCM_CNTRY_BUF_SZ - 1);
 
-	strncpy(wlc_cm->country_abbrev, country_abbrev, WLC_CNTRY_BUF_SZ - 1);
-	strncpy(wlc_cm->ccode, ccode, WLC_CNTRY_BUF_SZ - 1);
+	strncpy(wlc_cm->country_abbrev, country_abbrev, BRCM_CNTRY_BUF_SZ - 1);
+	strncpy(wlc_cm->ccode, ccode, BRCM_CNTRY_BUF_SZ - 1);
 	wlc_cm->regrev = regrev;
 
 	/* disable/restore nmode based on country regulations */
 	li_mimo = brcms_c_get_mimo_2g(country->locale_mimo_2G);
-	if (li_mimo && (li_mimo->flags & WLC_NO_MIMO)) {
+	if (li_mimo && (li_mimo->flags & BRCMS_NO_MIMO)) {
 		brcms_c_set_nmode(wlc, OFF);
 		wlc->stf->no_cddstbc = true;
 	} else {
@@ -755,7 +755,7 @@ brcms_c_set_country_common(struct brcms_cm_info *wlc_cm,
 	brcms_c_stf_ss_update(wlc, wlc->bandstate[BAND_5G_INDEX]);
 	/* set or restore gmode as required by regulatory */
 	locale = brcms_c_get_locale_2g(country->locale_2G);
-	if (locale && (locale->flags & WLC_NO_OFDM)) {
+	if (locale && (locale->flags & BRCMS_NO_OFDM)) {
 		brcms_c_set_gmode(wlc, GMODE_LEGACY_B, false);
 	} else {
 		brcms_c_set_gmode(wlc, wlc->protection->gmode_user, false);
@@ -773,7 +773,7 @@ static const struct country_info *
 brcms_c_country_lookup(struct brcms_c_info *wlc, const char *ccode)
 {
 	const struct country_info *country;
-	char mapped_ccode[WLC_CNTRY_BUF_SZ];
+	char mapped_ccode[BRCM_CNTRY_BUF_SZ];
 	uint mapped_regrev;
 
 	/* map the country code to a built-in country code, regrev, and country_info struct */
@@ -794,14 +794,14 @@ brcms_c_countrycode_map(struct brcms_cm_info *wlc_cm, const char *ccode,
 	int mapped;
 
 	/* check for currently supported ccode size */
-	if (strlen(ccode) > (WLC_CNTRY_BUF_SZ - 1)) {
+	if (strlen(ccode) > (BRCM_CNTRY_BUF_SZ - 1)) {
 		wiphy_err(wlc->wiphy, "wl%d: %s: ccode \"%s\" too long for "
 			  "match\n", wlc->pub->unit, __func__, ccode);
 		return NULL;
 	}
 
 	/* default mapping is the given ccode and regrev 0 */
-	strncpy(mapped_ccode, ccode, WLC_CNTRY_BUF_SZ);
+	strncpy(mapped_ccode, ccode, BRCM_CNTRY_BUF_SZ);
 	*mapped_regrev = 0;
 
 	/* If the desired country code matches the srom country code,
@@ -959,8 +959,7 @@ static void brcms_c_channels_commit(struct brcms_cm_info *wlc_cm)
 	if (wlc->pub->up && chan != INVCHANNEL) {
 		brcms_c_channel_reg_limits(wlc_cm, wlc->chanspec, &txpwr);
 		brcms_c_channel_min_txpower_limits_with_local_constraint(wlc_cm,
-								     &txpwr,
-								     WLC_TXPWR_MAX);
+			&txpwr, BRCMS_TXPWR_MAX);
 		wlc_phy_txpower_limit_set(wlc->band->pi, &txpwr, wlc->chanspec);
 	}
 }
@@ -1050,66 +1049,66 @@ brcms_c_channel_min_txpower_limits_with_local_constraint(
 	}
 
 	/* 20 MHz Legacy OFDM CDD */
-	for (j = 0; j < WLC_NUM_RATES_OFDM; j++) {
+	for (j = 0; j < BRCMS_NUM_RATES_OFDM; j++) {
 		txpwr->ofdm_cdd[j] =
 		    min(txpwr->ofdm_cdd[j], local_constraint_qdbm);
 	}
 
 	/* 40 MHz Legacy OFDM SISO */
-	for (j = 0; j < WLC_NUM_RATES_OFDM; j++) {
+	for (j = 0; j < BRCMS_NUM_RATES_OFDM; j++) {
 		txpwr->ofdm_40_siso[j] =
 		    min(txpwr->ofdm_40_siso[j], local_constraint_qdbm);
 	}
 
 	/* 40 MHz Legacy OFDM CDD */
-	for (j = 0; j < WLC_NUM_RATES_OFDM; j++) {
+	for (j = 0; j < BRCMS_NUM_RATES_OFDM; j++) {
 		txpwr->ofdm_40_cdd[j] =
 		    min(txpwr->ofdm_40_cdd[j], local_constraint_qdbm);
 	}
 
 	/* 20MHz MCS 0-7 SISO */
-	for (j = 0; j < WLC_NUM_RATES_MCS_1_STREAM; j++) {
+	for (j = 0; j < BRCMS_NUM_RATES_MCS_1_STREAM; j++) {
 		txpwr->mcs_20_siso[j] =
 		    min(txpwr->mcs_20_siso[j], local_constraint_qdbm);
 	}
 
 	/* 20MHz MCS 0-7 CDD */
-	for (j = 0; j < WLC_NUM_RATES_MCS_1_STREAM; j++) {
+	for (j = 0; j < BRCMS_NUM_RATES_MCS_1_STREAM; j++) {
 		txpwr->mcs_20_cdd[j] =
 		    min(txpwr->mcs_20_cdd[j], local_constraint_qdbm);
 	}
 
 	/* 20MHz MCS 0-7 STBC */
-	for (j = 0; j < WLC_NUM_RATES_MCS_1_STREAM; j++) {
+	for (j = 0; j < BRCMS_NUM_RATES_MCS_1_STREAM; j++) {
 		txpwr->mcs_20_stbc[j] =
 		    min(txpwr->mcs_20_stbc[j], local_constraint_qdbm);
 	}
 
 	/* 20MHz MCS 8-15 MIMO */
-	for (j = 0; j < WLC_NUM_RATES_MCS_2_STREAM; j++)
+	for (j = 0; j < BRCMS_NUM_RATES_MCS_2_STREAM; j++)
 		txpwr->mcs_20_mimo[j] =
 		    min(txpwr->mcs_20_mimo[j], local_constraint_qdbm);
 
 	/* 40MHz MCS 0-7 SISO */
-	for (j = 0; j < WLC_NUM_RATES_MCS_1_STREAM; j++) {
+	for (j = 0; j < BRCMS_NUM_RATES_MCS_1_STREAM; j++) {
 		txpwr->mcs_40_siso[j] =
 		    min(txpwr->mcs_40_siso[j], local_constraint_qdbm);
 	}
 
 	/* 40MHz MCS 0-7 CDD */
-	for (j = 0; j < WLC_NUM_RATES_MCS_1_STREAM; j++) {
+	for (j = 0; j < BRCMS_NUM_RATES_MCS_1_STREAM; j++) {
 		txpwr->mcs_40_cdd[j] =
 		    min(txpwr->mcs_40_cdd[j], local_constraint_qdbm);
 	}
 
 	/* 40MHz MCS 0-7 STBC */
-	for (j = 0; j < WLC_NUM_RATES_MCS_1_STREAM; j++) {
+	for (j = 0; j < BRCMS_NUM_RATES_MCS_1_STREAM; j++) {
 		txpwr->mcs_40_stbc[j] =
 		    min(txpwr->mcs_40_stbc[j], local_constraint_qdbm);
 	}
 
 	/* 40MHz MCS 8-15 MIMO */
-	for (j = 0; j < WLC_NUM_RATES_MCS_2_STREAM; j++)
+	for (j = 0; j < BRCMS_NUM_RATES_MCS_2_STREAM; j++)
 		txpwr->mcs_40_mimo[j] =
 		    min(txpwr->mcs_40_mimo[j], local_constraint_qdbm);
 
@@ -1143,112 +1142,122 @@ static void wlc_phy_txpower_limits_dump(struct txpwr_limits *txpwr)
 	char fraction[4][4] = { "   ", ".25", ".5 ", ".75" };
 
 	sprintf(buf, "CCK                ");
-	for (i = 0; i < WLC_NUM_RATES_CCK; i++) {
+	for (i = 0; i < BRCMS_NUM_RATES_CCK; i++) {
 		sprintf(buf[strlen(buf)], " %2d%s",
-			txpwr->cck[i] / WLC_TXPWR_DB_FACTOR,
-			fraction[txpwr->cck[i] % WLC_TXPWR_DB_FACTOR]);
+			txpwr->cck[i] / BRCMS_TXPWR_DB_FACTOR,
+			fraction[txpwr->cck[i] % BRCMS_TXPWR_DB_FACTOR]);
 	}
 	printk(KERN_DEBUG "%s\n", buf);
 
 	sprintf(buf, "20 MHz OFDM SISO   ");
-	for (i = 0; i < WLC_NUM_RATES_OFDM; i++) {
+	for (i = 0; i < BRCMS_NUM_RATES_OFDM; i++) {
 		sprintf(buf[strlen(buf)], " %2d%s",
-			txpwr->ofdm[i] / WLC_TXPWR_DB_FACTOR,
-			fraction[txpwr->ofdm[i] % WLC_TXPWR_DB_FACTOR]);
+			txpwr->ofdm[i] / BRCMS_TXPWR_DB_FACTOR,
+			fraction[txpwr->ofdm[i] % BRCMS_TXPWR_DB_FACTOR]);
 	}
 	printk(KERN_DEBUG "%s\n", buf);
 
 	sprintf(buf, "20 MHz OFDM CDD    ");
-	for (i = 0; i < WLC_NUM_RATES_OFDM; i++) {
+	for (i = 0; i < BRCMS_NUM_RATES_OFDM; i++) {
 		sprintf(buf[strlen(buf)], " %2d%s",
-			txpwr->ofdm_cdd[i] / WLC_TXPWR_DB_FACTOR,
-			fraction[txpwr->ofdm_cdd[i] % WLC_TXPWR_DB_FACTOR]);
+			txpwr->ofdm_cdd[i] / BRCMS_TXPWR_DB_FACTOR,
+			fraction[txpwr->ofdm_cdd[i] % BRCMS_TXPWR_DB_FACTOR]);
 	}
 	printk(KERN_DEBUG "%s\n", buf);
 
 	sprintf(buf, "40 MHz OFDM SISO   ");
-	for (i = 0; i < WLC_NUM_RATES_OFDM; i++) {
+	for (i = 0; i < BRCMS_NUM_RATES_OFDM; i++) {
 		sprintf(buf[strlen(buf)], " %2d%s",
-			txpwr->ofdm_40_siso[i] / WLC_TXPWR_DB_FACTOR,
-			fraction[txpwr->ofdm_40_siso[i] % WLC_TXPWR_DB_FACTOR]);
+			txpwr->ofdm_40_siso[i] / BRCMS_TXPWR_DB_FACTOR,
+			fraction[txpwr->ofdm_40_siso[i] %
+							BRCMS_TXPWR_DB_FACTOR]);
 	}
 	printk(KERN_DEBUG "%s\n", buf);
 
 	sprintf(buf, "40 MHz OFDM CDD    ");
-	for (i = 0; i < WLC_NUM_RATES_OFDM; i++) {
+	for (i = 0; i < BRCMS_NUM_RATES_OFDM; i++) {
 		sprintf(buf[strlen(buf)], " %2d%s",
-			txpwr->ofdm_40_cdd[i] / WLC_TXPWR_DB_FACTOR,
-			fraction[txpwr->ofdm_40_cdd[i] % WLC_TXPWR_DB_FACTOR]);
+			txpwr->ofdm_40_cdd[i] / BRCMS_TXPWR_DB_FACTOR,
+			fraction[txpwr->ofdm_40_cdd[i] %
+							BRCMS_TXPWR_DB_FACTOR]);
 	}
 	printk(KERN_DEBUG "%s\n", buf);
 
 	sprintf(buf, "20 MHz MCS0-7 SISO ");
-	for (i = 0; i < WLC_NUM_RATES_MCS_1_STREAM; i++) {
+	for (i = 0; i < BRCMS_NUM_RATES_MCS_1_STREAM; i++) {
 		sprintf(buf[strlen(buf)], " %2d%s",
-			txpwr->mcs_20_siso[i] / WLC_TXPWR_DB_FACTOR,
-			fraction[txpwr->mcs_20_siso[i] % WLC_TXPWR_DB_FACTOR]);
+			txpwr->mcs_20_siso[i] / BRCMS_TXPWR_DB_FACTOR,
+			fraction[txpwr->mcs_20_siso[i] %
+							BRCMS_TXPWR_DB_FACTOR]);
 	}
 	printk(KERN_DEBUG "%s\n", buf);
 
 	sprintf(buf, "20 MHz MCS0-7 CDD  ");
-	for (i = 0; i < WLC_NUM_RATES_MCS_1_STREAM; i++) {
+	for (i = 0; i < BRCMS_NUM_RATES_MCS_1_STREAM; i++) {
 		sprintf(buf[strlen(buf)], " %2d%s",
-			txpwr->mcs_20_cdd[i] / WLC_TXPWR_DB_FACTOR,
-			fraction[txpwr->mcs_20_cdd[i] % WLC_TXPWR_DB_FACTOR]);
+			txpwr->mcs_20_cdd[i] / BRCMS_TXPWR_DB_FACTOR,
+			fraction[txpwr->mcs_20_cdd[i] %
+							BRCMS_TXPWR_DB_FACTOR]);
 	}
 	printk(KERN_DEBUG "%s\n", buf);
 
 	sprintf(buf, "20 MHz MCS0-7 STBC ");
-	for (i = 0; i < WLC_NUM_RATES_MCS_1_STREAM; i++) {
+	for (i = 0; i < BRCMS_NUM_RATES_MCS_1_STREAM; i++) {
 		sprintf(buf[strlen(buf)], " %2d%s",
-			txpwr->mcs_20_stbc[i] / WLC_TXPWR_DB_FACTOR,
-			fraction[txpwr->mcs_20_stbc[i] % WLC_TXPWR_DB_FACTOR]);
+			txpwr->mcs_20_stbc[i] / BRCMS_TXPWR_DB_FACTOR,
+			fraction[txpwr->mcs_20_stbc[i] %
+							BRCMS_TXPWR_DB_FACTOR]);
 	}
 	printk(KERN_DEBUG "%s\n", buf);
 
 	sprintf(buf, "20 MHz MCS8-15 SDM ");
-	for (i = 0; i < WLC_NUM_RATES_MCS_2_STREAM; i++) {
+	for (i = 0; i < BRCMS_NUM_RATES_MCS_2_STREAM; i++) {
 		sprintf(buf[strlen(buf)], " %2d%s",
-			txpwr->mcs_20_mimo[i] / WLC_TXPWR_DB_FACTOR,
-			fraction[txpwr->mcs_20_mimo[i] % WLC_TXPWR_DB_FACTOR]);
+			txpwr->mcs_20_mimo[i] / BRCMS_TXPWR_DB_FACTOR,
+			fraction[txpwr->mcs_20_mimo[i] %
+							BRCMS_TXPWR_DB_FACTOR]);
 	}
 	printk(KERN_DEBUG "%s\n", buf);
 
 	sprintf(buf, "40 MHz MCS0-7 SISO ");
-	for (i = 0; i < WLC_NUM_RATES_MCS_1_STREAM; i++) {
+	for (i = 0; i < BRCMS_NUM_RATES_MCS_1_STREAM; i++) {
 		sprintf(buf[strlen(buf)], " %2d%s",
-			txpwr->mcs_40_siso[i] / WLC_TXPWR_DB_FACTOR,
-			fraction[txpwr->mcs_40_siso[i] % WLC_TXPWR_DB_FACTOR]);
+			txpwr->mcs_40_siso[i] / BRCMS_TXPWR_DB_FACTOR,
+			fraction[txpwr->mcs_40_siso[i] %
+							BRCMS_TXPWR_DB_FACTOR]);
 	}
 	printk(KERN_DEBUG "%s\n", buf);
 
 	sprintf(buf, "40 MHz MCS0-7 CDD  ");
-	for (i = 0; i < WLC_NUM_RATES_MCS_1_STREAM; i++) {
+	for (i = 0; i < BRCMS_NUM_RATES_MCS_1_STREAM; i++) {
 		sprintf(buf[strlen(buf)], " %2d%s",
-			txpwr->mcs_40_cdd[i] / WLC_TXPWR_DB_FACTOR,
-			fraction[txpwr->mcs_40_cdd[i] % WLC_TXPWR_DB_FACTOR]);
+			txpwr->mcs_40_cdd[i] / BRCMS_TXPWR_DB_FACTOR,
+			fraction[txpwr->mcs_40_cdd[i] %
+							BRCMS_TXPWR_DB_FACTOR]);
 	}
 	printk(KERN_DEBUG "%s\n", buf);
 
 	sprintf(buf, "40 MHz MCS0-7 STBC ");
-	for (i = 0; i < WLC_NUM_RATES_MCS_1_STREAM; i++) {
+	for (i = 0; i < BRCMS_NUM_RATES_MCS_1_STREAM; i++) {
 		sprintf(buf[strlen(buf)], " %2d%s",
-			txpwr->mcs_40_stbc[i] / WLC_TXPWR_DB_FACTOR,
-			fraction[txpwr->mcs_40_stbc[i] % WLC_TXPWR_DB_FACTOR]);
+			txpwr->mcs_40_stbc[i] / BRCMS_TXPWR_DB_FACTOR,
+			fraction[txpwr->mcs_40_stbc[i] %
+							BRCMS_TXPWR_DB_FACTOR]);
 	}
 	printk(KERN_DEBUG "%s\n", buf);
 
 	sprintf(buf, "40 MHz MCS8-15 SDM ");
-	for (i = 0; i < WLC_NUM_RATES_MCS_2_STREAM; i++) {
+	for (i = 0; i < BRCMS_NUM_RATES_MCS_2_STREAM; i++) {
 		sprintf(buf[strlen(buf)], " %2d%s",
-			txpwr->mcs_40_mimo[i] / WLC_TXPWR_DB_FACTOR,
-			fraction[txpwr->mcs_40_mimo[i] % WLC_TXPWR_DB_FACTOR]);
+			txpwr->mcs_40_mimo[i] / BRCMS_TXPWR_DB_FACTOR,
+			fraction[txpwr->mcs_40_mimo[i] %
+							BRCMS_TXPWR_DB_FACTOR]);
 	}
 	printk(KERN_DEBUG "%s\n", buf);
 
 	printk(KERN_DEBUG "MCS32               %2d%s\n",
-	       txpwr->mcs32 / WLC_TXPWR_DB_FACTOR,
-	       fraction[txpwr->mcs32 % WLC_TXPWR_DB_FACTOR]);
+	       txpwr->mcs32 / BRCMS_TXPWR_DB_FACTOR,
+	       fraction[txpwr->mcs32 % BRCMS_TXPWR_DB_FACTOR]);
 }
 #endif				/* POWER_DBG */
 
@@ -1282,7 +1291,7 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, chanspec_t chanspec,
 	}
 
 	chan = CHSPEC_CHANNEL(chanspec);
-	band = wlc->bandstate[CHSPEC_WLCBANDUNIT(chanspec)];
+	band = wlc->bandstate[CHSPEC_BANDUNIT(chanspec)];
 	li = BAND_5G(band->bandtype) ?
 	    brcms_c_get_locale_5g(country->locale_5G) :
 	    brcms_c_get_locale_2g(country->locale_2G);
@@ -1291,7 +1300,7 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, chanspec_t chanspec,
 	    brcms_c_get_mimo_5g(country->locale_mimo_5G) :
 	    brcms_c_get_mimo_2g(country->locale_mimo_2G);
 
-	if (li->flags & WLC_EIRP) {
+	if (li->flags & BRCMS_EIRP) {
 		delta = band->antgain;
 	} else {
 		delta = 0;
@@ -1312,7 +1321,7 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, chanspec_t chanspec,
 		maxpwr = max(maxpwr, 0);
 		maxpwr = min(maxpwr, conducted_max);
 
-		for (i = 0; i < WLC_NUM_RATES_CCK; i++)
+		for (i = 0; i < BRCMS_NUM_RATES_CCK; i++)
 			txpwr->cck[i] = (u8) maxpwr;
 	}
 
@@ -1332,11 +1341,10 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, chanspec_t chanspec,
 	if (BAND_2G(band->bandtype))
 		maxpwr = min_t(int, maxpwr, txpwr->cck[0]);
 
-	for (i = 0; i < WLC_NUM_RATES_OFDM; i++) {
+	for (i = 0; i < BRCMS_NUM_RATES_OFDM; i++)
 		txpwr->ofdm[i] = (u8) maxpwr;
-	}
 
-	for (i = 0; i < WLC_NUM_RATES_OFDM; i++) {
+	for (i = 0; i < BRCMS_NUM_RATES_OFDM; i++) {
 		/* OFDM 40 MHz SISO has the same power as the corresponding MCS0-7 rate unless
 		 * overriden by the locale specific code. We set this value to 0 as a
 		 * flag (presumably 0 dBm isn't a possibility) and then copy the MCS0-7 value
@@ -1350,7 +1358,7 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, chanspec_t chanspec,
 	}
 
 	/* MIMO/HT specific limits */
-	if (li_mimo->flags & WLC_EIRP) {
+	if (li_mimo->flags & BRCMS_EIRP) {
 		delta = band->antgain;
 	} else {
 		delta = 0;
@@ -1372,7 +1380,7 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, chanspec_t chanspec,
 	maxpwr40 = max(maxpwr40, 0);
 
 	/* Fill in the MCS 0-7 (SISO) rates */
-	for (i = 0; i < WLC_NUM_RATES_MCS_1_STREAM; i++) {
+	for (i = 0; i < BRCMS_NUM_RATES_MCS_1_STREAM; i++) {
 
 		/* 20 MHz has the same power as the corresponding OFDM rate unless
 		 * overriden by the locale specific code.
@@ -1382,7 +1390,7 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, chanspec_t chanspec,
 	}
 
 	/* Fill in the MCS 0-7 CDD rates */
-	for (i = 0; i < WLC_NUM_RATES_MCS_1_STREAM; i++) {
+	for (i = 0; i < BRCMS_NUM_RATES_MCS_1_STREAM; i++) {
 		txpwr->mcs_20_cdd[i] = (u8) maxpwr20;
 		txpwr->mcs_40_cdd[i] = (u8) maxpwr40;
 	}
@@ -1398,20 +1406,20 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, chanspec_t chanspec,
 			}
 		}
 
-		for (i = 0; i < WLC_NUM_RATES_MCS_1_STREAM; i++) {
+		for (i = 0; i < BRCMS_NUM_RATES_MCS_1_STREAM; i++) {
 			txpwr->mcs_20_siso[i] = (u8) maxpwr20;
 			txpwr->mcs_40_siso[i] = (u8) maxpwr40;
 		}
 	}
 
 	/* Fill in the MCS 0-7 STBC rates */
-	for (i = 0; i < WLC_NUM_RATES_MCS_1_STREAM; i++) {
+	for (i = 0; i < BRCMS_NUM_RATES_MCS_1_STREAM; i++) {
 		txpwr->mcs_20_stbc[i] = 0;
 		txpwr->mcs_40_stbc[i] = 0;
 	}
 
 	/* Fill in the MCS 8-15 SDM rates */
-	for (i = 0; i < WLC_NUM_RATES_MCS_2_STREAM; i++) {
+	for (i = 0; i < BRCMS_NUM_RATES_MCS_2_STREAM; i++) {
 		txpwr->mcs_20_mimo[i] = (u8) maxpwr20;
 		txpwr->mcs_40_mimo[i] = (u8) maxpwr40;
 	}
@@ -1419,7 +1427,7 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, chanspec_t chanspec,
 	/* Fill in MCS32 */
 	txpwr->mcs32 = (u8) maxpwr40;
 
-	for (i = 0, j = 0; i < WLC_NUM_RATES_OFDM; i++, j++) {
+	for (i = 0, j = 0; i < BRCMS_NUM_RATES_OFDM; i++, j++) {
 		if (txpwr->ofdm_40_cdd[i] == 0)
 			txpwr->ofdm_40_cdd[i] = txpwr->mcs_40_cdd[j];
 		if (i == 0) {
@@ -1433,12 +1441,12 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, chanspec_t chanspec,
 	 * provided explicitly.
 	 */
 
-	for (i = 0; i < WLC_NUM_RATES_MCS_1_STREAM; i++) {
+	for (i = 0; i < BRCMS_NUM_RATES_MCS_1_STREAM; i++) {
 		if (txpwr->mcs_40_siso[i] == 0)
 			txpwr->mcs_40_siso[i] = txpwr->mcs_40_cdd[i];
 	}
 
-	for (i = 0, j = 0; i < WLC_NUM_RATES_OFDM; i++, j++) {
+	for (i = 0, j = 0; i < BRCMS_NUM_RATES_OFDM; i++, j++) {
 		if (txpwr->ofdm_40_siso[i] == 0)
 			txpwr->ofdm_40_siso[i] = txpwr->mcs_40_siso[j];
 		if (i == 0) {
@@ -1451,7 +1459,7 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, chanspec_t chanspec,
 	/* Copy the 20 and 40 MHz MCS0-7 CDD values to the corresponding STBC values if they weren't
 	 * provided explicitly.
 	 */
-	for (i = 0; i < WLC_NUM_RATES_MCS_1_STREAM; i++) {
+	for (i = 0; i < BRCMS_NUM_RATES_MCS_1_STREAM; i++) {
 		if (txpwr->mcs_20_stbc[i] == 0)
 			txpwr->mcs_20_stbc[i] = txpwr->mcs_20_cdd[i];
 
@@ -1497,7 +1505,7 @@ brcms_c_valid_chanspec_ext(struct brcms_cm_info *wlc_cm, chanspec_t chspec,
 	}
 
 	if (CHANNEL_BANDUNIT(wlc_cm->wlc, channel) !=
-	    CHSPEC_WLCBANDUNIT(chspec))
+	    CHSPEC_BANDUNIT(chspec))
 		return false;
 
 	/* Check a 20Mhz channel */
@@ -1511,12 +1519,12 @@ brcms_c_valid_chanspec_ext(struct brcms_cm_info *wlc_cm, chanspec_t chspec,
 	/* We know we are now checking a 40MHZ channel, so we should only be here
 	 * for NPHYS
 	 */
-	if (WLCISNPHY(wlc->band) || WLCISSSLPNPHY(wlc->band)) {
+	if (BRCMS_ISNPHY(wlc->band) || BRCMS_ISSSLPNPHY(wlc->band)) {
 		u8 upper_sideband = 0, idx;
 		u8 num_ch20_entries =
 		    sizeof(chan20_info) / sizeof(struct chan20_info);
 
-		if (!VALID_40CHANSPEC_IN_BAND(wlc, CHSPEC_WLCBANDUNIT(chspec)))
+		if (!VALID_40CHANSPEC_IN_BAND(wlc, CHSPEC_BANDUNIT(chspec)))
 			return false;
 
 		if (dualband) {
diff --git a/drivers/staging/brcm80211/brcmsmac/channel.h b/drivers/staging/brcm80211/brcmsmac/channel.h
index ff7123c..d22f2f5 100644
--- a/drivers/staging/brcm80211/brcmsmac/channel.h
+++ b/drivers/staging/brcm80211/brcmsmac/channel.h
@@ -17,7 +17,8 @@
 #ifndef _BRCM_CHANNEL_H_
 #define _BRCM_CHANNEL_H_
 
-#define WLC_TXPWR_DB_FACTOR 4	/* conversion for phy txpwr cacluations that use .25 dB units */
+/* conversion for phy txpwr calculations that use .25 dB units */
+#define BRCMS_TXPWR_DB_FACTOR 4
 
 
 /* maxpwr mapping to 5GHz band channels:
@@ -46,8 +47,10 @@
 #define CHANNEL_POWER_IDX_5G(c) \
 	(((c) < 52) ? 0 : (((c) < 62) ? 1 : (((c) < 100) ? 2 : (((c) < 149) ? 3 : 4))))
 
-#define WLC_MAXPWR_TBL_SIZE		6	/* max of BAND_5G_PWR_LVLS and 6 for 2.4 GHz */
-#define WLC_MAXPWR_MIMO_TBL_SIZE	14	/* max of BAND_5G_PWR_LVLS and 14 for 2.4 GHz */
+/* max of BAND_5G_PWR_LVLS and 6 for 2.4 GHz */
+#define BRCMS_MAXPWR_TBL_SIZE		6
+/* max of BAND_5G_PWR_LVLS and 14 for 2.4 GHz */
+#define BRCMS_MAXPWR_MIMO_TBL_SIZE	14
 
 #define NBANDS(wlc) ((wlc)->pub->_nbands)
 #define NBANDS_PUB(pub) ((pub)->_nbands)
@@ -58,9 +61,12 @@
 /* locale channel and power info. */
 struct locale_info {
 	u32 valid_channels;
-	u8 radar_channels;	/* List of radar sensitive channels */
-	u8 restricted_channels;	/* List of channels used only if APs are detected */
-	s8 maxpwr[WLC_MAXPWR_TBL_SIZE];	/* Max tx pwr in qdBm for each sub-band */
+	/* List of radar sensitive channels */
+	u8 radar_channels;
+	/* List of channels used only if APs are detected */
+	u8 restricted_channels;
+	/* Max tx pwr in qdBm for each sub-band */
+	s8 maxpwr[BRCMS_MAXPWR_TBL_SIZE];
 	s8 pub_maxpwr[BAND_5G_PWR_LVLS];	/* Country IE advertised max tx pwr in dBm
 						 * per sub-band
 						 */
@@ -68,25 +74,27 @@ struct locale_info {
 };
 
 /* bits for locale_info flags */
-#define WLC_PEAK_CONDUCTED	0x00	/* Peak for locals */
-#define WLC_EIRP		0x01	/* Flag for EIRP */
-#define WLC_DFS_TPC		0x02	/* Flag for DFS TPC */
-#define WLC_NO_OFDM		0x04	/* Flag for No OFDM */
-#define WLC_NO_40MHZ		0x08	/* Flag for No MIMO 40MHz */
-#define WLC_NO_MIMO		0x10	/* Flag for No MIMO, 20 or 40 MHz */
-#define WLC_RADAR_TYPE_EU       0x20	/* Flag for EU */
-#define WLC_DFS_FCC             WLC_DFS_TPC	/* Flag for DFS FCC */
-#define WLC_DFS_EU              (WLC_DFS_TPC | WLC_RADAR_TYPE_EU)	/* Flag for DFS EU */
-
-#define ISDFS_EU(fl)		(((fl) & WLC_DFS_EU) == WLC_DFS_EU)
+#define BRCMS_PEAK_CONDUCTED	0x00	/* Peak for locals */
+#define BRCMS_EIRP		0x01	/* Flag for EIRP */
+#define BRCMS_DFS_TPC		0x02	/* Flag for DFS TPC */
+#define BRCMS_NO_OFDM		0x04	/* Flag for No OFDM */
+#define BRCMS_NO_40MHZ		0x08	/* Flag for No MIMO 40MHz */
+#define BRCMS_NO_MIMO		0x10	/* Flag for No MIMO, 20 or 40 MHz */
+#define BRCMS_RADAR_TYPE_EU       0x20	/* Flag for EU */
+#define BRCMS_DFS_FCC             BRCMS_DFS_TPC	/* Flag for DFS FCC */
+#define BRCMS_DFS_EU (BRCMS_DFS_TPC | BRCMS_RADAR_TYPE_EU) /* Flag for DFS EU */
+
+#define ISDFS_EU(fl)		(((fl) & BRCMS_DFS_EU) == BRCMS_DFS_EU)
 
 /* locale per-channel tx power limits for MIMO frames
  * maxpwr arrays are index by channel for 2.4 GHz limits, and
  * by sub-band for 5 GHz limits using CHANNEL_POWER_IDX_5G(channel)
  */
 struct locale_mimo_info {
-	s8 maxpwr20[WLC_MAXPWR_MIMO_TBL_SIZE];	/* tx 20 MHz power limits, qdBm units */
-	s8 maxpwr40[WLC_MAXPWR_MIMO_TBL_SIZE];	/* tx 40 MHz power limits, qdBm units */
+	/* tx 20 MHz power limits, qdBm units */
+	s8 maxpwr20[BRCMS_MAXPWR_MIMO_TBL_SIZE];
+	/* tx 40 MHz power limits, qdBm units */
+	s8 maxpwr40[BRCMS_MAXPWR_MIMO_TBL_SIZE];
 	u8 flags;
 };
 
diff --git a/drivers/staging/brcm80211/brcmsmac/d11.h b/drivers/staging/brcm80211/brcmsmac/d11.h
index 37629bf..70d3802 100644
--- a/drivers/staging/brcm80211/brcmsmac/d11.h
+++ b/drivers/staging/brcm80211/brcmsmac/d11.h
@@ -681,17 +681,17 @@ struct cck_phy_hdr {
 #define MIMO_PLCP_40MHZ		0x80	/* 40 Hz frame */
 #define MIMO_PLCP_AMPDU		0x08	/* ampdu */
 
-#define WLC_GET_CCK_PLCP_LEN(plcp) (plcp[4] + (plcp[5] << 8))
-#define WLC_GET_MIMO_PLCP_LEN(plcp) (plcp[1] + (plcp[2] << 8))
-#define WLC_SET_MIMO_PLCP_LEN(plcp, len) \
+#define BRCMS_GET_CCK_PLCP_LEN(plcp) (plcp[4] + (plcp[5] << 8))
+#define BRCMS_GET_MIMO_PLCP_LEN(plcp) (plcp[1] + (plcp[2] << 8))
+#define BRCMS_SET_MIMO_PLCP_LEN(plcp, len) \
 	do { \
 		plcp[1] = len & 0xff; \
 		plcp[2] = ((len >> 8) & 0xff); \
 	} while (0);
 
-#define WLC_SET_MIMO_PLCP_AMPDU(plcp) (plcp[3] |= MIMO_PLCP_AMPDU)
-#define WLC_CLR_MIMO_PLCP_AMPDU(plcp) (plcp[3] &= ~MIMO_PLCP_AMPDU)
-#define WLC_IS_MIMO_PLCP_AMPDU(plcp) (plcp[3] & MIMO_PLCP_AMPDU)
+#define BRCMS_SET_MIMO_PLCP_AMPDU(plcp) (plcp[3] |= MIMO_PLCP_AMPDU)
+#define BRCMS_CLR_MIMO_PLCP_AMPDU(plcp) (plcp[3] &= ~MIMO_PLCP_AMPDU)
+#define BRCMS_IS_MIMO_PLCP_AMPDU(plcp) (plcp[3] & MIMO_PLCP_AMPDU)
 
 /* The dot11a PLCP header is 5 bytes.  To simplify the software (so that we
  * don't need e.g. different tx DMA headers for 11a and 11b), the PLCP header has
diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index 77b06d5..84245b9 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -248,7 +248,7 @@ ieee_set_channel(struct ieee80211_hw *hw, struct ieee80211_channel *chan,
 	switch (type) {
 	case NL80211_CHAN_HT20:
 	case NL80211_CHAN_NO_HT:
-		err = brcms_c_set(wl->wlc, WLC_SET_CHANNEL, chan->hw_value);
+		err = brcms_c_set(wl->wlc, BRCM_SET_CHANNEL, chan->hw_value);
 		break;
 	case NL80211_CHAN_HT40MINUS:
 	case NL80211_CHAN_HT40PLUS:
@@ -310,13 +310,13 @@ static int brcms_ops_config(struct ieee80211_hw *hw, u32 changed)
 	}
 	if (changed & IEEE80211_CONF_CHANGE_RETRY_LIMITS) {
 		if (brcms_c_set
-		    (wl->wlc, WLC_SET_SRL,
+		    (wl->wlc, BRCM_SET_SRL,
 		     conf->short_frame_max_tx_count) < 0) {
 			wiphy_err(wiphy, "%s: Error setting srl\n", __func__);
 			err = -EIO;
 			goto config_out;
 		}
-		if (brcms_c_set(wl->wlc, WLC_SET_LRL,
+		if (brcms_c_set(wl->wlc, BRCM_SET_LRL,
 				conf->long_frame_max_tx_count) < 0) {
 			wiphy_err(wiphy, "%s: Error setting lrl\n", __func__);
 			err = -EIO;
@@ -355,7 +355,7 @@ brcms_ops_bss_info_changed(struct ieee80211_hw *hw,
 		else
 			val = 0;
 		LOCK(wl);
-		brcms_c_set(wl->wlc, WLC_SET_SHORTSLOT_OVERRIDE, val);
+		brcms_c_set(wl->wlc, BRCMS_SET_SHORTSLOT_OVERRIDE, val);
 		UNLOCK(wl);
 	}
 
@@ -364,11 +364,11 @@ brcms_ops_bss_info_changed(struct ieee80211_hw *hw,
 		u16 mode = info->ht_operation_mode;
 
 		LOCK(wl);
-		brcms_c_protection_upd(wl->wlc, WLC_PROT_N_CFG,
+		brcms_c_protection_upd(wl->wlc, BRCMS_PROT_N_CFG,
 			mode & IEEE80211_HT_OP_MODE_PROTECTION);
-		brcms_c_protection_upd(wl->wlc, WLC_PROT_N_NONGF,
+		brcms_c_protection_upd(wl->wlc, BRCMS_PROT_N_NONGF,
 			mode & IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT);
-		brcms_c_protection_upd(wl->wlc, WLC_PROT_N_OBSS,
+		brcms_c_protection_upd(wl->wlc, BRCMS_PROT_N_OBSS,
 			mode & IEEE80211_HT_OP_MODE_NON_HT_STA_PRSNT);
 		UNLOCK(wl);
 	}
@@ -381,7 +381,7 @@ brcms_ops_bss_info_changed(struct ieee80211_hw *hw,
 
 		/* retrieve the current rates */
 		LOCK(wl);
-		error = brcms_c_ioctl(wl->wlc, WLC_GET_CURR_RATESET,
+		error = brcms_c_ioctl(wl->wlc, BRCM_GET_CURR_RATESET,
 				  &rs, sizeof(rs), NULL);
 		UNLOCK(wl);
 		if (error) {
@@ -402,13 +402,13 @@ brcms_ops_bss_info_changed(struct ieee80211_hw *hw,
 
 		/* update the rate set */
 		LOCK(wl);
-		brcms_c_ioctl(wl->wlc, WLC_SET_RATESET, &rs, sizeof(rs), NULL);
+		brcms_c_ioctl(wl->wlc, BRCM_SET_RATESET, &rs, sizeof(rs), NULL);
 		UNLOCK(wl);
 	}
 	if (changed & BSS_CHANGED_BEACON_INT) {
 		/* Beacon interval changed */
 		LOCK(wl);
-		brcms_c_set(wl->wlc, WLC_SET_BCNPRD, info->beacon_int);
+		brcms_c_set(wl->wlc, BRCM_SET_BCNPRD, info->beacon_int);
 		UNLOCK(wl);
 	}
 	if (changed & BSS_CHANGED_BSSID) {
@@ -1045,7 +1045,7 @@ static int ieee_hw_rate_init(struct ieee80211_hw *hw)
 	hw->wiphy->bands[IEEE80211_BAND_2GHZ] = NULL;
 	hw->wiphy->bands[IEEE80211_BAND_5GHZ] = NULL;
 
-	if (brcms_c_get(wl->wlc, WLC_GET_PHYLIST, (int *)&phy_list) < 0)
+	if (brcms_c_get(wl->wlc, BRCM_GET_PHYLIST, (int *)&phy_list) < 0)
 		wiphy_err(hw->wiphy, "Phy list failed\n");
 
 	if (phy_list[0] == 'n' || phy_list[0] == 'c') {
@@ -1382,9 +1382,9 @@ static void brcms_set_basic_rate(struct wl_rateset *rs, u16 rate, bool is_br)
 			continue;
 
 		if (is_br)
-			rs->rates[i] |= WLC_RATE_FLAG;
+			rs->rates[i] |= BRCMS_RATE_FLAG;
 		else
-			rs->rates[i] &= WLC_RATE_MASK;
+			rs->rates[i] &= BRCMS_RATE_MASK;
 		return;
 	}
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.h b/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
index 42fc04c..40e3d37 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
@@ -21,7 +21,7 @@
 #include <linux/interrupt.h>
 
 /* softmac ioctl definitions */
-#define WLC_SET_SHORTSLOT_OVERRIDE		146
+#define BRCMS_SET_SHORTSLOT_OVERRIDE		146
 
 
 /* BMAC Note: High-only driver is no longer working in softirq context as it needs to block and
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index b89b0ec..7c06026 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -54,11 +54,14 @@
 #define	TIMER_INTERVAL_WATCHDOG	1000	/* watchdog timer, in unit of ms */
 #define	TIMER_INTERVAL_RADIOCHK	800	/* radio monitor timer, in unit of ms */
 
-#ifndef WLC_MPC_MAX_DELAYCNT
-#define	WLC_MPC_MAX_DELAYCNT	10	/* Max MPC timeout, in unit of watchdog */
+/* Max MPC timeout, in unit of watchdog */
+#ifndef BRCMS_MPC_MAX_DELAYCNT
+#define	BRCMS_MPC_MAX_DELAYCNT	10
 #endif
-#define	WLC_MPC_MIN_DELAYCNT	1	/* Min MPC timeout, in unit of watchdog */
-#define	WLC_MPC_THRESHOLD	3	/* MPC count threshold level */
+
+/* Min MPC timeout, in unit of watchdog */
+#define	BRCMS_MPC_MIN_DELAYCNT	1
+#define	BRCMS_MPC_THRESHOLD	3	/* MPC count threshold level */
 
 #define	BEACON_INTERVAL_DEFAULT	100	/* beacon interval, in unit of 1024TU */
 #define	DTIM_INTERVAL_DEFAULT	3	/* DTIM interval, in unit of beacon interval */
@@ -167,7 +170,7 @@
 /* To inform the ucode of the last mcast frame posted so that it can clear moredata bit */
 #define BCMCFID(wlc, fid) brcms_b_write_shm((wlc)->hw, M_BCMC_FID, (fid))
 
-#define WLC_WAR16165(wlc) (wlc->pub->sih->bustype == PCI_BUS && \
+#define BRCMS_WAR16165(wlc) (wlc->pub->sih->bustype == PCI_BUS && \
 				(!AP_ENAB(wlc->pub)) && (wlc->war16165))
 
 /* debug/trace */
@@ -179,7 +182,7 @@ uint brcm_msg_level =
 #endif				/* BCMDBG */
 
 /* Find basic rate for a given rate */
-#define WLC_BASIC_RATE(wlc, rspec)	(IS_MCS(rspec) ? \
+#define BRCMS_BASIC_RATE(wlc, rspec)	(IS_MCS(rspec) ? \
 			(wlc)->band->basic_rate[mcs_table[rspec & RSPEC_RATE_MASK].leg_ofdm] : \
 			(wlc)->band->basic_rate[rspec & RSPEC_RATE_MASK])
 
@@ -187,7 +190,7 @@ uint brcm_msg_level =
 
 #define RFDISABLE_DEFAULT	10000000	/* rfdisable delay timer 500 ms, runs of ALP clock */
 
-#define WLC_TEMPSENSE_PERIOD		10	/* 10 second timeout */
+#define BRCMS_TEMPSENSE_PERIOD		10	/* 10 second timeout */
 
 #define SCAN_IN_PROGRESS(x)	0
 
@@ -214,22 +217,22 @@ const u8 prio2fifo[NUMPRIO] = {
  * Odd numbers are used for HI priority traffic at same precedence levels
  * These constants are used ONLY by wlc_prio2prec_map.  Do not use them elsewhere.
  */
-#define	_WLC_PREC_NONE		0	/* None = - */
-#define	_WLC_PREC_BK		2	/* BK - Background */
-#define	_WLC_PREC_BE		4	/* BE - Best-effort */
-#define	_WLC_PREC_EE		6	/* EE - Excellent-effort */
-#define	_WLC_PREC_CL		8	/* CL - Controlled Load */
-#define	_WLC_PREC_VI		10	/* Vi - Video */
-#define	_WLC_PREC_VO		12	/* Vo - Voice */
-#define	_WLC_PREC_NC		14	/* NC - Network Control */
+#define	_BRCMS_PREC_NONE		0	/* None = - */
+#define	_BRCMS_PREC_BK		2	/* BK - Background */
+#define	_BRCMS_PREC_BE		4	/* BE - Best-effort */
+#define	_BRCMS_PREC_EE		6	/* EE - Excellent-effort */
+#define	_BRCMS_PREC_CL		8	/* CL - Controlled Load */
+#define	_BRCMS_PREC_VI		10	/* Vi - Video */
+#define	_BRCMS_PREC_VO		12	/* Vo - Voice */
+#define	_BRCMS_PREC_NC		14	/* NC - Network Control */
 
 #define MAXMACLIST		64	/* max # source MAC matches */
 #define BCN_TEMPLATE_COUNT	2
 
-#define WLC_BSSCFG_HW_BCN	0x20	/* The BSS is generating beacons in HW */
+/* The BSS is generating beacons in HW */
+#define BRCMS_BSSCFG_HW_BCN	0x20
 
-#define HWBCN_ENAB(cfg)		(((cfg)->flags & WLC_BSSCFG_HW_BCN) != 0)
-#define HWPRB_ENAB(cfg)		(((cfg)->flags & WLC_BSSCFG_HW_PRB) != 0)
+#define HWBCN_ENAB(cfg)		(((cfg)->flags & BRCMS_BSSCFG_HW_BCN) != 0)
 
 #define MBSS_BCN_ENAB(cfg)       0
 #define MBSS_PRB_ENAB(cfg)       0
@@ -237,14 +240,14 @@ const u8 prio2fifo[NUMPRIO] = {
 
 /* 802.1D Priority to precedence queue mapping */
 const u8 wlc_prio2prec_map[] = {
-	_WLC_PREC_BE,		/* 0 BE - Best-effort */
-	_WLC_PREC_BK,		/* 1 BK - Background */
-	_WLC_PREC_NONE,		/* 2 None = - */
-	_WLC_PREC_EE,		/* 3 EE - Excellent-effort */
-	_WLC_PREC_CL,		/* 4 CL - Controlled Load */
-	_WLC_PREC_VI,		/* 5 Vi - Video */
-	_WLC_PREC_VO,		/* 6 Vo - Voice */
-	_WLC_PREC_NC,		/* 7 NC - Network Control */
+	_BRCMS_PREC_BE,		/* 0 BE - Best-effort */
+	_BRCMS_PREC_BK,		/* 1 BK - Background */
+	_BRCMS_PREC_NONE,		/* 2 None = - */
+	_BRCMS_PREC_EE,		/* 3 EE - Excellent-effort */
+	_BRCMS_PREC_CL,		/* 4 CL - Controlled Load */
+	_BRCMS_PREC_VI,		/* 5 Vi - Video */
+	_BRCMS_PREC_VO,		/* 6 Vo - Voice */
+	_BRCMS_PREC_NC,		/* 7 NC - Network Control */
 };
 
 /* Check if a particular BSS config is AP or STA */
@@ -254,18 +257,9 @@ const u8 wlc_prio2prec_map[] = {
 
 /* As above for all non-NULL BSS configs */
 #define FOREACH_BSS(wlc, idx, cfg) \
-	for (idx = 0; (int) idx < WLC_MAXBSSCFG; idx++) \
+	for (idx = 0; (int) idx < BRCMS_MAXBSSCFG; idx++) \
 		if ((cfg = (wlc)->bsscfg[idx]))
 
-/* Sanity check for tx_prec_map and fifo synchup
- * Either there are some packets pending for the fifo, else if fifo is empty then
- * all the corresponding precmap bits should be set
- */
-#define WLC_TX_FIFO_CHECK(wlc, fifo) (TXPKTPENDGET((wlc), (fifo)) ||	\
-	(TXPKTPENDGET((wlc), (fifo)) == 0 && \
-	((wlc)->tx_prec_map & (wlc)->fifo2prec_map[(fifo)]) == \
-	(wlc)->fifo2prec_map[(fifo)]))
-
 /* TX FIFO number to WME/802.1E Access Category */
 const u8 wme_fifo2ac[] = { AC_BK, AC_BE, AC_VI, AC_VO, AC_BE, AC_BE };
 
@@ -292,10 +286,8 @@ static const u8 acbitmap2maxprio[] = {
 };
 
 /* currently the best mechanism for determining SIFS is the band in use */
-#define SIFS(band) ((band)->bandtype == WLC_BAND_5G ? APHY_SIFS_TIME : BPHY_SIFS_TIME);
-
-/* value for # replay counters currently supported */
-#define WLC_REPLAY_CNTRS_VALUE	WPA_CAP_16_REPLAY_CNTRS
+#define SIFS(band) ((band)->bandtype == BRCM_BAND_5G ? APHY_SIFS_TIME : \
+						       BPHY_SIFS_TIME);
 
 /* local prototypes */
 static u16 brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc,
@@ -390,14 +382,14 @@ bool brcms_c_ps_allowed(struct brcms_c_info *wlc)
 	if (AP_ACTIVE(wlc) || wlc->monitor)
 		return false;
 
-	for (idx = 0; idx < WLC_MAXBSSCFG; idx++) {
+	for (idx = 0; idx < BRCMS_MAXBSSCFG; idx++) {
 		cfg = wlc->bsscfg[idx];
 		if (cfg && BSSCFG_STA(cfg) && cfg->associated) {
 			/*
 			 * disallow PS when one of the following
 			 * bsscfg specific conditions meets
 			 */
-			if (!cfg->BSS || !WLC_PORTOPEN(cfg))
+			if (!cfg->BSS || !BRCMS_PORTOPEN(cfg))
 				return false;
 
 			if (!cfg->dtim_programmed)
@@ -561,13 +553,14 @@ void brcms_c_init(struct brcms_c_info *wlc)
 	W_REG(&wlc->regs->rfdisabledly, RFDISABLE_DEFAULT);
 
 	/* initialize mpc delay */
-	wlc->mpc_delay_off = wlc->mpc_dlycnt = WLC_MPC_MIN_DELAYCNT;
+	wlc->mpc_delay_off = wlc->mpc_dlycnt = BRCMS_MPC_MIN_DELAYCNT;
 
 	/*
 	 * Initialize WME parameters; if they haven't been set by some other
 	 * mechanism (IOVar, etc) then read them from the hardware.
 	 */
-	if (WLC_WME_RETRY_SHORT_GET(wlc, 0) == 0) {	/* Uninitialized; read from HW */
+	if (BRCMS_WME_RETRY_SHORT_GET(wlc, 0) == 0) {
+		/* Uninitialized; read from HW */
 		int ac;
 
 		for (ac = 0; ac < AC_COUNT; ac++) {
@@ -686,8 +679,8 @@ void brcms_c_switch_shortslot(struct brcms_c_info *wlc, bool shortslot)
 	struct brcms_bss_cfg *cfg;
 
 	/* use the override if it is set */
-	if (wlc->shortslot_override != WLC_SHORTSLOT_AUTO)
-		shortslot = (wlc->shortslot_override == WLC_SHORTSLOT_ON);
+	if (wlc->shortslot_override != BRCMS_SHORTSLOT_AUTO)
+		shortslot = (wlc->shortslot_override == BRCMS_SHORTSLOT_ON);
 
 	if (wlc->shortslot == shortslot)
 		return;
@@ -713,7 +706,7 @@ static u8 brcms_c_local_constraint_qdbm(struct brcms_c_info *wlc)
 	u8 local;
 	s16 local_max;
 
-	local = WLC_TXPWR_MAX;
+	local = BRCMS_TXPWR_MAX;
 	if (wlc->pub->associated &&
 	    (brcmu_chspec_ctlchan(wlc->chanspec) ==
 	     brcmu_chspec_ctlchan(wlc->home_chanspec))) {
@@ -721,11 +714,12 @@ static u8 brcms_c_local_constraint_qdbm(struct brcms_c_info *wlc)
 		/* get the local power constraint if we are on the AP's
 		 * channel [802.11h, 7.3.2.13]
 		 */
-		/* Clamp the value between 0 and WLC_TXPWR_MAX w/o overflowing the target */
+		/* Clamp the value between 0 and BRCMS_TXPWR_MAX w/o
+		 * overflowing the target */
 		local_max =
 		    (wlc->txpwr_local_max -
-		     wlc->txpwr_local_constraint) * WLC_TXPWR_DB_FACTOR;
-		if (local_max > 0 && local_max < WLC_TXPWR_MAX)
+		     wlc->txpwr_local_constraint) * BRCMS_TXPWR_DB_FACTOR;
+		if (local_max > 0 && local_max < BRCMS_TXPWR_MAX)
 			return (u8) local_max;
 		if (local_max < 0)
 			return 0;
@@ -787,7 +781,7 @@ void brcms_c_set_chanspec(struct brcms_c_info *wlc, chanspec_t chanspec)
 
 	/* Switch bands if necessary */
 	if (NBANDS(wlc) > 1) {
-		bandunit = CHSPEC_WLCBANDUNIT(chanspec);
+		bandunit = CHSPEC_BANDUNIT(chanspec);
 		if (wlc->band->bandunit != bandunit || wlc->bandinit_pending) {
 			switchband = true;
 			if (wlc->bandlocked) {
@@ -836,10 +830,10 @@ ratespec_t brcms_c_lowest_basic_rspec(struct brcms_c_info *wlc,
 	uint i;
 
 	/* Use the lowest basic rate */
-	lowest_basic_rspec = rs->rates[0] & WLC_RATE_MASK;
+	lowest_basic_rspec = rs->rates[0] & BRCMS_RATE_MASK;
 	for (i = 0; i < rs->count; i++) {
-		if (rs->rates[i] & WLC_RATE_FLAG) {
-			lowest_basic_rspec = rs->rates[i] & WLC_RATE_MASK;
+		if (rs->rates[i] & BRCMS_RATE_FLAG) {
+			lowest_basic_rspec = rs->rates[i] & BRCMS_RATE_MASK;
 			break;
 		}
 	}
@@ -866,9 +860,8 @@ void brcms_c_beacon_phytxctl_txant_upd(struct brcms_c_info *wlc,
 	u16 mask = PHY_TXC_ANT_MASK;
 
 	/* for non-siso rates or default setting, use the available chains */
-	if (WLC_PHY_11N_CAP(wlc->band)) {
+	if (BRCMS_PHY_11N_CAP(wlc->band))
 		phytxant = brcms_c_stf_phytxchain_sel(wlc, bcn_rspec);
-	}
 
 	phyctl = brcms_c_read_shm(wlc, M_BCN_PCTLWD);
 	phyctl = (phyctl & ~mask) | phytxant;
@@ -883,37 +876,37 @@ void brcms_c_protection_upd(struct brcms_c_info *wlc, uint idx, int val)
 	BCMMSG(wlc->wiphy, "idx %d, val %d\n", idx, val);
 
 	switch (idx) {
-	case WLC_PROT_G_SPEC:
+	case BRCMS_PROT_G_SPEC:
 		wlc->protection->_g = (bool) val;
 		break;
-	case WLC_PROT_G_OVR:
+	case BRCMS_PROT_G_OVR:
 		wlc->protection->g_override = (s8) val;
 		break;
-	case WLC_PROT_G_USER:
+	case BRCMS_PROT_G_USER:
 		wlc->protection->gmode_user = (u8) val;
 		break;
-	case WLC_PROT_OVERLAP:
+	case BRCMS_PROT_OVERLAP:
 		wlc->protection->overlap = (s8) val;
 		break;
-	case WLC_PROT_N_USER:
+	case BRCMS_PROT_N_USER:
 		wlc->protection->nmode_user = (s8) val;
 		break;
-	case WLC_PROT_N_CFG:
+	case BRCMS_PROT_N_CFG:
 		wlc->protection->n_cfg = (s8) val;
 		break;
-	case WLC_PROT_N_CFG_OVR:
+	case BRCMS_PROT_N_CFG_OVR:
 		wlc->protection->n_cfg_override = (s8) val;
 		break;
-	case WLC_PROT_N_NONGF:
+	case BRCMS_PROT_N_NONGF:
 		wlc->protection->nongf = (bool) val;
 		break;
-	case WLC_PROT_N_NONGF_OVR:
+	case BRCMS_PROT_N_NONGF_OVR:
 		wlc->protection->nongf_override = (s8) val;
 		break;
-	case WLC_PROT_N_PAM_OVR:
+	case BRCMS_PROT_N_PAM_OVR:
 		wlc->protection->n_pam_override = (s8) val;
 		break;
-	case WLC_PROT_N_OBSS:
+	case BRCMS_PROT_N_OBSS:
 		wlc->protection->n_obss = (bool) val;
 		break;
 
@@ -927,9 +920,9 @@ static void brcms_c_ht_update_sgi_rx(struct brcms_c_info *wlc, int val)
 {
 	wlc->ht_cap.cap_info &= ~(IEEE80211_HT_CAP_SGI_20 |
 					IEEE80211_HT_CAP_SGI_40);
-	wlc->ht_cap.cap_info |= (val & WLC_N_SGI_20) ?
+	wlc->ht_cap.cap_info |= (val & BRCMS_N_SGI_20) ?
 					IEEE80211_HT_CAP_SGI_20 : 0;
-	wlc->ht_cap.cap_info |= (val & WLC_N_SGI_40) ?
+	wlc->ht_cap.cap_info |= (val & BRCMS_N_SGI_40) ?
 					IEEE80211_HT_CAP_SGI_40 : 0;
 
 	if (wlc->pub->up) {
@@ -962,7 +955,7 @@ static void brcms_c_ucode_mac_upd(struct brcms_c_info *wlc)
 	/* enable or disable any active IBSSs depending on whether or not
 	 * we are on the home channel
 	 */
-	if (wlc->home_chanspec == WLC_BAND_PI_RADIO_CHANSPEC) {
+	if (wlc->home_chanspec == BRCMS_BAND_PI_RADIO_CHANSPEC) {
 		if (wlc->pub->associated) {
 			/* BMAC_NOTE: This is something that should be fixed in ucode inits.
 			 * I think that the ucode inits set up the bcn templates and shm values
@@ -970,7 +963,7 @@ static void brcms_c_ucode_mac_upd(struct brcms_c_info *wlc)
 			 * to set up a beacon for testing, the test routines should write it down,
 			 * not expect the inits to populate a bogus beacon.
 			 */
-			if (WLC_PHY_11N_CAP(wlc->band)) {
+			if (BRCMS_PHY_11N_CAP(wlc->band)) {
 				brcms_c_write_shm(wlc, M_BCN_TXTSF_OFFSET,
 					      wlc->band->bcntsfoff);
 			}
@@ -1002,7 +995,7 @@ static void brcms_c_bandinit_ordered(struct brcms_c_info *wlc,
 		band_order[0] = band_order[1] = parkband;
 	} else {
 		/* park on the band of the specified chanspec */
-		parkband = CHSPEC_WLCBANDUNIT(chanspec);
+		parkband = CHSPEC_BANDUNIT(chanspec);
 
 		/* order so that parkband initialize last */
 		band_order[0] = parkband ^ 1;
@@ -1019,7 +1012,7 @@ static void brcms_c_bandinit_ordered(struct brcms_c_info *wlc,
 
 		/* fill in hw_rate */
 		brcms_c_rateset_filter(&default_rateset, &wlc->band->hw_rateset,
-				   false, WLC_RATES_CCK_OFDM, WLC_RATE_MASK,
+				   false, BRCMS_RATES_CCK_OFDM, BRCMS_RATE_MASK,
 				   (bool) N_ENAB(wlc->pub));
 
 		/* init basic rate lookup */
@@ -1060,7 +1053,7 @@ static void WLBANDINITFN(brcms_c_setband) (struct brcms_c_info *wlc,
 		return;
 
 	/* wait for at least one beacon before entering sleeping state */
-	for (idx = 0; idx < WLC_MAXBSSCFG; idx++) {
+	for (idx = 0; idx < BRCMS_MAXBSSCFG; idx++) {
 		cfg = wlc->bsscfg[idx];
 		if (cfg && BSSCFG_STA(cfg) && cfg->associated)
 			cfg->PMawakebcn = true;
@@ -1247,19 +1240,21 @@ void brcms_c_info_init(struct brcms_c_info *wlc, int unit)
 
 	/* various 802.11g modes */
 	wlc->shortslot = false;
-	wlc->shortslot_override = WLC_SHORTSLOT_AUTO;
+	wlc->shortslot_override = BRCMS_SHORTSLOT_AUTO;
 
-	brcms_c_protection_upd(wlc, WLC_PROT_G_OVR, WLC_PROTECTION_AUTO);
-	brcms_c_protection_upd(wlc, WLC_PROT_G_SPEC, false);
+	brcms_c_protection_upd(wlc, BRCMS_PROT_G_OVR, BRCMS_PROTECTION_AUTO);
+	brcms_c_protection_upd(wlc, BRCMS_PROT_G_SPEC, false);
 
-	brcms_c_protection_upd(wlc, WLC_PROT_N_CFG_OVR, WLC_PROTECTION_AUTO);
-	brcms_c_protection_upd(wlc, WLC_PROT_N_CFG, WLC_N_PROTECTION_OFF);
-	brcms_c_protection_upd(wlc, WLC_PROT_N_NONGF_OVR, WLC_PROTECTION_AUTO);
-	brcms_c_protection_upd(wlc, WLC_PROT_N_NONGF, false);
-	brcms_c_protection_upd(wlc, WLC_PROT_N_PAM_OVR, AUTO);
+	brcms_c_protection_upd(wlc, BRCMS_PROT_N_CFG_OVR,
+			       BRCMS_PROTECTION_AUTO);
+	brcms_c_protection_upd(wlc, BRCMS_PROT_N_CFG, BRCMS_N_PROTECTION_OFF);
+	brcms_c_protection_upd(wlc, BRCMS_PROT_N_NONGF_OVR,
+			       BRCMS_PROTECTION_AUTO);
+	brcms_c_protection_upd(wlc, BRCMS_PROT_N_NONGF, false);
+	brcms_c_protection_upd(wlc, BRCMS_PROT_N_PAM_OVR, AUTO);
 
-	brcms_c_protection_upd(wlc, WLC_PROT_OVERLAP,
-			       WLC_PROTECTION_CTL_OVERLAP);
+	brcms_c_protection_upd(wlc, BRCMS_PROT_OVERLAP,
+			       BRCMS_PROTECTION_CTL_OVERLAP);
 
 	/* 802.11g draft 4.0 NonERP elt advertisement */
 	wlc->include_legacy_erp = true;
@@ -1267,7 +1262,7 @@ void brcms_c_info_init(struct brcms_c_info *wlc, int unit)
 	wlc->stf->ant_rx_ovr = ANT_RX_DIV_DEF;
 	wlc->stf->txant = ANT_TX_DEF;
 
-	wlc->prb_resp_timeout = WLC_PRB_RESP_TIMEOUT;
+	wlc->prb_resp_timeout = BRCMS_PRB_RESP_TIMEOUT;
 
 	wlc->usr_fragthresh = DOT11_DEFAULT_FRAG_LEN;
 	for (i = 0; i < NFIFO; i++)
@@ -1303,7 +1298,7 @@ void brcms_c_info_init(struct brcms_c_info *wlc, int unit)
 	wlc->pub->_coex = ON;
 
 	/* initialize mpc delay */
-	wlc->mpc_delay_off = wlc->mpc_dlycnt = WLC_MPC_MIN_DELAYCNT;
+	wlc->mpc_delay_off = wlc->mpc_dlycnt = BRCMS_MPC_MIN_DELAYCNT;
 }
 
 static bool brcms_c_state_bmac_sync(struct brcms_c_info *wlc)
@@ -1314,7 +1309,7 @@ static bool brcms_c_state_bmac_sync(struct brcms_c_info *wlc)
 		return false;
 
 	wlc->machwcap = state_bmac.machwcap;
-	brcms_c_protection_upd(wlc, WLC_PROT_N_PAM_OVR,
+	brcms_c_protection_upd(wlc, BRCMS_PROT_N_PAM_OVR,
 			   (s8) state_bmac.preamble_ovr);
 
 	return true;
@@ -1416,7 +1411,7 @@ void *brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 		goto fail;
 	}
 
-	pub->phy_11ncapable = WLC_PHY_11N_CAP(wlc->band);
+	pub->phy_11ncapable = BRCMS_PHY_11N_CAP(wlc->band);
 
 	/* propagate *vars* from BMAC driver to high driver */
 	brcms_b_copyfrom_vars(wlc->hw, &pub->vars, &wlc->vars_size);
@@ -1431,7 +1426,7 @@ void *brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 	brcms_c_stf_phy_chain_calc(wlc);
 
 	/* txchain 1: txant 0, txchain 2: txant 1 */
-	if (WLCISNPHY(wlc->band) && (wlc->stf->txstreams == 1))
+	if (BRCMS_ISNPHY(wlc->band) && (wlc->stf->txstreams == 1))
 		wlc->stf->txant = wlc->stf->hw_txchain - 1;
 
 	/* push to BMAC driver */
@@ -1468,19 +1463,19 @@ void *brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 		/* init gmode value */
 		if (BAND_2G(wlc->band->bandtype)) {
 			wlc->band->gmode = GMODE_AUTO;
-			brcms_c_protection_upd(wlc, WLC_PROT_G_USER,
+			brcms_c_protection_upd(wlc, BRCMS_PROT_G_USER,
 					   wlc->band->gmode);
 		}
 
 		/* init _n_enab supported mode */
-		if (WLC_PHY_11N_CAP(wlc->band) && CHIP_SUPPORTS_11N(wlc)) {
+		if (BRCMS_PHY_11N_CAP(wlc->band) && CHIP_SUPPORTS_11N(wlc)) {
 			if (n_disabled & WLFEATURE_DISABLE_11N) {
 				pub->_n_enab = OFF;
-				brcms_c_protection_upd(wlc, WLC_PROT_N_USER,
+				brcms_c_protection_upd(wlc, BRCMS_PROT_N_USER,
 						       OFF);
 			} else {
 				pub->_n_enab = SUPPORT_11N;
-				brcms_c_protection_upd(wlc, WLC_PROT_N_USER,
+				brcms_c_protection_upd(wlc, BRCMS_PROT_N_USER,
 						   ((pub->_n_enab ==
 						     SUPPORT_11N) ? WL_11N_2x2 :
 						    WL_11N_3x3));
@@ -1490,10 +1485,10 @@ void *brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 		/* init per-band default rateset, depend on band->gmode */
 		brcms_default_rateset(wlc, &wlc->band->defrateset);
 
-		/* fill in hw_rateset (used early by WLC_SET_RATESET) */
+		/* fill in hw_rateset (used early by BRCM_SET_RATESET) */
 		brcms_c_rateset_filter(&wlc->band->defrateset,
 				   &wlc->band->hw_rateset, false,
-				   WLC_RATES_CCK_OFDM, WLC_RATE_MASK,
+				   BRCMS_RATES_CCK_OFDM, BRCMS_RATE_MASK,
 				   (bool) N_ENAB(wlc->pub));
 	}
 
@@ -1552,14 +1547,16 @@ void *brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 	wlc->mimo_40txbw = AUTO;
 	wlc->ofdm_40txbw = AUTO;
 	wlc->cck_40txbw = AUTO;
-	brcms_c_update_mimo_band_bwcap(wlc, WLC_N_BW_20IN2G_40IN5G);
+	brcms_c_update_mimo_band_bwcap(wlc, BRCMS_N_BW_20IN2G_40IN5G);
 
 	/* Set default values of SGI */
-	if (WLC_SGI_CAP_PHY(wlc)) {
-		brcms_c_ht_update_sgi_rx(wlc, (WLC_N_SGI_20 | WLC_N_SGI_40));
+	if (BRCMS_SGI_CAP_PHY(wlc)) {
+		brcms_c_ht_update_sgi_rx(wlc, (BRCMS_N_SGI_20 |
+					       BRCMS_N_SGI_40));
 		wlc->sgi_tx = AUTO;
-	} else if (WLCISSSLPNPHY(wlc->band)) {
-		brcms_c_ht_update_sgi_rx(wlc, (WLC_N_SGI_20 | WLC_N_SGI_40));
+	} else if (BRCMS_ISSSLPNPHY(wlc->band)) {
+		brcms_c_ht_update_sgi_rx(wlc, (BRCMS_N_SGI_20 |
+					       BRCMS_N_SGI_40));
 		wlc->sgi_tx = AUTO;
 	} else {
 		brcms_c_ht_update_sgi_rx(wlc, 0);
@@ -1752,9 +1749,11 @@ uint brcms_c_detach(struct brcms_c_info *wlc)
 void brcms_c_ap_upd(struct brcms_c_info *wlc)
 {
 	if (AP_ENAB(wlc->pub))
-		wlc->PLCPHdr_override = WLC_PLCP_AUTO;	/* AP: short not allowed, but not enforced */
+		/* AP: short not allowed, but not enforced */
+		wlc->PLCPHdr_override = BRCMS_PLCP_AUTO;
 	else
-		wlc->PLCPHdr_override = WLC_PLCP_SHORT;	/* STA-BSS; short capable */
+		/* STA-BSS; short capable */
+		wlc->PLCPHdr_override = BRCMS_PLCP_SHORT;
 
 	/* fixup mpc */
 	wlc->mpc = true;
@@ -1819,10 +1818,10 @@ void brcms_c_radio_mpc_upd(struct brcms_c_info *wlc)
 	else if (radio_state == OFF && mpc_radio == ON) {
 		mboolclr(wlc->pub->radio_disabled, WL_RADIO_MPC_DISABLE);
 		brcms_c_radio_upd(wlc);
-		if (wlc->mpc_offcnt < WLC_MPC_THRESHOLD) {
-			wlc->mpc_dlycnt = WLC_MPC_MAX_DELAYCNT;
-		} else
-			wlc->mpc_dlycnt = WLC_MPC_MIN_DELAYCNT;
+		if (wlc->mpc_offcnt < BRCMS_MPC_THRESHOLD)
+			wlc->mpc_dlycnt = BRCMS_MPC_MAX_DELAYCNT;
+		else
+			wlc->mpc_dlycnt = BRCMS_MPC_MIN_DELAYCNT;
 		wlc->mpc_dur += OSL_SYSUPTIME() - wlc->mpc_laston_ts;
 	}
 	/* Below logic is meant to capture the transition from mpc off to mpc on for reasons
@@ -1855,9 +1854,9 @@ static void brcms_c_down_led_upd(struct brcms_c_info *wlc)
 	/* maintain LEDs while in down state, turn on sbclk if not available yet */
 	/* turn on sbclk if necessary */
 	if (!AP_ENAB(wlc->pub)) {
-		brcms_c_pllreq(wlc, true, WLC_PLLREQ_FLIP);
+		brcms_c_pllreq(wlc, true, BRCMS_PLLREQ_FLIP);
 
-		brcms_c_pllreq(wlc, false, WLC_PLLREQ_FLIP);
+		brcms_c_pllreq(wlc, false, BRCMS_PLLREQ_FLIP);
 	}
 }
 
@@ -1904,7 +1903,7 @@ static void brcms_c_radio_timer(void *arg)
 	}
 
 	/* cap mpc off count */
-	if (wlc->mpc_offcnt < WLC_MPC_MAX_DELAYCNT)
+	if (wlc->mpc_offcnt < BRCMS_MPC_MAX_DELAYCNT)
 		wlc->mpc_offcnt++;
 
 	brcms_c_radio_hwdisable_upd(wlc);
@@ -1918,7 +1917,7 @@ static bool brcms_c_radio_monitor_start(struct brcms_c_info *wlc)
 		return true;
 
 	wlc->radio_monitor = true;
-	brcms_c_pllreq(wlc, true, WLC_PLLREQ_RADIO_MON);
+	brcms_c_pllreq(wlc, true, BRCMS_PLLREQ_RADIO_MON);
 	brcms_add_timer(wlc->wl, wlc->radio_timer, TIMER_INTERVAL_RADIOCHK,
 			true);
 	return true;
@@ -1930,7 +1929,7 @@ bool brcms_c_radio_monitor_stop(struct brcms_c_info *wlc)
 		return true;
 
 	wlc->radio_monitor = false;
-	brcms_c_pllreq(wlc, false, WLC_PLLREQ_RADIO_MON);
+	brcms_c_pllreq(wlc, false, BRCMS_PLLREQ_RADIO_MON);
 	return brcms_del_timer(wlc->wl, wlc->radio_timer);
 }
 
@@ -1998,14 +1997,14 @@ static void brcms_c_watchdog(void *arg)
 	}
 
 	/* Call any registered watchdog handlers */
-	for (i = 0; i < WLC_MAXMODULES; i++) {
+	for (i = 0; i < BRCMS_MAXMODULES; i++) {
 		if (wlc->modulecb[i].watchdog_fn)
 			wlc->modulecb[i].watchdog_fn(wlc->modulecb[i].hdl);
 	}
 
-	if (WLCISNPHY(wlc->band) && !wlc->pub->tempsense_disable &&
+	if (BRCMS_ISNPHY(wlc->band) && !wlc->pub->tempsense_disable &&
 	    ((wlc->pub->now - wlc->tempsense_lasttime) >=
-	     WLC_TEMPSENSE_PERIOD)) {
+	     BRCMS_TEMPSENSE_PERIOD)) {
 		wlc->tempsense_lasttime = wlc->pub->now;
 		brcms_c_tempsense_upd(wlc);
 	}
@@ -2030,10 +2029,10 @@ int brcms_c_up(struct brcms_c_info *wlc)
 		if (wlc->pub->boardrev >= 0x1250
 		    && (wlc->pub->boardflags & BFL_FEM_BT)) {
 			brcms_c_mhf(wlc, MHF5, MHF5_4313_GPIOCTRL,
-				MHF5_4313_GPIOCTRL, WLC_BAND_ALL);
+				MHF5_4313_GPIOCTRL, BRCM_BAND_ALL);
 		} else {
 			brcms_c_mhf(wlc, MHF4, MHF4_EXTPA_ENABLE,
-				    MHF4_EXTPA_ENABLE, WLC_BAND_ALL);
+				    MHF4_EXTPA_ENABLE, BRCM_BAND_ALL);
 		}
 	}
 
@@ -2080,14 +2079,14 @@ int brcms_c_up(struct brcms_c_info *wlc)
 
 	/* Set EDCF hostflags */
 	if (EDCF_ENAB(wlc->pub)) {
-		brcms_c_mhf(wlc, MHF1, MHF1_EDCF, MHF1_EDCF, WLC_BAND_ALL);
+		brcms_c_mhf(wlc, MHF1, MHF1_EDCF, MHF1_EDCF, BRCM_BAND_ALL);
 	} else {
-		brcms_c_mhf(wlc, MHF1, MHF1_EDCF, 0, WLC_BAND_ALL);
+		brcms_c_mhf(wlc, MHF1, MHF1_EDCF, 0, BRCM_BAND_ALL);
 	}
 
-	if (WLC_WAR16165(wlc))
+	if (BRCMS_WAR16165(wlc))
 		brcms_c_mhf(wlc, MHF2, MHF2_PCISLOWCLKWAR, MHF2_PCISLOWCLKWAR,
-			WLC_BAND_ALL);
+			BRCM_BAND_ALL);
 
 	brcms_init(wlc->wl);
 	wlc->pub->up = true;
@@ -2123,20 +2122,20 @@ int brcms_c_up(struct brcms_c_info *wlc)
 /* Initialize the base precedence map for dequeueing from txq based on WME settings */
 static void brcms_c_tx_prec_map_init(struct brcms_c_info *wlc)
 {
-	wlc->tx_prec_map = WLC_PREC_BMP_ALL;
+	wlc->tx_prec_map = BRCMS_PREC_BMP_ALL;
 	memset(wlc->fifo2prec_map, 0, NFIFO * sizeof(u16));
 
 	/* For non-WME, both fifos have overlapping MAXPRIO. So just disable all precedences
 	 * if either is full.
 	 */
 	if (!EDCF_ENAB(wlc->pub)) {
-		wlc->fifo2prec_map[TX_DATA_FIFO] = WLC_PREC_BMP_ALL;
-		wlc->fifo2prec_map[TX_CTL_FIFO] = WLC_PREC_BMP_ALL;
+		wlc->fifo2prec_map[TX_DATA_FIFO] = BRCMS_PREC_BMP_ALL;
+		wlc->fifo2prec_map[TX_CTL_FIFO] = BRCMS_PREC_BMP_ALL;
 	} else {
-		wlc->fifo2prec_map[TX_AC_BK_FIFO] = WLC_PREC_BMP_AC_BK;
-		wlc->fifo2prec_map[TX_AC_BE_FIFO] = WLC_PREC_BMP_AC_BE;
-		wlc->fifo2prec_map[TX_AC_VI_FIFO] = WLC_PREC_BMP_AC_VI;
-		wlc->fifo2prec_map[TX_AC_VO_FIFO] = WLC_PREC_BMP_AC_VO;
+		wlc->fifo2prec_map[TX_AC_BK_FIFO] = BRCMS_PREC_BMP_AC_BK;
+		wlc->fifo2prec_map[TX_AC_BE_FIFO] = BRCMS_PREC_BMP_AC_BE;
+		wlc->fifo2prec_map[TX_AC_VI_FIFO] = BRCMS_PREC_BMP_AC_VI;
+		wlc->fifo2prec_map[TX_AC_VO_FIFO] = BRCMS_PREC_BMP_AC_VO;
 	}
 }
 
@@ -2179,7 +2178,7 @@ uint brcms_c_down(struct brcms_c_info *wlc)
 	dev_gone = DEVICEREMOVED(wlc);
 
 	/* Call any registered down handlers */
-	for (i = 0; i < WLC_MAXMODULES; i++) {
+	for (i = 0; i < BRCMS_MAXMODULES; i++) {
 		if (wlc->modulecb[i].down_fn)
 			callbacks +=
 			    wlc->modulecb[i].down_fn(wlc->modulecb[i].hdl);
@@ -2222,11 +2221,13 @@ int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config)
 	uint i;
 	wlc_rateset_t rs;
 	/* Default to 54g Auto */
-	s8 shortslot = WLC_SHORTSLOT_AUTO;	/* Advertise and use shortslot (-1/0/1 Auto/Off/On) */
+	/* Advertise and use shortslot (-1/0/1 Auto/Off/On) */
+	s8 shortslot = BRCMS_SHORTSLOT_AUTO;
 	bool shortslot_restrict = false;	/* Restrict association to stations that support shortslot
 						 */
 	bool ofdm_basic = false;	/* Make 6, 12, and 24 basic rates */
-	int preamble = WLC_PLCP_LONG;	/* Advertise and use short preambles (-1/0/1 Auto/Off/On) */
+	/* Advertise and use short preambles (-1/0/1 Auto/Off/On) */
+	int preamble = BRCMS_PLCP_LONG;
 	bool preamble_restrict = false;	/* Restrict association to stations that support short
 					 * preambles
 					 */
@@ -2239,22 +2240,22 @@ int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config)
 		return -ENOTSUPP;
 
 	/* verify that we are dealing with 2G band and grab the band pointer */
-	if (wlc->band->bandtype == WLC_BAND_2G)
+	if (wlc->band->bandtype == BRCM_BAND_2G)
 		band = wlc->band;
 	else if ((NBANDS(wlc) > 1) &&
-		 (wlc->bandstate[OTHERBANDUNIT(wlc)]->bandtype == WLC_BAND_2G))
+		 (wlc->bandstate[OTHERBANDUNIT(wlc)]->bandtype == BRCM_BAND_2G))
 		band = wlc->bandstate[OTHERBANDUNIT(wlc)];
 	else
 		return -EINVAL;
 
 	/* Legacy or bust when no OFDM is supported by regulatory */
 	if ((brcms_c_channel_locale_flags_in_band(wlc->cmi, band->bandunit) &
-	     WLC_NO_OFDM) && (gmode != GMODE_LEGACY_B))
+	     BRCMS_NO_OFDM) && (gmode != GMODE_LEGACY_B))
 		return -EINVAL;
 
 	/* update configuration value */
 	if (config == true)
-		brcms_c_protection_upd(wlc, WLC_PROT_G_USER, gmode);
+		brcms_c_protection_upd(wlc, BRCMS_PROT_G_USER, gmode);
 
 	/* Clear supported rates filter */
 	memset(&wlc->sup_rates_override, 0, sizeof(wlc_rateset_t));
@@ -2264,7 +2265,7 @@ int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config)
 
 	switch (gmode) {
 	case GMODE_LEGACY_B:
-		shortslot = WLC_SHORTSLOT_OFF;
+		shortslot = BRCMS_SHORTSLOT_OFF;
 		brcms_c_rateset_copy(&gphy_legacy_rates, &rs);
 
 		break;
@@ -2281,7 +2282,7 @@ int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config)
 
 	case GMODE_ONLY:
 		ofdm_basic = true;
-		preamble = WLC_PLCP_SHORT;
+		preamble = BRCMS_PLCP_SHORT;
 		preamble_restrict = true;
 		break;
 
@@ -2290,10 +2291,10 @@ int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config)
 			brcms_c_rateset_copy(&cck_ofdm_rates,
 					 &wlc->sup_rates_override);
 
-		shortslot = WLC_SHORTSLOT_ON;
+		shortslot = BRCMS_SHORTSLOT_ON;
 		shortslot_restrict = true;
 		ofdm_basic = true;
-		preamble = WLC_PLCP_SHORT;
+		preamble = BRCMS_PLCP_SHORT;
 		preamble_restrict = true;
 		break;
 
@@ -2327,18 +2328,18 @@ int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config)
 		/* wlc->ap->shortslot_restrict = shortslot_restrict; */
 		wlc->PLCPHdr_override =
 		    (preamble !=
-		     WLC_PLCP_LONG) ? WLC_PLCP_SHORT : WLC_PLCP_AUTO;
+		     BRCMS_PLCP_LONG) ? BRCMS_PLCP_SHORT : BRCMS_PLCP_AUTO;
 	}
 
-	if ((AP_ENAB(wlc->pub) && preamble != WLC_PLCP_LONG)
-	    || preamble == WLC_PLCP_SHORT)
+	if ((AP_ENAB(wlc->pub) && preamble != BRCMS_PLCP_LONG)
+	    || preamble == BRCMS_PLCP_SHORT)
 		wlc->default_bss->capability |= WLAN_CAPABILITY_SHORT_PREAMBLE;
 	else
 		wlc->default_bss->capability &= ~WLAN_CAPABILITY_SHORT_PREAMBLE;
 
 	/* Update shortslot capability bit for AP and IBSS */
-	if ((AP_ENAB(wlc->pub) && shortslot == WLC_SHORTSLOT_AUTO) ||
-	    shortslot == WLC_SHORTSLOT_ON)
+	if ((AP_ENAB(wlc->pub) && shortslot == BRCMS_SHORTSLOT_AUTO) ||
+	    shortslot == BRCMS_SHORTSLOT_ON)
 		wlc->default_bss->capability |= WLAN_CAPABILITY_SHORT_SLOT_TIME;
 	else
 		wlc->default_bss->capability &=
@@ -2350,10 +2351,10 @@ int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config)
 
 	if (ofdm_basic) {
 		for (i = 0; i < rs.count; i++) {
-			if (rs.rates[i] == WLC_RATE_6M
-			    || rs.rates[i] == WLC_RATE_12M
-			    || rs.rates[i] == WLC_RATE_24M)
-				rs.rates[i] |= WLC_RATE_FLAG;
+			if (rs.rates[i] == BRCM_RATE_6M
+			    || rs.rates[i] == BRCM_RATE_12M
+			    || rs.rates[i] == BRCM_RATE_24M)
+				rs.rates[i] |= BRCMS_RATE_FLAG;
 		}
 	}
 
@@ -2377,7 +2378,7 @@ static int brcms_c_nmode_validate(struct brcms_c_info *wlc, s32 nmode)
 	case AUTO:
 	case WL_11N_2x2:
 	case WL_11N_3x3:
-		if (!(WLC_PHY_11N_CAP(wlc->band)))
+		if (!(BRCMS_PHY_11N_CAP(wlc->band)))
 			err = -EINVAL;
 		break;
 
@@ -2401,7 +2402,7 @@ int brcms_c_set_nmode(struct brcms_c_info *wlc, s32 nmode)
 	switch (nmode) {
 	case OFF:
 		wlc->pub->_n_enab = OFF;
-		wlc->default_bss->flags &= ~WLC_BSS_HT;
+		wlc->default_bss->flags &= ~BRCMS_BSS_HT;
 		/* delete the mcs rates from the default and hw ratesets */
 		brcms_c_rateset_mcs_clear(&wlc->default_bss->rateset);
 		for (i = 0; i < NBANDS(wlc); i++) {
@@ -2429,7 +2430,7 @@ int brcms_c_set_nmode(struct brcms_c_info *wlc, s32 nmode)
 			wlc->pub->_n_enab = SUPPORT_HT;
 		else
 			wlc->pub->_n_enab = SUPPORT_11N;
-		wlc->default_bss->flags |= WLC_BSS_HT;
+		wlc->default_bss->flags |= BRCMS_BSS_HT;
 		/* add the mcs rates to the default and hw ratesets */
 		brcms_c_rateset_mcs_build(&wlc->default_bss->rateset,
 				      wlc->stf->txstreams);
@@ -2453,7 +2454,7 @@ static int brcms_c_set_rateset(struct brcms_c_info *wlc, wlc_rateset_t *rs_arg)
 	memcpy(&rs, rs_arg, sizeof(wlc_rateset_t));
 
 	/* check for bad count value */
-	if ((rs.count == 0) || (rs.count > WLC_NUMRATES))
+	if ((rs.count == 0) || (rs.count > BRCMS_NUMRATES))
 		return -EINVAL;
 
 	/* try the current band */
@@ -2573,7 +2574,7 @@ _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 
 	switch (cmd) {
 
-	case WLC_SET_CHANNEL:{
+	case BRCM_SET_CHANNEL:{
 			chanspec_t chspec = CH20MHZ_CHSPEC(val);
 
 			if (val < 0 || val > MAXCHANNEL) {
@@ -2588,7 +2589,7 @@ _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 
 			if (!wlc->pub->up && IS_MBAND_UNLOCKED(wlc)) {
 				if (wlc->band->bandunit !=
-				    CHSPEC_WLCBANDUNIT(chspec))
+				    CHSPEC_BANDUNIT(chspec))
 					wlc->bandinit_pending = true;
 				else
 					wlc->bandinit_pending = false;
@@ -2598,7 +2599,7 @@ _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 			/* brcms_c_BSSinit() will sanitize the rateset before
 			 * using it.. */
 			if (wlc->pub->up &&
-			    (WLC_BAND_PI_RADIO_CHANSPEC != chspec)) {
+			    (BRCMS_BAND_PI_RADIO_CHANSPEC != chspec)) {
 				brcms_c_set_home_chanspec(wlc, chspec);
 				brcms_c_suspend_mac_and_wait(wlc);
 				brcms_c_set_chanspec(wlc, chspec);
@@ -2607,7 +2608,7 @@ _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 			break;
 		}
 
-	case WLC_SET_SRL:
+	case BRCM_SET_SRL:
 		if (val >= 1 && val <= RETRY_SHORT_MAX) {
 			int ac;
 			wlc->SRL = (u16) val;
@@ -2615,14 +2616,14 @@ _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 			brcms_b_retrylimit_upd(wlc->hw, wlc->SRL, wlc->LRL);
 
 			for (ac = 0; ac < AC_COUNT; ac++) {
-				WLC_WME_RETRY_SHORT_SET(wlc, ac, wlc->SRL);
+				BRCMS_WME_RETRY_SHORT_SET(wlc, ac, wlc->SRL);
 			}
 			brcms_c_wme_retries_write(wlc);
 		} else
 			bcmerror = -EINVAL;
 		break;
 
-	case WLC_SET_LRL:
+	case BRCM_SET_LRL:
 		if (val >= 1 && val <= 255) {
 			int ac;
 			wlc->LRL = (u16) val;
@@ -2630,14 +2631,14 @@ _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 			brcms_b_retrylimit_upd(wlc->hw, wlc->SRL, wlc->LRL);
 
 			for (ac = 0; ac < AC_COUNT; ac++) {
-				WLC_WME_RETRY_LONG_SET(wlc, ac, wlc->LRL);
+				BRCMS_WME_RETRY_LONG_SET(wlc, ac, wlc->LRL);
 			}
 			brcms_c_wme_retries_write(wlc);
 		} else
 			bcmerror = -EINVAL;
 		break;
 
-	case WLC_GET_CURR_RATESET:{
+	case BRCM_GET_CURR_RATESET:{
 			wl_rateset_t *ret_rs = (wl_rateset_t *) arg;
 			wlc_rateset_t *rs;
 
@@ -2657,7 +2658,7 @@ _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 			break;
 		}
 
-	case WLC_SET_RATESET:{
+	case BRCM_SET_RATESET:{
 			wlc_rateset_t rs;
 			wl_rateset_t *in_rs = (wl_rateset_t *) arg;
 
@@ -2666,7 +2667,7 @@ _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 				break;
 			}
 
-			if (in_rs->count > WLC_NUMRATES) {
+			if (in_rs->count > BRCMS_NUMRATES) {
 				bcmerror = -ENOBUFS;
 				break;
 			}
@@ -2697,16 +2698,16 @@ _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 			break;
 		}
 
-	case WLC_SET_BCNPRD:
+	case BRCM_SET_BCNPRD:
 		/* range [1, 0xffff] */
 		if (val >= DOT11_MIN_BEACON_PERIOD
-		    && val <= DOT11_MAX_BEACON_PERIOD) {
+		    && val <= DOT11_MAX_BEACON_PERIOD)
 			wlc->default_bss->beacon_period = (u16) val;
-		} else
+		else
 			bcmerror = -EINVAL;
 		break;
 
-	case WLC_GET_PHYLIST:
+	case BRCM_GET_PHYLIST:
 		{
 			unsigned char *cp = arg;
 			if (len < 3) {
@@ -2714,20 +2715,19 @@ _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 				break;
 			}
 
-			if (WLCISNPHY(wlc->band)) {
+			if (BRCMS_ISNPHY(wlc->band))
 				*cp++ = 'n';
-			} else if (WLCISLCNPHY(wlc->band)) {
+			else if (BRCMS_ISLCNPHY(wlc->band))
 				*cp++ = 'c';
-			} else if (WLCISSSLPNPHY(wlc->band)) {
+			else if (BRCMS_ISSSLPNPHY(wlc->band))
 				*cp++ = 's';
-			}
 			*cp = '\0';
 			break;
 		}
 
-	case WLC_SET_SHORTSLOT_OVERRIDE:
-		if ((val != WLC_SHORTSLOT_AUTO) &&
-		    (val != WLC_SHORTSLOT_OFF) && (val != WLC_SHORTSLOT_ON)) {
+	case BRCMS_SET_SHORTSLOT_OVERRIDE:
+		if (val != BRCMS_SHORTSLOT_AUTO && val != BRCMS_SHORTSLOT_OFF &&
+		    val != BRCMS_SHORTSLOT_ON) {
 			bcmerror = -EINVAL;
 			break;
 		}
@@ -2748,12 +2748,12 @@ _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 		} else {
 			/* driver is down, so just update the brcms_c_info
 			 * value */
-			if (wlc->shortslot_override == WLC_SHORTSLOT_AUTO) {
+			if (wlc->shortslot_override == BRCMS_SHORTSLOT_AUTO) {
 				wlc->shortslot = false;
 			} else {
 				wlc->shortslot =
 				    (wlc->shortslot_override ==
-				     WLC_SHORTSLOT_ON);
+				     BRCMS_SHORTSLOT_ON);
 			}
 		}
 
@@ -2779,7 +2779,7 @@ int brcms_c_module_register(struct brcms_pub *pub,
 	int i;
 
 	/* find an empty entry and just add, no duplication check! */
-	for (i = 0; i < WLC_MAXMODULES; i++) {
+	for (i = 0; i < BRCMS_MAXMODULES; i++) {
 		if (wlc->modulecb[i].name[0] == '\0') {
 			strncpy(wlc->modulecb[i].name, name,
 				sizeof(wlc->modulecb[i].name) - 1);
@@ -2803,7 +2803,7 @@ brcms_c_module_unregister(struct brcms_pub *pub, const char *name, void *hdl)
 	if (wlc == NULL)
 		return -ENODATA;
 
-	for (i = 0; i < WLC_MAXMODULES; i++) {
+	for (i = 0; i < BRCMS_MAXMODULES; i++) {
 		if (!strcmp(wlc->modulecb[i].name, name) &&
 		    (wlc->modulecb[i].hdl == hdl)) {
 			memset(&wlc->modulecb[i], 0, sizeof(struct modulecb));
@@ -3210,7 +3210,7 @@ brcms_c_sendpkt_mac80211(struct brcms_c_info *wlc, struct sk_buff *sdu,
 	    (brcms_c_d11hdrs_mac80211(
 		wlc, hw, pkt, scb, 0, 1, fifo, 0, NULL, 0)))
 		return -EINVAL;
-	brcms_c_txq_enq(wlc, scb, pkt, WLC_PRIO_TO_PREC(prio));
+	brcms_c_txq_enq(wlc, scb, pkt, BRCMS_PRIO_TO_PREC(prio));
 	brcms_c_send_q(wlc);
 	return 0;
 }
@@ -3320,7 +3320,7 @@ brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo, struct sk_buff *p,
 
 	}
 
-	if (WLC_WAR16165(wlc))
+	if (BRCMS_WAR16165(wlc))
 		brcms_c_war16165(wlc, true);
 
 
@@ -3363,7 +3363,7 @@ static void brcms_c_compute_mimo_plcp(ratespec_t rspec, uint length, u8 *plcp)
 	plcp[0] = mcs;
 	if (RSPEC_IS40MHZ(rspec) || (mcs == 32))
 		plcp[0] |= MIMO_PLCP_40MHZ;
-	WLC_SET_MIMO_PLCP_LEN(plcp, length);
+	BRCMS_SET_MIMO_PLCP_LEN(plcp, length);
 	plcp[3] = RSPEC_MIMOPLCP3(rspec);	/* rspec already holds this byte */
 	plcp[3] |= 0x7;		/* set smoothing, not sounding ppdu & reserved */
 	plcp[4] = 0;		/* number of extension spatial streams bit 0 & 1 */
@@ -3379,7 +3379,7 @@ brcms_c_compute_ofdm_plcp(ratespec_t rspec, u32 length, u8 *plcp)
 	int rate = RSPEC2RATE(rspec);
 
 	/* encode rate per 802.11a-1999 sec 17.3.4.1, with lsb transmitted first */
-	rate_signal = rate_info[rate] & WLC_RATE_MASK;
+	rate_signal = rate_info[rate] & BRCMS_RATE_MASK;
 	memset(plcp, 0, D11_PHY_HDR_LEN);
 	D11A_PHY_HDR_SRATE((struct ofdm_phy_hdr *) plcp, rate_signal);
 
@@ -3405,18 +3405,18 @@ static void brcms_c_cck_plcp_set(struct brcms_c_info *wlc, int rate_500,
 	u8 le = 0;
 
 	switch (rate_500) {
-	case WLC_RATE_1M:
+	case BRCM_RATE_1M:
 		usec = length << 3;
 		break;
-	case WLC_RATE_2M:
+	case BRCM_RATE_2M:
 		usec = length << 2;
 		break;
-	case WLC_RATE_5M5:
+	case BRCM_RATE_5M5:
 		usec = (length << 4) / 11;
 		if ((length << 4) - (usec * 11) > 0)
 			usec++;
 		break;
-	case WLC_RATE_11M:
+	case BRCM_RATE_11M:
 		usec = (length << 3) / 11;
 		if ((length << 3) - (usec * 11) > 0) {
 			usec++;
@@ -3428,7 +3428,7 @@ static void brcms_c_cck_plcp_set(struct brcms_c_info *wlc, int rate_500,
 	default:
 		wiphy_err(wlc->wiphy, "brcms_c_cck_plcp_set: unsupported rate %d"
 			  "\n", rate_500);
-		rate_500 = WLC_RATE_1M;
+		rate_500 = BRCM_RATE_1M;
 		usec = length << 3;
 		break;
 	}
@@ -3522,7 +3522,7 @@ brcms_c_compute_rtscts_dur(struct brcms_c_info *wlc, bool cts_only,
 	if (ba)
 		dur +=
 		    (u16) brcms_c_calc_ba_time(wlc, frame_rate,
-					      WLC_SHORT_PREAMBLE);
+					      BRCMS_SHORT_PREAMBLE);
 	else
 		dur +=
 		    (u16) brcms_c_calc_ack_time(wlc, frame_rate,
@@ -3535,7 +3535,7 @@ u16 brcms_c_phytxctl1_calc(struct brcms_c_info *wlc, ratespec_t rspec)
 	u16 phyctl1 = 0;
 	u16 bw;
 
-	if (WLCISLCNPHY(wlc->band)) {
+	if (BRCMS_ISLCNPHY(wlc->band)) {
 		bw = PHY_TXC1_BW_20MHZ;
 	} else {
 		bw = RSPEC_GET_BW(rspec);
@@ -3554,8 +3554,8 @@ u16 brcms_c_phytxctl1_calc(struct brcms_c_info *wlc, ratespec_t rspec)
 		phyctl1 = RSPEC_PHYTXBYTE2(rspec);
 		/* set the upper byte of phyctl1 */
 		phyctl1 |= (mcs_table[mcs].tx_phy_ctl3 << 8);
-	} else if (IS_CCK(rspec) && !WLCISLCNPHY(wlc->band)
-		   && !WLCISSSLPNPHY(wlc->band)) {
+	} else if (IS_CCK(rspec) && !BRCMS_ISLCNPHY(wlc->band)
+		   && !BRCMS_ISSSLPNPHY(wlc->band)) {
 		/* In CCK mode LPPHY overloads OFDM Modulation bits with CCK Data Rate */
 		/* Eventually MIMOPHY would also be converted to this format */
 		/* 0 = 1Mbps; 1 = 2Mbps; 2 = 5.5Mbps; 3 = 11Mbps */
@@ -3589,21 +3589,21 @@ brcms_c_rspec_to_rts_rspec(struct brcms_c_info *wlc, ratespec_t rspec,
 
 	} else if (wlc->band->gmode && wlc->protection->_g && !IS_CCK(rspec)) {
 		/* Use 11Mbps as the g protection RTS target rate and fallback.
-		 * Use the WLC_BASIC_RATE() lookup to find the best basic rate under the
-		 * target in case 11 Mbps is not Basic.
+		 * Use the BRCMS_BASIC_RATE() lookup to find the best basic rate
+		 * under the target in case 11 Mbps is not Basic.
 		 * 6 and 9 Mbps are not usually selected by rate selection, but even
 		 * if the OFDM rate we are protecting is 6 or 9 Mbps, 11 is more robust.
 		 */
-		rts_rspec = WLC_BASIC_RATE(wlc, WLC_RATE_11M);
+		rts_rspec = BRCMS_BASIC_RATE(wlc, BRCM_RATE_11M);
 	} else {
 		/* calculate RTS rate and fallback rate based on the frame rate
 		 * RTS must be sent at a basic rate since it is a
 		 * control frame, sec 9.6 of 802.11 spec
 		 */
-		rts_rspec = WLC_BASIC_RATE(wlc, rspec);
+		rts_rspec = BRCMS_BASIC_RATE(wlc, rspec);
 	}
 
-	if (WLC_PHY_11N_CAP(wlc->band)) {
+	if (BRCMS_PHY_11N_CAP(wlc->band)) {
 		/* set rts txbw to correct side band */
 		rts_rspec &= ~RSPEC_BW_MASK;
 
@@ -3645,14 +3645,14 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	int len, phylen, rts_phylen;
 	u16 mch, phyctl, xfts, mainrates;
 	u16 seq = 0, mcl = 0, status = 0, frameid = 0;
-	ratespec_t rspec[2] = { WLC_RATE_1M, WLC_RATE_1M }, rts_rspec[2] = {
-	WLC_RATE_1M, WLC_RATE_1M};
+	ratespec_t rspec[2] = { BRCM_RATE_1M, BRCM_RATE_1M }, rts_rspec[2] = {
+	BRCM_RATE_1M, BRCM_RATE_1M};
 	bool use_rts = false;
 	bool use_cts = false;
 	bool use_rifs = false;
 	bool short_preamble[2] = { false, false };
-	u8 preamble_type[2] = { WLC_LONG_PREAMBLE, WLC_LONG_PREAMBLE };
-	u8 rts_preamble_type[2] = { WLC_LONG_PREAMBLE, WLC_LONG_PREAMBLE };
+	u8 preamble_type[2] = { BRCMS_LONG_PREAMBLE, BRCMS_LONG_PREAMBLE };
+	u8 rts_preamble_type[2] = { BRCMS_LONG_PREAMBLE, BRCMS_LONG_PREAMBLE };
 	u8 *rts_plcp, rts_plcp_fallback[D11_PHY_HDR_LEN];
 	struct ieee80211_rts *rts = NULL;
 	bool qos;
@@ -3704,7 +3704,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 		/* non-AP STA should never use BCMC queue */
 		if (queue == TX_BCMC_FIFO) {
 			wiphy_err(wlc->wiphy, "wl%d: %s: ASSERT queue == "
-				  "TX_BCMC!\n", WLCWLUNIT(wlc), __func__);
+				  "TX_BCMC!\n", BRCMS_UNIT(wlc), __func__);
 			frameid = bcmc_fid_generate(wlc, NULL, txh);
 		} else {
 			/* Increment the counter for first fragment */
@@ -3750,7 +3750,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 				    flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE ?
 				    true : false;
 			} else {
-				rate_val[k] = WLC_RATE_1M;
+				rate_val[k] = BRCM_RATE_1M;
 			}
 		} else {
 			rate_val[k] = txrate[k]->idx;
@@ -3772,7 +3772,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 
 		/* (1) RATE: determine and validate primary rate and fallback rates */
 		if (!RSPEC_ACTIVE(rspec[k])) {
-			rspec[k] = WLC_RATE_1M;
+			rspec[k] = BRCM_RATE_1M;
 		} else {
 			if (!is_multicast_ether_addr(h->addr1)) {
 				/* set tx antenna config */
@@ -3796,7 +3796,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 
 				/* For SISO MCS use STBC if possible */
 				if (IS_MCS(rspec[k])
-				    && WLC_STF_SS_STBC_TX(wlc, scb)) {
+				    && BRCMS_STF_SS_STBC_TX(wlc, scb)) {
 					u8 stc;
 
 					stc = 1;	/* Nss for single stream is always 1 */
@@ -3810,11 +3810,11 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 			}
 
 			/* Is the phy configured to use 40MHZ frames? If so then pick the desired txbw */
-			if (CHSPEC_WLC_BW(wlc->chanspec) == WLC_40_MHZ) {
+			if (CHSPEC_WLC_BW(wlc->chanspec) == BRCMS_40_MHZ) {
 				/* default txbw is 20in40 SB */
 				mimo_ctlchbw = mimo_txbw =
-				    CHSPEC_SB_UPPER(WLC_BAND_PI_RADIO_CHANSPEC)
-				    ? PHY_TXC1_BW_20MHZ_UP : PHY_TXC1_BW_20MHZ;
+				   CHSPEC_SB_UPPER(BRCMS_BAND_PI_RADIO_CHANSPEC)
+				   ? PHY_TXC1_BW_20MHZ_UP : PHY_TXC1_BW_20MHZ;
 
 				if (IS_MCS(rspec[k])) {
 					/* mcs 32 must be 40b/w DUP */
@@ -3863,15 +3863,15 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 			rspec[k] &= ~RSPEC_SHORT_GI;
 #endif
 
-			mimo_preamble_type = WLC_MM_PREAMBLE;
+			mimo_preamble_type = BRCMS_MM_PREAMBLE;
 			if (txrate[k]->flags & IEEE80211_TX_RC_GREEN_FIELD)
-				mimo_preamble_type = WLC_GF_PREAMBLE;
+				mimo_preamble_type = BRCMS_GF_PREAMBLE;
 
 			if ((txrate[k]->flags & IEEE80211_TX_RC_MCS)
 			    && (!IS_MCS(rspec[k]))) {
 				wiphy_err(wlc->wiphy, "wl%d: %s: IEEE80211_TX_"
 					  "RC_MCS != IS_MCS(rspec)\n",
-					  WLCWLUNIT(wlc), __func__);
+					  BRCMS_UNIT(wlc), __func__);
 			}
 
 			if (IS_MCS(rspec[k])) {
@@ -3881,7 +3881,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 				if ((rspec[k] & RSPEC_SHORT_GI)
 				    && IS_SINGLE_STREAM(rspec[k] &
 							RSPEC_RATE_MASK)) {
-					preamble_type[k] = WLC_MM_PREAMBLE;
+					preamble_type[k] = BRCMS_MM_PREAMBLE;
 				}
 			}
 
@@ -3889,7 +3889,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 			if (!IS_MCS(rspec[0])
 			    && (tx_info->control.rates[0].
 				flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE))
-				preamble_type[k] = WLC_SHORT_PREAMBLE;
+				preamble_type[k] = BRCMS_SHORT_PREAMBLE;
 		}
 	} else {
 		for (k = 0; k < hw->max_rates; k++) {
@@ -3898,7 +3898,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 			rspec[k] |= (PHY_TXC1_BW_20MHZ << RSPEC_BW_SHIFT);
 
 			/* for nphy, stf of ofdm frames must follow policies */
-			if (WLCISNPHY(wlc->band) && IS_OFDM(rspec[k])) {
+			if (BRCMS_ISNPHY(wlc->band) && IS_OFDM(rspec[k])) {
 				rspec[k] &= ~RSPEC_STF_MASK;
 				rspec[k] |= phyctl1_stf << RSPEC_STF_SHIFT;
 			}
@@ -3971,7 +3971,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	if (BAND_5G(wlc->band->bandtype))
 		mcl |= TXC_FREQBAND_5G;
 
-	if (CHSPEC_IS40(WLC_BAND_PI_RADIO_CHANSPEC))
+	if (CHSPEC_IS40(BRCMS_BAND_PI_RADIO_CHANSPEC))
 		mcl |= TXC_BW_40;
 
 	/* set AMIC bit if using hardware TKIP MIC */
@@ -3984,9 +3984,9 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	mch = 0;
 
 	/* Set fallback rate preamble type */
-	if ((preamble_type[1] == WLC_SHORT_PREAMBLE) ||
-	    (preamble_type[1] == WLC_GF_PREAMBLE)) {
-		if (RSPEC2RATE(rspec[1]) != WLC_RATE_1M)
+	if ((preamble_type[1] == BRCMS_SHORT_PREAMBLE) ||
+	    (preamble_type[1] == BRCMS_GF_PREAMBLE)) {
+		if (RSPEC2RATE(rspec[1]) != BRCM_RATE_1M)
 			mch |= TXC_PREAMBLE_DATA_FB_SHORT;
 	}
 
@@ -4029,16 +4029,16 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 		}
 
 		if (!IS_OFDM(rts_rspec[0]) &&
-		    !((RSPEC2RATE(rts_rspec[0]) == WLC_RATE_1M) ||
-		      (wlc->PLCPHdr_override == WLC_PLCP_LONG))) {
-			rts_preamble_type[0] = WLC_SHORT_PREAMBLE;
+		    !((RSPEC2RATE(rts_rspec[0]) == BRCM_RATE_1M) ||
+		      (wlc->PLCPHdr_override == BRCMS_PLCP_LONG))) {
+			rts_preamble_type[0] = BRCMS_SHORT_PREAMBLE;
 			mch |= TXC_PREAMBLE_RTS_MAIN_SHORT;
 		}
 
 		if (!IS_OFDM(rts_rspec[1]) &&
-		    !((RSPEC2RATE(rts_rspec[1]) == WLC_RATE_1M) ||
-		      (wlc->PLCPHdr_override == WLC_PLCP_LONG))) {
-			rts_preamble_type[1] = WLC_SHORT_PREAMBLE;
+		    !((RSPEC2RATE(rts_rspec[1]) == BRCM_RATE_1M) ||
+		      (wlc->PLCPHdr_override == BRCMS_PLCP_LONG))) {
+			rts_preamble_type[1] = BRCMS_SHORT_PREAMBLE;
 			mch |= TXC_PREAMBLE_RTS_FB_SHORT;
 		}
 
@@ -4127,14 +4127,14 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	xfts |= (FRAMETYPE(rts_rspec[0], wlc->mimoft) << XFTS_RTS_FT_SHIFT);
 	xfts |= (FRAMETYPE(rts_rspec[1], wlc->mimoft) << XFTS_FBRRTS_FT_SHIFT);
 	xfts |=
-	    CHSPEC_CHANNEL(WLC_BAND_PI_RADIO_CHANSPEC) << XFTS_CHANNEL_SHIFT;
+	    CHSPEC_CHANNEL(BRCMS_BAND_PI_RADIO_CHANSPEC) << XFTS_CHANNEL_SHIFT;
 	txh->XtraFrameTypes = cpu_to_le16(xfts);
 
 	/* PhyTxControlWord */
 	phyctl = FRAMETYPE(rspec[0], wlc->mimoft);
-	if ((preamble_type[0] == WLC_SHORT_PREAMBLE) ||
-	    (preamble_type[0] == WLC_GF_PREAMBLE)) {
-		if (RSPEC2RATE(rspec[0]) != WLC_RATE_1M)
+	if ((preamble_type[0] == BRCMS_SHORT_PREAMBLE) ||
+	    (preamble_type[0] == BRCMS_GF_PREAMBLE)) {
+		if (RSPEC2RATE(rspec[0]) != BRCM_RATE_1M)
 			phyctl |= PHY_TXC_SHORT_HDR;
 	}
 
@@ -4143,7 +4143,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	txh->PhyTxControlWord = cpu_to_le16(phyctl);
 
 	/* PhyTxControlWord_1 */
-	if (WLC_PHY_11N_CAP(wlc->band)) {
+	if (BRCMS_PHY_11N_CAP(wlc->band)) {
 		u16 phyctl1 = 0;
 
 		phyctl1 = brcms_c_phytxctl1_calc(wlc, rspec[0]);
@@ -4163,13 +4163,15 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 		 * fill in non-zero MModeLen and/or MModeFbrLen
 		 *  it will be unnecessary if they are separated
 		 */
-		if (IS_MCS(rspec[0]) && (preamble_type[0] == WLC_MM_PREAMBLE)) {
+		if (IS_MCS(rspec[0]) &&
+		    (preamble_type[0] == BRCMS_MM_PREAMBLE)) {
 			u16 mmodelen =
 			    brcms_c_calc_lsig_len(wlc, rspec[0], phylen);
 			txh->MModeLen = cpu_to_le16(mmodelen);
 		}
 
-		if (IS_MCS(rspec[1]) && (preamble_type[1] == WLC_MM_PREAMBLE)) {
+		if (IS_MCS(rspec[1]) &&
+		    (preamble_type[1] == BRCMS_MM_PREAMBLE)) {
 			u16 mmodefbrlen =
 			    brcms_c_calc_lsig_len(wlc, rspec[1], phylen);
 			txh->MModeFbrLen = cpu_to_le16(mmodefbrlen);
@@ -4290,7 +4292,6 @@ static void brcms_c_war16165(struct brcms_c_info *wlc, bool tx)
 }
 
 /* process an individual struct tx_status */
-/* WLC_HIGH_API */
 bool
 brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs, u32 frm_tx2)
 {
@@ -4329,7 +4330,7 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs, u32 frm_tx2)
 	}
 
 	p = GETNEXTTXP(wlc, queue);
-	if (WLC_WAR16165(wlc))
+	if (BRCMS_WAR16165(wlc))
 		brcms_c_war16165(wlc, false);
 	if (p == NULL)
 		goto fatal;
@@ -4389,8 +4390,8 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs, u32 frm_tx2)
 		    fbl;
 
 		if (queue < AC_COUNT) {
-			sfbl = WLC_WME_RETRY_SFB_GET(wlc, wme_fifo2ac[queue]);
-			lfbl = WLC_WME_RETRY_LFB_GET(wlc, wme_fifo2ac[queue]);
+			sfbl = BRCMS_WME_RETRY_SFB_GET(wlc, wme_fifo2ac[queue]);
+			lfbl = BRCMS_WME_RETRY_LFB_GET(wlc, wme_fifo2ac[queue]);
 		} else {
 			sfbl = wlc->SFBL;
 			lfbl = wlc->LFBL;
@@ -4461,12 +4462,12 @@ brcms_c_txfifo_complete(struct brcms_c_info *wlc, uint fifo, s8 txpktpend)
 		TXPKTPENDGET(wlc, fifo));
 
 	/* There is more room; mark precedences related to this FIFO sendable */
-	WLC_TX_FIFO_ENAB(wlc, fifo);
+	BRCMS_TX_FIFO_ENAB(wlc, fifo);
 
 	/* Clear MHF2_TXBCMC_NOW flag if BCMC fifo has drained */
 	if (AP_ENAB(wlc->pub) &&
 	    !TXPKTPENDGET(wlc, TX_BCMC_FIFO)) {
-		brcms_c_mhf(wlc, MHF2, MHF2_TXBCMC_NOW, 0, WLC_BAND_AUTO);
+		brcms_c_mhf(wlc, MHF2, MHF2_TXBCMC_NOW, 0, BRCM_BAND_AUTO);
 	}
 
 	/* figure out which bsscfg is being worked on... */
@@ -4539,7 +4540,7 @@ prep_mac80211_status(struct brcms_c_info *wlc, struct d11rxhdr *rxh,
 	rx_status->mactime = brcms_c_recover_tsf64(wlc, wlc_rxh);
 	rx_status->flag |= RX_FLAG_MACTIME_MPDU;
 
-	channel = WLC_CHAN_CHANNEL(rxh->RxChan);
+	channel = BRCMS_CHAN_CHANNEL(rxh->RxChan);
 
 	if (channel > 14) {
 		rx_status->band = IEEE80211_BAND_5GHZ;
@@ -4567,40 +4568,40 @@ prep_mac80211_status(struct brcms_c_info *wlc, struct d11rxhdr *rxh,
 			rx_status->flag |= RX_FLAG_40MHZ;
 	} else {
 		switch (RSPEC2RATE(rspec)) {
-		case WLC_RATE_1M:
+		case BRCM_RATE_1M:
 			rx_status->rate_idx = 0;
 			break;
-		case WLC_RATE_2M:
+		case BRCM_RATE_2M:
 			rx_status->rate_idx = 1;
 			break;
-		case WLC_RATE_5M5:
+		case BRCM_RATE_5M5:
 			rx_status->rate_idx = 2;
 			break;
-		case WLC_RATE_11M:
+		case BRCM_RATE_11M:
 			rx_status->rate_idx = 3;
 			break;
-		case WLC_RATE_6M:
+		case BRCM_RATE_6M:
 			rx_status->rate_idx = 4;
 			break;
-		case WLC_RATE_9M:
+		case BRCM_RATE_9M:
 			rx_status->rate_idx = 5;
 			break;
-		case WLC_RATE_12M:
+		case BRCM_RATE_12M:
 			rx_status->rate_idx = 6;
 			break;
-		case WLC_RATE_18M:
+		case BRCM_RATE_18M:
 			rx_status->rate_idx = 7;
 			break;
-		case WLC_RATE_24M:
+		case BRCM_RATE_24M:
 			rx_status->rate_idx = 8;
 			break;
-		case WLC_RATE_36M:
+		case BRCM_RATE_36M:
 			rx_status->rate_idx = 9;
 			break;
-		case WLC_RATE_48M:
+		case BRCM_RATE_48M:
 			rx_status->rate_idx = 10;
 			break;
-		case WLC_RATE_54M:
+		case BRCM_RATE_54M:
 			rx_status->rate_idx = 11;
 			break;
 		default:
@@ -4660,7 +4661,6 @@ brcms_c_recvctl(struct brcms_c_info *wlc, struct d11rxhdr *rxh,
  * Return true if more frames need to be processed. false otherwise.
  * Param 'bound' indicates max. # frames to process before break out.
  */
-/* WLC_HIGH_API */
 void brcms_c_recv(struct brcms_c_info *wlc, struct sk_buff *p)
 {
 	struct d11rxhdr *rxh;
@@ -4674,7 +4674,7 @@ void brcms_c_recv(struct brcms_c_info *wlc, struct sk_buff *p)
 	rxh = (struct d11rxhdr *) (p->data);
 
 	/* strip off rxhdr */
-	skb_pull(p, WL_HWRXOFF);
+	skb_pull(p, BRCMS_HWRXOFF);
 
 	/* fixup rx header endianness */
 	rxh->RxFrameSize = le16_to_cpu(rxh->RxFrameSize);
@@ -4808,7 +4808,7 @@ brcms_c_calc_frame_time(struct brcms_c_info *wlc, ratespec_t ratespec,
 	if (rate == 0) {
 		wiphy_err(wlc->wiphy, "wl%d: WAR: using rate of 1 mbps\n",
 			  wlc->pub->unit);
-		rate = WLC_RATE_1M;
+		rate = BRCM_RATE_1M;
 	}
 
 	BCMMSG(wlc->wiphy, "wl%d: rspec 0x%x, preamble_type %d, len%d\n",
@@ -4819,7 +4819,7 @@ brcms_c_calc_frame_time(struct brcms_c_info *wlc, ratespec_t ratespec,
 		int tot_streams = MCS_TXS(mcs) + RSPEC_STC(ratespec);
 
 		dur = PREN_PREAMBLE + (tot_streams * PREN_PREAMBLE_EXT);
-		if (preamble_type == WLC_MM_PREAMBLE)
+		if (preamble_type == BRCMS_MM_PREAMBLE)
 			dur += PREN_MM_EXT;
 		/* 1000Ndbps = kbps * 4 */
 		kNdps =
@@ -4858,7 +4858,7 @@ brcms_c_calc_frame_time(struct brcms_c_info *wlc, ratespec_t ratespec,
 		mac_len = mac_len * 8 * 2;
 		/* calc ceiling of bits/rate = microseconds of air time */
 		dur = (mac_len + rate - 1) / rate;
-		if (preamble_type & WLC_SHORT_PREAMBLE)
+		if (preamble_type & BRCMS_SHORT_PREAMBLE)
 			dur += BPHY_PLCP_SHORT_TIME;
 		else
 			dur += BPHY_PLCP_TIME;
@@ -4902,7 +4902,7 @@ brcms_c_calc_frame_len(struct brcms_c_info *wlc, ratespec_t ratespec,
 		    ((nsyms * Ndps) -
 		     (APHY_SERVICE_NBITS + APHY_TAIL_NBITS)) / 8;
 	} else {
-		if (preamble_type & WLC_SHORT_PREAMBLE)
+		if (preamble_type & BRCMS_SHORT_PREAMBLE)
 			dur -= BPHY_PLCP_SHORT_TIME;
 		else
 			dur -= BPHY_PLCP_TIME;
@@ -4922,7 +4922,7 @@ brcms_c_calc_ba_time(struct brcms_c_info *wlc, ratespec_t rspec,
 	/* Spec 9.6: ack rate is the highest rate in BSSBasicRateSet that is less than
 	 * or equal to the rate of the immediately previous frame in the FES
 	 */
-	rspec = WLC_BASIC_RATE(wlc, rspec);
+	rspec = BRCMS_BASIC_RATE(wlc, rspec);
 	/* BA len == 32 == 16(ctl hdr) + 4(ba len) + 8(bitmap) + 4(fcs) */
 	return brcms_c_calc_frame_time(wlc, rspec, preamble_type,
 				   (DOT11_BA_LEN + DOT11_BA_BITMAP_LEN +
@@ -4940,7 +4940,7 @@ brcms_c_calc_ack_time(struct brcms_c_info *wlc, ratespec_t rspec,
 	/* Spec 9.6: ack rate is the highest rate in BSSBasicRateSet that is less than
 	 * or equal to the rate of the immediately previous frame in the FES
 	 */
-	rspec = WLC_BASIC_RATE(wlc, rspec);
+	rspec = BRCMS_BASIC_RATE(wlc, rspec);
 	/* ACK frame len == 14 == 2(fc) + 2(dur) + 6(ra) + 4(fcs) */
 	dur =
 	    brcms_c_calc_frame_time(wlc, rspec, preamble_type,
@@ -4968,20 +4968,20 @@ void brcms_c_rate_lookup_init(struct brcms_c_info *wlc, wlc_rateset_t *rateset)
 	uint i;
 
 	/* incoming rates are in 500kbps units as in 802.11 Supported Rates */
-	memset(br, 0, WLC_MAXRATE + 1);
+	memset(br, 0, BRCM_MAXRATE + 1);
 
 	/* For each basic rate in the rates list, make an entry in the
 	 * best basic lookup.
 	 */
 	for (i = 0; i < rateset->count; i++) {
 		/* only make an entry for a basic rate */
-		if (!(rateset->rates[i] & WLC_RATE_FLAG))
+		if (!(rateset->rates[i] & BRCMS_RATE_FLAG))
 			continue;
 
 		/* mask off basic bit */
-		rate = (rateset->rates[i] & WLC_RATE_MASK);
+		rate = (rateset->rates[i] & BRCMS_RATE_MASK);
 
-		if (rate > WLC_MAXRATE) {
+		if (rate > BRCM_MAXRATE) {
 			wiphy_err(wlc->wiphy, "brcms_c_rate_lookup_init: "
 				  "invalid rate 0x%X in rate set\n",
 				  rateset->rates[i]);
@@ -5033,12 +5033,12 @@ void brcms_c_rate_lookup_init(struct brcms_c_info *wlc, wlc_rateset_t *rateset)
 
 		if (IS_OFDM(rate)) {
 			/* In 11g and 11a, the OFDM mandatory rates are 6, 12, and 24 Mbps */
-			if (rate >= WLC_RATE_24M)
-				mandatory = WLC_RATE_24M;
-			else if (rate >= WLC_RATE_12M)
-				mandatory = WLC_RATE_12M;
+			if (rate >= BRCM_RATE_24M)
+				mandatory = BRCM_RATE_24M;
+			else if (rate >= BRCM_RATE_12M)
+				mandatory = BRCM_RATE_12M;
 			else
-				mandatory = WLC_RATE_6M;
+				mandatory = BRCM_RATE_6M;
 		} else {
 			/* In 11b, all the CCK rates are mandatory 1 - 11 Mbps */
 			mandatory = rate;
@@ -5066,8 +5066,8 @@ static void brcms_c_write_rate_shm(struct brcms_c_info *wlc, u8 rate,
 	 * for a given rate, the LS-nibble of the PLCP SIGNAL field is
 	 * the index into the rate table.
 	 */
-	phy_rate = rate_info[rate] & WLC_RATE_MASK;
-	basic_phy_rate = rate_info[basic_rate] & WLC_RATE_MASK;
+	phy_rate = rate_info[rate] & BRCMS_RATE_MASK;
+	basic_phy_rate = rate_info[basic_rate] & BRCMS_RATE_MASK;
 	index = phy_rate & 0xf;
 	basic_index = basic_phy_rate & 0xf;
 
@@ -5086,7 +5086,7 @@ static const wlc_rateset_t *brcms_c_rateset_get_hwrs(struct brcms_c_info *wlc)
 {
 	const wlc_rateset_t *rs_dflt;
 
-	if (WLC_PHY_11N_CAP(wlc->band)) {
+	if (BRCMS_PHY_11N_CAP(wlc->band)) {
 		if (BAND_5G(wlc->band->bandtype))
 			rs_dflt = &ofdm_mimo_rates;
 		else
@@ -5113,17 +5113,17 @@ void brcms_c_set_ratetable(struct brcms_c_info *wlc)
 
 	/* walk the phy rate table and update SHM basic rate lookup table */
 	for (i = 0; i < rs.count; i++) {
-		rate = rs.rates[i] & WLC_RATE_MASK;
+		rate = rs.rates[i] & BRCMS_RATE_MASK;
 
-		/* for a given rate WLC_BASIC_RATE returns the rate at
+		/* for a given rate BRCMS_BASIC_RATE returns the rate at
 		 * which a response ACK/CTS should be sent.
 		 */
-		basic_rate = WLC_BASIC_RATE(wlc, rate);
+		basic_rate = BRCMS_BASIC_RATE(wlc, rate);
 		if (basic_rate == 0) {
 			/* This should only happen if we are using a
 			 * restricted rateset.
 			 */
-			basic_rate = rs.rates[0] & WLC_RATE_MASK;
+			basic_rate = rs.rates[0] & BRCMS_RATE_MASK;
 		}
 
 		brcms_c_write_rate_shm(wlc, rate, basic_rate);
@@ -5132,7 +5132,7 @@ void brcms_c_set_ratetable(struct brcms_c_info *wlc)
 
 /*
  * Return true if the specified rate is supported by the specified band.
- * WLC_BAND_AUTO indicates the current band.
+ * BRCM_BAND_AUTO indicates the current band.
  */
 bool brcms_c_valid_rate(struct brcms_c_info *wlc, ratespec_t rspec, int band,
 		    bool verbose)
@@ -5140,7 +5140,7 @@ bool brcms_c_valid_rate(struct brcms_c_info *wlc, ratespec_t rspec, int band,
 	wlc_rateset_t *hw_rateset;
 	uint i;
 
-	if ((band == WLC_BAND_AUTO) || (band == wlc->band->bandtype)) {
+	if ((band == BRCM_BAND_AUTO) || (band == wlc->band->bandtype)) {
 		hw_rateset = &wlc->band->hw_rateset;
 	} else if (NBANDS(wlc) > 1) {
 		hw_rateset = &wlc->bandstate[OTHERBANDUNIT(wlc)]->hw_rateset;
@@ -5178,14 +5178,14 @@ static void brcms_c_update_mimo_band_bwcap(struct brcms_c_info *wlc, u8 bwcap)
 		if (IS_SINGLEBAND_5G(wlc->deviceid))
 			i = BAND_5G_INDEX;
 		band = wlc->bandstate[i];
-		if (band->bandtype == WLC_BAND_5G) {
-			if ((bwcap == WLC_N_BW_40ALL)
-			    || (bwcap == WLC_N_BW_20IN2G_40IN5G))
+		if (band->bandtype == BRCM_BAND_5G) {
+			if ((bwcap == BRCMS_N_BW_40ALL)
+			    || (bwcap == BRCMS_N_BW_20IN2G_40IN5G))
 				band->mimo_cap_40 = true;
 			else
 				band->mimo_cap_40 = false;
 		} else {
-			if (bwcap == WLC_N_BW_40ALL)
+			if (bwcap == BRCMS_N_BW_40ALL)
 				band->mimo_cap_40 = true;
 			else
 				band->mimo_cap_40 = false;
@@ -5212,7 +5212,7 @@ void brcms_c_mod_prb_rsp_rate_table(struct brcms_c_info *wlc, uint frame_len)
 
 	/* walk the phy rate table and update MAC core SHM basic rate table entries */
 	for (i = 0; i < rs.count; i++) {
-		rate = rs.rates[i] & WLC_RATE_MASK;
+		rate = rs.rates[i] & BRCMS_RATE_MASK;
 
 		entry_ptr = brcms_c_rate_shm_offset(wlc, rate);
 
@@ -5220,9 +5220,8 @@ void brcms_c_mod_prb_rsp_rate_table(struct brcms_c_info *wlc, uint frame_len)
 		brcms_c_compute_plcp(wlc, rate, frame_len, plcp);
 
 		/* Calculate the duration of the Probe Response frame plus SIFS for the MAC */
-		dur =
-		    (u16) brcms_c_calc_frame_time(wlc, rate, WLC_LONG_PREAMBLE,
-						 frame_len);
+		dur = (u16) brcms_c_calc_frame_time(wlc, rate,
+						BRCMS_LONG_PREAMBLE, frame_len);
 		dur += sifs;
 
 		/* Update the SHM Rate Table entry Probe Response values */
@@ -5465,7 +5464,7 @@ int brcms_c_prep_pdu(struct brcms_c_info *wlc, struct sk_buff *pdu, uint *fifop)
 	/* return if insufficient dma resources */
 	if (TXAVAIL(wlc, fifo) < MAX_DMA_SEGS) {
 		/* Mark precedences related to this FIFO, unsendable */
-		WLC_TX_FIFO_CLEAR(wlc, fifo);
+		BRCMS_TX_FIFO_CLEAR(wlc, fifo);
 		return -EBUSY;
 	}
 	return 0;
@@ -5492,7 +5491,7 @@ void brcms_c_bsscfg_reprate_init(struct brcms_bss_cfg *bsscfg)
 void brcms_default_rateset(struct brcms_c_info *wlc, wlc_rateset_t *rs)
 {
 	brcms_c_rateset_default(rs, NULL, wlc->band->phytype,
-		wlc->band->bandtype, false, WLC_RATE_MASK_FULL,
+		wlc->band->bandtype, false, BRCMS_RATE_MASK_FULL,
 		(bool) N_ENAB(wlc->pub),
 		CHSPEC_WLC_BW(wlc->default_bss->chanspec),
 		wlc->stf->txstreams);
@@ -5517,17 +5516,17 @@ static void brcms_c_bss_default_init(struct brcms_c_info *wlc)
 
 	/* find the band of our default channel */
 	band = wlc->band;
-	if (NBANDS(wlc) > 1 && band->bandunit != CHSPEC_WLCBANDUNIT(chanspec))
+	if (NBANDS(wlc) > 1 && band->bandunit != CHSPEC_BANDUNIT(chanspec))
 		band = wlc->bandstate[OTHERBANDUNIT(wlc)];
 
 	/* init bss rates to the band specific default rate set */
 	brcms_c_rateset_default(&bi->rateset, NULL, band->phytype,
-		band->bandtype, false, WLC_RATE_MASK_FULL,
+		band->bandtype, false, BRCMS_RATE_MASK_FULL,
 		(bool) N_ENAB(wlc->pub), CHSPEC_WLC_BW(chanspec),
 		wlc->stf->txstreams);
 
 	if (N_ENAB(wlc->pub))
-		bi->flags |= WLC_BSS_HT;
+		bi->flags |= BRCMS_BSS_HT;
 }
 
 static ratespec_t
@@ -5552,7 +5551,7 @@ mac80211_wlc_set_nrate(struct brcms_c_info *wlc, struct brcms_band *cur_band,
 		/* mcs only allowed when nmode */
 		if (stf > PHY_TXC1_MODE_SDM) {
 			wiphy_err(wlc->wiphy, "wl%d: %s: Invalid stf\n",
-				 WLCWLUNIT(wlc), __func__);
+				 BRCMS_UNIT(wlc), __func__);
 			bcmerror = -EINVAL;
 			goto done;
 		}
@@ -5563,7 +5562,7 @@ mac80211_wlc_set_nrate(struct brcms_c_info *wlc, struct brcms_band *cur_band,
 			    ((stf != PHY_TXC1_MODE_SISO)
 			     && (stf != PHY_TXC1_MODE_CDD))) {
 				wiphy_err(wlc->wiphy, "wl%d: %s: Invalid mcs "
-					  "32\n", WLCWLUNIT(wlc), __func__);
+					  "32\n", BRCMS_UNIT(wlc), __func__);
 				bcmerror = -EINVAL;
 				goto done;
 			}
@@ -5573,16 +5572,16 @@ mac80211_wlc_set_nrate(struct brcms_c_info *wlc, struct brcms_band *cur_band,
 			if (stf != PHY_TXC1_MODE_SDM) {
 				BCMMSG(wlc->wiphy, "wl%d: enabling "
 					 "SDM mode for mcs %d\n",
-					 WLCWLUNIT(wlc), rate);
+					 BRCMS_UNIT(wlc), rate);
 				stf = PHY_TXC1_MODE_SDM;
 			}
 		} else {
 			/* MCS 0-7 may use SISO, CDD, and for phy_rev >= 3 STBC */
 			if ((stf > PHY_TXC1_MODE_STBC) ||
-			    (!WLC_STBC_CAP_PHY(wlc)
+			    (!BRCMS_STBC_CAP_PHY(wlc)
 			     && (stf == PHY_TXC1_MODE_STBC))) {
 				wiphy_err(wlc->wiphy, "wl%d: %s: Invalid STBC"
-					  "\n", WLCWLUNIT(wlc), __func__);
+					  "\n", BRCMS_UNIT(wlc), __func__);
 				bcmerror = -EINVAL;
 				goto done;
 			}
@@ -5590,28 +5589,28 @@ mac80211_wlc_set_nrate(struct brcms_c_info *wlc, struct brcms_band *cur_band,
 	} else if (IS_OFDM(rate)) {
 		if ((stf != PHY_TXC1_MODE_CDD) && (stf != PHY_TXC1_MODE_SISO)) {
 			wiphy_err(wlc->wiphy, "wl%d: %s: Invalid OFDM\n",
-				  WLCWLUNIT(wlc), __func__);
+				  BRCMS_UNIT(wlc), __func__);
 			bcmerror = -EINVAL;
 			goto done;
 		}
 	} else if (IS_CCK(rate)) {
-		if ((cur_band->bandtype != WLC_BAND_2G)
+		if ((cur_band->bandtype != BRCM_BAND_2G)
 		    || (stf != PHY_TXC1_MODE_SISO)) {
 			wiphy_err(wlc->wiphy, "wl%d: %s: Invalid CCK\n",
-				  WLCWLUNIT(wlc), __func__);
+				  BRCMS_UNIT(wlc), __func__);
 			bcmerror = -EINVAL;
 			goto done;
 		}
 	} else {
 		wiphy_err(wlc->wiphy, "wl%d: %s: Unknown rate type\n",
-			  WLCWLUNIT(wlc), __func__);
+			  BRCMS_UNIT(wlc), __func__);
 		bcmerror = -EINVAL;
 		goto done;
 	}
 	/* make sure multiple antennae are available for non-siso rates */
 	if ((stf != PHY_TXC1_MODE_SISO) && (wlc->stf->txstreams == 1)) {
 		wiphy_err(wlc->wiphy, "wl%d: %s: SISO antenna but !SISO "
-			  "request\n", WLCWLUNIT(wlc), __func__);
+			  "request\n", BRCMS_UNIT(wlc), __func__);
 		bcmerror = -EINVAL;
 		goto done;
 	}
@@ -5877,7 +5876,7 @@ brcms_c_txflowcontrol_signal(struct brcms_c_info *wlc,
 	struct brcms_c_if *wlcif;
 
 	for (wlcif = wlc->wlcif_list; wlcif != NULL; wlcif = wlcif->next) {
-		if (wlcif->qi == qi && wlcif->flags & WLC_IF_LINKED)
+		if (wlcif->qi == qi && wlcif->flags & BRCMS_IF_LINKED)
 			brcms_txflowcontrol(wlc->wl, wlcif->wlif, on, prio);
 	}
 #endif
@@ -5895,7 +5894,7 @@ static struct brcms_txq_info *brcms_c_txq_alloc(struct brcms_c_info *wlc)
 		 * leave PS mode. The watermark for flowcontrol to OS packets
 		 * will remain the same
 		 */
-		brcmu_pktq_init(&qi->q, WLC_PREC_COUNT,
+		brcmu_pktq_init(&qi->q, BRCMS_PREC_COUNT,
 			  (2 * wlc->pub->tunables->datahiwat) + PKTQ_LEN_DEFAULT
 			  + wlc->pub->psq_pkts_total);
 
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index 80b08a9..2d0a567 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -24,10 +24,12 @@
 #include "d11.h"
 
 #define MA_WINDOW_SZ		8	/* moving average window size */
-#define	WL_HWRXOFF		38	/* chip rx buffer offset */
+#define	BRCMS_HWRXOFF		38	/* chip rx buffer offset */
 #define	INVCHANNEL		255	/* invalid channel */
-#define	MAXCOREREV		28	/* max # supported core revisions (0 .. MAXCOREREV - 1) */
-#define WLC_MAXMODULES		22  /* max # brcms_c_module_register() calls */
+/* max # supported core revisions (0 .. MAXCOREREV - 1) */
+#define	MAXCOREREV		28
+/* max # brcms_c_module_register() calls */
+#define BRCMS_MAXMODULES	22
 
 #define SEQNUM_SHIFT		4
 #define AMPDU_DELIMITER_LEN	4
@@ -41,14 +43,15 @@
 
 #define NTXRATE			64	/* # tx MPDUs rate is reported for */
 
-#define WLC_BITSCNT(x)	brcmu_bitcount((u8 *)&(x), sizeof(u8))
+#define BRCMS_BITSCNT(x)	brcmu_bitcount((u8 *)&(x), sizeof(u8))
 
 /* Maximum wait time for a MAC suspend */
-#define	WLC_MAX_MAC_SUSPEND	83000	/* uS: 83mS is max packet time (64KB ampdu @ 6Mbps) */
+/* uS: 83mS is max packet time (64KB ampdu @ 6Mbps) */
+#define	BRCMS_MAX_MAC_SUSPEND	83000
 
 /* Probe Response timeout - responses for probe requests older that this are tossed, zero to disable
  */
-#define WLC_PRB_RESP_TIMEOUT	0	/* Disable probe response timeout */
+#define BRCMS_PRB_RESP_TIMEOUT	0	/* Disable probe response timeout */
 
 /* transmit buffer max headroom for protocol headers */
 #define TXOFF (D11_TXH_LEN + D11_PHY_HDR_LEN)
@@ -83,26 +86,28 @@
 #define	VALID_COREREV(corerev)	CONF_HAS(D11CONF, corerev)
 
 /* values for shortslot_override */
-#define WLC_SHORTSLOT_AUTO	-1	/* Driver will manage Shortslot setting */
-#define WLC_SHORTSLOT_OFF	0	/* Turn off short slot */
-#define WLC_SHORTSLOT_ON	1	/* Turn on short slot */
+#define BRCMS_SHORTSLOT_AUTO	-1 /* Driver will manage Shortslot setting */
+#define BRCMS_SHORTSLOT_OFF	0  /* Turn off short slot */
+#define BRCMS_SHORTSLOT_ON	1  /* Turn on short slot */
 
 /* value for short/long and mixmode/greenfield preamble */
-
-#define WLC_LONG_PREAMBLE	(0)
-#define WLC_SHORT_PREAMBLE	(1 << 0)
-#define WLC_GF_PREAMBLE		(1 << 1)
-#define WLC_MM_PREAMBLE		(1 << 2)
-#define WLC_IS_MIMO_PREAMBLE(_pre) (((_pre) == WLC_GF_PREAMBLE) || ((_pre) == WLC_MM_PREAMBLE))
+#define BRCMS_LONG_PREAMBLE	(0)
+#define BRCMS_SHORT_PREAMBLE	(1 << 0)
+#define BRCMS_GF_PREAMBLE		(1 << 1)
+#define BRCMS_MM_PREAMBLE		(1 << 2)
+#define BRCMS_IS_MIMO_PREAMBLE(_pre) (((_pre) == BRCMS_GF_PREAMBLE) || \
+				      ((_pre) == BRCMS_MM_PREAMBLE))
 
 /* values for barker_preamble */
-#define WLC_BARKER_SHORT_ALLOWED	0	/* Short pre-amble allowed */
+#define BRCMS_BARKER_SHORT_ALLOWED	0	/* Short pre-amble allowed */
 
 /* A fifo is full. Clear precedences related to that FIFO */
-#define WLC_TX_FIFO_CLEAR(wlc, fifo) ((wlc)->tx_prec_map &= ~(wlc)->fifo2prec_map[fifo])
+#define BRCMS_TX_FIFO_CLEAR(wlc, fifo) \
+			((wlc)->tx_prec_map &= ~(wlc)->fifo2prec_map[fifo])
 
 /* Fifo is NOT full. Enable precedences for that FIFO */
-#define WLC_TX_FIFO_ENAB(wlc, fifo)  ((wlc)->tx_prec_map |= (wlc)->fifo2prec_map[fifo])
+#define BRCMS_TX_FIFO_ENAB(wlc, fifo) \
+			((wlc)->tx_prec_map |= (wlc)->fifo2prec_map[fifo])
 
 /* TxFrameID */
 /* seq and frag bits: SEQNUM_SHIFT, FRAGNUM_MASK (802.11.h) */
@@ -121,10 +126,10 @@
 /* if wpa is in use then portopen is true when the group key is plumbed otherwise it is always true
  */
 #define WSEC_ENABLED(wsec) ((wsec) & (WEP_ENABLED | TKIP_ENABLED | AES_ENABLED))
-#define WLC_SW_KEYS(wlc, bsscfg) ((((wlc)->wsec_swkeys) || \
+#define BRCMS_SW_KEYS(wlc, bsscfg) ((((wlc)->wsec_swkeys) || \
 	((bsscfg)->wsec & WSEC_SWFLAG)))
 
-#define WLC_PORTOPEN(cfg) \
+#define BRCMS_PORTOPEN(cfg) \
 	(((cfg)->WPA_auth != WPA_AUTH_DISABLED && WSEC_ENABLED((cfg)->wsec)) ? \
 	(cfg)->wsec_portopen : true)
 
@@ -136,11 +141,11 @@
 extern const u8 prio2fifo[];
 
 /* Ucode MCTL_WAKE override bits */
-#define WLC_WAKE_OVERRIDE_CLKCTL	0x01
-#define WLC_WAKE_OVERRIDE_PHYREG	0x02
-#define WLC_WAKE_OVERRIDE_MACSUSPEND	0x04
-#define WLC_WAKE_OVERRIDE_TXFIFO	0x08
-#define WLC_WAKE_OVERRIDE_FORCEFAST	0x10
+#define BRCMS_WAKE_OVERRIDE_CLKCTL	0x01
+#define BRCMS_WAKE_OVERRIDE_PHYREG	0x02
+#define BRCMS_WAKE_OVERRIDE_MACSUSPEND	0x04
+#define BRCMS_WAKE_OVERRIDE_TXFIFO	0x08
+#define BRCMS_WAKE_OVERRIDE_FORCEFAST	0x10
 
 /* stuff pulled in from wlc.c */
 
@@ -179,24 +184,32 @@ extern const u8 prio2fifo[];
 
 #define	NFIFO			6	/* # tx/rx fifopairs */
 
-#define WLC_WME_RETRY_SHORT_GET(wlc, ac)    GFIELD(wlc->wme_retries[ac], EDCF_SHORT)
-#define WLC_WME_RETRY_SFB_GET(wlc, ac)      GFIELD(wlc->wme_retries[ac], EDCF_SFB)
-#define WLC_WME_RETRY_LONG_GET(wlc, ac)     GFIELD(wlc->wme_retries[ac], EDCF_LONG)
-#define WLC_WME_RETRY_LFB_GET(wlc, ac)      GFIELD(wlc->wme_retries[ac], EDCF_LFB)
+#define BRCMS_WME_RETRY_SHORT_GET(wlc, ac) \
+					GFIELD(wlc->wme_retries[ac], EDCF_SHORT)
+#define BRCMS_WME_RETRY_SFB_GET(wlc, ac) \
+					GFIELD(wlc->wme_retries[ac], EDCF_SFB)
+#define BRCMS_WME_RETRY_LONG_GET(wlc, ac) \
+					GFIELD(wlc->wme_retries[ac], EDCF_LONG)
+#define BRCMS_WME_RETRY_LFB_GET(wlc, ac) \
+					GFIELD(wlc->wme_retries[ac], EDCF_LFB)
 
-#define WLC_WME_RETRY_SHORT_SET(wlc, ac, val) \
+#define BRCMS_WME_RETRY_SHORT_SET(wlc, ac, val) \
 	(wlc->wme_retries[ac] = SFIELD(wlc->wme_retries[ac], EDCF_SHORT, val))
-#define WLC_WME_RETRY_SFB_SET(wlc, ac, val) \
+#define BRCMS_WME_RETRY_SFB_SET(wlc, ac, val) \
 	(wlc->wme_retries[ac] = SFIELD(wlc->wme_retries[ac], EDCF_SFB, val))
-#define WLC_WME_RETRY_LONG_SET(wlc, ac, val) \
+#define BRCMS_WME_RETRY_LONG_SET(wlc, ac, val) \
 	(wlc->wme_retries[ac] = SFIELD(wlc->wme_retries[ac], EDCF_LONG, val))
-#define WLC_WME_RETRY_LFB_SET(wlc, ac, val) \
+#define BRCMS_WME_RETRY_LFB_SET(wlc, ac, val) \
 	(wlc->wme_retries[ac] = SFIELD(wlc->wme_retries[ac], EDCF_LFB, val))
 
 /* PLL requests */
-#define WLC_PLLREQ_SHARED	0x1	/* pll is shared on old chips */
-#define WLC_PLLREQ_RADIO_MON	0x2	/* hold pll for radio monitor register checking */
-#define WLC_PLLREQ_FLIP		0x4	/* hold/release pll for some short operation */
+
+/* pll is shared on old chips */
+#define BRCMS_PLLREQ_SHARED	0x1
+/* hold pll for radio monitor register checking */
+#define BRCMS_PLLREQ_RADIO_MON	0x2
+/* hold/release pll for some short operation */
+#define BRCMS_PLLREQ_FLIP		0x4
 
 /*
  * Macros to check if AP or STA is active.
@@ -227,7 +240,7 @@ extern const u8 prio2fifo[];
 	(MCTL_PSM_JMP_0 | MCTL_IHR_EN)) != MCTL_IHR_EN) : \
 	(ai_deviceremoved(wlc->hw->sih)))
 
-#define WLCWLUNIT(wlc)		((wlc)->pub->unit)
+#define BRCMS_UNIT(wlc)		((wlc)->pub->unit)
 
 struct brcms_protection {
 	bool _g;		/* use g spec protection, driver internal */
@@ -270,37 +283,41 @@ struct brcms_stf {
 	s8 spatial_policy;
 };
 
-#define WLC_STF_SS_STBC_TX(wlc, scb) \
+#define BRCMS_STF_SS_STBC_TX(wlc, scb) \
 	(((wlc)->stf->txstreams > 1) && (((wlc)->band->band_stf_stbc_tx == ON) || \
 	 (SCB_STBC_CAP((scb)) &&					\
 	  (wlc)->band->band_stf_stbc_tx == AUTO &&			\
 	  isset(&((wlc)->stf->ss_algo_channel), PHY_TXC1_MODE_STBC))))
 
-#define WLC_STBC_CAP_PHY(wlc) (WLCISNPHY(wlc->band) && NREV_GE(wlc->band->phyrev, 3))
+#define BRCMS_STBC_CAP_PHY(wlc) (BRCMS_ISNPHY(wlc->band) && \
+				 NREV_GE(wlc->band->phyrev, 3))
 
-#define WLC_SGI_CAP_PHY(wlc) ((WLCISNPHY(wlc->band) && NREV_GE(wlc->band->phyrev, 3)) || \
-	WLCISLCNPHY(wlc->band))
+#define BRCMS_SGI_CAP_PHY(wlc) ((BRCMS_ISNPHY(wlc->band) && \
+				 NREV_GE(wlc->band->phyrev, 3)) || \
+				BRCMS_ISLCNPHY(wlc->band))
 
-#define WLC_CHAN_PHYTYPE(x)     (((x) & RXS_CHAN_PHYTYPE_MASK) >> RXS_CHAN_PHYTYPE_SHIFT)
-#define WLC_CHAN_CHANNEL(x)     (((x) & RXS_CHAN_ID_MASK) >> RXS_CHAN_ID_SHIFT)
-#define WLC_RX_CHANNEL(rxh)	(WLC_CHAN_CHANNEL((rxh)->RxChan))
+#define BRCMS_CHAN_PHYTYPE(x)     (((x) & RXS_CHAN_PHYTYPE_MASK) \
+				   >> RXS_CHAN_PHYTYPE_SHIFT)
+#define BRCMS_CHAN_CHANNEL(x)     (((x) & RXS_CHAN_ID_MASK) \
+				   >> RXS_CHAN_ID_SHIFT)
+#define BRCMS_RX_CHANNEL(rxh)	(BRCMS_CHAN_CHANNEL((rxh)->RxChan))
 
 /* brcms_bss_info flag bit values */
-#define WLC_BSS_HT		0x0020	/* BSS is HT (MIMO) capable */
+#define BRCMS_BSS_HT		0x0020	/* BSS is HT (MIMO) capable */
 
 /* Flags used in brcms_c_txq_info.stopped */
 #define TXQ_STOP_FOR_PRIOFC_MASK	0x000000FF	/* per prio flow control bits */
 #define TXQ_STOP_FOR_PKT_DRAIN		0x00000100	/* stop txq enqueue for packet drain */
 #define TXQ_STOP_FOR_AMPDU_FLOW_CNTRL	0x00000200	/* stop txq enqueue for ampdu flow control */
 
-#define WLC_HT_WEP_RESTRICT	0x01	/* restrict HT with WEP */
-#define WLC_HT_TKIP_RESTRICT	0x02	/* restrict HT with TKIP */
+#define BRCMS_HT_WEP_RESTRICT	0x01	/* restrict HT with WEP */
+#define BRCMS_HT_TKIP_RESTRICT	0x02	/* restrict HT with TKIP */
 
 /* Maximum # of keys that wl driver supports in S/W.
  * Keys supported in H/W is less than or equal to WSEC_MAX_KEYS.
  */
 #define WSEC_MAX_KEYS		54	/* Max # of keys (50 + 4 default keys) */
-#define WLC_DEFAULT_KEYS	4	/* Default # of keys */
+#define BRCMS_DEFAULT_KEYS	4	/* Default # of keys */
 
 /*
 * Max # of keys currently supported:
@@ -308,7 +325,7 @@ struct brcms_stf {
 *     s/w keys if WSEC_SW(wlc->wsec).
 *     h/w keys otherwise.
 */
-#define WLC_MAX_WSEC_KEYS(wlc) WSEC_MAX_KEYS
+#define BRCMS_MAX_WSEC_KEYS(wlc) WSEC_MAX_KEYS
 
 /* number of 802.11 default (non-paired, group keys) */
 #define WSEC_MAX_DEFAULT_KEYS	4	/* # of default keys */
@@ -318,7 +335,7 @@ struct wsec_iv {
 	u16 lo;		/* lower 16 bits of IV */
 };
 
-#define WLC_NUMRXIVS	16	/* # rx IVs (one per 802.11e TID) */
+#define BRCMS_NUMRXIVS	16	/* # rx IVs (one per 802.11e TID) */
 
 struct wsec_key {
 	u8 ea[ETH_ALEN];	/* per station */
@@ -334,7 +351,7 @@ struct wsec_key {
 	u32 len;		/* key length..don't move this var */
 	/* data is 4byte aligned */
 	u8 data[WLAN_MAX_KEY_LEN];	/* key data */
-	struct wsec_iv rxiv[WLC_NUMRXIVS];	/* Rx IV (one per TID) */
+	struct wsec_iv rxiv[BRCMS_NUMRXIVS];	/* Rx IV (one per TID) */
 	struct wsec_iv txiv;		/* Tx IV */
 };
 
@@ -355,7 +372,7 @@ struct brcms_core {
  * band state (phy+ana+radio)
  */
 struct brcms_band {
-	int bandtype;		/* WLC_BAND_2G, WLC_BAND_5G */
+	int bandtype;		/* BRCM_BAND_2G, BRCM_BAND_5G */
 	uint bandunit;		/* bandstate[] index */
 
 	u16 phytype;		/* phytype */
@@ -376,7 +393,7 @@ struct brcms_band {
 	u8 band_stf_ss_mode;	/* Configured STF type, 0:siso; 1:cdd */
 	s8 band_stf_stbc_tx;	/* STBC TX 0:off; 1:force on; -1:auto */
 	wlc_rateset_t hw_rateset;	/* rates supported by chip (phy-specific) */
-	u8 basic_rate[WLC_MAXRATE + 1];	/* basic rates indexed by rate */
+	u8 basic_rate[BRCM_MAXRATE + 1]; /* basic rates indexed by rate */
 	bool mimo_cap_40;	/* 40 MHz cap enabled on this band */
 	s8 antgain;		/* antenna gain from srom */
 
@@ -436,7 +453,7 @@ struct wme_param_ie {
 /* virtual interface */
 struct brcms_c_if {
 	struct brcms_c_if *next;
-	u8 type;		/* WLC_IFTYPE_BSS or WLC_IFTYPE_WDS */
+	u8 type;		/* BSS or WDS */
 	u8 index;		/* assigned in wl_add_if(), index of the wlif if any,
 				 * not necessarily corresponding to bsscfg._idx or
 				 * AID2PVBMAP(scb).
@@ -445,18 +462,18 @@ struct brcms_c_if {
 	struct brcms_if *wlif;		/* pointer to wlif */
 	struct brcms_txq_info *qi;	/* pointer to associated tx queue */
 	union {
-		/* pointer to scb if WLC_IFTYPE_WDS */
+		/* pointer to scb if WDS */
 		struct scb *scb;
-		/* pointer to bsscfg if WLC_IFTYPE_BSS */
+		/* pointer to bsscfg if BSS */
 		struct brcms_bss_cfg *bsscfg;
 	} u;
 };
 
 /* flags for the interface, this interface is linked to a brcms_if */
-#define WLC_IF_LINKED		0x02
+#define BRCMS_IF_LINKED		0x02
 
 struct brcms_hw_band {
-	int bandtype;		/* WLC_BAND_2G, WLC_BAND_5G */
+	int bandtype;		/* BRCM_BAND_2G, BRCM_BAND_5G */
 	uint bandunit;		/* bandstate[] index */
 	u16 mhfs[MHFMAX];	/* MHF array shadow */
 	u8 bandhw_stf_ss_mode;	/* HW configured STF type, 0:siso; 1:cdd */
@@ -673,7 +690,7 @@ struct brcms_c_info {
 	 * BSS Configurations set of BSS configurations, idx 0 is default and
 	 * always valid
 	 */
-	struct brcms_bss_cfg *bsscfg[WLC_MAXBSSCFG];
+	struct brcms_bss_cfg *bsscfg[BRCMS_MAXBSSCFG];
 	struct brcms_bss_cfg *cfg; /* the primary bsscfg (can be AP or STA) */
 
 	/* tx queue */
@@ -682,7 +699,7 @@ struct brcms_c_info {
 	/* security */
 	struct wsec_key *wsec_keys[WSEC_MAX_KEYS]; /* dynamic key storage */
 	/* default key storage */
-	struct wsec_key *wsec_def_keys[WLC_DEFAULT_KEYS];
+	struct wsec_key *wsec_def_keys[BRCMS_DEFAULT_KEYS];
 	bool wsec_swkeys;	/* indicates that all keys should be
 				 * treated as sw keys (used for debugging)
 				 */
@@ -699,12 +716,10 @@ struct brcms_c_info {
 
 	u16 mc_fid_counter;	/* BC/MC FIFO frame ID counter */
 
-	char country_default[WLC_CNTRY_BUF_SZ];	/* saved country for leaving 802.11d
-						 * auto-country mode
-						 */
-	char autocountry_default[WLC_CNTRY_BUF_SZ];	/* initial country for 802.11d
-							 * auto-country mode
-							 */
+	/* saved country for leaving 802.11d auto-country mode */
+	char country_default[BRCM_CNTRY_BUF_SZ];
+	/* initial country for 802.11d auto-country mode */
+	char autocountry_default[BRCM_CNTRY_BUF_SZ];
 	u16 prb_resp_timeout;	/* do not send prb resp if request older than this,
 					 * 0 = disable
 					 */
@@ -800,7 +815,7 @@ struct brcms_bss_cfg {
 	struct wsec_iv wpa_none_txiv;
 	int wsec_index;		/* 0-3: default tx key, -1: not set */
 	/* default key storage: */
-	struct wsec_key *bss_def_keys[WLC_DEFAULT_KEYS];
+	struct wsec_key *bss_def_keys[BRCMS_DEFAULT_KEYS];
 
 	/* TKIP countermeasures */
 	bool tkip_countermeasures;	/* flags TKIP no-assoc period */
@@ -814,7 +829,7 @@ struct brcms_bss_cfg {
 	u16 bcmc_fid;	/* the last BCMC FID queued to TX_BCMC_FIFO */
 	u16 bcmc_fid_shm;	/* the last BCMC FID written to shared mem */
 
-	u32 flags;		/* WLC_BSSCFG flags; see below */
+	u32 flags;		/* BSSCFG flags; see below */
 
 	u8 *bcn;		/* AP beacon */
 	uint bcn_len;		/* AP beacon length */
@@ -853,7 +868,7 @@ struct brcms_bss_cfg {
 #define IS_MBAND_UNLOCKED(wlc) \
 	((NBANDS(wlc) > 1) && !(wlc)->bandlocked)
 
-#define WLC_BAND_PI_RADIO_CHANSPEC wlc_phy_chanspec_get(wlc->band->pi)
+#define BRCMS_BAND_PI_RADIO_CHANSPEC wlc_phy_chanspec_get(wlc->band->pi)
 
 /* sum the individual fifo tx pending packet counts */
 #define	TXPKTPENDTOT(wlc) ((wlc)->core->txpktpend[0] + (wlc)->core->txpktpend[1] + \
@@ -866,7 +881,7 @@ struct brcms_bss_cfg {
 #define GETNEXTTXP(wlc, _queue)								\
 		dma_getnexttxp((wlc)->hw->di[(_queue)], DMA_RANGE_TRANSMITTED)
 
-#define WLC_IS_MATCH_SSID(wlc, ssid1, ssid2, len1, len2) \
+#define BRCMS_IS_MATCH_SSID(wlc, ssid1, ssid2, len1, len2) \
 	((len1 == len2) && !memcmp(ssid1, ssid2, len1))
 
 extern void brcms_c_fatal_error(struct brcms_c_info *wlc);
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index c4e9069..7b1b584 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -109,14 +109,14 @@ u16 ltrn_list[PHY_LTRN_LIST_LEN] = {
 
 const u8 ofdm_rate_lookup[] = {
 
-	WLC_RATE_48M,
-	WLC_RATE_24M,
-	WLC_RATE_12M,
-	WLC_RATE_6M,
-	WLC_RATE_54M,
-	WLC_RATE_36M,
-	WLC_RATE_18M,
-	WLC_RATE_9M
+	BRCM_RATE_48M,
+	BRCM_RATE_24M,
+	BRCM_RATE_12M,
+	BRCM_RATE_6M,
+	BRCM_RATE_54M,
+	BRCM_RATE_36M,
+	BRCM_RATE_18M,
+	BRCM_RATE_9M
 };
 
 #define PHY_WREG_LIMIT	24
@@ -636,9 +636,9 @@ wlc_phy_attach(struct shared_phy *sh, void *regs, int bandtype,
 		pi->phynoise_polling = false;
 
 	for (i = 0; i < TXP_NUM_RATES; i++) {
-		pi->txpwr_limit[i] = WLC_TXPWR_MAX;
-		pi->txpwr_env_limit[i] = WLC_TXPWR_MAX;
-		pi->tx_user_target[i] = WLC_TXPWR_MAX;
+		pi->txpwr_limit[i] = BRCMS_TXPWR_MAX;
+		pi->txpwr_env_limit[i] = BRCMS_TXPWR_MAX;
+		pi->tx_user_target[i] = BRCMS_TXPWR_MAX;
 	}
 
 	pi->radiopwr_override = RADIOPWR_OVERRIDE_DEF;
@@ -1110,7 +1110,7 @@ wlc_phy_init_radio_regs(struct brcms_phy *pi, struct radio_regs *radioregs,
 						address | core_offset,
 						(u16) radioregs[i].init_a);
 				if (ISNPHY(pi) && (++count % 4 == 0))
-					WLC_PHY_WAR_PR51571(pi);
+					BRCMS_PHY_WAR_PR51571(pi);
 			}
 		} else {
 			if (radioregs[i].do_init_g) {
@@ -1119,7 +1119,7 @@ wlc_phy_init_radio_regs(struct brcms_phy *pi, struct radio_regs *radioregs,
 						address | core_offset,
 						(u16) radioregs[i].init_g);
 				if (ISNPHY(pi) && (++count % 4 == 0))
-					WLC_PHY_WAR_PR51571(pi);
+					BRCMS_PHY_WAR_PR51571(pi);
 			}
 		}
 
@@ -1411,8 +1411,8 @@ wlc_phy_chanspec_band_validch(struct brcms_phy_pub *ppi, uint band,
 		    && (channel <= LAST_REF5_CHANNUM))
 			continue;
 
-		if (((band == WLC_BAND_2G) && (channel <= CH_MAX_2G_CHANNEL)) ||
-		    ((band == WLC_BAND_5G) && (channel > CH_MAX_2G_CHANNEL)))
+		if ((band == BRCM_BAND_2G && channel <= CH_MAX_2G_CHANNEL) ||
+		    (band == BRCM_BAND_5G && channel > CH_MAX_2G_CHANNEL))
 			setbit(channels->vec, channel);
 	}
 }
@@ -1443,7 +1443,7 @@ chanspec_t wlc_phy_chanspec_band_firstch(struct brcms_phy_pub *ppi, uint band)
 			chspec =
 			    channel | WL_CHANSPEC_BW_40 |
 			    WL_CHANSPEC_CTL_SB_LOWER;
-			if (band == WLC_BAND_2G)
+			if (band == BRCM_BAND_2G)
 				chspec |= WL_CHANSPEC_BAND_2G;
 			else
 				chspec |= WL_CHANSPEC_BAND_5G;
@@ -1454,8 +1454,8 @@ chanspec_t wlc_phy_chanspec_band_firstch(struct brcms_phy_pub *ppi, uint band)
 		    && (channel <= LAST_REF5_CHANNUM))
 			continue;
 
-		if (((band == WLC_BAND_2G) && (channel <= CH_MAX_2G_CHANNEL)) ||
-		    ((band == WLC_BAND_5G) && (channel > CH_MAX_2G_CHANNEL)))
+		if ((band == BRCM_BAND_2G && channel <= CH_MAX_2G_CHANNEL) ||
+		    (band == BRCM_BAND_5G && channel > CH_MAX_2G_CHANNEL))
 			return chspec;
 	}
 
@@ -1479,35 +1479,35 @@ void wlc_phy_txpower_target_set(struct brcms_phy_pub *ppi,
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 
 	memcpy(&pi->tx_user_target[TXP_FIRST_CCK],
-	       &txpwr->cck[0], WLC_NUM_RATES_CCK);
+	       &txpwr->cck[0], BRCMS_NUM_RATES_CCK);
 
 	memcpy(&pi->tx_user_target[TXP_FIRST_OFDM],
-	       &txpwr->ofdm[0], WLC_NUM_RATES_OFDM);
+	       &txpwr->ofdm[0], BRCMS_NUM_RATES_OFDM);
 	memcpy(&pi->tx_user_target[TXP_FIRST_OFDM_20_CDD],
-	       &txpwr->ofdm_cdd[0], WLC_NUM_RATES_OFDM);
+	       &txpwr->ofdm_cdd[0], BRCMS_NUM_RATES_OFDM);
 
 	memcpy(&pi->tx_user_target[TXP_FIRST_OFDM_40_SISO],
-	       &txpwr->ofdm_40_siso[0], WLC_NUM_RATES_OFDM);
+	       &txpwr->ofdm_40_siso[0], BRCMS_NUM_RATES_OFDM);
 	memcpy(&pi->tx_user_target[TXP_FIRST_OFDM_40_CDD],
-	       &txpwr->ofdm_40_cdd[0], WLC_NUM_RATES_OFDM);
+	       &txpwr->ofdm_40_cdd[0], BRCMS_NUM_RATES_OFDM);
 
 	memcpy(&pi->tx_user_target[TXP_FIRST_MCS_20_SISO],
-	       &txpwr->mcs_20_siso[0], WLC_NUM_RATES_MCS_1_STREAM);
+	       &txpwr->mcs_20_siso[0], BRCMS_NUM_RATES_MCS_1_STREAM);
 	memcpy(&pi->tx_user_target[TXP_FIRST_MCS_20_CDD],
-	       &txpwr->mcs_20_cdd[0], WLC_NUM_RATES_MCS_1_STREAM);
+	       &txpwr->mcs_20_cdd[0], BRCMS_NUM_RATES_MCS_1_STREAM);
 	memcpy(&pi->tx_user_target[TXP_FIRST_MCS_20_STBC],
-	       &txpwr->mcs_20_stbc[0], WLC_NUM_RATES_MCS_1_STREAM);
+	       &txpwr->mcs_20_stbc[0], BRCMS_NUM_RATES_MCS_1_STREAM);
 	memcpy(&pi->tx_user_target[TXP_FIRST_MCS_20_SDM],
-	       &txpwr->mcs_20_mimo[0], WLC_NUM_RATES_MCS_2_STREAM);
+	       &txpwr->mcs_20_mimo[0], BRCMS_NUM_RATES_MCS_2_STREAM);
 
 	memcpy(&pi->tx_user_target[TXP_FIRST_MCS_40_SISO],
-	       &txpwr->mcs_40_siso[0], WLC_NUM_RATES_MCS_1_STREAM);
+	       &txpwr->mcs_40_siso[0], BRCMS_NUM_RATES_MCS_1_STREAM);
 	memcpy(&pi->tx_user_target[TXP_FIRST_MCS_40_CDD],
-	       &txpwr->mcs_40_cdd[0], WLC_NUM_RATES_MCS_1_STREAM);
+	       &txpwr->mcs_40_cdd[0], BRCMS_NUM_RATES_MCS_1_STREAM);
 	memcpy(&pi->tx_user_target[TXP_FIRST_MCS_40_STBC],
-	       &txpwr->mcs_40_stbc[0], WLC_NUM_RATES_MCS_1_STREAM);
+	       &txpwr->mcs_40_stbc[0], BRCMS_NUM_RATES_MCS_1_STREAM);
 	memcpy(&pi->tx_user_target[TXP_FIRST_MCS_40_SDM],
-	       &txpwr->mcs_40_mimo[0], WLC_NUM_RATES_MCS_2_STREAM);
+	       &txpwr->mcs_40_mimo[0], BRCMS_NUM_RATES_MCS_2_STREAM);
 
 	if (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC)
 		mac_enabled = true;
@@ -1564,7 +1564,7 @@ wlc_phy_txpower_sromlimit(struct brcms_phy_pub *ppi, uint channel, u8 *min_pwr,
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 	uint i;
 
-	*min_pwr = pi->min_txpower * WLC_TXPWR_DB_FACTOR;
+	*min_pwr = pi->min_txpower * BRCMS_TXPWR_DB_FACTOR;
 
 	if (ISNPHY(pi)) {
 		if (txp_rate_idx < 0)
@@ -1578,7 +1578,7 @@ wlc_phy_txpower_sromlimit(struct brcms_phy_pub *ppi, uint channel, u8 *min_pwr,
 		*max_pwr = pi->tx_srom_max_rate_2g[txp_rate_idx];
 	} else {
 
-		*max_pwr = WLC_TXPWR_MAX;
+		*max_pwr = BRCMS_TXPWR_MAX;
 
 		if (txp_rate_idx < 0)
 			txp_rate_idx = TXP_FIRST_OFDM;
@@ -1670,7 +1670,7 @@ void wlc_phy_txpower_recalc_target(struct brcms_phy *pi)
 	u8 max_num_rate;
 	u8 start_rate = 0;
 	chanspec_t chspec;
-	u32 band = CHSPEC2WLC_BAND(pi->radio_chanspec);
+	u32 band = CHSPEC2BAND(pi->radio_chanspec);
 	initfn_t txpwr_recalc_fn = NULL;
 
 	chspec = pi->radio_chanspec;
@@ -1782,7 +1782,7 @@ void
 wlc_phy_txpower_reg_limit_calc(struct brcms_phy *pi, struct txpwr_limits *txpwr,
 			       chanspec_t chanspec)
 {
-	u8 tmp_txpwr_limit[2 * WLC_NUM_RATES_OFDM];
+	u8 tmp_txpwr_limit[2 * BRCMS_NUM_RATES_OFDM];
 	u8 *txpwr_ptr1 = NULL, *txpwr_ptr2 = NULL;
 	int rate_start_index = 0, rate1, rate2, k;
 
@@ -1825,16 +1825,15 @@ wlc_phy_txpower_reg_limit_calc(struct brcms_phy *pi, struct txpwr_limits *txpwr,
 				break;
 			}
 
-			for (rate2 = 0; rate2 < WLC_NUM_RATES_OFDM; rate2++) {
+			for (rate2 = 0; rate2 < BRCMS_NUM_RATES_OFDM; rate2++) {
 				tmp_txpwr_limit[rate2] = 0;
-				tmp_txpwr_limit[WLC_NUM_RATES_OFDM + rate2] =
+				tmp_txpwr_limit[BRCMS_NUM_RATES_OFDM + rate2] =
 				    txpwr_ptr1[rate2];
 			}
 			wlc_phy_mcs_to_ofdm_powers_nphy(tmp_txpwr_limit, 0,
-							WLC_NUM_RATES_OFDM - 1,
-							WLC_NUM_RATES_OFDM);
+				BRCMS_NUM_RATES_OFDM - 1, BRCMS_NUM_RATES_OFDM);
 			for (rate1 = rate_start_index, rate2 = 0;
-			     rate2 < WLC_NUM_RATES_OFDM; rate1++, rate2++)
+			     rate2 < BRCMS_NUM_RATES_OFDM; rate1++, rate2++)
 				pi->txpwr_limit[rate1] =
 				    min(txpwr_ptr2[rate2],
 					tmp_txpwr_limit[rate2]);
@@ -1867,16 +1866,15 @@ wlc_phy_txpower_reg_limit_calc(struct brcms_phy *pi, struct txpwr_limits *txpwr,
 				rate_start_index = WL_TX_POWER_MCS40_CDD_FIRST;
 				break;
 			}
-			for (rate2 = 0; rate2 < WLC_NUM_RATES_OFDM; rate2++) {
+			for (rate2 = 0; rate2 < BRCMS_NUM_RATES_OFDM; rate2++) {
 				tmp_txpwr_limit[rate2] = 0;
-				tmp_txpwr_limit[WLC_NUM_RATES_OFDM + rate2] =
+				tmp_txpwr_limit[BRCMS_NUM_RATES_OFDM + rate2] =
 				    txpwr_ptr1[rate2];
 			}
 			wlc_phy_ofdm_to_mcs_powers_nphy(tmp_txpwr_limit, 0,
-							WLC_NUM_RATES_OFDM - 1,
-							WLC_NUM_RATES_OFDM);
+				BRCMS_NUM_RATES_OFDM - 1, BRCMS_NUM_RATES_OFDM);
 			for (rate1 = rate_start_index, rate2 = 0;
-			     rate2 < WLC_NUM_RATES_MCS_1_STREAM;
+			     rate2 < BRCMS_NUM_RATES_MCS_1_STREAM;
 			     rate1++, rate2++)
 				pi->txpwr_limit[rate1] =
 				    min(txpwr_ptr2[rate2],
@@ -1897,7 +1895,7 @@ wlc_phy_txpower_reg_limit_calc(struct brcms_phy *pi, struct txpwr_limits *txpwr,
 				break;
 			}
 			for (rate1 = rate_start_index, rate2 = 0;
-			     rate2 < WLC_NUM_RATES_MCS_1_STREAM;
+			     rate2 < BRCMS_NUM_RATES_MCS_1_STREAM;
 			     rate1++, rate2++)
 				pi->txpwr_limit[rate1] = txpwr_ptr1[rate2];
 		}
@@ -1916,7 +1914,7 @@ wlc_phy_txpower_reg_limit_calc(struct brcms_phy *pi, struct txpwr_limits *txpwr,
 				break;
 			}
 			for (rate1 = rate_start_index, rate2 = 0;
-			     rate2 < WLC_NUM_RATES_MCS_2_STREAM;
+			     rate2 < BRCMS_NUM_RATES_MCS_2_STREAM;
 			     rate1++, rate2++)
 				pi->txpwr_limit[rate1] = txpwr_ptr1[rate2];
 		}
@@ -1986,7 +1984,7 @@ wlc_phy_txpower_limit_set(struct brcms_phy_pub *ppi, struct txpwr_limits *txpwr,
 	if (ISLCNPHY(pi)) {
 		int i, j;
 		for (i = TXP_FIRST_OFDM_20_CDD, j = 0;
-		     j < WLC_NUM_RATES_MCS_1_STREAM; i++, j++) {
+		     j < BRCMS_NUM_RATES_MCS_1_STREAM; i++, j++) {
 			if (txpwr->mcs_20_siso[j])
 				pi->txpwr_limit[i] = txpwr->mcs_20_siso[j];
 			else
@@ -2052,7 +2050,7 @@ void wlc_phy_txpower_update_shm(struct brcms_phy *pi)
 		}
 
 		wlapi_bmac_mhf(pi->sh->physhim, MHF2, MHF2_HWPWRCTL,
-			       MHF2_HWPWRCTL, WLC_BAND_ALL);
+			       MHF2_HWPWRCTL, BRCM_BAND_ALL);
 	} else {
 		int i;
 
@@ -2300,10 +2298,10 @@ void wlc_phy_ant_rxdiv_set(struct brcms_phy_pub *ppi, u8 val)
 	if (!(ISNPHY(pi) && D11REV_IS(pi->sh->corerev, 16))) {
 		if (val > ANT_RX_DIV_FORCE_1)
 			wlapi_bmac_mhf(pi->sh->physhim, MHF1, MHF1_ANTDIV,
-				       MHF1_ANTDIV, WLC_BAND_ALL);
+				       MHF1_ANTDIV, BRCM_BAND_ALL);
 		else
 			wlapi_bmac_mhf(pi->sh->physhim, MHF1, MHF1_ANTDIV, 0,
-				       WLC_BAND_ALL);
+				       BRCM_BAND_ALL);
 	}
 
 	if (ISNPHY(pi)) {
@@ -2689,13 +2687,13 @@ void wlc_phy_rssi_compute(struct brcms_phy_pub *pih, void *ctx)
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
 	if (NORADIO_ENAB(pi->pubpi)) {
-		rssi = WLC_RSSI_INVALID;
+		rssi = BRCMS_RSSI_INVALID;
 		goto end;
 	}
 
 	if ((pi->sh->corerev >= 11)
 	    && !(le16_to_cpu(rxh->RxStatus2) & RXS_PHYRXST_VALID)) {
-		rssi = WLC_RSSI_INVALID;
+		rssi = BRCMS_RSSI_INVALID;
 		goto end;
 	}
 
@@ -3191,7 +3189,7 @@ static void wlc_phy_upd_env_txpwr_rate_limits(struct brcms_phy *pi, u32 band)
 	s8 temp, vbat;
 
 	for (i = 0; i < TXP_NUM_RATES; i++)
-		pi->txpwr_env_limit[i] = WLC_TXPWR_MAX;
+		pi->txpwr_env_limit[i] = BRCMS_TXPWR_MAX;
 
 	vbat = wlc_phy_env_measure_vbat(pi);
 	temp = wlc_phy_env_measure_temperature(pi);
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
index e327a57..e27d9e9 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
@@ -87,40 +87,40 @@
 #define PHY_MODE_CAL		0x0002
 #define PHY_MODE_NOISEM		0x0004
 
-#define WLC_TXPWR_DB_FACTOR	4
+#define BRCMS_TXPWR_DB_FACTOR	4
 
 /* a large TX Power as an init value to factor out of min() calculations,
  * keep low enough to fit in an s8, units are .25 dBm
  */
-#define WLC_TXPWR_MAX		(127)	/* ~32 dBm = 1,500 mW */
+#define BRCMS_TXPWR_MAX		(127)	/* ~32 dBm = 1,500 mW */
 
-#define WLC_NUM_RATES_CCK           4
-#define WLC_NUM_RATES_OFDM          8
-#define WLC_NUM_RATES_MCS_1_STREAM  8
-#define WLC_NUM_RATES_MCS_2_STREAM  8
-#define WLC_NUM_RATES_MCS_3_STREAM  8
-#define WLC_NUM_RATES_MCS_4_STREAM  8
+#define BRCMS_NUM_RATES_CCK           4
+#define BRCMS_NUM_RATES_OFDM          8
+#define BRCMS_NUM_RATES_MCS_1_STREAM  8
+#define BRCMS_NUM_RATES_MCS_2_STREAM  8
+#define BRCMS_NUM_RATES_MCS_3_STREAM  8
+#define BRCMS_NUM_RATES_MCS_4_STREAM  8
 
-#define	WLC_RSSI_INVALID	 0	/* invalid RSSI value */
+#define	BRCMS_RSSI_INVALID	 0	/* invalid RSSI value */
 
 struct txpwr_limits {
-	u8 cck[WLC_NUM_RATES_CCK];
-	u8 ofdm[WLC_NUM_RATES_OFDM];
+	u8 cck[BRCMS_NUM_RATES_CCK];
+	u8 ofdm[BRCMS_NUM_RATES_OFDM];
 
-	u8 ofdm_cdd[WLC_NUM_RATES_OFDM];
+	u8 ofdm_cdd[BRCMS_NUM_RATES_OFDM];
 
-	u8 ofdm_40_siso[WLC_NUM_RATES_OFDM];
-	u8 ofdm_40_cdd[WLC_NUM_RATES_OFDM];
+	u8 ofdm_40_siso[BRCMS_NUM_RATES_OFDM];
+	u8 ofdm_40_cdd[BRCMS_NUM_RATES_OFDM];
 
-	u8 mcs_20_siso[WLC_NUM_RATES_MCS_1_STREAM];
-	u8 mcs_20_cdd[WLC_NUM_RATES_MCS_1_STREAM];
-	u8 mcs_20_stbc[WLC_NUM_RATES_MCS_1_STREAM];
-	u8 mcs_20_mimo[WLC_NUM_RATES_MCS_2_STREAM];
+	u8 mcs_20_siso[BRCMS_NUM_RATES_MCS_1_STREAM];
+	u8 mcs_20_cdd[BRCMS_NUM_RATES_MCS_1_STREAM];
+	u8 mcs_20_stbc[BRCMS_NUM_RATES_MCS_1_STREAM];
+	u8 mcs_20_mimo[BRCMS_NUM_RATES_MCS_2_STREAM];
 
-	u8 mcs_40_siso[WLC_NUM_RATES_MCS_1_STREAM];
-	u8 mcs_40_cdd[WLC_NUM_RATES_MCS_1_STREAM];
-	u8 mcs_40_stbc[WLC_NUM_RATES_MCS_1_STREAM];
-	u8 mcs_40_mimo[WLC_NUM_RATES_MCS_2_STREAM];
+	u8 mcs_40_siso[BRCMS_NUM_RATES_MCS_1_STREAM];
+	u8 mcs_40_cdd[BRCMS_NUM_RATES_MCS_1_STREAM];
+	u8 mcs_40_stbc[BRCMS_NUM_RATES_MCS_1_STREAM];
+	u8 mcs_40_mimo[BRCMS_NUM_RATES_MCS_2_STREAM];
 	u8 mcs32;
 };
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
index 4659503..a01b01c 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
@@ -1159,7 +1159,7 @@ extern void wlc_phy_table_write_nphy(struct brcms_phy *pi, u32, u32, u32,
 	((pi->ipa2g_on && CHSPEC_IS2G(pi->radio_chanspec)) || \
 	 (pi->ipa5g_on && CHSPEC_IS5G(pi->radio_chanspec)))
 
-#define WLC_PHY_WAR_PR51571(pi) \
+#define BRCMS_PHY_WAR_PR51571(pi) \
 	if (((pi)->sh->bustype == PCI_BUS) && NREV_LT((pi)->pubpi.phy_rev, 3)) \
 		(void)R_REG(&(pi)->regs->maccontrol)
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
index 70e79fc..8e98d8f 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -1606,15 +1606,15 @@ static void wlc_lcnphy_txpower_reset_npt(struct brcms_phy *pi)
 void wlc_lcnphy_txpower_recalc_target(struct brcms_phy *pi)
 {
 	struct phytbl_info tab;
-	u32 rate_table[WLC_NUM_RATES_CCK + WLC_NUM_RATES_OFDM +
-			  WLC_NUM_RATES_MCS_1_STREAM];
+	u32 rate_table[BRCMS_NUM_RATES_CCK + BRCMS_NUM_RATES_OFDM +
+			  BRCMS_NUM_RATES_MCS_1_STREAM];
 	uint i, j;
 	if (wlc_lcnphy_tempsense_based_pwr_ctrl_enabled(pi))
 		return;
 
 	for (i = 0, j = 0; i < ARRAY_SIZE(rate_table); i++, j++) {
 
-		if (i == WLC_NUM_RATES_CCK + WLC_NUM_RATES_OFDM)
+		if (i == BRCMS_NUM_RATES_CCK + BRCMS_NUM_RATES_OFDM)
 			j = TXP_FIRST_MCS_20_SISO;
 
 		rate_table[i] = (u32) ((s32) (-pi->tx_power_offset[j]));
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
index 2a8c9ff..8e19bd0 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
@@ -14470,7 +14470,7 @@ bool wlc_phy_attach_nphy(struct brcms_phy *pi)
 
 	pi->n_preamble_override = AUTO;
 	if (NREV_IS(pi->pubpi.phy_rev, 3) || NREV_IS(pi->pubpi.phy_rev, 4))
-		pi->n_preamble_override = WLC_N_PREAMBLE_MIXEDMODE;
+		pi->n_preamble_override = BRCMS_N_PREAMBLE_MIXEDMODE;
 
 	pi->nphy_txrx_chain = AUTO;
 	pi->phy_scraminit = AUTO;
@@ -14929,9 +14929,8 @@ static void wlc_phy_update_mimoconfig_nphy(struct brcms_phy *pi, s32 preamble)
 	bool gf_preamble = false;
 	u16 val;
 
-	if (preamble == WLC_N_PREAMBLE_GF) {
+	if (preamble == BRCMS_N_PREAMBLE_GF)
 		gf_preamble = true;
-	}
 
 	val = read_phy_reg(pi, 0xed);
 
@@ -14995,14 +14994,14 @@ void wlc_phy_stf_chain_upd_nphy(struct brcms_phy *pi)
 	    (NPHY_RfseqCoreActv_TxRxChain0 | NPHY_RfseqCoreActv_TxRxChain1);
 	bool CoreActv_override = false;
 
-	if (pi->nphy_txrx_chain == WLC_N_TXRX_CHAIN0) {
+	if (pi->nphy_txrx_chain == BRCMS_N_TXRX_CHAIN0) {
 		txrx_chain = NPHY_RfseqCoreActv_TxRxChain0;
 		CoreActv_override = true;
 
 		if (NREV_LE(pi->pubpi.phy_rev, 2)) {
 			and_phy_reg(pi, 0xa0, ~0x20);
 		}
-	} else if (pi->nphy_txrx_chain == WLC_N_TXRX_CHAIN1) {
+	} else if (pi->nphy_txrx_chain == BRCMS_N_TXRX_CHAIN1) {
 		txrx_chain = NPHY_RfseqCoreActv_TxRxChain1;
 		CoreActv_override = true;
 
@@ -16215,8 +16214,8 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 
 			if (pi->sh->boardflags2 & BFL2_SINGLEANT_CCK) {
 				wlapi_bmac_mhf(pi->sh->physhim, MHF4,
-					       MHF4_BPHY_TXCORE0,
-					       MHF4_BPHY_TXCORE0, WLC_BAND_ALL);
+					MHF4_BPHY_TXCORE0,
+					MHF4_BPHY_TXCORE0, BRCM_BAND_ALL);
 			}
 		}
 	} else {
@@ -16284,7 +16283,7 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 				wlapi_bmac_mhf(pi->sh->physhim, MHF3,
 					       MHF3_NPHY_MLADV_WAR,
 					       MHF3_NPHY_MLADV_WAR,
-					       WLC_BAND_ALL);
+					       BRCM_BAND_ALL);
 
 		} else if (NREV_IS(pi->pubpi.phy_rev, 2)) {
 			write_phy_reg(pi, 0x1e3, 0x0);
@@ -17798,21 +17797,21 @@ wlc_phy_chanspec_radio2055_setup(struct brcms_phy *pi,
 	write_radio_reg(pi, RADIO_2055_RF_PLL_MOD1, ci->RF_rf_pll_mod1);
 	write_radio_reg(pi, RADIO_2055_VCO_CAP_TAIL, ci->RF_vco_cap_tail);
 
-	WLC_PHY_WAR_PR51571(pi);
+	BRCMS_PHY_WAR_PR51571(pi);
 
 	write_radio_reg(pi, RADIO_2055_VCO_CAL1, ci->RF_vco_cal1);
 	write_radio_reg(pi, RADIO_2055_VCO_CAL2, ci->RF_vco_cal2);
 	write_radio_reg(pi, RADIO_2055_PLL_LF_C1, ci->RF_pll_lf_c1);
 	write_radio_reg(pi, RADIO_2055_PLL_LF_R1, ci->RF_pll_lf_r1);
 
-	WLC_PHY_WAR_PR51571(pi);
+	BRCMS_PHY_WAR_PR51571(pi);
 
 	write_radio_reg(pi, RADIO_2055_PLL_LF_C2, ci->RF_pll_lf_c2);
 	write_radio_reg(pi, RADIO_2055_LGBUF_CEN_BUF, ci->RF_lgbuf_cen_buf);
 	write_radio_reg(pi, RADIO_2055_LGEN_TUNE1, ci->RF_lgen_tune1);
 	write_radio_reg(pi, RADIO_2055_LGEN_TUNE2, ci->RF_lgen_tune2);
 
-	WLC_PHY_WAR_PR51571(pi);
+	BRCMS_PHY_WAR_PR51571(pi);
 
 	write_radio_reg(pi, RADIO_2055_CORE1_LGBUF_A_TUNE,
 			ci->RF_core1_lgbuf_a_tune);
@@ -17822,7 +17821,7 @@ wlc_phy_chanspec_radio2055_setup(struct brcms_phy *pi,
 	write_radio_reg(pi, RADIO_2055_CORE1_TX_PGA_PAD_TN,
 			ci->RF_core1_tx_pga_pad_tn);
 
-	WLC_PHY_WAR_PR51571(pi);
+	BRCMS_PHY_WAR_PR51571(pi);
 
 	write_radio_reg(pi, RADIO_2055_CORE1_TX_MX_BGTRIM,
 			ci->RF_core1_tx_mx_bgtrim);
@@ -17832,7 +17831,7 @@ wlc_phy_chanspec_radio2055_setup(struct brcms_phy *pi,
 			ci->RF_core2_lgbuf_g_tune);
 	write_radio_reg(pi, RADIO_2055_CORE2_RXRF_REG1, ci->RF_core2_rxrf_reg1);
 
-	WLC_PHY_WAR_PR51571(pi);
+	BRCMS_PHY_WAR_PR51571(pi);
 
 	write_radio_reg(pi, RADIO_2055_CORE2_TX_PGA_PAD_TN,
 			ci->RF_core2_tx_pga_pad_tn);
@@ -17844,7 +17843,7 @@ wlc_phy_chanspec_radio2055_setup(struct brcms_phy *pi,
 	write_radio_reg(pi, RADIO_2055_VCO_CAL10, 0x05);
 	write_radio_reg(pi, RADIO_2055_VCO_CAL10, 0x45);
 
-	WLC_PHY_WAR_PR51571(pi);
+	BRCMS_PHY_WAR_PR51571(pi);
 
 	write_radio_reg(pi, RADIO_2055_VCO_CAL10, 0x65);
 
@@ -28697,7 +28696,7 @@ void wlc_phy_txpwrctrl_enable_nphy(struct brcms_phy *pi, u8 ctrl_type)
 
 		if (NREV_LT(pi->pubpi.phy_rev, 2) && IS40MHZ(pi))
 			wlapi_bmac_mhf(pi->sh->physhim, MHF1, MHF1_IQSWAP_WAR,
-				       MHF1_IQSWAP_WAR, WLC_BAND_ALL);
+				       MHF1_IQSWAP_WAR, BRCM_BAND_ALL);
 
 	} else {
 
@@ -28756,7 +28755,7 @@ void wlc_phy_txpwrctrl_enable_nphy(struct brcms_phy *pi, u8 ctrl_type)
 
 		if (NREV_LT(pi->pubpi.phy_rev, 2) && IS40MHZ(pi))
 			wlapi_bmac_mhf(pi->sh->physhim, MHF1, MHF1_IQSWAP_WAR,
-				       0x0, WLC_BAND_ALL);
+				       0x0, BRCM_BAND_ALL);
 
 		if (PHY_IPA(pi)) {
 			mod_phy_reg(pi, (0 == PHY_CORE_0) ? 0x297 :
diff --git a/drivers/staging/brcm80211/brcmsmac/phy_shim.c b/drivers/staging/brcm80211/brcmsmac/phy_shim.c
index 12defaa..82ecdcd 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy_shim.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy_shim.c
@@ -178,13 +178,13 @@ void wlapi_bmac_core_phypll_reset(struct phy_shim_info *physhim)
 void wlapi_bmac_ucode_wake_override_phyreg_set(struct phy_shim_info *physhim)
 {
 	brcms_c_ucode_wake_override_set(physhim->wlc_hw,
-					WLC_WAKE_OVERRIDE_PHYREG);
+					BRCMS_WAKE_OVERRIDE_PHYREG);
 }
 
 void wlapi_bmac_ucode_wake_override_phyreg_clear(struct phy_shim_info *physhim)
 {
 	brcms_c_ucode_wake_override_clear(physhim->wlc_hw,
-					  WLC_WAKE_OVERRIDE_PHYREG);
+					  BRCMS_WAKE_OVERRIDE_PHYREG);
 }
 
 void
diff --git a/drivers/staging/brcm80211/brcmsmac/phy_shim.h b/drivers/staging/brcm80211/brcmsmac/phy_shim.h
index 0ac7fa5..2d12bb4 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy_shim.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy_shim.h
@@ -63,9 +63,9 @@
 #define WL_ANT_IDX_2		1	/* antenna index 2 */
 
 /* values for n_preamble_type */
-#define WLC_N_PREAMBLE_MIXEDMODE	0
-#define WLC_N_PREAMBLE_GF		1
-#define WLC_N_PREAMBLE_GF_BRCM          2
+#define BRCMS_N_PREAMBLE_MIXEDMODE	0
+#define BRCMS_N_PREAMBLE_GF		1
+#define BRCMS_N_PREAMBLE_GF_BRCM          2
 
 #define WL_TX_POWER_RATES_LEGACY	45
 #define WL_TX_POWER_MCS20_FIRST	        12
@@ -105,8 +105,8 @@
 #define WL_TX_POWER_F_SISO	8
 
 /* values to force tx/rx chain */
-#define WLC_N_TXRX_CHAIN0		0
-#define WLC_N_TXRX_CHAIN1		1
+#define BRCMS_N_TXRX_CHAIN0		0
+#define BRCMS_N_TXRX_CHAIN1		1
 
 extern struct phy_shim_info *wlc_phy_shim_attach(struct brcms_hardware *wlc_hw,
 						void *wl, void *wlc);
diff --git a/drivers/staging/brcm80211/brcmsmac/pub.h b/drivers/staging/brcm80211/brcmsmac/pub.h
index c1f2fdc..01d7460 100644
--- a/drivers/staging/brcm80211/brcmsmac/pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/pub.h
@@ -21,7 +21,7 @@
 #include "types.h"
 #include "defs.h"
 
-#define	WLC_NUMRATES	16	/* max # of rates in a rateset */
+#define	BRCMS_NUMRATES	16	/* max # of rates in a rateset */
 #define	MAXMULTILIST	32	/* max # multicast addresses */
 #define	D11_PHY_HDR_LEN	6	/* Phy header length - 6 bytes */
 
@@ -36,36 +36,37 @@
 #define	PHY_TYPE_HT	7	/* Phy type 3-Stream N */
 
 /* bw */
-#define WLC_10_MHZ	10	/* 10Mhz nphy channel bandwidth */
-#define WLC_20_MHZ	20	/* 20Mhz nphy channel bandwidth */
-#define WLC_40_MHZ	40	/* 40Mhz nphy channel bandwidth */
+#define BRCMS_10_MHZ	10	/* 10Mhz nphy channel bandwidth */
+#define BRCMS_20_MHZ	20	/* 20Mhz nphy channel bandwidth */
+#define BRCMS_40_MHZ	40	/* 40Mhz nphy channel bandwidth */
 
-#define CHSPEC_WLC_BW(chanspec)	(CHSPEC_IS40(chanspec) ? WLC_40_MHZ : \
-				 CHSPEC_IS20(chanspec) ? WLC_20_MHZ : \
-							 WLC_10_MHZ)
+#define CHSPEC_WLC_BW(chanspec)	(CHSPEC_IS40(chanspec) ? BRCMS_40_MHZ : \
+				 CHSPEC_IS20(chanspec) ? BRCMS_20_MHZ : \
+							 BRCMS_10_MHZ)
 
-#define	WLC_RSSI_MINVAL		-200	/* Low value, e.g. for forcing roam */
-#define	WLC_RSSI_NO_SIGNAL	-91	/* NDIS RSSI link quality cutoffs */
-#define	WLC_RSSI_VERY_LOW	-80	/* Very low quality cutoffs */
-#define	WLC_RSSI_LOW		-70	/* Low quality cutoffs */
-#define	WLC_RSSI_GOOD		-68	/* Good quality cutoffs */
-#define	WLC_RSSI_VERY_GOOD	-58	/* Very good quality cutoffs */
-#define	WLC_RSSI_EXCELLENT	-57	/* Excellent quality cutoffs */
+#define	BRCMS_RSSI_MINVAL	-200	/* Low value, e.g. for forcing roam */
+#define	BRCMS_RSSI_NO_SIGNAL	-91	/* NDIS RSSI link quality cutoffs */
+#define	BRCMS_RSSI_VERY_LOW	-80	/* Very low quality cutoffs */
+#define	BRCMS_RSSI_LOW		-70	/* Low quality cutoffs */
+#define	BRCMS_RSSI_GOOD		-68	/* Good quality cutoffs */
+#define	BRCMS_RSSI_VERY_GOOD	-58	/* Very good quality cutoffs */
+#define	BRCMS_RSSI_EXCELLENT	-57	/* Excellent quality cutoffs */
 
-#define WLC_PHYTYPE(_x) (_x)	/* macro to perform WLC PHY -> D11 PHY TYPE, currently 1:1 */
+/* macro to perform PHY -> D11 PHY TYPE, currently 1:1 */
+#define BRCMS_PHYTYPE(_x) (_x)
 
 #define MA_WINDOW_SZ		8	/* moving average window size */
 
-#define WLC_SNR_INVALID		0	/* invalid SNR value */
+#define BRCMS_SNR_INVALID		0	/* invalid SNR value */
 
 /* a large TX Power as an init value to factor out of min() calculations,
  * keep low enough to fit in an s8, units are .25 dBm
  */
-#define WLC_TXPWR_MAX		(127)	/* ~32 dBm = 1,500 mW */
+#define BRCMS_TXPWR_MAX		(127)	/* ~32 dBm = 1,500 mW */
 
 /* rate related definitions */
-#define	WLC_RATE_FLAG	0x80	/* Flag to indicate it is a basic rate */
-#define	WLC_RATE_MASK	0x7f	/* Rate value mask w/o basic rate flag */
+#define	BRCMS_RATE_FLAG	0x80	/* Flag to indicate it is a basic rate */
+#define	BRCMS_RATE_MASK	0x7f	/* Rate value mask w/o basic rate flag */
 
 /* legacy rx Antenna diversity for SISO rates */
 #define	ANT_RX_DIV_FORCE_0		0	/* Use antenna 0 */
@@ -126,7 +127,8 @@ struct brcms_tunables {
 
 struct brcms_rateset {
 	uint count;		/* number of rates in rates[] */
-	u8 rates[WLC_NUMRATES];	/* rates in 500kbps units w/hi bit set if basic */
+	 /* rates in 500kbps units w/hi bit set if basic */
+	u8 rates[BRCMS_NUMRATES];
 	u8 htphy_membership;	/* HT PHY Membership */
 	u8 mcs[MCSSET_LEN];	/* supported mcs index bit map */
 };
@@ -175,7 +177,7 @@ struct brcms_bss_info {
 	u8 dtim_period;	/* DTIM period */
 	s8 phy_noise;		/* noise right after tx (in dBm) */
 	u16 capability;	/* Capability information */
-	u8 wme_qosinfo;	/* QoS Info from WME IE; valid if WLC_BSS_WME flag set */
+	u8 wme_qosinfo;	/* QoS Info from WME IE; valid if BSS_WME flag set */
 	struct rsn_parms wpa;
 	struct rsn_parms wpa2;
 	u16 qbss_load_aac;	/* qbss load available admission capacity */
@@ -185,17 +187,6 @@ struct brcms_bss_info {
 	u8 wpacfg;		/* wpa config index */
 };
 
-/* brcms_c_ioctl error codes */
-#define WLC_ENOIOCTL	1	/* No such Ioctl */
-#define WLC_EINVAL	2	/* Invalid value */
-#define WLC_ETOOSMALL	3	/* Value too small */
-#define WLC_ETOOBIG	4	/* Value too big */
-#define WLC_ERANGE	5	/* Out of range */
-#define WLC_EDOWN	6	/* Down */
-#define WLC_EUP		7	/* Up */
-#define WLC_ENOMEM	8	/* No Memory */
-#define WLC_EBUSY	9	/* Busy */
-
 /* IOVar flags for common error checks */
 #define IOVF_MFG	(1<<3)	/* flag for mfgtest iovars */
 #define IOVF_WHL	(1<<4)	/* value must be whole (0-max) */
@@ -312,7 +303,7 @@ struct brcms_pub {
 
 	u16 boardrev;	/* version # of particular board */
 	u8 sromrev;		/* version # of the srom */
-	char srom_ccode[WLC_CNTRY_BUF_SZ];	/* Country Code in SROM */
+	char srom_ccode[BRCM_CNTRY_BUF_SZ];	/* Country Code in SROM */
 	u32 boardflags;	/* Board specific flags from srom */
 	u32 boardflags2;	/* More board flags if sromrev >= 4 */
 	bool tempsense_disable;	/* disable periodic tempsense check */
@@ -427,62 +418,64 @@ enum wlc_par_id {
 
 #define PROMISC_ENAB(wlc)	((wlc)->promisc)
 
-#define	WLC_PREC_COUNT		16	/* Max precedence level implemented */
+#define	BRCMS_PREC_COUNT	16	/* Max precedence level implemented */
 
 /* pri is priority encoded in the packet. This maps the Packet priority to
  * enqueue precedence as defined in wlc_prec_map
  */
 extern const u8 wlc_prio2prec_map[];
-#define WLC_PRIO_TO_PREC(pri)	wlc_prio2prec_map[(pri) & 7]
+#define BRCMS_PRIO_TO_PREC(pri)	wlc_prio2prec_map[(pri) & 7]
 
 /* This maps priority to one precedence higher - Used by PS-Poll response packets to
  * simulate enqueue-at-head operation, but still maintain the order on the queue
  */
-#define WLC_PRIO_TO_HI_PREC(pri)	min(WLC_PRIO_TO_PREC(pri) + 1, WLC_PREC_COUNT - 1)
+#define BRCMS_PRIO_TO_HI_PREC(pri)	min(BRCMS_PRIO_TO_PREC(pri) + 1,\
+					    BRCMS_PREC_COUNT - 1)
 
 extern const u8 wme_fifo2ac[];
 #define WME_PRIO2AC(prio)	wme_fifo2ac[prio2fifo[(prio)]]
 
 /* Mask to describe all precedence levels */
-#define WLC_PREC_BMP_ALL		MAXBITVAL(WLC_PREC_COUNT)
+#define BRCMS_PREC_BMP_ALL		MAXBITVAL(BRCMS_PREC_COUNT)
 
 /* Define a bitmap of precedences comprised by each AC */
-#define WLC_PREC_BMP_AC_BE	(NBITVAL(WLC_PRIO_TO_PREC(PRIO_8021D_BE)) |	\
-				NBITVAL(WLC_PRIO_TO_HI_PREC(PRIO_8021D_BE)) |	\
-				NBITVAL(WLC_PRIO_TO_PREC(PRIO_8021D_EE)) |	\
-				NBITVAL(WLC_PRIO_TO_HI_PREC(PRIO_8021D_EE)))
-#define WLC_PREC_BMP_AC_BK	(NBITVAL(WLC_PRIO_TO_PREC(PRIO_8021D_BK)) |	\
-				NBITVAL(WLC_PRIO_TO_HI_PREC(PRIO_8021D_BK)) |	\
-				NBITVAL(WLC_PRIO_TO_PREC(PRIO_8021D_NONE)) |	\
-				NBITVAL(WLC_PRIO_TO_HI_PREC(PRIO_8021D_NONE)))
-#define WLC_PREC_BMP_AC_VI	(NBITVAL(WLC_PRIO_TO_PREC(PRIO_8021D_CL)) |	\
-				NBITVAL(WLC_PRIO_TO_HI_PREC(PRIO_8021D_CL)) |	\
-				NBITVAL(WLC_PRIO_TO_PREC(PRIO_8021D_VI)) |	\
-				NBITVAL(WLC_PRIO_TO_HI_PREC(PRIO_8021D_VI)))
-#define WLC_PREC_BMP_AC_VO	(NBITVAL(WLC_PRIO_TO_PREC(PRIO_8021D_VO)) |	\
-				NBITVAL(WLC_PRIO_TO_HI_PREC(PRIO_8021D_VO)) |	\
-				NBITVAL(WLC_PRIO_TO_PREC(PRIO_8021D_NC)) |	\
-				NBITVAL(WLC_PRIO_TO_HI_PREC(PRIO_8021D_NC)))
+#define BRCMS_PREC_BMP_AC_BE	(NBITVAL(BRCMS_PRIO_TO_PREC(PRIO_8021D_BE)) | \
+			NBITVAL(BRCMS_PRIO_TO_HI_PREC(PRIO_8021D_BE)) |	\
+			NBITVAL(BRCMS_PRIO_TO_PREC(PRIO_8021D_EE)) |	\
+			NBITVAL(BRCMS_PRIO_TO_HI_PREC(PRIO_8021D_EE)))
+#define BRCMS_PREC_BMP_AC_BK	(NBITVAL(BRCMS_PRIO_TO_PREC(PRIO_8021D_BK)) | \
+			NBITVAL(BRCMS_PRIO_TO_HI_PREC(PRIO_8021D_BK)) |	\
+			NBITVAL(BRCMS_PRIO_TO_PREC(PRIO_8021D_NONE)) |	\
+			NBITVAL(BRCMS_PRIO_TO_HI_PREC(PRIO_8021D_NONE)))
+#define BRCMS_PREC_BMP_AC_VI	(NBITVAL(BRCMS_PRIO_TO_PREC(PRIO_8021D_CL)) | \
+			NBITVAL(BRCMS_PRIO_TO_HI_PREC(PRIO_8021D_CL)) |	\
+			NBITVAL(BRCMS_PRIO_TO_PREC(PRIO_8021D_VI)) |	\
+			NBITVAL(BRCMS_PRIO_TO_HI_PREC(PRIO_8021D_VI)))
+#define BRCMS_PREC_BMP_AC_VO	(NBITVAL(BRCMS_PRIO_TO_PREC(PRIO_8021D_VO)) | \
+			NBITVAL(BRCMS_PRIO_TO_HI_PREC(PRIO_8021D_VO)) |	\
+			NBITVAL(BRCMS_PRIO_TO_PREC(PRIO_8021D_NC)) |	\
+			NBITVAL(BRCMS_PRIO_TO_HI_PREC(PRIO_8021D_NC)))
 
 /* WME Support */
 #define WME_ENAB(pub) ((pub)->_wme != OFF)
 #define WME_AUTO(wlc) ((wlc)->pub->_wme == AUTO)
 
-#define WLC_USE_COREFLAGS	0xffffffff	/* invalid core flags, use the saved coreflags */
+/* invalid core flags, use the saved coreflags */
+#define BRCMS_USE_COREFLAGS	0xffffffff
 
 
 /* network protection config */
-#define	WLC_PROT_G_SPEC		1	/* SPEC g protection */
-#define	WLC_PROT_G_OVR		2	/* SPEC g prot override */
-#define	WLC_PROT_G_USER		3	/* gmode specified by user */
-#define	WLC_PROT_OVERLAP	4	/* overlap */
-#define	WLC_PROT_N_USER		10	/* nmode specified by user */
-#define	WLC_PROT_N_CFG		11	/* n protection */
-#define	WLC_PROT_N_CFG_OVR	12	/* n protection override */
-#define	WLC_PROT_N_NONGF	13	/* non-GF protection */
-#define	WLC_PROT_N_NONGF_OVR	14	/* non-GF protection override */
-#define	WLC_PROT_N_PAM_OVR	15	/* n preamble override */
-#define	WLC_PROT_N_OBSS		16	/* non-HT OBSS present */
+#define	BRCMS_PROT_G_SPEC		1	/* SPEC g protection */
+#define	BRCMS_PROT_G_OVR		2	/* SPEC g prot override */
+#define	BRCMS_PROT_G_USER		3	/* gmode specified by user */
+#define	BRCMS_PROT_OVERLAP	4	/* overlap */
+#define	BRCMS_PROT_N_USER		10	/* nmode specified by user */
+#define	BRCMS_PROT_N_CFG		11	/* n protection */
+#define	BRCMS_PROT_N_CFG_OVR	12	/* n protection override */
+#define	BRCMS_PROT_N_NONGF	13	/* non-GF protection */
+#define	BRCMS_PROT_N_NONGF_OVR	14	/* non-GF protection override */
+#define	BRCMS_PROT_N_PAM_OVR	15	/* n preamble override */
+#define	BRCMS_PROT_N_OBSS		16	/* non-HT OBSS present */
 
 /*
  * 54g modes (basic bits may still be overridden)
@@ -519,36 +512,36 @@ extern const u8 wme_fifo2ac[];
 #define GMODE_MAX		6
 
 /* values for PLCPHdr_override */
-#define WLC_PLCP_AUTO	-1
-#define WLC_PLCP_SHORT	0
-#define WLC_PLCP_LONG	1
+#define BRCMS_PLCP_AUTO	-1
+#define BRCMS_PLCP_SHORT	0
+#define BRCMS_PLCP_LONG	1
 
 /* values for g_protection_override and n_protection_override */
-#define WLC_PROTECTION_AUTO		-1
-#define WLC_PROTECTION_OFF		0
-#define WLC_PROTECTION_ON		1
-#define WLC_PROTECTION_MMHDR_ONLY	2
-#define WLC_PROTECTION_CTS_ONLY		3
+#define BRCMS_PROTECTION_AUTO		-1
+#define BRCMS_PROTECTION_OFF		0
+#define BRCMS_PROTECTION_ON		1
+#define BRCMS_PROTECTION_MMHDR_ONLY	2
+#define BRCMS_PROTECTION_CTS_ONLY		3
 
 /* values for g_protection_control and n_protection_control */
-#define WLC_PROTECTION_CTL_OFF		0
-#define WLC_PROTECTION_CTL_LOCAL	1
-#define WLC_PROTECTION_CTL_OVERLAP	2
+#define BRCMS_PROTECTION_CTL_OFF		0
+#define BRCMS_PROTECTION_CTL_LOCAL	1
+#define BRCMS_PROTECTION_CTL_OVERLAP	2
 
 /* values for n_protection */
-#define WLC_N_PROTECTION_OFF		0
-#define WLC_N_PROTECTION_OPTIONAL	1
-#define WLC_N_PROTECTION_20IN40		2
-#define WLC_N_PROTECTION_MIXEDMODE	3
+#define BRCMS_N_PROTECTION_OFF		0
+#define BRCMS_N_PROTECTION_OPTIONAL	1
+#define BRCMS_N_PROTECTION_20IN40		2
+#define BRCMS_N_PROTECTION_MIXEDMODE	3
 
 /* values for band specific 40MHz capabilities */
-#define WLC_N_BW_20ALL			0
-#define WLC_N_BW_40ALL			1
-#define WLC_N_BW_20IN2G_40IN5G		2
+#define BRCMS_N_BW_20ALL			0
+#define BRCMS_N_BW_40ALL			1
+#define BRCMS_N_BW_20IN2G_40IN5G		2
 
 /* bitflags for SGI support (sgi_rx iovar) */
-#define WLC_N_SGI_20			0x01
-#define WLC_N_SGI_40			0x02
+#define BRCMS_N_SGI_20			0x01
+#define BRCMS_N_SGI_40			0x02
 
 /* defines used by the nrate iovar */
 #define NRATE_MCS_INUSE	0x00000080	/* MSC in use,indicates b0-6 holds an mcs */
@@ -667,6 +660,6 @@ extern bool brcms_c_radio_monitor_stop(struct brcms_c_info *wlc);
 #define BAND_5G_NAME		"5G"
 
 /* BMAC RPC: 7 u32 params: pkttotlen, fifo, commit, fid, txpktpend, pktflag, rpc_id */
-#define WLC_RPCTX_PARAMS		32
+#define BRCMS_RPCTX_PARAMS		32
 
 #endif				/* _BRCM_PUB_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/rate.c b/drivers/staging/brcm80211/brcmsmac/rate.c
index 487523e..f0e4b99 100644
--- a/drivers/staging/brcm80211/brcmsmac/rate.c
+++ b/drivers/staging/brcm80211/brcmsmac/rate.c
@@ -22,7 +22,7 @@
 #include "rate.h"
 
 /* Rate info per rate: It tells whether a rate is ofdm or not and its phy_rate value */
-const u8 rate_info[WLC_MAXRATE + 1] = {
+const u8 rate_info[BRCM_MAXRATE + 1] = {
 	/*  0     1     2     3     4     5     6     7     8     9 */
 /*   0 */ 0x00, 0x00, 0x0a, 0x00, 0x14, 0x00, 0x00, 0x00, 0x00, 0x00,
 /*  10 */ 0x00, 0x37, 0x8b, 0x00, 0x00, 0x00, 0x00, 0x00, 0x8f, 0x00,
@@ -41,102 +41,102 @@ const u8 rate_info[WLC_MAXRATE + 1] = {
 const struct brcms_mcs_info mcs_table[MCS_TABLE_SIZE] = {
 	/* MCS  0: SS 1, MOD: BPSK,  CR 1/2 */
 	{6500, 13500, CEIL(6500 * 10, 9), CEIL(13500 * 10, 9), 0x00,
-	 WLC_RATE_6M},
+	 BRCM_RATE_6M},
 	/* MCS  1: SS 1, MOD: QPSK,  CR 1/2 */
 	{13000, 27000, CEIL(13000 * 10, 9), CEIL(27000 * 10, 9), 0x08,
-	 WLC_RATE_12M},
+	 BRCM_RATE_12M},
 	/* MCS  2: SS 1, MOD: QPSK,  CR 3/4 */
 	{19500, 40500, CEIL(19500 * 10, 9), CEIL(40500 * 10, 9), 0x0A,
-	 WLC_RATE_18M},
+	 BRCM_RATE_18M},
 	/* MCS  3: SS 1, MOD: 16QAM, CR 1/2 */
 	{26000, 54000, CEIL(26000 * 10, 9), CEIL(54000 * 10, 9), 0x10,
-	 WLC_RATE_24M},
+	 BRCM_RATE_24M},
 	/* MCS  4: SS 1, MOD: 16QAM, CR 3/4 */
 	{39000, 81000, CEIL(39000 * 10, 9), CEIL(81000 * 10, 9), 0x12,
-	 WLC_RATE_36M},
+	 BRCM_RATE_36M},
 	/* MCS  5: SS 1, MOD: 64QAM, CR 2/3 */
 	{52000, 108000, CEIL(52000 * 10, 9), CEIL(108000 * 10, 9), 0x19,
-	 WLC_RATE_48M},
+	 BRCM_RATE_48M},
 	/* MCS  6: SS 1, MOD: 64QAM, CR 3/4 */
 	{58500, 121500, CEIL(58500 * 10, 9), CEIL(121500 * 10, 9), 0x1A,
-	 WLC_RATE_54M},
+	 BRCM_RATE_54M},
 	/* MCS  7: SS 1, MOD: 64QAM, CR 5/6 */
 	{65000, 135000, CEIL(65000 * 10, 9), CEIL(135000 * 10, 9), 0x1C,
-	 WLC_RATE_54M},
+	 BRCM_RATE_54M},
 	/* MCS  8: SS 2, MOD: BPSK,  CR 1/2 */
 	{13000, 27000, CEIL(13000 * 10, 9), CEIL(27000 * 10, 9), 0x40,
-	 WLC_RATE_6M},
+	 BRCM_RATE_6M},
 	/* MCS  9: SS 2, MOD: QPSK,  CR 1/2 */
 	{26000, 54000, CEIL(26000 * 10, 9), CEIL(54000 * 10, 9), 0x48,
-	 WLC_RATE_12M},
+	 BRCM_RATE_12M},
 	/* MCS 10: SS 2, MOD: QPSK,  CR 3/4 */
 	{39000, 81000, CEIL(39000 * 10, 9), CEIL(81000 * 10, 9), 0x4A,
-	 WLC_RATE_18M},
+	 BRCM_RATE_18M},
 	/* MCS 11: SS 2, MOD: 16QAM, CR 1/2 */
 	{52000, 108000, CEIL(52000 * 10, 9), CEIL(108000 * 10, 9), 0x50,
-	 WLC_RATE_24M},
+	 BRCM_RATE_24M},
 	/* MCS 12: SS 2, MOD: 16QAM, CR 3/4 */
 	{78000, 162000, CEIL(78000 * 10, 9), CEIL(162000 * 10, 9), 0x52,
-	 WLC_RATE_36M},
+	 BRCM_RATE_36M},
 	/* MCS 13: SS 2, MOD: 64QAM, CR 2/3 */
 	{104000, 216000, CEIL(104000 * 10, 9), CEIL(216000 * 10, 9), 0x59,
-	 WLC_RATE_48M},
+	 BRCM_RATE_48M},
 	/* MCS 14: SS 2, MOD: 64QAM, CR 3/4 */
 	{117000, 243000, CEIL(117000 * 10, 9), CEIL(243000 * 10, 9), 0x5A,
-	 WLC_RATE_54M},
+	 BRCM_RATE_54M},
 	/* MCS 15: SS 2, MOD: 64QAM, CR 5/6 */
 	{130000, 270000, CEIL(130000 * 10, 9), CEIL(270000 * 10, 9), 0x5C,
-	 WLC_RATE_54M},
+	 BRCM_RATE_54M},
 	/* MCS 16: SS 3, MOD: BPSK,  CR 1/2 */
 	{19500, 40500, CEIL(19500 * 10, 9), CEIL(40500 * 10, 9), 0x80,
-	 WLC_RATE_6M},
+	 BRCM_RATE_6M},
 	/* MCS 17: SS 3, MOD: QPSK,  CR 1/2 */
 	{39000, 81000, CEIL(39000 * 10, 9), CEIL(81000 * 10, 9), 0x88,
-	 WLC_RATE_12M},
+	 BRCM_RATE_12M},
 	/* MCS 18: SS 3, MOD: QPSK,  CR 3/4 */
 	{58500, 121500, CEIL(58500 * 10, 9), CEIL(121500 * 10, 9), 0x8A,
-	 WLC_RATE_18M},
+	 BRCM_RATE_18M},
 	/* MCS 19: SS 3, MOD: 16QAM, CR 1/2 */
 	{78000, 162000, CEIL(78000 * 10, 9), CEIL(162000 * 10, 9), 0x90,
-	 WLC_RATE_24M},
+	 BRCM_RATE_24M},
 	/* MCS 20: SS 3, MOD: 16QAM, CR 3/4 */
 	{117000, 243000, CEIL(117000 * 10, 9), CEIL(243000 * 10, 9), 0x92,
-	 WLC_RATE_36M},
+	 BRCM_RATE_36M},
 	/* MCS 21: SS 3, MOD: 64QAM, CR 2/3 */
 	{156000, 324000, CEIL(156000 * 10, 9), CEIL(324000 * 10, 9), 0x99,
-	 WLC_RATE_48M},
+	 BRCM_RATE_48M},
 	/* MCS 22: SS 3, MOD: 64QAM, CR 3/4 */
 	{175500, 364500, CEIL(175500 * 10, 9), CEIL(364500 * 10, 9), 0x9A,
-	 WLC_RATE_54M},
+	 BRCM_RATE_54M},
 	/* MCS 23: SS 3, MOD: 64QAM, CR 5/6 */
 	{195000, 405000, CEIL(195000 * 10, 9), CEIL(405000 * 10, 9), 0x9B,
-	 WLC_RATE_54M},
+	 BRCM_RATE_54M},
 	/* MCS 24: SS 4, MOD: BPSK,  CR 1/2 */
 	{26000, 54000, CEIL(26000 * 10, 9), CEIL(54000 * 10, 9), 0xC0,
-	 WLC_RATE_6M},
+	 BRCM_RATE_6M},
 	/* MCS 25: SS 4, MOD: QPSK,  CR 1/2 */
 	{52000, 108000, CEIL(52000 * 10, 9), CEIL(108000 * 10, 9), 0xC8,
-	 WLC_RATE_12M},
+	 BRCM_RATE_12M},
 	/* MCS 26: SS 4, MOD: QPSK,  CR 3/4 */
 	{78000, 162000, CEIL(78000 * 10, 9), CEIL(162000 * 10, 9), 0xCA,
-	 WLC_RATE_18M},
+	 BRCM_RATE_18M},
 	/* MCS 27: SS 4, MOD: 16QAM, CR 1/2 */
 	{104000, 216000, CEIL(104000 * 10, 9), CEIL(216000 * 10, 9), 0xD0,
-	 WLC_RATE_24M},
+	 BRCM_RATE_24M},
 	/* MCS 28: SS 4, MOD: 16QAM, CR 3/4 */
 	{156000, 324000, CEIL(156000 * 10, 9), CEIL(324000 * 10, 9), 0xD2,
-	 WLC_RATE_36M},
+	 BRCM_RATE_36M},
 	/* MCS 29: SS 4, MOD: 64QAM, CR 2/3 */
 	{208000, 432000, CEIL(208000 * 10, 9), CEIL(432000 * 10, 9), 0xD9,
-	 WLC_RATE_48M},
+	 BRCM_RATE_48M},
 	/* MCS 30: SS 4, MOD: 64QAM, CR 3/4 */
 	{234000, 486000, CEIL(234000 * 10, 9), CEIL(486000 * 10, 9), 0xDA,
-	 WLC_RATE_54M},
+	 BRCM_RATE_54M},
 	/* MCS 31: SS 4, MOD: 64QAM, CR 5/6 */
 	{260000, 540000, CEIL(260000 * 10, 9), CEIL(540000 * 10, 9), 0xDB,
-	 WLC_RATE_54M},
+	 BRCM_RATE_54M},
 	/* MCS 32: SS 1, MOD: BPSK,  CR 1/2 */
-	{0, 6000, 0, CEIL(6000 * 10, 9), 0x00, WLC_RATE_6M},
+	{0, 6000, 0, CEIL(6000 * 10, 9), 0x00, BRCM_RATE_6M},
 };
 
 /* phycfg for legacy OFDM frames: code rate, modulation scheme, spatial streams
@@ -155,18 +155,26 @@ struct legacy_phycfg {
 /* 0 = 1Mbps; 1 = 2Mbps; 2 = 5.5Mbps; 3 = 11Mbps */
 static const struct
 legacy_phycfg legacy_phycfg_table[LEGACY_PHYCFG_TABLE_SIZE] = {
-	{WLC_RATE_1M, 0x00},	/* CCK  1Mbps,  data rate  0 */
-	{WLC_RATE_2M, 0x08},	/* CCK  2Mbps,  data rate  1 */
-	{WLC_RATE_5M5, 0x10},	/* CCK  5.5Mbps,  data rate  2 */
-	{WLC_RATE_11M, 0x18},	/* CCK  11Mbps,  data rate   3 */
-	{WLC_RATE_6M, 0x00},	/* OFDM  6Mbps,  code rate 1/2, BPSK,   1 spatial stream */
-	{WLC_RATE_9M, 0x02},	/* OFDM  9Mbps,  code rate 3/4, BPSK,   1 spatial stream */
-	{WLC_RATE_12M, 0x08},	/* OFDM  12Mbps, code rate 1/2, QPSK,   1 spatial stream */
-	{WLC_RATE_18M, 0x0A},	/* OFDM  18Mbps, code rate 3/4, QPSK,   1 spatial stream */
-	{WLC_RATE_24M, 0x10},	/* OFDM  24Mbps, code rate 1/2, 16-QAM, 1 spatial stream */
-	{WLC_RATE_36M, 0x12},	/* OFDM  36Mbps, code rate 3/4, 16-QAM, 1 spatial stream */
-	{WLC_RATE_48M, 0x19},	/* OFDM  48Mbps, code rate 2/3, 64-QAM, 1 spatial stream */
-	{WLC_RATE_54M, 0x1A},	/* OFDM  54Mbps, code rate 3/4, 64-QAM, 1 spatial stream */
+	{BRCM_RATE_1M, 0x00},	/* CCK  1Mbps,  data rate  0 */
+	{BRCM_RATE_2M, 0x08},	/* CCK  2Mbps,  data rate  1 */
+	{BRCM_RATE_5M5, 0x10},	/* CCK  5.5Mbps,  data rate  2 */
+	{BRCM_RATE_11M, 0x18},	/* CCK  11Mbps,  data rate   3 */
+	/* OFDM  6Mbps,  code rate 1/2, BPSK,   1 spatial stream */
+	{BRCM_RATE_6M, 0x00},
+	/* OFDM  9Mbps,  code rate 3/4, BPSK,   1 spatial stream */
+	{BRCM_RATE_9M, 0x02},
+	/* OFDM  12Mbps, code rate 1/2, QPSK,   1 spatial stream */
+	{BRCM_RATE_12M, 0x08},
+	/* OFDM  18Mbps, code rate 3/4, QPSK,   1 spatial stream */
+	{BRCM_RATE_18M, 0x0A},
+	/* OFDM  24Mbps, code rate 1/2, 16-QAM, 1 spatial stream */
+	{BRCM_RATE_24M, 0x10},
+	/* OFDM  36Mbps, code rate 3/4, 16-QAM, 1 spatial stream */
+	{BRCM_RATE_36M, 0x12},
+	/* OFDM  48Mbps, code rate 2/3, 64-QAM, 1 spatial stream */
+	{BRCM_RATE_48M, 0x19},
+	/* OFDM  54Mbps, code rate 3/4, 64-QAM, 1 spatial stream */
+	{BRCM_RATE_54M, 0x1A},
 };
 
 /* Hardware rates (also encodes default basic rates) */
@@ -262,7 +270,7 @@ static bool brcms_c_rateset_valid(wlc_rateset_t *rs, bool check_brate)
 
 	/* error if no basic rates */
 	for (idx = 0; idx < rs->count; idx++) {
-		if (rs->rates[idx] & WLC_RATE_FLAG)
+		if (rs->rates[idx] & BRCMS_RATE_FLAG)
 			return true;
 	}
 	return false;
@@ -283,7 +291,7 @@ brcms_c_rate_hwrs_filter_sort_validate(wlc_rateset_t *rs,
 				   const wlc_rateset_t *hw_rs,
 				   bool check_brate, u8 txstreams)
 {
-	u8 rateset[WLC_MAXRATE + 1];
+	u8 rateset[BRCM_MAXRATE + 1];
 	u8 r;
 	uint count;
 	uint i;
@@ -292,18 +300,17 @@ brcms_c_rate_hwrs_filter_sort_validate(wlc_rateset_t *rs,
 	count = rs->count;
 
 	for (i = 0; i < count; i++) {
-		/* mask off "basic rate" bit, WLC_RATE_FLAG */
-		r = (int)rs->rates[i] & WLC_RATE_MASK;
-		if ((r > WLC_MAXRATE) || (rate_info[r] == 0)) {
+		/* mask off "basic rate" bit, BRCMS_RATE_FLAG */
+		r = (int)rs->rates[i] & BRCMS_RATE_MASK;
+		if ((r > BRCM_MAXRATE) || (rate_info[r] == 0))
 			continue;
-		}
 		rateset[r] = rs->rates[i];	/* preserve basic bit! */
 	}
 
 	/* fill out the rates in order, looking at only supported rates */
 	count = 0;
 	for (i = 0; i < hw_rs->count; i++) {
-		r = hw_rs->rates[i] & WLC_RATE_MASK;
+		r = hw_rs->rates[i] & BRCMS_RATE_MASK;
 		if (rateset[r])
 			rs->rates[count++] = rateset[r];
 	}
@@ -395,18 +402,18 @@ brcms_c_rateset_filter(wlc_rateset_t *src, wlc_rateset_t *dst, bool basic_only,
 	count = 0;
 	for (i = 0; i < src->count; i++) {
 		r = src->rates[i];
-		if (basic_only && !(r & WLC_RATE_FLAG))
+		if (basic_only && !(r & BRCMS_RATE_FLAG))
 			continue;
-		if ((rates == WLC_RATES_CCK) && IS_OFDM((r & WLC_RATE_MASK)))
+		if (rates == BRCMS_RATES_CCK && IS_OFDM((r & BRCMS_RATE_MASK)))
 			continue;
-		if ((rates == WLC_RATES_OFDM) && IS_CCK((r & WLC_RATE_MASK)))
+		if (rates == BRCMS_RATES_OFDM && IS_CCK((r & BRCMS_RATE_MASK)))
 			continue;
 		dst->rates[count++] = r & xmask;
 	}
 	dst->count = count;
 	dst->htphy_membership = src->htphy_membership;
 
-	if (mcsallow && rates != WLC_RATES_CCK)
+	if (mcsallow && rates != BRCMS_RATES_CCK)
 		memcpy(&dst->mcs[0], &src->mcs[0], MCSSET_LEN);
 	else
 		brcms_c_rateset_mcs_clear(dst);
@@ -427,10 +434,10 @@ brcms_c_rateset_default(wlc_rateset_t *rs_tgt, const wlc_rateset_t *rs_hw,
 	    (PHYTYPE_IS(phy_type, PHY_TYPE_LCN)) ||
 	    (PHYTYPE_IS(phy_type, PHY_TYPE_SSN))) {
 		if (BAND_5G(bandtype)) {
-			rs_dflt = (bw == WLC_20_MHZ ?
+			rs_dflt = (bw == BRCMS_20_MHZ ?
 				   &ofdm_mimo_rates : &ofdm_40bw_mimo_rates);
 		} else {
-			rs_dflt = (bw == WLC_20_MHZ ?
+			rs_dflt = (bw == BRCMS_20_MHZ ?
 				   &cck_ofdm_mimo_rates :
 				   &cck_ofdm_40bw_mimo_rates);
 		}
@@ -452,7 +459,7 @@ brcms_c_rateset_default(wlc_rateset_t *rs_tgt, const wlc_rateset_t *rs_hw,
 	brcms_c_rateset_copy(rs_dflt, &rs_sel);
 	brcms_c_rateset_mcs_upd(&rs_sel, txstreams);
 	brcms_c_rateset_filter(&rs_sel, rs_tgt, false,
-			   cck_only ? WLC_RATES_CCK : WLC_RATES_CCK_OFDM,
+			   cck_only ? BRCMS_RATES_CCK : BRCMS_RATES_CCK_OFDM,
 			   rate_mask, mcsallow);
 	brcms_c_rate_hwrs_filter_sort_validate(rs_tgt, rs_hw, false,
 					   mcsallow ? txstreams : 1);
@@ -484,7 +491,7 @@ void brcms_c_rateset_mcs_build(wlc_rateset_t *rateset, u8 txstreams)
 /* Based on bandwidth passed, allow/disallow MCS 32 in the rateset */
 void brcms_c_rateset_bw_mcs_filter(wlc_rateset_t *rateset, u8 bw)
 {
-	if (bw == WLC_40_MHZ)
+	if (bw == BRCMS_40_MHZ)
 		setbit(rateset->mcs, 32);
 	else
 		clrbit(rateset->mcs, 32);
diff --git a/drivers/staging/brcm80211/brcmsmac/rate.h b/drivers/staging/brcm80211/brcmsmac/rate.h
index c3dec35..dbfd3e5 100644
--- a/drivers/staging/brcm80211/brcmsmac/rate.h
+++ b/drivers/staging/brcm80211/brcmsmac/rate.h
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef _WLC_RATE_H_
-#define _WLC_RATE_H_
+#ifndef _BRCM_RATE_H_
+#define _BRCM_RATE_H_
 
 #include "types.h"
 
@@ -38,7 +38,7 @@ struct brcms_mcs_info {
 	u8 leg_ofdm;		/* matching legacy ofdm rate in 500bkps */
 };
 
-#define WLC_MAXMCS	32	/* max valid mcs index */
+#define BRCMS_MAXMCS	32	/* max valid mcs index */
 #define MCS_TABLE_SIZE	33	/* Number of mcs entries in the table */
 extern const struct brcms_mcs_info mcs_table[];
 
@@ -57,9 +57,10 @@ extern const struct brcms_mcs_info mcs_table[];
 #define VALID_MCS(_mcs)	((_mcs < MCS_TABLE_SIZE))
 
 /* Macro to use the rate_info table */
-#define	WLC_RATE_MASK_FULL 0xff	/* Rate value mask with basic rate flag */
+#define	BRCMS_RATE_MASK_FULL 0xff /* Rate value mask with basic rate flag */
 
-#define WLC_RATE_500K_TO_BPS(rate)	((rate) * 500000)	/* convert 500kbps to bps */
+/* convert 500kbps to bps */
+#define BRCMS_RATE_500K_TO_BPS(rate)	((rate) * 500000)
 
 /* rate spec : holds rate and mode specific information required to generate a tx frame. */
 /* Legacy CCK and OFDM information is held in the same manner as was done in the past    */
@@ -81,7 +82,7 @@ extern const struct brcms_mcs_info mcs_table[];
 #define RSPEC_OVERRIDE		0x80000000	/* bit indicates override both rate & mode */
 #define RSPEC_OVERRIDE_MCS_ONLY 0x40000000	/* bit indicates override rate only */
 
-#define WLC_HTPHY		127	/* HT PHY Membership */
+#define BRCMS_HTPHY		127	/* HT PHY Membership */
 
 #define RSPEC_ACTIVE(rspec)	(rspec & (RSPEC_RATE_MASK | RSPEC_MIMORATE))
 #define RSPEC2RATE(rspec)	((rspec & RSPEC_MIMORATE) ? \
@@ -112,12 +113,13 @@ extern const struct brcms_mcs_info mcs_table[];
 
 /* Rate info table; takes a legacy rate or ratespec_t */
 #define	IS_MCS(r)	(r & RSPEC_MIMORATE)
-#define	IS_OFDM(r)	(!IS_MCS(r) && (rate_info[(r) & RSPEC_RATE_MASK] & WLC_RATE_FLAG))
+#define	IS_OFDM(r)	(!IS_MCS(r) && (rate_info[(r) & RSPEC_RATE_MASK] & \
+					BRCMS_RATE_FLAG))
 #define	IS_CCK(r)	(!IS_MCS(r) && ( \
-			 ((r) & WLC_RATE_MASK) == WLC_RATE_1M || \
-			 ((r) & WLC_RATE_MASK) == WLC_RATE_2M || \
-			 ((r) & WLC_RATE_MASK) == WLC_RATE_5M5 || \
-			 ((r) & WLC_RATE_MASK) == WLC_RATE_11M))
+			 ((r) & BRCMS_RATE_MASK) == BRCM_RATE_1M || \
+			 ((r) & BRCMS_RATE_MASK) == BRCM_RATE_2M || \
+			 ((r) & BRCMS_RATE_MASK) == BRCM_RATE_5M5 || \
+			 ((r) & BRCMS_RATE_MASK) == BRCM_RATE_11M))
 #define IS_SINGLE_STREAM(mcs)	(((mcs) <= HIGHEST_SINGLE_STREAM_MCS) || ((mcs) == 32))
 #define CCK_RSPEC(cck)		((cck) & RSPEC_RATE_MASK)
 #define OFDM_RSPEC(ofdm)	(((ofdm) & RSPEC_RATE_MASK) |\
@@ -134,9 +136,9 @@ extern const u8 ofdm_rate_lookup[];
 #define CCK_PHY2MAC_RATE(signal)	(signal/5)
 
 /* Rates specified in brcms_c_rateset_filter() */
-#define WLC_RATES_CCK_OFDM	0
-#define WLC_RATES_CCK		1
-#define WLC_RATES_OFDM		2
+#define BRCMS_RATES_CCK_OFDM	0
+#define BRCMS_RATES_CCK		1
+#define BRCMS_RATES_OFDM		2
 
 /* sanitize, and sort a rateset with the basic bit(s) preserved, validate rateset */
 extern bool
@@ -168,4 +170,4 @@ extern void brcms_c_rateset_mcs_build(struct brcms_rateset *rateset,
 				      u8 txstreams);
 extern void brcms_c_rateset_bw_mcs_filter(struct brcms_rateset *rateset, u8 bw);
 
-#endif				/* _WLC_RATE_H_ */
+#endif				/* _BRCM_RATE_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/stf.c b/drivers/staging/brcm80211/brcmsmac/stf.c
index 6bece8e..a55ff01 100644
--- a/drivers/staging/brcm80211/brcmsmac/stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/stf.c
@@ -28,7 +28,7 @@
 #define MIN_SPATIAL_EXPANSION	0
 #define MAX_SPATIAL_EXPANSION	1
 
-#define WLC_STF_SS_STBC_RX(wlc) (WLCISNPHY(wlc->band) && \
+#define BRCMS_STF_SS_STBC_RX(wlc) (BRCMS_ISNPHY(wlc->band) && \
 	NREV_GT(wlc->band->phyrev, 3) && NREV_LE(wlc->band->phyrev, 6))
 
 static bool brcms_c_stf_stbc_tx_set(struct brcms_c_info *wlc, s32 int_val);
@@ -55,7 +55,7 @@ const u8 txcore_default[5] = {
 static void brcms_c_stf_stbc_rx_ht_update(struct brcms_c_info *wlc, int val)
 {
 	/* MIMOPHYs rev3-6 cannot receive STBC with only one rx core active */
-	if (WLC_STF_SS_STBC_RX(wlc)) {
+	if (BRCMS_STF_SS_STBC_RX(wlc)) {
 		if ((wlc->stf->rxstreams == 1) && (val != HT_CAP_RX_STBC_NO))
 			return;
 	}
@@ -145,7 +145,7 @@ static bool brcms_c_stf_stbc_tx_set(struct brcms_c_info *wlc, s32 int_val)
 		return false;
 
 	if ((int_val == OFF) || (wlc->stf->txstreams == 1)
-	    || !WLC_STBC_CAP_PHY(wlc))
+	    || !BRCMS_STBC_CAP_PHY(wlc))
 		wlc->ht_cap.cap_info &= ~IEEE80211_HT_CAP_TX_STBC;
 	else
 		wlc->ht_cap.cap_info |= IEEE80211_HT_CAP_TX_STBC;
@@ -163,7 +163,7 @@ bool brcms_c_stf_stbc_rx_set(struct brcms_c_info *wlc, s32 int_val)
 		return false;
 	}
 
-	if (WLC_STF_SS_STBC_RX(wlc)) {
+	if (BRCMS_STF_SS_STBC_RX(wlc)) {
 		if ((int_val != HT_CAP_RX_STBC_NO)
 		    && (wlc->stf->rxstreams == 1))
 			return false;
@@ -179,11 +179,11 @@ static int brcms_c_stf_txcore_set(struct brcms_c_info *wlc, u8 Nsts,
 	BCMMSG(wlc->wiphy, "wl%d: Nsts %d core_mask %x\n",
 		 wlc->pub->unit, Nsts, core_mask);
 
-	if (WLC_BITSCNT(core_mask) > wlc->stf->txstreams) {
+	if (BRCMS_BITSCNT(core_mask) > wlc->stf->txstreams) {
 		core_mask = 0;
 	}
 
-	if ((WLC_BITSCNT(core_mask) == wlc->stf->txstreams) &&
+	if ((BRCMS_BITSCNT(core_mask) == wlc->stf->txstreams) &&
 	    ((core_mask & ~wlc->stf->txchain)
 	     || !(core_mask & wlc->stf->txchain))) {
 		core_mask = wlc->stf->txchain;
@@ -237,7 +237,7 @@ int brcms_c_stf_txchain_set(struct brcms_c_info *wlc, s32 int_val, bool force)
 		return -EINVAL;
 
 	/* if nrate override is configured to be non-SISO STF mode, reject reducing txchain to 1 */
-	txstreams = (u8) WLC_BITSCNT(txchain);
+	txstreams = (u8) BRCMS_BITSCNT(txchain);
 	if (txstreams > MAX_STREAMS_SUPPORTED)
 		return -EINVAL;
 
@@ -299,7 +299,7 @@ int brcms_c_stf_ss_update(struct brcms_c_info *wlc, struct brcms_band *band)
 	prev_stf_ss = wlc->stf->ss_opmode;
 
 	/* NOTE: opmode can only be SISO or CDD as STBC is decided on a per-packet basis */
-	if (WLC_STBC_CAP_PHY(wlc) &&
+	if (BRCMS_STBC_CAP_PHY(wlc) &&
 	    wlc->stf->ss_algosel_auto
 	    && (wlc->stf->ss_algo_channel != (u16) -1)) {
 		upd_stf_ss = (wlc->stf->no_cddstbc || (wlc->stf->txstreams == 1)
@@ -327,7 +327,7 @@ int brcms_c_stf_attach(struct brcms_c_info *wlc)
 	wlc->bandstate[BAND_2G_INDEX]->band_stf_ss_mode = PHY_TXC1_MODE_SISO;
 	wlc->bandstate[BAND_5G_INDEX]->band_stf_ss_mode = PHY_TXC1_MODE_CDD;
 
-	if (WLCISNPHY(wlc->band) &&
+	if (BRCMS_ISNPHY(wlc->band) &&
 	    (wlc_phy_txpower_hw_ctrl_get(wlc->band->pi) != PHY_TPC_HW_ON))
 		wlc->bandstate[BAND_2G_INDEX]->band_stf_ss_mode =
 		    PHY_TXC1_MODE_CDD;
@@ -338,7 +338,7 @@ int brcms_c_stf_attach(struct brcms_c_info *wlc)
 	wlc->bandstate[BAND_2G_INDEX]->band_stf_stbc_tx = OFF;
 	wlc->bandstate[BAND_5G_INDEX]->band_stf_stbc_tx = OFF;
 
-	if (WLC_STBC_CAP_PHY(wlc)) {
+	if (BRCMS_STBC_CAP_PHY(wlc)) {
 		wlc->stf->ss_algosel_auto = true;
 		wlc->stf->ss_algo_channel = (u16) -1;	/* Init the default value */
 	}
@@ -368,19 +368,20 @@ static void _brcms_c_stf_phy_txant_upd(struct brcms_c_info *wlc)
 	s8 txant;
 
 	txant = (s8) wlc->stf->txant;
-	if (WLC_PHY_11N_CAP(wlc->band)) {
+	if (BRCMS_PHY_11N_CAP(wlc->band)) {
 		if (txant == ANT_TX_FORCE_0) {
 			wlc->stf->phytxant = PHY_TXC_ANT_0;
 		} else if (txant == ANT_TX_FORCE_1) {
 			wlc->stf->phytxant = PHY_TXC_ANT_1;
 
-			if (WLCISNPHY(wlc->band) &&
+			if (BRCMS_ISNPHY(wlc->band) &&
 			    NREV_GE(wlc->band->phyrev, 3)
 			    && NREV_LT(wlc->band->phyrev, 7)) {
 				wlc->stf->phytxant = PHY_TXC_ANT_2;
 			}
 		} else {
-			if (WLCISLCNPHY(wlc->band) || WLCISSSLPNPHY(wlc->band))
+			if (BRCMS_ISLCNPHY(wlc->band) ||
+			    BRCMS_ISSSLPNPHY(wlc->band))
 				wlc->stf->phytxant = PHY_TXC_LCNPHY_ANT_LAST;
 			else {
 				/* catch out of sync wlc->stf->txcore */
@@ -414,7 +415,7 @@ void brcms_c_stf_phy_chain_calc(struct brcms_c_info *wlc)
 
 	/* these parameter are intended to be used for all PHY types */
 	if (wlc->stf->hw_txchain == 0 || wlc->stf->hw_txchain == 0xf) {
-		if (WLCISNPHY(wlc->band)) {
+		if (BRCMS_ISNPHY(wlc->band)) {
 			wlc->stf->hw_txchain = TXCHAIN_DEF_NPHY;
 		} else {
 			wlc->stf->hw_txchain = TXCHAIN_DEF;
@@ -422,10 +423,10 @@ void brcms_c_stf_phy_chain_calc(struct brcms_c_info *wlc)
 	}
 
 	wlc->stf->txchain = wlc->stf->hw_txchain;
-	wlc->stf->txstreams = (u8) WLC_BITSCNT(wlc->stf->hw_txchain);
+	wlc->stf->txstreams = (u8) BRCMS_BITSCNT(wlc->stf->hw_txchain);
 
 	if (wlc->stf->hw_rxchain == 0 || wlc->stf->hw_rxchain == 0xf) {
-		if (WLCISNPHY(wlc->band)) {
+		if (BRCMS_ISNPHY(wlc->band)) {
 			wlc->stf->hw_rxchain = RXCHAIN_DEF_NPHY;
 		} else {
 			wlc->stf->hw_rxchain = RXCHAIN_DEF;
@@ -433,7 +434,7 @@ void brcms_c_stf_phy_chain_calc(struct brcms_c_info *wlc)
 	}
 
 	wlc->stf->rxchain = wlc->stf->hw_rxchain;
-	wlc->stf->rxstreams = (u8) WLC_BITSCNT(wlc->stf->hw_rxchain);
+	wlc->stf->rxstreams = (u8) BRCMS_BITSCNT(wlc->stf->hw_rxchain);
 
 	/* initialize the txcore table */
 	memcpy(wlc->stf->txcore, txcore_default, sizeof(wlc->stf->txcore));
@@ -467,7 +468,7 @@ u16 brcms_c_stf_d11hdrs_phyctl_txant(struct brcms_c_info *wlc, ratespec_t rspec)
 	u16 mask = PHY_TXC_ANT_MASK;
 
 	/* for non-siso rates or default setting, use the available chains */
-	if (WLCISNPHY(wlc->band)) {
+	if (BRCMS_ISNPHY(wlc->band)) {
 		phytxant = _brcms_c_stf_phytxchain_sel(wlc, rspec);
 		mask = PHY_TXC_HTANT_MASK;
 	}
diff --git a/drivers/staging/brcm80211/brcmsmac/types.h b/drivers/staging/brcm80211/brcmsmac/types.h
index 17c1d8a..d8514c3 100644
--- a/drivers/staging/brcm80211/brcmsmac/types.h
+++ b/drivers/staging/brcm80211/brcmsmac/types.h
@@ -191,11 +191,11 @@
 	 PHYTYPE_IS(phytype, PHY_TYPE_SSN))
 
 /* Last but not least: shorter wlc-specific var checks */
-#define WLCISNPHY(band)		PHYTYPE_IS((band)->phytype, PHY_TYPE_N)
-#define WLCISLCNPHY(band)	PHYTYPE_IS((band)->phytype, PHY_TYPE_LCN)
-#define WLCISSSLPNPHY(band)	PHYTYPE_IS((band)->phytype, PHY_TYPE_SSN)
+#define BRCMS_ISNPHY(band)		PHYTYPE_IS((band)->phytype, PHY_TYPE_N)
+#define BRCMS_ISLCNPHY(band)	PHYTYPE_IS((band)->phytype, PHY_TYPE_LCN)
+#define BRCMS_ISSSLPNPHY(band)	PHYTYPE_IS((band)->phytype, PHY_TYPE_SSN)
 
-#define WLC_PHY_11N_CAP(band)	PHYTYPE_11N_CAP((band)->phytype)
+#define BRCMS_PHY_11N_CAP(band)	PHYTYPE_11N_CAP((band)->phytype)
 
 /**********************************************************************
  * ------------- End of Core phy/rev configuration. ----------------- *
@@ -227,12 +227,18 @@
 #define MAXPKTCB	MAXSCB	/* Max number of packet callbacks */
 
 /* NetBSD also needs to keep track of this */
-#define WLC_MAX_UCODE_BSS	(16)	/* Number of BSS handled in ucode bcn/prb */
-#define WLC_MAX_UCODE_BSS4	(4)	/* Number of BSS handled in sw bcn/prb */
-#define WLC_MAXBSSCFG		(1)	/* max # BSS configs */
-#define MAXBSS		64	/* max # available networks */
-#define WLC_DATAHIWAT		50	/* data msg txq hiwat mark */
-#define WLC_AMPDUDATAHIWAT 255
+
+/* Number of BSS handled in ucode bcn/prb */
+#define BRCMS_MAX_UCODE_BSS	(16)
+/* Number of BSS handled in sw bcn/prb */
+#define BRCMS_MAX_UCODE_BSS4	(4)
+/* max # BSS configs */
+#define BRCMS_MAXBSSCFG		(1)
+/* max # available networks */
+#define MAXBSS		64
+/* data msg txq hiwat mark */
+#define BRCMS_DATAHIWAT		50
+#define BRCMS_AMPDUDATAHIWAT 255
 
 /* bounded rx loops */
 #define RXBND		8	/* max # frames to process in brcms_c_recv() */
@@ -240,8 +246,8 @@
 
 #define WLBANDINITFN(_fn)	_fn
 
-#define BAND_5G(bt)	((bt) == WLC_BAND_5G)
-#define BAND_2G(bt)	((bt) == WLC_BAND_2G)
+#define BAND_5G(bt)	((bt) == BRCM_BAND_5G)
+#define BAND_2G(bt)	((bt) == BRCM_BAND_2G)
 
 #define BCMMSG(dev, fmt, args...)		\
 do {						\
diff --git a/drivers/staging/brcm80211/include/brcmu_wifi.h b/drivers/staging/brcm80211/include/brcmu_wifi.h
index 72013a4..fde592b 100644
--- a/drivers/staging/brcm80211/include/brcmu_wifi.h
+++ b/drivers/staging/brcm80211/include/brcmu_wifi.h
@@ -31,7 +31,7 @@ typedef u16 chanspec_t;
 #define CH_10MHZ_APART			2
 #define CH_5MHZ_APART			1	/* 2G band channels are 5 Mhz apart */
 #define CH_MAX_2G_CHANNEL		14	/* Max channel in 2G band */
-#define WLC_MAX_2G_CHANNEL		CH_MAX_2G_CHANNEL	/* legacy define */
+#define BRCM_MAX_2G_CHANNEL	CH_MAX_2G_CHANNEL	/* legacy define */
 #define	MAXCHANNEL		224	/* max # supported channels. The max channel no is 216,
 					 * this is that + 1 rounded up to a multiple of NBBY (8).
 					 * DO NOT MAKE it > 255: channels are u8's all over
@@ -67,7 +67,8 @@ typedef u16 chanspec_t;
 #define LOWER_20_SB(channel)	(((channel) > CH_10MHZ_APART) ? ((channel) - CH_10MHZ_APART) : 0)
 #define UPPER_20_SB(channel)	(((channel) < (MAXCHANNEL - CH_10MHZ_APART)) ? \
 				((channel) + CH_10MHZ_APART) : 0)
-#define CHSPEC_WLCBANDUNIT(chspec)	(CHSPEC_IS5G(chspec) ? BAND_5G_INDEX : BAND_2G_INDEX)
+#define CHSPEC_BANDUNIT(chspec)	(CHSPEC_IS5G(chspec) ? BAND_5G_INDEX : \
+						       BAND_2G_INDEX)
 #define CH20MHZ_CHSPEC(channel)	(chanspec_t)((chanspec_t)(channel) | WL_CHANSPEC_BW_20 | \
 				WL_CHANSPEC_CTL_SB_NONE | (((channel) <= CH_MAX_2G_CHANNEL) ? \
 				WL_CHANSPEC_BAND_2G : WL_CHANSPEC_BAND_5G))
@@ -110,26 +111,26 @@ typedef u16 chanspec_t;
 #define CHSPEC_CTL_CHAN(chspec)  ((CHSPEC_SB_LOWER(chspec)) ? \
 				  (LOWER_20_SB(((chspec) & WL_CHANSPEC_CHAN_MASK))) : \
 				  (UPPER_20_SB(((chspec) & WL_CHANSPEC_CHAN_MASK))))
-#define CHSPEC2WLC_BAND(chspec) (CHSPEC_IS5G(chspec) ? WLC_BAND_5G : WLC_BAND_2G)
+#define CHSPEC2BAND(chspec) (CHSPEC_IS5G(chspec) ? BRCM_BAND_5G : BRCM_BAND_2G)
 
 #define CHANSPEC_STR_LEN    8
 
 /* defined rate in 500kbps */
-#define WLC_MAXRATE	108	/* in 500kbps units */
-#define WLC_RATE_1M	2	/* in 500kbps units */
-#define WLC_RATE_2M	4	/* in 500kbps units */
-#define WLC_RATE_5M5	11	/* in 500kbps units */
-#define WLC_RATE_11M	22	/* in 500kbps units */
-#define WLC_RATE_6M	12	/* in 500kbps units */
-#define WLC_RATE_9M	18	/* in 500kbps units */
-#define WLC_RATE_12M	24	/* in 500kbps units */
-#define WLC_RATE_18M	36	/* in 500kbps units */
-#define WLC_RATE_24M	48	/* in 500kbps units */
-#define WLC_RATE_36M	72	/* in 500kbps units */
-#define WLC_RATE_48M	96	/* in 500kbps units */
-#define WLC_RATE_54M	108	/* in 500kbps units */
-
-#define WLC_2G_25MHZ_OFFSET		5	/* 2.4GHz band channel offset */
+#define BRCM_MAXRATE	108	/* in 500kbps units */
+#define BRCM_RATE_1M	2	/* in 500kbps units */
+#define BRCM_RATE_2M	4	/* in 500kbps units */
+#define BRCM_RATE_5M5	11	/* in 500kbps units */
+#define BRCM_RATE_11M	22	/* in 500kbps units */
+#define BRCM_RATE_6M	12	/* in 500kbps units */
+#define BRCM_RATE_9M	18	/* in 500kbps units */
+#define BRCM_RATE_12M	24	/* in 500kbps units */
+#define BRCM_RATE_18M	36	/* in 500kbps units */
+#define BRCM_RATE_24M	48	/* in 500kbps units */
+#define BRCM_RATE_36M	72	/* in 500kbps units */
+#define BRCM_RATE_48M	96	/* in 500kbps units */
+#define BRCM_RATE_54M	108	/* in 500kbps units */
+
+#define BRCM_2G_25MHZ_OFFSET		5	/* 2.4GHz band channel offset */
 
 #define MCSSET_LEN	16
 
diff --git a/drivers/staging/brcm80211/include/defs.h b/drivers/staging/brcm80211/include/defs.h
index 20e1407..8b3e17d 100644
--- a/drivers/staging/brcm80211/include/defs.h
+++ b/drivers/staging/brcm80211/include/defs.h
@@ -59,16 +59,16 @@ typedef struct wl_rateset {
 	u8 rates[WL_NUMRATES];	/* rates in 500kbps units w/hi bit set if basic */
 } wl_rateset_t;
 
-#define WLC_CNTRY_BUF_SZ	4	/* Country string is 3 bytes + NUL */
+#define BRCM_CNTRY_BUF_SZ	4	/* Country string is 3 bytes + NUL */
 
-#define WLC_SET_CHANNEL				30
-#define WLC_SET_SRL				32
-#define WLC_SET_LRL				34
+#define BRCM_SET_CHANNEL				30
+#define BRCM_SET_SRL				32
+#define BRCM_SET_LRL				34
 
-#define WLC_SET_RATESET				72
-#define WLC_SET_BCNPRD				76
-#define WLC_GET_CURR_RATESET			114	/* current rateset */
-#define WLC_GET_PHYLIST				180
+#define BRCM_SET_RATESET				72
+#define BRCM_SET_BCNPRD				76
+#define BRCM_GET_CURR_RATESET			114	/* current rateset */
+#define BRCM_GET_PHYLIST				180
 
 /* Bit masks for radio disabled status - returned by WL_GET_RADIO */
 #define WL_RADIO_SW_DISABLE		(1<<0)
@@ -76,14 +76,14 @@ typedef struct wl_rateset {
 #define WL_RADIO_MPC_DISABLE		(1<<2)
 #define WL_RADIO_COUNTRY_DISABLE	(1<<3)	/* some countries don't support any channel */
 
-/* Override bit for WLC_SET_TXPWR.  if set, ignore other level limits */
+/* Override bit for SET_TXPWR.  if set, ignore other level limits */
 #define WL_TXPWR_OVERRIDE	(1U<<31)
 
 /* band types */
-#define	WLC_BAND_AUTO		0	/* auto-select */
-#define	WLC_BAND_5G		1	/* 5 Ghz */
-#define	WLC_BAND_2G		2	/* 2.4 Ghz */
-#define	WLC_BAND_ALL		3	/* all bands */
+#define	BRCM_BAND_AUTO		0	/* auto-select */
+#define	BRCM_BAND_5G		1	/* 5 Ghz */
+#define	BRCM_BAND_2G		2	/* 2.4 Ghz */
+#define	BRCM_BAND_ALL		3	/* all bands */
 
 /* Values for PM */
 #define PM_OFF	0
-- 
1.7.4.1


