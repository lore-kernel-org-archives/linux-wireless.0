Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:40092 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbaFHBhM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jun 2014 21:37:12 -0400
Received: by mail-wi0-f171.google.com with SMTP id cc10so2667737wib.10
        for <linux-wireless@vger.kernel.org>; Sat, 07 Jun 2014 18:37:10 -0700 (PDT)
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	"John W. Linville" <linville@tuxdriver.com>,
	Joe Perches <joe@perches.com>, Peter Wu <lekensteyn@gmail.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] net: wireless: rtlwifi: rtl8188ee: hw.c:  Cleaning up if statement that always evaluates to false
Date: Sun,  8 Jun 2014 03:38:06 +0200
Message-Id: <1402191486-25679-1-git-send-email-rickard_strandqvist@spectrumdigital.se> (sfid-20140608_033737_463501_C70EEF66)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I find a logical error in an if statement '(X & 0xfc) == 0x3' is always false

After pointing this out, Larry Finger informed what would be the correct one.
'(X & 0x3) == 0x3'

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
index 94cd9df..35ea614 100644
--- a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
@@ -1231,7 +1231,7 @@ static int _rtl88ee_set_media_status(struct ieee80211_hw *hw,
 
 	rtl_write_byte(rtlpriv, (MSR), bt_msr);
 	rtlpriv->cfg->ops->led_control(hw, ledaction);
-	if ((bt_msr & 0xfc) == MSR_AP)
+	if ((bt_msr & MSR_AP) == MSR_AP)
 		rtl_write_byte(rtlpriv, REG_BCNTCFG + 1, 0x00);
 	else
 		rtl_write_byte(rtlpriv, REG_BCNTCFG + 1, 0x66);
-- 
1.7.10.4

