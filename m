Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34403 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755925AbcLOSYC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Dec 2016 13:24:02 -0500
Received: by mail-oi0-f67.google.com with SMTP id m75so7099193oig.1
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2016 10:23:23 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 00/14 V2] rtlwifi: Start reworking of debug system
Date: Thu, 15 Dec 2016 12:22:56 -0600
Message-Id: <20161215182310.13713-1-Larry.Finger@lwfinger.net> (sfid-20161215_192406_566043_6BDD2846)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Following the discussion regarding the patch entitled "rtlwifi: Add
BTC_TRACE_STRING to new btcoex", we are reworking the entire debug
system. This set of patches does the following:

1. Replaces every invocation of RT_ASSERT with WARN_ON. With this
   change, triggering these conditions with now give a stack dump.
   Note that the logical condition between RT_ASSERT and WARN_ON
   is inverted. In making these changes, 6 logic errors were found.
2. Replaces every call of RT_TRACE with the level set to DBG_EMERG
   with the equivalent pr_err() call. Future plans call for using
   the COMP_xxx portion of the macro as a debug mask. If these changes
   are not made, these error conditions might not be logged.
3. Removes some redundant logged conditions. For example, when the
   failure of firmware to start is logged, it is not necessary to
   log that the firmware did start.

The previous two patch sequences "[PATCH 00/14] rtlwifi: Various updates"
and "[PATCH 0/7] rtlwifi: btcoexist: Rewrite BT coexistence routines"
should be discarded. That material will be resubmitted later.

V2 removes those files that had rtlwifi_new in the subject. They should
not have been sent. It also removes the module name from the format as
it is specified by the pr_fmt macro in wifi.h as noted by Joe Perches.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>

Larry Finger (14):
  rtlwifi: Replace local debug macro RT_ASSERT
  rtlwifi_new: Remove RT_TRACE messages that use DBG_EMERG
  rtlwifi_new: rtl8821ae: Remove all instances of DBG_EMERG
  rtlwifi_new: rtl8723be: Remove all instances of DBG_EMERG
  rtlwifi_new: rtl8723ae: Remove all instances of DBG_EMERG
  rtlwifi_new: rtl8192ee: Remove all instances of DBG_EMERG
  rtlwifi_new: rtl8723-common: Remove all instances of DBG_EMERG
  rtlwifi_new: rtl8192se: Remove all instances of DBG_EMERG
  rtlwifi_new: rtl8192de: Remove all instances of DBG_EMERG
  rtlwifi_new: rtl8192cu: Remove all instances of DBG_EMERG
  rtlwifi_new: rtl8192ce: Remove all instances of DBG_EMERG
  rtlwifi_new: rtl8192c-common: Remove all instances of DBG_EMERG
  rtlwifi_new: rtl8188ee: Remove all instances of DBG_EMERG
  rtlwifi: Remove some redundant code

 drivers/net/wireless/realtek/rtlwifi/base.c        | 15 +++----
 drivers/net/wireless/realtek/rtlwifi/cam.c         | 14 +++---
 drivers/net/wireless/realtek/rtlwifi/core.c        | 29 +++++-------
 drivers/net/wireless/realtek/rtlwifi/debug.c       |  9 ++--
 drivers/net/wireless/realtek/rtlwifi/debug.h       | 18 +-------
 drivers/net/wireless/realtek/rtlwifi/efuse.c       |  3 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         | 48 ++++++++------------
 drivers/net/wireless/realtek/rtlwifi/ps.c          |  3 +-
 drivers/net/wireless/realtek/rtlwifi/rc.c          |  3 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/fw.c    | 43 +++++-------------
 .../net/wireless/realtek/rtlwifi/rtl8188ee/hw.c    | 32 +++++---------
 .../net/wireless/realtek/rtlwifi/rtl8188ee/phy.c   | 32 ++++++--------
 .../net/wireless/realtek/rtlwifi/rtl8188ee/rf.c    |  3 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/sw.c    |  8 ++--
 .../net/wireless/realtek/rtlwifi/rtl8188ee/trx.c   |  8 ++--
 .../wireless/realtek/rtlwifi/rtl8192c/fw_common.c  | 45 ++++++-------------
 .../wireless/realtek/rtlwifi/rtl8192c/phy_common.c | 27 ++++++------
 .../net/wireless/realtek/rtlwifi/rtl8192ce/hw.c    | 38 ++++++----------
 .../net/wireless/realtek/rtlwifi/rtl8192ce/led.c   |  6 +--
 .../net/wireless/realtek/rtlwifi/rtl8192ce/phy.c   | 13 +++---
 .../net/wireless/realtek/rtlwifi/rtl8192ce/rf.c    |  3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/sw.c    |  8 ++--
 .../net/wireless/realtek/rtlwifi/rtl8192ce/trx.c   |  8 ++--
 .../net/wireless/realtek/rtlwifi/rtl8192cu/hw.c    | 35 +++++----------
 .../net/wireless/realtek/rtlwifi/rtl8192cu/led.c   |  6 +--
 .../net/wireless/realtek/rtlwifi/rtl8192cu/mac.c   | 12 ++---
 .../net/wireless/realtek/rtlwifi/rtl8192cu/phy.c   | 12 ++---
 .../net/wireless/realtek/rtlwifi/rtl8192cu/rf.c    |  3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/sw.c    |  5 +--
 .../net/wireless/realtek/rtlwifi/rtl8192cu/trx.c   |  2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/fw.c    | 31 ++++---------
 .../net/wireless/realtek/rtlwifi/rtl8192de/hw.c    | 34 +++++----------
 .../net/wireless/realtek/rtlwifi/rtl8192de/led.c   |  6 +--
 .../net/wireless/realtek/rtlwifi/rtl8192de/phy.c   | 41 ++++++++---------
 .../net/wireless/realtek/rtlwifi/rtl8192de/rf.c    |  3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/sw.c    | 10 ++---
 .../net/wireless/realtek/rtlwifi/rtl8192de/trx.c   |  8 ++--
 .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.c    | 40 +++++------------
 .../net/wireless/realtek/rtlwifi/rtl8192ee/hw.c    | 13 +++---
 .../net/wireless/realtek/rtlwifi/rtl8192ee/phy.c   | 36 +++++++--------
 .../net/wireless/realtek/rtlwifi/rtl8192ee/rf.c    |  3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/sw.c    |  8 ++--
 .../net/wireless/realtek/rtlwifi/rtl8192ee/trx.c   | 15 ++++---
 .../net/wireless/realtek/rtlwifi/rtl8192se/fw.c    | 46 ++++++++-----------
 .../net/wireless/realtek/rtlwifi/rtl8192se/hw.c    | 42 +++++++-----------
 .../net/wireless/realtek/rtlwifi/rtl8192se/led.c   |  6 +--
 .../net/wireless/realtek/rtlwifi/rtl8192se/phy.c   | 42 +++++++-----------
 .../net/wireless/realtek/rtlwifi/rtl8192se/rf.c    |  3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/sw.c    |  8 ++--
 .../net/wireless/realtek/rtlwifi/rtl8192se/trx.c   |  8 ++--
 .../net/wireless/realtek/rtlwifi/rtl8723ae/fw.c    | 13 +++---
 .../net/wireless/realtek/rtlwifi/rtl8723ae/hw.c    | 21 ++++-----
 .../net/wireless/realtek/rtlwifi/rtl8723ae/led.c   |  6 +--
 .../net/wireless/realtek/rtlwifi/rtl8723ae/phy.c   | 28 +++++-------
 .../net/wireless/realtek/rtlwifi/rtl8723ae/rf.c    |  3 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/sw.c    |  8 ++--
 .../net/wireless/realtek/rtlwifi/rtl8723ae/trx.c   |  8 ++--
 .../net/wireless/realtek/rtlwifi/rtl8723be/fw.c    | 13 +++---
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.c    | 18 +++-----
 .../net/wireless/realtek/rtlwifi/rtl8723be/led.c   |  6 +--
 .../net/wireless/realtek/rtlwifi/rtl8723be/phy.c   | 30 ++++++-------
 .../net/wireless/realtek/rtlwifi/rtl8723be/rf.c    |  3 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/sw.c    |  8 ++--
 .../net/wireless/realtek/rtlwifi/rtl8723be/trx.c   | 14 +++---
 .../realtek/rtlwifi/rtl8723com/fw_common.c         | 25 +++--------
 .../realtek/rtlwifi/rtl8723com/phy_common.c        |  6 +--
 .../net/wireless/realtek/rtlwifi/rtl8821ae/dm.c    |  3 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.c    | 28 ++++--------
 .../net/wireless/realtek/rtlwifi/rtl8821ae/hw.c    | 31 ++++++-------
 .../net/wireless/realtek/rtlwifi/rtl8821ae/phy.c   | 51 +++++++++-------------
 .../net/wireless/realtek/rtlwifi/rtl8821ae/rf.c    |  5 +--
 .../net/wireless/realtek/rtlwifi/rtl8821ae/sw.c    | 14 +++---
 .../net/wireless/realtek/rtlwifi/rtl8821ae/trx.c   | 20 +++++----
 drivers/net/wireless/realtek/rtlwifi/usb.c         | 48 +++++++-------------
 74 files changed, 488 insertions(+), 816 deletions(-)

-- 
2.10.2
