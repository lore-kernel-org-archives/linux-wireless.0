Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:38375 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753952AbdIDRvv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Sep 2017 13:51:51 -0400
Received: by mail-oi0-f65.google.com with SMTP id t75so810000oie.5
        for <linux-wireless@vger.kernel.org>; Mon, 04 Sep 2017 10:51:51 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 0/2] rtlwifi: Fixes for antenna selection in rtl8723be
Date: Mon,  4 Sep 2017 12:51:32 -0500
Message-Id: <20170904175134.8331-1-Larry.Finger@lwfinger.net> (sfid-20170904_195214_554867_8F8B8C32)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are some HP laptops that contain only a single antenna, which would
not be a problem except these boxes have a mistake in their EFUSE coding.
The ant_sel module option has been provided to correct for this problem;
however, the current antenna selection code has bugs. The first of these
two patches fix a problem in kernel 4.12, and the second fixes an
additional problem in kernel 4.13.

These patches are intended for kernel 4.14.

Thanks,
Larry

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
Larry Finger (2):
  rtlwifi: btcoexist: Fix breakage of ant_sel for rtl8723be
  rtlwifi: btcoexist: Fix antenna selection code

 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    |  5 ++++-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       | 23 +++++++++++++++-------
 2 files changed, 20 insertions(+), 8 deletions(-)

-- 
2.12.3
