Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36877 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750777AbdGUEY5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Jul 2017 00:24:57 -0400
Received: by mail-oi0-f67.google.com with SMTP id q4so3924927oif.4
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jul 2017 21:24:57 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 09/10] rtlwifi: Add halmac structure to wifi.h
Date: Thu, 20 Jul 2017 23:24:39 -0500
Message-Id: <20170721042440.15839-10-Larry.Finger@lwfinger.net> (sfid-20170721_062507_882546_E2D7895B)
In-Reply-To: <20170721042440.15839-1-Larry.Finger@lwfinger.net>
References: <20170721042440.15839-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Add structure and ops to interact between halmac and other modules.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/wifi.h | 64 +++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 6c261b16a17d..92ce00819d2c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -2229,6 +2229,11 @@ struct rtl_hal_ops {
 	u16 (*get_available_desc)(struct ieee80211_hw *hw, u8 q_idx);
 	void (*c2h_content_parsing)(struct ieee80211_hw *hw, u8 tag, u8 len,
 				    u8 *val);
+	/* ops for halmac cb */
+	bool (*halmac_cb_init_mac_register)(struct rtl_priv *rtlpriv);
+	bool (*halmac_cb_init_bb_rf_register)(struct rtl_priv *rtlpriv);
+	bool (*halmac_cb_write_data_rsvd_page)(struct rtl_priv *rtlpriv, u8 *buf, u32 size);
+	bool (*halmac_cb_write_data_h2c)(struct rtl_priv *rtlpriv, u8 *buf, u32 size);
 };
 
 struct rtl_intf_ops {
@@ -2613,6 +2618,61 @@ struct rtl_btc_ops {
 
 };
 
+struct rtl_halmac_ops {
+	int (*halmac_init_adapter)(struct rtl_priv *);
+	int (*halmac_deinit_adapter)(struct rtl_priv *);
+	int (*halmac_init_hal)(struct rtl_priv *);
+	int (*halmac_deinit_hal)(struct rtl_priv *);
+	int (*halmac_poweron)(struct rtl_priv *);
+	int (*halmac_poweroff)(struct rtl_priv *);
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
+	struct rtl_halmac_ops *ops; /* halmac ops (halmac.ko own this object) */
+	void *internal;	/* internal context of halmac, i.e. PHALMAC_ADAPTER */
+	struct rtl_halmac_indicator *indicator;	/* size=10 */
+
+	/* flags */
+	/*
+	 * send_general_info
+	 *	0: no need to call halmac_send_general_info()
+	 *	1: need to call halmac_send_general_info()
+	 */
+	u8 send_general_info;
+};
+
 struct proxim {
 	bool proxim_on;
 
@@ -2825,6 +2886,9 @@ struct rtl_priv {
 	/* phydm for newer IC. (e.g. 8822B) */
 	struct rtl_phydm phydm;
 
+	/* halmac for newer IC. (e.g. 8822B) */
+	struct rtl_halmac halmac;
+
 	/* separate 92ee from other ICs,
 	 * 92ee use new trx flow.
 	 */
-- 
2.12.3
