Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:57291 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750813AbeA2D06 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 28 Jan 2018 22:26:58 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 00/10] rtlwifi: add more materials for 8822be
Date: Mon, 29 Jan 2018 11:26:31 +0800
Message-ID: <20180129032641.17841-1-pkshih@realtek.com> (sfid-20180129_042702_546546_F8C22D0A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

I continue to submit more materials needed by 8822be. A special patch is
"PATCH 10/10" that add new files to support 8822be btcoex in case wifi
only. In my plan, 8822be btcoex for combo card will be sumitted in next
patchset.

v2: Add 'Acked-by: Larry Finger' if the commits are acked
    Use 'switch...case' to replace verbose 'if...else if...else if...else'
    Use extern declaration to quiet sparse warnings

Ping-Ke Shih (10):
  rtlwifi: enable mac80211 fast-tx support
  rtlwifi: Add Support VHT to spec_ver
  rtlwifi: Use 6 bits as sequence number of TX report
  rtlwifi: Extend tx_power_by_rate_offset size for newer IC
  rtlwifi: Add rate section and its related definition and comment
  rtlwifi: Fix VHT NSS in RC
  rtlwifi: add definition radio_mask for RF and maximum bandwidth
  rtlwifi: add efuse ops for other components
  rtlwifi: btcoex: add routine to set default port id
  rtlwifi: btcoex: Add 8822be btcoex supported files for wifi only

 drivers/net/wireless/realtek/rtlwifi/base.c        | 34 ++++++++++---
 .../rtlwifi/btcoexist/halbtc8822bwifionly.c        | 55 ++++++++++++++++++++++
 .../rtlwifi/btcoexist/halbtc8822bwifionly.h        | 25 ++++++++++
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       | 22 +++++++++
 drivers/net/wireless/realtek/rtlwifi/efuse.c       | 13 +++++
 drivers/net/wireless/realtek/rtlwifi/efuse.h       |  2 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         |  1 +
 drivers/net/wireless/realtek/rtlwifi/rc.c          | 49 +++++++++++++++----
 .../net/wireless/realtek/rtlwifi/rtl8821ae/sw.c    |  1 +
 drivers/net/wireless/realtek/rtlwifi/wifi.h        | 39 +++++++++++++--
 10 files changed, 221 insertions(+), 20 deletions(-)
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822bwifionly.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822bwifionly.h

-- 
2.15.1
