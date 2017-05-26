Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35483 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754119AbdEZSlz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 May 2017 14:41:55 -0400
Received: by mail-oi0-f65.google.com with SMTP id v80so2985665oie.2
        for <linux-wireless@vger.kernel.org>; Fri, 26 May 2017 11:41:55 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH v2 0/7] rtlwifi: btcoex: Final round of fixes
Date: Fri, 26 May 2017 13:41:40 -0500
Message-Id: <20170526184147.31239-1-Larry.Finger@lwfinger.net> (sfid-20170526_204331_218718_C4471FD4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These 7 patches finish this round of fixes for the various components
of btcoex.

In v2 of these patches, two problems noted by the kbuild test robot are
corrected.

Larry

Larry Finger (4):
  rtlwifi: btcoex: Remove duplicate test in if statement
  rtlwifi: btcoex: Fix Sparse messages for undeclared symbols
  rtlwifi: btcoex: Fix logic error in 21a 1ant
  rtlwifi: btcoex: Fix another edit mistake in 21a 1ant

Yan-Hsuan Chuang (3):
  rtlwifi: btcoex: update new btcoex version
  rtlwifi: btcoex: fix compiler warnings for unused functions
  rtlwifi: btcoex: bind bt to the adapter when initialization

 .../realtek/rtlwifi/btcoexist/halbt_precomp.h      |  22 +
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.c    |   2 +-
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.h    |  32 +-
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    |  55 +-
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.h    |  41 +-
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    |   1 +
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.h    |   3 +
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    |  62 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.h    |  38 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    |   3 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.h    |  26 +-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       | 764 +++++++++++++++------
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |  43 +-
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.c   |  36 +-
 14 files changed, 748 insertions(+), 380 deletions(-)

-- 
2.12.0
