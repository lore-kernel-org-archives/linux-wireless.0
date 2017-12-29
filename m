Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:52787 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755289AbdL2Ibj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Dec 2017 03:31:39 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <yhchuang@realtek.com>, <Larry.Finger@lwfinger.net>,
        <johannes.berg@intel.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 00/11] rtlwifi: change rtlwifi maintainer and merge commits from staging
Date: Fri, 29 Dec 2017 16:31:01 +0800
Message-ID: <20171229083112.31540-1-pkshih@realtek.com> (sfid-20171229_093323_752378_54328DCB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Hello Kalle,

This patchset contain a patch written by Larry to change maintainer.
Since I'm a newbie maintainer, need your comments on my mistakes in the
future. Second part is the commits existed in staging's rtlwifi, and most
of them fix coding style issues so I merge them to make code consistent.
Finally, I put developing patches in third part.

Part 1: Change maintainer
  MAINTAINERS: Change maintainer for rtlwifi

Part 2: Merge commits from staing's rtlwifi
  The original logs are reserved, if this isn't appropriate, please give me
  comments.

  rtlwifi: check for array overflow
  rtlwifi: fix parenthesis alignment
  rtlwifi: use kcalloc instead of multiply
  rtlwifi: Remove unnecessary 'out of memory' message
  rtlwifi: mark expected switch fall-through in rtl_make_smps_action
  rtlwifi: Remove unnecessary parentheses

Part 3:
  We continue to develop and submit rtl8822be, and it is welcome to give us
  comments on rtlwifi RFC of the new components (ie. phydm and halamc).

  rtlwifi: rtl8723: Add error handling to no existing firmware
  rtlwifi: Improve debugging by using debugfs
  rtlwifi: btcoex: Use seq_file to dump btcoex status
  rtlwifi: fill FW version and subversion

---

Dan Carpenter (1):
  rtlwifi: check for array overflow

Frank A. Cancio Bello (1):
  rtlwifi: Remove unnecessary parentheses

Gustavo A. R. Silva (1):
  rtlwifi: mark expected switch fall-through in rtl_make_smps_action

Larry Finger (1):
  MAINTAINERS: Change maintainer for rtlwifi

Ping-Ke Shih (5):
  rtlwifi: fix parenthesis alignment
  rtlwifi: rtl8723: Add error handling to no existing firmware
  rtlwifi: Improve debugging by using debugfs
  rtlwifi: btcoex: Use seq_file to dump btcoex status
  rtlwifi: fill FW version and subversion

Shreeya Patel (1):
  rtlwifi: Remove unnecessary 'out of memory' message

Tobin C. Harding (1):
  rtlwifi: use kcalloc instead of multiply

 MAINTAINERS                                        |   6 +-
 drivers/net/wireless/realtek/rtlwifi/base.c        |  26 +-
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.c    | 203 ++++-----
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.h    |   3 +-
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    | 269 ++++++------
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.h    |   3 +-
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 206 ++++-----
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.h    |   3 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    | 285 ++++++------
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.h    |   3 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 177 ++++----
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.h    |   3 +-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       | 133 +++++-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |  14 +-
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.c   |   6 +
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.h   |   1 +
 drivers/net/wireless/realtek/rtlwifi/core.c        |  28 +-
 drivers/net/wireless/realtek/rtlwifi/debug.c       | 483 ++++++++++++++++++++-
 drivers/net/wireless/realtek/rtlwifi/debug.h       |  12 +
 drivers/net/wireless/realtek/rtlwifi/efuse.c       |   4 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         |   6 +
 drivers/net/wireless/realtek/rtlwifi/rc.c          |  16 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/fw.c    |   2 +
 .../realtek/rtlwifi/rtl8723com/fw_common.c         |   4 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |   9 +
 25 files changed, 1230 insertions(+), 675 deletions(-)

-- 
2.14.1
