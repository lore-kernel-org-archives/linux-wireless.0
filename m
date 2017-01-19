Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:35152 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753667AbdASRuk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jan 2017 12:50:40 -0500
Received: by mail-ot0-f193.google.com with SMTP id 65so5012099otq.2
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jan 2017 09:50:11 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH v2 0/3] rtlwifi: Rework debug system
Date: Thu, 19 Jan 2017 11:25:18 -0600
Message-Id: <20170119172521.32643-1-Larry.Finger@lwfinger.net> (sfid-20170119_185043_982977_927113EE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This set of patches modifies the debug system by replacing some
complicated macros with the equivalent operations in C. Then, the
COMP_XX component debugging is converted into a debug mask. Finally,
code that allows the dynamic setting of the debug level is removed.
All that functionality is already provided by
/sys/module/<driver>/parameters/.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>

---
V2 - Remove sysfs private interface rather than adding a new one

Larry Finger (3):
  rtlwifi: Redo debugging macros RTPRINT and RT_PRINT_DATA
  rtlwifi: Convert COMP_XX entries into a proper debugging mask
  rtlwifi: Remove debugging entry in sysfs

 drivers/net/wireless/realtek/rtlwifi/base.c        | 59 ----------------------
 drivers/net/wireless/realtek/rtlwifi/base.h        |  1 -
 drivers/net/wireless/realtek/rtlwifi/debug.c       | 55 +++++++++++++-------
 drivers/net/wireless/realtek/rtlwifi/debug.h       | 33 +++++-------
 drivers/net/wireless/realtek/rtlwifi/pci.c         |  8 ---
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
 15 files changed, 100 insertions(+), 105 deletions(-)

-- 
2.10.2
