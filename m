Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3690 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190Ab1ILKPX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 06:15:23 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 04/20] staging: brcm80211: cleaned up brcmu_wifi.h
 macro's
Date: Mon, 12 Sep 2011 12:14:48 +0200
Message-ID: <1315822504-24210-5-git-send-email-rvossen@broadcom.com> (sfid-20110912_121604_662036_6DB22236)
In-Reply-To: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
References: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Substituted/removed macro's.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_common.c  |    2 +-
 drivers/staging/brcm80211/brcmsmac/channel.c     |   20 +++---
 drivers/staging/brcm80211/brcmsmac/main.c        |   22 ++++----
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c |   10 ++--
 drivers/staging/brcm80211/brcmsmac/pub.h         |    4 -
 drivers/staging/brcm80211/brcmutil/wifi.c        |    4 +-
 drivers/staging/brcm80211/include/brcmu_wifi.h   |   69 +++++++++++++---------
 7 files changed, 70 insertions(+), 61 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index cb7393c..1a5f730 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -261,7 +261,7 @@ bool brcmf_c_prec_enq(struct brcmf_pub *drvr, struct pktq *q,
 	/* Evict if needed */
 	if (eprec >= 0) {
 		/* Detect queueing to unconfigured precedence */
-		discard_oldest = AC_BITMAP_TST(drvr->wme_dp, eprec);
+		discard_oldest = ac_bitmap_tst(drvr->wme_dp, eprec);
 		if (eprec == prec && !discard_oldest)
 			return false;	/* refuse newer (incoming) packet */
 		/* Evict packet according to discard policy */
diff --git a/drivers/staging/brcm80211/brcmsmac/channel.c b/drivers/staging/brcm80211/brcmsmac/channel.c
index 27c62c7..af01c9d 100644
--- a/drivers/staging/brcm80211/brcmsmac/channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/channel.c
@@ -1141,9 +1141,9 @@ brcms_c_quiet_chanspec(struct brcms_cm_info *wlc_cm, u16 chspec)
 	return (wlc_cm->wlc->pub->_n_enab & SUPPORT_11N) &&
 		CHSPEC_IS40(chspec) ?
 		(isset(wlc_cm->quiet_channels.vec,
-		       LOWER_20_SB(CHSPEC_CHANNEL(chspec))) ||
+		       lower_20_sb(CHSPEC_CHANNEL(chspec))) ||
 		 isset(wlc_cm->quiet_channels.vec,
-		       UPPER_20_SB(CHSPEC_CHANNEL(chspec)))) :
+		       upper_20_sb(CHSPEC_CHANNEL(chspec)))) :
 		isset(wlc_cm->quiet_channels.vec, CHSPEC_CHANNEL(chspec));
 }
 
@@ -1310,7 +1310,7 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, u16 chanspec,
 	}
 
 	chan = CHSPEC_CHANNEL(chanspec);
-	band = wlc->bandstate[CHSPEC_BANDUNIT(chanspec)];
+	band = wlc->bandstate[chspec_bandunit(chanspec)];
 	li = (band->bandtype == BRCM_BAND_5G) ?
 	    brcms_c_get_locale_5g(country->locale_5G) :
 	    brcms_c_get_locale_2g(country->locale_2G);
@@ -1516,7 +1516,7 @@ brcms_c_valid_chanspec_ext(struct brcms_cm_info *wlc_cm, u16 chspec,
 	}
 
 	if (CHANNEL_BANDUNIT(wlc_cm->wlc, channel) !=
-	    CHSPEC_BANDUNIT(chspec))
+	    chspec_bandunit(chspec))
 		return false;
 
 	/* Check a 20Mhz channel */
@@ -1538,26 +1538,26 @@ brcms_c_valid_chanspec_ext(struct brcms_cm_info *wlc_cm, u16 chspec,
 		u8 num_ch20_entries =
 		    sizeof(chan20_info) / sizeof(struct chan20_info);
 
-		if (!VALID_40CHANSPEC_IN_BAND(wlc, CHSPEC_BANDUNIT(chspec)))
+		if (!VALID_40CHANSPEC_IN_BAND(wlc, chspec_bandunit(chspec)))
 			return false;
 
 		if (dualband) {
 			if (!brcms_c_valid_channel20_db(wlc->cmi,
-							LOWER_20_SB(channel)) ||
+							lower_20_sb(channel)) ||
 			    !brcms_c_valid_channel20_db(wlc->cmi,
-							UPPER_20_SB(channel)))
+							upper_20_sb(channel)))
 				return false;
 		} else {
 			if (!brcms_c_valid_channel20(wlc->cmi,
-						     LOWER_20_SB(channel)) ||
+						     lower_20_sb(channel)) ||
 			    !brcms_c_valid_channel20(wlc->cmi,
-						     UPPER_20_SB(channel)))
+						     upper_20_sb(channel)))
 				return false;
 		}
 
 		/* find the lower sideband info in the sideband array */
 		for (idx = 0; idx < num_ch20_entries; idx++) {
-			if (chan20_info[idx].sb == LOWER_20_SB(channel))
+			if (chan20_info[idx].sb == lower_20_sb(channel))
 				upper_sideband = chan20_info[idx].adj_sbs;
 		}
 		/* check that the lower sideband allows an upper sideband */
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 51ad7f0..d755c18 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -1058,7 +1058,7 @@ static void brcms_b_info_init(struct brcms_hardware *wlc_hw)
 	/* default mac retry limits */
 	wlc_hw->SRL = RETRY_SHORT_DEF;
 	wlc_hw->LRL = RETRY_LONG_DEF;
-	wlc_hw->chanspec = CH20MHZ_CHSPEC(1);
+	wlc_hw->chanspec = ch20mhz_chspec(1);
 }
 
 static void brcms_b_wait_for_wake(struct brcms_hardware *wlc_hw)
@@ -3266,7 +3266,7 @@ static brcms_b_init(struct brcms_hardware *wlc_hw, u16 chanspec,
 	macintmask = brcms_intrsoff(wlc->wl);
 
 	/* set up the specified band and chanspec */
-	brcms_c_setxband(wlc_hw, CHSPEC_BANDUNIT(chanspec));
+	brcms_c_setxband(wlc_hw, chspec_bandunit(chanspec));
 	wlc_phy_chanspec_radio_set(wlc_hw->band->pi, chanspec);
 
 	/* do one-time phy inits and calibration */
@@ -3366,7 +3366,7 @@ static void brcms_c_bandinit_ordered(struct brcms_c_info *wlc,
 		band_order[0] = band_order[1] = parkband;
 	} else {
 		/* park on the band of the specified chanspec */
-		parkband = CHSPEC_BANDUNIT(chanspec);
+		parkband = chspec_bandunit(chanspec);
 
 		/* order so that parkband initialize last */
 		band_order[0] = parkband ^ 1;
@@ -3815,7 +3815,7 @@ brcms_b_set_chanspec(struct brcms_hardware *wlc_hw, u16 chanspec,
 
 	/* Switch bands if necessary */
 	if (wlc_hw->_nbands > 1) {
-		bandunit = CHSPEC_BANDUNIT(chanspec);
+		bandunit = chspec_bandunit(chanspec);
 		if (wlc_hw->band->bandunit != bandunit) {
 			/* brcms_b_setband disables other bandunit,
 			 *  use light band switch if not up yet
@@ -3885,7 +3885,7 @@ void brcms_c_set_chanspec(struct brcms_c_info *wlc, u16 chanspec)
 
 	/* Switch bands if necessary */
 	if (wlc->pub->_nbands > 1) {
-		bandunit = CHSPEC_BANDUNIT(chanspec);
+		bandunit = chspec_bandunit(chanspec);
 		if (wlc->band->bandunit != bandunit || wlc->bandinit_pending) {
 			switchband = true;
 			if (wlc->bandlocked) {
@@ -4428,7 +4428,7 @@ void brcms_c_info_init(struct brcms_c_info *wlc, int unit)
 	wlc->device_present = true;
 
 	/* Save our copy of the chanspec */
-	wlc->chanspec = CH20MHZ_CHSPEC(1);
+	wlc->chanspec = ch20mhz_chspec(1);
 
 	/* various 802.11g modes */
 	wlc->shortslot = false;
@@ -4974,13 +4974,13 @@ static void brcms_c_bss_default_init(struct brcms_c_info *wlc)
 	/* fill the default channel as the first valid channel
 	 * starting from the 2G channels
 	 */
-	chanspec = CH20MHZ_CHSPEC(1);
+	chanspec = ch20mhz_chspec(1);
 	wlc->home_chanspec = bi->chanspec = chanspec;
 
 	/* find the band of our default channel */
 	band = wlc->band;
 	if (wlc->pub->_nbands > 1 &&
-	    band->bandunit != CHSPEC_BANDUNIT(chanspec))
+	    band->bandunit != chspec_bandunit(chanspec))
 		band = wlc->bandstate[OTHERBANDUNIT(wlc)];
 
 	/* init bss rates to the band specific default rate set */
@@ -6222,7 +6222,7 @@ _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 	switch (cmd) {
 
 	case BRCM_SET_CHANNEL:{
-			u16 chspec = CH20MHZ_CHSPEC(val);
+			u16 chspec = ch20mhz_chspec(val);
 
 			if (val < 0 || val > MAXCHANNEL) {
 				bcmerror = -EINVAL;
@@ -6236,7 +6236,7 @@ _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 
 			if (!wlc->pub->up && IS_MBAND_UNLOCKED(wlc)) {
 				if (wlc->band->bandunit !=
-				    CHSPEC_BANDUNIT(chspec))
+				    chspec_bandunit(chspec))
 					wlc->bandinit_pending = true;
 				else
 					wlc->bandinit_pending = false;
@@ -6787,7 +6787,7 @@ brcms_c_prec_enq_head(struct brcms_c_info *wlc, struct pktq *q,
 	if (eprec >= 0) {
 		bool discard_oldest;
 
-		discard_oldest = AC_BITMAP_TST(wlc->wme_dp, eprec);
+		discard_oldest = ac_bitmap_tst(wlc->wme_dp, eprec);
 
 		/* Refuse newer packet unless configured to discard oldest */
 		if (eprec == prec && !discard_oldest) {
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index 119a127..eb171f0 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -596,7 +596,7 @@ wlc_phy_attach(struct shared_phy *sh, struct d11regs *regs, int bandtype,
 
 	pi->bw = WL_CHANSPEC_BW_20;
 	pi->radio_chanspec = (bandtype == BRCM_BAND_2G) ?
-			     CH20MHZ_CHSPEC(1) : CH20MHZ_CHSPEC(36);
+			     ch20mhz_chspec(1) : ch20mhz_chspec(36);
 
 	pi->rxiq_samps = PHY_NOISE_SAMPLE_LOG_NUM_NPHY;
 	pi->rxiq_antsel = ANT_RX_DIV_DEF;
@@ -1375,7 +1375,7 @@ u16 wlc_phy_chanspec_band_firstch(struct brcms_phy_pub *ppi, uint band)
 			if (j == ARRAY_SIZE(chan_info_all))
 				continue;
 
-			channel = UPPER_20_SB(channel);
+			channel = upper_20_sb(channel);
 			chspec =  channel | WL_CHANSPEC_BW_40 |
 				  WL_CHANSPEC_CTL_SB_LOWER;
 			if (band == BRCM_BAND_2G)
@@ -1383,7 +1383,7 @@ u16 wlc_phy_chanspec_band_firstch(struct brcms_phy_pub *ppi, uint band)
 			else
 				chspec |= WL_CHANSPEC_BAND_5G;
 		} else
-			chspec = CH20MHZ_CHSPEC(channel);
+			chspec = ch20mhz_chspec(channel);
 
 		if ((pi->a_band_high_disable) && (channel >= FIRST_REF5_CHANNUM)
 		    && (channel <= LAST_REF5_CHANNUM))
@@ -1650,9 +1650,9 @@ void wlc_phy_txpower_recalc_target(struct brcms_phy *pi)
 	if (CHSPEC_CTL_SB(chspec) == WL_CHANSPEC_CTL_SB_NONE)
 		target_chan = CHSPEC_CHANNEL(chspec);
 	else if (CHSPEC_CTL_SB(chspec) == WL_CHANSPEC_CTL_SB_UPPER)
-		target_chan = UPPER_20_SB(CHSPEC_CHANNEL(chspec));
+		target_chan = upper_20_sb(CHSPEC_CHANNEL(chspec));
 	else
-		target_chan = LOWER_20_SB(CHSPEC_CHANNEL(chspec));
+		target_chan = lower_20_sb(CHSPEC_CHANNEL(chspec));
 
 	pactrl = 0;
 	if (ISLCNPHY(pi)) {
diff --git a/drivers/staging/brcm80211/brcmsmac/pub.h b/drivers/staging/brcm80211/brcmsmac/pub.h
index 381ddb4..20582f1 100644
--- a/drivers/staging/brcm80211/brcmsmac/pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/pub.h
@@ -389,10 +389,6 @@ extern const u8 wlc_prio2prec_map[];
 
 #define	MAXBANDS		2	/* Maximum #of bands */
 
-/* bandstate array indices */
-#define BAND_2G_INDEX		0	/* wlc->bandstate[x] index */
-#define BAND_5G_INDEX		1	/* wlc->bandstate[x] index */
-
 /* max number of antenna configurations */
 #define ANT_SELCFG_MAX		4
 
diff --git a/drivers/staging/brcm80211/brcmutil/wifi.c b/drivers/staging/brcm80211/brcmutil/wifi.c
index 636515c..509e25c 100644
--- a/drivers/staging/brcm80211/brcmutil/wifi.c
+++ b/drivers/staging/brcm80211/brcmutil/wifi.c
@@ -65,13 +65,13 @@ u8 brcmu_chspec_ctlchan(u16 chspec)
 			 * control chan is the upper 20 MHZ SB of the
 			 * 40MHZ channel
 			 */
-			ctl_chan = UPPER_20_SB(CHSPEC_CHANNEL(chspec));
+			ctl_chan = upper_20_sb(CHSPEC_CHANNEL(chspec));
 		else
 			/*
 			 * control chan is the lower 20 MHZ SB of the
 			 * 40MHZ channel
 			 */
-			ctl_chan = LOWER_20_SB(CHSPEC_CHANNEL(chspec));
+			ctl_chan = lower_20_sb(CHSPEC_CHANNEL(chspec));
 	}
 
 	return ctl_chan;
diff --git a/drivers/staging/brcm80211/include/brcmu_wifi.h b/drivers/staging/brcm80211/include/brcmu_wifi.h
index 0ab432d..e98ed50 100644
--- a/drivers/staging/brcm80211/include/brcmu_wifi.h
+++ b/drivers/staging/brcm80211/include/brcmu_wifi.h
@@ -35,6 +35,10 @@
 #define CH_MAX_2G_CHANNEL		14	/* Max channel in 2G band */
 #define BRCM_MAX_2G_CHANNEL	CH_MAX_2G_CHANNEL	/* legacy define */
 
+/* bandstate array indices */
+#define BAND_2G_INDEX		0	/* wlc->bandstate[x] index */
+#define BAND_5G_INDEX		1	/* wlc->bandstate[x] index */
+
 /*
  * max # supported channels. The max channel no is 216, this is that + 1
  * rounded up to a multiple of NBBY (8). DO NOT MAKE it > 255: channels are
@@ -68,31 +72,6 @@
 #define WF_CHAN_FACTOR_5_G		10000	/* 5   GHz band, 5000 MHz */
 #define WF_CHAN_FACTOR_4_G		8000	/* 4.9 GHz band for Japan */
 
-/* channel defines */
-#define LOWER_20_SB(channel) \
-	(((channel) > CH_10MHZ_APART) ? ((channel) - CH_10MHZ_APART) : 0)
-
-#define UPPER_20_SB(channel) \
-	(((channel) < (MAXCHANNEL - CH_10MHZ_APART)) ? \
-	 ((channel) + CH_10MHZ_APART) : 0)
-
-#define CHSPEC_BANDUNIT(chspec) \
-	(CHSPEC_IS5G(chspec) ? BAND_5G_INDEX : BAND_2G_INDEX)
-
-#define CH20MHZ_CHSPEC(channel) \
-	(u16)((u16)(channel) | WL_CHANSPEC_BW_20 | WL_CHANSPEC_CTL_SB_NONE | \
-		    (((channel) <= CH_MAX_2G_CHANNEL) ? \
-		    WL_CHANSPEC_BAND_2G : WL_CHANSPEC_BAND_5G))
-
-#define NEXT_20MHZ_CHAN(channel) \
-	(((channel) < (MAXCHANNEL - CH_20MHZ_APART)) ? \
-	 ((channel) + CH_20MHZ_APART) : 0)
-
-#define CH40MHZ_CHSPEC(channel, ctlsb) \
-	(u16)((channel) | (ctlsb) | WL_CHANSPEC_BW_40 | \
-	      ((channel) <= CH_MAX_2G_CHANNEL ? \
-		WL_CHANSPEC_BAND_2G : WL_CHANSPEC_BAND_5G))
-
 #define CHSPEC_CHANNEL(chspec)	((u8)((chspec) & WL_CHANSPEC_CHAN_MASK))
 #define CHSPEC_BAND(chspec)	((chspec) & WL_CHANSPEC_BAND_MASK)
 
@@ -127,13 +106,44 @@
 
 #define CHSPEC_CTL_CHAN(chspec) \
 	((CHSPEC_SB_LOWER(chspec)) ? \
-	(LOWER_20_SB(((chspec) & WL_CHANSPEC_CHAN_MASK))) : \
-	(UPPER_20_SB(((chspec) & WL_CHANSPEC_CHAN_MASK))))
+	(lower_20_sb(((chspec) & WL_CHANSPEC_CHAN_MASK))) : \
+	(upper_20_sb(((chspec) & WL_CHANSPEC_CHAN_MASK))))
 
 #define CHSPEC2BAND(chspec) (CHSPEC_IS5G(chspec) ? BRCM_BAND_5G : BRCM_BAND_2G)
 
 #define CHANSPEC_STR_LEN    8
 
+static inline int lower_20_sb(int channel)
+{
+	return channel > CH_10MHZ_APART ? (channel - CH_10MHZ_APART) : 0;
+}
+
+static inline int upper_20_sb(int channel)
+{
+	return (channel < (MAXCHANNEL - CH_10MHZ_APART)) ?
+	       channel + CH_10MHZ_APART : 0;
+}
+
+static inline int chspec_bandunit(u16 chspec)
+{
+	return CHSPEC_IS5G(chspec) ? BAND_5G_INDEX : BAND_2G_INDEX;
+}
+
+static inline u16 ch20mhz_chspec(int channel)
+{
+	u16 rc = channel <= CH_MAX_2G_CHANNEL ?
+		 WL_CHANSPEC_BAND_2G : WL_CHANSPEC_BAND_5G;
+
+	return	(u16)((u16)channel | WL_CHANSPEC_BW_20 |
+		      WL_CHANSPEC_CTL_SB_NONE | rc);
+}
+
+static inline int next_20mhz_chan(int channel)
+{
+	return channel < (MAXCHANNEL - CH_20MHZ_APART) ?
+	       channel + CH_20MHZ_APART : 0;
+}
+
 /* defined rate in 500kbps */
 #define BRCM_MAXRATE	108	/* in 500kbps units */
 #define BRCM_RATE_1M	2	/* in 500kbps units */
@@ -153,7 +163,10 @@
 
 #define MCSSET_LEN	16
 
-#define AC_BITMAP_TST(ab, ac)	(((ab) & (1 << (ac))) != 0)
+static inline bool ac_bitmap_tst(u8 bitmap, int prec)
+{
+	return (bitmap & (1 << (prec))) != 0;
+}
 
 /*
  * Verify the chanspec is using a legal set of parameters, i.e. that the
-- 
1.7.4.1


