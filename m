Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:38824 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750727AbdGUEYt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Jul 2017 00:24:49 -0400
Received: by mail-oi0-f65.google.com with SMTP id p188so3925732oia.5
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jul 2017 21:24:49 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 00/10] rtlwifi: Set 1 of changes to prepare for RTL8822BE
Date: Thu, 20 Jul 2017 23:24:30 -0500
Message-Id: <20170721042440.15839-1-Larry.Finger@lwfinger.net> (sfid-20170721_062515_262133_B5154E54)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are many changes needed to prepare rtlwifi and family for the
addition of drivers for the new RTL8822BE. This is the first set of
patches that implement these changes.

These patches follow the following sets:
[PATCH v4 00/10] Set 3 of changes related to updates of btcoexist
[PATCH 0/2] rtlwifi: Fix two static errors
[PATCH] Revert "rtlwifi: btcoex: rtl8723be: fix ant_sel not work"
[PATCH v2 00/11] Set 4 of changes related to updates of btcoexist

Larry

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>

Ping-Ke Shih (10):
  rtlwifi: Add COMP_HALMAC to debug
  rtlwifi: define radio_mask for RF, and extend bw
  rtlwifi: Add phydm structure to main header file
  rtlwifi: Issue connection notification to phydm.
  rtlwifi: Add COMP_PHYDM to debug
  rtlwifi: btcoex: Add send_bt_mp common function, and modify related
    functions.
  rtlwifi: btcoex: btcoexist needs rfe_type to make decision
  rtlwifi: Use mutex to replace spin_lock in cases of IPS and LPS
  rtlwifi: Add halmac structure to wifi.h
  rtlwifi: Add phydm debug cmd to debugfs

 drivers/net/wireless/realtek/rtlwifi/base.c        |   6 +-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       | 238 ++++++++++++++++++---
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |  51 +++++
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.c   |  29 ++-
 drivers/net/wireless/realtek/rtlwifi/core.c        |  13 ++
 drivers/net/wireless/realtek/rtlwifi/debug.c       |  77 +++++++
 drivers/net/wireless/realtek/rtlwifi/debug.h       |   2 +
 drivers/net/wireless/realtek/rtlwifi/ps.c          |  26 ++-
 drivers/net/wireless/realtek/rtlwifi/usb.c         |   1 -
 drivers/net/wireless/realtek/rtlwifi/wifi.h        | 219 ++++++++++++++++++-
 10 files changed, 601 insertions(+), 61 deletions(-)

-- 
2.12.3
