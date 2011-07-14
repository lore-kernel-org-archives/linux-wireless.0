Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2051 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932231Ab1GNV3q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 17:29:46 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 00/35] staging: brcm80211: code cleanup and bugfix
Date: Thu, 14 Jul 2011 14:28:56 -0700
Message-ID: <1310678971-28952-1-git-send-email-frankyl@broadcom.com> (sfid-20110714_232951_859328_A5827B28)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Further code cleanup of attacking checkpatch warning/error along with bugfix.

Arend van Spriel (10):
  staging: brcm80211: modify the FOREACH_BSS macro
  staging: brcm80211: use mutex instead of semaphore in dhd_linux.c
  staging: brcm80211: remove duplicated code from brcmf_init_iscan
  staging: brcm80211: remove volatile keyword from driver sources
  staging: brcm80211: use native error code in brcmf_c_pattern_atoh()
  staging: brcm80211: use mac_pton() instead of own implementation
  staging: brcm80211: replace semaphore by wait_queue for sysioc thread
  staging: brcm80211: use wait queues instead of semaphores in
    wl_cfg80211.c
  staging: brcm80211: remove volatile keyword used in struct
    rte_console
  staging: brcm80211: replace simple_strtoul usage in brcmfmac

Franky Lin (2):
  staging: brcm80211: move sdio related variables to dhd_sdio.c
  staging: brcm80211: move ioctl response wait code to dhd_sdio.c

Henry Ptasinski (1):
  staging: brcm80211: fix for 'remove unnecessary braces' checkpatch
    warning

Roland Vossen (17):
  staging: brcm80211: bugfix for len==0 parameter in 3 fullmac
    functions
  staging: brcm80211: merged bmac.c into main.c
  staging: brcm80211: shuffled sections in main.c
  staging: brcm80211: removed function declaration typedefs from
    phy_int.h
  staging: brcm80211: removed function declaration typedefs from
    aiutils.h
  staging: brcm80211: removed function declaration typedefs from dma.h
    part 1
  staging: brcm80211: removed function declaration typedefs from dma.h
    part 2
  staging: brcm80211: removed function declaration typedefs from dma.h
    part 3
  staging: brcm80211: removed function declaration typedefs from dma.h
    part 4
  staging: brcm80211: removed function declaration typedefs from otp.c
  staging: brcm80211: removed function declaration typedefs from
    main.h,pub.h
  staging: brcm80211: removed function declaration typedefs from
    brcmutil
  staging: brcm80211: replaced various typedefs
  staging: brcm80211: replaced typedef wlc_rateset_t
  staging: brcm80211: replaced typedef wl_rateset_t by struct
    brcm_rateset
  staging: brcm80211: replaced all volatile typedefs
  staging: brcm80211: fix for checkpatch 'avoid externs in c file'
    warning

Sukesh Srikakula (5):
  staging: brcm80211: power save issue fixed in brcmfmac driver
  staging: brcm80211: brcmfmac: Enabling FW roaming by default
  staging: brcm80211: brcmfmac: Connect request made robust
  staging: brcm80211: brcmfmac: Fixed issues with iscan
  staging: brcm80211: brcmfmac: Roamed channel info passed to cfg80211

 drivers/staging/brcm80211/brcmfmac/bcmsdh.c        |   10 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |   22 +-
 drivers/staging/brcm80211/brcmfmac/dhd.h           |   24 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c    |  101 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |  127 +-
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |  151 +-
 drivers/staging/brcm80211/brcmfmac/sdio_host.h     |    1 +
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c   |  162 +-
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h   |    9 +-
 drivers/staging/brcm80211/brcmsmac/Makefile        |    1 -
 drivers/staging/brcm80211/brcmsmac/aiutils.c       |  100 +-
 drivers/staging/brcm80211/brcmsmac/aiutils.h       |   16 +-
 drivers/staging/brcm80211/brcmsmac/alloc.c         |    9 +-
 drivers/staging/brcm80211/brcmsmac/ampdu.c         |   33 +-
 drivers/staging/brcm80211/brcmsmac/antsel.c        |   10 +-
 drivers/staging/brcm80211/brcmsmac/bmac.c          | 3593 -----------------
 drivers/staging/brcm80211/brcmsmac/bmac.h          |  174 -
 drivers/staging/brcm80211/brcmsmac/channel.c       |  233 +-
 drivers/staging/brcm80211/brcmsmac/channel.h       |   10 +-
 drivers/staging/brcm80211/brcmsmac/d11.h           |   24 +-
 drivers/staging/brcm80211/brcmsmac/dma.c           |  159 +-
 drivers/staging/brcm80211/brcmsmac/dma.h           |  138 +-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c   |   58 +-
 drivers/staging/brcm80211/brcmsmac/main.c          | 4135 ++++++++++++++++++--
 drivers/staging/brcm80211/brcmsmac/main.h          |  165 +-
 drivers/staging/brcm80211/brcmsmac/nicpci.c        |   12 +-
 drivers/staging/brcm80211/brcmsmac/otp.c           |   60 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c   |  275 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h   |   26 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h   |   71 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c   |  157 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c     | 1354 +++----
 drivers/staging/brcm80211/brcmsmac/phy/phy_qmath.c |   36 +-
 drivers/staging/brcm80211/brcmsmac/phy_shim.c      |    1 -
 drivers/staging/brcm80211/brcmsmac/pmu.c           |   42 +-
 drivers/staging/brcm80211/brcmsmac/pub.h           |   40 +-
 drivers/staging/brcm80211/brcmsmac/rate.c          |   59 +-
 drivers/staging/brcm80211/brcmsmac/rate.h          |   45 +-
 drivers/staging/brcm80211/brcmsmac/srom.c          |   17 +-
 drivers/staging/brcm80211/brcmsmac/stf.c           |   46 +-
 drivers/staging/brcm80211/brcmsmac/stf.h           |    6 +-
 drivers/staging/brcm80211/brcmsmac/types.h         |   18 -
 drivers/staging/brcm80211/brcmutil/utils.c         |   36 +-
 drivers/staging/brcm80211/brcmutil/wifi.c          |   14 +-
 drivers/staging/brcm80211/include/brcmu_utils.h    |   11 +-
 drivers/staging/brcm80211/include/brcmu_wifi.h     |   36 +-
 drivers/staging/brcm80211/include/chipcommon.h     |    4 +-
 drivers/staging/brcm80211/include/defs.h           |    4 +-
 48 files changed, 5512 insertions(+), 6323 deletions(-)
 delete mode 100644 drivers/staging/brcm80211/brcmsmac/bmac.c
 delete mode 100644 drivers/staging/brcm80211/brcmsmac/bmac.h


