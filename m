Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:58191 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbaLRJF5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 04:05:57 -0500
Received: by mail-oi0-f48.google.com with SMTP id u20so110051oif.7
        for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2014 01:05:56 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 00/16] rtlwifi updates for kernel 3.20
Date: Thu, 18 Dec 2014 03:05:24 -0600
Message-Id: <1418893540-19944-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20141218_100603_491464_A350FF1C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle,

Welcome as the wireless-driver maintainer. I'm certain that it will take
a while for all of us to function with the new structure, but I will try.

This patch bomb is the first of a set of cleanups. As I wrote John earlier,
my intent is to identify code that appears in multiple drivers and move such
routines into rtlwifi. None of the changes in this set need have high priority,
and all should be pushed into the "next" stream for kernel 3.20.

Thanks,

Larry
---

Larry Finger (15):
  rtlwifi: rtl8821ae: Fix typos in power-sequence macro
  rtlwifi: rtl8192ce: Add code to set the keep-alive operation
  rtlwifi: rtl8192ce: Update setting of the media status
  rtlwifi: rtl8192ce: Update rate setting routines
  rtlwifi: rtl8192ce: Improve RF sleep routine
  rtlwifi: rtl8192ce: rtl8192cu: rtl8192de: rtl8192se:
  rtlwifi: rtl8723be: Swith to use common rate-mapping routine
  rtlwifi: rtl8188ee: Switch to use common rate-mapping routine
  rtlwifi: rtl8723ae: Modify driver to use rate-mapping routine in core
  rtlwifi: rtl8192ee: Convert driver to use common rate-mapping code
  rtlwifi: Convert all drivers to use a common set of rate descriptors
  rtlwifi: rtl8821ae: Add VHT rate descriptors
  rtlwifi: rtl8192cu: Rework calls to rate-control routine
  rtlwifi: rtl8192de: Rework calls to rate-control routine
  rtlwifi: rtl8821ae: Switch to use common rate control routine

Troy Tan (1):
  rtlwifi: rtl8821ae: Simplify loading of WOWLAN firmware

 drivers/net/wireless/rtlwifi/base.c               | 156 +++++++++++----
 drivers/net/wireless/rtlwifi/base.h               |   4 +-
 drivers/net/wireless/rtlwifi/core.c               |  24 ++-
 drivers/net/wireless/rtlwifi/core.h               |   1 +
 drivers/net/wireless/rtlwifi/rtl8188ee/trx.c      | 162 +--------------
 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h |   1 +
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c       | 165 ++++++++-------
 drivers/net/wireless/rtlwifi/rtl8192ce/phy.c      |   5 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c       |  30 +--
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c      |  13 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c      |   4 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c       |  28 +--
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c      |  20 +-
 drivers/net/wireless/rtlwifi/rtl8192de/sw.c       |  30 +--
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c      |  27 ++-
 drivers/net/wireless/rtlwifi/rtl8192ee/trx.c      | 175 +---------------
 drivers/net/wireless/rtlwifi/rtl8192ee/trx.h      |   8 +-
 drivers/net/wireless/rtlwifi/rtl8192se/def.h      |   8 +-
 drivers/net/wireless/rtlwifi/rtl8192se/sw.c       |  30 +--
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c      |  23 +--
 drivers/net/wireless/rtlwifi/rtl8723ae/trx.c      | 162 +--------------
 drivers/net/wireless/rtlwifi/rtl8723be/trx.c      | 162 +--------------
 drivers/net/wireless/rtlwifi/rtl8821ae/def.h      |  54 -----
 drivers/net/wireless/rtlwifi/rtl8821ae/pwrseq.h   |   4 +-
 drivers/net/wireless/rtlwifi/rtl8821ae/sw.c       |  74 +++----
 drivers/net/wireless/rtlwifi/rtl8821ae/trx.c      | 232 +---------------------
 drivers/net/wireless/rtlwifi/wifi.h               |  96 +++++----
 27 files changed, 433 insertions(+), 1265 deletions(-)

-- 
2.1.2

