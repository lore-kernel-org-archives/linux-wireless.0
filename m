Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:33531 "EHLO m12-17.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757058AbaLINUm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2014 08:20:42 -0500
From: weiyj_lk@163.com
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	Ben Hutchings <ben@decadent.org.uk>,
	Peter Wu <lekensteyn@gmail.com>,
	Karsten Wiese <fzuuzf@googlemail.com>,
	Andy Spencer <andy753421@ucla.edu>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	linux-wireless@vger.kernel.org
Subject: [PATCH -next] rtlwifi: rtl8192cu: Fix sparse non static symbol warning
Date: Tue,  9 Dec 2014 21:18:43 +0800
Message-Id: <1418131123-3606-1-git-send-email-weiyj_lk@163.com> (sfid-20141209_142046_265509_F10E1959)
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fixes the following sparse warnings:

drivers/net/wireless/rtlwifi/rtl8192cu/hw.c:1595:6: warning:
 symbol 'usb_cmd_send_packet' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
index 873363ac..5513217 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -1592,7 +1592,7 @@ void rtl92cu_get_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 	}
 }
 
-bool usb_cmd_send_packet(struct ieee80211_hw *hw, struct sk_buff *skb)
+static bool usb_cmd_send_packet(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
   /* Currently nothing happens here.
    * Traffic stops after some seconds in WPA2 802.11n mode.

