Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35146 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751789AbdBGDaT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Feb 2017 22:30:19 -0500
Received: by mail-oi0-f66.google.com with SMTP id x84so7947392oix.2
        for <linux-wireless@vger.kernel.org>; Mon, 06 Feb 2017 19:30:18 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 00/11 V4] rtlwifi: Various updates
Date: Mon,  6 Feb 2017 21:29:57 -0600
Message-Id: <20170120212716.29887-1-Larry.Finger@lwfinger.net> (sfid-20170207_043023_334414_A1394F03)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These 11 changes fix a number of deficiencies. None of them are
serious enough to be pushed to stable; however they help in the
stability of the drivers, and in the robustness of authentication/
association.

This material should be sent to the 4.11 stream.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
---

V2 - Fix Kalle's comment about unended loops. It now runs a maximum of 200 times.
V3 - Fix "WARNING: possible condition with no effect (if == else)" found by Test Robot
V4 - No chenges -resubmitting as requested by Kalle.
---
Larry Finger (1):
  rtlwifi: btcoexist: Change logging in halbtc8192e2ant.c

Ping-Ke Shih (10):
  rtlwifi: Fix programing CAM content sequence.
  rtlwifi: Set retry limit depends on vif type.
  rtlwifi: Add a new enumeration value to btc_set_type
  rtlwifi: btcoexist: Add vendor definition for new btcoexist
  rtlwifi: rtl8723be: btcoexist: Add single_ant_path
  rtlwifi: move btcoex's ant_num declaration
  rtlwifi: rtl8723be: btcoex: add package_type function to btcoex
  rtlwifi: btcoex: move bt_type declaration
  rtlwifi: rtl8723be: fix ant_sel code
  rtlwifi: Add work queue for c2h cmd.

 drivers/net/wireless/realtek/rtlwifi/base.c        |  92 +++
 drivers/net/wireless/realtek/rtlwifi/base.h        |   3 +
 .../wireless/realtek/rtlwifi/btcoexist/Makefile    |   1 +
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.c    | 825 +++++++++++----------
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       |  32 +
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |   8 +
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.c   |  16 -
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.h   |   5 +-
 drivers/net/wireless/realtek/rtlwifi/cam.c         |   6 +-
 drivers/net/wireless/realtek/rtlwifi/core.c        |  21 +-
 drivers/net/wireless/realtek/rtlwifi/efuse.c       |   5 +-
 drivers/net/wireless/realtek/rtlwifi/efuse.h       |   1 +
 drivers/net/wireless/realtek/rtlwifi/pci.c         |   7 +
 drivers/net/wireless/realtek/rtlwifi/ps.c          |   3 +
 .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.c    |  15 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.h    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/sw.c    |   1 +
 .../net/wireless/realtek/rtlwifi/rtl8723be/fw.c    |  18 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/fw.h    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.c    |  42 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/sw.c    |   1 +
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.c    |  18 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.h    |   3 +
 .../net/wireless/realtek/rtlwifi/rtl8821ae/sw.c    |   1 +
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  24 +
 25 files changed, 705 insertions(+), 449 deletions(-)

-- 
2.10.2
