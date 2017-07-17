Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:32998 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751278AbdGQPKC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 11:10:02 -0400
Received: by mail-oi0-f67.google.com with SMTP id k186so2558257oib.0
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jul 2017 08:10:02 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v2 00/11] Set 4 of changes related to updates of btcoexist
Date: Mon, 17 Jul 2017 10:09:43 -0500
Message-Id: <20170717150954.1441-1-Larry.Finger@lwfinger.net> (sfid-20170717_171007_397038_5FDF0142)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To get maximum benefit of the recent changes in btcoexist, changes need
to be made in the drivers for the NIC. This is set 4 of those changes.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>

v2 - Add the material in commit f95d95a7cd55 ("rtlwifi: btcoex: rtl8723be: fix ant_sel not work"), which was reverted.

Ping-Ke Shih (11):
  rtlwifi: btcoex: Add power_on_setting routine
  rtlwifi: Fix MAX MPDU of VHT capability
  rtlwifi: Remove redundant semicolon in wifi.h.
  rtlwifi: rtl8192ee: Make driver support 64bits DMA.
  rtlwifi: Implement rtl_get_tx_hw_rate to yield correct hw_rate
  rtlwifi: Add rtl_get_hal_edca_param() to generate register's format of
    EDCA.
  rtlwifi: Add TX/RX throughput statistics in period
  rtlwifi: Add RSSI and RF type to wifi.h for phydm
  rtlwifi: Remove BAND_NUM and related fields
  rtlwifi: Add bw_update parameter for RA mask update.
  rtlwifi: Add module parameter ASPM

 drivers/net/wireless/realtek/rtlwifi/base.c        | 100 +++++++++++++--
 drivers/net/wireless/realtek/rtlwifi/base.h        |   4 +
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |   1 +
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.c   |   6 +
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.h   |   1 +
 drivers/net/wireless/realtek/rtlwifi/core.c        |   5 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         |  49 ++++++--
 drivers/net/wireless/realtek/rtlwifi/pci.h         |  10 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/dm.c    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/hw.c    |   7 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/hw.h    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/sw.c    |   6 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/trx.c   |   5 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/trx.h   |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/hw.c    |   6 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/hw.h    |   5 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/sw.c    |   6 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/trx.c   |   5 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/trx.h   |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/hw.c    |   6 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/hw.h    |   2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/fw.c    |   2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/hw.c    |   6 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/hw.h    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/sw.c    |   6 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/trx.c   |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/trx.h   |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/dm.c    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/hw.c    |  40 ++++--
 .../net/wireless/realtek/rtlwifi/rtl8192ee/hw.h    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/sw.c    |   9 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/trx.c   |  49 ++++----
 .../net/wireless/realtek/rtlwifi/rtl8192ee/trx.h   | 140 ++++-----------------
 .../net/wireless/realtek/rtlwifi/rtl8192se/dm.c    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/hw.c    |   6 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/hw.h    |   2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/sw.c    |   8 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/trx.c   |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/trx.h   |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/hw.c    |   7 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/hw.h    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/sw.c    |   6 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/trx.c   |   5 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/trx.h   |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/dm.c    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.c    |   9 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.h    |   2 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/sw.c    |   6 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/trx.c   |   5 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/trx.h   |   3 +-
 .../realtek/rtlwifi/rtl8723com/fw_common.c         |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/dm.c    |   2 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/hw.c    |   9 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/hw.h    |   2 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/sw.c    |   6 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/trx.c   |   5 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/trx.h   |   3 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  60 ++++-----
 58 files changed, 392 insertions(+), 278 deletions(-)

-- 
2.12.3
