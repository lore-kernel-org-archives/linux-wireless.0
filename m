Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:35843 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751116AbdFURPo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Jun 2017 13:15:44 -0400
Received: by mail-ot0-f193.google.com with SMTP id r67so20191588ota.3
        for <linux-wireless@vger.kernel.org>; Wed, 21 Jun 2017 10:15:44 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v2 0/8] Set 2 of changes related to updates of btcoexist
Date: Wed, 21 Jun 2017 12:15:30 -0500
Message-Id: <20170621171538.4462-1-Larry.Finger@lwfinger.net> (sfid-20170621_191549_474559_03EE5DE5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To get maximum benefit of the recent changes in btcoexist, changes need
to be made in the drivers for the NIC. This is set 2 of those changes.

V2 - Two two patches that added vendor commands have been dropped from
     this submission as requested. They will be addressed later.

Larry
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>

 Ping-Ke Shih (8):
  rtlwifi: Fix a2dp choppy while BT RSSI stays on threshold.
  rtlwifi: Do IQK only once to reduce wifi occupy antenna
  rtlwifi: Modify power mode parameters of 8723be and 8821ae.
  rtlwifi: Update some cases in btc_get function -- roam, 5G, AP mode,
    and return value.
  rtlwifi: Add return value to btc_set.
  rtlwifi: Add ap_num field for btcoexist
  rtlwifi: Fill ap_num field by driver
  rtlwifi: Add in_4way field for btcoexist

 drivers/net/wireless/realtek/rtlwifi/base.c        | 102 +++++++++++++++++++++
 drivers/net/wireless/realtek/rtlwifi/base.h        |   2 +
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       |  36 +++++---
 drivers/net/wireless/realtek/rtlwifi/core.c        |   3 +
 drivers/net/wireless/realtek/rtlwifi/pci.c         |   4 +
 drivers/net/wireless/realtek/rtlwifi/ps.c          |  14 +--
 .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.c    |  10 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/hw.c    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/fw.c    |   8 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.c    |   7 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/phy.c   |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/sw.c    |   4 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.c    |  10 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/sw.c    |   4 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  16 ++++
 15 files changed, 192 insertions(+), 34 deletions(-)

-- 
2.12.3
