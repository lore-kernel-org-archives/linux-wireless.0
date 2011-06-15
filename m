Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41812 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377Ab1FOXXU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jun 2011 19:23:20 -0400
Received: by pvg12 with SMTP id 12so700898pvg.19
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jun 2011 16:23:19 -0700 (PDT)
Message-ID: <4DF93EBF.1070008@ring3k.org> (sfid-20110616_012324_149907_C26097DB)
Date: Thu, 16 Jun 2011 08:22:39 +0900
From: Mike McCormack <mikem@ring3k.org>
MIME-Version: 1.0
To: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 1/4] rtlwifi: rtl8192{ce,cu,se}: Remove irq_enabled flag
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This should be unnecessary if synchronize_irq is used.

Signed-off-by: Mike McCormack <mikem@ring3k.org>
---
 drivers/net/wireless/rtlwifi/pci.c           |    3 ---
 drivers/net/wireless/rtlwifi/pci.h           |    1 -
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c  |    2 --
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c |    9 ---------
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c  |    4 ----
 5 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index cb4e5e8..d4c2da8 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -794,9 +794,6 @@ static irqreturn_t _rtl_pci_interrupt(int irq, void *dev_id)
 	u32 inta = 0;
 	u32 intb = 0;
 
-	if (rtlpci->irq_enabled == 0)
-		return IRQ_HANDLED;
-
 	spin_lock_irqsave(&rtlpriv->locks.irq_th_lock, flags);
 
 	/*read ISR: 4/8bytes */
diff --git a/drivers/net/wireless/rtlwifi/pci.h b/drivers/net/wireless/rtlwifi/pci.h
index 671b1f5..12a25c5 100644
--- a/drivers/net/wireless/rtlwifi/pci.h
+++ b/drivers/net/wireless/rtlwifi/pci.h
@@ -169,7 +169,6 @@ struct rtl_pci {
 	bool first_init;
 	bool being_init_adapter;
 	bool init_ready;
-	bool irq_enabled;
 
 	/*Tx */
 	struct rtl8192_tx_ring tx_ring[RTL_PCI_MAX_TX_QUEUE_COUNT];
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
index 944f55e..7a7c3ae 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
@@ -1183,7 +1183,6 @@ void rtl92ce_enable_interrupt(struct ieee80211_hw *hw)
 
 	rtl_write_dword(rtlpriv, REG_HIMR, rtlpci->irq_mask[0] & 0xFFFFFFFF);
 	rtl_write_dword(rtlpriv, REG_HIMRE, rtlpci->irq_mask[1] & 0xFFFFFFFF);
-	rtlpci->irq_enabled = true;
 }
 
 void rtl92ce_disable_interrupt(struct ieee80211_hw *hw)
@@ -1193,7 +1192,6 @@ void rtl92ce_disable_interrupt(struct ieee80211_hw *hw)
 
 	rtl_write_dword(rtlpriv, REG_HIMR, IMR8190_DISABLED);
 	rtl_write_dword(rtlpriv, REG_HIMRE, IMR8190_DISABLED);
-	rtlpci->irq_enabled = false;
 	synchronize_irq(rtlpci->pdev->irq);
 }
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
index 4e057df..a90c09b 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
@@ -380,13 +380,11 @@ void rtl92c_enable_interrupt(struct ieee80211_hw *hw)
 				0xFFFFFFFF);
 		rtl_write_dword(rtlpriv, REG_HIMRE, rtlpci->irq_mask[1] &
 				0xFFFFFFFF);
-		rtlpci->irq_enabled = true;
 	} else {
 		rtl_write_dword(rtlpriv, REG_HIMR, rtlusb->irq_mask[0] &
 				0xFFFFFFFF);
 		rtl_write_dword(rtlpriv, REG_HIMRE, rtlusb->irq_mask[1] &
 				0xFFFFFFFF);
-		rtlusb->irq_enabled = true;
 	}
 }
 
@@ -398,16 +396,9 @@ void rtl92c_init_interrupt(struct ieee80211_hw *hw)
 void rtl92c_disable_interrupt(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-	struct rtl_usb *rtlusb = rtl_usbdev(rtl_usbpriv(hw));
 
 	rtl_write_dword(rtlpriv, REG_HIMR, IMR8190_DISABLED);
 	rtl_write_dword(rtlpriv, REG_HIMRE, IMR8190_DISABLED);
-	if (IS_HARDWARE_TYPE_8192CE(rtlhal))
-		rtlpci->irq_enabled = false;
-	else if (IS_HARDWARE_TYPE_8192CU(rtlhal))
-		rtlusb->irq_enabled = false;
 }
 
 void rtl92c_set_qos(struct ieee80211_hw *hw, int aci)
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c b/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
index 5fab47b..1b82684 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
@@ -1213,8 +1213,6 @@ void rtl92se_enable_interrupt(struct ieee80211_hw *hw)
 	rtl_write_dword(rtlpriv, INTA_MASK, rtlpci->irq_mask[0]);
 	/* Support Bit 32-37(Assign as Bit 0-5) interrupt setting now */
 	rtl_write_dword(rtlpriv, INTA_MASK + 4, rtlpci->irq_mask[1] & 0x3F);
-
-	rtlpci->irq_enabled = true;
 }
 
 void rtl92se_disable_interrupt(struct ieee80211_hw *hw)
@@ -1224,8 +1222,6 @@ void rtl92se_disable_interrupt(struct ieee80211_hw *hw)
 
 	rtl_write_dword(rtlpriv, INTA_MASK, 0);
 	rtl_write_dword(rtlpriv, INTA_MASK + 4, 0);
-
-	rtlpci->irq_enabled = false;
 	synchronize_irq(rtlpci->pdev->irq);
 }
 
-- 
1.7.4.1


