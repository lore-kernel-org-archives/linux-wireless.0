Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36066 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750992AbdDCBO3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Apr 2017 21:14:29 -0400
Received: by mail-oi0-f65.google.com with SMTP id b187so17391858oif.3
        for <linux-wireless@vger.kernel.org>; Sun, 02 Apr 2017 18:14:29 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v2 00/12] rtlwifi: btcoex: Improve Bluetooth coexistence
Date: Sun,  2 Apr 2017 20:14:10 -0500
Message-Id: <20170331164742.22374-1-Larry.Finger@lwfinger.net> (sfid-20170403_031433_836682_4C6B28F3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In previous submissions that were rejected, there were attempts to update
the BT coexistence routines. Those patches were essentially too large to
review. This time the changes have been reduced to smaller pieces, and
the documentation has been improved.

All of this material is intended for kernel 4.12.

v2 - Fix build errors from first two patches.

Larry

Yan-Hsuan Chuang (12):
  rtlwifi: btcoex: remove unused functions
  rtlwifi: btcoex: follow linux coding style
  rtlwifi: btcoex: 23b 2ant: add btc8723b2ant_limited_rx to reduce agg size
  rtlwifi: btcoex: 23b 2ant: detect if bt is slave, and modify tdma
  rtlwifi: btcoex: 23b 2ant: monitor wifi counter for allocate tdma time
  rtlwifi: btcoex: 23b 2ant: less sensitive to tx rate penalty
  rtlwifi: btcoex: 23b 2ant: adjust wifi duration for bt a2dp
  rtlwifi: btcoex: 23b 2ant: coex table fine tune
  rtlwifi: btcoex: 23b 2ant: remove redundant bt stack report
  rtlwifi: btcoex: 23b 2ant: finer bt power adjustment
  rtlwifi: btcoex: 23b 2ant: add comments to describe how duration adjusted
  rtlwifi: btcoex: 23b 2ant: new fw use h2c to control GNT_BT

 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.c    | 2468 ++++++++------------
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.h    |   24 +-
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    | 1005 +-------
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 1655 ++++---------
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.h    |   18 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    | 1470 +++++-------
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.h    |    2 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 2306 ++++++------------
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       |    2 +-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |    3 +-
 10 files changed, 2841 insertions(+), 6112 deletions(-)

-- 
2.10.2
