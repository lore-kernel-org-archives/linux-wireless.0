Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:33705 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758789AbcIXQ5a (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Sep 2016 12:57:30 -0400
Received: by mail-oi0-f49.google.com with SMTP id r126so166750490oib.0
        for <linux-wireless@vger.kernel.org>; Sat, 24 Sep 2016 09:57:30 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 0/2] rtlwifi: Add missing values to case statements and simplify debugging
Date: Sat, 24 Sep 2016 11:57:17 -0500
Message-Id: <1474736239-9826-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20160924_185734_162047_0A95B9A4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Routines *_get_hw_reg() for some of the drivers were missing entries for
HAL_DEF_WOWLAN. No action should be taken for these drivers.

Patch 1 depends on "realtek: Add switch variable to 'switch case not
processed' messages" submitted by Joe Perches. That patch will log
missing cases with the hex value. To aid in debugging, the values for
entries in the hardware variables enum are explicitly defined in hex. 

Larry Finger (2):
  rtlwifi: Add HAL_DEF_WOWLAN case to *_get_hw() routines
  rtlwifi: Add explicit values to hw_variables enum

 .../net/wireless/realtek/rtlwifi/rtl8188ee/hw.c    |   2 +
 .../net/wireless/realtek/rtlwifi/rtl8192ce/hw.c    |   2 +
 .../net/wireless/realtek/rtlwifi/rtl8192de/hw.c    |   2 +
 .../net/wireless/realtek/rtlwifi/rtl8192ee/hw.c    |   2 +
 .../net/wireless/realtek/rtlwifi/rtl8192se/hw.c    |   2 +
 .../net/wireless/realtek/rtlwifi/rtl8723ae/hw.c    |   2 +
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.c    |   2 +
 drivers/net/wireless/realtek/rtlwifi/wifi.h        | 208 ++++++++++-----------
 8 files changed, 118 insertions(+), 104 deletions(-)

-- 
2.6.6
