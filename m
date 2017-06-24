Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:33876 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754144AbdFXBxR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Jun 2017 21:53:17 -0400
Received: by mail-ot0-f194.google.com with SMTP id p48so6525446otc.1
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jun 2017 18:53:16 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 02/10] rtlwifi: Add BT_MP_INFO to c2h handler.
Date: Fri, 23 Jun 2017 20:53:01 -0500
Message-Id: <20170624015309.28099-3-Larry.Finger@lwfinger.net> (sfid-20170624_035323_219923_0F6033B5)
In-Reply-To: <20170624015309.28099-1-Larry.Finger@lwfinger.net>
References: <20170624015309.28099-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

We use H2C to ask BT's status, and C2H will return the status.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       | 17 ++++++++++++-
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.c   | 28 ++++++++++++++++++++++
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.h   |  1 +
 .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.c    |  9 +++++--
 .../net/wireless/realtek/rtlwifi/rtl8723be/fw.c    |  9 +++++--
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.c    | 13 +++++++---
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  2 ++
 7 files changed, 71 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index e6024b013ca5..c1eacd8352a2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -327,7 +327,22 @@ static void halbtc_aggregation_check(struct btc_coexist *btcoexist)
 
 static u32 halbtc_get_bt_patch_version(struct btc_coexist *btcoexist)
 {
-	return 0;
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	u8 cmd_buffer[4] = {0};
+	u8 oper_ver = 0;
+	u8 req_num = 0x0E;
+
+	if (btcoexist->bt_info.bt_real_fw_ver)
+		goto label_done;
+
+	cmd_buffer[0] |= (oper_ver & 0x0f);	/* Set OperVer */
+	cmd_buffer[0] |= ((req_num << 4) & 0xf0);	/* Set ReqNum */
+	cmd_buffer[1] = 0; /* BT_OP_GET_BT_VERSION = 0 */
+	rtlpriv->cfg->ops->fill_h2c_cmd(rtlpriv->mac80211.hw, 0x67, 4,
+					&cmd_buffer[0]);
+
+label_done:
+	return btcoexist->bt_info.bt_real_fw_ver;
 }
 
 u32 halbtc_get_wifi_link_status(struct btc_coexist *btcoexist)
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
index 4366c9817e1e..7d296a401b6f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
@@ -41,6 +41,7 @@ static struct rtl_btc_ops rtl_btc_operation = {
 	.btc_periodical = rtl_btc_periodical,
 	.btc_halt_notify = rtl_btc_halt_notify,
 	.btc_btinfo_notify = rtl_btc_btinfo_notify,
+	.btc_btmpinfo_notify = rtl_btc_btmpinfo_notify,
 	.btc_is_limited_dig = rtl_btc_is_limited_dig,
 	.btc_is_disable_edca_turbo = rtl_btc_is_disable_edca_turbo,
 	.btc_is_bt_disabled = rtl_btc_is_bt_disabled,
@@ -165,6 +166,33 @@ void rtl_btc_btinfo_notify(struct rtl_priv *rtlpriv, u8 *tmp_buf, u8 length)
 	exhalbtc_bt_info_notify(&gl_bt_coexist, tmp_buf, length);
 }
 
+void rtl_btc_btmpinfo_notify(struct rtl_priv *rtlpriv, u8 *tmp_buf, u8 length)
+{
+	u8 extid, seq, len;
+	u16 bt_real_fw_ver;
+	u8 bt_fw_ver;
+
+	if ((length < 4) || (!tmp_buf))
+		return;
+
+	extid = tmp_buf[0];
+	/* not response from BT FW then exit*/
+	if (extid != 1) /* C2H_TRIG_BY_BT_FW = 1 */
+		return;
+
+	len = tmp_buf[1] >> 4;
+	seq = tmp_buf[2] >> 4;
+
+	/* BT Firmware version response */
+	if (seq == 0x0E) {
+		bt_real_fw_ver = tmp_buf[3] | (tmp_buf[4] << 8);
+		bt_fw_ver = tmp_buf[5];
+
+		gl_bt_coexist.bt_info.bt_real_fw_ver = bt_real_fw_ver;
+		gl_bt_coexist.bt_info.bt_fw_ver = bt_fw_ver;
+	}
+}
+
 bool rtl_btc_is_limited_dig(struct rtl_priv *rtlpriv)
 {
 	return gl_bt_coexist.bt_info.limited_dig;
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h
index 6fe521cbe7f0..ac1253c46f44 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h
@@ -39,6 +39,7 @@ void rtl_btc_mediastatus_notify(struct rtl_priv *rtlpriv,
 void rtl_btc_periodical(struct rtl_priv *rtlpriv);
 void rtl_btc_halt_notify(void);
 void rtl_btc_btinfo_notify(struct rtl_priv *rtlpriv, u8 *tmpbuf, u8 length);
+void rtl_btc_btmpinfo_notify(struct rtl_priv *rtlpriv, u8 *tmp_buf, u8 length);
 bool rtl_btc_is_limited_dig(struct rtl_priv *rtlpriv);
 bool rtl_btc_is_disable_edca_turbo(struct rtl_priv *rtlpriv);
 bool rtl_btc_is_bt_disabled(struct rtl_priv *rtlpriv);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
index f4ee7906eb20..31a391e9b830 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
@@ -888,6 +888,7 @@ void rtl92ee_c2h_content_parsing(struct ieee80211_hw *hw, u8 c2h_cmd_id,
 				 u8 c2h_cmd_len, u8 *tmp_buf)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_btc_ops *btc_ops = rtlpriv->btcoexist.btc_ops;
 
 	switch (c2h_cmd_id) {
 	case C2H_8192E_DBG:
@@ -906,12 +907,16 @@ void rtl92ee_c2h_content_parsing(struct ieee80211_hw *hw, u8 c2h_cmd_id,
 	case C2H_8192E_BT_INFO:
 		RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE,
 			 "[C2H], C2H_8723BE_BT_INFO!!\n");
-		rtlpriv->btcoexist.btc_ops->btc_btinfo_notify(rtlpriv, tmp_buf,
-							      c2h_cmd_len);
+		if (rtlpriv->cfg->ops->get_btc_status())
+			btc_ops->btc_btinfo_notify(rtlpriv, tmp_buf,
+						   c2h_cmd_len);
 		break;
 	case C2H_8192E_BT_MP:
 		RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE,
 			 "[C2H], C2H_8723BE_BT_MP!!\n");
+		if (rtlpriv->cfg->ops->get_btc_status())
+			btc_ops->btc_btmpinfo_notify(rtlpriv, tmp_buf,
+						     c2h_cmd_len);
 		break;
 	case C2H_8192E_RA_RPT:
 		_rtl92ee_c2h_ra_report_handler(hw, tmp_buf, c2h_cmd_len);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c
index 95b2e9a87d20..624edfd22e43 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c
@@ -710,6 +710,7 @@ void rtl8723be_c2h_content_parsing(struct ieee80211_hw *hw,
 				   u8 c2h_cmd_len, u8 *tmp_buf)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_btc_ops *btc_ops = rtlpriv->btcoexist.btc_ops;
 
 	switch (c2h_cmd_id) {
 	case C2H_8723B_DBG:
@@ -724,12 +725,16 @@ void rtl8723be_c2h_content_parsing(struct ieee80211_hw *hw,
 	case C2H_8723B_BT_INFO:
 		RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE,
 			 "[C2H], C2H_8723BE_BT_INFO!!\n");
-		rtlpriv->btcoexist.btc_ops->btc_btinfo_notify(rtlpriv, tmp_buf,
-							      c2h_cmd_len);
+		if (rtlpriv->cfg->ops->get_btc_status())
+			btc_ops->btc_btinfo_notify(rtlpriv, tmp_buf,
+						   c2h_cmd_len);
 		break;
 	case C2H_8723B_BT_MP:
 		RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE,
 			 "[C2H], C2H_8723BE_BT_MP!!\n");
+		if (rtlpriv->cfg->ops->get_btc_status())
+			btc_ops->btc_btmpinfo_notify(rtlpriv, tmp_buf,
+						     c2h_cmd_len);
 		break;
 	default:
 		RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE,
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
index 97401aa4dacb..8b1a8bc12301 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
@@ -1925,6 +1925,7 @@ void rtl8821ae_c2h_content_parsing(struct ieee80211_hw *hw,
 				   u8 *tmp_buf)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_btc_ops *btc_ops = rtlpriv->btcoexist.btc_ops;
 
 	switch (c2h_cmd_id) {
 	case C2H_8812_DBG:
@@ -1940,9 +1941,15 @@ void rtl8821ae_c2h_content_parsing(struct ieee80211_hw *hw,
 		RT_TRACE(rtlpriv, COMP_FW, DBG_LOUD,
 			 "[C2H], C2H_8812_BT_INFO!!\n");
 		if (rtlpriv->cfg->ops->get_btc_status())
-			rtlpriv->btcoexist.btc_ops->btc_btinfo_notify(rtlpriv,
-								      tmp_buf,
-								      c2h_cmd_len);
+			btc_ops->btc_btinfo_notify(rtlpriv, tmp_buf,
+						   c2h_cmd_len);
+		break;
+	case C2H_8812_BT_MP:
+		RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE,
+			 "[C2H], C2H_8812_BT_MP!!\n");
+		if (rtlpriv->cfg->ops->get_btc_status())
+			btc_ops->btc_btmpinfo_notify(rtlpriv, tmp_buf,
+						     c2h_cmd_len);
 		break;
 	default:
 		break;
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 7ec0d502a0d9..77c3b186900e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -2562,6 +2562,8 @@ struct rtl_btc_ops {
 	void (*btc_halt_notify) (void);
 	void (*btc_btinfo_notify) (struct rtl_priv *rtlpriv,
 				   u8 *tmp_buf, u8 length);
+	void (*btc_btmpinfo_notify)(struct rtl_priv *rtlpriv,
+				    u8 *tmp_buf, u8 length);
 	bool (*btc_is_limited_dig) (struct rtl_priv *rtlpriv);
 	bool (*btc_is_disable_edca_turbo) (struct rtl_priv *rtlpriv);
 	bool (*btc_is_bt_disabled) (struct rtl_priv *rtlpriv);
-- 
2.12.3
