Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:58028 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752913AbeEOJPG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 05:15:06 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 0/8] brcmfmac: coredump functionality and fixes
Date: Tue, 15 May 2018 11:14:43 +0200
Message-Id: <1526375691-31789-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180515_111609_828982_4CB9EF1C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series is intended for 4.18:

 * fix variable initialization found by kbuild bot.
 * make ALLFFMAC variable static.
 * support user-space initiated coredump.

The first two patches in this series apply to the master branch of the
wireless-drivers-next repository. The remaining patches related to coredump
functionality are dependent upon a commit present since v4.17-rc3:

  commit ed4564babeeee4fb19fe4ec0beabe29754e380f9
  Author: Arend van Spriel <aspriel@gmail.com>
  Date:   Sun Apr 8 23:57:07 2018 +0200

     drivers: change struct device_driver::coredump() return type to void

Both w-d-next and bt-next (for patch 5/8) do not carry this patch yet.

Arend van Spriel (4):
  brcmfmac: move ALLFFMAC variable in flowring module
  brcmfmac: add support for sysfs initiated coredump
  mwifiex: support sysfs initiated device coredump
  btmrvl: support sysfs initiated firmware coredump

Franky Lin (4):
  brcmfmac: fix initialization of struct cfg80211_inform_bss variable
  brcmfmac: validate user provided data for memdump before copying
  brcmfmac: trigger memory dump upon firmware halt signal
  brcmfmac: trigger memory dump on SDIO firmware halt message

 drivers/bluetooth/btmrvl_debugfs.c                 | 31 ----------------------
 drivers/bluetooth/btmrvl_drv.h                     |  2 --
 drivers/bluetooth/btmrvl_main.c                    |  6 -----
 drivers/bluetooth/btmrvl_sdio.c                    | 11 +++++---
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |  1 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |  2 ++
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |  2 --
 .../wireless/broadcom/brcm80211/brcmfmac/common.h  |  2 --
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |  8 ++++++
 .../wireless/broadcom/brcm80211/brcmfmac/debug.c   |  3 ++-
 .../broadcom/brcm80211/brcmfmac/flowring.c         |  2 ++
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |  6 +++++
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  4 ++-
 drivers/net/wireless/marvell/mwifiex/debugfs.c     | 31 +---------------------
 drivers/net/wireless/marvell/mwifiex/pcie.c        | 18 +++++++++++--
 drivers/net/wireless/marvell/mwifiex/sdio.c        | 12 +++++++++
 drivers/net/wireless/marvell/mwifiex/usb.c         | 13 +++++++++
 18 files changed, 75 insertions(+), 81 deletions(-)

--
1.9.1
