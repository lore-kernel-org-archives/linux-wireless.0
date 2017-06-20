Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:36628 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752475AbdFTAcZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Jun 2017 20:32:25 -0400
Received: by mail-ot0-f196.google.com with SMTP id r67so13317807ota.3
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jun 2017 17:32:25 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 00/10] Set 2 of changes related to updates of btcoexist
Date: Mon, 19 Jun 2017 19:32:08 -0500
Message-Id: <20170620003218.17010-1-Larry.Finger@lwfinger.net> (sfid-20170620_023229_486461_B0ECDAEB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To get maximum benefit of the recent changes in btcoexist, changes need
to be made in the drivers for the NIC. This is set 2 of those changes.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
 

Ping-Ke Shih (10):
  rtlwifi: Fix a2dp choppy while BT RSSI stays on threshold.
  rtlwifi: Do IQK only once to reduce wifi occupy antenna
  rtlwifi: Modify power mode parameters of 8723be and 8821ae.
  rtlwifi: Update some cases in btc_get function -- roam, 5G, AP mode,
    and return value.
  rtlwifi: Add return value to btc_set.
  rtlwifi: Add ap_num field for btcoexist
  rtlwifi: Fill ap_num filed by vendor command
  rtlwifi: Fill ap_num field by driver
  rtlwifi: Add in_4way field for btcoexist
  rtlwifi: Fill in_4way field by vendor command

 drivers/net/wireless/realtek/rtlwifi/base.c        | 194 +++++++++++++++++++++
 drivers/net/wireless/realtek/rtlwifi/base.h        |   2 +
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       |  36 ++--
 drivers/net/wireless/realtek/rtlwifi/core.c        |   3 +
 drivers/net/wireless/realtek/rtlwifi/debug.h       |   1 +
 drivers/net/wireless/realtek/rtlwifi/pci.c         |   4 +
 drivers/net/wireless/realtek/rtlwifi/ps.c          |  14 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.c    |  10 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/hw.c    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/fw.c    |   8 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.c    |   7 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/phy.c   |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/sw.c    |   4 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.c    |  10 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/sw.c    |   4 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  16 ++
 16 files changed, 285 insertions(+), 34 deletions(-)

-- 
2.12.3
