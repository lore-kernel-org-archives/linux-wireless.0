Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:32946 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933151AbcBYRDI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2016 12:03:08 -0500
Received: by mail-ob0-f182.google.com with SMTP id jq7so53703523obb.0
        for <linux-wireless@vger.kernel.org>; Thu, 25 Feb 2016 09:03:08 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH] rtlwifi: Fix size of wireless mode variable
Date: Thu, 25 Feb 2016 11:03:01 -0600
Message-Id: <1456419781-14722-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20160225_180314_229478_5911017B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Smatch reports the following warning:

  CHECK   drivers/net/wireless/realtek/rtlwifi/rc.c
drivers/net/wireless/realtek/rtlwifi/rc.c:144 _rtl_rc_rate_set_series() warn: impossible condition '(wireless_mode == 256) => (0-255 == 256)'

This warning arises because commit acc6907b87a9 ("rtlwifi: Fix warning
from ieee80211_get_tx_rates() when using 5G") now checks the wireless
mode for WIRELESS_MODE_AC_ONLY (BIT(8)) in _rtl_rc_rate_set_series().
As a result, all quantities used to store the wireless mode must be u16.

This patch also reorders struct rtl_sta_info to save a little space.

Fixes: commit acc6907b87a9 ("rtlwifi: Fix warning from ieee80211_get_tx_rates() when using 5G")
Reported-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/rc.c           | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c | 2 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h         | 9 ++++-----
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rc.c b/drivers/net/wireless/realtek/rtlwifi/rc.c
index 28f7010..1aca777 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rc.c
@@ -41,7 +41,7 @@ static u8 _rtl_rc_get_highest_rix(struct rtl_priv *rtlpriv,
 	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
 	struct rtl_sta_info *sta_entry = NULL;
-	u8 wireless_mode = 0;
+	u16 wireless_mode = 0;
 
 	/*
 	 *this rate is no use for true rate, firmware
@@ -99,7 +99,7 @@ static void _rtl_rc_rate_set_series(struct rtl_priv *rtlpriv,
 {
 	struct rtl_mac *mac = rtl_mac(rtlpriv);
 	struct rtl_sta_info *sta_entry = NULL;
-	u8 wireless_mode = 0;
+	u16 wireless_mode = 0;
 	u8 sgi_20 = 0, sgi_40 = 0, sgi_80 = 0;
 
 	if (sta) {
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
index 5da9bd0..fe900ba 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
@@ -3837,7 +3837,7 @@ void rtl8821ae_update_channel_access_setting(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
-	u8 wireless_mode = mac->mode;
+	u16 wireless_mode = mac->mode;
 	u8 sifs_timer, r2t_sifs;
 
 	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_SLOT_TIME,
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index b07b364..554d814 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -1318,14 +1318,13 @@ struct rtl_tid_data {
 
 struct rtl_sta_info {
 	struct list_head list;
-	u8 ratr_index;
-	u8 wireless_mode;
-	u8 mimo_ps;
-	u8 mac_addr[ETH_ALEN];
 	struct rtl_tid_data tids[MAX_TID_COUNT];
-
 	/* just used for ap adhoc or mesh*/
 	struct rssi_sta rssi_stat;
+	u16 wireless_mode;
+	u8 ratr_index;
+	u8 mimo_ps;
+	u8 mac_addr[ETH_ALEN];
 } __packed;
 
 struct rtl_priv;
-- 
2.1.4

