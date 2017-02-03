Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36405 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751365AbdBCRcs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Feb 2017 12:32:48 -0500
Received: by mail-oi0-f68.google.com with SMTP id u143so1892512oif.3
        for <linux-wireless@vger.kernel.org>; Fri, 03 Feb 2017 09:32:48 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>, shaofu <shaofu@realtek.com>
Subject: [PATCH 02/11 V3] rtlwifi: Set retry limit depends on vif type.
Date: Fri,  3 Feb 2017 11:32:23 -0600
Message-Id: <20170120212716.29887-3-Larry.Finger@lwfinger.net> (sfid-20170203_183302_981198_1D213491)
In-Reply-To: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
References: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
In-Reply-To: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
References: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
In-Reply-To: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
References: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

We assign different retry limit according to vif type, because
it can boost performance in field.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: shaofu <shaofu@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
V2 - no changes
V3 - no changes
---
 drivers/net/wireless/realtek/rtlwifi/core.c | 21 ++++++++++++++++++---
 drivers/net/wireless/realtek/rtlwifi/pci.c  |  7 +++++++
 drivers/net/wireless/realtek/rtlwifi/ps.c   |  3 +++
 3 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index 179a699..a4f8e32 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -233,6 +233,7 @@ static int rtl_op_add_interface(struct ieee80211_hw *hw,
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	int err = 0;
+	u8 retry_limit = 0x30;
 
 	if (mac->vif) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
@@ -271,6 +272,7 @@ static int rtl_op_add_interface(struct ieee80211_hw *hw,
 		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_BASIC_RATE,
 				(u8 *)(&mac->basic_rates));
 
+		retry_limit = 0x07;
 		break;
 	case NL80211_IFTYPE_P2P_GO:
 		mac->p2p = P2P_ROLE_GO;
@@ -287,6 +289,8 @@ static int rtl_op_add_interface(struct ieee80211_hw *hw,
 			mac->basic_rates = 0xff0;
 		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_BASIC_RATE,
 					      (u8 *)(&mac->basic_rates));
+
+		retry_limit = 0x07;
 		break;
 	case NL80211_IFTYPE_MESH_POINT:
 		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD,
@@ -300,6 +304,8 @@ static int rtl_op_add_interface(struct ieee80211_hw *hw,
 			mac->basic_rates = 0xff0;
 		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_BASIC_RATE,
 				(u8 *)(&mac->basic_rates));
+
+		retry_limit = 0x07;
 		break;
 	default:
 		pr_err("operation mode %d is not supported!\n",
@@ -321,6 +327,10 @@ static int rtl_op_add_interface(struct ieee80211_hw *hw,
 	memcpy(mac->mac_addr, vif->addr, ETH_ALEN);
 	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_ETHER_ADDR, mac->mac_addr);
 
+	mac->retry_long = retry_limit;
+	mac->retry_short = retry_limit;
+	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RETRY_LIMIT,
+			(u8 *)(&retry_limit));
 out:
 	mutex_unlock(&rtlpriv->locks.conf_mutex);
 	return err;
@@ -645,10 +655,15 @@ static int rtl_op_config(struct ieee80211_hw *hw, u32 changed)
 		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD,
 			 "IEEE80211_CONF_CHANGE_RETRY_LIMITS %x\n",
 			 hw->conf.long_frame_max_tx_count);
-		mac->retry_long = hw->conf.long_frame_max_tx_count;
-		mac->retry_short = hw->conf.long_frame_max_tx_count;
-		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RETRY_LIMIT,
+		/* brought up everything changes (changed == ~0) indicates first
+		 * open, so use our default value instead of that of wiphy.
+		 */
+		if (changed != ~0) {
+			mac->retry_long = hw->conf.long_frame_max_tx_count;
+			mac->retry_short = hw->conf.long_frame_max_tx_count;
+			rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RETRY_LIMIT,
 				(u8 *)(&hw->conf.long_frame_max_tx_count));
+		}
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL &&
diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index 665cdb2..376239e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -1214,6 +1214,10 @@ static void _rtl_pci_init_struct(struct ieee80211_hw *hw,
 	mac->current_ampdu_density = 7;
 	mac->current_ampdu_factor = 3;
 
+	/*Retry Limit*/
+	mac->retry_short = 7;
+	mac->retry_long = 7;
+
 	/*QOS*/
 	rtlpci->acm_method = EACMWAY2_SW;
 
@@ -1814,6 +1818,7 @@ static int rtl_pci_start(struct ieee80211_hw *hw)
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
+	struct rtl_mac *rtlmac = rtl_mac(rtl_priv(hw));
 
 	int err;
 
@@ -1831,6 +1836,8 @@ static int rtl_pci_start(struct ieee80211_hw *hw)
 			 "Failed to config hardware!\n");
 		return err;
 	}
+	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RETRY_LIMIT,
+			&rtlmac->retry_long);
 
 	rtlpriv->cfg->ops->enable_interrupt(hw);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, "enable_interrupt OK\n");
diff --git a/drivers/net/wireless/realtek/rtlwifi/ps.c b/drivers/net/wireless/realtek/rtlwifi/ps.c
index 4f83270..0d15287 100644
--- a/drivers/net/wireless/realtek/rtlwifi/ps.c
+++ b/drivers/net/wireless/realtek/rtlwifi/ps.c
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
+			&rtlmac->retry_long);
 	RT_CLEAR_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_HALT_NIC);
 
 	/*<3> Enable Interrupt */
-- 
2.10.2
