Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:34556 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933290Ab2JZOYK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 10:24:10 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 09/18] brcmsmac: Use debug macros for general error and debug statements
Date: Fri, 26 Oct 2012 09:23:24 -0500
Message-Id: <1351261413-20821-10-git-send-email-seth.forshee@canonical.com> (sfid-20121026_162416_243149_BB3A1A4E)
In-Reply-To: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com>
References: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Convert most uses of wiphy_* and pr_* for general error and debug
messages to use the internal debug macros instead. Most code used only
for initialization still use wiphy_err(), as well as some locations
which are executed too early to use the debug macros. Some debug
messages which are redundant or not useful are removed.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c    |   20 +-
 drivers/net/wireless/brcm80211/brcmsmac/antsel.c   |    4 +-
 drivers/net/wireless/brcm80211/brcmsmac/channel.c  |   10 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |  107 +++----
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |  292 ++++++++++----------
 5 files changed, 221 insertions(+), 212 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
index a59954f..279b1a5 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
@@ -21,6 +21,7 @@
 #include "antsel.h"
 #include "main.h"
 #include "ampdu.h"
+#include "brcms_debug.h"
 
 /* max number of mpdus in an ampdu */
 #define AMPDU_MAX_MPDU			32
@@ -179,18 +180,19 @@ static bool brcms_c_ampdu_cap(struct ampdu_info *ampdu)
 static int brcms_c_ampdu_set(struct ampdu_info *ampdu, bool on)
 {
 	struct brcms_c_info *wlc = ampdu->wlc;
+	struct bcma_device *core = wlc->hw->d11core;
 
 	wlc->pub->_ampdu = false;
 
 	if (on) {
 		if (!(wlc->pub->_n_enab & SUPPORT_11N)) {
-			wiphy_err(ampdu->wlc->wiphy, "wl%d: driver not "
-				"nmode enabled\n", wlc->pub->unit);
+			BRCMS_ERR(core, "wl%d: driver not nmode enabled\n",
+				  wlc->pub->unit);
 			return -ENOTSUPP;
 		}
 		if (!brcms_c_ampdu_cap(ampdu)) {
-			wiphy_err(ampdu->wlc->wiphy, "wl%d: device not "
-				"ampdu capable\n", wlc->pub->unit);
+			BRCMS_ERR(core, "wl%d: device not ampdu capable\n",
+				  wlc->pub->unit);
 			return -ENOTSUPP;
 		}
 		wlc->pub->_ampdu = on;
@@ -481,7 +483,7 @@ brcms_c_ampdu_tx_operational(struct brcms_c_info *wlc, u8 tid,
 	scb_ampdu = &scb->scb_ampdu;
 
 	if (!ampdu->ini_enable[tid]) {
-		wiphy_err(ampdu->wlc->wiphy, "%s: Rejecting tid %d\n",
+		BRCMS_ERR(wlc->hw->d11core, "%s: Rejecting tid %d\n",
 			  __func__, tid);
 		return;
 	}
@@ -896,13 +898,14 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 		if (supr_status) {
 			update_rate = false;
 			if (supr_status == TX_STATUS_SUPR_BADCH) {
-				wiphy_err(wiphy,
+				BRCMS_ERR(wlc->hw->d11core,
 					  "%s: Pkt tx suppressed, illegal channel possibly %d\n",
 					  __func__, CHSPEC_CHANNEL(
 					  wlc->default_bss->chanspec));
 			} else {
 				if (supr_status != TX_STATUS_SUPR_FRAG)
-					wiphy_err(wiphy, "%s: supr_status 0x%x\n",
+					BRCMS_ERR(wlc->hw->d11core,
+						  "%s: supr_status 0x%x\n",
 						  __func__, supr_status);
 			}
 			/* no need to retry for badch; will fail again */
@@ -923,7 +926,8 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 			}
 		} else if (txs->phyerr) {
 			update_rate = false;
-			wiphy_err(wiphy, "%s: ampdu tx phy error (0x%x)\n",
+			BRCMS_ERR(wlc->hw->d11core,
+				  "%s: ampdu tx phy error (0x%x)\n",
 				  __func__, txs->phyerr);
 
 			if (brcm_have_debug_level(BRCM_DL_INFO)) {
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/antsel.c b/drivers/net/wireless/brcm80211/brcmsmac/antsel.c
index 55e12c3..94cd684 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/antsel.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/antsel.c
@@ -21,6 +21,7 @@
 #include "main.h"
 #include "phy_shim.h"
 #include "antsel.h"
+#include "brcms_debug.h"
 
 #define ANT_SELCFG_AUTO		0x80	/* bit indicates antenna sel AUTO */
 #define ANT_SELCFG_MASK		0x33	/* antenna configuration mask */
@@ -137,7 +138,8 @@ struct antsel_info *brcms_c_antsel_attach(struct brcms_c_info *wlc)
 				asi->antsel_avail = false;
 			} else {
 				asi->antsel_avail = false;
-				wiphy_err(wlc->wiphy, "antsel_attach: 2o3 "
+				BRCMS_ERR(wlc->hw->d11core,
+					  "antsel_attach: 2o3 "
 					  "board cfg invalid\n");
 			}
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
index 64a48f0..a256a89 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/channel.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
@@ -26,6 +26,7 @@
 #include "stf.h"
 #include "channel.h"
 #include "mac80211_if.h"
+#include "brcms_debug.h"
 
 /* QDB() macro takes a dB value and converts to a quarter dB value */
 #define QDB(n) ((n) * BRCMS_TXPWR_DB_FACTOR)
@@ -336,8 +337,6 @@ struct brcms_cm_info *brcms_c_channel_mgr_attach(struct brcms_c_info *wlc)
 	const char *ccode = sprom->alpha2;
 	int ccode_len = sizeof(sprom->alpha2);
 
-	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
-
 	wlc_cm = kzalloc(sizeof(struct brcms_cm_info), GFP_ATOMIC);
 	if (wlc_cm == NULL)
 		return NULL;
@@ -615,8 +614,8 @@ brcms_c_valid_chanspec_ext(struct brcms_cm_info *wlc_cm, u16 chspec)
 
 	/* check the chanspec */
 	if (brcms_c_chspec_malformed(chspec)) {
-		wiphy_err(wlc->wiphy, "wl%d: malformed chanspec 0x%x\n",
-			wlc->pub->unit, chspec);
+		BRCMS_ERR(wlc->hw->d11core, "wl%d: malformed chanspec 0x%x\n",
+			  wlc->pub->unit, chspec);
 		return false;
 	}
 
@@ -738,7 +737,8 @@ static int brcms_reg_notifier(struct wiphy *wiphy,
 		mboolclr(wlc->pub->radio_disabled, WL_RADIO_COUNTRY_DISABLE);
 	} else {
 		mboolset(wlc->pub->radio_disabled, WL_RADIO_COUNTRY_DISABLE);
-		wiphy_err(wlc->wiphy, "wl%d: %s: no valid channel for \"%s\"\n",
+		BRCMS_ERR(wlc->hw->d11core,
+			  "wl%d: %s: no valid channel for \"%s\"\n",
 			  wlc->pub->unit, __func__, request->alpha2);
 	}
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 37b9966..ebca6a5 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -33,6 +33,7 @@
 #include "ucode_loader.h"
 #include "mac80211_if.h"
 #include "main.h"
+#include "brcms_debug.h"
 
 #define N_TX_QUEUES	4 /* #tx queues on mac80211<->driver interface */
 
@@ -280,7 +281,7 @@ static void brcms_ops_tx(struct ieee80211_hw *hw,
 
 	spin_lock_bh(&wl->lock);
 	if (!wl->pub->up) {
-		wiphy_err(wl->wiphy, "ops->tx called while down\n");
+		BRCMS_ERR(wl->wlc->hw->d11core, "ops->tx called while down\n");
 		kfree_skb(skb);
 		goto done;
 	}
@@ -317,8 +318,8 @@ static int brcms_ops_start(struct ieee80211_hw *hw)
 	spin_unlock_bh(&wl->lock);
 
 	if (err != 0)
-		wiphy_err(hw->wiphy, "%s: brcms_up() returned %d\n", __func__,
-			  err);
+		BRCMS_ERR(wl->wlc->hw->d11core, "%s: brcms_up() returned %d\n",
+			  __func__, err);
 	return err;
 }
 
@@ -336,7 +337,7 @@ static void brcms_ops_stop(struct ieee80211_hw *hw)
 	status = brcms_c_chipmatch(wl->wlc->hw->d11core);
 	spin_unlock_bh(&wl->lock);
 	if (!status) {
-		wiphy_err(wl->wiphy,
+		BRCMS_ERR(wl->wlc->hw->d11core,
 			  "wl: brcms_ops_stop: chipmatch failed\n");
 		return;
 	}
@@ -354,8 +355,9 @@ brcms_ops_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 
 	/* Just STA for now */
 	if (vif->type != NL80211_IFTYPE_STATION) {
-		wiphy_err(hw->wiphy, "%s: Attempt to add type %d, only"
-			  " STA for now\n", __func__, vif->type);
+		BRCMS_ERR(wl->wlc->hw->d11core,
+			  "%s: Attempt to add type %d, only STA for now\n",
+			  __func__, vif->type);
 		return -EOPNOTSUPP;
 	}
 
@@ -374,9 +376,9 @@ static int brcms_ops_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct ieee80211_conf *conf = &hw->conf;
 	struct brcms_info *wl = hw->priv;
+	struct bcma_device *core = wl->wlc->hw->d11core;
 	int err = 0;
 	int new_int;
-	struct wiphy *wiphy = hw->wiphy;
 
 	spin_lock_bh(&wl->lock);
 	if (changed & IEEE80211_CONF_CHANGE_LISTEN_INTERVAL) {
@@ -384,25 +386,26 @@ static int brcms_ops_config(struct ieee80211_hw *hw, u32 changed)
 						   conf->listen_interval);
 	}
 	if (changed & IEEE80211_CONF_CHANGE_MONITOR)
-		wiphy_dbg(wiphy, "%s: change monitor mode: %s\n",
-			  __func__, conf->flags & IEEE80211_CONF_MONITOR ?
-			  "true" : "false");
+		BRCMS_DBG_INFO(core, "%s: change monitor mode: %s\n",
+			       __func__, conf->flags & IEEE80211_CONF_MONITOR ?
+			       "true" : "false");
 	if (changed & IEEE80211_CONF_CHANGE_PS)
-		wiphy_err(wiphy, "%s: change power-save mode: %s (implement)\n",
+		BRCMS_ERR(core, "%s: change power-save mode: %s (implement)\n",
 			  __func__, conf->flags & IEEE80211_CONF_PS ?
 			  "true" : "false");
 
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
 		err = brcms_c_set_tx_power(wl->wlc, conf->power_level);
 		if (err < 0) {
-			wiphy_err(wiphy, "%s: Error setting power_level\n",
+			BRCMS_ERR(core, "%s: Error setting power_level\n",
 				  __func__);
 			goto config_out;
 		}
 		new_int = brcms_c_get_tx_power(wl->wlc);
 		if (new_int != conf->power_level)
-			wiphy_err(wiphy, "%s: Power level req != actual, %d %d"
-				  "\n", __func__, conf->power_level,
+			BRCMS_ERR(core,
+				  "%s: Power level req != actual, %d %d\n",
+				  __func__, conf->power_level,
 				  new_int);
 	}
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
@@ -429,13 +432,13 @@ brcms_ops_bss_info_changed(struct ieee80211_hw *hw,
 			struct ieee80211_bss_conf *info, u32 changed)
 {
 	struct brcms_info *wl = hw->priv;
-	struct wiphy *wiphy = hw->wiphy;
+	struct bcma_device *core = wl->wlc->hw->d11core;
 
 	if (changed & BSS_CHANGED_ASSOC) {
 		/* association status changed (associated/disassociated)
 		 * also implies a change in the AID.
 		 */
-		wiphy_err(wiphy, "%s: %s: %sassociated\n", KBUILD_MODNAME,
+		BRCMS_ERR(core, "%s: %s: %sassociated\n", KBUILD_MODNAME,
 			  __func__, info->assoc ? "" : "dis");
 		spin_lock_bh(&wl->lock);
 		brcms_c_associate_upd(wl->wlc, info->assoc);
@@ -495,7 +498,7 @@ brcms_ops_bss_info_changed(struct ieee80211_hw *hw,
 		error = brcms_c_set_rateset(wl->wlc, &rs);
 		spin_unlock_bh(&wl->lock);
 		if (error)
-			wiphy_err(wiphy, "changing basic rates failed: %d\n",
+			BRCMS_ERR(core, "changing basic rates failed: %d\n",
 				  error);
 	}
 	if (changed & BSS_CHANGED_BEACON_INT) {
@@ -512,30 +515,30 @@ brcms_ops_bss_info_changed(struct ieee80211_hw *hw,
 	}
 	if (changed & BSS_CHANGED_BEACON)
 		/* Beacon data changed, retrieve new beacon (beaconing modes) */
-		wiphy_err(wiphy, "%s: beacon changed\n", __func__);
+		BRCMS_ERR(core, "%s: beacon changed\n", __func__);
 
 	if (changed & BSS_CHANGED_BEACON_ENABLED) {
 		/* Beaconing should be enabled/disabled (beaconing modes) */
-		wiphy_err(wiphy, "%s: Beacon enabled: %s\n", __func__,
+		BRCMS_ERR(core, "%s: Beacon enabled: %s\n", __func__,
 			  info->enable_beacon ? "true" : "false");
 	}
 
 	if (changed & BSS_CHANGED_CQM) {
 		/* Connection quality monitor config changed */
-		wiphy_err(wiphy, "%s: cqm change: threshold %d, hys %d "
+		BRCMS_ERR(core, "%s: cqm change: threshold %d, hys %d "
 			  " (implement)\n", __func__, info->cqm_rssi_thold,
 			  info->cqm_rssi_hyst);
 	}
 
 	if (changed & BSS_CHANGED_IBSS) {
 		/* IBSS join status changed */
-		wiphy_err(wiphy, "%s: IBSS joined: %s (implement)\n", __func__,
-			  info->ibss_joined ? "true" : "false");
+		BRCMS_ERR(core, "%s: IBSS joined: %s (implement)\n",
+			  __func__, info->ibss_joined ? "true" : "false");
 	}
 
 	if (changed & BSS_CHANGED_ARP_FILTER) {
 		/* Hardware ARP filter address list or state changed */
-		wiphy_err(wiphy, "%s: arp filtering: enabled %s, count %d"
+		BRCMS_ERR(core, "%s: arp filtering: enabled %s, count %d"
 			  " (implement)\n", __func__, info->arp_filter_enabled ?
 			  "true" : "false", info->arp_addr_cnt);
 	}
@@ -545,8 +548,8 @@ brcms_ops_bss_info_changed(struct ieee80211_hw *hw,
 		 * QoS for this association was enabled/disabled.
 		 * Note that it is only ever disabled for station mode.
 		 */
-		wiphy_err(wiphy, "%s: qos enabled: %s (implement)\n", __func__,
-			  info->qos ? "true" : "false");
+		BRCMS_ERR(core, "%s: qos enabled: %s (implement)\n",
+			  __func__, info->qos ? "true" : "false");
 	}
 	return;
 }
@@ -557,25 +560,25 @@ brcms_ops_configure_filter(struct ieee80211_hw *hw,
 			unsigned int *total_flags, u64 multicast)
 {
 	struct brcms_info *wl = hw->priv;
-	struct wiphy *wiphy = hw->wiphy;
+	struct bcma_device *core = wl->wlc->hw->d11core;
 
 	changed_flags &= MAC_FILTERS;
 	*total_flags &= MAC_FILTERS;
 
 	if (changed_flags & FIF_PROMISC_IN_BSS)
-		wiphy_dbg(wiphy, "FIF_PROMISC_IN_BSS\n");
+		BRCMS_DBG_INFO(core, "FIF_PROMISC_IN_BSS\n");
 	if (changed_flags & FIF_ALLMULTI)
-		wiphy_dbg(wiphy, "FIF_ALLMULTI\n");
+		BRCMS_DBG_INFO(core, "FIF_ALLMULTI\n");
 	if (changed_flags & FIF_FCSFAIL)
-		wiphy_dbg(wiphy, "FIF_FCSFAIL\n");
+		BRCMS_DBG_INFO(core, 0, "FIF_FCSFAIL\n");
 	if (changed_flags & FIF_CONTROL)
-		wiphy_dbg(wiphy, "FIF_CONTROL\n");
+		BRCMS_DBG_INFO(core, "FIF_CONTROL\n");
 	if (changed_flags & FIF_OTHER_BSS)
-		wiphy_dbg(wiphy, "FIF_OTHER_BSS\n");
+		BRCMS_DBG_INFO(core, "FIF_OTHER_BSS\n");
 	if (changed_flags & FIF_PSPOLL)
-		wiphy_dbg(wiphy, "FIF_PSPOLL\n");
+		BRCMS_DBG_INFO(core, "FIF_PSPOLL\n");
 	if (changed_flags & FIF_BCN_PRBRESP_PROMISC)
-		wiphy_dbg(wiphy, "FIF_BCN_PRBRESP_PROMISC\n");
+		BRCMS_DBG_INFO(core, "FIF_BCN_PRBRESP_PROMISC\n");
 
 	spin_lock_bh(&wl->lock);
 	brcms_c_mac_promisc(wl->wlc, *total_flags);
@@ -657,8 +660,8 @@ brcms_ops_ampdu_action(struct ieee80211_hw *hw,
 		status = brcms_c_aggregatable(wl->wlc, tid);
 		spin_unlock_bh(&wl->lock);
 		if (!status) {
-			wiphy_err(wl->wiphy, "START: tid %d is not agg\'able\n",
-				  tid);
+			BRCMS_ERR(wl->wlc->hw->d11core,
+				  "START: tid %d is not agg\'able\n", tid);
 			return -EINVAL;
 		}
 		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
@@ -685,8 +688,8 @@ brcms_ops_ampdu_action(struct ieee80211_hw *hw,
 		/* Power save wakeup */
 		break;
 	default:
-		wiphy_err(wl->wiphy, "%s: Invalid command, ignoring\n",
-			  __func__);
+		BRCMS_ERR(wl->wlc->hw->d11core,
+			  "%s: Invalid command, ignoring\n", __func__);
 	}
 
 	return 0;
@@ -1148,14 +1151,13 @@ static int brcms_suspend(struct bcma_device *pdev)
 	wl->pub->hw_up = false;
 	spin_unlock_bh(&wl->lock);
 
-	pr_debug("brcms_suspend ok\n");
+	BRCMS_DBG_INFO(wl->wlc->hw->d11core, "brcms_suspend ok\n");
 
 	return 0;
 }
 
 static int brcms_resume(struct bcma_device *pdev)
 {
-	pr_debug("brcms_resume ok\n");
 	return 0;
 }
 
@@ -1216,7 +1218,7 @@ module_exit(brcms_module_exit);
 void brcms_txflowcontrol(struct brcms_info *wl, struct brcms_if *wlif,
 			 bool state, int prio)
 {
-	wiphy_err(wl->wiphy, "Shouldn't be here %s\n", __func__);
+	BRCMS_ERR(wl->wlc->hw->d11core, "Shouldn't be here %s\n", __func__);
 }
 
 /*
@@ -1224,7 +1226,8 @@ void brcms_txflowcontrol(struct brcms_info *wl, struct brcms_if *wlif,
  */
 void brcms_init(struct brcms_info *wl)
 {
-	BCMMSG(wl->pub->ieee_hw->wiphy, "wl%d\n", wl->pub->unit);
+	BRCMS_DBG_INFO(wl->wlc->hw->d11core, "Initializing wl%d\n",
+		       wl->pub->unit);
 	brcms_reset(wl);
 	brcms_c_init(wl->wlc, wl->mute_tx);
 }
@@ -1234,7 +1237,7 @@ void brcms_init(struct brcms_info *wl)
  */
 uint brcms_reset(struct brcms_info *wl)
 {
-	BCMMSG(wl->pub->ieee_hw->wiphy, "wl%d\n", wl->pub->unit);
+	BRCMS_DBG_INFO(wl->wlc->hw->d11core, "Resetting wl%d\n", wl->pub->unit);
 	brcms_c_reset(wl->wlc);
 
 	/* dpc will not be rescheduled */
@@ -1248,7 +1251,7 @@ uint brcms_reset(struct brcms_info *wl)
 
 void brcms_fatal_error(struct brcms_info *wl)
 {
-	wiphy_err(wl->wlc->wiphy, "wl%d: fatal error, reinitializing\n",
+	BRCMS_ERR(wl->wlc->hw->d11core, "wl%d: fatal error, reinitializing\n",
 		  wl->wlc->pub->unit);
 	brcms_reset(wl);
 	ieee80211_restart_hw(wl->pub->ieee_hw);
@@ -1396,8 +1399,9 @@ void brcms_add_timer(struct brcms_timer *t, uint ms, int periodic)
 
 #ifdef DEBUG
 	if (t->set)
-		wiphy_err(hw->wiphy, "%s: Already set. Name: %s, per %d\n",
-			  __func__, t->name, periodic);
+		BRCMS_DBG_INFO(t->wl->wlc->hw->d11core,
+			       "%s: Already set. Name: %s, per %d\n",
+			       __func__, t->name, periodic);
 #endif
 	t->ms = ms;
 	t->periodic = (bool) periodic;
@@ -1486,8 +1490,8 @@ int brcms_ucode_init_buf(struct brcms_info *wl, void **pbuf, u32 idx)
 			}
 		}
 	}
-	wiphy_err(wl->wiphy, "ERROR: ucode buf tag:%d can not be found!\n",
-		  idx);
+	BRCMS_ERR(wl->wlc->hw->d11core,
+		  "ERROR: ucode buf tag:%d can not be found!\n", idx);
 	*pbuf = NULL;
 fail:
 	return -ENODATA;
@@ -1510,7 +1514,7 @@ int brcms_ucode_init_uint(struct brcms_info *wl, size_t *n_bytes, u32 idx)
 				pdata = wl->fw.fw_bin[i]->data +
 					le32_to_cpu(hdr->offset);
 				if (le32_to_cpu(hdr->len) != 4) {
-					wiphy_err(wl->wiphy,
+					BRCMS_ERR(wl->wlc->hw->d11core,
 						  "ERROR: fw hdr len\n");
 					return -ENOMSG;
 				}
@@ -1519,7 +1523,8 @@ int brcms_ucode_init_uint(struct brcms_info *wl, size_t *n_bytes, u32 idx)
 			}
 		}
 	}
-	wiphy_err(wl->wiphy, "ERROR: ucode tag:%d can not be found!\n", idx);
+	BRCMS_ERR(wl->wlc->hw->d11core,
+		  "ERROR: ucode tag:%d can not be found!\n", idx);
 	return -ENOMSG;
 }
 
@@ -1560,8 +1565,8 @@ int brcms_check_firmwares(struct brcms_info *wl)
 				sizeof(struct firmware_hdr));
 			rc = -EBADF;
 		} else if (fw->size < MIN_FW_SIZE || fw->size > MAX_FW_SIZE) {
-			wiphy_err(wl->wiphy, "%s: out of bounds fw file size "
-				  "%zu\n", __func__, fw->size);
+			wiphy_err(wl->wiphy, "%s: out of bounds fw file size %zu\n",
+				  __func__, fw->size);
 			rc = -EBADF;
 		} else {
 			/* check if ucode section overruns firmware image */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index fbc39b1..a5fafb0 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -35,6 +35,7 @@
 #include "main.h"
 #include "soc.h"
 #include "dma.h"
+#include "brcms_debug.h"
 
 /*
  * Indication for txflowcontrol that all priority bits in
@@ -646,7 +647,7 @@ static uint brcms_c_calc_frame_time(struct brcms_c_info *wlc, u32 ratespec,
 	uint rate = rspec2rate(ratespec);
 
 	if (rate == 0) {
-		wiphy_err(wlc->wiphy, "wl%d: WAR: using rate of 1 mbps\n",
+		BRCMS_ERR(wlc->hw->d11core, "wl%d: WAR: using rate of 1 mbps\n",
 			  wlc->pub->unit);
 		rate = BRCM_RATE_1M;
 	}
@@ -716,7 +717,7 @@ static void brcms_c_write_inits(struct brcms_hardware *wlc_hw,
 	u16 size;
 	u32 value;
 
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
+	BRCMS_DBG_INFO(wlc_hw->d11core, "wl%d\n", wlc_hw->unit);
 
 	for (i = 0; inits[i].addr != cpu_to_le16(0xffff); i++) {
 		size = le16_to_cpu(inits[i].size);
@@ -745,7 +746,6 @@ static void brcms_c_write_mhf(struct brcms_hardware *wlc_hw, u16 *mhfs)
 
 static void brcms_c_ucode_bsinit(struct brcms_hardware *wlc_hw)
 {
-	struct wiphy *wiphy = wlc_hw->wlc->wiphy;
 	struct brcms_ucode *ucode = &wlc_hw->wlc->wl->ucode;
 
 	/* init microcode host flags */
@@ -756,8 +756,9 @@ static void brcms_c_ucode_bsinit(struct brcms_hardware *wlc_hw)
 		if (BRCMS_ISNPHY(wlc_hw->band))
 			brcms_c_write_inits(wlc_hw, ucode->d11n0bsinitvals16);
 		else
-			wiphy_err(wiphy, "%s: wl%d: unsupported phy in corerev"
-				  " %d\n", __func__, wlc_hw->unit,
+			BRCMS_ERR(wlc_hw->d11core,
+				  "%s: wl%d: unsupported phy in corerev %d\n",
+				  __func__, wlc_hw->unit,
 				  wlc_hw->corerev);
 	} else {
 		if (D11REV_IS(wlc_hw->corerev, 24)) {
@@ -765,12 +766,14 @@ static void brcms_c_ucode_bsinit(struct brcms_hardware *wlc_hw)
 				brcms_c_write_inits(wlc_hw,
 						    ucode->d11lcn0bsinitvals24);
 			else
-				wiphy_err(wiphy, "%s: wl%d: unsupported phy in"
-					  " core rev %d\n", __func__,
-					  wlc_hw->unit, wlc_hw->corerev);
+				BRCMS_ERR(wlc_hw->d11core,
+					  "%s: wl%d: unsupported phy in core rev %d\n",
+					  __func__, wlc_hw->unit,
+					  wlc_hw->corerev);
 		} else {
-			wiphy_err(wiphy, "%s: wl%d: unsupported corerev %d\n",
-				__func__, wlc_hw->unit, wlc_hw->corerev);
+			BRCMS_ERR(wlc_hw->d11core,
+				  "%s: wl%d: unsupported corerev %d\n",
+				  __func__, wlc_hw->unit, wlc_hw->corerev);
 		}
 	}
 }
@@ -785,7 +788,7 @@ static void brcms_b_core_ioctl(struct brcms_hardware *wlc_hw, u32 m, u32 v)
 
 static void brcms_b_core_phy_clk(struct brcms_hardware *wlc_hw, bool clk)
 {
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d: clk %d\n", wlc_hw->unit, clk);
+	BRCMS_DBG_INFO(wlc_hw->d11core, "wl%d: clk %d\n", wlc_hw->unit, clk);
 
 	wlc_hw->phyclk = clk;
 
@@ -904,7 +907,7 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 
 	if (txs->phyerr) {
 		if (brcm_have_debug_level(BRCM_DL_INFO)) {
-			wiphy_err(wlc->wiphy, "phyerr 0x%x, rate 0x%x\n",
+			BRCMS_ERR(wlc->hw->d11core, "phyerr 0x%x, rate 0x%x\n",
 				  txs->phyerr, txh->MainRates);
 			brcms_c_print_txdesc(txh);
 		}
@@ -940,7 +943,7 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 	lastframe = !ieee80211_has_morefrags(h->frame_control);
 
 	if (!lastframe) {
-		wiphy_err(wlc->wiphy, "Not last frame!\n");
+		BRCMS_ERR(wlc->hw->d11core, "Not last frame!\n");
 	} else {
 		/*
 		 * Set information to be consumed by Minstrel ht.
@@ -1012,8 +1015,9 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 		skb_pull(p, D11_TXH_LEN);
 		ieee80211_tx_status_irqsafe(wlc->pub->ieee_hw, p);
 	} else {
-		wiphy_err(wlc->wiphy, "%s: Not last frame => not calling "
-			  "tx_status\n", __func__);
+		BRCMS_ERR(wlc->hw->d11core,
+			  "%s: Not last frame => not calling tx_status\n",
+			  __func__);
 	}
 
 	fatal = false;
@@ -1061,8 +1065,8 @@ brcms_b_txstatus(struct brcms_hardware *wlc_hw, bool bound, bool *fatal)
 	       && (s1 & TXS_V)) {
 
 		if (s1 == 0xffffffff) {
-			wiphy_err(wlc->wiphy, "wl%d: %s: dead chip\n",
-				wlc_hw->unit, __func__);
+			BRCMS_ERR(core, "wl%d: %s: dead chip\n", wlc_hw->unit,
+				  __func__);
 			return morepending;
 		}
 		s2 = bcma_read32(core, D11REGOFFS(frmtxstatus2));
@@ -1138,7 +1142,6 @@ static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 	u16 pio_mhf2 = 0;
 	struct brcms_hardware *wlc_hw = wlc->hw;
 	uint unit = wlc_hw->unit;
-	struct wiphy *wiphy = wlc->wiphy;
 
 	/* name and offsets for dma_attach */
 	snprintf(name, sizeof(name), "wl%d", unit);
@@ -1194,8 +1197,9 @@ static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 /* Cleaner to leave this as if with AP defined */
 
 		if (dma_attach_err) {
-			wiphy_err(wiphy, "wl%d: wlc_attach: dma_attach failed"
-				  "\n", unit);
+			BRCMS_ERR(wlc_hw->d11core,
+				  "wl%d: wlc_attach: dma_attach failed\n",
+				  unit);
 			return false;
 		}
 
@@ -1553,7 +1557,7 @@ brcms_b_write_template_ram(struct brcms_hardware *wlc_hw, int offset, int len,
 	__le32 word_le;
 	__be32 word_be;
 	bool be_bit;
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
+	BRCMS_DBG_INFO(core, "wl%d\n", wlc_hw->unit);
 
 	bcma_write32(core, D11REGOFFS(tplatewrptr), offset);
 
@@ -1762,8 +1766,6 @@ static void brcms_b_bsinit(struct brcms_c_info *wlc, u16 chanspec)
 /* Perform a soft reset of the PHY PLL */
 void brcms_b_core_phypll_reset(struct brcms_hardware *wlc_hw)
 {
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
-
 	ai_cc_reg(wlc_hw->sih, offsetof(struct chipcregs, chipcontrol_addr),
 		  ~0, 0);
 	udelay(1);
@@ -1808,7 +1810,7 @@ void brcms_b_phy_reset(struct brcms_hardware *wlc_hw)
 	u32 phy_bw_clkbits;
 	bool phy_in_reset = false;
 
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
+	BRCMS_DBG_INFO(wlc_hw->d11core, "wl%d: reset phy\n", wlc_hw->unit);
 
 	if (pih == NULL)
 		return;
@@ -1942,7 +1944,7 @@ static void brcms_c_get_macaddr(struct brcms_hardware *wlc_hw, u8 etheraddr[ETH_
 /* power both the pll and external oscillator on/off */
 static void brcms_b_xtal(struct brcms_hardware *wlc_hw, bool want)
 {
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d: want %d\n", wlc_hw->unit, want);
+	BRCMS_DBG_INFO(wlc_hw->d11core, "wl%d: want %d\n", wlc_hw->unit, want);
 
 	/*
 	 * dont power down if plldown is false or
@@ -2031,7 +2033,7 @@ void brcms_b_corereset(struct brcms_hardware *wlc_hw, u32 flags)
 	if (flags == BRCMS_USE_COREFLAGS)
 		flags = (wlc_hw->band->pi ? wlc_hw->band->core_flags : 0);
 
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
+	BRCMS_DBG_INFO(wlc_hw->d11core, "wl%d: core reset\n", wlc_hw->unit);
 
 	/* request FAST clock if not on  */
 	fastclk = wlc_hw->forcefastclk;
@@ -2042,13 +2044,13 @@ void brcms_b_corereset(struct brcms_hardware *wlc_hw, u32 flags)
 	if (bcma_core_is_enabled(wlc_hw->d11core)) {
 		for (i = 0; i < NFIFO; i++)
 			if ((wlc_hw->di[i]) && (!dma_txreset(wlc_hw->di[i])))
-				wiphy_err(wlc_hw->wlc->wiphy, "wl%d: %s: "
+				BRCMS_ERR(wlc_hw->d11core, "wl%d: %s: "
 					  "dma_txreset[%d]: cannot stop dma\n",
 					   wlc_hw->unit, __func__, i);
 
 		if ((wlc_hw->di[RX_FIFO])
 		    && (!wlc_dma_rxreset(wlc_hw, RX_FIFO)))
-			wiphy_err(wlc_hw->wlc->wiphy, "wl%d: %s: dma_rxreset"
+			BRCMS_ERR(wlc_hw->d11core, "wl%d: %s: dma_rxreset"
 				  "[%d]: cannot stop dma\n",
 				  wlc_hw->unit, __func__, RX_FIFO);
 	}
@@ -2261,7 +2263,7 @@ static void brcms_ucode_write(struct brcms_hardware *wlc_hw,
 	uint i;
 	uint count;
 
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
+	BRCMS_DBG_INFO(wlc_hw->d11core, "wl%d\n", wlc_hw->unit);
 
 	count = (nbytes / sizeof(u32));
 
@@ -2289,8 +2291,8 @@ static void brcms_ucode_download(struct brcms_hardware *wlc_hw)
 					  ucode->bcm43xx_16_mimosz);
 			wlc_hw->ucode_loaded = true;
 		} else
-			wiphy_err(wlc->wiphy, "%s: wl%d: unsupported phy in "
-				  "corerev %d\n",
+			BRCMS_ERR(wlc_hw->d11core,
+				  "%s: wl%d: unsupported phy in corerev %d\n",
 				  __func__, wlc_hw->unit, wlc_hw->corerev);
 	} else if (D11REV_IS(wlc_hw->corerev, 24)) {
 		if (BRCMS_ISLCNPHY(wlc_hw->band)) {
@@ -2298,8 +2300,8 @@ static void brcms_ucode_download(struct brcms_hardware *wlc_hw)
 					  ucode->bcm43xx_24_lcnsz);
 			wlc_hw->ucode_loaded = true;
 		} else {
-			wiphy_err(wlc->wiphy, "%s: wl%d: unsupported phy in "
-				  "corerev %d\n",
+			BRCMS_ERR(wlc_hw->d11core,
+				  "%s: wl%d: unsupported phy in corerev %d\n",
 				  __func__, wlc_hw->unit, wlc_hw->corerev);
 		}
 	}
@@ -2336,7 +2338,6 @@ static void brcms_b_fifoerrors(struct brcms_hardware *wlc_hw)
 	uint unit;
 	uint intstatus, idx;
 	struct bcma_device *core = wlc_hw->d11core;
-	struct wiphy *wiphy = wlc_hw->wlc->wiphy;
 
 	unit = wlc_hw->unit;
 
@@ -2353,35 +2354,35 @@ static void brcms_b_fifoerrors(struct brcms_hardware *wlc_hw)
 			unit, idx, intstatus);
 
 		if (intstatus & I_RO) {
-			wiphy_err(wiphy, "wl%d: fifo %d: receive fifo "
+			BRCMS_ERR(core, "wl%d: fifo %d: receive fifo "
 				  "overflow\n", unit, idx);
 			fatal = true;
 		}
 
 		if (intstatus & I_PC) {
-			wiphy_err(wiphy, "wl%d: fifo %d: descriptor error\n",
-				 unit, idx);
+			BRCMS_ERR(core, "wl%d: fifo %d: descriptor error\n",
+				  unit, idx);
 			fatal = true;
 		}
 
 		if (intstatus & I_PD) {
-			wiphy_err(wiphy, "wl%d: fifo %d: data error\n", unit,
+			BRCMS_ERR(core, "wl%d: fifo %d: data error\n", unit,
 				  idx);
 			fatal = true;
 		}
 
 		if (intstatus & I_DE) {
-			wiphy_err(wiphy, "wl%d: fifo %d: descriptor protocol "
+			BRCMS_ERR(core, "wl%d: fifo %d: descriptor protocol "
 				  "error\n", unit, idx);
 			fatal = true;
 		}
 
 		if (intstatus & I_RU)
-			wiphy_err(wiphy, "wl%d: fifo %d: receive descriptor "
+			BRCMS_ERR(core, "wl%d: fifo %d: receive descriptor "
 				  "underflow\n", idx, unit);
 
 		if (intstatus & I_XU) {
-			wiphy_err(wiphy, "wl%d: fifo %d: transmit fifo "
+			BRCMS_ERR(core, "wl%d: fifo %d: transmit fifo "
 				  "underflow\n", idx, unit);
 			fatal = true;
 		}
@@ -2631,8 +2632,8 @@ bool brcms_c_isr(struct brcms_c_info *wlc, bool *wantdpc)
 	macintstatus = wlc_intstatus(wlc, true);
 
 	if (macintstatus == 0xffffffff)
-		wiphy_err(wlc->wiphy, "DEVICEREMOVED detected in the ISR code"
-			  " path\n");
+		BRCMS_ERR(wlc_hw->d11core,
+			  "DEVICEREMOVED detected in the ISR code path\n");
 
 	/* it is not for us */
 	if (macintstatus == 0)
@@ -2652,7 +2653,6 @@ void brcms_c_suspend_mac_and_wait(struct brcms_c_info *wlc)
 	struct brcms_hardware *wlc_hw = wlc->hw;
 	struct bcma_device *core = wlc_hw->d11core;
 	u32 mc, mi;
-	struct wiphy *wiphy = wlc->wiphy;
 
 	BCMMSG(wlc->wiphy, "wl%d: bandunit %d\n", wlc_hw->unit,
 		wlc_hw->band->bandunit);
@@ -2670,7 +2670,7 @@ void brcms_c_suspend_mac_and_wait(struct brcms_c_info *wlc)
 	mc = bcma_read32(core, D11REGOFFS(maccontrol));
 
 	if (mc == 0xffffffff) {
-		wiphy_err(wiphy, "wl%d: %s: dead chip\n", wlc_hw->unit,
+		BRCMS_ERR(core, "wl%d: %s: dead chip\n", wlc_hw->unit,
 			  __func__);
 		brcms_down(wlc->wl);
 		return;
@@ -2681,7 +2681,7 @@ void brcms_c_suspend_mac_and_wait(struct brcms_c_info *wlc)
 
 	mi = bcma_read32(core, D11REGOFFS(macintstatus));
 	if (mi == 0xffffffff) {
-		wiphy_err(wiphy, "wl%d: %s: dead chip\n", wlc_hw->unit,
+		BRCMS_ERR(core, "wl%d: %s: dead chip\n", wlc_hw->unit,
 			  __func__);
 		brcms_down(wlc->wl);
 		return;
@@ -2694,10 +2694,10 @@ void brcms_c_suspend_mac_and_wait(struct brcms_c_info *wlc)
 		 BRCMS_MAX_MAC_SUSPEND);
 
 	if (!(bcma_read32(core, D11REGOFFS(macintstatus)) & MI_MACSSPNDD)) {
-		wiphy_err(wiphy, "wl%d: wlc_suspend_mac_and_wait: waited %d uS"
+		BRCMS_ERR(core, "wl%d: wlc_suspend_mac_and_wait: waited %d uS"
 			  " and MI_MACSSPNDD is still not on.\n",
 			  wlc_hw->unit, BRCMS_MAX_MAC_SUSPEND);
-		wiphy_err(wiphy, "wl%d: psmdebug 0x%08x, phydebug 0x%08x, "
+		BRCMS_ERR(core, "wl%d: psmdebug 0x%08x, phydebug 0x%08x, "
 			  "psm_brc 0x%04x\n", wlc_hw->unit,
 			  bcma_read32(core, D11REGOFFS(psmdebug)),
 			  bcma_read32(core, D11REGOFFS(phydebug)),
@@ -2706,7 +2706,7 @@ void brcms_c_suspend_mac_and_wait(struct brcms_c_info *wlc)
 
 	mc = bcma_read32(core, D11REGOFFS(maccontrol));
 	if (mc == 0xffffffff) {
-		wiphy_err(wiphy, "wl%d: %s: dead chip\n", wlc_hw->unit,
+		BRCMS_ERR(core, "wl%d: %s: dead chip\n", wlc_hw->unit,
 			  __func__);
 		brcms_down(wlc->wl);
 		return;
@@ -2766,8 +2766,6 @@ static bool brcms_b_validate_chip_access(struct brcms_hardware *wlc_hw)
 	u32 w, val;
 	struct wiphy *wiphy = wlc_hw->wlc->wiphy;
 
-	BCMMSG(wiphy, "wl%d\n", wlc_hw->unit);
-
 	/* Validate dchip register access */
 
 	bcma_write32(core, D11REGOFFS(objaddr), OBJADDR_SHM_SEL | 0);
@@ -2828,7 +2826,7 @@ void brcms_b_core_phypll_ctl(struct brcms_hardware *wlc_hw, bool on)
 	struct bcma_device *core = wlc_hw->d11core;
 	u32 tmp;
 
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
+	BRCMS_DBG_INFO(core, "wl%d\n", wlc_hw->unit);
 
 	tmp = 0;
 
@@ -2844,8 +2842,8 @@ void brcms_b_core_phypll_ctl(struct brcms_hardware *wlc_hw, bool on)
 
 			tmp = bcma_read32(core, D11REGOFFS(clk_ctl_st));
 			if ((tmp & CCS_ERSRC_AVAIL_HT) != CCS_ERSRC_AVAIL_HT)
-				wiphy_err(wlc_hw->wlc->wiphy, "%s: turn on PHY"
-					  " PLL failed\n", __func__);
+				BRCMS_ERR(core, "%s: turn on PHY PLL failed\n",
+					  __func__);
 		} else {
 			bcma_set32(core, D11REGOFFS(clk_ctl_st),
 				   tmp | CCS_ERSRC_REQ_D11PLL |
@@ -2861,8 +2859,8 @@ void brcms_b_core_phypll_ctl(struct brcms_hardware *wlc_hw, bool on)
 			     (CCS_ERSRC_AVAIL_D11PLL | CCS_ERSRC_AVAIL_PHYPLL))
 			    !=
 			    (CCS_ERSRC_AVAIL_D11PLL | CCS_ERSRC_AVAIL_PHYPLL))
-				wiphy_err(wlc_hw->wlc->wiphy, "%s: turn on "
-					  "PHY PLL failed\n", __func__);
+				BRCMS_ERR(core, "%s: turn on PHY PLL failed\n",
+					  __func__);
 		}
 	} else {
 		/*
@@ -2880,7 +2878,7 @@ static void brcms_c_coredisable(struct brcms_hardware *wlc_hw)
 {
 	bool dev_gone;
 
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
+	BRCMS_DBG_INFO(wlc_hw->d11core, "wl%d: disable core\n", wlc_hw->unit);
 
 	dev_gone = brcms_deviceremoved(wlc_hw->wlc);
 
@@ -3137,7 +3135,7 @@ static void brcms_c_statsupd(struct brcms_c_info *wlc)
 	/* check for rx fifo 0 overflow */
 	delta = (u16) (wlc->core->macstat_snapshot->rxf0ovfl - rxf0ovfl);
 	if (delta)
-		wiphy_err(wlc->wiphy, "wl%d: %u rx fifo 0 overflows!\n",
+		BRCMS_ERR(wlc->hw->d11core, "wl%d: %u rx fifo 0 overflows!\n",
 			  wlc->pub->unit, delta);
 
 	/* check for tx fifo underflows */
@@ -3146,8 +3144,9 @@ static void brcms_c_statsupd(struct brcms_c_info *wlc)
 		    (u16) (wlc->core->macstat_snapshot->txfunfl[i] -
 			      txfunfl[i]);
 		if (delta)
-			wiphy_err(wlc->wiphy, "wl%d: %u tx fifo %d underflows!"
-				  "\n", wlc->pub->unit, delta, i);
+			BRCMS_ERR(wlc->hw->d11core,
+				  "wl%d: %u tx fifo %d underflows!\n",
+				  wlc->pub->unit, delta, i);
 	}
 #endif				/* DEBUG */
 
@@ -3160,8 +3159,6 @@ static void brcms_c_statsupd(struct brcms_c_info *wlc)
 
 static void brcms_b_reset(struct brcms_hardware *wlc_hw)
 {
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
-
 	/* reset the core */
 	if (!brcms_deviceremoved(wlc_hw->wlc))
 		brcms_b_corereset(wlc_hw, BRCMS_USE_COREFLAGS);
@@ -3172,7 +3169,7 @@ static void brcms_b_reset(struct brcms_hardware *wlc_hw)
 
 void brcms_c_reset(struct brcms_c_info *wlc)
 {
-	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
+	BRCMS_DBG_INFO(wlc->hw->d11core, "wl%d\n", wlc->pub->unit);
 
 	/* slurp up hw mac counters before core reset */
 	brcms_c_statsupd(wlc);
@@ -3217,10 +3214,9 @@ static void brcms_b_coreinit(struct brcms_c_info *wlc)
 	bool fifosz_fixup = false;
 	int err = 0;
 	u16 buf[NFIFO];
-	struct wiphy *wiphy = wlc->wiphy;
 	struct brcms_ucode *ucode = &wlc_hw->wlc->wl->ucode;
 
-	BCMMSG(wlc->wiphy, "wl%d\n", wlc_hw->unit);
+	BRCMS_DBG_INFO(core, "wl%d: core init\n", wlc_hw->unit);
 
 	/* reset PSM */
 	brcms_b_mctrl(wlc_hw, ~0, (MCTL_IHR_EN | MCTL_PSM_JMP_0 | MCTL_WAKE));
@@ -3240,7 +3236,7 @@ static void brcms_b_coreinit(struct brcms_c_info *wlc)
 	SPINWAIT(((bcma_read32(core, D11REGOFFS(macintstatus)) &
 		   MI_MACSSPNDD) == 0), 1000 * 1000);
 	if ((bcma_read32(core, D11REGOFFS(macintstatus)) & MI_MACSSPNDD) == 0)
-		wiphy_err(wiphy, "wl%d: wlc_coreinit: ucode did not self-"
+		BRCMS_ERR(core, "wl%d: wlc_coreinit: ucode did not self-"
 			  "suspend!\n", wlc_hw->unit);
 
 	brcms_c_gpio_init(wlc);
@@ -3251,18 +3247,18 @@ static void brcms_b_coreinit(struct brcms_c_info *wlc)
 		if (BRCMS_ISNPHY(wlc_hw->band))
 			brcms_c_write_inits(wlc_hw, ucode->d11n0initvals16);
 		else
-			wiphy_err(wiphy, "%s: wl%d: unsupported phy in corerev"
+			BRCMS_ERR(core, "%s: wl%d: unsupported phy in corerev"
 				  " %d\n", __func__, wlc_hw->unit,
 				  wlc_hw->corerev);
 	} else if (D11REV_IS(wlc_hw->corerev, 24)) {
 		if (BRCMS_ISLCNPHY(wlc_hw->band))
 			brcms_c_write_inits(wlc_hw, ucode->d11lcn0initvals24);
 		else
-			wiphy_err(wiphy, "%s: wl%d: unsupported phy in corerev"
+			BRCMS_ERR(core, "%s: wl%d: unsupported phy in corerev"
 				  " %d\n", __func__, wlc_hw->unit,
 				  wlc_hw->corerev);
 	} else {
-		wiphy_err(wiphy, "%s: wl%d: unsupported corerev %d\n",
+		BRCMS_ERR(core, "%s: wl%d: unsupported corerev %d\n",
 			  __func__, wlc_hw->unit, wlc_hw->corerev);
 	}
 
@@ -3304,7 +3300,7 @@ static void brcms_b_coreinit(struct brcms_c_info *wlc)
 		err = -1;
 	}
 	if (err != 0)
-		wiphy_err(wiphy, "wlc_coreinit: txfifo mismatch: ucode size %d"
+		BRCMS_ERR(core, "wlc_coreinit: txfifo mismatch: ucode size %d"
 			  " driver size %d index %d\n", buf[i],
 			  wlc_hw->xmtfifo_sz[i], i);
 
@@ -3387,8 +3383,6 @@ static brcms_b_init(struct brcms_hardware *wlc_hw, u16 chanspec) {
 	bool fastclk;
 	struct brcms_c_info *wlc = wlc_hw->wlc;
 
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
-
 	/* request FAST clock if not on */
 	fastclk = wlc_hw->forcefastclk;
 	if (!fastclk)
@@ -3481,7 +3475,7 @@ static void brcms_c_rate_lookup_init(struct brcms_c_info *wlc,
 		rate = (rateset->rates[i] & BRCMS_RATE_MASK);
 
 		if (rate > BRCM_MAXRATE) {
-			wiphy_err(wlc->wiphy, "brcms_c_rate_lookup_init: "
+			BRCMS_ERR(wlc->hw->d11core, "brcms_c_rate_lookup_init: "
 				  "invalid rate 0x%X in rate set\n",
 				  rateset->rates[i]);
 			continue;
@@ -3557,7 +3551,6 @@ static void brcms_c_bandinit_ordered(struct brcms_c_info *wlc,
 	uint parkband;
 	uint i, band_order[2];
 
-	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 	/*
 	 * We might have been bandlocked during down and the chip
 	 * power-cycled (hibernate). Figure out the right band to park on
@@ -3738,8 +3731,8 @@ static void brcms_c_set_ratetable(struct brcms_c_info *wlc)
 /* band-specific init */
 static void brcms_c_bsinit(struct brcms_c_info *wlc)
 {
-	BCMMSG(wlc->wiphy, "wl%d: bandunit %d\n",
-		 wlc->pub->unit, wlc->band->bandunit);
+	BRCMS_DBG_INFO(wlc->hw->d11core, "wl%d: bandunit %d\n",
+		       wlc->pub->unit, wlc->band->bandunit);
 
 	/* write ucode ACK/CTS rate table */
 	brcms_c_set_ratetable(wlc);
@@ -3762,7 +3755,8 @@ brcms_c_duty_cycle_set(struct brcms_c_info *wlc, int duty_cycle, bool isOFDM,
 	    isOFDM ? M_TX_IDLE_BUSY_RATIO_X_16_OFDM :
 	    M_TX_IDLE_BUSY_RATIO_X_16_CCK;
 	if (duty_cycle > 100 || duty_cycle < 0) {
-		wiphy_err(wlc->wiphy, "wl%d:  duty cycle value off limit\n",
+		BRCMS_ERR(wlc->hw->d11core,
+			  "wl%d:  duty cycle value off limit\n",
 			  wlc->pub->unit);
 		return -EINVAL;
 	}
@@ -3936,7 +3930,7 @@ static void brcms_c_set_chanspec(struct brcms_c_info *wlc, u16 chanspec)
 	u16 old_chanspec = wlc->chanspec;
 
 	if (!brcms_c_valid_chanspec_db(wlc->cmi, chanspec)) {
-		wiphy_err(wlc->wiphy, "wl%d: %s: Bad channel %d\n",
+		BRCMS_ERR(wlc->hw->d11core, "wl%d: %s: Bad channel %d\n",
 			  wlc->pub->unit, __func__, CHSPEC_CHANNEL(chanspec));
 		return;
 	}
@@ -3947,8 +3941,8 @@ static void brcms_c_set_chanspec(struct brcms_c_info *wlc, u16 chanspec)
 		if (wlc->band->bandunit != bandunit || wlc->bandinit_pending) {
 			switchband = true;
 			if (wlc->bandlocked) {
-				wiphy_err(wlc->wiphy, "wl%d: %s: chspec %d "
-					  "band is locked!\n",
+				BRCMS_ERR(wlc->hw->d11core,
+					  "wl%d: %s: chspec %d band is locked!\n",
 					  wlc->pub->unit, __func__,
 					  CHSPEC_CHANNEL(chanspec));
 				return;
@@ -4012,6 +4006,10 @@ void brcms_c_beacon_phytxctl_txant_upd(struct brcms_c_info *wlc,
  */
 void brcms_c_protection_upd(struct brcms_c_info *wlc, uint idx, int val)
 {
+	/*
+	 * Cannot use BRCMS_DBG_* here because this function is called
+	 * before wlc is sufficiently initialized.
+	 */
 	BCMMSG(wlc->wiphy, "idx %d, val %d\n", idx, val);
 
 	switch (idx) {
@@ -4084,8 +4082,8 @@ void brcms_c_wme_setparams(struct brcms_c_info *wlc, u16 aci,
 
 	/* Only apply params if the core is out of reset and has clocks */
 	if (!wlc->clk) {
-		wiphy_err(wlc->wiphy, "wl%d: %s : no-clock\n", wlc->pub->unit,
-			  __func__);
+		BRCMS_ERR(wlc->hw->d11core, "wl%d: %s : no-clock\n",
+			  wlc->pub->unit, __func__);
 		return;
 	}
 
@@ -4103,7 +4101,7 @@ void brcms_c_wme_setparams(struct brcms_c_info *wlc, u16 aci,
 
 	if (acp_shm.aifs < EDCF_AIFSN_MIN
 	    || acp_shm.aifs > EDCF_AIFSN_MAX) {
-		wiphy_err(wlc->wiphy, "wl%d: edcf_setparams: bad "
+		BRCMS_ERR(wlc->hw->d11core, "wl%d: edcf_setparams: bad "
 			  "aifs %d\n", wlc->pub->unit, acp_shm.aifs);
 	} else {
 		acp_shm.cwmin = params->cw_min;
@@ -4218,8 +4216,8 @@ static void brcms_c_radio_timer(void *arg)
 	struct brcms_c_info *wlc = (struct brcms_c_info *) arg;
 
 	if (brcms_deviceremoved(wlc)) {
-		wiphy_err(wlc->wiphy, "wl%d: %s: dead chip\n", wlc->pub->unit,
-			__func__);
+		BRCMS_ERR(wlc->hw->d11core, "wl%d: %s: dead chip\n",
+			  wlc->pub->unit, __func__);
 		brcms_down(wlc->wl);
 		return;
 	}
@@ -4232,8 +4230,6 @@ static void brcms_b_watchdog(struct brcms_c_info *wlc)
 {
 	struct brcms_hardware *wlc_hw = wlc->hw;
 
-	BCMMSG(wlc->wiphy, "wl%d\n", wlc_hw->unit);
-
 	if (!wlc_hw->up)
 		return;
 
@@ -4252,14 +4248,14 @@ static void brcms_b_watchdog(struct brcms_c_info *wlc)
 /* common watchdog code */
 static void brcms_c_watchdog(struct brcms_c_info *wlc)
 {
-	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
+	BRCMS_DBG_INFO(wlc->hw->d11core, "wl%d\n", wlc->pub->unit);
 
 	if (!wlc->pub->up)
 		return;
 
 	if (brcms_deviceremoved(wlc)) {
-		wiphy_err(wlc->wiphy, "wl%d: %s: dead chip\n", wlc->pub->unit,
-			  __func__);
+		BRCMS_ERR(wlc->hw->d11core, "wl%d: %s: dead chip\n",
+			  wlc->pub->unit, __func__);
 		brcms_down(wlc->wl);
 		return;
 	}
@@ -4431,13 +4427,13 @@ static int brcms_b_attach(struct brcms_c_info *wlc, struct bcma_device *core,
 	struct ssb_sprom *sprom = &core->bus->sprom;
 
 	if (core->bus->hosttype == BCMA_HOSTTYPE_PCI)
-		BCMMSG(wlc->wiphy, "wl%d: vendor 0x%x device 0x%x\n", unit,
-		       pcidev->vendor,
-		       pcidev->device);
+		BRCMS_DBG_INFO(core, "wl%d: vendor 0x%x device 0x%x\n", unit,
+			       pcidev->vendor,
+			       pcidev->device);
 	else
-		BCMMSG(wlc->wiphy, "wl%d: vendor 0x%x device 0x%x\n", unit,
-		       core->bus->boardinfo.vendor,
-		       core->bus->boardinfo.type);
+		BRCMS_DBG_INFO(core, "wl%d: vendor 0x%x device 0x%x\n", unit,
+			       core->bus->boardinfo.vendor,
+			       core->bus->boardinfo.type);
 
 	wme = true;
 
@@ -4709,8 +4705,9 @@ static int brcms_b_attach(struct brcms_c_info *wlc, struct bcma_device *core,
 		goto fail;
 	}
 
-	BCMMSG(wlc->wiphy, "deviceid 0x%x nbands %d board 0x%x\n",
-	       wlc_hw->deviceid, wlc_hw->_nbands, ai_get_boardtype(wlc_hw->sih));
+	BRCMS_DBG_INFO(wlc_hw->d11core, "deviceid 0x%x nbands %d board 0x%x\n",
+		       wlc_hw->deviceid, wlc_hw->_nbands,
+		       ai_get_boardtype(wlc_hw->sih));
 
 	return err;
 
@@ -4966,7 +4963,7 @@ static void brcms_b_hw_up(struct brcms_hardware *wlc_hw)
 	if (wlc_hw->wlc->pub->hw_up)
 		return;
 
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
+	BRCMS_DBG_INFO(wlc_hw->d11core, "wl%d\n", wlc_hw->unit);
 
 	/*
 	 * Enable pll and xtal, initialize the power control registers,
@@ -5003,7 +5000,7 @@ static void brcms_b_hw_up(struct brcms_hardware *wlc_hw)
 
 static int brcms_b_up_prep(struct brcms_hardware *wlc_hw)
 {
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
+	BRCMS_DBG_INFO(wlc_hw->d11core, "wl%d\n", wlc_hw->unit);
 
 	/*
 	 * Enable pll and xtal, initialize the power control registers,
@@ -5042,8 +5039,6 @@ static int brcms_b_up_prep(struct brcms_hardware *wlc_hw)
 
 static int brcms_b_up_finish(struct brcms_hardware *wlc_hw)
 {
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
-
 	wlc_hw->up = true;
 	wlc_phy_hw_state_upd(wlc_hw->band->pi, true);
 
@@ -5075,7 +5070,7 @@ int brcms_c_up(struct brcms_c_info *wlc)
 {
 	struct ieee80211_channel *ch;
 
-	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
+	BRCMS_DBG_INFO(wlc->hw->d11core, "wl%d\n", wlc->pub->unit);
 
 	/* HW is turned off so don't try to access it */
 	if (wlc->pub->hw_off || brcms_deviceremoved(wlc))
@@ -5116,8 +5111,8 @@ int brcms_c_up(struct brcms_c_info *wlc)
 					 WL_RADIO_HW_DISABLE);
 
 				if (bsscfg->enable && bsscfg->BSS)
-					wiphy_err(wlc->wiphy, "wl%d: up"
-						  ": rfdisable -> "
+					BRCMS_ERR(wlc->hw->d11core,
+						  "wl%d: up: rfdisable -> "
 						  "bsscfg_disable()\n",
 						   wlc->pub->unit);
 			}
@@ -5177,8 +5172,6 @@ static int brcms_b_bmac_down_prep(struct brcms_hardware *wlc_hw)
 	bool dev_gone;
 	uint callbacks = 0;
 
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
-
 	if (!wlc_hw->up)
 		return callbacks;
 
@@ -5205,8 +5198,6 @@ static int brcms_b_down_finish(struct brcms_hardware *wlc_hw)
 	uint callbacks = 0;
 	bool dev_gone;
 
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
-
 	if (!wlc_hw->up)
 		return callbacks;
 
@@ -5255,12 +5246,13 @@ uint brcms_c_down(struct brcms_c_info *wlc)
 	int i;
 	bool dev_gone = false;
 
-	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
+	BRCMS_DBG_INFO(wlc->hw->d11core, "wl%d\n", wlc->pub->unit);
 
 	/* check if we are already in the going down path */
 	if (wlc->going_down) {
-		wiphy_err(wlc->wiphy, "wl%d: %s: Driver going down so return"
-			  "\n", wlc->pub->unit, __func__);
+		BRCMS_ERR(wlc->hw->d11core,
+			  "wl%d: %s: Driver going down so return\n",
+			  wlc->pub->unit, __func__);
 		return 0;
 	}
 	if (!wlc->pub->up)
@@ -5373,7 +5365,7 @@ int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config)
 
 	default:
 		/* Error */
-		wiphy_err(wlc->wiphy, "wl%d: %s: invalid gmode %d\n",
+		BRCMS_ERR(wlc->hw->d11core, "wl%d: %s: invalid gmode %d\n",
 			  wlc->pub->unit, __func__, gmode);
 		return -ENOTSUPP;
 	}
@@ -6021,7 +6013,7 @@ brcms_c_calc_ba_time(struct brcms_c_info *wlc, u32 rspec,
 		     u8 preamble_type)
 {
 	BCMMSG(wlc->wiphy, "wl%d: rspec 0x%x, "
-		 "preamble_type %d\n", wlc->pub->unit, rspec, preamble_type);
+                "preamble_type %d\n", wlc->pub->unit, rspec, preamble_type);
 	/*
 	 * Spec 9.6: ack rate is the highest rate in BSSBasicRateSet that
 	 * is less than or equal to the rate of the immediately previous
@@ -6144,7 +6136,7 @@ static bool brcms_c_valid_rate(struct brcms_c_info *wlc, u32 rspec, int band,
 			return true;
  error:
 	if (verbose)
-		wiphy_err(wlc->wiphy, "wl%d: valid_rate: rate spec 0x%x "
+		BRCMS_ERR(wlc->hw->d11core, "wl%d: valid_rate: rate spec 0x%x "
 			  "not in hw_rateset\n", wlc->pub->unit, rspec);
 
 	return false;
@@ -6154,6 +6146,7 @@ static u32
 mac80211_wlc_set_nrate(struct brcms_c_info *wlc, struct brcms_band *cur_band,
 		       u32 int_val)
 {
+	struct bcma_device *core = wlc->hw->d11core;
 	u8 stf = (int_val & NRATE_STF_MASK) >> NRATE_STF_SHIFT;
 	u8 rate = int_val & NRATE_RATE_MASK;
 	u32 rspec;
@@ -6170,7 +6163,7 @@ mac80211_wlc_set_nrate(struct brcms_c_info *wlc, struct brcms_band *cur_band,
 	if ((wlc->pub->_n_enab & SUPPORT_11N) && ismcs) {
 		/* mcs only allowed when nmode */
 		if (stf > PHY_TXC1_MODE_SDM) {
-			wiphy_err(wlc->wiphy, "wl%d: %s: Invalid stf\n",
+			BRCMS_ERR(core, "wl%d: %s: Invalid stf\n",
 				  wlc->pub->unit, __func__);
 			bcmerror = -EINVAL;
 			goto done;
@@ -6181,8 +6174,8 @@ mac80211_wlc_set_nrate(struct brcms_c_info *wlc, struct brcms_band *cur_band,
 			if (!CHSPEC_IS40(wlc->home_chanspec) ||
 			    ((stf != PHY_TXC1_MODE_SISO)
 			     && (stf != PHY_TXC1_MODE_CDD))) {
-				wiphy_err(wlc->wiphy, "wl%d: %s: Invalid mcs "
-					  "32\n", wlc->pub->unit, __func__);
+				BRCMS_ERR(core, "wl%d: %s: Invalid mcs 32\n",
+					  wlc->pub->unit, __func__);
 				bcmerror = -EINVAL;
 				goto done;
 			}
@@ -6203,15 +6196,15 @@ mac80211_wlc_set_nrate(struct brcms_c_info *wlc, struct brcms_band *cur_band,
 			if ((stf > PHY_TXC1_MODE_STBC) ||
 			    (!BRCMS_STBC_CAP_PHY(wlc)
 			     && (stf == PHY_TXC1_MODE_STBC))) {
-				wiphy_err(wlc->wiphy, "wl%d: %s: Invalid STBC"
-					  "\n", wlc->pub->unit, __func__);
+				BRCMS_ERR(core, "wl%d: %s: Invalid STBC\n",
+					  wlc->pub->unit, __func__);
 				bcmerror = -EINVAL;
 				goto done;
 			}
 		}
 	} else if (is_ofdm_rate(rate)) {
 		if ((stf != PHY_TXC1_MODE_CDD) && (stf != PHY_TXC1_MODE_SISO)) {
-			wiphy_err(wlc->wiphy, "wl%d: %s: Invalid OFDM\n",
+			BRCMS_ERR(core, "wl%d: %s: Invalid OFDM\n",
 				  wlc->pub->unit, __func__);
 			bcmerror = -EINVAL;
 			goto done;
@@ -6219,20 +6212,20 @@ mac80211_wlc_set_nrate(struct brcms_c_info *wlc, struct brcms_band *cur_band,
 	} else if (is_cck_rate(rate)) {
 		if ((cur_band->bandtype != BRCM_BAND_2G)
 		    || (stf != PHY_TXC1_MODE_SISO)) {
-			wiphy_err(wlc->wiphy, "wl%d: %s: Invalid CCK\n",
+			BRCMS_ERR(core, "wl%d: %s: Invalid CCK\n",
 				  wlc->pub->unit, __func__);
 			bcmerror = -EINVAL;
 			goto done;
 		}
 	} else {
-		wiphy_err(wlc->wiphy, "wl%d: %s: Unknown rate type\n",
+		BRCMS_ERR(core, "wl%d: %s: Unknown rate type\n",
 			  wlc->pub->unit, __func__);
 		bcmerror = -EINVAL;
 		goto done;
 	}
 	/* make sure multiple antennae are available for non-siso rates */
 	if ((stf != PHY_TXC1_MODE_SISO) && (wlc->stf->txstreams == 1)) {
-		wiphy_err(wlc->wiphy, "wl%d: %s: SISO antenna but !SISO "
+		BRCMS_ERR(core, "wl%d: %s: SISO antenna but !SISO "
 			  "request\n", wlc->pub->unit, __func__);
 		bcmerror = -EINVAL;
 		goto done;
@@ -6301,7 +6294,7 @@ static void brcms_c_cck_plcp_set(struct brcms_c_info *wlc, int rate_500,
 		break;
 
 	default:
-		wiphy_err(wlc->wiphy,
+		BRCMS_ERR(wlc->hw->d11core,
 			  "brcms_c_cck_plcp_set: unsupported rate %d\n",
 			  rate_500);
 		rate_500 = BRCM_RATE_1M;
@@ -6434,7 +6427,7 @@ static u16 brcms_c_phytxctl1_calc(struct brcms_c_info *wlc, u32 rspec)
 		bw = rspec_get_bw(rspec);
 		/* 10Mhz is not supported yet */
 		if (bw < PHY_TXC1_BW_20MHZ) {
-			wiphy_err(wlc->wiphy, "phytxctl1_calc: bw %d is "
+			BRCMS_ERR(wlc->hw->d11core, "phytxctl1_calc: bw %d is "
 				  "not supported yet, set to 20L\n", bw);
 			bw = PHY_TXC1_BW_20MHZ;
 		}
@@ -6461,7 +6454,7 @@ static u16 brcms_c_phytxctl1_calc(struct brcms_c_info *wlc, u32 rspec)
 		/* get the phyctl byte from rate phycfg table */
 		phycfg = brcms_c_rate_legacy_phyctl(rspec2rate(rspec));
 		if (phycfg == -1) {
-			wiphy_err(wlc->wiphy, "phytxctl1_calc: wrong "
+			BRCMS_ERR(wlc->hw->d11core, "phytxctl1_calc: wrong "
 				  "legacy OFDM/CCK rate\n");
 			phycfg = 0;
 		}
@@ -6541,8 +6534,9 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	if (tx_info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
 		/* non-AP STA should never use BCMC queue */
 		if (queue == TX_BCMC_FIFO) {
-			wiphy_err(wlc->wiphy, "wl%d: %s: ASSERT queue == "
-				  "TX_BCMC!\n", wlc->pub->unit, __func__);
+			BRCMS_ERR(wlc->hw->d11core,
+				  "wl%d: %s: ASSERT queue == TX_BCMC!\n",
+				  wlc->pub->unit, __func__);
 			frameid = bcmc_fid_generate(wlc, NULL, txh);
 		} else {
 			/* Increment the counter for first fragment */
@@ -6712,7 +6706,8 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 
 			if ((txrate[k]->flags & IEEE80211_TX_RC_MCS)
 			    && (!is_mcs_rate(rspec[k]))) {
-				wiphy_err(wlc->wiphy, "wl%d: %s: IEEE80211_TX_"
+				BRCMS_ERR(wlc->hw->d11core,
+					  "wl%d: %s: IEEE80211_TX_"
 					  "RC_MCS != is_mcs_rate(rspec)\n",
 					  wlc->pub->unit, __func__);
 			}
@@ -7106,14 +7101,16 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 					wlc->fragthresh[queue] =
 					    (u16) newfragthresh;
 			} else {
-				wiphy_err(wlc->wiphy, "wl%d: %s txop invalid "
+				BRCMS_ERR(wlc->hw->d11core,
+					  "wl%d: %s txop invalid "
 					  "for rate %d\n",
 					  wlc->pub->unit, fifo_names[queue],
 					  rspec2rate(rspec[0]));
 			}
 
 			if (dur > wlc->edcf_txop[ac])
-				wiphy_err(wlc->wiphy, "wl%d: %s: %s txop "
+				BRCMS_ERR(wlc->hw->d11core,
+					  "wl%d: %s: %s txop "
 					  "exceeded phylen %d/%d dur %d/%d\n",
 					  wlc->pub->unit, __func__,
 					  fifo_names[queue],
@@ -7146,7 +7143,7 @@ static int brcms_c_tx(struct brcms_c_info *wlc, struct sk_buff *skb)
 		 * in the tx ring and the tx queue isn't stopped then
 		 * we've really got a bug; warn loudly if that happens.
 		 */
-		wiphy_warn(wlc->wiphy,
+		BRCMS_WARN(wlc->hw->d11core,
 			   "Received frame for tx with no space in DMA ring\n");
 		WARN_ON(!ieee80211_queue_stopped(wlc->pub->ieee_hw,
 						 skb_get_queue_mapping(skb)));
@@ -7398,7 +7395,8 @@ prep_mac80211_status(struct brcms_c_info *wlc, struct d11rxhdr *rxh,
 			rx_status->rate_idx = 11;
 			break;
 		default:
-			wiphy_err(wlc->wiphy, "%s: Unknown rate\n", __func__);
+			BRCMS_ERR(wlc->hw->d11core,
+				  "%s: Unknown rate\n", __func__);
 		}
 
 		/*
@@ -7417,7 +7415,7 @@ prep_mac80211_status(struct brcms_c_info *wlc, struct d11rxhdr *rxh,
 		} else if (is_ofdm_rate(rspec)) {
 			rx_status->flag |= RX_FLAG_SHORTPRE;
 		} else {
-			wiphy_err(wlc->wiphy, "%s: Unknown modulation\n",
+			BRCMS_ERR(wlc->hw->d11core, "%s: Unknown modulation\n",
 				  __func__);
 		}
 	}
@@ -7427,12 +7425,12 @@ prep_mac80211_status(struct brcms_c_info *wlc, struct d11rxhdr *rxh,
 
 	if (rxh->RxStatus1 & RXS_DECERR) {
 		rx_status->flag |= RX_FLAG_FAILED_PLCP_CRC;
-		wiphy_err(wlc->wiphy, "%s:  RX_FLAG_FAILED_PLCP_CRC\n",
+		BRCMS_ERR(wlc->hw->d11core, "%s:  RX_FLAG_FAILED_PLCP_CRC\n",
 			  __func__);
 	}
 	if (rxh->RxStatus1 & RXS_FCSERR) {
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
-		wiphy_err(wlc->wiphy, "%s:  RX_FLAG_FAILED_FCS_CRC\n",
+		BRCMS_ERR(wlc->hw->d11core, "%s:  RX_FLAG_FAILED_FCS_CRC\n",
 			  __func__);
 	}
 }
@@ -7843,8 +7841,9 @@ static void brcms_c_recv(struct brcms_c_info *wlc, struct sk_buff *p)
 	/* MAC inserts 2 pad bytes for a4 headers or QoS or A-MSDU subframes */
 	if (rxh->RxStatus1 & RXS_PBPRES) {
 		if (p->len < 2) {
-			wiphy_err(wlc->wiphy, "wl%d: recv: rcvd runt of "
-				  "len %d\n", wlc->pub->unit, p->len);
+			BRCMS_ERR(wlc->hw->d11core,
+				  "wl%d: recv: rcvd runt of len %d\n",
+				  wlc->pub->unit, p->len);
 			goto toss;
 		}
 		skb_pull(p, 2);
@@ -7940,10 +7939,9 @@ bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 	u32 macintstatus;
 	struct brcms_hardware *wlc_hw = wlc->hw;
 	struct bcma_device *core = wlc_hw->d11core;
-	struct wiphy *wiphy = wlc->wiphy;
 
 	if (brcms_deviceremoved(wlc)) {
-		wiphy_err(wiphy, "wl%d: %s: dead chip\n", wlc_hw->unit,
+		BRCMS_ERR(core, "wl%d: %s: dead chip\n", wlc_hw->unit,
 			  __func__);
 		brcms_down(wlc->wl);
 		return false;
@@ -7964,7 +7962,7 @@ bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 		if (brcms_b_txstatus(wlc->hw, bounded, &fatal))
 			wlc->macintstatus |= MI_TFS;
 		if (fatal) {
-			wiphy_err(wiphy, "MI_TFS: fatal\n");
+			BRCMS_ERR(core, "MI_TFS: fatal\n");
 			goto fatal;
 		}
 	}
@@ -7974,7 +7972,7 @@ bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 
 	/* ATIM window end */
 	if (macintstatus & MI_ATIMWINEND) {
-		BCMMSG(wlc->wiphy, "end of ATIM window\n");
+		BRCMS_DBG_INFO(core, "end of ATIM window\n");
 		bcma_set32(core, D11REGOFFS(maccommand), wlc->qvalid);
 		wlc->qvalid = 0;
 	}
@@ -7992,7 +7990,7 @@ bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 		wlc_phy_noise_sample_intr(wlc_hw->band->pi);
 
 	if (macintstatus & MI_GP0) {
-		wiphy_err(wiphy, "wl%d: PSM microcode watchdog fired at %d "
+		BRCMS_ERR(core, "wl%d: PSM microcode watchdog fired at %d "
 			  "(seconds). Resetting.\n", wlc_hw->unit, wlc_hw->now);
 
 		printk_once("%s : PSM Watchdog, chipid 0x%x, chiprev 0x%x\n",
@@ -8006,8 +8004,8 @@ bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 		bcma_write32(core, D11REGOFFS(gptimer), 0);
 
 	if (macintstatus & MI_RFDISABLE) {
-		BCMMSG(wlc->wiphy, "wl%d: BMAC Detected a change on the"
-		       " RF Disable Input\n", wlc_hw->unit);
+		BRCMS_DBG_INFO(core, "wl%d: BMAC Detected a change on the"
+			       " RF Disable Input\n", wlc_hw->unit);
 		brcms_rfkill_set_hw_state(wlc->wl);
 	}
 
@@ -8025,7 +8023,7 @@ void brcms_c_init(struct brcms_c_info *wlc, bool mute_tx)
 	struct ieee80211_channel *ch = wlc->pub->ieee_hw->conf.channel;
 	u16 chanspec;
 
-	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
+	BRCMS_DBG_INFO(core, "wl%d\n", wlc->pub->unit);
 
 	chanspec = ch20mhz_chspec(ch->hw_value);
 
-- 
1.7.9.5

