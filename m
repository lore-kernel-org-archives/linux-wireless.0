Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:34611 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750970AbdEPNUC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 May 2017 09:20:02 -0400
Received: by mail-oi0-f68.google.com with SMTP id w10so3308911oif.1
        for <linux-wireless@vger.kernel.org>; Tue, 16 May 2017 06:20:01 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 00/10] rtlwifi: btcoex: More changes to Bluetooth Coexistence
Date: Tue, 16 May 2017 08:19:47 -0500
Message-Id: <20170516131957.9513-1-Larry.Finger@lwfinger.net> (sfid-20170516_152006_902899_EB52CD60)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This set of patches complete the updates for the 8821a 1ant code and
starts the updates for 8723b 1ant.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Pkshih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>

Larry Finger (1):
  rtlwifi: btcoex: Restore 23b 1ant routine for tdma adjustment

Ping-Ke Shih (6):
  rtlwifi: btcoex: 23b 1ant: rename and coding style modification.
  rtlwifi: btcoex: 23b 1ant: TDMA duration for ACL busy
  rtlwifi: btcoex: 23b 1ant: monitor wifi and BT counter
  rtlwifi: btcoex: 23b 1ant: check if BT high priority packet exist
  rtlwifi: btcoex: 23b 1ant: monitor bt is enabled or disabled
  rtlwifi: btcoex: 23b 1ant: check PS state before setting tdma duration

Yan-Hsuan Chuang (3):
  rtlwifi: btcoex: 21a 1ant: treat ARP as special packet
  rtlwifi: btcoex: 21a 1ant: fix some coding style issues
  rtlwifi: btcoex: 21a 1ant: add bt_tx_rx_mask into bt info

 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    | 422 ++++++++++++++++++---
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.h    |  19 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    |  77 +++-
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.h    |   2 +
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |   1 +
 5 files changed, 456 insertions(+), 65 deletions(-)

-- 
2.12.0
