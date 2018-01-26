Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:38998 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751431AbeAZHrG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 02:47:06 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 02/10] rtlwifi: Add Support VHT to spec_ver
Date: Fri, 26 Jan 2018 15:46:37 +0800
Message-ID: <20180126074645.27201-3-pkshih@realtek.com> (sfid-20180126_084727_083904_15A4C3CE)
In-Reply-To: <20180126074645.27201-1-pkshih@realtek.com>
References: <20180126074645.27201-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

We are going to add 8822be, which is a VHT 2x2 wifi chip, so add VHT flag
to replace enumeration of chips.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/base.c         | 6 ++++--
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c | 1 +
 drivers/net/wireless/realtek/rtlwifi/wifi.h         | 1 +
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index e461eed32699..a2da057d3cdd 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -244,6 +244,9 @@ static void _rtl_init_hw_vht_capab(struct ieee80211_hw *hw,
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
 
+	if (!(rtlpriv->cfg->spec_ver & RTL_SPEC_SUPPORT_VHT))
+		return;
+
 	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8812AE ||
 	    rtlhal->hw_type == HARDWARE_TYPE_RTL8822BE) {
 		u16 mcs_map;
@@ -887,8 +890,7 @@ static void _rtl_query_bandwidth_mode(struct ieee80211_hw *hw,
 
 	tcb_desc->packet_bw = HT_CHANNEL_WIDTH_20_40;
 
-	if (rtlpriv->rtlhal.hw_type == HARDWARE_TYPE_RTL8812AE ||
-	    rtlpriv->rtlhal.hw_type == HARDWARE_TYPE_RTL8821AE) {
+	if (rtlpriv->cfg->spec_ver & RTL_SPEC_SUPPORT_VHT) {
 		if (mac->opmode == NL80211_IFTYPE_AP ||
 		    mac->opmode == NL80211_IFTYPE_ADHOC ||
 		    mac->opmode == NL80211_IFTYPE_MESH_POINT) {
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
index ab5d462b1a3a..9bb3d9dfce79 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
@@ -328,6 +328,7 @@ static const struct rtl_hal_cfg rtl8821ae_hal_cfg = {
 	.alt_fw_name = "rtlwifi/rtl8821aefw.bin",
 	.ops = &rtl8821ae_hal_ops,
 	.mod_params = &rtl8821ae_mod_params,
+	.spec_ver = RTL_SPEC_SUPPORT_VHT,
 	.maps[SYS_ISO_CTRL] = REG_SYS_ISO_CTRL,
 	.maps[SYS_FUNC_EN] = REG_SYS_FUNC_EN,
 	.maps[SYS_CLK] = REG_SYS_CLKR,
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index a7aacbc3984e..2df0bc316532 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -951,6 +951,7 @@ enum package_type {
 
 enum rtl_spec_ver {
 	RTL_SPEC_NEW_RATEID = BIT(0),	/* use ratr_table_mode_new */
+	RTL_SPEC_SUPPORT_VHT = BIT(1),	/* support VHT */
 };
 
 struct octet_string {
-- 
2.15.1
