Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1692 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753683Ab1JBRPA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Oct 2011 13:15:00 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 00/20] staging: brcm80211: code clean up
Date: Sun, 2 Oct 2011 10:14:25 -0700
Message-ID: <1317575685-3156-1-git-send-email-frankyl@broadcom.com> (sfid-20111002_191517_132485_03480388)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code clean up for both brcmfmac and brcmsmac

This series applies to staging-next and depends on the following patch set:
Message-ID: <1317335676-3424-1-git-send-email-frankyl@broadcom.com>

Arend van Spriel (2):
  staging: brcm80211: only allow one call to add_interface callback
  staging: brcm80211: reducing indentation levels in bcmsdh_sdmmc.c

Roland Vossen (18):
  staging: brmc80211: removed some unused fmac variable declarations
  staging: brcm80211: removed unused smac tx ampdu packet queue
  staging: brcm80211: cleaning up tx rate control code in softmac
  staging: brcm80211: various __iomem additions to softmac.
  staging: brcm80211: reduced softmac sparse warnings
  staging: brcm80211: added __iomem qualifier to softmac main.c
  staging: brcm80211: added __iomem qualifier to softmac dma.c
  staging: brcm80211: added __iomem qualifier to softmac phy
  staging: brcm80211: reduce indentation level in dhd_sdio.c #1
  staging: brcm80211: reduce indentation level in dhd_sdio.c #2
  staging: brcm80211: reduce indentation level in dhd_sdio.c #3
  staging: brcm80211: removed unused fullmac spinlock
  staging: brcm80211: removed unused softmac mimo disable code
  staging: brcm80211: removed fullmac function brcmf_bus_devreset()
  staging: brcm80211: removed 'enforce_mutex' parameter in fullmac
  staging: brcm80211: renamed ioctl functions/structs to dcmd
  staging: brcm80211: cleaned up buffer len defines in fullmac
  staging: brcm80211: removed functionality to disable N mode

 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |  140 +++----
 drivers/staging/brcm80211/brcmfmac/dhd.h           |   63 +---
 drivers/staging/brcm80211/brcmfmac/dhd_bus.h       |    4 +-
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c       |  118 +++---
 drivers/staging/brcm80211/brcmfmac/dhd_common.c    |   32 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |  122 +++---
 drivers/staging/brcm80211/brcmfmac/dhd_proto.h     |   13 +-
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |  477 ++++++++------------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c   |  126 +++---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h   |   10 +-
 drivers/staging/brcm80211/brcmsmac/aiutils.c       |  107 +++--
 drivers/staging/brcm80211/brcmsmac/aiutils.h       |   16 +-
 drivers/staging/brcm80211/brcmsmac/channel.c       |   19 +-
 drivers/staging/brcm80211/brcmsmac/dma.c           |   17 +-
 drivers/staging/brcm80211/brcmsmac/dma.h           |    5 +-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c   |    5 +-
 drivers/staging/brcm80211/brcmsmac/main.c          |  191 +++-----
 drivers/staging/brcm80211/brcmsmac/main.h          |    8 +-
 drivers/staging/brcm80211/brcmsmac/nicpci.c        |   45 +-
 drivers/staging/brcm80211/brcmsmac/nicpci.h        |    9 +-
 drivers/staging/brcm80211/brcmsmac/otp.c           |    9 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c   |   19 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h   |    2 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h   |    2 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c     |   57 ++--
 .../staging/brcm80211/brcmsmac/phy/phytbl_lcn.c    |    4 -
 drivers/staging/brcm80211/brcmsmac/pmu.c           |   16 +-
 drivers/staging/brcm80211/brcmsmac/scb.h           |    1 -
 drivers/staging/brcm80211/brcmsmac/srom.c          |   20 +-
 drivers/staging/brcm80211/brcmsmac/srom.h          |    2 +-
 drivers/staging/brcm80211/brcmsmac/stf.c           |   14 +-
 31 files changed, 745 insertions(+), 928 deletions(-)


