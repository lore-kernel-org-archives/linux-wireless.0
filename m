Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1645 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623Ab2KFAWp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 19:22:45 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 00/24] brcmfmac: miscellaneous bug fix and code clean up
 patches
Date: Mon, 5 Nov 2012 16:22:08 -0800
Message-ID: <1352161352-30405-1-git-send-email-frankyl@broadcom.com> (sfid-20121106_012429_125002_70D2DE2F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


In this series, Arend provides some patches related to cfg80211 interface code. I have 5 patches focus on sdio bus data path. Hante removed iscan code and did some work on init/deinit code path.

Arend van Spriel (9):
  brcmfmac: remove obsolete structure ap_info
  brcmfmac: simplify if-else condition in brcmf_cfg80211_escan()
  brcmfmac: restrict error condition in brcmf_inform_bss()
  brcmfmac: make pointer type constant in brcmf_set_management_ie()
  brcmfmac: change parameter of brcmf_set_management_ie()
  brcmfmac: remove obsolete variable from brcmf_cfg80211_start_ap()
  brcmfmac: fix NULL pointer access in brcmf_create_iovar()
  brcmfmac: fix build regression
  brcmfmac: use struct brcmf_if parameter in firmware event callbacks

Franky Lin (5):
  brcmfmac: use dynamically allocated control frame buffer
  brcmfmac: decrease the range of SDIO access lock
  brcmfmac: protect consecutive SDIO access with sdio_claim_host
  brcmfmac: remove brcmf_sdbrcm_wait_for_event
  brcmfmac: change return type of brcmf_sdio_hdparser

Hante Meuleman (10):
  brcmfmac: remove obsolete i-scan and clean up related code.
  brcmfmac: use fwil for netdev callbacks.
  brcmfmac: handle exceptions in brcmf_bus_start correct.
  brcmfmac: use wait_event_timeout for 8021x pending count
  brcmfmac: fix pkt_filter sizeof calculation.
  brcmfmac: remove obsolete function brcmf_c_mkiovar
  brcmfmac: return immediately error for out of range key_idx.
  brcmfmac: check bus state to be data before sending data.
  brcmfmac: on halting driver check before release or free.
  brcmfmac: add dedicated USB log level.

 drivers/net/wireless/brcm80211/Kconfig             |    8 -
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |   28 +-
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    7 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |   48 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c  |   70 --
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |   29 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h  |   10 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |  314 +++------
 .../net/wireless/brcm80211/brcmfmac/dhd_proto.h    |    3 -
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  227 +++---
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c     |    4 +-
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |   81 ++-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  725 ++------------------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |  119 +---
 14 files changed, 414 insertions(+), 1259 deletions(-)

-- 
1.7.9.5


