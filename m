Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:36437 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752152AbdEDSrG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 May 2017 14:47:06 -0400
Received: by mail-io0-f196.google.com with SMTP id x86so5673944ioe.3
        for <linux-wireless@vger.kernel.org>; Thu, 04 May 2017 11:47:06 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v2 0/4] rtlwifi: btcoex: Remove all references to BT_AUTO_REPORT_ONLY* parameters
Date: Thu,  4 May 2017 13:46:57 -0500
Message-Id: <20170504184701.16560-1-Larry.Finger@lwfinger.net> (sfid-20170504_204716_874950_0F46FEE1)
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

v2 - Some earlier patches were missed in V1.

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
