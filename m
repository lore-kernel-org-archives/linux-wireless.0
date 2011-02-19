Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61659 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113Ab1BSWaB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Feb 2011 17:30:01 -0500
Date: Sat, 19 Feb 2011 16:29:57 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: george0505@realtek.com, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org
Subject: [PATCH V2 15/16] rtlwifi: rtl8192ce: Fix endian warnings
Message-ID: <4d604465.TCAK1hoPZgFWH2PE%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drivers rtlwifi, and rtl8192ce generate a large number of
sparse warnings. This patch fixes most of them.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/base.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/base.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/base.c
@@ -144,7 +144,7 @@ static void _rtl_init_hw_ht_capab(struct
 		ht_cap->mcs.rx_mask[1] = 0xFF;
 		ht_cap->mcs.rx_mask[4] = 0x01;
 
-		ht_cap->mcs.rx_highest = MAX_BIT_RATE_40MHZ_MCS15;
+		ht_cap->mcs.rx_highest = cpu_to_le16(MAX_BIT_RATE_40MHZ_MCS15);
 	} else if (get_rf_type(rtlphy) == RF_1T1R) {
 
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, ("1T1R\n"));
@@ -153,7 +153,7 @@ static void _rtl_init_hw_ht_capab(struct
 		ht_cap->mcs.rx_mask[1] = 0x00;
 		ht_cap->mcs.rx_mask[4] = 0x01;
 
-		ht_cap->mcs.rx_highest = MAX_BIT_RATE_40MHZ_MCS7;
+		ht_cap->mcs.rx_highest = cpu_to_le16(MAX_BIT_RATE_40MHZ_MCS7);
 	}
 }
 
@@ -498,7 +498,7 @@ void rtl_get_tcb_desc(struct ieee80211_h
 	struct rtl_mac *rtlmac = rtl_mac(rtl_priv(hw));
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
 	struct ieee80211_rate *txrate;
-	u16 fc = le16_to_cpu(hdr->frame_control);
+	__le16 fc = hdr->frame_control;
 
 	memset(tcb_desc, 0, sizeof(struct rtl_tcb_desc));
 
@@ -570,7 +570,7 @@ bool rtl_tx_mgmt_proc(struct ieee80211_h
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
-	u16 fc = le16_to_cpu(hdr->frame_control);
+	__le16 fc = hdr->frame_control;
 
 	if (ieee80211_is_auth(fc)) {
 		RT_TRACE(rtlpriv, COMP_SEND, DBG_DMESG, ("MAC80211_LINKING\n"));
@@ -587,7 +587,7 @@ bool rtl_action_proc(struct ieee80211_hw
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u16 fc = le16_to_cpu(hdr->frame_control);
+	__le16 fc = hdr->frame_control;
 	u8 *act = (u8 *) (((u8 *) skb->data + MAC80211_3ADDR_LEN));
 	u8 category;
 
@@ -632,7 +632,7 @@ u8 rtl_is_special_data(struct ieee80211_
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
-	u16 fc = le16_to_cpu(hdr->frame_control);
+	__le16 fc = hdr->frame_control;
 	u16 ether_type;
 	u8 mac_hdr_len = ieee80211_get_hdrlen_from_skb(skb);
 	const struct iphdr *ip;
@@ -646,7 +646,6 @@ u8 rtl_is_special_data(struct ieee80211_
 	ip = (struct iphdr *)((u8 *) skb->data + mac_hdr_len +
 			      SNAP_SIZE + PROTOC_TYPE_SIZE);
 	ether_type = *(u16 *) ((u8 *) skb->data + mac_hdr_len + SNAP_SIZE);
-	ether_type = ntohs(ether_type);
 
 	if (ETH_P_IP == ether_type) {
 		if (IPPROTO_UDP == ip->protocol) {
@@ -690,7 +689,8 @@ u8 rtl_is_special_data(struct ieee80211_
 		}
 
 		return true;
-	} else if (0x86DD == ether_type) {
+	} else if (ETH_P_IPV6 == ether_type) {
+		/* IPv6 */
 		return true;
 	}
 
Index: wireless-testing/drivers/net/wireless/rtlwifi/core.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/core.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/core.c
@@ -434,9 +434,9 @@ static int rtl_op_conf_tx(struct ieee802
 
 	aci = _rtl_get_hal_qnum(queue);
 	mac->ac[aci].aifs = param->aifs;
-	mac->ac[aci].cw_min = param->cw_min;
-	mac->ac[aci].cw_max = param->cw_max;
-	mac->ac[aci].tx_op = param->txop;
+	mac->ac[aci].cw_min = cpu_to_le16(param->cw_min);
+	mac->ac[aci].cw_max = cpu_to_le16(param->cw_max);
+	mac->ac[aci].tx_op = cpu_to_le16(param->txop);
 	memcpy(&mac->edca_param[aci], param, sizeof(*param));
 	rtlpriv->cfg->ops->set_qos(hw, aci);
 	return 0;
Index: wireless-testing/drivers/net/wireless/rtlwifi/pci.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/pci.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/pci.c
@@ -476,9 +476,9 @@ static void _rtl_pci_tx_isr(struct ieee8
 
 		skb = __skb_dequeue(&ring->queue);
 		pci_unmap_single(rtlpci->pdev,
-				 le32_to_cpu(rtlpriv->cfg->ops->
+				 rtlpriv->cfg->ops->
 					     get_desc((u8 *) entry, true,
-						      HW_DESC_TXBUFF_ADDR)),
+						      HW_DESC_TXBUFF_ADDR),
 				 skb->len, PCI_DMA_TODEVICE);
 
 		RT_TRACE(rtlpriv, (COMP_INTR | COMP_SEND), DBG_TRACE,
@@ -557,7 +557,7 @@ static void _rtl_pci_rx_interrupt(struct
 			return;
 		} else {
 			struct ieee80211_hdr *hdr;
-			u16 fc;
+			__le16 fc;
 			struct sk_buff *new_skb = NULL;
 
 			rtlpriv->cfg->ops->query_rx_desc(hw, &stats,
@@ -583,7 +583,7 @@ static void _rtl_pci_rx_interrupt(struct
 			 */
 
 			hdr = (struct ieee80211_hdr *)(skb->data);
-			fc = le16_to_cpu(hdr->frame_control);
+			fc = hdr->frame_control;
 
 			if (!stats.crc) {
 				memcpy(IEEE80211_SKB_RXCB(skb), &rx_status,
@@ -666,7 +666,7 @@ static void _rtl_pci_rx_interrupt(struct
 
 		}
 done:
-		bufferaddress = cpu_to_le32(*((dma_addr_t *) skb->cb));
+		bufferaddress = (u32)(*((dma_addr_t *) skb->cb));
 		tmp_one = 1;
 		rtlpriv->cfg->ops->set_desc((u8 *) pdesc, false,
 					    HW_DESC_RXBUFF_ADDR,
@@ -955,9 +955,8 @@ static int _rtl_pci_init_tx_ring(struct
 		 ("queue:%d, ring_addr:%p\n", prio, ring));
 
 	for (i = 0; i < entries; i++) {
-		nextdescaddress = cpu_to_le32((u32) dma +
-					      ((i + 1) % entries) *
-					      sizeof(*ring));
+		nextdescaddress = (u32) dma + ((i + 1) % entries) *
+					      sizeof(*ring);
 
 		rtlpriv->cfg->ops->set_desc((u8 *)&(ring[i]),
 					    true, HW_DESC_TX_NEXTDESC_ADDR,
@@ -1021,7 +1020,7 @@ static int _rtl_pci_init_rx_ring(struct
 					   rtlpci->rxbuffersize,
 					   PCI_DMA_FROMDEVICE);
 
-			bufferaddress = cpu_to_le32(*((dma_addr_t *)skb->cb));
+			bufferaddress = (u32)(*((dma_addr_t *)skb->cb));
 			rtlpriv->cfg->ops->set_desc((u8 *)entry, false,
 						    HW_DESC_RXBUFF_ADDR,
 						    (u8 *)&bufferaddress);
@@ -1052,9 +1051,9 @@ static void _rtl_pci_free_tx_ring(struct
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
@@ -1186,11 +1185,11 @@ int rtl_pci_reset_trx_ring(struct ieee80
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
@@ -1204,7 +1203,7 @@ int rtl_pci_reset_trx_ring(struct ieee80
 	return 0;
 }
 
-static unsigned int _rtl_mac_to_hwqueue(u16 fc,
+static unsigned int _rtl_mac_to_hwqueue(__le16 fc,
 		unsigned int mac80211_queue_index)
 {
 	unsigned int hw_queue_index;
@@ -1254,7 +1253,7 @@ static int rtl_pci_tx(struct ieee80211_h
 	unsigned int queue_index, hw_queue;
 	unsigned long flags;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
-	u16 fc = le16_to_cpu(hdr->frame_control);
+	__le16 fc = hdr->frame_control;
 	u8 *pda_addr = hdr->addr1;
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	/*ssn */
Index: wireless-testing/drivers/net/wireless/rtlwifi/usb.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/usb.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/usb.c
@@ -126,7 +126,7 @@ static u32 _usb_read_sync(struct usb_dev
 
 	wvalue = (u16)addr;
 	_usbctrl_vendorreq_sync_read(udev, request, wvalue, index, data, len);
-	ret = le32_to_cpu(*data);
+	ret = *data;
 	kfree(data);
 	return ret;
 }
@@ -163,7 +163,7 @@ static void _usb_write_async(struct usb_
 	request = REALTEK_USB_VENQT_CMD_REQ;
 	index = REALTEK_USB_VENQT_CMD_IDX; /* n/a */
 	wvalue = (u16)(addr&0x0000ffff);
-	data = cpu_to_le32(val);
+	data = val;
 	_usbctrl_vendorreq_async_write(udev, request, wvalue, index, &data,
 				       len);
 }
@@ -437,7 +437,7 @@ static void _rtl_usb_rx_process_agg(stru
 	u8 *rxdesc = skb->data;
 	struct ieee80211_hdr *hdr;
 	bool unicast = false;
-	u16 fc;
+	__le16 fc;
 	struct ieee80211_rx_status rx_status = {0};
 	struct rtl_stats stats = {
 		.signal = 0,
@@ -449,7 +449,7 @@ static void _rtl_usb_rx_process_agg(stru
 	rtlpriv->cfg->ops->query_rx_desc(hw, &stats, &rx_status, rxdesc, skb);
 	skb_pull(skb, (stats.rx_drvinfo_size + stats.rx_bufshift));
 	hdr = (struct ieee80211_hdr *)(skb->data);
-	fc = le16_to_cpu(hdr->frame_control);
+	fc = hdr->frame_control;
 	if (!stats.crc) {
 		memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
 
@@ -480,7 +480,7 @@ static void _rtl_usb_rx_process_noagg(st
 	u8 *rxdesc = skb->data;
 	struct ieee80211_hdr *hdr;
 	bool unicast = false;
-	u16 fc;
+	__le16 fc;
 	struct ieee80211_rx_status rx_status = {0};
 	struct rtl_stats stats = {
 		.signal = 0,
@@ -492,7 +492,7 @@ static void _rtl_usb_rx_process_noagg(st
 	rtlpriv->cfg->ops->query_rx_desc(hw, &stats, &rx_status, rxdesc, skb);
 	skb_pull(skb, (stats.rx_drvinfo_size + stats.rx_bufshift));
 	hdr = (struct ieee80211_hdr *)(skb->data);
-	fc = le16_to_cpu(hdr->frame_control);
+	fc = hdr->frame_control;
 	if (!stats.crc) {
 		memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
 
@@ -853,7 +853,7 @@ static void _rtl_usb_tx_preprocess(struc
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct rtl_tx_desc *pdesc = NULL;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
-	u16 fc = le16_to_cpu(hdr->frame_control);
+	__le16 fc = hdr->frame_control;
 	u8 *pda_addr = hdr->addr1;
 	/* ssn */
 	u8 *qc = NULL;
@@ -892,7 +892,7 @@ static int rtl_usb_tx(struct ieee80211_h
 	struct rtl_usb *rtlusb = rtl_usbdev(rtl_usbpriv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
-	u16 fc = le16_to_cpu(hdr->frame_control);
+	__le16 fc = hdr->frame_control;
 	u16 hw_queue;
 
 	if (unlikely(is_hal_stop(rtlhal)))
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
@@ -36,7 +36,7 @@
 #include "trx.h"
 #include "led.h"
 
-static enum rtl_desc_qsel _rtl92ce_map_hwqueue_to_fwqueue(u16 fc,
+static enum rtl_desc_qsel _rtl92ce_map_hwqueue_to_fwqueue(__le16 fc,
 							  unsigned int
 							  skb_queue)
 {
@@ -617,13 +617,15 @@ static void _rtl92ce_translate_rx_signal
 	u8 *tmp_buf;
 	u8 *praddr;
 	u8 *psaddr;
-	u16 fc, type;
+	__le16 fc;
+	u16 type, c_fc;
 	bool packet_matchbssid, packet_toself, packet_beacon;
 
 	tmp_buf = skb->data + pstats->rx_drvinfo_size + pstats->rx_bufshift;
 
 	hdr = (struct ieee80211_hdr *)tmp_buf;
-	fc = le16_to_cpu(hdr->frame_control);
+	fc = hdr->frame_control;
+	c_fc = le16_to_cpu(fc);
 	type = WLAN_FC_GET_TYPE(fc);
 	praddr = hdr->addr1;
 	psaddr = hdr->addr2;
@@ -631,8 +633,8 @@ static void _rtl92ce_translate_rx_signal
 	packet_matchbssid =
 	    ((IEEE80211_FTYPE_CTL != type) &&
 	     (!compare_ether_addr(mac->bssid,
-				  (fc & IEEE80211_FCTL_TODS) ?
-				  hdr->addr1 : (fc & IEEE80211_FCTL_FROMDS) ?
+				  (c_fc & IEEE80211_FCTL_TODS) ?
+				  hdr->addr1 : (c_fc & IEEE80211_FCTL_FROMDS) ?
 				  hdr->addr2 : hdr->addr3)) &&
 	     (!pstats->hwerror) && (!pstats->crc) && (!pstats->icv));
 
@@ -728,20 +730,17 @@ void rtl92ce_tx_fill_desc(struct ieee802
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	bool defaultadapter = true;
-
 	struct ieee80211_sta *sta = ieee80211_find_sta(mac->vif, mac->bssid);
-
 	u8 *pdesc = (u8 *) pdesc_tx;
 	struct rtl_tcb_desc tcb_desc;
 	u8 *qc = ieee80211_get_qos_ctl(hdr);
 	u8 tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
 	u16 seq_number;
-	u16 fc = le16_to_cpu(hdr->frame_control);
+	__le16 fc = hdr->frame_control;
 	u8 rate_flag = info->control.rates[0].flags;
 
 	enum rtl_desc_qsel fw_qsel =
-	    _rtl92ce_map_hwqueue_to_fwqueue(le16_to_cpu(hdr->frame_control),
-					    queue_index);
+	    _rtl92ce_map_hwqueue_to_fwqueue(fc, queue_index);
 
 	bool firstseg = ((hdr->seq_ctrl &
 			  cpu_to_le16(IEEE80211_SCTL_FRAG)) == 0);
@@ -901,7 +900,7 @@ void rtl92ce_tx_fill_cmddesc(struct ieee
 					    PCI_DMA_TODEVICE);
 
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
-	u16 fc = le16_to_cpu(hdr->frame_control);
+	__le16 fc = hdr->frame_control;
 
 	CLEAR_PCI_TX_DESC_CONTENT(pdesc, TX_DESC_SIZE);
 
Index: wireless-testing/drivers/net/wireless/rtlwifi/usb.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/usb.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/usb.h
@@ -114,7 +114,7 @@ struct rtl_usb {
 	u32 irq_mask[2];
 	bool irq_enabled;
 
-	u16 (*usb_mq_to_hwq)(u16 fc, u16 mac80211_queue_index);
+	u16 (*usb_mq_to_hwq)(__le16 fc, u16 mac80211_queue_index);
 
 	/* Tx */
 	u8 out_ep_nums ;
Index: wireless-testing/drivers/net/wireless/rtlwifi/wifi.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/wifi.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/wifi.h
@@ -1427,7 +1427,7 @@ struct rtl_hal_usbint_cfg {
 
 	/* endpoint mapping */
 	int (*usb_endpoint_mapping)(struct ieee80211_hw *hw);
-	u16 (*usb_mq_to_hwq)(u16 fc, u16 mac80211_queue_index);
+	u16 (*usb_mq_to_hwq)(__le16 fc, u16 mac80211_queue_index);
 };
 
 struct rtl_hal_cfg {
@@ -1646,7 +1646,7 @@ struct bt_coexist_info {
 #define READEF2BYTE(_ptr)	\
 	EF2BYTE(*((u16 *)(_ptr)))
 #define READEF4BYTE(_ptr)	\
-	EF4BYTE(*((u32 *)(_ptr)))
+	EF4BYTE(*((__le32 *)(_ptr)))
 
 /* Write data to memory */
 #define WRITEEF1BYTE(_ptr, _val)	\
@@ -1759,10 +1759,10 @@ Set subfield of little-endian 4-byte val
 #define packet_get_type(_packet) (EF1BYTE((_packet).octet[0]) & 0xFC)
 #define RTL_WATCH_DOG_TIME	2000
 #define MSECS(t)		msecs_to_jiffies(t)
-#define WLAN_FC_GET_VERS(fc)	((fc) & IEEE80211_FCTL_VERS)
-#define WLAN_FC_GET_TYPE(fc)	((fc) & IEEE80211_FCTL_FTYPE)
-#define WLAN_FC_GET_STYPE(fc)	((fc) & IEEE80211_FCTL_STYPE)
-#define WLAN_FC_MORE_DATA(fc)	((fc) & IEEE80211_FCTL_MOREDATA)
+#define WLAN_FC_GET_VERS(fc)	(le16_to_cpu(fc) & IEEE80211_FCTL_VERS)
+#define WLAN_FC_GET_TYPE(fc)	(le16_to_cpu(fc) & IEEE80211_FCTL_FTYPE)
+#define WLAN_FC_GET_STYPE(fc)	(le16_to_cpu(fc) & IEEE80211_FCTL_STYPE)
+#define WLAN_FC_MORE_DATA(fc)	(le16_to_cpu(fc) & IEEE80211_FCTL_MOREDATA)
 #define SEQ_TO_SN(seq)		(((seq) & IEEE80211_SCTL_SEQ) >> 4)
 #define SN_TO_SEQ(ssn)		(((ssn) << 4) & IEEE80211_SCTL_SEQ)
 #define MAX_SN			((IEEE80211_SCTL_SEQ) >> 4)
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
@@ -318,15 +318,17 @@ void rtl92ce_set_hw_reg(struct ieee80211
 		}
 	case HW_VAR_AC_PARAM:{
 			u8 e_aci = *((u8 *) val);
-			u32 u4b_ac_param = 0;
+			u32 u4b_ac_param;
+			u16 cw_min = le16_to_cpu(mac->ac[e_aci].cw_min);
+			u16 cw_max = le16_to_cpu(mac->ac[e_aci].cw_max);
+			u16 tx_op = le16_to_cpu(mac->ac[e_aci].tx_op);
 
-			u4b_ac_param |= (u32) mac->ac[e_aci].aifs;
-			u4b_ac_param |= ((u32) mac->ac[e_aci].cw_min
+			u4b_ac_param = (u32) mac->ac[e_aci].aifs;
+			u4b_ac_param |= ((u32)cw_min
 					 & 0xF) << AC_PARAM_ECW_MIN_OFFSET;
-			u4b_ac_param |= ((u32) mac->ac[e_aci].cw_max &
+			u4b_ac_param |= ((u32)cw_max &
 					 0xF) << AC_PARAM_ECW_MAX_OFFSET;
-			u4b_ac_param |= (u32) mac->ac[e_aci].tx_op
-			    << AC_PARAM_TXOP_LIMIT_OFFSET;
+			u4b_ac_param |= (u32)tx_op << AC_PARAM_TXOP_OFFSET;
 
 			RT_TRACE(rtlpriv, COMP_MLME, DBG_LOUD,
 				 ("queue:%x, ac_param:%x\n", e_aci,
@@ -1170,21 +1172,20 @@ void rtl92ce_set_qos(struct ieee80211_hw
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
-
 	u32 u4b_ac_param;
+	u16 cw_min = le16_to_cpu(mac->ac[aci].cw_min);
+	u16 cw_max = le16_to_cpu(mac->ac[aci].cw_max);
+	u16 tx_op = le16_to_cpu(mac->ac[aci].tx_op);
 
 	rtl92c_dm_init_edca_turbo(hw);
-
 	u4b_ac_param = (u32) mac->ac[aci].aifs;
-	u4b_ac_param |=
-	    ((u32) mac->ac[aci].cw_min & 0xF) << AC_PARAM_ECW_MIN_OFFSET;
-	u4b_ac_param |=
-	    ((u32) mac->ac[aci].cw_max & 0xF) << AC_PARAM_ECW_MAX_OFFSET;
-	u4b_ac_param |= (u32) mac->ac[aci].tx_op << AC_PARAM_TXOP_LIMIT_OFFSET;
+	u4b_ac_param |= (u32) ((cw_min & 0xF) << AC_PARAM_ECW_MIN_OFFSET);
+	u4b_ac_param |= (u32) ((cw_max & 0xF) << AC_PARAM_ECW_MAX_OFFSET);
+	u4b_ac_param |= (u32) (tx_op << AC_PARAM_TXOP_OFFSET);
 	RT_TRACE(rtlpriv, COMP_QOS, DBG_DMESG,
 		 ("queue:%x, ac_param:%x aifs:%x cwmin:%x cwmax:%x txop:%x\n",
-		  aci, u4b_ac_param, mac->ac[aci].aifs, mac->ac[aci].cw_min,
-		  mac->ac[aci].cw_max, mac->ac[aci].tx_op));
+		  aci, u4b_ac_param, mac->ac[aci].aifs, cw_min,
+		  cw_max, tx_op));
 	switch (aci) {
 	case AC1_BK:
 		rtl_write_dword(rtlpriv, REG_EDCA_BK_PARAM, u4b_ac_param);
@@ -1712,7 +1713,7 @@ void rtl92ce_update_hal_rate_table(struc
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 
 	u32 ratr_value = (u32) mac->basic_rates;
-	u8 *p_mcsrate = mac->mcs;
+	u8 *mcsrate = mac->mcs;
 	u8 ratr_index = 0;
 	u8 nmode = mac->ht_enable;
 	u8 mimo_ps = 1;
@@ -1723,7 +1724,7 @@ void rtl92ce_update_hal_rate_table(struc
 	u8 curshortgi_20mhz = mac->sgi_20;
 	enum wireless_mode wirelessmode = mac->mode;
 
-	ratr_value |= EF2BYTE((*(u16 *) (p_mcsrate))) << 12;
+	ratr_value |= ((*(u16 *) (mcsrate))) << 12;
 
 	switch (wirelessmode) {
 	case WIRELESS_MODE_B:
@@ -1892,8 +1893,8 @@ void rtl92ce_update_hal_rate_mask(struct
 	}
 	RT_TRACE(rtlpriv, COMP_RATR, DBG_DMESG,
 		 ("ratr_bitmap :%x\n", ratr_bitmap));
-	*(u32 *)&rate_mask = EF4BYTE((ratr_bitmap & 0x0fffffff) |
-				       (ratr_index << 28));
+	*(u32 *)&rate_mask = (ratr_bitmap & 0x0fffffff) |
+				       (ratr_index << 28);
 	rate_mask[4] = macid | (shortgi ? 0x20 : 0x00) | 0x80;
 	RT_TRACE(rtlpriv, COMP_RATR, DBG_DMESG, ("Rate_index:%x, "
 						 "ratr_val:%x, %x:%x:%x:%x:%x\n",
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
@@ -1076,7 +1076,6 @@
 #define _RARF_RC7(x)				(((x) & 0x1F) << 16)
 #define _RARF_RC8(x)				(((x) & 0x1F) << 24)
 
-#define AC_PARAM_TXOP_LIMIT_OFFSET		16
 #define AC_PARAM_TXOP_OFFSET			16
 #define AC_PARAM_ECW_MAX_OFFSET			12
 #define AC_PARAM_ECW_MIN_OFFSET			8
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
@@ -40,470 +40,494 @@
 #define USB_HWDESC_HEADER_LEN			32
 #define CRCLENGTH				4
 
+/* Define a macro that takes a le32 word, converts it to host ordering,
+ * right shifts by a specified count, creates a mask of the specified
+ * bit count, and extracts that number of bits.
+ */
+
+#define SHIFT_AND_MASK_LE(__pdesc, __shift, __mask)		\
+	((le32_to_cpu(*(((__le32 *)(__pdesc)))) >> (__shift)) &	\
+	BIT_LEN_MASK_32(__mask))
+
+/* Define a macro that clears a bit field in an le32 word and
+ * sets the specified value into that bit field. The resulting
+ * value remains in le32 ordering; however, it is properly converted
+ * to host ordering for the clear and set operations before conversion
+ * back to le32.
+ */
+
+#define SET_BITS_OFFSET_LE(__pdesc, __shift, __len, __val)	\
+	(*(__le32 *)(__pdesc) = 				\
+	(cpu_to_le32((le32_to_cpu(*((__le32 *)(__pdesc))) &	\
+	(~(BIT_OFFSET_LEN_MASK_32((__shift), __len)))) |		\
+	(((u32)(__val) & BIT_LEN_MASK_32(__len)) << (__shift)))));
+
+/* macros to read/write various fields in RX or TX descriptors */
+
 #define SET_TX_DESC_PKT_SIZE(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc, 0, 16, __val)
+	SET_BITS_OFFSET_LE(__pdesc, 0, 16, __val)
 #define SET_TX_DESC_OFFSET(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc, 16, 8, __val)
+	SET_BITS_OFFSET_LE(__pdesc, 16, 8, __val)
 #define SET_TX_DESC_BMC(__pdesc, __val)			\
-	SET_BITS_TO_LE_4BYTE(__pdesc, 24, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc, 24, 1, __val)
 #define SET_TX_DESC_HTC(__pdesc, __val)			\
-	SET_BITS_TO_LE_4BYTE(__pdesc, 25, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc, 25, 1, __val)
 #define SET_TX_DESC_LAST_SEG(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc, 26, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc, 26, 1, __val)
 #define SET_TX_DESC_FIRST_SEG(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc, 27, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc, 27, 1, __val)
 #define SET_TX_DESC_LINIP(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc, 28, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc, 28, 1, __val)
 #define SET_TX_DESC_NO_ACM(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc, 29, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc, 29, 1, __val)
 #define SET_TX_DESC_GF(__pdesc, __val)			\
-	SET_BITS_TO_LE_4BYTE(__pdesc, 30, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc, 30, 1, __val)
 #define SET_TX_DESC_OWN(__pdesc, __val)			\
-	SET_BITS_TO_LE_4BYTE(__pdesc, 31, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc, 31, 1, __val)
 
 #define GET_TX_DESC_PKT_SIZE(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc, 0, 16)
+	SHIFT_AND_MASK_LE(__pdesc, 0, 16)
 #define GET_TX_DESC_OFFSET(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc, 16, 8)
+	SHIFT_AND_MASK_LE(__pdesc, 16, 8)
 #define GET_TX_DESC_BMC(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc, 24, 1)
+	SHIFT_AND_MASK_LE(__pdesc, 24, 1)
 #define GET_TX_DESC_HTC(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc, 25, 1)
+	SHIFT_AND_MASK_LE(__pdesc, 25, 1)
 #define GET_TX_DESC_LAST_SEG(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc, 26, 1)
+	SHIFT_AND_MASK_LE(__pdesc, 26, 1)
 #define GET_TX_DESC_FIRST_SEG(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc, 27, 1)
+	SHIFT_AND_MASK_LE(__pdesc, 27, 1)
 #define GET_TX_DESC_LINIP(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc, 28, 1)
+	SHIFT_AND_MASK_LE(__pdesc, 28, 1)
 #define GET_TX_DESC_NO_ACM(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc, 29, 1)
+	SHIFT_AND_MASK_LE(__pdesc, 29, 1)
 #define GET_TX_DESC_GF(__pdesc)				\
-	LE_BITS_TO_4BYTE(__pdesc, 30, 1)
+	SHIFT_AND_MASK_LE(__pdesc, 30, 1)
 #define GET_TX_DESC_OWN(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc, 31, 1)
+	SHIFT_AND_MASK_LE(__pdesc, 31, 1)
 
 #define SET_TX_DESC_MACID(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+4, 0, 5, __val)
+	SET_BITS_OFFSET_LE(__pdesc+4, 0, 5, __val)
 #define SET_TX_DESC_AGG_BREAK(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+4, 5, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc+4, 5, 1, __val)
 #define SET_TX_DESC_BK(__pdesc, __val)			\
-	SET_BITS_TO_LE_4BYTE(__pdesc+4, 6, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc+4, 6, 1, __val)
 #define SET_TX_DESC_RDG_ENABLE(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+4, 7, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc+4, 7, 1, __val)
 #define SET_TX_DESC_QUEUE_SEL(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+4, 8, 5, __val)
+	SET_BITS_OFFSET_LE(__pdesc+4, 8, 5, __val)
 #define SET_TX_DESC_RDG_NAV_EXT(__pdesc, __val)	\
-	SET_BITS_TO_LE_4BYTE(__pdesc+4, 13, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc+4, 13, 1, __val)
 #define SET_TX_DESC_LSIG_TXOP_EN(__pdesc, __val)	\
-	SET_BITS_TO_LE_4BYTE(__pdesc+4, 14, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc+4, 14, 1, __val)
 #define SET_TX_DESC_PIFS(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+4, 15, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc+4, 15, 1, __val)
 #define SET_TX_DESC_RATE_ID(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+4, 16, 4, __val)
+	SET_BITS_OFFSET_LE(__pdesc+4, 16, 4, __val)
 #define SET_TX_DESC_NAV_USE_HDR(__pdesc, __val)	\
-	SET_BITS_TO_LE_4BYTE(__pdesc+4, 20, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc+4, 20, 1, __val)
 #define SET_TX_DESC_EN_DESC_ID(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+4, 21, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc+4, 21, 1, __val)
 #define SET_TX_DESC_SEC_TYPE(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+4, 22, 2, __val)
+	SET_BITS_OFFSET_LE(__pdesc+4, 22, 2, __val)
 #define SET_TX_DESC_PKT_OFFSET(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+4, 24, 8, __val)
+	SET_BITS_OFFSET_LE(__pdesc+4, 24, 8, __val)
 
 #define GET_TX_DESC_MACID(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+4, 0, 5)
+	SHIFT_AND_MASK_LE(__pdesc+4, 0, 5)
 #define GET_TX_DESC_AGG_ENABLE(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+4, 5, 1)
+	SHIFT_AND_MASK_LE(__pdesc+4, 5, 1)
 #define GET_TX_DESC_AGG_BREAK(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+4, 6, 1)
+	SHIFT_AND_MASK_LE(__pdesc+4, 6, 1)
 #define GET_TX_DESC_RDG_ENABLE(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+4, 7, 1)
+	SHIFT_AND_MASK_LE(__pdesc+4, 7, 1)
 #define GET_TX_DESC_QUEUE_SEL(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+4, 8, 5)
+	SHIFT_AND_MASK_LE(__pdesc+4, 8, 5)
 #define GET_TX_DESC_RDG_NAV_EXT(__pdesc)		\
-	LE_BITS_TO_4BYTE(__pdesc+4, 13, 1)
+	SHIFT_AND_MASK_LE(__pdesc+4, 13, 1)
 #define GET_TX_DESC_LSIG_TXOP_EN(__pdesc)		\
-	LE_BITS_TO_4BYTE(__pdesc+4, 14, 1)
+	SHIFT_AND_MASK_LE(__pdesc+4, 14, 1)
 #define GET_TX_DESC_PIFS(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+4, 15, 1)
+	SHIFT_AND_MASK_LE(__pdesc+4, 15, 1)
 #define GET_TX_DESC_RATE_ID(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+4, 16, 4)
+	SHIFT_AND_MASK_LE(__pdesc+4, 16, 4)
 #define GET_TX_DESC_NAV_USE_HDR(__pdesc)		\
-	LE_BITS_TO_4BYTE(__pdesc+4, 20, 1)
+	SHIFT_AND_MASK_LE(__pdesc+4, 20, 1)
 #define GET_TX_DESC_EN_DESC_ID(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+4, 21, 1)
+	SHIFT_AND_MASK_LE(__pdesc+4, 21, 1)
 #define GET_TX_DESC_SEC_TYPE(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+4, 22, 2)
+	SHIFT_AND_MASK_LE(__pdesc+4, 22, 2)
 #define GET_TX_DESC_PKT_OFFSET(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+4, 24, 8)
+	SHIFT_AND_MASK_LE(__pdesc+4, 24, 8)
 
 #define SET_TX_DESC_RTS_RC(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+8, 0, 6, __val)
+	SET_BITS_OFFSET_LE(__pdesc+8, 0, 6, __val)
 #define SET_TX_DESC_DATA_RC(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+8, 6, 6, __val)
+	SET_BITS_OFFSET_LE(__pdesc+8, 6, 6, __val)
 #define SET_TX_DESC_BAR_RTY_TH(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+8, 14, 2, __val)
+	SET_BITS_OFFSET_LE(__pdesc+8, 14, 2, __val)
 #define SET_TX_DESC_MORE_FRAG(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+8, 17, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc+8, 17, 1, __val)
 #define SET_TX_DESC_RAW(__pdesc, __val)			\
-	SET_BITS_TO_LE_4BYTE(__pdesc+8, 18, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc+8, 18, 1, __val)
 #define SET_TX_DESC_CCX(__pdesc, __val)			\
-	SET_BITS_TO_LE_4BYTE(__pdesc+8, 19, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc+8, 19, 1, __val)
 #define SET_TX_DESC_AMPDU_DENSITY(__pdesc, __val)	\
-	SET_BITS_TO_LE_4BYTE(__pdesc+8, 20, 3, __val)
+	SET_BITS_OFFSET_LE(__pdesc+8, 20, 3, __val)
 #define SET_TX_DESC_ANTSEL_A(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+8, 24, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc+8, 24, 1, __val)
 #define SET_TX_DESC_ANTSEL_B(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+8, 25, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc+8, 25, 1, __val)
 #define SET_TX_DESC_TX_ANT_CCK(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+8, 26, 2, __val)
+	SET_BITS_OFFSET_LE(__pdesc+8, 26, 2, __val)
 #define SET_TX_DESC_TX_ANTL(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+8, 28, 2, __val)
+	SET_BITS_OFFSET_LE(__pdesc+8, 28, 2, __val)
 #define SET_TX_DESC_TX_ANT_HT(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+8, 30, 2, __val)
+	SET_BITS_OFFSET_LE(__pdesc+8, 30, 2, __val)
 
 #define GET_TX_DESC_RTS_RC(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+8, 0, 6)
+	SHIFT_AND_MASK_LE(__pdesc+8, 0, 6)
 #define GET_TX_DESC_DATA_RC(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+8, 6, 6)
+	SHIFT_AND_MASK_LE(__pdesc+8, 6, 6)
 #define GET_TX_DESC_BAR_RTY_TH(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+8, 14, 2)
+	SHIFT_AND_MASK_LE(__pdesc+8, 14, 2)
 #define GET_TX_DESC_MORE_FRAG(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+8, 17, 1)
+	SHIFT_AND_MASK_LE(__pdesc+8, 17, 1)
 #define GET_TX_DESC_RAW(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+8, 18, 1)
+	SHIFT_AND_MASK_LE(__pdesc+8, 18, 1)
 #define GET_TX_DESC_CCX(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+8, 19, 1)
+	SHIFT_AND_MASK_LE(__pdesc+8, 19, 1)
 #define GET_TX_DESC_AMPDU_DENSITY(__pdesc)		\
-	LE_BITS_TO_4BYTE(__pdesc+8, 20, 3)
+	SHIFT_AND_MASK_LE(__pdesc+8, 20, 3)
 #define GET_TX_DESC_ANTSEL_A(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+8, 24, 1)
+	SHIFT_AND_MASK_LE(__pdesc+8, 24, 1)
 #define GET_TX_DESC_ANTSEL_B(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+8, 25, 1)
+	SHIFT_AND_MASK_LE(__pdesc+8, 25, 1)
 #define GET_TX_DESC_TX_ANT_CCK(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+8, 26, 2)
+	SHIFT_AND_MASK_LE(__pdesc+8, 26, 2)
 #define GET_TX_DESC_TX_ANTL(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+8, 28, 2)
+	SHIFT_AND_MASK_LE(__pdesc+8, 28, 2)
 #define GET_TX_DESC_TX_ANT_HT(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+8, 30, 2)
+	SHIFT_AND_MASK_LE(__pdesc+8, 30, 2)
 
 #define SET_TX_DESC_NEXT_HEAP_PAGE(__pdesc, __val)	\
-	SET_BITS_TO_LE_4BYTE(__pdesc+12, 0, 8, __val)
+	SET_BITS_OFFSET_LE(__pdesc+12, 0, 8, __val)
 #define SET_TX_DESC_TAIL_PAGE(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+12, 8, 8, __val)
+	SET_BITS_OFFSET_LE(__pdesc+12, 8, 8, __val)
 #define SET_TX_DESC_SEQ(__pdesc, __val)			\
-	SET_BITS_TO_LE_4BYTE(__pdesc+12, 16, 12, __val)
+	SET_BITS_OFFSET_LE(__pdesc+12, 16, 12, __val)
 #define SET_TX_DESC_PKT_ID(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+12, 28, 4, __val)
+	SET_BITS_OFFSET_LE(__pdesc+12, 28, 4, __val)
 
 #define GET_TX_DESC_NEXT_HEAP_PAGE(__pdesc)		\
-	LE_BITS_TO_4BYTE(__pdesc+12, 0, 8)
+	SHIFT_AND_MASK_LE(__pdesc+12, 0, 8)
 #define GET_TX_DESC_TAIL_PAGE(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+12, 8, 8)
+	SHIFT_AND_MASK_LE(__pdesc+12, 8, 8)
 #define GET_TX_DESC_SEQ(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+12, 16, 12)
+	SHIFT_AND_MASK_LE(__pdesc+12, 16, 12)
 #define GET_TX_DESC_PKT_ID(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+12, 28, 4)
+	SHIFT_AND_MASK_LE(__pdesc+12, 28, 4)
 
 #define SET_TX_DESC_RTS_RATE(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+16, 0, 5, __val)
+	SET_BITS_OFFSET_LE(__pdesc+16, 0, 5, __val)
 #define SET_TX_DESC_AP_DCFE(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+16, 5, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc+16, 5, 1, __val)
 #define SET_TX_DESC_QOS(__pdesc, __val)			\
-	SET_BITS_TO_LE_4BYTE(__pdesc+16, 6, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc+16, 6, 1, __val)
 #define SET_TX_DESC_HWSEQ_EN(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+16, 7, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc+16, 7, 1, __val)
 #define SET_TX_DESC_USE_RATE(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+16, 8, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc+16, 8, 1, __val)
 #define SET_TX_DESC_DISABLE_RTS_FB(__pdesc, __val)	\
-	SET_BITS_TO_LE_4BYTE(__pdesc+16, 9, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc+16, 9, 1, __val)
 #define SET_TX_DESC_DISABLE_FB(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+16, 10, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc+16, 10, 1, __val)
 #define SET_TX_DESC_CTS2SELF(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+16, 11, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc+16, 11, 1, __val)
 #define SET_TX_DESC_RTS_ENABLE(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+16, 12, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc+16, 12, 1, __val)
 #define SET_TX_DESC_HW_RTS_ENABLE(__pdesc, __val)	\
-	SET_BITS_TO_LE_4BYTE(__pdesc+16, 13, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc+16, 13, 1, __val)
 #define SET_TX_DESC_PORT_ID(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+16, 14, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc+16, 14, 1, __val)
 #define SET_TX_DESC_WAIT_DCTS(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+16, 18, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc+16, 18, 1, __val)
 #define SET_TX_DESC_CTS2AP_EN(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+16, 19, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc+16, 19, 1, __val)
 #define SET_TX_DESC_TX_SUB_CARRIER(__pdesc, __val)	\
-	SET_BITS_TO_LE_4BYTE(__pdesc+16, 20, 2, __val)
+	SET_BITS_OFFSET_LE(__pdesc+16, 20, 2, __val)
 #define SET_TX_DESC_TX_STBC(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+16, 22, 2, __val)
+	SET_BITS_OFFSET_LE(__pdesc+16, 22, 2, __val)
 #define SET_TX_DESC_DATA_SHORT(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+16, 24, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc+16, 24, 1, __val)
 #define SET_TX_DESC_DATA_BW(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+16, 25, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc+16, 25, 1, __val)
 #define SET_TX_DESC_RTS_SHORT(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+16, 26, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc+16, 26, 1, __val)
 #define SET_TX_DESC_RTS_BW(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+16, 27, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc+16, 27, 1, __val)
 #define SET_TX_DESC_RTS_SC(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+16, 28, 2, __val)
+	SET_BITS_OFFSET_LE(__pdesc+16, 28, 2, __val)
 #define SET_TX_DESC_RTS_STBC(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+16, 30, 2, __val)
+	SET_BITS_OFFSET_LE(__pdesc+16, 30, 2, __val)
 
 #define GET_TX_DESC_RTS_RATE(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+16, 0, 5)
+	SHIFT_AND_MASK_LE(__pdesc+16, 0, 5)
 #define GET_TX_DESC_AP_DCFE(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+16, 5, 1)
+	SHIFT_AND_MASK_LE(__pdesc+16, 5, 1)
 #define GET_TX_DESC_QOS(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+16, 6, 1)
+	SHIFT_AND_MASK_LE(__pdesc+16, 6, 1)
 #define GET_TX_DESC_HWSEQ_EN(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+16, 7, 1)
+	SHIFT_AND_MASK_LE(__pdesc+16, 7, 1)
 #define GET_TX_DESC_USE_RATE(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+16, 8, 1)
+	SHIFT_AND_MASK_LE(__pdesc+16, 8, 1)
 #define GET_TX_DESC_DISABLE_RTS_FB(__pdesc)		\
-	LE_BITS_TO_4BYTE(__pdesc+16, 9, 1)
+	SHIFT_AND_MASK_LE(__pdesc+16, 9, 1)
 #define GET_TX_DESC_DISABLE_FB(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+16, 10, 1)
+	SHIFT_AND_MASK_LE(__pdesc+16, 10, 1)
 #define GET_TX_DESC_CTS2SELF(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+16, 11, 1)
+	SHIFT_AND_MASK_LE(__pdesc+16, 11, 1)
 #define GET_TX_DESC_RTS_ENABLE(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+16, 12, 1)
+	SHIFT_AND_MASK_LE(__pdesc+16, 12, 1)
 #define GET_TX_DESC_HW_RTS_ENABLE(__pdesc)		\
-	LE_BITS_TO_4BYTE(__pdesc+16, 13, 1)
+	SHIFT_AND_MASK_LE(__pdesc+16, 13, 1)
 #define GET_TX_DESC_PORT_ID(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+16, 14, 1)
+	SHIFT_AND_MASK_LE(__pdesc+16, 14, 1)
 #define GET_TX_DESC_WAIT_DCTS(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+16, 18, 1)
+	SHIFT_AND_MASK_LE(__pdesc+16, 18, 1)
 #define GET_TX_DESC_CTS2AP_EN(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+16, 19, 1)
+	SHIFT_AND_MASK_LE(__pdesc+16, 19, 1)
 #define GET_TX_DESC_TX_SUB_CARRIER(__pdesc)		\
-	LE_BITS_TO_4BYTE(__pdesc+16, 20, 2)
+	SHIFT_AND_MASK_LE(__pdesc+16, 20, 2)
 #define GET_TX_DESC_TX_STBC(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+16, 22, 2)
+	SHIFT_AND_MASK_LE(__pdesc+16, 22, 2)
 #define GET_TX_DESC_DATA_SHORT(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+16, 24, 1)
+	SHIFT_AND_MASK_LE(__pdesc+16, 24, 1)
 #define GET_TX_DESC_DATA_BW(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+16, 25, 1)
+	SHIFT_AND_MASK_LE(__pdesc+16, 25, 1)
 #define GET_TX_DESC_RTS_SHORT(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+16, 26, 1)
+	SHIFT_AND_MASK_LE(__pdesc+16, 26, 1)
 #define GET_TX_DESC_RTS_BW(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+16, 27, 1)
+	SHIFT_AND_MASK_LE(__pdesc+16, 27, 1)
 #define GET_TX_DESC_RTS_SC(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+16, 28, 2)
+	SHIFT_AND_MASK_LE(__pdesc+16, 28, 2)
 #define GET_TX_DESC_RTS_STBC(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+16, 30, 2)
+	SHIFT_AND_MASK_LE(__pdesc+16, 30, 2)
 
 #define SET_TX_DESC_TX_RATE(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+20, 0, 6, __val)
+	SET_BITS_OFFSET_LE(__pdesc+20, 0, 6, __val)
 #define SET_TX_DESC_DATA_SHORTGI(__pdesc, __val)	\
-	SET_BITS_TO_LE_4BYTE(__pdesc+20, 6, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc+20, 6, 1, __val)
 #define SET_TX_DESC_CCX_TAG(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+20, 7, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc+20, 7, 1, __val)
 #define SET_TX_DESC_DATA_RATE_FB_LIMIT(__pdesc, __val)	\
-	SET_BITS_TO_LE_4BYTE(__pdesc+20, 8, 5, __val)
+	SET_BITS_OFFSET_LE(__pdesc+20, 8, 5, __val)
 #define SET_TX_DESC_RTS_RATE_FB_LIMIT(__pdesc, __val)	\
-	SET_BITS_TO_LE_4BYTE(__pdesc+20, 13, 4, __val)
+	SET_BITS_OFFSET_LE(__pdesc+20, 13, 4, __val)
 #define SET_TX_DESC_RETRY_LIMIT_ENABLE(__pdesc, __val)	\
-	SET_BITS_TO_LE_4BYTE(__pdesc+20, 17, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc+20, 17, 1, __val)
 #define SET_TX_DESC_DATA_RETRY_LIMIT(__pdesc, __val)	\
-	SET_BITS_TO_LE_4BYTE(__pdesc+20, 18, 6, __val)
+	SET_BITS_OFFSET_LE(__pdesc+20, 18, 6, __val)
 #define SET_TX_DESC_USB_TXAGG_NUM(__pdesc, __val)	\
-	SET_BITS_TO_LE_4BYTE(__pdesc+20, 24, 8, __val)
+	SET_BITS_OFFSET_LE(__pdesc+20, 24, 8, __val)
 
 #define GET_TX_DESC_TX_RATE(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+20, 0, 6)
+	SHIFT_AND_MASK_LE(__pdesc+20, 0, 6)
 #define GET_TX_DESC_DATA_SHORTGI(__pdesc)		\
-	LE_BITS_TO_4BYTE(__pdesc+20, 6, 1)
+	SHIFT_AND_MASK_LE(__pdesc+20, 6, 1)
 #define GET_TX_DESC_CCX_TAG(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+20, 7, 1)
+	SHIFT_AND_MASK_LE(__pdesc+20, 7, 1)
 #define GET_TX_DESC_DATA_RATE_FB_LIMIT(__pdesc)		\
-	LE_BITS_TO_4BYTE(__pdesc+20, 8, 5)
+	SHIFT_AND_MASK_LE(__pdesc+20, 8, 5)
 #define GET_TX_DESC_RTS_RATE_FB_LIMIT(__pdesc)		\
-	LE_BITS_TO_4BYTE(__pdesc+20, 13, 4)
+	SHIFT_AND_MASK_LE(__pdesc+20, 13, 4)
 #define GET_TX_DESC_RETRY_LIMIT_ENABLE(__pdesc)		\
-	LE_BITS_TO_4BYTE(__pdesc+20, 17, 1)
+	SHIFT_AND_MASK_LE(__pdesc+20, 17, 1)
 #define GET_TX_DESC_DATA_RETRY_LIMIT(__pdesc)		\
-	LE_BITS_TO_4BYTE(__pdesc+20, 18, 6)
+	SHIFT_AND_MASK_LE(__pdesc+20, 18, 6)
 #define GET_TX_DESC_USB_TXAGG_NUM(__pdesc)		\
-	LE_BITS_TO_4BYTE(__pdesc+20, 24, 8)
+	SHIFT_AND_MASK_LE(__pdesc+20, 24, 8)
 
 #define SET_TX_DESC_TXAGC_A(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+24, 0, 5, __val)
+	SET_BITS_OFFSET_LE(__pdesc+24, 0, 5, __val)
 #define SET_TX_DESC_TXAGC_B(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+24, 5, 5, __val)
+	SET_BITS_OFFSET_LE(__pdesc+24, 5, 5, __val)
 #define SET_TX_DESC_USE_MAX_LEN(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+24, 10, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc+24, 10, 1, __val)
 #define SET_TX_DESC_MAX_AGG_NUM(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+24, 11, 5, __val)
+	SET_BITS_OFFSET_LE(__pdesc+24, 11, 5, __val)
 #define SET_TX_DESC_MCSG1_MAX_LEN(__pdesc, __val)	\
-	SET_BITS_TO_LE_4BYTE(__pdesc+24, 16, 4, __val)
+	SET_BITS_OFFSET_LE(__pdesc+24, 16, 4, __val)
 #define SET_TX_DESC_MCSG2_MAX_LEN(__pdesc, __val)	\
-	SET_BITS_TO_LE_4BYTE(__pdesc+24, 20, 4, __val)
+	SET_BITS_OFFSET_LE(__pdesc+24, 20, 4, __val)
 #define SET_TX_DESC_MCSG3_MAX_LEN(__pdesc, __val)	\
-	SET_BITS_TO_LE_4BYTE(__pdesc+24, 24, 4, __val)
+	SET_BITS_OFFSET_LE(__pdesc+24, 24, 4, __val)
 #define SET_TX_DESC_MCS7_SGI_MAX_LEN(__pdesc, __val)	\
-	SET_BITS_TO_LE_4BYTE(__pdesc+24, 28, 4, __val)
+	SET_BITS_OFFSET_LE(__pdesc+24, 28, 4, __val)
 
 #define GET_TX_DESC_TXAGC_A(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+24, 0, 5)
+	SHIFT_AND_MASK_LE(__pdesc+24, 0, 5)
 #define GET_TX_DESC_TXAGC_B(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+24, 5, 5)
+	SHIFT_AND_MASK_LE(__pdesc+24, 5, 5)
 #define GET_TX_DESC_USE_MAX_LEN(__pdesc)		\
-	LE_BITS_TO_4BYTE(__pdesc+24, 10, 1)
+	SHIFT_AND_MASK_LE(__pdesc+24, 10, 1)
 #define GET_TX_DESC_MAX_AGG_NUM(__pdesc)		\
-	LE_BITS_TO_4BYTE(__pdesc+24, 11, 5)
+	SHIFT_AND_MASK_LE(__pdesc+24, 11, 5)
 #define GET_TX_DESC_MCSG1_MAX_LEN(__pdesc)		\
-	LE_BITS_TO_4BYTE(__pdesc+24, 16, 4)
+	SHIFT_AND_MASK_LE(__pdesc+24, 16, 4)
 #define GET_TX_DESC_MCSG2_MAX_LEN(__pdesc)		\
-	LE_BITS_TO_4BYTE(__pdesc+24, 20, 4)
+	SHIFT_AND_MASK_LE(__pdesc+24, 20, 4)
 #define GET_TX_DESC_MCSG3_MAX_LEN(__pdesc)		\
-	LE_BITS_TO_4BYTE(__pdesc+24, 24, 4)
+	SHIFT_AND_MASK_LE(__pdesc+24, 24, 4)
 #define GET_TX_DESC_MCS7_SGI_MAX_LEN(__pdesc)		\
-	LE_BITS_TO_4BYTE(__pdesc+24, 28, 4)
+	SHIFT_AND_MASK_LE(__pdesc+24, 28, 4)
 
 #define SET_TX_DESC_TX_BUFFER_SIZE(__pdesc, __val)	\
-	SET_BITS_TO_LE_4BYTE(__pdesc+28, 0, 16, __val)
+	SET_BITS_OFFSET_LE(__pdesc+28, 0, 16, __val)
 #define SET_TX_DESC_MCSG4_MAX_LEN(__pdesc, __val)	\
-	SET_BITS_TO_LE_4BYTE(__pdesc+28, 16, 4, __val)
+	SET_BITS_OFFSET_LE(__pdesc+28, 16, 4, __val)
 #define SET_TX_DESC_MCSG5_MAX_LEN(__pdesc, __val)	\
-	SET_BITS_TO_LE_4BYTE(__pdesc+28, 20, 4, __val)
+	SET_BITS_OFFSET_LE(__pdesc+28, 20, 4, __val)
 #define SET_TX_DESC_MCSG6_MAX_LEN(__pdesc, __val)	\
-	SET_BITS_TO_LE_4BYTE(__pdesc+28, 24, 4, __val)
+	SET_BITS_OFFSET_LE(__pdesc+28, 24, 4, __val)
 #define SET_TX_DESC_MCS15_SGI_MAX_LEN(__pdesc, __val)	\
-	SET_BITS_TO_LE_4BYTE(__pdesc+28, 28, 4, __val)
+	SET_BITS_OFFSET_LE(__pdesc+28, 28, 4, __val)
 
 #define GET_TX_DESC_TX_BUFFER_SIZE(__pdesc)		\
-	LE_BITS_TO_4BYTE(__pdesc+28, 0, 16)
+	SHIFT_AND_MASK_LE(__pdesc+28, 0, 16)
 #define GET_TX_DESC_MCSG4_MAX_LEN(__pdesc)		\
-	LE_BITS_TO_4BYTE(__pdesc+28, 16, 4)
+	SHIFT_AND_MASK_LE(__pdesc+28, 16, 4)
 #define GET_TX_DESC_MCSG5_MAX_LEN(__pdesc)		\
-	LE_BITS_TO_4BYTE(__pdesc+28, 20, 4)
+	SHIFT_AND_MASK_LE(__pdesc+28, 20, 4)
 #define GET_TX_DESC_MCSG6_MAX_LEN(__pdesc)		\
-	LE_BITS_TO_4BYTE(__pdesc+28, 24, 4)
+	SHIFT_AND_MASK_LE(__pdesc+28, 24, 4)
 #define GET_TX_DESC_MCS15_SGI_MAX_LEN(__pdesc)		\
-	LE_BITS_TO_4BYTE(__pdesc+28, 28, 4)
+	SHIFT_AND_MASK_LE(__pdesc+28, 28, 4)
 
 #define SET_TX_DESC_TX_BUFFER_ADDRESS(__pdesc, __val)	\
-	SET_BITS_TO_LE_4BYTE(__pdesc+32, 0, 32, __val)
+	SET_BITS_OFFSET_LE(__pdesc+32, 0, 32, __val)
 #define SET_TX_DESC_TX_BUFFER_ADDRESS64(__pdesc, __val) \
-	SET_BITS_TO_LE_4BYTE(__pdesc+36, 0, 32, __val)
+	SET_BITS_OFFSET_LE(__pdesc+36, 0, 32, __val)
 
 #define GET_TX_DESC_TX_BUFFER_ADDRESS(__pdesc)		\
-	LE_BITS_TO_4BYTE(__pdesc+32, 0, 32)
+	SHIFT_AND_MASK_LE(__pdesc+32, 0, 32)
 #define GET_TX_DESC_TX_BUFFER_ADDRESS64(__pdesc)	\
-	LE_BITS_TO_4BYTE(__pdesc+36, 0, 32)
+	SHIFT_AND_MASK_LE(__pdesc+36, 0, 32)
 
 #define SET_TX_DESC_NEXT_DESC_ADDRESS(__pdesc, __val)	\
-	SET_BITS_TO_LE_4BYTE(__pdesc+40, 0, 32, __val)
+	SET_BITS_OFFSET_LE(__pdesc+40, 0, 32, __val)
 #define SET_TX_DESC_NEXT_DESC_ADDRESS64(__pdesc, __val) \
-	SET_BITS_TO_LE_4BYTE(__pdesc+44, 0, 32, __val)
+	SET_BITS_OFFSET_LE(__pdesc+44, 0, 32, __val)
 
 #define GET_TX_DESC_NEXT_DESC_ADDRESS(__pdesc)		\
-	LE_BITS_TO_4BYTE(__pdesc+40, 0, 32)
+	SHIFT_AND_MASK_LE(__pdesc+40, 0, 32)
 #define GET_TX_DESC_NEXT_DESC_ADDRESS64(__pdesc)	\
-	LE_BITS_TO_4BYTE(__pdesc+44, 0, 32)
+	SHIFT_AND_MASK_LE(__pdesc+44, 0, 32)
 
 #define GET_RX_DESC_PKT_LEN(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc, 0, 14)
+	SHIFT_AND_MASK_LE(__pdesc, 0, 14)
 #define GET_RX_DESC_CRC32(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc, 14, 1)
+	SHIFT_AND_MASK_LE(__pdesc, 14, 1)
 #define GET_RX_DESC_ICV(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc, 15, 1)
+	SHIFT_AND_MASK_LE(__pdesc, 15, 1)
 #define GET_RX_DESC_DRV_INFO_SIZE(__pdesc)		\
-	LE_BITS_TO_4BYTE(__pdesc, 16, 4)
+	SHIFT_AND_MASK_LE(__pdesc, 16, 4)
 #define GET_RX_DESC_SECURITY(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc, 20, 3)
+	SHIFT_AND_MASK_LE(__pdesc, 20, 3)
 #define GET_RX_DESC_QOS(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc, 23, 1)
+	SHIFT_AND_MASK_LE(__pdesc, 23, 1)
 #define GET_RX_DESC_SHIFT(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc, 24, 2)
+	SHIFT_AND_MASK_LE(__pdesc, 24, 2)
 #define GET_RX_DESC_PHYST(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc, 26, 1)
+	SHIFT_AND_MASK_LE(__pdesc, 26, 1)
 #define GET_RX_DESC_SWDEC(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc, 27, 1)
+	SHIFT_AND_MASK_LE(__pdesc, 27, 1)
 #define GET_RX_DESC_LS(__pdesc)				\
-	LE_BITS_TO_4BYTE(__pdesc, 28, 1)
+	SHIFT_AND_MASK_LE(__pdesc, 28, 1)
 #define GET_RX_DESC_FS(__pdesc)				\
-	LE_BITS_TO_4BYTE(__pdesc, 29, 1)
+	SHIFT_AND_MASK_LE(__pdesc, 29, 1)
 #define GET_RX_DESC_EOR(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc, 30, 1)
+	SHIFT_AND_MASK_LE(__pdesc, 30, 1)
 #define GET_RX_DESC_OWN(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc, 31, 1)
+	SHIFT_AND_MASK_LE(__pdesc, 31, 1)
 
 #define SET_RX_DESC_PKT_LEN(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc, 0, 14, __val)
+	SET_BITS_OFFSET_LE(__pdesc, 0, 14, __val)
 #define SET_RX_DESC_EOR(__pdesc, __val)			\
-	SET_BITS_TO_LE_4BYTE(__pdesc, 30, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc, 30, 1, __val)
 #define SET_RX_DESC_OWN(__pdesc, __val)			\
-	SET_BITS_TO_LE_4BYTE(__pdesc, 31, 1, __val)
+	SET_BITS_OFFSET_LE(__pdesc, 31, 1, __val)
 
 #define GET_RX_DESC_MACID(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+4, 0, 5)
+	SHIFT_AND_MASK_LE(__pdesc+4, 0, 5)
 #define GET_RX_DESC_TID(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+4, 5, 4)
+	SHIFT_AND_MASK_LE(__pdesc+4, 5, 4)
 #define GET_RX_DESC_HWRSVD(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+4, 9, 5)
+	SHIFT_AND_MASK_LE(__pdesc+4, 9, 5)
 #define GET_RX_DESC_PAGGR(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+4, 14, 1)
+	SHIFT_AND_MASK_LE(__pdesc+4, 14, 1)
 #define GET_RX_DESC_FAGGR(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+4, 15, 1)
+	SHIFT_AND_MASK_LE(__pdesc+4, 15, 1)
 #define GET_RX_DESC_A1_FIT(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+4, 16, 4)
+	SHIFT_AND_MASK_LE(__pdesc+4, 16, 4)
 #define GET_RX_DESC_A2_FIT(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+4, 20, 4)
+	SHIFT_AND_MASK_LE(__pdesc+4, 20, 4)
 #define GET_RX_DESC_PAM(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+4, 24, 1)
+	SHIFT_AND_MASK_LE(__pdesc+4, 24, 1)
 #define GET_RX_DESC_PWR(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+4, 25, 1)
+	SHIFT_AND_MASK_LE(__pdesc+4, 25, 1)
 #define GET_RX_DESC_MD(__pdesc)				\
-	LE_BITS_TO_4BYTE(__pdesc+4, 26, 1)
+	SHIFT_AND_MASK_LE(__pdesc+4, 26, 1)
 #define GET_RX_DESC_MF(__pdesc)				\
-	LE_BITS_TO_4BYTE(__pdesc+4, 27, 1)
+	SHIFT_AND_MASK_LE(__pdesc+4, 27, 1)
 #define GET_RX_DESC_TYPE(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+4, 28, 2)
+	SHIFT_AND_MASK_LE(__pdesc+4, 28, 2)
 #define GET_RX_DESC_MC(__pdesc)				\
-	LE_BITS_TO_4BYTE(__pdesc+4, 30, 1)
+	SHIFT_AND_MASK_LE(__pdesc+4, 30, 1)
 #define GET_RX_DESC_BC(__pdesc)				\
-	LE_BITS_TO_4BYTE(__pdesc+4, 31, 1)
+	SHIFT_AND_MASK_LE(__pdesc+4, 31, 1)
 #define GET_RX_DESC_SEQ(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+8, 0, 12)
+	SHIFT_AND_MASK_LE(__pdesc+8, 0, 12)
 #define GET_RX_DESC_FRAG(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+8, 12, 4)
+	SHIFT_AND_MASK_LE(__pdesc+8, 12, 4)
 #define GET_RX_DESC_NEXT_PKT_LEN(__pdesc)		\
-	LE_BITS_TO_4BYTE(__pdesc+8, 16, 14)
+	SHIFT_AND_MASK_LE(__pdesc+8, 16, 14)
 #define GET_RX_DESC_NEXT_IND(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+8, 30, 1)
+	SHIFT_AND_MASK_LE(__pdesc+8, 30, 1)
 #define GET_RX_DESC_RSVD(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+8, 31, 1)
+	SHIFT_AND_MASK_LE(__pdesc+8, 31, 1)
 
 #define GET_RX_DESC_RXMCS(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+12, 0, 6)
+	SHIFT_AND_MASK_LE(__pdesc+12, 0, 6)
 #define GET_RX_DESC_RXHT(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+12, 6, 1)
+	SHIFT_AND_MASK_LE(__pdesc+12, 6, 1)
 #define GET_RX_DESC_SPLCP(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+12, 8, 1)
+	SHIFT_AND_MASK_LE(__pdesc+12, 8, 1)
 #define GET_RX_DESC_BW(__pdesc)				\
-	LE_BITS_TO_4BYTE(__pdesc+12, 9, 1)
+	SHIFT_AND_MASK_LE(__pdesc+12, 9, 1)
 #define GET_RX_DESC_HTC(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+12, 10, 1)
+	SHIFT_AND_MASK_LE(__pdesc+12, 10, 1)
 #define GET_RX_DESC_HWPC_ERR(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+12, 14, 1)
+	SHIFT_AND_MASK_LE(__pdesc+12, 14, 1)
 #define GET_RX_DESC_HWPC_IND(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+12, 15, 1)
+	SHIFT_AND_MASK_LE(__pdesc+12, 15, 1)
 #define GET_RX_DESC_IV0(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+12, 16, 16)
+	SHIFT_AND_MASK_LE(__pdesc+12, 16, 16)
 
 #define GET_RX_DESC_IV1(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+16, 0, 32)
+	SHIFT_AND_MASK_LE(__pdesc+16, 0, 32)
 #define GET_RX_DESC_TSFL(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+20, 0, 32)
+	SHIFT_AND_MASK_LE(__pdesc+20, 0, 32)
 
 #define GET_RX_DESC_BUFF_ADDR(__pdesc)			\
-	LE_BITS_TO_4BYTE(__pdesc+24, 0, 32)
+	SHIFT_AND_MASK_LE(__pdesc+24, 0, 32)
 #define GET_RX_DESC_BUFF_ADDR64(__pdesc)		\
-	LE_BITS_TO_4BYTE(__pdesc+28, 0, 32)
+	SHIFT_AND_MASK_LE(__pdesc+28, 0, 32)
 
 #define SET_RX_DESC_BUFF_ADDR(__pdesc, __val)		\
-	SET_BITS_TO_LE_4BYTE(__pdesc+24, 0, 32, __val)
+	SET_BITS_OFFSET_LE(__pdesc+24, 0, 32, __val)
 #define SET_RX_DESC_BUFF_ADDR64(__pdesc, __val) 	\
-	SET_BITS_TO_LE_4BYTE(__pdesc+28, 0, 32, __val)
+	SET_BITS_OFFSET_LE(__pdesc+28, 0, 32, __val)
 
 #define CLEAR_PCI_TX_DESC_CONTENT(__pdesc, _size)	\
 do {							\
