Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1057 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204Ab1ILKPW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 06:15:22 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 00/20] staging: brcm80211: 4th reaction to mainline
 patch #2
Date: Mon, 12 Sep 2011 12:14:44 +0200
Message-ID: <1315822504-24210-1-git-send-email-rvossen@broadcom.com> (sfid-20110912_121534_514434_6C74B91A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup items, both fullmac and softmac.

Arend van Spriel (2):
  staging: brcm80211: remove static function variable in brcmfmac
  staging: brcm80211: remove static variables from wl_cfg80211.c

Franky Lin (2):
  staging: brcm80211: stop using kthread for iscan status check in
    fullmac
  staging: brcm80211: remove static function declaration in wl_cfg80211

Roland Vossen (16):
  staging: brcm80211: cleaned up softmac types.h macro's
  staging: brcm80211: cleaned up brcmu_utils.h macro's
  staging: brcm80211: cleaned up brcmu_wifi.h macro's
  staging: brcm80211: cleaned up fullmac macro's
  staging: brcm80211: removed fullmac BRCMF_IOCTL_MAGIC support
  staging: brcm80211: removed fullmac function brcmf_sdcard_iovar_op()
  staging: brcm80211: removed unused encryption/security functionality
  staging: brcm80211: removed softmac 'tunable' functionality
  staging: brcm80211: cleaned up unused softmac struct members
  staging: brcm80211: removed softmac ratespec override functionality
  staging: brcm80211: removed unused softmac code after macro cleanup
  staging: brcm80211: removed unused softmac struct brcms_c_if
  staging: brcm80211: removed several unused softmac main.h struct
    members
  staging: brcm80211: removed unused softmac transmit power variables
  staging: brcm80211: removed more unused softmac main.h struct members
  staging: brcm80211: removed softmac files alloc.c/alloc.h

 drivers/staging/brcm80211/brcmfmac/bcmsdh.c       |  148 --
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   34 -
 drivers/staging/brcm80211/brcmfmac/dhd.h          |   15 +-
 drivers/staging/brcm80211/brcmfmac/dhd_bus.h      |   15 +-
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c      |   17 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c   |  297 +---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c    |   29 +-
 drivers/staging/brcm80211/brcmfmac/dhd_proto.h    |    7 -
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |  868 +-------
 drivers/staging/brcm80211/brcmfmac/sdio_host.h    |   22 -
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c  | 2692 +++++++++------------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h  |   56 +-
 drivers/staging/brcm80211/brcmsmac/Makefile       |    1 -
 drivers/staging/brcm80211/brcmsmac/alloc.c        |  265 --
 drivers/staging/brcm80211/brcmsmac/alloc.h        |   19 -
 drivers/staging/brcm80211/brcmsmac/ampdu.c        |   11 +-
 drivers/staging/brcm80211/brcmsmac/channel.c      |   38 +-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c  |    4 +-
 drivers/staging/brcm80211/brcmsmac/main.c         |  463 ++--
 drivers/staging/brcm80211/brcmsmac/main.h         |  197 --
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c  |   32 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c  |    7 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c    |   17 +-
 drivers/staging/brcm80211/brcmsmac/pub.h          |  105 +-
 drivers/staging/brcm80211/brcmsmac/rate.c         |    5 +-
 drivers/staging/brcm80211/brcmsmac/stf.c          |   30 -
 drivers/staging/brcm80211/brcmsmac/types.h        |   64 +-
 drivers/staging/brcm80211/brcmutil/utils.c        |   67 -
 drivers/staging/brcm80211/brcmutil/wifi.c         |    4 +-
 drivers/staging/brcm80211/include/brcmu_utils.h   |  206 +-
 drivers/staging/brcm80211/include/brcmu_wifi.h    |   69 +-
 31 files changed, 1748 insertions(+), 4056 deletions(-)
 delete mode 100644 drivers/staging/brcm80211/brcmsmac/alloc.c
 delete mode 100644 drivers/staging/brcm80211/brcmsmac/alloc.h

-- 
1.7.4.1


