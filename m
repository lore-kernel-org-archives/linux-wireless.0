Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35448 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751105AbcLBBso (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Dec 2016 20:48:44 -0500
Received: by mail-oi0-f67.google.com with SMTP id v84so25421427oie.2
        for <linux-wireless@vger.kernel.org>; Thu, 01 Dec 2016 17:48:43 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 00/14] rtlwifi: Various updates
Date: Thu,  1 Dec 2016 19:48:19 -0600
Message-Id: <20161202014833.6856-1-Larry.Finger@lwfinger.net> (sfid-20161202_024848_755113_877365D9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Realtek has finished an extensive review and rewrite of the rtlwifi
drivers. Much of that work resulted in major changes to btcoexist.
Those changes are not included here, but will be submitted later.

These 14 changes fix a number of deficiencies. None of them are
serious enough to be pushed to stable; however they help in the
stability of the drivers, and in the robustness of authentication/
association.

This material should be sent to the 4.11 stream.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Vincent Fann (1)
  rtlwifi: Correct power save capability while init mac80211
Ping-Ke Shih (13)
  rtlwifi: Fix programing CAM content sequence.
  rtlwifi: Set retry limit depends on vif type.
  rtlwifi: extend debug_comp to u64
  rtlwifi: Add TX report and disable key will wait until report acked.
  rtlwifi: rtl8723be: btcoexist: Add single_ant_path
  rtlwifi: move btcoex's ant_num declaration
  rtlwifi: rtl8723be: btcoex: add package_type function to btcoex
  rtlwifi: ibtcoex: move bt_type declaration
  rtlwifi: Add BTC_TRACE_STRING to new btcoex
  rtlwifi: Add a new enumeration value to btc_set_type
  rtlwifi: btcoexist: Add vendor definition for new btcoexist
  rtlwifi: rtl8723be: fix ant_sel code
  rtlwifi: Add work queue for c2h cmd.

 drivers/net/wireless/realtek/rtlwifi/base.c        | 211 +++++++++++++++++++--
 drivers/net/wireless/realtek/rtlwifi/base.h        |  10 +
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       |  32 ++++
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |  31 +++
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.c   |  16 --
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.h   |   5 +-
 drivers/net/wireless/realtek/rtlwifi/cam.c         |   6 +-
 drivers/net/wireless/realtek/rtlwifi/core.c        |  26 ++-
 drivers/net/wireless/realtek/rtlwifi/debug.c       |   4 +-
 drivers/net/wireless/realtek/rtlwifi/debug.h       |  19 +-
 drivers/net/wireless/realtek/rtlwifi/efuse.c       |   5 +-
 drivers/net/wireless/realtek/rtlwifi/efuse.h       |   1 +
 drivers/net/wireless/realtek/rtlwifi/pci.c         |   7 +
 drivers/net/wireless/realtek/rtlwifi/ps.c          |   3 +
 .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.c    |  16 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.h    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/sw.c    |   1 +
 .../net/wireless/realtek/rtlwifi/rtl8192ee/trx.c   |   8 +
 .../net/wireless/realtek/rtlwifi/rtl8723be/fw.c    |  19 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/fw.h    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.c    |  42 +++-
 .../net/wireless/realtek/rtlwifi/rtl8723be/sw.c    |   1 +
 .../net/wireless/realtek/rtlwifi/rtl8723be/trx.c   |   8 +
 .../net/wireless/realtek/rtlwifi/rtl8723be/trx.h   |  12 ++
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.c    |  21 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.h    |   3 +
 .../net/wireless/realtek/rtlwifi/rtl8821ae/sw.c    |   1 +
 .../net/wireless/realtek/rtlwifi/rtl8821ae/trx.c   |   8 +
 .../net/wireless/realtek/rtlwifi/rtl8821ae/trx.h   |  13 ++
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  34 ++++
 30 files changed, 512 insertions(+), 57 deletions(-)

-- 
2.10.2
