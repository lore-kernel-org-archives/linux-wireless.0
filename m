Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35013 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753093AbdHJQrt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Aug 2017 12:47:49 -0400
Received: by mail-oi0-f67.google.com with SMTP id q70so1117867oic.2
        for <linux-wireless@vger.kernel.org>; Thu, 10 Aug 2017 09:47:49 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v2 0/2] rtlwifi: btcoex: Improve debugging system
Date: Thu, 10 Aug 2017 11:47:42 -0500
Message-Id: <20170810164744.9336-1-Larry.Finger@lwfinger.net> (sfid-20170810_184753_868805_4BCB26D0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Resubmit the two patches to the debugging system that were rejected
earlier. V2 includes fixes for the reviewers comments.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>

Ping-Ke Shih (2):
  rtlwifi: use debugfs to debug.
  rtlwifi: btcoex: Use seq_file to dump btcoex status

 drivers/net/wireless/realtek/rtlwifi/base.c        |   6 +
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.c    | 203 +++++-----
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.h    |   3 +-
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    | 269 ++++++-------
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.h    |   3 +-
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 206 +++++-----
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.h    |   3 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    | 285 ++++++-------
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.h    |   3 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 177 ++++-----
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.h    |   3 +-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       | 133 ++++++-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |  14 +-
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.c   |   6 +
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.h   |   1 +
 drivers/net/wireless/realtek/rtlwifi/debug.c       | 439 +++++++++++++++++++++
 drivers/net/wireless/realtek/rtlwifi/debug.h       |  12 +
 drivers/net/wireless/realtek/rtlwifi/pci.c         |   6 +
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |   9 +
 19 files changed, 1147 insertions(+), 634 deletions(-)

-- 
2.12.3
