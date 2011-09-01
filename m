Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4154 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783Ab1IAJRg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 05:17:36 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 00/30] first response to mainline patch#2 comments
Date: Thu, 1 Sep 2011 11:16:50 +0200
Message-ID: <1314868640-9425-1-git-send-email-rvossen@broadcom.com> (sfid-20110901_111740_613279_9D2338F3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Consisting of code cleanup changes.

This series applies to staging-next and depends on the following patch set:

Message-ID: <1314364780-9462-14-git-send-email-rvossen@broadcom.com>

Arend van Spriel (6):
  staging: brcm80211: remove static function prototypes from main.c
  staging: brcm80211: use static qualifier for local symbols in
    brcmfmac
  staging: brcm80211: reduce sparse messages on brcmsmac sources
  staging: brcm80211: remove sparse warnings from mac80211_if.c
  staging: brcm80211: use static qualifier for local symbols in
    brcmsmac
  staging: brcm80211: macro cleanup in softmac aiutils.h

Franky Lin (7):
  staging: brcm80211: consolidate SHOW_EVENTS code under BCMDBG in
    fullmac
  staging: brcm80211: remove duplicate set sb window address function
  staging: brcm80211: remove function wrapper of getting sb window
    address
  staging: brcm80211: remove unused sdioh data mode code in fullmac
  staging: brcm80211: remove unused sdioh command type code in fullmac
  staging: brcm80211: remove static function declaration in
    bcmsdh_sdmmc
  staging: brcm80211: remove static function declaration in dhd_linux

Henry Ptasinski (1):
  staging: brcm80211: use min_t() instead of min()

Roland Vossen (16):
  staging: brcm80211: removed static function declarations in aiutils.c
  staging: brcm80211: removed static function declarations in alloc.c
  staging: brcm80211: removed static function declarations in ampdu.c
  staging: brcm80211: removed static function declarations in antsel.c
  staging: brcm80211: removed static function declarations in channel.c
  staging: brcm80211: removed static function declarations in dma.c
  staging: brcm80211: removed static function declarations in
    mac80211_if.c
  staging: brcm80211: removed static function declarations in 3 files
  staging: brcm80211: cleaned up fullmac macro
    BRCMF_PM_RESUME_RETURN_ERROR
  staging: brcm80211: replaced fullmac BRCMF_PM_RESUME_WAIT macro with
    function
  staging: brcm80211: removed redundant macro's in softmac
  staging: brcm80211: removed redundant SI_INFO() macro from softmac
  staging: brcm80211: macro cleanup in softmac ampdu.c
  staging: brcm80211: cleaned up softmac channel related macro's
  staging: brcm80211: cleaned up several softmac macro's
  staging: brcm80211: cleaned up several main.h/main.c related macro's

 drivers/staging/brcm80211/brcmfmac/Makefile        |    2 -
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c        |   36 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |  391 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c    |   23 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |   51 +-
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |   71 +-
 drivers/staging/brcm80211/brcmfmac/sdio_host.h     |    8 +-
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c   |    5 +-
 drivers/staging/brcm80211/brcmsmac/aiutils.c       |  486 +-
 drivers/staging/brcm80211/brcmsmac/aiutils.h       |  246 +-
 drivers/staging/brcm80211/brcmsmac/alloc.c         |   39 +-
 drivers/staging/brcm80211/brcmsmac/ampdu.c         |  320 +-
 drivers/staging/brcm80211/brcmsmac/antsel.c        |  222 +-
 drivers/staging/brcm80211/brcmsmac/channel.c       | 1018 ++--
 drivers/staging/brcm80211/brcmsmac/channel.h       |   82 +-
 drivers/staging/brcm80211/brcmsmac/d11.h           |    5 -
 drivers/staging/brcm80211/brcmsmac/dma.c           |  583 ++--
 drivers/staging/brcm80211/brcmsmac/dma.h           |    9 +-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c   | 1146 +++---
 drivers/staging/brcm80211/brcmsmac/mac80211_if.h   |    2 +-
 drivers/staging/brcm80211/brcmsmac/main.c          | 5007 ++++++++++----------
 drivers/staging/brcm80211/brcmsmac/main.h          |  164 +-
 drivers/staging/brcm80211/brcmsmac/nicpci.c        |   22 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c   |   28 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h   |   36 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c   |    4 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c     |   57 +-
 .../staging/brcm80211/brcmsmac/phy/phytbl_lcn.c    |   66 +-
 drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.c  |  128 +-
 drivers/staging/brcm80211/brcmsmac/pmu.c           |    4 +-
 drivers/staging/brcm80211/brcmsmac/rate.c          |    4 +-
 drivers/staging/brcm80211/brcmsmac/srom.c          |  329 +-
 drivers/staging/brcm80211/brcmsmac/stf.c           |  122 +-
 drivers/staging/brcm80211/brcmsmac/types.h         |   12 +-
 drivers/staging/brcm80211/brcmsmac/ucode_loader.c  |    5 +-
 35 files changed, 4989 insertions(+), 5744 deletions(-)

-- 
1.7.4.1


