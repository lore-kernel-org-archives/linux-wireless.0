Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:40117 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750972AbdKMJlZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 04:41:25 -0500
From: <pkshih@realtek.com>
To: <Larry.Finger@lwfinger.net>, <kvalo@codeaurora.org>
CC: <linux-wireless@vger.kernel.org>, <steventing@realtek.com>,
        <yhchuang@realtek.com>
Subject: [PATCH 2/3] rtlwifi: fix the wrong size to calculate fifo space
Date: Mon, 13 Nov 2017 17:39:34 +0800
Message-ID: <20171113093935.20431-3-pkshih@realtek.com> (sfid-20171113_104129_083797_B8348A99)
In-Reply-To: <20171113093935.20431-1-pkshih@realtek.com>
References: <20171113093935.20431-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Give correct fifo size to calculate fifo space. Fortunately, the values of
RTL_PCI_MAX_RX_COUNT and TX_DESC_NUM_92E are the same in old code, so it
still works.

Signed-off-by: Steven Ting <steventing@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/pci.h           | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c | 6 ++++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.h b/drivers/net/wireless/realtek/rtlwifi/pci.h
index e7d070e8da2d..ed5de1218bd9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.h
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.h
@@ -320,10 +320,10 @@ static inline void pci_write32_async(struct rtl_priv *rtlpriv,
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
index 12255682e890..bc44d9d912d8 100644
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
@@ -560,7 +561,8 @@ u16 rtl92ee_get_available_desc(struct ieee80211_hw *hw, u8 q_idx)
 	current_tx_write_point = (u16)((tmp_4byte) & 0x0fff);
 
 	point_diff = calc_fifo_space(current_tx_read_point,
-				     current_tx_write_point);
+				     current_tx_write_point,
+				     TX_DESC_NUM_92E);
 
 	rtlpci->tx_ring[q_idx].avl_desc = point_diff;
 	return point_diff;
-- 
2.14.1
