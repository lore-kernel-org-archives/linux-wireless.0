Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34355 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752153AbdDMSHQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 14:07:16 -0400
Received: by mail-oi0-f65.google.com with SMTP id t14so4184153oif.1
        for <linux-wireless@vger.kernel.org>; Thu, 13 Apr 2017 11:07:16 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 00/19] rtlwifi: btcoex: First set of changes for rtl8821ae 2ant
Date: Thu, 13 Apr 2017 13:06:51 -0500
Message-Id: <20170413180710.19953-1-Larry.Finger@lwfinger.net> (sfid-20170413_200759_593711_929B2F27)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches are the first set of patches for file
btcoexist/halbtc8821a2ant.c.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>

Yan-Hsuan Chuang (19):
  rtlwifi: btcoex: 21a 2ant: limit rx aggregation size to avoid bt
    interrupt
  rtlwifi: btcoex: 21a 2ant: monitor if bt is slave or not
  rtlwifi: btcoex: 21a 2ant: monitor wifi counter to check network
    status
  rtlwifi: btcoex: 21a 2ant: update bt profiling information
  rtlwifi: btcoex: 21a 2ant: finer adjustment of bt power
  rtlwifi: btcoex: 21a 2ant: move from bt_stack_info to bt_link_info
  rtlwifi: btcoex: 21a 2ant: suffer less tx penalty from retry
  rtlwifi: btcoex: 21a 2ant: check power save state before pstdma
  rtlwifi: btcoex: 21a 2ant: do not check wifi bandwidth
  rtlwifi: btcoex: 21a 2ant: centralized control of coex table
  rtlwifi: btcoex: 21a 2ant: check if wifi status changed
  rtlwifi: btcoex: 21a 2ant: ignore wifi if it is at 5G band
  rtlwifi: btcoex: 21a 2ant: set coex table and tdma when bt inquiry
  rtlwifi: btcoex: 21a 2ant: let PTA circuit control the switch
  rtlwifi: btcoex: 21a 2ant: slot time fine tune
  rtlwifi: btcoex: 21a 2ant: tdma cases for low wifi/bt rssi
  rtlwifi: btcoex: 21a 2ant: action for wifi is idle/linking/common
  rtlwifi: btcoex: 21a 2ant: fix invalid argument passed
  rtlwifi: btcoex: 21a 2ant: refine tdma duration adjust function

 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 1982 ++++++++++++++++----
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.h    |   29 +-
 2 files changed, 1663 insertions(+), 348 deletions(-)

-- 
2.12.0
