Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2383 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754518Ab1IWAIO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 20:08:14 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH v2 00/19] staging: brcm80211: 7th reaction for mainline
 patch #2
Date: Thu, 22 Sep 2011 17:07:37 -0700
Message-ID: <1316736476-23725-1-git-send-email-frankyl@broadcom.com> (sfid-20110923_020847_813699_04F0172B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code clean up for fullmac.

v2: 
* remove patch "staging: brcm80211: reduced checkpatch warnings to zero" based
  on Joe Perches's comments

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

Roland Vossen (12):
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

 drivers/staging/brcm80211/brcmfmac/Makefile       |    1 +
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c       |    2 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    6 +-
 drivers/staging/brcm80211/brcmfmac/dhd.h          |   51 +-
 drivers/staging/brcm80211/brcmfmac/dhd_bus.h      |   13 +-
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c      |   37 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c   |  166 +++---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c    |  296 +++++-----
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |  215 +++----
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c  |  678 +++++++++------------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h  |   11 +-
 drivers/staging/brcm80211/brcmsmac/ampdu.c        |    8 +-
 drivers/staging/brcm80211/brcmsmac/antsel.c       |    5 +-
 drivers/staging/brcm80211/brcmsmac/channel.c      |    5 +-
 drivers/staging/brcm80211/brcmsmac/dma.c          |   16 +-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c  |   11 +-
 drivers/staging/brcm80211/brcmsmac/nicpci.c       |    3 +-
 drivers/staging/brcm80211/brcmsmac/phy_shim.c     |    7 +-
 18 files changed, 689 insertions(+), 842 deletions(-)


