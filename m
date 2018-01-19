Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:39518 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751480AbeASGqT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Jan 2018 01:46:19 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 00/10] rtlwifi: add btcoex materials for 8822be
Date: Fri, 19 Jan 2018 14:45:41 +0800
Message-ID: <20180119064551.10084-1-pkshih@realtek.com> (sfid-20180119_074624_851302_EB26303B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

In order to support rtl8822be, btcoex needs more information to control
rtl8822be, and common code needs to add more materials as well.

Ping-Ke Shih (10):
  rtlwifi: btcoex: extend get_wifi_bw to support bandwidth 80M
  rtlwifi: btcoex: Add switch band notify for btc
  rtlwifi: btcoex: Add variable ant_div_cfg to support antenna diversity
  rtlwifi: btcoex: add scan_notify within ips_notify if RFON
  rtlwifi: btcoex: Add wifi_only series ops to control solo card
  rtlwifi: btcoex: add boolean variables dbg_mode
  rtlwifi: btcoex: Fix some static warnings from Sparse
  rtlwifi: 8822be has to report vht capability to mac80211
  rtlwifi: Add ratr_table for newer IC
  rtlwifi: Add spec_ver to check whether use new rate-id or not

 drivers/net/wireless/realtek/rtlwifi/base.c        | 129 ++++++++++++++++++--
 drivers/net/wireless/realtek/rtlwifi/base.h        |   2 +
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       | 135 ++++++++++++++-------
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |  64 ++++++++++
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.c   |  89 +++++++++++++-
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.h   |   7 ++
 drivers/net/wireless/realtek/rtlwifi/core.c        |   6 +
 drivers/net/wireless/realtek/rtlwifi/pci.c         |   8 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  32 +++++
 9 files changed, 409 insertions(+), 63 deletions(-)

-- 
2.15.1
