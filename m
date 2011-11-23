Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4798 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759562Ab1KWBWP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 20:22:15 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 00/24] brcm80211: generic cleanup and fullmac bus
 interface refactoring
Date: Tue, 22 Nov 2011 17:21:35 -0800
Message-ID: <1322011319-24863-1-git-send-email-frankyl@broadcom.com> (sfid-20111123_022236_484307_0EBE700B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch serises contains some clean up patches for both fullmac and
softmac as well as some fullmac bus interface refactoring patches.

In order to add USB bus support to fullmac, current interface between
common layer and bus layer must be optimized. Interface functions of
bus layer will be stored in a interface structure along with other
context variables and registered to common layer during
initialization. Interface functions of common layer can be called
directly by bus layer. The pointer of the shared interface
structure will be saved in the private driver_data pointer of the
dongle device.

Alwin Beukers (2):
  brcm80211: smac: fix channel frequency
  brcm80211: smac: added support for mac80211 filter flags

Arend van Spriel (7):
  brcm80211: fmac: cleanup receive path using proper skb_queue
    functions
  brcm80211: smac: remove skb next pointer usage from the driver
  brcm80211: fmac: separate receiving skb chain from other receive path
  brcm80211: fmac: remove width parameter from
    brcmf_sdioh_request_buffer
  brcm80211: fmac: simplify the brcmf_sdioh_request_buffer() function
  brcm80211: fmac: remove alignment check from
    brcmf_sdioh_request_buffer()
  brcm80211: fmac: rename wait queue name to match using function

Franky Lin (15):
  brcm80211: fmac: change firmware/nvram name to be more generic
  brcm80211: fmac: discard packet received when net device not
    registered
  brcm80211: fmac: move module init/exit to sdio layer
  brcm80211: fmac: remove function brcmf_c_init
  brcm80211: fmac: remove unused parameter of brcmf_sdbrcm_probe
  brcm80211: fmac: rename structure brcmf_bus to brcmf_sdio
  brcm80211: fmac: introduce common bus interface struct brcmf_bus
  brcm80211: fmac: move busstate to struct brcmf_bus
  brcm80211: fmac: stop using brcmf_pub in brcmf_sdbrcm_bus_watchdog
  brcm80211: fmac: change function bus_rxctl parameter
  brcm80211: fmac: change function bus_txctl parameter
  brcm80211: fmac: change function bus_txdata parameter
  brcm80211: fmac: change function bus_init parameter
  brcm80211: fmac: remove function brcmf_bus_get_device
  brcm80211: fmac: change function bus_stop parameter

 drivers/net/wireless/brcm80211/brcmfmac/bcmchip.h  |   25 --
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |  148 ++++++++--
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |  207 ++++++-------
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |   31 ++-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |   19 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c  |    6 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |   15 -
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   85 ++----
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  320 +++++++++-----------
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |   30 ++-
 drivers/net/wireless/brcm80211/brcmsmac/dma.c      |   62 ++---
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   38 +--
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |   47 ++--
 drivers/net/wireless/brcm80211/brcmsmac/main.h     |    6 +-
 .../net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c  |    2 +-
 15 files changed, 512 insertions(+), 529 deletions(-)
 delete mode 100644 drivers/net/wireless/brcm80211/brcmfmac/bcmchip.h

-- 
1.7.5.4


