Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3247 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992Ab2LEO0Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 09:26:25 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 00/11] brcm80211: cleanup patches
Date: Wed, 5 Dec 2012 15:25:53 +0100
Message-ID: <1354717564-7183-1-git-send-email-arend@broadcom.com> (sfid-20121205_152633_776144_6862972C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For brcmsmac there is only one patch that fixes a warning when
building for ARM. The brcmfmac patches are mostly dealing with
debug facility. The driver had two separate ones that are now
consolidated into one.

Arend van Spriel (10):
  brcmfmac: rework bus interface
  brcmsmac: fix uninitialized variable warning on arm architecture
  brcmfmac: use one list of event defintions
  brcmfmac: error messages should not be suppressed
  brcmfmac: consolidate debug macros in wl_cfg80211
  brcmfmac: replace WL_ERR() with brcmf_err()
  brcmfmac: replace WL_INFO() macro
  brcmfmac: remove WL_TRACE() macro
  brcmfmac: remove WL_SCAN() macro
  brcmfmac: remove WL_CONN() macro

Piotr Haber (1):
  brcmsmac: radio on led support

 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |   15 +-
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   44 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    1 -
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |   92 ++-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c  |   25 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |   40 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c  |    5 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h  |   24 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   57 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  205 ++---
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c     |   84 +-
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h     |  142 ++--
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c     |   14 +-
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |   14 +-
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |   91 +--
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  817 ++++++++++----------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |   70 +-
 drivers/net/wireless/brcm80211/brcmsmac/Makefile   |    3 +-
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c  |    2 +-
 drivers/net/wireless/brcm80211/brcmsmac/led.c      |  103 +++
 drivers/net/wireless/brcm80211/brcmsmac/led.h      |   29 +
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    5 +
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.h  |    4 +
 23 files changed, 981 insertions(+), 905 deletions(-)
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/led.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/led.h

-- 
1.7.9.5


