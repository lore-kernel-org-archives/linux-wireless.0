Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plaes.org ([188.166.43.21]:49776 "EHLO plaes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687AbbIOGHr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 02:07:47 -0400
From: Priit Laes <plaes@plaes.org>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Kalle Valo <kvalo@codeaurora.org>,
	Taehee Yoo <ap420073@gmail.com>
Cc: linux-wireless@vger.kernel.org, Priit Laes <plaes@plaes.org>
Subject: [PATCH RFC] rtlwifi: rtl8192cu: Add missing case in rtl92cu_get_hw_reg
Date: Tue, 15 Sep 2015 09:01:56 +0300
Message-Id: <1442296916-24336-1-git-send-email-plaes@plaes.org> (sfid-20150915_080750_981385_3216AC1C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver was reporting 'switch case not processed' after association,
so HW_VAR_KEEP_ALIVE was added and filled similarily to other drivers.

Positive side effect to this seems to be a bit more stable connection.

Signed-off-by: Priit Laes <plaes@plaes.org>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
index 25db369..34ce064 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -1946,6 +1946,14 @@ void rtl92cu_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 		rtl_write_word(rtlpriv, REG_RXFLTMAP2, *(u16 *)val);
 		mac->rx_data_filter = *(u16 *)val;
 		break;
+	case HW_VAR_KEEP_ALIVE:{
+			u8 array[2];
+			array[0] = 0xff;
+			array[1] = *((u8 *)val);
+			rtl92c_fill_h2c_cmd(hw, H2C_92C_KEEP_ALIVE_CTRL, 2,
+					    array);
+			break;
+		}
 	default:
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 "switch case not processed\n");
-- 
2.5.2

