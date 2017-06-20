Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:35201 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752475AbdFTAc1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Jun 2017 20:32:27 -0400
Received: by mail-ot0-f193.google.com with SMTP id z48so13333843otz.2
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jun 2017 17:32:27 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 02/10] rtlwifi: Do IQK only once to reduce wifi occupy antenna
Date: Mon, 19 Jun 2017 19:32:10 -0500
Message-Id: <20170620003218.17010-3-Larry.Finger@lwfinger.net> (sfid-20170620_023233_536430_E8D9C5A1)
In-Reply-To: <20170620003218.17010-1-Larry.Finger@lwfinger.net>
References: <20170620003218.17010-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Modify 8723be and 8192e only.
8812/8821 do IQK in DM, so we may do it later.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c  | 3 ++-
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c  | 7 +++++--
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c | 3 ++-
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
index 11d97fa0e921..d84ac7adfd82 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
@@ -1670,7 +1670,8 @@ void rtl92ee_card_disable(struct ieee80211_hw *hw)
 	_rtl92ee_poweroff_adapter(hw);
 
 	/* after power off we should do iqk again */
-	rtlpriv->phy.iqk_initialized = false;
+	if (!rtlpriv->cfg->ops->get_btc_status())
+		rtlpriv->phy.iqk_initialized = false;
 }
 
 void rtl92ee_interrupt_recognized(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
index 0ce2900722f4..2a7ad5ffe997 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
@@ -1443,7 +1443,9 @@ int rtl8723be_hw_init(struct ieee80211_hw *hw)
 		 */
 		if (rtlpriv->btcoexist.btc_info.ant_num == ANT_X2 ||
 		    !rtlpriv->cfg->ops->get_btc_status()) {
-			rtl8723be_phy_iq_calibrate(hw, false);
+			rtl8723be_phy_iq_calibrate(hw,
+						   (rtlphy->iqk_initialized ?
+						    true : false));
 			rtlphy->iqk_initialized = true;
 		}
 		rtl8723be_dm_check_txpower_tracking(hw);
@@ -1677,7 +1679,8 @@ void rtl8723be_card_disable(struct ieee80211_hw *hw)
 	_rtl8723be_poweroff_adapter(hw);
 
 	/* after power off we should do iqk again */
-	rtlpriv->phy.iqk_initialized = false;
+	if (!rtlpriv->cfg->ops->get_btc_status())
+		rtlpriv->phy.iqk_initialized = false;
 }
 
 void rtl8723be_interrupt_recognized(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
index ab0f39e46e1b..9752175cc466 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
@@ -2352,7 +2352,7 @@ void rtl8723be_phy_iq_calibrate(struct ieee80211_hw *hw, bool b_recovery)
 	if (b_recovery) {
 		rtl8723_phy_reload_adda_registers(hw, iqk_bb_reg,
 						  rtlphy->iqk_bb_backup, 9);
-		return;
+		goto label_done;
 	}
 	/* Save RF Path */
 	path_sel_bb = rtl_get_bbreg(hw, 0x948, MASKDWORD);
@@ -2460,6 +2460,7 @@ void rtl8723be_phy_iq_calibrate(struct ieee80211_hw *hw, bool b_recovery)
 	rtl_set_bbreg(hw, 0x948, MASKDWORD, path_sel_bb);
 	/* rtl_set_rfreg(hw, RF90_PATH_A, 0xb0, 0xfffff, path_sel_rf); */
 
+label_done:
 	spin_lock(&rtlpriv->locks.iqk_lock);
 	rtlphy->lck_inprogress = false;
 	spin_unlock(&rtlpriv->locks.iqk_lock);
-- 
2.12.3
