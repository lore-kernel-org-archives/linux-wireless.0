Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:39445 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab2GEUQE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 16:16:04 -0400
Received: by gglu4 with SMTP id u4so7857658ggl.19
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jul 2012 13:16:04 -0700 (PDT)
Message-ID: <4FF5F600.9040900@lwfinger.net> (sfid-20120705_221609_805447_5EB048C2)
Date: Thu, 05 Jul 2012 15:16:00 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ivan Ivanich <ivanich@ivanich.org.ua>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Trial change to rtl8192ce used as AP
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivan,

The following patch is suggested by the code-analysis tool cppcheck as the test 
is always false. As it will not affect STA usage, I have no way to test the 
change. Could you please do so?

Thanks,

Larry


Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
@@ -1097,7 +1097,7 @@ static int _rtl92ce_set_media_status(str

  	rtl_write_byte(rtlpriv, (MSR), bt_msr);
  	rtlpriv->cfg->ops->led_control(hw, ledaction);
-	if ((bt_msr & 0xfc) == MSR_AP)
+	if ((bt_msr & 0x03) == MSR_AP)
  		rtl_write_byte(rtlpriv, REG_BCNTCFG + 1, 0x00);
  	else
  		rtl_write_byte(rtlpriv, REG_BCNTCFG + 1, 0x66);

