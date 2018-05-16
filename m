Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:48254 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752479AbeEPMMa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 May 2018 08:12:30 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH V2 0/6] brcmfmac: coredump functionality and fixes
Date: Wed, 16 May 2018 14:11:57 +0200
Message-Id: <1526472723-15758-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180516_141243_852772_4B2DD662)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series is intended for 4.18:

 * make ALLFFMAC variable static.
 * support user-space initiated coredump.

The first patch in this series applies to the master branch of the
wireless-drivers-next repository. The remaining patches related to coredump
functionality are dependent upon a commit present since v4.17-rc3:

  commit ed4564babeeee4fb19fe4ec0beabe29754e380f9
  Author: Arend van Spriel <aspriel@gmail.com>
  Date:   Sun Apr 8 23:57:07 2018 +0200

     drivers: change struct device_driver::coredump() return type to void

This patch is not in w-d-next yet.

Arend van Spriel (3):
  brcmfmac: move ALLFFMAC variable in flowring module
  brcmfmac: add support for sysfs initiated coredump
  mwifiex: support sysfs initiated device coredump

Franky Lin (3):
  brcmfmac: validate user provided data for memdump before copying
  brcmfmac: trigger memory dump upon firmware halt signal
  brcmfmac: trigger memory dump on SDIO firmware halt message

 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |  1 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |  2 ++
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |  2 --
 .../wireless/broadcom/brcm80211/brcmfmac/common.h  |  2 --
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |  8 ++++++
 .../wireless/broadcom/brcm80211/brcmfmac/debug.c   |  3 ++-
 .../broadcom/brcm80211/brcmfmac/flowring.c         |  2 ++
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |  6 +++++
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  4 ++-
 drivers/net/wireless/marvell/mwifiex/cmdevt.c      |  1 +
 drivers/net/wireless/marvell/mwifiex/debugfs.c     | 31 +---------------------
 drivers/net/wireless/marvell/mwifiex/pcie.c        | 18 +++++++++++--
 drivers/net/wireless/marvell/mwifiex/sdio.c        | 12 +++++++++
 drivers/net/wireless/marvell/mwifiex/usb.c         | 13 +++++++++
 14 files changed, 67 insertions(+), 38 deletions(-)

-- 
1.9.1
