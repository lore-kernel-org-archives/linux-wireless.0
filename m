Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:58497 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965999AbbBCRP1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 12:15:27 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Troy Tan <troy_tan@realsil.com.cn>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Stable <stable@vger.kernel.org>
Subject: [PATCH RESEND 1/2] rtlwifi: rtl8192ee: Fix handling of new style descriptors
Date: Tue,  3 Feb 2015 11:15:17 -0600
Message-Id: <1422983718-21432-2-git-send-email-Larry.Finger@lwfinger.net> (sfid-20150203_181537_057349_379ACDC6)
In-Reply-To: <1422983718-21432-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1422983718-21432-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Troy Tan <troy_tan@realsil.com.cn>

The hardware and firmware for the RTL8192EE utilize a FIFO list of
descriptors. There were some problems with the initial implementation.
The worst of these failed to detect that the FIFO was becoming full,
which led to the device needing to be power cycled. As this condition
is not relevant to most of the devices supported by rtlwifi, a callback
routine was added to detect this situation. This patch implements the
necessary changes in the pci handler, and the linkage into the appropriate
rtl8192ee routine.

Signed-off-by: Troy Tan <troy_tan@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org> [V3.18]
---
 drivers/net/wireless/rtlwifi/pci.c           | 31 +++++++++++++++++++++-------
 drivers/net/wireless/rtlwifi/rtl8192ee/sw.c  |  3 +--
 drivers/net/wireless/rtlwifi/rtl8192ee/trx.c | 20 ++++++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8192ee/trx.h |  1 +
 drivers/net/wireless/rtlwifi/wifi.h          |  1 +
 5 files changed, 46 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index 846a2e6..88331d7 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -578,6 +578,13 @@ static void _rtl_pci_tx_isr(struct ieee80211_hw *hw, int prio)
 		else
 			entry = (u8 *)(&ring->desc[ring->idx]);
 
+		if (rtlpriv->cfg->ops->get_available_desc &&
+		    rtlpriv->cfg->ops->get_available_desc(hw, prio) <= 1) {
+			RT_TRACE(rtlpriv, (COMP_INTR | COMP_SEND), DBG_DMESG,
+				 "no available desc!\n");
+			return;
+		}
+
 		if (!rtlpriv->cfg->ops->is_tx_desc_closed(hw, prio, ring->idx))
 			return;
 		ring->idx = (ring->idx + 1) % ring->entries;
@@ -641,10 +648,9 @@ static void _rtl_pci_tx_isr(struct ieee80211_hw *hw, int prio)
 
 		ieee80211_tx_status_irqsafe(hw, skb);
 
-		if ((ring->entries - skb_queue_len(&ring->queue))
-				== 2) {
+		if ((ring->entries - skb_queue_len(&ring->queue)) <= 4) {
 
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_LOUD,
+			RT_TRACE(rtlpriv, COMP_ERR, DBG_DMESG,
 				 "more desc left, wake skb_queue@%d, ring->idx = %d, skb_queue_len = 0x%x\n",
 				 prio, ring->idx,
 				 skb_queue_len(&ring->queue));
@@ -786,7 +792,7 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 			rx_remained_cnt =
 				rtlpriv->cfg->ops->rx_desc_buff_remained_cnt(hw,
 								      hw_queue);
-			if (rx_remained_cnt < 1)
+			if (rx_remained_cnt == 0)
 				return;
 
 		} else {	/* rx descriptor */
@@ -834,18 +840,18 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 			else
 				skb_reserve(skb, stats.rx_drvinfo_size +
 					    stats.rx_bufshift);
-
 		} else {
 			RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
 				 "skb->end - skb->tail = %d, len is %d\n",
 				 skb->end - skb->tail, len);
-			break;
+			dev_kfree_skb_any(skb);
+			goto new_trx_end;
 		}
 		/* handle command packet here */
 		if (rtlpriv->cfg->ops->rx_command_packet &&
 		    rtlpriv->cfg->ops->rx_command_packet(hw, stats, skb)) {
 				dev_kfree_skb_any(skb);
-				goto end;
+				goto new_trx_end;
 		}
 
 		/*
@@ -895,6 +901,7 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 		} else {
 			dev_kfree_skb_any(skb);
 		}
+new_trx_end:
 		if (rtlpriv->use_new_trx_flow) {
 			rtlpci->rx_ring[hw_queue].next_rx_rp += 1;
 			rtlpci->rx_ring[hw_queue].next_rx_rp %=
@@ -910,7 +917,6 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 			rtlpriv->enter_ps = false;
 			schedule_work(&rtlpriv->works.lps_change_work);
 		}
-end:
 		if (rtlpriv->use_new_trx_flow) {
 			_rtl_pci_init_one_rxdesc(hw, (u8 *)buffer_desc,
 						 rxring_idx,
@@ -1672,6 +1678,15 @@ static int rtl_pci_tx(struct ieee80211_hw *hw,
 		}
 	}
 
+	if (rtlpriv->cfg->ops->get_available_desc &&
+	    rtlpriv->cfg->ops->get_available_desc(hw, hw_queue) == 0) {
+			RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
+				 "get_available_desc fail\n");
+			spin_unlock_irqrestore(&rtlpriv->locks.irq_th_lock,
+					       flags);
+			return skb->len;
+	}
+
 	if (ieee80211_is_data_qos(fc)) {
 		tid = rtl_get_tid(skb);
 		if (sta) {
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/sw.c b/drivers/net/wireless/rtlwifi/rtl8192ee/sw.c
index 9b5a7d5..c31c6bf 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ee/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ee/sw.c
@@ -113,8 +113,6 @@ int rtl92ee_init_sw_vars(struct ieee80211_hw *hw)
 				  RCR_HTC_LOC_CTRL		|
 				  RCR_AMF			|
 				  RCR_ACF			|
-				  RCR_ADF			|
-				  RCR_AICV			|
 				  RCR_ACRC32			|
 				  RCR_AB			|
 				  RCR_AM			|
@@ -241,6 +239,7 @@ static struct rtl_hal_ops rtl8192ee_hal_ops = {
 	.set_desc = rtl92ee_set_desc,
 	.get_desc = rtl92ee_get_desc,
 	.is_tx_desc_closed = rtl92ee_is_tx_desc_closed,
+	.get_available_desc = rtl92ee_get_available_desc,
 	.tx_polling = rtl92ee_tx_polling,
 	.enable_hw_sec = rtl92ee_enable_hw_security_config,
 	.set_key = rtl92ee_set_key,
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/trx.c b/drivers/net/wireless/rtlwifi/rtl8192ee/trx.c
index 2b60bdc..1245e2f 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ee/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ee/trx.c
@@ -555,6 +555,26 @@ static u16 get_desc_addr_fr_q_idx(u16 queue_index)
 	return desc_address;
 }
 
+u16 rtl92ee_get_available_desc(struct ieee80211_hw *hw, u8 q_idx)
+{
+	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u16 point_diff = 0;
+	u16 current_tx_read_point = 0, current_tx_write_point = 0;
+	u32 tmp_4byte;
+
+	tmp_4byte = rtl_read_dword(rtlpriv,
+				   get_desc_addr_fr_q_idx(q_idx));
+	current_tx_read_point = (u16)((tmp_4byte >> 16) & 0x0fff);
+	current_tx_write_point = (u16)((tmp_4byte) & 0x0fff);
+
+	point_diff = calc_fifo_space(current_tx_read_point,
+				     current_tx_write_point);
+
+	rtlpci->tx_ring[q_idx].avl_desc = point_diff;
+	return point_diff;
+}
+
 void rtl92ee_pre_fill_tx_bd_desc(struct ieee80211_hw *hw,
 				 u8 *tx_bd_desc, u8 *desc, u8 queue_index,
 				 struct sk_buff *skb, dma_addr_t addr)
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/trx.h b/drivers/net/wireless/rtlwifi/rtl8192ee/trx.h
index 5abb749..8f78ac9 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ee/trx.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ee/trx.h
@@ -831,6 +831,7 @@ void rtl92ee_rx_check_dma_ok(struct ieee80211_hw *hw, u8 *header_desc,
 			     u8 queue_index);
 u16	rtl92ee_rx_desc_buff_remained_cnt(struct ieee80211_hw *hw,
 					  u8 queue_index);
+u16 rtl92ee_get_available_desc(struct ieee80211_hw *hw, u8 queue_index);
 void rtl92ee_pre_fill_tx_bd_desc(struct ieee80211_hw *hw,
 				 u8 *tx_bd_desc, u8 *desc, u8 queue_index,
 				 struct sk_buff *skb, dma_addr_t addr);
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index b53d9dd..5157291 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -2182,6 +2182,7 @@ struct rtl_hal_ops {
 	void (*add_wowlan_pattern)(struct ieee80211_hw *hw,
 				   struct rtl_wow_pattern *rtl_pattern,
 				   u8 index);
+	u16 (*get_available_desc)(struct ieee80211_hw *hw, u8 q_idx);
 };
 
 struct rtl_intf_ops {
-- 
2.1.4

