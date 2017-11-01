Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:45364 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752246AbdKAP3h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Nov 2017 11:29:37 -0400
Received: by mail-oi0-f67.google.com with SMTP id f66so5042088oib.2
        for <linux-wireless@vger.kernel.org>; Wed, 01 Nov 2017 08:29:36 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 05/11] rtlwifi: rtl_pci: Add fill_tx_special_desc to issue H2C data, and process TXOK in interrupt.
Date: Wed,  1 Nov 2017 10:29:20 -0500
Message-Id: <20171101152926.24971-6-Larry.Finger@lwfinger.net> (sfid-20171101_163002_772732_E204C3AE)
In-Reply-To: <20171101152926.24971-1-Larry.Finger@lwfinger.net>
References: <20171101152926.24971-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

With the RTL8822BE, an H2C tx queue is added to download FW and special
data. This change implements the support code in rtl_pci.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/pci.c  | 11 +++++++++++
 drivers/net/wireless/realtek/rtlwifi/pci.h  |  1 +
 drivers/net/wireless/realtek/rtlwifi/wifi.h |  4 ++++
 3 files changed, 16 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index e8c8ce601229..0c30f4bf657b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -926,6 +926,7 @@ static irqreturn_t _rtl_pci_interrupt(int irq, void *dev_id)
 	unsigned long flags;
 	u32 inta = 0;
 	u32 intb = 0;
+	u32 intd = 0;
 	irqreturn_t ret = IRQ_HANDLED;
 
 	if (rtlpci->irq_enabled == 0)
@@ -1007,6 +1008,16 @@ static irqreturn_t _rtl_pci_interrupt(int irq, void *dev_id)
 		_rtl_pci_tx_isr(hw, VO_QUEUE);
 	}
 
+	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8822BE) {
+		if (intd & rtlpriv->cfg->maps[RTL_IMR_H2CDOK]) {
+			rtlpriv->link_info.num_tx_inperiod++;
+
+			RT_TRACE(rtlpriv, COMP_INTR, DBG_TRACE,
+				 "H2C TX OK interrupt!\n");
+			_rtl_pci_tx_isr(hw, H2C_QUEUE);
+		}
+	}
+
 	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8192SE) {
 		if (inta & rtlpriv->cfg->maps[RTL_IMR_COMDOK]) {
 			rtlpriv->link_info.num_tx_inperiod++;
diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.h b/drivers/net/wireless/realtek/rtlwifi/pci.h
index 0f1a0f8585b6..6bf346ec4616 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.h
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.h
@@ -51,6 +51,7 @@
 #define MGNT_QUEUE				6
 #define HIGH_QUEUE				7
 #define HCCA_QUEUE				8
+#define H2C_QUEUE				TXCMD_QUEUE	/* In 8822B */
 
 #define RTL_PCI_DEVICE(vend, dev, cfg)  \
 	.vendor = (vend), \
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 22afc14c3da6..f6b00505a69f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -709,6 +709,7 @@ enum rtl_var_map {
 	RTL_IMR_RXFOVW,		/*Receive FIFO Overflow */
 	RTL_IMR_RDU,		/*Receive Descriptor Unavailable */
 	RTL_IMR_ATIMEND,	/*For 92C,ATIM Window End Interrupt */
+	RTL_IMR_H2CDOK,		/*H2C Queue DMA OK Interrupt */
 	RTL_IMR_BDOK,		/*Beacon Queue DMA OK Interrup */
 	RTL_IMR_HIGHDOK,	/*High Queue DMA OK Interrupt */
 	RTL_IMR_COMDOK,		/*Command Queue DMA OK Interrupt*/
@@ -2144,6 +2145,9 @@ struct rtl_hal_ops {
 	void (*fill_tx_cmddesc) (struct ieee80211_hw *hw, u8 *pdesc,
 				 bool firstseg, bool lastseg,
 				 struct sk_buff *skb);
+	void (*fill_tx_special_desc)(struct ieee80211_hw *hw,
+				     u8 *pdesc, u8 *pbd_desc,
+				     struct sk_buff *skb, u8 hw_queue);
 	bool (*query_rx_desc) (struct ieee80211_hw *hw,
 			       struct rtl_stats *stats,
 			       struct ieee80211_rx_status *rx_status,
-- 
2.14.3
