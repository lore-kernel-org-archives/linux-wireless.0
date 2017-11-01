Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:46808 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752194AbdKAP3k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Nov 2017 11:29:40 -0400
Received: by mail-oi0-f66.google.com with SMTP id n82so5022358oig.3
        for <linux-wireless@vger.kernel.org>; Wed, 01 Nov 2017 08:29:40 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Steven Ting <steventing@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>, Shaofu <shaofu@realtek.com>
Subject: [PATCH 08/11] rtlwifi: rtl_pci: Refactor TX/RX flow
Date: Wed,  1 Nov 2017 10:29:23 -0500
Message-Id: <20171101152926.24971-9-Larry.Finger@lwfinger.net> (sfid-20171101_162944_861492_D19874FA)
In-Reply-To: <20171101152926.24971-1-Larry.Finger@lwfinger.net>
References: <20171101152926.24971-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Steven Ting <steventing@realtek.com>

After this refactoring, the variables wp and rp in TX ring can only be
updated in OP_TX and TX_OK respectively without protection. The other
changes are listed below:

1. remove avl_desc from TX ring, because it can be calculated by wp and rp.
   Moreover, we update this variable in op_tx (thread context) and TX_OK
   (BH context) without protection.
2. extend calc_fifo_space(rp, wp) to calc_fifo_space(rp, wp, size), and fix
   the caller's parameter 'size'.
3. Get RX remaining counter only if it count down to zero.
4. remove available_desc check from Tx ISR

Signed-off-by: Steven Ting <steventing@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/pci.c         | 13 ++---
 drivers/net/wireless/realtek/rtlwifi/pci.h         |  5 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/trx.c   | 57 ++++------------------
 3 files changed, 15 insertions(+), 60 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index c2575b0b9440..e544f4bcfae9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -557,13 +557,6 @@ static void _rtl_pci_tx_isr(struct ieee80211_hw *hw, int prio)
 		else
 			entry = (u8 *)(&ring->desc[ring->idx]);
 
-		if (rtlpriv->cfg->ops->get_available_desc &&
-		    rtlpriv->cfg->ops->get_available_desc(hw, prio) <= 1) {
-			RT_TRACE(rtlpriv, (COMP_INTR | COMP_SEND), DBG_DMESG,
-				 "no available desc!\n");
-			return;
-		}
-
 		if (!rtlpriv->cfg->ops->is_tx_desc_closed(hw, prio, ring->idx))
 			return;
 		ring->idx = (ring->idx + 1) % ring->entries;
@@ -747,7 +740,7 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 	u8 tmp_one;
 	bool unicast = false;
 	u8 hw_queue = 0;
-	unsigned int rx_remained_cnt;
+	unsigned int rx_remained_cnt = 0;
 	struct rtl_stats stats = {
 		.signal = 0,
 		.rate = 0,
@@ -768,7 +761,8 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 		struct sk_buff *new_skb;
 
 		if (rtlpriv->use_new_trx_flow) {
-			rx_remained_cnt =
+			if (rx_remained_cnt == 0)
+				rx_remained_cnt =
 				rtlpriv->cfg->ops->rx_desc_buff_remained_cnt(hw,
 								      hw_queue);
 			if (rx_remained_cnt == 0)
@@ -1250,7 +1244,6 @@ static int _rtl_pci_init_tx_ring(struct ieee80211_hw *hw,
 
 		rtlpci->tx_ring[prio].cur_tx_rp = 0;
 		rtlpci->tx_ring[prio].cur_tx_wp = 0;
-		rtlpci->tx_ring[prio].avl_desc = entries;
 	}
 
 	/* alloc dma for this ring */
diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.h b/drivers/net/wireless/realtek/rtlwifi/pci.h
index e7d070e8da2d..3fb56c845a61 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.h
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.h
@@ -173,7 +173,6 @@ struct rtl8192_tx_ring {
 	/*add for new trx flow*/
 	struct rtl_tx_buffer_desc *buffer_desc; /*tx buffer descriptor*/
 	dma_addr_t buffer_desc_dma; /*tx bufferd desc dma memory*/
-	u16 avl_desc; /* available_desc_to_write */
 	u16 cur_tx_wp; /* current_tx_write_point */
 	u16 cur_tx_rp; /* current_tx_read_point */
 };
@@ -320,10 +319,10 @@ static inline void pci_write32_async(struct rtl_priv *rtlpriv,
 	writel(val, (u8 __iomem *)rtlpriv->io.pci_mem_start + addr);
 }
 
-static inline u16 calc_fifo_space(u16 rp, u16 wp)
+static inline u16 calc_fifo_space(u16 rp, u16 wp, u16 size)
 {
 	if (rp <= wp)
-		return RTL_PCI_MAX_RX_COUNT - 1 + rp - wp;
+		return size - 1 + rp - wp;
 	return rp - wp - 1;
 }
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
index 12255682e890..4f7444331b07 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
@@ -498,7 +498,8 @@ u16 rtl92ee_rx_desc_buff_remained_cnt(struct ieee80211_hw *hw, u8 queue_index)
 	if (!start_rx)
 		return 0;
 
-	remind_cnt = calc_fifo_space(read_point, write_point);
+	remind_cnt = calc_fifo_space(read_point, write_point,
+				     RTL_PCI_MAX_RX_COUNT);
 
 	if (remind_cnt == 0)
 		return 0;
@@ -548,7 +549,6 @@ static u16 get_desc_addr_fr_q_idx(u16 queue_index)
 
 u16 rtl92ee_get_available_desc(struct ieee80211_hw *hw, u8 q_idx)
 {
-	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u16 point_diff = 0;
 	u16 current_tx_read_point = 0, current_tx_write_point = 0;
@@ -560,9 +560,9 @@ u16 rtl92ee_get_available_desc(struct ieee80211_hw *hw, u8 q_idx)
 	current_tx_write_point = (u16)((tmp_4byte) & 0x0fff);
 
 	point_diff = calc_fifo_space(current_tx_read_point,
-				     current_tx_write_point);
+				     current_tx_write_point,
+				     TX_DESC_NUM_92E);
 
-	rtlpci->tx_ring[q_idx].avl_desc = point_diff;
 	return point_diff;
 }
 
@@ -907,10 +907,6 @@ void rtl92ee_set_desc(struct ieee80211_hw *hw, u8 *pdesc, bool istx,
 		      u8 desc_name, u8 *val)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u16 cur_tx_rp = 0;
-	u16 cur_tx_wp = 0;
-	static bool over_run;
-	u32 tmp = 0;
 	u8 q_idx = *val;
 	bool dma64 = rtlpriv->cfg->mod_params->dma64;
 
@@ -931,38 +927,12 @@ void rtl92ee_set_desc(struct ieee80211_hw *hw, u8 *pdesc, bool istx,
 				return;
 			}
 
+			/* make sure tx desc is available by caller */
 			ring->cur_tx_wp = ((ring->cur_tx_wp + 1) % max_tx_desc);
 
-			if (over_run) {
-				ring->cur_tx_wp = 0;
-				over_run = false;
-			}
-			if (ring->avl_desc > 1) {
-				ring->avl_desc--;
-
-				rtl_write_word(rtlpriv,
-					       get_desc_addr_fr_q_idx(q_idx),
-					       ring->cur_tx_wp);
-			}
-
-			if (ring->avl_desc < (max_tx_desc - 15)) {
-				u16 point_diff = 0;
-
-				tmp =
-				  rtl_read_dword(rtlpriv,
-						 get_desc_addr_fr_q_idx(q_idx));
-				cur_tx_rp = (u16)((tmp >> 16) & 0x0fff);
-				cur_tx_wp = (u16)(tmp & 0x0fff);
-
-				ring->cur_tx_wp = cur_tx_wp;
-				ring->cur_tx_rp = cur_tx_rp;
-				point_diff = ((cur_tx_rp > cur_tx_wp) ?
-					      (cur_tx_rp - cur_tx_wp) :
-					      (TX_DESC_NUM_92E - 1 -
-					       cur_tx_wp + cur_tx_rp));
-
-				ring->avl_desc = point_diff;
-			}
+			rtl_write_word(rtlpriv,
+				       get_desc_addr_fr_q_idx(q_idx),
+				       ring->cur_tx_wp);
 		}
 		break;
 		}
@@ -1044,13 +1014,12 @@ bool rtl92ee_is_tx_desc_closed(struct ieee80211_hw *hw, u8 hw_queue, u16 index)
 {
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u16 read_point, write_point, available_desc_num;
+	u16 read_point, write_point;
 	bool ret = false;
 	static u8 stop_report_cnt;
 	struct rtl8192_tx_ring *ring = &rtlpci->tx_ring[hw_queue];
 
 	{
-		u16 point_diff = 0;
 		u16 cur_tx_rp, cur_tx_wp;
 		u32 tmpu32 = 0;
 
@@ -1060,18 +1029,12 @@ bool rtl92ee_is_tx_desc_closed(struct ieee80211_hw *hw, u8 hw_queue, u16 index)
 		cur_tx_rp = (u16)((tmpu32 >> 16) & 0x0fff);
 		cur_tx_wp = (u16)(tmpu32 & 0x0fff);
 
-		ring->cur_tx_wp = cur_tx_wp;
+		/* don't need to update ring->cur_tx_wp */
 		ring->cur_tx_rp = cur_tx_rp;
-		point_diff = ((cur_tx_rp > cur_tx_wp) ?
-			      (cur_tx_rp - cur_tx_wp) :
-			      (TX_DESC_NUM_92E - cur_tx_wp + cur_tx_rp));
-
-		ring->avl_desc = point_diff;
 	}
 
 	read_point = ring->cur_tx_rp;
 	write_point = ring->cur_tx_wp;
-	available_desc_num = ring->avl_desc;
 
 	if (write_point > read_point) {
 		if (index < write_point && index >= read_point)
-- 
2.14.3
