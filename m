Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fbr01-uk.csee.siteprotect.eu ([81.3.27.131]:47333 "EHLO
	fbr01-uk.csee.siteprotect.eu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751561AbcCOKmT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2016 06:42:19 -0400
Received: from smtpauth01-uk.csee.siteprotect.eu (unknown [192.168.22.213])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client CN "smtp.securepod.com", Issuer "RapidSSL SHA256 CA - G3" (not verified))
	by fbr01-uk.csee.siteprotect.eu (Postfix) with ESMTPS id A205C42155
	for <linux-wireless@vger.kernel.org>; Tue, 15 Mar 2016 11:42:16 +0100 (CET)
Received: from Authenticated sender: roger@beardandsandals.co.uk
	by smtpauth01-uk.csee.siteprotect.eu (Postfix) with ESMTPSA id 7AEC140634
	for <linux-wireless@vger.kernel.org>; Tue, 15 Mar 2016 11:42:16 +0100 (CET)
From: Roger James <roger@beardandsandals.co.uk>
Subject: The mac80211 softmac driver subsystem and handling of monitor
 interfaces
To: linux-wireless@vger.kernel.org
Message-ID: <56E7E707.2050900@beardandsandals.co.uk> (sfid-20160315_114224_775256_DBFB4DF0)
Date: Tue, 15 Mar 2016 10:42:15 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

For various reasons I have been looking into the handling of monitor 
virtual interfaces in drivers that link with the mac80211 module.
It is my understanding that monitor interfaces are not "notified" to the 
driver module, and that driver modules should handle the 
IEEE80211_CONF_CHANGE_MONITOR flag passed down by the config callback 
whenever the set of virtual interfaces changes between having zero and 
one monitor member. I am basing this assumption on Johannes's 2009 
presentation

    "relevancy to drivers

    drivers need to allow each interface type

    drivers need to support certain operations for certain interface
    types

    drivers can support multiple virtual interfaces

    but:
    drivers not notified of monitor interface"

and the somewhat opaque comments in mac80211.h

    "@IEEE80211_CONF_MONITOR: there's a monitor interface present --
     use this to determine for example whether to calculate timestamps
     for packets or not, do not use instead of filter flags!"

Firstly is this assumption correct?

Looking at the drivers in the current mainline kernel that link the 
mac80211 modules only a small minority of them hook this event. They are :-

ath/ath10k ath/ath9k (both ath9k and ath9k_htc) cw1200 brcm80211/brcmsmac

All the others seem to be doing things with NL80211_IFTYPE_MONITOR in 
the vif structure. This seems contradictory.

If my assumptions are true I would expect drivers to do whatever private 
interaction with the hardware to enable monitoring at the point
they receive the monitor change notification.  For example setting up 
the right frame headers and frame types to pass up etc. I wonder why the 
majority of drivers seem to be doing it elsewhere. I assume this is 
historical. I also assume that hw filters are handled separately so that 
different monitor vifs can have different flag sets.

Please feel free to tear this to shreds! I am on a steep learning curve 
on this. I have read most of the docs I could find and studied the code, 
but please let me have any suggestions you have for further research.

For information I have appended a couple of greps in the current 
mainline kernel tree and a list of modules in my current running kernel 
linking mac80211, after the end of this note.

Thanks
Roger

roger@dragon:~/linux-mainline/drivers/net/wireless$ find . -name 
"*.[ch]" -exec rgrep NL80211_IFTYPE_MONITOR {} \; -print
		{NL80211_IFTYPE_MONITOR,	WMI_NETTYPE_ADHOC}, /* FIXME */
	case NL80211_IFTYPE_MONITOR:
				 BIT(NL80211_IFTYPE_MONITOR);
./ath/wil6210/cfg80211.c
	if (wil->wdev->iftype == NL80211_IFTYPE_MONITOR) {
./ath/wil6210/ethtool.c
	if (wdev->iftype == NL80211_IFTYPE_MONITOR) {
./ath/wil6210/wmi.c
		if (wil->wdev->iftype == NL80211_IFTYPE_MONITOR) {
	if (unlikely(wil->wdev->iftype == NL80211_IFTYPE_MONITOR)) {
./ath/wil6210/txrx.c
	if (wil->wdev->iftype == NL80211_IFTYPE_MONITOR)
./ath/wil6210/interrupt.c
	case NL80211_IFTYPE_MONITOR:
./ath/wil6210/pm.c
	case NL80211_IFTYPE_MONITOR:
	case NL80211_IFTYPE_MONITOR:
./ath/wil6210/main.c
	case NL80211_IFTYPE_MONITOR:
./ath/debug.c
	if (!vif || vif->type == NL80211_IFTYPE_MONITOR)
	case NL80211_IFTYPE_MONITOR:
	if (vif->type == NL80211_IFTYPE_MONITOR) {
	if (vif->type == NL80211_IFTYPE_MONITOR) {
	if (vif->type == NL80211_IFTYPE_MONITOR) {
	if (vif->type == NL80211_IFTYPE_MONITOR) {
./ath/ath10k/mac.c
		priv->ah->opmode = NL80211_IFTYPE_MONITOR;
./ath/ath9k/htc_drv_main.c
	case NL80211_IFTYPE_MONITOR:
	case NL80211_IFTYPE_MONITOR:
./ath/ath5k/pcu.c
		     ah->opmode == NL80211_IFTYPE_MONITOR)) {
./ath/ath5k/base.c
	case NL80211_IFTYPE_MONITOR:
./zydas/zd1211rw/zd_mac.c
	case NL80211_IFTYPE_MONITOR:
./st/cw1200/debug.c
	priv->mode = NL80211_IFTYPE_MONITOR;
	if (priv->mode != NL80211_IFTYPE_MONITOR) {
	priv->mode = NL80211_IFTYPE_MONITOR;
	case NL80211_IFTYPE_MONITOR:
	    priv->mode == NL80211_IFTYPE_MONITOR ||
./st/cw1200/sta.c
	case NL80211_IFTYPE_MONITOR:
./st/cw1200/wsm.c
	case NL80211_IFTYPE_MONITOR:
	if (vif->type == NL80211_IFTYPE_MONITOR) {
	case NL80211_IFTYPE_MONITOR:
./intel/iwlwifi/mvm/mac80211.c
	case NL80211_IFTYPE_MONITOR:
./intel/iwlwifi/mvm/quota.c
	case NL80211_IFTYPE_MONITOR:
	WARN_ON(vif->type != NL80211_IFTYPE_MONITOR);
	case NL80211_IFTYPE_MONITOR:
	if (vif->type == NL80211_IFTYPE_MONITOR) {
./intel/iwlwifi/mvm/mac-ctxt.c
	case NL80211_IFTYPE_MONITOR:
./intel/iwlwifi/mvm/power.c
	if (vif->type == NL80211_IFTYPE_MONITOR)
./intel/iwlwifi/dvm/mac80211.c
	case NL80211_IFTYPE_MONITOR:
./intel/iwlwifi/dvm/rxon.c
		BIT(NL80211_IFTYPE_ADHOC) | BIT(NL80211_IFTYPE_MONITOR);
./intel/iwlwifi/dvm/main.c
	case NL80211_IFTYPE_MONITOR:
		wdev->wiphy->interface_modes |= BIT(NL80211_IFTYPE_MONITOR);
./marvell/libertas/cfg.c
	if (priv->wdev->iftype == NL80211_IFTYPE_MONITOR) {
./marvell/libertas/mesh.c
	if (priv->wdev->iftype == NL80211_IFTYPE_MONITOR) {
	if (priv->wdev->iftype == NL80211_IFTYPE_MONITOR) {
	if (priv->wdev->iftype != NL80211_IFTYPE_MONITOR ||
./marvell/libertas/tx.c
	case NL80211_IFTYPE_MONITOR:
		if (priv->wdev->iftype == NL80211_IFTYPE_MONITOR)
		if (priv->wdev->iftype == NL80211_IFTYPE_MONITOR)
./marvell/libertas/main.c
	if (priv->wdev->iftype == NL80211_IFTYPE_MONITOR) {
./marvell/libertas/rx.c
			if (priv->wdev->iftype == NL80211_IFTYPE_MONITOR &&
./marvell/libertas/cmdresp.c
	case NL80211_IFTYPE_MONITOR:
	case NL80211_IFTYPE_MONITOR:
	case NL80211_IFTYPE_MONITOR:
./broadcom/brcm80211/brcmfmac/cfg80211.c
		case NL80211_IFTYPE_MONITOR:
./intersil/p54/fwio.c
	case NL80211_IFTYPE_MONITOR:
./intersil/p54/txrx.c
	priv->mode = NL80211_IFTYPE_MONITOR;
	if (priv->mode != NL80211_IFTYPE_MONITOR) {
	priv->mode = NL80211_IFTYPE_MONITOR;
./intersil/p54/main.c
		wiphy->interface_modes |= BIT(NL80211_IFTYPE_MONITOR);
	case NL80211_IFTYPE_MONITOR:
	if (priv->iw_mode == NL80211_IFTYPE_MONITOR) {
./intersil/orinoco/cfg.c
	if (priv->iw_mode == NL80211_IFTYPE_MONITOR) {
./intersil/orinoco/wext.c
	    (priv->iw_mode == NL80211_IFTYPE_MONITOR)) {
./intersil/orinoco/orinoco_usb.c
	if (priv->iw_mode == NL80211_IFTYPE_MONITOR) {
		if (priv->iw_mode == NL80211_IFTYPE_MONITOR)
	if (priv->iw_mode == NL80211_IFTYPE_MONITOR) {
./intersil/orinoco/hw.c
	case NL80211_IFTYPE_MONITOR:
	    (priv->iw_mode == NL80211_IFTYPE_MONITOR)) {
	if (priv->iw_mode == NL80211_IFTYPE_MONITOR) {
		if (priv->iw_mode == NL80211_IFTYPE_MONITOR)
./intersil/orinoco/main.c
	case NL80211_IFTYPE_MONITOR:
	if (priv->mode != NL80211_IFTYPE_MONITOR)
	priv->mode = NL80211_IFTYPE_MONITOR;
	priv->mode = NL80211_IFTYPE_MONITOR;
./admtek/adm8211.c
roger@dragon:~/linux-mainline/drivers/net/wireless$ find . -name 
"*.[ch]" -exec rgrep IEEE80211_CONF_CHANGE_MONITOR {} \; -print
	if (changed & IEEE80211_CONF_CHANGE_MONITOR) {
./ath/ath10k/mac.c
	if (changed & IEEE80211_CONF_CHANGE_MONITOR) {
./ath/ath9k/htc_drv_main.c
	if (changed & IEEE80211_CONF_CHANGE_MONITOR) {
./ath/ath9k/main.c
	if (changed & IEEE80211_CONF_CHANGE_MONITOR) {
./ti/wl1251/main.c
	if (changed & IEEE80211_CONF_CHANGE_MONITOR) {
./st/cw1200/sta.c
	if (changed & IEEE80211_CONF_CHANGE_MONITOR)
./broadcom/brcm80211/brcmsmac/mac80211_if.c

The following comes from the kernel I am currently running (4.2.0) not 
the latest mainline.

roger@dragon:/lib/modules/4.2.0-30-generic$ grep mac80211 modules.dep | 
cut -d: -f1
kernel/drivers/net/wireless/mediatek/mt7601u/mt7601u.ko
kernel/drivers/net/wireless/ti/wlcore/wlcore.ko
kernel/drivers/net/wireless/ti/wl12xx/wl12xx.ko
kernel/drivers/net/wireless/ti/wl1251/wl1251.ko
kernel/drivers/net/wireless/ti/wl1251/wl1251_spi.ko
kernel/drivers/net/wireless/ti/wl1251/wl1251_sdio.ko
kernel/drivers/net/wireless/ti/wl18xx/wl18xx.ko
kernel/drivers/net/wireless/at76c50x-usb.ko
kernel/drivers/net/wireless/b43/b43.ko
kernel/drivers/net/wireless/b43legacy/b43legacy.ko
kernel/drivers/net/wireless/zd1211rw/zd1211rw.ko
kernel/drivers/net/wireless/rtl818x/rtl8180/rtl818x_pci.ko
kernel/drivers/net/wireless/rtl818x/rtl8187/rtl8187.ko
kernel/drivers/net/wireless/rtlwifi/rtlwifi.ko
kernel/drivers/net/wireless/rtlwifi/rtl_pci.ko
kernel/drivers/net/wireless/rtlwifi/rtl_usb.ko
kernel/drivers/net/wireless/rtlwifi/rtl8192c/rtl8192c-common.ko
kernel/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192ce.ko
kernel/drivers/net/wireless/rtlwifi/rtl8192cu/rtl8192cu.ko
kernel/drivers/net/wireless/rtlwifi/rtl8192se/rtl8192se.ko
kernel/drivers/net/wireless/rtlwifi/rtl8192de/rtl8192de.ko
kernel/drivers/net/wireless/rtlwifi/rtl8723ae/rtl8723ae.ko
kernel/drivers/net/wireless/rtlwifi/rtl8723be/rtl8723be.ko
kernel/drivers/net/wireless/rtlwifi/rtl8188ee/rtl8188ee.ko
kernel/drivers/net/wireless/rtlwifi/rtl8821ae/rtl8821ae.ko
kernel/drivers/net/wireless/rtlwifi/rtl8192ee/rtl8192ee.ko
kernel/drivers/net/wireless/libertas_tf/libertas_tf.ko
kernel/drivers/net/wireless/libertas_tf/libertas_tf_usb.ko
kernel/drivers/net/wireless/adm8211.ko
kernel/drivers/net/wireless/mwl8k.ko
kernel/drivers/net/wireless/iwlwifi/dvm/iwldvm.ko
kernel/drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko
kernel/drivers/net/wireless/iwlegacy/iwlegacy.ko
kernel/drivers/net/wireless/iwlegacy/iwl4965.ko
kernel/drivers/net/wireless/iwlegacy/iwl3945.ko
kernel/drivers/net/wireless/rt2x00/rt2x00lib.ko
kernel/drivers/net/wireless/rt2x00/rt2x00mmio.ko
kernel/drivers/net/wireless/rt2x00/rt2x00pci.ko
kernel/drivers/net/wireless/rt2x00/rt2x00usb.ko
kernel/drivers/net/wireless/rt2x00/rt2800lib.ko
kernel/drivers/net/wireless/rt2x00/rt2800mmio.ko
kernel/drivers/net/wireless/rt2x00/rt2400pci.ko
kernel/drivers/net/wireless/rt2x00/rt2500pci.ko
kernel/drivers/net/wireless/rt2x00/rt61pci.ko
kernel/drivers/net/wireless/rt2x00/rt2800pci.ko
kernel/drivers/net/wireless/rt2x00/rt2500usb.ko
kernel/drivers/net/wireless/rt2x00/rt73usb.ko
kernel/drivers/net/wireless/rt2x00/rt2800usb.ko
kernel/drivers/net/wireless/p54/p54common.ko
kernel/drivers/net/wireless/p54/p54usb.ko
kernel/drivers/net/wireless/p54/p54pci.ko
kernel/drivers/net/wireless/p54/p54spi.ko
kernel/drivers/net/wireless/ath/ath5k/ath5k.ko
kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
kernel/drivers/net/wireless/ath/ath9k/ath9k_htc.ko
kernel/drivers/net/wireless/ath/carl9170/carl9170.ko
kernel/drivers/net/wireless/ath/ar5523/ar5523.ko
kernel/drivers/net/wireless/ath/ath10k/ath10k_core.ko
kernel/drivers/net/wireless/ath/ath10k/ath10k_pci.ko
kernel/drivers/net/wireless/ath/wcn36xx/wcn36xx.ko
kernel/drivers/net/wireless/mac80211_hwsim.ko
kernel/drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko
kernel/drivers/net/wireless/cw1200/cw1200_core.ko
kernel/drivers/net/wireless/cw1200/cw1200_wlan_sdio.ko
kernel/drivers/net/wireless/cw1200/cw1200_wlan_spi.ko
kernel/drivers/net/wireless/rsi/rsi_91x.ko
kernel/drivers/net/wireless/rsi/rsi_sdio.ko
kernel/drivers/net/wireless/rsi/rsi_usb.ko
kernel/drivers/staging/vt6655/vt6655_stage.ko
kernel/drivers/staging/vt6656/vt6656_stage.ko
kernel/net/mac80211/mac80211.ko



