Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:52464 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751682AbeB1DHl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 22:07:41 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 08/15] rtlwifi: btcoex: Add pre- and post- normal LPS function
Date: Wed, 28 Feb 2018 11:07:11 +0800
Message-ID: <20180228030718.19510-9-pkshih@realtek.com> (sfid-20180228_040756_839482_3478030C)
In-Reply-To: <20180228030718.19510-1-pkshih@realtek.com>
References: <20180228030718.19510-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Normal LPS is decomposed into pre- and post- parts, so we can issue H2C
with TDMA parameters in the "critical section" that dirver can't change
LPS state at the moment.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       | 22 ++++++++++++++++++++++
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |  2 ++
 2 files changed, 24 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index bfb32d476a70..0f664a0490a7 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -363,6 +363,22 @@ static void halbtc_normal_lps(struct btc_coexist *btcoexist)
 	}
 }
 
+static void halbtc_pre_normal_lps(struct btc_coexist *btcoexist)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	if (btcoexist->bt_info.bt_ctrl_lps) {
+		btcoexist->bt_info.bt_lps_on = false;
+		rtl_lps_leave(rtlpriv->mac80211.hw);
+	}
+}
+
+static void halbtc_post_normal_lps(struct btc_coexist *btcoexist)
+{
+	if (btcoexist->bt_info.bt_ctrl_lps)
+		btcoexist->bt_info.bt_ctrl_lps = false;
+}
+
 static void halbtc_leave_low_power(struct btc_coexist *btcoexist)
 {
 }
@@ -806,6 +822,12 @@ static bool halbtc_set(void *void_btcoexist, u8 set_type, void *in_buf)
 	case BTC_SET_ACT_NORMAL_LPS:
 		halbtc_normal_lps(btcoexist);
 		break;
+	case BTC_SET_ACT_PRE_NORMAL_LPS:
+		halbtc_pre_normal_lps(btcoexist);
+		break;
+	case BTC_SET_ACT_POST_NORMAL_LPS:
+		halbtc_post_normal_lps(btcoexist);
+		break;
 	case BTC_SET_ACT_DISABLE_LOW_POWER:
 		halbtc_disable_low_power(btcoexist, *bool_tmp);
 		break;
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
index 1f12449363c2..ad80ec05975e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -349,6 +349,8 @@ enum btc_set_type {
 	BTC_SET_ACT_LEAVE_LPS,
 	BTC_SET_ACT_ENTER_LPS,
 	BTC_SET_ACT_NORMAL_LPS,
+	BTC_SET_ACT_PRE_NORMAL_LPS,
+	BTC_SET_ACT_POST_NORMAL_LPS,
 	BTC_SET_ACT_INC_FORCE_EXEC_PWR_CMD_CNT,
 	BTC_SET_ACT_DISABLE_LOW_POWER,
 	BTC_SET_ACT_UPDATE_RAMASK,
-- 
2.15.1
