Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35952 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754144AbdFXBxP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Jun 2017 21:53:15 -0400
Received: by mail-oi0-f66.google.com with SMTP id p66so4919585oia.3
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jun 2017 18:53:14 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 00/10] Set 3 of changes related to updates of btcoexist
Date: Fri, 23 Jun 2017 20:52:59 -0500
Message-Id: <20170624015309.28099-1-Larry.Finger@lwfinger.net> (sfid-20170624_035319_521121_0398D02A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To get maximum benefit of the recent changes in btcoexist, changes need
to be made in the drivers for the NIC. This is set 3 of those changes.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>

Ping-Ke Shih (10):
  rtlwifi: Fill in_4way field by driver
  rtlwifi: Add BT_MP_INFO to c2h handler.
  rtlwifi: Add board type for 8723be and 8192ee
  rtlwifi: add amplifier type for 8812ae
  rtlwifi: Update 8723be new phy parameters and its parser.
  rtlwifi: Rename rtl_desc92_rate to rtl_desc_rate
  rtlwifi: Uses addr1 instead DA to determine broadcast and multicast
    addr.
  rtlwifi: move IS_HARDWARE_TYPE_xxx checker to wifi.h
  rtlwifi: use debugfs to debug.
  rtlwifi: btcoex: Use seq_file to dump btcoex status

 drivers/net/wireless/realtek/rtlwifi/base.c        |  21 +-
 .../realtek/rtlwifi/btcoexist/halbt_precomp.h      |  16 -
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.c    | 203 +++++-----
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.h    |   3 +-
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    | 269 ++++++-------
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.h    |   3 +-
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 206 +++++-----
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.h    |   3 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    | 285 ++++++-------
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.h    |   3 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 177 ++++-----
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.h    |   3 +-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       | 150 ++++++-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |  14 +-
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.c   |  34 ++
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.h   |   2 +
 drivers/net/wireless/realtek/rtlwifi/core.c        |   2 +
 drivers/net/wireless/realtek/rtlwifi/debug.c       | 439 +++++++++++++++++++++
 drivers/net/wireless/realtek/rtlwifi/debug.h       |  12 +
 drivers/net/wireless/realtek/rtlwifi/pci.c         |   6 +
 .../net/wireless/realtek/rtlwifi/rtl8192cu/mac.c   |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.c    |   9 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/hw.c    |   5 +
 .../net/wireless/realtek/rtlwifi/rtl8723be/fw.c    |   9 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.c    |   7 +
 .../net/wireless/realtek/rtlwifi/rtl8723be/phy.c   | 365 ++++++++---------
 .../net/wireless/realtek/rtlwifi/rtl8723be/table.c | 192 +++++----
 .../net/wireless/realtek/rtlwifi/rtl8723be/table.h |  10 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.c    |  13 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/hw.c    |  41 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  58 +--
 31 files changed, 1589 insertions(+), 974 deletions(-)

-- 
2.12.3
