Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:51317 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752246AbdKAP3c (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Nov 2017 11:29:32 -0400
Received: by mail-oi0-f67.google.com with SMTP id j126so5002930oib.8
        for <linux-wireless@vger.kernel.org>; Wed, 01 Nov 2017 08:29:32 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 01/11] rtlwifi: rtl_pci: Fix formatting errors in pci.h
Date: Wed,  1 Nov 2017 10:29:16 -0500
Message-Id: <20171101152926.24971-2-Larry.Finger@lwfinger.net> (sfid-20171101_162938_042845_8D488BED)
In-Reply-To: <20171101152926.24971-1-Larry.Finger@lwfinger.net>
References: <20171101152926.24971-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Checkpatch.pl reports a number of formatting problems in this header
file. None of the changes cause any functional changes in the driver.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/pci.h | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.h b/drivers/net/wireless/realtek/rtlwifi/pci.h
index 1af92b34979d..e331f5a3b35f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.h
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.h
@@ -27,10 +27,9 @@
 #define __RTL_PCI_H__
 
 #include <linux/pci.h>
-/*
-1: MSDU packet queue,
-2: Rx Command Queue
-*/
+/* 1: MSDU packet queue,
+ * 2: Rx Command Queue
+ */
 #define RTL_PCI_RX_MPDU_QUEUE			0
 #define RTL_PCI_RX_CMD_QUEUE			1
 #define RTL_PCI_MAX_RX_QUEUE			2
@@ -223,8 +222,9 @@ struct rtl_pci {
 	u8 const_hostpci_aspm_setting;
 	/*pci-e device */
 	u8 const_devicepci_aspm_setting;
-	/*If it supports ASPM, Offset[560h] = 0x40,
-	   otherwise Offset[560h] = 0x00. */
+	/* If it supports ASPM, Offset[560h] = 0x40,
+	 * otherwise Offset[560h] = 0x00.
+	 */
 	bool support_aspm;
 	bool support_backdoor;
 
@@ -279,7 +279,7 @@ int rtl_pci_reset_trx_ring(struct ieee80211_hw *hw);
 extern const struct rtl_intf_ops rtl_pci_ops;
 
 int rtl_pci_probe(struct pci_dev *pdev,
-			    const struct pci_device_id *id);
+		  const struct pci_device_id *id);
 void rtl_pci_disconnect(struct pci_dev *pdev);
 #ifdef CONFIG_PM_SLEEP
 int rtl_pci_suspend(struct device *dev);
@@ -287,34 +287,34 @@ int rtl_pci_resume(struct device *dev);
 #endif /* CONFIG_PM_SLEEP */
 static inline u8 pci_read8_sync(struct rtl_priv *rtlpriv, u32 addr)
 {
-	return readb((u8 __iomem *) rtlpriv->io.pci_mem_start + addr);
+	return readb((u8 __iomem *)rtlpriv->io.pci_mem_start + addr);
 }
 
 static inline u16 pci_read16_sync(struct rtl_priv *rtlpriv, u32 addr)
 {
-	return readw((u8 __iomem *) rtlpriv->io.pci_mem_start + addr);
+	return readw((u8 __iomem *)rtlpriv->io.pci_mem_start + addr);
 }
 
 static inline u32 pci_read32_sync(struct rtl_priv *rtlpriv, u32 addr)
 {
-	return readl((u8 __iomem *) rtlpriv->io.pci_mem_start + addr);
+	return readl((u8 __iomem *)rtlpriv->io.pci_mem_start + addr);
 }
 
 static inline void pci_write8_async(struct rtl_priv *rtlpriv, u32 addr, u8 val)
 {
-	writeb(val, (u8 __iomem *) rtlpriv->io.pci_mem_start + addr);
+	writeb(val, (u8 __iomem *)rtlpriv->io.pci_mem_start + addr);
 }
 
 static inline void pci_write16_async(struct rtl_priv *rtlpriv,
 				     u32 addr, u16 val)
 {
-	writew(val, (u8 __iomem *) rtlpriv->io.pci_mem_start + addr);
+	writew(val, (u8 __iomem *)rtlpriv->io.pci_mem_start + addr);
 }
 
 static inline void pci_write32_async(struct rtl_priv *rtlpriv,
 				     u32 addr, u32 val)
 {
-	writel(val, (u8 __iomem *) rtlpriv->io.pci_mem_start + addr);
+	writel(val, (u8 __iomem *)rtlpriv->io.pci_mem_start + addr);
 }
 
 static inline u16 calc_fifo_space(u16 rp, u16 wp)
-- 
2.14.3
