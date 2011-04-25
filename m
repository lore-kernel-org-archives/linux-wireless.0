Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62764 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758203Ab1DYSXW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 14:23:22 -0400
Date: Mon, 25 Apr 2011 13:23:20 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	chaoming_li@realsil.com.cn
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 18/18] rtlwifi: rtl8192ce: rtl8192cu: Fix most sparse
 warnings
Message-ID: <4db5bc18.4W+Jfz7tGNfOfYvj%Larry.Finger@lwfinger.net> (sfid-20110425_202325_362010_D04ECF87)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix most sparse warnings in rtlwifi, rtl8192ce and rtl8192cu drivers.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 base.c                |    6 -
 efuse.c               |    4 -
 pci.c                 |  170 +++++---------------------------------------------
 rtl8192c/dm_common.c  |   45 -------------
 rtl8192c/phy_common.c |   16 ++--
 rtl8192c/phy_common.h |   16 ++++
 rtl8192ce/hw.c        |    2 
 rtl8192ce/phy.c       |   69 --------------------
 rtl8192ce/phy.h       |    4 +
 rtl8192ce/reg.h       |    2 
 rtl8192ce/sw.c        |    8 +-
 rtl8192ce/trx.c       |   10 +-
 rtl8192cu/phy.c       |   14 ++--
 rtl8192cu/phy.h       |   14 ++++
 rtl8192cu/rf.c        |    4 -
 rtl8192cu/rf.h        |    4 +
 wifi.h                |    7 +-
 17 files changed, 93 insertions(+), 302 deletions(-)
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/base.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/base.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/base.c
@@ -795,7 +795,7 @@ u8 rtl_is_special_data(struct ieee80211_
 	ip = (struct iphdr *)((u8 *) skb->data + mac_hdr_len +
 			      SNAP_SIZE + PROTOC_TYPE_SIZE);
 	ether_type = *(u16 *) ((u8 *) skb->data + mac_hdr_len + SNAP_SIZE);
-	ether_type = ntohs(ether_type);
+	/*	ether_type = ntohs(ether_type); */
 
 	if (ETH_P_IP == ether_type) {
 		if (IPPROTO_UDP == ip->protocol) {
@@ -1105,7 +1105,7 @@ u8 *rtl_find_ie(u8 *data, unsigned int l
 
 /* when we use 2 rx ants we send IEEE80211_SMPS_OFF */
 /* when we use 1 rx ant we send IEEE80211_SMPS_STATIC */
-struct sk_buff *rtl_make_smps_action(struct ieee80211_hw *hw,
+static struct sk_buff *rtl_make_smps_action(struct ieee80211_hw *hw,
 		enum ieee80211_smps_mode smps, u8 *da, u8 *bssid)
 {
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
@@ -1230,7 +1230,7 @@ static bool rtl_chk_vendor_ouisub(struct
 	return matched;
 }
 
-bool rtl_find_221_ie(struct ieee80211_hw *hw, u8 *data,
+static bool rtl_find_221_ie(struct ieee80211_hw *hw, u8 *data,
 		unsigned int len)
 {
 	struct ieee80211_mgmt *mgmt = (void *)data;
Index: wireless-testing/drivers/net/wireless/rtlwifi/efuse.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/efuse.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/efuse.c
@@ -235,7 +235,7 @@ void read_efuse(struct ieee80211_hw *hw,
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
-	u8 efuse_tbl[rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE]];
+	u8 efuse_tbl[HWSET_MAX_SIZE];
 	u8 rtemp8[1];
 	u16 efuse_addr = 0;
 	u8 offset, wren;
@@ -245,7 +245,7 @@ void read_efuse(struct ieee80211_hw *hw,
 		rtlpriv->cfg->maps[EFUSE_MAX_SECTION_MAP];
 	const u32 efuse_len =
 		rtlpriv->cfg->maps[EFUSE_REAL_CONTENT_SIZE];
-	u16 efuse_word[efuse_max_section][EFUSE_MAX_WORD_UNIT];
+	u16 efuse_word[EFUSE_MAX_SECTION][EFUSE_MAX_WORD_UNIT];
 	u16 efuse_utilized = 0;
 	u8 efuse_usage;
 
Index: wireless-testing/drivers/net/wireless/rtlwifi/pci.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/pci.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/pci.c
@@ -48,11 +48,11 @@ static const u8 ac_to_hwq[] = {
 	BK_QUEUE
 };
 
-u8 _rtl_mac_to_hwqueue(struct ieee80211_hw *hw,
+static u8 _rtl_mac_to_hwqueue(struct ieee80211_hw *hw,
 		       struct sk_buff *skb)
 {
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-	u16 fc = rtl_get_fc(skb);
+	__le16 fc = rtl_get_fc(skb);
 	u8 queue_index = skb_get_queue_mapping(skb);
 
 	if (unlikely(ieee80211_is_beacon(fc)))
@@ -181,71 +181,6 @@ static void _rtl_pci_update_default_sett
 		ppsc->support_aspm = false;
 }
 
-/*Disable L0s dirtectly. We will disable host L0s by default. */
-void rtl_pci_disable_host_l0s(struct ieee80211_hw *hw)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
-	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-	u8 pcibridge_busnum = pcipriv->ndis_adapter.pcibridge_busnum;
-	u8 pcibridge_devnum = pcipriv->ndis_adapter.pcibridge_devnum;
-	u8 pcibridge_funcnum = pcipriv->ndis_adapter.pcibridge_funcnum;
-	u32 pcicfg_addrport = pcipriv->ndis_adapter.pcicfg_addrport;
-	u8 num4bytes = pcipriv->ndis_adapter.num4bytes;
-	u8 u_pcibridge_aspmsetting = 0;
-
-	/*Read  Link Control Register */
-	rtl_pci_raw_write_port_ulong(PCI_CONF_ADDRESS,
-				     pcicfg_addrport + (num4bytes << 2));
-	rtl_pci_raw_read_port_uchar(PCI_CONF_DATA, &u_pcibridge_aspmsetting);
-
-	if (u_pcibridge_aspmsetting & BIT(0))
-		u_pcibridge_aspmsetting &= ~(BIT(0));
-
-	rtl_pci_raw_write_port_ulong(PCI_CONF_ADDRESS,
-				     pcicfg_addrport + (num4bytes << 2));
-	rtl_pci_raw_write_port_uchar(PCI_CONF_DATA, u_pcibridge_aspmsetting);
-
-	udelay(50);
-
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
-		 ("PciBridge busnumber[%x], DevNumbe[%x], "
-		  "funcnumber[%x], Write reg[%x] = %lx\n",
-		  pcibridge_busnum, pcibridge_devnum, pcibridge_funcnum,
-		  (pcipriv->ndis_adapter.pcibridge_pciehdr_offset + 0x10),
-		  (pcipriv->ndis_adapter.pcibridge_linkctrlreg |
-		   (rtlpci->const_devicepci_aspm_setting & ~BIT(0)))));
-}
-
-/*Enable rtl8192ce backdoor to control ASPM and clock request.*/
-bool rtl_pci_enable_back_door(struct ieee80211_hw *hw)
-{
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
-	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-	u8 pcibridge_vendor = pcipriv->ndis_adapter.pcibridge_vendor;
-	bool bresult = true;
-	u8 value;
-
-	pci_read_config_byte(rtlpci->pdev, 0x70f, &value);
-
-	/*0x70f BIT(7) is used to control L0S */
-	if (pcibridge_vendor == PCI_BRIDGE_VENDOR_INTEL) {
-		value |= BIT(7);
-	} else {
-		/*Set 0x70f to 0x23 when non-Intel platform. */
-		value = 0x23;
-	}
-
-	pci_write_config_byte(rtlpci->pdev, 0x70f, value);
-
-	pci_read_config_byte(rtlpci->pdev, 0x719, &value);
-	/*0x719 BIT(3) is for L1 BIT(4) is for clock request */
-	value |= (BIT(3) | BIT(4));
-	pci_write_config_byte(rtlpci->pdev, 0x719, value);
-
-	return bresult;
-}
-
 static bool _rtl_pci_platform_switch_device_pci_aspm(
 			struct ieee80211_hw *hw,
 			u8 value)
@@ -426,7 +361,7 @@ static bool rtl_pci_get_amd_l1_patch(str
 	return status;
 }
 
-void rtl_pci_get_linkcontrol_field(struct ieee80211_hw *hw)
+static void rtl_pci_get_linkcontrol_field(struct ieee80211_hw *hw)
 {
 	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
 	u8 capabilityoffset = pcipriv->ndis_adapter.pcibridge_pciehdr_offset;
@@ -618,9 +553,9 @@ static void _rtl_pci_tx_isr(struct ieee8
 
 		skb = __skb_dequeue(&ring->queue);
 		pci_unmap_single(rtlpci->pdev,
-				 le32_to_cpu(rtlpriv->cfg->ops->
+				 rtlpriv->cfg->ops->
 					     get_desc((u8 *) entry, true,
-						      HW_DESC_TXBUFF_ADDR)),
+						      HW_DESC_TXBUFF_ADDR),
 				 skb->len, PCI_DMA_TODEVICE);
 
 		/* remove early mode header */
@@ -844,7 +779,7 @@ static void _rtl_pci_rx_interrupt(struct
 
 		}
 done:
-		bufferaddress = cpu_to_le32(*((dma_addr_t *)skb->cb));
+		bufferaddress = (*((dma_addr_t *)skb->cb));
 		tmp_one = 1;
 		rtlpriv->cfg->ops->set_desc((u8 *) pdesc, false,
 					    HW_DESC_RXBUFF_ADDR,
@@ -868,75 +803,6 @@ done:
 
 }
 
-void _rtl_pci_tx_interrupt(struct ieee80211_hw *hw)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-	int prio;
-
-	for (prio = 0; prio < RTL_PCI_MAX_TX_QUEUE_COUNT; prio++) {
-		struct rtl8192_tx_ring *ring = &rtlpci->tx_ring[prio];
-
-		while (skb_queue_len(&ring->queue)) {
-			struct rtl_tx_desc *entry = &ring->desc[ring->idx];
-			struct sk_buff *skb;
-			struct ieee80211_tx_info *info;
-			u8 own;
-
-			/*
-			 *beacon packet will only use the first
-			 *descriptor defautly, and the own may not
-			 *be cleared by the hardware, and
-			 *beacon will free in prepare beacon
-			 */
-			if (prio == BEACON_QUEUE || prio == TXCMD_QUEUE ||
-			    prio == HCCA_QUEUE)
-				break;
-
-			own = (u8) rtlpriv->cfg->ops->get_desc((u8 *) entry,
-							       true,
-							       HW_DESC_OWN);
-
-			if (own)
-				break;
-
-			skb = __skb_dequeue(&ring->queue);
-			pci_unmap_single(rtlpci->pdev,
-					 le32_to_cpu(rtlpriv->cfg->ops->
-						     get_desc((u8 *) entry,
-							  true,
-							  HW_DESC_TXBUFF_ADDR)),
-					 skb->len, PCI_DMA_TODEVICE);
-
-			ring->idx = (ring->idx + 1) % ring->entries;
-
-			info = IEEE80211_SKB_CB(skb);
-			ieee80211_tx_info_clear_status(info);
-
-			info->flags |= IEEE80211_TX_STAT_ACK;
-			/*info->status.rates[0].count = 1; */
-
-			ieee80211_tx_status_irqsafe(hw, skb);
-
-			if ((ring->entries - skb_queue_len(&ring->queue))
-			    == 2 && prio != BEACON_QUEUE) {
-				RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-					 ("more desc left, wake "
-					  "skb_queue@%d,ring->idx = %d,"
-					  "skb_queue_len = 0x%d\n",
-					  prio, ring->idx,
-					  skb_queue_len(&ring->queue)));
-
-				ieee80211_wake_queue(hw,
-						     skb_get_queue_mapping
-						     (skb));
-			}
-
-			skb = NULL;
-		}
-	}
-}
-
 static irqreturn_t _rtl_pci_interrupt(int irq, void *dev_id)
 {
 	struct ieee80211_hw *hw = dev_id;
@@ -1202,9 +1068,9 @@ static int _rtl_pci_init_tx_ring(struct
 		 ("queue:%d, ring_addr:%p\n", prio, ring));
 
 	for (i = 0; i < entries; i++) {
-		nextdescaddress = cpu_to_le32((u32) dma +
+		nextdescaddress = (u32) dma +
 					      ((i + 11) % entries) *
-					      sizeof(*ring));
+					      sizeof(*ring);
 
 		rtlpriv->cfg->ops->set_desc((u8 *)&(ring[i]),
 					    true, HW_DESC_TX_NEXTDESC_ADDR,
@@ -1268,7 +1134,7 @@ static int _rtl_pci_init_rx_ring(struct
 					   rtlpci->rxbuffersize,
 					   PCI_DMA_FROMDEVICE);
 
-			bufferaddress = cpu_to_le32(*((dma_addr_t *)skb->cb));
+			bufferaddress = (*((dma_addr_t *)skb->cb));
 			rtlpriv->cfg->ops->set_desc((u8 *)entry, false,
 						    HW_DESC_RXBUFF_ADDR,
 						    (u8 *)&bufferaddress);
@@ -1299,9 +1165,9 @@ static void _rtl_pci_free_tx_ring(struct
 		struct sk_buff *skb = __skb_dequeue(&ring->queue);
 
 		pci_unmap_single(rtlpci->pdev,
-				 le32_to_cpu(rtlpriv->cfg->
+				 rtlpriv->cfg->
 					     ops->get_desc((u8 *) entry, true,
-						   HW_DESC_TXBUFF_ADDR)),
+						   HW_DESC_TXBUFF_ADDR),
 				 skb->len, PCI_DMA_TODEVICE);
 		kfree_skb(skb);
 		ring->idx = (ring->idx + 1) % ring->entries;
@@ -1433,11 +1299,11 @@ int rtl_pci_reset_trx_ring(struct ieee80
 				    __skb_dequeue(&ring->queue);
 
 				pci_unmap_single(rtlpci->pdev,
-						 le32_to_cpu(rtlpriv->cfg->ops->
+						 rtlpriv->cfg->ops->
 							 get_desc((u8 *)
 							 entry,
 							 true,
-							 HW_DESC_TXBUFF_ADDR)),
+							 HW_DESC_TXBUFF_ADDR),
 						 skb->len, PCI_DMA_TODEVICE);
 				kfree_skb(skb);
 				ring->idx = (ring->idx + 1) % ring->entries;
@@ -1484,7 +1350,7 @@ static bool rtl_pci_tx_chk_waitq_insert(
 	return true;
 }
 
-int rtl_pci_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
+static int rtl_pci_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 		struct rtl_tcb_desc *ptcb_desc)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -1623,7 +1489,7 @@ static void rtl_pci_flush(struct ieee802
 	}
 }
 
-void rtl_pci_deinit(struct ieee80211_hw *hw)
+static void rtl_pci_deinit(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
@@ -1638,7 +1504,7 @@ void rtl_pci_deinit(struct ieee80211_hw
 
 }
 
-int rtl_pci_init(struct ieee80211_hw *hw, struct pci_dev *pdev)
+static int rtl_pci_init(struct ieee80211_hw *hw, struct pci_dev *pdev)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	int err;
@@ -1655,7 +1521,7 @@ int rtl_pci_init(struct ieee80211_hw *hw
 	return 1;
 }
 
-int rtl_pci_start(struct ieee80211_hw *hw)
+static int rtl_pci_start(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
@@ -1690,7 +1556,7 @@ int rtl_pci_start(struct ieee80211_hw *h
 	return 0;
 }
 
-void rtl_pci_stop(struct ieee80211_hw *hw)
+static void rtl_pci_stop(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
@@ -1238,51 +1238,6 @@ static void rtl92c_dm_init_dynamic_bb_po
 	dm_pstable.rssi_val_min = 0;
 }
 
-void rtl92c_dm_1r_cca(struct ieee80211_hw *hw)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_phy *rtlphy = &(rtlpriv->phy);
-
-	if (dm_pstable.rssi_val_min != 0) {
-		if (dm_pstable.pre_ccastate == CCA_2R) {
-			if (dm_pstable.rssi_val_min >= 35)
-				dm_pstable.cur_ccasate = CCA_1R;
-			else
-				dm_pstable.cur_ccasate = CCA_2R;
-		} else {
-			if (dm_pstable.rssi_val_min <= 30)
-				dm_pstable.cur_ccasate = CCA_2R;
-			else
-				dm_pstable.cur_ccasate = CCA_1R;
-		}
-	} else {
-		dm_pstable.cur_ccasate = CCA_MAX;
-	}
-
-	if (dm_pstable.pre_ccastate != dm_pstable.cur_ccasate) {
-		if (dm_pstable.cur_ccasate == CCA_1R) {
-			if (get_rf_type(rtlphy) == RF_2T2R) {
-				rtl_set_bbreg(hw, ROFDM0_TRXPATHENABLE,
-					      MASKBYTE0, 0x13);
-				rtl_set_bbreg(hw, 0xe70, MASKBYTE3, 0x20);
-			} else {
-				rtl_set_bbreg(hw, ROFDM0_TRXPATHENABLE,
-					      MASKBYTE0, 0x23);
-				rtl_set_bbreg(hw, 0xe70, 0x7fc00000, 0x10c);
-			}
-		} else {
-			rtl_set_bbreg(hw, ROFDM0_TRXPATHENABLE, MASKBYTE0,
-				      0x33);
-			rtl_set_bbreg(hw, 0xe70, MASKBYTE3, 0x63);
-		}
-		dm_pstable.pre_ccastate = dm_pstable.cur_ccasate;
-	}
-
-	RT_TRACE(rtlpriv, DBG_LOUD, DBG_LOUD, ("CCAStage = %s\n",
-					       (dm_pstable.cur_ccasate ==
-						0) ? "1RCCA" : "2RCCA"));
-}
-
 void rtl92c_dm_rf_saving(struct ieee80211_hw *hw, u8 bforce_in_normal)
 {
 	static u8 initialize;
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
@@ -83,7 +83,7 @@ void rtl92c_phy_set_bb_reg(struct ieee80
 EXPORT_SYMBOL(rtl92c_phy_set_bb_reg);
 
 u32 _rtl92c_phy_fw_rf_serial_read(struct ieee80211_hw *hw,
-					 enum radio_path rfpath, u32 offset)
+				  enum radio_path rfpath, u32 offset)
 {
 	RT_ASSERT(false, ("deprecated!\n"));
 	return 0;
@@ -92,15 +92,15 @@ u32 _rtl92c_phy_fw_rf_serial_read(struct
 EXPORT_SYMBOL(_rtl92c_phy_fw_rf_serial_read);
 
 void _rtl92c_phy_fw_rf_serial_write(struct ieee80211_hw *hw,
-					   enum radio_path rfpath, u32 offset,
-					   u32 data)
+				    enum radio_path rfpath, u32 offset,
+				    u32 data)
 {
 	RT_ASSERT(false, ("deprecated!\n"));
 }
 EXPORT_SYMBOL(_rtl92c_phy_fw_rf_serial_write);
 
 u32 _rtl92c_phy_rf_serial_read(struct ieee80211_hw *hw,
-				      enum radio_path rfpath, u32 offset)
+			       enum radio_path rfpath, u32 offset)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
@@ -151,8 +151,8 @@ u32 _rtl92c_phy_rf_serial_read(struct ie
 EXPORT_SYMBOL(_rtl92c_phy_rf_serial_read);
 
 void _rtl92c_phy_rf_serial_write(struct ieee80211_hw *hw,
-					enum radio_path rfpath, u32 offset,
-					u32 data)
+				 enum radio_path rfpath, u32 offset,
+				 u32 data)
 {
 	u32 data_and_addr;
 	u32 newoffset;
@@ -250,8 +250,8 @@ bool _rtl92c_phy_bb8192c_config_parafile
 EXPORT_SYMBOL(_rtl92c_phy_bb8192c_config_parafile);
 
 void _rtl92c_store_pwrIndex_diffrate_offset(struct ieee80211_hw *hw,
-						   u32 regaddr, u32 bitmask,
-						   u32 data)
+					    u32 regaddr, u32 bitmask,
+					    u32 data)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.h
@@ -238,6 +238,22 @@ void _rtl92c_phy_set_rf_sleep(struct iee
 bool _rtl92c_phy_sw_chnl_step_by_step(struct ieee80211_hw *hw,
 				      u8 channel, u8 *stage, u8 *step,
 				      u32 *delay);
+u8 rtl92c_bt_rssi_state_change(struct ieee80211_hw *hw);
+u32 _rtl92c_phy_fw_rf_serial_read(struct ieee80211_hw *hw,
+				  enum radio_path rfpath, u32 offset);
+void _rtl92c_phy_fw_rf_serial_write(struct ieee80211_hw *hw,
+				    enum radio_path rfpath, u32 offset,
+				    u32 data);
+u32 _rtl92c_phy_rf_serial_read(struct ieee80211_hw *hw,
+			       enum radio_path rfpath, u32 offset);
+void _rtl92c_phy_rf_serial_write(struct ieee80211_hw *hw,
+				 enum radio_path rfpath, u32 offset,
+				 u32 data);
+bool _rtl92c_phy_bb8192c_config_parafile(struct ieee80211_hw *hw);
+void _rtl92c_store_pwrIndex_diffrate_offset(struct ieee80211_hw *hw,
+					    u32 regaddr, u32 bitmask,
+					    u32 data);
+bool rtl92c_phy_set_io_cmd(struct ieee80211_hw *hw, enum io_type iotype);
 
 #endif
 
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
@@ -2177,7 +2177,7 @@ void rtl92ce_set_key(struct ieee80211_hw
 	}
 }
 
-void rtl8192ce_bt_var_init(struct ieee80211_hw *hw)
+static void rtl8192ce_bt_var_init(struct ieee80211_hw *hw)
 {
 	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
 
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
@@ -366,75 +366,6 @@ bool rtl92c_phy_config_rf_with_headerfil
 	return true;
 }
 
-void rtl92c_phy_set_bw_mode_callback(struct ieee80211_hw *hw)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-	struct rtl_phy *rtlphy = &(rtlpriv->phy);
-	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
-	u8 reg_bw_opmode;
-	u8 reg_prsr_rsc;
-
-	RT_TRACE(rtlpriv, COMP_SCAN, DBG_TRACE,
-		 ("Switch to %s bandwidth\n",
-		  rtlphy->current_chan_bw == HT_CHANNEL_WIDTH_20 ?
-		  "20MHz" : "40MHz"))
-
-	if (is_hal_stop(rtlhal)) {
-		rtlphy->set_bwmode_inprogress = false;
-		return;
-	}
-
-	reg_bw_opmode = rtl_read_byte(rtlpriv, REG_BWOPMODE);
-	reg_prsr_rsc = rtl_read_byte(rtlpriv, REG_RRSR + 2);
-
-	switch (rtlphy->current_chan_bw) {
-	case HT_CHANNEL_WIDTH_20:
-		reg_bw_opmode |= BW_OPMODE_20MHZ;
-		rtl_write_byte(rtlpriv, REG_BWOPMODE, reg_bw_opmode);
-		break;
-	case HT_CHANNEL_WIDTH_20_40:
-		reg_bw_opmode &= ~BW_OPMODE_20MHZ;
-		rtl_write_byte(rtlpriv, REG_BWOPMODE, reg_bw_opmode);
-		reg_prsr_rsc =
-		    (reg_prsr_rsc & 0x90) | (mac->cur_40_prime_sc << 5);
-		rtl_write_byte(rtlpriv, REG_RRSR + 2, reg_prsr_rsc);
-		break;
-	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 ("unknown bandwidth: %#X\n", rtlphy->current_chan_bw));
-		break;
-	}
-
-	switch (rtlphy->current_chan_bw) {
-	case HT_CHANNEL_WIDTH_20:
-		rtl_set_bbreg(hw, RFPGA0_RFMOD, BRFMOD, 0x0);
-		rtl_set_bbreg(hw, RFPGA1_RFMOD, BRFMOD, 0x0);
-		rtl_set_bbreg(hw, RFPGA0_ANALOGPARAMETER2, BIT(10), 1);
-		break;
-	case HT_CHANNEL_WIDTH_20_40:
-		rtl_set_bbreg(hw, RFPGA0_RFMOD, BRFMOD, 0x1);
-		rtl_set_bbreg(hw, RFPGA1_RFMOD, BRFMOD, 0x1);
-
-		rtl_set_bbreg(hw, RCCK0_SYSTEM, BCCK_SIDEBAND,
-			      (mac->cur_40_prime_sc >> 1));
-		rtl_set_bbreg(hw, ROFDM1_LSTF, 0xC00, mac->cur_40_prime_sc);
-		rtl_set_bbreg(hw, RFPGA0_ANALOGPARAMETER2, BIT(10), 0);
-
-		rtl_set_bbreg(hw, 0x818, (BIT(26) | BIT(27)),
-			      (mac->cur_40_prime_sc ==
-			       HAL_PRIME_CHNL_OFFSET_LOWER) ? 2 : 1);
-		break;
-	default:
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 ("unknown bandwidth: %#X\n", rtlphy->current_chan_bw));
-		break;
-	}
-	rtl92ce_phy_rf6052_set_bandwidth(hw, rtlphy->current_chan_bw);
-	rtlphy->set_bwmode_inprogress = false;
-	RT_TRACE(rtlpriv, COMP_SCAN, DBG_TRACE, ("<==\n"));
-}
-
 void _rtl92ce_phy_lc_calibrate(struct ieee80211_hw *hw, bool is2t)
 {
 	u8 tmpreg;
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
@@ -253,6 +253,10 @@ bool _rtl92c_phy_bb8192c_config_parafile
 void _rtl92c_phy_set_rf_sleep(struct ieee80211_hw *hw);
 bool rtl92c_phy_set_rf_power_state(struct ieee80211_hw *hw,
 				   enum rf_pwrstate rfpwr_state);
+bool _rtl92ce_phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
+					    u8 configtype);
+bool _rtl92ce_phy_config_bb_with_pgheaderfile(struct ieee80211_hw *hw,
+					      u8 configtype);
 
 #endif
 
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
@@ -543,8 +543,6 @@
 #define	IMR_OCPINT				BIT(1)
 #define	IMR_WLANOFF				BIT(0)
 
-#define	HWSET_MAX_SIZE				128
-#define EFUSE_MAX_SECTION			16
 #define EFUSE_REAL_CONTENT_LEN			512
 
 #define	EEPROM_DEFAULT_TSSI			0x0
Index: wireless-testing/drivers/net/wireless/rtlwifi/wifi.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/wifi.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/wifi.h
@@ -303,6 +303,9 @@ enum hw_variables {
 	HW_VAR_DATA_FILTER,
 };
 
+#define HWSET_MAX_SIZE				128
+#define EFUSE_MAX_SECTION			16
+
 enum _RT_MEDIA_STATUS {
 	RT_MEDIA_DISCONNECT = 0,
 	RT_MEDIA_CONNECT = 1
@@ -1963,9 +1966,9 @@ static inline struct ieee80211_hdr *rtl_
 	return (struct ieee80211_hdr *)(skb->data);
 }
 
-static inline u16 rtl_get_fc(struct sk_buff *skb)
+static inline __le16 rtl_get_fc(struct sk_buff *skb)
 {
-	return le16_to_cpu(rtl_get_hdr(skb)->frame_control);
+	return rtl_get_hdr(skb)->frame_control;
 }
 
 static inline u16 rtl_get_tid_h(struct ieee80211_hdr *hdr)
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
@@ -42,7 +42,7 @@
 #include "trx.h"
 #include "led.h"
 
-void rtl92c_init_aspm_vars(struct ieee80211_hw *hw)
+static void rtl92c_init_aspm_vars(struct ieee80211_hw *hw)
 {
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 
@@ -185,7 +185,7 @@ void rtl92c_deinit_sw_vars(struct ieee80
 	}
 }
 
-struct rtl_hal_ops rtl8192ce_hal_ops = {
+static struct rtl_hal_ops rtl8192ce_hal_ops = {
 	.init_sw_vars = rtl92c_init_sw_vars,
 	.deinit_sw_vars = rtl92c_deinit_sw_vars,
 	.read_eeprom_info = rtl92ce_read_eeprom_info,
@@ -235,14 +235,14 @@ struct rtl_hal_ops rtl8192ce_hal_ops = {
 	.dm_dynamic_txpower = rtl92ce_dm_dynamic_txpower,
 };
 
-struct rtl_mod_params rtl92ce_mod_params = {
+static struct rtl_mod_params rtl92ce_mod_params = {
 	.sw_crypto = false,
 	.inactiveps = true,
 	.swctrl_lps = false,
 	.fwctrl_lps = true,
 };
 
-struct rtl_hal_cfg rtl92ce_hal_cfg = {
+static struct rtl_hal_cfg rtl92ce_hal_cfg = {
 	.bar_id = 2,
 	.write_readback = true,
 	.name = "rtl92c_pci",
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
@@ -36,9 +36,9 @@
 #include "trx.h"
 #include "led.h"
 
-u8 _rtl92ce_map_hwqueue_to_fwqueue(struct sk_buff *skb, u8 hw_queue)
+static u8 _rtl92ce_map_hwqueue_to_fwqueue(struct sk_buff *skb, u8 hw_queue)
 {
-	u16 fc = rtl_get_fc(skb);
+	__le16 fc = rtl_get_fc(skb);
 
 	if (unlikely(ieee80211_is_beacon(fc)))
 		return QSLT_BEACON;
@@ -795,7 +795,6 @@ void rtl92ce_tx_fill_desc(struct ieee802
 			u8 ampdu_density = sta->ht_cap.ampdu_density;
 			SET_TX_DESC_AMPDU_DENSITY(pdesc, ampdu_density);
 		}
-		rcu_read_unlock();
 
 		if (info->control.hw_key) {
 			struct ieee80211_key_conf *keyconf =
@@ -834,13 +833,14 @@ void rtl92ce_tx_fill_desc(struct ieee802
 			}
 		}
 	}
+	rcu_read_unlock();
 
 	SET_TX_DESC_FIRST_SEG(pdesc, (firstseg ? 1 : 0));
 	SET_TX_DESC_LAST_SEG(pdesc, (lastseg ? 1 : 0));
 
 	SET_TX_DESC_TX_BUFFER_SIZE(pdesc, (u16) skb->len);
 
-	SET_TX_DESC_TX_BUFFER_ADDRESS(pdesc, cpu_to_le32(mapping));
+	SET_TX_DESC_TX_BUFFER_ADDRESS(pdesc, mapping);
 
 	if (rtlpriv->dm.useramask) {
 		SET_TX_DESC_RATE_ID(pdesc, tcb_desc->ratr_index);
@@ -901,7 +901,7 @@ void rtl92ce_tx_fill_cmddesc(struct ieee
 
 	SET_TX_DESC_TX_BUFFER_SIZE(pdesc, (u16) (skb->len));
 
-	SET_TX_DESC_TX_BUFFER_ADDRESS(pdesc, cpu_to_le32(mapping));
+	SET_TX_DESC_TX_BUFFER_ADDRESS(pdesc, mapping);
 
 	SET_TX_DESC_RATE_ID(pdesc, 7);
 	SET_TX_DESC_MACID(pdesc, 0);
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
@@ -38,7 +38,7 @@
 #include "table.h"
 
 u32 rtl92cu_phy_query_rf_reg(struct ieee80211_hw *hw,
-			    enum radio_path rfpath, u32 regaddr, u32 bitmask)
+			     enum radio_path rfpath, u32 regaddr, u32 bitmask)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u32 original_value, readback_value, bitshift;
@@ -64,8 +64,8 @@ u32 rtl92cu_phy_query_rf_reg(struct ieee
 }
 
 void rtl92cu_phy_set_rf_reg(struct ieee80211_hw *hw,
-			   enum radio_path rfpath,
-			   u32 regaddr, u32 bitmask, u32 data)
+			    enum radio_path rfpath,
+			    u32 regaddr, u32 bitmask, u32 data)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
@@ -163,7 +163,7 @@ bool _rtl92cu_phy_config_mac_with_header
 }
 
 bool _rtl92cu_phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
-						  u8 configtype)
+					    u8 configtype)
 {
 	int i;
 	u32 *phy_regarray_table;
@@ -223,7 +223,7 @@ bool _rtl92cu_phy_config_bb_with_headerf
 }
 
 bool _rtl92cu_phy_config_bb_with_pgheaderfile(struct ieee80211_hw *hw,
-						    u8 configtype)
+					      u8 configtype)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
@@ -459,7 +459,7 @@ void _rtl92cu_phy_lc_calibrate(struct ie
 	}
 }
 
-bool _rtl92cu_phy_set_rf_power_state(struct ieee80211_hw *hw,
+static bool _rtl92cu_phy_set_rf_power_state(struct ieee80211_hw *hw,
 					    enum rf_pwrstate rfpwr_state)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -595,7 +595,7 @@ bool _rtl92cu_phy_set_rf_power_state(str
 }
 
 bool rtl92cu_phy_set_rf_power_state(struct ieee80211_hw *hw,
-				   enum rf_pwrstate rfpwr_state)
+				    enum rf_pwrstate rfpwr_state)
 {
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	bool bresult = false;
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/phy.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/phy.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/phy.h
@@ -34,3 +34,17 @@ bool rtl8192_phy_check_is_legal_rfpath(s
 void rtl92c_phy_set_io(struct ieee80211_hw *hw);
 bool _rtl92cu_phy_config_mac_with_headerfile(struct ieee80211_hw *hw);
 bool rtl92cu_phy_bb_config(struct ieee80211_hw *hw);
+u32 rtl92cu_phy_query_rf_reg(struct ieee80211_hw *hw,
+			     enum radio_path rfpath, u32 regaddr, u32 bitmask);
+void rtl92cu_phy_set_rf_reg(struct ieee80211_hw *hw,
+			    enum radio_path rfpath,
+			    u32 regaddr, u32 bitmask, u32 data);
+bool rtl92cu_phy_mac_config(struct ieee80211_hw *hw);
+bool _rtl92cu_phy_config_bb_with_pgheaderfile(struct ieee80211_hw *hw,
+					      u8 configtype);
+void _rtl92cu_phy_lc_calibrate(struct ieee80211_hw *hw, bool is2t);
+bool _rtl92cu_phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
+					    u8 configtype);
+void rtl92cu_phy_set_bw_mode_callback(struct ieee80211_hw *hw);
+bool rtl92cu_phy_set_rf_power_state(struct ieee80211_hw *hw,
+				    enum rf_pwrstate rfpwr_state);
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
@@ -62,7 +62,7 @@ void rtl92cu_phy_rf6052_set_bandwidth(st
 }
 
 void rtl92cu_phy_rf6052_set_cck_txpower(struct ieee80211_hw *hw,
-				       u8 *ppowerlevel)
+					u8 *ppowerlevel)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
@@ -389,7 +389,7 @@ static void _rtl92c_write_ofdm_power_reg
 }
 
 void rtl92cu_phy_rf6052_set_ofdm_txpower(struct ieee80211_hw *hw,
-					u8 *ppowerlevel, u8 channel)
+					 u8 *ppowerlevel, u8 channel)
 {
 	u32 writeVal[2], powerBase0[2], powerBase1[2];
 	u8 index = 0;
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/rf.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/rf.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/rf.h
@@ -43,5 +43,9 @@ extern void rtl92c_phy_rf6052_set_ofdm_t
 bool rtl92cu_phy_rf6052_config(struct ieee80211_hw *hw);
 bool rtl92cu_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 					  enum radio_path rfpath);
+void rtl92cu_phy_rf6052_set_cck_txpower(struct ieee80211_hw *hw,
+					u8 *ppowerlevel);
+void rtl92cu_phy_rf6052_set_ofdm_txpower(struct ieee80211_hw *hw,
+					 u8 *ppowerlevel, u8 channel);
 
 #endif
