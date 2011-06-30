Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40800 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab1F3VqQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 17:46:16 -0400
Date: Thu, 30 Jun 2011 16:46:14 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] rtlwifi: rtl8192{ce,cu,se} Remove irq_enabled
Message-ID: <4e0ceea6.VwwHeLJqoZXlWM3F%Larry.Finger@lwfinger.net> (sfid-20110630_234618_331958_46F84F6F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mike McCormack <mikem@ring3k.org>

This should be unnecessary if synchronize_irq is used.

Signed-off-by: Mike McCormack <mikem@ring3k.org>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This patch only does a cleanup of the source. There are no bugs
involved, thus it is for 3.1.

Larry
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/pci.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
@@ -788,15 +788,11 @@ static irqreturn_t _rtl_pci_interrupt(in
 {
 	struct ieee80211_hw *hw = dev_id;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	unsigned long flags;
 	u32 inta = 0;
 	u32 intb = 0;
 
-	if (rtlpci->irq_enabled == 0)
-		return IRQ_HANDLED;
-
 	spin_lock_irqsave(&rtlpriv->locks.irq_th_lock, flags);
 
 	/*read ISR: 4/8bytes */
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/pci.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/pci.h
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/pci.h
@@ -158,7 +158,6 @@ struct rtl_pci {
 	bool first_init;
 	bool being_init_adapter;
 	bool init_ready;
-	bool irq_enabled;
 
 	/*Tx */
 	struct rtl8192_tx_ring tx_ring[RTL_PCI_MAX_TX_QUEUE_COUNT];
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
@@ -1183,7 +1183,6 @@ void rtl92ce_enable_interrupt(struct iee
 
 	rtl_write_dword(rtlpriv, REG_HIMR, rtlpci->irq_mask[0] & 0xFFFFFFFF);
 	rtl_write_dword(rtlpriv, REG_HIMRE, rtlpci->irq_mask[1] & 0xFFFFFFFF);
-	rtlpci->irq_enabled = true;
 }
 
 void rtl92ce_disable_interrupt(struct ieee80211_hw *hw)
@@ -1193,7 +1192,6 @@ void rtl92ce_disable_interrupt(struct ie
 
 	rtl_write_dword(rtlpriv, REG_HIMR, IMR8190_DISABLED);
 	rtl_write_dword(rtlpriv, REG_HIMRE, IMR8190_DISABLED);
-	rtlpci->irq_enabled = false;
 	synchronize_irq(rtlpci->pdev->irq);
 }
 
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
@@ -380,13 +380,11 @@ void rtl92c_enable_interrupt(struct ieee
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
 
@@ -398,16 +396,9 @@ void rtl92c_init_interrupt(struct ieee80
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
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
@@ -1214,8 +1214,6 @@ void rtl92se_enable_interrupt(struct iee
 	rtl_write_dword(rtlpriv, INTA_MASK, rtlpci->irq_mask[0]);
 	/* Support Bit 32-37(Assign as Bit 0-5) interrupt setting now */
 	rtl_write_dword(rtlpriv, INTA_MASK + 4, rtlpci->irq_mask[1] & 0x3F);
-
-	rtlpci->irq_enabled = true;
 }
 
 void rtl92se_disable_interrupt(struct ieee80211_hw *hw)
@@ -1226,7 +1224,6 @@ void rtl92se_disable_interrupt(struct ie
 	rtl_write_dword(rtlpriv, INTA_MASK, 0);
 	rtl_write_dword(rtlpriv, INTA_MASK + 4, 0);
 
-	rtlpci->irq_enabled = false;
 	synchronize_irq(rtlpci->pdev->irq);
 }
 
