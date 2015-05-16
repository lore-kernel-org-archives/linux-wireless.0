Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:34606 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992449AbbEPC3e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2015 22:29:34 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
	Vincent Fann <vincent_fann@realtek.com>,
	Shao Fu <shaofu@realtek.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Stable <stable@vger.kernel.org>
Subject: [PATCH 4.1] rtlwifi: Remove the clear interrupt routine from all drivers
Date: Fri, 15 May 2015 21:29:27 -0500
Message-Id: <1431743367-10059-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20150516_042946_349462_7C9D7F48)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vincent Fann <vincent_fann@realtek.com>

Several of these drivers have there TX randomly blocked for 3~5 seconds while
measuring tx throughput (iperf). The root couse happens in rtl_pci_flush().
The function uses a while-loop to wait for TX queue length to decrease to 0.
The TX queue length counts the number of packets that are queued in the driver.
The driver relys on the TX OK interrupt to return skb and reduce TX queue length.

The interrupt subroutine disables interupts, reads the interrupt registers, and
then clears the registers in the beginning of _rtl_pci_interrupt(). After all
interupts process are finished, the driver invokes enable_interrupt() to enable
interupts. This behavior is normal for an interrupt subroutine.

But enable_interrupt() invokes clear_interrupt() again. This unexpected interrupt
clearing may cleari me fresh TX OK interrupts. These missing interrupts cause TX
queue length to never reduce to 0i, which causes rtl_pci_flush() to be stuck in
unterminated while-loop.

This patch removes clear_interrupt() in enable_interrupt() to avoid this behavior.

Signed-off-by: Vincent Fann <vincent_fann@realtek.com>
Signed-off-by: Shao Fu <shaofu@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org> [3.18+]
---

Kalle,

This patch is a little large for the current kernel and stable; however, it only
deletes code that is clearly wrong. I hope it will be OK.

Larry
---
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c | 16 ----------------
 drivers/net/wireless/rtlwifi/rtl8192ee/hw.c | 17 -----------------
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.c | 13 -------------
 drivers/net/wireless/rtlwifi/rtl8723be/hw.c | 17 -----------------
 drivers/net/wireless/rtlwifi/rtl8821ae/hw.c | 20 --------------------
 5 files changed, 83 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
index 86ce5b1..e5d8108f 100644
--- a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
@@ -1354,27 +1354,11 @@ void rtl88ee_set_qos(struct ieee80211_hw *hw, int aci)
 	}
 }
 
-static void rtl88ee_clear_interrupt(struct ieee80211_hw *hw)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u32 tmp;
-
-	tmp = rtl_read_dword(rtlpriv, REG_HISR);
-	rtl_write_dword(rtlpriv, REG_HISR, tmp);
-
-	tmp = rtl_read_dword(rtlpriv, REG_HISRE);
-	rtl_write_dword(rtlpriv, REG_HISRE, tmp);
-
-	tmp = rtl_read_dword(rtlpriv, REG_HSISR);
-	rtl_write_dword(rtlpriv, REG_HSISR, tmp);
-}
-
 void rtl88ee_enable_interrupt(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 
-	rtl88ee_clear_interrupt(hw);/*clear it here first*/
 	rtl_write_dword(rtlpriv, REG_HIMR,
 			rtlpci->irq_mask[0] & 0xFFFFFFFF);
 	rtl_write_dword(rtlpriv, REG_HIMRE,
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/hw.c b/drivers/net/wireless/rtlwifi/rtl8192ee/hw.c
index 2786ccf..0586ecb 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ee/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ee/hw.c
@@ -1584,28 +1584,11 @@ void rtl92ee_set_qos(struct ieee80211_hw *hw, int aci)
 	}
 }
 
-static void rtl92ee_clear_interrupt(struct ieee80211_hw *hw)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u32 tmp;
-
-	tmp = rtl_read_dword(rtlpriv, REG_HISR);
-	rtl_write_dword(rtlpriv, REG_HISR, tmp);
-
-	tmp = rtl_read_dword(rtlpriv, REG_HISRE);
-	rtl_write_dword(rtlpriv, REG_HISRE, tmp);
-
-	tmp = rtl_read_dword(rtlpriv, REG_HSISR);
-	rtl_write_dword(rtlpriv, REG_HSISR, tmp);
-}
-
 void rtl92ee_enable_interrupt(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 
-	rtl92ee_clear_interrupt(hw);/*clear it here first*/
-
 	rtl_write_dword(rtlpriv, REG_HIMR, rtlpci->irq_mask[0] & 0xFFFFFFFF);
 	rtl_write_dword(rtlpriv, REG_HIMRE, rtlpci->irq_mask[1] & 0xFFFFFFFF);
 	rtlpci->irq_enabled = true;
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c b/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c
index 67bb47d..a4b7eac 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c
@@ -1258,18 +1258,6 @@ void rtl8723e_set_qos(struct ieee80211_hw *hw, int aci)
 	}
 }
 
-static void rtl8723e_clear_interrupt(struct ieee80211_hw *hw)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u32 tmp;
-
-	tmp = rtl_read_dword(rtlpriv, REG_HISR);
-	rtl_write_dword(rtlpriv, REG_HISR, tmp);
-
-	tmp = rtl_read_dword(rtlpriv, REG_HISRE);
-	rtl_write_dword(rtlpriv, REG_HISRE, tmp);
-}
-
 void rtl8723e_enable_interrupt(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -1284,7 +1272,6 @@ void rtl8723e_disable_interrupt(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-	rtl8723e_clear_interrupt(hw);/*clear it here first*/
 	rtl_write_dword(rtlpriv, 0x3a8, IMR8190_DISABLED);
 	rtl_write_dword(rtlpriv, 0x3ac, IMR8190_DISABLED);
 	rtlpci->irq_enabled = false;
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/hw.c b/drivers/net/wireless/rtlwifi/rtl8723be/hw.c
index b681af3..b941726 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723be/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723be/hw.c
@@ -1634,28 +1634,11 @@ void rtl8723be_set_qos(struct ieee80211_hw *hw, int aci)
 	}
 }
 
-static void rtl8723be_clear_interrupt(struct ieee80211_hw *hw)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u32 tmp;
-
-	tmp = rtl_read_dword(rtlpriv, REG_HISR);
-	rtl_write_dword(rtlpriv, REG_HISR, tmp);
-
-	tmp = rtl_read_dword(rtlpriv, REG_HISRE);
-	rtl_write_dword(rtlpriv, REG_HISRE, tmp);
-
-	tmp = rtl_read_dword(rtlpriv, REG_HSISR);
-	rtl_write_dword(rtlpriv, REG_HSISR, tmp);
-}
-
 void rtl8723be_enable_interrupt(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 
-	rtl8723be_clear_interrupt(hw);/*clear it here first*/
-
 	rtl_write_dword(rtlpriv, REG_HIMR, rtlpci->irq_mask[0] & 0xFFFFFFFF);
 	rtl_write_dword(rtlpriv, REG_HIMRE, rtlpci->irq_mask[1] & 0xFFFFFFFF);
 	rtlpci->irq_enabled = true;
diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/rtlwifi/rtl8821ae/hw.c
index 8704eee..57966e3 100644
--- a/drivers/net/wireless/rtlwifi/rtl8821ae/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8821ae/hw.c
@@ -2253,31 +2253,11 @@ void rtl8821ae_set_qos(struct ieee80211_hw *hw, int aci)
 	}
 }
 
-static void rtl8821ae_clear_interrupt(struct ieee80211_hw *hw)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u32 tmp;
-	tmp = rtl_read_dword(rtlpriv, REG_HISR);
-	/*printk("clear interrupt first:\n");
-	printk("0x%x = 0x%08x\n",REG_HISR, tmp);*/
-	rtl_write_dword(rtlpriv, REG_HISR, tmp);
-
-	tmp = rtl_read_dword(rtlpriv, REG_HISRE);
-	/*printk("0x%x = 0x%08x\n",REG_HISRE, tmp);*/
-	rtl_write_dword(rtlpriv, REG_HISRE, tmp);
-
-	tmp = rtl_read_dword(rtlpriv, REG_HSISR);
-	/*printk("0x%x = 0x%08x\n",REG_HSISR, tmp);*/
-	rtl_write_dword(rtlpriv, REG_HSISR, tmp);
-}
-
 void rtl8821ae_enable_interrupt(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 
-	rtl8821ae_clear_interrupt(hw);/*clear it here first*/
-
 	rtl_write_dword(rtlpriv, REG_HIMR, rtlpci->irq_mask[0] & 0xFFFFFFFF);
 	rtl_write_dword(rtlpriv, REG_HIMRE, rtlpci->irq_mask[1] & 0xFFFFFFFF);
 	rtlpci->irq_enabled = true;
-- 
2.1.4

