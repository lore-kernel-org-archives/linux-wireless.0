Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:45346 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751738AbdKAP3b (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Nov 2017 11:29:31 -0400
Received: by mail-oi0-f67.google.com with SMTP id f66so5041592oib.2
        for <linux-wireless@vger.kernel.org>; Wed, 01 Nov 2017 08:29:31 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 00/11] rtlwifi: rtl_pci: Update mini driver for RTL8822BE
Date: Wed,  1 Nov 2017 10:29:15 -0500
Message-Id: <20171101152926.24971-1-Larry.Finger@lwfinger.net> (sfid-20171101_162936_003846_38FFD505)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These changes are for the 4.15 stream.

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

Larry Finger (3):
  rtlwifi: rtl_pci: Fix formatting errors in pci.h
  rtlwifi: rtl_pci: Fix formatting problems in pci.c
  rtlwifi: rtl_pci: Simplify some code be eliminating extraneous
    variables

Ping-Ke Shih (5):
  rtlwifi: rtl_pci: Add support for 8822be TX/RX BD
  rtlwifi: rtl_pci: Add fill_tx_special_desc to issue H2C data, and
    process TXOK in interrupt.
  rtlwifi: rtl_pci: Add ID for 8822BE
  rtlwifi: rtl_pci: Extend recognized interrupt parameters from two to
    four ISR
  rtlwifi: rtl_pci: 8822BE puts broadcast and multicast packet to HIQ

Steven Ting (1):
  rtlwifi: rtl_pci: Refactor TX/RX flow

Tsang-Shian Lin (2):
  rtlwifi: Add beacon check mechanism to check if AP settings changed.
  rtlwifi: rtl_pci: Fix the bug when inactiveps is enabled.

 drivers/net/wireless/realtek/rtlwifi/base.c        | 178 ++++++++++++
 drivers/net/wireless/realtek/rtlwifi/base.h        |   3 +-
 drivers/net/wireless/realtek/rtlwifi/core.c        |  48 ++++
 drivers/net/wireless/realtek/rtlwifi/pci.c         | 305 +++++++++++----------
 drivers/net/wireless/realtek/rtlwifi/pci.h         |  36 +--
 .../net/wireless/realtek/rtlwifi/rtl8188ee/hw.c    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/hw.h    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/hw.c    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/hw.h    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/hw.c    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/hw.h    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/hw.c    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/hw.h    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/trx.c   |  57 +---
 .../net/wireless/realtek/rtlwifi/rtl8192se/hw.c    |   2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/hw.h    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/hw.c    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/hw.h    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.c    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.h    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/hw.c    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/hw.h    |   3 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  20 +-
 23 files changed, 460 insertions(+), 234 deletions(-)

-- 
2.12.3
