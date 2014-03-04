Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:64167 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105AbaCDWyX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2014 17:54:23 -0500
Received: by mail-ob0-f169.google.com with SMTP id va2so227052obc.0
        for <linux-wireless@vger.kernel.org>; Tue, 04 Mar 2014 14:54:23 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 1/9] rtlwifi: rtl8192ce: rtl8192cu: rtl8192de: rtl8192se: rtl8723ae: rtl8723be: rtl8188eu: Modify for new API
Date: Tue,  4 Mar 2014 16:53:47 -0600
Message-Id: <1393973635-24799-2-git-send-email-Larry.Finger@lwfinger.net> (sfid-20140304_235430_125053_0D6D1811)
In-Reply-To: <1393973635-24799-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1393973635-24799-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The addition of a driver for the RTL8821AE requires a new API for the
fill_tx_desc() and set_desc() callback routines. This commit makes the
appropriate modifications in all the other drivers.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 .../net/wireless/rtlwifi/btcoexist/halbtcoutsrc.c  |   2 +-
 drivers/net/wireless/rtlwifi/pci.c                 |  64 ++++---
 drivers/net/wireless/rtlwifi/pci.h                 |  10 +
 drivers/net/wireless/rtlwifi/rtl8188ee/trx.c       |   8 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/trx.h       |   8 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c       |   5 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.h       |   7 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c       |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.h       |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c       |   5 +-
 drivers/net/wireless/rtlwifi/rtl8192de/trx.h       |   7 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c       |   5 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.h       |   8 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/trx.c       |   5 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/trx.h       |   7 +-
 drivers/net/wireless/rtlwifi/rtl8723be/trx.c       |   5 +-
 drivers/net/wireless/rtlwifi/rtl8723be/trx.h       |   7 +-
 drivers/net/wireless/rtlwifi/usb.c                 |   2 +-
 drivers/net/wireless/rtlwifi/wifi.h                | 201 +++++++++++++++++++--
 19 files changed, 282 insertions(+), 78 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.c
index 9e1217f..b6722de6 100644
--- a/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -980,7 +980,7 @@ void exhalbtc_set_chip_type(u8 chip_type)
 	case BT_RTL8723A:
 		gl_bt_coexist.board_info.bt_chip_type = BTC_CHIP_RTL8723A;
 		break;
-	case BT_RTL8821:
+	case BT_RTL8821A:
 		gl_bt_coexist.board_info.bt_chip_type = BTC_CHIP_RTL8821;
 		break;
 	case BT_RTL8723B:
diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index 2577268..f26f4ff 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -811,19 +811,19 @@ done:
 		if (pci_dma_mapping_error(rtlpci->pdev, bufferaddress))
 			return;
 		tmp_one = 1;
-		rtlpriv->cfg->ops->set_desc((u8 *) pdesc, false,
+		rtlpriv->cfg->ops->set_desc(hw, (u8 *)pdesc, false,
 					    HW_DESC_RXBUFF_ADDR,
 					    (u8 *)&bufferaddress);
-		rtlpriv->cfg->ops->set_desc((u8 *)pdesc, false,
+		rtlpriv->cfg->ops->set_desc(hw, (u8 *)pdesc, false,
 					    HW_DESC_RXPKT_LEN,
 					    (u8 *)&rtlpci->rxbuffersize);
 
 		if (index == rtlpci->rxringcount - 1)
-			rtlpriv->cfg->ops->set_desc((u8 *)pdesc, false,
+			rtlpriv->cfg->ops->set_desc(hw, (u8 *)pdesc, false,
 						    HW_DESC_RXERO,
 						    &tmp_one);
 
-		rtlpriv->cfg->ops->set_desc((u8 *)pdesc, false, HW_DESC_RXOWN,
+		rtlpriv->cfg->ops->set_desc(hw, (u8 *)pdesc, false, HW_DESC_RXOWN,
 					    &tmp_one);
 
 		index = (index + 1) % rtlpci->rxringcount;
@@ -983,6 +983,8 @@ static void _rtl_pci_prepare_bcn_tasklet(struct ieee80211_hw *hw)
 	struct sk_buff *pskb = NULL;
 	struct rtl_tx_desc *pdesc = NULL;
 	struct rtl_tcb_desc tcb_desc;
+	/*This is for new trx flow*/
+	struct rtl_tx_buffer_desc *pbuffer_desc = NULL;
 	u8 temp_one = 1;
 
 	memset(&tcb_desc, 0, sizeof(struct rtl_tcb_desc));
@@ -1004,11 +1006,12 @@ static void _rtl_pci_prepare_bcn_tasklet(struct ieee80211_hw *hw)
 	info = IEEE80211_SKB_CB(pskb);
 	pdesc = &ring->desc[0];
 	rtlpriv->cfg->ops->fill_tx_desc(hw, hdr, (u8 *) pdesc,
-		info, NULL, pskb, BEACON_QUEUE, &tcb_desc);
+					(u8 *)pbuffer_desc, info, NULL, pskb,
+					BEACON_QUEUE, &tcb_desc);
 
 	__skb_queue_tail(&ring->queue, pskb);
 
-	rtlpriv->cfg->ops->set_desc((u8 *) pdesc, true, HW_DESC_OWN,
+	rtlpriv->cfg->ops->set_desc(hw, (u8 *)pdesc, true, HW_DESC_OWN,
 				    &temp_one);
 
 	return;
@@ -1113,7 +1116,7 @@ static int _rtl_pci_init_tx_ring(struct ieee80211_hw *hw,
 					      ((i + 1) % entries) *
 					      sizeof(*ring);
 
-		rtlpriv->cfg->ops->set_desc((u8 *)&(ring[i]),
+		rtlpriv->cfg->ops->set_desc(hw, (u8 *)&(ring[i]),
 					    true, HW_DESC_TX_NEXTDESC_ADDR,
 					    (u8 *)&nextdescaddress);
 	}
@@ -1188,19 +1191,19 @@ static int _rtl_pci_init_rx_ring(struct ieee80211_hw *hw)
 				dev_kfree_skb_any(skb);
 				return 1;
 			}
-			rtlpriv->cfg->ops->set_desc((u8 *)entry, false,
+			rtlpriv->cfg->ops->set_desc(hw, (u8 *)entry, false,
 						    HW_DESC_RXBUFF_ADDR,
 						    (u8 *)&bufferaddress);
-			rtlpriv->cfg->ops->set_desc((u8 *)entry, false,
+			rtlpriv->cfg->ops->set_desc(hw, (u8 *)entry, false,
 						    HW_DESC_RXPKT_LEN,
 						    (u8 *)&rtlpci->
 						    rxbuffersize);
-			rtlpriv->cfg->ops->set_desc((u8 *) entry, false,
+			rtlpriv->cfg->ops->set_desc(hw, (u8 *)entry, false,
 						    HW_DESC_RXOWN,
 						    &tmp_one);
 		}
 
-		rtlpriv->cfg->ops->set_desc((u8 *) entry, false,
+		rtlpriv->cfg->ops->set_desc(hw, (u8 *)entry, false,
 					    HW_DESC_RXERO, &tmp_one);
 	}
 	return 0;
@@ -1331,7 +1334,7 @@ int rtl_pci_reset_trx_ring(struct ieee80211_hw *hw)
 
 			for (i = 0; i < rtlpci->rxringcount; i++) {
 				entry = &rtlpci->rx_ring[rx_queue_idx].desc[i];
-				rtlpriv->cfg->ops->set_desc((u8 *) entry,
+				rtlpriv->cfg->ops->set_desc(hw, (u8 *)entry,
 							    false,
 							    HW_DESC_RXOWN,
 							    &tmp_one);
@@ -1424,6 +1427,7 @@ static int rtl_pci_tx(struct ieee80211_hw *hw,
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct rtl8192_tx_ring *ring;
 	struct rtl_tx_desc *pdesc;
+	struct rtl_tx_buffer_desc *ptx_bd_desc = NULL;
 	u8 idx;
 	u8 hw_queue = _rtl_mac_to_hwqueue(hw, skb);
 	unsigned long flags;
@@ -1464,17 +1468,22 @@ static int rtl_pci_tx(struct ieee80211_hw *hw,
 		idx = 0;
 
 	pdesc = &ring->desc[idx];
-	own = (u8) rtlpriv->cfg->ops->get_desc((u8 *) pdesc,
-			true, HW_DESC_OWN);
+	if (rtlpriv->use_new_trx_flow) {
+		ptx_bd_desc = &ring->buffer_desc[idx];
+	} else {
+		own = (u8) rtlpriv->cfg->ops->get_desc((u8 *)pdesc,
+				true, HW_DESC_OWN);
 
-	if ((own == 1) && (hw_queue != BEACON_QUEUE)) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
-			 "No more TX desc@%d, ring->idx = %d, idx = %d, skb_queue_len = 0x%d\n",
-			 hw_queue, ring->idx, idx,
-			 skb_queue_len(&ring->queue));
+		if ((own == 1) && (hw_queue != BEACON_QUEUE)) {
+			RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
+				 "No more TX desc@%d, ring->idx = %d, idx = %d, skb_queue_len = 0x%d\n",
+				 hw_queue, ring->idx, idx,
+				 skb_queue_len(&ring->queue));
 
-		spin_unlock_irqrestore(&rtlpriv->locks.irq_th_lock, flags);
-		return skb->len;
+			spin_unlock_irqrestore(&rtlpriv->locks.irq_th_lock,
+					       flags);
+			return skb->len;
+		}
 	}
 
 	if (ieee80211_is_data_qos(fc)) {
@@ -1494,17 +1503,20 @@ static int rtl_pci_tx(struct ieee80211_hw *hw,
 		rtlpriv->cfg->ops->led_control(hw, LED_CTL_TX);
 
 	rtlpriv->cfg->ops->fill_tx_desc(hw, hdr, (u8 *)pdesc,
-			info, sta, skb, hw_queue, ptcb_desc);
+			(u8 *)ptx_bd_desc, info, sta, skb, hw_queue, ptcb_desc);
 
 	__skb_queue_tail(&ring->queue, skb);
 
-	rtlpriv->cfg->ops->set_desc((u8 *)pdesc, true,
-				    HW_DESC_OWN, &temp_one);
-
+	if (rtlpriv->use_new_trx_flow) {
+		rtlpriv->cfg->ops->set_desc(hw, (u8 *)pdesc, true,
+					    HW_DESC_OWN, (u8 *)&hw_queue);
+	} else {
+		rtlpriv->cfg->ops->set_desc(hw, (u8 *)pdesc, true,
+					    HW_DESC_OWN, (u8 *)&temp_one);
+	}
 
 	if ((ring->entries - skb_queue_len(&ring->queue)) < 2 &&
 	    hw_queue != BEACON_QUEUE) {
-
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_LOUD,
 			 "less desc left, stop skb_queue@%d, ring->idx = %d, idx = %d, skb_queue_len = 0x%d\n",
 			 hw_queue, ring->idx, idx,
diff --git a/drivers/net/wireless/rtlwifi/pci.h b/drivers/net/wireless/rtlwifi/pci.h
index 2a33335..90174a8 100644
--- a/drivers/net/wireless/rtlwifi/pci.h
+++ b/drivers/net/wireless/rtlwifi/pci.h
@@ -137,12 +137,22 @@ struct rtl_tx_cmd_desc {
 	u32 dword[16];
 } __packed;
 
+/* In new TRX flow, Buffer_desc is new concept
+ * But TX wifi info == TX descriptor in old flow
+ * RX wifi info == RX descriptor in old flow
+ */
+struct rtl_tx_buffer_desc {
+	u32 dword[8]; /*seg = 4*/
+} __packed;
+
 struct rtl8192_tx_ring {
 	struct rtl_tx_desc *desc;
 	dma_addr_t dma;
 	unsigned int idx;
 	unsigned int entries;
 	struct sk_buff_head queue;
+	/*add for new trx flow*/
+	struct rtl_tx_buffer_desc *buffer_desc; /*tx buffer descriptor*/
 };
 
 struct rtl8192_rx_ring {
diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/trx.c b/drivers/net/wireless/rtlwifi/rtl8188ee/trx.c
index 27ace30..2ba6f51 100644
--- a/drivers/net/wireless/rtlwifi/rtl8188ee/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/trx.c
@@ -489,9 +489,8 @@ bool rtl88ee_rx_query_desc(struct ieee80211_hw *hw,
 
 void rtl88ee_tx_fill_desc(struct ieee80211_hw *hw,
 			  struct ieee80211_hdr *hdr, u8 *pdesc_tx,
-			  struct ieee80211_tx_info *info,
-			  struct ieee80211_sta *sta,
-			  struct sk_buff *skb,
+			  u8 *pbd_desc_tx, struct ieee80211_tx_info *info,
+			  struct ieee80211_sta *sta, struct sk_buff *skb,
 			  u8 hw_queue, struct rtl_tcb_desc *ptcb_desc)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -734,7 +733,8 @@ void rtl88ee_tx_fill_cmddesc(struct ieee80211_hw *hw,
 		      pdesc, TX_DESC_SIZE);
 }
 
-void rtl88ee_set_desc(u8 *pdesc, bool istx, u8 desc_name, u8 *val)
+void rtl88ee_set_desc(struct ieee80211_hw *hw, u8 *pdesc, bool istx,
+		      u8 desc_name, u8 *val)
 {
 	if (istx == true) {
 		switch (desc_name) {
diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/trx.h b/drivers/net/wireless/rtlwifi/rtl8188ee/trx.h
index 21ca33a..8c26094 100644
--- a/drivers/net/wireless/rtlwifi/rtl8188ee/trx.h
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/trx.h
@@ -777,15 +777,15 @@ struct rx_desc_88e {
 
 void rtl88ee_tx_fill_desc(struct ieee80211_hw *hw,
 			  struct ieee80211_hdr *hdr, u8 *pdesc_tx,
-			  struct ieee80211_tx_info *info,
-			  struct ieee80211_sta *sta,
-			  struct sk_buff *skb,
+			  u8 *pbd_desc_tx, struct ieee80211_tx_info *info,
+			  struct ieee80211_sta *sta, struct sk_buff *skb,
 			  u8 hw_queue, struct rtl_tcb_desc *ptcb_desc);
 bool rtl88ee_rx_query_desc(struct ieee80211_hw *hw,
 			   struct rtl_stats *status,
 			   struct ieee80211_rx_status *rx_status,
 			   u8 *pdesc, struct sk_buff *skb);
-void rtl88ee_set_desc(u8 *pdesc, bool istx, u8 desc_name, u8 *val);
+void rtl88ee_set_desc(struct ieee80211_hw *hw, u8 *pdesc, bool istx,
+		      u8 desc_name, u8 *val);
 u32 rtl88ee_get_desc(u8 *pdesc, bool istx, u8 desc_name);
 void rtl88ee_tx_polling(struct ieee80211_hw *hw, u8 hw_queue);
 void rtl88ee_tx_fill_cmddesc(struct ieee80211_hw *hw, u8 *pdesc,
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
index 114858d..8f04817 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
@@ -426,7 +426,7 @@ bool rtl92ce_rx_query_desc(struct ieee80211_hw *hw,
 
 void rtl92ce_tx_fill_desc(struct ieee80211_hw *hw,
 			  struct ieee80211_hdr *hdr, u8 *pdesc_tx,
-			  struct ieee80211_tx_info *info,
+			  u8 *pbd_desc_tx, struct ieee80211_tx_info *info,
 			  struct ieee80211_sta *sta,
 			  struct sk_buff *skb,
 			  u8 hw_queue, struct rtl_tcb_desc *tcb_desc)
@@ -666,7 +666,8 @@ void rtl92ce_tx_fill_cmddesc(struct ieee80211_hw *hw,
 		      "H2C Tx Cmd Content", pdesc, TX_DESC_SIZE);
 }
 
-void rtl92ce_set_desc(u8 *pdesc, bool istx, u8 desc_name, u8 *val)
+void rtl92ce_set_desc(struct ieee80211_hw *hw, u8 *pdesc, bool istx,
+		      u8 desc_name, u8 *val)
 {
 	if (istx) {
 		switch (desc_name) {
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
index a7cdd51..9a39ec4 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
@@ -711,8 +711,8 @@ struct rx_desc_92c {
 } __packed;
 
 void rtl92ce_tx_fill_desc(struct ieee80211_hw *hw,
-			  struct ieee80211_hdr *hdr,
-			  u8 *pdesc, struct ieee80211_tx_info *info,
+			  struct ieee80211_hdr *hdr, u8 *pdesc,
+			  u8 *pbd_desc_tx, struct ieee80211_tx_info *info,
 			  struct ieee80211_sta *sta,
 			  struct sk_buff *skb, u8 hw_queue,
 			  struct rtl_tcb_desc *ptcb_desc);
@@ -720,7 +720,8 @@ bool rtl92ce_rx_query_desc(struct ieee80211_hw *hw,
 			   struct rtl_stats *stats,
 			   struct ieee80211_rx_status *rx_status,
 			   u8 *pdesc, struct sk_buff *skb);
-void rtl92ce_set_desc(u8 *pdesc, bool istx, u8 desc_name, u8 *val);
+void rtl92ce_set_desc(struct ieee80211_hw *hw, u8 *pdesc, bool istx,
+		      u8 desc_name, u8 *val);
 u32 rtl92ce_get_desc(u8 *pdesc, bool istx, u8 desc_name);
 void rtl92ce_tx_polling(struct ieee80211_hw *hw, u8 hw_queue);
 void rtl92ce_tx_fill_cmddesc(struct ieee80211_hw *hw, u8 *pdesc,
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
index 1bc21cc..035e0dc 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
@@ -495,7 +495,7 @@ static void _rtl_tx_desc_checksum(u8 *txdesc)
 
 void rtl92cu_tx_fill_desc(struct ieee80211_hw *hw,
 			  struct ieee80211_hdr *hdr, u8 *pdesc_tx,
-			  struct ieee80211_tx_info *info,
+			  u8 *pbd_desc_tx, struct ieee80211_tx_info *info,
 			  struct ieee80211_sta *sta,
 			  struct sk_buff *skb,
 			  u8 queue_index,
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.h b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.h
index 725c53a..fd8051d 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.h
@@ -420,7 +420,7 @@ struct sk_buff *rtl8192c_tx_aggregate_hdl(struct ieee80211_hw *,
 					   struct sk_buff_head *);
 void rtl92cu_tx_fill_desc(struct ieee80211_hw *hw,
 			  struct ieee80211_hdr *hdr, u8 *pdesc_tx,
-			  struct ieee80211_tx_info *info,
+			  u8 *pbd_desc_tx, struct ieee80211_tx_info *info,
 			  struct ieee80211_sta *sta,
 			  struct sk_buff *skb,
 			  u8 queue_index,
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/trx.c b/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
index 0eb0f4a..99c2ab5 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
@@ -545,7 +545,7 @@ static void _rtl92de_insert_emcontent(struct rtl_tcb_desc *ptcb_desc,
 
 void rtl92de_tx_fill_desc(struct ieee80211_hw *hw,
 			  struct ieee80211_hdr *hdr, u8 *pdesc_tx,
-			  struct ieee80211_tx_info *info,
+			  u8 *pbd_desc_tx, struct ieee80211_tx_info *info,
 			  struct ieee80211_sta *sta,
 			  struct sk_buff *skb,
 			  u8 hw_queue, struct rtl_tcb_desc *ptcb_desc)
@@ -786,7 +786,8 @@ void rtl92de_tx_fill_cmddesc(struct ieee80211_hw *hw,
 	SET_TX_DESC_OWN(pdesc, 1);
 }
 
-void rtl92de_set_desc(u8 *pdesc, bool istx, u8 desc_name, u8 *val)
+void rtl92de_set_desc(struct ieee80211_hw *hw, u8 *pdesc, bool istx,
+		      u8 desc_name, u8 *val)
 {
 	if (istx) {
 		switch (desc_name) {
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/trx.h b/drivers/net/wireless/rtlwifi/rtl8192de/trx.h
index c1b5dfb..fb5cf06 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/trx.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/trx.h
@@ -728,8 +728,8 @@ struct rx_desc_92d {
 } __packed;
 
 void rtl92de_tx_fill_desc(struct ieee80211_hw *hw,
-			  struct ieee80211_hdr *hdr,
-			  u8 *pdesc, struct ieee80211_tx_info *info,
+			  struct ieee80211_hdr *hdr, u8 *pdesc,
+			  u8 *pbd_desc_tx, struct ieee80211_tx_info *info,
 			  struct ieee80211_sta *sta,
 			  struct sk_buff *skb, u8 hw_queue,
 			  struct rtl_tcb_desc *ptcb_desc);
@@ -737,7 +737,8 @@ bool rtl92de_rx_query_desc(struct ieee80211_hw *hw,
 			   struct rtl_stats *stats,
 			   struct ieee80211_rx_status *rx_status,
 			   u8 *pdesc, struct sk_buff *skb);
-void rtl92de_set_desc(u8 *pdesc, bool istx, u8 desc_name, u8 *val);
+void rtl92de_set_desc(struct ieee80211_hw *hw, u8 *pdesc, bool istx,
+		      u8 desc_name, u8 *val);
 u32 rtl92de_get_desc(u8 *pdesc, bool istx, u8 desc_name);
 void rtl92de_tx_polling(struct ieee80211_hw *hw, u8 hw_queue);
 void rtl92de_tx_fill_cmddesc(struct ieee80211_hw *hw, u8 *pdesc,
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
index 163a681..36b48be 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
@@ -336,7 +336,7 @@ bool rtl92se_rx_query_desc(struct ieee80211_hw *hw, struct rtl_stats *stats,
 
 void rtl92se_tx_fill_desc(struct ieee80211_hw *hw,
 		struct ieee80211_hdr *hdr, u8 *pdesc_tx,
-		struct ieee80211_tx_info *info,
+		u8 *pbd_desc_tx, struct ieee80211_tx_info *info,
 		struct ieee80211_sta *sta,
 		struct sk_buff *skb,
 		u8 hw_queue, struct rtl_tcb_desc *ptcb_desc)
@@ -573,7 +573,8 @@ void rtl92se_tx_fill_cmddesc(struct ieee80211_hw *hw, u8 *pdesc,
 	}
 }
 
-void rtl92se_set_desc(u8 *pdesc, bool istx, u8 desc_name, u8 *val)
+void rtl92se_set_desc(struct ieee80211_hw *hw, u8 *pdesc, bool istx,
+		      u8 desc_name, u8 *val)
 {
 	if (istx) {
 		switch (desc_name) {
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/trx.h b/drivers/net/wireless/rtlwifi/rtl8192se/trx.h
index 64dd66f..5a13f17 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/trx.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/trx.h
@@ -29,8 +29,9 @@
 #ifndef __REALTEK_PCI92SE_TRX_H__
 #define __REALTEK_PCI92SE_TRX_H__
 
-void rtl92se_tx_fill_desc(struct ieee80211_hw *hw, struct ieee80211_hdr *hdr,
-			  u8 *pdesc, struct ieee80211_tx_info *info,
+void rtl92se_tx_fill_desc(struct ieee80211_hw *hw,
+			  struct ieee80211_hdr *hdr, u8 *pdesc,
+			  u8 *pbd_desc_tx, struct ieee80211_tx_info *info,
 			  struct ieee80211_sta *sta,
 			  struct sk_buff *skb, u8 hw_queue,
 			  struct rtl_tcb_desc *ptcb_desc);
@@ -39,7 +40,8 @@ void rtl92se_tx_fill_cmddesc(struct ieee80211_hw *hw, u8 *pdesc, bool firstseg,
 bool rtl92se_rx_query_desc(struct ieee80211_hw *hw, struct rtl_stats *stats,
 			   struct ieee80211_rx_status *rx_status, u8 *pdesc,
 			   struct sk_buff *skb);
-void rtl92se_set_desc(u8 *pdesc, bool istx, u8 desc_name, u8 *val);
+void rtl92se_set_desc(struct ieee80211_hw *hw, u8 *pdesc, bool istx,
+		      u8 desc_name, u8 *val);
 u32 rtl92se_get_desc(u8 *pdesc, bool istx, u8 desc_name);
 void rtl92se_tx_polling(struct ieee80211_hw *hw, u8 hw_queue);
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/trx.c b/drivers/net/wireless/rtlwifi/rtl8723ae/trx.c
index 721162c..29adf55 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723ae/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723ae/trx.c
@@ -365,7 +365,7 @@ bool rtl8723ae_rx_query_desc(struct ieee80211_hw *hw,
 
 void rtl8723ae_tx_fill_desc(struct ieee80211_hw *hw,
 			    struct ieee80211_hdr *hdr, u8 *pdesc_tx,
-			    struct ieee80211_tx_info *info,
+			    u8 *pbd_desc_tx, struct ieee80211_tx_info *info,
 			    struct ieee80211_sta *sta,
 			    struct sk_buff *skb, u8 hw_queue,
 			    struct rtl_tcb_desc *ptcdesc)
@@ -597,7 +597,8 @@ void rtl8723ae_tx_fill_cmddesc(struct ieee80211_hw *hw,
 		      pdesc, TX_DESC_SIZE);
 }
 
-void rtl8723ae_set_desc(u8 *pdesc, bool istx, u8 desc_name, u8 *val)
+void rtl8723ae_set_desc(struct ieee80211_hw *hw, u8 *pdesc, bool istx,
+			u8 desc_name, u8 *val)
 {
 	if (istx == true) {
 		switch (desc_name) {
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/trx.h b/drivers/net/wireless/rtlwifi/rtl8723ae/trx.h
index c75bfe8..4380b7d 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723ae/trx.h
+++ b/drivers/net/wireless/rtlwifi/rtl8723ae/trx.h
@@ -700,8 +700,8 @@ struct rx_desc_8723e {
 } __packed;
 
 void rtl8723ae_tx_fill_desc(struct ieee80211_hw *hw,
-			    struct ieee80211_hdr *hdr, u8 *pdesc_tx,
-			    struct ieee80211_tx_info *info,
+			    struct ieee80211_hdr *hdr, u8 *pdesc,
+			    u8 *pbd_desc_tx, struct ieee80211_tx_info *info,
 			    struct ieee80211_sta *sta,
 			    struct sk_buff *skb, u8 hw_queue,
 			    struct rtl_tcb_desc *ptcb_desc);
@@ -709,7 +709,8 @@ bool rtl8723ae_rx_query_desc(struct ieee80211_hw *hw,
 			     struct rtl_stats *status,
 			     struct ieee80211_rx_status *rx_status,
 			     u8 *pdesc, struct sk_buff *skb);
-void rtl8723ae_set_desc(u8 *pdesc, bool istx, u8 desc_name, u8 *val);
+void rtl8723ae_set_desc(struct ieee80211_hw *hw, u8 *pdesc, bool istx,
+			u8 desc_name, u8 *val);
 u32 rtl8723ae_get_desc(u8 *pdesc, bool istx, u8 desc_name);
 void rtl8723ae_tx_polling(struct ieee80211_hw *hw, u8 hw_queue);
 void rtl8723ae_tx_fill_cmddesc(struct ieee80211_hw *hw, u8 *pdesc,
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/trx.c b/drivers/net/wireless/rtlwifi/rtl8723be/trx.c
index 7779531..74a75dc 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723be/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723be/trx.c
@@ -639,7 +639,7 @@ bool rtl8723be_rx_query_desc(struct ieee80211_hw *hw,
 
 void rtl8723be_tx_fill_desc(struct ieee80211_hw *hw,
 			    struct ieee80211_hdr *hdr, u8 *pdesc_tx,
-			    struct ieee80211_tx_info *info,
+			    u8 *pbd_desc_tx, struct ieee80211_tx_info *info,
 			    struct ieee80211_sta *sta, struct sk_buff *skb,
 			    u8 hw_queue, struct rtl_tcb_desc *ptcb_desc)
 {
@@ -858,7 +858,8 @@ void rtl8723be_tx_fill_cmddesc(struct ieee80211_hw *hw, u8 *pdesc,
 	SET_TX_DESC_USE_RATE(pdesc, 1);
 }
 
-void rtl8723be_set_desc(u8 *pdesc, bool istx, u8 desc_name, u8 *val)
+void rtl8723be_set_desc(struct ieee80211_hw *hw, u8 *pdesc, bool istx,
+			u8 desc_name, u8 *val)
 {
 	if (istx) {
 		switch (desc_name) {
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/trx.h b/drivers/net/wireless/rtlwifi/rtl8723be/trx.h
index d375cf0..102f33d 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723be/trx.h
+++ b/drivers/net/wireless/rtlwifi/rtl8723be/trx.h
@@ -597,15 +597,16 @@ struct rx_desc_8723be {
 } __packed;
 
 void rtl8723be_tx_fill_desc(struct ieee80211_hw *hw,
-			    struct ieee80211_hdr *hdr, u8 *pdesc_tx,
-			    struct ieee80211_tx_info *info,
+			    struct ieee80211_hdr *hdr, u8 *pdesc,
+			    u8 *pbd_desc_tx, struct ieee80211_tx_info *info,
 			    struct ieee80211_sta *sta, struct sk_buff *skb,
 			    u8 hw_queue, struct rtl_tcb_desc *ptcb_desc);
 bool rtl8723be_rx_query_desc(struct ieee80211_hw *hw,
 			     struct rtl_stats *status,
 			     struct ieee80211_rx_status *rx_status,
 			     u8 *pdesc, struct sk_buff *skb);
-void rtl8723be_set_desc(u8 *pdesc, bool istx, u8 desc_name, u8 *val);
+void rtl8723be_set_desc(struct ieee80211_hw *hw, u8 *pdesc, bool istx,
+			u8 desc_name, u8 *val);
 u32 rtl8723be_get_desc(u8 *pdesc, bool istx, u8 desc_name);
 bool rtl8723be_is_tx_desc_closed(struct ieee80211_hw *hw,
 				 u8 hw_queue, u16 index);
diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index 4e2a726..0398d3e 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -994,7 +994,7 @@ static void _rtl_usb_tx_preprocess(struct ieee80211_hw *hw,
 		seq_number += 1;
 		seq_number <<= 4;
 	}
-	rtlpriv->cfg->ops->fill_tx_desc(hw, hdr, (u8 *)pdesc, info, sta, skb,
+	rtlpriv->cfg->ops->fill_tx_desc(hw, hdr, (u8 *)pdesc, NULL, info, sta, skb,
 					hw_queue, &tcb_desc);
 	if (!ieee80211_has_morefrags(hdr->frame_control)) {
 		if (qc)
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index 2304c7f..5cb799e 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -41,6 +41,22 @@
 #include <linux/completion.h>
 #include "debug.h"
 
+#define	MASKBYTE0				0xff
+#define	MASKBYTE1				0xff00
+#define	MASKBYTE2				0xff0000
+#define	MASKBYTE3				0xff000000
+#define	MASKHWORD				0xffff0000
+#define	MASKLWORD				0x0000ffff
+#define	MASKDWORD				0xffffffff
+#define	MASK12BITS				0xfff
+#define	MASKH4BITS				0xf0000000
+#define MASKOFDM_D				0xffc00000
+#define	MASKCCK					0x3f3f3f3f
+
+#define	MASK4BITS				0x0f
+#define	MASK20BITS				0xfffff
+#define RFREG_OFFSET_MASK			0xfffff
+
 #define RF_CHANGE_BY_INIT			0
 #define RF_CHANGE_BY_IPS			BIT(28)
 #define RF_CHANGE_BY_PS				BIT(29)
@@ -87,7 +103,18 @@
 #define MAC80211_4ADDR_LEN			30
 
 #define CHANNEL_MAX_NUMBER	(14 + 24 + 21)	/* 14 is the max channel no */
+#define CHANNEL_MAX_NUMBER_2G		14
+#define CHANNEL_MAX_NUMBER_5G		54 /* Please refer to
+					    *"phy_GetChnlGroup8812A" and
+					    * "Hal_ReadTxPowerInfo8812A"
+					    */
+#define CHANNEL_MAX_NUMBER_5G_80M	7
 #define CHANNEL_GROUP_MAX	(3 + 9)	/*  ch1~3, 4~9, 10~14 = three groups */
+#define CHANNEL_MAX_NUMBER_5G		54 /* Please refer to
+					    *"phy_GetChnlGroup8812A" and
+					    * "Hal_ReadTxPowerInfo8812A"
+					    */
+#define CHANNEL_MAX_NUMBER_5G_80M	7
 #define MAX_PG_GROUP			13
 #define	CHANNEL_GROUP_MAX_2G		3
 #define	CHANNEL_GROUP_IDX_5GL		3
@@ -115,6 +142,11 @@
 #define MAX_BASE_NUM_IN_PHY_REG_PG_24G  6
 #define MAX_BASE_NUM_IN_PHY_REG_PG_5G	5
 
+#define RTL8192EE_SEG_NUM		1 /* 0:2 seg, 1: 4 seg, 2: 8 seg */
+
+#define DEL_SW_IDX_SZ		30
+#define BAND_NUM			3
+
 enum rf_tx_num {
 	RF_1TX = 0,
 	RF_2TX,
@@ -140,6 +172,8 @@ struct txpower_info_5g {
 	u8 ofdm_diff[MAX_RF_PATH][MAX_TX_COUNT];
 	u8 bw20_diff[MAX_RF_PATH][MAX_TX_COUNT];
 	u8 bw40_diff[MAX_RF_PATH][MAX_TX_COUNT];
+	u8 bw80_diff[MAX_RF_PATH][MAX_TX_COUNT];
+	u8 bw160_diff[MAX_RF_PATH][MAX_TX_COUNT];
 };
 
 enum rate_section {
@@ -186,6 +220,8 @@ enum hardware_type {
 	HARDWARE_TYPE_RTL8723U,
 	HARDWARE_TYPE_RTL8723BE,
 	HARDWARE_TYPE_RTL8188EE,
+	HARDWARE_TYPE_RTL8821AE,
+	HARDWARE_TYPE_RTL8812AE,
 
 	/* keep it last */
 	HARDWARE_TYPE_NUM
@@ -230,6 +266,8 @@ enum hardware_type {
 
 enum scan_operation_backup_opt {
 	SCAN_OPT_BACKUP = 0,
+	SCAN_OPT_BACKUP_BAND0 = 0,
+	SCAN_OPT_BACKUP_BAND1,
 	SCAN_OPT_RESTORE,
 	SCAN_OPT_MAX
 };
@@ -264,7 +302,9 @@ struct bb_reg_def {
 
 enum io_type {
 	IO_CMD_PAUSE_DM_BY_SCAN = 0,
-	IO_CMD_RESUME_DM_BY_SCAN = 1,
+	IO_CMD_PAUSE_BAND0_DM_BY_SCAN = 0,
+	IO_CMD_PAUSE_BAND1_DM_BY_SCAN = 1,
+	IO_CMD_RESUME_DM_BY_SCAN = 2,
 };
 
 enum hw_variables {
@@ -331,6 +371,7 @@ enum hw_variables {
 	HW_VAR_SET_RPWM,
 	HW_VAR_H2C_FW_PWRMODE,
 	HW_VAR_H2C_FW_JOINBSSRPT,
+	HW_VAR_H2C_FW_MEDIASTATUSRPT,
 	HW_VAR_H2C_FW_P2P_PS_OFFLOAD,
 	HW_VAR_FW_PSMODE_STATUS,
 	HW_VAR_RESUME_CLK_ON,
@@ -364,6 +405,7 @@ enum hw_variables {
 	HAL_DEF_WOWLAN,
 	HW_VAR_MRC,
 	HW_VAR_KEEP_ALIVE,
+	HW_VAR_NAV_UPPER,
 
 	HW_VAR_MGT_FILTER,
 	HW_VAR_CTRL_FILTER,
@@ -423,6 +465,7 @@ enum hw_descs {
 	HW_DESC_RXBUFF_ADDR,
 	HW_DESC_RXPKT_LEN,
 	HW_DESC_RXERO,
+	HW_DESC_RX_PREPARE,
 };
 
 enum prime_sc {
@@ -441,6 +484,7 @@ enum rf_type {
 enum ht_channel_width {
 	HT_CHANNEL_WIDTH_20 = 0,
 	HT_CHANNEL_WIDTH_20_40 = 1,
+	HT_CHANNEL_WIDTH_80 = 2,
 };
 
 /* Ref: 802.11i sepc D10.0 7.3.2.25.1
@@ -505,6 +549,9 @@ enum rtl_var_map {
 	MAC_RCR_ACRC32,
 	MAC_RCR_ACF,
 	MAC_RCR_AAP,
+	MAC_HIMR,
+	MAC_HIMRE,
+	MAC_HSISR,
 
 	/*efuse map */
 	EFUSE_TEST,
@@ -679,7 +726,9 @@ enum wireless_mode {
 	WIRELESS_MODE_G = 0x04,
 	WIRELESS_MODE_AUTO = 0x08,
 	WIRELESS_MODE_N_24G = 0x10,
-	WIRELESS_MODE_N_5G = 0x20
+	WIRELESS_MODE_N_5G = 0x20,
+	WIRELESS_MODE_AC_5G = 0x40,
+	WIRELESS_MODE_AC_24G  = 0x80
 };
 
 #define IS_WIRELESS_MODE_A(wirelessmode)	\
@@ -703,6 +752,8 @@ enum ratr_table_mode {
 	RATR_INX_WIRELESS_B = 6,
 	RATR_INX_WIRELESS_MC = 7,
 	RATR_INX_WIRELESS_A = 8,
+	RATR_INX_WIRELESS_AC_5N = 8,
+	RATR_INX_WIRELESS_AC_24N = 9,
 };
 
 enum rtl_link_state {
@@ -837,8 +888,12 @@ struct wireless_stats {
 	long signal_strength;
 
 	u8 rx_rssi_percentage[4];
+	u8 rx_evm_dbm[4];
 	u8 rx_evm_percentage[2];
 
+	u16 rx_cfo_short[4];
+	u16 rx_cfo_tail[4];
+
 	struct rt_smooth_data ui_rssi;
 	struct rt_smooth_data ui_link_quality;
 };
@@ -867,6 +922,10 @@ struct rate_adaptive {
 	u32 ping_rssi_thresh_for_ra;
 	u32 last_ratr;
 	u8 pre_ratr_state;
+	u8 ldpc_thres;
+	bool use_ldpc;
+	bool lower_rts_rate;
+	bool is_special_data;
 };
 
 struct regd_pair_mapping {
@@ -875,6 +934,16 @@ struct regd_pair_mapping {
 	u16 reg_2ghz_ctl;
 };
 
+struct dynamic_primary_cca {
+	u8 pricca_flag;
+	u8 intf_flag;
+	u8 intf_type;
+	u8 dup_rts_flag;
+	u8 monitor_flag;
+	u8 ch_offset;
+	u8 mf_state;
+};
+
 struct rtl_regulatory {
 	char alpha2[2];
 	u16 country_code;
@@ -1010,11 +1079,14 @@ struct rtl_phy {
 	u32 iqk_bb_backup[10];
 	bool iqk_initialized;
 
+	bool rfpath_rx_enable[MAX_RF_PATH];
+	u8 reg_837;
 	/* Dual mac */
 	bool need_iqk;
 	struct iqk_matrix_regs iqk_matrix[IQK_MATRIX_SETTINGS_NUM];
 
 	bool rfpi_enable;
+	bool iqk_in_progress;
 
 	u8 pwrgroup_cnt;
 	u8 cck_high_power;
@@ -1027,6 +1099,9 @@ struct rtl_phy {
 	u8 txpwr_by_rate_base_24g[TX_PWR_BY_RATE_NUM_RF]
 				 [TX_PWR_BY_RATE_NUM_RF]
 				 [MAX_BASE_NUM_IN_PHY_REG_PG_24G];
+	u8 txpwr_by_rate_base_5g[TX_PWR_BY_RATE_NUM_RF]
+				[TX_PWR_BY_RATE_NUM_RF]
+				[MAX_BASE_NUM_IN_PHY_REG_PG_5G];
 	u8 default_initialgain[4];
 
 	/* the current Tx power level */
@@ -1039,6 +1114,7 @@ struct rtl_phy {
 	bool apk_done;
 	u32 reg_rf3c[2];	/* pathA / pathB  */
 
+	u32 backup_rf_0x1a;/*92ee*/
 	/* bfsync */
 	u8 framesync;
 	u32 framesync_c34;
@@ -1047,6 +1123,7 @@ struct rtl_phy {
 	struct phy_parameters hwparam_tables[MAX_TAB];
 	u16 rf_pathmap;
 
+	u8 hw_rof_enable; /*Enable GPIO[9] as WL RF HW PDn source*/
 	enum rt_polarity_ctl polarity_ctl;
 };
 
@@ -1174,6 +1251,7 @@ struct rtl_mac {
 	u8 use_cts_protect;
 	u8 cur_40_prime_sc;
 	u8 cur_40_prime_sc_bk;
+	u8 cur_80_prime_sc;
 	u64 tsf;
 	u8 retry_short;
 	u8 retry_long;
@@ -1276,6 +1354,7 @@ struct rtl_hal {
 	/*Reserve page start offset except beacon in TxQ. */
 	u8 fw_rsvdpage_startoffset;
 	u8 h2c_txcmd_seq;
+	u8 current_ra_rate;
 
 	/* FW Cmd IO related */
 	u16 fwcmd_iomap;
@@ -1315,6 +1394,9 @@ struct rtl_hal {
 	bool disable_amsdu_8k;
 	bool master_of_dmsp;
 	bool slave_of_dmsp;
+
+	u16 rx_tag;/*for 92ee*/
+	u8 rts_en;
 };
 
 struct rtl_security {
@@ -1412,11 +1494,18 @@ struct rtl_dm {
 	u8 txpower_track_control;
 	bool interrupt_migration;
 	bool disable_tx_int;
-	char ofdm_index[2];
+	char ofdm_index[MAX_RF_PATH];
+	u8 default_ofdm_index;
+	u8 default_cck_index;
 	char cck_index;
 	char delta_power_index[MAX_RF_PATH];
 	char delta_power_index_last[MAX_RF_PATH];
 	char power_index_offset[MAX_RF_PATH];
+	char absolute_ofdm_swing_idx[MAX_RF_PATH];
+	char remnant_ofdm_swing_idx[MAX_RF_PATH];
+	char remnant_cck_idx;
+	bool modify_txagc_flag_path_a;
+	bool modify_txagc_flag_path_b;
 
 	bool one_entry_only;
 	struct dm_phy_dbg_info dbginfo;
@@ -1431,9 +1520,10 @@ struct rtl_dm {
 	u8 cfo_threshold;
 	u32 packet_count;
 	u32 packet_count_pre;
+	u8 tx_rate;
 
 	/*88e tx power tracking*/
-	u8	swing_idx_ofdm[2];
+	u8	swing_idx_ofdm[MAX_RF_PATH];
 	u8	swing_idx_ofdm_cur;
 	u8	swing_idx_ofdm_base[MAX_RF_PATH];
 	bool	swing_flag_ofdm;
@@ -1442,10 +1532,43 @@ struct rtl_dm {
 	u8	swing_idx_cck_base;
 	bool	swing_flag_cck;
 
+	char	swing_diff_2g;
+	char	swing_diff_5g;
+
+	u8 delta_swing_table_idx_24gccka_p[DEL_SW_IDX_SZ];
+	u8 delta_swing_table_idx_24gccka_n[DEL_SW_IDX_SZ];
+	u8 delta_swing_table_idx_24gcckb_p[DEL_SW_IDX_SZ];
+	u8 delta_swing_table_idx_24gcckb_n[DEL_SW_IDX_SZ];
+	u8 delta_swing_table_idx_24ga_p[DEL_SW_IDX_SZ];
+	u8 delta_swing_table_idx_24ga_n[DEL_SW_IDX_SZ];
+	u8 delta_swing_table_idx_24gb_p[DEL_SW_IDX_SZ];
+	u8 delta_swing_table_idx_24gb_n[DEL_SW_IDX_SZ];
+	u8 delta_swing_table_idx_5ga_p[BAND_NUM][DEL_SW_IDX_SZ];
+	u8 delta_swing_table_idx_5ga_n[BAND_NUM][DEL_SW_IDX_SZ];
+	u8 delta_swing_table_idx_5gb_p[BAND_NUM][DEL_SW_IDX_SZ];
+	u8 delta_swing_table_idx_5gb_n[BAND_NUM][DEL_SW_IDX_SZ];
+	u8 delta_swing_table_idx_24ga_p_8188e[DEL_SW_IDX_SZ];
+	u8 delta_swing_table_idx_24ga_n_8188e[DEL_SW_IDX_SZ];
+
 	/* DMSP */
 	bool supp_phymode_switch;
 
+	/* DulMac */
 	struct fast_ant_training fat_table;
+
+	u8	resp_tx_path;
+	u8	path_sel;
+	u32	patha_sum;
+	u32	pathb_sum;
+	u32	patha_cnt;
+	u32	pathb_cnt;
+
+	u8 pre_channel;
+	u8 *p_channel;
+	u8 linked_interval;
+
+	u64 last_tx_ok_cnt;
+	u64 last_rx_ok_cnt;
 };
 
 #define	EFUSE_MAX_LOGICAL_SIZE			256
@@ -1491,11 +1614,6 @@ struct rtl_efuse {
 	u8 eeprom_chnlarea_txpwr_cck[MAX_RF_PATH][CHANNEL_GROUP_MAX_2G];
 	u8 eeprom_chnlarea_txpwr_ht40_1s[MAX_RF_PATH][CHANNEL_GROUP_MAX];
 	u8 eprom_chnl_txpwr_ht40_2sdf[MAX_RF_PATH][CHANNEL_GROUP_MAX];
-	u8 txpwrlevel_cck[2][CHANNEL_MAX_NUMBER_2G];
-	/* For HT 40MHZ pwr */
-	u8 txpwrlevel_ht40_1s[MAX_RF_PATH][CHANNEL_MAX_NUMBER];
-	u8 txpwrlevel_ht40_2s[MAX_RF_PATH][CHANNEL_MAX_NUMBER];
-	u8 txpwr_ht40diff[MAX_RF_PATH][MAX_TX_COUNT];/*BW40_24G_Diff*/
 
 	u8 internal_pa_5g[2];	/* pathA / pathB */
 	u8 eeprom_c9;
@@ -1506,9 +1624,38 @@ struct rtl_efuse {
 	u8 pwrgroup_ht20[2][CHANNEL_MAX_NUMBER];
 	u8 pwrgroup_ht40[2][CHANNEL_MAX_NUMBER];
 
-	char txpwr_ht20diff[2][CHANNEL_MAX_NUMBER]; /*HT 20<->40 Pwr diff */
-	/*For HT<->legacy pwr diff*/
-	u8 txpwr_legacyhtdiff[2][CHANNEL_MAX_NUMBER];
+	u8 txpwrlevel_cck[MAX_RF_PATH][CHANNEL_MAX_NUMBER_2G];
+	/*For HT 40MHZ pwr */
+	u8 txpwrlevel_ht40_1s[MAX_RF_PATH][CHANNEL_MAX_NUMBER];
+	/*For HT 40MHZ pwr */
+	u8 txpwrlevel_ht40_2s[MAX_RF_PATH][CHANNEL_MAX_NUMBER];
+
+	/*--------------------------------------------------------*
+	 * 8192CE\8192SE\8192DE\8723AE use the following 4 arrays,
+	 * other ICs (8188EE\8723BE\8192EE\8812AE...)
+	 * define new arrays in Windows code.
+	 * BUT, in linux code, we use the same array for all ICs.
+	 *
+	 * The Correspondance relation between two arrays is:
+	 * txpwr_cckdiff[][] == CCK_24G_Diff[][]
+	 * txpwr_ht20diff[][] == BW20_24G_Diff[][]
+	 * txpwr_ht40diff[][] == BW40_24G_Diff[][]
+	 * txpwr_legacyhtdiff[][] == OFDM_24G_Diff[][]
+	 *
+	 * Sizes of these arrays are decided by the larger ones.
+	 */
+	char txpwr_cckdiff[MAX_RF_PATH][CHANNEL_MAX_NUMBER];
+	char txpwr_ht20diff[MAX_RF_PATH][CHANNEL_MAX_NUMBER];
+	char txpwr_ht40diff[MAX_RF_PATH][CHANNEL_MAX_NUMBER];
+	char txpwr_legacyhtdiff[MAX_RF_PATH][CHANNEL_MAX_NUMBER];
+
+	u8 txpwr_5g_bw40base[MAX_RF_PATH][CHANNEL_MAX_NUMBER];
+	u8 txpwr_5g_bw80base[MAX_RF_PATH][CHANNEL_MAX_NUMBER_5G_80M];
+	char txpwr_5g_ofdmdiff[MAX_RF_PATH][MAX_TX_COUNT];
+	char txpwr_5g_bw20diff[MAX_RF_PATH][MAX_TX_COUNT];
+	char txpwr_5g_bw40diff[MAX_RF_PATH][MAX_TX_COUNT];
+	char txpwr_5g_bw80diff[MAX_RF_PATH][MAX_TX_COUNT];
+
 	u8 txpwr_safetyflag;			/* Band edge enable flag */
 	u16 eeprom_txpowerdiff;
 	u8 legacy_httxpowerdiff;	/* Legacy to HT rate power diff */
@@ -1639,7 +1786,9 @@ struct rtl_stats {
 	bool rx_is40Mhzpacket;
 	u32 rx_pwdb_all;
 	u8 rx_mimo_signalstrength[4];	/*in 0~100 index */
-	s8 rx_mimo_sig_qual[2];
+	s8 rx_mimo_sig_qual[4];
+	u8 rx_pwr[4]; /* per-path's pwdb */
+	u8 rx_snr[4]; /* per-path's SNR */
 	bool packet_matchbssid;
 	bool is_cck;
 	bool is_ht;
@@ -1743,9 +1892,17 @@ struct rtl_hal_ops {
 	void (*set_hw_reg) (struct ieee80211_hw *hw, u8 variable, u8 *val);
 	void (*update_rate_tbl) (struct ieee80211_hw *hw,
 			      struct ieee80211_sta *sta, u8 rssi_level);
+	void (*pre_fill_tx_bd_desc)(struct ieee80211_hw *hw, u8 *tx_bd_desc,
+				    u8 *desc, u8 queue_index,
+				    struct sk_buff *skb, dma_addr_t addr);
 	void (*update_rate_mask) (struct ieee80211_hw *hw, u8 rssi_level);
+	u16 (*rx_desc_buff_remained_cnt)(struct ieee80211_hw *hw,
+					 u8 queue_index);
+	void (*rx_check_dma_ok)(struct ieee80211_hw *hw, u8 *header_desc,
+				u8 queue_index);
 	void (*fill_tx_desc) (struct ieee80211_hw *hw,
 			      struct ieee80211_hdr *hdr, u8 *pdesc_tx,
+			      u8 *pbd_desc_tx,
 			      struct ieee80211_tx_info *info,
 			      struct ieee80211_sta *sta,
 			      struct sk_buff *skb, u8 hw_queue,
@@ -1768,7 +1925,8 @@ struct rtl_hal_ops {
 				    enum rf_pwrstate rfpwr_state);
 	void (*led_control) (struct ieee80211_hw *hw,
 			     enum led_ctl_mode ledaction);
-	void (*set_desc) (u8 *pdesc, bool istx, u8 desc_name, u8 *val);
+	void (*set_desc)(struct ieee80211_hw *hw, u8 *pdesc, bool istx,
+			 u8 desc_name, u8 *val);
 	u32 (*get_desc) (u8 *pdesc, bool istx, u8 desc_name);
 	bool (*is_tx_desc_closed) (struct ieee80211_hw *hw,
 				   u8 hw_queue, u16 index);
@@ -1812,6 +1970,8 @@ struct rtl_hal_ops {
 			      u32 cmd_len, u8 *p_cmdbuffer);
 	bool (*get_btc_status) (void);
 	bool (*is_fw_header) (struct rtl92c_firmware_header *hdr);
+	u32 (*rx_command_packet)(struct ieee80211_hw *hw,
+				 struct rtl_stats status, struct sk_buff *skb);
 };
 
 struct rtl_intf_ops {
@@ -1921,6 +2081,8 @@ struct rtl_locks {
 
 	/*Easy concurrent*/
 	spinlock_t check_sendpkt_lock;
+
+	spinlock_t iqk_lock;
 };
 
 struct rtl_works {
@@ -2014,6 +2176,7 @@ struct dig_t {
 	u8 cursta_cstate;
 	u8 presta_cstate;
 	u8 curmultista_cstate;
+	u8 stop_dig;
 	char back_val;
 	char back_range_max;
 	char back_range_min;
@@ -2031,6 +2194,7 @@ struct dig_t {
 	u8 cur_ccasate;
 	u8 large_fa_hit;
 	u8 dig_dynamic_min;
+	u8 dig_dynamic_min_1;
 	u8 forbidden_igi;
 	u8 dig_state;
 	u8 dig_highpwrstate;
@@ -2174,6 +2338,7 @@ struct rtl_priv {
 
 	struct rtl_ps_ctl psc;
 	struct rate_adaptive ra;
+	struct dynamic_primary_cca primarycca;
 	struct wireless_stats stats;
 	struct rt_link_detect link_info;
 	struct false_alarm_statistics falsealm_cnt;
@@ -2259,9 +2424,15 @@ enum bt_co_type {
 	BT_CSR_BC8 = 4,
 	BT_RTL8756 = 5,
 	BT_RTL8723A = 6,
-	BT_RTL8821 = 7,
+	BT_RTL8821A = 7,
 	BT_RTL8723B = 8,
 	BT_RTL8192E = 9,
+	BT_RTL8812A = 11,
+};
+
+enum bt_total_ant_num {
+	ANT_TOTAL_X2 = 0,
+	ANT_TOTAL_X1 = 1
 };
 
 enum bt_cur_state {
-- 
1.8.4.5

