Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:34149 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbcF0PxN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2016 11:53:13 -0400
Received: by mail-oi0-f48.google.com with SMTP id s66so206072881oif.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jun 2016 08:53:08 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 00/10 V2] rtlwifi: Various clean-ups for the hwinfo routines
Date: Mon, 27 Jun 2016 10:52:28 -0500
Message-Id: <1467042758-25742-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20160627_175327_809837_A27FBD0A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rtlwifi family of drivers use similar routines to extract hardware
information from EFUSE. This set of patches create a common routine to
extract this data, and converts most of the drivers to use this routine.

In addition, a complicated set of if ... else if ... else statements are
present in rtl8723ae. These are converted into switch statements that
are much easier to read.

The changes in the hwinfo routines was suggested by Arnd Bergmann.

All of this material is intended for kernel 4.8.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
V2 - Applied changes suggested by Joe Perches
     Fixed a bug found after V1 was submitted
     These patches require ("rtlwifi: Add missing newlines to RT_TRACE calls")
	submitted by Joe Perches.

Larry Finger (10):
  rtlwifi: Create common routine to get hardware info
  rtlwifi: rtl8192ce: Convert driver to use common hardware info routine
  rtlwifi: rtl8192cu: Convert driver to use common hardware info routine
  rtlwifi: rtl8188ee: Convert driver to use common hardware info routine
  rtlwifi: rtl8192ee: Convert driver to use common hardware info routine
  rtlwifi: rtl8723ee: Convert driver to use common hardware info routine
  rtlwifi: rtl8723be: Convert driver to use common hardware info routine
  rtlwifi: rtl8821ae: Convert driver to use common hardware info routine
  rtlwifi: rtl8192de: Convert driver to use common hardware info routine
  rtlwifi: rtl8723ae: Clean up the hardware info routine

 drivers/net/wireless/realtek/rtlwifi/efuse.c       |  78 ++++++
 drivers/net/wireless/realtek/rtlwifi/efuse.h       |   2 +
 .../net/wireless/realtek/rtlwifi/rtl8188ee/hw.c    |  76 +-----
 .../net/wireless/realtek/rtlwifi/rtl8192ce/hw.c    |  83 +-----
 .../net/wireless/realtek/rtlwifi/rtl8192cu/hw.c    |  61 ++---
 .../net/wireless/realtek/rtlwifi/rtl8192de/hw.c    |  77 ++----
 .../net/wireless/realtek/rtlwifi/rtl8192ee/hw.c    |  73 +-----
 .../net/wireless/realtek/rtlwifi/rtl8723ae/hw.c    | 286 +++++++++------------
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.c    |  74 +-----
 .../net/wireless/realtek/rtlwifi/rtl8821ae/hw.c    |  84 +-----
 10 files changed, 288 insertions(+), 606 deletions(-)

-- 
2.1.4

