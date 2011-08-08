Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1681 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953Ab1HHN7W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:22 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 00/82] staging: brcm80211: resubmit previously posted
 patches
Date: Mon, 8 Aug 2011 15:57:44 +0200
Message-ID: <1312811946-16713-1-git-send-email-arend@broadcom.com> (sfid-20110808_160235_989820_7B1D8056)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Before and during the 3.1 merge window three patch series were posted. Feedback
from Dan Carpenter learned that some of the patches did not apply after 3.1
merges. Therefor the series are resubmitted here with some changes as described
below.

[PATCHv2 01/82] fixes a compilation error due to missing <linux/io.h> include
since 3.1-rc1.

Series "[PATCH 00/35] staging: brcm80211: code cleanup and bugfix":
  [PATCH 17/35] has been merged with later patch to remove checkpatch warning.
  [PATCH 33/35] was removed as it caused regression for brcmfmac driver.

Series "[PATCH 00/19] checkpatch changes and brcmfmac cleanup"
  Resubmitted as before.

Series "[PATCH 00/29] staging: brcm80211: cleanup checkpatch warnings"
  [PATCH 09/29] has been rephrased to apropriately describe what changed.
  [PATCH 13/29] was merged with [PATCH 17/35] from the first series.

[PATCHv2 80/82] fixes a compiler warning for ARM platform since 3.1-rc1.

Arend Van Spriel (1):
  staging: brcm80211: fix compile error on non-x86 archs since 3.0
    kernel

Arend van Spriel (19):
  staging: brcm80211: modify the FOREACH_BSS macro
  staging: brcm80211: use mutex instead of semaphore in dhd_linux.c
  staging: brcm80211: remove duplicated code from brcmf_init_iscan
  staging: brcm80211: remove volatile keyword from driver sources
  staging: brcm80211: use native error code in brcmf_c_pattern_atoh()
  staging: brcm80211: use mac_pton() instead of own implementation
  staging: brcm80211: replace semaphore by wait_queue for sysioc thread
  staging: brcm80211: remove volatile keyword used in struct
    rte_console
  staging: brcm80211: replace simple_strtoul usage in brcmsmac
  staging: brcm80211: replace simple_strtoul usage in brcmfmac
  staging: brcm80211: use PCI_DEVICE() macro in device table
  staging: brcm80211: remove unused rx status definitions
  staging: brcm80211: reformat long lines in brcmsmac to 80 columns
  staging: brcm80211: remove wl_alloc_dma_resources() function
  staging: brcm80211: remove dma_addrwidth() function
  staging: brcm80211: cleanup to get rid of 'over 80 character' line
  staging: brcm80211: fix 'uninitialized usage' compiler warning
  staging: brcm80211: remove target platform limitations for drivers
  staging: brcm80211: updated TODO file

Franky Lin (20):
  staging: brcm80211: move sdio related variables to dhd_sdio.c
  staging: brcm80211: move ioctl response wait code to dhd_sdio.c
  staging: brcm80211: remove private timeout functions in fullmac
  staging: brcm80211: move brcmf_mmc_suspend to sdio layer in fullmac
  staging: brcm80211: remove global wait queue head
    sdioh_spinwait_sleep
  staging: brcm80211: remove code for unsupported chip
  staging: brcm80211: get rid of sd debug message macro in fullmac
  staging: brcm80211: remove structure sdio_hc in brcmfmac
  staging: brcm80211: remove SDLX_MSG from brcmfmac
  staging: brcm80211: remove BRCMF_SD_* debug macros from brcmfmac
  staging: brcm80211: absorb brcmf_sdcard_attach into brcmf_sdio_probe
  staging: brcm80211: absorb brcmf_sdcard_detach into brcmf_sdio_remove
  staging: brcm80211: revert removal of atomic initialization
  staging: brcm80211: placed suspend flag in gInstance in brcmfmac
  staging: brcm80211: remove struct brcmf_sdioh_driver from brcmfmac
  staging: brcm80211: remove vendor and device id check from brcmfmac
  staging: brcm80211: remove struct brcmf_sdio_card from brcmfmac
  staging: brcm80211: remove dead code from brcmfmac
  staging: brcm80211: remove dead client interrupt code from brcmfmac
  staging: brcm80211: remove function pointer of interrupt isr in
    brcmfmac

Henry Ptasinski (1):
  staging: brcm80211: fix for 'remove unnecessary braces' checkpatch
    warning

Pieter-Paul Giesberts (1):
  staging: brcm80211: SPARC build error fix

Roland Vossen (35):
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
  staging: brcm80211: fix for checkpatch warnings in phy directory
  staging: brcm80211: resolved checkpatch warnings in LCN phy
  staging: brcm80211: resolved checkpatch warnings in N phy
  staging: brcm80211: fixed build issue for big endian platforms
  staging: brcm80211: remove MIPS specific 'sync' instruction in
    fullmac
  staging: brcm80211: removed R_REG and OR_REG macro's from fullmac
  staging: brcm80211: removed global variable from sdio fullmac
  staging: brcm80211: fixed checkpatch warnings for fullmac
  staging: brcm80211: fixed checkpatch warnings for brcmutil dir
  staging: brcm80211: fixed checkpatch warnings for 'include' dir
  staging: brcm80211: cleaned up softmac DMA layer
  staging: brcm80211: removed void * from softmac phy
  staging: brcm80211: simplified register access macro's in softmac
  staging: brcm80211: removed unused bus code from softmac
  staging: brcm80211: replaced void *btparam into struct pci_dev
    *btparam
  staging: brcm80211: removed void * from ai_ functions
  staging: brcm80211: removed brcms_c_module_unregister() call in
    ampdu.c
  staging: brcm80211: removed watchdog function from softmac

Sukesh Srikakula (5):
  staging: brcm80211: power save issue fixed in brcmfmac driver
  staging: brcm80211: brcmfmac: Enabling FW roaming by default
  staging: brcm80211: brcmfmac: Connect request made robust
  staging: brcm80211: brcmfmac: Fixed issues with iscan
  staging: brcm80211: brcmfmac: Roamed channel info passed to cfg80211

 drivers/staging/brcm80211/Kconfig                  |    2 -
 drivers/staging/brcm80211/TODO                     |    4 -
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c        |  408 +--
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |  484 +--
 drivers/staging/brcm80211/brcmfmac/dhd.h           |  186 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c    |  124 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |  221 +-
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |  915 ++--
 drivers/staging/brcm80211/brcmfmac/sdio_host.h     |  218 +-
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c   |  165 +-
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h   |    7 +-
 drivers/staging/brcm80211/brcmsmac/Makefile        |    1 -
 drivers/staging/brcm80211/brcmsmac/aiutils.c       |  769 ++--
 drivers/staging/brcm80211/brcmsmac/aiutils.h       |   54 +-
 drivers/staging/brcm80211/brcmsmac/alloc.c         |    9 +-
 drivers/staging/brcm80211/brcmsmac/ampdu.c         |  230 +-
 drivers/staging/brcm80211/brcmsmac/antsel.c        |   25 +-
 drivers/staging/brcm80211/brcmsmac/bmac.c          | 3593 --------------
 drivers/staging/brcm80211/brcmsmac/bmac.h          |  174 -
 drivers/staging/brcm80211/brcmsmac/channel.c       |  388 +-
 drivers/staging/brcm80211/brcmsmac/channel.h       |   25 +-
 drivers/staging/brcm80211/brcmsmac/d11.h           |  641 ++-
 drivers/staging/brcm80211/brcmsmac/dma.c           |  803 +---
 drivers/staging/brcm80211/brcmsmac/dma.h           |  178 +-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c   |  134 +-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.h   |   13 +-
 drivers/staging/brcm80211/brcmsmac/main.c          | 4812 ++++++++++++++++---
 drivers/staging/brcm80211/brcmsmac/main.h          |  837 ++--
 drivers/staging/brcm80211/brcmsmac/nicpci.c        |   16 +-
 drivers/staging/brcm80211/brcmsmac/otp.c           |   93 +-
 drivers/staging/brcm80211/brcmsmac/otp.h           |    3 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c   |  535 +--
 drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h   |   85 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h   |  189 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c   |  577 ++--
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c     | 5110 ++++++++++----------
 drivers/staging/brcm80211/brcmsmac/phy/phy_qmath.c |  172 +-
 .../staging/brcm80211/brcmsmac/phy/phytbl_lcn.c    | 1168 ++---
 drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.c  |    3 +-
 drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.h  |   24 +-
 drivers/staging/brcm80211/brcmsmac/phy_shim.c      |   17 +-
 drivers/staging/brcm80211/brcmsmac/phy_shim.h      |   66 +-
 drivers/staging/brcm80211/brcmsmac/pmu.c           |   54 +-
 drivers/staging/brcm80211/brcmsmac/pub.h           |  264 +-
 drivers/staging/brcm80211/brcmsmac/rate.c          |  163 +-
 drivers/staging/brcm80211/brcmsmac/rate.h          |  186 +-
 drivers/staging/brcm80211/brcmsmac/scb.h           |   35 +-
 drivers/staging/brcm80211/brcmsmac/srom.c          |   92 +-
 drivers/staging/brcm80211/brcmsmac/srom.h          |    4 +-
 drivers/staging/brcm80211/brcmsmac/stf.c           |  100 +-
 drivers/staging/brcm80211/brcmsmac/stf.h           |    6 +-
 drivers/staging/brcm80211/brcmsmac/types.h         |  287 +-
 drivers/staging/brcm80211/brcmutil/utils.c         |   45 +-
 drivers/staging/brcm80211/brcmutil/wifi.c          |   37 +-
 drivers/staging/brcm80211/include/brcmu_utils.h    |   14 +-
 drivers/staging/brcm80211/include/brcmu_wifi.h     |  135 +-
 drivers/staging/brcm80211/include/chipcommon.h     |   13 +-
 drivers/staging/brcm80211/include/defs.h           |   18 +-
 drivers/staging/brcm80211/include/soc.h            |    5 +-
 59 files changed, 11817 insertions(+), 13119 deletions(-)
 delete mode 100644 drivers/staging/brcm80211/brcmsmac/bmac.c
 delete mode 100644 drivers/staging/brcm80211/brcmsmac/bmac.h

-- 
1.7.4.1


