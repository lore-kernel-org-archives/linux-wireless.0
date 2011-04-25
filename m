Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64021 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758738Ab1DYRyb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 13:54:31 -0400
Date: Mon, 25 Apr 2011 12:54:05 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	chaoming_li@realsil.com.cn
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 17/18] rtlwifi: rtl8192ce: Change rtl8192ce routines phy
 and trx and modify rtl8192cu for addition of rtl8192se and rtl8192de
Message-ID: <4db5b53d.W5k6k2re4ne5A29j%Larry.Finger@lwfinger.net> (sfid-20110425_195434_800876_7B27B5EF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaoming_Li <chaoming_li@realsil.com.cn>

Change rtl8192ce routines phy and trx for addition of RTL8192SE and RTL8192DE.
In addition, make necessary modifications to rtl8192cu. This patch also
removes the temporary patches needed to enable intermediate steps to build
without error.

Signed-off-by: Chaoming_Li <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 pci.c                 |    4 -
 rtl8192c/phy_common.c |   13 +--
 rtl8192ce/hw.c        |    2 
 rtl8192ce/phy.c       |   25 -------
 rtl8192ce/sw.c        |    2 
 rtl8192ce/trx.c       |  174 +++++++++++++++++---------------------------------
 rtl8192ce/trx.h       |    8 +-
 rtl8192cu/hw.c        |   16 ++--
 rtl8192cu/hw.h        |    7 +-
 rtl8192cu/sw.c        |    4 -
 rtl8192cu/trx.c       |   50 +++++++-------
 rtl8192cu/trx.h       |    7 +-
 wifi.h                |    5 -
 13 files changed, 120 insertions(+), 197 deletions(-)
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
@@ -36,42 +36,16 @@
 #include "trx.h"
 #include "led.h"
 
-static enum rtl_desc_qsel _rtl92ce_map_hwqueue_to_fwqueue(__le16 fc,
-							  unsigned int
-							  skb_queue)
+u8 _rtl92ce_map_hwqueue_to_fwqueue(struct sk_buff *skb, u8 hw_queue)
 {
-	enum rtl_desc_qsel qsel;
+	u16 fc = rtl_get_fc(skb);
 
-	if (unlikely(ieee80211_is_beacon(fc))) {
-		qsel = QSLT_BEACON;
-		return qsel;
-	}
-
-	if (ieee80211_is_mgmt(fc)) {
-		qsel = QSLT_MGNT;
-		return qsel;
-	}
+	if (unlikely(ieee80211_is_beacon(fc)))
+		return QSLT_BEACON;
+	if (ieee80211_is_mgmt(fc))
+		return QSLT_MGNT;
 
-	switch (skb_queue) {
-	case VO_QUEUE:
-		qsel = QSLT_VO;
-		break;
-	case VI_QUEUE:
-		qsel = QSLT_VI;
-		break;
-	case BE_QUEUE:
-		qsel = QSLT_BE;
-		break;
-	case BK_QUEUE:
-		qsel = QSLT_BK;
-		break;
-	default:
-		qsel = QSLT_BE;
-		RT_ASSERT(false, ("BE queue, skb_queue:%d,"
-				  " set qsel = 0x%X\n", skb_queue, QSLT_BE));
-		break;
-	}
-	return qsel;
+	return skb->priority;
 }
 
 static int _rtl92ce_rate_mapping(bool isht, u8 desc_rate, bool first_ampdu)
@@ -255,6 +229,7 @@ static void _rtl92ce_query_rxphystatus(s
 	u8 evm, pwdb_all, rf_rx_num = 0;
 	u8 i, max_spatial_stream;
 	u32 rssi, total_rssi = 0;
+	bool in_powersavemode = false;
 	bool is_cck_rate;
 
 	is_cck_rate = RX_HAL_IS_CCK_RATE(pdesc);
@@ -270,9 +245,13 @@ static void _rtl92ce_query_rxphystatus(s
 		u8 report, cck_highpwr;
 		cck_buf = (struct phy_sts_cck_8192s_t *)p_drvinfo;
 
-		cck_highpwr = (u8) rtl_get_bbreg(hw,
-					 RFPGA0_XA_HSSIPARAMETER2,
-					 BIT(9));
+		if (!in_powersavemode)
+			cck_highpwr = (u8) rtl_get_bbreg(hw,
+						 RFPGA0_XA_HSSIPARAMETER2,
+						 BIT(9));
+		else
+			cck_highpwr = false;
+
 		if (!cck_highpwr) {
 			u8 cck_agc_rpt = cck_buf->cck_agc_rpt;
 			report = cck_buf->cck_agc_rpt & 0xc0;
@@ -398,6 +377,7 @@ static void _rtl92ce_process_ui_rssi(str
 
 		if (rtlpriv->stats.ui_rssi.total_num++ >=
 		    PHY_RSSI_SLID_WIN_MAX) {
+
 			rtlpriv->stats.ui_rssi.total_num =
 			    PHY_RSSI_SLID_WIN_MAX;
 			last_rssi =
@@ -424,10 +404,6 @@ static void _rtl92ce_process_ui_rssi(str
 	if (!pstats->is_cck && pstats->packet_toself) {
 		for (rfpath = RF90_PATH_A; rfpath < rtlphy->num_total_rfpath;
 		     rfpath++) {
-
-			if (!rtl8192_phy_check_is_legal_rfpath(hw, rfpath))
-				continue;
-
 			if (rtlpriv->stats.rx_rssi_percentage[rfpath] == 0) {
 				rtlpriv->stats.rx_rssi_percentage[rfpath] =
 				    pstats->rx_mimo_signalstrength[rfpath];
@@ -723,7 +699,7 @@ bool rtl92ce_rx_query_desc(struct ieee80
 void rtl92ce_tx_fill_desc(struct ieee80211_hw *hw,
 			  struct ieee80211_hdr *hdr, u8 *pdesc_tx,
 			  struct ieee80211_tx_info *info, struct sk_buff *skb,
-			  unsigned int queue_index)
+			  u8 hw_queue, struct rtl_tcb_desc *tcb_desc)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
@@ -732,16 +708,9 @@ void rtl92ce_tx_fill_desc(struct ieee802
 	bool defaultadapter = true;
 	struct ieee80211_sta *sta;
 	u8 *pdesc = (u8 *) pdesc_tx;
-	struct rtl_tcb_desc tcb_desc;
-	u8 *qc = ieee80211_get_qos_ctl(hdr);
-	u8 tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
 	u16 seq_number;
 	__le16 fc = hdr->frame_control;
-	u8 rate_flag = info->control.rates[0].flags;
-
-	enum rtl_desc_qsel fw_qsel =
-	    _rtl92ce_map_hwqueue_to_fwqueue(fc, queue_index);
-
+	u8 fw_qsel = _rtl92ce_map_hwqueue_to_fwqueue(skb, hw_queue);
 	bool firstseg = ((hdr->seq_ctrl &
 			  cpu_to_le16(IEEE80211_SCTL_FRAG)) == 0);
 
@@ -751,56 +720,68 @@ void rtl92ce_tx_fill_desc(struct ieee802
 	dma_addr_t mapping = pci_map_single(rtlpci->pdev,
 					    skb->data, skb->len,
 					    PCI_DMA_TODEVICE);
+	u8 bw_40 = 0;
+
+	rcu_read_lock();
+	sta = get_sta(hw, mac->vif, mac->bssid);
+	if (mac->opmode == NL80211_IFTYPE_STATION) {
+		bw_40 = mac->bw_40;
+	} else if (mac->opmode == NL80211_IFTYPE_AP ||
+		mac->opmode == NL80211_IFTYPE_ADHOC) {
+		if (sta)
+			bw_40 = sta->ht_cap.cap &
+				IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+	}
 
 	seq_number = (le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_SEQ) >> 4;
 
-	rtl_get_tcb_desc(hw, info, sta, skb, &tcb_desc);
+	rtl_get_tcb_desc(hw, info, sta, skb, tcb_desc);
 
 	CLEAR_PCI_TX_DESC_CONTENT(pdesc, sizeof(struct tx_desc_92c));
 
+	if (ieee80211_is_nullfunc(fc) || ieee80211_is_ctl(fc)) {
+		firstseg = true;
+		lastseg = true;
+	}
 	if (firstseg) {
 		SET_TX_DESC_OFFSET(pdesc, USB_HWDESC_HEADER_LEN);
 
-		SET_TX_DESC_TX_RATE(pdesc, tcb_desc.hw_rate);
+		SET_TX_DESC_TX_RATE(pdesc, tcb_desc->hw_rate);
 
-		if (tcb_desc.use_shortgi || tcb_desc.use_shortpreamble)
+		if (tcb_desc->use_shortgi || tcb_desc->use_shortpreamble)
 			SET_TX_DESC_DATA_SHORTGI(pdesc, 1);
 
-		if (mac->tids[tid].agg.agg_state == RTL_AGG_ON &&
-		    info->flags & IEEE80211_TX_CTL_AMPDU) {
+		if (info->flags & IEEE80211_TX_CTL_AMPDU) {
 			SET_TX_DESC_AGG_BREAK(pdesc, 1);
 			SET_TX_DESC_MAX_AGG_NUM(pdesc, 0x14);
 		}
 		SET_TX_DESC_SEQ(pdesc, seq_number);
 
-		SET_TX_DESC_RTS_ENABLE(pdesc, ((tcb_desc.rts_enable &&
-						!tcb_desc.
+		SET_TX_DESC_RTS_ENABLE(pdesc, ((tcb_desc->rts_enable &&
+						!tcb_desc->
 						cts_enable) ? 1 : 0));
 		SET_TX_DESC_HW_RTS_ENABLE(pdesc,
-					  ((tcb_desc.rts_enable
-					    || tcb_desc.cts_enable) ? 1 : 0));
-		SET_TX_DESC_CTS2SELF(pdesc, ((tcb_desc.cts_enable) ? 1 : 0));
-		SET_TX_DESC_RTS_STBC(pdesc, ((tcb_desc.rts_stbc) ? 1 : 0));
+					  ((tcb_desc->rts_enable
+					    || tcb_desc->cts_enable) ? 1 : 0));
+		SET_TX_DESC_CTS2SELF(pdesc, ((tcb_desc->cts_enable) ? 1 : 0));
+		SET_TX_DESC_RTS_STBC(pdesc, ((tcb_desc->rts_stbc) ? 1 : 0));
 
-		SET_TX_DESC_RTS_RATE(pdesc, tcb_desc.rts_rate);
+		SET_TX_DESC_RTS_RATE(pdesc, tcb_desc->rts_rate);
 		SET_TX_DESC_RTS_BW(pdesc, 0);
-		SET_TX_DESC_RTS_SC(pdesc, tcb_desc.rts_sc);
+		SET_TX_DESC_RTS_SC(pdesc, tcb_desc->rts_sc);
 		SET_TX_DESC_RTS_SHORT(pdesc,
-				      ((tcb_desc.rts_rate <= DESC92C_RATE54M) ?
-				      (tcb_desc.rts_use_shortpreamble ? 1 : 0)
-				      : (tcb_desc.rts_use_shortgi ? 1 : 0)));
+				      ((tcb_desc->rts_rate <= DESC92C_RATE54M) ?
+				       (tcb_desc->rts_use_shortpreamble ? 1 : 0)
+				       : (tcb_desc->rts_use_shortgi ? 1 : 0)));
 
-		if (mac->bw_40) {
-			if (tcb_desc.packet_bw) {
+		if (bw_40) {
+			if (tcb_desc->packet_bw) {
 				SET_TX_DESC_DATA_BW(pdesc, 1);
 				SET_TX_DESC_TX_SUB_CARRIER(pdesc, 3);
 			} else {
 				SET_TX_DESC_DATA_BW(pdesc, 0);
-
-				if (rate_flag & IEEE80211_TX_RC_DUP_DATA) {
-					SET_TX_DESC_TX_SUB_CARRIER(pdesc,
-							mac->cur_40_prime_sc);
-				}
+				SET_TX_DESC_TX_SUB_CARRIER(pdesc,
+						 mac->cur_40_prime_sc);
 			}
 		} else {
 			SET_TX_DESC_DATA_BW(pdesc, 0);
@@ -810,8 +791,6 @@ void rtl92ce_tx_fill_desc(struct ieee802
 		SET_TX_DESC_LINIP(pdesc, 0);
 		SET_TX_DESC_PKT_SIZE(pdesc, (u16) skb->len);
 
-		rcu_read_lock();
-		sta = ieee80211_find_sta(mac->vif, mac->bssid);
 		if (sta) {
 			u8 ampdu_density = sta->ht_cap.ampdu_density;
 			SET_TX_DESC_AMPDU_DENSITY(pdesc, ampdu_density);
@@ -844,7 +823,7 @@ void rtl92ce_tx_fill_desc(struct ieee802
 		SET_TX_DESC_DATA_RATE_FB_LIMIT(pdesc, 0x1F);
 		SET_TX_DESC_RTS_RATE_FB_LIMIT(pdesc, 0xF);
 		SET_TX_DESC_DISABLE_FB(pdesc, 0);
-		SET_TX_DESC_USE_RATE(pdesc, tcb_desc.use_driver_rate ? 1 : 0);
+		SET_TX_DESC_USE_RATE(pdesc, tcb_desc->use_driver_rate ? 1 : 0);
 
 		if (ieee80211_is_data_qos(fc)) {
 			if (mac->rdg_en) {
@@ -864,15 +843,14 @@ void rtl92ce_tx_fill_desc(struct ieee802
 	SET_TX_DESC_TX_BUFFER_ADDRESS(pdesc, cpu_to_le32(mapping));
 
 	if (rtlpriv->dm.useramask) {
-		SET_TX_DESC_RATE_ID(pdesc, tcb_desc.ratr_index);
-		SET_TX_DESC_MACID(pdesc, tcb_desc.mac_id);
+		SET_TX_DESC_RATE_ID(pdesc, tcb_desc->ratr_index);
+		SET_TX_DESC_MACID(pdesc, tcb_desc->mac_id);
 	} else {
-		SET_TX_DESC_RATE_ID(pdesc, 0xC + tcb_desc.ratr_index);
-		SET_TX_DESC_MACID(pdesc, tcb_desc.ratr_index);
+		SET_TX_DESC_RATE_ID(pdesc, 0xC + tcb_desc->ratr_index);
+		SET_TX_DESC_MACID(pdesc, tcb_desc->ratr_index);
 	}
 
-	if ((!ieee80211_is_data_qos(fc)) && ppsc->leisure_ps &&
-	    ppsc->fwctrl_lps) {
+	if ((!ieee80211_is_data_qos(fc)) && ppsc->fwctrl_lps) {
 		SET_TX_DESC_HWSEQ_EN(pdesc, 1);
 		SET_TX_DESC_PKT_ID(pdesc, 8);
 
@@ -1021,7 +999,7 @@ u32 rtl92ce_get_desc(u8 *p_desc, bool is
 	return ret;
 }
 
-void rtl92ce_tx_polling(struct ieee80211_hw *hw, unsigned int hw_queue)
+void rtl92ce_tx_polling(struct ieee80211_hw *hw, u8 hw_queue)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	if (hw_queue == BEACON_QUEUE) {
@@ -1032,35 +1010,3 @@ void rtl92ce_tx_polling(struct ieee80211
 	}
 }
 
-bool _rtl92c_cmd_send_packet(struct ieee80211_hw *hw,
-			     struct sk_buff *skb)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-	struct rtl8192_tx_ring *ring;
-	struct rtl_tx_desc *pdesc;
-	u8 own;
-	unsigned long flags;
-	struct sk_buff *pskb = NULL;
-
-	ring = &rtlpci->tx_ring[BEACON_QUEUE];
-
-	spin_lock_irqsave(&rtlpriv->locks.irq_th_lock, flags);
-
-	pskb = __skb_dequeue(&ring->queue);
-	if (pskb)
-		kfree_skb(pskb);
-
-	pdesc = &ring->desc[0];
-	own = (u8) rtlpriv->cfg->ops->get_desc((u8 *) pdesc, true, HW_DESC_OWN);
-
-	rtlpriv->cfg->ops->fill_tx_cmddesc(hw, (u8 *) pdesc, 1, 1, skb);
-
-	__skb_queue_tail(&ring->queue, skb);
-
-	spin_unlock_irqrestore(&rtlpriv->locks.irq_th_lock, flags);
-
-	rtlpriv->cfg->ops->tx_polling(hw, BEACON_QUEUE);
-
-	return true;
-}
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
@@ -724,17 +724,17 @@ struct rx_desc_92c {
 void rtl92ce_tx_fill_desc(struct ieee80211_hw *hw,
 			  struct ieee80211_hdr *hdr,
 			  u8 *pdesc, struct ieee80211_tx_info *info,
-			  struct sk_buff *skb, unsigned int qsel);
+			  struct sk_buff *skb, u8 hw_queue,
+			  struct rtl_tcb_desc *ptcb_desc);
 bool rtl92ce_rx_query_desc(struct ieee80211_hw *hw,
 			   struct rtl_stats *stats,
 			   struct ieee80211_rx_status *rx_status,
 			   u8 *pdesc, struct sk_buff *skb);
 void rtl92ce_set_desc(u8 *pdesc, bool istx, u8 desc_name, u8 *val);
 u32 rtl92ce_get_desc(u8 *pdesc, bool istx, u8 desc_name);
-void rtl92ce_tx_polling(struct ieee80211_hw *hw, unsigned int hw_queue);
+void rtl92ce_tx_polling(struct ieee80211_hw *hw, u8 hw_queue);
 void rtl92ce_tx_fill_cmddesc(struct ieee80211_hw *hw, u8 *pdesc,
 			     bool b_firstseg, bool b_lastseg,
 			     struct sk_buff *skb);
-bool _rtl92c_cmd_send_packet(struct ieee80211_hw *hw, struct sk_buff *skb);
-
 #endif
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/pci.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/pci.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/pci.c
@@ -584,9 +584,7 @@ static void _rtl_pci_tx_chk_waitq(struct
 				_rtl_update_earlymode_info(hw, skb,
 							   &tcb_desc, tid);
 
-#if 0	/* temporary */
 			rtlpriv->intf_ops->adapter_tx(hw, skb, &tcb_desc);
-#endif
 		}
 	}
 }
@@ -1100,10 +1098,8 @@ static void _rtl_pci_prepare_bcn_tasklet
 	hdr = rtl_get_hdr(pskb);
 	info = IEEE80211_SKB_CB(pskb);
 	pdesc = &ring->desc[0];
-#if 0	/* temporary */
 	rtlpriv->cfg->ops->fill_tx_desc(hw, hdr, (u8 *) pdesc,
 		info, pskb, BEACON_QUEUE, &tcb_desc);
-#endif
 
 	__skb_queue_tail(&ring->queue, pskb);
 
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
@@ -930,10 +930,8 @@ int rtl92ce_hw_init(struct ieee80211_hw
 	}
 
 	rtlhal->last_hmeboxnum = 0;
-#if 0	/* temporary */
 	rtl92c_phy_mac_config(hw);
 	rtl92c_phy_bb_config(hw);
-#endif
 	rtlphy->rf_mode = RF_OP_BY_SW_3WIRE;
 	rtl92c_phy_rf_config(hw);
 	rtlphy->rfreg_chnlval[0] = rtl_get_rfreg(hw, (enum radio_path)0,
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
@@ -366,7 +366,7 @@ bool rtl92c_phy_config_rf_with_headerfil
 	return true;
 }
 
-static void rtl92c_phy_set_bw_mode_callback(struct ieee80211_hw *hw)
+void rtl92c_phy_set_bw_mode_callback(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
@@ -430,34 +430,11 @@ static void rtl92c_phy_set_bw_mode_callb
 			 ("unknown bandwidth: %#X\n", rtlphy->current_chan_bw));
 		break;
 	}
-#if 0	/* temporary */
 	rtl92ce_phy_rf6052_set_bandwidth(hw, rtlphy->current_chan_bw);
-#endif
 	rtlphy->set_bwmode_inprogress = false;
 	RT_TRACE(rtlpriv, COMP_SCAN, DBG_TRACE, ("<==\n"));
 }
 
-void rtl92c_phy_set_bw_mode(struct ieee80211_hw *hw,
-			    enum nl80211_channel_type ch_type)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_phy *rtlphy = &(rtlpriv->phy);
-	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-	u8 tmp_bw = rtlphy->current_chan_bw;
-
-	if (rtlphy->set_bwmode_inprogress)
-		return;
-	rtlphy->set_bwmode_inprogress = true;
-	if ((!is_hal_stop(rtlhal)) && !(RT_CANNOT_IO(hw))) {
-		rtl92c_phy_set_bw_mode_callback(hw);
-	} else {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
-			 ("FALSE driver sleep or unload\n"));
-		rtlphy->set_bwmode_inprogress = false;
-		rtlphy->current_chan_bw = tmp_bw;
-	}
-}
-
 void _rtl92ce_phy_lc_calibrate(struct ieee80211_hw *hw, bool is2t)
 {
 	u8 tmpreg;
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
@@ -214,7 +214,6 @@ struct rtl_hal_ops rtl8192ce_hal_ops = {
 	.switch_channel = rtl92c_phy_sw_chnl,
 	.dm_watchdog = rtl92c_dm_watchdog,
 	.scan_operation_backup = rtl92c_phy_scan_operation_backup,
-#if 0	/* temporary */
 	.set_rf_power_state = rtl92c_phy_set_rf_power_state,
 	.led_control = rtl92ce_led_control,
 	.set_desc = rtl92ce_set_desc,
@@ -234,7 +233,6 @@ struct rtl_hal_ops rtl8192ce_hal_ops = {
 	.config_bb_with_pgheaderfile = _rtl92ce_phy_config_bb_with_pgheaderfile,
 	.phy_lc_calibrate = _rtl92ce_phy_lc_calibrate,
 	.dm_dynamic_txpower = rtl92ce_dm_dynamic_txpower,
-#endif
 };
 
 struct rtl_mod_params rtl92ce_mod_params = {
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -39,10 +39,10 @@
 #include "mac.h"
 #include "dm.h"
 #include "hw.h"
+#include "../rtl8192ce/hw.h"
 #include "trx.h"
 #include "led.h"
 #include "table.h"
-#include "../rtl8192ce/hw.h"
 
 static void _rtl92cu_phy_param_tab_init(struct ieee80211_hw *hw)
 {
@@ -606,12 +606,10 @@ void rtl92cu_read_eeprom_info(struct iee
 	if (!IS_NORMAL_CHIP(rtlhal->version))
 		return;
 	tmp_u1b = rtl_read_byte(rtlpriv, REG_9346CR);
-#if 0	/* temporary */
-	rtlefuse->epromtype = (tmp_u1b & EEPROMSEL) ?
+	rtlefuse->epromtype = (tmp_u1b & BOOT_FROM_EEPROM) ?
 			       EEPROM_93C46 : EEPROM_BOOT_EFUSE;
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, ("Boot from %s\n",
-		 (tmp_u1b & EEPROMSEL) ? "EERROM" : "EFUSE"));
-#endif
+		 (tmp_u1b & BOOT_FROM_EEPROM) ? "EERROM" : "EFUSE"));
 	rtlefuse->autoload_failflag = (tmp_u1b & EEPROM_EN) ? false : true;
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, ("Autoload %s\n",
 		 (tmp_u1b & EEPROM_EN) ? "OK!!" : "ERR!!"));
@@ -980,7 +978,7 @@ static void _rtl92cu_init_wmac_setting(s
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 
-	mac->rx_conf = (RCR_APM | RCR_AM | RCR_ADF | RCR_AB | RCR_APP_FCS |
+	mac->rx_conf = (RCR_APM | RCR_AM | RCR_ADF | RCR_AB | RCR_APPFCS |
 		      RCR_APP_ICV | RCR_AMF | RCR_HTC_LOC_CTRL |
 		      RCR_APP_MIC | RCR_APP_PHYSTS | RCR_ACRC32);
 	rtl_write_dword(rtlpriv, REG_RCR, mac->rx_conf);
@@ -2185,7 +2183,9 @@ void rtl92cu_set_hw_reg(struct ieee80211
 	}
 }
 
-void rtl92cu_update_hal_rate_table(struct ieee80211_hw *hw)
+void rtl92cu_update_hal_rate_table(struct ieee80211_hw *hw,
+				   struct ieee80211_sta *sta,
+				   u8 rssi_level)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
@@ -2505,3 +2505,5 @@ bool rtl92cu_gpio_radio_on_off_checking(
 	*valid = 1;
 	return !ppsc->hwradiooff;
 }
+
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/hw.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/hw.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/hw.h
@@ -98,13 +98,14 @@ void rtl92cu_update_interrupt_mask(struc
 				   u32 add_msr, u32 rm_msr);
 void rtl92cu_get_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val);
 void rtl92cu_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val);
-void rtl92cu_update_hal_rate_table(struct ieee80211_hw *hw);
+void rtl92cu_update_hal_rate_table(struct ieee80211_hw *hw,
+				   struct ieee80211_sta *sta,
+				   u8 rssi_level);
 void rtl92cu_update_hal_rate_mask(struct ieee80211_hw *hw, u8 rssi_level);
 
 void rtl92cu_update_channel_access_setting(struct ieee80211_hw *hw);
 bool rtl92cu_gpio_radio_on_off_checking(struct ieee80211_hw *hw, u8 * valid);
 void rtl92cu_set_check_bssid(struct ieee80211_hw *hw, bool check_bssid);
-static u8 _rtl92c_get_chnl_group(u8 chnl);
 int rtl92c_download_fw(struct ieee80211_hw *hw);
 void rtl92c_set_fw_pwrmode_cmd(struct ieee80211_hw *hw, u8 mode);
 void rtl92c_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool dl_finished);
@@ -114,3 +115,5 @@ void rtl92c_fill_h2c_cmd(struct ieee8021
 bool rtl92cu_phy_mac_config(struct ieee80211_hw *hw);
 
 #endif
+
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -94,7 +94,7 @@ static struct rtl_hal_ops rtl8192cu_hal_
 	.update_interrupt_mask = rtl92cu_update_interrupt_mask,
 	.get_hw_reg = rtl92cu_get_hw_reg,
 	.set_hw_reg = rtl92cu_set_hw_reg,
-	.update_rate_table = rtl92cu_update_hal_rate_table,
+	.update_rate_tbl = rtl92cu_update_hal_rate_table,
 	.update_rate_mask = rtl92cu_update_hal_rate_mask,
 	.fill_tx_desc = rtl92cu_tx_fill_desc,
 	.fill_fake_txdesc = rtl92cu_fill_fake_txdesc,
@@ -334,3 +334,5 @@ static void __exit rtl8192cu_exit(void)
 
 module_init(rtl8192cu_init);
 module_exit(rtl8192cu_exit);
+
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
@@ -498,14 +498,14 @@ static void _rtl_tx_desc_checksum(u8 *tx
 void rtl92cu_tx_fill_desc(struct ieee80211_hw *hw,
 			  struct ieee80211_hdr *hdr, u8 *pdesc_tx,
 			  struct ieee80211_tx_info *info, struct sk_buff *skb,
-			  unsigned int queue_index)
+			  u8 queue_index,
+			  struct rtl_tcb_desc *tcb_desc)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	bool defaultadapter = true;
-	struct ieee80211_sta *sta = info->control.sta;
-	struct rtl_tcb_desc tcb_desc;
+	struct ieee80211_sta *sta = info->control.sta = info->control.sta;
 	u8 *qc = ieee80211_get_qos_ctl(hdr);
 	u8 tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
 	u16 seq_number;
@@ -517,15 +517,15 @@ void rtl92cu_tx_fill_desc(struct ieee802
 	u8 *txdesc;
 
 	seq_number = (le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_SEQ) >> 4;
-	rtl_get_tcb_desc(hw, info, sta, skb, &tcb_desc);
+	rtl_get_tcb_desc(hw, info, sta, skb, tcb_desc);
 	txdesc = (u8 *)skb_push(skb, RTL_TX_HEADER_SIZE);
 	memset(txdesc, 0, RTL_TX_HEADER_SIZE);
 	SET_TX_DESC_PKT_SIZE(txdesc, pktlen);
 	SET_TX_DESC_LINIP(txdesc, 0);
 	SET_TX_DESC_PKT_OFFSET(txdesc, RTL_DUMMY_OFFSET);
 	SET_TX_DESC_OFFSET(txdesc, RTL_TX_HEADER_SIZE);
-	SET_TX_DESC_TX_RATE(txdesc, tcb_desc.hw_rate);
-	if (tcb_desc.use_shortgi || tcb_desc.use_shortpreamble)
+	SET_TX_DESC_TX_RATE(txdesc, tcb_desc->hw_rate);
+	if (tcb_desc->use_shortgi || tcb_desc->use_shortpreamble)
 		SET_TX_DESC_DATA_SHORTGI(txdesc, 1);
 	if (mac->tids[tid].agg.agg_state == RTL_AGG_ON &&
 		    info->flags & IEEE80211_TX_CTL_AMPDU) {
@@ -535,21 +535,21 @@ void rtl92cu_tx_fill_desc(struct ieee802
 		SET_TX_DESC_AGG_BREAK(txdesc, 1);
 	}
 	SET_TX_DESC_SEQ(txdesc, seq_number);
-	SET_TX_DESC_RTS_ENABLE(txdesc, ((tcb_desc.rts_enable &&
-			       !tcb_desc.cts_enable) ? 1 : 0));
-	SET_TX_DESC_HW_RTS_ENABLE(txdesc, ((tcb_desc.rts_enable ||
-				  tcb_desc.cts_enable) ? 1 : 0));
-	SET_TX_DESC_CTS2SELF(txdesc, ((tcb_desc.cts_enable) ? 1 : 0));
-	SET_TX_DESC_RTS_STBC(txdesc, ((tcb_desc.rts_stbc) ? 1 : 0));
-	SET_TX_DESC_RTS_RATE(txdesc, tcb_desc.rts_rate);
+	SET_TX_DESC_RTS_ENABLE(txdesc, ((tcb_desc->rts_enable &&
+			       !tcb_desc->cts_enable) ? 1 : 0));
+	SET_TX_DESC_HW_RTS_ENABLE(txdesc, ((tcb_desc->rts_enable ||
+				  tcb_desc->cts_enable) ? 1 : 0));
+	SET_TX_DESC_CTS2SELF(txdesc, ((tcb_desc->cts_enable) ? 1 : 0));
+	SET_TX_DESC_RTS_STBC(txdesc, ((tcb_desc->rts_stbc) ? 1 : 0));
+	SET_TX_DESC_RTS_RATE(txdesc, tcb_desc->rts_rate);
 	SET_TX_DESC_RTS_BW(txdesc, 0);
-	SET_TX_DESC_RTS_SC(txdesc, tcb_desc.rts_sc);
+	SET_TX_DESC_RTS_SC(txdesc, tcb_desc->rts_sc);
 	SET_TX_DESC_RTS_SHORT(txdesc,
-			      ((tcb_desc.rts_rate <= DESC92C_RATE54M) ?
-			       (tcb_desc.rts_use_shortpreamble ? 1 : 0)
-			       : (tcb_desc.rts_use_shortgi ? 1 : 0)));
+			      ((tcb_desc->rts_rate <= DESC92C_RATE54M) ?
+			       (tcb_desc->rts_use_shortpreamble ? 1 : 0)
+			       : (tcb_desc->rts_use_shortgi ? 1 : 0)));
 	if (mac->bw_40) {
-		if (tcb_desc.packet_bw) {
+		if (tcb_desc->packet_bw) {
 			SET_TX_DESC_DATA_BW(txdesc, 1);
 			SET_TX_DESC_DATA_SC(txdesc, 3);
 		} else {
@@ -590,7 +590,7 @@ void rtl92cu_tx_fill_desc(struct ieee802
 	SET_TX_DESC_DATA_RATE_FB_LIMIT(txdesc, 0x1F);
 	SET_TX_DESC_RTS_RATE_FB_LIMIT(txdesc, 0xF);
 	SET_TX_DESC_DISABLE_FB(txdesc, 0);
-	SET_TX_DESC_USE_RATE(txdesc, tcb_desc.use_driver_rate ? 1 : 0);
+	SET_TX_DESC_USE_RATE(txdesc, tcb_desc->use_driver_rate ? 1 : 0);
 	if (ieee80211_is_data_qos(fc)) {
 		if (mac->rdg_en) {
 			RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE,
@@ -600,11 +600,11 @@ void rtl92cu_tx_fill_desc(struct ieee802
 		}
 	}
 	if (rtlpriv->dm.useramask) {
-		SET_TX_DESC_RATE_ID(txdesc, tcb_desc.ratr_index);
-		SET_TX_DESC_MACID(txdesc, tcb_desc.mac_id);
+		SET_TX_DESC_RATE_ID(txdesc, tcb_desc->ratr_index);
+		SET_TX_DESC_MACID(txdesc, tcb_desc->mac_id);
 	} else {
-		SET_TX_DESC_RATE_ID(txdesc, 0xC + tcb_desc.ratr_index);
-		SET_TX_DESC_MACID(txdesc, tcb_desc.ratr_index);
+		SET_TX_DESC_RATE_ID(txdesc, 0xC + tcb_desc->ratr_index);
+		SET_TX_DESC_MACID(txdesc, tcb_desc->ratr_index);
 	}
 	if ((!ieee80211_is_data_qos(fc)) && ppsc->leisure_ps &&
 	      ppsc->fwctrl_lps) {
@@ -656,7 +656,7 @@ void rtl92cu_tx_fill_cmddesc(struct ieee
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
 	__le16 fc = hdr->frame_control;
 
-	memset(pdesc, 0, RTL_TX_HEADER_SIZE);
+	memset((void *)pdesc, 0, RTL_TX_HEADER_SIZE);
 	if (firstseg)
 		SET_TX_DESC_OFFSET(pdesc, RTL_TX_HEADER_SIZE);
 	SET_TX_DESC_TX_RATE(pdesc, DESC92C_RATE1M);
@@ -685,3 +685,5 @@ bool rtl92cu_cmd_send_packet(struct ieee
 {
 	return true;
 }
+
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/trx.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/trx.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/trx.h
@@ -37,6 +37,8 @@
 #define RTL92C_SIZE_MAX_RX_BUFFER		15360   /* 8192 */
 #define RX_DRV_INFO_SIZE_UNIT			8
 
+#define RTL_AGG_ON				1
+
 enum usb_rx_agg_mode {
 	USB_RX_AGG_DISABLE,
 	USB_RX_AGG_DMA,
@@ -419,7 +421,8 @@ struct sk_buff *rtl8192c_tx_aggregate_hd
 void rtl92cu_tx_fill_desc(struct ieee80211_hw *hw,
 			  struct ieee80211_hdr *hdr, u8 *pdesc_tx,
 			  struct ieee80211_tx_info *info, struct sk_buff *skb,
-			  unsigned int queue_index);
+			  u8 queue_index,
+			  struct rtl_tcb_desc *tcb_desc);
 void rtl92cu_fill_fake_txdesc(struct ieee80211_hw *hw, u8 * pDesc,
 			      u32 buffer_len, bool bIsPsPoll);
 void rtl92cu_tx_fill_cmddesc(struct ieee80211_hw *hw,
@@ -428,3 +431,5 @@ void rtl92cu_tx_fill_cmddesc(struct ieee
 bool rtl92cu_cmd_send_packet(struct ieee80211_hw *hw, struct sk_buff *skb);
 
 #endif
+
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
@@ -82,7 +82,7 @@ void rtl92c_phy_set_bb_reg(struct ieee80
 }
 EXPORT_SYMBOL(rtl92c_phy_set_bb_reg);
 
-static u32 _rtl92c_phy_fw_rf_serial_read(struct ieee80211_hw *hw,
+u32 _rtl92c_phy_fw_rf_serial_read(struct ieee80211_hw *hw,
 					 enum radio_path rfpath, u32 offset)
 {
 	RT_ASSERT(false, ("deprecated!\n"));
@@ -91,7 +91,7 @@ static u32 _rtl92c_phy_fw_rf_serial_read
 }
 EXPORT_SYMBOL(_rtl92c_phy_fw_rf_serial_read);
 
-static void _rtl92c_phy_fw_rf_serial_write(struct ieee80211_hw *hw,
+void _rtl92c_phy_fw_rf_serial_write(struct ieee80211_hw *hw,
 					   enum radio_path rfpath, u32 offset,
 					   u32 data)
 {
@@ -99,7 +99,7 @@ static void _rtl92c_phy_fw_rf_serial_wri
 }
 EXPORT_SYMBOL(_rtl92c_phy_fw_rf_serial_write);
 
-static u32 _rtl92c_phy_rf_serial_read(struct ieee80211_hw *hw,
+u32 _rtl92c_phy_rf_serial_read(struct ieee80211_hw *hw,
 				      enum radio_path rfpath, u32 offset)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -150,7 +150,7 @@ static u32 _rtl92c_phy_rf_serial_read(st
 }
 EXPORT_SYMBOL(_rtl92c_phy_rf_serial_read);
 
-static void _rtl92c_phy_rf_serial_write(struct ieee80211_hw *hw,
+void _rtl92c_phy_rf_serial_write(struct ieee80211_hw *hw,
 					enum radio_path rfpath, u32 offset,
 					u32 data)
 {
@@ -208,7 +208,7 @@ bool rtl92c_phy_rf_config(struct ieee802
 }
 EXPORT_SYMBOL(rtl92c_phy_rf_config);
 
-static bool _rtl92c_phy_bb8192c_config_parafile(struct ieee80211_hw *hw)
+bool _rtl92c_phy_bb8192c_config_parafile(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
@@ -1364,8 +1364,7 @@ static void _rtl92c_phy_iq_calibrate(str
 static void _rtl92c_phy_ap_calibrate(struct ieee80211_hw *hw,
 				     char delta, bool is2t)
 {
-	/* This routine is deliberately dummied out for later fixes */
-#if 0
+#if 0 /* This routine is deliberately dummied out for later fixes */
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
Index: wireless-testing/drivers/net/wireless/rtlwifi/wifi.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/wifi.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/wifi.h
@@ -1370,13 +1370,8 @@ struct rtl_hal_ops {
 				       u32 add_msr, u32 rm_msr);
 	void (*get_hw_reg) (struct ieee80211_hw *hw, u8 variable, u8 *val);
 	void (*set_hw_reg) (struct ieee80211_hw *hw, u8 variable, u8 *val);
-#if 1	/* temporary */
 	void (*update_rate_tbl) (struct ieee80211_hw *hw,
 			      struct ieee80211_sta *sta, u8 rssi_level);
-#endif
-#if 1	/* temporary */
-	void (*update_rate_table) (struct ieee80211_hw *hw);
-#endif
 	void (*update_rate_mask) (struct ieee80211_hw *hw, u8 rssi_level);
 	void (*fill_tx_desc) (struct ieee80211_hw *hw,
 			      struct ieee80211_hdr *hdr, u8 *pdesc_tx,
