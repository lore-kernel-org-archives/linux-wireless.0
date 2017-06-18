Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:36444 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753094AbdFRQMy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Jun 2017 12:12:54 -0400
Received: by mail-ot0-f193.google.com with SMTP id r67so9070816ota.3
        for <linux-wireless@vger.kernel.org>; Sun, 18 Jun 2017 09:12:54 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 00/11] rtlwifi: Update drivers for various changes in btcoex
Date: Sun, 18 Jun 2017 11:12:38 -0500
Message-Id: <20170618161249.6146-1-Larry.Finger@lwfinger.net> (sfid-20170618_181308_671626_8012425B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There have been a number of changes in btcoex that require changes in
the other drivers.

Larry

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>


Ping-Ke Shih (11):
  rtlwifi: btcoex: call bind to setup btcoex
  rtlwifi: btcoex: set correct interface type and parameter.
  rtlwifi: btcoex: rtl8723be: fix ant_sel not work
  rtlwifi: Correct power save capability while init mac80211
  rtlwifi: extend debug_comp to u64
  rtlwifi: Add TX report and disable key to force wait until report
    acked.
  rtlwifi: Revise special packet notification to be readable format.
  rtlwifi: Add btcoex record_pwr_mode
  rtlwifi: Add rx ampdu cfg for btcoexist.
  rtlwifi: add btc_is_bt_lps_on() for btcoexist
  rtlwifi: btcoexist control to enter/leave LPS

 drivers/net/wireless/realtek/rtlwifi/base.c        | 180 +++++++++++++++++++--
 drivers/net/wireless/realtek/rtlwifi/base.h        |  14 ++
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       |  41 ++++-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |   3 +-
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.c   |  52 +++++-
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.h   |   7 +
 drivers/net/wireless/realtek/rtlwifi/core.c        |   5 +-
 drivers/net/wireless/realtek/rtlwifi/debug.c       |   2 +-
 drivers/net/wireless/realtek/rtlwifi/debug.h       |   7 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/sw.c    |   2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.c    |  70 +++++++-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.h    |   4 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/sw.c    |   2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/trx.c   |   3 +
 .../net/wireless/realtek/rtlwifi/rtl8192ee/trx.h   |   2 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/fw.c    |  71 +++++++-
 .../net/wireless/realtek/rtlwifi/rtl8723be/fw.h    |   4 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.c    |   3 +
 .../net/wireless/realtek/rtlwifi/rtl8723be/trx.c   |   3 +
 .../net/wireless/realtek/rtlwifi/rtl8723be/trx.h   |  12 ++
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.c    |  73 +++++++--
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.h    |   4 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/trx.c   |   3 +
 .../net/wireless/realtek/rtlwifi/rtl8821ae/trx.h   |  13 ++
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  18 +++
 25 files changed, 536 insertions(+), 62 deletions(-)

-- 
2.12.3
