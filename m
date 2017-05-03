Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:35534 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751233AbdECXvF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 May 2017 19:51:05 -0400
Received: by mail-io0-f195.google.com with SMTP id v34so5942375iov.2
        for <linux-wireless@vger.kernel.org>; Wed, 03 May 2017 16:51:04 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 0/4] rtlwifi: btcoex: Remove all references to BT_AUTO_REPORT_ONLY* parameters
Date: Wed,  3 May 2017 18:50:53 -0500
Message-Id: <20170503235057.23211-1-Larry.Finger@lwfinger.net> (sfid-20170504_015116_210975_A14FBD30)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The btcoex code uses #if constructs to compile conditional code. There
is no way to modify this behavior without editting the source. This
logic is converted into regular if statements that interrogate a
boolean variable in a structure known to all routines. The new form
does not provide any mechanism for dynamic changes, but it now is in a
form whereby module parameters could be added to select the behavior
at module load time. In these patches, a number of routines removed
because they were not referenced must be restored.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>

Larry Finger (4):
  rtlwifi: btcoex: Remove 21a 1ant configuration parameter
  rtlwifi: btcoex: Remove 23b 1ant configuration parameter
  rtlwifi: btcoex: Remove 23b 2ant configuration parameter
  rtlwifi: btcoex: Remove 92e 2ant configuration parameter

 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.c    |  72 ++++++++----
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.h    |   1 -
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    | 123 +++++++++++++++++----
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.h    |   2 +-
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    |  84 +++++++++-----
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.h    |   1 -
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    |  18 +--
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.h    |   2 +-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |   5 +
 9 files changed, 229 insertions(+), 79 deletions(-)

-- 
2.12.2
