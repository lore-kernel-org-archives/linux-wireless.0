Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:54049 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750853AbeAQGPu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Jan 2018 01:15:50 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <yhchuang@realtek.com>,
        <linux-wireless@vger.kernel.org>
Subject: [PATCH v3 00/10] rtlwifi: fix some bugs and add btcoex functions
Date: Wed, 17 Jan 2018 14:15:20 +0800
Message-ID: <20180117061530.30049-1-pkshih@realtek.com> (sfid-20180117_071614_133743_6657A6A2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Fix some bugs reported by QC, and continue to submit btcoex patches for
further use.

v3:
  * remove the commit that adds sta_statistics op, because Johannes fixes
    it in cfg80211 (Thanks!)
  * for 'typedef' comment, add a commit to resolve old typedef, and remove
    typedef from the commit "rtlwifi: btcoex: Add common function for
    qeurying BT information"

v2:
  * add my sob to commit log if missing, and remove trivial comments.

Larry Finger (1):
  rtlwifi: btcoex: Remove typedef statements

Ping-Ke Shih (7):
  rtlwifi: Use mutex to replace spin_lock to protect IPS and LPS
  rtlwifi: fix scan channel 1 fail after IPS
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
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       | 178 +++++----
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.c   | 234 ++++++++++--
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.h   |   4 +-
 drivers/net/wireless/realtek/rtlwifi/core.c        |  24 ++
 drivers/net/wireless/realtek/rtlwifi/pci.c         |   5 +-
 drivers/net/wireless/realtek/rtlwifi/ps.c          |  29 +-
 drivers/net/wireless/realtek/rtlwifi/usb.c         |   1 -
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  16 +-
 10 files changed, 694 insertions(+), 204 deletions(-)

-- 
2.15.1
