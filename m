Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2289 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053Ab1ECJgR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:17 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: [PATCH 06/61] staging: brcm80211: replaced WL_ERROR in two
 files.
Date: Tue, 3 May 2011 11:35:06 +0200
Message-ID: <1304415361-7813-7-git-send-email-arend@broadcom.com> (sfid-20110503_113853_140449_22A0BE82)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. Use Linux functions instead of Broadcom specific
one. On spots where the wiphy object is not yet available,
pr_err() is used instead.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c |  214 ++++++++++++----------
 drivers/staging/brcm80211/brcmsmac/wlc_antsel.c  |    7 +-
 2 files changed, 121 insertions(+), 100 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
index f2e481f..7e9ed52 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
@@ -156,7 +156,7 @@ static void wl_ops_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	WL_LOCK(wl);
 	if (!wl->pub->up) {
-		WL_ERROR("ops->tx called while down\n");
+		wiphy_err(wl->wiphy, "ops->tx called while down\n");
 		kfree_skb(skb);
 		goto done;
 	}
@@ -204,8 +204,8 @@ wl_ops_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	    vif->type != NL80211_IFTYPE_STATION &&
 	    vif->type != NL80211_IFTYPE_WDS &&
 	    vif->type != NL80211_IFTYPE_ADHOC) {
-		WL_ERROR("%s: Attempt to add type %d, only STA for now\n",
-			 __func__, vif->type);
+		wiphy_err(hw->wiphy, "%s: Attempt to add type %d, only"
+			  " STA for now\n", __func__, vif->type);
 		return -EOPNOTSUPP;
 	}
 
@@ -215,7 +215,8 @@ wl_ops_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	WL_UNLOCK(wl);
 
 	if (err != 0) {
-		WL_ERROR("%s: wl_up() returned %d\n", __func__, err);
+		wiphy_err(hw->wiphy, "%s: wl_up() returned %d\n", __func__,
+			  err);
 	}
 	return err;
 }
@@ -250,7 +251,8 @@ ieee_set_channel(struct ieee80211_hw *hw, struct ieee80211_channel *chan,
 		break;
 	case NL80211_CHAN_HT40MINUS:
 	case NL80211_CHAN_HT40PLUS:
-		WL_ERROR("%s: Need to implement 40 Mhz Channels!\n", __func__);
+		wiphy_err(hw->wiphy,
+			  "%s: Need to implement 40 Mhz Channels!\n", __func__);
 		err = 1;
 		break;
 	}
@@ -266,13 +268,14 @@ static int wl_ops_config(struct ieee80211_hw *hw, u32 changed)
 	struct wl_info *wl = HW_TO_WL(hw);
 	int err = 0;
 	int new_int;
+	struct wiphy *wiphy = hw->wiphy;
 
 	WL_LOCK(wl);
 	if (changed & IEEE80211_CONF_CHANGE_LISTEN_INTERVAL) {
 		if (wlc_iovar_setint
 		    (wl->wlc, "bcn_li_bcn", conf->listen_interval)) {
-			WL_ERROR("%s: Error setting listen_interval\n",
-				 __func__);
+			wiphy_err(wiphy, "%s: Error setting listen_interval\n",
+				  __func__);
 			err = -EIO;
 			goto config_out;
 		}
@@ -280,25 +283,27 @@ static int wl_ops_config(struct ieee80211_hw *hw, u32 changed)
 		ASSERT(new_int == conf->listen_interval);
 	}
 	if (changed & IEEE80211_CONF_CHANGE_MONITOR)
-		WL_ERROR("%s: change monitor mode: %s (implement)\n", __func__,
-			 conf->flags & IEEE80211_CONF_MONITOR ?
-				"true" : "false");
+		wiphy_err(wiphy, "%s: change monitor mode: %s (implement)\n",
+			  __func__, conf->flags & IEEE80211_CONF_MONITOR ?
+			  "true" : "false");
 	if (changed & IEEE80211_CONF_CHANGE_PS)
-		WL_ERROR("%s: change power-save mode: %s (implement)\n",
-			 __func__, conf->flags & IEEE80211_CONF_PS ?
-				"true" : "false");
+		wiphy_err(wiphy, "%s: change power-save mode: %s (implement)\n",
+			  __func__, conf->flags & IEEE80211_CONF_PS ?
+			  "true" : "false");
 
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
 		if (wlc_iovar_setint
 		    (wl->wlc, "qtxpower", conf->power_level * 4)) {
-			WL_ERROR("%s: Error setting power_level\n", __func__);
+			wiphy_err(wiphy, "%s: Error setting power_level\n",
+				  __func__);
 			err = -EIO;
 			goto config_out;
 		}
 		wlc_iovar_getint(wl->wlc, "qtxpower", &new_int);
 		if (new_int != (conf->power_level * 4))
-			WL_ERROR("%s: Power level req != actual, %d %d\n",
-				 __func__, conf->power_level * 4, new_int);
+			wiphy_err(wiphy, "%s: Power level req != actual, %d %d"
+				  "\n", __func__, conf->power_level * 4,
+				  new_int);
 	}
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
 		err = ieee_set_channel(hw, conf->channel, conf->channel_type);
@@ -307,13 +312,13 @@ static int wl_ops_config(struct ieee80211_hw *hw, u32 changed)
 		if (wlc_set
 		    (wl->wlc, WLC_SET_SRL,
 		     conf->short_frame_max_tx_count) < 0) {
-			WL_ERROR("%s: Error setting srl\n", __func__);
+			wiphy_err(wiphy, "%s: Error setting srl\n", __func__);
 			err = -EIO;
 			goto config_out;
 		}
 		if (wlc_set(wl->wlc, WLC_SET_LRL, conf->long_frame_max_tx_count)
 		    < 0) {
-			WL_ERROR("%s: Error setting lrl\n", __func__);
+			wiphy_err(wiphy, "%s: Error setting lrl\n", __func__);
 			err = -EIO;
 			goto config_out;
 		}
@@ -330,25 +335,27 @@ wl_ops_bss_info_changed(struct ieee80211_hw *hw,
 			struct ieee80211_bss_conf *info, u32 changed)
 {
 	struct wl_info *wl = HW_TO_WL(hw);
+	struct wiphy *wiphy = hw->wiphy;
 	int val;
 
 	if (changed & BSS_CHANGED_ASSOC) {
 		/* association status changed (associated/disassociated)
 		 * also implies a change in the AID.
 		 */
-		WL_ERROR("%s: %s: %sassociated\n", KBUILD_MODNAME, __func__,
-			 info->assoc ? "" : "dis");
+		wiphy_err(wiphy, "%s: %s: %sassociated\n", KBUILD_MODNAME,
+			  __func__, info->assoc ? "" : "dis");
 		wlc_associate_upd(wl->wlc, info->assoc);
 	}
 	if (changed & BSS_CHANGED_ERP_CTS_PROT) {
 		/* CTS protection changed */
-		WL_ERROR("%s: use_cts_prot: %s (implement)\n", __func__,
-			info->use_cts_prot ? "true" : "false");
+		wiphy_err(wiphy, "%s: use_cts_prot: %s (implement)\n", __func__,
+			  info->use_cts_prot ? "true" : "false");
 	}
 	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
 		/* preamble changed */
-		WL_ERROR("%s: short preamble: %s (implement)\n", __func__,
-			info->use_short_preamble ? "true" : "false");
+		wiphy_err(wiphy, "%s: short preamble: %s (implement)\n",
+			  __func__, info->use_short_preamble ? "true" :
+			  "false");
 	}
 	if (changed & BSS_CHANGED_ERP_SLOT) {
 		/* slot timing changed */
@@ -373,8 +380,8 @@ wl_ops_bss_info_changed(struct ieee80211_hw *hw,
 	}
 	if (changed & BSS_CHANGED_BASIC_RATES) {
 		/* Basic rateset changed */
-		WL_ERROR("%s: Need to change Basic Rates: 0x%x (implement)\n",
-			 __func__, (u32) info->basic_rates);
+		wiphy_err(wiphy, "%s: Need to change Basic Rates: 0x%x"
+			  " (implement)\n", __func__, (u32) info->basic_rates);
 	}
 	if (changed & BSS_CHANGED_BEACON_INT) {
 		/* Beacon interval changed */
@@ -389,41 +396,42 @@ wl_ops_bss_info_changed(struct ieee80211_hw *hw,
 	}
 	if (changed & BSS_CHANGED_BEACON) {
 		/* Beacon data changed, retrieve new beacon (beaconing modes) */
-		WL_ERROR("%s: beacon changed\n", __func__);
+		wiphy_err(wiphy, "%s: beacon changed\n", __func__);
 	}
 	if (changed & BSS_CHANGED_BEACON_ENABLED) {
 		/* Beaconing should be enabled/disabled (beaconing modes) */
-		WL_ERROR("%s: Beacon enabled: %s\n", __func__,
-			 info->enable_beacon ? "true" : "false");
+		wiphy_err(wiphy, "%s: Beacon enabled: %s\n", __func__,
+			  info->enable_beacon ? "true" : "false");
 	}
 	if (changed & BSS_CHANGED_CQM) {
 		/* Connection quality monitor config changed */
-		WL_ERROR("%s: cqm change: threshold %d, hys %d (implement)\n",
-			__func__, info->cqm_rssi_thold, info->cqm_rssi_hyst);
+		wiphy_err(wiphy, "%s: cqm change: threshold %d, hys %d "
+			  " (implement)\n", __func__, info->cqm_rssi_thold,
+			  info->cqm_rssi_hyst);
 	}
 	if (changed & BSS_CHANGED_IBSS) {
 		/* IBSS join status changed */
-		WL_ERROR("%s: IBSS joined: %s (implement)\n", __func__,
-			info->ibss_joined ? "true" : "false");
+		wiphy_err(wiphy, "%s: IBSS joined: %s (implement)\n", __func__,
+			  info->ibss_joined ? "true" : "false");
 	}
 	if (changed & BSS_CHANGED_ARP_FILTER) {
 		/* Hardware ARP filter address list or state changed */
-		WL_ERROR("%s: arp filtering: enabled %s, count %d (implement)\n",
-			__func__, info->arp_filter_enabled ? "true" : "false",
-			info->arp_addr_cnt);
+		wiphy_err(wiphy, "%s: arp filtering: enabled %s, count %d"
+			  " (implement)\n", __func__, info->arp_filter_enabled ?
+			  "true" : "false", info->arp_addr_cnt);
 	}
 	if (changed & BSS_CHANGED_QOS) {
 		/*
 		 * QoS for this association was enabled/disabled.
 		 * Note that it is only ever disabled for station mode.
 		 */
-		WL_ERROR("%s: qos enabled: %s (implement)\n", __func__,
-			info->qos ? "true" : "false");
+		wiphy_err(wiphy, "%s: qos enabled: %s (implement)\n", __func__,
+			  info->qos ? "true" : "false");
 	}
 	if (changed & BSS_CHANGED_IDLE) {
 		/* Idle changed for this BSS/interface */
-		WL_ERROR("%s: BSS idle: %s (implement)\n", __func__,
-			info->idle ? "true" : "false");
+		wiphy_err(wiphy, "%s: BSS idle: %s (implement)\n", __func__,
+			  info->idle ? "true" : "false");
 	}
 	return;
 }
@@ -434,21 +442,22 @@ wl_ops_configure_filter(struct ieee80211_hw *hw,
 			unsigned int *total_flags, u64 multicast)
 {
 	struct wl_info *wl = hw->priv;
+	struct wiphy *wiphy = hw->wiphy;
 
 	changed_flags &= MAC_FILTERS;
 	*total_flags &= MAC_FILTERS;
 	if (changed_flags & FIF_PROMISC_IN_BSS)
-		WL_ERROR("FIF_PROMISC_IN_BSS\n");
+		wiphy_err(wiphy, "FIF_PROMISC_IN_BSS\n");
 	if (changed_flags & FIF_ALLMULTI)
-		WL_ERROR("FIF_ALLMULTI\n");
+		wiphy_err(wiphy, "FIF_ALLMULTI\n");
 	if (changed_flags & FIF_FCSFAIL)
-		WL_ERROR("FIF_FCSFAIL\n");
+		wiphy_err(wiphy, "FIF_FCSFAIL\n");
 	if (changed_flags & FIF_PLCPFAIL)
-		WL_ERROR("FIF_PLCPFAIL\n");
+		wiphy_err(wiphy, "FIF_PLCPFAIL\n");
 	if (changed_flags & FIF_CONTROL)
-		WL_ERROR("FIF_CONTROL\n");
+		wiphy_err(wiphy, "FIF_CONTROL\n");
 	if (changed_flags & FIF_OTHER_BSS)
-		WL_ERROR("FIF_OTHER_BSS\n");
+		wiphy_err(wiphy, "FIF_OTHER_BSS\n");
 	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
 		WL_LOCK(wl);
 		if (*total_flags & FIF_BCN_PRBRESP_PROMISC) {
@@ -489,7 +498,7 @@ static void wl_ops_sw_scan_complete(struct ieee80211_hw *hw)
 
 static void wl_ops_set_tsf(struct ieee80211_hw *hw, u64 tsf)
 {
-	WL_ERROR("%s: Enter\n", __func__);
+	wiphy_err(hw->wiphy, "%s: Enter\n", __func__);
 	return;
 }
 
@@ -526,7 +535,8 @@ wl_ops_sta_notify(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 {
 	switch (cmd) {
 	default:
-		WL_ERROR("%s: Unknown cmd = %d\n", __func__, cmd);
+		wiphy_err(hw->wiphy, "%s: Unknown cmd = %d\n", __func__,
+			  cmd);
 		break;
 	}
 	return;
@@ -547,7 +557,7 @@ wl_ops_conf_tx(struct ieee80211_hw *hw, u16 queue,
 
 static u64 wl_ops_get_tsf(struct ieee80211_hw *hw)
 {
-	WL_ERROR("%s: Enter\n", __func__);
+	wiphy_err(hw->wiphy, "%s: Enter\n", __func__);
 	return 0;
 }
 
@@ -617,7 +627,8 @@ wl_ops_ampdu_action(struct ieee80211_hw *hw,
 		status = wlc_aggregatable(wl->wlc, tid);
 		WL_UNLOCK(wl);
 		if (!status) {
-			/* WL_ERROR("START: tid %d is not agg' able, return FAILURE to stack\n", tid); */
+			wiphy_err(wl->wiphy, "START: tid %d is not agg\'able\n",
+				  tid);
 			return -1;
 		}
 		/* XXX: Use the starting sequence number provided ... */
@@ -636,7 +647,8 @@ wl_ops_ampdu_action(struct ieee80211_hw *hw,
 		/* Power save wakeup */
 		break;
 	default:
-		WL_ERROR("%s: Invalid command, ignoring\n", __func__);
+		wiphy_err(wl->wiphy, "%s: Invalid command, ignoring\n",
+			  __func__);
 	}
 
 	return 0;
@@ -714,7 +726,6 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 	err = 0;
 
 	if (unit < 0) {
-		WL_ERROR("wl%d: unit number overflow, exiting\n", unit);
 		return NULL;
 	}
 
@@ -745,7 +756,7 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 
 	wl->regsva = ioremap_nocache(base_addr, PCI_BAR0_WINSZ);
 	if (wl->regsva == NULL) {
-		WL_ERROR("wl%d: ioremap() failed\n", unit);
+		wiphy_err(wl->wiphy, "wl%d: ioremap() failed\n", unit);
 		goto fail;
 	}
 	spin_lock_init(&wl->lock);
@@ -753,8 +764,8 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 
 	/* prepare ucode */
 	if (wl_request_fw(wl, (struct pci_dev *)btparam) < 0) {
-		WL_ERROR("%s: Failed to find firmware usually in %s\n",
-			 KBUILD_MODNAME, "/lib/firmware/brcm");
+		wiphy_err(wl->wiphy, "%s: Failed to find firmware usually in "
+			  "%s\n", KBUILD_MODNAME, "/lib/firmware/brcm");
 		wl_release_fw(wl);
 		wl_remove((struct pci_dev *)btparam);
 		goto fail1;
@@ -765,8 +776,8 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 			     wl->regsva, wl->bcm_bustype, btparam, &err);
 	wl_release_fw(wl);
 	if (!wl->wlc) {
-		WL_ERROR("%s: wlc_attach() failed with code %d\n",
-			 KBUILD_MODNAME, err);
+		wiphy_err(wl->wiphy, "%s: wlc_attach() failed with code %d\n",
+			  KBUILD_MODNAME, err);
 		goto fail;
 	}
 	wl->pub = wlc_pub(wl->wlc);
@@ -777,12 +788,13 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 
 
 	if (wlc_iovar_setint(wl->wlc, "mpc", 0)) {
-		WL_ERROR("wl%d: Error setting MPC variable to 0\n", unit);
+		wiphy_err(wl->wiphy, "wl%d: Error setting MPC variable to 0\n",
+			  unit);
 	}
 
 	/* register our interrupt handler */
 	if (request_irq(irq, wl_isr, IRQF_SHARED, KBUILD_MODNAME, wl)) {
-		WL_ERROR("wl%d: request_irq() failed\n", unit);
+		wiphy_err(wl->wiphy, "wl%d: request_irq() failed\n", unit);
 		goto fail;
 	}
 	wl->irq = irq;
@@ -792,7 +804,8 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 			    NULL);
 
 	if (ieee_hw_init(hw)) {
-		WL_ERROR("wl%d: %s: ieee_hw_init failed!\n", unit, __func__);
+		wiphy_err(wl->wiphy, "wl%d: %s: ieee_hw_init failed!\n", unit,
+			  __func__);
 		goto fail;
 	}
 
@@ -802,8 +815,8 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 
 	err = ieee80211_register_hw(hw);
 	if (err) {
-		WL_ERROR("%s: ieee80211_register_hw failed, status %d\n",
-			 __func__, err);
+		wiphy_err(wl->wiphy, "%s: ieee80211_register_hw failed, status"
+			  "%d\n", __func__, err);
 	}
 
 	if (wl->pub->srom_ccode[0])
@@ -811,8 +824,8 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 	else
 		err = wl_set_hint(wl, "US");
 	if (err) {
-		WL_ERROR("%s: regulatory_hint failed, status %d\n",
-			 __func__, err);
+		wiphy_err(wl->wiphy, "%s: regulatory_hint failed, status %d\n",
+			  __func__, err);
 	}
 
 	wl_found++;
@@ -1007,7 +1020,7 @@ static int ieee_hw_rate_init(struct ieee80211_hw *hw)
 	hw->wiphy->bands[IEEE80211_BAND_5GHZ] = NULL;
 
 	if (wlc_get(wl->wlc, WLC_GET_PHYLIST, (int *)&phy_list) < 0) {
-		WL_ERROR("Phy list failed\n");
+		wiphy_err(hw->wiphy, "Phy list failed\n");
 	}
 
 	if (phy_list[0] == 'n' || phy_list[0] == 'c') {
@@ -1093,9 +1106,9 @@ wl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	rc = pci_enable_device(pdev);
 	if (rc) {
-		WL_ERROR("%s: Cannot enable device %d-%d_%d\n",
-			 __func__, pdev->bus->number, PCI_SLOT(pdev->devfn),
-			 PCI_FUNC(pdev->devfn));
+		pr_err("%s: Cannot enable device %d-%d_%d\n",
+		       __func__, pdev->bus->number, PCI_SLOT(pdev->devfn),
+		       PCI_FUNC(pdev->devfn));
 		return -ENODEV;
 	}
 	pci_set_master(pdev);
@@ -1106,7 +1119,7 @@ wl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	hw = ieee80211_alloc_hw(sizeof(struct wl_info), &wl_ops);
 	if (!hw) {
-		WL_ERROR("%s: ieee80211_alloc_hw failed\n", __func__);
+		pr_err("%s: ieee80211_alloc_hw failed\n", __func__);
 		rc = -ENOMEM;
 		goto err_1;
 	}
@@ -1121,13 +1134,13 @@ wl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		       PCI_BUS, pdev, pdev->irq);
 
 	if (!wl) {
-		WL_ERROR("%s: %s: wl_attach failed!\n",
-			 KBUILD_MODNAME, __func__);
+		pr_err("%s: %s: wl_attach failed!\n", KBUILD_MODNAME,
+		       __func__);
 		return -ENODEV;
 	}
 	return 0;
  err_1:
-	WL_ERROR("%s: err_1: Major hoarkage\n", __func__);
+	pr_err("%s: err_1: Major hoarkage\n", __func__);
 	return 0;
 }
 
@@ -1141,7 +1154,8 @@ static int wl_suspend(struct pci_dev *pdev, pm_message_t state)
 	hw = pci_get_drvdata(pdev);
 	wl = HW_TO_WL(hw);
 	if (!wl) {
-		WL_ERROR("wl: wl_suspend: pci_get_drvdata failed\n");
+		wiphy_err(wl->wiphy,
+			  "wl_suspend: pci_get_drvdata failed\n");
 		return -ENODEV;
 	}
 
@@ -1166,7 +1180,8 @@ static int wl_resume(struct pci_dev *pdev)
 	hw = pci_get_drvdata(pdev);
 	wl = HW_TO_WL(hw);
 	if (!wl) {
-		WL_ERROR("wl: wl_resume: pci_get_drvdata failed\n");
+		wiphy_err(wl->wiphy,
+			  "wl: wl_resume: pci_get_drvdata failed\n");
 		return -ENODEV;
 	}
 
@@ -1206,7 +1221,7 @@ static void wl_remove(struct pci_dev *pdev)
 	hw = pci_get_drvdata(pdev);
 	wl = HW_TO_WL(hw);
 	if (!wl) {
-		WL_ERROR("wl: wl_remove: pci_get_drvdata failed\n");
+		pr_err("wl: wl_remove: pci_get_drvdata failed\n");
 		return;
 	}
 
@@ -1214,7 +1229,7 @@ static void wl_remove(struct pci_dev *pdev)
 	status = wlc_chipmatch(pdev->vendor, pdev->device);
 	WL_UNLOCK(wl);
 	if (!status) {
-		WL_ERROR("wl: wl_remove: wlc_chipmatch failed\n");
+		wiphy_err(wl->wiphy, "wl: wl_remove: wlc_chipmatch failed\n");
 		return;
 	}
 	if (wl->wlc) {
@@ -1369,7 +1384,7 @@ static void wl_free(struct wl_info *wl)
 void wl_txflowcontrol(struct wl_info *wl, struct wl_if *wlif, bool state,
 		      int prio)
 {
-	WL_ERROR("Shouldn't be here %s\n", __func__);
+	wiphy_err(wl->wiphy, "Shouldn't be here %s\n", __func__);
 }
 
 /*
@@ -1587,7 +1602,8 @@ struct wl_timer *wl_init_timer(struct wl_info *wl, void (*fn) (void *arg),
 
 	t = kzalloc(sizeof(struct wl_timer), GFP_ATOMIC);
 	if (!t) {
-		WL_ERROR("wl%d: wl_init_timer: out of memory\n", wl->pub->unit);
+		wiphy_err(wl->wiphy, "wl%d: wl_init_timer: out of memory\n",
+			  wl->pub->unit);
 		return 0;
 	}
 
@@ -1618,8 +1634,8 @@ void wl_add_timer(struct wl_info *wl, struct wl_timer *t, uint ms, int periodic)
 {
 #ifdef BCMDBG
 	if (t->set) {
-		WL_ERROR("%s: Already set. Name: %s, per %d\n",
-			 __func__, t->name, periodic);
+		wiphy_err(wl->wiphy, "%s: Already set. Name: %s, per %d\n",
+			  __func__, t->name, periodic);
 	}
 #endif
 	ASSERT(!t->set);
@@ -1754,8 +1770,8 @@ int wl_ucode_init_buf(struct wl_info *wl, void **pbuf, u32 idx)
 				pdata = wl->fw.fw_bin[i]->data + hdr->offset;
 				*pbuf = kmalloc(hdr->len, GFP_ATOMIC);
 				if (*pbuf == NULL) {
-					WL_ERROR("fail to alloc %d bytes\n",
-						 hdr->len);
+					wiphy_err(wl->wiphy, "fail to alloc %d"
+						  " bytes\n", hdr->len);
 					goto fail;
 				}
 				memcpy(*pbuf, pdata, hdr->len);
@@ -1763,7 +1779,8 @@ int wl_ucode_init_buf(struct wl_info *wl, void **pbuf, u32 idx)
 			}
 		}
 	}
-	WL_ERROR("ERROR: ucode buf tag:%d can not be found!\n", idx);
+	wiphy_err(wl->wiphy, "ERROR: ucode buf tag:%d can not be found!\n",
+		  idx);
 	*pbuf = NULL;
 fail:
 	return -BCME_NOTFOUND;
@@ -1790,7 +1807,7 @@ int wl_ucode_init_uint(struct wl_info *wl, u32 *data, u32 idx)
 			}
 		}
 	}
-	WL_ERROR("ERROR: ucode tag:%d can not be found!\n", idx);
+	wiphy_err(wl->wiphy, "ERROR: ucode tag:%d can not be found!\n", idx);
 	return -1;
 }
 
@@ -1813,16 +1830,16 @@ static int wl_request_fw(struct wl_info *wl, struct pci_dev *pdev)
 			UCODE_LOADER_API_VER);
 		status = request_firmware(&wl->fw.fw_bin[i], fw_name, device);
 		if (status) {
-			WL_ERROR("%s: fail to load firmware %s\n",
-				 KBUILD_MODNAME, fw_name);
+			wiphy_err(wl->wiphy, "%s: fail to load firmware %s\n",
+				  KBUILD_MODNAME, fw_name);
 			return status;
 		}
 		sprintf(fw_name, "%s_hdr-%d.fw", wl_firmwares[i],
 			UCODE_LOADER_API_VER);
 		status = request_firmware(&wl->fw.fw_hdr[i], fw_name, device);
 		if (status) {
-			WL_ERROR("%s: fail to load firmware %s\n",
-				 KBUILD_MODNAME, fw_name);
+			wiphy_err(wl->wiphy, "%s: fail to load firmware %s\n",
+				  KBUILD_MODNAME, fw_name);
 			return status;
 		}
 		wl->fw.hdr_num_entries[i] =
@@ -1874,16 +1891,17 @@ int wl_check_firmwares(struct wl_info *wl)
 		if (fw == NULL && fw_hdr == NULL) {
 			break;
 		} else if (fw == NULL || fw_hdr == NULL) {
-			WL_ERROR("%s: invalid bin/hdr fw\n", __func__);
+			wiphy_err(wl->wiphy, "%s: invalid bin/hdr fw\n",
+				  __func__);
 			rc = -EBADF;
 		} else if (fw_hdr->size % sizeof(struct wl_fw_hdr)) {
-			WL_ERROR("%s: non integral fw hdr file size %zu/%zu\n",
-				 __func__, fw_hdr->size,
-				 sizeof(struct wl_fw_hdr));
+			wiphy_err(wl->wiphy, "%s: non integral fw hdr file "
+				"size %zu/%zu\n", __func__, fw_hdr->size,
+				sizeof(struct wl_fw_hdr));
 			rc = -EBADF;
 		} else if (fw->size < MIN_FW_SIZE || fw->size > MAX_FW_SIZE) {
-			WL_ERROR("%s: out of bounds fw file size %zu\n",
-				 __func__, fw->size);
+			wiphy_err(wl->wiphy, "%s: out of bounds fw file size "
+				  "%zu\n", __func__, fw->size);
 			rc = -EBADF;
 		} else {
 			/* check if ucode section overruns firmware image */
@@ -1892,15 +1910,17 @@ int wl_check_firmwares(struct wl_info *wl)
 			     !rc; entry++, ucode_hdr++) {
 				if (ucode_hdr->offset + ucode_hdr->len >
 				    fw->size) {
-					WL_ERROR("%s: conflicting bin/hdr\n",
-						 __func__);
+					wiphy_err(wl->wiphy,
+						  "%s: conflicting bin/hdr\n",
+						  __func__);
 					rc = -EBADF;
 				}
 			}
 		}
 	}
 	if (rc == 0 && wl->fw.fw_cnt != i) {
-		WL_ERROR("%s: invalid fw_cnt=%d\n", __func__, wl->fw.fw_cnt);
+		wiphy_err(wl->wiphy, "%s: invalid fw_cnt=%d\n", __func__,
+			wl->fw.fw_cnt);
 		rc = -EBADF;
 	}
 	return rc;
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c b/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
index 85a73a9..0121ce3 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
@@ -98,8 +98,8 @@ struct antsel_info *wlc_antsel_attach(struct wlc_info *wlc)
 
 	asi = kzalloc(sizeof(struct antsel_info), GFP_ATOMIC);
 	if (!asi) {
-		WL_ERROR("wl%d: wlc_antsel_attach: out of mem\n",
-			 wlc->pub->unit);
+		wiphy_err(wlc->wiphy, "wl%d: wlc_antsel_attach: out of mem\n",
+			  wlc->pub->unit);
 		return NULL;
 	}
 
@@ -128,7 +128,8 @@ struct antsel_info *wlc_antsel_attach(struct wlc_info *wlc)
 				asi->antsel_avail = false;
 			} else {
 				asi->antsel_avail = false;
-				WL_ERROR("wlc_antsel_attach: 2o3 board cfg invalid\n");
+				wiphy_err(wlc->wiphy, "wlc_antsel_attach: 2o3 "
+					  "board cfg invalid\n");
 				ASSERT(0);
 			}
 			break;
-- 
1.7.4.1


