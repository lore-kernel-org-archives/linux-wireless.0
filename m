Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:44448 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751038AbdLIRhQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Dec 2017 12:37:16 -0500
Received: by mail-ot0-f193.google.com with SMTP id d27so11606657ote.11
        for <linux-wireless@vger.kernel.org>; Sat, 09 Dec 2017 09:37:16 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 0/3] rtlwifi: rtl_pci: More updates to mini driver for RTL8822BE
Date: Sat,  9 Dec 2017 11:37:07 -0600
Message-Id: <20171209173710.9879-1-Larry.Finger@lwfinger.net> (sfid-20171209_183720_599979_307CE1C1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These changes are for the 4.16 stream.

The modifications implement nearly all the changes needed to allow the
RTL8822BE in staging to use rtl_pci in the wireless tree. The only
exceptions are related to BT coexistence, which will be added once btcoex
is updated.

Once these patches reach mainline, I will submit a patch to staging that
changes r8822be to use the standard rtl_pci, and deletes the duplicated
code.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>

Ping-Ke Shih (1):
  rtlwifi: rtl_pci: 8822BE puts broadcast and multicast packet to HIQ

Tsang-Shian Lin (2):
  rtlwifi: Add beacon check mechanism to check if AP settings changed.
  rtlwifi: rtl_pci: Fix the bug when inactiveps is enabled.

 drivers/net/wireless/realtek/rtlwifi/base.c | 179 ++++++++++++++++++++++++++++
 drivers/net/wireless/realtek/rtlwifi/base.h |   3 +-
 drivers/net/wireless/realtek/rtlwifi/core.c |  48 ++++++++
 drivers/net/wireless/realtek/rtlwifi/pci.c  |  17 +++
 drivers/net/wireless/realtek/rtlwifi/wifi.h |  13 ++
 5 files changed, 259 insertions(+), 1 deletion(-)

-- 
2.15.1
