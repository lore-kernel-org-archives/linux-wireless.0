Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:34396 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874AbbHCSyV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2015 14:54:21 -0400
Received: by oigu133 with SMTP id u133so32405227oig.1
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2015 11:54:21 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, pkshih <pkshih@realtek.com>,
	shaofu <shaofu@realtek.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH NEXT 3/7] rtlwifi: Make retry limits depend on vif type
Date: Mon,  3 Aug 2015 13:53:48 -0500
Message-Id: <1438628032-5865-4-git-send-email-Larry.Finger@lwfinger.net> (sfid-20150803_205424_931876_48B36992)
In-Reply-To: <1438628032-5865-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1438628032-5865-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: pkshih <pkshih@realtek.com>

Making the retry limits depend on the vif type can boost performance.

Signed-off-by: pkshih <pkshih@realtek.com>
Signed-off-by: shaofu <shaofu@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/core.c | 19 +++++++++++++++----
 drivers/net/wireless/rtlwifi/pci.c  |  8 +++++++-
 drivers/net/wireless/rtlwifi/ps.c   |  3 +++
 3 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtlwifi/core.c
index 3b3a88b..19729ed 100644
--- a/drivers/net/wireless/rtlwifi/core.c
+++ b/drivers/net/wireless/rtlwifi/core.c
@@ -238,6 +238,7 @@ static int rtl_op_add_interface(struct ieee80211_hw *hw,
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	int err = 0;
+	u8 retry_limit = 0x30;
 
 	if (mac->vif) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
@@ -275,7 +276,7 @@ static int rtl_op_add_interface(struct ieee80211_hw *hw,
 			mac->basic_rates = 0xff0;
 		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_BASIC_RATE,
 				(u8 *)(&mac->basic_rates));
-
+		retry_limit = 0x07;
 		break;
 	case NL80211_IFTYPE_P2P_GO:
 		mac->p2p = P2P_ROLE_GO;
@@ -292,6 +293,7 @@ static int rtl_op_add_interface(struct ieee80211_hw *hw,
 			mac->basic_rates = 0xff0;
 		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_BASIC_RATE,
 					      (u8 *)(&mac->basic_rates));
+		retry_limit = 0x07;
 		break;
 	case NL80211_IFTYPE_MESH_POINT:
 		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD,
@@ -326,6 +328,10 @@ static int rtl_op_add_interface(struct ieee80211_hw *hw,
 	memcpy(mac->mac_addr, vif->addr, ETH_ALEN);
 	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_ETHER_ADDR, mac->mac_addr);
 
+	mac->retry_long = retry_limit;
+	mac->retry_short = retry_limit;
+	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RETRY_LIMIT,
+				      (u8 *)(&retry_limit));
 out:
 	mutex_unlock(&rtlpriv->locks.conf_mutex);
 	return err;
@@ -650,10 +656,15 @@ static int rtl_op_config(struct ieee80211_hw *hw, u32 changed)
 		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD,
 			 "IEEE80211_CONF_CHANGE_RETRY_LIMITS %x\n",
 			 hw->conf.long_frame_max_tx_count);
-		mac->retry_long = hw->conf.long_frame_max_tx_count;
-		mac->retry_short = hw->conf.long_frame_max_tx_count;
-		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RETRY_LIMIT,
+		/* On first open, everything changes (changed == ~0),
+		 * so use our default value instead of wiphy's one.
+		 */
+		if (changed != ~0) {
+			mac->retry_long = hw->conf.long_frame_max_tx_count;
+			mac->retry_short = hw->conf.long_frame_max_tx_count;
+			rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RETRY_LIMIT,
 				(u8 *)(&hw->conf.long_frame_max_tx_count));
+		}
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL &&
diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index f46c9d7..a621d7d 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -1227,6 +1227,10 @@ static void _rtl_pci_init_struct(struct ieee80211_hw *hw,
 	mac->current_ampdu_density = 7;
 	mac->current_ampdu_factor = 3;
 
+	/* Retry Limit */
+	mac->retry_short = 7;
+	mac->retry_long = 7;
+
 	/*QOS*/
 	rtlpci->acm_method = EACMWAY2_SW;
 
@@ -1833,7 +1837,7 @@ static int rtl_pci_start(struct ieee80211_hw *hw)
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
-
+	struct rtl_mac *rtlmac = rtl_mac(rtl_priv(hw));
 	int err;
 
 	rtl_pci_reset_trx_ring(hw);
@@ -1850,6 +1854,8 @@ static int rtl_pci_start(struct ieee80211_hw *hw)
 			 "Failed to config hardware!\n");
 		return err;
 	}
+	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RETRY_LIMIT,
+				      &rtlmac->retry_long);
 
 	rtlpriv->cfg->ops->enable_interrupt(hw);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, "enable_interrupt OK\n");
diff --git a/drivers/net/wireless/rtlwifi/ps.c b/drivers/net/wireless/rtlwifi/ps.c
index b69321d..b6b6834 100644
--- a/drivers/net/wireless/rtlwifi/ps.c
+++ b/drivers/net/wireless/rtlwifi/ps.c
@@ -34,6 +34,7 @@ bool rtl_ps_enable_nic(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	struct rtl_mac *rtlmac = rtl_mac(rtl_priv(hw));
 
 	/*<1> reset trx ring */
 	if (rtlhal->interface == INTF_PCI)
@@ -46,6 +47,8 @@ bool rtl_ps_enable_nic(struct ieee80211_hw *hw)
 	/*<2> Enable Adapter */
 	if (rtlpriv->cfg->ops->hw_init(hw))
 		return false;
+	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RETRY_LIMIT,
+				      &rtlmac->retry_long);
 	RT_CLEAR_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_HALT_NIC);
 
 	/*<3> Enable Interrupt */
-- 
2.1.4

