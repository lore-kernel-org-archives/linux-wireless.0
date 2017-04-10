Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36537 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752805AbdDJQXP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Apr 2017 12:23:15 -0400
Received: by mail-oi0-f66.google.com with SMTP id b187so23324623oif.3
        for <linux-wireless@vger.kernel.org>; Mon, 10 Apr 2017 09:23:15 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 00/14] rtlwifi: btcoex: Fixes for rtl8821ae 1ant code
Date: Mon, 10 Apr 2017 11:22:56 -0500
Message-Id: <20170410162310.7515-1-Larry.Finger@lwfinger.net> (sfid-20170410_182324_217917_96B805DE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches update the BT coexistence routines for the RTL8821AE 1ant
routines.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>


Yan-Hsuan Chuang (14):
  rtlwifi: btcoex: 21a 1ant: fw settings for softap mode
  rtlwifi: btcoex: 21a 1ant: add function to check wifi status
  rtlwifi: btcoex: 21a 1ant: coex table setting for new fw
  rtlwifi: btcoex: 21a 1ant: mask profile bit for connect-ilde
  rtlwifi: btcoex: 21a 1ant: remove setting for 2 antennas
  rtlwifi: btcoex: 21a 1ant: set antenna control path for PTA
  rtlwifi: btcoex: 21a 1ant: add multi port action for miracast and P2P
  rtlwifi: btcoex: 21a 1ant: action when associating/authenticating
  rtlwifi: btcoex: 21a 1ant: If wifi only, do not initiate coex
    mechanism
  rtlwifi: btcoex: 21a 1ant: move bt_disabled to global struct
  rtlwifi: btcoex: 21a 1ant: consider more cases when bt inquiry
  rtlwifi: btcoex: 21a 1ant: monitor bt profiling when scan
  rtlwifi: btcoex: 21a 1ant: do not switch antenna when wifi is under 5G
    channel
  rtlwifi: btcoex: 21a 1ant: avoid LPS/IPS mismatch for pnp notify

 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    | 408 ++++++++++++++++++---
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.h    |   2 +
 2 files changed, 351 insertions(+), 59 deletions(-)

-- 
2.12.0
