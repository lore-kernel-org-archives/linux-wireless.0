Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3339 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755002Ab1GVS5e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 14:57:34 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Arend van Spriel" <arend@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 00/29] staging: brcm80211: cleanup checkpatch warnings
Date: Fri, 22 Jul 2011 20:56:47 +0200
Message-ID: <1311361036-3175-1-git-send-email-arend@broadcom.com> (sfid-20110722_205809_950304_0A067DB5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains several patches getting rid of the last checkpatch
warnings on the brcm80211 folder. Also several cleanup patches for
brcmfmac driver are in this series.

This series applies to staging-next and depends on the following patch sets:

Message-ID:<1310678971-28952-1-git-send-email-frankyl@broadcom.com>
*excluding* Message-ID:<1310678971-28952-36-git-send-email-frankyl@broadcom.com>
Message-ID: <1310999405-10062-1-git-send-email-arend@broadcom.com>

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org

Arend van Spriel (9):
  staging: brcm80211: use PCI_DEVICE() macro in device table
  staging: brcm80211: remove unused rx status definitions
  staging: brcm80211: reformat long lines in brcmsmac to 80 columns
  staging: brcm80211: remove wl_alloc_dma_resources() function
  staging: brcm80211: remove dma_addrwidth() function
  staging: brcm80211: revisited END_FOREACH_BSS macro
  staging: brcm80211: cleanup to get rid of 'over 80 character' line
  staging: brcm80211: remove target platform limitations for drivers
  staging: brcm80211: updated TODO file

Franky Lin (8):
  staging: brcm80211: remove code for unsupported chip
  staging: brcm80211: placed suspend flag in gInstance in brcmfmac
  staging: brcm80211: remove struct brcmf_sdioh_driver from brcmfmac
  staging: brcm80211: remove vendor and device id check from brcmfmac
  staging: brcm80211: remove struct brcmf_sdio_card from brcmfmac
  staging: brcm80211: remove dead code from brcmfmac
  staging: brcm80211: remove dead client interrupt code from brcmfmac
  staging: brcm80211: remove function pointer of interrupt isr in
    brcmfmac

Pieter-Paul Giesberts (1):
  staging: brcm80211: SPARC build error fix

Roland Vossen (11):
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

 drivers/staging/brcm80211/Kconfig                 |    2 -
 drivers/staging/brcm80211/TODO                    |    4 -
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c       |  196 ++----
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |  161 +----
 drivers/staging/brcm80211/brcmfmac/dhd.h          |  115 ++--
 drivers/staging/brcm80211/brcmfmac/dhd_common.c   |   23 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c    |   27 +-
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |  687 ++++++++---------
 drivers/staging/brcm80211/brcmfmac/sdio_host.h    |  189 +++---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c  |   23 +-
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h  |    3 +-
 drivers/staging/brcm80211/brcmsmac/aiutils.c      |  701 +++++++----------
 drivers/staging/brcm80211/brcmsmac/aiutils.h      |   40 +-
 drivers/staging/brcm80211/brcmsmac/ampdu.c        |  197 +++--
 drivers/staging/brcm80211/brcmsmac/antsel.c       |   15 +-
 drivers/staging/brcm80211/brcmsmac/channel.c      |  151 +++--
 drivers/staging/brcm80211/brcmsmac/channel.h      |   15 +-
 drivers/staging/brcm80211/brcmsmac/d11.h          |  617 +++++++++------
 drivers/staging/brcm80211/brcmsmac/dma.c          |  726 +++++-------------
 drivers/staging/brcm80211/brcmsmac/dma.h          |  133 +---
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c  |   78 +--
 drivers/staging/brcm80211/brcmsmac/mac80211_if.h  |   13 +-
 drivers/staging/brcm80211/brcmsmac/main.c         |  869 +++++++++++++--------
 drivers/staging/brcm80211/brcmsmac/main.h         |  694 ++++++++++-------
 drivers/staging/brcm80211/brcmsmac/nicpci.c       |    4 +-
 drivers/staging/brcm80211/brcmsmac/otp.c          |   33 +-
 drivers/staging/brcm80211/brcmsmac/otp.h          |    3 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c  |   30 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h  |   12 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h  |    8 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c  |    7 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c    |   47 +-
 drivers/staging/brcm80211/brcmsmac/phy_shim.c     |   16 +-
 drivers/staging/brcm80211/brcmsmac/phy_shim.h     |   66 +-
 drivers/staging/brcm80211/brcmsmac/pmu.c          |   14 +-
 drivers/staging/brcm80211/brcmsmac/pub.h          |  228 +++---
 drivers/staging/brcm80211/brcmsmac/rate.c         |  104 ++--
 drivers/staging/brcm80211/brcmsmac/rate.h         |  141 +++-
 drivers/staging/brcm80211/brcmsmac/scb.h          |   35 +-
 drivers/staging/brcm80211/brcmsmac/srom.c         |   75 +-
 drivers/staging/brcm80211/brcmsmac/srom.h         |    4 +-
 drivers/staging/brcm80211/brcmsmac/stf.c          |   54 +-
 drivers/staging/brcm80211/brcmsmac/types.h        |  268 ++++---
 drivers/staging/brcm80211/brcmutil/utils.c        |    9 +-
 drivers/staging/brcm80211/brcmutil/wifi.c         |   23 +-
 drivers/staging/brcm80211/include/brcmu_utils.h   |    3 +-
 drivers/staging/brcm80211/include/brcmu_wifi.h    |  103 ++-
 drivers/staging/brcm80211/include/chipcommon.h    |    9 +-
 drivers/staging/brcm80211/include/defs.h          |   14 +-
 drivers/staging/brcm80211/include/soc.h           |    5 +-
 50 files changed, 3491 insertions(+), 3503 deletions(-)

-- 
1.7.4.1


