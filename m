Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 220-135-115-6.HINET-IP.hinet.net ([220.135.115.6]:42505 "EHLO
        ns.kevlo.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727112AbeICSgm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Sep 2018 14:36:42 -0400
Date: Mon, 3 Sep 2018 22:06:09 +0800
From: Kevin Lo <kevlo@kevlo.org>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
        John Linville <linville@tuxdriver.com>
Subject: [PATCH] rtlwifi: remove set but unused variables
Message-ID: <20180903140609.GA63782@ns.kevlo.org> (sfid-20180903_161627_055895_F7AC33BF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove unused variables from _rtl88ee_hw_configure() and
_rtl8723e_hw_configure().

Signed-off-by: Kevin Lo <kevlo.org>
---
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
index 988d5ac57d02..cfc8762c55f4 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
@@ -951,12 +951,8 @@ static bool _rtl88ee_init_mac(struct ieee80211_hw *hw)
 static void _rtl88ee_hw_configure(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u8 reg_bw_opmode;
-	u32 reg_ratr, reg_prsr;
+	u32 reg_prsr;
 
-	reg_bw_opmode = BW_OPMODE_20MHZ;
-	reg_ratr = RATE_ALL_CCK | RATE_ALL_OFDM_AG |
-	    RATE_ALL_OFDM_1SS | RATE_ALL_OFDM_2SS;
 	reg_prsr = RATE_ALL_CCK | RATE_ALL_OFDM_AG;
 
 	rtl_write_dword(rtlpriv, REG_RRSR, reg_prsr);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
index 545115db507e..f783e4a8083d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
@@ -799,11 +799,9 @@ static void _rtl8723e_hw_configure(struct ieee80211_hw *hw)
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u8 reg_bw_opmode;
-	u32 reg_ratr, reg_prsr;
+	u32 reg_prsr;
 
 	reg_bw_opmode = BW_OPMODE_20MHZ;
-	reg_ratr = RATE_ALL_CCK | RATE_ALL_OFDM_AG |
-	    RATE_ALL_OFDM_1SS | RATE_ALL_OFDM_2SS;
 	reg_prsr = RATE_ALL_CCK | RATE_ALL_OFDM_AG;
 
 	rtl_write_byte(rtlpriv, REG_INIRTS_RATE_SEL, 0x8);
