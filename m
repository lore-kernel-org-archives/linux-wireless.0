Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:33376 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbbC3P73 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 11:59:29 -0400
Received: by pdnc3 with SMTP id c3so179929762pdn.0
        for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2015 08:59:29 -0700 (PDT)
From: Taehee Yoo <ap420073@gmail.com>
To: Larry.Finger@lwfinger.net, ap420073@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192cu: remove duplicated routine in hw.c and mac.c
Date: Tue, 31 Mar 2015 00:55:32 +0900
Message-Id: <1427730932-4364-1-git-send-email-ap420073@gmail.com> (sfid-20150330_175933_288798_0595E507)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rtl92c_set_xxx_filter is same routine with rtl92cu_set_hw_reg.
so i remove those functions that are rtl92c_set_xxx_filter.
(rtl92c_get_xxx_filter is also same reason.)
also i add code updating struct rtl_mac member variable in the
rtl92cu_set_hw_reg.
after that, no more _update_mac_setting is not useful. thus i remove that.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c  | 38 +++++++++++---------------
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c | 41 ----------------------------
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.h |  9 ------
 3 files changed, 16 insertions(+), 72 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
index 43b2b20..be9dba3 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -818,26 +818,29 @@ static void _rtl92cu_init_usb_aggregation(struct ieee80211_hw *hw)
 
 static void _rtl92cu_init_wmac_setting(struct ieee80211_hw *hw)
 {
-	u16			value16;
-
+	u16 value16;
+	u32 value32;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 
-	mac->rx_conf = (RCR_APM | RCR_AM | RCR_ADF | RCR_AB | RCR_APPFCS |
-		      RCR_APP_ICV | RCR_AMF | RCR_HTC_LOC_CTRL |
-		      RCR_APP_MIC | RCR_APP_PHYSTS | RCR_ACRC32);
-	rtl_write_dword(rtlpriv, REG_RCR, mac->rx_conf);
+	value32 = (RCR_APM | RCR_AM | RCR_ADF | RCR_AB | RCR_APPFCS |
+		   RCR_APP_ICV | RCR_AMF | RCR_HTC_LOC_CTRL |
+		   RCR_APP_MIC | RCR_APP_PHYSTS | RCR_ACRC32);
+	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR, (u8 *)(&value32));
 	/* Accept all multicast address */
 	rtl_write_dword(rtlpriv,  REG_MAR, 0xFFFFFFFF);
 	rtl_write_dword(rtlpriv,  REG_MAR + 4, 0xFFFFFFFF);
 	/* Accept all management frames */
 	value16 = 0xFFFF;
-	rtl92c_set_mgt_filter(hw, value16);
+	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_MGT_FILTER,
+				      (u8 *)(&value16));
 	/* Reject all control frame - default value is 0 */
-	rtl92c_set_ctrl_filter(hw, 0x0);
+	value16 = 0x0;
+	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_CTRL_FILTER,
+				      (u8 *)(&value16));
 	/* Accept all data frames */
 	value16 = 0xFFFF;
-	rtl92c_set_data_filter(hw, value16);
+	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_DATA_FILTER,
+				      (u8 *)(&value16));
 }
 
 static int _rtl92cu_init_mac(struct ieee80211_hw *hw)
@@ -968,17 +971,6 @@ static void _InitPABias(struct ieee80211_hw *hw)
 	}
 }
 
-static void _update_mac_setting(struct ieee80211_hw *hw)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
-
-	mac->rx_conf = rtl_read_dword(rtlpriv, REG_RCR);
-	mac->rx_mgt_filter = rtl_read_word(rtlpriv, REG_RXFLTMAP0);
-	mac->rx_ctrl_filter = rtl_read_word(rtlpriv, REG_RXFLTMAP1);
-	mac->rx_data_filter = rtl_read_word(rtlpriv, REG_RXFLTMAP2);
-}
-
 int rtl92cu_hw_init(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -1049,7 +1041,6 @@ int rtl92cu_hw_init(struct ieee80211_hw *hw)
 	}
 	_rtl92cu_hw_configure(hw);
 	_InitPABias(hw);
-	_update_mac_setting(hw);
 	rtl92c_dm_init(hw);
 exit:
 	local_irq_restore(flags);
@@ -1997,12 +1988,15 @@ void rtl92cu_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 		}
 	case HW_VAR_MGT_FILTER:
 		rtl_write_word(rtlpriv, REG_RXFLTMAP0, *(u16 *)val);
+		mac->rx_mgt_filter = *(u16 *)val;
 		break;
 	case HW_VAR_CTRL_FILTER:
 		rtl_write_word(rtlpriv, REG_RXFLTMAP1, *(u16 *)val);
+		mac->rx_ctrl_filter = *(u16 *)val;
 		break;
 	case HW_VAR_DATA_FILTER:
 		rtl_write_word(rtlpriv, REG_RXFLTMAP2, *(u16 *)val);
+		mac->rx_data_filter = *(u16 *)val;
 		break;
 	default:
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
index 133e395..6e033c7 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
@@ -671,47 +671,6 @@ void rtl92c_set_min_space(struct ieee80211_hw *hw, bool is2T)
 	rtl_write_byte(rtlpriv, REG_AMPDU_MIN_SPACE, value);
 }
 
-u16 rtl92c_get_mgt_filter(struct ieee80211_hw *hw)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-
-	return rtl_read_word(rtlpriv, REG_RXFLTMAP0);
-}
-
-void rtl92c_set_mgt_filter(struct ieee80211_hw *hw, u16 filter)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-
-	rtl_write_word(rtlpriv, REG_RXFLTMAP0, filter);
-}
-
-u16 rtl92c_get_ctrl_filter(struct ieee80211_hw *hw)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-
-	return rtl_read_word(rtlpriv, REG_RXFLTMAP1);
-}
-
-void rtl92c_set_ctrl_filter(struct ieee80211_hw *hw, u16 filter)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-
-	rtl_write_word(rtlpriv, REG_RXFLTMAP1, filter);
-}
-
-u16 rtl92c_get_data_filter(struct ieee80211_hw *hw)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-
-	return rtl_read_word(rtlpriv,  REG_RXFLTMAP2);
-}
-
-void rtl92c_set_data_filter(struct ieee80211_hw *hw, u16 filter)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-
-	rtl_write_word(rtlpriv, REG_RXFLTMAP2, filter);
-}
 /*==============================================================*/
 
 static u8 _rtl92c_query_rxpwrpercentage(char antpower)
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.h b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.h
index bf53652..969819d 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.h
@@ -76,15 +76,6 @@ void rtl92c_init_beacon_parameters(struct ieee80211_hw *hw,
 void rtl92c_disable_fast_edca(struct ieee80211_hw *hw);
 void rtl92c_set_min_space(struct ieee80211_hw *hw, bool is2T);
 
-/* For filter */
-u16 rtl92c_get_mgt_filter(struct ieee80211_hw *hw);
-void rtl92c_set_mgt_filter(struct ieee80211_hw *hw, u16 filter);
-u16 rtl92c_get_ctrl_filter(struct ieee80211_hw *hw);
-void rtl92c_set_ctrl_filter(struct ieee80211_hw *hw, u16 filter);
-u16 rtl92c_get_data_filter(struct ieee80211_hw *hw);
-void rtl92c_set_data_filter(struct ieee80211_hw *hw, u16 filter);
-
-
 u32 rtl92c_get_txdma_status(struct ieee80211_hw *hw);
 
 struct rx_fwinfo_92c {
-- 
1.9.1

