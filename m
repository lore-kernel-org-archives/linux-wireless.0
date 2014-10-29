Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:65137 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251AbaJ2RpB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:45:01 -0400
Received: by mail-wi0-f170.google.com with SMTP id q5so2193860wiv.3
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:45:00 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 08/34] staging: vt6655: mac80211 conversion add main mac80211 functions
Date: Wed, 29 Oct 2014 17:43:43 +0000
Message-Id: <1414604649-9105-9-git-send-email-tvboxspy@gmail.com> (sfid-20141029_184509_594577_992D6EDC)
In-Reply-To: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
References: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace existing vt6655_probe with one converted to mac80211
with the following operations

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
vnt_get_tsf
vnt_set_tsf
vnt_reset_tsf

The following variables are also added.
basic_rates
mc_list_count
mac_hw

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h      |   3 +
 drivers/staging/vt6655/device_main.c | 754 ++++++++++++++++++++++++++++-------
 2 files changed, 621 insertions(+), 136 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 7d521c6..17a36dc 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -324,7 +324,10 @@ struct vnt_private {
 	struct ieee80211_hw *hw;
 	struct ieee80211_vif *vif;
 	unsigned long key_entry_inuse;
+	u32 basic_rates;
 	u16 current_aid;
+	int mc_list_count;
+	u8 mac_hw;
 /* netdev */
 	struct net_device *dev;
 
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index c8ee91c..23d9344 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -809,142 +809,6 @@ static const struct net_device_ops device_netdev_ops = {
 	.ndo_set_rx_mode	= device_set_multi,
 };
 
-static int
-vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
-{
-	static bool bFirst = true;
-	struct net_device *dev = NULL;
-	PCHIP_INFO  pChip_info = (PCHIP_INFO)ent->driver_data;
-	struct vnt_private *pDevice;
-	int         rc;
-
-	dev = alloc_etherdev(sizeof(*pDevice));
-
-	pDevice = netdev_priv(dev);
-
-	if (dev == NULL) {
-		pr_err(DEVICE_NAME ": allocate net device failed\n");
-		return -ENOMEM;
-	}
-
-	// Chain it all together
-	SET_NETDEV_DEV(dev, &pcid->dev);
-
-	if (bFirst) {
-		pr_notice("%s Ver. %s\n", DEVICE_FULL_DRV_NAM, DEVICE_VERSION);
-		pr_notice("Copyright (c) 2003 VIA Networking Technologies, Inc.\n");
-		bFirst = false;
-	}
-
-	vt6655_init_info(pcid, &pDevice, pChip_info);
-	pDevice->dev = dev;
-
-	if (pci_enable_device(pcid)) {
-		device_free_info(pDevice);
-		return -ENODEV;
-	}
-	dev->irq = pcid->irq;
-
-#ifdef	DEBUG
-	pr_debug("Before get pci_info memaddr is %x\n", pDevice->memaddr);
-#endif
-	if (!device_get_pci_info(pDevice, pcid)) {
-		pr_err(DEVICE_NAME ": Failed to find PCI device.\n");
-		device_free_info(pDevice);
-		return -ENODEV;
-	}
-
-#ifdef	DEBUG
-
-	pr_debug("after get pci_info memaddr is %x, io addr is %x,io_size is %d\n", pDevice->memaddr, pDevice->ioaddr, pDevice->io_size);
-	{
-		int i;
-		u32 bar, len;
-		u32 address[] = {
-			PCI_BASE_ADDRESS_0,
-			PCI_BASE_ADDRESS_1,
-			PCI_BASE_ADDRESS_2,
-			PCI_BASE_ADDRESS_3,
-			PCI_BASE_ADDRESS_4,
-			PCI_BASE_ADDRESS_5,
-			0};
-		for (i = 0; address[i]; i++) {
-			pci_read_config_dword(pcid, address[i], &bar);
-			pr_debug("bar %d is %x\n", i, bar);
-			if (!bar) {
-				pr_debug("bar %d not implemented\n", i);
-				continue;
-			}
-			if (bar & PCI_BASE_ADDRESS_SPACE_IO) {
-				/* This is IO */
-
-				len = bar & (PCI_BASE_ADDRESS_IO_MASK & 0xFFFF);
-				len = len & ~(len - 1);
-
-				pr_debug("IO space:  len in IO %x, BAR %d\n", len, i);
-			} else {
-				len = bar & 0xFFFFFFF0;
-				len = ~len + 1;
-
-				pr_debug("len in MEM %x, BAR %d\n", len, i);
-			}
-		}
-	}
-#endif
-
-	pDevice->PortOffset = ioremap(pDevice->memaddr & PCI_BASE_ADDRESS_MEM_MASK, pDevice->io_size);
-
-	if (pDevice->PortOffset == NULL) {
-		pr_err(DEVICE_NAME ": Failed to IO remapping ..\n");
-		device_free_info(pDevice);
-		return -ENODEV;
-	}
-
-	rc = pci_request_regions(pcid, DEVICE_NAME);
-	if (rc) {
-		pr_err(DEVICE_NAME ": Failed to find PCI device\n");
-		device_free_info(pDevice);
-		return -ENODEV;
-	}
-
-	dev->base_addr = pDevice->ioaddr;
-	// do reset
-	if (!MACbSoftwareReset(pDevice->PortOffset)) {
-		pr_err(DEVICE_NAME ": Failed to access MAC hardware..\n");
-		device_free_info(pDevice);
-		return -ENODEV;
-	}
-	// initial to reload eeprom
-	MACvInitialize(pDevice->PortOffset);
-	MACvReadEtherAddress(pDevice->PortOffset, dev->dev_addr);
-
-	device_get_options(pDevice);
-	device_set_options(pDevice);
-	//Mask out the options cannot be set to the chip
-	pDevice->sOpts.flags &= pChip_info->flags;
-
-	//Enable the chip specified capabilities
-	pDevice->flags = pDevice->sOpts.flags | (pChip_info->flags & 0xFF000000UL);
-	pDevice->tx_80211 = device_dma0_tx_80211;
-	pDevice->sMgmtObj.pAdapter = (void *)pDevice;
-	pDevice->pMgmt = &(pDevice->sMgmtObj);
-
-	dev->irq                = pcid->irq;
-	dev->netdev_ops         = &device_netdev_ops;
-
-	dev->wireless_handlers = (struct iw_handler_def *)&iwctl_handler_def;
-
-	rc = register_netdev(dev);
-	if (rc) {
-		pr_err(DEVICE_NAME " Failed to register netdev\n");
-		device_free_info(pDevice);
-		return -ENODEV;
-	}
-	device_print_info(pDevice);
-	pci_set_drvdata(pcid, pDevice);
-	return 0;
-}
-
 static void device_print_info(struct vnt_private *pDevice)
 {
 	struct net_device *dev = pDevice->dev;
@@ -2996,6 +2860,624 @@ static int ethtool_ioctl(struct net_device *dev, void __user *useraddr)
 	return -EOPNOTSUPP;
 }
 
+static int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	PSTxDesc head_td;
+	u32 dma_idx = TYPE_AC0DMA;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	if (!ieee80211_is_data(hdr->frame_control))
+		dma_idx = TYPE_TXDMA0;
+
+	if (AVAIL_TD(priv, dma_idx) < 1) {
+		spin_unlock_irqrestore(&priv->lock, flags);
+		return -ENOMEM;
+	}
+
+	head_td = priv->apCurrTD[dma_idx];
+
+	head_td->m_td1TD1.byTCR = (TCR_EDP|TCR_STP);
+
+	head_td->pTDInfo->skb = skb;
+
+	priv->iTDUsed[dma_idx]++;
+
+	/* Take ownership */
+	wmb();
+	head_td->m_td0TD0.f1Owner = OWNED_BY_NIC;
+
+	/* get Next */
+	wmb();
+	priv->apCurrTD[dma_idx] = head_td->next;
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	vnt_generate_fifo_header(priv, dma_idx, head_td, skb);
+
+	if (MACbIsRegBitsOn(priv->PortOffset, MAC_REG_PSCTL, PSCTL_PS))
+		MACbPSWakeup(priv->PortOffset);
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	priv->bPWBitOn = false;
+
+	head_td->pTDInfo->byFlags = TD_FLAGS_NETIF_SKB;
+
+	if (dma_idx == TYPE_AC0DMA)
+		MACvTransmitAC0(priv->PortOffset);
+	else
+		MACvTransmit0(priv->PortOffset);
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	return 0;
+}
+
+static void vnt_tx_80211(struct ieee80211_hw *hw,
+			 struct ieee80211_tx_control *control,
+			 struct sk_buff *skb)
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
+	int ret;
+
+	priv->rx_buf_sz = PKT_BUF_SZ;
+	if (!device_init_rings(priv))
+		return -ENOMEM;
+
+	ret = request_irq(priv->pcid->irq, &device_intr,
+			  IRQF_SHARED, "vt6655", priv);
+	if (ret) {
+		dev_dbg(&priv->pcid->dev, "failed to start irq\n");
+		return ret;
+	}
+
+	dev_dbg(&priv->pcid->dev, "call device init rd0 ring\n");
+	device_init_rd0_ring(priv);
+	device_init_rd1_ring(priv);
+	device_init_defrag_cb(priv);
+	device_init_td0_ring(priv);
+	device_init_td1_ring(priv);
+
+	device_init_registers(priv);
+
+	dev_dbg(&priv->pcid->dev, "call MACvIntEnable\n");
+	MACvIntEnable(priv->PortOffset, IMR_MASK_VALUE);
+
+	ieee80211_wake_queues(hw);
+
+	return 0;
+}
+
+static void vnt_stop(struct ieee80211_hw *hw)
+{
+	struct vnt_private *priv = hw->priv;
+
+	ieee80211_stop_queues(hw);
+
+	MACbShutdown(priv->PortOffset);
+	MACbSoftwareReset(priv->PortOffset);
+	CARDbRadioPowerOff(priv);
+
+	device_free_td0_ring(priv);
+	device_free_td1_ring(priv);
+	device_free_rd0_ring(priv);
+	device_free_rd1_ring(priv);
+	device_free_frag_buf(priv);
+	device_free_rings(priv);
+
+	free_irq(priv->pcid->irq, priv);
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
+		if (priv->bDiversityRegCtlON)
+			device_init_diversity_timer(priv);
+		break;
+	case NL80211_IFTYPE_ADHOC:
+		MACvRegBitsOff(priv->PortOffset, MAC_REG_RCR, RCR_UNICAST);
+
+		MACvRegBitsOn(priv->PortOffset, MAC_REG_HOSTCR, HOSTCR_ADHOC);
+
+		break;
+	case NL80211_IFTYPE_AP:
+		MACvRegBitsOff(priv->PortOffset, MAC_REG_RCR, RCR_UNICAST);
+
+		MACvRegBitsOn(priv->PortOffset, MAC_REG_HOSTCR, HOSTCR_AP);
+
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	priv->op_mode = vif->type;
+
+	return 0;
+}
+
+static void vnt_remove_interface(struct ieee80211_hw *hw,
+				 struct ieee80211_vif *vif)
+{
+	struct vnt_private *priv = hw->priv;
+
+	switch (vif->type) {
+	case NL80211_IFTYPE_STATION:
+		if (priv->bDiversityRegCtlON) {
+			del_timer(&priv->TimerSQ3Tmax1);
+			del_timer(&priv->TimerSQ3Tmax2);
+			del_timer(&priv->TimerSQ3Tmax3);
+		}
+		break;
+	case NL80211_IFTYPE_ADHOC:
+		MACvRegBitsOff(priv->PortOffset, MAC_REG_TCR, TCR_AUTOBCNTX);
+		MACvRegBitsOff(priv->PortOffset,
+			       MAC_REG_TFTCTL, TFTCTL_TSFCNTREN);
+		MACvRegBitsOff(priv->PortOffset, MAC_REG_HOSTCR, HOSTCR_ADHOC);
+		break;
+	case NL80211_IFTYPE_AP:
+		MACvRegBitsOff(priv->PortOffset, MAC_REG_TCR, TCR_AUTOBCNTX);
+		MACvRegBitsOff(priv->PortOffset,
+			       MAC_REG_TFTCTL, TFTCTL_TSFCNTREN);
+		MACvRegBitsOff(priv->PortOffset, MAC_REG_HOSTCR, HOSTCR_AP);
+		break;
+	default:
+		break;
+	}
+
+	priv->op_mode = NL80211_IFTYPE_UNSPECIFIED;
+}
+
+
+static int vnt_config(struct ieee80211_hw *hw, u32 changed)
+{
+	struct vnt_private *priv = hw->priv;
+	struct ieee80211_conf *conf = &hw->conf;
+	u8 bb_type;
+
+	if (changed & IEEE80211_CONF_CHANGE_PS) {
+		if (conf->flags & IEEE80211_CONF_PS)
+			PSvEnablePowerSaving(priv, conf->listen_interval);
+		else
+			PSvDisablePowerSaving(priv);
+	}
+
+	if ((changed & IEEE80211_CONF_CHANGE_CHANNEL) ||
+	    (conf->flags & IEEE80211_CONF_OFFCHANNEL)) {
+		set_channel(priv, conf->chandef.chan->hw_value);
+
+		if (conf->chandef.chan->band == IEEE80211_BAND_5GHZ)
+			bb_type = BB_TYPE_11A;
+		else
+			bb_type = BB_TYPE_11G;
+
+		if (priv->byBBType != bb_type) {
+			priv->byBBType = bb_type;
+
+			CARDbSetPhyParameter(priv,
+					     priv->byBBType, 0, 0, NULL, NULL);
+		}
+	}
+
+	if (changed & IEEE80211_CONF_CHANGE_POWER) {
+		if (priv->byBBType == BB_TYPE_11B)
+			priv->wCurrentRate = RATE_1M;
+		else
+			priv->wCurrentRate = RATE_54M;
+
+		RFbSetPower(priv, priv->wCurrentRate,
+			    conf->chandef.chan->hw_value);
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
+
+	priv->current_aid = conf->aid;
+
+	if (changed & BSS_CHANGED_BSSID)
+		MACvWriteBSSIDAddress(priv->PortOffset, (u8 *)conf->bssid);
+
+	if (changed & BSS_CHANGED_BASIC_RATES) {
+		priv->basic_rates = conf->basic_rates;
+
+		CARDvUpdateBasicTopRate(priv);
+
+		dev_dbg(&priv->pcid->dev,
+			"basic rates %x\n", conf->basic_rates);
+	}
+
+	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
+		if (conf->use_short_preamble) {
+			MACvEnableBarkerPreambleMd(priv->PortOffset);
+			priv->byPreambleType = true;
+		} else {
+			MACvDisableBarkerPreambleMd(priv->PortOffset);
+			priv->byPreambleType = false;
+		}
+	}
+
+	if (changed & BSS_CHANGED_ERP_CTS_PROT) {
+		if (conf->use_cts_prot)
+			MACvEnableProtectMD(priv->PortOffset);
+		else
+			MACvDisableProtectMD(priv->PortOffset);
+	}
+
+	if (changed & BSS_CHANGED_ERP_SLOT) {
+		if (conf->use_short_slot)
+			priv->bShortSlotTime = true;
+		else
+			priv->bShortSlotTime = false;
+
+		vUpdateIFS(priv);
+		CARDbSetPhyParameter(priv, priv->byBBType, 0, 0, NULL, NULL);
+		BBvSetVGAGainOffset(priv, priv->abyBBVGA[0]);
+	}
+
+	if (changed & BSS_CHANGED_TXPOWER)
+		RFbSetPower(priv, priv->wCurrentRate,
+			    conf->chandef.chan->hw_value);
+
+	if (changed & BSS_CHANGED_BEACON_ENABLED) {
+		dev_dbg(&priv->pcid->dev,
+			"Beacon enable %d\n", conf->enable_beacon);
+
+		if (conf->enable_beacon) {
+			vnt_beacon_enable(priv, vif, conf);
+
+			MACvRegBitsOn(priv, MAC_REG_TCR, TCR_AUTOBCNTX);
+		} else {
+			MACvRegBitsOff(priv, MAC_REG_TCR, TCR_AUTOBCNTX);
+		}
+	}
+
+	if (changed & BSS_CHANGED_ASSOC && priv->op_mode != NL80211_IFTYPE_AP) {
+		if (conf->assoc) {
+			CARDbUpdateTSF(priv, conf->beacon_rate->hw_value,
+				       conf->sync_device_ts, conf->sync_tsf);
+
+			CARDbSetBeaconPeriod(priv, conf->beacon_int);
+
+			CARDvSetFirstNextTBTT(priv->PortOffset,
+					      conf->beacon_int);
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
+
+	*total_flags &= FIF_ALLMULTI | FIF_OTHER_BSS | FIF_PROMISC_IN_BSS |
+		FIF_BCN_PRBRESP_PROMISC;
+
+	VNSvInPortB(priv->PortOffset + MAC_REG_RCR, &rx_mode);
+
+	dev_dbg(&priv->pcid->dev, "rx mode in = %x\n", rx_mode);
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
+			if (priv->mc_list_count > 2) {
+				MACvSelectPage1(priv->PortOffset);
+
+				VNSvOutPortD(priv->PortOffset +
+					     MAC_REG_MAR0, 0xffffffff);
+				VNSvOutPortD(priv->PortOffset +
+					    MAC_REG_MAR0 + 4, 0xffffffff);
+
+				MACvSelectPage0(priv->PortOffset);
+			} else {
+				MACvSelectPage1(priv->PortOffset);
+
+				VNSvOutPortD(priv->PortOffset +
+					     MAC_REG_MAR0, (u32)multicast);
+				VNSvOutPortD(priv->PortOffset +
+					     MAC_REG_MAR0 + 4,
+					     (u32)(multicast >> 32));
+
+				MACvSelectPage0(priv->PortOffset);
+			}
+
+			rx_mode |= RCR_MULTICAST | RCR_BROADCAST;
+		} else {
+			rx_mode &= ~(RCR_MULTICAST | RCR_BROADCAST);
+		}
+	}
+
+	if (changed_flags & (FIF_OTHER_BSS | FIF_BCN_PRBRESP_PROMISC)) {
+		rx_mode |= RCR_MULTICAST | RCR_BROADCAST;
+
+		if (*total_flags & (FIF_OTHER_BSS | FIF_BCN_PRBRESP_PROMISC))
+			rx_mode &= ~RCR_BSSID;
+		else
+			rx_mode |= RCR_BSSID;
+	}
+
+	VNSvOutPortB(priv->PortOffset + MAC_REG_RCR, rx_mode);
+
+	dev_dbg(&priv->pcid->dev, "rx mode out= %x\n", rx_mode);
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
+static u64 vnt_get_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
+{
+	struct vnt_private *priv = hw->priv;
+	u64 tsf;
+
+	CARDbGetCurrentTSF(priv->PortOffset, &tsf);
+
+	return tsf;
+}
+
+static void vnt_set_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			u64 tsf)
+{
+	struct vnt_private *priv = hw->priv;
+
+	CARDvUpdateNextTBTT(priv->PortOffset, tsf, vif->bss_conf.beacon_int);
+}
+
+static void vnt_reset_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
+{
+	struct vnt_private *priv = hw->priv;
+
+	/* reset TSF counter */
+	VNSvOutPortB(priv->PortOffset + MAC_REG_TFTCTL, TFTCTL_TSFCNTRST);
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
+	.get_tsf		= vnt_get_tsf,
+	.set_tsf		= vnt_set_tsf,
+	.reset_tsf		= vnt_reset_tsf,
+};
+
+int vnt_init(struct vnt_private *priv)
+{
+	SET_IEEE80211_PERM_ADDR(priv->hw, priv->abyCurrentNetAddr);
+
+	if (ieee80211_register_hw(priv->hw))
+		return -ENODEV;
+
+	priv->mac_hw = true;
+
+	CARDbRadioPowerOff(priv);
+
+	return 0;
+}
+
+static int
+vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
+{
+	PCHIP_INFO  pChip_info = (PCHIP_INFO)ent->driver_data;
+	struct vnt_private *priv;
+	struct ieee80211_hw *hw;
+	struct wiphy *wiphy;
+	int         rc;
+
+	dev_notice(&pcid->dev,
+		   "%s Ver. %s\n", DEVICE_FULL_DRV_NAM, DEVICE_VERSION);
+
+	dev_notice(&pcid->dev,
+		   "Copyright (c) 2003 VIA Networking Technologies, Inc.\n");
+
+	hw = ieee80211_alloc_hw(sizeof(*priv), &vnt_mac_ops);
+	if (!hw) {
+		dev_err(&pcid->dev, "could not register ieee80211_hw\n");
+		return -ENOMEM;
+	}
+
+	priv = hw->priv;
+
+	vt6655_init_info(pcid, &priv, pChip_info);
+
+	priv->hw = hw;
+
+	SET_IEEE80211_DEV(priv->hw, &pcid->dev);
+
+	if (pci_enable_device(pcid)) {
+		device_free_info(priv);
+		return -ENODEV;
+	}
+
+	dev_dbg(&pcid->dev,
+		"Before get pci_info memaddr is %x\n", priv->memaddr);
+
+	if (!device_get_pci_info(priv, pcid)) {
+		dev_err(&pcid->dev, ": Failed to find PCI device.\n");
+		device_free_info(priv);
+		return -ENODEV;
+	}
+
+#ifdef	DEBUG
+	dev_dbg(&pcid->dev,
+		"after get pci_info memaddr is %x, io addr is %x,io_size is %d\n",
+		priv->memaddr, priv->ioaddr, priv->io_size);
+	{
+		int i;
+		u32 bar, len;
+		u32 address[] = {
+			PCI_BASE_ADDRESS_0,
+			PCI_BASE_ADDRESS_1,
+			PCI_BASE_ADDRESS_2,
+			PCI_BASE_ADDRESS_3,
+			PCI_BASE_ADDRESS_4,
+			PCI_BASE_ADDRESS_5,
+			0};
+		for (i = 0; address[i]; i++) {
+			pci_read_config_dword(pcid, address[i], &bar);
+
+			dev_dbg(&pcid->dev, "bar %d is %x\n", i, bar);
+
+			if (!bar) {
+				dev_dbg(&pcid->dev,
+					"bar %d not implemented\n", i);
+				continue;
+			}
+
+			if (bar & PCI_BASE_ADDRESS_SPACE_IO) {
+				/* This is IO */
+
+				len = bar & (PCI_BASE_ADDRESS_IO_MASK & 0xffff);
+				len = len & ~(len - 1);
+
+				dev_dbg(&pcid->dev,
+					"IO space:  len in IO %x, BAR %d\n",
+					len, i);
+			} else {
+				len = bar & 0xfffffff0;
+				len = ~len + 1;
+
+				dev_dbg(&pcid->dev,
+					"len in MEM %x, BAR %d\n", len, i);
+			}
+		}
+	}
+#endif
+
+	priv->PortOffset = ioremap(priv->memaddr & PCI_BASE_ADDRESS_MEM_MASK,
+				   priv->io_size);
+	if (!priv->PortOffset) {
+		dev_err(&pcid->dev, ": Failed to IO remapping ..\n");
+		device_free_info(priv);
+		return -ENODEV;
+	}
+
+	rc = pci_request_regions(pcid, DEVICE_NAME);
+	if (rc) {
+		dev_err(&pcid->dev, ": Failed to find PCI device\n");
+		device_free_info(priv);
+		return -ENODEV;
+	}
+
+	/* do reset */
+	if (!MACbSoftwareReset(priv->PortOffset)) {
+		dev_err(&pcid->dev, ": Failed to access MAC hardware..\n");
+		device_free_info(priv);
+		return -ENODEV;
+	}
+	/* initial to reload eeprom */
+	MACvInitialize(priv->PortOffset);
+	MACvReadEtherAddress(priv->PortOffset, priv->abyCurrentNetAddr);
+
+	device_get_options(priv);
+	device_set_options(priv);
+	/* Mask out the options cannot be set to the chip */
+	priv->sOpts.flags &= pChip_info->flags;
+
+	/* Enable the chip specified capabilities */
+	priv->flags = priv->sOpts.flags | (pChip_info->flags & 0xff000000UL);
+	priv->tx_80211 = device_dma0_tx_80211;
+	priv->sMgmtObj.pAdapter = (void *)priv;
+	priv->pMgmt = &(priv->sMgmtObj);
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
+	priv->hw->max_signal = 100;
+
+	if (vnt_init(priv))
+		return -ENODEV;
+
+	device_print_info(priv);
+	pci_set_drvdata(pcid, priv);
+
+	return 0;
+}
+
 /*------------------------------------------------------------------*/
 
 MODULE_DEVICE_TABLE(pci, vt6655_pci_id_table);
-- 
2.1.0

