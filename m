Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4896 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754691Ab1IOIGw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 04:06:52 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de, dan.carpenter@oracle.com
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH V2 02/17] staging: brcm80211: remove ioctl layer from
 brcmsmac
Date: Thu, 15 Sep 2011 10:06:21 +0200
Message-ID: <1316073981-4845-1-git-send-email-rvossen@broadcom.com> (sfid-20110915_100658_991841_E25A0D41)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The ioctl layer in brcmsmac only provided an interface layer that
was internal to the driver. This is considered pointless and has
been removed.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |   65 ++---
 drivers/staging/brcm80211/brcmsmac/main.c        |  353 +++++++--------------
 drivers/staging/brcm80211/brcmsmac/pub.h         |   12 +-
 drivers/staging/brcm80211/include/defs.h         |   13 +-
 4 files changed, 158 insertions(+), 285 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index d003786..11ad5d0 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -371,23 +371,23 @@ ieee_set_channel(struct ieee80211_hw *hw, struct ieee80211_channel *chan,
 		 enum nl80211_channel_type type)
 {
 	struct brcms_info *wl = hw->priv;
-	int err = 0;
+	int err;
 
 	switch (type) {
 	case NL80211_CHAN_HT20:
 	case NL80211_CHAN_NO_HT:
-		err = brcms_c_set(wl->wlc, BRCM_SET_CHANNEL, chan->hw_value);
+		err = brcms_c_set_channel(wl->wlc, chan->hw_value);
 		break;
 	case NL80211_CHAN_HT40MINUS:
 	case NL80211_CHAN_HT40PLUS:
 		wiphy_err(hw->wiphy,
 			  "%s: Need to implement 40 Mhz Channels!\n", __func__);
-		err = 1;
+		err = -ENOTSUPP;
 		break;
+	default:
+		err = -EINVAL;
 	}
 
-	if (err)
-		return -EIO;
 	return err;
 }
 
@@ -436,21 +436,10 @@ static int brcms_ops_config(struct ieee80211_hw *hw, u32 changed)
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL)
 		err = ieee_set_channel(hw, conf->channel, conf->channel_type);
 
-	if (changed & IEEE80211_CONF_CHANGE_RETRY_LIMITS) {
-		if (brcms_c_set
-		    (wl->wlc, BRCM_SET_SRL,
-		     conf->short_frame_max_tx_count) < 0) {
-			wiphy_err(wiphy, "%s: Error setting srl\n", __func__);
-			err = -EIO;
-			goto config_out;
-		}
-		if (brcms_c_set(wl->wlc, BRCM_SET_LRL,
-				conf->long_frame_max_tx_count) < 0) {
-			wiphy_err(wiphy, "%s: Error setting lrl\n", __func__);
-			err = -EIO;
-			goto config_out;
-		}
-	}
+	if (changed & IEEE80211_CONF_CHANGE_RETRY_LIMITS)
+		err = brcms_c_set_rate_limit(wl->wlc,
+					     conf->short_frame_max_tx_count,
+					     conf->long_frame_max_tx_count);
 
  config_out:
 	UNLOCK(wl);
@@ -464,7 +453,6 @@ brcms_ops_bss_info_changed(struct ieee80211_hw *hw,
 {
 	struct brcms_info *wl = hw->priv;
 	struct wiphy *wiphy = hw->wiphy;
-	int val;
 
 	if (changed & BSS_CHANGED_ASSOC) {
 		/* association status changed (associated/disassociated)
@@ -477,13 +465,15 @@ brcms_ops_bss_info_changed(struct ieee80211_hw *hw,
 		UNLOCK(wl);
 	}
 	if (changed & BSS_CHANGED_ERP_SLOT) {
+		s8 val;
+
 		/* slot timing changed */
 		if (info->use_short_slot)
 			val = 1;
 		else
 			val = 0;
 		LOCK(wl);
-		brcms_c_set(wl->wlc, BRCMS_SET_SHORTSLOT_OVERRIDE, val);
+		brcms_c_set_shortslot_override(wl->wlc, val);
 		UNLOCK(wl);
 	}
 
@@ -509,14 +499,9 @@ brcms_ops_bss_info_changed(struct ieee80211_hw *hw,
 
 		/* retrieve the current rates */
 		LOCK(wl);
-		error = brcms_c_ioctl(wl->wlc, BRCM_GET_CURR_RATESET,
-				  &rs, sizeof(rs));
+		brcms_c_get_current_rateset(wl->wlc, &rs);
 		UNLOCK(wl);
-		if (error) {
-			wiphy_err(wiphy, "%s: retrieve rateset failed: %d\n",
-				  __func__, error);
-			return;
-		}
+
 		br_mask = info->basic_rates;
 		bi = hw->wiphy->bands[brcms_c_get_curband(wl->wlc)];
 		for (i = 0; i < bi->n_bitrates; i++) {
@@ -530,20 +515,22 @@ brcms_ops_bss_info_changed(struct ieee80211_hw *hw,
 
 		/* update the rate set */
 		LOCK(wl);
-		brcms_c_ioctl(wl->wlc, BRCM_SET_RATESET, &rs, sizeof(rs));
+		error = brcms_c_set_rateset(wl->wlc, &rs);
 		UNLOCK(wl);
+		if (error)
+			wiphy_err(wiphy, "changing basic rates failed: %d\n",
+				  error);
 	}
 	if (changed & BSS_CHANGED_BEACON_INT) {
 		/* Beacon interval changed */
 		LOCK(wl);
-		brcms_c_set(wl->wlc, BRCM_SET_BCNPRD, info->beacon_int);
+		brcms_c_set_beacon_period(wl->wlc, info->beacon_int);
 		UNLOCK(wl);
 	}
 	if (changed & BSS_CHANGED_BSSID) {
 		/* BSSID changed, for whatever reason (IBSS and managed mode) */
 		LOCK(wl);
-		brcms_c_set_addrmatch(wl->wlc, RCM_BSSID_OFFSET,
-				  info->bssid);
+		brcms_c_set_addrmatch(wl->wlc, RCM_BSSID_OFFSET, info->bssid);
 		UNLOCK(wl);
 	}
 	if (changed & BSS_CHANGED_BEACON)
@@ -1086,18 +1073,16 @@ static int ieee_hw_rate_init(struct ieee80211_hw *hw)
 {
 	struct brcms_info *wl = hw->priv;
 	int has_5g;
-	char phy_list[4];
+	u16 phy_type;
 
 	has_5g = 0;
 
 	hw->wiphy->bands[IEEE80211_BAND_2GHZ] = NULL;
 	hw->wiphy->bands[IEEE80211_BAND_5GHZ] = NULL;
 
-	if (brcms_c_get(wl->wlc, BRCM_GET_PHYLIST, (int *)&phy_list) < 0)
-		wiphy_err(hw->wiphy, "Phy list failed\n");
-
-	if (phy_list[0] == 'n' || phy_list[0] == 'c') {
-		if (phy_list[0] == 'c') {
+	phy_type = brcms_c_get_phy_type(wl->wlc, 0);
+	if (phy_type == PHY_TYPE_N || phy_type == PHY_TYPE_LCN) {
+		if (phy_type == PHY_TYPE_LCN) {
 			/* Single stream */
 			brcms_band_2GHz_nphy.ht_cap.mcs.rx_mask[1] = 0;
 			brcms_band_2GHz_nphy.ht_cap.mcs.rx_highest = 72;
@@ -1110,7 +1095,7 @@ static int ieee_hw_rate_init(struct ieee80211_hw *hw)
 	/* Assume all bands use the same phy.  True for 11n devices. */
 	if (wl->pub->_nbands > 1) {
 		has_5g++;
-		if (phy_list[0] == 'n' || phy_list[0] == 'c')
+		if (phy_type == PHY_TYPE_N || phy_type == PHY_TYPE_LCN)
 			hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
 			    &brcms_band_5GHz_nphy;
 		else
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 2b5d4de..705f0eb 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -5252,7 +5252,7 @@ brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 		/* init per-band default rateset, depend on band->gmode */
 		brcms_default_rateset(wlc, &wlc->band->defrateset);
 
-		/* fill in hw_rateset (used early by BRCM_SET_RATESET) */
+		/* fill in hw_rateset */
 		brcms_c_rateset_filter(&wlc->band->defrateset,
 				   &wlc->band->hw_rateset, false,
 				   BRCMS_RATES_CCK_OFDM, BRCMS_RATE_MASK,
@@ -6116,7 +6116,8 @@ int brcms_c_set_nmode(struct brcms_c_info *wlc, s32 nmode)
 }
 
 static int
-brcms_c_set_rateset(struct brcms_c_info *wlc, struct brcms_c_rateset *rs_arg)
+brcms_c_set_internal_rateset(struct brcms_c_info *wlc,
+			     struct brcms_c_rateset *rs_arg)
 {
 	struct brcms_c_rateset rs, new;
 	uint bandunit;
@@ -6158,18 +6159,6 @@ brcms_c_set_rateset(struct brcms_c_info *wlc, struct brcms_c_rateset *rs_arg)
 	return 0;
 }
 
-/* simplified integer set interface for common ioctl handler */
-int brcms_c_set(struct brcms_c_info *wlc, int cmd, int arg)
-{
-	return brcms_c_ioctl(wlc, cmd, (void *)&arg, sizeof(arg));
-}
-
-/* simplified integer get interface for common ioctl handler */
-int brcms_c_get(struct brcms_c_info *wlc, int cmd, int *arg)
-{
-	return brcms_c_ioctl(wlc, cmd, arg, sizeof(int));
-}
-
 static void brcms_c_ofdm_rateset_war(struct brcms_c_info *wlc)
 {
 	u8 r;
@@ -6185,259 +6174,153 @@ static void brcms_c_ofdm_rateset_war(struct brcms_c_info *wlc)
 	return;
 }
 
-/* common ioctl handler. return: 0=ok, -1=error, positive=particular error */
-static int
-_brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len)
+int brcms_c_set_channel(struct brcms_c_info *wlc, u16 channel)
 {
-	int val, *pval;
-	bool bool_val;
-	int bcmerror;
-	struct scb *nextscb;
-	bool ta_ok;
-	uint band;
-	struct brcms_bss_cfg *bsscfg;
-	struct brcms_bss_info *current_bss;
-
-	/* update bsscfg pointer */
-	bsscfg = wlc->cfg;
-	current_bss = bsscfg->current_bss;
-
-	/* initialize the following to get rid of compiler warning */
-	nextscb = NULL;
-	ta_ok = false;
-	band = 0;
-
-	/* If the device is turned off, then it's not "removed" */
-	if (!wlc->pub->hw_off && DEVICEREMOVED(wlc)) {
-		wiphy_err(wlc->wiphy, "wl%d: %s: dead chip\n", wlc->pub->unit,
-			  __func__);
-		brcms_down(wlc->wl);
-		return -EBADE;
-	}
+	u16 chspec = ch20mhz_chspec(channel);
 
-	/* default argument is generic integer */
-	pval = arg ? (int *)arg : NULL;
+	if (channel < 0 || channel > MAXCHANNEL)
+		return -EINVAL;
 
-	/*
-	 * This will prevent misaligned access. The (void *) cast prevents a
-	 * memcpy alignment issue on e.g. Sparc64 platforms.
-	 */
-	if (pval && (u32) len >= sizeof(val))
-		memcpy((void *)&val, (void *)pval, sizeof(val));
-	else
-		val = 0;
+	if (!brcms_c_valid_chanspec_db(wlc->cmi, chspec))
+		return -EINVAL;
 
-	/* bool conversion to avoid duplication below */
-	bool_val = val != 0;
-	bcmerror = 0;
 
-	if ((arg == NULL) || (len <= 0)) {
-		wiphy_err(wlc->wiphy, "wl%d: %s: Command %d needs arguments\n",
-			  wlc->pub->unit, __func__, cmd);
-		bcmerror = -EINVAL;
-		goto done;
+	if (!wlc->pub->up && IS_MBAND_UNLOCKED(wlc)) {
+		if (wlc->band->bandunit != chspec_bandunit(chspec))
+			wlc->bandinit_pending = true;
+		else
+			wlc->bandinit_pending = false;
 	}
 
-	switch (cmd) {
-
-	case BRCM_SET_CHANNEL:{
-			u16 chspec = ch20mhz_chspec(val);
-
-			if (val < 0 || val > MAXCHANNEL) {
-				bcmerror = -EINVAL;
-				break;
-			}
-
-			if (!brcms_c_valid_chanspec_db(wlc->cmi, chspec)) {
-				bcmerror = -EINVAL;
-				break;
-			}
-
-			if (!wlc->pub->up && IS_MBAND_UNLOCKED(wlc)) {
-				if (wlc->band->bandunit !=
-				    chspec_bandunit(chspec))
-					wlc->bandinit_pending = true;
-				else
-					wlc->bandinit_pending = false;
-			}
-
-			wlc->default_bss->chanspec = chspec;
-			/* brcms_c_BSSinit() will sanitize the rateset before
-			 * using it.. */
-			if (wlc->pub->up &&
-			    (wlc_phy_chanspec_get(wlc->band->pi) != chspec)) {
-				brcms_c_set_home_chanspec(wlc, chspec);
-				brcms_c_suspend_mac_and_wait(wlc);
-				brcms_c_set_chanspec(wlc, chspec);
-				brcms_c_enable_mac(wlc);
-			}
-			break;
-		}
-
-	case BRCM_SET_SRL:
-		if (val >= 1 && val <= RETRY_SHORT_MAX) {
-			int ac;
-			wlc->SRL = (u16) val;
-
-			brcms_b_retrylimit_upd(wlc->hw, wlc->SRL, wlc->LRL);
-
-			for (ac = 0; ac < AC_COUNT; ac++)
-				BRCMS_WME_RETRY_SHORT_SET(wlc, ac, wlc->SRL);
-
-			brcms_c_wme_retries_write(wlc);
-		} else
-			bcmerror = -EINVAL;
-		break;
-
-	case BRCM_SET_LRL:
-		if (val >= 1 && val <= 255) {
-			int ac;
-			wlc->LRL = (u16) val;
-
-			brcms_b_retrylimit_upd(wlc->hw, wlc->SRL, wlc->LRL);
+	wlc->default_bss->chanspec = chspec;
+	/* brcms_c_BSSinit() will sanitize the rateset before
+	 * using it.. */
+	if (wlc->pub->up && (wlc_phy_chanspec_get(wlc->band->pi) != chspec)) {
+		brcms_c_set_home_chanspec(wlc, chspec);
+		brcms_c_suspend_mac_and_wait(wlc);
+		brcms_c_set_chanspec(wlc, chspec);
+		brcms_c_enable_mac(wlc);
+	}
+	return 0;
+}
 
-			for (ac = 0; ac < AC_COUNT; ac++)
-				BRCMS_WME_RETRY_LONG_SET(wlc, ac, wlc->LRL);
+int brcms_c_set_rate_limit(struct brcms_c_info *wlc, u16 srl, u16 lrl)
+{
+	int ac;
 
-			brcms_c_wme_retries_write(wlc);
-		} else
-			bcmerror = -EINVAL;
-		break;
+	if (srl < 1 || srl > RETRY_SHORT_MAX ||
+	    lrl < 1 || lrl > RETRY_SHORT_MAX)
+		return -EINVAL;
 
-	case BRCM_GET_CURR_RATESET:{
-			struct brcm_rateset *ret_rs =
-						(struct brcm_rateset *) arg;
-			struct brcms_c_rateset *rs;
+	wlc->SRL = srl;
+	wlc->LRL = lrl;
 
-			if (wlc->pub->associated)
-				rs = &current_bss->rateset;
-			else
-				rs = &wlc->default_bss->rateset;
+	brcms_b_retrylimit_upd(wlc->hw, wlc->SRL, wlc->LRL);
 
-			if (len < (int)(rs->count + sizeof(rs->count))) {
-				bcmerror = -EOVERFLOW;
-				break;
-			}
+	for (ac = 0; ac < AC_COUNT; ac++) {
+		BRCMS_WME_RETRY_SHORT_SET(wlc, ac, srl);
+		BRCMS_WME_RETRY_LONG_SET(wlc, ac, lrl);
+	}
+	brcms_c_wme_retries_write(wlc);
 
-			/* Copy only legacy rateset section */
-			ret_rs->count = rs->count;
-			memcpy(&ret_rs->rates, &rs->rates, rs->count);
-			break;
-		}
+	return 0;
+}
 
-	case BRCM_SET_RATESET:{
-			struct brcms_c_rateset rs;
-			struct brcm_rateset *in_rs =
-						(struct brcm_rateset *) arg;
+void brcms_c_get_current_rateset(struct brcms_c_info *wlc,
+				 struct brcm_rateset *currs)
+{
+	struct brcms_c_rateset *rs;
 
-			if (len < (int)(in_rs->count + sizeof(in_rs->count))) {
-				bcmerror = -EOVERFLOW;
-				break;
-			}
+	if (wlc->pub->associated)
+		rs = &wlc->cfg->current_bss->rateset;
+	else
+		rs = &wlc->default_bss->rateset;
 
-			if (in_rs->count > BRCMS_NUMRATES) {
-				bcmerror = -ENOBUFS;
-				break;
-			}
+	/* Copy only legacy rateset section */
+	currs->count = rs->count;
+	memcpy(&currs->rates, &rs->rates, rs->count);
+}
 
-			memset(&rs, 0, sizeof(struct brcms_c_rateset));
-
-			/* Copy only legacy rateset section */
-			rs.count = in_rs->count;
-			memcpy(&rs.rates, &in_rs->rates, rs.count);
-
-			/* merge rateset coming in with the current mcsset */
-			if (wlc->pub->_n_enab & SUPPORT_11N) {
-				struct brcms_bss_info *mcsset_bss;
-				if (bsscfg->associated)
-					mcsset_bss = current_bss;
-				else
-					mcsset_bss = wlc->default_bss;
-				memcpy(rs.mcs, &mcsset_bss->rateset.mcs[0],
-				       MCSSET_LEN);
-			}
+int brcms_c_set_rateset(struct brcms_c_info *wlc, struct brcm_rateset *rs)
+{
+	struct brcms_c_rateset internal_rs;
+	int bcmerror;
 
-			bcmerror = brcms_c_set_rateset(wlc, &rs);
+	if (rs->count > BRCMS_NUMRATES)
+		return -ENOBUFS;
 
-			if (!bcmerror)
-				brcms_c_ofdm_rateset_war(wlc);
+	memset(&internal_rs, 0, sizeof(struct brcms_c_rateset));
 
-			break;
-		}
+	/* Copy only legacy rateset section */
+	internal_rs.count = rs->count;
+	memcpy(&internal_rs.rates, &rs->rates, internal_rs.count);
 
-	case BRCM_SET_BCNPRD:
-		/* range [1, 0xffff] */
-		if (val >= DOT11_MIN_BEACON_PERIOD
-		    && val <= DOT11_MAX_BEACON_PERIOD)
-			wlc->default_bss->beacon_period = (u16) val;
+	/* merge rateset coming in with the current mcsset */
+	if (wlc->pub->_n_enab & SUPPORT_11N) {
+		struct brcms_bss_info *mcsset_bss;
+		if (wlc->cfg->associated)
+			mcsset_bss = wlc->cfg->current_bss;
 		else
-			bcmerror = -EINVAL;
-		break;
-
-	case BRCM_GET_PHYLIST:
-		{
-			unsigned char *cp = arg;
-			if (len < 3) {
-				bcmerror = -EOVERFLOW;
-				break;
-			}
+			mcsset_bss = wlc->default_bss;
+		memcpy(internal_rs.mcs, &mcsset_bss->rateset.mcs[0],
+		       MCSSET_LEN);
+	}
 
-			if (BRCMS_ISNPHY(wlc->band))
-				*cp++ = 'n';
-			else if (BRCMS_ISLCNPHY(wlc->band))
-				*cp++ = 'c';
-			else if (BRCMS_ISSSLPNPHY(wlc->band))
-				*cp++ = 's';
-			*cp = '\0';
-			break;
-		}
+	bcmerror = brcms_c_set_internal_rateset(wlc, &internal_rs);
+	if (!bcmerror)
+		brcms_c_ofdm_rateset_war(wlc);
 
-	case BRCMS_SET_SHORTSLOT_OVERRIDE:
-		if (val != BRCMS_SHORTSLOT_AUTO && val != BRCMS_SHORTSLOT_OFF &&
-		    val != BRCMS_SHORTSLOT_ON) {
-			bcmerror = -EINVAL;
-			break;
-		}
-
-		wlc->shortslot_override = (s8) val;
+	return bcmerror;
+}
 
-		/* shortslot is an 11g feature, so no more work if we are
-		 * currently on the 5G band
-		 */
-		if (wlc->band->bandtype == BRCM_BAND_5G)
-			break;
+int brcms_c_set_beacon_period(struct brcms_c_info *wlc, u16 period)
+{
+	if (period < DOT11_MIN_BEACON_PERIOD ||
+	    period > DOT11_MAX_BEACON_PERIOD)
+		return -EINVAL;
 
-		if (wlc->pub->up && wlc->pub->associated) {
-			/* let watchdog or beacon processing update shortslot */
-		} else if (wlc->pub->up) {
-			/* unassociated shortslot is off */
-			brcms_c_switch_shortslot(wlc, false);
-		} else {
-			/* driver is down, so just update the brcms_c_info
-			 * value */
-			if (wlc->shortslot_override == BRCMS_SHORTSLOT_AUTO)
-				wlc->shortslot = false;
-			else
-				wlc->shortslot =
-				    (wlc->shortslot_override ==
-				     BRCMS_SHORTSLOT_ON);
-		}
+	wlc->default_bss->beacon_period = period;
+	return 0;
+}
 
-		break;
+u16 brcms_c_get_phy_type(struct brcms_c_info *wlc, int phyidx)
+{
+	return wlc->band->phytype;
+}
 
+int brcms_c_set_shortslot_override(struct brcms_c_info *wlc, s8 sslot_override)
+{
+	if (sslot_override != BRCMS_SHORTSLOT_AUTO &&
+	    sslot_override != BRCMS_SHORTSLOT_OFF &&
+	    sslot_override != BRCMS_SHORTSLOT_ON) {
+		return -EINVAL;
 	}
- done:
 
-	if (bcmerror)
-		wlc->pub->bcmerror = bcmerror;
+	wlc->shortslot_override = sslot_override;
 
-	return bcmerror;
-}
+	/*
+	 * shortslot is an 11g feature, so no more work if we are
+	 * currently on the 5G band
+	 */
+	if (wlc->band->bandtype == BRCM_BAND_5G)
+		return 0;
 
-int
-brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len)
-{
-	return _brcms_c_ioctl(wlc, cmd, arg, len);
+	if (wlc->pub->up && wlc->pub->associated) {
+		/* let watchdog or beacon processing update shortslot */
+	} else if (wlc->pub->up) {
+		/* unassociated shortslot is off */
+		brcms_c_switch_shortslot(wlc, false);
+	} else {
+		/* driver is down, so just update the brcms_c_info
+		 * value */
+		if (wlc->shortslot_override == BRCMS_SHORTSLOT_AUTO)
+			wlc->shortslot = false;
+		else
+			wlc->shortslot =
+			    (wlc->shortslot_override ==
+			     BRCMS_SHORTSLOT_ON);
+	}
+	return 0;
 }
 
 /*
diff --git a/drivers/staging/brcm80211/brcmsmac/pub.h b/drivers/staging/brcm80211/brcmsmac/pub.h
index 33e7ebe..3655ac6 100644
--- a/drivers/staging/brcm80211/brcmsmac/pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/pub.h
@@ -312,8 +312,6 @@ extern uint brcms_c_detach(struct brcms_c_info *wlc);
 extern int brcms_c_up(struct brcms_c_info *wlc);
 extern uint brcms_c_down(struct brcms_c_info *wlc);
 
-extern int brcms_c_set(struct brcms_c_info *wlc, int cmd, int arg);
-extern int brcms_c_get(struct brcms_c_info *wlc, int cmd, int *arg);
 extern bool brcms_c_chipmatch(u16 vendor, u16 device);
 extern void brcms_c_init(struct brcms_c_info *wlc);
 extern void brcms_c_reset(struct brcms_c_info *wlc);
@@ -327,7 +325,6 @@ extern bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded);
 extern void brcms_c_sendpkt_mac80211(struct brcms_c_info *wlc,
 				     struct sk_buff *sdu,
 				     struct ieee80211_hw *hw);
-extern int brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len);
 extern bool brcms_c_aggregatable(struct brcms_c_info *wlc, u8 tid);
 
 /* helper functions */
@@ -382,6 +379,15 @@ extern int brcms_c_get_curband(struct brcms_c_info *wlc);
 extern void brcms_c_wait_for_tx_completion(struct brcms_c_info *wlc,
 					   bool drop);
 
+int brcms_c_set_channel(struct brcms_c_info *wlc, u16 channel);
+int brcms_c_set_rate_limit(struct brcms_c_info *wlc, u16 srl, u16 lrl);
+void brcms_c_get_current_rateset(struct brcms_c_info *wlc,
+				 struct brcm_rateset *currs);
+int brcms_c_set_rateset(struct brcms_c_info *wlc, struct brcm_rateset *rs);
+int brcms_c_set_beacon_period(struct brcms_c_info *wlc, u16 period);
+u16 brcms_c_get_phy_type(struct brcms_c_info *wlc, int phyidx);
+int brcms_c_set_shortslot_override(struct brcms_c_info *wlc, s8 sslot_override);
+
 /* helper functions */
 extern bool brcms_c_check_radio_disabled(struct brcms_c_info *wlc);
 extern bool brcms_c_radio_monitor_stop(struct brcms_c_info *wlc);
diff --git a/drivers/staging/brcm80211/include/defs.h b/drivers/staging/brcm80211/include/defs.h
index c745b7e..3438c54 100644
--- a/drivers/staging/brcm80211/include/defs.h
+++ b/drivers/staging/brcm80211/include/defs.h
@@ -57,14 +57,13 @@ struct brcm_rateset {
 
 #define BRCM_CNTRY_BUF_SZ	4	/* Country string is 3 bytes + NUL */
 
-#define BRCM_SET_CHANNEL				30
-#define BRCM_SET_SRL				32
-#define BRCM_SET_LRL				34
-
-#define BRCM_SET_RATESET				72
-#define BRCM_SET_BCNPRD				76
-#define BRCM_GET_CURR_RATESET			114	/* current rateset */
-#define BRCM_GET_PHYLIST				180
+#define BRCM_SET_CHANNEL	30
+#define BRCM_SET_SRL		32
+#define BRCM_SET_LRL		34
+#define BRCM_SET_BCNPRD		76
+
+#define BRCM_GET_CURR_RATESET	114	/* current rateset */
+#define BRCM_GET_PHYLIST	180
 
 /* Bit masks for radio disabled status - returned by WL_GET_RADIO */
 
-- 
1.7.4.1


