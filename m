Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:56136 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753131AbdKFN55 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Nov 2017 08:57:57 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] rtlwifi: drop unused ppsc->last_wakeup_time
Date: Mon,  6 Nov 2017 14:55:37 +0100
Message-Id: <20171106135619.1248453-3-arnd@arndb.de> (sfid-20171106_145839_757422_6C7441D0)
In-Reply-To: <20171106135619.1248453-1-arnd@arndb.de>
References: <20171106135619.1248453-1-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The calculation of ppsc->last_wakeup_time is not y2038-safe, but
the variable is not used at all, so we can simply drop it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c | 5 -----
 drivers/net/wireless/realtek/rtlwifi/wifi.h         | 2 --
 2 files changed, 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
index ad28e188bd04..36f785c4ea0f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
@@ -1364,7 +1364,6 @@ static void _rtl8821ae_get_wakeup_reason(struct ieee80211_hw *hw)
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtlpriv);
 	u8 fw_reason = 0;
-	struct timeval ts;
 
 	fw_reason = rtl_read_byte(rtlpriv, REG_MCUTST_WOWLAN);
 
@@ -1378,15 +1377,11 @@ static void _rtl8821ae_get_wakeup_reason(struct ieee80211_hw *hw)
 	switch (fw_reason) {
 	case FW_WOW_V2_PTK_UPDATE_EVENT:
 		ppsc->wakeup_reason = WOL_REASON_PTK_UPDATE;
-		do_gettimeofday(&ts);
-		ppsc->last_wakeup_time = ts.tv_sec*1000 + ts.tv_usec/1000;
 		RT_TRACE(rtlpriv, COMP_POWER, DBG_DMESG,
 			 "It's a WOL PTK Key update event!\n");
 		break;
 	case FW_WOW_V2_GTK_UPDATE_EVENT:
 		ppsc->wakeup_reason = WOL_REASON_GTK_UPDATE;
-		do_gettimeofday(&ts);
-		ppsc->last_wakeup_time = ts.tv_sec*1000 + ts.tv_usec/1000;
 		RT_TRACE(rtlpriv, COMP_POWER, DBG_DMESG,
 			 "It's a WOL GTK Key update event!\n");
 		break;
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 6f1b0f4667d9..d9776af41976 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -1953,8 +1953,6 @@ struct rtl_ps_ctl {
 	u8 gtk_offload_enable;
 	/* Used for WOL, indicates the reason for waking event.*/
 	u32 wakeup_reason;
-	/* Record the last waking time for comparison with setting key. */
-	u64 last_wakeup_time;
 };
 
 struct rtl_stats {
-- 
2.9.0
