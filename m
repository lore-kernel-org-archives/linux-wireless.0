Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4649 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab1DULCW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 07:02:22 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH v3 3/3] staging: brcm80211: replaced WL_ERROR with
 dev_err in two files.
Date: Thu, 21 Apr 2011 13:02:05 +0200
Message-ID: <1303383725-1440-4-git-send-email-rvossen@broadcom.com>
In-Reply-To: <1303383725-1440-1-git-send-email-rvossen@broadcom.com>
References: <1303383725-1440-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. Use Linux function instead of Broadcom specific
one. On spots where the device object is not yet available,
pr_err() is used instead.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c |  216 ++++++++++++----------
 drivers/staging/brcm80211/brcmsmac/wlc_antsel.c  |    7 +-
 2 files changed, 124 insertions(+), 99 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
index 1477419..1417033 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
@@ -16,6 +16,8 @@
 
 #define __UNDEF_NO_VERSION__
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/etherdevice.h>
 #include <linux/types.h>
@@ -156,7 +158,7 @@ static void wl_ops_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	WL_LOCK(wl);
 	if (!wl->pub->up) {
-		WL_ERROR("ops->tx called while down\n");
+		dev_err(wl->dev, "ops->tx called while down\n");
 		kfree_skb(skb);
 		goto done;
 	}
@@ -205,8 +207,8 @@ wl_ops_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	    vif->type != NL80211_IFTYPE_STATION &&
 	    vif->type != NL80211_IFTYPE_WDS &&
 	    vif->type != NL80211_IFTYPE_ADHOC) {
-		WL_ERROR("%s: Attempt to add type %d, only STA for now\n",
-			 __func__, vif->type);
+		dev_err(&hw->wiphy->dev, "%s: Attempt to add type %d, only"
+			" STA for now\n", __func__, vif->type);
 		return -EOPNOTSUPP;
 	}
 
@@ -216,7 +218,8 @@ wl_ops_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	WL_UNLOCK(wl);
 
 	if (err != 0) {
-		WL_ERROR("%s: wl_up() returned %d\n", __func__, err);
+		dev_err(wl->dev, "%s: wl_up() returned %d\n", __func__,
+			err);
 	}
 	return err;
 }
@@ -251,7 +254,8 @@ ieee_set_channel(struct ieee80211_hw *hw, struct ieee80211_channel *chan,
 		break;
 	case NL80211_CHAN_HT40MINUS:
 	case NL80211_CHAN_HT40PLUS:
-		WL_ERROR("%s: Need to implement 40 Mhz Channels!\n", __func__);
+		dev_err(wl->dev,
+			"%s: Need to implement 40 Mhz Channels!\n", __func__);
 		err = 1;
 		break;
 	}
@@ -267,13 +271,15 @@ static int wl_ops_config(struct ieee80211_hw *hw, u32 changed)
 	struct wl_info *wl = HW_TO_WL(hw);
 	int err = 0;
 	int new_int;
+	struct device *dev;
 
 	WL_LOCK(wl);
+	dev = wl->dev;
 	if (changed & IEEE80211_CONF_CHANGE_LISTEN_INTERVAL) {
 		if (wlc_iovar_setint
 		    (wl->wlc, "bcn_li_bcn", conf->listen_interval)) {
-			WL_ERROR("%s: Error setting listen_interval\n",
-				 __func__);
+			dev_err(dev, "%s: Error setting listen_interval\n",
+				__func__);
 			err = -EIO;
 			goto config_out;
 		}
@@ -281,25 +287,26 @@ static int wl_ops_config(struct ieee80211_hw *hw, u32 changed)
 		ASSERT(new_int == conf->listen_interval);
 	}
 	if (changed & IEEE80211_CONF_CHANGE_MONITOR)
-		WL_ERROR("%s: change monitor mode: %s (implement)\n", __func__,
-			 conf->flags & IEEE80211_CONF_MONITOR ?
-				"true" : "false");
+		dev_err(dev, "%s: change monitor mode: %s (implement)\n",
+			__func__, conf->flags & IEEE80211_CONF_MONITOR ?
+			"true" : "false");
 	if (changed & IEEE80211_CONF_CHANGE_PS)
-		WL_ERROR("%s: change power-save mode: %s (implement)\n",
-			 __func__, conf->flags & IEEE80211_CONF_PS ?
-				"true" : "false");
+		dev_err(dev, "%s: change power-save mode: %s (implement)\n",
+			__func__, conf->flags & IEEE80211_CONF_PS ?
+			"true" : "false");
 
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
 		if (wlc_iovar_setint
 		    (wl->wlc, "qtxpower", conf->power_level * 4)) {
-			WL_ERROR("%s: Error setting power_level\n", __func__);
+			dev_err(dev, "%s: Error setting power_level\n",
+				__func__);
 			err = -EIO;
 			goto config_out;
 		}
 		wlc_iovar_getint(wl->wlc, "qtxpower", &new_int);
 		if (new_int != (conf->power_level * 4))
-			WL_ERROR("%s: Power level req != actual, %d %d\n",
-				 __func__, conf->power_level * 4, new_int);
+			dev_err(dev, "%s: Power level req != actual, %d %d\n",
+				__func__, conf->power_level * 4, new_int);
 	}
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
 		err = ieee_set_channel(hw, conf->channel, conf->channel_type);
@@ -308,13 +315,13 @@ static int wl_ops_config(struct ieee80211_hw *hw, u32 changed)
 		if (wlc_set
 		    (wl->wlc, WLC_SET_SRL,
 		     conf->short_frame_max_tx_count) < 0) {
-			WL_ERROR("%s: Error setting srl\n", __func__);
+			dev_err(dev, "%s: Error setting srl\n", __func__);
 			err = -EIO;
 			goto config_out;
 		}
 		if (wlc_set(wl->wlc, WLC_SET_LRL, conf->long_frame_max_tx_count)
 		    < 0) {
-			WL_ERROR("%s: Error setting lrl\n", __func__);
+			dev_err(dev, "%s: Error setting lrl\n", __func__);
 			err = -EIO;
 			goto config_out;
 		}
@@ -331,24 +338,25 @@ wl_ops_bss_info_changed(struct ieee80211_hw *hw,
 			struct ieee80211_bss_conf *info, u32 changed)
 {
 	struct wl_info *wl = HW_TO_WL(hw);
+	struct device *dev = wl->dev;
 	int val;
 
 	if (changed & BSS_CHANGED_ASSOC) {
 		/* association status changed (associated/disassociated)
 		 * also implies a change in the AID.
 		 */
-		WL_ERROR("%s: %s: %sassociated\n", KBUILD_MODNAME, __func__,
-			 info->assoc ? "" : "dis");
+		dev_err(dev, "%s: %s: %sassociated\n", KBUILD_MODNAME,
+			__func__, info->assoc ? "" : "dis");
 		wlc_associate_upd(wl->wlc, info->assoc);
 	}
 	if (changed & BSS_CHANGED_ERP_CTS_PROT) {
 		/* CTS protection changed */
-		WL_ERROR("%s: use_cts_prot: %s (implement)\n", __func__,
+		dev_err(dev, "%s: use_cts_prot: %s (implement)\n", __func__,
 			info->use_cts_prot ? "true" : "false");
 	}
 	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
 		/* preamble changed */
-		WL_ERROR("%s: short preamble: %s (implement)\n", __func__,
+		dev_err(dev, "%s: short preamble: %s (implement)\n", __func__,
 			info->use_short_preamble ? "true" : "false");
 	}
 	if (changed & BSS_CHANGED_ERP_SLOT) {
@@ -375,8 +383,8 @@ wl_ops_bss_info_changed(struct ieee80211_hw *hw,
 	}
 	if (changed & BSS_CHANGED_BASIC_RATES) {
 		/* Basic rateset changed */
-		WL_ERROR("%s: Need to change Basic Rates: 0x%x (implement)\n",
-			 __func__, (u32) info->basic_rates);
+		dev_err(dev, "%s: Need to change Basic Rates: 0x%x"
+			" (implement)\n", __func__, (u32) info->basic_rates);
 	}
 	if (changed & BSS_CHANGED_BEACON_INT) {
 		/* Beacon interval changed */
@@ -395,40 +403,40 @@ wl_ops_bss_info_changed(struct ieee80211_hw *hw,
 	}
 	if (changed & BSS_CHANGED_BEACON) {
 		/* Beacon data changed, retrieve new beacon (beaconing modes) */
-		WL_ERROR("%s: beacon changed\n", __func__);
+		dev_err(dev, "%s: beacon changed\n", __func__);
 	}
 	if (changed & BSS_CHANGED_BEACON_ENABLED) {
 		/* Beaconing should be enabled/disabled (beaconing modes) */
-		WL_ERROR("%s: Beacon enabled: %s\n", __func__,
+		dev_err(dev, "%s: Beacon enabled: %s\n", __func__,
 			 info->enable_beacon ? "true" : "false");
 	}
 	if (changed & BSS_CHANGED_CQM) {
 		/* Connection quality monitor config changed */
-		WL_ERROR("%s: cqm change: threshold %d, hys %d (implement)\n",
+		dev_err(dev, "%s: cqm change: threshold %d, hys %d (implement)\n",
 			__func__, info->cqm_rssi_thold, info->cqm_rssi_hyst);
 	}
 	if (changed & BSS_CHANGED_IBSS) {
 		/* IBSS join status changed */
-		WL_ERROR("%s: IBSS joined: %s (implement)\n", __func__,
+		dev_err(dev, "%s: IBSS joined: %s (implement)\n", __func__,
 			info->ibss_joined ? "true" : "false");
 	}
 	if (changed & BSS_CHANGED_ARP_FILTER) {
 		/* Hardware ARP filter address list or state changed */
-		WL_ERROR("%s: arp filtering: enabled %s, count %d (implement)\n",
-			__func__, info->arp_filter_enabled ? "true" : "false",
-			info->arp_addr_cnt);
+		dev_err(dev, "%s: arp filtering: enabled %s, count %d"
+			" (implement)\n", __func__, info->arp_filter_enabled ?
+			"true" : "false", info->arp_addr_cnt);
 	}
 	if (changed & BSS_CHANGED_QOS) {
 		/*
 		 * QoS for this association was enabled/disabled.
 		 * Note that it is only ever disabled for station mode.
 		 */
-		WL_ERROR("%s: qos enabled: %s (implement)\n", __func__,
+		dev_err(dev, "%s: qos enabled: %s (implement)\n", __func__,
 			info->qos ? "true" : "false");
 	}
 	if (changed & BSS_CHANGED_IDLE) {
 		/* Idle changed for this BSS/interface */
-		WL_ERROR("%s: BSS idle: %s (implement)\n", __func__,
+		dev_err(dev, "%s: BSS idle: %s (implement)\n", __func__,
 			info->idle ? "true" : "false");
 	}
 	return;
@@ -440,21 +448,22 @@ wl_ops_configure_filter(struct ieee80211_hw *hw,
 			unsigned int *total_flags, u64 multicast)
 {
 	struct wl_info *wl = hw->priv;
+	struct device *dev = wl->dev;
 
 	changed_flags &= MAC_FILTERS;
 	*total_flags &= MAC_FILTERS;
 	if (changed_flags & FIF_PROMISC_IN_BSS)
-		WL_ERROR("FIF_PROMISC_IN_BSS\n");
+		dev_err(dev, "FIF_PROMISC_IN_BSS\n");
 	if (changed_flags & FIF_ALLMULTI)
-		WL_ERROR("FIF_ALLMULTI\n");
+		dev_err(dev, "FIF_ALLMULTI\n");
 	if (changed_flags & FIF_FCSFAIL)
-		WL_ERROR("FIF_FCSFAIL\n");
+		dev_err(dev, "FIF_FCSFAIL\n");
 	if (changed_flags & FIF_PLCPFAIL)
-		WL_ERROR("FIF_PLCPFAIL\n");
+		dev_err(dev, "FIF_PLCPFAIL\n");
 	if (changed_flags & FIF_CONTROL)
-		WL_ERROR("FIF_CONTROL\n");
+		dev_err(dev, "FIF_CONTROL\n");
 	if (changed_flags & FIF_OTHER_BSS)
-		WL_ERROR("FIF_OTHER_BSS\n");
+		dev_err(dev, "FIF_OTHER_BSS\n");
 	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
 		no_printk("FIF_BCN_PRBRESP_PROMISC\n");
 		WL_LOCK(wl);
@@ -499,7 +508,7 @@ static void wl_ops_sw_scan_complete(struct ieee80211_hw *hw)
 
 static void wl_ops_set_tsf(struct ieee80211_hw *hw, u64 tsf)
 {
-	WL_ERROR("%s: Enter\n", __func__);
+	dev_err(&hw->wiphy->dev, "%s: Enter\n", __func__);
 	return;
 }
 
@@ -537,7 +546,8 @@ wl_ops_sta_notify(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	no_printk("%s: Enter\n", __func__);
 	switch (cmd) {
 	default:
-		WL_ERROR("%s: Unknown cmd = %d\n", __func__, cmd);
+		dev_err(&hw->wiphy->dev, "%s: Unknown cmd = %d\n", __func__,
+			cmd);
 		break;
 	}
 	return;
@@ -562,7 +572,7 @@ wl_ops_conf_tx(struct ieee80211_hw *hw, u16 queue,
 
 static u64 wl_ops_get_tsf(struct ieee80211_hw *hw)
 {
-	WL_ERROR("%s: Enter\n", __func__);
+	dev_err(&hw->wiphy->dev, "%s: Enter\n", __func__);
 	return 0;
 }
 
@@ -635,7 +645,8 @@ wl_ops_ampdu_action(struct ieee80211_hw *hw,
 		status = wlc_aggregatable(wl->wlc, tid);
 		WL_UNLOCK(wl);
 		if (!status) {
-			/* WL_ERROR("START: tid %d is not agg' able, return FAILURE to stack\n", tid); */
+			dev_err(wl->dev, "START: tid %d is not agg\'able\n",
+				tid);
 			return -1;
 		}
 		/* XXX: Use the starting sequence number provided ... */
@@ -656,7 +667,8 @@ wl_ops_ampdu_action(struct ieee80211_hw *hw,
 			__func__);
 		break;
 	default:
-		WL_ERROR("%s: Invalid command, ignoring\n", __func__);
+		dev_err(wl->dev, "%s: Invalid command, ignoring\n",
+			__func__);
 	}
 
 	return 0;
@@ -736,10 +748,6 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 	unit = wl_found;
 	err = 0;
 
-	if (unit < 0) {
-		WL_ERROR("wl%d: unit number overflow, exiting\n", unit);
-		return NULL;
-	}
 
 	/* allocate private info */
 	hw = pci_get_drvdata(btparam);	/* btparam == pdev */
@@ -748,6 +756,12 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 
 	wl->dev = get_device(&hw->wiphy->dev);
 
+	if (unit < 0) {
+		dev_err(wl->dev, "wl%d: unit number overflow, exiting\n", unit);
+		put_device(wl->dev);
+		return NULL;
+	}
+
 	atomic_set(&wl->callbacks, 0);
 
 	/* setup the bottom half handler */
@@ -769,7 +783,7 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 
 	wl->regsva = ioremap_nocache(base_addr, PCI_BAR0_WINSZ);
 	if (wl->regsva == NULL) {
-		WL_ERROR("wl%d: ioremap() failed\n", unit);
+		dev_err(wl->dev, "wl%d: ioremap() failed\n", unit);
 		goto fail;
 	}
 	spin_lock_init(&wl->lock);
@@ -777,8 +791,8 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 
 	/* prepare ucode */
 	if (wl_request_fw(wl, (struct pci_dev *)btparam) < 0) {
-		WL_ERROR("%s: Failed to find firmware usually in %s\n",
-			 KBUILD_MODNAME, "/lib/firmware/brcm");
+		dev_err(wl->dev, "%s: Failed to find firmware usually in %s\n",
+			KBUILD_MODNAME, "/lib/firmware/brcm");
 		wl_release_fw(wl);
 		wl_remove((struct pci_dev *)btparam);
 		goto fail1;
@@ -790,8 +804,8 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 			     &hw->wiphy->dev);
 	wl_release_fw(wl);
 	if (!wl->wlc) {
-		WL_ERROR("%s: wlc_attach() failed with code %d\n",
-			 KBUILD_MODNAME, err);
+		dev_err(wl->dev, "%s: wlc_attach() failed with code %d\n",
+			KBUILD_MODNAME, err);
 		goto fail;
 	}
 	wl->pub = wlc_pub(wl->wlc);
@@ -802,12 +816,13 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 
 
 	if (wlc_iovar_setint(wl->wlc, "mpc", 0)) {
-		WL_ERROR("wl%d: Error setting MPC variable to 0\n", unit);
+		dev_err(wl->dev, "wl%d: Error setting MPC variable to 0\n",
+			unit);
 	}
 
 	/* register our interrupt handler */
 	if (request_irq(irq, wl_isr, IRQF_SHARED, KBUILD_MODNAME, wl)) {
-		WL_ERROR("wl%d: request_irq() failed\n", unit);
+		dev_err(wl->dev, "wl%d: request_irq() failed\n", unit);
 		goto fail;
 	}
 	wl->irq = irq;
@@ -817,7 +832,8 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 			    NULL);
 
 	if (ieee_hw_init(hw)) {
-		WL_ERROR("wl%d: %s: ieee_hw_init failed!\n", unit, __func__);
+		dev_err(wl->dev, "wl%d: %s: ieee_hw_init failed!\n", unit,
+			__func__);
 		goto fail;
 	}
 
@@ -827,8 +843,8 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 
 	err = ieee80211_register_hw(hw);
 	if (err) {
-		WL_ERROR("%s: ieee80211_register_hw failed, status %d\n",
-			 __func__, err);
+		dev_err(wl->dev, "%s: ieee80211_register_hw failed, status"
+			"%d\n", __func__, err);
 	}
 
 	if (wl->pub->srom_ccode[0])
@@ -836,8 +852,8 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 	else
 		err = wl_set_hint(wl, "US");
 	if (err) {
-		WL_ERROR("%s: regulatory_hint failed, status %d\n",
-			 __func__, err);
+		dev_err(wl->dev, "%s: regulatory_hint failed, status %d\n",
+			__func__, err);
 	}
 
 	wl_found++;
@@ -1031,7 +1047,7 @@ static int ieee_hw_rate_init(struct ieee80211_hw *hw)
 	hw->wiphy->bands[IEEE80211_BAND_5GHZ] = NULL;
 
 	if (wlc_get(wl->wlc, WLC_GET_PHYLIST, (int *)&phy_list) < 0) {
-		WL_ERROR("Phy list failed\n");
+		dev_err(&hw->wiphy->dev, "Phy list failed\n");
 	}
 	no_printk("%s: phylist = %c\n", __func__, phy_list[0]);
 
@@ -1121,9 +1137,9 @@ wl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
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
@@ -1134,7 +1150,7 @@ wl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	hw = ieee80211_alloc_hw(sizeof(struct wl_info), &wl_ops);
 	if (!hw) {
-		WL_ERROR("%s: ieee80211_alloc_hw failed\n", __func__);
+		pr_err("%s: ieee80211_alloc_hw failed\n", __func__);
 		rc = -ENOMEM;
 		goto err_1;
 	}
@@ -1149,13 +1165,13 @@ wl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
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
 
@@ -1169,7 +1185,8 @@ static int wl_suspend(struct pci_dev *pdev, pm_message_t state)
 	hw = pci_get_drvdata(pdev);
 	wl = HW_TO_WL(hw);
 	if (!wl) {
-		WL_ERROR("wl: wl_suspend: pci_get_drvdata failed\n");
+		dev_err(wl->dev,
+			"wl: wl_suspend: pci_get_drvdata failed\n");
 		return -ENODEV;
 	}
 
@@ -1194,7 +1211,8 @@ static int wl_resume(struct pci_dev *pdev)
 	hw = pci_get_drvdata(pdev);
 	wl = HW_TO_WL(hw);
 	if (!wl) {
-		WL_ERROR("wl: wl_resume: pci_get_drvdata failed\n");
+		dev_err(wl->dev,
+			"wl: wl_resume: pci_get_drvdata failed\n");
 		return -ENODEV;
 	}
 
@@ -1234,7 +1252,7 @@ static void wl_remove(struct pci_dev *pdev)
 	hw = pci_get_drvdata(pdev);
 	wl = HW_TO_WL(hw);
 	if (!wl) {
-		WL_ERROR("wl: wl_remove: pci_get_drvdata failed\n");
+		pr_err("wl: wl_remove: pci_get_drvdata failed\n");
 		return;
 	}
 
@@ -1242,7 +1260,7 @@ static void wl_remove(struct pci_dev *pdev)
 	status = wlc_chipmatch(pdev->vendor, pdev->device);
 	WL_UNLOCK(wl);
 	if (!status) {
-		WL_ERROR("wl: wl_remove: wlc_chipmatch failed\n");
+		dev_err(wl->dev, "wl: wl_remove: wlc_chipmatch failed\n");
 		return;
 	}
 	if (wl->wlc) {
@@ -1397,7 +1415,7 @@ static void wl_free(struct wl_info *wl)
 void wl_txflowcontrol(struct wl_info *wl, struct wl_if *wlif, bool state,
 		      int prio)
 {
-	WL_ERROR("Shouldn't be here %s\n", __func__);
+	dev_err(wl->dev, "Shouldn't be here %s\n", __func__);
 }
 
 /*
@@ -1615,7 +1633,8 @@ struct wl_timer *wl_init_timer(struct wl_info *wl, void (*fn) (void *arg),
 
 	t = kzalloc(sizeof(struct wl_timer), GFP_ATOMIC);
 	if (!t) {
-		WL_ERROR("wl%d: wl_init_timer: out of memory\n", wl->pub->unit);
+		dev_err(wl->dev,
+			"wl%d: wl_init_timer: out of memory\n", wl->pub->unit);
 		return 0;
 	}
 
@@ -1646,8 +1665,8 @@ void wl_add_timer(struct wl_info *wl, struct wl_timer *t, uint ms, int periodic)
 {
 #ifdef BCMDBG
 	if (t->set) {
-		WL_ERROR("%s: Already set. Name: %s, per %d\n",
-			 __func__, t->name, periodic);
+		dev_err(wl->dev, "%s: Already set. Name: %s, per %d\n",
+			__func__, t->name, periodic);
 	}
 #endif
 	ASSERT(!t->set);
@@ -1774,6 +1793,8 @@ int wl_ucode_init_buf(struct wl_info *wl, void **pbuf, u32 idx)
 	int i, entry;
 	const u8 *pdata;
 	struct wl_fw_hdr *hdr;
+	struct device *dev = wl->dev;
+
 	for (i = 0; i < wl->fw.fw_cnt; i++) {
 		hdr = (struct wl_fw_hdr *)wl->fw.fw_hdr[i]->data;
 		for (entry = 0; entry < wl->fw.hdr_num_entries[i];
@@ -1782,8 +1803,8 @@ int wl_ucode_init_buf(struct wl_info *wl, void **pbuf, u32 idx)
 				pdata = wl->fw.fw_bin[i]->data + hdr->offset;
 				*pbuf = kmalloc(hdr->len, GFP_ATOMIC);
 				if (*pbuf == NULL) {
-					WL_ERROR("fail to alloc %d bytes\n",
-						 hdr->len);
+					dev_err(dev, "fail to alloc %d bytes"
+						"\n", hdr->len);
 					goto fail;
 				}
 				memcpy(*pbuf, pdata, hdr->len);
@@ -1791,7 +1812,7 @@ int wl_ucode_init_buf(struct wl_info *wl, void **pbuf, u32 idx)
 			}
 		}
 	}
-	WL_ERROR("ERROR: ucode buf tag:%d can not be found!\n", idx);
+	dev_err(dev, "ERROR: ucode buf tag:%d can not be found!\n", idx);
 	*pbuf = NULL;
 fail:
 	return BCME_NOTFOUND;
@@ -1818,7 +1839,7 @@ int wl_ucode_init_uint(struct wl_info *wl, u32 *data, u32 idx)
 			}
 		}
 	}
-	WL_ERROR("ERROR: ucode tag:%d can not be found!\n", idx);
+	dev_err(wl->dev, "ERROR: ucode tag:%d can not be found!\n", idx);
 	return -1;
 }
 
@@ -1829,7 +1850,7 @@ int wl_ucode_init_uint(struct wl_info *wl, u32 *data, u32 idx)
 static int wl_request_fw(struct wl_info *wl, struct pci_dev *pdev)
 {
 	int status;
-	struct device *device = &pdev->dev;
+	struct device *dev = &pdev->dev;
 	char fw_name[100];
 	int i;
 
@@ -1840,19 +1861,19 @@ static int wl_request_fw(struct wl_info *wl, struct pci_dev *pdev)
 		sprintf(fw_name, "%s-%d.fw", wl_firmwares[i],
 			UCODE_LOADER_API_VER);
 		no_printk("request fw %s\n", fw_name);
-		status = request_firmware(&wl->fw.fw_bin[i], fw_name, device);
+		status = request_firmware(&wl->fw.fw_bin[i], fw_name, dev);
 		if (status) {
-			WL_ERROR("%s: fail to load firmware %s\n",
-				 KBUILD_MODNAME, fw_name);
+			dev_err(dev, "%s: fail to load firmware %s\n",
+				KBUILD_MODNAME, fw_name);
 			return status;
 		}
 		no_printk("request fw %s\n", fw_name);
 		sprintf(fw_name, "%s_hdr-%d.fw", wl_firmwares[i],
 			UCODE_LOADER_API_VER);
-		status = request_firmware(&wl->fw.fw_hdr[i], fw_name, device);
+		status = request_firmware(&wl->fw.fw_hdr[i], fw_name, dev);
 		if (status) {
-			WL_ERROR("%s: fail to load firmware %s\n",
-				 KBUILD_MODNAME, fw_name);
+			dev_err(dev, "%s: fail to load firmware %s\n",
+				KBUILD_MODNAME, fw_name);
 			return status;
 		}
 		wl->fw.hdr_num_entries[i] =
@@ -1900,22 +1921,24 @@ int wl_check_firmwares(struct wl_info *wl)
 	const struct firmware *fw;
 	const struct firmware *fw_hdr;
 	struct wl_fw_hdr *ucode_hdr;
+	struct device *dev = wl->dev;
+
 	for (i = 0; i < WL_MAX_FW && rc == 0; i++) {
 		fw =  wl->fw.fw_bin[i];
 		fw_hdr = wl->fw.fw_hdr[i];
 		if (fw == NULL && fw_hdr == NULL) {
 			break;
 		} else if (fw == NULL || fw_hdr == NULL) {
-			WL_ERROR("%s: invalid bin/hdr fw\n", __func__);
+			dev_err(dev, "%s: invalid bin/hdr fw\n", __func__);
 			rc = -EBADF;
 		} else if (fw_hdr->size % sizeof(struct wl_fw_hdr)) {
-			WL_ERROR("%s: non integral fw hdr file size %zu/%zu\n",
-				 __func__, fw_hdr->size,
-				 sizeof(struct wl_fw_hdr));
+			dev_err(dev, "%s: non integral fw hdr file size %zu/%zu"
+				"\n", __func__, fw_hdr->size,
+				sizeof(struct wl_fw_hdr));
 			rc = -EBADF;
 		} else if (fw->size < MIN_FW_SIZE || fw->size > MAX_FW_SIZE) {
-			WL_ERROR("%s: out of bounds fw file size %zu\n",
-				 __func__, fw->size);
+			dev_err(dev, "%s: out of bounds fw file size %zu\n",
+				__func__, fw->size);
 			rc = -EBADF;
 		} else {
 			/* check if ucode section overruns firmware image */
@@ -1924,15 +1947,16 @@ int wl_check_firmwares(struct wl_info *wl)
 			     !rc; entry++, ucode_hdr++) {
 				if (ucode_hdr->offset + ucode_hdr->len >
 				    fw->size) {
-					WL_ERROR("%s: conflicting bin/hdr\n",
-						 __func__);
+					dev_err(dev, "%s: conflicting bin/hdr"
+						"\n", __func__);
 					rc = -EBADF;
 				}
 			}
 		}
 	}
 	if (rc == 0 && wl->fw.fw_cnt != i) {
-		WL_ERROR("%s: invalid fw_cnt=%d\n", __func__, wl->fw.fw_cnt);
+		dev_err(dev, "%s: invalid fw_cnt=%d\n", __func__,
+			wl->fw.fw_cnt);
 		rc = -EBADF;
 	}
 	return rc;
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c b/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
index 85a73a9..9e44991 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
@@ -98,8 +98,8 @@ struct antsel_info *wlc_antsel_attach(struct wlc_info *wlc)
 
 	asi = kzalloc(sizeof(struct antsel_info), GFP_ATOMIC);
 	if (!asi) {
-		WL_ERROR("wl%d: wlc_antsel_attach: out of mem\n",
-			 wlc->pub->unit);
+		dev_err(wlc->dev, "wl%d: wlc_antsel_attach: out of mem\n",
+			wlc->pub->unit);
 		return NULL;
 	}
 
@@ -128,7 +128,8 @@ struct antsel_info *wlc_antsel_attach(struct wlc_info *wlc)
 				asi->antsel_avail = false;
 			} else {
 				asi->antsel_avail = false;
-				WL_ERROR("wlc_antsel_attach: 2o3 board cfg invalid\n");
+				dev_err(wlc->dev, "wlc_antsel_attach: 2o3 "
+					"board cfg invalid\n");
 				ASSERT(0);
 			}
 			break;
-- 
1.7.1


