Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:59641 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342AbbAFP6a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 10:58:30 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org
Subject: [PATCH 08/11 V2] rtlwifi: rtl8723ae: Convert driver to use common DM table initialization
Date: Tue,  6 Jan 2015 09:58:09 -0600
Message-Id: <1420559892-12384-9-git-send-email-Larry.Finger@lwfinger.net> (sfid-20150106_165904_356017_A3B53C8F)
In-Reply-To: <1420559892-12384-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1420559892-12384-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Convert driver rtl8723ae to use common routine rtl_dm_diginit().

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

V2 - unchanged from V1
---

 drivers/net/wireless/rtlwifi/rtl8723ae/dm.c | 27 +--------------------------
 1 file changed, 1 insertion(+), 26 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/dm.c b/drivers/net/wireless/rtlwifi/rtl8723ae/dm.c
index 8bd124c..4c1c96c 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723ae/dm.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723ae/dm.c
@@ -147,31 +147,6 @@ static const u8 cckswing_table_ch14[CCK_TABLE_SIZE][8] = {
 	{0x09, 0x08, 0x07, 0x04, 0x00, 0x00, 0x00, 0x00}
 };
 
-static void rtl8723e_dm_diginit(struct ieee80211_hw *hw)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct dig_t *dm_digtable = &rtlpriv->dm_digtable;
-
-	dm_digtable->dig_enable_flag = true;
-	dm_digtable->dig_ext_port_stage = DIG_EXT_PORT_STAGE_MAX;
-	dm_digtable->cur_igvalue = 0x20;
-	dm_digtable->pre_igvalue = 0x0;
-	dm_digtable->cursta_cstate = DIG_STA_DISCONNECT;
-	dm_digtable->presta_cstate = DIG_STA_DISCONNECT;
-	dm_digtable->curmultista_cstate = DIG_MULTISTA_DISCONNECT;
-	dm_digtable->rssi_lowthresh = DM_DIG_THRESH_LOW;
-	dm_digtable->rssi_highthresh = DM_DIG_THRESH_HIGH;
-	dm_digtable->fa_lowthresh = DM_FALSEALARM_THRESH_LOW;
-	dm_digtable->fa_highthresh = DM_FALSEALARM_THRESH_HIGH;
-	dm_digtable->rx_gain_max = DM_DIG_MAX;
-	dm_digtable->rx_gain_min = DM_DIG_MIN;
-	dm_digtable->back_val = DM_DIG_BACKOFF_DEFAULT;
-	dm_digtable->back_range_max = DM_DIG_BACKOFF_MAX;
-	dm_digtable->back_range_min = DM_DIG_BACKOFF_MIN;
-	dm_digtable->pre_cck_pd_state = CCK_PD_STAGE_MAX;
-	dm_digtable->cur_cck_pd_state = CCK_PD_STAGE_MAX;
-}
-
 static u8 rtl8723e_dm_initial_gain_min_pwdb(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -819,7 +794,7 @@ void rtl8723e_dm_init(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
 	rtlpriv->dm.dm_type = DM_TYPE_BYDRIVER;
-	rtl8723e_dm_diginit(hw);
+	rtl_dm_diginit(hw, 0x20);
 	rtl8723_dm_init_dynamic_txpower(hw);
 	rtl8723_dm_init_edca_turbo(hw);
 	rtl8723e_dm_init_rate_adaptive_mask(hw);
-- 
2.1.2

