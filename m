Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49150 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758664Ab1DYSXR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 14:23:17 -0400
Date: Mon, 25 Apr 2011 13:23:15 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	chaoming_li@realsil.com.cn
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 06/18] rtlwifi: Convert pci routines for addition of
 rtl8192se and rtl8192de
Message-ID: <4db5bc13.P1Z2TU7/kW0t9z68%Larry.Finger@lwfinger.net> (sfid-20110425_202321_280963_DFF1B74B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaoming_Li <chaoming_li@realsil.com.cn>

Convert pci routines for addition of RTL8192SE and RTL8192DE code
These changes allow the upper-level driver to specify the BAR to be
used as it is different for rtl8192se than for the others.

Signed-off-by: Chaoming_Li <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 pci.c |  787 +++++++++++++++++++++++++++++++++++++++++++++++-------------------
 pci.h |   16 +
 ps.c  |    4 
 3 files changed, 579 insertions(+), 228 deletions(-)
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/pci.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/pci.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/pci.c
@@ -32,6 +32,7 @@
 #include "pci.h"
 #include "base.h"
 #include "ps.h"
+#include "efuse.h"
 
 static const u16 pcibridge_vendors[PCI_BRIDGE_VENDOR_MAX] = {
 	INTEL_VENDOR_ID,
@@ -40,6 +41,31 @@ static const u16 pcibridge_vendors[PCI_B
 	SIS_VENDOR_ID
 };
 
+static const u8 ac_to_hwq[] = {
+	VO_QUEUE,
+	VI_QUEUE,
+	BE_QUEUE,
+	BK_QUEUE
+};
+
+u8 _rtl_mac_to_hwqueue(struct ieee80211_hw *hw,
+		       struct sk_buff *skb)
+{
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	u16 fc = rtl_get_fc(skb);
+	u8 queue_index = skb_get_queue_mapping(skb);
+
+	if (unlikely(ieee80211_is_beacon(fc)))
+		return BEACON_QUEUE;
+	if (ieee80211_is_mgmt(fc))
+		return MGNT_QUEUE;
+	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8192SE)
+		if (ieee80211_is_nullfunc(fc))
+			return HIGH_QUEUE;
+
+	return ac_to_hwq[queue_index];
+}
+
 /* Update PCI dependent default settings*/
 static void _rtl_pci_update_default_setting(struct ieee80211_hw *hw)
 {
@@ -48,6 +74,7 @@ static void _rtl_pci_update_default_sett
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	u8 pcibridge_vendor = pcipriv->ndis_adapter.pcibridge_vendor;
+	u8 init_aspm;
 
 	ppsc->reg_rfps_level = 0;
 	ppsc->support_aspm = 0;
@@ -113,25 +140,110 @@ static void _rtl_pci_update_default_sett
 
 	/*Set HW definition to determine if it supports ASPM. */
 	switch (rtlpci->const_support_pciaspm) {
-	case 0:
-		/*Not support ASPM. */
-		ppsc->support_aspm = false;
-		break;
-	case 1:
-		/*Support ASPM. */
-		ppsc->support_aspm = true;
-		ppsc->support_backdoor = true;
-		break;
+	case 0:{
+			/*Not support ASPM. */
+			bool support_aspm = false;
+			ppsc->support_aspm = support_aspm;
+			break;
+		}
+	case 1:{
+			/*Support ASPM. */
+			bool support_aspm = true;
+			bool support_backdoor = true;
+			ppsc->support_aspm = support_aspm;
+
+			/*if (priv->oem_id == RT_CID_TOSHIBA &&
+			   !priv->ndis_adapter.amd_l1_patch)
+			   support_backdoor = false; */
+
+			ppsc->support_backdoor = support_backdoor;
+
+			break;
+		}
 	case 2:
 		/*ASPM value set by chipset. */
-		if (pcibridge_vendor == PCI_BRIDGE_VENDOR_INTEL)
-			ppsc->support_aspm = true;
+		if (pcibridge_vendor == PCI_BRIDGE_VENDOR_INTEL) {
+			bool support_aspm = true;
+			ppsc->support_aspm = support_aspm;
+		}
 		break;
 	default:
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 ("switch case not process\n"));
 		break;
 	}
+
+	/* toshiba aspm issue, toshiba will set aspm selfly
+	 * so we should not set aspm in driver */
+	pci_read_config_byte(rtlpci->pdev, 0x80, &init_aspm);
+	if (rtlpriv->rtlhal.hw_type == HARDWARE_TYPE_RTL8192SE &&
+		init_aspm == 0x43)
+		ppsc->support_aspm = false;
+}
+
+/*Disable L0s dirtectly. We will disable host L0s by default. */
+void rtl_pci_disable_host_l0s(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
+	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
+	u8 pcibridge_busnum = pcipriv->ndis_adapter.pcibridge_busnum;
+	u8 pcibridge_devnum = pcipriv->ndis_adapter.pcibridge_devnum;
+	u8 pcibridge_funcnum = pcipriv->ndis_adapter.pcibridge_funcnum;
+	u32 pcicfg_addrport = pcipriv->ndis_adapter.pcicfg_addrport;
+	u8 num4bytes = pcipriv->ndis_adapter.num4bytes;
+	u8 u_pcibridge_aspmsetting = 0;
+
+	/*Read  Link Control Register */
+	rtl_pci_raw_write_port_ulong(PCI_CONF_ADDRESS,
+				     pcicfg_addrport + (num4bytes << 2));
+	rtl_pci_raw_read_port_uchar(PCI_CONF_DATA, &u_pcibridge_aspmsetting);
+
+	if (u_pcibridge_aspmsetting & BIT(0))
+		u_pcibridge_aspmsetting &= ~(BIT(0));
+
+	rtl_pci_raw_write_port_ulong(PCI_CONF_ADDRESS,
+				     pcicfg_addrport + (num4bytes << 2));
+	rtl_pci_raw_write_port_uchar(PCI_CONF_DATA, u_pcibridge_aspmsetting);
+
+	udelay(50);
+
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+		 ("PciBridge busnumber[%x], DevNumbe[%x], "
+		  "funcnumber[%x], Write reg[%x] = %lx\n",
+		  pcibridge_busnum, pcibridge_devnum, pcibridge_funcnum,
+		  (pcipriv->ndis_adapter.pcibridge_pciehdr_offset + 0x10),
+		  (pcipriv->ndis_adapter.pcibridge_linkctrlreg |
+		   (rtlpci->const_devicepci_aspm_setting & ~BIT(0)))));
+}
+
+/*Enable rtl8192ce backdoor to control ASPM and clock request.*/
+bool rtl_pci_enable_back_door(struct ieee80211_hw *hw)
+{
+	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
+	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
+	u8 pcibridge_vendor = pcipriv->ndis_adapter.pcibridge_vendor;
+	bool bresult = true;
+	u8 value;
+
+	pci_read_config_byte(rtlpci->pdev, 0x70f, &value);
+
+	/*0x70f BIT(7) is used to control L0S */
+	if (pcibridge_vendor == PCI_BRIDGE_VENDOR_INTEL) {
+		value |= BIT(7);
+	} else {
+		/*Set 0x70f to 0x23 when non-Intel platform. */
+		value = 0x23;
+	}
+
+	pci_write_config_byte(rtlpci->pdev, 0x70f, value);
+
+	pci_read_config_byte(rtlpci->pdev, 0x719, &value);
+	/*0x719 BIT(3) is for L1 BIT(4) is for clock request */
+	value |= (BIT(3) | BIT(4));
+	pci_write_config_byte(rtlpci->pdev, 0x719, value);
+
+	return bresult;
 }
 
 static bool _rtl_pci_platform_switch_device_pci_aspm(
@@ -139,8 +251,11 @@ static bool _rtl_pci_platform_switch_dev
 			u8 value)
 {
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+
+	if (rtlhal->hw_type != HARDWARE_TYPE_RTL8192SE)
+		value |= 0x40;
 
-	value |= 0x40;
 	pci_write_config_byte(rtlpci->pdev, 0x80, value);
 
 	return false;
@@ -150,11 +265,13 @@ static bool _rtl_pci_platform_switch_dev
 static bool _rtl_pci_switch_clk_req(struct ieee80211_hw *hw, u8 value)
 {
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-	u8 buffer;
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 
-	buffer = value;
 	pci_write_config_byte(rtlpci->pdev, 0x81, value);
 
+	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8192SE)
+		udelay(100);
+
 	return true;
 }
 
@@ -175,6 +292,9 @@ static void rtl_pci_disable_aspm(struct
 	u16 aspmlevel = 0;
 	u8 tmp_u1b = 0;
 
+	if (!ppsc->support_aspm)
+		return;
+
 	if (pcibridge_vendor == PCI_BRIDGE_VENDOR_UNKNOWN) {
 		RT_TRACE(rtlpriv, COMP_POWER, DBG_TRACE,
 			 ("PCI(Bridge) UNKNOWN.\n"));
@@ -228,6 +348,9 @@ static void rtl_pci_enable_aspm(struct i
 	u8 u_pcibridge_aspmsetting;
 	u8 u_device_aspmsetting;
 
+	if (!ppsc->support_aspm)
+		return;
+
 	if (pcibridge_vendor == PCI_BRIDGE_VENDOR_UNKNOWN) {
 		RT_TRACE(rtlpriv, COMP_POWER, DBG_TRACE,
 			 ("PCI(Bridge) UNKNOWN.\n"));
@@ -272,7 +395,7 @@ static void rtl_pci_enable_aspm(struct i
 					     RT_RF_OFF_LEVL_CLK_REQ) ? 1 : 0);
 		RT_SET_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_CLK_REQ);
 	}
-	udelay(200);
+	udelay(100);
 }
 
 static bool rtl_pci_get_amd_l1_patch(struct ieee80211_hw *hw)
@@ -303,19 +426,19 @@ static bool rtl_pci_get_amd_l1_patch(str
 	return status;
 }
 
-static void rtl_pci_get_linkcontrol_field(struct ieee80211_hw *hw)
+void rtl_pci_get_linkcontrol_field(struct ieee80211_hw *hw)
 {
 	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
 	u8 capabilityoffset = pcipriv->ndis_adapter.pcibridge_pciehdr_offset;
 	u32 pcicfg_addrport = pcipriv->ndis_adapter.pcicfg_addrport;
 	u8 linkctrl_reg;
-	u8 num4bBytes;
+	u8 num4bbytes;
 
-	num4bBytes = (capabilityoffset + 0x10) / 4;
+	num4bbytes = (capabilityoffset + 0x10) / 4;
 
 	/*Read  Link Control Register */
 	rtl_pci_raw_write_port_ulong(PCI_CONF_ADDRESS,
-				     pcicfg_addrport + (num4bBytes << 2));
+				     pcicfg_addrport + (num4bbytes << 2));
 	rtl_pci_raw_read_port_uchar(PCI_CONF_DATA, &linkctrl_reg);
 
 	pcipriv->ndis_adapter.pcibridge_linkctrlreg = linkctrl_reg;
@@ -348,7 +471,7 @@ static void rtl_pci_parse_configuration(
 	pci_write_config_byte(pdev, 0x70f, tmp);
 }
 
-static void _rtl_pci_initialize_adapter_common(struct ieee80211_hw *hw)
+static void rtl_pci_init_aspm(struct ieee80211_hw *hw)
 {
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 
@@ -362,52 +485,6 @@ static void _rtl_pci_initialize_adapter_
 
 }
 
-static void rtl_pci_init_aspm(struct ieee80211_hw *hw)
-{
-	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-
-	/*close ASPM for AMD defaultly */
-	rtlpci->const_amdpci_aspm = 0;
-
-	/*
-	 * ASPM PS mode.
-	 * 0 - Disable ASPM,
-	 * 1 - Enable ASPM without Clock Req,
-	 * 2 - Enable ASPM with Clock Req,
-	 * 3 - Always Enable ASPM with Clock Req,
-	 * 4 - Always Enable ASPM without Clock Req.
-	 * set defult to RTL8192CE:3 RTL8192E:2
-	 * */
-	rtlpci->const_pci_aspm = 3;
-
-	/*Setting for PCI-E device */
-	rtlpci->const_devicepci_aspm_setting = 0x03;
-
-	/*Setting for PCI-E bridge */
-	rtlpci->const_hostpci_aspm_setting = 0x02;
-
-	/*
-	 * In Hw/Sw Radio Off situation.
-	 * 0 - Default,
-	 * 1 - From ASPM setting without low Mac Pwr,
-	 * 2 - From ASPM setting with low Mac Pwr,
-	 * 3 - Bus D3
-	 * set default to RTL8192CE:0 RTL8192SE:2
-	 */
-	rtlpci->const_hwsw_rfoff_d3 = 0;
-
-	/*
-	 * This setting works for those device with
-	 * backdoor ASPM setting such as EPHY setting.
-	 * 0 - Not support ASPM,
-	 * 1 - Support ASPM,
-	 * 2 - According to chipset.
-	 */
-	rtlpci->const_support_pciaspm = 1;
-
-	_rtl_pci_initialize_adapter_common(hw);
-}
-
 static void _rtl_pci_io_handler_init(struct device *dev,
 				     struct ieee80211_hw *hw)
 {
@@ -429,6 +506,92 @@ static void _rtl_pci_io_handler_release(
 {
 }
 
+static bool _rtl_update_earlymode_info(struct ieee80211_hw *hw,
+		struct sk_buff *skb, struct rtl_tcb_desc *tcb_desc, u8 tid)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	u8 additionlen = FCS_LEN;
+	struct sk_buff *next_skb;
+
+	/* here open is 4, wep/tkip is 8, aes is 12*/
+	if (info->control.hw_key)
+		additionlen += info->control.hw_key->icv_len;
+
+	/* The most skb num is 6 */
+	tcb_desc->empkt_num = 0;
+	spin_lock_bh(&rtlpriv->locks.waitq_lock);
+	skb_queue_walk(&rtlpriv->mac80211.skb_waitq[tid], next_skb) {
+		struct ieee80211_tx_info *next_info;
+
+		next_info = IEEE80211_SKB_CB(next_skb);
+		if (next_info->flags & IEEE80211_TX_CTL_AMPDU) {
+			tcb_desc->empkt_len[tcb_desc->empkt_num] =
+				next_skb->len + additionlen;
+			tcb_desc->empkt_num++;
+		} else {
+			break;
+		}
+
+		if (skb_queue_is_last(&rtlpriv->mac80211.skb_waitq[tid],
+				      next_skb))
+			break;
+
+		if (tcb_desc->empkt_num >= 5)
+			break;
+	}
+	spin_unlock_bh(&rtlpriv->locks.waitq_lock);
+
+	return true;
+}
+
+/* just for early mode now */
+static void _rtl_pci_tx_chk_waitq(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
+	struct sk_buff *skb = NULL;
+	struct ieee80211_tx_info *info = NULL;
+	int tid; /* should be int */
+
+	if (!rtlpriv->rtlhal.earlymode_enable)
+		return;
+
+	/* we juse use em for BE/BK/VI/VO */
+	for (tid = 7; tid >= 0; tid--) {
+		u8 hw_queue = ac_to_hwq[rtl_tid_to_ac(hw, tid)];
+		struct rtl8192_tx_ring *ring = &rtlpci->tx_ring[hw_queue];
+		while (!mac->act_scanning &&
+		       rtlpriv->psc.rfpwr_state == ERFON) {
+			struct rtl_tcb_desc tcb_desc;
+			memset(&tcb_desc, 0, sizeof(struct rtl_tcb_desc));
+
+			spin_lock_bh(&rtlpriv->locks.waitq_lock);
+			if (!skb_queue_empty(&mac->skb_waitq[tid]) &&
+			   (ring->entries - skb_queue_len(&ring->queue) > 5)) {
+				skb = skb_dequeue(&mac->skb_waitq[tid]);
+			} else {
+				spin_unlock_bh(&rtlpriv->locks.waitq_lock);
+				break;
+			}
+			spin_unlock_bh(&rtlpriv->locks.waitq_lock);
+
+			/* Some macaddr can't do early mode. like
+			 * multicast/broadcast/no_qos data */
+			info = IEEE80211_SKB_CB(skb);
+			if (info->flags & IEEE80211_TX_CTL_AMPDU)
+				_rtl_update_earlymode_info(hw, skb,
+							   &tcb_desc, tid);
+
+#if 0	/* temporary */
+			rtlpriv->intf_ops->adapter_tx(hw, skb, &tcb_desc);
+#endif
+		}
+	}
+}
+
+
 static void _rtl_pci_tx_isr(struct ieee80211_hw *hw, int prio)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -440,6 +603,8 @@ static void _rtl_pci_tx_isr(struct ieee8
 		struct rtl_tx_desc *entry = &ring->desc[ring->idx];
 		struct sk_buff *skb;
 		struct ieee80211_tx_info *info;
+		__le16 fc;
+		u8 tid;
 
 		u8 own = (u8) rtlpriv->cfg->ops->get_desc((u8 *) entry, true,
 							  HW_DESC_OWN);
@@ -455,11 +620,15 @@ static void _rtl_pci_tx_isr(struct ieee8
 
 		skb = __skb_dequeue(&ring->queue);
 		pci_unmap_single(rtlpci->pdev,
-				 rtlpriv->cfg->ops->
+				 le32_to_cpu(rtlpriv->cfg->ops->
 					     get_desc((u8 *) entry, true,
-						      HW_DESC_TXBUFF_ADDR),
+						      HW_DESC_TXBUFF_ADDR)),
 				 skb->len, PCI_DMA_TODEVICE);
 
+		/* remove early mode header */
+		if (rtlpriv->rtlhal.earlymode_enable)
+			skb_pull(skb, EM_HDR_LEN);
+
 		RT_TRACE(rtlpriv, (COMP_INTR | COMP_SEND), DBG_TRACE,
 			 ("new ring->idx:%d, "
 			  "free: skb_queue_len:%d, free: seq:%x\n",
@@ -467,6 +636,30 @@ static void _rtl_pci_tx_isr(struct ieee8
 			  skb_queue_len(&ring->queue),
 			  *(u16 *) (skb->data + 22)));
 
+		if (prio == TXCMD_QUEUE) {
+			dev_kfree_skb(skb);
+			goto tx_status_ok;
+
+		}
+
+		/* for sw LPS, just after NULL skb send out, we can
+		 * sure AP kown we are sleeped, our we should not let
+		 * rf to sleep*/
+		fc = rtl_get_fc(skb);
+		if (ieee80211_is_nullfunc(fc)) {
+			if (ieee80211_has_pm(fc)) {
+				rtlpriv->mac80211.offchan_deley = true;
+				rtlpriv->psc.state_inap = 1;
+			} else {
+				rtlpriv->psc.state_inap = 0;
+			}
+		}
+
+		/* update tid tx pkt num */
+		tid = rtl_get_tid(skb);
+		if (tid <= 7)
+			rtlpriv->link_info.tidtx_inperiod[tid]++;
+
 		info = IEEE80211_SKB_CB(skb);
 		ieee80211_tx_info_clear_status(info);
 
@@ -489,7 +682,7 @@ static void _rtl_pci_tx_isr(struct ieee8
 					skb_get_queue_mapping
 					(skb));
 		}
-
+tx_status_ok:
 		skb = NULL;
 	}
 
@@ -561,23 +754,21 @@ static void _rtl_pci_rx_interrupt(struct
 			 *skb_trim(skb, skb->len - 4);
 			 */
 
-			hdr = (struct ieee80211_hdr *)(skb->data);
-			fc = hdr->frame_control;
+			hdr = rtl_get_hdr(skb);
+			fc = rtl_get_fc(skb);
 
-			if (!stats.crc) {
+			if (!stats.crc || !stats.hwerror) {
 				memcpy(IEEE80211_SKB_RXCB(skb), &rx_status,
 				       sizeof(rx_status));
 
-				if (is_broadcast_ether_addr(hdr->addr1))
+				if (is_broadcast_ether_addr(hdr->addr1)) {
 					;/*TODO*/
-				else {
-					if (is_multicast_ether_addr(hdr->addr1))
-						;/*TODO*/
-					else {
-						unicast = true;
-						rtlpriv->stats.rxbytesunicast +=
-						    skb->len;
-					}
+				} else if (is_multicast_ether_addr(hdr->addr1)) {
+					;/*TODO*/
+				} else {
+					unicast = true;
+					rtlpriv->stats.rxbytesunicast +=
+					    skb->len;
 				}
 
 				rtl_is_special_data(hw, skb, false);
@@ -591,28 +782,38 @@ static void _rtl_pci_rx_interrupt(struct
 						    num_rx_inperiod++;
 				}
 
-				if (unlikely(!rtl_action_proc(hw, skb,
-				    false))) {
+				/* for sw lps */
+				rtl_swlps_beacon(hw, (void *)skb->data,
+						 skb->len);
+				rtl_recognize_peer(hw, (void *)skb->data,
+						   skb->len);
+				if ((rtlpriv->mac80211.opmode ==
+				     NL80211_IFTYPE_AP) &&
+				    (rtlpriv->rtlhal.current_bandtype ==
+				     BAND_ON_2_4G) &&
+				     (ieee80211_is_beacon(fc) ||
+				     ieee80211_is_probe_resp(fc))) {
 					dev_kfree_skb_any(skb);
 				} else {
-					struct sk_buff *uskb = NULL;
-					u8 *pdata;
-					uskb = dev_alloc_skb(skb->len + 128);
-					if (!uskb) {
-						RT_TRACE(rtlpriv,
-							(COMP_INTR | COMP_RECV),
-							DBG_EMERG,
-							("can't alloc rx skb\n"));
-						goto done;
-					}
-					memcpy(IEEE80211_SKB_RXCB(uskb),
-							&rx_status,
-							sizeof(rx_status));
-					pdata = (u8 *)skb_put(uskb, skb->len);
-					memcpy(pdata, skb->data, skb->len);
-					dev_kfree_skb_any(skb);
+					if (unlikely(!rtl_action_proc(hw, skb,
+					    false))) {
+						dev_kfree_skb_any(skb);
+					} else {
+						struct sk_buff *uskb = NULL;
+						u8 *pdata;
+						uskb = dev_alloc_skb(skb->len
+								     + 128);
+						memcpy(IEEE80211_SKB_RXCB(uskb),
+						       &rx_status,
+						       sizeof(rx_status));
+						pdata = (u8 *)skb_put(uskb,
+							skb->len);
+						memcpy(pdata, skb->data,
+						       skb->len);
+						dev_kfree_skb_any(skb);
 
-					ieee80211_rx_irqsafe(hw, uskb);
+						ieee80211_rx_irqsafe(hw, uskb);
+					}
 				}
 			} else {
 				dev_kfree_skb_any(skb);
@@ -627,7 +828,7 @@ static void _rtl_pci_rx_interrupt(struct
 			new_skb = dev_alloc_skb(rtlpci->rxbuffersize);
 			if (unlikely(!new_skb)) {
 				RT_TRACE(rtlpriv, (COMP_INTR | COMP_RECV),
-					 DBG_EMERG,
+					 DBG_DMESG,
 					 ("can't alloc skb for rx\n"));
 				goto done;
 			}
@@ -645,7 +846,7 @@ static void _rtl_pci_rx_interrupt(struct
 
 		}
 done:
-		bufferaddress = (u32)(*((dma_addr_t *) skb->cb));
+		bufferaddress = cpu_to_le32(*((dma_addr_t *)skb->cb));
 		tmp_one = 1;
 		rtlpriv->cfg->ops->set_desc((u8 *) pdesc, false,
 					    HW_DESC_RXBUFF_ADDR,
@@ -669,11 +870,81 @@ done:
 
 }
 
+void _rtl_pci_tx_interrupt(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
+	int prio;
+
+	for (prio = 0; prio < RTL_PCI_MAX_TX_QUEUE_COUNT; prio++) {
+		struct rtl8192_tx_ring *ring = &rtlpci->tx_ring[prio];
+
+		while (skb_queue_len(&ring->queue)) {
+			struct rtl_tx_desc *entry = &ring->desc[ring->idx];
+			struct sk_buff *skb;
+			struct ieee80211_tx_info *info;
+			u8 own;
+
+			/*
+			 *beacon packet will only use the first
+			 *descriptor defautly, and the own may not
+			 *be cleared by the hardware, and
+			 *beacon will free in prepare beacon
+			 */
+			if (prio == BEACON_QUEUE || prio == TXCMD_QUEUE ||
+			    prio == HCCA_QUEUE)
+				break;
+
+			own = (u8) rtlpriv->cfg->ops->get_desc((u8 *) entry,
+							       true,
+							       HW_DESC_OWN);
+
+			if (own)
+				break;
+
+			skb = __skb_dequeue(&ring->queue);
+			pci_unmap_single(rtlpci->pdev,
+					 le32_to_cpu(rtlpriv->cfg->ops->
+						     get_desc((u8 *) entry,
+							  true,
+							  HW_DESC_TXBUFF_ADDR)),
+					 skb->len, PCI_DMA_TODEVICE);
+
+			ring->idx = (ring->idx + 1) % ring->entries;
+
+			info = IEEE80211_SKB_CB(skb);
+			ieee80211_tx_info_clear_status(info);
+
+			info->flags |= IEEE80211_TX_STAT_ACK;
+			/*info->status.rates[0].count = 1; */
+
+			ieee80211_tx_status_irqsafe(hw, skb);
+
+			if ((ring->entries - skb_queue_len(&ring->queue))
+			    == 2 && prio != BEACON_QUEUE) {
+				RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+					 ("more desc left, wake "
+					  "skb_queue@%d,ring->idx = %d,"
+					  "skb_queue_len = 0x%d\n",
+					  prio, ring->idx,
+					  skb_queue_len(&ring->queue)));
+
+				ieee80211_wake_queue(hw,
+						     skb_get_queue_mapping
+						     (skb));
+			}
+
+			skb = NULL;
+		}
+	}
+}
+
 static irqreturn_t _rtl_pci_interrupt(int irq, void *dev_id)
 {
 	struct ieee80211_hw *hw = dev_id;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	unsigned long flags;
 	u32 inta = 0;
 	u32 intb = 0;
@@ -760,23 +1031,36 @@ static irqreturn_t _rtl_pci_interrupt(in
 		_rtl_pci_tx_isr(hw, VO_QUEUE);
 	}
 
+	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8192SE) {
+		if (inta & rtlpriv->cfg->maps[RTL_IMR_COMDOK]) {
+			rtlpriv->link_info.num_tx_inperiod++;
+
+			RT_TRACE(rtlpriv, COMP_INTR, DBG_TRACE,
+					("CMD TX OK interrupt!\n"));
+			_rtl_pci_tx_isr(hw, TXCMD_QUEUE);
+		}
+	}
+
 	/*<2> Rx related */
 	if (inta & rtlpriv->cfg->maps[RTL_IMR_ROK]) {
 		RT_TRACE(rtlpriv, COMP_INTR, DBG_TRACE, ("Rx ok interrupt!\n"));
-		tasklet_schedule(&rtlpriv->works.irq_tasklet);
+		_rtl_pci_rx_interrupt(hw);
 	}
 
 	if (unlikely(inta & rtlpriv->cfg->maps[RTL_IMR_RDU])) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
 			 ("rx descriptor unavailable!\n"));
-		tasklet_schedule(&rtlpriv->works.irq_tasklet);
+		_rtl_pci_rx_interrupt(hw);
 	}
 
 	if (unlikely(inta & rtlpriv->cfg->maps[RTL_IMR_RXFOVW])) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING, ("rx overflow !\n"));
-		tasklet_schedule(&rtlpriv->works.irq_tasklet);
+		_rtl_pci_rx_interrupt(hw);
 	}
 
+	if (rtlpriv->rtlhal.earlymode_enable)
+		tasklet_schedule(&rtlpriv->works.irq_tasklet);
+
 	spin_unlock_irqrestore(&rtlpriv->locks.irq_th_lock, flags);
 	return IRQ_HANDLED;
 
@@ -787,7 +1071,7 @@ done:
 
 static void _rtl_pci_irq_tasklet(struct ieee80211_hw *hw)
 {
-	_rtl_pci_rx_interrupt(hw);
+	_rtl_pci_tx_chk_waitq(hw);
 }
 
 static void _rtl_pci_prepare_bcn_tasklet(struct ieee80211_hw *hw)
@@ -795,14 +1079,15 @@ static void _rtl_pci_prepare_bcn_tasklet
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
-	struct rtl8192_tx_ring *ring = &rtlpci->tx_ring[BEACON_QUEUE];
+	struct rtl8192_tx_ring *ring = NULL;
 	struct ieee80211_hdr *hdr = NULL;
 	struct ieee80211_tx_info *info = NULL;
 	struct sk_buff *pskb = NULL;
 	struct rtl_tx_desc *pdesc = NULL;
-	unsigned int queue_index;
+	struct rtl_tcb_desc tcb_desc;
 	u8 temp_one = 1;
 
+	memset(&tcb_desc, 0, sizeof(struct rtl_tcb_desc));
 	ring = &rtlpci->tx_ring[BEACON_QUEUE];
 	pskb = __skb_dequeue(&ring->queue);
 	if (pskb)
@@ -812,14 +1097,13 @@ static void _rtl_pci_prepare_bcn_tasklet
 	pskb = ieee80211_beacon_get(hw, mac->vif);
 	if (pskb == NULL)
 		return;
-	hdr = (struct ieee80211_hdr *)(pskb->data);
+	hdr = rtl_get_hdr(pskb);
 	info = IEEE80211_SKB_CB(pskb);
-
-	queue_index = BEACON_QUEUE;
-
 	pdesc = &ring->desc[0];
+#if 0	/* temporary */
 	rtlpriv->cfg->ops->fill_tx_desc(hw, hdr, (u8 *) pdesc,
-					info, pskb, queue_index);
+		info, pskb, BEACON_QUEUE, &tcb_desc);
+#endif
 
 	__skb_queue_tail(&ring->queue, pskb);
 
@@ -861,7 +1145,6 @@ static void _rtl_pci_init_struct(struct
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 
 	rtlpci->up_first_time = true;
 	rtlpci->being_init_adapter = false;
@@ -869,31 +1152,20 @@ static void _rtl_pci_init_struct(struct
 	rtlhal->hw = hw;
 	rtlpci->pdev = pdev;
 
-	ppsc->inactiveps = false;
-	ppsc->leisure_ps = true;
-	ppsc->fwctrl_lps = true;
-	ppsc->reg_fwctrl_lps = 3;
-	ppsc->reg_max_lps_awakeintvl = 5;
-
-	if (ppsc->reg_fwctrl_lps == 1)
-		ppsc->fwctrl_psmode = FW_PS_MIN_MODE;
-	else if (ppsc->reg_fwctrl_lps == 2)
-		ppsc->fwctrl_psmode = FW_PS_MAX_MODE;
-	else if (ppsc->reg_fwctrl_lps == 3)
-		ppsc->fwctrl_psmode = FW_PS_DTIM_MODE;
-
 	/*Tx/Rx related var */
 	_rtl_pci_init_trx_var(hw);
 
-	 /*IBSS*/ mac->beacon_interval = 100;
+	/*IBSS*/ mac->beacon_interval = 100;
 
-	 /*AMPDU*/ mac->min_space_cfg = 0;
+	/*AMPDU*/
+	mac->min_space_cfg = 0;
 	mac->max_mss_density = 0;
 	/*set sane AMPDU defaults */
 	mac->current_ampdu_density = 7;
 	mac->current_ampdu_factor = 3;
 
-	 /*QOS*/ rtlpci->acm_method = eAcmWay2_SW;
+	/*QOS*/
+	rtlpci->acm_method = eAcmWay2_SW;
 
 	/*task */
 	tasklet_init(&rtlpriv->works.irq_tasklet,
@@ -934,8 +1206,9 @@ static int _rtl_pci_init_tx_ring(struct
 		 ("queue:%d, ring_addr:%p\n", prio, ring));
 
 	for (i = 0; i < entries; i++) {
-		nextdescaddress = (u32) dma + ((i + 1) % entries) *
-					      sizeof(*ring);
+		nextdescaddress = cpu_to_le32((u32) dma +
+					      ((i + 11) % entries) *
+					      sizeof(*ring));
 
 		rtlpriv->cfg->ops->set_desc((u8 *)&(ring[i]),
 					    true, HW_DESC_TX_NEXTDESC_ADDR,
@@ -999,7 +1272,7 @@ static int _rtl_pci_init_rx_ring(struct
 					   rtlpci->rxbuffersize,
 					   PCI_DMA_FROMDEVICE);
 
-			bufferaddress = (u32)(*((dma_addr_t *)skb->cb));
+			bufferaddress = cpu_to_le32(*((dma_addr_t *)skb->cb));
 			rtlpriv->cfg->ops->set_desc((u8 *)entry, false,
 						    HW_DESC_RXBUFF_ADDR,
 						    (u8 *)&bufferaddress);
@@ -1030,9 +1303,9 @@ static void _rtl_pci_free_tx_ring(struct
 		struct sk_buff *skb = __skb_dequeue(&ring->queue);
 
 		pci_unmap_single(rtlpci->pdev,
-				 rtlpriv->cfg->
+				 le32_to_cpu(rtlpriv->cfg->
 					     ops->get_desc((u8 *) entry, true,
-						   HW_DESC_TXBUFF_ADDR),
+						   HW_DESC_TXBUFF_ADDR)),
 				 skb->len, PCI_DMA_TODEVICE);
 		kfree_skb(skb);
 		ring->idx = (ring->idx + 1) % ring->entries;
@@ -1164,11 +1437,11 @@ int rtl_pci_reset_trx_ring(struct ieee80
 				    __skb_dequeue(&ring->queue);
 
 				pci_unmap_single(rtlpci->pdev,
-						 rtlpriv->cfg->ops->
+						 le32_to_cpu(rtlpriv->cfg->ops->
 							 get_desc((u8 *)
 							 entry,
 							 true,
-							 HW_DESC_TXBUFF_ADDR),
+							 HW_DESC_TXBUFF_ADDR)),
 						 skb->len, PCI_DMA_TODEVICE);
 				kfree_skb(skb);
 				ring->idx = (ring->idx + 1) % ring->entries;
@@ -1182,70 +1455,73 @@ int rtl_pci_reset_trx_ring(struct ieee80
 	return 0;
 }
 
-static unsigned int _rtl_mac_to_hwqueue(__le16 fc,
-		unsigned int mac80211_queue_index)
+static bool rtl_pci_tx_chk_waitq_insert(struct ieee80211_hw *hw,
+					struct sk_buff *skb)
 {
-	unsigned int hw_queue_index;
-
-	if (unlikely(ieee80211_is_beacon(fc))) {
-		hw_queue_index = BEACON_QUEUE;
-		goto out;
-	}
-
-	if (ieee80211_is_mgmt(fc)) {
-		hw_queue_index = MGNT_QUEUE;
-		goto out;
-	}
-
-	switch (mac80211_queue_index) {
-	case 0:
-		hw_queue_index = VO_QUEUE;
-		break;
-	case 1:
-		hw_queue_index = VI_QUEUE;
-		break;
-	case 2:
-		hw_queue_index = BE_QUEUE;;
-		break;
-	case 3:
-		hw_queue_index = BK_QUEUE;
-		break;
-	default:
-		hw_queue_index = BE_QUEUE;
-		RT_ASSERT(false, ("QSLT_BE queue, skb_queue:%d\n",
-				  mac80211_queue_index));
-		break;
-	}
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_sta *sta = info->control.sta;
+	struct rtl_sta_info *sta_entry = NULL;
+	u8 tid = rtl_get_tid(skb);
+
+	if (!sta)
+		return false;
+	sta_entry = (struct rtl_sta_info *)sta->drv_priv;
+
+	if (!rtlpriv->rtlhal.earlymode_enable)
+		return false;
+	if (sta_entry->tids[tid].agg.agg_state != RTL_AGG_OPERATIONAL)
+		return false;
+	if (_rtl_mac_to_hwqueue(hw, skb) > VO_QUEUE)
+		return false;
+	if (tid > 7)
+		return false;
+
+	/* maybe every tid should be checked */
+	if (!rtlpriv->link_info.higher_busytxtraffic[tid])
+		return false;
+
+	spin_lock_bh(&rtlpriv->locks.waitq_lock);
+	skb_queue_tail(&rtlpriv->mac80211.skb_waitq[tid], skb);
+	spin_unlock_bh(&rtlpriv->locks.waitq_lock);
 
-out:
-	return hw_queue_index;
+	return true;
 }
 
-static int rtl_pci_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+int rtl_pci_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
+		struct rtl_tcb_desc *ptcb_desc)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	struct rtl_sta_info *sta_entry = NULL;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_sta *sta = info->control.sta;
 	struct rtl8192_tx_ring *ring;
 	struct rtl_tx_desc *pdesc;
 	u8 idx;
-	unsigned int queue_index, hw_queue;
+	u8 hw_queue = _rtl_mac_to_hwqueue(hw, skb);
 	unsigned long flags;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
-	__le16 fc = hdr->frame_control;
+	struct ieee80211_hdr *hdr = rtl_get_hdr(skb);
+	__le16 fc = rtl_get_fc(skb);
 	u8 *pda_addr = hdr->addr1;
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	/*ssn */
-	u8 *qc = NULL;
 	u8 tid = 0;
 	u16 seq_number = 0;
 	u8 own;
 	u8 temp_one = 1;
 
-	rtl_action_proc(hw, skb, true);
+	if (ieee80211_is_auth(fc)) {
+		RT_TRACE(rtlpriv, COMP_SEND, DBG_DMESG, ("MAC80211_LINKING\n"));
+		rtl_ips_nic_on(hw);
+	}
+
+	if (rtlpriv->psc.sw_ps_enabled) {
+		if (ieee80211_is_data(fc) && !ieee80211_is_nullfunc(fc) &&
+			!ieee80211_has_pm(fc))
+			hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
+	}
 
-	queue_index = skb_get_queue_mapping(skb);
-	hw_queue = _rtl_mac_to_hwqueue(fc, queue_index);
+	rtl_action_proc(hw, skb, true);
 
 	if (is_multicast_ether_addr(pda_addr))
 		rtlpriv->stats.txbytesmulticast += skb->len;
@@ -1255,7 +1531,6 @@ static int rtl_pci_tx(struct ieee80211_h
 		rtlpriv->stats.txbytesunicast += skb->len;
 
 	spin_lock_irqsave(&rtlpriv->locks.irq_th_lock, flags);
-
 	ring = &rtlpci->tx_ring[hw_queue];
 	if (hw_queue != BEACON_QUEUE)
 		idx = (ring->idx + skb_queue_len(&ring->queue)) %
@@ -1278,43 +1553,32 @@ static int rtl_pci_tx(struct ieee80211_h
 		return skb->len;
 	}
 
-	/*
-	 *if(ieee80211_is_nullfunc(fc)) {
-	 *      spin_unlock_irqrestore(&rtlpriv->locks.irq_th_lock, flags);
-	 *      return 1;
-	 *}
-	 */
-
 	if (ieee80211_is_data_qos(fc)) {
-		qc = ieee80211_get_qos_ctl(hdr);
-		tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
-
-		seq_number = mac->tids[tid].seq_number;
-		seq_number &= IEEE80211_SCTL_SEQ;
-		/*
-		 *hdr->seq_ctrl = hdr->seq_ctrl &
-		 *cpu_to_le16(IEEE80211_SCTL_FRAG);
-		 *hdr->seq_ctrl |= cpu_to_le16(seq_number);
-		 */
+		tid = rtl_get_tid(skb);
+		if (sta) {
+			sta_entry = (struct rtl_sta_info *)sta->drv_priv;
+			seq_number = (le16_to_cpu(hdr->seq_ctrl) &
+				      IEEE80211_SCTL_SEQ) >> 4;
+			seq_number += 1;
 
-		seq_number += 1;
+			if (!ieee80211_has_morefrags(hdr->frame_control))
+				sta_entry->tids[tid].seq_number = seq_number;
+		}
 	}
 
 	if (ieee80211_is_data(fc))
 		rtlpriv->cfg->ops->led_control(hw, LED_CTL_TX);
 
-	rtlpriv->cfg->ops->fill_tx_desc(hw, hdr, (u8 *) pdesc,
-					info, skb, hw_queue);
+#if 0	/* temporary */
+	rtlpriv->cfg->ops->fill_tx_desc(hw, hdr, (u8 *)pdesc,
+			info, skb, hw_queue, ptcb_desc);
+#endif
 
 	__skb_queue_tail(&ring->queue, skb);
 
-	rtlpriv->cfg->ops->set_desc((u8 *) pdesc, true,
+	rtlpriv->cfg->ops->set_desc((u8 *)pdesc, true,
 				    HW_DESC_OWN, (u8 *)&temp_one);
 
-	if (!ieee80211_has_morefrags(hdr->frame_control)) {
-		if (qc)
-			mac->tids[tid].seq_number = seq_number;
-	}
 
 	if ((ring->entries - skb_queue_len(&ring->queue)) < 2 &&
 	    hw_queue != BEACON_QUEUE) {
@@ -1336,7 +1600,36 @@ static int rtl_pci_tx(struct ieee80211_h
 	return 0;
 }
 
-static void rtl_pci_deinit(struct ieee80211_hw *hw)
+static void rtl_pci_flush(struct ieee80211_hw *hw, bool drop)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	u16 i = 0;
+	int queue_id;
+	struct rtl8192_tx_ring *ring;
+
+	for (queue_id = RTL_PCI_MAX_TX_QUEUE_COUNT - 1; queue_id >= 0;) {
+		u32 queue_len;
+		ring = &pcipriv->dev.tx_ring[queue_id];
+		queue_len = skb_queue_len(&ring->queue);
+		if (queue_len == 0 || queue_id == BEACON_QUEUE ||
+			queue_id == TXCMD_QUEUE) {
+			queue_id--;
+			continue;
+		} else {
+			msleep(20);
+			i++;
+		}
+
+		/* we just wait 1s for all queues */
+		if (rtlpriv->psc.rfpwr_state == ERFOFF ||
+			is_hal_stop(rtlhal) || i >= 200)
+			return;
+	}
+}
+
+void rtl_pci_deinit(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
@@ -1351,7 +1644,7 @@ static void rtl_pci_deinit(struct ieee80
 
 }
 
-static int rtl_pci_init(struct ieee80211_hw *hw, struct pci_dev *pdev)
+int rtl_pci_init(struct ieee80211_hw *hw, struct pci_dev *pdev)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	int err;
@@ -1368,7 +1661,7 @@ static int rtl_pci_init(struct ieee80211
 	return 1;
 }
 
-static int rtl_pci_start(struct ieee80211_hw *hw)
+int rtl_pci_start(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
@@ -1403,7 +1696,7 @@ static int rtl_pci_start(struct ieee8021
 	return 0;
 }
 
-static void rtl_pci_stop(struct ieee80211_hw *hw)
+void rtl_pci_stop(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
@@ -1454,11 +1747,13 @@ static bool _rtl_pci_find_adapter(struct
 	struct pci_dev *bridge_pdev = pdev->bus->self;
 	u16 venderid;
 	u16 deviceid;
+	u8 revisionid;
 	u16 irqline;
 	u8 tmp;
 
 	venderid = pdev->vendor;
 	deviceid = pdev->device;
+	pci_read_config_byte(pdev, 0x8, &revisionid);
 	pci_read_config_word(pdev, 0x3C, &irqline);
 
 	if (deviceid == RTL_PCI_8192_DID ||
@@ -1469,7 +1764,7 @@ static bool _rtl_pci_find_adapter(struct
 	    deviceid == RTL_PCI_8173_DID ||
 	    deviceid == RTL_PCI_8172_DID ||
 	    deviceid == RTL_PCI_8171_DID) {
-		switch (pdev->revision) {
+		switch (revisionid) {
 		case RTL_PCI_REVISION_ID_8192PCIE:
 			RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
 				 ("8192 PCI-E is found - "
@@ -1498,6 +1793,12 @@ static bool _rtl_pci_find_adapter(struct
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
 			 ("8192C PCI-E is found - "
 			  "vid/did=%x/%x\n", venderid, deviceid));
+	} else if (deviceid == RTL_PCI_8192DE_DID ||
+		   deviceid == RTL_PCI_8192DE_DID2) {
+		rtlhal->hw_type = HARDWARE_TYPE_RTL8192DE;
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
+			 ("8192D PCI-E is found - "
+			  "vid/did=%x/%x\n", venderid, deviceid));
 	} else {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
 			 ("Err: Unknown device -"
@@ -1506,6 +1807,25 @@ static bool _rtl_pci_find_adapter(struct
 		rtlhal->hw_type = RTL_DEFAULT_HARDWARE_TYPE;
 	}
 
+	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8192DE) {
+		if (revisionid == 0 || revisionid == 1) {
+			if (revisionid == 0) {
+				RT_TRACE(rtlpriv, COMP_INIT,
+					 DBG_LOUD, ("Find 92DE MAC0.\n"));
+				rtlhal->interfaceindex = 0;
+			} else if (revisionid == 1) {
+				RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+					("Find 92DE MAC1.\n"));
+				rtlhal->interfaceindex = 1;
+			}
+		} else {
+			RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+				("Unknown device - "
+				"VendorID/DeviceID=%x/%x, Revision=%x\n",
+				venderid, deviceid, revisionid));
+			rtlhal->interfaceindex = 0;
+		}
+	}
 	/*find bus info */
 	pcipriv->ndis_adapter.busnumber = pdev->bus->number;
 	pcipriv->ndis_adapter.devnumber = PCI_SLOT(pdev->devfn);
@@ -1531,12 +1851,12 @@ static bool _rtl_pci_find_adapter(struct
 		    PCI_SLOT(bridge_pdev->devfn);
 		pcipriv->ndis_adapter.pcibridge_funcnum =
 		    PCI_FUNC(bridge_pdev->devfn);
-		pcipriv->ndis_adapter.pcibridge_pciehdr_offset =
-		    pci_pcie_cap(bridge_pdev);
 		pcipriv->ndis_adapter.pcicfg_addrport =
 		    (pcipriv->ndis_adapter.pcibridge_busnum << 16) |
 		    (pcipriv->ndis_adapter.pcibridge_devnum << 11) |
 		    (pcipriv->ndis_adapter.pcibridge_funcnum << 8) | (1 << 31);
+		pcipriv->ndis_adapter.pcibridge_pciehdr_offset =
+		    pci_pcie_cap(bridge_pdev);
 		pcipriv->ndis_adapter.num4bytes =
 		    (pcipriv->ndis_adapter.pcibridge_pciehdr_offset + 0x10) / 4;
 
@@ -1619,6 +1939,11 @@ int __devinit rtl_pci_probe(struct pci_d
 	pcipriv = (void *)rtlpriv->priv;
 	pcipriv->dev.pdev = pdev;
 
+	/* init cfg & intf_ops */
+	rtlpriv->rtlhal.interface = INTF_PCI;
+	rtlpriv->cfg = (struct rtl_hal_cfg *)(id->driver_data);
+	rtlpriv->intf_ops = &rtl_pci_ops;
+
 	/*
 	 *init dbgp flags before all
 	 *other functions, because we will
@@ -1636,13 +1961,14 @@ int __devinit rtl_pci_probe(struct pci_d
 		return err;
 	}
 
-	pmem_start = pci_resource_start(pdev, 2);
-	pmem_len = pci_resource_len(pdev, 2);
-	pmem_flags = pci_resource_flags(pdev, 2);
+	pmem_start = pci_resource_start(pdev, rtlpriv->cfg->bar_id);
+	pmem_len = pci_resource_len(pdev, rtlpriv->cfg->bar_id);
+	pmem_flags = pci_resource_flags(pdev, rtlpriv->cfg->bar_id);
 
 	/*shared mem start */
 	rtlpriv->io.pci_mem_start =
-			(unsigned long)pci_iomap(pdev, 2, pmem_len);
+			(unsigned long)pci_iomap(pdev,
+			rtlpriv->cfg->bar_id, pmem_len);
 	if (rtlpriv->io.pci_mem_start == 0) {
 		RT_ASSERT(false, ("Can't map PCI mem\n"));
 		goto fail2;
@@ -1661,11 +1987,6 @@ int __devinit rtl_pci_probe(struct pci_d
 	pci_write_config_byte(pdev, 0x04, 0x06);
 	pci_write_config_byte(pdev, 0x04, 0x07);
 
-	/* init cfg & intf_ops */
-	rtlpriv->rtlhal.interface = INTF_PCI;
-	rtlpriv->cfg = (struct rtl_hal_cfg *)(id->driver_data);
-	rtlpriv->intf_ops = &rtl_pci_ops;
-
 	/* find adapter */
 	_rtl_pci_find_adapter(pdev, hw);
 
@@ -1783,8 +2104,6 @@ void rtl_pci_disconnect(struct pci_dev *
 
 	rtl_pci_deinit(hw);
 	rtl_deinit_core(hw);
-	if (rtlpriv->cfg->ops->deinit_sw_leds)
-		rtlpriv->cfg->ops->deinit_sw_leds(hw);
 	_rtl_pci_io_handler_release(hw);
 	rtlpriv->cfg->ops->deinit_sw_vars(hw);
 
@@ -1799,6 +2118,9 @@ void rtl_pci_disconnect(struct pci_dev *
 	}
 
 	pci_disable_device(pdev);
+
+	rtl_pci_disable_aspm(hw);
+
 	pci_set_drvdata(pdev, NULL);
 
 	ieee80211_free_hw(hw);
@@ -1822,10 +2144,15 @@ no need to call hw_disable here.
 ****************************************/
 int rtl_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 {
+	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	rtlpriv->cfg->ops->hw_suspend(hw);
+	rtl_deinit_rfkill(hw);
+
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
 	pci_set_power_state(pdev, PCI_D3hot);
-
 	return 0;
 }
 EXPORT_SYMBOL(rtl_pci_suspend);
@@ -1833,6 +2160,8 @@ EXPORT_SYMBOL(rtl_pci_suspend);
 int rtl_pci_resume(struct pci_dev *pdev)
 {
 	int ret;
+	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
 	pci_set_power_state(pdev, PCI_D0);
 	ret = pci_enable_device(pdev);
@@ -1843,16 +2172,22 @@ int rtl_pci_resume(struct pci_dev *pdev)
 
 	pci_restore_state(pdev);
 
+	rtlpriv->cfg->ops->hw_resume(hw);
+	rtl_init_rfkill(hw);
 	return 0;
 }
 EXPORT_SYMBOL(rtl_pci_resume);
 
 struct rtl_intf_ops rtl_pci_ops = {
+	.read_efuse_byte = read_efuse_byte,
 	.adapter_start = rtl_pci_start,
 	.adapter_stop = rtl_pci_stop,
 	.adapter_tx = rtl_pci_tx,
+	.flush = rtl_pci_flush,
 	.reset_trx_ring = rtl_pci_reset_trx_ring,
+	.waitq_insert = rtl_pci_tx_chk_waitq_insert,
 
 	.disable_aspm = rtl_pci_disable_aspm,
 	.enable_aspm = rtl_pci_enable_aspm,
 };
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/pci.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/pci.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/pci.h
@@ -102,8 +102,8 @@
 #define RTL_PCI_8191CE_DID	0x8177	/*8192ce */
 #define RTL_PCI_8188CE_DID	0x8176	/*8192ce */
 #define RTL_PCI_8192CU_DID	0x8191	/*8192ce */
-#define RTL_PCI_8192DE_DID	0x092D	/*8192ce */
-#define RTL_PCI_8192DU_DID	0x092D	/*8192ce */
+#define RTL_PCI_8192DE_DID	0x8193	/*8192de */
+#define RTL_PCI_8192DE_DID2	0x002B	/*92DE*/
 
 /*8192 support 16 pages of IO registers*/
 #define RTL_MEM_MAPPED_IO_RANGE_8190PCI		0x1000
@@ -129,6 +129,11 @@ enum pci_bridge_vendor {
 	PCI_BRIDGE_VENDOR_MAX,
 };
 
+struct rtl_pci_capabilities_header {
+	u8 capability_id;
+	u8 next;
+};
+
 struct rtl_rx_desc {
 	u32 dword[8];
 } __packed;
@@ -161,7 +166,9 @@ struct rtl_pci {
 
 	bool driver_is_goingto_unload;
 	bool up_first_time;
+	bool first_init;
 	bool being_init_adapter;
+	bool init_ready;
 	bool irq_enabled;
 
 	/*Tx */
@@ -197,6 +204,9 @@ struct rtl_pci {
 
 	/*QOS & EDCA */
 	enum acm_method acm_method;
+
+	u16 shortretry_limit;
+	u16 longretry_limit;
 };
 
 struct mp_adapter {
@@ -227,6 +237,7 @@ struct rtl_pci_priv {
 	struct rtl_pci dev;
 	struct mp_adapter ndis_adapter;
 	struct rtl_led_ctl ledctl;
+	struct bt_coexist_info bt_coexist;
 };
 
 #define rtl_pcipriv(hw)		(((struct rtl_pci_priv *)(rtl_priv(hw))->priv))
@@ -300,3 +311,4 @@ static inline void rtl_pci_raw_read_port
 }
 
 #endif
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/ps.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/ps.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/ps.c
@@ -428,6 +428,10 @@ void rtl_swlps_rf_awake(struct ieee80211
 {
 }
 
+void rtl_swlps_beacon(struct ieee80211_hw *hw, void *data, unsigned int len)
+{
+}
+
 /*Enter the leisure power save mode.*/
 void rtl_lps_enter(struct ieee80211_hw *hw)
 {
