Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1622 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab1ECJgN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:13 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 00/61] staging: brcm80211: resubmit after flush of patch
 queue
Date: Tue, 3 May 2011 11:35:00 +0200
Message-ID: <1304415361-7813-1-git-send-email-arend@broadcom.com> (sfid-20110503_113625_429563_FB244978)
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Things got pretty out of sync so the pending patches were dropped from the
queue. This series is to get back in sync with the staging-next tree.

This series is rebased on latest staging-next and one patch from the driver list
has been applied (see partial git log below)
   1aa69ac brcm80211: FIX for TKIP GTK bug
   3d51406 Staging: hv: Get rid of the priv pointer in struct hv_driver
   de632a2 Staging: hv: Cleanup vmbus_match()

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
---
Arend van Spriel (31):
  staging: brcm80211: remove unnecessary if statements from
    bss_info_changed
  staging: brcm80211: remove wl_ops_set_rts_threshold
  staging: brcm80211: rename rate related definitions
  staging: brcm80211: honour basic rate configuration from mac80211
  staging: brcm80211: implement flush driver callback for mac80211
  staging: brcm80211: rename active_queue identifier
  staging: brcm80211: remove queue info parameter from wlc_send_q
  staging: brcm80211: provide TSF value in receive status
  staging: brcm80211: remove tsf retrieval from wlc_bmac.c
  staging: brcm80211: remove retrieval function for tsf in wlc_main.c
  Revert "staging: brcm80211: separate hndpmu functionality for
    brcmsmac driver"
  staging: brcm80211: remove unused functions from hndpmu.c
  staging: brcm80211: remove use of si_* functions from wlc_phy_lcn.c
  staging: brcm80211: separate hndpmu functionality for brcmsmac driver
  staging: brcm80211: remove dependency between aiutils and siutils
    sources
  staging: brcm80211: fix checkpatch warnings in
    si_pmu_spuravoid_pllupdate
  staging: brcm80211: remove zero initialization of static in
    si_pmu_ilp_clock
  staging: brcm80211: fix checkpatch warning in si_pmu_res_init
  staging: brcm80211: fix checkpatch issues in si_pmu_measure_alpclk
  staging: brcm80211: fix checkpatch warning in si_pmu_otp_power
  staging: brcm80211: cleanup definitions in aiutils header file
  staging: brcm80211: cleanup code in source file aiutils.c
  staging: brcm80211: move aiutils source files to brcmsmac folder
  staging: brcm80211: remove check on interconnect type in ai_setcore
  staging: brcm80211: use local variable for socitype during ai_scan
  staging: brcm80211: remove socitype member for struct si_pub
    definition
  staging: brcm80211: replace hndcrc16 with crc-ccitt function
  staging: brcm80211: remove unused hndcrc32 function
  staging: brcm80211: remove CRC_INNER_LOOP macro
  staging: brcm80211: move qmath sources to phy directory
  staging: brcm80211: remove unused functions from wlc_phy_qmath.c

Roland Vossen (30):
  staging: brcm80211: fixed error in non-DHD_DEBUG fullmac build
  staging: brcm80211: made error codes in bcmutils.h positive
  staging: brcm80211: bugfix for fullmac return codes
  staging: brcm80211: removed WL_NONE
  staging: brcm80211: making wiphy object accessible from wlc and phy
  staging: brcm80211: replaced WL_ERROR in two files.
  staging: brcm80211: replaced WL_ERROR in wlc_ampdu.c
  staging: brcm80211: replaced WL_ERROR in wlc_bmac.c
  staging: brcm80211: replaced WL_ERROR in wlc_main.c
  staging: brcm80211: replaced WL_ERROR in rest of softmac.
  staging: brcm80211: removed ASSERTs from wlc_main.c
  staging: brcm80211: removed ASSERTs from wlc_ampdu.c
  staging: brcm80211: removed ASSERTs from wlc_bmac.c
  staging: brcm80211: removed error string function
  staging: brcm80211: replace error codes part 1
  staging: brcm80211: replace error codes part 2
  staging: brcm80211: made fullmac error codes more consistent
  staging: brcm80211: removed ASSERTs from util dir, part 1
  staging: brcm80211: removed ASSERTs from util dir, part 2
  staging: brcm80211: delete ASSERTs in 4 files in brcmsmac dir
  staging: brcm80211: removed all ASSERTs from wl_mac80211.c
  staging: brcm80211: removed all ASSERTs from wlc_ampdu.c
  staging: brcm80211: removed remaining ASSERTs from phy
  staging: brcm80211: removed ASSERTs from aiutils.c
  staging: brcm80211: removed ASSERTs from wlc_pmu.c
  staging: brcm80211: moved ASSERT logic to fullmac driver
  staging: brcm80211: replaced WL_TRACE by BCMMSG
  staging: brcm80211: replaced WL_AMPDU_* with BCMMSG
  staging: brcm80211: got rid of WL_FFPLD message log macro
  staging: brcm80211: removed function wlc_calloc()

 drivers/staging/brcm80211/Kconfig                  |    1 +
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c        |   34 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c  |    4 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |   18 +-
 .../brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c        |    5 +-
 drivers/staging/brcm80211/brcmfmac/dhd.h           |   10 +
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c       |   12 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c    |   30 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |   65 +-
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |  124 +-
 drivers/staging/brcm80211/brcmfmac/wl_iw.c         |   50 +
 drivers/staging/brcm80211/brcmsmac/Makefile        |    5 +-
 drivers/staging/brcm80211/brcmsmac/aiutils.c       | 2054 +++++++++++++++
 drivers/staging/brcm80211/brcmsmac/aiutils.h       |  546 ++++
 drivers/staging/brcm80211/brcmsmac/d11.h           |    2 +
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c   |   47 +-
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h   |    5 +-
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_int.h   |    1 +
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c   |   16 +-
 drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c |   63 +-
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_qmath.c |  296 +++
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_qmath.h |   40 +
 drivers/staging/brcm80211/brcmsmac/wl_dbg.h        |   24 +-
 drivers/staging/brcm80211/brcmsmac/wl_export.h     |    1 +
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c   |  403 ++--
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.h   |    1 +
 drivers/staging/brcm80211/brcmsmac/wlc_alloc.c     |   66 +-
 drivers/staging/brcm80211/brcmsmac/wlc_alloc.h     |    2 -
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c     |  211 +--
 drivers/staging/brcm80211/brcmsmac/wlc_antsel.c    |   12 +-
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c      |  550 ++---
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.h      |    1 -
 drivers/staging/brcm80211/brcmsmac/wlc_channel.c   |   60 +-
 drivers/staging/brcm80211/brcmsmac/wlc_key.h       |   10 +-
 drivers/staging/brcm80211/brcmsmac/wlc_main.c      | 1088 +++-----
 drivers/staging/brcm80211/brcmsmac/wlc_main.h      |   15 +-
 drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c  |    9 +-
 drivers/staging/brcm80211/brcmsmac/wlc_pmu.c       |  197 +-
 drivers/staging/brcm80211/brcmsmac/wlc_pmu.h       |    4 +-
 drivers/staging/brcm80211/brcmsmac/wlc_pub.h       |    8 +-
 drivers/staging/brcm80211/brcmsmac/wlc_rate.c      |   16 +-
 drivers/staging/brcm80211/brcmsmac/wlc_rate.h      |   15 +-
 drivers/staging/brcm80211/brcmsmac/wlc_stf.c       |   49 +-
 drivers/staging/brcm80211/include/bcmdefs.h        |    6 -
 drivers/staging/brcm80211/include/bcmutils.h       |   98 -
 drivers/staging/brcm80211/include/hndpmu.h         |   67 -
 drivers/staging/brcm80211/include/qmath.h          |   78 -
 drivers/staging/brcm80211/include/wlioctl.h        |    2 -
 drivers/staging/brcm80211/util/aiutils.c           |  705 ------
 drivers/staging/brcm80211/util/bcmotp.c            |  127 +-
 drivers/staging/brcm80211/util/bcmsrom.c           |   62 +-
 drivers/staging/brcm80211/util/bcmutils.c          |  292 +---
 drivers/staging/brcm80211/util/bcmwifi.c           |    3 -
 drivers/staging/brcm80211/util/hnddma.c            |   72 +-
 drivers/staging/brcm80211/util/hndpmu.c            | 2626 --------------------
 drivers/staging/brcm80211/util/nicpci.c            |   25 +-
 drivers/staging/brcm80211/util/nvram/nvram_ro.c    |    6 +-
 drivers/staging/brcm80211/util/qmath.c             |  681 -----
 drivers/staging/brcm80211/util/siutils.c           |   59 +-
 59 files changed, 4403 insertions(+), 6676 deletions(-)
 create mode 100644 drivers/staging/brcm80211/brcmsmac/aiutils.c
 create mode 100644 drivers/staging/brcm80211/brcmsmac/aiutils.h
 create mode 100644 drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_qmath.c
 create mode 100644 drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_qmath.h
 delete mode 100644 drivers/staging/brcm80211/include/hndpmu.h
 delete mode 100644 drivers/staging/brcm80211/include/qmath.h
 delete mode 100644 drivers/staging/brcm80211/util/aiutils.c
 delete mode 100644 drivers/staging/brcm80211/util/hndpmu.c
 delete mode 100644 drivers/staging/brcm80211/util/qmath.c

-- 
1.7.4.1


