Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35970 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751266AbcLCRcX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Dec 2016 12:32:23 -0500
Received: by mail-oi0-f67.google.com with SMTP id u15so31484356oie.3
        for <linux-wireless@vger.kernel.org>; Sat, 03 Dec 2016 09:32:23 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 0/7] rtlwifi: btcoexist: Rewrite BT coexistence routines
Date: Sat,  3 Dec 2016 11:32:00 -0600
Message-Id: <20161203173207.17774-1-Larry.Finger@lwfinger.net> (sfid-20161203_183227_426871_4B241361)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This set of patches implement a major rewrite of the BT coexistence
routines.

These patches must follow [PATCH 14/14] rtlwifi: Add work queue for c2h cmd.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Ping-Ke Shih (7)
  rtlwifi: btcoexist: Update routines for RTL8192EE
  rtlwifi: btcoexist: Rewrite halbtc8723b1ant code
  rtlwifi: btcoexist: Rewrite of halbtc8723b2ant
  rtlwifi: btcoexist: Rewrite routine halbtc8821a1ant
  rtlwifi: btcoexist: Rewrite routine halbtc8821a2ant
  rtlwifi: Add btcoex record_pwr_mode
  rtlwifi: btcoexist control to enter/leave LPS

 drivers/net/wireless/realtek/rtlwifi/base.c        |    8 +
 .../wireless/realtek/rtlwifi/btcoexist/Makefile    |    7 +-
 .../realtek/rtlwifi/btcoexist/halbt_precomp.h      |   22 +
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.c    | 4598 ++++++++-------
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.h    |  243 +-
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    | 5165 +++++++++++------
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.h    |  342 +-
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 5495 +++++++++++-------
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.h    |  287 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    | 3233 ++++++-----
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.h    |  148 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 6122 +++++++++++---------
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.h    |  273 +-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       | 1018 +++-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |  364 +-
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.c   |   74 +-
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.h   |    5 +
 .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.c    |   67 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.h    |    4 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/fw.c    |   68 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/fw.h    |   23 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.c    |    2 +
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.c    |   68 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.h    |   33 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |    5 +
 25 files changed, 16246 insertions(+), 11428 deletions(-)

-- 
2.10.2
