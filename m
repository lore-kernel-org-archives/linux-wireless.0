Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35473 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754732AbcLBBsu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Dec 2016 20:48:50 -0500
Received: by mail-oi0-f66.google.com with SMTP id v84so25421656oie.2
        for <linux-wireless@vger.kernel.org>; Thu, 01 Dec 2016 17:48:50 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Ping-Ke Shih <pkshih@realtek.com>, shaofu <shaofu@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 03/14] rtlwifi: Set retry limit depends on vif type.
Date: Thu,  1 Dec 2016 19:48:22 -0600
Message-Id: <20161202014833.6856-4-Larry.Finger@lwfinger.net> (sfid-20161202_025212_309415_E2860399)
In-Reply-To: <20161202014833.6856-1-Larry.Finger@lwfinger.net>
References: <20161202014833.6856-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

We assign different retry limit according to vif type, because
it can boost performance in field.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: shaofu <shaofu@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/core.c | 21 ++++++++++++++++++---
 drivers/net/wireless/realtek/rtlwifi/pci.c  |  7 +++++++
 drivers/net/wireless/realtek/rtlwifi/ps.c   |  3 +++
 3 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index 7c2ac24..35b620a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -234,6 +234,7 @@ static int rtl_op_add_interface(struct ieee80211_hw *hw,
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	int err = 0;
+	u8 retry_limit = 0x30;
 
 	if (mac->vif) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
@@ -272,6 +273,7 @@ static int rtl_op_add_interface(struct ieee80211_hw *hw,
 		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_BASIC_RATE,
 				(u8 *)(&mac->basic_rates));
 
+		retry_limit = 0x07;
 		break;
 	case NL80211_IFTYPE_P2P_GO:
 		mac->p2p = P2P_ROLE_GO;
@@ -288,6 +290,8 @@ static int rtl_op_add_interface(struct ieee80211_hw *hw,
 			mac->basic_rates = 0xff0;
 		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_BASIC_RATE,
 					      (u8 *)(&mac->basic_rates));
+
+		retry_limit = 0x07;
 		break;
 	case NL80211_IFTYPE_MESH_POINT:
 		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD,
@@ -301,6 +305,8 @@ static int rtl_op_add_interface(struct ieee80211_hw *hw,
 			mac->basic_rates = 0xff0;
 		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_BASIC_RATE,
 				(u8 *)(&mac->basic_rates));
+
+		retry_limit = 0x07;
 		break;
 	default:
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
@@ -322,6 +328,10 @@ static int rtl_op_add_interface(struct ieee80211_hw *hw,
 	memcpy(mac->mac_addr, vif->addr, ETH_ALEN);
 	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_ETHER_ADDR, mac->mac_addr);
 
+	mac->retry_long = retry_limit;
+	mac->retry_short = retry_limit;
+	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RETRY_LIMIT,
+			(u8 *)(&retry_limit));
 out:
 	mutex_unlock(&rtlpriv->locks.conf_mutex);
 	return err;
@@ -647,10 +657,15 @@ static int rtl_op_config(struct ieee80211_hw *hw, u32 changed)
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
index 8bfe020..0991298 100644
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
 
@@ -1820,6 +1824,7 @@ static int rtl_pci_start(struct ieee80211_hw *hw)
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
+	struct rtl_mac *rtlmac = rtl_mac(rtl_priv(hw));
 
 	int err;
 
@@ -1837,6 +1842,8 @@ static int rtl_pci_start(struct ieee80211_hw *hw)
 			 "Failed to config hardware!\n");
 		return err;
 	}
+	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RETRY_LIMIT,
+			&rtlmac->retry_long);
 
 	rtlpriv->cfg->ops->enable_interrupt(hw);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, "enable_interrupt OK\n");
diff --git a/drivers/net/wireless/realtek/rtlwifi/ps.c b/drivers/net/wireless/realtek/rtlwifi/ps.c
index d0ffc4d..0643a82 100644
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
