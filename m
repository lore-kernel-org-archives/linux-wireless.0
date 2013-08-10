Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1675 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968544Ab3HJK1q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Aug 2013 06:27:46 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 00/12] brcm80211: new functionality and some cleanup
 fixes
Date: Sat, 10 Aug 2013 12:27:18 +0200
Message-ID: <1376130450-29746-1-git-send-email-arend@broadcom.com> (sfid-20130810_122814_460973_3EED3003)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series adds new functionality to the brcm80211 drivers listed below:

AMPDU host-reordering:
	The brcmfmac driver buffers individual A-MPDU packets
	reducing memory requirement in the wireless device.

TDLS:
	The 802.11 standards AP bypass is added to brcmfmac.

BCM4313 iPA:
	This adds support to brcmsmac for a new variant of the
	BCM4313. This was already submitted but reverted due
	to regressions for other devices.

Other changes are brcmfmac cleanup work for firmware-signalling
feature and rework in SDIO-specific driver code.

This series is intended for v3.12 and applies to the master branch
of the wireless-next repository.

Arend van Spriel (5):
  brcmfmac: use irq safe spinlock in brcmf_sdbrcm_txdata()
  brcmfmac: .txdata() bus callback should not call brcmf_txcomplete()
  brcmfmac: add AMPDU reordering functionality
  brcmfmac: ignore IF event if firmware indicates it
  brcmfmac: add support for manual TDLS operations

Franky Lin (4):
  brcmfmac: abstract tx packet processing functions
  brcmfmac: remove align from brcmf_bus structure
  brcmfmac: streamline sdio bus header code
  brcmfmac: use configurable sdio bus header length for tx packet

Hante Meuleman (2):
  brcmfmac: always use worker thread for tx data.
  brcmfmac: no fws locking outside fws module.

Piotr Haber (1):
  brcmsmac: support 4313iPA

 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |  16 +-
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   1 -
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |  31 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |   8 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    | 279 ++++++++++--
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c | 481 +++++++++++++--------
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c     |   4 +
 .../net/wireless/brcm80211/brcmfmac/fwil_types.h   |  21 +
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c | 228 +++++-----
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |   2 +-
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |   1 -
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  57 ++-
 .../net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c  | 399 ++++++++++-------
 .../wireless/brcm80211/brcmsmac/phy/phytbl_lcn.c   | 289 ++++++++-----
 .../wireless/brcm80211/brcmsmac/phy/phytbl_lcn.h   |   1 +
 include/linux/platform_data/brcmfmac-sdio.h        |   6 +
 16 files changed, 1228 insertions(+), 596 deletions(-)

-- 
1.8.1.3


