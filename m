Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35437 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932072AbdDDQuM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Apr 2017 12:50:12 -0400
Received: by mail-oi0-f67.google.com with SMTP id d2so18371711oig.2
        for <linux-wireless@vger.kernel.org>; Tue, 04 Apr 2017 09:50:12 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 00/13] rtlwifi: btcoex: More improvements to Bluetooth Coexistence for 23b
Date: Tue,  4 Apr 2017 11:49:53 -0500
Message-Id: <20170404165006.14329-1-Larry.Finger@lwfinger.net> (sfid-20170404_185016_181025_618BC897)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This set of patches, which should be applied after the 12 patches submitted
with cover title "rtlwifi: btcoex: Improve Bluetooth coexistence", offers
more updates to driver btcoex for the RTL8723BE device.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>

Yan-Hsuan Chuang (13):
  rtlwifi: btcoex: 23b 2ant: check PS state before setting tdma duration
  rtlwifi: btcoex: 23b 2ant: rename tdma_adj_type to ps_tdma_du_adj_type
  rtlwifi: btcoex: 23b 2ant: detect ap num and set GNT_BT properly
  rtlwifi: btcoex: 23b 2ant: more cases for adjusting tdma duration
  rtlwifi: btcoex: 23b 2ant: fix PTA unstable problem when hw init
  rtlwifi: btcoex: 23b 2ant: add pnp notidy to avoid LPS/IPS mismatch
  rtlwifi: btcoex: 23b 2ant: check more cases when bt is quering
  rtlwifi: btcoex: 23b 2ant: workaround for bt a2dp and hid
  rtlwifi: btcoex: 23b 2ant: tell fw external or internal switch is
    equipped
  rtlwifi: btcoex: 23b 2ant: let bt transmit when hw initialisation
  rtlwifi: btcoex: 23b 2ant: turn off ps and tdma mechanism when in
    concurrent mode
  rtlwifi: btcoex: 23b 2ant: turn off antenna when rssi is too high/low
  rtlwifi: btcoex: 23b 2ant: set coex table when wifi is linking

 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 1467 ++++++++++++++++++--
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.h    |   18 +-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |    1 +
 3 files changed, 1362 insertions(+), 124 deletions(-)

-- 
2.10.2
