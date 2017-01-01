Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33668 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754832AbdAABHP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 31 Dec 2016 20:07:15 -0500
Received: by mail-oi0-f65.google.com with SMTP id f201so62677881oib.0
        for <linux-wireless@vger.kernel.org>; Sat, 31 Dec 2016 17:07:15 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 0/3] rtlwifi: Rework debug system
Date: Sat, 31 Dec 2016 19:07:03 -0600
Message-Id: <20170101010706.13234-1-Larry.Finger@lwfinger.net> (sfid-20170101_020725_225895_744CA531)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This set of patches modifies the debug system by replacing some
complicated macros with the equivalent operations in C. Then, the
COMP_XX component debugging is converted into a debug mask. Finally,
code is added to permit setting the debug mask from sysfs.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>


Larry Finger (3):
  rtlwifi: Redo debugging macros RTPRINT and RT_PRINT_DATA
  rtlwifi: Convert COMP_XX entries into a proper debugging mask
  rtlwifi: Enable debug mask to be set from sysfs

 drivers/net/wireless/realtek/rtlwifi/base.c        | 43 ++++++++++++++---
 drivers/net/wireless/realtek/rtlwifi/debug.c       | 55 +++++++++++++++-------
 drivers/net/wireless/realtek/rtlwifi/debug.h       | 31 +++++-------
 .../net/wireless/realtek/rtlwifi/rtl8188ee/sw.c    |  5 ++
 .../net/wireless/realtek/rtlwifi/rtl8192ce/sw.c    |  5 ++
 .../net/wireless/realtek/rtlwifi/rtl8192cu/sw.c    |  5 ++
 .../net/wireless/realtek/rtlwifi/rtl8192de/sw.c    |  5 ++
 .../net/wireless/realtek/rtlwifi/rtl8192ee/sw.c    |  5 ++
 .../net/wireless/realtek/rtlwifi/rtl8192se/sw.c    |  5 ++
 .../net/wireless/realtek/rtlwifi/rtl8723ae/sw.c    |  5 ++
 .../net/wireless/realtek/rtlwifi/rtl8723be/sw.c    |  5 ++
 .../net/wireless/realtek/rtlwifi/rtl8821ae/sw.c    |  5 ++
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  4 +-
 13 files changed, 135 insertions(+), 43 deletions(-)

-- 
2.10.2
