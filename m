Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:57309 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751197AbeA2D1E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 28 Jan 2018 22:27:04 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 09/10] rtlwifi: btcoex: add routine to set default port id
Date: Mon, 29 Jan 2018 11:26:40 +0800
Message-ID: <20180129032641.17841-10-pkshih@realtek.com> (sfid-20180129_042713_352580_9A68EDCD)
In-Reply-To: <20180129032641.17841-1-pkshih@realtek.com>
References: <20180129032641.17841-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Tell wifi and BT firmware the default port ID to set multiports' state
properly, but only 8822be needs this function currently.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       | 22 ++++++++++++++++++++++
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |  2 ++
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  5 +++++
 3 files changed, 29 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index 1404729441a2..823694cb4fdb 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -1039,6 +1039,28 @@ static void halbtc_fill_h2c_cmd(void *bt_context, u8 element_id,
 					cmd_len, cmd_buf);
 }
 
+void halbtc_send_wifi_port_id_cmd(void *bt_context)
+{
+	struct btc_coexist *btcoexist = (struct btc_coexist *)bt_context;
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	u8 cmd_buf[1] = {0};	/* port id [2:0] = 0 */
+
+	rtlpriv->cfg->ops->fill_h2c_cmd(rtlpriv->mac80211.hw, H2C_BT_PORT_ID,
+					1, cmd_buf);
+}
+
+void halbtc_set_default_port_id_cmd(void *bt_context)
+{
+	struct btc_coexist *btcoexist = (struct btc_coexist *)bt_context;
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct ieee80211_hw *hw = rtlpriv->mac80211.hw;
+
+	if (!rtlpriv->cfg->ops->set_default_port_id_cmd)
+		return;
+
+	rtlpriv->cfg->ops->set_default_port_id_cmd(hw);
+}
+
 static
 void halbtc_set_bt_reg(void *btc_context, u8 reg_type, u32 offset, u32 set_val)
 {
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
index 8ed217656539..f5d8159a88eb 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -691,6 +691,8 @@ void exhalbtc_lps_leave(struct btc_coexist *btcoexist);
 void exhalbtc_low_wifi_traffic_notify(struct btc_coexist *btcoexist);
 void exhalbtc_set_single_ant_path(struct btc_coexist *btcoexist,
 				  u8 single_ant_path);
+void halbtc_send_wifi_port_id_cmd(void *bt_context);
+void halbtc_set_default_port_id_cmd(void *bt_context);
 
 /* The following are used by wifi_only case */
 enum wifionly_chip_interface {
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 0e8aae0c05c1..1c9ed28b42da 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -153,6 +153,10 @@ enum rtl8192c_h2c_cmd {
 	MAX_H2CCMD
 };
 
+enum {
+	H2C_BT_PORT_ID = 0x71,
+};
+
 #define GET_TX_REPORT_SN_V1(c2h)	(c2h[6])
 #define GET_TX_REPORT_ST_V1(c2h)	(c2h[0] & 0xC0)
 #define GET_TX_REPORT_RETRY_V1(c2h)	(c2h[2] & 0x3F)
@@ -2256,6 +2260,7 @@ struct rtl_hal_ops {
 	void (*bt_coex_off_before_lps) (struct ieee80211_hw *hw);
 	void (*fill_h2c_cmd) (struct ieee80211_hw *hw, u8 element_id,
 			      u32 cmd_len, u8 *p_cmdbuffer);
+	void (*set_default_port_id_cmd)(struct ieee80211_hw *hw);
 	bool (*get_btc_status) (void);
 	bool (*is_fw_header)(struct rtlwifi_firmware_header *hdr);
 	u32 (*rx_command_packet)(struct ieee80211_hw *hw,
-- 
2.15.1
