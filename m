Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1385 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266Ab1GEWDV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 18:03:21 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 00/31] staging: brcm80211: fullmac cleanup and
 checkpatch fixes
Date: Wed, 6 Jul 2011 00:02:27 +0200
Message-ID: <1309903378-29021-1-git-send-email-arend@broadcom.com> (sfid-20110706_000404_299602_FDEB3E05)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series mainly consists of fullmac cleanup. Several checkpatch warnings
were fixed and some review comments from the previous series were addressed.

Arend van Spriel (10):
  staging: brcm80211: clean up checkpatch error
  staging: brcm80211: rename macros in dhd_dbg.h
  staging: brcm80211: remove checkpatch warnings 'suspect code indent'
  staging: brcm80211: made name lookup arrays more const
  staging: brcm80211: remove checkpatch warnings from phy_n.c
  staging: brcm80211: replace occurrences of __attribute__((packed))
  staging: brcm80211: remove several externs from dhd_linux.c
  staging: brcm80211: remove external definitions from phy_lcn.c
  staging: brcm80211: remove macro WLBANDINITFN from brcmsmac
  staging: brcm80211: added newlines to some debug macros in
    bcmsdh_sdmmc.c

Roland Vossen (21):
  staging: brcm80211: removed occurrences of 'dhd'
  staging: brcm80211: removed unused #ifdef sections in fullmac
  staging: brcm80211: removed asserts from two fullmac files
  staging: brcm80211: removed asserts from bcmsdh.c
  staging: brcm80211: removed asserts from dhd_cdc.c and dhd_common.c
  staging: brcm80211: removed asserts from dhd_linux.c
  staging: brcm80211: removed asserts from dhd_sdio.c
  staging: brcm80211: removed remains of assert mechanism in fullmac
  staging: brcm80211: replaced various typedefs in softmac
  staging: brcm80211: replaced typedef phy_info_t by struct brcms_phy
  staging: brcm80211: replaced typedef wlc_phy_t with struct
    brcms_phy_pub
  staging: brcm80211: replaced typedef tx_power_t by struct
    brcms_tx_power
  staging: brcm80211: renamed structures in softmac
  staging: brcm80211: replaced Broadcom specific acronym WLC
  staging: brcm80211: deleted two fullmac source files
  staging: brcm80211: merged dngl_stats.h into dhd.h
  staging: brcm80211: merged sbsdio.h into sdio_host.h
  staging: brcm80211: merged bcmsdbus.h into sdio_host.h
  staging: brcm80211: moved fullmac definitions from .h to .c files
  staging: brcm80211: removed #ifdef SDIOH_API_ACCESS_RETRY_LIMIT
  staging: brcm80211: simpler string handling in
    brcmf_c_pktfilter_offload_set()

 drivers/staging/brcm80211/brcmfmac/Makefile        |    4 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdbus.h      |  190 ---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c        |  208 +++-
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c  |  178 ---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |  344 +++++-
 .../brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c        |  262 ----
 drivers/staging/brcm80211/brcmfmac/dhd.h           |   49 +-
 drivers/staging/brcm80211/brcmfmac/dhd_bus.h       |   15 +-
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c       |   78 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c    |  251 ++--
 drivers/staging/brcm80211/brcmfmac/dhd_dbg.h       |   68 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |  468 ++-----
 drivers/staging/brcm80211/brcmfmac/dhd_proto.h     |   32 +-
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      | 1344 +++++++++++---------
 drivers/staging/brcm80211/brcmfmac/dngl_stats.h    |   32 -
 drivers/staging/brcm80211/brcmfmac/sbsdio.h        |  277 ----
 drivers/staging/brcm80211/brcmfmac/sdio_host.h     |  152 +++
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c   |   44 +-
 drivers/staging/brcm80211/brcmsmac/aiutils.c       |  134 +-
 drivers/staging/brcm80211/brcmsmac/aiutils.h       |    2 +-
 drivers/staging/brcm80211/brcmsmac/alloc.c         |   79 +-
 drivers/staging/brcm80211/brcmsmac/ampdu.c         |  121 +-
 drivers/staging/brcm80211/brcmsmac/ampdu.h         |    4 +-
 drivers/staging/brcm80211/brcmsmac/antsel.c        |   21 +-
 drivers/staging/brcm80211/brcmsmac/bmac.c          |  452 ++++----
 drivers/staging/brcm80211/brcmsmac/bmac.h          |   98 +-
 drivers/staging/brcm80211/brcmsmac/channel.c       |  417 ++++---
 drivers/staging/brcm80211/brcmsmac/channel.h       |   61 +-
 drivers/staging/brcm80211/brcmsmac/d11.h           |   32 +-
 drivers/staging/brcm80211/brcmsmac/dma.c           |  300 +++---
 drivers/staging/brcm80211/brcmsmac/dma.h           |    8 +-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c   |   26 +-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.h   |    4 +-
 drivers/staging/brcm80211/brcmsmac/main.c          |  804 ++++++------
 drivers/staging/brcm80211/brcmsmac/main.h          |  295 +++--
 drivers/staging/brcm80211/brcmsmac/nicpci.c        |  103 +-
 drivers/staging/brcm80211/brcmsmac/otp.c           |   45 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c   |  550 ++++----
 drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h   |  203 ++--
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h   |  336 +++---
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c   |  532 ++++----
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.h   |    4 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c     |  832 ++++++------
 .../staging/brcm80211/brcmsmac/phy/phytbl_lcn.c    |   29 +-
 .../staging/brcm80211/brcmsmac/phy/phytbl_lcn.h    |   30 +-
 drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.c  |   18 +-
 drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.h  |    8 +-
 drivers/staging/brcm80211/brcmsmac/phy_shim.c      |   74 +-
 drivers/staging/brcm80211/brcmsmac/phy_shim.h      |   76 +-
 drivers/staging/brcm80211/brcmsmac/pub.h           |  186 ++--
 drivers/staging/brcm80211/brcmsmac/rate.c          |  153 ++-
 drivers/staging/brcm80211/brcmsmac/rate.h          |   90 +-
 drivers/staging/brcm80211/brcmsmac/scb.h           |    5 +-
 drivers/staging/brcm80211/brcmsmac/srom.c          |   26 +-
 drivers/staging/brcm80211/brcmsmac/stf.c           |   43 +-
 drivers/staging/brcm80211/brcmsmac/stf.h           |    2 +-
 drivers/staging/brcm80211/brcmsmac/types.h         |  127 +--
 drivers/staging/brcm80211/include/brcmu_utils.h    |    4 -
 drivers/staging/brcm80211/include/brcmu_wifi.h     |   37 +-
 drivers/staging/brcm80211/include/defs.h           |   26 +-
 60 files changed, 4940 insertions(+), 5453 deletions(-)
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/dngl_stats.h
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/sbsdio.h

-- 
1.7.4.1


