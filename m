Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3966 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757863Ab2BIUJ1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 15:09:27 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 00/15] brcm80211: resolve brcmsmac issues and brcmfmac
 usb support
Date: Thu, 9 Feb 2012 21:08:54 +0100
Message-ID: <1328818149-4826-1-git-send-email-arend@broadcom.com> (sfid-20120209_210959_266412_4FDEF97F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series contains patches for a couple of issue in brcmsmac. The A-MPDU
endless retry fix is a long standing issue that exists in previous kernels. So
it should go to 3.3 kernel.

For the brcmfmac driver support has been added for USB chipsets. Firmware has
been submitted for bcm43235, bcm43236, and bcm43238 chipsets.

Arend van Spriel (14):
  brcm80211: update the maintainers listed for brcm80211 drivers
  brcm80211: smac: fix unintended fallthru in wlc_phy_radio_init_2057()
  brcm80211: smac: remove redundant assignments from
    txpwrctrl_pwr_setup_nphy
  brcm80211: smac: fix endless retry of A-MPDU transmissions
  brcm80211: smac: remove smatch warnings from brcmsmac code
  brcm80211: fmac: resolve smatch issues in brcmfmac code
  brcm80211: fmac: use specific types in struct brcmf_bus
  brcm80211: fmac: move module entry points to dhd_linux.c
  brcm80211: fmac: only return success in brcmf_sdbrcm_bus_init() when
    true
  brcm80211: fmac: update bus state in common driver part
  brcm80211: fmac: change allocation flag in brcmf_enq_event() function
  brcm80211: fmac: use spinlock calls saving irq flags in
    brcmf_enq_event()
  brcm80211: fmac: add USB support for bcm43235/6/8 chipsets
  brcm80211: fmac: make sdio firmware filename specific

Franky Lin (1):
  brcm80211: fmac: make sure cancel_work_sync only called after
    INIT_WORK

 MAINTAINERS                                        |    1 -
 drivers/net/wireless/brcm80211/Kconfig             |   17 +-
 drivers/net/wireless/brcm80211/brcmfmac/Makefile   |    6 +-
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   14 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |   17 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   59 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   32 +-
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      | 1623 ++++++++++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/usb.h      |   84 +
 drivers/net/wireless/brcm80211/brcmfmac/usb_rdl.h  |   75 +
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   13 +-
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c    |    6 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    4 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |    1 -
 .../net/wireless/brcm80211/brcmsmac/phy/phy_n.c    |   28 +-
 drivers/net/wireless/brcm80211/brcmsmac/srom.c     |   14 +-
 16 files changed, 1905 insertions(+), 89 deletions(-)
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/usb.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/usb.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/usb_rdl.h

-- 
1.7.5.4


