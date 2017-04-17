Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34193 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932307AbdDQALQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Apr 2017 20:11:16 -0400
Received: by mail-oi0-f66.google.com with SMTP id t14so15968772oif.1
        for <linux-wireless@vger.kernel.org>; Sun, 16 Apr 2017 17:11:16 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 00/27] rtlwifi: btcoex: Changes for 23b 1ant
Date: Sun, 16 Apr 2017 19:10:44 -0500
Message-Id: <20170417001111.29384-1-Larry.Finger@lwfinger.net> (sfid-20170417_021125_696653_289E92A1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This set of patches updates file btcoexist/halbtc8723b1ant.c for
changes in Bluetooth and wifi performance.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>


Larry Finger (1):
  rtlwifi: btcoex: Restore 23b 1ant routine for tdma adjustment

Ping-Ke Shih (25):
  rtlwifi: btcoex: 23b 1ant: rename and coding style modification.
  rtlwifi: btcoex: 23b 1ant: TDMA duration for ACL busy
  rtlwifi: btcoex: 23b 1ant: monitor wifi and BT counter
  rtlwifi: btcoex: 23b 1ant: check if BT high priority packet exist
  rtlwifi: btcoex: 23b 1ant: monitor bt is enabled or disabled
  rtlwifi: btcoex: 23b 1ant: check PS state before setting tdma duration
  rtlwifi: btcoex: 23b 1ant: Switch antenna to wifi or BT.
  rtlwifi: btcoex: 23b 1ant: need these information when scan
  rtlwifi: btcoex: 23b 1ant: adjust wifi duration for bt a2dp
  rtlwifi: btcoex: 23b 1ant: add wifi_only argument to init_hwconfig
  rtlwifi: btcoex: 23b 1ant: Add power_on_setting
  rtlwifi: btcoex: 23b 1ant: parse more BT information from C2H
  rtlwifi: btcoex: 23b 1ant: Setup register for BT WHCK test
  rtlwifi: btcoex: 23b 1ant: Add rf status notification
  rtlwifi: btcoex: 23b 1ant: fine tune connect notify
  rtlwifi: btcoex: 23b 1ant: Revise media status notify to fix no scan
    result issue
  rtlwifi: btcoex: 23b 1ant: Special packets statistic in notification
  rtlwifi: btcoex: 23b 1ant: define wifi in high priority task.
  rtlwifi: btcoex: 23b 1ant: check more cases when bt is queing
  rtlwifi: btcoex: 23b 1ant: remove verbose log from periodic function
  rtlwifi: btcoex: 23b 1ant: Add coex_table_type to log
  rtlwifi: btcoex: 23b 1ant: coex table fine tune
  rtlwifi: btcoex: 23b 1ant: fine tune for wifi connected
  rtlwifi: btcoex: 23b 1ant: fine tune for wifi not connected
  rtlwifi: btcoex: 23b 1ant: fine tune for bt_sco_hid busy

Yan-Hsuan Chuang (1):
  rtlwifi: btcoex: 23b 1ant: turn off ps and tdma mechanism when
    concurrent mode

 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    | 1981 +++++++++++++++-----
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.h    |   45 +-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |   23 +
 3 files changed, 1573 insertions(+), 476 deletions(-)

-- 
2.12.0
