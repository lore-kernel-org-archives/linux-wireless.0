Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4213 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540Ab1GROaX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2011 10:30:23 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Arend van Spriel" <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, devel@linuxdriverproject.org
Subject: [PATCH 00/19] checkpatch changes and brcmfmac cleanup
Date: Mon, 18 Jul 2011 16:29:46 +0200
Message-ID: <1310999405-10062-1-git-send-email-arend@broadcom.com> (sfid-20110718_163051_948368_D7F1C675)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series removes several checkpatch errors and warnings in the
drivers and several cleanup changes in brcmfmac driver.

Arend van Spriel (2):
  staging: brcm80211: replace simple_strtoul usage in brcmsmac
  staging: brcm80211: replace simple_strtoul usage in brcmfmac

Franky Lin (10):
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

Roland Vossen (7):
  staging: brcm80211: fix for checkpatch warnings in phy directory
  staging: brcm80211: resolved checkpatch warnings in LCN phy
  staging: brcm80211: resolved checkpatch warnings in N phy
  staging: brcm80211: fixed build issue for big endian platforms
  staging: brcm80211: remove MIPS specific 'sync' instruction in
    fullmac
  staging: brcm80211: removed R_REG and OR_REG macro's from fullmac
  staging: brcm80211: removed global variable from sdio fullmac

 drivers/staging/brcm80211/brcmfmac/bcmsdh.c        |  246 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |  337 +-
 drivers/staging/brcm80211/brcmfmac/dhd.h           |   49 -
 drivers/staging/brcm80211/brcmfmac/dhd_common.c    |   27 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |   66 -
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |   97 +-
 drivers/staging/brcm80211/brcmfmac/sdio_host.h     |   30 +-
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c   |    8 -
 drivers/staging/brcm80211/brcmsmac/dma.h           |    1 +
 drivers/staging/brcm80211/brcmsmac/main.c          |   16 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c   |  244 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h   |   51 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h   |  138 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c   |  413 ++-
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c     | 3777 ++++++++++----------
 drivers/staging/brcm80211/brcmsmac/phy/phy_qmath.c |  136 +-
 .../staging/brcm80211/brcmsmac/phy/phytbl_lcn.c    | 1168 ++----
 drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.c  |    3 +-
 drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.h  |   24 +-
 drivers/staging/brcm80211/brcmsmac/types.h         |    8 +-
 20 files changed, 3195 insertions(+), 3644 deletions(-)

Cc: linux-wireless@vger.kernel.org
Cc: devel@linuxdriverproject.org
-- 
1.7.4.1


