Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:42895 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752957AbeAJFUc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Jan 2018 00:20:32 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <yhchuang@realtek.com>,
        <linux-wireless@vger.kernel.org>
Subject: [PATCH 02/10] rtlwifi: fix scan channel 1 fail after IPS
Date: Wed, 10 Jan 2018 13:19:54 +0800
Message-ID: <20180110052002.9544-3-pkshih@realtek.com> (sfid-20180110_063154_703643_C6241134)
In-Reply-To: <20180110052002.9544-1-pkshih@realtek.com>
References: <20180110052002.9544-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

If there is no connection, driver will enter IPS state. Meanwhile, it
fails to scan channel 1 by the command 'iw dev wlan0 scan freq 2412',
because hardware channel setting lose after IPS. Thus, restore channel
setting from hw->conf.channel set by last rtl_op_config().

Signed-off-by: Tim Lee <timlee@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/ps.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/ps.c b/drivers/net/wireless/realtek/rtlwifi/ps.c
index 6a4008845f49..0ffe43772c9a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/ps.c
+++ b/drivers/net/wireless/realtek/rtlwifi/ps.c
@@ -51,6 +51,12 @@ bool rtl_ps_enable_nic(struct ieee80211_hw *hw)
 			&rtlmac->retry_long);
 	RT_CLEAR_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_HALT_NIC);
 
+	/*<2.1> Switch Channel & Bandwidth to last rtl_op_config setting*/
+	rtlpriv->cfg->ops->switch_channel(hw);
+	rtlpriv->cfg->ops->set_channel_access(hw);
+	rtlpriv->cfg->ops->set_bw_mode(hw,
+			cfg80211_get_chandef_type(&hw->conf.chandef));
+
 	/*<3> Enable Interrupt */
 	rtlpriv->cfg->ops->enable_interrupt(hw);
 
-- 
2.15.1
