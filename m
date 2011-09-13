Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4062 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755084Ab1IMHuS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 03:50:18 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 11/17] staging: brcm80211: remove brcms_c_get_par and
 set_par functions
Date: Tue, 13 Sep 2011 09:49:51 +0200
Message-ID: <1315900197-7260-12-git-send-email-rvossen@broadcom.com> (sfid-20110913_095041_960004_9454CF4E)
In-Reply-To: <1315900197-7260-1-git-send-email-rvossen@broadcom.com>
References: <1315900197-7260-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The source main.c provided an interface function that handled several
things demultiplexing on given identifier. This interface has been
replaced by separate functions to make it more straightforward.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |   26 ++----
 drivers/staging/brcm80211/brcmsmac/main.c        |   87 ++++++---------------
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c |    2 +-
 drivers/staging/brcm80211/brcmsmac/pub.h         |    8 +-
 4 files changed, 39 insertions(+), 84 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index 5696b39..4cc0db6 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -373,14 +373,8 @@ static int brcms_ops_config(struct ieee80211_hw *hw, u32 changed)
 
 	LOCK(wl);
 	if (changed & IEEE80211_CONF_CHANGE_LISTEN_INTERVAL) {
-		if (brcms_c_set_par(wl->wlc, IOV_BCN_LI_BCN,
-				    conf->listen_interval) < 0) {
-			wiphy_err(wiphy, "%s: Error setting listen_interval\n",
-				  __func__);
-			err = -EIO;
-			goto config_out;
-		}
-		brcms_c_get_par(wl->wlc, IOV_BCN_LI_BCN, &new_int);
+		brcms_c_set_beacon_listen_interval(wl->wlc,
+						   conf->listen_interval);
 	}
 	if (changed & IEEE80211_CONF_CHANGE_MONITOR)
 		wiphy_err(wiphy, "%s: change monitor mode: %s (implement)\n",
@@ -392,17 +386,16 @@ static int brcms_ops_config(struct ieee80211_hw *hw, u32 changed)
 			  "true" : "false");
 
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
-		if (brcms_c_set_par(wl->wlc, IOV_QTXPOWER,
-				    conf->power_level * 4) < 0) {
+		err = brcms_c_set_tx_power(wl->wlc, conf->power_level);
+		if (err < 0) {
 			wiphy_err(wiphy, "%s: Error setting power_level\n",
 				  __func__);
-			err = -EIO;
 			goto config_out;
 		}
-		brcms_c_get_par(wl->wlc, IOV_QTXPOWER, &new_int);
-		if (new_int != (conf->power_level * 4))
+		new_int = brcms_c_get_tx_power(wl->wlc);
+		if (new_int != conf->power_level)
 			wiphy_err(wiphy, "%s: Power level req != actual, %d %d"
-				  "\n", __func__, conf->power_level * 4,
+				  "\n", __func__, conf->power_level,
 				  new_int);
 	}
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
@@ -1177,9 +1170,8 @@ static struct brcms_info *brcms_attach(u16 vendor, u16 device,
 
 	wl->pub->ieee_hw = hw;
 
-	if (brcms_c_set_par(wl->wlc, IOV_MPC, 0) < 0)
-		wiphy_err(wl->wiphy, "wl%d: Error setting MPC variable to 0\n",
-			  unit);
+	/* disable mpc */
+	brcms_c_set_radio_mpc(wl->wlc, false);
 
 	/* register our interrupt handler */
 	if (request_irq(irq, brcms_isr, IRQF_SHARED, KBUILD_MODNAME, wl)) {
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index a40fcba..ec7de38 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -9375,74 +9375,37 @@ void brcms_c_wait_for_tx_completion(struct brcms_c_info *wlc, bool drop)
 		brcms_msleep(wlc->wl, 1);
 }
 
-int brcms_c_set_par(struct brcms_c_info *wlc, enum wlc_par_id par_id,
-		    int int_val)
+void brcms_c_set_beacon_listen_interval(struct brcms_c_info *wlc, u8 interval)
 {
-	int err = 0;
+	wlc->bcn_li_bcn = interval;
+	if (wlc->pub->up)
+		brcms_c_bcn_li_upd(wlc);
+}
 
-	switch (par_id) {
-	case IOV_BCN_LI_BCN:
-		wlc->bcn_li_bcn = (u8) int_val;
-		if (wlc->pub->up)
-			brcms_c_bcn_li_upd(wlc);
-		break;
-		/* As long as override is false, this only sets the *user*
-		   targets. User can twiddle this all he wants with no harm.
-		   wlc_phy_txpower_set() explicitly sets override to false if
-		   not internal or test.
-		 */
-	case IOV_QTXPOWER:{
-		u8 qdbm;
-		bool override;
-
-		/* Remove override bit and clip to max qdbm value */
-		qdbm = (u8)min_t(u32, (int_val & ~WL_TXPWR_OVERRIDE), 0xff);
-		/* Extract override setting */
-		override = (int_val & WL_TXPWR_OVERRIDE) ? true : false;
-		err =
-		    wlc_phy_txpower_set(wlc->band->pi, qdbm, override);
-		break;
-		}
-	case IOV_MPC:
-		wlc->mpc = (bool)int_val;
-		brcms_c_radio_mpc_upd(wlc);
-		break;
-	default:
-		err = -ENOTSUPP;
-	}
-	return err;
+int brcms_c_set_tx_power(struct brcms_c_info *wlc, int txpwr)
+{
+	uint qdbm;
+
+	/* Remove override bit and clip to max qdbm value */
+	qdbm = min_t(uint, txpwr * BRCMS_TXPWR_DB_FACTOR, 0xff);
+	return wlc_phy_txpower_set(wlc->band->pi, qdbm, false);
 }
 
-int brcms_c_get_par(struct brcms_c_info *wlc, enum wlc_par_id par_id,
-		    int *ret_int_ptr)
+int brcms_c_get_tx_power(struct brcms_c_info *wlc)
 {
-	int err = 0;
+	uint qdbm;
+	bool override;
 
-	switch (par_id) {
-	case IOV_BCN_LI_BCN:
-		*ret_int_ptr = wlc->bcn_li_bcn;
-		break;
-	case IOV_QTXPOWER: {
-		uint qdbm;
-		bool override;
-
-		err = wlc_phy_txpower_get(wlc->band->pi, &qdbm,
-			&override);
-		if (err != 0)
-			return err;
-
-		/* Return qdbm units */
-		*ret_int_ptr =
-		    qdbm | (override ? WL_TXPWR_OVERRIDE : 0);
-		break;
-		}
-	case IOV_MPC:
-		*ret_int_ptr = (s32) wlc->mpc;
-		break;
-	default:
-		err = -ENOTSUPP;
-	}
-	return err;
+	wlc_phy_txpower_get(wlc->band->pi, &qdbm, &override);
+
+	/* Return qdbm units */
+	return (int)(qdbm / BRCMS_TXPWR_DB_FACTOR);
+}
+
+void brcms_c_set_radio_mpc(struct brcms_c_info *wlc, bool mpc)
+{
+	wlc->mpc = mpc;
+	brcms_c_radio_mpc_upd(wlc);
 }
 
 /*
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index eb171f0..196a595 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -1463,7 +1463,7 @@ int wlc_phy_txpower_set(struct brcms_phy_pub *ppi, uint qdbm, bool override)
 	int i;
 
 	if (qdbm > 127)
-		return 5;
+		return -EINVAL;
 
 	for (i = 0; i < TXP_NUM_RATES; i++)
 		pi->tx_user_target[i] = (u8) qdbm;
diff --git a/drivers/staging/brcm80211/brcmsmac/pub.h b/drivers/staging/brcm80211/brcmsmac/pub.h
index 6230350..c72f7b5 100644
--- a/drivers/staging/brcm80211/brcmsmac/pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/pub.h
@@ -350,10 +350,6 @@ extern void brcms_c_ampdu_flush(struct brcms_c_info *wlc,
 			    struct ieee80211_sta *sta, u16 tid);
 extern void brcms_c_ampdu_tx_operational(struct brcms_c_info *wlc, u8 tid,
 					 u8 ba_wsize, uint max_rx_ampdu_bytes);
-extern int brcms_c_set_par(struct brcms_c_info *wlc, enum wlc_par_id par_id,
-			   int val);
-extern int brcms_c_get_par(struct brcms_c_info *wlc, enum wlc_par_id par_id,
-			   int *ret_int_ptr);
 extern char *getvar(char *vars, const char *name);
 extern int getintvar(char *vars, const char *name);
 
@@ -384,6 +380,10 @@ int brcms_c_set_beacon_period(struct brcms_c_info *wlc, u16 period);
 u16 brcms_c_get_phy_type(struct brcms_c_info *wlc, int phyidx);
 void brcms_c_set_shortslot_override(struct brcms_c_info *wlc,
 				    s8 sslot_override);
+void brcms_c_set_beacon_listen_interval(struct brcms_c_info *wlc, u8 interval);
+int brcms_c_set_tx_power(struct brcms_c_info *wlc, int txpwr);
+int brcms_c_get_tx_power(struct brcms_c_info *wlc);
+void brcms_c_set_radio_mpc(struct brcms_c_info *wlc, bool mpc);
 
 /* helper functions */
 extern bool brcms_c_check_radio_disabled(struct brcms_c_info *wlc);
-- 
1.7.4.1


