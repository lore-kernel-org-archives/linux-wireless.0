Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2341 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760925Ab1LQChb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 21:37:31 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 00/30] brcmfmac: the last batch of bus interface
 refactoring
Date: Fri, 16 Dec 2011 18:36:50 -0800
Message-ID: <1324089440-8957-1-git-send-email-frankyl@broadcom.com> (sfid-20111217_033740_011126_DCA8AD29)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The series finish the brcmfmac bus interface refactoring aim for adding USB
bus support. It's a little bigger than usual. But we think it would be
better to send them out once to present a better picture. Most of them are
small patches.

Franky Lin (30):
  brcm80211: fmac: unify common layer driver data structure
  brcm80211: fmac: remove oneline proto block functions
  brcm80211: fmac: register a dummy irq handler for SDIO function 2
  brcm80211: fmac: change function add_if parameter
  brcm80211: fmac: change function bus_start parameter
  brcm80211: fmac: change function brcmf_detach parameter
  brcm80211: fmac: change function txflowcontrol parameter
  brcm80211: fmac: change function txcomplete parameter
  brcm80211: fmac: change function brcmf_c_prec_enq parameter
  brcm80211: fmac: change function rx_frame parameter
  brcm80211: fmac: change function proto_hdrpull parameter
  brcm80211: fmac: move sdio used statistics to struct brcmf_sdio
  brcm80211: fmac: move maxctl to struct brcmf_bus
  brcm80211: fmac: move driver up status to struct brcmf_bus
  brcm80211: fmac: remove duplicate statistics from driver data
    structure
  brcm80211: fmac: move dongle statistics to struct brcmf_bus
  brcm80211: fmac: move packet realloc stats to struct brcmf_bus
  brcm80211: fmac: move tx flow ctrl flag to bus layer
  brcm80211: fmac: stop referencing brcmf_pub in bus layer
  brcm80211: fmac: stop referencing brcmf_sdio in common layer
  brcm80211: fmac: move sdio related macros to sdio_host.h
  brcm80211: fmac: abstract bus_stop interface function pointer
  brcm80211: fmac: move common layer bus interface context to dhd_bus.h
  brcm80211: fmac: abstract bus_init interface function pointer
  brcm80211: fmac: abstract bus_txdata interface function pointer
  brcm80211: fmac: abstract ctrl frames interface function pointers
  brcm80211: fmac: move debug level macros to dhd_dbg.h
  brcm80211: fmac: move idle macros to dhd_sdio.c
  brcm80211: fmac: exclude unnecessary header files
  brcm80211: fmac: add Kconfig option for SDIO bus support

 drivers/net/wireless/brcm80211/Kconfig             |   18 +-
 drivers/net/wireless/brcm80211/brcmfmac/Makefile   |   22 +-
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |    8 +-
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    4 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |  135 +------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |   93 ++++-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c  |   42 +--
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |   20 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h  |   15 +
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |  423 +++++++++-----------
 .../net/wireless/brcm80211/brcmfmac/dhd_proto.h    |    7 -
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  325 ++++++++-------
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |    1 -
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |   10 +
 14 files changed, 531 insertions(+), 592 deletions(-)

-- 
1.7.5.4


