Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33243 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752776AbdF1PMf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 11:12:35 -0400
Received: by mail-oi0-f68.google.com with SMTP id l83so5758457oif.0
        for <linux-wireless@vger.kernel.org>; Wed, 28 Jun 2017 08:12:35 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH v3 00/10] Set 3 of changes related to updates of btcoexist
Date: Wed, 28 Jun 2017 10:12:15 -0500
Message-Id: <20170628151225.22190-1-Larry.Finger@lwfinger.net> (sfid-20170628_171310_704178_2D3A7E2A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To get maximum benefit of the recent changes in btcoexist, changes need
to be made in the drivers for the NIC. This is set 3 of those changes.

v2 - remove \r characters as suggested by Joe Perches
v3 - remove those \r characters missed in v2

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
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.c    | 202 +++++-----
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
 31 files changed, 1588 insertions(+), 974 deletions(-)

-- 
2.12.3
