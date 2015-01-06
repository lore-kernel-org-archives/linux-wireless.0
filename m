Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:40143 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755915AbbAFP6d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 10:58:33 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org
Subject: [PATCH 10/11 V2] rtlwifi: rtl8821ae: Convert driver to use common DM table initialization
Date: Tue,  6 Jan 2015 09:58:11 -0600
Message-Id: <1420559892-12384-11-git-send-email-Larry.Finger@lwfinger.net> (sfid-20150106_165850_463450_8D1FD73D)
In-Reply-To: <1420559892-12384-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1420559892-12384-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Convert driver to use routine rtl_dm_diginit().

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

V2 - unchanged from V1
---

 drivers/net/wireless/rtlwifi/rtl8821ae/dm.c | 31 ++---------------------------
 1 file changed, 2 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/dm.c b/drivers/net/wireless/rtlwifi/rtl8821ae/dm.c
index 4af4613..0b2082d 100644
--- a/drivers/net/wireless/rtlwifi/rtl8821ae/dm.c
+++ b/drivers/net/wireless/rtlwifi/rtl8821ae/dm.c
@@ -520,34 +520,6 @@ void rtl8821ae_dm_initialize_txpower_tracking_thermalmeter(
 	}
 }
 
-static void rtl8821ae_dm_diginit(struct ieee80211_hw *hw)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct dig_t *dm_digtable = &rtlpriv->dm_digtable;
-
-	dm_digtable->cur_igvalue = rtl_get_bbreg(hw, ROFDM0_XAAGCCORE1, 0x7f);
-	dm_digtable->rssi_lowthresh = DM_DIG_THRESH_LOW;
-	dm_digtable->rssi_highthresh = DM_DIG_THRESH_HIGH;
-	dm_digtable->fa_lowthresh = DM_FALSEALARM_THRESH_LOW;
-	dm_digtable->fa_highthresh = DM_FALSEALARM_THRESH_HIGH;
-	dm_digtable->rx_gain_max = DM_DIG_MAX;
-	dm_digtable->rx_gain_min = DM_DIG_MIN;
-	dm_digtable->back_val = DM_DIG_BACKOFF_DEFAULT;
-	dm_digtable->back_range_max = DM_DIG_BACKOFF_MAX;
-	dm_digtable->back_range_min = DM_DIG_BACKOFF_MIN;
-	dm_digtable->pre_cck_cca_thres = 0xff;
-	dm_digtable->cur_cck_cca_thres = 0x83;
-	dm_digtable->forbidden_igi = DM_DIG_MIN;
-	dm_digtable->large_fa_hit = 0;
-	dm_digtable->recover_cnt = 0;
-	dm_digtable->dig_min_0 = DM_DIG_MIN;
-	dm_digtable->dig_min_1 = DM_DIG_MIN;
-	dm_digtable->media_connect_0 = false;
-	dm_digtable->media_connect_1 = false;
-	rtlpriv->dm.dm_initialgain_enable = true;
-	dm_digtable->bt30_cur_igi = 0x32;
-}
-
 void rtl8821ae_dm_init_edca_turbo(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -607,6 +579,7 @@ void rtl8821ae_dm_init(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &rtlpriv->phy;
+	u32 cur_igvalue = rtl_get_bbreg(hw, ROFDM0_XAAGCCORE1, 0x7f);
 
 	spin_lock(&rtlpriv->locks.iqk_lock);
 	rtlphy->lck_inprogress = false;
@@ -614,7 +587,7 @@ void rtl8821ae_dm_init(struct ieee80211_hw *hw)
 
 	rtlpriv->dm.dm_type = DM_TYPE_BYDRIVER;
 	rtl8821ae_dm_common_info_self_init(hw);
-	rtl8821ae_dm_diginit(hw);
+	rtl_dm_diginit(hw, cur_igvalue);
 	rtl8821ae_dm_init_rate_adaptive_mask(hw);
 	rtl8821ae_dm_init_edca_turbo(hw);
 	rtl8821ae_dm_initialize_txpower_tracking_thermalmeter(hw);
-- 
2.1.2

