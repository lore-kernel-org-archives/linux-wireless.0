Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4633 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328Ab1FIOpP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 10:45:15 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 00/21] staging: brcm80211: code cleanup and fullmac
 bugfix
Date: Thu, 9 Jun 2011 16:44:40 +0200
Message-ID: <1307630701-9170-1-git-send-email-rvossen@broadcom.com> (sfid-20110609_164520_611083_DEF1765C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel (9):
  staging: brcm80211: remove 'used' keyword from function ai_ispcie()
  staging: brcm80211: remove regs variable from brcms_ioctl function
  staging: brcm80211: remove d11regs_t parameter from wlc_tbtt function
  staging: brcm80211: remove device id parameter from ai_attach()
  staging: brcm80211: remove unused fields from struct si_info
  staging: brcm80211: use __BIG_ENDIAN macro in dma.c
  staging: brcm80211: remove checkpatch errors found in fullmac
  staging: brcm80211: fix checkpatch errors from main.c
  staging: brcm80211: fix checkpatch errors in brcmsmac driver

Franky Lin (1):
  staging: brcm80211: Remove flags from wl_is_nonetwork

Roland Vossen (10):
  staging: brcm80211: moved typedefs to decrease header file
    dependencies
  staging: brcm80211: cleaned brcmu_utils.h
  staging: brcm80211: #include reduction
  staging: brcm80211: fixed double #include problem
  staging: brcm80211: replaced bmac acronym by brcms_b_
  staging: brcm80211: replaced wlc_ by brcms_c_
  staging: brcm80211: removed superfluous forward struct declarations
  staging: brcm80211: further replaced wlc_ by brcmsmac_c_
  staging: brcm80211: replaced wlc_ by brcms_c_, part 2
  staging: brcm80211: change wl_cfg80211_suspend corresponding to
    cfg80211

Sukesh Srikakula (1):
  staging: brcm80211: Fix for suspend issue in brcmfmac driver

 drivers/staging/brcm80211/brcmfmac/bcmsdh.c        |    7 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |   20 +-
 .../brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c        |   19 +-
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c       |   10 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c    |   14 +-
 .../staging/brcm80211/brcmfmac/dhd_custom_gpio.c   |    4 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |   24 +-
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |   15 +-
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c   |   76 +-
 drivers/staging/brcm80211/brcmfmac/wl_iw.c         |   22 +-
 drivers/staging/brcm80211/brcmsmac/aiutils.c       |   45 +-
 drivers/staging/brcm80211/brcmsmac/aiutils.h       |   18 +-
 drivers/staging/brcm80211/brcmsmac/alloc.c         |   94 +-
 drivers/staging/brcm80211/brcmsmac/alloc.h         |    5 +-
 drivers/staging/brcm80211/brcmsmac/ampdu.c         |  199 ++--
 drivers/staging/brcm80211/brcmsmac/ampdu.h         |   15 +-
 drivers/staging/brcm80211/brcmsmac/antsel.c        |   77 +-
 drivers/staging/brcm80211/brcmsmac/antsel.h        |   10 +-
 drivers/staging/brcm80211/brcmsmac/bmac.c          |  846 ++++++------
 drivers/staging/brcm80211/brcmsmac/bmac.h          |  127 +-
 drivers/staging/brcm80211/brcmsmac/channel.c       |  254 ++--
 drivers/staging/brcm80211/brcmsmac/channel.h       |   26 +-
 drivers/staging/brcm80211/brcmsmac/d11.h           |   55 +-
 drivers/staging/brcm80211/brcmsmac/dma.c           |   28 +-
 drivers/staging/brcm80211/brcmsmac/dma.h           |   21 +-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c   |  118 +-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.h   |    7 +-
 drivers/staging/brcm80211/brcmsmac/main.c          | 1384 ++++++++++----------
 drivers/staging/brcm80211/brcmsmac/main.h          |  321 +++---
 drivers/staging/brcm80211/brcmsmac/nicpci.c        |   13 +-
 drivers/staging/brcm80211/brcmsmac/nicpci.h        |    4 +-
 drivers/staging/brcm80211/brcmsmac/otp.c           |   14 +-
 drivers/staging/brcm80211/brcmsmac/otp.h           |    2 +
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c   |   23 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h   |   33 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h   |   98 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c   |   21 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.h   |    2 +
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c     |   24 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_qmath.c |    2 -
 drivers/staging/brcm80211/brcmsmac/phy/phy_qmath.h |    2 +
 .../staging/brcm80211/brcmsmac/phy/phytbl_lcn.c    |    6 +-
 .../staging/brcm80211/brcmsmac/phy/phytbl_lcn.h    |    7 +-
 drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.c  |    7 +-
 drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.h  |    3 +-
 drivers/staging/brcm80211/brcmsmac/phy_shim.c      |   73 +-
 drivers/staging/brcm80211/brcmsmac/phy_shim.h      |    9 +-
 drivers/staging/brcm80211/brcmsmac/pmu.c           |    6 +-
 drivers/staging/brcm80211/brcmsmac/pmu.h           |    5 +-
 drivers/staging/brcm80211/brcmsmac/pub.h           |  155 ++--
 drivers/staging/brcm80211/brcmsmac/rate.c          |   46 +-
 drivers/staging/brcm80211/brcmsmac/rate.h          |   38 +-
 drivers/staging/brcm80211/brcmsmac/scb.h           |   12 +-
 drivers/staging/brcm80211/brcmsmac/srom.c          |   21 +-
 drivers/staging/brcm80211/brcmsmac/srom.h          |    2 +
 drivers/staging/brcm80211/brcmsmac/stf.c           |  108 +-
 drivers/staging/brcm80211/brcmsmac/stf.h           |   30 +-
 drivers/staging/brcm80211/brcmsmac/types.h         |  105 ++-
 drivers/staging/brcm80211/brcmsmac/ucode_loader.c  |    2 +-
 drivers/staging/brcm80211/brcmutil/utils.c         |   10 -
 drivers/staging/brcm80211/brcmutil/wifi.c          |    5 -
 drivers/staging/brcm80211/include/brcmu_utils.h    |  114 +--
 drivers/staging/brcm80211/include/defs.h           |    2 +
 63 files changed, 2384 insertions(+), 2481 deletions(-)

-- 
1.7.4.1


