Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:34453 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbbFFLSB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Jun 2015 07:18:01 -0400
Received: by pdbki1 with SMTP id ki1so69577188pdb.1
        for <linux-wireless@vger.kernel.org>; Sat, 06 Jun 2015 04:18:00 -0700 (PDT)
From: Taehee Yoo <ap420073@gmail.com>
To: Larry.Finger@lwfinger.net
Cc: ap420073@gmail.com, linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192cu: Modify _rtl92cu_phy_set_rf_power_state().
Date: Sat,  6 Jun 2015 20:17:48 +0900
Message-Id: <1433589468-30877-1-git-send-email-ap420073@gmail.com> (sfid-20150606_131806_514921_58B700A9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I change the RTL8192CE routines to the RTL8192CU routines
in the _rtl92cu_phy_set_rf_power_state().
These RTL8192CU routines are copy codes of vendor driver.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/phy.c | 153 +++++++++------------------
 1 file changed, 50 insertions(+), 103 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c b/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
index 12f6d47..0b65f25 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
@@ -416,116 +416,63 @@ static bool _rtl92cu_phy_set_rf_power_state(struct ieee80211_hw *hw,
 					    enum rf_pwrstate rfpwr_state)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
-	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	struct rtl_phy *rtlphy = &rtlpriv->phy;
 	bool bresult = true;
-	u8 i, queue_id;
-	struct rtl8192_tx_ring *ring = NULL;
+	u8 value8;
 
 	switch (rfpwr_state) {
 	case ERFON:
-		if ((ppsc->rfpwr_state == ERFOFF) &&
-		    RT_IN_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_HALT_NIC)) {
-			bool rtstatus;
-			u32 InitializeCount = 0;
-
-			do {
-				InitializeCount++;
-				RT_TRACE(rtlpriv, COMP_RF, DBG_DMESG,
-					 "IPS Set eRf nic enable\n");
-				rtstatus = rtl_ps_enable_nic(hw);
-			} while (!rtstatus && (InitializeCount < 10));
-			RT_CLEAR_PS_LEVEL(ppsc,
-					  RT_RF_OFF_LEVL_HALT_NIC);
-		} else {
-			RT_TRACE(rtlpriv, COMP_RF, DBG_DMESG,
-				 "Set ERFON sleeped:%d ms\n",
-				 jiffies_to_msecs(jiffies -
-						  ppsc->last_sleep_jiffies));
-			ppsc->last_awake_jiffies = jiffies;
-			rtl92ce_phy_set_rf_on(hw);
-		}
-		if (mac->link_state == MAC80211_LINKED) {
-			rtlpriv->cfg->ops->led_control(hw,
-						       LED_CTL_LINK);
-		} else {
-			rtlpriv->cfg->ops->led_control(hw,
-						       LED_CTL_NO_LINK);
-		}
-		break;
-	case ERFOFF:
-		for (queue_id = 0, i = 0;
-		     queue_id < RTL_PCI_MAX_TX_QUEUE_COUNT;) {
-			ring = &pcipriv->dev.tx_ring[queue_id];
-			if (skb_queue_len(&ring->queue) == 0 ||
-				queue_id == BEACON_QUEUE) {
-				queue_id++;
-				continue;
-			} else {
-				RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
-					 "eRf Off/Sleep: %d times TcbBusyQueue[%d] =%d before doze!\n",
-					 i + 1,
-					 queue_id,
-					 skb_queue_len(&ring->queue));
-				udelay(10);
-				i++;
-			}
-			if (i >= MAX_DOZE_WAITING_TIMES_9x) {
-				RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
-					 "ERFOFF: %d times TcbBusyQueue[%d] = %d !\n",
-					 MAX_DOZE_WAITING_TIMES_9x,
-					 queue_id,
-					 skb_queue_len(&ring->queue));
-				break;
-			}
-		}
-		if (ppsc->reg_rfps_level & RT_RF_OFF_LEVL_HALT_NIC) {
-			RT_TRACE(rtlpriv, COMP_RF, DBG_DMESG,
-				 "IPS Set eRf nic disable\n");
-			rtl_ps_disable_nic(hw);
-			RT_SET_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_HALT_NIC);
-		} else {
-			if (ppsc->rfoff_reason == RF_CHANGE_BY_IPS) {
-				rtlpriv->cfg->ops->led_control(hw,
-							 LED_CTL_NO_LINK);
-			} else {
-				rtlpriv->cfg->ops->led_control(hw,
-							 LED_CTL_POWER_OFF);
-			}
-		}
+		value8 = rtl_read_byte(rtlpriv, REG_SPS0_CTRL);
+		value8 |= (BIT(0) | BIT(3));
+		rtl_write_byte(rtlpriv, REG_SPS0_CTRL, value8);
+
+		if (rtlphy->rf_type == RF_2T2R)
+			rtl_set_bbreg(hw, rFPGA0_XAB_RFPARAMETER, 0x380038, 1);
+		else
+			rtl_set_bbreg(hw, rFPGA0_XAB_RFPARAMETER, 0x38, 1);
+
+		rtl_set_bbreg(hw, ROFDM0_TRXPATHENABLE, 0xf0, 1);
+		rtl_set_bbreg(hw, RFPGA0_RFMOD, BIT(1), 0);
+
+		if (rtlphy->rf_type == RF_2T2R)
+			rtl_set_bbreg(hw, 0xe70, 0xffffffff, 0x63DB25A0);
+		else
+			rtl_set_bbreg(hw, 0xe70, 0xffffffff, 0x631B25A0);
+
+		rtl_set_rfreg(hw, RF90_PATH_A, 0, 0xfffff, 0x32D95);
+
+		if (rtlphy->rf_type == RF_2T2R)
+			rtl_set_rfreg(hw, RF90_PATH_B, 0, 0xfffff, 0x32D95);
 		break;
 	case ERFSLEEP:
-		if (ppsc->rfpwr_state == ERFOFF)
-			return false;
-		for (queue_id = 0, i = 0;
-		     queue_id < RTL_PCI_MAX_TX_QUEUE_COUNT;) {
-			ring = &pcipriv->dev.tx_ring[queue_id];
-			if (skb_queue_len(&ring->queue) == 0) {
-				queue_id++;
-				continue;
-			} else {
-				RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
-					 "eRf Off/Sleep: %d times TcbBusyQueue[%d] =%d before doze!\n",
-					 i + 1, queue_id,
-					 skb_queue_len(&ring->queue));
-				udelay(10);
-				i++;
-			}
-			if (i >= MAX_DOZE_WAITING_TIMES_9x) {
-				RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
-					 "ERFSLEEP: %d times TcbBusyQueue[%d] = %d !\n",
-					 MAX_DOZE_WAITING_TIMES_9x,
-					 queue_id,
-					 skb_queue_len(&ring->queue));
-				break;
-			}
-		}
-		RT_TRACE(rtlpriv, COMP_RF, DBG_DMESG,
-			 "Set ERFSLEEP awaked:%d ms\n",
-			 jiffies_to_msecs(jiffies - ppsc->last_awake_jiffies));
-		ppsc->last_sleep_jiffies = jiffies;
-		_rtl92c_phy_set_rf_sleep(hw);
+	case ERFOFF:
+		value8 = rtl_read_byte(rtlpriv, REG_SPS0_CTRL);
+		if (IS_81XXC_VENDOR_UMC_B_CUT(rtlhal->version))
+			value8 &= ~BIT(0);
+		else
+			value8 &= ~(BIT(0) | BIT(3));
+
+		if (rtlphy->rf_type == RF_2T2R)
+			rtl_set_bbreg(hw, rFPGA0_XAB_RFPARAMETER, 0x380038, 0);
+		else if (rtlphy->rf_type == RF_1T1R)
+			rtl_set_bbreg(hw, rFPGA0_XAB_RFPARAMETER, 0x38, 0);
+
+		rtl_set_bbreg(hw, ROFDM0_TRXPATHENABLE, 0xf0, 0);
+		rtl_set_bbreg(hw, RFPGA0_RFMOD, BIT(1), 1);
+
+		if (rtlphy->rf_type == RF_2T2R)
+			rtl_set_bbreg(hw, 0xe70, 0xffffffff, 0x00DB25A0);
+		else if (rtlphy->rf_type == RF_1T1R)
+			rtl_set_bbreg(hw, 0xe70, 0xffffffff, 0x001B25A0);
+
+		rtl_set_rfreg(hw, RF90_PATH_A, 0, 0xfffff, 0);
+
+		if (rtlphy->rf_type == RF_2T2R)
+			rtl_set_rfreg(hw, RF90_PATH_B, 0, 0xfffff, 0);
+
+		rtl_write_byte(rtlpriv, REG_SPS0_CTRL, value8);
 		break;
 	default:
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-- 
2.1.4

