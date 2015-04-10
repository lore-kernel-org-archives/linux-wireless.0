Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:33916 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbbDJHu1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Apr 2015 03:50:27 -0400
Received: by pdbqa5 with SMTP id qa5so14805855pdb.1
        for <linux-wireless@vger.kernel.org>; Fri, 10 Apr 2015 00:50:26 -0700 (PDT)
From: Taehee Yoo <ap420073@gmail.com>
To: Larry.Finger@lwfinger.net, ap420073@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192cu: Remove pci check routine in rtl92c_enable_interrupt.
Date: Fri, 10 Apr 2015 16:49:59 +0900
Message-Id: <1428652199-28713-1-git-send-email-ap420073@gmail.com> (sfid-20150410_095031_611314_15906AA9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I change three things about below.

1. remove pci interface check routine in rtl92c_enable_interrupt
because rtl8192cu chipset is always usb interface.

2. rename rtl92c_xxx_interrupt to rtl92cu_xxx_interrupt.
rtl92c_xxx_interrupt functions can only be handled rtl8192cu chipset.

3. remove rtl92c_init_interrupt wrapper function
because rtl92cu_enable_interrupt does not need to have the wrapper function anymore.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c  |  2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c | 27 +++++++--------------------
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.h |  5 ++---
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c  |  4 ++--
 4 files changed, 12 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
index d310d55..54516aa 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -877,7 +877,7 @@ static int _rtl92cu_init_mac(struct ieee80211_hw *hw)
 				     queue_sel);
 	/* Get Rx PHY status in order to report RSSI and others. */
 	rtl92c_init_driver_info_size(hw, RTL92C_DRIVER_INFO_SIZE);
-	rtl92c_init_interrupt(hw);
+	rtl92cu_enable_interrupt(hw);
 	rtl92c_init_network_type(hw);
 	_rtl92cu_init_wmac_setting(hw);
 	rtl92c_init_adaptive_ctrl(hw);
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
index adb8107..6d7c8b0 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
@@ -369,37 +369,24 @@ u32 rtl92c_get_txdma_status(struct ieee80211_hw *hw)
 	return rtl_read_dword(rtlpriv, REG_TXDMA_STATUS);
 }
 
-void rtl92c_enable_interrupt(struct ieee80211_hw *hw)
+void rtl92cu_enable_interrupt(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_usb *rtlusb = rtl_usbdev(rtl_usbpriv(hw));
 
-	if (IS_HARDWARE_TYPE_8192CE(rtlhal)) {
-		rtl_write_dword(rtlpriv, REG_HIMR, rtlpci->irq_mask[0] &
-				0xFFFFFFFF);
-		rtl_write_dword(rtlpriv, REG_HIMRE, rtlpci->irq_mask[1] &
-				0xFFFFFFFF);
-	} else {
-		rtl_write_dword(rtlpriv, REG_HIMR, rtlusb->irq_mask[0] &
-				0xFFFFFFFF);
-		rtl_write_dword(rtlpriv, REG_HIMRE, rtlusb->irq_mask[1] &
-				0xFFFFFFFF);
-	}
-}
-
-void rtl92c_init_interrupt(struct ieee80211_hw *hw)
-{
-	 rtl92c_enable_interrupt(hw);
+	rtl_write_dword(rtlpriv, REG_HIMR, rtlusb->irq_mask[0] & 0xFFFFFFFF);
+	rtl_write_dword(rtlpriv, REG_HIMRE, rtlusb->irq_mask[1] & 0xFFFFFFFF);
+	rtlusb->irq_enabled = true;
 }
 
-void rtl92c_disable_interrupt(struct ieee80211_hw *hw)
+void rtl92cu_disable_interrupt(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_usb *rtlusb = rtl_usbdev(rtl_usbpriv(hw));
 
 	rtl_write_dword(rtlpriv, REG_HIMR, IMR8190_DISABLED);
 	rtl_write_dword(rtlpriv, REG_HIMRE, IMR8190_DISABLED);
+	rtlusb->irq_enabled = false;
 }
 
 void rtl92c_set_qos(struct ieee80211_hw *hw, int aci)
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.h b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.h
index bf53652..165f468 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.h
@@ -40,8 +40,8 @@ bool rtl92c_init_llt_table(struct ieee80211_hw *hw, u32 boundary);
 void rtl92c_set_key(struct ieee80211_hw *hw, u32 key_index,
 		     u8 *p_macaddr, bool is_group, u8 enc_algo,
 		     bool is_wepkey, bool clear_all);
-void rtl92c_enable_interrupt(struct ieee80211_hw *hw);
-void rtl92c_disable_interrupt(struct ieee80211_hw *hw);
+void rtl92cu_enable_interrupt(struct ieee80211_hw *hw);
+void rtl92cu_disable_interrupt(struct ieee80211_hw *hw);
 void rtl92c_set_qos(struct ieee80211_hw *hw, int aci);
 
 
@@ -49,7 +49,6 @@ void rtl92c_set_qos(struct ieee80211_hw *hw, int aci);
  *	Hardware init functions
  *---------------------------------------------------------------*/
 void rtl92c_set_mac_addr(struct ieee80211_hw *hw, const u8 *addr);
-void rtl92c_init_interrupt(struct ieee80211_hw *hw);
 void rtl92c_init_driver_info_size(struct ieee80211_hw *hw, u8 size);
 
 int rtl92c_set_network_type(struct ieee80211_hw *hw, enum nl80211_iftype type);
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
index 23806c2..899a40f 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -112,8 +112,8 @@ static struct rtl_hal_ops rtl8192cu_hal_ops = {
 	.deinit_sw_vars = rtl92cu_deinit_sw_vars,
 	.read_chip_version = rtl92c_read_chip_version,
 	.read_eeprom_info = rtl92cu_read_eeprom_info,
-	.enable_interrupt = rtl92c_enable_interrupt,
-	.disable_interrupt = rtl92c_disable_interrupt,
+	.enable_interrupt = rtl92cu_enable_interrupt,
+	.disable_interrupt = rtl92cu_disable_interrupt,
 	.hw_init = rtl92cu_hw_init,
 	.hw_disable = rtl92cu_card_disable,
 	.set_network_type = rtl92cu_set_network_type,
-- 
1.9.1

