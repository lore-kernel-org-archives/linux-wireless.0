Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:38490 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752654AbeCFB0L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Mar 2018 20:26:11 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 00/15] rtlwifi: Add 8822b 1ant/2ant btcoex files
Date: Tue, 6 Mar 2018 09:25:39 +0800
Message-ID: <20180306012554.3108-1-pkshih@realtek.com> (sfid-20180306_022639_013343_896A42B9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

This patchset mainly contains 8822b 1ant/2ant btcoex files and related
materials, and patch 1/15 and 2/15 fix the issues reported by static checker.
After this patchset, I will start to submit the new component halmac that
contains many new files, so the patch will be little big.

v2: Don't change content of patch, but only comment log.
    - fix typo in patch 3/15.
    - Add Acked-by to patches 1/15, 2/15, 4/15

Ping-Ke Shih (15):
  rtlwifi: Add modifier static to functions reported by sparse
  rtlwifi: remove redundant statement found by static checker
  rtlwifi: btcoex: Add enum DM_INFO for btcoex to query dm's counters
  rtlwifi: btcoex: Add customer_id to do special deal to oem vendor
  rtlwifi: btcoex: Get status of multichannel concurrence
  rtlwifi: btcoex: Add rate table for the use of btcoex
  rtlwifi: btcoex: Add interaction with phydm
  rtlwifi: btcoex: Add pre- and post- normal LPS function
  rtlwifi: btcoex: add assoc type v2 to connection notify
  rtlwifi: btcoex: new definitions introduced by 8822be
  rtlwifi: btcoex: Add new but dummy definitions introduced by 8822b
  rtlwifi: btcoex: Add 8822b 1ant/2ant coex files
  rtlwifi: btcoex: Add 8822b header files to precomp.h
  rtlwifi: btcoex: Add 8822b to Makefile
  rtlwifi: btcoex: Add 8822b routine to btc interfaces

 drivers/net/wireless/realtek/rtlwifi/base.c        |    1 -
 .../wireless/realtek/rtlwifi/btcoexist/Makefile    |    3 +
 .../realtek/rtlwifi/btcoexist/halbt_precomp.h      |    3 +
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    |    1 +
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    |    6 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    |   33 -
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    |    4 +-
 .../realtek/rtlwifi/btcoexist/halbtc8822b1ant.c    | 5327 +++++++++++++++++++
 .../realtek/rtlwifi/btcoexist/halbtc8822b1ant.h    |  413 ++
 .../realtek/rtlwifi/btcoexist/halbtc8822b2ant.c    | 5370 ++++++++++++++++++++
 .../realtek/rtlwifi/btcoexist/halbtc8822b2ant.h    |  434 ++
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       |  186 +-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |  122 +
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |   33 +
 14 files changed, 11894 insertions(+), 42 deletions(-)
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822b1ant.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822b1ant.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822b2ant.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822b2ant.h

-- 
2.15.1
