Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:54911 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751110AbeDYCIh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 22:08:37 -0400
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH v3 01/19] rtlwifi: add halmac structure to wifi.h
Date: Wed, 25 Apr 2018 10:08:02 +0800
Message-ID: <20180425020820.6141-2-pkshih@realtek.com> (sfid-20180425_040843_892339_7894FA43)
In-Reply-To: <20180425020820.6141-1-pkshih@realtek.com>
References: <20180425020820.6141-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Add structure and ops to interact with halmac and other modules.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/wifi.h | 58 +++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index d27e33960e77..c8542b87cc2b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -2305,6 +2305,13 @@ struct rtl_hal_ops {
 	u16 (*get_available_desc)(struct ieee80211_hw *hw, u8 q_idx);
 	void (*c2h_content_parsing)(struct ieee80211_hw *hw, u8 tag, u8 len,
 				    u8 *val);
+	/* ops for halmac cb */
+	bool (*halmac_cb_init_mac_register)(struct rtl_priv *rtlpriv);
+	bool (*halmac_cb_init_bb_rf_register)(struct rtl_priv *rtlpriv);
+	bool (*halmac_cb_write_data_rsvd_page)(struct rtl_priv *rtlpriv,
+					       u8 *buf, u32 size);
+	bool (*halmac_cb_write_data_h2c)(struct rtl_priv *rtlpriv, u8 *buf,
+					 u32 size);
 };
 
 struct rtl_intf_ops {
@@ -2687,6 +2694,54 @@ struct rtl_btc_ops {
 	bool (*btc_is_bt_lps_on)(struct rtl_priv *rtlpriv);
 };
 
+struct rtl_halmac_ops {
+	int (*halmac_init_adapter)(struct rtl_priv *rtlpriv);
+	int (*halmac_deinit_adapter)(struct rtl_priv *rtlpriv);
+	int (*halmac_init_hal)(struct rtl_priv *rtlpriv);
+	int (*halmac_deinit_hal)(struct rtl_priv *rtlpriv);
+	int (*halmac_poweron)(struct rtl_priv *rtlpriv);
+	int (*halmac_poweroff)(struct rtl_priv *rtlpriv);
+
+	int (*halmac_phy_power_switch)(struct rtl_priv *rtlpriv, u8 enable);
+	int (*halmac_set_mac_address)(struct rtl_priv *rtlpriv, u8 hwport,
+				      u8 *addr);
+	int (*halmac_set_bssid)(struct rtl_priv *rtlpriv, u8 hwport, u8 *addr);
+
+	int (*halmac_get_physical_efuse_size)(struct rtl_priv *rtlpriv,
+					      u32 *size);
+	int (*halmac_read_physical_efuse_map)(struct rtl_priv *rtlpriv,
+					      u8 *map, u32 size);
+	int (*halmac_get_logical_efuse_size)(struct rtl_priv *rtlpriv,
+					     u32 *size);
+	int (*halmac_read_logical_efuse_map)(struct rtl_priv *rtlpriv, u8 *map,
+					     u32 size);
+
+	int (*halmac_set_bandwidth)(struct rtl_priv *rtlpriv, u8 channel,
+				    u8 pri_ch_idx, u8 bw);
+
+	int (*halmac_c2h_handle)(struct rtl_priv *rtlpriv, u8 *c2h, u32 size);
+
+	int (*halmac_chk_txdesc)(struct rtl_priv *rtlpriv, u8 *txdesc,
+				 u32 size);
+	int (*halmac_iqk)(struct rtl_priv *rtlpriv, u8 clear, u8 segment);
+};
+
+struct rtl_halmac_indicator {
+	struct completion *comp;
+	u32 wait_ms;
+
+	u8 *buffer;
+	u32 buf_size;
+	u32 ret_size;
+	u32 status;
+};
+
+struct rtl_halmac {
+	const struct rtl_halmac_ops *ops;
+	void *internal;	/* internal context of halmac, i.e. PHALMAC_ADAPTER */
+	struct rtl_halmac_indicator *indicator;	/* size=10 */
+};
+
 struct proxim {
 	bool proxim_on;
 
@@ -2792,6 +2847,9 @@ struct rtl_priv {
 	/*for bt coexist use*/
 	struct bt_coexist_info btcoexist;
 
+	/* halmac for newer ICs */
+	struct rtl_halmac halmac;
+
 	/* separate 92ee from other ICs,
 	 * 92ee use new trx flow.
 	 */
-- 
2.15.1
