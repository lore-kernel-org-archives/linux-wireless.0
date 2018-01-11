Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:60542 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932102AbeAKHKA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Jan 2018 02:10:00 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <yhchuang@realtek.com>,
        <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 00/10] rtlwifi: fix some bugs and add btcoex functions
Date: Thu, 11 Jan 2018 15:09:22 +0800
Message-ID: <20180111070932.9929-1-pkshih@realtek.com> (sfid-20180111_081021_561081_B53FFEEE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Fix some bugs reported by QC, and continue to submit btcoex patches for
further use.

v2: add my sob to commit log if missing, and remove trivial comments.

Ping-Ke Shih (8):
  rtlwifi: Use mutex to replace spin_lock to protect IPS and LPS
  rtlwifi: fix scan channel 1 fail after IPS
  rtlwifi: Add sta_statistics of mac80211's op, and set filled=0 by
    default
  rtlwifi: enable mac80211 fast-tx support
  rtlwifi: btcoex: Add power_on_setting routine
  rtlwifi: btcoex: Remove global variables from btcoex
  rtlwifi: btcoex: Add common function for qeurying BT information
  rtlwifi: btcoex: add rfe_type parameter to btcoex

Steven Ting (1):
  rtlwifi: Support A-MSDU in A-MPDU capability

Tsang-Shian Lin (1):
  rtlwifi: unlink bss when un-association

 drivers/net/wireless/realtek/rtlwifi/base.c        |   9 +-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       | 398 +++++++++++++++++----
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |  94 ++++-
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.c   | 234 ++++++++++--
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.h   |   4 +-
 drivers/net/wireless/realtek/rtlwifi/core.c        |  34 ++
 drivers/net/wireless/realtek/rtlwifi/pci.c         |   5 +-
 drivers/net/wireless/realtek/rtlwifi/ps.c          |  30 +-
 drivers/net/wireless/realtek/rtlwifi/usb.c         |   1 -
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  16 +-
 10 files changed, 688 insertions(+), 137 deletions(-)

-- 
2.15.1
