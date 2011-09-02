Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2156 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349Ab1IBOA6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Sep 2011 10:00:58 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 10/12] staging: brcm80211: cleaned up softmac pub.h
 macro's
Date: Fri, 2 Sep 2011 16:00:37 +0200
Message-ID: <1314972039-27098-11-git-send-email-rvossen@broadcom.com> (sfid-20110902_160127_396940_F564648C)
In-Reply-To: <1314972039-27098-1-git-send-email-rvossen@broadcom.com>
References: <1314972039-27098-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Substituted/removed macro's.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/ampdu.c   |    2 +-
 drivers/staging/brcm80211/brcmsmac/channel.c |    6 +-
 drivers/staging/brcm80211/brcmsmac/main.c    |   84 +++++++++++++++++----
 drivers/staging/brcm80211/brcmsmac/pub.h     |  108 ++++----------------------
 drivers/staging/brcm80211/brcmsmac/scb.h     |    4 +-
 5 files changed, 92 insertions(+), 112 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/ampdu.c b/drivers/staging/brcm80211/brcmsmac/ampdu.c
index cbf6c6d..7c44598 100644
--- a/drivers/staging/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/ampdu.c
@@ -180,7 +180,7 @@ static int brcms_c_ampdu_set(struct ampdu_info *ampdu, bool on)
 	wlc->pub->_ampdu = false;
 
 	if (on) {
-		if (!N_ENAB(wlc->pub)) {
+		if (!(wlc->pub->_n_enab & SUPPORT_11N)) {
 			wiphy_err(ampdu->wlc->wiphy, "wl%d: driver not "
 				"nmode enabled\n", wlc->pub->unit);
 			return -ENOTSUPP;
diff --git a/drivers/staging/brcm80211/brcmsmac/channel.c b/drivers/staging/brcm80211/brcmsmac/channel.c
index e6afdc9..282adce 100644
--- a/drivers/staging/brcm80211/brcmsmac/channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/channel.c
@@ -1010,7 +1010,8 @@ brcms_c_set_country_common(struct brcms_cm_info *wlc_cm,
 		wlc->stf->no_cddstbc = true;
 	} else {
 		wlc->stf->no_cddstbc = false;
-		if (N_ENAB(wlc->pub) != wlc->protection->nmode_user)
+		if ((wlc->pub->_n_enab & SUPPORT_11N) !=
+		    wlc->protection->nmode_user)
 			brcms_c_set_nmode(wlc, wlc->protection->nmode_user);
 	}
 
@@ -1137,7 +1138,8 @@ brcms_c_channel_locale_flags_in_band(struct brcms_cm_info *wlc_cm,
 static bool
 brcms_c_quiet_chanspec(struct brcms_cm_info *wlc_cm, u16 chspec)
 {
-	return N_ENAB(wlc_cm->wlc->pub) && CHSPEC_IS40(chspec) ?
+	return (wlc_cm->wlc->pub->_n_enab & SUPPORT_11N) &&
+		CHSPEC_IS40(chspec) ?
 		(isset(wlc_cm->quiet_channels.vec,
 		       LOWER_20_SB(CHSPEC_CHANNEL(chspec))) ||
 		 isset(wlc_cm->quiet_channels.vec,
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 4de57f4..4436b4f 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -271,6 +271,64 @@
 #define	WL_SPURAVOID_ON1	1
 #define	WL_SPURAVOID_ON2	2
 
+/* invalid core flags, use the saved coreflags */
+#define BRCMS_USE_COREFLAGS	0xffffffff
+
+/* values for PLCPHdr_override */
+#define BRCMS_PLCP_AUTO	-1
+#define BRCMS_PLCP_SHORT	0
+#define BRCMS_PLCP_LONG	1
+
+/* values for g_protection_override and n_protection_override */
+#define BRCMS_PROTECTION_AUTO		-1
+#define BRCMS_PROTECTION_OFF		0
+#define BRCMS_PROTECTION_ON		1
+#define BRCMS_PROTECTION_MMHDR_ONLY	2
+#define BRCMS_PROTECTION_CTS_ONLY		3
+
+/* values for g_protection_control and n_protection_control */
+#define BRCMS_PROTECTION_CTL_OFF		0
+#define BRCMS_PROTECTION_CTL_LOCAL	1
+#define BRCMS_PROTECTION_CTL_OVERLAP	2
+
+/* values for n_protection */
+#define BRCMS_N_PROTECTION_OFF		0
+#define BRCMS_N_PROTECTION_OPTIONAL	1
+#define BRCMS_N_PROTECTION_20IN40		2
+#define BRCMS_N_PROTECTION_MIXEDMODE	3
+
+/* values for band specific 40MHz capabilities */
+#define BRCMS_N_BW_20ALL			0
+#define BRCMS_N_BW_40ALL			1
+#define BRCMS_N_BW_20IN2G_40IN5G		2
+
+/* bitflags for SGI support (sgi_rx iovar) */
+#define BRCMS_N_SGI_20			0x01
+#define BRCMS_N_SGI_40			0x02
+
+/* defines used by the nrate iovar */
+/* MSC in use,indicates b0-6 holds an mcs */
+#define NRATE_MCS_INUSE	0x00000080
+/* rate/mcs value */
+#define NRATE_RATE_MASK 0x0000007f
+/* stf mode mask: siso, cdd, stbc, sdm */
+#define NRATE_STF_MASK	0x0000ff00
+/* stf mode shift */
+#define NRATE_STF_SHIFT	8
+/* bit indicates override both rate & mode */
+#define NRATE_OVERRIDE	0x80000000
+/* bit indicate to override mcs only */
+#define NRATE_OVERRIDE_MCS_ONLY 0x40000000
+#define NRATE_SGI_MASK  0x00800000	/* sgi mode */
+#define NRATE_SGI_SHIFT 23	/* sgi mode */
+#define NRATE_LDPC_CODING 0x00400000	/* bit indicates adv coding in use */
+#define NRATE_LDPC_SHIFT 22	/* ldpc shift */
+
+#define NRATE_STF_SISO	0	/* stf mode SISO */
+#define NRATE_STF_CDD	1	/* stf mode CDD */
+#define NRATE_STF_STBC	2	/* stf mode STBC */
+#define NRATE_STF_SDM	3	/* stf mode SDM */
+
 /*
  * 32 SSID chars, max of 4 chars for each SSID char "\xFF", plus NULL.
  */
@@ -3323,7 +3381,7 @@ static void brcms_c_bandinit_ordered(struct brcms_c_info *wlc,
 		/* fill in hw_rate */
 		brcms_c_rateset_filter(&default_rateset, &wlc->band->hw_rateset,
 				   false, BRCMS_RATES_CCK_OFDM, BRCMS_RATE_MASK,
-				   (bool) N_ENAB(wlc->pub));
+				   (bool) (wlc->pub->_n_enab & SUPPORT_11N));
 
 		/* init basic rate lookup */
 		brcms_c_rate_lookup_init(wlc, &default_rateset);
@@ -3608,14 +3666,14 @@ void brcms_c_mac_promisc(struct brcms_c_info *wlc)
 	 * the MCTL_PROMISC bit since all BSS data traffic is
 	 * directed at the AP
 	 */
-	if (PROMISC_ENAB(wlc->pub))
+	if (wlc->pub->promisc)
 		promisc_bits |= MCTL_PROMISC;
 
 	/* monitor mode needs both MCTL_PROMISC and MCTL_KEEPCONTROL
 	 * Note: monitor mode also needs MCTL_BCNS_PROMISC, but that is
 	 * handled in brcms_c_mac_bcn_promisc()
 	 */
-	if (MONITOR_ENAB(wlc))
+	if (wlc->monitor)
 		promisc_bits |= MCTL_PROMISC | MCTL_KEEPCONTROL;
 
 	brcms_c_mctrl(wlc, MCTL_PROMISC | MCTL_KEEPCONTROL, promisc_bits);
@@ -4925,10 +4983,10 @@ static void brcms_c_bss_default_init(struct brcms_c_info *wlc)
 	/* init bss rates to the band specific default rate set */
 	brcms_c_rateset_default(&bi->rateset, NULL, band->phytype,
 		band->bandtype, false, BRCMS_RATE_MASK_FULL,
-		(bool) N_ENAB(wlc->pub), CHSPEC_WLC_BW(chanspec),
-		wlc->stf->txstreams);
+		(bool) (wlc->pub->_n_enab & SUPPORT_11N),
+		CHSPEC_WLC_BW(chanspec), wlc->stf->txstreams);
 
-	if (N_ENAB(wlc->pub))
+	if (wlc->pub->_n_enab & SUPPORT_11N)
 		bi->flags |= BRCMS_BSS_HT;
 }
 
@@ -5139,7 +5197,7 @@ brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 		brcms_c_rateset_filter(&wlc->band->defrateset,
 				   &wlc->band->hw_rateset, false,
 				   BRCMS_RATES_CCK_OFDM, BRCMS_RATE_MASK,
-				   (bool) N_ENAB(wlc->pub));
+				   (bool) (wlc->pub->_n_enab & SUPPORT_11N));
 	}
 
 	/*
@@ -5194,8 +5252,6 @@ brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 
 	wlc->mimoft = FT_HT;
 	wlc->ht_cap.cap_info = HT_CAP;
-	if (HT_ENAB(wlc->pub))
-		wlc->stf->ldpc = AUTO;
 
 	wlc->mimo_40txbw = AUTO;
 	wlc->ofdm_40txbw = AUTO;
@@ -5843,7 +5899,7 @@ int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config)
 	/* if N-support is enabled, allow Gmode set as long as requested
 	 * Gmode is not GMODE_LEGACY_B
 	 */
-	if (N_ENAB(wlc->pub) && gmode == GMODE_LEGACY_B)
+	if ((wlc->pub->_n_enab & SUPPORT_11N) && gmode == GMODE_LEGACY_B)
 		return -ENOTSUPP;
 
 	/* verify that we are dealing with 2G band and grab the band pointer */
@@ -6269,7 +6325,7 @@ _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 			memcpy(&rs.rates, &in_rs->rates, rs.count);
 
 			/* merge rateset coming in with the current mcsset */
-			if (N_ENAB(wlc->pub)) {
+			if (wlc->pub->_n_enab & SUPPORT_11N) {
 				struct brcms_bss_info *mcsset_bss;
 				if (bsscfg->associated)
 					mcsset_bss = current_bss;
@@ -6957,7 +7013,7 @@ mac80211_wlc_set_nrate(struct brcms_c_info *wlc, struct brcms_band *cur_band,
 		return (u32) rate;
 
 	/* validate the combination of rate/mcs/stf is allowed */
-	if (N_ENAB(wlc->pub) && ismcs) {
+	if ((wlc->pub->_n_enab & SUPPORT_11N) && ismcs) {
 		/* mcs only allowed when nmode */
 		if (stf > PHY_TXC1_MODE_SDM) {
 			wiphy_err(wlc->wiphy, "wl%d: %s: Invalid stf\n",
@@ -7223,7 +7279,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 
 	phyctl1_stf = wlc->stf->ss_opmode;
 
-	if (N_ENAB(wlc->pub)) {
+	if (wlc->pub->_n_enab & SUPPORT_11N) {
 		for (k = 0; k < hw->max_rates; k++) {
 			/*
 			 * apply siso/cdd to single stream mcs's or ofdm
@@ -9287,7 +9343,7 @@ void brcms_default_rateset(struct brcms_c_info *wlc, struct brcms_c_rateset *rs)
 {
 	brcms_c_rateset_default(rs, NULL, wlc->band->phytype,
 		wlc->band->bandtype, false, BRCMS_RATE_MASK_FULL,
-		(bool) N_ENAB(wlc->pub),
+		(bool) (wlc->pub->_n_enab & SUPPORT_11N),
 		CHSPEC_WLC_BW(wlc->default_bss->chanspec),
 		wlc->stf->txstreams);
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/pub.h b/drivers/staging/brcm80211/brcmsmac/pub.h
index a56239a..f623d6e 100644
--- a/drivers/staging/brcm80211/brcmsmac/pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/pub.h
@@ -293,22 +293,10 @@ enum wlc_par_id {
 #define SUPPORT_HT	(ENAB_1x1|ENAB_2x2|ENAB_3x3)
 
 /* WL11N Support */
-#define N_ENAB(pub) ((pub)->_n_enab & SUPPORT_11N)
-#define N_REQD(pub) ((pub)->_n_reqd)
-
-#define HT_ENAB(pub) 0
-
 #define AMPDU_AGG_HOST	1
-#define AMPDU_ENAB(pub) ((pub)->_ampdu)
-
-#define EDCF_ENAB(pub) (WME_ENAB(pub))
-#define QOS_ENAB(pub) (WME_ENAB(pub) || N_ENAB(pub))
 
-#define MONITOR_ENAB(wlc)	((wlc)->monitor)
-
-#define PROMISC_ENAB(wlc)	((wlc)->promisc)
-
-#define	BRCMS_PREC_COUNT	16	/* Max precedence level implemented */
+#define EDCF_ENAB(pub) ((pub)->_wme != OFF)
+#define QOS_ENAB(pub) ((pub)->_wme != OFF || (pub)->_n_enab & SUPPORT_11N)
 
 /* pri is priority encoded in the packet. This maps the Packet priority to
  * enqueue precedence as defined in wlc_prec_map
@@ -316,6 +304,11 @@ enum wlc_par_id {
 extern const u8 wlc_prio2prec_map[];
 #define BRCMS_PRIO_TO_PREC(pri)	wlc_prio2prec_map[(pri) & 7]
 
+#define	BRCMS_PREC_COUNT	16	/* Max precedence level implemented */
+
+/* Mask to describe all precedence levels */
+#define BRCMS_PREC_BMP_ALL		MAXBITVAL(BRCMS_PREC_COUNT)
+
 /*
  * This maps priority to one precedence higher - Used by PS-Poll response
  * packets to simulate enqueue-at-head operation, but still maintain the
@@ -324,12 +317,6 @@ extern const u8 wlc_prio2prec_map[];
 #define BRCMS_PRIO_TO_HI_PREC(pri)	min(BRCMS_PRIO_TO_PREC(pri) + 1,\
 					    BRCMS_PREC_COUNT - 1)
 
-extern const u8 wme_fifo2ac[];
-#define WME_PRIO2AC(prio)	wme_fifo2ac[prio2fifo[(prio)]]
-
-/* Mask to describe all precedence levels */
-#define BRCMS_PREC_BMP_ALL		MAXBITVAL(BRCMS_PREC_COUNT)
-
 /* Define a bitmap of precedences comprised by each AC */
 #define BRCMS_PREC_BMP_AC_BE	(NBITVAL(BRCMS_PRIO_TO_PREC(PRIO_8021D_BE)) | \
 			NBITVAL(BRCMS_PRIO_TO_HI_PREC(PRIO_8021D_BE)) |	\
@@ -348,14 +335,6 @@ extern const u8 wme_fifo2ac[];
 			NBITVAL(BRCMS_PRIO_TO_PREC(PRIO_8021D_NC)) |	\
 			NBITVAL(BRCMS_PRIO_TO_HI_PREC(PRIO_8021D_NC)))
 
-/* WME Support */
-#define WME_ENAB(pub) ((pub)->_wme != OFF)
-#define WME_AUTO(wlc) ((wlc)->pub->_wme == AUTO)
-
-/* invalid core flags, use the saved coreflags */
-#define BRCMS_USE_COREFLAGS	0xffffffff
-
-
 /* network protection config */
 #define	BRCMS_PROT_G_SPEC		1	/* SPEC g protection */
 #define	BRCMS_PROT_G_OVR		2	/* SPEC g prot override */
@@ -409,67 +388,18 @@ extern const u8 wme_fifo2ac[];
 #define GMODE_LRS		5
 #define GMODE_MAX		6
 
-/* values for PLCPHdr_override */
-#define BRCMS_PLCP_AUTO	-1
-#define BRCMS_PLCP_SHORT	0
-#define BRCMS_PLCP_LONG	1
-
-/* values for g_protection_override and n_protection_override */
-#define BRCMS_PROTECTION_AUTO		-1
-#define BRCMS_PROTECTION_OFF		0
-#define BRCMS_PROTECTION_ON		1
-#define BRCMS_PROTECTION_MMHDR_ONLY	2
-#define BRCMS_PROTECTION_CTS_ONLY		3
-
-/* values for g_protection_control and n_protection_control */
-#define BRCMS_PROTECTION_CTL_OFF		0
-#define BRCMS_PROTECTION_CTL_LOCAL	1
-#define BRCMS_PROTECTION_CTL_OVERLAP	2
-
-/* values for n_protection */
-#define BRCMS_N_PROTECTION_OFF		0
-#define BRCMS_N_PROTECTION_OPTIONAL	1
-#define BRCMS_N_PROTECTION_20IN40		2
-#define BRCMS_N_PROTECTION_MIXEDMODE	3
-
-/* values for band specific 40MHz capabilities */
-#define BRCMS_N_BW_20ALL			0
-#define BRCMS_N_BW_40ALL			1
-#define BRCMS_N_BW_20IN2G_40IN5G		2
-
-/* bitflags for SGI support (sgi_rx iovar) */
-#define BRCMS_N_SGI_20			0x01
-#define BRCMS_N_SGI_40			0x02
-
-/* defines used by the nrate iovar */
-/* MSC in use,indicates b0-6 holds an mcs */
-#define NRATE_MCS_INUSE	0x00000080
-/* rate/mcs value */
-#define NRATE_RATE_MASK 0x0000007f
-/* stf mode mask: siso, cdd, stbc, sdm */
-#define NRATE_STF_MASK	0x0000ff00
-/* stf mode shift */
-#define NRATE_STF_SHIFT	8
-/* bit indicates override both rate & mode */
-#define NRATE_OVERRIDE	0x80000000
-/* bit indicate to override mcs only */
-#define NRATE_OVERRIDE_MCS_ONLY 0x40000000
-#define NRATE_SGI_MASK  0x00800000	/* sgi mode */
-#define NRATE_SGI_SHIFT 23	/* sgi mode */
-#define NRATE_LDPC_CODING 0x00400000	/* bit indicates adv coding in use */
-#define NRATE_LDPC_SHIFT 22	/* ldpc shift */
-
-#define NRATE_STF_SISO	0	/* stf mode SISO */
-#define NRATE_STF_CDD	1	/* stf mode CDD */
-#define NRATE_STF_STBC	2	/* stf mode STBC */
-#define NRATE_STF_SDM	3	/* stf mode SDM */
+/* MCS values greater than this enable multiple streams */
+#define HIGHEST_SINGLE_STREAM_MCS	7
+
+#define	MAXBANDS		2	/* Maximum #of bands */
+
+/* bandstate array indices */
+#define BAND_2G_INDEX		0	/* wlc->bandstate[x] index */
+#define BAND_5G_INDEX		1	/* wlc->bandstate[x] index */
 
 /* max number of antenna configurations */
 #define ANT_SELCFG_MAX		4
 
-/* MCS values greater than this enable multiple streams */
-#define HIGHEST_SINGLE_STREAM_MCS	7
-
 struct brcms_antselcfg {
 	u8 ant_config[ANT_SELCFG_MAX];	/* antenna configuration */
 	u8 num_antcfg;	/* number of available antenna configurations */
@@ -559,12 +489,4 @@ extern void brcms_c_wait_for_tx_completion(struct brcms_c_info *wlc,
 extern bool brcms_c_check_radio_disabled(struct brcms_c_info *wlc);
 extern bool brcms_c_radio_monitor_stop(struct brcms_c_info *wlc);
 
-#define	MAXBANDS		2	/* Maximum #of bands */
-/* bandstate array indices */
-#define BAND_2G_INDEX		0	/* wlc->bandstate[x] index */
-#define BAND_5G_INDEX		1	/* wlc->bandstate[x] index */
-
-#define BAND_2G_NAME		"2.4G"
-#define BAND_5G_NAME		"5G"
-
 #endif				/* _BRCM_PUB_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/scb.h b/drivers/staging/brcm80211/brcmsmac/scb.h
index efa5047..3fe9cf2 100644
--- a/drivers/staging/brcm80211/brcmsmac/scb.h
+++ b/drivers/staging/brcm80211/brcmsmac/scb.h
@@ -75,11 +75,11 @@ struct scb {
 };
 
 /* scb flags */
-#define SCB_WMECAP		0x0040	/* may ONLY be set if WME_ENAB(wlc) */
+#define SCB_WMECAP		0x0040	/* may ONLY be set if pub->_wme!=OFF */
 #define SCB_HTCAP		0x10000	/* HT (MIMO) capable device */
 #define SCB_IS40		0x80000	/* 40MHz capable */
 #define SCB_STBCCAP		0x40000000	/* STBC Capable */
-#define SCB_WME(a)		((a)->flags & SCB_WMECAP)/* implies WME_ENAB */
+#define SCB_WME(a)		((a)->flags & SCB_WMECAP)/* implies WME enab */
 #define SCB_SEQNUM(scb, prio)	((scb)->seqnum[(prio)])
 #define SCB_PS(a)		NULL
 #define SCB_STBC_CAP(a)		((a)->flags & SCB_STBCCAP)
-- 
1.7.4.1


