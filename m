Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4433 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932331Ab1ISV0b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 17:26:31 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 00/20] staging: brcm80211: 7th reaction for mainline
 patch #2
Date: Mon, 19 Sep 2011 14:25:48 -0700
Message-ID: <1316467568-27683-1-git-send-email-frankyl@broadcom.com> (sfid-20110919_232636_918099_FCE6A735)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code clean up for fullmac.

Arend van Spriel (1):
  staging: brcm80211: remove unconditional code blocks from brcmfmac

Franky Lin (6):
  staging: brcm80211: remove event handler thread from fullmac
  staging: brcm80211: remove fullmac module_param brcmf_dongle_memsize
  staging: brcm80211: remove fullmac module_param
    brcmf_sdiod_drive_strength
  staging: brcm80211: remove fullmac module_param for watchdog
  staging: brcm80211: remove fullmac module_param brcmf_idletime
  staging: brcm80211: remove global variables for data frame boundary

Roland Vossen (13):
  staging: brcm80211: sparse endianness warnings on dongle events
  staging: brcm80211: various fulmac sparse endianness fixes
  staging: brcm80211: sparse endianness warnings for struct
    brcmf_proto_cdc_ioctl
  staging: brcm80211: sparse endianness warnings for struct
    sdpcm_shared
  staging: brcm80211: more fullmac sparse endianness scan related
    changes
  staging: brcm80211: removed two fullmac sparse spinlock warnings
  staging: brcm80211: added endianness check flag to fullmac Makefile
  staging: brcm80211: removed likely/unlikely calls
  staging: brcm80211: removed log after kzalloc()/kmalloc() failure
  staging: brcm80211: clarified fullmac io and event codes
  staging: brcm80211: consistent naming of struct net_device *ndev
  staging: brcm80211: simplified internal ioctl function once more
  staging: brcm80211: reduced checkpatch warnings to zero

 drivers/staging/brcm80211/brcmfmac/Makefile       |    1 +
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c       |    2 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   33 +-
 drivers/staging/brcm80211/brcmfmac/dhd.h          |   51 +-
 drivers/staging/brcm80211/brcmfmac/dhd_bus.h      |   13 +-
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c      |   47 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c   |  189 +++---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c    |  309 +++++-----
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |  430 +++++++-------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c  |  678 +++++++++------------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h  |   11 +-
 drivers/staging/brcm80211/brcmsmac/aiutils.c      |   14 +-
 drivers/staging/brcm80211/brcmsmac/ampdu.c        |    8 +-
 drivers/staging/brcm80211/brcmsmac/antsel.c       |    5 +-
 drivers/staging/brcm80211/brcmsmac/channel.c      |    5 +-
 drivers/staging/brcm80211/brcmsmac/dma.c          |   16 +-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c  |   11 +-
 drivers/staging/brcm80211/brcmsmac/main.c         |    3 +-
 drivers/staging/brcm80211/brcmsmac/nicpci.c       |    6 +-
 drivers/staging/brcm80211/brcmsmac/phy_shim.c     |    7 +-
 drivers/staging/brcm80211/brcmsmac/srom.c         |    3 +-
 21 files changed, 865 insertions(+), 977 deletions(-)


