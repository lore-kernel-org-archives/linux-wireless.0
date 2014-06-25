Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57104 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452AbaFYUPX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:15:23 -0400
Received: by mail-wi0-f178.google.com with SMTP id n15so3167455wiw.5
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:15:20 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 04/17] staging: vt6656: mac80211 conversion: main_usb add functions and change usb_driver functions
Date: Wed, 25 Jun 2014 21:14:25 +0100
Message-Id: <1403727278-6666-5-git-send-email-tvboxspy@gmail.com> (sfid-20140625_221650_479084_0213D6C1)
In-Reply-To: <1403727278-6666-1-git-send-email-tvboxspy@gmail.com>
References: <1403727278-6666-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Create new functions for the operations of mac80211
vnt_tx_80211
vnt_start
vnt_stop
vnt_add_interface
vnt_remove_interface
vnt_config
vnt_bss_info_changed
vnt_prepare_multicast
vnt_configure
vnt_set_key
vnt_sw_scan_start
vnt_sw_scan_complete
vnt_get_tsf
vnt_set_tsf
vnt_reset_tsf

Create vnt_init to call device_init_registers to get permanent mac address.
This will be linked to vt6656_probe via bScheduleCommand in another patch as
firmware needs to be loaded first.

Modify vt6656_probe, vt6656_disconnect for mac80211

Change vt6656_suspend and vt6656_resume, nothing needs to be done here
let mac80211 handle the suspend.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   |   3 +
 drivers/staging/vt6656/main_usb.c | 619 ++++++++++++++++++++++++++++++++------
 2 files changed, 522 insertions(+), 100 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 112e0b0..46d7704 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -396,6 +396,7 @@ typedef struct __device_opt {
 struct vnt_private {
 	/* mac80211 */
 	struct ieee80211_hw *hw;
+	struct ieee80211_vif *vif;
 	/* netdev */
 	struct usb_device *usb;
 	struct net_device *dev;
@@ -410,6 +411,7 @@ struct vnt_private {
 	u8 rx_rate;
 
 	u32 rx_buf_sz;
+	int mc_list_count;
 	int multicast_limit;
 	u8 byRxMode;
 
@@ -574,6 +576,7 @@ struct vnt_private {
 	int bRadioOff;
 
 	/* Power save */
+	u16 current_aid;
 	int bEnablePSMode;
 	u16 wListenInterval;
 	int bPWBitOn;
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index ebbb10d..6f66b86 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -572,36 +572,6 @@ static int device_init_registers(struct vnt_private *pDevice)
 	return true;
 }
 
-#ifdef CONFIG_PM	/* Minimal support for suspend and resume */
-
-static int vt6656_suspend(struct usb_interface *intf, pm_message_t message)
-{
-	struct vnt_private *device = usb_get_intfdata(intf);
-
-	if (!device || !device->dev)
-		return -ENODEV;
-
-	if (device->flags & DEVICE_FLAGS_OPENED)
-		device_close(device->dev);
-
-	return 0;
-}
-
-static int vt6656_resume(struct usb_interface *intf)
-{
-	struct vnt_private *device = usb_get_intfdata(intf);
-
-	if (!device || !device->dev)
-		return -ENODEV;
-
-	if (!(device->flags & DEVICE_FLAGS_OPENED))
-		device_open(device->dev);
-
-	return 0;
-}
-
-#endif /* CONFIG_PM */
-
 static const struct net_device_ops device_netdev_ops = {
     .ndo_open               = device_open,
     .ndo_stop               = device_close,
@@ -611,69 +581,6 @@ static const struct net_device_ops device_netdev_ops = {
     .ndo_set_rx_mode	    = device_set_multi,
 };
 
-static int
-vt6656_probe(struct usb_interface *intf, const struct usb_device_id *id)
-{
-	u8 fake_mac[ETH_ALEN] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x01};
-	struct usb_device *udev = interface_to_usbdev(intf);
-	int rc = 0;
-	struct net_device *netdev = NULL;
-	struct vnt_private *pDevice;
-
-	printk(KERN_NOTICE "%s Ver. %s\n", DEVICE_FULL_DRV_NAM, DEVICE_VERSION);
-	printk(KERN_NOTICE "Copyright (c) 2004 VIA Networking Technologies, Inc.\n");
-
-	udev = usb_get_dev(udev);
-	netdev = alloc_etherdev(sizeof(struct vnt_private));
-	if (!netdev) {
-		printk(KERN_ERR DEVICE_NAME ": allocate net device failed\n");
-		rc = -ENOMEM;
-		goto err_nomem;
-	}
-
-	pDevice = netdev_priv(netdev);
-	memset(pDevice, 0, sizeof(struct vnt_private));
-
-	pDevice->dev = netdev;
-	pDevice->usb = udev;
-
-	device_set_options(pDevice);
-	spin_lock_init(&pDevice->lock);
-	mutex_init(&pDevice->usb_lock);
-
-	INIT_DELAYED_WORK(&pDevice->run_command_work, vRunCommand);
-	INIT_DELAYED_WORK(&pDevice->second_callback_work, BSSvSecondCallBack);
-	INIT_WORK(&pDevice->read_work_item, RXvWorkItem);
-	INIT_WORK(&pDevice->rx_mng_work_item, RXvMngWorkItem);
-
-	pDevice->vnt_mgmt.pAdapter = (void *) pDevice;
-
-	netdev->netdev_ops = &device_netdev_ops;
-	netdev->wireless_handlers =
-		(struct iw_handler_def *) &iwctl_handler_def;
-
-	usb_set_intfdata(intf, pDevice);
-	SET_NETDEV_DEV(netdev, &intf->dev);
-	memcpy(pDevice->dev->dev_addr, fake_mac, ETH_ALEN);
-
-	usb_device_reset(pDevice);
-
-	rc = register_netdev(netdev);
-	if (rc) {
-		printk(KERN_ERR DEVICE_NAME " Failed to register netdev\n");
-		goto err_netdev;
-	}
-
-	return 0;
-
-err_netdev:
-	free_netdev(netdev);
-err_nomem:
-	usb_put_dev(udev);
-
-	return rc;
-}
-
 static void device_free_tx_bufs(struct vnt_private *priv)
 {
 	struct vnt_usb_send_context *tx_context;
@@ -1043,24 +950,536 @@ static int device_close(struct net_device *dev)
     return 0;
 }
 
+static void vnt_tx_80211(struct ieee80211_hw *hw,
+	struct ieee80211_tx_control *control, struct sk_buff *skb)
+{
+	struct vnt_private *priv = hw->priv;
+
+	ieee80211_stop_queues(hw);
+
+	if (vnt_tx_packet(priv, skb)) {
+		ieee80211_free_txskb(hw, skb);
+
+		ieee80211_wake_queues(hw);
+	}
+}
+
+static int vnt_start(struct ieee80211_hw *hw)
+{
+	struct vnt_private *priv = hw->priv;
+
+	priv->rx_buf_sz = MAX_TOTAL_SIZE_WITH_ALL_HEADERS;
+
+	if (device_alloc_bufs(priv) == false) {
+		dev_dbg(&priv->usb->dev, "device_alloc_bufs fail...\n");
+		return -ENOMEM;
+	}
+
+	MP_CLEAR_FLAG(priv, fMP_DISCONNECTED);
+	MP_SET_FLAG(priv, fMP_POST_READS);
+	MP_SET_FLAG(priv, fMP_POST_WRITES);
+
+	if (device_init_registers(priv) == false) {
+		dev_dbg(&priv->usb->dev, " init register fail\n");
+		goto free_all;
+	}
+
+	priv->int_interval = 1;  /* bInterval is set to 1 */
+
+	schedule_work(&priv->read_work_item);
+	INTvWorkItem(priv);
+
+	priv->flags |= DEVICE_FLAGS_OPENED;
+
+	ieee80211_wake_queues(hw);
+
+	return 0;
+
+free_all:
+	device_free_rx_bufs(priv);
+	device_free_tx_bufs(priv);
+	device_free_int_bufs(priv);
+
+	usb_kill_urb(priv->pInterruptURB);
+	usb_free_urb(priv->pInterruptURB);
+
+	return -ENOMEM;
+}
+
+static void vnt_stop(struct ieee80211_hw *hw)
+{
+	struct vnt_private *priv = hw->priv;
+	int i;
+
+	if (!priv)
+		return;
+
+	for (i = 0; i < MAX_KEY_TABLE; i++)
+		vnt_mac_disable_keyentry(priv, i);
+
+	/* clear all keys */
+	priv->key_entry_inuse = 0;
+
+	if ((priv->flags & DEVICE_FLAGS_UNPLUG) == false)
+		vnt_mac_shutdown(priv);
+
+	ieee80211_stop_queues(hw);
+
+	MP_SET_FLAG(priv, fMP_DISCONNECTED);
+	MP_CLEAR_FLAG(priv, fMP_POST_WRITES);
+	MP_CLEAR_FLAG(priv, fMP_POST_READS);
+
+	cancel_delayed_work_sync(&priv->run_command_work);
+	cancel_work_sync(&priv->read_work_item);
+
+	priv->bCmdRunning = false;
+
+	priv->flags &= ~DEVICE_FLAGS_OPENED;
+
+	device_free_tx_bufs(priv);
+	device_free_rx_bufs(priv);
+	device_free_int_bufs(priv);
+
+	usb_kill_urb(priv->pInterruptURB);
+	usb_free_urb(priv->pInterruptURB);
+
+	return;
+}
+
+static int vnt_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
+{
+	struct vnt_private *priv = hw->priv;
+
+	priv->vif = vif;
+
+	switch (vif->type) {
+	case NL80211_IFTYPE_STATION:
+		break;
+	case NL80211_IFTYPE_ADHOC:
+		vnt_mac_reg_bits_off(priv, MAC_REG_RCR, RCR_UNICAST);
+
+		vnt_mac_reg_bits_on(priv, MAC_REG_HOSTCR, HOSTCR_ADHOC);
+
+		break;
+	case NL80211_IFTYPE_AP:
+		vnt_mac_reg_bits_off(priv, MAC_REG_RCR, RCR_UNICAST);
+
+		vnt_mac_reg_bits_on(priv, MAC_REG_HOSTCR, HOSTCR_AP);
+
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	priv->op_mode = vif->type;
+
+	/* LED blink on TX */
+	vnt_mac_set_led(priv, LEDSTS_STS, LEDSTS_INTER);
+
+	return 0;
+}
+
+static void vnt_remove_interface(struct ieee80211_hw *hw,
+		struct ieee80211_vif *vif)
+{
+	struct vnt_private *priv = hw->priv;
+
+	switch (vif->type) {
+	case NL80211_IFTYPE_STATION:
+		break;
+	case NL80211_IFTYPE_ADHOC:
+		vnt_mac_reg_bits_off(priv, MAC_REG_TCR, TCR_AUTOBCNTX);
+		vnt_mac_reg_bits_off(priv, MAC_REG_TFTCTL, TFTCTL_TSFCNTREN);
+		vnt_mac_reg_bits_off(priv, MAC_REG_HOSTCR, HOSTCR_ADHOC);
+		break;
+	case NL80211_IFTYPE_AP:
+		vnt_mac_reg_bits_off(priv, MAC_REG_TCR, TCR_AUTOBCNTX);
+		vnt_mac_reg_bits_off(priv, MAC_REG_TFTCTL, TFTCTL_TSFCNTREN);
+		vnt_mac_reg_bits_off(priv, MAC_REG_HOSTCR, HOSTCR_AP);
+		break;
+	default:
+		break;
+	}
+
+	vnt_radio_power_off(priv);
+
+	priv->op_mode = NL80211_IFTYPE_UNSPECIFIED;
+
+	/* LED slow blink */
+	vnt_mac_set_led(priv, LEDSTS_STS, LEDSTS_SLOW);
+
+	return;
+}
+
+static int vnt_config(struct ieee80211_hw *hw, u32 changed)
+{
+	struct vnt_private *priv = hw->priv;
+	struct ieee80211_conf *conf = &hw->conf;
+	u8 bb_type;
+
+	if (changed & IEEE80211_CONF_CHANGE_PS) {
+		if (conf->flags & IEEE80211_CONF_PS)
+			vnt_enable_power_saving(priv, conf->listen_interval);
+		else
+			vnt_disable_power_saving(priv);
+	}
+
+	if ((changed & IEEE80211_CONF_CHANGE_CHANNEL) ||
+			(conf->flags & IEEE80211_CONF_OFFCHANNEL)) {
+		vnt_set_channel(priv, conf->chandef.chan->hw_value);
+
+		if (conf->chandef.chan->band == IEEE80211_BAND_5GHZ)
+			bb_type = BB_TYPE_11A;
+		else
+			bb_type = BB_TYPE_11G;
+
+		if (priv->byBBType != bb_type) {
+			priv->byBBType = bb_type;
+
+			vnt_set_bss_mode(priv);
+		}
+	}
+
+	if (changed & IEEE80211_CONF_CHANGE_POWER) {
+		if (priv->byBBType == BB_TYPE_11B)
+			priv->wCurrentRate = RATE_1M;
+		else
+			priv->wCurrentRate = RATE_54M;
+
+		vnt_rf_setpower(priv, priv->wCurrentRate,
+				conf->chandef.chan->hw_value);
+	}
+
+	return 0;
+}
+
+static void vnt_bss_info_changed(struct ieee80211_hw *hw,
+		struct ieee80211_vif *vif, struct ieee80211_bss_conf *conf,
+		u32 changed)
+{
+	struct vnt_private *priv = hw->priv;
+	priv->current_aid = conf->aid;
+
+	if (changed & BSS_CHANGED_BSSID)
+		vnt_mac_set_bssid_addr(priv, (u8 *)conf->bssid);
+
+
+	if (changed & BSS_CHANGED_BASIC_RATES) {
+		priv->wBasicRate = conf->basic_rates;
+
+		vnt_update_top_rates(priv);
+
+		dev_dbg(&priv->usb->dev, "basic rates %x\n", conf->basic_rates);
+	}
+
+	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
+		if (conf->use_short_preamble) {
+			vnt_mac_enable_barker_preamble_mode(priv);
+			priv->byPreambleType = true;
+		} else {
+			vnt_mac_disable_barker_preamble_mode(priv);
+			priv->byPreambleType = false;
+		}
+	}
+
+	if (changed & BSS_CHANGED_ERP_CTS_PROT) {
+		if (conf->use_cts_prot)
+			vnt_mac_enable_protect_mode(priv);
+		else
+			vnt_mac_disable_protect_mode(priv);
+	}
+
+	if (changed & BSS_CHANGED_ERP_SLOT) {
+		if (conf->use_short_slot)
+			priv->bShortSlotTime = true;
+		else
+			priv->bShortSlotTime = false;
+
+		BBvSetShortSlotTime(priv);
+		BBvSetVGAGainOffset(priv, priv->abyBBVGA[0]);
+		BBvUpdatePreEDThreshold(priv, false);
+	}
+
+	if (changed & BSS_CHANGED_TXPOWER)
+		vnt_rf_setpower(priv, priv->wCurrentRate,
+					conf->chandef.chan->hw_value);
+
+	if (changed & BSS_CHANGED_BEACON_ENABLED) {
+		dev_dbg(&priv->usb->dev,
+				"Beacon enable %d\n", conf->enable_beacon);
+
+		if (conf->enable_beacon) {
+			vnt_beacon_enable(priv, vif, conf);
+
+			vnt_mac_reg_bits_on(priv, MAC_REG_TCR, TCR_AUTOBCNTX);
+		} else {
+			vnt_mac_reg_bits_off(priv, MAC_REG_TCR, TCR_AUTOBCNTX);
+		}
+	}
+}
+
+static u64 vnt_prepare_multicast(struct ieee80211_hw *hw,
+	struct netdev_hw_addr_list *mc_list)
+{
+	struct vnt_private *priv = hw->priv;
+	struct netdev_hw_addr *ha;
+	u64 mc_filter = 0;
+	u32 bit_nr = 0;
+
+	netdev_hw_addr_list_for_each(ha, mc_list) {
+		bit_nr = ether_crc(ETH_ALEN, ha->addr) >> 26;
+
+		mc_filter |= 1ULL << (bit_nr & 0x3f);
+	}
+
+	priv->mc_list_count = mc_list->count;
+
+	return mc_filter;
+}
+
+static void vnt_configure(struct ieee80211_hw *hw,
+	unsigned int changed_flags, unsigned int *total_flags, u64 multicast)
+{
+	struct vnt_private *priv = hw->priv;
+	u8 rx_mode = 0;
+	int rc;
+
+	*total_flags &= FIF_ALLMULTI | FIF_OTHER_BSS | FIF_PROMISC_IN_BSS |
+		FIF_BCN_PRBRESP_PROMISC;
+
+	rc = vnt_control_in(priv, MESSAGE_TYPE_READ, MAC_REG_RCR,
+		MESSAGE_REQUEST_MACREG, sizeof(u8), &rx_mode);
+
+	if (!rc)
+		rx_mode = RCR_MULTICAST | RCR_BROADCAST;
+
+	dev_dbg(&priv->usb->dev, "rx mode in = %x\n", rx_mode);
+
+	if (changed_flags & FIF_PROMISC_IN_BSS) {
+		/* unconditionally log net taps */
+		if (*total_flags & FIF_PROMISC_IN_BSS)
+			rx_mode |= RCR_UNICAST;
+		else
+			rx_mode &= ~RCR_UNICAST;
+	}
+
+	if (changed_flags & FIF_ALLMULTI) {
+		if (*total_flags & FIF_ALLMULTI) {
+			if (priv->mc_list_count > 2)
+				vnt_mac_set_filter(priv, ~0);
+			else
+				vnt_mac_set_filter(priv, multicast);
+
+			rx_mode |= RCR_MULTICAST | RCR_BROADCAST;
+		} else {
+			rx_mode &= ~(RCR_MULTICAST | RCR_BROADCAST);
+		}
+
+	}
+
+	if (changed_flags & (FIF_OTHER_BSS | FIF_BCN_PRBRESP_PROMISC)) {
+		if (*total_flags & (FIF_OTHER_BSS | FIF_BCN_PRBRESP_PROMISC))
+			rx_mode &= ~RCR_BSSID;
+		else
+			rx_mode |= RCR_BSSID;
+	}
+
+	vnt_control_out_u8(priv, MESSAGE_REQUEST_MACREG, MAC_REG_RCR, rx_mode);
+
+	dev_dbg(&priv->usb->dev, "rx mode out= %x\n", rx_mode);
+
+	return;
+}
+
+static int vnt_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
+	struct ieee80211_vif *vif, struct ieee80211_sta *sta,
+		struct ieee80211_key_conf *key)
+{
+	struct vnt_private *priv = hw->priv;
+
+	switch (cmd) {
+	case SET_KEY:
+		if (vnt_set_keys(hw, sta, vif, key))
+			return -EOPNOTSUPP;
+		break;
+	case DISABLE_KEY:
+		if (test_bit(key->hw_key_idx, &priv->key_entry_inuse))
+			clear_bit(key->hw_key_idx, &priv->key_entry_inuse);
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static void vnt_sw_scan_start(struct ieee80211_hw *hw)
+{
+	struct vnt_private *priv = hw->priv;
+
+	/* Set max sensitivity*/
+	BBvUpdatePreEDThreshold(priv, true);
+}
+
+static void vnt_sw_scan_complete(struct ieee80211_hw *hw)
+{
+	struct vnt_private *priv = hw->priv;
+
+	/* Return sensitivity to channel level*/
+	BBvUpdatePreEDThreshold(priv, false);
+}
+
+static u64 vnt_get_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
+{
+	struct vnt_private *priv = hw->priv;
+
+	return priv->qwCurrTSF;
+}
+
+static void vnt_set_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			u64 tsf)
+{
+	struct vnt_private *priv = hw->priv;
+
+	vnt_update_next_tbtt(priv, tsf, vif->bss_conf.beacon_int);
+}
+
+static void vnt_reset_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
+{
+	struct vnt_private *priv = hw->priv;
+
+	vnt_mac_reg_bits_off(priv, MAC_REG_TFTCTL, TFTCTL_TSFCNTREN);
+
+	vnt_clear_current_tsf(priv);
+}
+
+static const struct ieee80211_ops vnt_mac_ops = {
+	.tx			= vnt_tx_80211,
+	.start			= vnt_start,
+	.stop			= vnt_stop,
+	.add_interface		= vnt_add_interface,
+	.remove_interface	= vnt_remove_interface,
+	.config			= vnt_config,
+	.bss_info_changed	= vnt_bss_info_changed,
+	.prepare_multicast	= vnt_prepare_multicast,
+	.configure_filter	= vnt_configure,
+	.set_key		= vnt_set_key,
+	.sw_scan_start		= vnt_sw_scan_start,
+	.sw_scan_complete	= vnt_sw_scan_complete,
+	.get_tsf		= vnt_get_tsf,
+	.set_tsf		= vnt_set_tsf,
+	.reset_tsf		= vnt_reset_tsf,
+};
+
+int vnt_init(struct vnt_private *priv)
+{
+
+	if (!(device_init_registers(priv)))
+		return -EAGAIN;
+
+	SET_IEEE80211_PERM_ADDR(priv->hw, priv->abyPermanentNetAddr);
+
+	if (ieee80211_register_hw(priv->hw))
+		return -ENODEV;
+
+	return 0;
+}
+
+static int
+vt6656_probe(struct usb_interface *intf, const struct usb_device_id *id)
+{
+	struct usb_device *udev;
+	struct vnt_private *priv;
+	struct ieee80211_hw *hw;
+	struct wiphy *wiphy;
+	int rc = 0;
+
+	udev = usb_get_dev(interface_to_usbdev(intf));
+
+	dev_notice(&udev->dev, "%s Ver. %s\n",
+					DEVICE_FULL_DRV_NAM, DEVICE_VERSION);
+	dev_notice(&udev->dev,
+		"Copyright (c) 2004 VIA Networking Technologies, Inc.\n");
+
+	hw = ieee80211_alloc_hw(sizeof(struct vnt_private), &vnt_mac_ops);
+	if (!hw) {
+		dev_err(&udev->dev, "could not register ieee80211_hw\n");
+		goto err_nomem;
+	}
+
+	priv = hw->priv;
+	priv->hw = hw;
+	priv->usb = udev;
+
+	device_set_options(priv);
+
+	spin_lock_init(&priv->lock);
+	mutex_init(&priv->usb_lock);
+
+	INIT_DELAYED_WORK(&priv->run_command_work, vRunCommand);
+	INIT_WORK(&priv->read_work_item, RXvWorkItem);
+
+	priv->vnt_mgmt.pAdapter = priv;
+
+	usb_set_intfdata(intf, priv);
+
+	wiphy = priv->hw->wiphy;
+
+	wiphy->frag_threshold = FRAG_THRESH_DEF;
+	wiphy->rts_threshold = RTS_THRESH_DEF;
+	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
+		BIT(NL80211_IFTYPE_ADHOC) | BIT(NL80211_IFTYPE_AP);
+
+	priv->hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
+		IEEE80211_HW_REPORTS_TX_ACK_STATUS |
+		IEEE80211_HW_SIGNAL_DBM |
+		IEEE80211_HW_TIMING_BEACON_ONLY;
+
+	priv->hw->rate_control_algorithm = "pid";
+	priv->hw->max_signal = 100;
+
+	SET_IEEE80211_DEV(priv->hw, &intf->dev);
+
+	usb_device_reset(priv);
+
+	return 0;
+
+err_nomem:
+	usb_put_dev(udev);
+
+	return rc;
+}
+
 static void vt6656_disconnect(struct usb_interface *intf)
 {
-	struct vnt_private *device = usb_get_intfdata(intf);
+	struct vnt_private *priv = usb_get_intfdata(intf);
 
-	if (!device)
+	if (!priv)
 		return;
 
+	ieee80211_unregister_hw(priv->hw);
+
 	usb_set_intfdata(intf, NULL);
 	usb_put_dev(interface_to_usbdev(intf));
 
-	device->flags |= DEVICE_FLAGS_UNPLUG;
+	priv->flags |= DEVICE_FLAGS_UNPLUG;
 
-	if (device->dev) {
-		unregister_netdev(device->dev);
-		free_netdev(device->dev);
-	}
+	ieee80211_free_hw(priv->hw);
+}
+
+#ifdef CONFIG_PM
+
+static int vt6656_suspend(struct usb_interface *intf, pm_message_t message)
+{
+	return 0;
 }
 
+static int vt6656_resume(struct usb_interface *intf)
+{
+	return 0;
+}
+
+#endif /* CONFIG_PM */
+
 static int device_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct vnt_private *pDevice = netdev_priv(dev);
-- 
1.9.1

