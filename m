Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2831 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984Ab1LHXHK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 18:07:10 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 00/23] brcm80211: fullmac 4430 support and softmac
 switch to bcma
Date: Thu, 8 Dec 2011 15:06:36 -0800
Message-ID: <1323385619-7454-1-git-send-email-frankyl@broadcom.com> (sfid-20111209_000718_657793_8ABF022A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This train contains patches enable the support for bcm4330 for fullmac
and part of the patch series of switching to bcma bus interface for
softmac.

Arend van Spriel (19):
  bcma: add set/mask macros for 16-bit register access
  bcma: use static keyword for inline function declaration in bcma.h
  brcm80211: smac: remove unused fields from struct si_pub definition
  brcm80211: smac: move fields from struct si_pub to struct si_info
  brcm80211: smac: use inline access functions for struct si_pub fields
  brcm80211: smac: change from pci device driver to bcma device driver
  brcm80211: smac: change attach interfaces in main.c for bcma support
  brcm80211: smac: rename struct si_info field pbus to pcibus
  brcm80211: smac: change ai_attach interface taking a bcma_bus object
  brcm80211: smac: remove enumeration rom parsing function
  brcm80211: smac: use bcma core register access functions for 802.11
    core
  brcm80211: smac: use DMA-API calls for descriptor allocations
  brcm80211: smac: use bcma function for register access in dma.c
  brcm80211: smac: use bcma functions for register access in phy code
  brcm80211: smac: remove SI_FAST() macro usage
  brcm80211: smac: replace ai_corereg() function with ai_cc_reg()
  brcm80211: smac: remove unused functions and/or prototypes
  brcm80211: smac: use bcma core control functions
  brcm80211: smac: use bcma core access functions in nicpci.c

Franky Lin (4):
  brcm80211: fmac: save bus interface structure in function 2 device
  brcm80211: fmac: fix firmware shared structures version
  brcm80211: fmac: add bcm4330 support
  brcm80211: fmac: remove drive strength code for unsupported chips

 drivers/net/wireless/brcm80211/Kconfig             |    3 +-
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |    3 +-
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   25 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c  |    6 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    2 +
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |   74 +-
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    1 +
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c  |  873 ++++----------------
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h  |  100 ++-
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c    |    7 +-
 drivers/net/wireless/brcm80211/brcmsmac/d11.h      |    3 +
 drivers/net/wireless/brcm80211/brcmsmac/dma.c      |  220 +++---
 drivers/net/wireless/brcm80211/brcmsmac/dma.h      |    9 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |  166 ++---
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.h  |    2 -
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |  676 ++++++++--------
 drivers/net/wireless/brcm80211/brcmsmac/main.h     |    4 +-
 drivers/net/wireless/brcm80211/brcmsmac/nicpci.c   |  238 +++---
 drivers/net/wireless/brcm80211/brcmsmac/nicpci.h   |   11 +-
 drivers/net/wireless/brcm80211/brcmsmac/otp.c      |   20 +-
 .../net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c  |  225 +++---
 .../net/wireless/brcm80211/brcmsmac/phy/phy_hal.h  |    4 +-
 .../net/wireless/brcm80211/brcmsmac/phy/phy_int.h  |    6 +-
 .../net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c  |   69 +-
 .../net/wireless/brcm80211/brcmsmac/phy/phy_n.c    |   81 +-
 drivers/net/wireless/brcm80211/brcmsmac/pmu.c      |   48 +-
 drivers/net/wireless/brcm80211/brcmsmac/pub.h      |    6 +-
 drivers/net/wireless/brcm80211/brcmsmac/srom.c     |    4 +-
 drivers/net/wireless/brcm80211/brcmsmac/types.h    |    3 +
 include/linux/bcma/bcma.h                          |   55 +-
 31 files changed, 1184 insertions(+), 1762 deletions(-)

-- 
1.7.5.4


