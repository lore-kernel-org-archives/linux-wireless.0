Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35913 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753144AbdEPNUL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 May 2017 09:20:11 -0400
Received: by mail-oi0-f68.google.com with SMTP id w138so3299847oiw.3
        for <linux-wireless@vger.kernel.org>; Tue, 16 May 2017 06:20:11 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 10/10] rtlwifi: btcoex: 23b 1ant: check PS state before setting tdma duration
Date: Tue, 16 May 2017 08:19:57 -0500
Message-Id: <20170516131957.9513-11-Larry.Finger@lwfinger.net> (sfid-20170516_152024_393411_C085C789)
In-Reply-To: <20170516131957.9513-1-Larry.Finger@lwfinger.net>
References: <20170516131957.9513-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

For time division multiple access, the wifi and bt take turns to
transmit, but we need to let AP know that wifi is under standby mode by
sending null data to "pretend" entering power saving state using lps
rpwm.

But, the fw does not know if it is the actual power saving mode or just a
fake one to cheat to the AP. Hence, before fw setting the tdma duration,
the fw needs the driver to check the power saving state first.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c | 3 +++
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
index b07883eaec5e..f3704d7db4d5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -1401,6 +1401,7 @@ static void halbtc8723b1ant_power_save_state(struct btc_coexist *btcoexist,
 		btcoexist->btc_set(btcoexist, BTC_SET_ACT_DISABLE_LOW_POWER,
 				   &low_pwr_disable);
 		btcoexist->btc_set(btcoexist, BTC_SET_ACT_NORMAL_LPS, NULL);
+		coex_sta->force_lps_on = false;
 		break;
 	case BTC_PS_LPS_ON:
 		halbtc8723b1ant_ps_tdma_chk_pwr_save(btcoexist, true);
@@ -1412,10 +1413,12 @@ static void halbtc8723b1ant_power_save_state(struct btc_coexist *btcoexist,
 				   &low_pwr_disable);
 		/* power save must executed before psTdma */
 		btcoexist->btc_set(btcoexist, BTC_SET_ACT_ENTER_LPS, NULL);
+		coex_sta->force_lps_on = true;
 		break;
 	case BTC_PS_LPS_OFF:
 		halbtc8723b1ant_ps_tdma_chk_pwr_save(btcoexist, false);
 		btcoexist->btc_set(btcoexist, BTC_SET_ACT_LEAVE_LPS, NULL);
+		coex_sta->force_lps_on = false;
 		break;
 	default:
 		break;
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
index 0b7b9b2a8e12..d502a31812ab 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
@@ -161,6 +161,7 @@ struct coex_sta_8723b_1ant {
 	u8 bt_retry_cnt;
 	u8 bt_info_ext;
 	bool cck_ever_lock;
+	bool force_lps_on;
 	u32 pop_event_cnt;
 
 	u32 crc_ok_cck;
-- 
2.12.0
